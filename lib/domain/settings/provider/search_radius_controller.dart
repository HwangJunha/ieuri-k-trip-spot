import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../common/storage/app_preferences.dart';

part 'search_radius_controller.g.dart';

/// 검색 반경(km) 설정을 들고 있는 컨트롤러(SPEC-0011 R13).
///
/// **서버 상태가 아니다** — 로컬 [AppPreferences]에만 산다. 이 값을 실제 조회에
/// 반영하는 것은 이 스펙의 인수 기준에 없고, 저장과 복원까지가 범위다.
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
