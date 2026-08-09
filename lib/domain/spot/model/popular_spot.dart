import 'tourist_spot.dart';

/// 인기 spot 한 건(SPEC-0013 R18) — spot과 그 랭킹 근거.
///
/// [likeCount]를 [TouristSpot]에 넣지 않는 이유는 순위와 무관한 다른 조회
/// (`spots`·`searchSpots`)에서는 의미가 없기 때문이다. 서버도 같은 이유로 이 값을
/// 노드가 아니라 edge에 싣는다.
class PopularSpot {
  const PopularSpot({required this.spot, required this.likeCount});

  final TouristSpot spot;

  /// 누적 좋아요 총합. 서버가 10 미만인 spot을 이미 걸러 낸다(AC-18.2).
  final int likeCount;

  @override
  bool operator ==(Object other) =>
      other is PopularSpot &&
      other.spot == spot &&
      other.likeCount == likeCount;

  @override
  int get hashCode => Object.hash(spot, likeCount);
}
