import '../../../common/network/auth_error_codes.dart';

/// 스팟 데이터 접근 실패(SPEC-0002·0003). repository가 전송/도메인 오류를 이 값으로
/// 번역해 provider·UI에 넘긴다 — 서버 코드 문자열을 UI로 직접 흘리지 않는다
/// (POL-016 대비). 순수 도메인.
class SpotFailure implements Exception, AuthAwareFailure {
  const SpotFailure(this.kind, {this.code});

  /// 전송 오류(네트워크·서버 도달 불가·정체불명 top-level errors).
  static const SpotFailure network = SpotFailure(SpotFailureKind.network);

  /// 예상치 못한 응답(데이터 없음·형태 불일치).
  static const SpotFailure unknown = SpotFailure(SpotFailureKind.unknown);

  /// 그런 장소가 아예 없음(SPEC-0003 SPOT_NOT_FOUND, AC-26).
  static const SpotFailure notFound = SpotFailure(SpotFailureKind.notFound);

  /// 장소는 있으나 **활성 언어에서 열람할 수 없음**(SPEC-0029 SPOT_NOT_FOUND_IN_LOCALE).
  ///
  /// [notFound]와 반드시 구분한다 — 사용자에게 할 안내가 다르다. 이쪽은 **언어를
  /// 바꾸면 볼 수 있는 장소**라, "없다"고 안내하면 사용자가 오해한다(R-20).
  ///
  /// 정상 경로에서는 도달하지 않는다. 목록·칩·마커가 전부 활성 언어로 걸러지므로
  /// 여기에 닿는 것은 우회 진입뿐이다 — 딥링크, 푸시 페이로드, 복원된 초안, 언어를
  /// 바꾸기 전에 열려 있던 화면. 마지막 방어선이다.
  static const SpotFailure notFoundInLocale = SpotFailure(
    SpotFailureKind.notFoundInLocale,
  );

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

  /// 이어 받기 커서가 더 이상 유효하지 않음(SPEC-0035 `CURSOR_EXPIRED`·`INVALID_CURSOR`).
  ///
  /// **두 코드를 하나로 접는다** — 만료든 손상·조건 불일치든 클라이언트가 할 일은
  /// 같다: 커서 없이 첫 요청을 다시 보낸다(AC-28.1·28.3). 이름은 그래서 만료와 손상을
  /// 아우르는 중립형이다.
  ///
  /// **재시도 예산에 계상하지 않는다**(`retry_counting.dart`). 네트워크 실패가 아니라
  /// 세션 조건이 바뀌었다는 신호이며, 같은 커서로 다시 보내 봐야 같은 답이 온다.
  static const SpotFailure cursorInvalid = SpotFailure(
    SpotFailureKind.cursorInvalid,
  );

  final SpotFailureKind kind;

  /// 뮤테이션 userErrors의 서버 코드(있으면). 로깅·분기용이며 UI엔 노출하지 않는다.
  final String? code;

  /// 대상 스팟이 **지금 이 언어에서** 해소되지 않는 실패인지(SPEC-0007 §1.1).
  ///
  /// 같은 사유가 오퍼레이션에 따라 다른 곳으로 온다 — 상세 조회는 최상위 `errors[]`라
  /// [SpotFailureKind.notFound]로 번역되고, `reactToSpot`은 payload의 `userErrors[]`라
  /// [SpotFailureKind.userError] + `SPOT_NOT_FOUND` 코드로 온다. 호출부가 두 경로를
  /// 각각 알 필요는 없으므로 판정을 여기 둔다.
  ///
  /// **두 코드를 함께 본다**(SPEC-0029). 스와이프 큐에서 카드를 걷어내는 판단에는
  /// "없다"와 "이 언어에서 못 본다"가 같은 결론이다 — 어느 쪽이든 지금 그 카드는
  /// 열리지 않으므로, 남겨 두면 같은 카드가 계속 돌아온다. 사용자 **안내**를 가르는
  /// 것은 [isSpotMissingInLocale]이지 이 판정이 아니다.
  bool get isSpotMissing =>
      kind == SpotFailureKind.notFound ||
      kind == SpotFailureKind.notFoundInLocale ||
      code?.toUpperCase() == _notFoundCode ||
      code?.toUpperCase() == _notFoundInLocaleCode;

