import 'spot_category.dart';
import 'spot_category_selection.dart';

/// 카테고리 다중 선택 토글(SPEC-0020 R2·R3·R4).
///
/// **화면별 provider 네 개가 같은 규칙을 쓴다**(Discover·좋아요·검색·지도). R12가
/// 화면 독립을 요구하므로 provider는 넷으로 나뉘어 있지만, "어떻게 토글하는가"는 같은
/// 규칙이라 여기 한 번만 적는다 — provider마다 복사하면 한 곳만 고쳐 규칙이 갈린다.
///
/// **빈 집합이 "전체"다**(사용자 결정, 2026-08-15). 바 맨 앞에 "전체" 칩이 생기면서
/// 아무것도 고르지 않은 상태가 막다른 곳이 아니라 정상 상태가 됐다 — 서버에는
/// 카테고리 인자를 보내지 않아 전체가 온다([SpotCategorySelection.codesOrNull]이
/// null로 접는다). 그래서 예전의 "마지막 1개 해제 불가"(AC3.1)와 진입 시 기본값
/// 심기(AC4.1·AC4.2)는 함께 사라졌다.
///
/// **토글 로직이 위젯이 아니라 provider에 있는 이유**(설계 §선택 상태를 provider로
/// 올린다): 위젯 없이 테스트가 성립해야 한다.
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
  /// 마지막 하나를 꺼도 막지 않는다 — 빈 집합은 "전체"이며 바의 "전체" 칩이 저절로
  /// 켜진다. 되돌릴 방법이 있는 상태라 막을 이유가 없어졌다.
  void toggle(SpotCategory category) {
    final Set<SpotCategory> next = <SpotCategory>{...state};
    if (!next.remove(category)) next.add(category);
    state = next;
  }

  /// 선택을 [categories]로 통째로 바꾼다. 빈 집합이면 "전체"가 된다.
  void replace(Set<SpotCategory> categories) {
    state = <SpotCategory>{...categories};
  }

  /// "전체"로 되돌린다 — 개별 선택을 전부 푼다.
  ///
  /// 서버에는 카테고리 인자를 **보내지 않는다**(빈 배열은 `EmptyCategorySetException`으로
  /// 거절된다) — [SpotCategorySelection.codesOrNull]이 그 접기를 맡는다.
  void selectAll() => state = <SpotCategory>{};

  /// family 인자·조회 변수로 쓸 안정 키(AC5.1·AC5.2).
  ///
  /// `Set`은 값 동등성이 없어 family 인자로 직접 쓸 수 없다 —
  /// [SpotCategorySelection]이 그 함정을 감싼다.
  SpotCategorySelection get selection => SpotCategorySelection(state);
}
