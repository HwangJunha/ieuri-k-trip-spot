/// 칸 대표 이미지의 저작권 유형(계약 `CopyrightType`, POL-051).
enum CellCopyrightType {
  /// 공공누리 제1유형 — 변형할 수 있다. 크롭·리사이즈가 허용된다.
  type1,

  /// 공공누리 제3유형 — 변경금지. 원본 비율을 유지해야 한다.
  type3,

  /// 유형이 밝혀지지 않음. **TYPE3와 같게 다룬다**(R23) — 안전한 쪽으로 간다.
  unspecified,
}

/// 칸 대표 이미지의 성격(계약 `CellImageKind`).
enum CellImageKind {
  /// 랜드마크 — 문화재, 자연경관, 공원, 구조물.
  landmark,

  /// 특산품 — 농수축산물이나 가공품.
  specialty,
}

/// 칸의 대표 이미지(R9·R23·R24).
class CellImage {
  const CellImage({
    required this.imageUrl,
    required this.caption,
    required this.kind,
    required this.copyright,
    required this.attributionText,
    this.thumbnailUrl,
  });

  final String imageUrl;
  final String? thumbnailUrl;

  /// 이미지가 무엇인지. 예: 경복궁, 성주 참외.
  final String caption;

  final CellImageKind kind;
  final CellCopyrightType copyright;

  /// 출처 표기. **유형과 무관하게 항상 노출한다**(R24).
  final String attributionText;

  /// 이 이미지를 잘라도 되는지(R23).
  ///
  /// 공공누리 제3유형의 "변경금지"가 형식의 변경까지 포함한다고 읽히므로 크롭이
  /// 저촉될 수 있다. 해석이 갈리는 지점이라 안전한 쪽을 고른다(설계 §6).
  ///
  /// **UI 취향이 아니라 법적 제약이다.** 화면에서 `BoxFit`을 직접 고르지 말고
  /// 이 값으로 결정한다.
  bool get allowsCrop => copyright == CellCopyrightType.type1;

  @override
  bool operator ==(Object other) =>
      other is CellImage &&
      other.imageUrl == imageUrl &&
      other.thumbnailUrl == thumbnailUrl &&
      other.caption == caption &&
      other.kind == kind &&
      other.copyright == copyright &&
      other.attributionText == attributionText;

  @override
  int get hashCode => Object.hash(
    imageUrl,
    thumbnailUrl,
    caption,
    kind,
    copyright,
    attributionText,
  );
}
