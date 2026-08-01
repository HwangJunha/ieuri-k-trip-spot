import 'copyright_type.dart';
import 'spot_category.dart';
import 'spot_image.dart';

/// 관광지 상세(SPEC-0003). Discover 스와이프의 [TouristSpot]과 별개인 상세 전용
/// read shape다 — 스와이프는 대량 리스트라 상세 필드를 얹지 않는다(contract §SpotDetail).
///
/// 순수 도메인 모델 — 위젯·GraphQL·Riverpod 의존 없음. repository가 생성 타입
/// (`Query$SpotDetail$spotDetail`)에서 이 모델로 매핑하고, provider·view·component는
/// 이 모델만 본다(POL-020, AC-32).
///
/// nullable 필드([overview]·[address]·[homepage]·[tel])는 값 없으면 해당 섹션을
/// 렌더하지 않는다(AC-25 — 빈 라벨/placeholder 금지). [gallery]는 빈 배열일 수 있고
/// (null 아님), 그때 UI는 [thumbnailImageUrl]로 폴백한다(AC-27).
class SpotDetail {
  const SpotDetail({
    required this.id,
    required this.title,
    required this.category,
    required this.thumbnailImageUrl,
    required this.copyright,
    required this.attributionText,
    required this.gallery,
    required this.likeCount,
    this.overview,
    this.address,
    this.homepage,
    this.tel,
  });

  /// contentId — [TouristSpot.id]와 동일 식별자 공간(언어별로 갈림).
  final String id;
  final String title;
  final SpotCategory? category;

  /// 갤러리 폴백/헤더 이미지(항상 존재).
  final String thumbnailImageUrl;

  /// 장문 소개글(detailCommon2). 없으면 소개 섹션 숨김(AC-25).
  final String? overview;
  final String? address;

  /// 홈페이지 링크. 없으면 연락처의 홈페이지 행 숨김.
  final String? homepage;

  /// 전화번호. 없으면 연락처의 전화 행 숨김.
  final String? tel;

  /// 항목 저작권 유형(갤러리 이미지별 저작권과 별개).
  final CopyrightType copyright;

  /// 저작권 표준 문구 전문(AttributionBlock에 전문 노출, AC-28).
  final String attributionText;

  /// 갤러리(TourAPI 반환 순서, 최대 10장). 없으면 빈 배열.
  final List<SpotImage> gallery;

  /// 현재 요청 언어의 이 contentId LIKE 수. 상세 화면에 보이는 값이라 반응 실패 시
  /// provider가 롤백한다(AC-30).
  final int likeCount;

  @override
  bool operator ==(Object other) =>
      other is SpotDetail &&
      other.id == id &&
      other.title == title &&
      other.category == category &&
      other.thumbnailImageUrl == thumbnailImageUrl &&
      other.overview == overview &&
      other.address == address &&
      other.homepage == homepage &&
      other.tel == tel &&
      other.copyright == copyright &&
      other.attributionText == attributionText &&
      _listEquals(other.gallery, gallery) &&
      other.likeCount == likeCount;

  @override
  int get hashCode => Object.hash(
    id,
    title,
    category,
    thumbnailImageUrl,
    overview,
    address,
    homepage,
    tel,
    copyright,
    attributionText,
    Object.hashAll(gallery),
    likeCount,
  );

  /// [likeCount]만 바꾼 사본(낙관적 갱신·롤백용). 나머지 필드는 유지한다.
  SpotDetail copyWithLikeCount(int likeCount) => SpotDetail(
    id: id,
    title: title,
    category: category,
    thumbnailImageUrl: thumbnailImageUrl,
    copyright: copyright,
    attributionText: attributionText,
    gallery: gallery,
    likeCount: likeCount,
    overview: overview,
    address: address,
    homepage: homepage,
    tel: tel,
  );
}

bool _listEquals(List<SpotImage> a, List<SpotImage> b) {
  if (a.length != b.length) return false;
  for (int i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}
