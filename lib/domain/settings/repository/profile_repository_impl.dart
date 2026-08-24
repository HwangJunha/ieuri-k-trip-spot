import 'dart:io';

import 'package:gql/ast.dart' show DocumentNode;
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../../common/model/post.dart';
import '../../../common/model/post_author.dart';
import '../../../common/model/post_spot.dart';
import '../../../common/model/target_category.dart';
import '../../../common/network/graphql_debug_log.dart';
import '../../../common/network/graphql_failure.dart';
import '../../../common/pagination/page.dart';
// **생성 타입 하나만 가져온다 — 기능 간 의존이 아니다.** codegen은 모든 스키마 조각을
// 한 이름공간에 합치므로 `TargetCategory`의 생성 enum은 그것을 선언한 community 조각에
// 놓인다(settings가 `TermsCode`를 auth 조각에서 가져오는 것과 같다). 같은 enum을 프로필
// 조각에 다시 선언하면 중복 정의로 빌드가 깨진다. 이 타입은 repository 밖으로 나가지
// 않고, 도메인 값은 `common/model/target_category.dart`다(CLAUDE.md §3).
import '../../../common/network/shared_schema.graphql.dart';
import '../model/profile_image_upload.dart';
import '../model/settings_failure.dart';
import 'profile_operations.graphql.dart';
import 'profile_repository.dart';
import 'profile_schema.graphql.dart';

/// GraphQL 기반 [ProfileRepository](SPEC-0011 R3~R6). 생성 타입(`*.graphql.dart`)은
/// **이 파일 밖으로 나가지 않는다**(CLAUDE.md §3).
///
/// 실패 판정은 두 단계다(auth·community·settings와 같은 규약):
///  1. 전송 실패 — 링크 예외나 최상위 `errors[]`. **HTTP는 실패해도 200이다.**
///  2. 도메인 실패 — payload의 `success == false` 또는 `userErrors[]`가 비어있지 않음.
///
/// [uploadProfileImage]만 GraphQL이 아니다 — 이미지 바이트는 서버를 거치지 않고 앱이
/// 스토리지로 직접 PUT한다(R6 2단계). 그래도 repository에 두는 이유는 그것이 데이터
/// 접근이고, 위젯이나 provider가 HTTP를 직접 부르면 계층이 무너지기 때문이다.
class ProfileRepositoryImpl implements ProfileRepository {
  ProfileRepositoryImpl(this._client, {HttpClient? httpClient})
    : _httpClient = httpClient,
      // 우리가 만든 클라이언트만 닫는다 — 주입받은 것은 호출부 소유다.
      _ownsHttpClient = httpClient == null;

  final GraphQLClient _client;

  /// 스토리지 PUT 전용 클라이언트. **`package:http`가 의존성에 없어 `dart:io`의
  /// [HttpClient]를 쓴다** — 커뮤니티 사진 업로드가 이미 같은 판단을 했고, 이것 하나
  /// 때문에 새 패키지를 들이지 않는다. 테스트가 갈아끼울 수 있도록 주입 가능하다.
  final HttpClient? _httpClient;

  final bool _ownsHttpClient;

  @override
  Future<CursorPage<Post>> fetchMyPosts({int? first, String? after}) async {
    final Map<String, dynamic> data = await _query(
      documentNodeQueryMyPosts,
      Variables$Query$MyPosts(first: first, after: after).toJson(),
      'myPosts',
    );
    final Query$MyPosts$myPosts result = Query$MyPosts.fromJson(data).myPosts;
    return CursorPage<Post>(
      items: result.edges
          .map((Query$MyPosts$myPosts$edges e) => _post(e.node))
          .toList(growable: false),
      hasNextPage: result.pageInfo.hasNextPage,
      endCursor: result.pageInfo.endCursor,
    );
  }

