// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'permission_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// [PermissionService]를 노출한다. provider 뒤에 두어 부트 코디네이터가 직접
/// 생성하지 않고 읽으며(never construct), 테스트는 실제 `permission_handler`
/// 플러그인 대신 fake로 override 한다 (CLAUDE.md §5). autoDispose(기본값): const
/// 무상태 래퍼라 살아남을 게 없다.

@ProviderFor(permissionService)
const permissionServiceProvider = PermissionServiceProvider._();

/// [PermissionService]를 노출한다. provider 뒤에 두어 부트 코디네이터가 직접
/// 생성하지 않고 읽으며(never construct), 테스트는 실제 `permission_handler`
/// 플러그인 대신 fake로 override 한다 (CLAUDE.md §5). autoDispose(기본값): const
/// 무상태 래퍼라 살아남을 게 없다.

final class PermissionServiceProvider
    extends
        $FunctionalProvider<
          PermissionService,
          PermissionService,
          PermissionService
        >
    with $Provider<PermissionService> {
  /// [PermissionService]를 노출한다. provider 뒤에 두어 부트 코디네이터가 직접
  /// 생성하지 않고 읽으며(never construct), 테스트는 실제 `permission_handler`
  /// 플러그인 대신 fake로 override 한다 (CLAUDE.md §5). autoDispose(기본값): const
  /// 무상태 래퍼라 살아남을 게 없다.
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

/// 최초 실행 권한 시퀀스(위치 → 알림)가 끝까지 실행됐는지 여부. 스플래시는 라우팅 전에
/// 이 값을 기다린다 — 그래야 위치가 허용되는 순간(시퀀스 중간, 선택 권한인 알림 프롬프트가
/// 아직 남은 시점)에 곧바로 떠나버리지 않는다 (SPEC-0001 §최초실행, R2 순차).
///
/// keepAlive: 스플래시보다 오래 살아야 하는 부트 시퀀스 래치. 한 번 켜지면 세션 동안
/// 다시 꺼지지 않는다.

@ProviderFor(PermissionBootComplete)
const permissionBootCompleteProvider = PermissionBootCompleteProvider._();

/// 최초 실행 권한 시퀀스(위치 → 알림)가 끝까지 실행됐는지 여부. 스플래시는 라우팅 전에
/// 이 값을 기다린다 — 그래야 위치가 허용되는 순간(시퀀스 중간, 선택 권한인 알림 프롬프트가
/// 아직 남은 시점)에 곧바로 떠나버리지 않는다 (SPEC-0001 §최초실행, R2 순차).
///
/// keepAlive: 스플래시보다 오래 살아야 하는 부트 시퀀스 래치. 한 번 켜지면 세션 동안
/// 다시 꺼지지 않는다.
final class PermissionBootCompleteProvider
    extends $NotifierProvider<PermissionBootComplete, bool> {
  /// 최초 실행 권한 시퀀스(위치 → 알림)가 끝까지 실행됐는지 여부. 스플래시는 라우팅 전에
  /// 이 값을 기다린다 — 그래야 위치가 허용되는 순간(시퀀스 중간, 선택 권한인 알림 프롬프트가
  /// 아직 남은 시점)에 곧바로 떠나버리지 않는다 (SPEC-0001 §최초실행, R2 순차).
  ///
  /// keepAlive: 스플래시보다 오래 살아야 하는 부트 시퀀스 래치. 한 번 켜지면 세션 동안
  /// 다시 꺼지지 않는다.
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

/// 최초 실행 권한 시퀀스(위치 → 알림)가 끝까지 실행됐는지 여부. 스플래시는 라우팅 전에
/// 이 값을 기다린다 — 그래야 위치가 허용되는 순간(시퀀스 중간, 선택 권한인 알림 프롬프트가
/// 아직 남은 시점)에 곧바로 떠나버리지 않는다 (SPEC-0001 §최초실행, R2 순차).
///
/// keepAlive: 스플래시보다 오래 살아야 하는 부트 시퀀스 래치. 한 번 켜지면 세션 동안
/// 다시 꺼지지 않는다.

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

/// 앱 전역 런타임 권한 상태 (SPEC-0001 §영구거부처리): [PermissionKind]별 마지막으로
/// 알려진 [PermissionState]. 빈 상태(아직 아무것도 조회 안 함)로 시작한다.
///
/// keepAlive: 권한 상태는 한 화면보다 오래 사는 부트 시퀀스 관심사다 — 이후 기능들이
/// "설정 열기" 경로 노출 여부를 판단하려고 읽고(R5), 앱 resume 훅이 이를 갱신한다
/// (CLAUDE.md §5 근거). 메모리에만 둔다: OS가 진실의 원천이므로 저장하지 않고 다시
/// 조회한다 (스펙 — "상태만 보관").

@ProviderFor(PermissionController)
const permissionControllerProvider = PermissionControllerProvider._();

/// 앱 전역 런타임 권한 상태 (SPEC-0001 §영구거부처리): [PermissionKind]별 마지막으로
/// 알려진 [PermissionState]. 빈 상태(아직 아무것도 조회 안 함)로 시작한다.
///
/// keepAlive: 권한 상태는 한 화면보다 오래 사는 부트 시퀀스 관심사다 — 이후 기능들이
/// "설정 열기" 경로 노출 여부를 판단하려고 읽고(R5), 앱 resume 훅이 이를 갱신한다
/// (CLAUDE.md §5 근거). 메모리에만 둔다: OS가 진실의 원천이므로 저장하지 않고 다시
/// 조회한다 (스펙 — "상태만 보관").
final class PermissionControllerProvider
    extends
        $NotifierProvider<
          PermissionController,
          Map<PermissionKind, PermissionState>
        > {
  /// 앱 전역 런타임 권한 상태 (SPEC-0001 §영구거부처리): [PermissionKind]별 마지막으로
  /// 알려진 [PermissionState]. 빈 상태(아직 아무것도 조회 안 함)로 시작한다.
  ///
  /// keepAlive: 권한 상태는 한 화면보다 오래 사는 부트 시퀀스 관심사다 — 이후 기능들이
  /// "설정 열기" 경로 노출 여부를 판단하려고 읽고(R5), 앱 resume 훅이 이를 갱신한다
  /// (CLAUDE.md §5 근거). 메모리에만 둔다: OS가 진실의 원천이므로 저장하지 않고 다시
  /// 조회한다 (스펙 — "상태만 보관").
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

/// 앱 전역 런타임 권한 상태 (SPEC-0001 §영구거부처리): [PermissionKind]별 마지막으로
/// 알려진 [PermissionState]. 빈 상태(아직 아무것도 조회 안 함)로 시작한다.
///
/// keepAlive: 권한 상태는 한 화면보다 오래 사는 부트 시퀀스 관심사다 — 이후 기능들이
/// "설정 열기" 경로 노출 여부를 판단하려고 읽고(R5), 앱 resume 훅이 이를 갱신한다
/// (CLAUDE.md §5 근거). 메모리에만 둔다: OS가 진실의 원천이므로 저장하지 않고 다시
/// 조회한다 (스펙 — "상태만 보관").

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
