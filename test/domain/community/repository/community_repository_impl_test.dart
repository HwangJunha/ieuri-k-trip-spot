import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:ieuri_k_trip_spot/common/pagination/offset_page.dart';
import 'package:ieuri_k_trip_spot/common/pagination/page.dart';
import 'package:ieuri_k_trip_spot/domain/community/model/blocked_user.dart';
import 'package:ieuri_k_trip_spot/common/model/comment.dart';
import 'package:ieuri_k_trip_spot/domain/community/model/community_chip.dart';
import 'package:ieuri_k_trip_spot/domain/community/model/community_failure.dart';
import 'package:ieuri_k_trip_spot/domain/community/model/nearby_spot.dart';
import 'package:ieuri_k_trip_spot/domain/community/model/nearby_spot_category.dart';
import 'package:ieuri_k_trip_spot/common/model/post.dart';
import 'package:ieuri_k_trip_spot/common/model/post_image_upload.dart';
import 'package:ieuri_k_trip_spot/domain/community/model/post_sort_order.dart';
import 'package:ieuri_k_trip_spot/domain/community/model/report_reason.dart';
import 'package:ieuri_k_trip_spot/common/model/target_category.dart';
import 'package:ieuri_k_trip_spot/domain/community/repository/community_repository_impl.dart';

/// 정형 [Response] 하나를 돌려주는 링크. 실제 네트워크 대신 repository의 매핑과
/// 실패 판정만 검증한다(spot·auth 테스트와 같은 패턴).
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

