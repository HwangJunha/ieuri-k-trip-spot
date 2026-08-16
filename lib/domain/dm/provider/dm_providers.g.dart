// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dm_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// DM repository 하나의 출처(CLAUDE.md §5 — 위젯이 repository를 직접 만들지
/// 않는다). 테스트는 이 provider 하나만 오버라이드해 페이크를 주입한다.
///
/// **클라이언트를 둘 받는다.** 쿼리·뮤테이션은 HTTP, 구독만 WebSocket이다
/// (SPEC-0017 — 이 앱 최초의 Subscription).

@ProviderFor(dmRepository)
const dmRepositoryProvider = DmRepositoryProvider._();

/// DM repository 하나의 출처(CLAUDE.md §5 — 위젯이 repository를 직접 만들지
/// 않는다). 테스트는 이 provider 하나만 오버라이드해 페이크를 주입한다.
///
/// **클라이언트를 둘 받는다.** 쿼리·뮤테이션은 HTTP, 구독만 WebSocket이다
/// (SPEC-0017 — 이 앱 최초의 Subscription).

final class DmRepositoryProvider
    extends $FunctionalProvider<DmRepository, DmRepository, DmRepository>
    with $Provider<DmRepository> {
  /// DM repository 하나의 출처(CLAUDE.md §5 — 위젯이 repository를 직접 만들지
  /// 않는다). 테스트는 이 provider 하나만 오버라이드해 페이크를 주입한다.
  ///
  /// **클라이언트를 둘 받는다.** 쿼리·뮤테이션은 HTTP, 구독만 WebSocket이다
  /// (SPEC-0017 — 이 앱 최초의 Subscription).
  const DmRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dmRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dmRepositoryHash();

  @$internal
  @override
  $ProviderElement<DmRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  DmRepository create(Ref ref) {
    return dmRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DmRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DmRepository>(value),
    );
  }
}

String _$dmRepositoryHash() => r'9bea8d2f1d738d057c63c28404b2dc05da69e20d';
