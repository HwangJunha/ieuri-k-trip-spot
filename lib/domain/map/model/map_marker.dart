/// 지도 마커의 종류(R21). **아이콘 모양으로 구분한다** — 색으로만 구분하면 혼잡도
/// 폴리곤 채색과 섞여 읽기 어려워진다(설계 §4.1).
enum MapMarkerKind {
  /// 관광지.
  spot,

  /// 문화행사.
  ///
  /// **더 이상 지도에 그리지 않는다**(FR-012 개정 2026-09-18). repository가 이
  /// 종류의 마커를 만들지 않으므로 실제로 생성되는 값은 [spot]뿐이다 — 값 자체는
  /// 남겨 둔다. `switch`가 모든 case를 덮어야 컴파일되는 자리들이 있고, 행사를
  /// 다시 그리기로 하면 그 분기들이 그대로 되살아난다.
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
    this.categoryName,
    this.subtitle,
    this.thumbnailUrl,
    this.isHighlighted = false,
  });

  final String id;
  final String name;
  final double latitude;
  final double longitude;
  final MapMarkerKind kind;

  /// spot의 카테고리 이름. 아이콘 선택에만 쓴다.
  ///
  /// enum이 아니라 문자열인 이유는 `SpotCategory`를 `domain/spot`이 소유하기
  /// 때문이다 — 여기서 그 타입을 쓰면 교차 feature 의존이 생긴다(CLAUDE.md §3).
  final String? categoryName;

  /// 부가 정보 한 줄. 행사는 장소·기간이 들어가고 spot은 비어 있다.
  final String? subtitle;

  /// 마커에 그릴 썸네일 URL.
  ///
  /// **지도 위에서 우리 데이터임을 드러내는 수단이다.** 단색 점으로 그렸더니 카카오
  /// 지도가 기본으로 찍는 POI와 구분되지 않아 "무엇이 우리 것인지 모르겠다"는 지적을
  /// 받았다. 사진이 들어가면 한눈에 갈린다.
  ///
  /// 없을 수 있다 — 그때는 종류별 도형으로 떨어진다.
  final String? thumbnailUrl;

  /// 검색으로 찾아 강조할 마커인가.
  ///
  /// 참이면 테두리를 브랜드 빨강으로 그린다 — 지도에 마커가 여럿일 때 "내가 찾은
  /// 그것"이 어느 것인지 한눈에 갈려야 한다.
  final bool isHighlighted;

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
