// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'region_recommendation_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 지역 추천 목록(SPEC-0015).
///
/// **위치가 필수다.** 설계 초안(R27)은 "위치 없이도 추천이 나온다"였으나 서버가
/// `origin`을 필수로 확정했다 — 이 쿼리는 origin이 속한 시도 안에서만 후보를 고르고
/// origin의 시군구 자신을 빼므로 좌표 없이는 질문이 성립하지 않는다. 그래서 위치를
/// 얻지 못하면 [RegionRecommendationNeedsLocation]을 올려 화면이 권한 안내를 그린다.
///
/// 목록 정렬은 **서버가 준 총점 내림차순을 그대로 유지한다**(R22) — 클라이언트가 다시
/// 정렬하지 않는다.
///
/// **재시도 상한은 여기 있지 않다.** provider의 생명주기(폐기·재생성·지연 빌드)에
/// 횟수를 얹으면 "몇 번 조회됐나"가 구독 상태에 따라 달라진다 — 실제로 재시도 한 번에
/// 요청이 두 번 나가거나, 상한을 넘겨 한 번 더 나가는 것을 측정했다. 횟수는 누른
/// 사람이 세는 것이므로 화면이 [RegionRecommendationRetryCount]로 센다.
/// **[mapCenter]가 있으면 그 좌표를, 없으면 내 위치를 기준으로 조회한다.**
///
/// 사용자가 화면에서 기준을 바꿀 수 있으므로 인자로 받아 family가 된다 — 기준이
/// 바뀌면 새 인자가 되어 이전 조회는 자동으로 버려지고, 두 기준의 결과가 각각
/// 캐시된다(왔다 갔다 해도 다시 받지 않는다).

@ProviderFor(regionRecommendations)
const regionRecommendationsProvider = RegionRecommendationsFamily._();

