/// DM 데이터 접근 실패(SPEC-0017·SPEC-0021). repository가 전송/도메인 오류를 이 값으로
/// 번역해 provider·UI에 넘긴다 — 서버 코드 문자열을 UI로 직접 흘리지 않는다. 순수 도메인.
///
/// **서버 오류는 두 갈래이고 위치가 연산 종류로 갈린다**(계약 §에러):
///  - **조회·구독**에서 참여자가 아니면 최상위 `errors[]`의 `FORBIDDEN` → [forbidden]
///  - **뮤테이션**에서 참여자가 아니면 `userErrors[]`의
///    `NOT_CONVERSATION_PARTICIPANT` → [userError]
///
/// 조회는 볼 자격 자체가 없어 부분 성공이 성립하지 않고, 뮤테이션은 요청이 정상
/// 처리된 뒤 도메인 규칙에 걸린 것이라 화면이 폼 상태를 유지한 채 분기해야 한다.
///
/// **`userErrors`만 검사하는 공통 핸들러를 만들면 조회 실패가 빈 화면이 된다.**
class DmFailure implements Exception {
  const DmFailure(this.kind, {this.code});

  /// 전송 오류(네트워크·서버 도달 불가·정체불명 top-level errors).
  static const DmFailure network = DmFailure(DmFailureKind.network);

  /// 예상치 못한 응답(데이터 없음·형태 불일치).
  static const DmFailure unknown = DmFailure(DmFailureKind.unknown);

  /// 인증 실패(`UNAUTHENTICATED`). SPEC-0005의 갱신·로그아웃 경로가 소관이다.
  static const DmFailure unauthenticated = DmFailure(
    DmFailureKind.unauthenticated,
  );

  /// 권한 실패(`FORBIDDEN`) — 참여자가 아닌 대화의 조회·구독.
  ///
  /// **재시도로 풀리지 않는다.** 구독 재연결 로직은 이 실패에 재시도하지 않아야
  /// 상한까지 헛돌지 않는다.
  static const DmFailure forbidden = DmFailure(DmFailureKind.forbidden);

  /// 소켓 신원 만료(`SUBSCRIPTION_UNAUTHENTICATED`, 2026-08-25).
  ///
  /// **재연결로 풀리지 않는다.** 신원은 `connection_init` 시점에 고정되어 같은
  /// 토큰으로 다시 붙으면 결과가 같다 — 무한 재연결의 원인이던 자리다.
  static const DmFailure subscriptionUnauthenticated = DmFailure(
    DmFailureKind.subscriptionUnauthenticated,
  );

  /// 뮤테이션 `userErrors`의 서버 코드로 만든 실패.
  factory DmFailure.userError(String code) =>
      DmFailure(DmFailureKind.userError, code: code);

  final DmFailureKind kind;

  /// 서버 `UserError.code`(있으면). 원문 message는 담지 않는다 — 서버 문자열에
  /// PII가 실릴 수 있다(POL-013).
  final String? code;

  /// 최상위 `errors[]`의 코드를 번역한다.
  static DmFailure fromQueryErrorCode(String? code) =>
      switch (code?.toUpperCase()) {
        'UNAUTHENTICATED' => DmFailure.unauthenticated,
        // 토큰 거부(2026-08-25). 갱신으로 회복되는 자리라 위와 같게 다룬다.
        'UNAUTHENTICATED_TOKEN_REJECTED' => DmFailure.unauthenticated,
        'FORBIDDEN' => DmFailure.forbidden,
        // **소켓 신원 만료.** 재연결로 풀리지 않는다 — 아래 [permanent] 참고.
        'SUBSCRIPTION_UNAUTHENTICATED' => DmFailure.subscriptionUnauthenticated,
        // 저장소 일시 장애(2026-08-25). **재시도로 풀린다** — `permanent`가 아니라
        // 네트워크 실패와 같은 갈래로 두어 정상 백오프를 타게 한다.
        'AUTH_STORE_UNAVAILABLE' => DmFailure.network,
        _ => DmFailure.network,
      };

  /// 재시도해도 소용없는 실패인지. 구독 재연결·provider 재시도가 이 값을 본다.
  ///
  /// **[subscriptionUnauthenticated]도 참이다.** 같은 토큰으로 다시 붙으면 결과가
  /// 같으므로 재시도는 낭비다. 다만 "그래서 포기한다"가 아니라 **갱신 후 새 연결로
  /// 간다** — 그 갈래는 구독을 여는 쪽이 따로 본다(`conversation_providers.dart`).
  bool get permanent =>
      kind == DmFailureKind.forbidden ||
      kind == DmFailureKind.unauthenticated ||
      kind == DmFailureKind.subscriptionUnauthenticated;

  @override
  bool operator ==(Object other) =>
      other is DmFailure && other.kind == kind && other.code == code;

  @override
  int get hashCode => Object.hash(kind, code);

  @override
  String toString() =>
      'DmFailure(${kind.name}${code == null ? '' : ', $code'})';
}

enum DmFailureKind {
  network,
  unknown,
  unauthenticated,
  forbidden,

  /// 소켓 신원 만료. 갱신 → 재연결 → 재구독으로만 풀린다.
  subscriptionUnauthenticated,
  userError,
}
