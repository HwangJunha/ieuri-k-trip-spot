import 'copyright_type.dart';

/// 상세 갤러리 이미지 한 장(SPEC-0003). TourAPI detailImage2가 이미지별
/// cpyrhtDivCd를 주므로 저작권·문구는 **이미지별**이며 부모 Spot에서 상속하지 않는다.
///
/// 순수 도메인 값객체 — 위젯·전송 타입 의존 없음. repository가 생성 타입에서 매핑한다.
///
/// [imageUrl]은 항상 존재(url 없는 항목은 갤러리에 안 들어감), [thumbnailUrl]·[caption]은
/// nullable(TourAPI가 항목별로 보장하지 않음).
class SpotImage {
  const SpotImage({
    required this.imageUrl,
    required this.copyright,
    required this.attributionText,
    this.thumbnailUrl,
    this.caption,
  });

  final String imageUrl;

  /// 축소본. 없을 수 있어 nullable — 없으면 [imageUrl]로 폴백한다.
  final String? thumbnailUrl;

  /// 이미지 설명(TourAPI imgname). 자주 없어 nullable.
  final String? caption;

  /// 이미지별 저작권 유형. 부모 [SpotDetail.copyright]와 독립.
  final CopyrightType copyright;

  /// 이미지별 저작권 문구(유형에서 도출). 배지로 노출한다(AC-28).
  final String attributionText;

  @override
  bool operator ==(Object other) =>
      other is SpotImage &&
      other.imageUrl == imageUrl &&
      other.thumbnailUrl == thumbnailUrl &&
      other.caption == caption &&
      other.copyright == copyright &&
      other.attributionText == attributionText;

  @override
  int get hashCode =>
      Object.hash(imageUrl, thumbnailUrl, caption, copyright, attributionText);
}
