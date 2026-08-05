// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'composer_targets_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 컴포저에서 고를 수 있는 주변 대상(관광지) 목록.
///
/// **왜 spot 도메인을 쓰지 않는가.** 관광지 검색·좋아요 목록은 `domain/spot`에 있지만
/// 커뮤니티가 그것을 import하면 기능 간 의존이 생긴다(CLAUDE.md §3 — 교차 import
/// 금지). 그렇다고 공용으로 끌어올릴 만큼 둘이 공유하는 것도 아니다.
///
/// 그래서 **커뮤니티가 이미 가진 데이터로 목록을 만든다**: 주변 글들의
/// [PostTarget]을 모아 중복을 없앤 것이다. "사람들이 글을 쓰고 있는 근처 장소"라
/// 컴포저의 선택지로도 자연스럽다.
///
/// 한계는 분명하다 — **글이 하나도 없는 장소는 고를 수 없다.** 지금 서버는 커넥션
/// 조회가 깨져 있어(피드가 오류 상태) 이 목록도 비는데, 그때 컴포저는 대상을
/// 고를 수 없다는 사실을 화면에 드러낸다. 관광지 검색이 필요해지면 그 시점에
/// `common/`으로 올릴 대상을 정하는 것이 순서다.

@ProviderFor(composerTargets)
const composerTargetsProvider = ComposerTargetsProvider._();

/// 컴포저에서 고를 수 있는 주변 대상(관광지) 목록.
///
/// **왜 spot 도메인을 쓰지 않는가.** 관광지 검색·좋아요 목록은 `domain/spot`에 있지만
/// 커뮤니티가 그것을 import하면 기능 간 의존이 생긴다(CLAUDE.md §3 — 교차 import
/// 금지). 그렇다고 공용으로 끌어올릴 만큼 둘이 공유하는 것도 아니다.
///
/// 그래서 **커뮤니티가 이미 가진 데이터로 목록을 만든다**: 주변 글들의
/// [PostTarget]을 모아 중복을 없앤 것이다. "사람들이 글을 쓰고 있는 근처 장소"라
/// 컴포저의 선택지로도 자연스럽다.
///
/// 한계는 분명하다 — **글이 하나도 없는 장소는 고를 수 없다.** 지금 서버는 커넥션
/// 조회가 깨져 있어(피드가 오류 상태) 이 목록도 비는데, 그때 컴포저는 대상을
/// 고를 수 없다는 사실을 화면에 드러낸다. 관광지 검색이 필요해지면 그 시점에
/// `common/`으로 올릴 대상을 정하는 것이 순서다.

final class ComposerTargetsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<PostTarget>>,
          List<PostTarget>,
          FutureOr<List<PostTarget>>
        >
    with $FutureModifier<List<PostTarget>>, $FutureProvider<List<PostTarget>> {
  /// 컴포저에서 고를 수 있는 주변 대상(관광지) 목록.
  ///
  /// **왜 spot 도메인을 쓰지 않는가.** 관광지 검색·좋아요 목록은 `domain/spot`에 있지만
  /// 커뮤니티가 그것을 import하면 기능 간 의존이 생긴다(CLAUDE.md §3 — 교차 import
  /// 금지). 그렇다고 공용으로 끌어올릴 만큼 둘이 공유하는 것도 아니다.
  ///
  /// 그래서 **커뮤니티가 이미 가진 데이터로 목록을 만든다**: 주변 글들의
  /// [PostTarget]을 모아 중복을 없앤 것이다. "사람들이 글을 쓰고 있는 근처 장소"라
  /// 컴포저의 선택지로도 자연스럽다.
  ///
  /// 한계는 분명하다 — **글이 하나도 없는 장소는 고를 수 없다.** 지금 서버는 커넥션
  /// 조회가 깨져 있어(피드가 오류 상태) 이 목록도 비는데, 그때 컴포저는 대상을
  /// 고를 수 없다는 사실을 화면에 드러낸다. 관광지 검색이 필요해지면 그 시점에
  /// `common/`으로 올릴 대상을 정하는 것이 순서다.
  const ComposerTargetsProvider._()
    : super(
        from: null,
        argument: null,
        retry: communityRetryPolicy,
        name: r'composerTargetsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$composerTargetsHash();

  @$internal
  @override
  $FutureProviderElement<List<PostTarget>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<PostTarget>> create(Ref ref) {
    return composerTargets(ref);
  }
}

String _$composerTargetsHash() => r'6fe01fd69fedb4d198e0e25be8ee3128fe69df3a';
