// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'community_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 커뮤니티 repository 하나의 출처(CLAUDE.md §5 — 위젯이 repository를 직접 만들지
/// 않는다). 테스트는 이 provider 하나만 오버라이드해 페이크를 주입한다.

@ProviderFor(communityRepository)
const communityRepositoryProvider = CommunityRepositoryProvider._();

/// 커뮤니티 repository 하나의 출처(CLAUDE.md §5 — 위젯이 repository를 직접 만들지
/// 않는다). 테스트는 이 provider 하나만 오버라이드해 페이크를 주입한다.

final class CommunityRepositoryProvider
    extends
        $FunctionalProvider<
          CommunityRepository,
          CommunityRepository,
          CommunityRepository
        >
    with $Provider<CommunityRepository> {
  /// 커뮤니티 repository 하나의 출처(CLAUDE.md §5 — 위젯이 repository를 직접 만들지
  /// 않는다). 테스트는 이 provider 하나만 오버라이드해 페이크를 주입한다.
  const CommunityRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'communityRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$communityRepositoryHash();

  @$internal
  @override
  $ProviderElement<CommunityRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CommunityRepository create(Ref ref) {
    return communityRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CommunityRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CommunityRepository>(value),
    );
  }
}

String _$communityRepositoryHash() =>
    r'7986e4e6d2a4317266b467814894b5d4d235f38d';

/// 탐색 타일(R11). **빈 목록이 정상**이므로 빈 결과를 오류로 다루지 않는다 —
/// 어드민이 아직 없고, 활성 언어의 타일이 없으면 다른 언어로 대체되지 않는다
/// (가이드 §10·§15). 화면은 타일 영역이 비는 경우를 허용해야 한다.
///
/// 피드와 **분리된 provider**인 이유는 실패가 서로를 가리지 않게 하기 위해서다.
/// 지금 서버는 커넥션 조회만 깨져 있어 타일은 정상으로 내려오는데, 하나로 묶었으면
/// 화면 전체가 오류가 됐을 것이다.

@ProviderFor(discoveryTiles)
const discoveryTilesProvider = DiscoveryTilesProvider._();

/// 탐색 타일(R11). **빈 목록이 정상**이므로 빈 결과를 오류로 다루지 않는다 —
/// 어드민이 아직 없고, 활성 언어의 타일이 없으면 다른 언어로 대체되지 않는다
/// (가이드 §10·§15). 화면은 타일 영역이 비는 경우를 허용해야 한다.
///
/// 피드와 **분리된 provider**인 이유는 실패가 서로를 가리지 않게 하기 위해서다.
/// 지금 서버는 커넥션 조회만 깨져 있어 타일은 정상으로 내려오는데, 하나로 묶었으면
/// 화면 전체가 오류가 됐을 것이다.

final class DiscoveryTilesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<DiscoveryTile>>,
          List<DiscoveryTile>,
          FutureOr<List<DiscoveryTile>>
        >
    with
        $FutureModifier<List<DiscoveryTile>>,
        $FutureProvider<List<DiscoveryTile>> {
  /// 탐색 타일(R11). **빈 목록이 정상**이므로 빈 결과를 오류로 다루지 않는다 —
  /// 어드민이 아직 없고, 활성 언어의 타일이 없으면 다른 언어로 대체되지 않는다
  /// (가이드 §10·§15). 화면은 타일 영역이 비는 경우를 허용해야 한다.
  ///
  /// 피드와 **분리된 provider**인 이유는 실패가 서로를 가리지 않게 하기 위해서다.
  /// 지금 서버는 커넥션 조회만 깨져 있어 타일은 정상으로 내려오는데, 하나로 묶었으면
  /// 화면 전체가 오류가 됐을 것이다.
  const DiscoveryTilesProvider._()
    : super(
        from: null,
        argument: null,
        retry: communityRetryPolicy,
        name: r'discoveryTilesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$discoveryTilesHash();

  @$internal
  @override
  $FutureProviderElement<List<DiscoveryTile>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<DiscoveryTile>> create(Ref ref) {
    return discoveryTiles(ref);
  }
}

String _$discoveryTilesHash() => r'443a4e2fadca55fe3da92a5423fe16f7f36c03e9';
