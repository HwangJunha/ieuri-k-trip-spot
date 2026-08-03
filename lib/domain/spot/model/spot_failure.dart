/// 스팟 데이터 접근 실패(SPEC-0002·0003). repository가 전송/도메인 오류를 이 값으로
/// 번역해 provider·UI에 넘긴다 — 서버 코드 문자열을 UI로 직접 흘리지 않는다
/// (POL-016 대비). 순수 도메인.
class SpotFailure implements Exception {
  const SpotFailure(this.kind, {this.code});

  /// 전송 오류(네트워크·서버 도달 불가·정체불명 top-level errors).
  static const SpotFailure network = SpotFailure(SpotFailureKind.network);

  /// 예상치 못한 응답(데이터 없음·형태 불일치).
  static const SpotFailure unknown = SpotFailure(SpotFailureKind.unknown);

  /// 상세 id가 현재 언어 서비스에서 해소되지 않음(SPEC-0003 SPOT_NOT_FOUND, AC-26).
  static const SpotFailure notFound = SpotFailure(SpotFailureKind.notFound);

  /// 업스트림 호출 한도 초과(UPSTREAM_RATE_LIMITED) — "잠시 후 다시" 안내.
  static const SpotFailure rateLimited = SpotFailure(
    SpotFailureKind.rateLimited,
  );

  /// 업스트림 도달 불가/복구 불능(UPSTREAM_UNAVAILABLE) — 재시도 가능한 오류.
  static const SpotFailure upstreamUnavailable = SpotFailure(
    SpotFailureKind.upstreamUnavailable,
  );

  /// 인증 실패(UNAUTHENTICATED). 토큰 갱신 링크가 갱신에 실패했을 때 원래 오류가
  /// 그대로 올라온 경우다. **재시도 상한에 계상하지 않는다**(SPEC-0006 R5·AC-14) —
  /// 조회를 반복해도 해결되지 않고, SPEC-0005의 갱신·로그아웃 경로가 소관이다.
  static const SpotFailure unauthenticated = SpotFailure(
    SpotFailureKind.unauthenticated,
  );

  final SpotFailureKind kind;

  /// 뮤테이션 userErrors의 서버 코드(있으면). 로깅·분기용이며 UI엔 노출하지 않는다.
  final String? code;

  /// 상세 조회의 최상위 error 코드 문자열을 [SpotFailureKind]로 번역한다(spec §6·AC-26).
  /// 코드 최종 문자열은 서버 하네스 소유(`[TBD-2]`)라 대문자 정규화 후 매칭하고, 알 수
  /// 없는 코드는 [network](정체불명 전송 오류)로 안전하게 떨어진다.
  static SpotFailure fromQueryErrorCode(String? code) =>
      switch (code?.toUpperCase()) {
        'SPOT_NOT_FOUND' => SpotFailure.notFound,
        'UPSTREAM_RATE_LIMITED' => SpotFailure.rateLimited,
        'UPSTREAM_UNAVAILABLE' => SpotFailure.upstreamUnavailable,
        'UNAUTHENTICATED' => SpotFailure.unauthenticated,
        _ => SpotFailure.network,
      };

  @override
  String toString() => 'SpotFailure($kind${code == null ? '' : ', $code'})';
}

enum SpotFailureKind {
  network,
  userError,
  unknown,
  notFound,
  rateLimited,
  upstreamUnavailable,
  unauthenticated,
}
