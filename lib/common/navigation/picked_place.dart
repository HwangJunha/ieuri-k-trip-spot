import '../location/coordinates.dart';

/// 검색 화면이 "이 장소를 골랐다"고 돌려주는 값.
///
/// **왜 별도 타입인가.** 검색 결과는 `domain/spot`의 `TouristSpot`인데, 지도가 그걸
/// 그대로 받으려면 그 타입을 import해야 하고 그러면 교차 feature 의존이 생긴다
/// (CLAUDE.md §3).
///
/// 처음에는 `dynamic`으로 필드를 읽어 피했는데, 그 대가로 **런타임에 두 번 깨졌다** —
/// `.name`이 확장 게터라 동적 호출에서 없다는 오류가 났고, 컴파일러도 테스트도 그걸
/// 잡지 못했다. 타입을 피하려다 기능을 잃은 셈이라, 두 기능이 함께 쓰는 작은 값 객체를
/// `common/`에 두는 쪽으로 바꿨다(§4 — 둘 이상이 쓰면 common).
///
/// 지도가 필요한 것만 담는다 — 상세로 가는 데 필요한 나머지는 검색 화면이 이미 안다.
class PickedPlace {
  const PickedPlace({
    required this.id,
    required this.name,
    required this.coordinates,
    this.categoryName,
    this.thumbnailUrl,
  });

  final String id;
  final String name;

  /// 지도를 옮길 좌표. **이것이 없는 장소는 고를 수 없다** — 옮길 곳이 없다.
  final Coordinates coordinates;

  /// 상세로 넘길 카테고리 이름(`SpotCategory.name`). 서버의 `intro`/`infoItems`가
  /// 필수 인자로 요구한다.
  final String? categoryName;

  /// 마커에 그릴 사진. 없으면 종류별 도형으로 떨어진다.
  final String? thumbnailUrl;
}
