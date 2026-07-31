/// 관광지 이미지의 저작권 유형(한국관광공사 OpenAPI 규약, spec.md §4.7). 이미지
/// 렌더 방식을 좌우한다:
///
/// - [type1] → 자유 이용·변형 허용. 카드에서 크롭 가능(`BoxFit.cover`).
/// - [type3] → 변형 금지(원본 유지). 크롭하면 안 되므로 `BoxFit.contain` + 블러 배경.
/// - [unspecified] → 저작권 정보 없음. 안전하게 [type3]과 동일 처리.
///
/// 순수 도메인 enum — `BoxFit`(flutter) 의존을 두지 않는다. 어떤 fit이 맞는지는
/// [cropAllowed] 불리언으로만 노출하고, 위젯이 이를 `BoxFit`으로 번역한다.
enum CopyrightType {
  type1,
  type3,
  unspecified;

  /// 서버/와이어 토큰을 유형으로 매핑한다. 알 수 없는 값은 [unspecified](안전 기본값).
  static CopyrightType fromWire(String? wire) => switch (wire?.toUpperCase()) {
    'TYPE1' => CopyrightType.type1,
    'TYPE3' => CopyrightType.type3,
    _ => CopyrightType.unspecified,
  };

  /// 이미지 크롭(cover) 허용 여부. TYPE1만 허용, 나머지는 원본 유지(contain).
  /// 위젯이 이 값으로 `BoxFit`을 고른다(POL-024: 표시 규칙은 클라이언트).
  bool get cropAllowed => this == CopyrightType.type1;
}
