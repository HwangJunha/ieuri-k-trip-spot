// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'permission_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Exposes the [PermissionService]. Behind a provider so the boot coordinator
/// reads it (never constructs it) and tests override it with a fake instead of
/// driving the real `permission_handler` plugin (CLAUDE.md §5). autoDispose
/// (the default): it's a const stateless wrapper, so nothing needs to survive.

@ProviderFor(permissionService)
const permissionServiceProvider = PermissionServiceProvider._();

/// Exposes the [PermissionService]. Behind a provider so the boot coordinator
/// reads it (never constructs it) and tests override it with a fake instead of
/// driving the real `permission_handler` plugin (CLAUDE.md §5). autoDispose
/// (the default): it's a const stateless wrapper, so nothing needs to survive.

final class PermissionServiceProvider
    extends
        $FunctionalProvider<
          PermissionService,
          PermissionService,
          PermissionService
        >
    with $Provider<PermissionService> {
  /// Exposes the [PermissionService]. Behind a provider so the boot coordinator
  /// reads it (never constructs it) and tests override it with a fake instead of
  /// driving the real `permission_handler` plugin (CLAUDE.md §5). autoDispose
  /// (the default): it's a const stateless wrapper, so nothing needs to survive.
  const PermissionServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'permissionServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$permissionServiceHash();

  @$internal
  @override
  $ProviderElement<PermissionService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  PermissionService create(Ref ref) {
    return permissionService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PermissionService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PermissionService>(value),
    );
  }
}

String _$permissionServiceHash() => r'94fb7f67b76d9452165e42e9b0aad8c70c5011bd';

/// Whether the first-launch permission sequence (location then notification)
/// has finished running. The splash waits on this before routing so it doesn't
/// leave the moment location is granted — mid-sequence, while the optional
/// notification prompt is still to come (SPEC-0001 §최초실행, R2 sequential).
///
/// keepAlive: a boot-sequence latch that must outlive the splash. It flips once
/// and never resets during a session.

@ProviderFor(PermissionBootComplete)
const permissionBootCompleteProvider = PermissionBootCompleteProvider._();

/// Whether the first-launch permission sequence (location then notification)
/// has finished running. The splash waits on this before routing so it doesn't
/// leave the moment location is granted — mid-sequence, while the optional
/// notification prompt is still to come (SPEC-0001 §최초실행, R2 sequential).
///
/// keepAlive: a boot-sequence latch that must outlive the splash. It flips once
/// and never resets during a session.
final class PermissionBootCompleteProvider
    extends $NotifierProvider<PermissionBootComplete, bool> {
  /// Whether the first-launch permission sequence (location then notification)
  /// has finished running. The splash waits on this before routing so it doesn't
  /// leave the moment location is granted — mid-sequence, while the optional
  /// notification prompt is still to come (SPEC-0001 §최초실행, R2 sequential).
  ///
  /// keepAlive: a boot-sequence latch that must outlive the splash. It flips once
  /// and never resets during a session.
  const PermissionBootCompleteProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'permissionBootCompleteProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$permissionBootCompleteHash();

  @$internal
  @override
  PermissionBootComplete create() => PermissionBootComplete();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$permissionBootCompleteHash() =>
    r'318428d7b4e6c4d0e78e7ad4ecfb5f823ae437e0';

/// Whether the first-launch permission sequence (location then notification)
/// has finished running. The splash waits on this before routing so it doesn't
/// leave the moment location is granted — mid-sequence, while the optional
/// notification prompt is still to come (SPEC-0001 §최초실행, R2 sequential).
///
/// keepAlive: a boot-sequence latch that must outlive the splash. It flips once
/// and never resets during a session.

abstract class _$PermissionBootComplete extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// App-global runtime-permission state (SPEC-0001 §영구거부처리): the last known
/// [PermissionState] per [PermissionKind], starting empty (nothing queried yet).
///
/// keepAlive: permission state is a boot-sequence concern that outlives any one
/// screen — later features read it to decide whether to surface the "open
/// Settings" path (R5), and the app-resume hook refreshes it (CLAUDE.md §5
/// justification). It is in-memory only: the OS is the source of truth, so we
/// re-query rather than persist (spec — "상태만 보관").

@ProviderFor(PermissionController)
const permissionControllerProvider = PermissionControllerProvider._();

/// App-global runtime-permission state (SPEC-0001 §영구거부처리): the last known
/// [PermissionState] per [PermissionKind], starting empty (nothing queried yet).
///
/// keepAlive: permission state is a boot-sequence concern that outlives any one
/// screen — later features read it to decide whether to surface the "open
/// Settings" path (R5), and the app-resume hook refreshes it (CLAUDE.md §5
/// justification). It is in-memory only: the OS is the source of truth, so we
/// re-query rather than persist (spec — "상태만 보관").
final class PermissionControllerProvider
    extends
        $NotifierProvider<
          PermissionController,
          Map<PermissionKind, PermissionState>
        > {
  /// App-global runtime-permission state (SPEC-0001 §영구거부처리): the last known
  /// [PermissionState] per [PermissionKind], starting empty (nothing queried yet).
  ///
  /// keepAlive: permission state is a boot-sequence concern that outlives any one
  /// screen — later features read it to decide whether to surface the "open
  /// Settings" path (R5), and the app-resume hook refreshes it (CLAUDE.md §5
  /// justification). It is in-memory only: the OS is the source of truth, so we
  /// re-query rather than persist (spec — "상태만 보관").
  const PermissionControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'permissionControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$permissionControllerHash();

  @$internal
  @override
  PermissionController create() => PermissionController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<PermissionKind, PermissionState> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride:
          $SyncValueProvider<Map<PermissionKind, PermissionState>>(value),
    );
  }
}

String _$permissionControllerHash() =>
    r'9bb1ea400cb0ed35d9d8cd9d05886d1d132b276b';

/// App-global runtime-permission state (SPEC-0001 §영구거부처리): the last known
/// [PermissionState] per [PermissionKind], starting empty (nothing queried yet).
///
/// keepAlive: permission state is a boot-sequence concern that outlives any one
/// screen — later features read it to decide whether to surface the "open
/// Settings" path (R5), and the app-resume hook refreshes it (CLAUDE.md §5
/// justification). It is in-memory only: the OS is the source of truth, so we
/// re-query rather than persist (spec — "상태만 보관").

abstract class _$PermissionController
    extends $Notifier<Map<PermissionKind, PermissionState>> {
  Map<PermissionKind, PermissionState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<
              Map<PermissionKind, PermissionState>,
              Map<PermissionKind, PermissionState>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                Map<PermissionKind, PermissionState>,
                Map<PermissionKind, PermissionState>
              >,
              Map<PermissionKind, PermissionState>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
