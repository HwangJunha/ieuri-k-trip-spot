import '../../../common/model/post_author.dart';

/// 상대의 타이핑 상태(서버 `TypingEvent`를 화면 상태로 옮긴 것).
///
/// **이 화면에서 가장 틀리기 쉬운 지점이다**(설계 §5). 타이핑 이벤트는 전달 보장이
/// 없고 재연결해도 재전송되지 않는다. "입력 중"을 이벤트로만 켜고 끄면 마지막
/// 이벤트가 유실되는 순간 화면이 **영원히 "입력 중"에 갇힌다.**
///
/// 그래서 표시 여부를 이벤트가 아니라 **마지막 수신 시각 기준 타임아웃으로
/// 판정한다**(AC10-4). 서버가 "멈췄다"는 이벤트를 보내주기를 기다리지 않는다.
/// `TypingEvent.emittedAt`이 이 판단을 위해 존재한다.
///
/// 순수 도메인 모델 — 시계를 주입받아 판정하므로 가짜 시계로 검증할 수 있다.
class TypingIndicator {
  const TypingIndicator({required this.sender, required this.emittedAt});

  /// 타이핑 중인 상대방.
  final PostAuthor sender;

  /// 이벤트 발생 시각(서버가 준 값). **수신 시각이 아니라 발생 시각이다** — 전달이
  /// 지연된 이벤트로 표시를 연장하지 않기 위해서다.
  final DateTime emittedAt;

  /// 이 이벤트가 [now] 시점에도 유효한지. [timeout]이 지났으면 표시를 내린다.
  ///
  /// 경계는 **초과**로 판정한다 — 정확히 타임아웃 시각이면 아직 유효하다.
  bool isActiveAt(DateTime now, Duration timeout) =>
      now.difference(emittedAt) <= timeout;

  @override
  bool operator ==(Object other) =>
      other is TypingIndicator &&
      other.sender == sender &&
      other.emittedAt == emittedAt;

  @override
  int get hashCode => Object.hash(sender, emittedAt);
}
