// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'region_recommendation_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 지역 추천 목록(SPEC-0015).
///
/// **위치가 없어도 조회한다**(R27 · §4.1). 다섯 항목 중 넷은 위치와 무관하므로 위치
/// 권한 부재가 추천 자체를 막지 않는다 — `origin` 없이 요청하면 서버가 거리 항목을
/// 빼고 나머지로 산출해 준다(R21). 위치 실패를 오류로 올리면 R27을 어긴다.
///
/// 목록 정렬은 **서버가 준 총점 내림차순을 그대로 유지한다**(R22) — 클라이언트가 다시
/// 정렬하지 않는다.
///
/// **재시도 상한은 여기 있지 않다.** provider의 생명주기(폐기·재생성·지연 빌드)에
/// 횟수를 얹으면 "몇 번 조회됐나"가 구독 상태에 따라 달라진다 — 실제로 재시도 한 번에
/// 요청이 두 번 나가거나, 상한을 넘겨 한 번 더 나가는 것을 측정했다. 횟수는 누른
/// 사람이 세는 것이므로 화면이 [RegionRecommendationRetryCount]로 센다.

@ProviderFor(regionRecommendations)
const regionRecommendationsProvider = RegionRecommendationsProvider._();

/// 지역 추천 목록(SPEC-0015).
///
/// **위치가 없어도 조회한다**(R27 · §4.1). 다섯 항목 중 넷은 위치와 무관하므로 위치
/// 권한 부재가 추천 자체를 막지 않는다 — `origin` 없이 요청하면 서버가 거리 항목을
/// 빼고 나머지로 산출해 준다(R21). 위치 실패를 오류로 올리면 R27을 어긴다.
///
/// 목록 정렬은 **서버가 준 총점 내림차순을 그대로 유지한다**(R22) — 클라이언트가 다시
/// 정렬하지 않는다.
///
/// **재시도 상한은 여기 있지 않다.** provider의 생명주기(폐기·재생성·지연 빌드)에
/// 횟수를 얹으면 "몇 번 조회됐나"가 구독 상태에 따라 달라진다 — 실제로 재시도 한 번에
/// 요청이 두 번 나가거나, 상한을 넘겨 한 번 더 나가는 것을 측정했다. 횟수는 누른
/// 사람이 세는 것이므로 화면이 [RegionRecommendationRetryCount]로 센다.

final class RegionRecommendationsProvider
    extends
        $FunctionalProvider<
          AsyncValue<RegionRecommendationResult>,
          RegionRecommendationResult,
          FutureOr<RegionRecommendationResult>
        >
    with
        $FutureModifier<RegionRecommendationResult>,
        $FutureProvider<RegionRecommendationResult> {
  /// 지역 추천 목록(SPEC-0015).
  ///
  /// **위치가 없어도 조회한다**(R27 · §4.1). 다섯 항목 중 넷은 위치와 무관하므로 위치
  /// 권한 부재가 추천 자체를 막지 않는다 — `origin` 없이 요청하면 서버가 거리 항목을
  /// 빼고 나머지로 산출해 준다(R21). 위치 실패를 오류로 올리면 R27을 어긴다.
  ///
  /// 목록 정렬은 **서버가 준 총점 내림차순을 그대로 유지한다**(R22) — 클라이언트가 다시
  /// 정렬하지 않는다.
  ///
  /// **재시도 상한은 여기 있지 않다.** provider의 생명주기(폐기·재생성·지연 빌드)에
  /// 횟수를 얹으면 "몇 번 조회됐나"가 구독 상태에 따라 달라진다 — 실제로 재시도 한 번에
  /// 요청이 두 번 나가거나, 상한을 넘겨 한 번 더 나가는 것을 측정했다. 횟수는 누른
  /// 사람이 세는 것이므로 화면이 [RegionRecommendationRetryCount]로 센다.
  const RegionRecommendationsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'regionRecommendationsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$regionRecommendationsHash();

  @$internal
  @override
  $FutureProviderElement<RegionRecommendationResult> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<RegionRecommendationResult> create(Ref ref) {
    return regionRecommendations(ref);
  }
}

String _$regionRecommendationsHash() =>
    r'fec1993161a6147b1906198e62312ff99779c46d';

/// 사용자가 재시도를 몇 번 썼는지(R28 · POL-040).
///
/// 화면이 재시도를 누르기 전에 [canRetry]를 확인하고, 누른 뒤 [record]로 센다.
/// 조회 자체는 `ref.invalidate(regionRecommendationsProvider)`로 다시 돈다.
///
/// **상한에 걸리면 화면이 버튼을 비활성화한다** — 해결되지 않는 재시도를 반복하게
/// 두지 않는다.

@ProviderFor(RegionRecommendationRetryCount)
const regionRecommendationRetryCountProvider =
    RegionRecommendationRetryCountProvider._();

/// 사용자가 재시도를 몇 번 썼는지(R28 · POL-040).
///
/// 화면이 재시도를 누르기 전에 [canRetry]를 확인하고, 누른 뒤 [record]로 센다.
/// 조회 자체는 `ref.invalidate(regionRecommendationsProvider)`로 다시 돈다.
///
/// **상한에 걸리면 화면이 버튼을 비활성화한다** — 해결되지 않는 재시도를 반복하게
/// 두지 않는다.
final class RegionRecommendationRetryCountProvider
    extends $NotifierProvider<RegionRecommendationRetryCount, int> {
  /// 사용자가 재시도를 몇 번 썼는지(R28 · POL-040).
  ///
  /// 화면이 재시도를 누르기 전에 [canRetry]를 확인하고, 누른 뒤 [record]로 센다.
  /// 조회 자체는 `ref.invalidate(regionRecommendationsProvider)`로 다시 돈다.
  ///
  /// **상한에 걸리면 화면이 버튼을 비활성화한다** — 해결되지 않는 재시도를 반복하게
  /// 두지 않는다.
  const RegionRecommendationRetryCountProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'regionRecommendationRetryCountProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$regionRecommendationRetryCountHash();

  @$internal
  @override
  RegionRecommendationRetryCount create() => RegionRecommendationRetryCount();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$regionRecommendationRetryCountHash() =>
    r'9d061f00d8974fa88bdd2483e06d00777786df93';

/// 사용자가 재시도를 몇 번 썼는지(R28 · POL-040).
///
/// 화면이 재시도를 누르기 전에 [canRetry]를 확인하고, 누른 뒤 [record]로 센다.
/// 조회 자체는 `ref.invalidate(regionRecommendationsProvider)`로 다시 돈다.
///
/// **상한에 걸리면 화면이 버튼을 비활성화한다** — 해결되지 않는 재시도를 반복하게
/// 두지 않는다.

abstract class _$RegionRecommendationRetryCount extends $Notifier<int> {
  int build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<int, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int, int>,
              int,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
