import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../common/location/coordinates.dart';
import '../../../common/location/location_providers.dart';
import '../../../common/location/location_service.dart';
import '../model/region_recommendation.dart';
import 'map_providers.dart';

part 'region_recommendation_provider.g.dart';

/// 재시도 상한(R28 · POL-040).
///
/// **시간 기반이 아니라 횟수 상한이다**(§5.2). 응답 시간 목표(POL-029)에 근거가 없는
/// 동안 "몇 초 뒤 재시도" 같은 수치는 근거 없는 값이 된다. SPEC-0006이 같은 처리를
/// 했고 그것이 POL-040의 출처다.
const int regionRecommendationRetryLimit = 3;

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
@riverpod
Future<RegionRecommendationResult> regionRecommendations(Ref ref) async {
  final Coordinates? origin = await _resolveOrigin(ref);
  return ref
      .read(mapRepositoryProvider)
      .fetchRecommendedRegions(origin: origin);
}

/// 위치를 얻되 **실패를 삼킨다**(§4.1).
///
/// 권한 거부·서비스 꺼짐은 이 화면에서 오류가 아니다. 좌표 없이 요청하면 거리 항목만
/// 빠지고 추천은 그대로 나온다.
Future<Coordinates?> _resolveOrigin(Ref ref) async {
  try {
    return await ref.read(locationServiceProvider).currentCoordinates();
  } on LocationUnavailable {
    return null;
  }
}

/// 사용자가 재시도를 몇 번 썼는지(R28 · POL-040).
///
/// 화면이 재시도를 누르기 전에 [canRetry]를 확인하고, 누른 뒤 [record]로 센다.
/// 조회 자체는 `ref.invalidate(regionRecommendationsProvider)`로 다시 돈다.
///
/// **상한에 걸리면 화면이 버튼을 비활성화한다** — 해결되지 않는 재시도를 반복하게
/// 두지 않는다.
@Riverpod(keepAlive: true)
class RegionRecommendationRetryCount extends _$RegionRecommendationRetryCount {
  @override
  int build() => 0;

  /// 아직 재시도를 쓸 수 있는지.
  bool get canRetry => state < regionRecommendationRetryLimit;

  /// 남은 횟수. 화면이 "n번 남음"으로 쓸 수 있다.
  int get remaining => regionRecommendationRetryLimit - state;

  /// 재시도 1회를 쓴다. 상한을 넘겨 늘어나지 않는다.
  void record() {
    if (!canRetry) return;
    state = state + 1;
  }

  /// 목록을 처음부터 다시 여는 경우(화면 재진입 등).
  void reset() => state = 0;
}
