import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../common/location/coordinates.dart';
import '../../../common/location/location_providers.dart';
import '../../../common/location/location_service.dart';
import '../../../common/network/network_retry_policy.dart';
import '../model/region_recommendation.dart';
import 'map_providers.dart';
import '../../auth/provider/session_scope.dart';

part 'region_recommendation_provider.g.dart';

/// 재시도 상한(R28 · POL-040).
///
/// **시간 기반이 아니라 횟수 상한이다**(§5.2). 응답 시간 목표(POL-029)에 근거가 없는
/// 동안 "몇 초 뒤 재시도" 같은 수치는 근거 없는 값이 된다. SPEC-0006이 같은 처리를
/// 했고 그것이 POL-040의 출처다.
const int regionRecommendationRetryLimit = 3;

/// 위치가 없어 추천을 요청조차 할 수 없는 상태(설계 §9.3).
///
/// **오류가 아니라 안내로 그려야 한다.** 화면은 이 예외를 만나면 실패 문구 대신 권한
/// 요청·설정 이동을 안내한다 — 재시도 버튼을 눌러도 권한이 생기지 않으므로 일반
/// 오류와 같은 취급을 하면 사용자가 해결되지 않는 재시도를 반복한다.
class RegionRecommendationNeedsLocation implements Exception {
  const RegionRecommendationNeedsLocation(this.reason);

  final LocationUnavailableReason reason;

  @override
  String toString() => 'RegionRecommendationNeedsLocation($reason)';
}

/// 이 화면의 재시도 정책(2026-08-29).
///
/// **공통 정책을 그대로 쓰면 위치 부재에 백오프가 돈다.** `defaultNetworkRetry`는
/// `LocationUnavailable`을 걸러 내는데, 이 provider는 그것을
/// [RegionRecommendationNeedsLocation]으로 **갈아 끼워** 던진다. 정책이 그 타입을
/// 알 리 없으니 네트워크 오류로 보고 5회를 지수 백오프로 돌렸고, 위치를 끈
/// 사용자는 안내가 뜨기까지 10초 가까이 스피너만 봤다(사용자 지적 — "계속
/// 빙글빙글 돌다가").
///
/// 위치가 없다는 사실은 다시 물어도 달라지지 않는다. 곧바로 안내로 보낸다.
Duration? regionRecommendationRetry(int retryCount, Object error) {
  if (error is RegionRecommendationNeedsLocation) return null;
  return defaultNetworkRetry(retryCount, error);
}

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
@Riverpod(retry: regionRecommendationRetry)
Future<RegionRecommendationResult> regionRecommendations(
  Ref ref,
  Coordinates? mapCenter,
) async {
  final Coordinates origin = mapCenter ?? await _resolveOrigin(ref);
  return ref
      .read(mapRepositoryProvider)
      .fetchRecommendedRegions(origin: origin);
}

/// 위치를 얻는다. 실패하면 **일반 오류와 구분되는** 예외로 바꿔 올린다.
Future<Coordinates> _resolveOrigin(Ref ref) async {
  try {
    return await ref.read(locationServiceProvider).currentCoordinates();
  } on LocationUnavailable catch (e) {
    throw RegionRecommendationNeedsLocation(e.reason);
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
  int build() {
    // 로그아웃하면 재시도 횟수를 되돌린다.
    ref.watchSignedIn();
    return 0;
  }

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
