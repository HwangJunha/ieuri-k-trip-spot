import '../../../common/category/spot_category_selection.dart';

/// 상세 라우트의 `source` 쿼리 파라미터 값 — 추천 세션에서 열렸다는 표시(SPEC-0035).
/// 전체 목록 세션은 파라미터를 싣지 않는다.
const String swipeSourceRecommended = 'recommended';

/// Discover 스와이프 세션 하나를 가리키는 키(SPEC-0035 R10). `SwipeController`의
/// family 인자이며 상세 화면이 "어느 세션에서 열렸는가"를 되돌릴 때도 쓴다.
///
/// 두 축이다:
/// - [recommended] — 소스. 참이면 `recommendedSpots` **묶음**(추천, 페이지 없음),
///   거짓이면 `spots` 오프셋 목록(전체).
/// - [selection] — 카테고리 필터. 두 소스 모두에 얹힌다(사용자 결정 2026-09-12 —
///   「추천」은 칩처럼 다른 칩과 함께 켜진다).
///
/// 값 동등성은 두 축 모두로 정의한다 — 같은 필터라도 소스가 다르면 다른 세션이고,
/// 큐도 재시도 예산도 따로다. 순수 Dart.
class SwipeFeedKey {
  const SwipeFeedKey({required this.recommended, required this.selection});

  /// 소스가 추천 묶음인가.
  final bool recommended;

  /// 카테고리 필터. 비어 있으면 서버에 인자를 보내지 않는다(전체).
  final SpotCategorySelection selection;

  /// 재시도 예산·로그용 안정 문자열. 소스가 앞에 붙어 같은 필터의 두 소스가
  /// 예산을 나눠 쓰지 않는다.
  String get scopeKey =>
      '${recommended ? 'recommended' : 'all'}/${selection.codes.join(',')}';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SwipeFeedKey &&
          other.recommended == recommended &&
          other.selection == selection);

  @override
  int get hashCode => Object.hash(recommended, selection);

  @override
  String toString() => 'SwipeFeedKey($scopeKey)';
}