CommunityRepositoryImpl _repo(Link link) => CommunityRepositoryImpl(
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

Map<String, dynamic> _postNode({
  String id = 'p1',
  String category = 'TOURIST_SPOT',
  bool hidden = false,
  bool edited = false,
  int commentCount = 4,
  int viewCount = 330,
  List<String> tags = const <String>[],
  List<String> photoKeys = const <String>[],
  bool withSpot = true,
}) => <String, dynamic>{
  'id': id,
  'title': '경복궁 야간개장 후기',
  'body': '한복 입고 가면 무료예요',
  'tags': tags,
  'category': category,
  'createdAt': '2026-08-05T09:22:00.966439Z',
  'photoKeys': photoKeys,
  'likeCount': 12,
  'commentCount': commentCount,
  'viewCount': viewCount,
  'likedByViewer': false,
  'ownedByViewer': false,
  'hidden': hidden,
  'edited': edited,
  'spot': withSpot
      ? <String, dynamic>{
          'id': '11094',
          'title': '경복궁',
          'thumbnailImageUrl': 'https://img/spot.jpg',
          'category': 'TOURIST_SPOT',
        }
      : null,
  'author': <String, dynamic>{
    'id': '20',
    'nickname': '여행자',
    'profileImageUrl': null,
  },
};

/// 서버가 주는 댓글 노드 하나. [replies]는 최상위에만 준다(2차 가이드 §1).
Map<String, dynamic> _commentNode({
  required String id,
  required String body,
  String nickname = '민지',
  String? parentCommentId,
  List<dynamic> replies = const <dynamic>[],
}) => <String, dynamic>{
  'id': id,
  'body': body,
  'createdAt': '2026-08-05T10:00:00Z',
  'ownedByViewer': false,
  'hidden': false,
  'parentCommentId': parentCommentId,
  'author': <String, dynamic>{
    'id': '12',
    'nickname': nickname,
    'profileImageUrl': null,
  },
  'replies': replies,
};

Map<String, dynamic> _postsData({
  List<Map<String, dynamic>>? nodes,
  bool hasNextPage = false,
  String? endCursor,
}) => <String, dynamic>{
  'posts': <String, dynamic>{
    'edges': <dynamic>[
      for (final Map<String, dynamic> node in nodes ?? <Map<String, dynamic>>[])
        <String, dynamic>{'cursor': node['id'], 'node': node},
    ],
    'pageInfo': <String, dynamic>{
      'hasNextPage': hasNextPage,
      'endCursor': endCursor,
    },
  },
};

void main() {
  group('posts — 인자 조합이 범위를 정한다 (가이드 §2)', () {
    test('PostConnection을 도메인 CursorPage로 매핑한다', () async {
      final _FakeLink link = _FakeLink(
        data: _postsData(
          nodes: <Map<String, dynamic>>[
            _postNode(id: 'p1', tags: const <String>['야간개장']),
            _postNode(id: 'p2', category: 'RESTAURANT'),
          ],
          hasNextPage: true,
          endCursor: 'p2',
        ),
      );

      final CursorPage<Post> page = await _repo(link).fetchPosts(
        latitude: 37.5665,
        longitude: 126.978,
        category: TargetCategory.touristSpot,
        first: 20,
      );

      expect(page.items, hasLength(2));
      expect(page.items.first.id, 'p1');
      expect(page.items.first.title, '경복궁 야간개장 후기');
      expect(page.items.first.category, TargetCategory.touristSpot);
      expect(page.items.first.tags, <String>['야간개장']);
      expect(page.items.first.spot?.title, '경복궁');
      expect(page.items.first.author.nickname, '여행자');
      // 조회수는 서버 값을 그대로 쓴다 — 클라이언트가 세지 않는다.
      expect(page.items.first.viewCount, 330);
      expect(page.items[1].category, TargetCategory.restaurant);
      expect(page.hasNextPage, isTrue);
      expect(page.endCursor, 'p2');
      // 필터는 서버로 넘어간다 — 클라이언트가 받은 목록을 거르지 않는다.
      expect(link.sentVariables?['category'], 'TOURIST_SPOT');
    });

    // 2차 가이드 §3 — 정렬은 서버 인자다. 클라이언트가 받은 목록을 다시 세우지 않는다.
    test('정렬을 서버 enum으로 넘긴다', () async {
      final _FakeLink link = _FakeLink(data: _postsData());

      await _repo(link).fetchPosts(
        latitude: 37.4665,
        longitude: 126.8956,
        sort: PostSortOrder.distance,
      );

      expect(link.sentVariables?['sort'], 'DISTANCE');
    });

    // 서버 기본값이 LATEST라 null이면 변수를 아예 보내지 않는다.
    test('정렬을 주지 않으면 변수를 보내지 않는다', () async {
      final _FakeLink link = _FakeLink(data: _postsData());

      await _repo(link).fetchPosts();

      expect(link.sentVariables?['sort'], isNull);
    });

    // 2차 가이드 §2 — 숨긴 글은 이 인자로만 보인다.
    test('hiddenByViewer를 서버로 넘긴다', () async {
      final _FakeLink link = _FakeLink(
        data: _postsData(nodes: <Map<String, dynamic>>[_postNode(id: 'p21')]),
      );

      final CursorPage<Post> page = await _repo(
        link,
      ).fetchPosts(hiddenByViewer: true, first: 20);

      expect(link.sentVariables?['hiddenByViewer'], isTrue);
      expect(page.items.single.id, 'p21');
    });

    // 가이드 §5 — 장소 없는 글이 허용된다. null이 오류가 아니다.
    test('spot이 null인 글도 그대로 매핑한다', () async {
      final CursorPage<Post> page = await _repo(
        _FakeLink(
          data: _postsData(
            nodes: <Map<String, dynamic>>[_postNode(withSpot: false)],
          ),
        ),
      ).fetchPosts();

      expect(page.items.single.spot, isNull);
    });

    test('edited: true를 그대로 전달한다', () async {
      final CursorPage<Post> page = await _repo(
        _FakeLink(
          data: _postsData(
            nodes: <Map<String, dynamic>>[_postNode(edited: true)],
          ),
        ),
      ).fetchPosts();

      expect(page.items.single.edited, isTrue);
    });

    test('catalogId를 주면 그대로 서버에 넘긴다', () async {
      final _FakeLink link = _FakeLink(data: _postsData());

      await _repo(link).fetchPosts(catalogId: '11094');

      expect(link.sentVariables?['catalogId'], '11094');
    });

    // 가이드 §2 — 좌표는 둘 다 줘야 의미가 있다. 하나만 주면 서버가 둘 다 무시하므로
    // 어중간한 요청을 보내지 않고 아예 뺀다.
    test('위도만 주면 좌표를 아예 보내지 않는다', () async {
      final _FakeLink link = _FakeLink(data: _postsData());

      await _repo(link).fetchPosts(latitude: 37.5, radiusMeters: 5000);

      expect(link.sentVariables?.containsKey('latitude'), isFalse);
      expect(link.sentVariables?.containsKey('longitude'), isFalse);
      expect(link.sentVariables?.containsKey('radiusMeters'), isFalse);
    });

    test('태그 필터를 그대로 서버에 넘긴다', () async {
      final _FakeLink link = _FakeLink(data: _postsData());

      await _repo(link).fetchPosts(tag: 'seoul');

      expect(link.sentVariables?['tag'], 'seoul');
    });

    // GraphQL은 실패해도 HTTP 200이다. 최상위 errors[]가 이 필드를 가리키면 전체
    // 실패로 다뤄야 한다.
    test('최상위 errors[]는 실패로 surface된다', () async {
      final _FakeLink link = _FakeLink(
        data: null,
        errors: <GraphQLError>[
          const GraphQLError(
            message: 'internal error',
            path: <dynamic>['posts'],
          ),
        ],
      );

      expect(() => _repo(link).fetchPosts(), throwsA(isA<CommunityFailure>()));
    });

    test('UNAUTHENTICATED는 전용 실패 종류로 번역된다', () async {
      final _FakeLink link = _FakeLink(
        data: null,
        errors: <GraphQLError>[
          const GraphQLError(
            message: '인증이 필요합니다.',
            path: <dynamic>['posts'],
            extensions: <String, dynamic>{'code': 'UNAUTHENTICATED'},
          ),
        ],
      );

      expect(
        () => _repo(link).fetchPosts(),
        throwsA(
          isA<CommunityFailure>().having(
            (CommunityFailure f) => f.kind,
            'kind',
            CommunityFailureKind.unauthenticated,
          ),
        ),
      );
    });
  });

  group('post(id:)', () {
    test('글 하나를 매핑한다', () async {
      final Post? post = await _repo(
        _FakeLink(data: <String, dynamic>{'post': _postNode(hidden: true)}),
      ).fetchPost('p1');

      expect(post, isNotNull);
      expect(post!.hidden, isTrue);
      expect(post.title, '경복궁 야간개장 후기');
    });

    // 가이드 §6 — 차단·숨김·삭제면 오류가 아니라 null이다. errors[]를 기대하면 안 된다.
    test('차단·숨김이면 오류가 아니라 null을 돌려준다', () async {
      final Post? post = await _repo(
        _FakeLink(data: <String, dynamic>{'post': null}),
      ).fetchPost('p1');

      expect(post, isNull);
    });
  });

  group('comments — 루트 쿼리 (가이드 §2)', () {
    test('CommentConnection을 CursorPage로 매핑한다', () async {
      final _FakeLink link = _FakeLink(
        data: <String, dynamic>{
          'comments': <String, dynamic>{
            'edges': <dynamic>[
              <String, dynamic>{
                'cursor': 'cc1',
                'node': _commentNode(id: 'c1', body: '저도 가봤어요', nickname: '민지'),
              },
            ],
            'pageInfo': <String, dynamic>{
              'hasNextPage': true,
              'endCursor': 'cc1',
            },
          },
        },
      );

      final CursorPage<Comment> page = await _repo(
        link,
      ).fetchComments('p1', first: 20);

      expect(page.items.single.author.nickname, '민지');
      expect(page.hasNextPage, isTrue);
      expect(page.endCursor, 'cc1');
      expect(link.sentVariables?['postId'], 'p1');
    });

    // 2차 가이드 §1 — `comments(postId:)`는 최상위만 주고 답글은 `replies`에 온다.
    test('답글을 부모의 replies로 매핑한다', () async {
      final _FakeLink link = _FakeLink(
        data: <String, dynamic>{
          'comments': <String, dynamic>{
            'edges': <dynamic>[
              <String, dynamic>{
                'cursor': 'cc18',
                'node': _commentNode(
                  id: '18',
                  body: '수문장 교대식 시간표가 어떻게 되나요?',
                  replies: <dynamic>[
                    _commentNode(
                      id: '27',
                      body: '10시, 14시 두 번이에요',
                      parentCommentId: '18',
                    ),
                    _commentNode(
                      id: '28',
                      body: '겨울에는 조금 달라요',
                      parentCommentId: '18',
                    ),
                  ],
                ),
              },
            ],
            'pageInfo': <String, dynamic>{
              'hasNextPage': false,
              'endCursor': null,
            },
          },
        },
      );

      final CursorPage<Comment> page = await _repo(
        link,
      ).fetchComments('p1', first: 20);

      final Comment parent = page.items.single;
      expect(parent.isTopLevel, isTrue);
      expect(parent.parentCommentId, isNull);
      // **오래된 순 그대로다** — 대화 흐름이라 뒤집지 않는다.
      expect(parent.replies.map((Comment c) => c.id), <String>['27', '28']);
      expect(parent.replies.first.parentCommentId, '18');
      expect(parent.replies.first.isTopLevel, isFalse);
      // 답글의 답글은 없다(3단계가 없어 요청조차 하지 않는다).
      expect(parent.replies.first.replies, isEmpty);
    });
  });

  group('communityChips', () {
    test('칩을 매핑한다 (표시 문구는 서버가 주지 않는다)', () async {
      final List<CommunityChip> chips = await _repo(
        _FakeLink(
          data: <String, dynamic>{
            'communityChips': <dynamic>[
              <String, dynamic>{'category': 'RESTAURANT', 'position': 0},
              <String, dynamic>{'category': 'LODGING', 'position': 1},
            ],
          },
        ),
      ).fetchCommunityChips();

      expect(chips.map((CommunityChip c) => c.category), <TargetCategory>[
        TargetCategory.restaurant,
        TargetCategory.lodging,
      ]);
    });

    // 가이드 §2 — 구성이 없는 앱이면 빈 목록이고 그것이 정상이다.
    test('빈 목록은 정상이다', () async {
      final List<CommunityChip> chips = await _repo(
        _FakeLink(data: <String, dynamic>{'communityChips': <dynamic>[]}),
      ).fetchCommunityChips();

      expect(chips, isEmpty);
    });

    // 클라이언트가 모르는 카테고리 하나 때문에 상단 줄 전체를 실패시키지 않는다.
    test('모르는 카테고리는 빼고 나머지를 준다', () async {
      final List<CommunityChip> chips = await _repo(
        _FakeLink(
          data: <String, dynamic>{
            'communityChips': <dynamic>[
              <String, dynamic>{'category': 'SOMETHING_NEW', 'position': 0},
              <String, dynamic>{'category': 'RESTAURANT', 'position': 1},
            ],
          },
        ),
      ).fetchCommunityChips();

      expect(chips, hasLength(1));
      expect(chips.single.category, TargetCategory.restaurant);
    });
  });

  group('blockedUsers', () {
    test('차단 목록과 차단 시각을 매핑한다', () async {
      final CursorPage<BlockedUser> page = await _repo(
        _FakeLink(
          data: <String, dynamic>{
            'blockedUsers': <String, dynamic>{
              'edges': <dynamic>[
                <String, dynamic>{
                  'cursor': 'b1',
                  'blockedAt': '2026-08-01T00:00:00Z',
                  'node': <String, dynamic>{
                    'id': '19',
                    'nickname': '차단된사람',
                    'profileImageUrl': null,
                  },
                },
              ],
              'pageInfo': <String, dynamic>{
                'hasNextPage': false,
                'endCursor': null,
              },
            },
          },
        ),
      ).fetchBlockedUsers();

      expect(page.items.single.member.nickname, '차단된사람');
      expect(page.items.single.blockedAt.year, 2026);
    });
  });

  group('likePost', () {
    test('서버가 돌려준 likeCount를 반환한다', () async {
      final int? count = await _repo(
        _FakeLink(
          data: <String, dynamic>{
            'likePost': <String, dynamic>{
              'success': true,
              'userErrors': <dynamic>[],
              'likeCount': 13,
            },
          },
        ),
      ).likePost('p1');

      expect(count, 13);
    });

    // 가이드 §7 — 최상위 errors[]가 아니라 payload의 userErrors로 실패가 온다.
    // HTTP 200이므로 success/userErrors로만 판정해야 한다.
    test('payload userErrors는 실패로 surface되고 코드를 담는다', () async {
      expect(
        () => _repo(
          _FakeLink(
            data: <String, dynamic>{
              'likePost': <String, dynamic>{
                'success': false,
                'userErrors': <dynamic>[
                  <String, dynamic>{
                    'code': 'POST_NOT_FOUND',
                    'message': '이미 삭제된 글입니다.',
                    'field': null,
                  },
                ],
                'likeCount': null,
              },
            },
          ),
        ).likePost('p1'),
        throwsA(
          isA<CommunityFailure>()
              .having(
                (CommunityFailure f) => f.kind,
                'kind',
                CommunityFailureKind.userError,
              )
              .having((CommunityFailure f) => f.code, 'code', 'POST_NOT_FOUND'),
        ),
      );
    });
  });

  group('createPost', () {
    // 가이드 §5 — postId만 오고 post는 항상 null이다.
    test('postId만 돌려주고 입력을 그대로 서버에 넘긴다', () async {
      final _FakeLink link = _FakeLink(
        data: <String, dynamic>{
          'createPost': <String, dynamic>{
            'success': true,
            'userErrors': <dynamic>[],
            'postId': '42',
          },
        },
      );

      final String? postId = await _repo(link).createPost(
        category: TargetCategory.restaurant,
        title: '경복궁 야간개장 후기',
        body: '한복 입고 가면 무료예요',
        catalogId: '11094',
        tags: <String>['야간개장'],
        photoKeys: <String>['images/20/abc'],
      );

      expect(postId, '42');
      expect(link.sentVariables?['category'], 'RESTAURANT');
      expect(link.sentVariables?['catalogId'], '11094');
      expect(link.sentVariables?['tags'], <String>['야간개장']);
      expect(link.sentVariables?['photoKeys'], <String>['images/20/abc']);
    });

    // 가이드 §5 — 장소는 선택이다. 생략하면 변수 자체를 보내지 않는다.
    test('장소 없이도 작성할 수 있다', () async {
      final _FakeLink link = _FakeLink(
        data: <String, dynamic>{
          'createPost': <String, dynamic>{
            'success': true,
            'userErrors': <dynamic>[],
            'postId': '43',
          },
        },
      );

      await _repo(link).createPost(
        category: TargetCategory.touristSpot,
        title: '여행 짐 싸는 팁',
        body: '가볍게 싸세요',
      );

      expect(link.sentVariables?.containsKey('catalogId'), isFalse);
    });

    test('제목 길이 위반은 코드를 담은 실패가 된다', () async {
      expect(
        () =>
            _repo(
              _FakeLink(
                data: <String, dynamic>{
                  'createPost': <String, dynamic>{
                    'success': false,
                    'userErrors': <dynamic>[
                      <String, dynamic>{
                        'code': 'POST_TITLE_LENGTH_INVALID',
                        'message': '제목이 너무 깁니다.',
                        'field': 'title',
                      },
                    ],
                    'postId': null,
                  },
                },
              ),
            ).createPost(
              category: TargetCategory.touristSpot,
              title: '가' * 51,
              body: '본문',
            ),
        throwsA(
          isA<CommunityFailure>().having(
            (CommunityFailure f) => f.code,
            'code',
            'POST_TITLE_LENGTH_INVALID',
          ),
        ),
      );
    });
  });

  group('editPost', () {
    // 가이드 §5 — photoKeys를 생략하면 사진을 건드리지 않는다. 빈 배열과 다른 뜻이라
    // 변수 자체가 나가면 안 된다.
    test('photoKeys를 주지 않으면 변수를 보내지 않는다', () async {
      final _FakeLink link = _FakeLink(
        data: <String, dynamic>{
          'editPost': <String, dynamic>{
            'success': true,
            'userErrors': <dynamic>[],
          },
        },
      );

      await _repo(link).editPost(postId: '42', title: '새 제목', body: '새 본문');

      expect(link.sentVariables?['title'], '새 제목');
      expect(link.sentVariables?.containsKey('photoKeys'), isFalse);
    });

    // 서버가 뒤늦게 받기 시작한 셋. enum은 서버 표기로 나가야 한다.
    test('카테고리·태그를 함께 보낸다', () async {
      final _FakeLink link = _FakeLink(
        data: <String, dynamic>{
          'editPost': <String, dynamic>{
            'success': true,
            'userErrors': <dynamic>[],
          },
        },
      );

      await _repo(link).editPost(
        postId: '42',
        title: 't',
        body: 'b',
        category: TargetCategory.restaurant,
        tags: <String>['야간개장'],
      );

      expect(link.sentVariables?['category'], 'RESTAURANT');
      expect(link.sentVariables?['tags'], <String>['야간개장']);
    });

    // `changeSpot`은 스키마에만 있는 인자다 — false면 서버가 catalogId를 무시하므로
    // 아예 싣지 않는다.
    test('장소를 바꾸지 않으면 changeSpot: false로 나가고 catalogId를 싣지 않는다', () async {
      final _FakeLink link = _FakeLink(
        data: <String, dynamic>{
          'editPost': <String, dynamic>{
            'success': true,
            'userErrors': <dynamic>[],
          },
        },
      );

      await _repo(link).editPost(
        postId: '42',
        title: 't',
        body: 'b',
        // 호출자가 실수로 실어 보내도 changeSpot이 false면 버린다.
        catalogId: '11094',
      );

      expect(link.sentVariables?['changeSpot'], isFalse);
      expect(link.sentVariables?.containsKey('catalogId'), isFalse);
    });

    test('장소를 바꾸면 changeSpot: true와 새 catalogId가 나간다', () async {
      final _FakeLink link = _FakeLink(
        data: <String, dynamic>{
          'editPost': <String, dynamic>{
            'success': true,
            'userErrors': <dynamic>[],
          },
        },
      );

      await _repo(link).editPost(
        postId: '42',
        title: 't',
        body: 'b',
        changeSpot: true,
        catalogId: '11094',
      );

      expect(link.sentVariables?['changeSpot'], isTrue);
      expect(link.sentVariables?['catalogId'], '11094');
    });

    // 떼기는 **true + catalogId 없음**이다. 생략된 nullable 입력은 서버에서 null로
    // 읽히고, changeSpot이 true라 "비우라"는 뜻이 된다.
    test('장소를 떼면 changeSpot: true만 나가고 catalogId는 빠진다', () async {
      final _FakeLink link = _FakeLink(
        data: <String, dynamic>{
          'editPost': <String, dynamic>{
            'success': true,
            'userErrors': <dynamic>[],
          },
        },
      );

      await _repo(
        link,
      ).editPost(postId: '42', title: 't', body: 'b', changeSpot: true);

      expect(link.sentVariables?['changeSpot'], isTrue);
      expect(link.sentVariables?.containsKey('catalogId'), isFalse);
    });

    test('숨겨진 글 수정은 POST_NOT_EDITABLE 실패가 된다', () async {
      expect(
        () => _repo(
          _FakeLink(
            data: <String, dynamic>{
              'editPost': <String, dynamic>{
                'success': false,
                'userErrors': <dynamic>[
                  <String, dynamic>{
                    'code': 'POST_NOT_EDITABLE',
                    'message': '숨겨진 글은 수정할 수 없습니다.',
                    'field': null,
                  },
                ],
              },
            },
          ),
        ).editPost(postId: '42', title: 't', body: 'b'),
        throwsA(
          isA<CommunityFailure>().having(
            (CommunityFailure f) => f.code,
            'code',
            'POST_NOT_EDITABLE',
          ),
        ),
      );
    });
  });

  group('댓글 뮤테이션', () {
    test('createComment는 commentId만 돌려준다', () async {
      final _FakeLink link = _FakeLink(
        data: <String, dynamic>{
          'createComment': <String, dynamic>{
            'success': true,
            'userErrors': <dynamic>[],
            'commentId': 'c9',
          },
        },
      );

      final String? id = await _repo(
        link,
      ).createComment(postId: 'p1', body: '좋네요');

      expect(id, 'c9');
      expect(link.sentVariables?['postId'], 'p1');
      // 최상위 댓글이면 부모를 보내지 않는다(2차 가이드 §1).
      expect(link.sentVariables?['parentCommentId'], isNull);
    });

    // 2차 가이드 §1 — 답글은 parentCommentId로 단다.
    test('답글은 parentCommentId를 함께 넘긴다', () async {
      final _FakeLink link = _FakeLink(
        data: <String, dynamic>{
          'createComment': <String, dynamic>{
            'success': true,
            'userErrors': <dynamic>[],
            'commentId': 'c27',
          },
        },
      );

      await _repo(
        link,
      ).createComment(postId: 'p1', body: '저도요!', parentCommentId: '18');

      expect(link.sentVariables?['parentCommentId'], '18');
    });

    test('남의 댓글 삭제는 NOT_COMMENT_OWNER 실패가 된다', () async {
      expect(
        () => _repo(
          _FakeLink(
            data: <String, dynamic>{
              'deleteComment': <String, dynamic>{
                'success': false,
                'userErrors': <dynamic>[
                  <String, dynamic>{
                    'code': 'NOT_COMMENT_OWNER',
                    'message': '본인 댓글만 삭제할 수 있습니다.',
                    'field': null,
                  },
                ],
              },
            },
          ),
        ).deleteComment('c1'),
        throwsA(
          isA<CommunityFailure>().having(
            (CommunityFailure f) => f.code,
            'code',
            'NOT_COMMENT_OWNER',
          ),
        ),
      );
    });
  });

  group('사진 업로드 (가이드 §4)', () {
    test('1단계는 발급 URL을 순서대로 매핑한다', () async {
      final _FakeLink link = _FakeLink(
        data: <String, dynamic>{
          'createPostImageUploadUrls': <String, dynamic>{
            'success': true,
            'userErrors': <dynamic>[],
            'uploadUrls': <dynamic>[
              <String, dynamic>{
                'uploadUrl': 'https://storage/1?sig=a',
                'objectKey': 'pending/20/1',
                'expiresAt': '2026-08-06T12:30:00Z',
              },
              <String, dynamic>{
                'uploadUrl': 'https://storage/2?sig=b',
                'objectKey': 'pending/20/2',
                'expiresAt': '2026-08-06T12:30:00Z',
              },
            ],
          },
        },
      );

      final List<PostImageUploadUrl> urls = await _repo(link)
          .createPostImageUploadUrls(<PostImageUploadRequest>[
            const PostImageUploadRequest(
              contentType: 'image/jpeg',
              contentLength: 184320,
            ),
            const PostImageUploadRequest(
              contentType: 'image/png',
              contentLength: 502113,
            ),
          ]);

      expect(urls.map((PostImageUploadUrl u) => u.objectKey), <String>[
        'pending/20/1',
        'pending/20/2',
      ]);
      // contentLength가 서명에 들어가므로 정확히 전달돼야 한다.
      expect(
        (link.sentVariables?['images'] as List<dynamic>).first,
        <String, dynamic>{'contentType': 'image/jpeg', 'contentLength': 184320},
      );
    });

    // 가이드 §4 — 하나라도 어긋나면 전부 발급되지 않는다(빈 목록). 부분 발급이 없다.
    test('1단계 실패는 빈 목록으로 온다', () async {
      final List<PostImageUploadUrl> urls = await _repo(
        _FakeLink(
          data: <String, dynamic>{
            'createPostImageUploadUrls': <String, dynamic>{
              'success': true,
              'userErrors': <dynamic>[],
              'uploadUrls': <dynamic>[],
            },
          },
        ),
      ).createPostImageUploadUrls(const <PostImageUploadRequest>[]);

      expect(urls, isEmpty);
    });

    // 가이드 §4의 핵심 — failed가 있으면 success는 false지만 confirmed의 키는
    // **여전히 유효하다.** 실패로 던지면 통과한 장까지 버려져 사용자가 전부 다시
    // 올려야 한다.
    test('3단계 부분 실패에서도 confirmed 키를 버리지 않는다', () async {
      final PostImageConfirmation result = await _repo(
        _FakeLink(
          data: <String, dynamic>{
            'confirmPostImageUploads': <String, dynamic>{
              'success': false,
              'userErrors': <dynamic>[],
              'confirmed': <dynamic>['images/20/1'],
              'failed': <dynamic>[
                <String, dynamic>{
                  'objectKey': 'pending/20/2',
                  'code': 'UNSUPPORTED_CONTENT_TYPE',
                },
              ],
            },
          },
        ),
      ).confirmPostImageUploads(<String>['pending/20/1', 'pending/20/2']);

      expect(result.confirmed, <String>['images/20/1']);
      expect(result.failed.single.code, 'UNSUPPORTED_CONTENT_TYPE');
      expect(result.hasFailures, isTrue);
    });

    // 반면 userErrors는 요청 자체가 거부된 것이라 실패로 다룬다.
    test('3단계 userErrors는 실패로 surface된다', () async {
      expect(
        () => _repo(
          _FakeLink(
            data: <String, dynamic>{
              'confirmPostImageUploads': <String, dynamic>{
                'success': false,
                'userErrors': <dynamic>[
                  <String, dynamic>{
                    'code': 'PHOTO_NOT_UPLOADED',
                    'message': '업로드되지 않은 키입니다.',
                    'field': null,
                  },
                ],
                'confirmed': <dynamic>[],
                'failed': <dynamic>[],
              },
            },
          ),
        ).confirmPostImageUploads(<String>['pending/20/1']),
        throwsA(
          isA<CommunityFailure>().having(
            (CommunityFailure f) => f.code,
            'code',
            'PHOTO_NOT_UPLOADED',
          ),
        ),
      );
    });

    test('deletePostImage는 키를 그대로 넘긴다', () async {
      final _FakeLink link = _FakeLink(
        data: <String, dynamic>{
          'deletePostImage': <String, dynamic>{
            'success': true,
            'userErrors': <dynamic>[],
          },
        },
      );

      await _repo(link).deletePostImage('images/20/1');

      expect(link.sentVariables?['objectKey'], 'images/20/1');
    });
  });

  group('blockUser', () {
    test('대상 회원 id를 서버에 넘긴다', () async {
      final _FakeLink link = _FakeLink(
        data: <String, dynamic>{
          'blockUser': <String, dynamic>{
            'success': true,
            'userErrors': <dynamic>[],
          },
        },
      );

      await _repo(link).blockUser('19');

      expect(link.sentVariables?['targetMemberId'], '19');
    });

    // 가이드 §7 — 쓰기는 전부 인증 필수이고, UNAUTHENTICATED만 최상위 errors[]로
    // 온다. 화면이 로그인으로 유도하려면 이 종류가 구분돼야 한다.
    test('미인증은 전용 실패 종류로 번역된다', () async {
      expect(
        () => _repo(
          _FakeLink(
            data: null,
            errors: <GraphQLError>[
              const GraphQLError(
                message: '인증이 필요합니다.',
                path: <dynamic>['blockUser'],
                extensions: <String, dynamic>{'code': 'UNAUTHENTICATED'},
              ),
            ],
          ),
        ).blockUser('19'),
        throwsA(
          isA<CommunityFailure>().having(
            (CommunityFailure f) => f.kind,
            'kind',
            CommunityFailureKind.unauthenticated,
          ),
        ),
      );
    });
  });

  // 2차 가이드 §2 — 글 하나를 내 화면에서만 감춘다. 차단·신고와 다른 축이다.
  group('hidePost / unhidePost', () {
    test('숨김 뮤테이션에 postId를 넘긴다', () async {
      final _FakeLink link = _FakeLink(
        data: <String, dynamic>{
          'hidePost': <String, dynamic>{
            'success': true,
            'userErrors': <dynamic>[],
          },
        },
      );

      await _repo(link).hidePost('42');

      expect(link.sentVariables?['postId'], '42');
    });

    test('해제 뮤테이션에 postId를 넘긴다', () async {
      final _FakeLink link = _FakeLink(
        data: <String, dynamic>{
          'unhidePost': <String, dynamic>{
            'success': true,
            'userErrors': <dynamic>[],
          },
        },
      );

      await _repo(link).unhidePost('42');

      expect(link.sentVariables?['postId'], '42');
    });

    // HTTP는 실패해도 200이다 — userErrors로만 판정한다(가이드 §7).
    test('userErrors가 오면 실패로 올린다', () async {
      await expectLater(
        _repo(
          _FakeLink(
            data: <String, dynamic>{
              'hidePost': <String, dynamic>{
                'success': false,
                'userErrors': <dynamic>[
                  <String, dynamic>{
                    'code': 'POST_NOT_FOUND',
                    'message': '없는 글입니다.',
                    'field': null,
                  },
                ],
              },
            },
          ),
        ).hidePost('42'),
        throwsA(
          isA<CommunityFailure>().having(
            (CommunityFailure f) => f.code,
            'code',
            'POST_NOT_FOUND',
          ),
        ),
      );
    });

    // GraphQL은 실패해도 HTTP 200이다 — errors 배열이 차 있으면 실패로 올려야 한다.
    test('errors 배열이 차 있으면 실패가 된다', () async {
      await expectLater(
        _repo(
          _FakeLink(
            data: null,
            errors: <GraphQLError>[
              const GraphQLError(
                message: '인증이 필요합니다.',
                path: <dynamic>['hidePost'],
                extensions: <String, dynamic>{'code': 'UNAUTHENTICATED'},
              ),
            ],
          ),
        ).hidePost('42'),
        throwsA(
          isA<CommunityFailure>().having(
            (CommunityFailure f) => f.kind,
            'kind',
            CommunityFailureKind.unauthenticated,
          ),
        ),
      );
    });
  });

  group('reportContent', () {
    test('사유와 상세를 서버 enum으로 옮겨 넘긴다', () async {
      final _FakeLink link = _FakeLink(
        data: <String, dynamic>{
          'reportContent': <String, dynamic>{
            'success': true,
            'userErrors': <dynamic>[],
          },
        },
      );

      await _repo(link).reportContent(
        targetType: ReportTargetType.post,
        targetId: 'p1',
        reason: ReportReason.inappropriateContent,
        detail: '  광고성 글이에요  ',
      );

      expect(link.sentVariables?['targetType'], 'POST');
      expect(link.sentVariables?['reason'], 'INAPPROPRIATE_CONTENT');
      expect(link.sentVariables?['detail'], '광고성 글이에요');
    });

    // 공백뿐인 상세는 없는 것과 같다 — 서버도 REPORT_DETAIL_REQUIRED로 본다.
    test('공백뿐인 상세는 아예 보내지 않는다', () async {
      final _FakeLink link = _FakeLink(
        data: <String, dynamic>{
          'reportContent': <String, dynamic>{
            'success': true,
            'userErrors': <dynamic>[],
          },
        },
      );

      await _repo(link).reportContent(
        targetType: ReportTargetType.post,
        targetId: 'p1',
        reason: ReportReason.spam,
        detail: '   ',
      );

      expect(link.sentVariables?.containsKey('detail'), isFalse);
    });

    test('재신고는 ALREADY_REPORTED 코드를 담은 실패가 된다', () async {
      expect(
        () =>
            _repo(
              _FakeLink(
                data: <String, dynamic>{
                  'reportContent': <String, dynamic>{
                    'success': false,
                    'userErrors': <dynamic>[
                      <String, dynamic>{
                        'code': 'ALREADY_REPORTED',
                        'message': '이미 신고했습니다.',
                        'field': null,
                      },
                    ],
                  },
                },
              ),
            ).reportContent(
              targetType: ReportTargetType.post,
              targetId: 'p1',
              reason: ReportReason.spam,
            ),
        throwsA(
          isA<CommunityFailure>().having(
            (CommunityFailure f) => f.code,
            'code',
            'ALREADY_REPORTED',
          ),
        ),
      );
    });
  });

  group('deletePost', () {
    test('글 id를 서버에 넘긴다', () async {
      final _FakeLink link = _FakeLink(
        data: <String, dynamic>{
          'deletePost': <String, dynamic>{
            'success': true,
            'userErrors': <dynamic>[],
          },
        },
      );

      await _repo(link).deletePost('p1');

      expect(link.sentVariables?['postId'], 'p1');
    });

    test('남의 글 삭제는 코드를 담은 실패가 된다', () async {
      expect(
        () => _repo(
          _FakeLink(
            data: <String, dynamic>{
              'deletePost': <String, dynamic>{
                'success': false,
                'userErrors': <dynamic>[
                  <String, dynamic>{
                    'code': 'NOT_POST_OWNER',
                    'message': '본인 글만 삭제할 수 있습니다.',
                    'field': null,
                  },
                ],
              },
            },
          ),
        ).deletePost('p1'),
        throwsA(
          isA<CommunityFailure>().having(
            (CommunityFailure f) => f.code,
            'code',
            'NOT_POST_OWNER',
          ),
        ),
      );
    });
  });

  group('likedSpots — 컴포저 장소 선택의 두 번째 출처 (커서 페이징)', () {
    // 주변 장소와 달리 커서 페이징이다 — CursorPage로 매핑된다.
    test('LikedSpotConnection을 도메인 CursorPage로 매핑한다', () async {
      final _FakeLink link = _FakeLink(
        data: <String, dynamic>{
          'likedSpots': <String, dynamic>{
            'edges': <dynamic>[
              <String, dynamic>{
                'cursor': 'MjAyNi0wOC0wNA',
                'node': <String, dynamic>{
                  'id': '5092',
                  'title': '국회박물관',
                  'thumbnailImageUrl': 'https://img/liked.jpg',
                  'address': '서울특별시 영등포구 의사당대로 1',
                },
              },
            ],
            'pageInfo': <String, dynamic>{
              'hasNextPage': true,
              'endCursor': 'MjAyNi0wOC0wNA',
            },
          },
        },
      );

      final CursorPage<NearbySpot> page = await _repo(link).fetchLikedSpots(
        category: NearbySpotCategory.culturalFacility,
        first: 50,
      );

      expect(page.items, hasLength(1));
      expect(page.items.first.id, '5092');
      expect(page.items.first.title, '국회박물관');
      expect(page.items.first.address, '서울특별시 영등포구 의사당대로 1');
      // **거리가 없다** — 이 쿼리는 좌표를 받지 않는다. 시트가 그 자리에 주소를 그린다.
      expect(page.items.first.distanceMeters, isNull);
      expect(page.hasNextPage, isTrue);
      expect(page.endCursor, 'MjAyNi0wOC0wNA');
      // 카테고리는 서버로 넘어간다 — 주변 장소와 같은 필터다.
      expect(link.sentVariables?['categories'], <String>['CULTURAL_FACILITY']);
    });

    // 좋아요한 장소가 없는 계정이 정상 상태다 — 오류가 아니라 빈 페이지다.
    test('빈 목록은 오류가 아니다', () async {
      final CursorPage<NearbySpot> page = await _repo(
        _FakeLink(
          data: <String, dynamic>{
            'likedSpots': <String, dynamic>{
              'edges': <dynamic>[],
              'pageInfo': <String, dynamic>{
                'hasNextPage': false,
                'endCursor': null,
              },
            },
          },
        ),
      ).fetchLikedSpots();

      expect(page.items, isEmpty);
      expect(page.hasNextPage, isFalse);
    });

    // GraphQL은 실패해도 HTTP 200이다 — errors[]가 실려 오면 실패로 올려야 한다.
    test('errors[]가 실려 오면 실패로 올린다', () async {
      await expectLater(
        _repo(
          _FakeLink(
            errors: <GraphQLError>[
              const GraphQLError(
                message: '인증이 필요합니다.',
                path: <String>['likedSpots'],
                extensions: <String, dynamic>{'code': 'UNAUTHENTICATED'},
              ),
            ],
          ),
        ).fetchLikedSpots(),
        throwsA(isA<CommunityFailure>()),
      );
    });
  });

  group('spots — 컴포저 장소 선택 (오프셋 페이징)', () {
    test('SpotPage를 도메인 OffsetPage로 매핑한다', () async {
      final _FakeLink link = _FakeLink(
        data: <String, dynamic>{
          'spots': <String, dynamic>{
            'items': <dynamic>[
              <String, dynamic>{
                'id': '11915',
                'title': '내 친구 서울 서울갤러리',
                'address': '서울특별시 종로구',
                'thumbnailImageUrl': 'https://img/spot.jpg',
                'distanceMeters': 16.0,
              },
            ],
            'page': 0,
            'hasNext': true,
            'totalCount': 3386,
          },
        },
      );

      final OffsetPage<NearbySpot> page = await _repo(link).fetchNearbySpots(
        latitude: 37.5665,
        longitude: 126.978,
        radiusMeters: 5000,
        page: 0,
        size: 30,
      );

      expect(page.items, hasLength(1));
      expect(page.items.first.id, '11915');
      expect(page.items.first.title, '내 친구 서울 서울갤러리');
      expect(page.items.first.distanceMeters, 16.0);
      expect(page.items.first.address, '서울특별시 종로구');
      expect(page.hasNext, isTrue);
      expect(page.totalCount, 3386);
      // 좌표·반경·페이지가 그대로 서버로 넘어간다.
      expect(link.sentVariables?['latitude'], 37.5665);
      expect(link.sentVariables?['radiusMeters'], 5000);
      expect(link.sentVariables?['page'], 0);
    });

    // 서버가 빈 문자열을 주면 화면이 자리채움으로 떨어져야 한다.
    test('빈 썸네일 URL은 null로 접는다', () async {
      final OffsetPage<NearbySpot> page = await _repo(
        _FakeLink(
          data: <String, dynamic>{
            'spots': <String, dynamic>{
              'items': <dynamic>[
                <String, dynamic>{
                  'id': '1',
                  'title': '이름',
                  'address': null,
                  'thumbnailImageUrl': '',
                  'distanceMeters': 5.0,
                },
              ],
              'page': 0,
              'hasNext': false,
              'totalCount': 1,
            },
          },
        ),
      ).fetchNearbySpots(latitude: 37.5, longitude: 127.0);

      expect(page.items.first.thumbnailImageUrl, isNull);
    });

    // GraphQL은 실패해도 HTTP 200이다 — errors 배열이 차 있으면 실패로 올려야 한다.
    test('errors 배열이 차 있으면 실패가 된다', () async {
      expect(
        () => _repo(
          _FakeLink(
            errors: <GraphQLError>[
              const GraphQLError(
                message: 'UNAUTHENTICATED',
                path: <dynamic>['spots'],
              ),
            ],
          ),
        ).fetchNearbySpots(latitude: 37.5, longitude: 127.0),
        throwsA(
          isA<CommunityFailure>().having(
            (CommunityFailure f) => f.kind,
            'kind',
            CommunityFailureKind.unauthenticated,
          ),
        ),
      );
    });

    // 이름 필터와 달리 카테고리는 **서버가 거른다** — 값이 실제로 전송돼야 한다.
    test('카테고리가 코드 배열로 전송된다', () async {
      final _FakeLink link = _FakeLink(data: _emptySpotPage);

      await _repo(link).fetchNearbySpots(
        latitude: 37.5,
        longitude: 127.0,
        category: NearbySpotCategory.restaurant,
      );

      expect(link.sentVariables?['categories'], <String>['RESTAURANT']);
    });

    // null은 "전체"다 — 서버가 nullable로 받으므로 값을 지어내지 않는다.
    test('카테고리를 주지 않으면 전체다', () async {
      final _FakeLink link = _FakeLink(data: _emptySpotPage);

      await _repo(link).fetchNearbySpots(latitude: 37.5, longitude: 127.0);

      expect(link.sentVariables?['category'], isNull);
    });
  });

  group('availableSpotCategories — 장소 선택 시트의 카테고리 줄', () {
    // SPEC-0020: 서버 `SpotCategory`가 enum에서 객체로 바뀌었다. 커뮤니티는 그
    // 전환의 대상이 아니라(spec §범위 밖) 도메인 타입은 그대로 두고 `code`로 매핑한다.
    test('서버 카테고리 객체의 code를 커뮤니티 도메인 enum으로 매핑한다', () async {
      final List<NearbySpotCategory> categories = await _repo(
        _FakeLink(
          data: <String, dynamic>{
            'availableSpotCategories': <dynamic>[
              <String, dynamic>{
                'code': 'TOURIST_SPOT',
                'label': '관광지',
                'iconUrl': null,
              },
              <String, dynamic>{
                'code': 'RESTAURANT',
                'label': '음식점',
                'iconUrl': null,
              },
              <String, dynamic>{
                'code': 'TRAVEL_COURSE',
                'label': '여행코스',
                'iconUrl': null,
              },
            ],
          },
        ),
      ).fetchNearbySpotCategories();

      expect(categories, <NearbySpotCategory>[
        NearbySpotCategory.touristSpot,
        NearbySpotCategory.restaurant,
        NearbySpotCategory.travelCourse,
      ]);
    });

    // 구성이 없으면 빈 목록이 오고 **그것이 정상이다** — 오류로 만들지 않는다.
    test('빈 목록은 오류가 아니다', () async {
      final List<NearbySpotCategory> categories = await _repo(
        _FakeLink(
          data: <String, dynamic>{'availableSpotCategories': <dynamic>[]},
        ),
      ).fetchNearbySpotCategories();

      expect(categories, isEmpty);
    });

    test('errors 배열이 차 있으면 실패가 된다', () async {
      expect(
        () => _repo(
          _FakeLink(
            errors: <GraphQLError>[
              const GraphQLError(
                message: 'UNAUTHENTICATED',
                path: <dynamic>['availableSpotCategories'],
              ),
            ],
          ),
        ).fetchNearbySpotCategories(),
        throwsA(
          isA<CommunityFailure>().having(
            (CommunityFailure f) => f.kind,
            'kind',
            CommunityFailureKind.unauthenticated,
          ),
        ),
      );
    });
  });
}

/// 인자 전송만 볼 때 쓰는 빈 `SpotPage` 응답.
const Map<String, dynamic> _emptySpotPage = <String, dynamic>{
  'spots': <String, dynamic>{
    'items': <dynamic>[],
    'page': 0,
    'hasNext': false,
    'totalCount': 0,
  },
};
