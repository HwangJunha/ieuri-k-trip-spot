import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../auth/model/auth_state.dart';
import '../../auth/provider/auth_controller.dart';
import '../model/alarm_failure.dart';
import '../model/notification_preference.dart';
import 'push_registration_controller.dart';

part 'notification_preference_controller.g.dart';

/// 인증 실패는 재시도하지 않는다 — 세션 갱신은 SPEC-0005의 소관이고, 여기서 다시
/// 불러 봐야 같은 실패가 돌아온다. 그 밖의 실패는 한 번만 다시 시도한다.
Duration? alarmRetryPolicy(int retryCount, Object error) {
  if (error is AlarmFailure &&
      error.kind == AlarmFailureKind.unauthenticated) {
    return null;
  }
  if (retryCount >= 1) return null;
  return const Duration(milliseconds: 400);
}

/// 카테고리별 푸시 수신 설정(SPEC-0028 R19).
///
/// 서버가 두 카테고리를 **항상** 돌려주므로 초기화 호출이 따로 없다(AC19.1).
/// 미인증이면 빈 목록이다 — 설정은 회원에 묶이고 보낼 대상이 없다.
@Riverpod(keepAlive: true, retry: alarmRetryPolicy)
class NotificationPreferenceController
    extends _$NotificationPreferenceController {
  @override
  Future<List<NotificationPreference>> build() async {
    final AsyncValue<AuthState> auth = ref.watch(authControllerProvider);
    if (auth.value?.isAuthenticated != true) {
      return const <NotificationPreference>[];
    }
    return ref.watch(alarmRepositoryProvider).fetchPreferences();
  }

  /// 카테고리 하나를 토글한다(R19).
  ///
  /// 낙관적으로 먼저 반영하고 실패하면 **그 항목 하나만** 되돌린다 — 진입 시점의
  /// 목록 전체로 되돌리면 두 항목을 잇달아 토글했을 때 다른 항목의 낙관적 값까지
  /// 지운다(agreements_controller와 같은 판단).
  Future<void> toggle(NotificationCategory category, bool enabled) async {
    final List<NotificationPreference>? current = state.value;
    if (current == null) return;

    final NotificationPreference? target = current
        .where((NotificationPreference p) => p.category == category)
        .firstOrNull;
    if (target == null) return;

    state = AsyncValue<List<NotificationPreference>>.data(
      _replace(current, target.copyWith(enabled: enabled)),
    );

    try {
      // 응답이 두 카테고리 전체를 돌려주므로 재조회 없이 갈아 끼운다(AC19.3).
      final List<NotificationPreference> updated = await ref
          .read(alarmRepositoryProvider)
          .updatePreference(category: category, enabled: enabled);
      if (updated.isNotEmpty) {
        state = AsyncValue<List<NotificationPreference>>.data(updated);
      }
    } on Object {
      state = AsyncValue<List<NotificationPreference>>.data(
        _replace(state.value ?? current, target),
      );
      rethrow;
    }
  }

  List<NotificationPreference> _replace(
    List<NotificationPreference> list,
    NotificationPreference updated,
  ) => list
      .map(
        (NotificationPreference p) =>
            p.category == updated.category ? updated : p,
      )
      .toList();
}
