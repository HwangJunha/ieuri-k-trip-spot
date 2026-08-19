import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'pending_destination.g.dart';

/// 게이트에 막히기 직전의 목적지를 한 칸 보관한다.
///
/// 두 주체가 쓴다.
///  - 필수 약관 게이트(SPEC-0011 R12) — 해제 후 원래 가려던 곳으로 복귀
///  - 푸시 딥링크(SPEC-0028 R17) — 종료 상태에서 열린 알림의 목적지
///
/// **provider의 state가 아니라 평범한 객체인 이유가 핵심이다.** 리다이렉트는 위젯
/// 트리가 빌드되는 중에 돌기 때문에, 여기서 provider의 state를 바꾸면 Riverpod이
/// `Tried to modify a provider while the widget tree was building`으로 즉시 던진다.
/// 그래서 [pendingDestinationProvider]는 **객체만** 공유하고 값 변경은 이 객체 안에서
/// 일어난다 — Riverpod이 관여하지 않는다.
///
/// **슬롯은 하나다**(SPEC-0028 §3.3). 약관 게이트와 푸시가 같은 칸을 쓰는데, 둘은
/// 경쟁하는 두 목적지가 아니라 **같은 하나**다 — 약관 게이트가 보관하는 값은 "게이트에
/// 막히지 않았다면 갔을 곳"이고, 푸시로 열린 경우 그곳이 바로 푸시 목적지다. 그래서
/// 칸을 둘로 늘리지 않고 먼저 넣은 값을 지킨다.
///
/// 꺼낼 때 진입 전 화면(로그인·온보딩 등)을 기본 착지점으로 바꾸는 일은 라우터의
/// `destinationAfterGate`가 한다 — 그 판정은 경로 상수를 알아야 해서 여기 두지 않는다.
class PendingDestination {
  String? _location;

  /// 보관한 경로. 없으면 null이다.
  String? get location => _location;

  bool get hasDestination => _location != null;

  /// 무조건 덮어쓴다. 약관 게이트가 쓰던 기존 동작이다.
  void remember(String location) => _location = location;

  /// 비어 있을 때만 넣는다(SPEC-0028 §3.3).
  ///
  /// 푸시로 열린 목적지는 게이트가 돌기 **전에** 들어오므로, 그 뒤 약관 게이트가
  /// 무조건 덮어쓰면 사용자는 엉뚱한 곳에 착지한다. 푸시 목적지가 이긴다.
  void rememberIfAbsent(String location) => _location ??= location;

  /// 보관한 값을 꺼내고 비운다. 한 번 쓰면 사라져야 다음 게이트가 옛 목적지로 잘못
  /// 보내지 않는다(AC17.4).
  String? takeLocation() {
    final String? location = _location;
    _location = null;
    return location;
  }
}

/// 보관 슬롯 하나의 출처. **state를 노출하지 않는다** — 객체만 공유하므로 리다이렉트가
/// 빌드 중에 이 안의 필드를 바꿔도 Riverpod이 관여하지 않는다.
@Riverpod(keepAlive: true)
PendingDestination pendingDestination(Ref ref) => PendingDestination();
