// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'graphql_socket_client.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
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

@ProviderFor(graphqlSocketClient)
const graphqlSocketClientProvider = GraphqlSocketClientProvider._();

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

final class GraphqlSocketClientProvider
    extends $FunctionalProvider<GraphQLClient, GraphQLClient, GraphQLClient>
    with $Provider<GraphQLClient> {
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
  const GraphqlSocketClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'graphqlSocketClientProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$graphqlSocketClientHash();

  @$internal
  @override
  $ProviderElement<GraphQLClient> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GraphQLClient create(Ref ref) {
    return graphqlSocketClient(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GraphQLClient value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GraphQLClient>(value),
    );
  }
}

String _$graphqlSocketClientHash() =>
    r'23e61ace07cf56cdd5ac8d1653613e2f9d849708';
