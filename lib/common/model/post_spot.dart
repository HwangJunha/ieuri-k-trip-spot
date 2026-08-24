import 'target_category.dart';

/// 글에 붙은 장소(서버 `PostSpot`).
///
/// **글에 장소가 없을 수 있다** — `Post.spot`은 nullable이고 장소 없는 글이 허용된다
/// (가이드 §5). 그런 글은 좌표 반경 조회에 잡히지 않는다(§10).
///
/// [title]·[thumbnailImageUrl]은 `Accept-Language`를 따른다(가이드 §9).
class PostSpot {
  const PostSpot({
    required this.id,
    required this.title,
    required this.thumbnailImageUrl,
    this.category,
  });

  /// 장소 식별자. 관광 도메인의 `spot.id`와 같은 식별자 공간이다.
  ///
  /// **id 자체는 언어와 무관하지만 열람 가능 여부는 아니다**(SPEC-0029). 이 구분이
  /// 요점이다:
  ///
  /// - **목록에서 방금 받은 id는 안전하다** — 서버가 활성 언어에서 해소되지 않는
  ///   spot이 붙은 글을 목록에 넣지 않으므로(R-23), 그 글의 장소는 지금 열린다.
  /// - **저장해 뒀다 쓰는 id는 안전하지 않다** — 그 사이 언어를 바꿨다면
  ///   `spotDetail(id:)`·`posts(catalogId:)`가 `SPOT_NOT_FOUND_IN_LOCALE`로 실패한다.
  ///
  /// 서버 스키마도 같은 문구로 무조건적 보장을 철회했다(`PostSpot.id`).
  final String id;

  /// 장소명. **활성 언어로 해소된 값이다**(SPEC-0029) — 한국어 고정이던 것이 바뀌었다.
  final String title;
  final String thumbnailImageUrl;

  /// 그 장소의 카테고리. **컴포저에서 기본값 제안에 쓴다** — 장소를 고르면 그
  /// 카테고리를 카테고리 선택의 기본값으로 제시한다(가이드 §5).
  ///
  /// 서버가 아직 매핑되지 않은 값을 추가했으면 null이며, 그때는 제안을 하지 않을
  /// 뿐 글 전체가 실패하지 않는다.
  final TargetCategory? category;

  @override
  bool operator ==(Object other) =>
      other is PostSpot &&
      other.id == id &&
      other.title == title &&
      other.thumbnailImageUrl == thumbnailImageUrl &&
      other.category == category;

  @override
  int get hashCode => Object.hash(id, title, thumbnailImageUrl, category);
}
