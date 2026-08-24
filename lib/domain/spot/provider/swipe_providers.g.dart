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

/// Discover 스와이프의 카테고리 선택(SPEC-0020 R2). **비어 있을 수 없는 집합이다** —
/// "전체 보기"가 사라졌으므로 `null`("필터 없음")이라는 표현 자체가 없다.
///
/// [SwipeController]와 같은 이유로 `keepAlive`다 — autoDispose면 다른 탭에 다녀오는
/// 것만으로 선택이 초기화된다. 사용자가 고른 필터는 화면이 아니라 세션에 속한다
/// (AC12.3). R12의 "비영속"은 **재시작 기준**이라(AC12.2) 세션 내 유지와 충돌하지
/// 않는다 — 디스크에 쓰지 않는 것만을 요구한다.

@ProviderFor(SelectedSpotCategory)
const selectedSpotCategoryProvider = SelectedSpotCategoryProvider._();

/// Discover 스와이프의 카테고리 선택(SPEC-0020 R2). **비어 있을 수 없는 집합이다** —
/// "전체 보기"가 사라졌으므로 `null`("필터 없음")이라는 표현 자체가 없다.
///
/// [SwipeController]와 같은 이유로 `keepAlive`다 — autoDispose면 다른 탭에 다녀오는
/// 것만으로 선택이 초기화된다. 사용자가 고른 필터는 화면이 아니라 세션에 속한다
/// (AC12.3). R12의 "비영속"은 **재시작 기준**이라(AC12.2) 세션 내 유지와 충돌하지
/// 않는다 — 디스크에 쓰지 않는 것만을 요구한다.
final class SelectedSpotCategoryProvider
    extends $NotifierProvider<SelectedSpotCategory, Set<SpotCategory>> {
  /// Discover 스와이프의 카테고리 선택(SPEC-0020 R2). **비어 있을 수 없는 집합이다** —
  /// "전체 보기"가 사라졌으므로 `null`("필터 없음")이라는 표현 자체가 없다.
  ///
  /// [SwipeController]와 같은 이유로 `keepAlive`다 — autoDispose면 다른 탭에 다녀오는
  /// 것만으로 선택이 초기화된다. 사용자가 고른 필터는 화면이 아니라 세션에 속한다
  /// (AC12.3). R12의 "비영속"은 **재시작 기준**이라(AC12.2) 세션 내 유지와 충돌하지
  /// 않는다 — 디스크에 쓰지 않는 것만을 요구한다.
  const SelectedSpotCategoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedSpotCategoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedSpotCategoryHash();

  @$internal
  @override
  SelectedSpotCategory create() => SelectedSpotCategory();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Set<SpotCategory> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Set<SpotCategory>>(value),
    );
  }
}

String _$selectedSpotCategoryHash() =>
    r'521be5ec397fe4a748f419007d1883b2ae05bcd7';

/// Discover 스와이프의 카테고리 선택(SPEC-0020 R2). **비어 있을 수 없는 집합이다** —
/// "전체 보기"가 사라졌으므로 `null`("필터 없음")이라는 표현 자체가 없다.
///
/// [SwipeController]와 같은 이유로 `keepAlive`다 — autoDispose면 다른 탭에 다녀오는
/// 것만으로 선택이 초기화된다. 사용자가 고른 필터는 화면이 아니라 세션에 속한다
/// (AC12.3). R12의 "비영속"은 **재시작 기준**이라(AC12.2) 세션 내 유지와 충돌하지
/// 않는다 — 디스크에 쓰지 않는 것만을 요구한다.

