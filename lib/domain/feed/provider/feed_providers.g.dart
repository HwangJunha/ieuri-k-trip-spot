// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feed_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 피드 repository 하나의 출처(CLAUDE.md §5 — 위젯이 repository를 직접 만들지
/// 않는다). 테스트는 이 provider 하나만 오버라이드해 페이크를 주입한다.
///
/// **구현체가 아직 없다.** 서버의 SPEC-0017이 배포되지 않아 GraphQL 오퍼레이션을
/// 생성할 수 없다(CLAUDE.md §13). 서버가 준비되면 여기서 `FeedRepositoryImpl`을
/// 돌려주도록 바꾸는 것으로 끝나고, 위 계층은 손대지 않는다.

@ProviderFor(feedRepository)
const feedRepositoryProvider = FeedRepositoryProvider._();

/// 피드 repository 하나의 출처(CLAUDE.md §5 — 위젯이 repository를 직접 만들지
/// 않는다). 테스트는 이 provider 하나만 오버라이드해 페이크를 주입한다.
///
/// **구현체가 아직 없다.** 서버의 SPEC-0017이 배포되지 않아 GraphQL 오퍼레이션을
/// 생성할 수 없다(CLAUDE.md §13). 서버가 준비되면 여기서 `FeedRepositoryImpl`을
/// 돌려주도록 바꾸는 것으로 끝나고, 위 계층은 손대지 않는다.

final class FeedRepositoryProvider
    extends $FunctionalProvider<FeedRepository, FeedRepository, FeedRepository>
    with $Provider<FeedRepository> {
  /// 피드 repository 하나의 출처(CLAUDE.md §5 — 위젯이 repository를 직접 만들지
  /// 않는다). 테스트는 이 provider 하나만 오버라이드해 페이크를 주입한다.
  ///
  /// **구현체가 아직 없다.** 서버의 SPEC-0017이 배포되지 않아 GraphQL 오퍼레이션을
  /// 생성할 수 없다(CLAUDE.md §13). 서버가 준비되면 여기서 `FeedRepositoryImpl`을
  /// 돌려주도록 바꾸는 것으로 끝나고, 위 계층은 손대지 않는다.
  const FeedRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'feedRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$feedRepositoryHash();

  @$internal
  @override
  $ProviderElement<FeedRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  FeedRepository create(Ref ref) {
    return feedRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FeedRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FeedRepository>(value),
    );
  }
}

String _$feedRepositoryHash() => r'e0d9cb4968354d95effaeb2b099b0273860c29a4';

/// 둘러보기 탭에서 지금 보고 있는 화면(R5).
///
/// **이 provider는 어느 쪽을 그릴지만 안다.** 두 화면의 데이터는 각자의 provider가
/// 따로 들고 있어서, 전환해도 상태가 유지되고(AC5-1) 한쪽의 실패가 다른 쪽을
/// 막지 않는다(AC5-3). 토글이 두 화면의 상태까지 소유하면 그 격리가 깨진다.
///
/// keepAlive인 이유는 커뮤니티의 카테고리·정렬 선택과 같다 — 사용자가 고른 화면은
/// 위젯이 아니라 세션에 속한다. autoDispose면 spot 상세에 다녀오는 것만으로
/// 추천으로 되돌아간다.

@ProviderFor(SelectedDiscoverSegment)
const selectedDiscoverSegmentProvider = SelectedDiscoverSegmentProvider._();

/// 둘러보기 탭에서 지금 보고 있는 화면(R5).
///
/// **이 provider는 어느 쪽을 그릴지만 안다.** 두 화면의 데이터는 각자의 provider가
/// 따로 들고 있어서, 전환해도 상태가 유지되고(AC5-1) 한쪽의 실패가 다른 쪽을
/// 막지 않는다(AC5-3). 토글이 두 화면의 상태까지 소유하면 그 격리가 깨진다.
///
/// keepAlive인 이유는 커뮤니티의 카테고리·정렬 선택과 같다 — 사용자가 고른 화면은
/// 위젯이 아니라 세션에 속한다. autoDispose면 spot 상세에 다녀오는 것만으로
/// 추천으로 되돌아간다.
final class SelectedDiscoverSegmentProvider
    extends $NotifierProvider<SelectedDiscoverSegment, DiscoverSegment> {
  /// 둘러보기 탭에서 지금 보고 있는 화면(R5).
  ///
  /// **이 provider는 어느 쪽을 그릴지만 안다.** 두 화면의 데이터는 각자의 provider가
  /// 따로 들고 있어서, 전환해도 상태가 유지되고(AC5-1) 한쪽의 실패가 다른 쪽을
  /// 막지 않는다(AC5-3). 토글이 두 화면의 상태까지 소유하면 그 격리가 깨진다.
  ///
  /// keepAlive인 이유는 커뮤니티의 카테고리·정렬 선택과 같다 — 사용자가 고른 화면은
  /// 위젯이 아니라 세션에 속한다. autoDispose면 spot 상세에 다녀오는 것만으로
  /// 추천으로 되돌아간다.
  const SelectedDiscoverSegmentProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedDiscoverSegmentProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedDiscoverSegmentHash();

  @$internal
  @override
  SelectedDiscoverSegment create() => SelectedDiscoverSegment();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DiscoverSegment value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DiscoverSegment>(value),
    );
  }
}

String _$selectedDiscoverSegmentHash() =>
    r'fce01c3585ea23bca9542200da5dce22541d7771';

/// 둘러보기 탭에서 지금 보고 있는 화면(R5).
///
/// **이 provider는 어느 쪽을 그릴지만 안다.** 두 화면의 데이터는 각자의 provider가
/// 따로 들고 있어서, 전환해도 상태가 유지되고(AC5-1) 한쪽의 실패가 다른 쪽을
/// 막지 않는다(AC5-3). 토글이 두 화면의 상태까지 소유하면 그 격리가 깨진다.
///
/// keepAlive인 이유는 커뮤니티의 카테고리·정렬 선택과 같다 — 사용자가 고른 화면은
/// 위젯이 아니라 세션에 속한다. autoDispose면 spot 상세에 다녀오는 것만으로
/// 추천으로 되돌아간다.

abstract class _$SelectedDiscoverSegment extends $Notifier<DiscoverSegment> {
  DiscoverSegment build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<DiscoverSegment, DiscoverSegment>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<DiscoverSegment, DiscoverSegment>,
              DiscoverSegment,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
