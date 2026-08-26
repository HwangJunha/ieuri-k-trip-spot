import 'package:flutter/material.dart';

/// 조회 실패를 알리는 공통 안내(SPEC-0006 R2). 두 형태를 갖는다:
///
/// - [FailureNotice.retryable] — 일반 오류. 자동 재시도가 아직 남아 있거나 다시 시도해
///   볼 만한 상태다.
/// - [FailureNotice.terminal] — 자동 재시도 상한 소진(AC-5·AC-6). "재시도 중"이 아니라
///   **끝났음**을 알리고, 사용자가 원하면 명시적으로 1회 더 시도할 수 있게 한다(AC-8).
///
/// 두 상태를 한 컴포넌트의 두 생성자로 두는 이유는 화면이 둘을 **구분해서** 그려야
/// 하는데(AC-6) 레이아웃은 같기 때문이다. 재시도 가능/종료를 호출부가 bool로 넘기게
/// 하면 어느 쪽인지가 호출부마다 흩어진다.
///
/// `k-trip-spot` #24(토큰 갱신 억제 해제 UI)가 같은 형태를 쓸 예정이라 `common`에 둔다.
class FailureNotice extends StatelessWidget {
  /// 다시 시도해 볼 수 있는 일반 실패.
  const FailureNotice.retryable({
    super.key,
    required this.title,
    required this.body,
    required this.actionLabel,
    required this.onAction,
    this.icon = Icons.cloud_off_outlined,
  }) : isTerminal = false;

  /// 자동 재시도 상한을 소진한 종료 상태. 아이콘과 문구로 일반 오류와 구분된다.
  ///
  /// **[icon]은 화면이 정한다**(2026-08-26). 기본값이 `wifi_off`였는데, 소진의
  /// 원인이 늘 네트워크인 것은 아니라 화면과 어긋났다 — 장소 상세에서 와이파이
  /// 아이콘이 뜨는 것을 보고 지적이 나왔다. 무엇을 못 불러왔는지는 그 화면이
  /// 가장 잘 아므로 거기서 넘기고, 기본값은 원인을 단정하지 않는 것으로 둔다.
  const FailureNotice.terminal({
    super.key,
    required this.title,
    required this.body,
    required this.actionLabel,
    required this.onAction,
    this.icon = Icons.error_outline,
  }) : isTerminal = true;

  final String title;
  final String body;

  /// 행동 버튼 문구. 종료 상태에서도 버튼은 있다 — 상한은 자동 재시도만 막고 사용자의
  /// 명시적 재시도는 막지 않는다(AC-8·AC-13).
  final String actionLabel;
  final VoidCallback onAction;

  final IconData icon;

  /// 종료 상태 여부. 테스트와 화면이 두 상태를 구분하는 지점이다(AC-6).
  final bool isTerminal;

  /// 종료 상태를 찾는 위젯 테스트용 키. 문구는 언어마다 달라 키로 구분한다.
  static const Key terminalKey = Key('failure_notice_terminal');

  /// 재시도 가능 상태를 찾는 위젯 테스트용 키.
  static const Key retryableKey = Key('failure_notice_retryable');

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Center(
      key: isTerminal ? terminalKey : retryableKey,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(icon, size: 48, color: theme.colorScheme.onSurfaceVariant),
            const SizedBox(height: 16),
            Text(
              title,
              style: theme.textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              body,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            FilledButton(onPressed: onAction, child: Text(actionLabel)),
          ],
        ),
      ),
    );
  }
}
