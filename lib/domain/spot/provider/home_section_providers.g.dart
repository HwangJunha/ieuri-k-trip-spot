// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_section_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 홈 "Near you" 섹션(R16). 설정된 반경 안의 spot을 서버가 계산한 거리순으로 준다.
///
/// **Discover와 같은 `spots` 쿼리를 재사용한다**(설계 §3). 홈 전용 조회 경로를
///따로 두면 같은 데이터에 두 규약이 생긴다.
///
/// 좌표와 반경을 `watch`하는 것이 AC-16.2를 만족시키는 지점이다 — 설정에서 반경을
/// 바꾸면 이 provider가 무효화되어 다음 조회에 새 값이 실린다. `read`로 하면 값은
/// 읽히지만 다시 부를 계기가 없어 옛 반경 결과가 그대로 남는다.
///
/// **세 홈 섹션은 각각 독립된 provider다**(R19). 하나로 묶으면 한 섹션의 실패가
/// 화면 전체를 무너뜨려 AC-19.1을 위반한다. 재시도도 이 provider 하나만
/// 무효화하므로 다른 섹션은 건드리지 않는다(AC-20.2).

@ProviderFor(nearbySpotsSection)
const nearbySpotsSectionProvider = NearbySpotsSectionProvider._();

/// 홈 "Near you" 섹션(R16). 설정된 반경 안의 spot을 서버가 계산한 거리순으로 준다.
///
/// **Discover와 같은 `spots` 쿼리를 재사용한다**(설계 §3). 홈 전용 조회 경로를
///따로 두면 같은 데이터에 두 규약이 생긴다.
///
/// 좌표와 반경을 `watch`하는 것이 AC-16.2를 만족시키는 지점이다 — 설정에서 반경을
/// 바꾸면 이 provider가 무효화되어 다음 조회에 새 값이 실린다. `read`로 하면 값은
/// 읽히지만 다시 부를 계기가 없어 옛 반경 결과가 그대로 남는다.
///
/// **세 홈 섹션은 각각 독립된 provider다**(R19). 하나로 묶으면 한 섹션의 실패가
/// 화면 전체를 무너뜨려 AC-19.1을 위반한다. 재시도도 이 provider 하나만
/// 무효화하므로 다른 섹션은 건드리지 않는다(AC-20.2).

final class NearbySpotsSectionProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<TouristSpot>>,
          List<TouristSpot>,
          FutureOr<List<TouristSpot>>
        >
    with
        $FutureModifier<List<TouristSpot>>,
        $FutureProvider<List<TouristSpot>> {
  /// 홈 "Near you" 섹션(R16). 설정된 반경 안의 spot을 서버가 계산한 거리순으로 준다.
  ///
  /// **Discover와 같은 `spots` 쿼리를 재사용한다**(설계 §3). 홈 전용 조회 경로를
  ///따로 두면 같은 데이터에 두 규약이 생긴다.
  ///
  /// 좌표와 반경을 `watch`하는 것이 AC-16.2를 만족시키는 지점이다 — 설정에서 반경을
  /// 바꾸면 이 provider가 무효화되어 다음 조회에 새 값이 실린다. `read`로 하면 값은
  /// 읽히지만 다시 부를 계기가 없어 옛 반경 결과가 그대로 남는다.
  ///
  /// **세 홈 섹션은 각각 독립된 provider다**(R19). 하나로 묶으면 한 섹션의 실패가
  /// 화면 전체를 무너뜨려 AC-19.1을 위반한다. 재시도도 이 provider 하나만
  /// 무효화하므로 다른 섹션은 건드리지 않는다(AC-20.2).
  const NearbySpotsSectionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'nearbySpotsSectionProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$nearbySpotsSectionHash();

  @$internal
  @override
  $FutureProviderElement<List<TouristSpot>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<TouristSpot>> create(Ref ref) {
    return nearbySpotsSection(ref);
  }
}

String _$nearbySpotsSectionHash() =>
    r'e2b17ac487a3b8f3650351cd9bbb71008bb798ab';

