import 'package:flutter/foundation.dart' show visibleForTesting;
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../localization/locale_controller.dart';
import '../storage/secure_storage.dart';
import 'auth_error_classifier.dart';
import 'graphql_endpoint.dart';

part 'graphql_client.g.dart';

/// A hook the auth layer registers so the network layer can refresh an expired
/// access token WITHOUT importing the auth provider (spec §7/§8 — the link ↔
/// auth-state cycle is broken with this callback/token-getter pattern).
///
/// Returns the new access token on success, or `null` if refresh failed (which
/// tells the caller to sign out).
typedef TokenRefresher = Future<String?> Function();

/// Holds the current [TokenRefresher]. The auth controller assigns [refresher]
/// after it is built; the [AuthLink] below reads it lazily so there is no
/// direct provider → client → provider dependency cycle.
class TokenRefreshBridge {
  TokenRefreshBridge();

  TokenRefresher? refresher;

  /// 갱신 실패 후 억제 플래그(R14). 참이면 인증 실패가 와도 갱신을 시도하지 않고
  /// 오류를 그대로 전달한다(AC-37).
  ///
  /// §2.3의 단일 실행은 동시 요청을 합칠 뿐 순차 재발화를 막지 못한다. R10 경로에서
  /// 세션이 유지된 채 사용자가 화면을 오가면 전환마다 갱신이 나가는데, 그걸 막는
  /// 장치다(AC-36).
  ///
  /// **해제 계기는 명시적인 것만 인정한다** — 사용자의 재시도 동작([allowRefresh])
  /// 또는 앱 재시작(AC-38). 시간 기반 쿨다운은 두지 않는다: POL-029가 `[TBD]`인
  /// 이상 어떤 대기 시간을 적어도 근거 없는 수치가 된다.
  bool suppressed = false;

  /// 갱신 실패 — 이후 자동 갱신을 억제한다.
  void suppressRefresh() => suppressed = true;

  /// 억제를 해제한다. 갱신 성공 시, 그리고 사용자의 명시적 재시도 시 호출된다.
  void allowRefresh() => suppressed = false;
}

@Riverpod(keepAlive: true)
TokenRefreshBridge tokenRefreshBridge(Ref ref) => TokenRefreshBridge();

/// The shared `graphql_flutter` client (CLAUDE.md §4 — lives only in
/// `common/network`). Injects `Authorization: Bearer <accessToken>` from
/// [SecureStorage] on every request, sends the app's active language as an
/// `Accept-Language` header (the server localizes content from it — spec §2), and
/// on an auth error tries one refresh via the [TokenRefreshBridge] before retrying.
@Riverpod(keepAlive: true)
GraphQLClient graphqlClient(Ref ref) {
  final SecureStorage storage = ref.watch(secureStorageProvider);
  final TokenRefreshBridge bridge = ref.watch(tokenRefreshBridgeProvider);

  final HttpLink httpLink = HttpLink(GraphqlEndpoint.resolve());

  final AuthLink authLink = AuthLink(
    getToken: () async {
      final String? token = await storage.readAccessToken();
      return token == null ? null : 'Bearer $token';
    },
  );

  // 매 요청마다 현재 활성 언어를 읽어 헤더에 싣는다(언어 변경 시 클라이언트 재생성
  // 없이 반영). 이 provider가 살아있는 동안 ref.read는 안전하다.
  final Link languageLink = _AcceptLanguageLink(
    () => ref.read(localeControllerProvider).languageCode,
  );

  final Link refreshLink = _RefreshLink(bridge);

  return GraphQLClient(
    link: languageLink.concat(refreshLink).concat(authLink).concat(httpLink),
    cache: GraphQLCache(),
    defaultPolicies: DefaultPolicies(
      mutate: Policies(fetch: FetchPolicy.noCache),
      query: Policies(fetch: FetchPolicy.noCache),
    ),
  );
}

/// 앱 활성 언어를 `Accept-Language` 요청 헤더로 실어 서버가 언어별 콘텐츠를
/// 내려주게 한다(spec §2). 요청 컨텍스트의 [HttpLinkHeaders]에 얹어 HttpLink가
/// 정적 헤더와 병합한다 — AuthLink가 토큰을 다루는 방식과 동일.
class _AcceptLanguageLink extends Link {
  _AcceptLanguageLink(this._currentLanguageCode);

  final String Function() _currentLanguageCode;

  @override
  Stream<Response> request(Request request, [NextLink? forward]) {
    final HttpLinkHeaders existing =
        request.context.entry<HttpLinkHeaders>() ??
        const HttpLinkHeaders(headers: <String, String>{});
    final Request updated = request.updateContextEntry<HttpLinkHeaders>(
      (HttpLinkHeaders? headers) => HttpLinkHeaders(
        headers: <String, String>{
          ...existing.headers,
          'Accept-Language': _currentLanguageCode(),
        },
      ),
    );
    return forward!(updated);
  }
}

