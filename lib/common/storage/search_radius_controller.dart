import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'app_preferences.dart';

part 'search_radius_controller.g.dart';

/// 설정의 km 값을 서버가 받는 미터로 바꾼다.
///
/// **0km는 null이 된다**(R13 네 번째 기준 — "현재 위치만"). 서버의 `radiusMeters`는
/// 선택 인자이고 0을 보내면 반경 0인 원이라 아무것도 걸리지 않는데, 사용자가 뜻한
/// 것은 "가장 가까운 것부터"이지 "빈 결과"가 아니다. 인자를 빼면 서버 기본값으로
/// 조회되고 결과는 거리순으로 온다.
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
}
