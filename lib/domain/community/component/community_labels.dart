import '../../../l10n/gen/app_localizations.dart';
import '../model/relative_time.dart';
import '../model/report_reason.dart';
import '../model/target_category.dart';

/// [TargetCategory]의 표시 문자열(POL-023, 가이드 §9).
///
/// **서버는 표시명을 내려주지 않는다** — enum은 안정 식별자이고 매핑은 클라이언트
/// 몫이다. 네 언어 모두 ARB에 값이 있어야 하며, 누락되면 여기서 컴파일이 깨진다
/// (switch가 전수라서).
///
/// 값이 `SpotCategory`와 같아도 **spot 도메인의 라벨 함수를 쓰지 않는다** — 기능 간
/// import가 되고(CLAUDE.md §3), 두 도메인의 문구가 갈릴 자유도 사라진다.
/// 실제로 커뮤니티는 "맛집"이 자연스럽고 관광 목록은 "음식점"이 자연스럽다.
String targetCategoryLabel(AppLocalizations l10n, TargetCategory category) =>
    switch (category) {
      TargetCategory.touristSpot => l10n.communityCategoryTouristSpot,
      TargetCategory.culturalFacility => l10n.communityCategoryCulturalFacility,
      TargetCategory.festivalEvent => l10n.communityCategoryFestivalEvent,
      TargetCategory.travelCourse => l10n.communityCategoryTravelCourse,
      TargetCategory.leisureSports => l10n.communityCategoryLeisureSports,
      TargetCategory.lodging => l10n.communityCategoryLodging,
      TargetCategory.shopping => l10n.communityCategoryShopping,
      TargetCategory.restaurant => l10n.communityCategoryRestaurant,
      TargetCategory.transport => l10n.communityCategoryTransport,
    };

/// 상대 시각의 표시 문자열. **버킷 판정은 모델([relativeTimeSince])이 하고 여기서는
/// 문구만 고른다** — 모델은 순수 Dart라 l10n을 알 수 없기 때문이다(CLAUDE.md §3).
///
/// [now]를 인자로 받는 이유는 테스트가 시간을 고정하기 위해서다.
String relativePostTime(
  AppLocalizations l10n,
  DateTime createdAt,
  DateTime now,
) {
  final RelativeTime relative = relativeTimeSince(createdAt, now);
  return switch (relative.unit) {
    RelativeTimeUnit.justNow => l10n.communityTimeJustNow,
    RelativeTimeUnit.minutes => l10n.communityTimeMinutes(relative.count),
    RelativeTimeUnit.hours => l10n.communityTimeHours(relative.count),
    RelativeTimeUnit.days => l10n.communityTimeDays(relative.count),
    RelativeTimeUnit.months => l10n.communityTimeMonths(relative.count),
    RelativeTimeUnit.years => l10n.communityTimeYears(relative.count),
  };
}

/// 신고 사유의 표시 문자열(POL-023). 서버 `ReportReason`은 안정 식별자일 뿐이다.
String reportReasonLabel(AppLocalizations l10n, ReportReason reason) =>
    switch (reason) {
      ReportReason.spam => l10n.communityReportReasonSpam,
      ReportReason.abuse => l10n.communityReportReasonAbuse,
      ReportReason.inappropriateContent =>
        l10n.communityReportReasonInappropriate,
      ReportReason.other => l10n.communityReportReasonOther,
    };
