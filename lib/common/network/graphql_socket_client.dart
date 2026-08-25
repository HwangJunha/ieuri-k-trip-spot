import 'dart:async';

import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../storage/secure_storage.dart';
import 'access_gateway.dart';
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

/// 지금 살아 있는 링크. 재연결을 멈추려면 이것을 `dispose`해야 한다.
///
/// provider가 만들 때 채우고 폐기할 때 비운다. 전역 변수를 두는 것이 반갑지는
/// 않으나, `dispose`가 **상태와 무관하게 재연결을 끊는 유일한 수단**이라 링크 참조를
/// 잡아 둘 자리가 필요하다.
WebSocketLink? _liveLink;

/// 소켓을 끊고 **재연결을 완전히 멈춘다.**
///
/// ## 왜 구독을 닫는 것만으로는 부족한가
///
/// `graphql` 5.2.4의 재연결 중단 조건은 넷뿐이다(`websocket_client.dart:395`):
/// `_isReconnectionPaused`, `!autoReconnect`, 컨트롤러 닫힘, `_wasDisposed`.
/// **열려 있는 구독 개수는 조건에 없다** — 구독을 전부 `cancel()`해도 소켓은 5초마다
/// 영원히 다시 붙으려 하고, 서버에는 그 시도가 그대로 도착한다.
///
/// ## 왜 `toggleConnection`이 아니라 `dispose`인가
///
/// 처음에는 `toggleConnection` 스트림에 `disconnect`를 흘렸는데 **작동하지 않았다.**
/// 라이브러리가 그 이벤트를 상태가 `connected`일 때만 받는다(`websocket_client.dart:256`).
/// 정지가 필요한 시점은 구독이 오류로 끊긴 직후이고, 그때 상태는 이미
/// `notConnected`라 이벤트가 조용히 버려진다 — 컴파일도 되고 테스트도 통과하지만
/// 아무것도 멈추지 않는다.
///
/// `onConnectionLost` 콜백도 답이 아니다 — `Duration?`을 돌려줄 뿐이라 지연만 바꾼다.
///
/// `dispose()`는 `_wasDisposed = true`와 `_reconnectTimer?.cancel()`을 **상태와
/// 무관하게** 실행한다(`websocket_client.dart:429-437`). 그 함수의 주석도 재연결을
/// 막는 것이 목적이라고 적고 있다.
///
/// **서버에 WAF도 rate limit도 없다**(사용자, 2026-08-25). 클라이언트가 스스로
/// 멈추지 않으면 의도치 않은 DoS가 된다 — 끊기는 편이 낫다.
///
/// 다시 쓰려면 [resetSocketConnection]으로 링크를 새로 만든다.
Future<void> stopSocketReconnect() async {
  final WebSocketLink? link = _liveLink;
  if (link == null) return;
  _liveLink = null;
  await link.dispose();
}

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
      // 웹소켓 핸드셰이크도 HTTP 업그레이드라 Cloudflare Access를 지난다 —
      // 헤더가 없으면 개발 서버에서 연결이 거부된다. 운영 빌드에서는 빈 맵이다.
      headers: AccessGateway.headers.isEmpty ? null : AccessGateway.headers,
      // 상한이 없다 — 멈추는 것은 [stopSocketReconnect]가 맡는다.
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

  // 정지 스위치가 이 참조로 `dispose`를 부른다([stopSocketReconnect]).
  _liveLink = link;
  ref.onDispose(() {
    // 이미 정지 스위치가 비웠으면 건드리지 않는다 — 그 사이 새 링크가 등록됐을
    // 수 있고, 그것까지 끊으면 방금 살린 소켓이 다시 죽는다.
    if (identical(_liveLink, link)) _liveLink = null;
    link.dispose();
  });

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
///
/// **정지 상태도 함께 풀린다.** provider를 무효화하면 링크와 소켓 클라이언트가
/// 통째로 새로 만들어지고, `_isReconnectionPaused`는 그 인스턴스의 상태라 새 것은
/// 처음부터 정지가 아니다 — [pauseSocketReconnect]로 멈춰 둔 뒤에도 이 함수로
/// 되살릴 수 있다.
Future<void> resetSocketConnection(Ref ref) async {
  ref.invalidate(graphqlSocketClientProvider);
}