/// 갱신 링크를 테스트에서 만들기 위한 진입점. 링크 클래스 자체는 private으로 두어
/// 프로덕션 코드가 직접 구성하지 못하게 하되, 재시도 규율은 단위 테스트로 닫는다
/// (SPEC-0005 §4).
@visibleForTesting
Link buildRefreshLink(TokenRefreshBridge bridge) => _RefreshLink(bridge);

/// 인증 실패 응답을 받으면 등록된 refresher로 토큰을 갱신하고 요청을 재시도한다
/// (SPEC-0005 §2.3~§2.4). 갱신에 실패하면 원래 오류를 그대로 통과시켜 상위가
/// 처리하게 한다.
///
/// 호출 반복을 막는 장치가 셋이며 서로 겹치지 않는다 — 셋 다 필요하다:
///   - [_inFlight] 단일 실행: 동시 요청 **간** 중복 갱신을 막는다(R8).
///   - `retried` 지역 변수 요청당 1회: 한 요청 **내** 갱신 반복을 막는다(R7).
///   - [TokenRefreshBridge.suppressed] 실패 후 억제: 실패 후 순차 재발화에 의한
///     반복을 막는다(R14).
class _RefreshLink extends Link {
  _RefreshLink(this._bridge);

  final TokenRefreshBridge _bridge;

  /// 진행 중인 갱신. 갱신이 필요한 후속 요청은 새로 시작하지 않고 이 Future를
  /// 기다린다(R8, AC-23). 완료되면 비운다.
  ///
  /// 이게 없으면 서버 refresh가 1회용 회전이므로 두 번째 갱신이 방금 폐기된 jti를
  /// 제시해 회원 전체 세션이 폐기된다(AC-22).
  Future<String?>? _inFlight;

  @override
  Stream<Response> request(Request request, [NextLink? forward]) async* {
    final NextLink next = forward!;

    // R7 — 이 요청이 이미 갱신을 한 번 트리거했는지. **호출별 지역 변수**여야 한다:
    // [Request]는 operation/variables/context에 대한 값 동등성을 쓰므로(gql_exec),
    // 공유 Set에 담으면 동시에 나간 동일 요청들이 서로의 키와 충돌해 한 요청만
    // 재시도되고 나머지는 인증 오류를 그대로 받는다. 탭 셸이 같은 쿼리를 동시에
    // 발사하는 구조라 실제로 발생한다.
    bool retried = false;

    await for (final Response response in next(request)) {
      if (retried || !_shouldRefresh(response)) {
        yield response;
        continue;
      }

      retried = true;
      // refresher가 던지면 갱신 실패로 다룬다. 예외를 그대로 흘리면 억제 플래그가
      // 서지 않아 R14가 무력화되고(무한 재발화), 호출자에게는 원인이 지워진
      // 불투명한 오류만 남는다.
      String? newToken;
      try {
        newToken = await _refreshOnce();
      } on Object {
        _bridge.suppressRefresh();
        newToken = null;
      }
      if (newToken == null) {
        // 갱신 실패 — 원래 오류를 그대로 전달한다. 억제 플래그는 refresher가
        // 세운다(R14).
        yield response;
        continue;
      }

      // 대기 중이던 요청은 갱신 완료 **후의** 토큰으로 재시도해야 한다(AC-21).
      // AuthLink가 매 요청마다 저장소에서 토큰을 다시 읽으므로, 여기서 next를 다시
      // 태우는 것만으로 새 accessToken이 실린다.
      yield* next(request);
      return;
    }
  }

  /// 갱신을 시도해야 하는 응답인지 판단한다. 요청당 1회(R7)는 호출자의 지역 변수가
  /// 맡고, 여기서는 나머지 두 장치를 본다.
  bool _shouldRefresh(Response response) {
    if (_bridge.refresher == null) return false;
    // R14 — 갱신 실패 후 억제 중이면 인증 실패가 와도 시도하지 않는다(AC-37).
    if (_bridge.suppressed) return false;
    return _isAuthError(response);
  }

  /// 갱신을 단일 실행으로 만든다(R8). 이미 진행 중이면 그 Future를 기다린다.
  Future<String?> _refreshOnce() {
    final Future<String?>? existing = _inFlight;
    if (existing != null) return existing;

    final Future<String?> started = _bridge.refresher!().whenComplete(() {
      _inFlight = null;
    });
    _inFlight = started;
    return started;
  }

  /// 인증 실패 판별은 공용 분류 함수 하나에만 의존한다(SPEC-0005 §2.1). 두 곳에
  /// 문자열 매칭을 흩어 두면 서버가 형태를 바꿀 때 한쪽만 고쳐진다.
  bool _isAuthError(Response response) {
    final List<GraphQLError>? errors = response.errors;
    if (errors == null || errors.isEmpty) return false;
    return classifyGraphqlErrors(errors) == AuthErrorClass.unauthenticated;
  }
}
