import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:ieuri_k_trip_spot/common/model/post.dart';
import 'package:ieuri_k_trip_spot/common/model/target_category.dart';
import 'package:ieuri_k_trip_spot/common/pagination/page.dart';
import 'package:ieuri_k_trip_spot/domain/settings/model/profile_image_upload.dart';
import 'package:ieuri_k_trip_spot/domain/settings/model/settings_failure.dart';
import 'package:ieuri_k_trip_spot/domain/settings/repository/profile_repository_impl.dart';

/// 정형 [Response] 하나를 돌려주는 링크. 실제 네트워크 대신 repository의 매핑과
/// 실패 판정만 검증한다(auth·community 테스트와 같은 패턴).
class _FakeLink extends Link {
  _FakeLink({this.data, this.errors});

  final Map<String, dynamic>? data;
  final List<GraphQLError>? errors;

  /// 마지막으로 서버에 나간 변수(전송 내용 검증용).
  Map<String, dynamic>? sentVariables;

  @override
  Stream<Response> request(Request request, [NextLink? forward]) async* {
    sentVariables = request.variables;
    yield Response(
      data: data,
      errors: errors,
      response: const <String, dynamic>{},
      context: const Context(),
    );
  }
}

ProfileRepositoryImpl _repo(Link link) => ProfileRepositoryImpl(
  GraphQLClient(
    link: link,
    cache: GraphQLCache(),
    // 프로덕션 클라이언트와 같은 정책이어야 부분 실패 경로가 실제와 같게 검증된다.
    defaultPolicies: DefaultPolicies(
      mutate: Policies(fetch: FetchPolicy.noCache, error: ErrorPolicy.all),
      query: Policies(fetch: FetchPolicy.noCache, error: ErrorPolicy.all),
    ),
  ),
);

Map<String, dynamic> _postNode({String id = 'p1'}) => <String, dynamic>{
  'id': id,
  'title': '경복궁 야간개장 후기',
  'body': '한복 입고 가면 무료예요',
  'tags': <String>['야간개장'],
  'category': 'TOURIST_SPOT',
  'createdAt': '2026-08-05T09:22:00.966439Z',
  'photoKeys': <String>['posts/1.jpg'],
  'likeCount': 12,
  'commentCount': 4,
  'viewCount': 330,
  'likedByViewer': false,
  'ownedByViewer': true,
  'hidden': false,
  'edited': false,
  'spot': <String, dynamic>{
    'id': '11094',
    'title': '경복궁',
    'thumbnailImageUrl': 'https://img/spot.jpg',
    'category': 'TOURIST_SPOT',
  },
  'author': <String, dynamic>{
    'id': '20',
    'nickname': 'Traveler',
    'profileImageUrl': null,
  },
};

List<dynamic> _userErrors(String code) => <dynamic>[
  <String, dynamic>{'code': code, 'message': 'x', 'field': null},
];

