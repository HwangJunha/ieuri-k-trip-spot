import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:ieuri_k_trip_spot/common/network/graphql_client.dart';
import 'package:ieuri_k_trip_spot/common/storage/secure_storage.dart';

import '../../domain/auth/auth_test_doubles.dart';

/// 갱신 링크의 재시도 규율을 검증한다(SPEC-0005 §2.3~§2.4). 서버를 띄우지 않고
/// 인증 실패 응답을 직접 만들어, 호출 반복을 막는 세 장치가 각각 독립적으로 동작하는지
/// 본다.

/// 맨 아래 전송 계층 스텁. 각 요청마다 [responses]에서 하나씩 꺼내 돌려주고, 요청이
/// 실릴 때의 Authorization 헤더를 기록한다 — 재시도가 **새** 토큰으로 나갔는지
/// 확인하기 위해서다(AC-21).
class _StubTransport extends Link {
  _StubTransport(this.responses);

  final List<Response Function()> responses;
  final List<String?> sentTokens = <String?>[];
  int calls = 0;

  @override
  Stream<Response> request(Request request, [NextLink? forward]) async* {
    final HttpLinkHeaders? headers = request.context.entry<HttpLinkHeaders>();
    sentTokens.add(headers?.headers['Authorization']);
    final int index = calls < responses.length ? calls : responses.length - 1;
    calls++;
    yield responses[index]();
  }
}

Response _authError() => Response(
  errors: const <GraphQLError>[
    GraphQLError(
      message:
          'org.around.ieuri.common.security.UnauthorizedException: expired',
    ),
  ],
  response: const <String, dynamic>{},
  context: const Context(),
);

Response _ok() => Response(
  data: const <String, dynamic>{'ok': true},
  response: const <String, dynamic>{},
  context: const Context(),
);

/// R15 이후 서버가 내보내는 `reactToSpot` 인증 실패 응답. 인증 실패는 연산과 무관하게
/// **항상 최상위 `errors[]`**로 오며, payload의 `userErrors`는 비어 있다
/// (SPEC-0005 R15, AC-39). 이전에는 이게 `userErrors[]`에 code `UNAUTHENTICATED`로
/// 담겨 링크 계층이 보지 못했고, 그래서 좋아요/싫어요에서 갱신이 죽어 있었다.
Response _reactAuthError() => Response(
  errors: const <GraphQLError>[
    GraphQLError(
      message:
          'org.around.ieuri.common.security.UnauthorizedException: expired',
    ),
  ],
  response: const <String, dynamic>{},
  context: const Context(),
);

Response _reactOk() => Response(
  data: const <String, dynamic>{
    'reactToSpot': <String, dynamic>{
      'success': true,
      'userErrors': <dynamic>[],
    },
  },
  response: const <String, dynamic>{},
  context: const Context(),
);

/// 실제 [graphqlClientProvider]가 만드는 링크 체인을 그대로 쓰되, 맨 아래 HttpLink만
/// [transport] 스텁으로 바꾼 클라이언트를 만든다. AuthLink는 실제 코드라 매 요청마다
/// 저장소에서 토큰을 다시 읽는다.
GraphQLClient _client({
  required _StubTransport transport,
  required TokenRefreshBridge bridge,
  required SecureStorage storage,
}) {
  final AuthLink authLink = AuthLink(
    getToken: () async {
      final String? token = await storage.readAccessToken();
      return token == null ? null : 'Bearer $token';
    },
  );
  return GraphQLClient(
    link: buildRefreshLink(bridge).concat(authLink).concat(transport),
    cache: GraphQLCache(),
    defaultPolicies: DefaultPolicies(
      mutate: Policies(fetch: FetchPolicy.noCache),
      query: Policies(fetch: FetchPolicy.noCache),
    ),
  );
}

Future<QueryResult<Object?>> _query(GraphQLClient client) =>
    client.query(QueryOptions<Object?>(document: gql('{ ok }')));

