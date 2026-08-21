// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'library_tab_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 보관함의 상단 토글 상태(R18).
///
/// **탭을 떠나도 유지한다** — 다른 탭에 갔다 돌아오면 마지막으로 보던 쪽이 나온다.
/// 그래서 화면의 `State`가 아니라 provider가 들고 있고, `keepAlive`다.
///
/// 앱을 껐다 켜면 초기값으로 돌아간다. 스펙이 요구하는 것은 탭 사이 이동에서의
/// 유지이지 재실행 후 복원이 아니다(AC R17~R19).

@ProviderFor(LibraryTabController)
const libraryTabControllerProvider = LibraryTabControllerProvider._();

/// 보관함의 상단 토글 상태(R18).
///
/// **탭을 떠나도 유지한다** — 다른 탭에 갔다 돌아오면 마지막으로 보던 쪽이 나온다.
/// 그래서 화면의 `State`가 아니라 provider가 들고 있고, `keepAlive`다.
///
/// 앱을 껐다 켜면 초기값으로 돌아간다. 스펙이 요구하는 것은 탭 사이 이동에서의
/// 유지이지 재실행 후 복원이 아니다(AC R17~R19).
final class LibraryTabControllerProvider
    extends $NotifierProvider<LibraryTabController, LibraryTab> {
  /// 보관함의 상단 토글 상태(R18).
  ///
  /// **탭을 떠나도 유지한다** — 다른 탭에 갔다 돌아오면 마지막으로 보던 쪽이 나온다.
  /// 그래서 화면의 `State`가 아니라 provider가 들고 있고, `keepAlive`다.
  ///
  /// 앱을 껐다 켜면 초기값으로 돌아간다. 스펙이 요구하는 것은 탭 사이 이동에서의
  /// 유지이지 재실행 후 복원이 아니다(AC R17~R19).
  const LibraryTabControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'libraryTabControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$libraryTabControllerHash();

  @$internal
  @override
  LibraryTabController create() => LibraryTabController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LibraryTab value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LibraryTab>(value),
    );
  }
}

String _$libraryTabControllerHash() =>
    r'd01a7362ee9178a46b4f078e0c16ca44f98650c6';

/// 보관함의 상단 토글 상태(R18).
///
/// **탭을 떠나도 유지한다** — 다른 탭에 갔다 돌아오면 마지막으로 보던 쪽이 나온다.
/// 그래서 화면의 `State`가 아니라 provider가 들고 있고, `keepAlive`다.
///
/// 앱을 껐다 켜면 초기값으로 돌아간다. 스펙이 요구하는 것은 탭 사이 이동에서의
/// 유지이지 재실행 후 복원이 아니다(AC R17~R19).

abstract class _$LibraryTabController extends $Notifier<LibraryTab> {
  LibraryTab build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<LibraryTab, LibraryTab>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<LibraryTab, LibraryTab>,
              LibraryTab,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