void main() {
  group('myPosts', () {
    test('PostConnection을 CursorPage<Post>로 매핑한다', () async {
      final ProfileRepositoryImpl repo = _repo(
        _FakeLink(
          data: <String, dynamic>{
            'myPosts': <String, dynamic>{
              'edges': <dynamic>[
                <String, dynamic>{'node': _postNode()},
              ],
              'pageInfo': <String, dynamic>{
                'hasNextPage': true,
                'endCursor': 'cursor-1',
              },
            },
          },
        ),
      );

      final CursorPage<Post> page = await repo.fetchMyPosts(first: 20);

      expect(page.items.single.id, 'p1');
      expect(page.items.single.category, TargetCategory.touristSpot);
      expect(page.items.single.spot?.title, '경복궁');
      expect(page.hasNextPage, isTrue);
      expect(page.endCursor, 'cursor-1');
    });

    test('after 커서를 변수로 전송한다', () async {
      final _FakeLink link = _FakeLink(
        data: <String, dynamic>{
          'myPosts': <String, dynamic>{
            'edges': <dynamic>[],
            'pageInfo': <String, dynamic>{
              'hasNextPage': false,
              'endCursor': null,
            },
          },
        },
      );

      await _repo(link).fetchMyPosts(first: 20, after: 'cursor-1');

      expect(link.sentVariables?['after'], 'cursor-1');
    });

    test('errors 배열이 실리면 실패로 surface한다', () async {
      final ProfileRepositoryImpl repo = _repo(
        _FakeLink(
          errors: <GraphQLError>[
            const GraphQLError(
              message: 'UNAUTHENTICATED',
              path: <dynamic>['myPosts'],
            ),
          ],
        ),
      );

      await expectLater(
        repo.fetchMyPosts(),
        throwsA(
          isA<SettingsFailure>().having(
            (SettingsFailure f) => f.kind,
            'kind',
            SettingsFailureKind.unauthenticated,
          ),
        ),
      );
    });
  });

  group('changeNickname', () {
    test('서버가 확정한 닉네임을 돌려준다', () async {
      final ProfileRepositoryImpl repo = _repo(
        _FakeLink(
          data: <String, dynamic>{
            'changeNickname': <String, dynamic>{
              'success': true,
              'userErrors': <dynamic>[],
              'nickname': 'Traveler',
            },
          },
        ),
      );

      expect(await repo.changeNickname('Traveler'), 'Traveler');
    });

    test('NICKNAME_ALREADY_TAKEN을 코드가 실린 실패로 옮긴다', () async {
      final ProfileRepositoryImpl repo = _repo(
        _FakeLink(
          data: <String, dynamic>{
            'changeNickname': <String, dynamic>{
              'success': false,
              'userErrors': _userErrors('NICKNAME_ALREADY_TAKEN'),
              'nickname': null,
            },
          },
        ),
      );

      await expectLater(
        repo.changeNickname('Traveler'),
        throwsA(
          isA<SettingsFailure>().having(
            (SettingsFailure f) => f.code,
            'code',
            'NICKNAME_ALREADY_TAKEN',
          ),
        ),
      );
    });
  });

  group('createProfileImageUploadUrl', () {
    test('선언한 contentType·contentLength를 그대로 전송한다', () async {
      final _FakeLink link = _FakeLink(
        data: <String, dynamic>{
          'createProfileImageUploadUrl': <String, dynamic>{
            'success': true,
            'userErrors': <dynamic>[],
            'uploadUrl': 'https://storage.example/put?sig=abc',
            'objectKey': 'profile/tmp-1',
            'expiresAt': '2026-08-08T10:00:00Z',
          },
        },
      );

      final ProfileImageUploadUrl issued = await _repo(link)
          .createProfileImageUploadUrl(
            contentType: 'image/jpeg',
            contentLength: 2048,
          );

      final Map<String, dynamic> input =
          link.sentVariables?['input'] as Map<String, dynamic>;
      expect(input['contentType'], 'image/jpeg');
      expect(input['contentLength'], 2048);
      expect(issued.objectKey, 'profile/tmp-1');
    });

    test('성공인데 uploadUrl이 없으면 실패로 본다', () async {
      final ProfileRepositoryImpl repo = _repo(
        _FakeLink(
          data: <String, dynamic>{
            'createProfileImageUploadUrl': <String, dynamic>{
              'success': true,
              'userErrors': <dynamic>[],
              'uploadUrl': null,
              'objectKey': null,
              'expiresAt': null,
            },
          },
        ),
      );

      await expectLater(
        repo.createProfileImageUploadUrl(
          contentType: 'image/jpeg',
          contentLength: 1,
        ),
        throwsA(isA<SettingsFailure>()),
      );
    });
  });

  test('confirmProfileImageUpload가 확정된 키를 돌려준다', () async {
    final ProfileRepositoryImpl repo = _repo(
      _FakeLink(
        data: <String, dynamic>{
          'confirmProfileImageUpload': <String, dynamic>{
            'success': true,
            'userErrors': <dynamic>[],
            'profileImageKey': 'profile/confirmed-1',
          },
        },
      ),
    );

    expect(
      await repo.confirmProfileImageUpload('profile/tmp-1'),
      'profile/confirmed-1',
    );
  });

  test('removeProfileImage는 인자 없이 실행된다', () async {
    final _FakeLink link = _FakeLink(
      data: <String, dynamic>{
        'removeProfileImage': <String, dynamic>{
          'success': true,
          'userErrors': <dynamic>[],
        },
      },
    );

    await _repo(link).removeProfileImage();

    expect(link.sentVariables, isEmpty);
  });

  test('removeProfileImage의 userErrors는 실패다', () async {
    final ProfileRepositoryImpl repo = _repo(
      _FakeLink(
        data: <String, dynamic>{
          'removeProfileImage': <String, dynamic>{
            'success': false,
            'userErrors': _userErrors('PROFILE_IMAGE_NOT_FOUND'),
          },
        },
      ),
    );

    await expectLater(
      repo.removeProfileImage(),
      throwsA(
        isA<SettingsFailure>().having(
          (SettingsFailure f) => f.code,
          'code',
          'PROFILE_IMAGE_NOT_FOUND',
        ),
      ),
    );
  });
}
