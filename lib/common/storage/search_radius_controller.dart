import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'app_preferences.dart';

part 'search_radius_controller.g.dart';

/// "반경 넓히기"가 한 번에 올리는 폭(km).
///
/// 20km 안팎에서 한 단계가 의미 있게 넓어지되, 100km 상한까지 몇 번이면 닿는 크기다.
/// 배로 늘리는 방식(1→2→4)은 작은 값에서 체감이 없고 큰 값에서 상한을 바로 넘긴다.
const double searchRadiusStepKm = 10;

/// 설정의 km 값을 서버가 받는 미터로 바꾼다.
///
/// **0 이하는 null이 된다** — 반경 0인 원에는 아무것도 걸리지 않으므로 인자를 빼
/// 서버 기본값으로 조회한다. 설정에서 고를 수 있는 최소는 1km이고
/// ([AppPreferences.minSearchRadiusKm]) 이 경로는 낡은 저장값에 대한 방어다.
int? radiusMetersOf(double km) => km <= 0 ? null : (km * 1000).round();

/// 검색 반경(km) 설정을 들고 있는 컨트롤러(SPEC-0011 R13).
///
/// **서버 상태가 아니다** — 로컬 [AppPreferences]에만 산다.
///
/// **왜 `common/`에 있는가.** 설정 화면이 값을 정하지만 쓰는 쪽은 조회다 —
/// Discover 스와이프(`domain/spot`)가 이 값을 조회 반경으로 보낸다. 설정 기능 안에
/// 두면 spot이 settings를 import하게 되어 기능 간 의존이 생긴다(CLAUDE.md §3).
/// 언어 설정([LocaleController])이 같은 이유로 `common/`에 있는 것과 같다.
///
/// `autoDispose`(codegen 기본)로 둔다. 값을 지키는 것은 이 provider가 아니라
/// SharedPreferences이므로 화면을 벗어나 버려져도 다음에 같은 값이 복원되고,
/// `build()`는 이미 로드된 인스턴스에서 동기로 읽는 한 줄이라 되살리는 비용이
/// 사실상 없다. 살려 둘 이유가 생기기 전에 살려 두지 않는다(CLAUDE.md §5).
@riverpod
class SearchRadiusController extends _$SearchRadiusController {
  @override
  double build() => ref.watch(appPreferencesProvider).searchRadiusKm;

  /// 반경을 저장한다. **0은 유효값이다**(R13) — "현재 위치만"을 뜻하므로
  /// 미설정으로 취급해 기본값으로 되돌리면 안 된다.
  Future<void> select(double km) async {
    final double clamped = km.clamp(
      AppPreferences.minSearchRadiusKm,
      AppPreferences.maxSearchRadiusKm,
    );
    await ref.read(appPreferencesProvider).saveSearchRadiusKm(clamped);
    state = clamped;
  }

  /// 반경을 한 단계 넓힌다. Discover의 빈 상태 "반경 넓히기"가 쓴다.
  ///
  /// **이미 상한이면 아무 일도 하지 않고 false를 돌려준다.** 상한에서 눌렀을 때
  /// 같은 값을 다시 저장하면 상태가 안 바뀌어 피드도 다시 받지 않는데, 화면은
  /// 눌렀다고 생각한다 — 호출부가 "더 넓힐 수 없다"를 안내할 수 있게 결과를 준다.
  ///
  /// 한 단계([searchRadiusStepKm])씩 넓힌다. 상한에 닿아 있으면 `false`를 준다.
  ///
  /// 0km 전용 분기는 걷어냈다 — 최소가 1km라 그 상태가 생기지 않는다
  /// ([AppPreferences.minSearchRadiusKm]).
  Future<bool> widen() async {
    final double current = state;
    if (current >= AppPreferences.maxSearchRadiusKm) return false;

    await select(current + searchRadiusStepKm);
    return true;
  }
}
