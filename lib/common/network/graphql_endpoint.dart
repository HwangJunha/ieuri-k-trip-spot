import 'dart:io' show Platform;

/// Resolves the GraphQL endpoint (spec §6.1). Injected via
/// `--dart-define=GRAPHQL_ENDPOINT=...`.
///
/// **기본값은 시뮬레이터/에뮬레이터 전용이다.** 안드로이드 에뮬레이터는 호스트
/// 루프백을 `10.0.2.2`로 보고, iOS 시뮬레이터는 맥과 루프백을 공유해 `localhost`가
/// 통한다.
///
/// **실기기에서는 둘 다 통하지 않는다** — 실기기의 `localhost`는 폰 자신이고
/// `10.0.2.2`는 아무 데도 가리키지 않는다. 개발 머신의 LAN IP를 넣어야 한다:
///
/// ```
/// GRAPHQL_ENDPOINT=http://192.168.0.10:8888/graphql
/// ```
///
/// 값은 `.env`에 두고 `--dart-define-from-file=.env`로 넘긴다(README 참고).
/// 서버가 루프백에만 바인딩돼 있으면 IP를 맞춰도 닿지 않으므로, `lsof -nP
/// -iTCP:8888 -sTCP:LISTEN`이 `*:8888`인지 함께 본다.
class GraphqlEndpoint {
  const GraphqlEndpoint._();

  static const String _override = String.fromEnvironment('GRAPHQL_ENDPOINT');

  static const String _androidHost = 'http://10.0.2.2:8888/graphql';
  static const String _defaultHost = 'http://localhost:8888/graphql';

  static String resolve() {
    if (_override.isNotEmpty) return _override;
    return Platform.isAndroid ? _androidHost : _defaultHost;
  }

  /// 구독용 WebSocket 주소(SPEC-0017).
  ///
  /// **HTTP와 같은 `/graphql` 경로이고 스킴만 바뀐다** — `/subscriptions` 같은 별도
  /// 경로가 아니다. 그래서 별도 dart-define을 두지 않고 [resolve]에서 파생한다:
  /// 엔드포인트를 실기기용으로 바꿀 때 한 곳만 고치면 둘 다 따라온다.
  static String resolveWebSocket() {
    final Uri http = Uri.parse(resolve());
    return http
        .replace(scheme: http.scheme == 'https' ? 'wss' : 'ws')
        .toString();
  }
}
