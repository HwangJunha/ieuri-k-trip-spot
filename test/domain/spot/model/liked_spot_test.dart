import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/copyright_type.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/liked_spot.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/spot_category.dart';

void main() {
  LikedSpot build({String id = 'spot-1', String? address = 'Seoul'}) =>
      LikedSpot(
        id: id,
        title: 'Gyeongbokgung',
        thumbnailImageUrl: 'https://img/1.jpg',
        address: address,
        category: SpotCategory.touristSpot,
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
