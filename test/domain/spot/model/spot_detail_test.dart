import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/copyright_type.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/spot_category.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/spot_detail.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/spot_image.dart';

void main() {
  const SpotImage image = SpotImage(
    imageUrl: 'https://img/1.jpg',
    copyright: CopyrightType.type1,
    attributionText: 'KTO',
  );

  SpotDetail build({int likeCount = 5}) => SpotDetail(
    id: 'c1',
    title: 'Gyeongbokgung',
    category: SpotCategory.touristSpot,
    thumbnailImageUrl: 'https://img/thumb.jpg',
    overview: 'A palace.',
    address: 'Seoul',
    homepage: 'https://example.com',
    tel: '02-000',
    copyright: CopyrightType.type1,
    attributionText: 'Source: KTO',
    gallery: const <SpotImage>[image],
    likeCount: likeCount,
  );

  test('SpotDetail equality is value-based (gallery included)', () {
    expect(build(), build());
    expect(build().hashCode, build().hashCode);
    expect(build(likeCount: 5), isNot(build(likeCount: 6)));
  });

  test('copyWithLikeCount changes only likeCount', () {
    final SpotDetail original = build(likeCount: 5);
    final SpotDetail updated = original.copyWithLikeCount(6);

    expect(updated.likeCount, 6);
    // 나머지 필드는 그대로.
    expect(updated.copyWithLikeCount(5), original);
  });
}
