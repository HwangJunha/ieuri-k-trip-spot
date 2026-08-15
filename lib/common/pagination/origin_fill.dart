/// **원문을 먼저 채우고 모자란 만큼 번역본으로 보충한다**(SPEC-0019).
///
/// 서버가 `hasOrigin`으로 장소를 가른다 — true면 요청 언어로 **쓰인** 원문만, false면
/// **번역된** 것만 오며 두 집합은 서로 겹치지 않는다. 생략하면 둘 다 온다.
///
/// 목표 건수가 정해진 화면(홈 섹션, 지도 마커 상한)은 "끝에 도달하면 다음"이라는
/// 계기가 없다. 그래서 **한 번에 목표를 채운다** — 원문이 3건뿐이면 나머지 7건을
/// 번역본에서 가져온다. 원문만 걸고 끝내면 그 지역에서 번역본은 영영 보이지 않는다.
///
/// **원문이 목표를 채웠으면 두 번째 조회를 하지 않는다.** 대부분의 지역이 이 경로라
/// 추가 왕복이 생기지 않는다.
///
/// `common/`에 두는 이유는 spot·event 두 기능이 쓰기 때문이다(CLAUDE.md §4).
/// [fetch]는 `(hasOrigin, size)`를 받아 그만큼 조회한다.
Future<List<T>> fillWithTranslated<T>({
  required int target,
  required Future<List<T>> Function(bool hasOrigin, int size) fetch,
}) async {
  final List<T> origin = await fetch(true, target);
  if (origin.length >= target) return origin;

  // 번역본은 **부족한 만큼만** 요청한다. 목표 전체를 다시 받아 잘라내면 서버가
  // 쓸데없이 더 많은 행을 만든다.
  final List<T> translated = await fetch(false, target - origin.length);
  return <T>[...origin, ...translated];
}
