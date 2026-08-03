/// 재시도 상한 소진(SPEC-0006 R2, AC-5·AC-6). 자동 재시도를 다 쓴 뒤에도 조회가
/// 실패한 상태를 **일반 오류와 구분되는 별도 값**으로 표현한다.
///
/// 화면은 이 값을 받으면 "재시도 중"이 아니라 종료 상태를 그리고, 자동 재시도가 더
/// 일어나지 않음을 알린다(설계문서 §2.4). 상한을 소진했다는 사실만 나르고, 어떤
/// 실패였는지는 [cause]에 원래 실패를 그대로 담아 화면이 필요하면 참조하게 한다.
class RetryExhausted implements Exception {
  const RetryExhausted(this.cause);

  /// 상한을 소진시킨 마지막 실패(예: `SpotFailure`). 종료 문구는 원인과 무관하게
  /// 하나지만, 원인을 버리면 로깅·분기에서 되짚을 수 없어 들고 있는다.
  final Object cause;

  @override
  String toString() => 'RetryExhausted($cause)';
}