  /// 장소는 있으나 활성 언어에서 볼 수 없는 실패인지(SPEC-0029 R-20).
  ///
  /// [isSpotMissing]과 달리 **안내 문구를 가르는 판정이다.** 참이면 "언어를 바꾸면
  /// 볼 수 있다"는 뜻이므로 "존재하지 않는다"고 말하면 안 된다.
  bool get isSpotMissingInLocale =>
      kind == SpotFailureKind.notFoundInLocale ||
      code?.toUpperCase() == _notFoundInLocaleCode;

  static const String _notFoundCode = 'SPOT_NOT_FOUND';
  static const String _notFoundInLocaleCode = 'SPOT_NOT_FOUND_IN_LOCALE';

  /// 상세 조회의 최상위 error 코드 문자열을 [SpotFailureKind]로 번역한다(spec §6·AC-26).
  /// 코드 최종 문자열은 서버 하네스 소유(`[TBD-2]`)라 대문자 정규화 후 매칭하고, 알 수
  /// 없는 코드는 [network](정체불명 전송 오류)로 안전하게 떨어진다.
  static SpotFailure fromQueryErrorCode(String? code) =>
      switch (code?.toUpperCase()) {
        _notFoundCode => SpotFailure.notFound,
        _notFoundInLocaleCode => SpotFailure.notFoundInLocale,
        'UPSTREAM_RATE_LIMITED' => SpotFailure.rateLimited,
        'UPSTREAM_UNAVAILABLE' => SpotFailure.upstreamUnavailable,
        'UNAUTHENTICATED' => SpotFailure.unauthenticated,
        // 커서 만료·손상(SPEC-0035). 둘 다 "커서 없이 다시 시작"이라 구분하지 않는다.
        'CURSOR_EXPIRED' => SpotFailure.cursorInvalid,
        'INVALID_CURSOR' => SpotFailure.cursorInvalid,
        // 토큰 거부(2026-08-25). 갱신으로 회복되는 자리라 위와 같게 다룬다.
        'UNAUTHENTICATED_TOKEN_REJECTED' => SpotFailure.unauthenticated,
        // 인증 저장소 일시 장애. **인증 실패로 접지 않는다** — 재로그인이
        // 아니라 잠시 후 재시도가 맞고, 재시도 예산에 계상돼야 정상
        // 백오프를 탄다.
        'AUTH_STORE_UNAVAILABLE' => SpotFailure.network,
        _ => SpotFailure.network,
      };

  /// 액세스 토큰이 만료·무효라 갱신이 필요하다.
  ///
  /// **공통 재시도 정책이 보는 이름이다**(`common/network/network_retry_policy.dart`).
  /// 도메인마다 실패 타입이 달라 공통 코드가 `kind`를 알 수 없으므로, 모든 failure가
  /// 같은 이름의 게터를 노출해 그쪽에서 하나로 판별한다 — 인증 실패에 자동 재시도를
  /// 하면 같은 토큰으로 같은 실패가 나 상한까지 헛돈다(2026-08-29 실기기).
  @override
  bool get isUnauthenticated => kind == SpotFailureKind.unauthenticated;

  @override
  String toString() => 'SpotFailure($kind${code == null ? '' : ', $code'})';
}

enum SpotFailureKind {
  network,
  userError,
  unknown,
  notFound,

  /// 장소는 있으나 활성 언어에서 열람 불가(SPEC-0029). [notFound]와 분리해야
  /// 안내가 갈린다.
  notFoundInLocale,
  rateLimited,
  upstreamUnavailable,
  unauthenticated,

  /// 이어 받기 커서 만료·손상(SPEC-0035). 커서 없이 첫 요청부터 다시 한다.
  cursorInvalid,
}
