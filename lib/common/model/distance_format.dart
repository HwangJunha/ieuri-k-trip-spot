import 'dart:math' as math;

import '../../l10n/gen/app_localizations.dart';

/// 거리 표시. 1km 미만은 미터로, 그 이상은 소수 한 자리 킬로미터로 — 그 경계에서
/// 사람이 읽는 단위가 바뀐다.
///
/// **두 피처 이상이 쓰므로 여기 있다**(CLAUDE.md §4). community의 장소 선택 시트와
/// map의 지역 추천이 같은 규칙으로 거리를 적어야 한다.
///
/// **km를 여기서 미리 반올림한다.** ARB의 `decimalDigits: 1`만 믿었더니 "5.691km"가
/// 그대로 나왔다(실측) — 자릿수 제한이 걸리지 않는다. 8.888km 같은 값은 정밀해 보일
/// 뿐 뜻이 없고, 지역 대표 좌표까지의 직선 거리라 애초에 그만한 정밀도가 없다.
String formatDistance(AppLocalizations l10n, double meters) => meters < 1000
    ? l10n.communitySpotDistanceMeters(meters.round())
    : l10n.communitySpotDistanceKilometers(
        (meters / 100).round() / 10,
      );

/// 두 좌표 사이의 대권 거리(미터).
///
/// **서버가 추천 지역의 거리를 내려주지 않아 클라이언트가 계산한다.** 점수(0~100)는
/// 정규화된 값이라 km로 되돌릴 수 없지만, 사용자 좌표와 지역 대표 좌표가 둘 다 있어
/// 직접 구할 수 있다.
///
/// 하버사인 공식을 쓴다 — 시군구 단위 거리(수 km~수백 km)에서 오차가 무시할 수준이고
/// 순수 계산이라 그대로 테스트된다.
double distanceMetersBetween({
  required double lat1,
  required double lng1,
  required double lat2,
  required double lng2,
}) {
  // 지구 평균 반지름(m).
  const double earthRadius = 6371000;

  final double dLat = _toRadians(lat2 - lat1);
  final double dLng = _toRadians(lng2 - lng1);
  final double a =
      math.sin(dLat / 2) * math.sin(dLat / 2) +
      math.cos(_toRadians(lat1)) *
          math.cos(_toRadians(lat2)) *
          math.sin(dLng / 2) *
          math.sin(dLng / 2);

  return earthRadius * 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
}

double _toRadians(double degrees) => degrees * math.pi / 180;
