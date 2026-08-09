// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nearby_spots_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 장소 선택 시트에 입력한 검색어.
///
/// **주변 탭에서는 서버 검색어다**(SPEC-0013 R14) — 값이 있으면 시트가
/// `searchSpots`를 부르고, 지우면 좌표 기반 목록으로 돌아온다(AC-14.3).
/// 좋아요 탭에서는 여전히 이미 받아 둔 목록을 좁히는 이름 필터다 — `searchSpots`는
/// 좌표 기반 반경 검색이라 "내가 좋아요한 것 중에서"를 표현할 수 없다.
///
/// 필터는 시트가 열려 있는 동안의 상태라 autoDispose(codegen 기본)로 둔다 — 시트를
/// 닫으면 사라지는 것이 맞다.

@ProviderFor(NearbySpotQuery)
const nearbySpotQueryProvider = NearbySpotQueryProvider._();

/// 장소 선택 시트에 입력한 검색어.
///
/// **주변 탭에서는 서버 검색어다**(SPEC-0013 R14) — 값이 있으면 시트가
/// `searchSpots`를 부르고, 지우면 좌표 기반 목록으로 돌아온다(AC-14.3).
/// 좋아요 탭에서는 여전히 이미 받아 둔 목록을 좁히는 이름 필터다 — `searchSpots`는
/// 좌표 기반 반경 검색이라 "내가 좋아요한 것 중에서"를 표현할 수 없다.
///
/// 필터는 시트가 열려 있는 동안의 상태라 autoDispose(codegen 기본)로 둔다 — 시트를
/// 닫으면 사라지는 것이 맞다.
final class NearbySpotQueryProvider
    extends $NotifierProvider<NearbySpotQuery, String> {
  /// 장소 선택 시트에 입력한 검색어.
  ///
  /// **주변 탭에서는 서버 검색어다**(SPEC-0013 R14) — 값이 있으면 시트가
  /// `searchSpots`를 부르고, 지우면 좌표 기반 목록으로 돌아온다(AC-14.3).
  /// 좋아요 탭에서는 여전히 이미 받아 둔 목록을 좁히는 이름 필터다 — `searchSpots`는
  /// 좌표 기반 반경 검색이라 "내가 좋아요한 것 중에서"를 표현할 수 없다.
  ///
  /// 필터는 시트가 열려 있는 동안의 상태라 autoDispose(codegen 기본)로 둔다 — 시트를
  /// 닫으면 사라지는 것이 맞다.
  const NearbySpotQueryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'nearbySpotQueryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$nearbySpotQueryHash();

  @$internal
  @override
  NearbySpotQuery create() => NearbySpotQuery();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$nearbySpotQueryHash() => r'63e79ee800d2432273edd5098c4b24db16eecd17';

/// 장소 선택 시트에 입력한 검색어.
///
/// **주변 탭에서는 서버 검색어다**(SPEC-0013 R14) — 값이 있으면 시트가
/// `searchSpots`를 부르고, 지우면 좌표 기반 목록으로 돌아온다(AC-14.3).
/// 좋아요 탭에서는 여전히 이미 받아 둔 목록을 좁히는 이름 필터다 — `searchSpots`는
/// 좌표 기반 반경 검색이라 "내가 좋아요한 것 중에서"를 표현할 수 없다.
///
/// 필터는 시트가 열려 있는 동안의 상태라 autoDispose(codegen 기본)로 둔다 — 시트를
/// 닫으면 사라지는 것이 맞다.

abstract class _$NearbySpotQuery extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<String, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String, String>,
              String,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// 장소 선택 시트의 카테고리 줄 구성.
///
/// **언어마다 목록이 다르다**(라이브 확인 — ko에는 `TRAVEL_COURSE`가, en에는 그 자리에
/// `TRANSPORT`가 있다). 그래서 클라이언트가 값을 하드코딩하지 않고 상단 칩과 같이
/// 서버가 준 것만 그린다. **빈 목록도 정상**이라 그때는 줄 자체를 그리지 않는다.
///
/// 목록 조회와 **분리된 provider**인 이유는 실패가 서로를 가리지 않게 하기 위해서다 —
/// 카테고리 줄이 못 떠도 주변 장소 목록은 그대로 뜬다.

@ProviderFor(nearbySpotCategories)
const nearbySpotCategoriesProvider = NearbySpotCategoriesProvider._();

/// 장소 선택 시트의 카테고리 줄 구성.
///
/// **언어마다 목록이 다르다**(라이브 확인 — ko에는 `TRAVEL_COURSE`가, en에는 그 자리에
/// `TRANSPORT`가 있다). 그래서 클라이언트가 값을 하드코딩하지 않고 상단 칩과 같이
/// 서버가 준 것만 그린다. **빈 목록도 정상**이라 그때는 줄 자체를 그리지 않는다.
///
/// 목록 조회와 **분리된 provider**인 이유는 실패가 서로를 가리지 않게 하기 위해서다 —
/// 카테고리 줄이 못 떠도 주변 장소 목록은 그대로 뜬다.

final class NearbySpotCategoriesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<NearbySpotCategory>>,
          List<NearbySpotCategory>,
          FutureOr<List<NearbySpotCategory>>
        >
    with
        $FutureModifier<List<NearbySpotCategory>>,
        $FutureProvider<List<NearbySpotCategory>> {
  /// 장소 선택 시트의 카테고리 줄 구성.
  ///
  /// **언어마다 목록이 다르다**(라이브 확인 — ko에는 `TRAVEL_COURSE`가, en에는 그 자리에
  /// `TRANSPORT`가 있다). 그래서 클라이언트가 값을 하드코딩하지 않고 상단 칩과 같이
  /// 서버가 준 것만 그린다. **빈 목록도 정상**이라 그때는 줄 자체를 그리지 않는다.
  ///
  /// 목록 조회와 **분리된 provider**인 이유는 실패가 서로를 가리지 않게 하기 위해서다 —
  /// 카테고리 줄이 못 떠도 주변 장소 목록은 그대로 뜬다.
  const NearbySpotCategoriesProvider._()
    : super(
        from: null,
        argument: null,
        retry: communityRetryPolicy,
        name: r'nearbySpotCategoriesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$nearbySpotCategoriesHash();

  @$internal
  @override
  $FutureProviderElement<List<NearbySpotCategory>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<NearbySpotCategory>> create(Ref ref) {
    return nearbySpotCategories(ref);
  }
}

String _$nearbySpotCategoriesHash() =>
    r'4f84a6e2de83dea003b4af6982680edcd8239846';

/// 시트에서 지금 고른 출처(탭). 시트가 열려 있는 동안의 상태라 autoDispose다.

@ProviderFor(SpotPickerSourceTab)
const spotPickerSourceTabProvider = SpotPickerSourceTabProvider._();

/// 시트에서 지금 고른 출처(탭). 시트가 열려 있는 동안의 상태라 autoDispose다.
final class SpotPickerSourceTabProvider
    extends $NotifierProvider<SpotPickerSourceTab, SpotPickerSource> {
  /// 시트에서 지금 고른 출처(탭). 시트가 열려 있는 동안의 상태라 autoDispose다.
  const SpotPickerSourceTabProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'spotPickerSourceTabProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$spotPickerSourceTabHash();

  @$internal
  @override
  SpotPickerSourceTab create() => SpotPickerSourceTab();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SpotPickerSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SpotPickerSource>(value),
    );
  }
}

