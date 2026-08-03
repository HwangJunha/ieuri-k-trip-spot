// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'swipe_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 활성 언어에서 서버가 노출하는 카테고리 목록(spec §5). 서버가 가용성의 단일
/// 출처이므로 CategoryBar는 이 결과만 렌더한다. 언어(locale)에 의존하므로 언어가
/// 바뀌면 자동 재조회된다.

@ProviderFor(availableSpotCategories)
const availableSpotCategoriesProvider = AvailableSpotCategoriesProvider._();

/// 활성 언어에서 서버가 노출하는 카테고리 목록(spec §5). 서버가 가용성의 단일
/// 출처이므로 CategoryBar는 이 결과만 렌더한다. 언어(locale)에 의존하므로 언어가
/// 바뀌면 자동 재조회된다.

final class AvailableSpotCategoriesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<SpotCategory>>,
          List<SpotCategory>,
          FutureOr<List<SpotCategory>>
        >
    with
        $FutureModifier<List<SpotCategory>>,
        $FutureProvider<List<SpotCategory>> {
  /// 활성 언어에서 서버가 노출하는 카테고리 목록(spec §5). 서버가 가용성의 단일
  /// 출처이므로 CategoryBar는 이 결과만 렌더한다. 언어(locale)에 의존하므로 언어가
  /// 바뀌면 자동 재조회된다.
  const AvailableSpotCategoriesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'availableSpotCategoriesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$availableSpotCategoriesHash();

  @$internal
  @override
  $FutureProviderElement<List<SpotCategory>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<SpotCategory>> create(Ref ref) {
    return availableSpotCategories(ref);
  }
}

String _$availableSpotCategoriesHash() =>
    r'fc2f7f8ea17881476c5db007d85ddb5c5060dc3d';

/// 현재 선택된 카테고리(null=전체). CategoryBar가 갱신하고 SwipeController 패밀리
/// 인자로 쓰인다 — 값이 바뀌면 다른 SwipeController 인스턴스를 보게 되어 재로딩된다.

@ProviderFor(SelectedSpotCategory)
const selectedSpotCategoryProvider = SelectedSpotCategoryProvider._();

/// 현재 선택된 카테고리(null=전체). CategoryBar가 갱신하고 SwipeController 패밀리
/// 인자로 쓰인다 — 값이 바뀌면 다른 SwipeController 인스턴스를 보게 되어 재로딩된다.
final class SelectedSpotCategoryProvider
    extends $NotifierProvider<SelectedSpotCategory, SpotCategory?> {
  /// 현재 선택된 카테고리(null=전체). CategoryBar가 갱신하고 SwipeController 패밀리
  /// 인자로 쓰인다 — 값이 바뀌면 다른 SwipeController 인스턴스를 보게 되어 재로딩된다.
  const SelectedSpotCategoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedSpotCategoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedSpotCategoryHash();

  @$internal
  @override
  SelectedSpotCategory create() => SelectedSpotCategory();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SpotCategory? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SpotCategory?>(value),
    );
  }
}

String _$selectedSpotCategoryHash() =>
    r'3b37c0b6064ed5ba5bc46349b6eed19b9dd9fe69';

/// 현재 선택된 카테고리(null=전체). CategoryBar가 갱신하고 SwipeController 패밀리
/// 인자로 쓰인다 — 값이 바뀌면 다른 SwipeController 인스턴스를 보게 되어 재로딩된다.