  @override
  Future<String> changeNickname(String nickname) async {
    final Map<String, dynamic> data = await _mutate(
      documentNodeMutationChangeNickname,
      Variables$Mutation$ChangeNickname(
        input: Input$ChangeNicknameInput(nickname: nickname),
      ).toJson(),
      'changeNickname',
    );
    final Mutation$ChangeNickname$changeNickname payload =
        Mutation$ChangeNickname.fromJson(data).changeNickname;
    _check('changeNickname', payload.success, payload.userErrors);
    // 서버가 확정한 값이 정본이다. 안 주면 보낸 값을 그대로 쓴다 — 성공했는데 화면이
    // 옛 닉네임을 남겨 두는 것보다 낫다.
    return payload.nickname ?? nickname;
  }

  @override
  Future<ProfileImageUploadUrl> createProfileImageUploadUrl({
    required String contentType,
    required int contentLength,
  }) async {
    final Map<String, dynamic> data = await _mutate(
      documentNodeMutationCreateProfileImageUploadUrl,
      Variables$Mutation$CreateProfileImageUploadUrl(
        input: Input$CreateProfileImageUploadUrlInput(
          contentType: contentType,
          contentLength: contentLength,
        ),
      ).toJson(),
      'createProfileImageUploadUrl',
    );
    final Mutation$CreateProfileImageUploadUrl$createProfileImageUploadUrl
    payload = Mutation$CreateProfileImageUploadUrl.fromJson(
      data,
    ).createProfileImageUploadUrl;
    _check('createProfileImageUploadUrl', payload.success, payload.userErrors);

    final String? uploadUrl = payload.uploadUrl;
    final String? objectKey = payload.objectKey;
    // 성공인데 URL이나 키가 없으면 다음 단계를 진행할 수 없다 — 조용히 넘기면 2단계가
    // null URL로 PUT을 시도한다.
    if (uploadUrl == null || objectKey == null) {
      throw SettingsFailure.unknown;
    }
    return ProfileImageUploadUrl(
      uploadUrl: uploadUrl,
      objectKey: objectKey,
      expiresAt: payload.expiresAt,
    );
  }

  @override
  Future<void> uploadProfileImage({
    required String uploadUrl,
    required String contentType,
    required List<int> bytes,
  }) async {
    final HttpClient client = _httpClient ?? HttpClient();
    try {
      final HttpClientRequest request = await client.putUrl(
        Uri.parse(uploadUrl),
      );
      // **두 헤더가 1단계 선언과 정확히 같아야 한다** — 서명에 들어 있어서 다르면
      // 스토리지가 403 SignatureDoesNotMatch로 거부한다(설계 §4).
      //
      // `contentType` 대신 `set`을 쓰는 이유: HttpHeaders.contentType은 파싱 후 다시
      // 조립하며 charset을 덧붙일 수 있고, 그러면 서명이 깨진다.
      request.headers.set(HttpHeaders.contentTypeHeader, contentType);
      request.headers.contentLength = bytes.length;
      // 압축이 걸리면 Content-Length가 바뀌어 서명이 깨진다.
      request.headers.set(HttpHeaders.acceptEncodingHeader, 'identity');
      // **인증 헤더를 붙이지 않는다** — 서명이 이미 URL에 들어 있다.
      request.add(bytes);

      final HttpClientResponse response = await request.close();
      // 바이트를 비워야 연결이 반환된다.
      await response.drain<void>();
      if (response.statusCode < 200 || response.statusCode >= 300) {
        // 서버를 거치지 않은 실패라 GraphQL 응답에 안 나온다 — 여기서만 보인다.
        GraphqlDebugLog.clientThrew(
          'uploadProfileImage',
          HttpException('status ${response.statusCode}'),
        );
        throw SettingsFailure.network;
      }
    } on SettingsFailure {
      rethrow;
    } on Exception catch (error) {
      GraphqlDebugLog.clientThrew('uploadProfileImage', error);
      throw SettingsFailure.network;
    } finally {
      if (_ownsHttpClient) client.close();
    }
  }

