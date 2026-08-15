import 'spot_category.dart';
import 'spot_category_selection.dart';

/// 카테고리 다중 선택 토글(SPEC-0020 R2·R3·R4).
///
/// **화면별 provider 세 개가 같은 규칙을 쓴다**(Discover·좋아요·검색). R12가 화면
/// 독립을 요구하므로 provider는 셋으로 나뉘어 있지만, "어떻게 토글하는가"는 같은
/// 규칙이라 여기 한 번만 적는다 — provider마다 복사하면 한 곳만 고쳐 규칙이 갈린다.
///
/// **토글 로직이 위젯이 아니라 provider에 있는 이유**(설계 §선택 상태를 provider로
/// 올린다): 위젯 없이 테스트가 성립해야 한다. 마지막 1개 해제 불가(AC3.1)는 화면이
/// 아니라 상태의 성질이다.
/// **`on Notifier<...>` 제약을 걸지 않는 이유**: riverpod_generator가 만드는 기반
/// 클래스 이름은 생성 코드의 내부 사정이라(버전마다 `Notifier`/`$Notifier`로 바뀐다)
/// 여기에 못 박으면 codegen 업그레이드가 이 파일을 깬다. 대신 [state]만 계약으로
/// 요구한다 — 필요한 것이 그것뿐이다.
mixin SpotCategoryToggle {
  /// 구현체(생성된 Notifier)가 제공하는 선택 상태.
  Set<SpotCategory> get state;
  set state(Set<SpotCategory> value);

  /// [category]를 켜거나 끈다(AC2.1·AC2.2).
  ///
  /// **마지막 하나는 해제되지 않는다**(AC3.1·AC3.2). 빈 집합은 서버가
  /// `EMPTY_CATEGORY_SET`으로 거절하는 데다, 아무것도 선택되지 않은 화면은 사용자가
  /// 되돌릴 방법이 없는 막다른 상태다 — 9개를 전부 골랐다가 8번 해제하면 크기 1로
  /// 남고, 9번째 해제는 아무 일도 하지 않는다.
  void toggle(SpotCategory category) {
    final Set<SpotCategory> next = <SpotCategory>{...state};
    if (next.contains(category)) {
      if (next.length == 1) return; // 마지막 1개는 유지한다.
      next.remove(category);
    } else {
      next.add(category);
    }
    state = next;
  }

  /// 선택을 [categories]로 통째로 바꾼다. 빈 집합 요청은 무시한다 — [toggle]과 같은
  /// 이유로 비어 있을 수 없는 상태다.
  void replace(Set<SpotCategory> categories) {
    if (categories.isEmpty) return;
    state = <SpotCategory>{...categories};
  }

  /// 아직 아무것도 고르지 않았다면 기본값을 심는다(R4).
  ///
  /// 기본은 코드가 `TOURIST_SPOT`인 카테고리이며, [available]에 그것이 없으면 **목록의
  /// 첫 값**으로 떨어진다(AC4.1·AC4.2). 언어마다 가용 목록이 다르기 때문이다(KO에는
  /// `TRAVEL_COURSE`가 있고 비KO에는 그 자리에 `TRANSPORT`가 있다) — 목록에 없는 값을
  /// 기본으로 두면 어떤 칩도 선택되지 않은 화면이 나온다.
  ///
  /// **이미 고른 것이 있으면 건드리지 않는다.** 목록은 비동기로 오므로 이 호출은
  /// 화면이 다시 그려질 때마다 반복되는데, 매번 덮으면 사용자의 선택이 지워진다.
  ///
  /// [available]이 비어 있으면 아무 일도 하지 않는다 — 심을 값이 없다.
  void seedDefault(List<SpotCategory> available) {
    if (state.isNotEmpty || available.isEmpty) return;
    final SpotCategory fallback = available.firstWhere(
      (SpotCategory c) => c.code == kDefaultSpotCategoryCode,
      orElse: () => available.first,
    );
    state = <SpotCategory>{fallback};
  }

  /// family 인자·조회 변수로 쓸 안정 키(AC5.1·AC5.2).
  ///
  /// `Set`은 값 동등성이 없어 family 인자로 직접 쓸 수 없다 —
  /// [SpotCategorySelection]이 그 함정을 감싼다.
  SpotCategorySelection get selection => SpotCategorySelection(state);
}
