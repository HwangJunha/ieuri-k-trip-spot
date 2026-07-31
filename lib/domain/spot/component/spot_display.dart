import '../../../l10n/gen/app_localizations.dart';
import '../model/distance.dart';
import '../model/spot_category.dart';

/// 도메인 enum/값 → 표시 문자열 매핑을 한곳에 모은다. 순수 모델을 UI 표시로 번역하는
/// 얇은 계층(POL-023/024): enum·거리는 서버 콘텐츠, 문구·포맷은 클라이언트.

/// 카테고리 → 현지화 표시명(POL-023: enum은 식별자, 표시는 l10n 키).
String spotCategoryLabel(AppLocalizations l10n, SpotCategory category) =>
    switch (category) {
      SpotCategory.touristSpot => l10n.discoverCategoryTouristSpot,
      SpotCategory.culturalFacility => l10n.discoverCategoryCulturalFacility,
      SpotCategory.festivalEvent => l10n.discoverCategoryFestivalEvent,
      SpotCategory.travelCourse => l10n.discoverCategoryTravelCourse,
      SpotCategory.leisureSports => l10n.discoverCategoryLeisureSports,
      SpotCategory.lodging => l10n.discoverCategoryLodging,
      SpotCategory.shopping => l10n.discoverCategoryShopping,
      SpotCategory.restaurant => l10n.discoverCategoryRestaurant,
      SpotCategory.transport => l10n.discoverCategoryTransport,
    };

/// 거리 값 → 현지화 표시 문자열(POL-024). 1km 미만은 m, 그 이상은 km 단위로
/// 클라이언트가 포맷한다.
String distanceLabel(AppLocalizations l10n, Distance distance) =>
    distance.isSubKilometer
    ? l10n.distanceMeters(distance.metersLabel)
    : l10n.distanceKilometers(distance.kilometersLabel);
