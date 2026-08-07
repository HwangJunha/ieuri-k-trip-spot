import '../../../l10n/gen/app_localizations.dart';
import '../model/nearby_spot_category.dart';
import '../model/report_reason.dart';

/// `TargetCategory`·상대 시각 라벨은 **`common/widget/post_labels.dart`로 옮겼다** —
/// 설정의 "내가 쓴 글"(SPEC-0011 R3)이 같은 `Post`를 그리면서 둘 이상의 기능이 쓰게
/// 됐기 때문이다(CLAUDE.md §4). 커뮤니티 호출부가 계속 이 파일 하나만 import하도록
/// 다시 내보낸다.
export '../../../common/widget/post_labels.dart'
    show relativePostTime, targetCategoryLabel;

/// [NearbySpotCategory]의 표시 문자열.
///
/// **[TargetCategory]와 같은 ARB 키를 쓴다.** 두 enum은 식별자가 같고(9개 전부),
/// 커뮤니티 안에서 "맛집"이 글의 카테고리든 장소의 카테고리든 같은 뜻으로 읽힌다 —
/// 키를 9개 복제하면 같은 문구가 네 파일에서 따로 늙는다.
///
/// 그래도 `domain/spot`의 라벨 함수를 부르지 않는 것은 여전하다(CLAUDE.md §3) —
/// 이 키들은 커뮤니티가 소유한 키라 재사용이 기능 간 의존이 아니다.
String nearbySpotCategoryLabel(
  AppLocalizations l10n,
  NearbySpotCategory category,
) => switch (category) {
  NearbySpotCategory.touristSpot => l10n.communityCategoryTouristSpot,
  NearbySpotCategory.culturalFacility => l10n.communityCategoryCulturalFacility,
  NearbySpotCategory.festivalEvent => l10n.communityCategoryFestivalEvent,
  NearbySpotCategory.travelCourse => l10n.communityCategoryTravelCourse,
  NearbySpotCategory.leisureSports => l10n.communityCategoryLeisureSports,
  NearbySpotCategory.lodging => l10n.communityCategoryLodging,
  NearbySpotCategory.shopping => l10n.communityCategoryShopping,
  NearbySpotCategory.restaurant => l10n.communityCategoryRestaurant,
  NearbySpotCategory.transport => l10n.communityCategoryTransport,
};

/// 신고 사유의 표시 문자열(POL-023). 서버 `ReportReason`은 안정 식별자일 뿐이다.
String reportReasonLabel(AppLocalizations l10n, ReportReason reason) =>
    switch (reason) {
      ReportReason.spam => l10n.communityReportReasonSpam,
      ReportReason.abuse => l10n.communityReportReasonAbuse,
      ReportReason.inappropriateContent =>
        l10n.communityReportReasonInappropriate,
      ReportReason.other => l10n.communityReportReasonOther,
    };
