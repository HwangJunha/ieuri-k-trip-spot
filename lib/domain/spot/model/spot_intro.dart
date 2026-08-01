/// 운영 정보 항목의 종류. 뷰가 아이콘·라벨(다국어)을 고르는 키다 — 문구 자체는
/// l10n에 있고 모델은 종류만 안다(모델은 순수, CLAUDE.md §3).
enum SpotIntroField {
  businessHours,
  closedDays,
  parking,
  fee,
  inquiryPhone,
  petAllowed,
  creditCardAccepted,
}

/// 값이 있는 운영 정보 한 줄. [SpotIntro.presentEntries]가 만들어 준다.
class SpotIntroEntry {
  const SpotIntroEntry(this.field, this.value);

  final SpotIntroField field;

  /// 앞뒤 공백을 다듬은 표시용 값(비어 있지 않음이 보장된다).
  final String value;

  @override
  bool operator ==(Object other) =>
      other is SpotIntroEntry && other.field == field && other.value == value;

  @override
  int get hashCode => Object.hash(field, value);
}

/// 관광지 운영 정보(detailIntro2).
///
/// TourAPI는 카테고리마다 응답 필드가 완전히 다르지만(관광지 `usetime`, 음식점
/// `opentimefood` …) 서버가 **의미가 같은 필드를 공통 이름으로 정규화**해 내려준다.
/// 그래서 클라이언트는 카테고리 분기 없이 이 한 shape만 본다.
///
/// 카테고리에 해당 개념이 없으면 그 필드는 null이다(예: 여행코스엔 주차·휴무 개념이
/// 없음). 값이 없는 항목은 화면에 그리지 않으므로, 어떤 항목이 실제로 표시 대상인지는
/// [presentEntries]가 한 곳에서 판단한다 — 뷰가 필드 7개를 각각 검사하지 않는다.
///
/// 순수 도메인 모델 — 위젯·GraphQL 의존 없음(POL-020).
class SpotIntro {
  const SpotIntro({
    this.businessHours,
    this.closedDays,
    this.parking,
    this.inquiryPhone,
    this.fee,
    this.petAllowed,
    this.creditCardAccepted,
  });

  /// 이용 시간.
  final String? businessHours;

  /// 휴무일.
  final String? closedDays;

  /// 주차 안내.
  final String? parking;

  /// 문의·안내 전화. 상세의 `tel`과 다를 수 있다.
  final String? inquiryPhone;

  /// 이용 요금.
  final String? fee;

  /// 반려동물 동반 가능 여부(서버가 원문 문구를 그대로 준다).
  final String? petAllowed;

  /// 신용카드 가능 여부.
  final String? creditCardAccepted;

  /// 표시할 값이 있는 항목만, 화면에 쌓을 순서대로. 전부 비어 있으면 빈 리스트이고
  /// 그때 뷰는 운영 정보 섹션 자체를 그리지 않는다(AC-25 — 빈 라벨 금지).
  ///
  /// null뿐 아니라 공백뿐인 값도 "없음"으로 친다 — TourAPI는 값이 없을 때 빈 문자열을
  /// 주기도 하는데, null만 검사하면 `"주차: "` 같은 빈 라벨이 남는다.
  List<SpotIntroEntry> get presentEntries {
    final List<SpotIntroEntry> entries = <SpotIntroEntry>[];
    void add(SpotIntroField field, String? value) {
      final String? trimmed = value?.trim();
      if (trimmed != null && trimmed.isNotEmpty) {
        entries.add(SpotIntroEntry(field, trimmed));
      }
    }

    // 여행자가 먼저 확인하는 순서: 언제 여는가 → 언제 닫는가 → 얼마인가 → 부가 조건.
    add(SpotIntroField.businessHours, businessHours);
    add(SpotIntroField.closedDays, closedDays);
    add(SpotIntroField.fee, fee);
    add(SpotIntroField.parking, parking);
    add(SpotIntroField.petAllowed, petAllowed);
    add(SpotIntroField.creditCardAccepted, creditCardAccepted);
    add(SpotIntroField.inquiryPhone, inquiryPhone);
    return entries;
  }

  /// 운영 정보 섹션을 그릴지.
  bool get hasAny => presentEntries.isNotEmpty;

  @override
  bool operator ==(Object other) =>
      other is SpotIntro &&
      other.businessHours == businessHours &&
      other.closedDays == closedDays &&
      other.parking == parking &&
      other.inquiryPhone == inquiryPhone &&
      other.fee == fee &&
      other.petAllowed == petAllowed &&
      other.creditCardAccepted == creditCardAccepted;

  @override
  int get hashCode => Object.hash(
    businessHours,
    closedDays,
    parking,
    inquiryPhone,
    fee,
    petAllowed,
    creditCardAccepted,
  );
}
