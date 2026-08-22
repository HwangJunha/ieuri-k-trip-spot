// 칸 대표 랜드마크의 카테고리 5종. 면 색(틴트)을 이 값으로 고른다.
//
// 스펙 R12·R13: 서버가 주는 분류 중 landmark 는 culture 로 정규화해 들어온다.

enum LandmarkCategory {
  culture,
  heritage,
  nature,
  park,
  specialty,
}
