/// 글 카드가 쓰는 표시 문자열 매핑.
///
/// **왜 `common/`에 있는가.** `Post`가 커뮤니티와 설정(내가 쓴 글, SPEC-0011 R3)
/// 두 기능에서 쓰이면서 모델이 `common/model/`로 올라왔고, 그 모델을 그리는 라벨도
/// 함께 올라왔다(CLAUDE.md §4 — 둘 이상이 쓰면 공용). 설정이 커뮤니티의
/// `community_labels.dart`를 부르면 기능 간 import가 된다(§3).
///
/// ARB 키는 `community*` 접두를 그대로 쓴다 — 문구는 같고 소유만 옮긴 것이라,
/// 키를 새로 파면 같은 문장이 네 언어 파일에서 두 벌로 늙는다.
library;

import '../../l10n/gen/app_localizations.dart';
import '../model/relative_time.dart';
import '../model/target_category.dart';

/// [TargetCategory]의 표시 문자열(POL-023).
///
/// **서버는 표시명을 내려주지 않는다** — enum은 안정 식별자이고 매핑은 클라이언트
/// 몫이다. 네 언어 모두 ARB에 값이 있어야 하며, 누락되면 여기서 컴파일이 깨진다
/// (switch가 전수라서).
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