/// `reactToSpot` 뮤테이션을 링크 체인에 태운다. AC-40은 이 연산으로 확인해야 한다 —
/// 이전 결함이 바로 이 연산에서만 나타났기 때문이다.
Future<QueryResult<Object?>> _reactMutation(GraphQLClient client) =>
    client.mutate(
      MutationOptions<Object?>(
        document: gql(
          'mutation { reactToSpot(input: {catalogId: "s1", reaction: LIKE}) '
          '{ success userErrors { code } } }',
        ),
      ),
    );

void main() {
  late SecureStorage storage;
  late TokenRefreshBridge bridge;

  setUp(() async {
    storage = SecureStorage(MemoryStore());
    await storage.writeTokens(accessToken: 'old', refreshToken: 'r');
    bridge = TokenRefreshBridge();
  });

  test('인증 실패면 갱신 후 요청을 재시도한다 (R4·R5)', () async {
    final _StubTransport transport = _StubTransport(<Response Function()>[
      _authError,
      _ok,
    ]);
    bridge.refresher = () async {
      await storage.writeTokens(accessToken: 'new', refreshToken: 'r2');
      return 'new';
    };

    final QueryResult<Object?> result = await _query(
      _client(transport: transport, bridge: bridge, storage: storage),
    );

    expect(result.hasException, isFalse);
    expect(transport.calls, 2);
  });

  test('재시도는 갱신 완료 후의 새 accessToken으로 나간다 (AC-21)', () async {
    final _StubTransport transport = _StubTransport(<Response Function()>[
      _authError,
      _ok,
    ]);
    bridge.refresher = () async {
      await storage.writeTokens(accessToken: 'new', refreshToken: 'r2');
      return 'new';
    };

    await _query(
      _client(transport: transport, bridge: bridge, storage: storage),
    );

    // 갱신 시작 시점에 읽어둔 토큰이 아니라 갱신 완료 후의 토큰이어야 한다.
    expect(transport.sentTokens, <String?>['Bearer old', 'Bearer new']);
  });

  test('재시도한 요청이 다시 인증 실패로 끝나도 두 번째 갱신을 하지 않는다 (R7, AC-19)', () async {
    final _StubTransport transport = _StubTransport(<Response Function()>[
      _authError,
    ]);
    int refreshCalls = 0;
    bridge.refresher = () async {
      refreshCalls++;
      return 'new';
    };

    final QueryResult<Object?> result = await _query(
      _client(transport: transport, bridge: bridge, storage: storage),
    );

    expect(refreshCalls, 1, reason: '요청당 갱신은 1회');
    expect(transport.calls, 2, reason: '원 요청 + 재시도 1회');
    expect(result.hasException, isTrue, reason: '두 번째 실패는 그대로 전달된다');
  });

  test('동시 인증 실패에도 갱신은 한 번만 실행된다 (R8, AC-23)', () async {
    final _StubTransport transport = _StubTransport(<Response Function()>[
      _authError,
      _authError,
      _authError,
      _ok,
    ]);
    int refreshCalls = 0;
    final Completer<void> gate = Completer<void>();
    bridge.refresher = () async {
      refreshCalls++;
      // 세 요청이 모두 갱신 지점에 도달할 때까지 붙잡아 둔다.
      await gate.future;
      await storage.writeTokens(accessToken: 'new', refreshToken: 'r2');
      return 'new';
    };

    final GraphQLClient client = _client(
      transport: transport,
      bridge: bridge,
      storage: storage,
    );
    final Future<List<QueryResult<Object?>>> all = Future.wait(
      <Future<QueryResult<Object?>>>[
        _query(client),
        _query(client),
        _query(client),
      ],
    );
    await Future<void>.delayed(Duration.zero);
    gate.complete();
    final List<QueryResult<Object?>> results = await all;

    // 갱신이 중복 실행되면 서버가 방금 폐기한 jti를 다시 제시해 회원 전체 세션이
    // 폐기된다(AC-22). 단일 실행이 그걸 막는다.
    expect(refreshCalls, 1);
    // 그리고 **셋 다** 복구되어야 한다. 재시도 여부를 공유 Set<Request>로 추적하면
    // Request의 값 동등성 때문에 동일 요청들이 서로의 키와 충돌해 하나만 재시도되고
    // 나머지는 인증 오류를 그대로 받는다.
    expect(
      results.map((QueryResult<Object?> r) => r.hasException),
      everyElement(isFalse),
      reason: '동시에 나간 동일 요청이 서로의 재시도를 잡아먹으면 안 된다',
    );
  });

  test('refresher가 던져도 갱신 실패로 다루고 억제를 세운다', () async {
    final _StubTransport transport = _StubTransport(<Response Function()>[
      _authError,
    ]);
    bridge.refresher = () async => throw StateError('저장소 접근 실패');

    final QueryResult<Object?> result = await _query(
      _client(transport: transport, bridge: bridge, storage: storage),
    );

    // 예외가 그대로 새어 나가면 억제가 서지 않아 R14가 무력화된다.
    expect(result.hasException, isTrue);
    expect(bridge.suppressed, isTrue);
    expect(transport.calls, 1, reason: '재시도하지 않는다');
  });

  test('갱신 성공 후에는 다음 갱신이 다시 가능하다', () async {
    final _StubTransport transport = _StubTransport(<Response Function()>[
      _authError,
      _ok,
      _authError,
      _ok,
    ]);
    int refreshCalls = 0;
    bridge.refresher = () async {
      refreshCalls++;
      return 'new';
    };

    final GraphQLClient client = _client(
      transport: transport,
      bridge: bridge,
      storage: storage,
    );
    await _query(client);
    await _query(client);

    // 진행 중인 갱신 참조가 완료 후 비워지지 않으면 두 번째는 갱신 없이 실패한다.
    expect(refreshCalls, 2);
  });

  test('억제 중에는 인증 실패가 와도 갱신을 시도하지 않는다 (R14, AC-37)', () async {
    final _StubTransport transport = _StubTransport(<Response Function()>[
      _authError,
    ]);
    int refreshCalls = 0;
    bridge.refresher = () async {
      refreshCalls++;
      return 'new';
    };
    bridge.suppressRefresh();

    final QueryResult<Object?> result = await _query(
      _client(transport: transport, bridge: bridge, storage: storage),
    );

    expect(refreshCalls, 0);
    expect(transport.calls, 1, reason: '재시도조차 하지 않는다');
    expect(result.hasException, isTrue, reason: '오류를 그대로 전달한다');
  });

  test('억제가 해제되면 갱신이 다시 나간다 (AC-38)', () async {
    final _StubTransport transport = _StubTransport(<Response Function()>[
      _authError,
      _ok,
    ]);
    int refreshCalls = 0;
    bridge.refresher = () async {
      refreshCalls++;
      return 'new';
    };
    bridge.suppressRefresh();
    bridge.allowRefresh();

    await _query(
      _client(transport: transport, bridge: bridge, storage: storage),
    );

    expect(refreshCalls, 1);
  });

  test('갱신이 실패하면 원래 오류가 그대로 전달된다 (R10)', () async {
    final _StubTransport transport = _StubTransport(<Response Function()>[
      _authError,
    ]);
    bridge.refresher = () async => null;

    final QueryResult<Object?> result = await _query(
      _client(transport: transport, bridge: bridge, storage: storage),
    );

    expect(result.hasException, isTrue);
    expect(transport.calls, 1, reason: '갱신 실패 시 재시도하지 않는다');
  });

  test('refresher가 등록되지 않았으면 오류를 그대로 통과시킨다', () async {
    final _StubTransport transport = _StubTransport(<Response Function()>[
      _authError,
    ]);

    final QueryResult<Object?> result = await _query(
      _client(transport: transport, bridge: bridge, storage: storage),
    );

    expect(result.hasException, isTrue);
    expect(transport.calls, 1);
  });

  test('인증과 무관한 오류에는 갱신이 나가지 않는다', () async {
    final _StubTransport transport = _StubTransport(<Response Function()>[
      () => Response(
        errors: const <GraphQLError>[GraphQLError(message: 'Cannot query X')],
        response: const <String, dynamic>{},
        context: const Context(),
      ),
    ]);
    int refreshCalls = 0;
    bridge.refresher = () async {
      refreshCalls++;
      return 'new';
    };

    await _query(
      _client(transport: transport, bridge: bridge, storage: storage),
    );

    expect(refreshCalls, 0);
  });

  // --- R15 이후의 reactToSpot 경로 (AC-40) ----------------------------------
  //
  // 서버가 인증 실패를 payload userErrors[]에서 최상위 errors[]로 옮겼으므로
  // (ieuri-server#32), 클라이언트는 `userErrors` 분기를 추가하지 않고 **기존 판별
  // 규칙(E1~E5)만으로** 이 경로가 동작해야 한다. 그게 성립하는지가 AC-40이다.
  //
  // 서버가 실제로 그 형태를 내보내는지는 AC-39(서버 소관)다. 여기서는 "그 형태가
  // 오면 동작한다"까지만 책임진다 — 두 기준을 뭉뚱그리면 어느 쪽이 깨졌는지
  // 구분되지 않는다.
  group('reactToSpot 인증 실패 (R15 이후, AC-40)', () {
    test('기존 판별 규칙만으로 갱신이 트리거되고 재시도가 성공한다', () async {
      final _StubTransport transport = _StubTransport(<Response Function()>[
        _reactAuthError,
        _reactOk,
      ]);
      int refreshCalls = 0;
      bridge.refresher = () async {
        refreshCalls++;
        await storage.writeTokens(accessToken: 'new', refreshToken: 'r2');
        return 'new';
      };

      final QueryResult<Object?> result = await _reactMutation(
        _client(transport: transport, bridge: bridge, storage: storage),
      );

      expect(refreshCalls, 1, reason: '갱신이 트리거된다');
      expect(transport.calls, 2, reason: '원 요청 + 재시도');
      // 사용자에게 오류가 노출되지 않는다(AC-43) — 재시도가 성공했으므로.
      expect(result.hasException, isFalse);
      // 재시도는 갱신 완료 후의 토큰으로 나간다(AC-21).
      expect(transport.sentTokens, <String?>['Bearer old', 'Bearer new']);
    });

    test('갱신이 실패하면 오류가 그대로 호출자에게 전달된다 (AC-44 전제)', () async {
      final _StubTransport transport = _StubTransport(<Response Function()>[
        _reactAuthError,
      ]);
      bridge.refresher = () async => null;

      final QueryResult<Object?> result = await _reactMutation(
        _client(transport: transport, bridge: bridge, storage: storage),
      );

      expect(result.hasException, isTrue);
      expect(transport.calls, 1, reason: '갱신 실패 시 재시도하지 않는다');
    });

    test('재시도가 다시 인증 실패로 끝나도 추가 갱신·재전송이 없다 (AC-45)', () async {
      // 두 응답 모두 인증 실패 — 재시도한 요청이 또 실패하는 상황.
      final _StubTransport transport = _StubTransport(<Response Function()>[
        _reactAuthError,
      ]);
      int refreshCalls = 0;
      bridge.refresher = () async {
        refreshCalls++;
        return 'new';
      };

      final QueryResult<Object?> result = await _reactMutation(
        _client(transport: transport, bridge: bridge, storage: storage),
      );

      expect(refreshCalls, 1, reason: '요청당 갱신은 1회(R7)');
      expect(transport.calls, 2, reason: '원 요청 + 재시도 1회, 그 이상 없음');
      expect(result.hasException, isTrue);
    });
  });
}
