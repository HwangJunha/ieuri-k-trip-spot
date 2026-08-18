/// 장소 질문/답변 데이터 접근 실패(SPEC-0026). repository가 전송/도메인 오류를 이 값으로
/// 번역해 provider·UI에 넘긴다 — 서버 코드 문자열을 UI로 직접 흘리지 않는다. 순수 도메인.
///
/// **서버 오류는 두 갈래다**(계약 §오류 코드):
///  - 최상위 `errors[]` — 세션 신호(`UNAUTHENTICATED`). 구현체가 예외로 던진다
///  - `userErrors[]` — 도메인 규칙 위반. **폼 상태를 유지한 채 분기해야 하므로**
///    예외가 아니라 값으로 돌려준다([SpotQaMutationResult])
///
/// 자격 실패(`NOT_ELIGIBLE_TO_ASK`/`NOT_ELIGIBLE_TO_ANSWER`)가 후자에 속하는 것이
/// 중요하다 — 작성 화면을 닫지 않고 안내만 띄워 사용자가 쓴 글을 지키기 때문이다.
class SpotQaFailure implements Exception {
  const SpotQaFailure(this.kind, {this.code});

  /// 전송 오류(네트워크·서버 도달 불가·정체불명 top-level errors).
  static const SpotQaFailure network = SpotQaFailure(SpotQaFailureKind.network);

  /// 예상치 못한 응답(데이터 없음·형태 불일치).
  static const SpotQaFailure unknown = SpotQaFailure(SpotQaFailureKind.unknown);

  /// 인증 실패(`UNAUTHENTICATED`). SPEC-0005의 갱신·로그아웃 경로가 소관이다.
  ///
  /// **조회에는 오지 않는다** — 질문·답변 읽기는 비로그인도 허용된다(AC-1.4).
  static const SpotQaFailure unauthenticated = SpotQaFailure(
    SpotQaFailureKind.unauthenticated,
  );

  /// 뮤테이션 `userErrors`의 서버 코드로 만든 실패.
  factory SpotQaFailure.userError(String code) =>
      SpotQaFailure(SpotQaFailureKind.userError, code: code);

  final SpotQaFailureKind kind;

  /// 서버 `UserError.code`(있으면). 원문 message는 담지 않는다 — 서버 문자열에
  /// PII가 실릴 수 있다(POL-013).
  final String? code;

  /// 최상위 `errors[]`의 코드를 번역한다.
  static SpotQaFailure fromQueryErrorCode(String? code) =>
      switch (code?.toUpperCase()) {
        'UNAUTHENTICATED' => SpotQaFailure.unauthenticated,
        _ => SpotQaFailure.network,
      };

  /// 재시도해도 소용없는 실패인지. provider 재시도 정책이 이 값을 본다.
  bool get permanent =>
      kind == SpotQaFailureKind.unauthenticated ||
      kind == SpotQaFailureKind.userError;

  @override
  bool operator ==(Object other) =>
      other is SpotQaFailure && other.kind == kind && other.code == code;

  @override
  int get hashCode => Object.hash(kind, code);

  @override
  String toString() =>
      'SpotQaFailure(${kind.name}${code == null ? '' : ', $code'})';
}

enum SpotQaFailureKind { network, unknown, unauthenticated, userError }

/// 뮤테이션 결과. 성공이면 [value], 도메인 규칙 위반이면 [errorCode]다.
///
/// **`userErrors`를 예외로 던지지 않는 이유**는 작성 화면이 폼 상태를 유지한 채
/// 분기해야 하기 때문이다(설계 §작성 자격 표시) — 자격 없음으로 거절됐다고 사용자가
/// 쓴 글을 날리지 않는다.
class SpotQaMutationResult<T> {
  const SpotQaMutationResult.success(this.value)
    : errorCode = null,
      succeeded = true;

  const SpotQaMutationResult.failure(this.errorCode)
    : value = null,
      succeeded = false;

  final bool succeeded;

  /// 성공 시의 반환값(생성된 질문·답변·답글 id). 없을 수 있다.
  final T? value;

  /// 실패 사유 코드. `NOT_ELIGIBLE_TO_ASK`·`NOT_ELIGIBLE_TO_ANSWER`·
  /// `REPLY_TO_REPLY_NOT_ALLOWED`·`NOT_QUESTION_OWNER` 등.
  ///
  /// **문자열로 둔다** — 계약이 가산적이라 서버가 새 코드를 더할 수 있고, 열거형으로
  /// 전수 분기하면 그 시점에 깨진다.
  final String? errorCode;

  /// 좋아요 자격이 없어 거절된 것인지. **작성 화면을 닫지 않고 안내만 띄우는** 분기가
  /// 이 값을 본다.
  bool get notEligible =>
      errorCode == 'NOT_ELIGIBLE_TO_ASK' ||
      errorCode == 'NOT_ELIGIBLE_TO_ANSWER';
}
