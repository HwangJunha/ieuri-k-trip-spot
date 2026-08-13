import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../storage/secure_storage.dart';
import 'graphql_endpoint.dart';

part 'graphql_socket_client.g.dart';

/// 재연결 시도 간격(POL-040 — 재시도는 횟수로 제한하지만, 소켓은 라이브러리가
/// 간격으로만 제어한다). 상한은 [subscriptionReconnectAttempts]에서 클라이언트가 센다.
const Duration _reconnectDelay = Duration(seconds: 5);

/// 구독 재연결 시도 상한(POL-040).
///
/// **`FORBIDDEN`에는 재시도하지 않는다** — 권한 문제는 재시도로 풀리지 않고 상한까지
/// 헛돌 뿐이다. 그 판단은 구독을 여는 쪽이 한다.
const int subscriptionReconnectAttempts = 5;

/// 구독 전용 WebSocket 클라이언트(SPEC-0017 — 이 앱 최초의 Subscription).
///
/// HTTP 클라이언트와 **분리된 이유**는 전송이 다르기 때문이다. 쿼리·뮤테이션은
/// 그대로 `HttpLink`를 타고, 구독만 이 소켓을 탄다. 두 링크를 `Link.split`으로 합치면
/// 한쪽 설정 변경이 다른 쪽에 새어 들어가고, 소켓 수명(연결 유지)과 요청 수명(단발)이
/// 서로 다른 것을 한 객체가 관리하게 된다.
///
/// **프로토콜은 `graphql-transport-ws`다**(구형 `subscriptions-transport-ws` 아님).
/// 경로는 HTTP와 **같은 `/graphql`**이고 스킴만 `ws`/`wss`다.
///
/// **인증은 `connection_init` 페이로드로 보낸다.** 브라우저 WebSocket API가 커스텀
/// 헤더를 못 붙이므로 페이로드가 유일하게 이식 가능한 수단이다. `Bearer ` 접두어가
/// **필수이며**, 없으면 서버가 토큰 없음으로 보고 연결을 거부한다.
///
/// 토큰은 [SocketClientConfig.initialPayload]에 **함수로** 넘긴다 — 연결할 때마다
/// 저장소에서 다시 읽어야 갱신된 토큰이 실린다. 값으로 넘기면 앱 시작 시점의 토큰이
/// 소켓 수명 내내 박힌다.
///
/// **만료 처리:** 서버는 accessToken이 만료돼도 기존 연결을 끊지 않는다(끊으면 타이핑
/// 표시가 주기적으로 사라진다). 만료는 **새 `subscribe`를 열 때부터** 적용되므로,
/// 토큰을 갱신했다면 새 구독을 열기 전에 [resetSocketConnection]으로 다시 연결하는
/// 편이 안전하다 — 세션에 박힌 신원은 `connection_init` 시점의 것이고 갱신 수단이 없다.
@Riverpod(keepAlive: true)
GraphQLClient graphqlSocketClient(Ref ref) {
  final SecureStorage storage = ref.watch(secureStorageProvider);

  final WebSocketLink link = WebSocketLink(
    GraphqlEndpoint.resolveWebSocket(),
    subProtocol: GraphQLProtocol.graphqlTransportWs,
    config: SocketClientConfig(
      autoReconnect: true,
      delayBetweenReconnectionAttempts: _reconnectDelay,
      // **연결 유지가 목적이라 비활성 타임아웃을 두지 않는다.** 기본 30초는 조용한
      // 대화에서 소켓을 닫아 버리고, 그러면 그동안의 새 메시지 이벤트를 놓친다.
      inactivityTimeout: null,
      initialPayload: () async {
        final String? token = await storage.readAccessToken();
        if (token == null) return const <String, dynamic>{};
        // `Bearer ` 접두어 없는 raw 토큰은 토큰 없음으로 취급되어 연결이 거부된다.
        return <String, dynamic>{'Authorization': 'Bearer $token'};
      },
    ),
  );

  ref.onDispose(link.dispose);

  return GraphQLClient(
    link: link,
    cache: GraphQLCache(),
    defaultPolicies: DefaultPolicies(
      // HTTP 클라이언트와 같은 이유로 `all`이다 — 구독 시작 시점의 권한 실패는
      // 최상위 `errors[]`로 오므로 data를 통째로 버리면 코드를 읽을 수 없다.
      subscribe: Policies(fetch: FetchPolicy.noCache, error: ErrorPolicy.all),
    ),
  );
}

/// 소켓을 끊고 다시 연결한다. **토큰을 갱신한 직후에 부른다.**
///
/// `connection_init`에 실린 신원은 연결 수명 동안 고정이고 갱신 수단이 없어서,
/// 새 토큰을 적용하려면 다시 연결하는 수밖에 없다.
Future<void> resetSocketConnection(Ref ref) async {
  ref.invalidate(graphqlSocketClientProvider);
}
