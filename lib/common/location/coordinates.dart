/// 위치 좌표(위도·경도). 순수 도메인 값 — flutter/geolocator 미의존. 위치 기반
/// 조회(SPEC-0002 spots 쿼리)에 위도·경도를 넘기는 데 쓴다.
class Coordinates {
  const Coordinates({required this.latitude, required this.longitude});

  final double latitude;
  final double longitude;

  @override
  bool operator ==(Object other) =>
      other is Coordinates &&
      other.latitude == latitude &&
      other.longitude == longitude;

  @override
  int get hashCode => Object.hash(latitude, longitude);

  @override
  String toString() => 'Coordinates($latitude, $longitude)';
}
