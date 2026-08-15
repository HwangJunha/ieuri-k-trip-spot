/// 스팟 카드류가 공유하는 여백·모서리·썸네일 치수(SPEC-0020 R9·AC9.3).
///
/// 카드마다 여백과 모서리 반경을 각자 하드코딩하던 것이 "카드가 제각각"의 기계적
/// 실체였다. 값을 한곳에 모아 카드들이 같은 리듬을 쓰게 한다.
///
/// **정보 위계는 통일하지 않는다**(R9 범위). `SpotCard`는 세로형(이미지 위·글 아래),
/// `LikedSpotCard`는 가로형이고, spot에는 작성자·댓글 수가 없어 커뮤니티 카드와 같은
/// 위계를 가질 수 없다. 여기서 맞추는 것은 치수뿐이다.
class CardMetrics {
  const CardMetrics._();

  /// 카드 바깥 모서리 반경.
  static const double radius = 12;

  /// 썸네일 모서리 반경. 카드 안에 들어앉으므로 바깥보다 한 단계 작다.
  static const double thumbnailRadius = 12;

  /// 카드 내부 콘텐츠 여백.
  static const double contentPadding = 8;

  /// 제목과 부가 정보(카테고리·주소·거리) 사이 간격.
  static const double titleGap = 4;

  /// 서로 다른 종류의 정보 묶음 사이 간격.
  static const double sectionGap = 8;

  /// 가로형 카드에서 썸네일과 글 사이 간격.
  static const double thumbnailGap = 12;

  /// 가로형 카드 썸네일의 한 변.
  static const double thumbnailSize = 104;

  /// 세로형 카드 썸네일 높이.
  static const double coverHeight = 120;
}
