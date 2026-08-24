import 'package:ieuri_k_trip_spot/common/model/post.dart';
import 'package:ieuri_k_trip_spot/common/pagination/page.dart';
import 'package:ieuri_k_trip_spot/domain/settings/model/profile_image_upload.dart';
import 'package:ieuri_k_trip_spot/domain/settings/model/settings_failure.dart';
import 'package:ieuri_k_trip_spot/domain/settings/repository/profile_repository.dart';

/// 3단계 업로드 중 어느 단계가 실행됐는지 기록하는 이름들.
///
/// 순서를 문자열로 남기면 "1단계는 했는데 확정은 안 했다"를 한 리스트로 단언할 수
/// 있다 — 단계별 bool 플래그 다섯 개보다 읽기 쉽고, 순서까지 검증된다.
const String stepCreateUrl = 'createUrl';
const String stepUpload = 'upload';
const String stepConfirm = 'confirm';
const String stepRemove = 'remove';

/// 네트워크 없는 [ProfileRepository]. 반환값과 실패를 테스트가 정한다.
class FakeProfileRepository implements ProfileRepository {
  FakeProfileRepository({this.pages = const <CursorPage<Post>>[]});

  /// 호출 순서대로 돌려줄 페이지들. 다 쓰면 마지막 것을 다시 준다.
  List<CursorPage<Post>> pages;

  /// [fetchMyPosts]에 실린 `after` 커서들(첫 페이지는 null).
  final List<String?> requestedCursors = <String?>[];

  /// 밟은 단계의 순서. 중간 실패 시 어디까지 갔는지 여기로 확인한다.
  final List<String> steps = <String>[];

  /// 각 메서드가 던질 실패. null이면 성공한다.
  SettingsFailure? fetchFailure;
  SettingsFailure? nicknameFailure;
  SettingsFailure? createUrlFailure;
  SettingsFailure? uploadFailure;

  /// `SettingsFailure`가 **아닌** 예외를 2단계에서 던진다. 매핑 중의 `TypeError`처럼
  /// 예상 밖의 실패에도 컨트롤러가 idle로 돌아오는지 보는 데 쓴다 — 이걸 못 잡으면
  /// `isBusy`가 영영 true로 남아 사용자가 재시도조차 못 한다.
  Object? uploadRawError;
  SettingsFailure? confirmFailure;
  SettingsFailure? removeFailure;

  /// 1단계에 선언된 값. 실제 PUT과 일치하는지 검증하는 데 쓴다.
  String? declaredContentType;
  int? declaredContentLength;

  /// 2단계가 실제로 보낸 바이트 수와 타입.
  int? sentByteCount;
  String? sentContentType;

  String? submittedNickname;

  @override
  Future<CursorPage<Post>> fetchMyPosts({int? first, String? after}) async {
    requestedCursors.add(after);
    if (fetchFailure != null) throw fetchFailure!;
    if (pages.isEmpty) return CursorPage.empty<Post>();
    final int index = requestedCursors.length - 1;
    return pages[index < pages.length ? index : pages.length - 1];
  }

  @override
  Future<String> changeNickname(String nickname) async {
    submittedNickname = nickname;
    if (nicknameFailure != null) throw nicknameFailure!;
    return nickname;
  }

  @override
  Future<ProfileImageUploadUrl> createProfileImageUploadUrl({
    required String contentType,
    required int contentLength,
  }) async {
    steps.add(stepCreateUrl);
    declaredContentType = contentType;
    declaredContentLength = contentLength;
    if (createUrlFailure != null) throw createUrlFailure!;
    return const ProfileImageUploadUrl(
      uploadUrl: 'https://storage.example/put?sig=abc',
      objectKey: 'profile/tmp-1',
    );
  }

  @override
  Future<void> uploadProfileImage({
    required String uploadUrl,
    required String contentType,
    required List<int> bytes,
  }) async {
    steps.add(stepUpload);
    sentByteCount = bytes.length;
    sentContentType = contentType;
    if (uploadRawError != null) throw uploadRawError!;
    if (uploadFailure != null) throw uploadFailure!;
  }

  @override
  Future<String?> confirmProfileImageUpload(String objectKey) async {
    steps.add(stepConfirm);
    if (confirmFailure != null) throw confirmFailure!;
    return 'profile/confirmed-1';
  }

  @override
  Future<void> removeProfileImage() async {
    steps.add(stepRemove);
    if (removeFailure != null) throw removeFailure!;
  }
}