  @override
  Future<String?> confirmProfileImageUpload(String objectKey) async {
    final Map<String, dynamic> data = await _mutate(
      documentNodeMutationConfirmProfileImageUpload,
      Variables$Mutation$ConfirmProfileImageUpload(
        input: Input$ConfirmProfileImageUploadInput(objectKey: objectKey),
      ).toJson(),
      'confirmProfileImageUpload',
    );
    final Mutation$ConfirmProfileImageUpload$confirmProfileImageUpload payload =
        Mutation$ConfirmProfileImageUpload.fromJson(
          data,
        ).confirmProfileImageUpload;
    _check('confirmProfileImageUpload', payload.success, payload.userErrors);
    return payload.profileImageKey;
  }

  @override
  Future<void> removeProfileImage() async {
    final Map<String, dynamic> data = await _mutate(
      documentNodeMutationRemoveProfileImage,
      const <String, dynamic>{},
      'removeProfileImage',
    );
    final Mutation$RemoveProfileImage$removeProfileImage payload =
        Mutation$RemoveProfileImage.fromJson(data).removeProfileImage;
    _check('removeProfileImage', payload.success, payload.userErrors);
  }

  // --- 매핑 (생성 타입 → 도메인) ---------------------------------------------

  /// `myPosts`의 노드 → 공용 [Post].
  ///
  /// **`commentPreview`를 요청하지 않아 비어 있다** — 행 하나에 댓글 미리보기를 그리지
  /// 않는다(디자인 §7). 커뮤니티 피드와 같은 타입이지만 필드 집합은 화면이 정한다.
  Post _post(Query$MyPosts$myPosts$edges$node n) => Post(
    id: n.id,
    title: n.title,
    body: n.body,
    tags: n.tags,
    category: _categoryFromEnum(n.category),
    // **null일 수 있다** — 장소 없는 글이 허용된다.
    spot: n.spot == null
        ? null
        : PostSpot(
            id: n.spot!.id,
            title: n.spot!.title,
            thumbnailImageUrl: n.spot!.thumbnailImageUrl,
            category: n.spot!.category == null
                ? null
                : _categoryFromEnum(n.spot!.category!),
          ),
    author: PostAuthor(
      id: n.author.id,
      nickname: n.author.nickname,
      profileImageUrl: n.author.profileImageUrl,
    ),
    createdAt: _parseTime(n.createdAt),
    photoKeys: n.photoKeys,
    likeCount: n.likeCount,
    commentCount: n.commentCount,
    viewCount: n.viewCount,
    likedByViewer: n.likedByViewer,
    ownedByViewer: n.ownedByViewer,
    hidden: n.hidden,
    edited: n.edited,
  );

  /// 서버가 준 ISO-8601 문자열을 시각으로 파싱한다. 형식이 어긋나면 글 전체를
  /// 실패시키지 않고 epoch로 떨어뜨린다 — 상대 시각 하나 때문에 목록이 비면 손해가 더
  /// 크다(커뮤니티와 같은 판단).
  DateTime _parseTime(String raw) =>
      DateTime.tryParse(raw)?.toUtc() ??
      DateTime.fromMillisecondsSinceEpoch(0, isUtc: true);

  /// 생성 enum → 도메인 enum. 서버가 새 값을 추가하면 `$unknown`이 되어 null이며, 그
  /// 글은 카테고리 라벨만 빠지고 나머지는 정상 표시된다.
  TargetCategory? _categoryFromEnum(Enum$TargetCategory value) =>
      switch (value) {
        Enum$TargetCategory.TOURIST_SPOT => TargetCategory.touristSpot,
        Enum$TargetCategory.CULTURAL_FACILITY =>
          TargetCategory.culturalFacility,
        Enum$TargetCategory.FESTIVAL_EVENT => TargetCategory.festivalEvent,
        Enum$TargetCategory.TRAVEL_COURSE => TargetCategory.travelCourse,
        Enum$TargetCategory.LEISURE_SPORTS => TargetCategory.leisureSports,
        Enum$TargetCategory.LODGING => TargetCategory.lodging,
        Enum$TargetCategory.SHOPPING => TargetCategory.shopping,
        Enum$TargetCategory.RESTAURANT => TargetCategory.restaurant,
        Enum$TargetCategory.TRANSPORT => TargetCategory.transport,
        Enum$TargetCategory.$unknown => null,
      };