/// 지역 추천 목록(SPEC-0015).
///
/// **위치가 필수다.** 설계 초안(R27)은 "위치 없이도 추천이 나온다"였으나 서버가
/// `origin`을 필수로 확정했다 — 이 쿼리는 origin이 속한 시도 안에서만 후보를 고르고
/// origin의 시군구 자신을 빼므로 좌표 없이는 질문이 성립하지 않는다. 그래서 위치를
/// 얻지 못하면 [RegionRecommendationNeedsLocation]을 올려 화면이 권한 안내를 그린다.
///
/// 목록 정렬은 **서버가 준 총점 내림차순을 그대로 유지한다**(R22) — 클라이언트가 다시
/// 정렬하지 않는다.
///
/// **재시도 상한은 여기 있지 않다.** provider의 생명주기(폐기·재생성·지연 빌드)에
/// 횟수를 얹으면 "몇 번 조회됐나"가 구독 상태에 따라 달라진다 — 실제로 재시도 한 번에
/// 요청이 두 번 나가거나, 상한을 넘겨 한 번 더 나가는 것을 측정했다. 횟수는 누른
/// 사람이 세는 것이므로 화면이 [RegionRecommendationRetryCount]로 센다.
/// **[mapCenter]가 있으면 그 좌표를, 없으면 내 위치를 기준으로 조회한다.**
///
/// 사용자가 화면에서 기준을 바꿀 수 있으므로 인자로 받아 family가 된다 — 기준이
/// 바뀌면 새 인자가 되어 이전 조회는 자동으로 버려지고, 두 기준의 결과가 각각
/// 캐시된다(왔다 갔다 해도 다시 받지 않는다).

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
  /// **위치가 필수다.** 설계 초안(R27)은 "위치 없이도 추천이 나온다"였으나 서버가
  /// `origin`을 필수로 확정했다 — 이 쿼리는 origin이 속한 시도 안에서만 후보를 고르고
  /// origin의 시군구 자신을 빼므로 좌표 없이는 질문이 성립하지 않는다. 그래서 위치를
  /// 얻지 못하면 [RegionRecommendationNeedsLocation]을 올려 화면이 권한 안내를 그린다.
  ///
  /// 목록 정렬은 **서버가 준 총점 내림차순을 그대로 유지한다**(R22) — 클라이언트가 다시
  /// 정렬하지 않는다.
  ///
  /// **재시도 상한은 여기 있지 않다.** provider의 생명주기(폐기·재생성·지연 빌드)에
  /// 횟수를 얹으면 "몇 번 조회됐나"가 구독 상태에 따라 달라진다 — 실제로 재시도 한 번에
  /// 요청이 두 번 나가거나, 상한을 넘겨 한 번 더 나가는 것을 측정했다. 횟수는 누른
  /// 사람이 세는 것이므로 화면이 [RegionRecommendationRetryCount]로 센다.
  /// **[mapCenter]가 있으면 그 좌표를, 없으면 내 위치를 기준으로 조회한다.**
  ///
  /// 사용자가 화면에서 기준을 바꿀 수 있으므로 인자로 받아 family가 된다 — 기준이
  /// 바뀌면 새 인자가 되어 이전 조회는 자동으로 버려지고, 두 기준의 결과가 각각
  /// 캐시된다(왔다 갔다 해도 다시 받지 않는다).
  const RegionRecommendationsProvider._({
    required RegionRecommendationsFamily super.from,
    required Coordinates? super.argument,
  }) : super(
         retry: null,
         name: r'regionRecommendationsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$regionRecommendationsHash();

  @override
  String toString() {
    return r'regionRecommendationsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<RegionRecommendationResult> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<RegionRecommendationResult> create(Ref ref) {
    final argument = this.argument as Coordinates?;
    return regionRecommendations(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is RegionRecommendationsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$regionRecommendationsHash() =>
    r'3fa6fe5591be03c7186961e298292e5925cdc1cb';

/// 지역 추천 목록(SPEC-0015).
///
/// **위치가 필수다.** 설계 초안(R27)은 "위치 없이도 추천이 나온다"였으나 서버가
/// `origin`을 필수로 확정했다 — 이 쿼리는 origin이 속한 시도 안에서만 후보를 고르고
/// origin의 시군구 자신을 빼므로 좌표 없이는 질문이 성립하지 않는다. 그래서 위치를
/// 얻지 못하면 [RegionRecommendationNeedsLocation]을 올려 화면이 권한 안내를 그린다.
///
/// 목록 정렬은 **서버가 준 총점 내림차순을 그대로 유지한다**(R22) — 클라이언트가 다시
/// 정렬하지 않는다.
///
/// **재시도 상한은 여기 있지 않다.** provider의 생명주기(폐기·재생성·지연 빌드)에
/// 횟수를 얹으면 "몇 번 조회됐나"가 구독 상태에 따라 달라진다 — 실제로 재시도 한 번에
/// 요청이 두 번 나가거나, 상한을 넘겨 한 번 더 나가는 것을 측정했다. 횟수는 누른
/// 사람이 세는 것이므로 화면이 [RegionRecommendationRetryCount]로 센다.
/// **[mapCenter]가 있으면 그 좌표를, 없으면 내 위치를 기준으로 조회한다.**
///
/// 사용자가 화면에서 기준을 바꿀 수 있으므로 인자로 받아 family가 된다 — 기준이
/// 바뀌면 새 인자가 되어 이전 조회는 자동으로 버려지고, 두 기준의 결과가 각각
/// 캐시된다(왔다 갔다 해도 다시 받지 않는다).

final class RegionRecommendationsFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<RegionRecommendationResult>,
          Coordinates?
        > {
  const RegionRecommendationsFamily._()
    : super(
        retry: null,
        name: r'regionRecommendationsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// 지역 추천 목록(SPEC-0015).
  ///
  /// **위치가 필수다.** 설계 초안(R27)은 "위치 없이도 추천이 나온다"였으나 서버가
  /// `origin`을 필수로 확정했다 — 이 쿼리는 origin이 속한 시도 안에서만 후보를 고르고
  /// origin의 시군구 자신을 빼므로 좌표 없이는 질문이 성립하지 않는다. 그래서 위치를
  /// 얻지 못하면 [RegionRecommendationNeedsLocation]을 올려 화면이 권한 안내를 그린다.
  ///
  /// 목록 정렬은 **서버가 준 총점 내림차순을 그대로 유지한다**(R22) — 클라이언트가 다시
  /// 정렬하지 않는다.
  ///
  /// **재시도 상한은 여기 있지 않다.** provider의 생명주기(폐기·재생성·지연 빌드)에
  /// 횟수를 얹으면 "몇 번 조회됐나"가 구독 상태에 따라 달라진다 — 실제로 재시도 한 번에
  /// 요청이 두 번 나가거나, 상한을 넘겨 한 번 더 나가는 것을 측정했다. 횟수는 누른
  /// 사람이 세는 것이므로 화면이 [RegionRecommendationRetryCount]로 센다.
  /// **[mapCenter]가 있으면 그 좌표를, 없으면 내 위치를 기준으로 조회한다.**
  ///
  /// 사용자가 화면에서 기준을 바꿀 수 있으므로 인자로 받아 family가 된다 — 기준이
  /// 바뀌면 새 인자가 되어 이전 조회는 자동으로 버려지고, 두 기준의 결과가 각각
  /// 캐시된다(왔다 갔다 해도 다시 받지 않는다).

  RegionRecommendationsProvider call(Coordinates? mapCenter) =>
      RegionRecommendationsProvider._(argument: mapCenter, from: this);

  @override
  String toString() => r'regionRecommendationsProvider';
}

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
    r'928cf3a750bad92f0dfc44c96ffcef349a5c308b';

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
