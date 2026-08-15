import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/copyright_type.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/liked_spot.dart';
import 'package:ieuri_k_trip_spot/common/category/spot_category.dart';

/// SPEC-0020 이후 카테고리는 enum이 아니라 값 객체다. 동등성은 `code`만 보므로
/// 라벨이 달라도 같은 카테고리다.
const SpotCategory catTouristSpot = SpotCategory(
  code: 'TOURIST_SPOT',
  label: 'Tourist Spots',
);
const SpotCategory catRestaurant = SpotCategory(
  code: 'RESTAURANT',
  label: 'Restaurants',
);
const SpotCategory catTravelCourse = SpotCategory(
  code: 'TRAVEL_COURSE',
  label: 'Travel Courses',
);
const SpotCategory catTransport = SpotCategory(
  code: 'TRANSPORT',
  label: 'Transport',
);

void main() {
  LikedSpot build({String id = 'spot-1', String? address = 'Seoul'}) =>
      LikedSpot(
        id: id,
        title: 'Gyeongbokgung',
        thumbnailImageUrl: 'https://img/1.jpg',
        address: address,
        category: catTouristSpot,
        copyright: CopyrightType.type1,
        attributionText: 'KTO',
      );

  test('LikedSpot equality is value-based', () {
    expect(build(), build());
    expect(build().hashCode, build().hashCode);
    expect(build(), isNot(build(id: 'spot-2')));
  });

  test('주소는 없을 수 있다', () {
    // 서버가 주소를 안 주는 항목이 있다 — 카드가 주소 행을 그리지 않을 뿐 오류가 아니다.
    expect(build(address: null).address, isNull);
  });
}
