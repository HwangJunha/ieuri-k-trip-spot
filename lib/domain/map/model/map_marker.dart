/// 지도 마커의 종류(R21). **아이콘 모양으로 구분한다** — 색으로만 구분하면 혼잡도
/// 폴리곤 채색과 섞여 읽기 어려워진다(설계 §4.1).
enum MapMarkerKind {
  /// 관광지.
  spot,

  /// 문화행사. spot과 **항상 함께** 표시하며 토글 필터를 두지 않는다(R21).
  culturalEvent,
}

/// 지도 위의 개별 마커.
///
/// **`TouristSpot`·`Festival`을 그대로 쓰지 않는다.** 그 타입들은 각각
/// `domain/spot`·`domain/event`가 소유하고 있어, 여기서 import하면 교차 feature
/// 의존이 생긴다(CLAUDE.md §3). 지도가 마커를 찍는 데 필요한 것은 좌표·이름·종류뿐이라
/// 지도가 자기 타입을 갖는 편이 결합도 낮고 실제로도 더 작다.
///
/// 탭하면 [id]로 기존 상세 라우트에 넘긴다 — 모델이 아니라 식별자만 건넨다(§6).
class MapMarker {
  const MapMarker({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.kind,
  });

  final String id;
  final String name;
  final double latitude;
  final double longitude;
  final MapMarkerKind kind;

  @override
  bool operator ==(Object other) =>
      other is MapMarker &&
      other.id == id &&
      other.kind == kind &&
      other.latitude == latitude &&
      other.longitude == longitude;

  @override
  int get hashCode => Object.hash(id, kind, latitude, longitude);
}

/// 저줌에서 서버가 묶어 준 클러스터(R2).
///
/// **클라이언트가 다시 클러스터링하지 않는다** — 서버 클러스터와 클라이언트 클러스터가
/// 겹치면 개수가 어긋난다(설계 §4.2).
class MapCluster {
  const MapCluster({
    required this.centerLatitude,
    required this.centerLongitude,
    required this.count,
    this.dominantCategoryName,
  });

  final double centerLatitude;
  final double centerLongitude;

  /// 묶인 spot 개수. 마커 위에 그대로 표시한다.
  final int count;

  /// 우세 카테고리 이름. **부재가 정상이다** — 과반을 차지하는 카테고리가 없으면
  /// 서버가 비워 보낸다(R2). 섞인 클러스터에 특정 아이콘을 붙이면 사실과 다른 인상을
  /// 준다.
  ///
  /// enum이 아니라 문자열인 이유는 `SpotCategory`를 `domain/spot`이 소유하기
  /// 때문이다(위 [MapMarker] 주석과 같은 이유). 아이콘 선택에만 쓴다.
  final String? dominantCategoryName;
}
