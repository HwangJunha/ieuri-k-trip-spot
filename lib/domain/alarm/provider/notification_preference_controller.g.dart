// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_preference_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 카테고리별 푸시 수신 설정(SPEC-0028 R19).
///
/// 서버가 두 카테고리를 **항상** 돌려주므로 초기화 호출이 따로 없다(AC19.1).
/// 미인증이면 빈 목록이다 — 설정은 회원에 묶이고 보낼 대상이 없다.

@ProviderFor(NotificationPreferenceController)
const notificationPreferenceControllerProvider =
    NotificationPreferenceControllerProvider._();

/// 카테고리별 푸시 수신 설정(SPEC-0028 R19).
///
/// 서버가 두 카테고리를 **항상** 돌려주므로 초기화 호출이 따로 없다(AC19.1).
/// 미인증이면 빈 목록이다 — 설정은 회원에 묶이고 보낼 대상이 없다.
final class NotificationPreferenceControllerProvider
    extends
        $AsyncNotifierProvider<
          NotificationPreferenceController,
          List<NotificationPreference>
        > {
  /// 카테고리별 푸시 수신 설정(SPEC-0028 R19).
  ///
  /// 서버가 두 카테고리를 **항상** 돌려주므로 초기화 호출이 따로 없다(AC19.1).
  /// 미인증이면 빈 목록이다 — 설정은 회원에 묶이고 보낼 대상이 없다.
  const NotificationPreferenceControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: alarmRetryPolicy,
        name: r'notificationPreferenceControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$notificationPreferenceControllerHash();

  @$internal
  @override
  NotificationPreferenceController create() =>
      NotificationPreferenceController();
}

String _$notificationPreferenceControllerHash() =>
    r'c1641ced2d7e3cde36f9e1035fa68f1f8d6781c8';

/// 카테고리별 푸시 수신 설정(SPEC-0028 R19).
///
/// 서버가 두 카테고리를 **항상** 돌려주므로 초기화 호출이 따로 없다(AC19.1).
/// 미인증이면 빈 목록이다 — 설정은 회원에 묶이고 보낼 대상이 없다.

abstract class _$NotificationPreferenceController
    extends $AsyncNotifier<List<NotificationPreference>> {
  FutureOr<List<NotificationPreference>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<
              AsyncValue<List<NotificationPreference>>,
              List<NotificationPreference>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<NotificationPreference>>,
                List<NotificationPreference>
              >,
              AsyncValue<List<NotificationPreference>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