abstract class _$SelectedSpotCategory extends $Notifier<SpotCategory?> {
  SpotCategory? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<SpotCategory?, SpotCategory?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SpotCategory?, SpotCategory?>,
              SpotCategory?,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// Discover 스와이프 카드 스택 컨트롤러(spec §4). [category]별 패밀리 —
/// 카테고리 변경은 다른 인스턴스 로딩으로 이어진다.
///
/// - 첫 빌드: 현재 좌표를 얻어 첫 페이지(page 0, size 100)를 조회해 [SwipeQueue]를 만든다.
/// - [swipe]: 낙관적으로 맨 위 카드를 즉시 제거하고 `reactToSpot`을 비동기 발사한다.
///   실패해도 카드를 복원하지 않고 조용히 로깅한다(좋아요 실패는 비치명적).
/// - 잔여 [_prefetchThreshold] 미만이고 다음 페이지가 있으면 백그라운드로 이어 붙인다.
/// - 소진: 큐가 비고 `hasNext=false`면 [SwipeQueue.isExhausted]로 빈 상태.
/// [retry]로 자동 재시도를 1회로 묶는다(R1). Riverpod 기본값은 최대 10회 지수 백오프라
/// 실패 상태에서 조회가 폭주하는데, 그 폭주의 실제 경로가 여기다(설계문서 §2.1).

@ProviderFor(SwipeController)
const swipeControllerProvider = SwipeControllerFamily._();

/// Discover 스와이프 카드 스택 컨트롤러(spec §4). [category]별 패밀리 —
/// 카테고리 변경은 다른 인스턴스 로딩으로 이어진다.
///
/// - 첫 빌드: 현재 좌표를 얻어 첫 페이지(page 0, size 100)를 조회해 [SwipeQueue]를 만든다.
/// - [swipe]: 낙관적으로 맨 위 카드를 즉시 제거하고 `reactToSpot`을 비동기 발사한다.
///   실패해도 카드를 복원하지 않고 조용히 로깅한다(좋아요 실패는 비치명적).
/// - 잔여 [_prefetchThreshold] 미만이고 다음 페이지가 있으면 백그라운드로 이어 붙인다.
/// - 소진: 큐가 비고 `hasNext=false`면 [SwipeQueue.isExhausted]로 빈 상태.
/// [retry]로 자동 재시도를 1회로 묶는다(R1). Riverpod 기본값은 최대 10회 지수 백오프라
/// 실패 상태에서 조회가 폭주하는데, 그 폭주의 실제 경로가 여기다(설계문서 §2.1).
final class SwipeControllerProvider
    extends $AsyncNotifierProvider<SwipeController, SwipeQueue> {
  /// Discover 스와이프 카드 스택 컨트롤러(spec §4). [category]별 패밀리 —
  /// 카테고리 변경은 다른 인스턴스 로딩으로 이어진다.
  ///
  /// - 첫 빌드: 현재 좌표를 얻어 첫 페이지(page 0, size 100)를 조회해 [SwipeQueue]를 만든다.
  /// - [swipe]: 낙관적으로 맨 위 카드를 즉시 제거하고 `reactToSpot`을 비동기 발사한다.
  ///   실패해도 카드를 복원하지 않고 조용히 로깅한다(좋아요 실패는 비치명적).
  /// - 잔여 [_prefetchThreshold] 미만이고 다음 페이지가 있으면 백그라운드로 이어 붙인다.
  /// - 소진: 큐가 비고 `hasNext=false`면 [SwipeQueue.isExhausted]로 빈 상태.
  /// [retry]로 자동 재시도를 1회로 묶는다(R1). Riverpod 기본값은 최대 10회 지수 백오프라
  /// 실패 상태에서 조회가 폭주하는데, 그 폭주의 실제 경로가 여기다(설계문서 §2.1).
  const SwipeControllerProvider._({
    required SwipeControllerFamily super.from,
    required SpotCategory? super.argument,
  }) : super(
         retry: spotRetryPolicy,
         name: r'swipeControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$swipeControllerHash();

  @override
  String toString() {
    return r'swipeControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  SwipeController create() => SwipeController();

  @override
  bool operator ==(Object other) {
    return other is SwipeControllerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$swipeControllerHash() => r'02826f307d4bddfb12c083466aaf41f82d98635a';

/// Discover 스와이프 카드 스택 컨트롤러(spec §4). [category]별 패밀리 —
/// 카테고리 변경은 다른 인스턴스 로딩으로 이어진다.
///
/// - 첫 빌드: 현재 좌표를 얻어 첫 페이지(page 0, size 100)를 조회해 [SwipeQueue]를 만든다.
/// - [swipe]: 낙관적으로 맨 위 카드를 즉시 제거하고 `reactToSpot`을 비동기 발사한다.
///   실패해도 카드를 복원하지 않고 조용히 로깅한다(좋아요 실패는 비치명적).
/// - 잔여 [_prefetchThreshold] 미만이고 다음 페이지가 있으면 백그라운드로 이어 붙인다.
/// - 소진: 큐가 비고 `hasNext=false`면 [SwipeQueue.isExhausted]로 빈 상태.
/// [retry]로 자동 재시도를 1회로 묶는다(R1). Riverpod 기본값은 최대 10회 지수 백오프라
/// 실패 상태에서 조회가 폭주하는데, 그 폭주의 실제 경로가 여기다(설계문서 §2.1).

final class SwipeControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          SwipeController,
          AsyncValue<SwipeQueue>,
          SwipeQueue,
          FutureOr<SwipeQueue>,
          SpotCategory?
        > {
  const SwipeControllerFamily._()
    : super(
        retry: spotRetryPolicy,
        name: r'swipeControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Discover 스와이프 카드 스택 컨트롤러(spec §4). [category]별 패밀리 —
  /// 카테고리 변경은 다른 인스턴스 로딩으로 이어진다.
  ///
  /// - 첫 빌드: 현재 좌표를 얻어 첫 페이지(page 0, size 100)를 조회해 [SwipeQueue]를 만든다.
  /// - [swipe]: 낙관적으로 맨 위 카드를 즉시 제거하고 `reactToSpot`을 비동기 발사한다.
  ///   실패해도 카드를 복원하지 않고 조용히 로깅한다(좋아요 실패는 비치명적).
  /// - 잔여 [_prefetchThreshold] 미만이고 다음 페이지가 있으면 백그라운드로 이어 붙인다.
  /// - 소진: 큐가 비고 `hasNext=false`면 [SwipeQueue.isExhausted]로 빈 상태.
  /// [retry]로 자동 재시도를 1회로 묶는다(R1). Riverpod 기본값은 최대 10회 지수 백오프라
  /// 실패 상태에서 조회가 폭주하는데, 그 폭주의 실제 경로가 여기다(설계문서 §2.1).

  SwipeControllerProvider call(SpotCategory? category) =>
      SwipeControllerProvider._(argument: category, from: this);

  @override
  String toString() => r'swipeControllerProvider';
}

/// Discover 스와이프 카드 스택 컨트롤러(spec §4). [category]별 패밀리 —
/// 카테고리 변경은 다른 인스턴스 로딩으로 이어진다.
///
/// - 첫 빌드: 현재 좌표를 얻어 첫 페이지(page 0, size 100)를 조회해 [SwipeQueue]를 만든다.
/// - [swipe]: 낙관적으로 맨 위 카드를 즉시 제거하고 `reactToSpot`을 비동기 발사한다.
///   실패해도 카드를 복원하지 않고 조용히 로깅한다(좋아요 실패는 비치명적).
/// - 잔여 [_prefetchThreshold] 미만이고 다음 페이지가 있으면 백그라운드로 이어 붙인다.
/// - 소진: 큐가 비고 `hasNext=false`면 [SwipeQueue.isExhausted]로 빈 상태.
/// [retry]로 자동 재시도를 1회로 묶는다(R1). Riverpod 기본값은 최대 10회 지수 백오프라
/// 실패 상태에서 조회가 폭주하는데, 그 폭주의 실제 경로가 여기다(설계문서 §2.1).

abstract class _$SwipeController extends $AsyncNotifier<SwipeQueue> {
  late final _$args = ref.$arg as SpotCategory?;
  SpotCategory? get category => _$args;

  FutureOr<SwipeQueue> build(SpotCategory? category);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
    final ref = this.ref as $Ref<AsyncValue<SwipeQueue>, SwipeQueue>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<SwipeQueue>, SwipeQueue>,
              AsyncValue<SwipeQueue>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
