/// 진행 중인 축제 한 건(SPEC-0013 R17).
///
/// 순수 도메인: flutter/graphql/riverpod 미의존.
///
/// **카테고리와 저작권 유형을 담지 않는다.** `ongoingFestivals`는 축제만 반환하므로
/// 카테고리가 항상 같아 화면에 드러낼 정보가 못 되고, 두 값의 enum은 `domain/spot`이
/// 소유하고 있어 여기서 쓰면 기능 간 의존이 생긴다(CLAUDE.md §3). 대신 이 카드가
/// 실제로 보여줄 것은 **행사 기간**이다.
///
/// [attributionText]는 문자열이라 의존을 만들지 않으면서 출처 표기 의무를 지킨다.
class Festival {
  const Festival({
    required this.id,
    required this.title,
    required this.thumbnailImageUrl,
    required this.distanceMeters,
    required this.attributionText,
    required this.startDate,
    required this.endDate,
    this.address,
  });

  final String id;
  final String title;
  final String thumbnailImageUrl;

  /// 서버가 계산한 미터 거리.
  final int distanceMeters;

  /// 최소 출처 표기(TourAPI 규약).
  final String attributionText;

  /// 행사 시작일·종료일. 시각 성분이 없다 — 원본이 DATE 컬럼이다.
  ///
  /// **파싱에 실패한 행은 목록에서 제외된다**(AC-17.5) — 계약이 두 날짜를 non-null로
  /// 선언하므로 매핑할 수 없는 행을 내보낼 수 없다. 그래서 이 필드는 non-null이다.
  final DateTime startDate;
  final DateTime endDate;

  final String? address;

  @override
  bool operator ==(Object other) =>
      other is Festival &&
      other.id == id &&
      other.title == title &&
      other.thumbnailImageUrl == thumbnailImageUrl &&
      other.distanceMeters == distanceMeters &&
      other.attributionText == attributionText &&
      other.startDate == startDate &&
      other.endDate == endDate &&
      other.address == address;

  @override
  int get hashCode => Object.hash(
    id,
    title,
    thumbnailImageUrl,
    distanceMeters,
    attributionText,
    startDate,
    endDate,
    address,
  );
}
