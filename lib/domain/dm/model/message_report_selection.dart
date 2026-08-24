import 'message.dart';

/// DM 메시지 다중 선택 신고의 선택 상태(R15).
///
/// **기존 단건 신고 시트로는 표현되지 않아 선택 모드를 별도로 둔다**(설계 §8).
/// 대화 화면 안에서 상대 메시지 여러 건을 골라 한 번에 신고한다.
///
/// 세 가지를 화면에 닿기 전에 막는다:
/// - 선택 0건이면 신고 버튼이 활성화되지 않는다(AC15-3을 UX에서 먼저 막는다)
/// - 자기 메시지는 선택 대상에서 제외한다(AC15-5)
/// - 한 대화 안에서만 선택하므로 대화 혼재(AC15-4)는 화면 구조상 발생하지 않는다
///
/// 순수 도메인 모델 — 위젯·GraphQL·Riverpod 의존 없음.
class MessageReportSelection {
  const MessageReportSelection({
    this.active = false,
    this.selectedIds = const <String>{},
  });

  /// 선택 모드가 켜져 있는지. 꺼져 있으면 평소의 대화 화면이다.
  final bool active;

  /// 고른 메시지 id들. **순서는 의미가 없다** — 서버가 한 신고로 묶어 접수한다.
  final Set<String> selectedIds;

  int get selectedCount => selectedIds.length;

  /// 신고 버튼을 활성화할지. **0건이면 비활성이다**(AC15-3).
  bool get canReport => active && selectedIds.isNotEmpty;

  bool isSelected(String messageId) => selectedIds.contains(messageId);

  /// 한 건을 선택/해제한다. **신고할 수 없는 메시지는 무시한다** — 자기 메시지와
  /// 아직 서버에 없는 메시지는 대상이 아니다([Message.reportable]).
  MessageReportSelection toggle(Message message) {
    if (!message.reportable) return this;
    final next = Set<String>.of(selectedIds);
    if (!next.remove(message.id)) next.add(message.id);
    return MessageReportSelection(active: active, selectedIds: next);
  }

  /// 선택 모드를 켠다. 첫 대상이 있으면 그것을 고른 채로 시작한다 — 길게 눌러
  /// 진입하는 흐름에서 누른 메시지가 곧 첫 선택이다.
  MessageReportSelection start([Message? first]) {
    const started = MessageReportSelection(active: true);
    return first == null ? started : started.toggle(first);
  }

  /// 선택 모드를 끈다. **선택도 함께 비운다** — 다시 들어왔을 때 지난 선택이 남아
  /// 있으면 실수로 엉뚱한 메시지를 신고하게 된다.
  MessageReportSelection cancel() => const MessageReportSelection();

  @override
  bool operator ==(Object other) =>
      other is MessageReportSelection &&
      other.active == active &&
      other.selectedIds.length == selectedIds.length &&
      other.selectedIds.containsAll(selectedIds);

  @override
  int get hashCode => Object.hash(active, Object.hashAllUnordered(selectedIds));
}
