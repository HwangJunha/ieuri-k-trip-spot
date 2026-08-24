import '../../../common/pagination/offset_page.dart';
import 'tourist_spot.dart';

/// 검색 결과 한 페이지(R1·R7).
///
/// **오프셋 페이징이다.** 초안(스펙 §8.1)은 커서를 요구했으나 — BM25 점수 동점이
/// 흔해 offset이면 순서가 흔들린다는 이유였다 — 서버가 커서 방식에서 정확히
/// 동작하지 않아 `page`/`size`로 전환했다. 기존 `spots`와 같은 방식이므로
/// `common/pagination`의 [OffsetPage]를 그대로 쓴다(CLAUDE.md §4 — 기능이 자기
/// 페이지네이션을 새로 만들지 않는다).
///
/// [totalCount]를 따로 감싸는 이유는 검색 페이지가 "N개 결과"를 표시하기 때문이다.
/// [OffsetPage.totalCount]는 nullable인데 검색 계약은 non-null이라, 화면이 null
/// 분기를 하지 않도록 여기서 확정한다.
class SpotSearchResult {
  const SpotSearchResult({required this.page, required this.totalCount});

  /// 빈 결과. **정상 상태이며 실패가 아니다**(AC-11.2).
  static const SpotSearchResult empty = SpotSearchResult(
    page: OffsetPage<TouristSpot>(
      items: <TouristSpot>[],
      page: 0,
      hasNext: false,
    ),
    totalCount: 0,
  );

  /// 이 페이지의 spot과 페이지 번호. 다음 장은 `page + 1`로 요청한다.
  final OffsetPage<TouristSpot> page;

  /// 반경 안에서 질의에 일치한 전체 건수.
  final int totalCount;

  List<TouristSpot> get spots => page.items;

  bool get isEmpty => page.items.isEmpty;

  bool get hasNextPage => page.hasNext;

  /// 마지막으로 받은 페이지 번호(0-based).
  int get pageNumber => page.page;

  /// 다음 페이지를 이어 붙인 결과. 총 건수는 최신 응답의 값을 쓴다.
  SpotSearchResult append(SpotSearchResult next) => SpotSearchResult(
    page: OffsetPage<TouristSpot>(
      items: <TouristSpot>[...page.items, ...next.page.items],
      page: next.page.page,
      hasNext: next.page.hasNext,
      totalCount: next.totalCount,
    ),
    totalCount: next.totalCount,
  );
}
