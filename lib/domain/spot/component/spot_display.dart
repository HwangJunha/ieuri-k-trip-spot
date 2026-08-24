import '../../../l10n/gen/app_localizations.dart';
import '../model/distance.dart';

/// 도메인 값 → 표시 문자열 매핑을 한곳에 모은다. 순수 모델을 UI 표시로 번역하는
/// 얇은 계층(POL-024): 거리는 서버 콘텐츠, 포맷은 클라이언트.
///
/// **`spotCategoryLabel`은 제거됐다**(SPEC-0020 R11). 카테고리 표시 문구는 서버가
/// 활성 언어로 내려주므로(`SpotCategory.label`) 클라이언트가 번역하지 않는다 —
/// 서버가 카테고리를 추가해도 앱 업데이트 없이 라벨이 따라온다.

/// 거리 값 → 현지화 표시 문자열(POL-024). 1km 미만은 m, 그 이상은 km 단위로
/// 클라이언트가 포맷한다.
String distanceLabel(AppLocalizations l10n, Distance distance) =>
    distance.isSubKilometer
    ? l10n.distanceMeters(distance.metersLabel)
    : l10n.distanceKilometers(distance.kilometersLabel);
