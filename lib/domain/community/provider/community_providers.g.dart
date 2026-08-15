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

/// 상단 칩 구성(가이드 §2). **빈 목록이 정상**이므로 빈 결과를 오류로 다루지 않는다 —
/// 구성이 없는 앱이면 비어 오고, 칩 영역이 비는 레이아웃을 화면이 허용해야 한다.
///
/// **서버가 준 순서를 그대로 쓰지 않는다** — 코드 알파벳순일 뿐이라 언어를 바꾸면
/// 같은 칩이 다른 자리로 간다. 표시 순서는 그리는 쪽이 `kCategoryDisplayOrder`로 잡는다.
///
/// 피드와 **분리된 provider**인 이유는 실패가 서로를 가리지 않게 하기 위해서다.
/// 칩 조회가 실패해도 피드는 그대로 뜨고, 그 반대도 같다.

@ProviderFor(communityChips)
const communityChipsProvider = CommunityChipsProvider._();

/// 상단 칩 구성(가이드 §2). **빈 목록이 정상**이므로 빈 결과를 오류로 다루지 않는다 —
/// 구성이 없는 앱이면 비어 오고, 칩 영역이 비는 레이아웃을 화면이 허용해야 한다.
///
/// **서버가 준 순서를 그대로 쓰지 않는다** — 코드 알파벳순일 뿐이라 언어를 바꾸면
/// 같은 칩이 다른 자리로 간다. 표시 순서는 그리는 쪽이 `kCategoryDisplayOrder`로 잡는다.
///
/// 피드와 **분리된 provider**인 이유는 실패가 서로를 가리지 않게 하기 위해서다.
/// 칩 조회가 실패해도 피드는 그대로 뜨고, 그 반대도 같다.

final class CommunityChipsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<TargetCategory>>,
          List<TargetCategory>,
          FutureOr<List<TargetCategory>>
        >
    with
        $FutureModifier<List<TargetCategory>>,
        $FutureProvider<List<TargetCategory>> {
  /// 상단 칩 구성(가이드 §2). **빈 목록이 정상**이므로 빈 결과를 오류로 다루지 않는다 —
  /// 구성이 없는 앱이면 비어 오고, 칩 영역이 비는 레이아웃을 화면이 허용해야 한다.
  ///
  /// **서버가 준 순서를 그대로 쓰지 않는다** — 코드 알파벳순일 뿐이라 언어를 바꾸면
  /// 같은 칩이 다른 자리로 간다. 표시 순서는 그리는 쪽이 `kCategoryDisplayOrder`로 잡는다.
  ///
  /// 피드와 **분리된 provider**인 이유는 실패가 서로를 가리지 않게 하기 위해서다.
  /// 칩 조회가 실패해도 피드는 그대로 뜨고, 그 반대도 같다.
  const CommunityChipsProvider._()
    : super(
        from: null,
        argument: null,
        retry: communityRetryPolicy,
        name: r'communityChipsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$communityChipsHash();

  @$internal
  @override
  $FutureProviderElement<List<TargetCategory>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<TargetCategory>> create(Ref ref) {
    return communityChips(ref);
  }
}

String _$communityChipsHash() => r'484095824303e1a43df876c6d9bc9a43ab15d044';