  // --- 전송/실행 -------------------------------------------------------------

  Future<Map<String, dynamic>> _query(
    DocumentNode document,
    Map<String, dynamic> variables,
    String operation,
  ) => _run(
    () => _client.query(QueryOptions(document: document, variables: variables)),
    operation,
    variables,
  );

  Future<Map<String, dynamic>> _mutate(
    DocumentNode document,
    Map<String, dynamic> variables,
    String operation,
  ) => _run(
    () => _client.mutate(
      MutationOptions(document: document, variables: variables),
    ),
    operation,
    variables,
  );

  Future<Map<String, dynamic>> _run(
    Future<QueryResult<Object?>> Function() call,
    String operation,
    Map<String, dynamic> variables,
  ) async {
    GraphqlDebugLog.request(operation, variables);
    late final QueryResult<Object?> result;
    try {
      result = await call();
    } on Exception catch (error) {
      GraphqlDebugLog.clientThrew(operation, error);
      // 클라이언트가 던졌다 = 응답 자체를 못 받았다 → 전송 실패.
      throw SettingsFailure.network;
    }

    GraphqlDebugLog.response(operation, result);

    // 범위 판별은 `path`로 한다 — `operation`이 곧 최상위 필드 이름이다. `myPosts`는
    // 커넥션이라 하위 필드만 실패한 응답이 올 수 있고, 그때 목록 전체를 오류로 만들면
    // 글 하나 때문에 화면이 빈다.
    if (hasRootFailure(result, operation)) {
      GraphqlDebugLog.transportFailure(operation, result);
      throw SettingsFailure.fromQueryErrorCode(
        _rootErrorCode(result, operation),
      );
    }

    final Object? data = result.data;
    if (data is! Map<String, dynamic>) throw SettingsFailure.unknown;
    return data;
  }

  /// 전체 실패로 판정된 오류의 코드 문자열. `extensions.code`가 관례이고, 없으면
  /// 코드처럼 보이는 메시지(SCREAMING_SNAKE)를 폴백으로 본다.
  String? _rootErrorCode(QueryResult<Object?> result, String rootField) {
    final GraphQLError? error = firstRootError(result, rootField);
    if (error == null) return null;
    final Object? code = error.extensions?['code'];
    if (code is String && code.isNotEmpty) return code;
    final String message = error.message;
    return RegExp(r'^[A-Z][A-Z0-9_]+$').hasMatch(message) ? message : null;
  }

  /// 도메인 실패 검사: `userErrors`가 비어 있지 않거나 `success == false`면 실패.
  /// **코드만** 로깅한다 — 서버 message는 PII를 담을 수 있다(POL-013).
  void _check(String operation, bool success, List<Object?> userErrors) {
    final List<({String code, String? field})> parsed = userErrors
        .map(_userError)
        .toList();
    if (parsed.isNotEmpty) {
      GraphqlDebugLog.userErrors(operation, parsed);
      throw SettingsFailure.userError(parsed.first.code);
    }
    if (!success) throw SettingsFailure.unknown;
  }

  /// 생성된 `*$userErrors` payload에서 `code`/`field`만 JSON으로 꺼낸다 — 오퍼레이션별
  /// 생성 타입에 묶이지 않기 위해서다(auth·settings repository와 같은 방식).
  ({String code, String? field}) _userError(Object? error) {
    if (error == null) return (code: '', field: null);
    final Map<String, dynamic> json =
        (error as dynamic).toJson() as Map<String, dynamic>;
    return (
      code: json['code'] as String? ?? '',
      field: json['field'] as String?,
    );
  }
}