String _$spotPickerSourceTabHash() =>
    r'53e2f050ee19a0d921a876fb834c77fb5417511e';

/// 시트에서 지금 고른 출처(탭). 시트가 열려 있는 동안의 상태라 autoDispose다.

abstract class _$SpotPickerSourceTab extends $Notifier<SpotPickerSource> {
  SpotPickerSource build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<SpotPickerSource, SpotPickerSource>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SpotPickerSource, SpotPickerSource>,
              SpotPickerSource,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// 시트에서 지금 고른 카테고리. null이면 "전체"다.
///
/// **이름 필터와 달리 이 값은 서버로 간다** — 바뀌면 [NearbySpotsController]가
/// 페이지 0부터 다시 받는다(오프셋이 카테고리마다 다르므로 이어 붙일 수 없다).
///
/// 시트가 열려 있는 동안의 상태라 autoDispose(codegen 기본)로 둔다.

@ProviderFor(NearbySpotCategoryFilter)
const nearbySpotCategoryFilterProvider = NearbySpotCategoryFilterProvider._();

/// 시트에서 지금 고른 카테고리. null이면 "전체"다.
///
/// **이름 필터와 달리 이 값은 서버로 간다** — 바뀌면 [NearbySpotsController]가
/// 페이지 0부터 다시 받는다(오프셋이 카테고리마다 다르므로 이어 붙일 수 없다).
///
/// 시트가 열려 있는 동안의 상태라 autoDispose(codegen 기본)로 둔다.
final class NearbySpotCategoryFilterProvider
    extends $NotifierProvider<NearbySpotCategoryFilter, NearbySpotCategory?> {
  /// 시트에서 지금 고른 카테고리. null이면 "전체"다.
  ///
  /// **이름 필터와 달리 이 값은 서버로 간다** — 바뀌면 [NearbySpotsController]가
  /// 페이지 0부터 다시 받는다(오프셋이 카테고리마다 다르므로 이어 붙일 수 없다).
  ///
  /// 시트가 열려 있는 동안의 상태라 autoDispose(codegen 기본)로 둔다.
  const NearbySpotCategoryFilterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'nearbySpotCategoryFilterProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$nearbySpotCategoryFilterHash();

  @$internal
  @override
  NearbySpotCategoryFilter create() => NearbySpotCategoryFilter();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NearbySpotCategory? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NearbySpotCategory?>(value),
    );
  }
}