/// 홈 "Popular" 섹션(R18). 반경 안의 spot을 누적 좋아요 총합 내림차순으로 준다.
///
/// **최소 좋아요 수 미만은 서버가 이미 걸러 낸다**(AC-18.2) — 표본이 적으면 순위가
/// 사실상 잡음이기 때문이고, 그 판단은 서버 몫이라 클라이언트가 다시 거르지 않는다.
/// 그 기준은 SPEC-0029에서 10에서 5로 낮아졌으나 **클라이언트가 아는 값이 아니다** —
/// 숫자를 여기 박아 두면 서버가 다시 바꿀 때 어긋난다. 정렬도 계약이므로 재정렬하지
/// 않는다(POL-019).
///
/// 좋아요가 **활성 언어별로 집계된다**(SPEC-0029). 언어를 바꾸면 같은 지역에서도
/// 다른 목록이 나오는데, 이는 데이터가 사라진 것이 아니라 축이 다른 것이다.
///
/// 조건을 만족하는 spot이 0건인 것은 정상 상태다(AC-18.4) — 특히 초기 데이터
/// 상황에서는 대부분 비어 있을 것으로 예상된다(설계 §2).
///
/// Near you와 마찬가지로 좌표·반경을 `watch`하고, 이 provider 하나만 무효화하면
/// 이 섹션만 다시 조회된다(R19·R20).

@ProviderFor(popularSpotsSection)
const popularSpotsSectionProvider = PopularSpotsSectionProvider._();

/// 홈 "Popular" 섹션(R18). 반경 안의 spot을 누적 좋아요 총합 내림차순으로 준다.
///
/// **최소 좋아요 수 미만은 서버가 이미 걸러 낸다**(AC-18.2) — 표본이 적으면 순위가
/// 사실상 잡음이기 때문이고, 그 판단은 서버 몫이라 클라이언트가 다시 거르지 않는다.
/// 그 기준은 SPEC-0029에서 10에서 5로 낮아졌으나 **클라이언트가 아는 값이 아니다** —
/// 숫자를 여기 박아 두면 서버가 다시 바꿀 때 어긋난다. 정렬도 계약이므로 재정렬하지
/// 않는다(POL-019).
///
/// 좋아요가 **활성 언어별로 집계된다**(SPEC-0029). 언어를 바꾸면 같은 지역에서도
/// 다른 목록이 나오는데, 이는 데이터가 사라진 것이 아니라 축이 다른 것이다.
///
/// 조건을 만족하는 spot이 0건인 것은 정상 상태다(AC-18.4) — 특히 초기 데이터
/// 상황에서는 대부분 비어 있을 것으로 예상된다(설계 §2).
///
/// Near you와 마찬가지로 좌표·반경을 `watch`하고, 이 provider 하나만 무효화하면
/// 이 섹션만 다시 조회된다(R19·R20).

final class PopularSpotsSectionProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<PopularSpot>>,
          List<PopularSpot>,
          FutureOr<List<PopularSpot>>
        >
    with
        $FutureModifier<List<PopularSpot>>,
        $FutureProvider<List<PopularSpot>> {
  /// 홈 "Popular" 섹션(R18). 반경 안의 spot을 누적 좋아요 총합 내림차순으로 준다.
  ///
  /// **최소 좋아요 수 미만은 서버가 이미 걸러 낸다**(AC-18.2) — 표본이 적으면 순위가
  /// 사실상 잡음이기 때문이고, 그 판단은 서버 몫이라 클라이언트가 다시 거르지 않는다.
  /// 그 기준은 SPEC-0029에서 10에서 5로 낮아졌으나 **클라이언트가 아는 값이 아니다** —
  /// 숫자를 여기 박아 두면 서버가 다시 바꿀 때 어긋난다. 정렬도 계약이므로 재정렬하지
  /// 않는다(POL-019).
  ///
  /// 좋아요가 **활성 언어별로 집계된다**(SPEC-0029). 언어를 바꾸면 같은 지역에서도
  /// 다른 목록이 나오는데, 이는 데이터가 사라진 것이 아니라 축이 다른 것이다.
  ///
  /// 조건을 만족하는 spot이 0건인 것은 정상 상태다(AC-18.4) — 특히 초기 데이터
  /// 상황에서는 대부분 비어 있을 것으로 예상된다(설계 §2).
  ///
  /// Near you와 마찬가지로 좌표·반경을 `watch`하고, 이 provider 하나만 무효화하면
  /// 이 섹션만 다시 조회된다(R19·R20).
  const PopularSpotsSectionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'popularSpotsSectionProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$popularSpotsSectionHash();

  @$internal
  @override
  $FutureProviderElement<List<PopularSpot>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<PopularSpot>> create(Ref ref) {
    return popularSpotsSection(ref);
  }
}

String _$popularSpotsSectionHash() =>
    r'3fd36953f0a39f10009cab00d9c0deb0561bb7e9';
