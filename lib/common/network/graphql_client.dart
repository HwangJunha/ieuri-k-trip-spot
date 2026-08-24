import 'package:flutter/foundation.dart' show visibleForTesting;
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../localization/locale_controller.dart';
import '../storage/secure_storage.dart';
import 'access_gateway.dart';
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

  /// 서버가 `EMAIL_NOT_VERIFIED`를 최상위 오류로 보냈을 때 불리는 훅
  /// (SPEC-0024 §2). [refresher]와 같은 이유로 콜백이다 — 네트워크 층이
  /// 인증 provider를 직접 import하면 provider→client→provider 순환이 생긴다.
  ///
  /// 라우팅 게이트가 정상이면 이 경로는 발화하지 않는다. 게이트가 놓친 진입점이나
  /// 서버에서 인증 상태가 바뀐 경우의 안전망이다.
  Future<void> Function()? emailNotVerifiedHandler;

  /// 중복 발화를 막는다. 한 화면이 여러 요청을 동시에 보내면 모두 같은 오류를
  /// 받는데, 그때마다 `me`를 다시 읽으면 요청 수만큼 조회가 나간다.
  bool _handlingEmailNotVerified = false;

  /// 미인증 오류를 알린다. 처리 중이면 무시한다.
  void notifyEmailNotVerified() {
    final Future<void> Function()? handler = emailNotVerifiedHandler;
    if (handler == null || _handlingEmailNotVerified) return;
    _handlingEmailNotVerified = true;
    // 실패해도 삼킨다 — 이건 안전망이라, 여기서 던지면 원래 오류가 가려진다.
    handler()
        .catchError((Object _) {})
        .whenComplete(() => _handlingEmailNotVerified = false);
  }
}

@Riverpod(keepAlive: true)
TokenRefreshBridge tokenRefreshBridge(Ref ref) => TokenRefreshBridge();

/// 모든 GraphQL 요청의 응답 시한.
///
/// 두 곳에 같은 값을 건다 — `queryRequestTimeout`(링크 체인 바깥, 실제로
/// 요청을 끊는 쪽)과 [_TimeoutHttpClient](HTTP 소켓 쪽). 앞의 것만으로도
/// 충분하지만, 뒤가 없으면 소켓이 열린 채 남을 수 있다.
const Duration _requestTimeout = Duration(seconds: 30);

/// 앱 구분자(SPEC-0020 R13). 서버가 `availableSpotCategories` 같은 앱별 노출 구성을
/// 이 값으로 가른다. 헤더가 없으면 서버는 "기본 앱"으로 읽는데, 지금은 결과가 같아
/// 증상이 없지만 구성이 갈리는 순간 조용히 잘못된 목록을 받게 된다.
///
/// 값이 고정이라 요청마다 계산할 필요가 없어 `HttpLink` 정적 헤더에 둔다 —
/// `Accept-Language`처럼 매번 달라지는 값만 Link로 싣는다.
const String _appKey = 'k-trip-spot';