String _$nearbySpotCategoryFilterHash() =>
    r'97ad4ec94bd7aa73ee9bd20cba3f9f42808df20e';

/// 시트에서 지금 고른 카테고리. null이면 "전체"다.
///
/// **이름 필터와 달리 이 값은 서버로 간다** — 바뀌면 [NearbySpotsController]가
/// 페이지 0부터 다시 받는다(오프셋이 카테고리마다 다르므로 이어 붙일 수 없다).
///
/// 시트가 열려 있는 동안의 상태라 autoDispose(codegen 기본)로 둔다.

abstract class _$NearbySpotCategoryFilter
    extends $Notifier<NearbySpotCategory?> {
  NearbySpotCategory? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<NearbySpotCategory?, NearbySpotCategory?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<NearbySpotCategory?, NearbySpotCategory?>,
              NearbySpotCategory?,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// 컴포저 장소 선택 시트의 목록.
///
/// 좌표는 앱이 이미 쓰고 있는 [currentCoordinatesProvider]를 그대로 쓴다. 위치를
/// 얻지 못하면 그 실패가 `AsyncValue.error`로 올라오고 **시트가 사유와 재시도를
/// 보여준다** — 빈 시트나 무한 스피너로 두지 않는다. 그 상태에서도 장소 없이 글을
/// 등록하는 길은 그대로 열려 있다(가이드 §5).
///
/// [nearbySpotCategoryFilterProvider]를 watch하므로 **카테고리를 바꾸면 build가 다시
/// 돌아 페이지 0부터 받는다** — 오프셋이 카테고리마다 다르니 이어 붙일 수 없다.

@ProviderFor(NearbySpotsController)
const nearbySpotsControllerProvider = NearbySpotsControllerProvider._();

/// 컴포저 장소 선택 시트의 목록.
///
/// 좌표는 앱이 이미 쓰고 있는 [currentCoordinatesProvider]를 그대로 쓴다. 위치를
/// 얻지 못하면 그 실패가 `AsyncValue.error`로 올라오고 **시트가 사유와 재시도를
/// 보여준다** — 빈 시트나 무한 스피너로 두지 않는다. 그 상태에서도 장소 없이 글을
/// 등록하는 길은 그대로 열려 있다(가이드 §5).
///
/// [nearbySpotCategoryFilterProvider]를 watch하므로 **카테고리를 바꾸면 build가 다시
/// 돌아 페이지 0부터 받는다** — 오프셋이 카테고리마다 다르니 이어 붙일 수 없다.
final class NearbySpotsControllerProvider
    extends $AsyncNotifierProvider<NearbySpotsController, NearbySpotsState> {
  /// 컴포저 장소 선택 시트의 목록.
  ///
  /// 좌표는 앱이 이미 쓰고 있는 [currentCoordinatesProvider]를 그대로 쓴다. 위치를
  /// 얻지 못하면 그 실패가 `AsyncValue.error`로 올라오고 **시트가 사유와 재시도를
  /// 보여준다** — 빈 시트나 무한 스피너로 두지 않는다. 그 상태에서도 장소 없이 글을
  /// 등록하는 길은 그대로 열려 있다(가이드 §5).
  ///
  /// [nearbySpotCategoryFilterProvider]를 watch하므로 **카테고리를 바꾸면 build가 다시
  /// 돌아 페이지 0부터 받는다** — 오프셋이 카테고리마다 다르니 이어 붙일 수 없다.
  const NearbySpotsControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: communityRetryPolicy,
        name: r'nearbySpotsControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$nearbySpotsControllerHash();

  @$internal
  @override
  NearbySpotsController create() => NearbySpotsController();
}

String _$nearbySpotsControllerHash() =>
    r'e241a6d8662e294966a1b9fa4f077997980e5315';

/// 컴포저 장소 선택 시트의 목록.
///
/// 좌표는 앱이 이미 쓰고 있는 [currentCoordinatesProvider]를 그대로 쓴다. 위치를
/// 얻지 못하면 그 실패가 `AsyncValue.error`로 올라오고 **시트가 사유와 재시도를
/// 보여준다** — 빈 시트나 무한 스피너로 두지 않는다. 그 상태에서도 장소 없이 글을
/// 등록하는 길은 그대로 열려 있다(가이드 §5).
///
/// [nearbySpotCategoryFilterProvider]를 watch하므로 **카테고리를 바꾸면 build가 다시
/// 돌아 페이지 0부터 받는다** — 오프셋이 카테고리마다 다르니 이어 붙일 수 없다.

abstract class _$NearbySpotsController
    extends $AsyncNotifier<NearbySpotsState> {
  FutureOr<NearbySpotsState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<AsyncValue<NearbySpotsState>, NearbySpotsState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<NearbySpotsState>, NearbySpotsState>,
              AsyncValue<NearbySpotsState>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// 시트 검색 결과(SPEC-0013 R14, AC-14.1·14.2).
///
/// **질의를 인자로 받는다**(family) — 질의가 바뀌면 Riverpod이 새 provider를 만들고
/// 이전 것을 폐기하므로, 이어 붙이던 커서가 자동으로 초기화된다. 질의를 상태로 들고
/// 있으면 그 초기화를 손으로 해야 하고, 한 번 빠뜨리면 이전 질의의 다음 페이지를
/// 새 질의 결과에 붙이게 된다.
///
/// 디바운스도 여기서 처리한다 — 시트는 입력할 때마다 질의를 갱신하므로, 그대로
/// 두면 키 입력마다 서버를 부른다.

@ProviderFor(SpotSearchList)
const spotSearchListProvider = SpotSearchListFamily._();

/// 시트 검색 결과(SPEC-0013 R14, AC-14.1·14.2).
///
/// **질의를 인자로 받는다**(family) — 질의가 바뀌면 Riverpod이 새 provider를 만들고
/// 이전 것을 폐기하므로, 이어 붙이던 커서가 자동으로 초기화된다. 질의를 상태로 들고
/// 있으면 그 초기화를 손으로 해야 하고, 한 번 빠뜨리면 이전 질의의 다음 페이지를
/// 새 질의 결과에 붙이게 된다.
///
/// 디바운스도 여기서 처리한다 — 시트는 입력할 때마다 질의를 갱신하므로, 그대로
/// 두면 키 입력마다 서버를 부른다.
final class SpotSearchListProvider
    extends $AsyncNotifierProvider<SpotSearchList, SpotSearchListState> {
  /// 시트 검색 결과(SPEC-0013 R14, AC-14.1·14.2).
  ///
  /// **질의를 인자로 받는다**(family) — 질의가 바뀌면 Riverpod이 새 provider를 만들고
  /// 이전 것을 폐기하므로, 이어 붙이던 커서가 자동으로 초기화된다. 질의를 상태로 들고
  /// 있으면 그 초기화를 손으로 해야 하고, 한 번 빠뜨리면 이전 질의의 다음 페이지를
  /// 새 질의 결과에 붙이게 된다.
  ///
  /// 디바운스도 여기서 처리한다 — 시트는 입력할 때마다 질의를 갱신하므로, 그대로
  /// 두면 키 입력마다 서버를 부른다.
  const SpotSearchListProvider._({
    required SpotSearchListFamily super.from,
    required String super.argument,
  }) : super(
         retry: communityRetryPolicy,
         name: r'spotSearchListProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$spotSearchListHash();

  @override
  String toString() {
    return r'spotSearchListProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  SpotSearchList create() => SpotSearchList();

  @override
  bool operator ==(Object other) {
    return other is SpotSearchListProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$spotSearchListHash() => r'7471feb95781379e3cc65036669961cd5f30cac6';

/// 시트 검색 결과(SPEC-0013 R14, AC-14.1·14.2).
///
/// **질의를 인자로 받는다**(family) — 질의가 바뀌면 Riverpod이 새 provider를 만들고
/// 이전 것을 폐기하므로, 이어 붙이던 커서가 자동으로 초기화된다. 질의를 상태로 들고
/// 있으면 그 초기화를 손으로 해야 하고, 한 번 빠뜨리면 이전 질의의 다음 페이지를
/// 새 질의 결과에 붙이게 된다.
///
/// 디바운스도 여기서 처리한다 — 시트는 입력할 때마다 질의를 갱신하므로, 그대로
/// 두면 키 입력마다 서버를 부른다.

final class SpotSearchListFamily extends $Family
    with
        $ClassFamilyOverride<
          SpotSearchList,
          AsyncValue<SpotSearchListState>,
          SpotSearchListState,
          FutureOr<SpotSearchListState>,
          String
        > {
  const SpotSearchListFamily._()
    : super(
        retry: communityRetryPolicy,
        name: r'spotSearchListProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// 시트 검색 결과(SPEC-0013 R14, AC-14.1·14.2).
  ///
  /// **질의를 인자로 받는다**(family) — 질의가 바뀌면 Riverpod이 새 provider를 만들고
  /// 이전 것을 폐기하므로, 이어 붙이던 커서가 자동으로 초기화된다. 질의를 상태로 들고
  /// 있으면 그 초기화를 손으로 해야 하고, 한 번 빠뜨리면 이전 질의의 다음 페이지를
  /// 새 질의 결과에 붙이게 된다.
  ///
  /// 디바운스도 여기서 처리한다 — 시트는 입력할 때마다 질의를 갱신하므로, 그대로
  /// 두면 키 입력마다 서버를 부른다.

  SpotSearchListProvider call(String query) =>
      SpotSearchListProvider._(argument: query, from: this);

  @override
  String toString() => r'spotSearchListProvider';
}

/// 시트 검색 결과(SPEC-0013 R14, AC-14.1·14.2).
///
/// **질의를 인자로 받는다**(family) — 질의가 바뀌면 Riverpod이 새 provider를 만들고
/// 이전 것을 폐기하므로, 이어 붙이던 커서가 자동으로 초기화된다. 질의를 상태로 들고
/// 있으면 그 초기화를 손으로 해야 하고, 한 번 빠뜨리면 이전 질의의 다음 페이지를
/// 새 질의 결과에 붙이게 된다.
///
/// 디바운스도 여기서 처리한다 — 시트는 입력할 때마다 질의를 갱신하므로, 그대로
/// 두면 키 입력마다 서버를 부른다.

abstract class _$SpotSearchList extends $AsyncNotifier<SpotSearchListState> {
  late final _$args = ref.$arg as String;
  String get query => _$args;

  FutureOr<SpotSearchListState> build(String query);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
    final ref =
        this.ref as $Ref<AsyncValue<SpotSearchListState>, SpotSearchListState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<SpotSearchListState>, SpotSearchListState>,
              AsyncValue<SpotSearchListState>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// 장소 선택 시트의 "좋아요한 장소" 탭.
///
/// **좌표가 필요 없다** — `likedSpots`는 좌표 인자를 받지 않으므로 위치를 못 얻는
/// 상황에서도 이 탭은 그대로 돈다. 주변 탭이 위치 실패로 막혔을 때 장소를 붙일 수
/// 있는 유일한 길이기도 하다.
///
/// [nearbySpotCategoryFilterProvider]를 watch하므로 **카테고리 줄 하나가 두 탭에
/// 함께 걸린다** — 바꾸면 build가 다시 돌아 첫 페이지부터 받는다.

@ProviderFor(LikedSpotsController)
const likedSpotsControllerProvider = LikedSpotsControllerProvider._();

/// 장소 선택 시트의 "좋아요한 장소" 탭.
///
/// **좌표가 필요 없다** — `likedSpots`는 좌표 인자를 받지 않으므로 위치를 못 얻는
/// 상황에서도 이 탭은 그대로 돈다. 주변 탭이 위치 실패로 막혔을 때 장소를 붙일 수
/// 있는 유일한 길이기도 하다.
///
/// [nearbySpotCategoryFilterProvider]를 watch하므로 **카테고리 줄 하나가 두 탭에
/// 함께 걸린다** — 바꾸면 build가 다시 돌아 첫 페이지부터 받는다.
final class LikedSpotsControllerProvider
    extends $AsyncNotifierProvider<LikedSpotsController, LikedSpotsState> {
  /// 장소 선택 시트의 "좋아요한 장소" 탭.
  ///
  /// **좌표가 필요 없다** — `likedSpots`는 좌표 인자를 받지 않으므로 위치를 못 얻는
  /// 상황에서도 이 탭은 그대로 돈다. 주변 탭이 위치 실패로 막혔을 때 장소를 붙일 수
  /// 있는 유일한 길이기도 하다.
  ///
  /// [nearbySpotCategoryFilterProvider]를 watch하므로 **카테고리 줄 하나가 두 탭에
  /// 함께 걸린다** — 바꾸면 build가 다시 돌아 첫 페이지부터 받는다.
  const LikedSpotsControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: communityRetryPolicy,
        name: r'likedSpotsControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$likedSpotsControllerHash();

  @$internal
  @override
  LikedSpotsController create() => LikedSpotsController();
}

String _$likedSpotsControllerHash() =>
    r'f3a1a9ba4130670eb612503dfd35206466e6dd69';

/// 장소 선택 시트의 "좋아요한 장소" 탭.
///
/// **좌표가 필요 없다** — `likedSpots`는 좌표 인자를 받지 않으므로 위치를 못 얻는
/// 상황에서도 이 탭은 그대로 돈다. 주변 탭이 위치 실패로 막혔을 때 장소를 붙일 수
/// 있는 유일한 길이기도 하다.
///
/// [nearbySpotCategoryFilterProvider]를 watch하므로 **카테고리 줄 하나가 두 탭에
/// 함께 걸린다** — 바꾸면 build가 다시 돌아 첫 페이지부터 받는다.

abstract class _$LikedSpotsController extends $AsyncNotifier<LikedSpotsState> {
  FutureOr<LikedSpotsState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<LikedSpotsState>, LikedSpotsState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<LikedSpotsState>, LikedSpotsState>,
              AsyncValue<LikedSpotsState>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