abstract class _$SelectedSpotCategory extends $Notifier<Set<SpotCategory>> {
  Set<SpotCategory> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<Set<SpotCategory>, Set<SpotCategory>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Set<SpotCategory>, Set<SpotCategory>>,
              Set<SpotCategory>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// Discover 스와이프 카드 스택 컨트롤러(spec §4). [selection]별 패밀리 —
/// 선택 변경은 다른 인스턴스 로딩으로 이어진다.
///
/// **family 인자가 `Set`이 아니라 [SpotCategorySelection]인 이유**(SPEC-0020):
/// Dart의 `Set`은 값 동등성이 없어, 원소가 같아도 매 빌드마다 새 키가 되어
/// keepAlive 세션이 무한히 쌓이고 피드를 계속 다시 받는다. 정렬된 코드 문자열로
/// 동등성을 정의한 값 객체가 그것을 막는다.
///
/// - 첫 빌드: 현재 좌표를 얻어 첫 페이지(page 0, size 100)를 조회해 [SwipeQueue]를 만든다.
/// - [swipe]: 낙관적으로 맨 위 카드를 즉시 제거하고 `reactToSpot`을 비동기 발사한다.
///   실패해도 카드를 복원하지 않고 조용히 로깅한다(좋아요 실패는 비치명적).
/// - 잔여 [_prefetchThreshold] 미만이고 다음 페이지가 있으면 백그라운드로 이어 붙인다.
/// - 소진: 큐가 비고 `hasNext=false`면 [SwipeQueue.isExhausted]로 빈 상태.
/// [retry]로 자동 재시도를 1회로 묶는다(R1). Riverpod 기본값은 최대 10회 지수 백오프라
/// 실패 상태에서 조회가 폭주하는데, 그 폭주의 실제 경로가 여기다(설계문서 §2.1).
///
/// SPEC-0007: 서버가 종료된 축제를 삭제하므로 쌓아둔 카드의 id가 세션 도중 해소
/// 불가가 될 수 있다. 그 경우 [dropMissingCard]로 해당 카드만 걷어내고 세션은
/// 계속한다(AC-43·AC-44) — 세션 전체를 실패로 만들지 않는다.
///
/// **`keepAlive`인 이유(CLAUDE.md §5의 근거 요구).** 이 상태는 화면이 아니라 *세션*에
/// 속한다. autoDispose면 카테고리를 옮기거나 다른 탭에 다녀오는 것만으로 큐가 버려지고,
/// 돌아왔을 때 `build()`가 다시 돌아 [_shuffled]가 **새 순서**를 만든다. 사용자에겐
/// 목록이 매번 랜덤으로 바뀌는 것으로 보이고, 이미 스와이프해 소비한 카드까지 되살아난다.
/// 피드를 새로 받는 계기는 앱 재시작·언어 전환·로그아웃·명시적 [reload]다.

@ProviderFor(SwipeController)
const swipeControllerProvider = SwipeControllerFamily._();

/// Discover 스와이프 카드 스택 컨트롤러(spec §4). [selection]별 패밀리 —
/// 선택 변경은 다른 인스턴스 로딩으로 이어진다.
///
/// **family 인자가 `Set`이 아니라 [SpotCategorySelection]인 이유**(SPEC-0020):
/// Dart의 `Set`은 값 동등성이 없어, 원소가 같아도 매 빌드마다 새 키가 되어
/// keepAlive 세션이 무한히 쌓이고 피드를 계속 다시 받는다. 정렬된 코드 문자열로
/// 동등성을 정의한 값 객체가 그것을 막는다.
///
/// - 첫 빌드: 현재 좌표를 얻어 첫 페이지(page 0, size 100)를 조회해 [SwipeQueue]를 만든다.
/// - [swipe]: 낙관적으로 맨 위 카드를 즉시 제거하고 `reactToSpot`을 비동기 발사한다.
///   실패해도 카드를 복원하지 않고 조용히 로깅한다(좋아요 실패는 비치명적).
/// - 잔여 [_prefetchThreshold] 미만이고 다음 페이지가 있으면 백그라운드로 이어 붙인다.
/// - 소진: 큐가 비고 `hasNext=false`면 [SwipeQueue.isExhausted]로 빈 상태.
/// [retry]로 자동 재시도를 1회로 묶는다(R1). Riverpod 기본값은 최대 10회 지수 백오프라
/// 실패 상태에서 조회가 폭주하는데, 그 폭주의 실제 경로가 여기다(설계문서 §2.1).
///
/// SPEC-0007: 서버가 종료된 축제를 삭제하므로 쌓아둔 카드의 id가 세션 도중 해소
/// 불가가 될 수 있다. 그 경우 [dropMissingCard]로 해당 카드만 걷어내고 세션은
/// 계속한다(AC-43·AC-44) — 세션 전체를 실패로 만들지 않는다.
///
/// **`keepAlive`인 이유(CLAUDE.md §5의 근거 요구).** 이 상태는 화면이 아니라 *세션*에
/// 속한다. autoDispose면 카테고리를 옮기거나 다른 탭에 다녀오는 것만으로 큐가 버려지고,
/// 돌아왔을 때 `build()`가 다시 돌아 [_shuffled]가 **새 순서**를 만든다. 사용자에겐
/// 목록이 매번 랜덤으로 바뀌는 것으로 보이고, 이미 스와이프해 소비한 카드까지 되살아난다.
/// 피드를 새로 받는 계기는 앱 재시작·언어 전환·로그아웃·명시적 [reload]다.
final class SwipeControllerProvider
    extends $AsyncNotifierProvider<SwipeController, SwipeQueue> {
  /// Discover 스와이프 카드 스택 컨트롤러(spec §4). [selection]별 패밀리 —
  /// 선택 변경은 다른 인스턴스 로딩으로 이어진다.
  ///
  /// **family 인자가 `Set`이 아니라 [SpotCategorySelection]인 이유**(SPEC-0020):
  /// Dart의 `Set`은 값 동등성이 없어, 원소가 같아도 매 빌드마다 새 키가 되어
  /// keepAlive 세션이 무한히 쌓이고 피드를 계속 다시 받는다. 정렬된 코드 문자열로
  /// 동등성을 정의한 값 객체가 그것을 막는다.
  ///
  /// - 첫 빌드: 현재 좌표를 얻어 첫 페이지(page 0, size 100)를 조회해 [SwipeQueue]를 만든다.
  /// - [swipe]: 낙관적으로 맨 위 카드를 즉시 제거하고 `reactToSpot`을 비동기 발사한다.
  ///   실패해도 카드를 복원하지 않고 조용히 로깅한다(좋아요 실패는 비치명적).
  /// - 잔여 [_prefetchThreshold] 미만이고 다음 페이지가 있으면 백그라운드로 이어 붙인다.
  /// - 소진: 큐가 비고 `hasNext=false`면 [SwipeQueue.isExhausted]로 빈 상태.
  /// [retry]로 자동 재시도를 1회로 묶는다(R1). Riverpod 기본값은 최대 10회 지수 백오프라
  /// 실패 상태에서 조회가 폭주하는데, 그 폭주의 실제 경로가 여기다(설계문서 §2.1).
  ///
  /// SPEC-0007: 서버가 종료된 축제를 삭제하므로 쌓아둔 카드의 id가 세션 도중 해소
  /// 불가가 될 수 있다. 그 경우 [dropMissingCard]로 해당 카드만 걷어내고 세션은
  /// 계속한다(AC-43·AC-44) — 세션 전체를 실패로 만들지 않는다.
  ///
  /// **`keepAlive`인 이유(CLAUDE.md §5의 근거 요구).** 이 상태는 화면이 아니라 *세션*에
  /// 속한다. autoDispose면 카테고리를 옮기거나 다른 탭에 다녀오는 것만으로 큐가 버려지고,
  /// 돌아왔을 때 `build()`가 다시 돌아 [_shuffled]가 **새 순서**를 만든다. 사용자에겐
  /// 목록이 매번 랜덤으로 바뀌는 것으로 보이고, 이미 스와이프해 소비한 카드까지 되살아난다.
  /// 피드를 새로 받는 계기는 앱 재시작·언어 전환·로그아웃·명시적 [reload]다.
  const SwipeControllerProvider._({
    required SwipeControllerFamily super.from,
    required SpotCategorySelection super.argument,
  }) : super(
         retry: spotRetryPolicy,
         name: r'swipeControllerProvider',
         isAutoDispose: false,
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

String _$swipeControllerHash() => r'ec77ed4526ce8b67c9d806e2e82e2bf501980a4d';

/// Discover 스와이프 카드 스택 컨트롤러(spec §4). [selection]별 패밀리 —
/// 선택 변경은 다른 인스턴스 로딩으로 이어진다.
///
/// **family 인자가 `Set`이 아니라 [SpotCategorySelection]인 이유**(SPEC-0020):
/// Dart의 `Set`은 값 동등성이 없어, 원소가 같아도 매 빌드마다 새 키가 되어
/// keepAlive 세션이 무한히 쌓이고 피드를 계속 다시 받는다. 정렬된 코드 문자열로
/// 동등성을 정의한 값 객체가 그것을 막는다.
///
/// - 첫 빌드: 현재 좌표를 얻어 첫 페이지(page 0, size 100)를 조회해 [SwipeQueue]를 만든다.
/// - [swipe]: 낙관적으로 맨 위 카드를 즉시 제거하고 `reactToSpot`을 비동기 발사한다.
///   실패해도 카드를 복원하지 않고 조용히 로깅한다(좋아요 실패는 비치명적).
/// - 잔여 [_prefetchThreshold] 미만이고 다음 페이지가 있으면 백그라운드로 이어 붙인다.
/// - 소진: 큐가 비고 `hasNext=false`면 [SwipeQueue.isExhausted]로 빈 상태.
/// [retry]로 자동 재시도를 1회로 묶는다(R1). Riverpod 기본값은 최대 10회 지수 백오프라
/// 실패 상태에서 조회가 폭주하는데, 그 폭주의 실제 경로가 여기다(설계문서 §2.1).
///
/// SPEC-0007: 서버가 종료된 축제를 삭제하므로 쌓아둔 카드의 id가 세션 도중 해소
/// 불가가 될 수 있다. 그 경우 [dropMissingCard]로 해당 카드만 걷어내고 세션은
/// 계속한다(AC-43·AC-44) — 세션 전체를 실패로 만들지 않는다.
///
/// **`keepAlive`인 이유(CLAUDE.md §5의 근거 요구).** 이 상태는 화면이 아니라 *세션*에
/// 속한다. autoDispose면 카테고리를 옮기거나 다른 탭에 다녀오는 것만으로 큐가 버려지고,
/// 돌아왔을 때 `build()`가 다시 돌아 [_shuffled]가 **새 순서**를 만든다. 사용자에겐
/// 목록이 매번 랜덤으로 바뀌는 것으로 보이고, 이미 스와이프해 소비한 카드까지 되살아난다.
/// 피드를 새로 받는 계기는 앱 재시작·언어 전환·로그아웃·명시적 [reload]다.

final class SwipeControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          SwipeController,
          AsyncValue<SwipeQueue>,
          SwipeQueue,
          FutureOr<SwipeQueue>,
          SpotCategorySelection
        > {
  const SwipeControllerFamily._()
    : super(
        retry: spotRetryPolicy,
        name: r'swipeControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  /// Discover 스와이프 카드 스택 컨트롤러(spec §4). [selection]별 패밀리 —
  /// 선택 변경은 다른 인스턴스 로딩으로 이어진다.
  ///
  /// **family 인자가 `Set`이 아니라 [SpotCategorySelection]인 이유**(SPEC-0020):
  /// Dart의 `Set`은 값 동등성이 없어, 원소가 같아도 매 빌드마다 새 키가 되어
  /// keepAlive 세션이 무한히 쌓이고 피드를 계속 다시 받는다. 정렬된 코드 문자열로
  /// 동등성을 정의한 값 객체가 그것을 막는다.
  ///
  /// - 첫 빌드: 현재 좌표를 얻어 첫 페이지(page 0, size 100)를 조회해 [SwipeQueue]를 만든다.
  /// - [swipe]: 낙관적으로 맨 위 카드를 즉시 제거하고 `reactToSpot`을 비동기 발사한다.
  ///   실패해도 카드를 복원하지 않고 조용히 로깅한다(좋아요 실패는 비치명적).
  /// - 잔여 [_prefetchThreshold] 미만이고 다음 페이지가 있으면 백그라운드로 이어 붙인다.
  /// - 소진: 큐가 비고 `hasNext=false`면 [SwipeQueue.isExhausted]로 빈 상태.
  /// [retry]로 자동 재시도를 1회로 묶는다(R1). Riverpod 기본값은 최대 10회 지수 백오프라
  /// 실패 상태에서 조회가 폭주하는데, 그 폭주의 실제 경로가 여기다(설계문서 §2.1).
  ///
  /// SPEC-0007: 서버가 종료된 축제를 삭제하므로 쌓아둔 카드의 id가 세션 도중 해소
  /// 불가가 될 수 있다. 그 경우 [dropMissingCard]로 해당 카드만 걷어내고 세션은
  /// 계속한다(AC-43·AC-44) — 세션 전체를 실패로 만들지 않는다.
  ///
  /// **`keepAlive`인 이유(CLAUDE.md §5의 근거 요구).** 이 상태는 화면이 아니라 *세션*에
  /// 속한다. autoDispose면 카테고리를 옮기거나 다른 탭에 다녀오는 것만으로 큐가 버려지고,
  /// 돌아왔을 때 `build()`가 다시 돌아 [_shuffled]가 **새 순서**를 만든다. 사용자에겐
  /// 목록이 매번 랜덤으로 바뀌는 것으로 보이고, 이미 스와이프해 소비한 카드까지 되살아난다.
  /// 피드를 새로 받는 계기는 앱 재시작·언어 전환·로그아웃·명시적 [reload]다.

  SwipeControllerProvider call(SpotCategorySelection selection) =>
      SwipeControllerProvider._(argument: selection, from: this);

  @override
  String toString() => r'swipeControllerProvider';
}

/// Discover 스와이프 카드 스택 컨트롤러(spec §4). [selection]별 패밀리 —
/// 선택 변경은 다른 인스턴스 로딩으로 이어진다.
///
/// **family 인자가 `Set`이 아니라 [SpotCategorySelection]인 이유**(SPEC-0020):
/// Dart의 `Set`은 값 동등성이 없어, 원소가 같아도 매 빌드마다 새 키가 되어
/// keepAlive 세션이 무한히 쌓이고 피드를 계속 다시 받는다. 정렬된 코드 문자열로
/// 동등성을 정의한 값 객체가 그것을 막는다.
///
/// - 첫 빌드: 현재 좌표를 얻어 첫 페이지(page 0, size 100)를 조회해 [SwipeQueue]를 만든다.
/// - [swipe]: 낙관적으로 맨 위 카드를 즉시 제거하고 `reactToSpot`을 비동기 발사한다.
///   실패해도 카드를 복원하지 않고 조용히 로깅한다(좋아요 실패는 비치명적).
/// - 잔여 [_prefetchThreshold] 미만이고 다음 페이지가 있으면 백그라운드로 이어 붙인다.
/// - 소진: 큐가 비고 `hasNext=false`면 [SwipeQueue.isExhausted]로 빈 상태.
/// [retry]로 자동 재시도를 1회로 묶는다(R1). Riverpod 기본값은 최대 10회 지수 백오프라
/// 실패 상태에서 조회가 폭주하는데, 그 폭주의 실제 경로가 여기다(설계문서 §2.1).
///
/// SPEC-0007: 서버가 종료된 축제를 삭제하므로 쌓아둔 카드의 id가 세션 도중 해소
/// 불가가 될 수 있다. 그 경우 [dropMissingCard]로 해당 카드만 걷어내고 세션은
/// 계속한다(AC-43·AC-44) — 세션 전체를 실패로 만들지 않는다.
///
/// **`keepAlive`인 이유(CLAUDE.md §5의 근거 요구).** 이 상태는 화면이 아니라 *세션*에
/// 속한다. autoDispose면 카테고리를 옮기거나 다른 탭에 다녀오는 것만으로 큐가 버려지고,
/// 돌아왔을 때 `build()`가 다시 돌아 [_shuffled]가 **새 순서**를 만든다. 사용자에겐
/// 목록이 매번 랜덤으로 바뀌는 것으로 보이고, 이미 스와이프해 소비한 카드까지 되살아난다.
/// 피드를 새로 받는 계기는 앱 재시작·언어 전환·로그아웃·명시적 [reload]다.

abstract class _$SwipeController extends $AsyncNotifier<SwipeQueue> {
  late final _$args = ref.$arg as SpotCategorySelection;
  SpotCategorySelection get selection => _$args;

  FutureOr<SwipeQueue> build(SpotCategorySelection selection);
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
