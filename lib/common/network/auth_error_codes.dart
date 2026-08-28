/// 서버가 인증 실패에 붙이는 오류 코드(SPEC-0005 · SPEC-0024 §6).
///
/// ## 왜 파일을 따로 두는가
///
/// 같은 목록이 [auth_error_classifier.dart]에도 있지만 그 파일은
/// `graphql_flutter`를 import한다 — **`model/`은 순수 Dart여야 하므로**
/// (CLAUDE.md §3) 도메인 failure 타입이 그 파일을 쓸 수 없다. 그래서 코드 문자열만
/// 순수 Dart로 떼어 두고 양쪽이 이것을 참조한다.
///
/// ## 왜 목록을 한곳에 모으는가
///
/// 서버가 2026-08-25에 `UNAUTHENTICATED_TOKEN_REJECTED`를 추가했을 때
/// `SpotFailure`·`CommunityFailure`는 따라갔지만 `NationalMapFailure`는
/// `code == 'UNAUTHENTICATED'` 한 줄에 머물렀고, `MapFailure`·`EventFailure`는
/// 인증 판별 자체가 없었다. 그 결과 토큰이 거부돼도 그 도메인들은 그것을 "일반
/// 실패"로 보고 재시도 상한까지 서버를 두드렸다(2026-08-29 실기기).
///
/// 목록이 하나면 서버가 코드를 늘릴 때 고칠 자리도 하나다.
library;

/// **갱신으로 회복될 수 있는** 인증 실패 코드.
///
/// 액세스 토큰이 만료·무효라는 뜻이며, refreshToken으로 재발급하면 같은 요청이
/// 성공한다. 그래서 이 실패에는 **자동 재시도를 하지 않는다** — 재시도해 봐야 같은
/// 토큰으로 같은 실패가 날 뿐이고, 회복은 갱신 링크(`graphql_client.dart`)가 맡는다.
///
/// **`TOKEN_REUSE_DETECTED`·`AUTH_STORE_UNAVAILABLE`은 여기 없다.** 전자는 갱신으로
/// 회복되지 않아 재로그인이 필요하고, 후자는 토큰이 멀쩡한 일시 장애라 정상 백오프를
/// 타야 한다(각각의 이유는 `AuthErrorClass` 문서 참고).
const Set<String> refreshableAuthErrorCodes = <String>{
  'UNAUTHENTICATED',
  // 서명·만료·타입 불일치.
  'INVALID_TOKEN',
  // 토큰 거부(2026-08-25 신설). 서버가 만료된 액세스 토큰에 이 코드를 붙인다.
  'UNAUTHENTICATED_TOKEN_REJECTED',
};

/// [code]가 갱신으로 회복 가능한 인증 실패인지. null·미지의 코드는 false다.
bool isRefreshableAuthErrorCode(String? code) =>
    code != null && refreshableAuthErrorCodes.contains(code);

/// 인증 실패 여부를 스스로 말할 수 있는 도메인 실패 타입.
///
/// ## 왜 필요한가
///
/// 공통 재시도 정책(`network_retry_policy.dart`)은 **모든 도메인의 실패를 받지만**
/// `SpotFailure`·`MapFailure` 같은 도메인 타입을 알지 못한다(알면 common이 domain을
/// 참조하게 되어 의존 방향이 뒤집힌다, CLAUDE.md §3). Dart에는 덕 타이핑이 없으므로
/// 공통 계층이 볼 수 있는 **최소한의 약속**을 인터페이스로 둔다.
///
/// 예전에는 그 약속이 없어 공통 정책이 "인증 실패는 여기서 거르지 않는다"고 포기했고,
/// 그 정책을 쓰는 7개 도메인 37곳이 전부 인증 실패에 재시도를 반복했다 — 토큰이
/// 거부된 상태에서 홈 화면 세 쿼리가 0.5초 간격으로 무한히 서버를 두드렸다
/// (2026-08-29 실기기).
///
/// `implements`만 붙이면 된다 — 게터는 각 failure가 이미 갖고 있다.
abstract interface class AuthAwareFailure {
  /// 액세스 토큰이 만료·무효라 **갱신으로 회복되는** 실패인지.
  ///
  /// 재로그인이 필요한 실패(재사용 감지 등)는 여기 포함하지 않는다 — 그것도
  /// 재시도로는 안 풀리지만 성격이 다르고, 지금 판별의 목적은 "갱신 링크에
  /// 맡기고 재시도하지 않는다"이다.
  bool get isUnauthenticated;
}
