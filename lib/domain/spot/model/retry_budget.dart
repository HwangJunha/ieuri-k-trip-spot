/// 조회 재시도 예산(SPEC-0006 R1~R5). 한 조회 대상에 대해 자동 시도를 몇 번까지
/// 허용할지 세는 순수 값 객체다.
///
/// 컨트롤러 인스턴스가 아니라 **컨트롤러 바깥**에 두고 쓴다(설계문서 §2.2). provider가
/// 재빌드되면 인스턴스 필드는 초기화되는데, 바로 그 재빌드가 폭주의 경로이기 때문이다.
///
/// [maxAttempts]는 최초 시도를 포함한 총 시도 횟수다 — 2면 "최초 1회 + 자동 재시도
/// 1회"에서 멈춘다(AC-1·AC-2).
class RetryBudget {
  const RetryBudget({
    this.attempts = 0,
    this.maxAttempts = defaultMaxAttempts,
    this.lastFailure,
  });

  /// 기본 상한: 최초 시도 + 자동 재시도 1회 = 총 2회(AC-2).
  static const int defaultMaxAttempts = 2;

  /// 지금까지 계상된 시도 횟수. 인증 실패·권한 거부는 계상되지 않으므로(설계문서
  /// §2.3) 실제 조회 횟수와 일치하지 않을 수 있다.
  final int attempts;

  /// 계상 가능한 총 시도 상한.
  final int maxAttempts;

  /// 상한을 소진시킨 마지막 실패. 소진 뒤의 재빌드는 repository를 부르지 않고 이 값을
  /// 원인으로 종료 상태를 돌려준다 — 원인을 들고 있지 않으면 "무엇이 실패했는지"를
  /// 지어내야 하고, 그러면 로깅·분기가 실제와 어긋난다.
  final Object? lastFailure;

  /// 상한을 다 썼는지 여부. true면 자동 조회를 시작하지 않는다(AC-11·AC-12).
  bool get isExhausted => attempts >= maxAttempts;

  /// 시도 1회를 계상한 예산. 상한을 넘겨 증가시키지 않는다 — 소진 상태는 하나뿐이라
  /// 카운터가 무한히 커질 이유가 없다.
  RetryBudget countFailure(Object failure) => attempts >= maxAttempts
      ? this
      : RetryBudget(
          attempts: attempts + 1,
          maxAttempts: maxAttempts,
          lastFailure: failure,
        );

  /// 카운터를 0으로 되돌린 예산. 명시적 재시도가 성공했을 때 쓴다(AC-9).
  RetryBudget reset() => RetryBudget(maxAttempts: maxAttempts);

  @override
  bool operator ==(Object other) =>
      other is RetryBudget &&
      other.attempts == attempts &&
      other.maxAttempts == maxAttempts &&
      other.lastFailure == lastFailure;

  @override
  int get hashCode => Object.hash(attempts, maxAttempts, lastFailure);

  @override
  String toString() => 'RetryBudget($attempts/$maxAttempts)';
}
