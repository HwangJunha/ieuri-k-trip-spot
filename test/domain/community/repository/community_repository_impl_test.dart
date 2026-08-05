import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:ieuri_k_trip_spot/common/pagination/page.dart';
import 'package:ieuri_k_trip_spot/domain/community/model/community_failure.dart';
import 'package:ieuri_k_trip_spot/domain/community/model/discovery_tile.dart';
import 'package:ieuri_k_trip_spot/domain/community/model/post.dart';
import 'package:ieuri_k_trip_spot/domain/community/model/post_topic.dart';
import 'package:ieuri_k_trip_spot/domain/community/model/report_reason.dart';
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

/// 지금 서버를 그대로 흉내 내는 링크: `comments`를 요청하면 커넥션 어댑터 예외로
/// 글까지 통째로 null이 되고(`CommentConnection!`이 non-null이라 부모가 날아간다),
/// 요청하지 않으면 정상 응답이 온다.
class _CommentsBrokenLink extends Link {
  _CommentsBrokenLink(this.node);

  final Map<String, dynamic> node;

  int calls = 0;

  @override
  Stream<Response> request(Request request, [NextLink? forward]) async* {
    calls++;
    final bool withComments = request.variables['withComments'] == true;
    yield Response(
      data: <String, dynamic>{'post': withComments ? null : node},
      errors: withComments
          ? <GraphQLError>[
              const GraphQLError(
                message: 'No ConnectionAdapter for: CommentConnectionResponse',
                path: <dynamic>['post', 'comments'],
              ),
            ]
          : null,
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
  String topic = 'REVIEW',
  bool hidden = false,
  int commentCount = 4,
  List<String> photoKeys = const <String>[],
}) => <String, dynamic>{
  'id': id,
  'body': '경복궁 야간개장 다녀왔어요',
  'topic': topic,
  'createdAt': '2026-08-05T09:22:00.966439Z',
  'photoKeys': photoKeys,
  'likeCount': 12,
  'commentCount': commentCount,
  'likedByViewer': false,
  'ownedByViewer': false,
  'hidden': hidden,
  'target': <String, dynamic>{
    'type': 'SPOT',
    'id': '11094',
    'title': '경복궁',
    'thumbnailImageUrl': 'https://img/spot.jpg',
  },
  'author': <String, dynamic>{
    'id': '20',
    'nickname': '여행자',
    'profileImageUrl': null,
  },
};

void main() {
  group('nearbyPosts', () {
    test('PostConnection을 도메인 CursorPage로 매핑한다', () async {
      final _FakeLink link = _FakeLink(
        data: <String, dynamic>{
          'nearbyPosts': <String, dynamic>{
            'edges': <dynamic>[
              <String, dynamic>{
                'cursor': 'c1',
                'node': _postNode(id: 'p1', topic: 'REVIEW'),
              },
              <String, dynamic>{
                'cursor': 'c2',
                'node': _postNode(id: 'p2', topic: 'TIP'),
              },
            ],
            'pageInfo': <String, dynamic>{
              'hasNextPage': true,
              'endCursor': 'c2',
            },
          },
        },
      );

      final CursorPage<Post> page = await _repo(link).fetchNearbyPosts(
        latitude: 37.5665,
        longitude: 126.978,
        topic: PostTopic.review,
        first: 20,
      );

      expect(page.items, hasLength(2));
      expect(page.items.first.id, 'p1');
      expect(page.items.first.topic, PostTopic.review);
      expect(page.items.first.target.title, '경복궁');
      expect(page.items.first.author.nickname, '여행자');
      expect(page.items[1].topic, PostTopic.tip);
      expect(page.hasNextPage, isTrue);
      expect(page.endCursor, 'c2');
      // 필터는 서버로 넘어간다 — 클라이언트가 받은 목록을 거르지 않는다.
      expect(link.sentVariables?['topic'], 'REVIEW');
    });

    test('createdAt을 UTC 시각으로 파싱한다', () async {
      final CursorPage<Post> page = await _repo(
        _FakeLink(
          data: <String, dynamic>{
            'nearbyPosts': <String, dynamic>{
              'edges': <dynamic>[
                <String, dynamic>{'cursor': 'c1', 'node': _postNode()},
              ],
              'pageInfo': <String, dynamic>{
                'hasNextPage': false,
                'endCursor': null,
              },
            },
          },
        ),
      ).fetchNearbyPosts(latitude: 37.5, longitude: 127);

      expect(page.items.first.createdAt.isUtc, isTrue);
      expect(page.items.first.createdAt.year, 2026);
    });

    // GraphQL은 실패해도 HTTP 200이다. 최상위 errors[]가 이 필드를 가리키면 전체
    // 실패로 다뤄야 한다 — 지금 서버의 커넥션 어댑터 예외가 정확히 이 형태다.
    test('최상위 errors[]는 실패로 surface된다', () async {
      final _FakeLink link = _FakeLink(
        data: null,
        errors: <GraphQLError>[
          const GraphQLError(
            message:
                'java.lang.IllegalStateException: No ConnectionAdapter for: PostConnectionResponse',
            path: <dynamic>['nearbyPosts'],
          ),
        ],
      );

      expect(
        () => _repo(link).fetchNearbyPosts(latitude: 37.5, longitude: 127),
        throwsA(isA<CommunityFailure>()),
      );
    });

    test('UNAUTHENTICATED는 전용 실패 종류로 번역된다', () async {
      final _FakeLink link = _FakeLink(
        data: null,
        errors: <GraphQLError>[
          const GraphQLError(
            message: '인증이 필요합니다.',
            path: <dynamic>['nearbyPosts'],
            extensions: <String, dynamic>{'code': 'UNAUTHENTICATED'},
          ),
        ],
      );

      expect(
        () => _repo(link).fetchNearbyPosts(latitude: 37.5, longitude: 127),
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
    test('댓글을 함께 매핑한다', () async {
      final Post? post = await _repo(
        _FakeLink(
          data: <String, dynamic>{
            'post': <String, dynamic>{
              ..._postNode(commentCount: 4),
              'comments': <String, dynamic>{
                'edges': <dynamic>[
                  <String, dynamic>{
                    'cursor': 'cc1',
                    'node': <String, dynamic>{
                      'id': 'c1',
                      'body': '저도 가봤어요',
                      'createdAt': '2026-08-05T10:00:00Z',
                      'ownedByViewer': false,
                      'hidden': false,
                      'author': <String, dynamic>{
                        'id': '12',
                        'nickname': '민지',
                        'profileImageUrl': null,
                      },
                    },
                  },
                ],
                'pageInfo': <String, dynamic>{
                  'hasNextPage': false,
                  'endCursor': null,
                },
              },
            },
          },
        ),
      ).fetchPost('p1');

      expect(post, isNotNull);
      expect(post!.comments, hasLength(1));
      expect(post.comments!.first.author.nickname, '민지');
      // 가이드 §6 — 차단된 사람의 댓글은 목록에서 빠지지만 수에는 남는다.
      // 불일치를 오류로 만들지 않는다.
      expect(post.commentCount, 4);
    });

    // 가이드 §6 — 차단·숨김이면 오류가 아니라 null이다. errors[]를 기대하면 안 된다.
    test('차단·숨김이면 오류가 아니라 null을 돌려준다', () async {
      final Post? post = await _repo(
        _FakeLink(data: <String, dynamic>{'post': null}),
      ).fetchPost('p1');

      expect(post, isNull);
    });

    // 지금 서버의 실제 동작: `comments` 해소가 실패하면 non-null 제약 때문에 글까지
    // null이 된다. 그것을 "볼 수 없는 글"로 안내하면 멀쩡한 글이 사라진 것처럼
    // 보이므로, 댓글 없이 다시 조회해 본문만이라도 살린다.
    test('댓글 해소 실패로 글이 null이면 댓글 없이 다시 조회한다', () async {
      final _CommentsBrokenLink link = _CommentsBrokenLink(_postNode());

      final Post? post = await _repo(link).fetchPost('p1');

      expect(post, isNotNull);
      expect(post!.body, isNotEmpty);
      // 댓글은 못 받았다 — 빈 목록("댓글 없음")과 구분되도록 null이다.
      expect(post.comments, isNull);
      expect(link.calls, 2);
    });

    test('hidden: true인 글을 그대로 전달한다', () async {
      final Post? post = await _repo(
        _FakeLink(
          data: <String, dynamic>{
            'post': <String, dynamic>{
              ..._postNode(hidden: true),
              'comments': <String, dynamic>{
                'edges': <dynamic>[],
                'pageInfo': <String, dynamic>{
                  'hasNextPage': false,
                  'endCursor': null,
                },
              },
            },
          },
        ),
      ).fetchPost('p1');

      expect(post!.hidden, isTrue);
    });
  });

  group('discoveryTiles', () {
    test('타일을 매핑하고 title은 서버 문자열 그대로 둔다', () async {
      final List<DiscoveryTile> tiles = await _repo(
        _FakeLink(
          data: <String, dynamic>{
            'discoveryTiles': <dynamic>[
              <String, dynamic>{
                'id': '5',
                'title': '[시드] Travel Tips',
                'imageUrl': null,
                'filterTopic': 'TIP',
                'filterTargetType': 'SPOT',
              },
            ],
          },
        ),
      ).fetchDiscoveryTiles();

      expect(tiles.single.title, '[시드] Travel Tips');
      expect(tiles.single.filterTopic, PostTopic.tip);
    });

    // 가이드 §15 — 빈 목록이 정상이다. 오류로 만들지 않는다.
    test('빈 목록은 정상이다', () async {
      final List<DiscoveryTile> tiles = await _repo(
        _FakeLink(data: <String, dynamic>{'discoveryTiles': <dynamic>[]}),
      ).fetchDiscoveryTiles();

      expect(tiles, isEmpty);
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
    // 가이드 §11 — postId만 오고 post는 항상 null이다. 응답에서 글을 조립할 수 없다.
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
        targetType: 'SPOT',
        targetId: '11094',
        topic: PostTopic.tip,
        body: '경복궁은 화요일 휴무예요.',
        photoKeys: <String>['images/20/abc'],
      );

      expect(postId, '42');
      expect(link.sentVariables?['targetType'], 'SPOT');
      expect(link.sentVariables?['topic'], 'TIP');
      expect(link.sentVariables?['photoKeys'], <String>['images/20/abc']);
    });

    test('본문 길이 위반은 코드를 담은 실패가 된다', () async {
      expect(
        () =>
            _repo(
              _FakeLink(
                data: <String, dynamic>{
                  'createPost': <String, dynamic>{
                    'success': false,
                    'userErrors': <dynamic>[
                      <String, dynamic>{
                        'code': 'POST_BODY_LENGTH_INVALID',
                        'message': '본문이 너무 깁니다.',
                        'field': 'body',
                      },
                    ],
                    'postId': null,
                  },
                },
              ),
            ).createPost(
              targetType: 'SPOT',
              targetId: '11094',
              topic: PostTopic.tip,
              body: '가' * 501,
            ),
        throwsA(
          isA<CommunityFailure>().having(
            (CommunityFailure f) => f.code,
            'code',
            'POST_BODY_LENGTH_INVALID',
          ),
        ),
      );
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

    test('자기 차단은 코드를 담은 실패가 된다', () async {
      expect(
        () => _repo(
          _FakeLink(
            data: <String, dynamic>{
              'blockUser': <String, dynamic>{
                'success': false,
                'userErrors': <dynamic>[
                  <String, dynamic>{
                    'code': 'CANNOT_BLOCK_SELF',
                    'message': '자기 자신은 차단할 수 없습니다.',
                    'field': null,
                  },
                ],
              },
            },
          ),
        ).blockUser('20'),
        throwsA(
          isA<CommunityFailure>().having(
            (CommunityFailure f) => f.code,
            'code',
            'CANNOT_BLOCK_SELF',
          ),
        ),
      );
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
}