/// The shared `graphql_flutter` client (CLAUDE.md §4 — lives only in
/// `common/network`). Injects `Authorization: Bearer <accessToken>` from
/// [SecureStorage] on every request, sends the app's active language as an
/// `Accept-Language` header (the server localizes content from it — spec §2), and
/// on an auth error tries one refresh via the [TokenRefreshBridge] before retrying.
@Riverpod(keepAlive: true)
GraphQLClient graphqlClient(Ref ref) {
  final SecureStorage storage = ref.watch(secureStorageProvider);
  final TokenRefreshBridge bridge = ref.watch(tokenRefreshBridgeProvider);

  final HttpLink httpLink = HttpLink(
    GraphqlEndpoint.resolve(),
    defaultHeaders: <String, String>{
      'X-App-Key': _appKey,
      // 개발 서버는 Cloudflare Access 뒤에 있다 — 없으면 GraphQL 응답 대신
      // 로그인 HTML이 온다. 운영 빌드에서는 빈 맵이라 아무것도 붙지 않는다.
      ...AccessGateway.headers,
    },
    httpClient: _TimeoutHttpClient(),
  );

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
    // **graphql_flutter의 기본값은 5초다.** 이 시한이 링크 체인 바깥에 있어서,
    // HttpLink에 더 긴 시한을 걸어도 여기서 먼저 끊긴다. 5초는 회원가입·인증
    // 코드 발송처럼 서버가 외부(메일 등)를 거치는 요청에 턱없이 짧아, 정상
    // 처리 중인 요청이 "네트워크 오류"로 실패했다.
    //
    // 더 나쁜 것은 부수 효과가 있는 요청에서다 — 서버에는 가입이 반영되고
    // 클라이언트만 실패로 알게 되어, 재시도가 "이미 가입된 계정"으로 막힌다.
    // 끊는 것보다 기다리는 편이 안전하므로 넉넉히 잡는다.
    queryRequestTimeout: _requestTimeout,
    defaultPolicies: DefaultPolicies(
      // `ErrorPolicy.all`이어야 **부분 실패**를 다룰 수 있다(SPEC-0008 R-7).
      //
      // 기본값 `ErrorPolicy.none`은 errors[]가 하나라도 있으면 **data를 통째로
      // 버린다**. 그러면 `["spotDetail","gallery"]`처럼 하위 필드만 실패한 응답에서도
      // 본문이 사라져, path로 범위를 판별하는 것(§2.1)이 무의미해진다 — 판별에
      // 성공해도 매핑할 데이터가 없기 때문이다.
      //
      // `all`은 data와 errors를 함께 넘기고, 전체 실패 여부는 repository가 path로
      // 판단한다(`hasRootFailure`). 전체 실패면 data가 어차피 null이라 동작이 같다.
      mutate: Policies(fetch: FetchPolicy.noCache, error: ErrorPolicy.all),
      query: Policies(fetch: FetchPolicy.noCache, error: ErrorPolicy.all),
    ),
  );
}

/// HTTP 소켓 수준의 응답 시한([_requestTimeout]).
///
/// 실제로 요청을 끊는 것은 `queryRequestTimeout`이다 — 그쪽이 링크 체인
/// 바깥에 있어 먼저 발동한다. 이 클라이언트는 그 아래에서 소켓이 열린 채
/// 남지 않도록 같은 시한을 한 번 더 거는 안전장치다.
class _TimeoutHttpClient extends http.BaseClient {
  _TimeoutHttpClient({http.Client? inner, this.timeout = _requestTimeout})
    : _inner = inner ?? http.Client();

  final http.Client _inner;
  final Duration timeout;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) =>
      _inner.send(request).timeout(timeout);

  @override
  void close() {
    _inner.close();
    super.close();
  }
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

@visibleForTesting
http.Client buildTimeoutHttpClient({
  required http.Client inner,
  required Duration timeout,
}) => _TimeoutHttpClient(inner: inner, timeout: timeout);

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
      // 미인증 회원의 비허용 호출(SPEC-0024 §2). 갱신 대상이 아니다 — 토큰은
      // 유효하고 인증 상태만 문제라, 여기서 알리기만 하고 응답은 그대로 흘린다.
      if (_isEmailNotVerified(response)) {
        _bridge.notifyEmailNotVerified();
        yield response;
        continue;
      }

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

  /// 미인증 회원의 비허용 호출인지(SPEC-0024 §2). 판별은 [_isAuthError]와 같은
  /// 분류 함수 하나에만 의존한다.
  bool _isEmailNotVerified(Response response) {
    final List<GraphQLError>? errors = response.errors;
    if (errors == null || errors.isEmpty) return false;
    return classifyGraphqlErrors(errors) == AuthErrorClass.emailNotVerified;
  }
}
