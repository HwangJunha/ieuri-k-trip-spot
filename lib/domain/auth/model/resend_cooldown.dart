/// 재발송·주소 정정이 **공유하는** 60초 쿨다운(SPEC-0024 R7).
///
/// 서버가 두 오퍼레이션에 하나의 타이머를 쓴다 — 재발송 직후 주소 정정을 누르면
/// `RESEND_COOLDOWN_ACTIVE`로 막히고, 그 반대도 같다. 앱이 버튼별로 따로 세면
/// 한쪽이 열려 보이는데 누르면 실패한다.
///
/// 시계를 직접 읽지 않는다 — `now`를 받아 계산만 한다. 그래야 테스트가 시간을
/// 기다리지 않고 표처럼 검증할 수 있다.
library;

/// 서버가 강제하는 쿨다운 길이(POL 기준 60초).
const Duration resendCooldown = Duration(seconds: 60);

/// 쿨다운 상태. 마지막 발송 시각만 들고 나머지는 계산한다.
class ResendCooldown {
  const ResendCooldown({this.lastSentAt});

  /// 재발송이든 주소 정정이든 **마지막으로 코드를 보낸** 시각. null이면 아직 한 번도
  /// 보내지 않았다는 뜻이라 즉시 가능하다.
  final DateTime? lastSentAt;

  /// 아직 보낸 적 없는 상태.
  static const ResendCooldown idle = ResendCooldown();

  /// [now] 기준으로 코드를 보낼 수 있는지.
  bool canSendAt(DateTime now) => remainingAt(now) == Duration.zero;

  /// [now] 기준 남은 대기 시간. 지났으면 [Duration.zero]다.
  Duration remainingAt(DateTime now) {
    final DateTime? sent = lastSentAt;
    if (sent == null) return Duration.zero;
    final Duration elapsed = now.difference(sent);
    // 기기 시계가 뒤로 갔거나 서버와 어긋나면 elapsed가 음수가 된다. 그 경우 전체
    // 시간을 기다리게 두면 사용자가 영영 못 보내므로 흐르지 않은 것으로 본다.
    if (elapsed.isNegative) return resendCooldown;
    final Duration left = resendCooldown - elapsed;
    return left.isNegative ? Duration.zero : left;
  }

  /// 남은 초(올림). 화면 카운트다운에 쓴다 — 0.2초 남았을 때 "0초"라고 쓰면 버튼이
  /// 아직 잠겨 있는데 열린 것처럼 보인다.
  int remainingSecondsAt(DateTime now) {
    final Duration left = remainingAt(now);
    return (left.inMilliseconds / 1000).ceil();
  }

  /// [sentAt]에 코드를 보냈다고 표시한 새 상태.
  ResendCooldown markSent(DateTime sentAt) => ResendCooldown(lastSentAt: sentAt);

  @override
  bool operator ==(Object other) =>
      other is ResendCooldown && other.lastSentAt == lastSentAt;

  @override
  int get hashCode => lastSentAt.hashCode;
}
