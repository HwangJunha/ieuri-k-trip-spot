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

  // --- 표시 여부 (AC-25) ------------------------------------------------------
  // TourAPI는 값이 없을 때 null이 아니라 빈 문자열/공백을 주는 경우가 있다. null만
  // 검사하면 빈 라벨("웹사이트: ")이 그려지므로, 값의 유무 판단은 이 게터로 한 곳에
  // 모은다 — 각 위젯이 제각기 검사하지 않는다.

  /// 소개 섹션을 그릴지. 값이 없거나 공백뿐이면 false.
  bool get hasOverview => _present(overview);

  /// 주소 행을 그릴지.
  bool get hasAddress => _present(address);

  /// 홈페이지 행을 그릴지. 값이 있어도 URL을 못 뽑으면(빈 앵커 등) 그리지 않는다.
  bool get hasHomepage => homepageUrl != null;

  /// [homepage]에서 실제 이동할 URL만 뽑아낸다.
  ///
  /// TourAPI의 homepage는 평문 URL이 아니라 앵커 태그 원문으로 오는 경우가 많다:
  /// `<a href="http://example.com " target="_blank" title="...">http://example.com</a>`
  /// (href 안에 공백이 끼기도 한다). 그대로 렌더하면 태그가 노출되고 링크도 안 되므로
  /// href 값을 우선 취하고, 앵커가 없으면 본문에서 첫 URL을 찾는다. 둘 다 없으면 null.
  ///
  /// 표시 규칙은 클라이언트 몫이라(POL-024) 이 정규화를 모델에 둔다 — 위젯마다
  /// 파싱을 반복하지 않는다.
  String? get homepageUrl {
    final String? raw = homepage;
    if (raw == null || raw.trim().isEmpty) return null;

    // 1순위: href="..." 안의 값(작은/큰따옴표 모두 허용).
    final RegExpMatch? href = RegExp(
      r'''href\s*=\s*["']([^"']+)["']''',
      caseSensitive: false,
    ).firstMatch(raw);
    final String? fromHref = href?.group(1)?.trim();
    if (fromHref != null && fromHref.isNotEmpty) return fromHref;

    // 2순위: 태그가 없거나 href가 비었으면 본문에서 첫 URL을 찾는다.
    // 공백·따옴표·꺾쇠는 URL의 끝으로 본다.
    final RegExpMatch? bare = RegExp(
      '''https?://[^\\s"'<>]+''',
      caseSensitive: false,
    ).firstMatch(raw);
    return bare?.group(0);
  }

  /// 전화 행을 그릴지.
  bool get hasTel => _present(tel);

  /// 연락처 섹션 자체를 그릴지 — 홈페이지·전화가 모두 없으면 섹션을 숨긴다.
  bool get hasContact => hasHomepage || hasTel;

  /// 항목 [attributionText]와 **다른** 갤러리 이미지 출처 문구(순서 유지, 중복 제거).
  /// 이미지 위에 배지를 얹지 않고도 이미지별 저작권을 표기하기 위한 값이다(AC-28).
  /// 모든 이미지가 항목과 같은 출처면 빈 리스트.
  List<String> get distinctImageAttributions {
    final Set<String> seen = <String>{attributionText};
    final List<String> result = <String>[];
    for (final SpotImage image in gallery) {
      if (seen.add(image.attributionText)) result.add(image.attributionText);
    }
    return result;
  }

  static bool _present(String? value) =>
      value != null && value.trim().isNotEmpty;

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
