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

  test('blank or whitespace-only values count as absent', () {
    // TourAPI는 값이 없을 때 null이 아니라 빈 문자열/공백을 주기도 한다 —
    // 그 경우에도 섹션이 숨겨져야 한다(빈 라벨 금지, AC-25).
    final SpotDetail blank = SpotDetail(
      id: 'c1',
      title: 'T',
      category: SpotCategory.touristSpot,
      thumbnailImageUrl: 'https://img/t.jpg',
      overview: '',
      address: '   ',
      homepage: '',
      tel: '  ',
      copyright: CopyrightType.type1,
      attributionText: 'KTO',
      gallery: const <SpotImage>[],
      likeCount: 0,
    );

    expect(blank.hasOverview, isFalse);
    expect(blank.hasAddress, isFalse);
    expect(blank.hasHomepage, isFalse);
    expect(blank.hasTel, isFalse);
    expect(blank.hasContact, isFalse);
  });

  test('present values are reported as present', () {
    final SpotDetail full = build();

    expect(full.hasOverview, isTrue);
    expect(full.hasAddress, isTrue);
    expect(full.hasHomepage, isTrue);
    expect(full.hasTel, isTrue);
    expect(full.hasContact, isTrue);
  });

  group('homepageUrl', () {
    SpotDetail withHomepage(String? homepage) => SpotDetail(
      id: 'c1',
      title: 'T',
      category: SpotCategory.touristSpot,
      thumbnailImageUrl: 'https://img/t.jpg',
      homepage: homepage,
      copyright: CopyrightType.type1,
      attributionText: 'KTO',
      gallery: const <SpotImage>[],
      likeCount: 0,
    );

    test('extracts the href from a TourAPI anchor tag', () {
      // 실제 TourAPI 응답 형태 — href 안에 후행 공백이 있다.
      final SpotDetail detail = withHomepage(
        '<a href="http://www.i-etland.co.kr " target="_blank" '
        'title="용산전자랜드 홈페이지로 이동">http://www.i-etland.co.kr</a>',
      );

      expect(detail.homepageUrl, 'http://www.i-etland.co.kr');
      expect(detail.hasHomepage, isTrue);
    });

    test('accepts single-quoted href', () {
      expect(
        withHomepage("<a href='https://example.com'>x</a>").homepageUrl,
        'https://example.com',
      );
    });

    test('takes the first link when several are present', () {
      final SpotDetail detail = withHomepage(
        '<a href="https://first.com">1</a> <a href="https://second.com">2</a>',
      );

      expect(detail.homepageUrl, 'https://first.com');
    });

    test('falls back to a bare URL when there is no anchor tag', () {
      expect(
        withHomepage('http://www.example.co.kr').homepageUrl,
        'http://www.example.co.kr',
      );
      expect(
        withHomepage('안내: https://example.com 로 문의').homepageUrl,
        'https://example.com',
      );
    });

    test('is null when there is no usable URL', () {
      expect(withHomepage(null).homepageUrl, isNull);
      expect(withHomepage('').homepageUrl, isNull);
      expect(withHomepage('   ').homepageUrl, isNull);
      // 링크 없는 평문 → 열 수 있는 URL이 없으므로 행을 숨긴다.
      expect(withHomepage('준비 중').homepageUrl, isNull);
      expect(withHomepage('준비 중').hasHomepage, isFalse);
    });
  });

  test('distinctImageAttributions excludes the item attribution', () {
    final SpotDetail detail = SpotDetail(
      id: 'c1',
      title: 'T',
      category: SpotCategory.touristSpot,
      thumbnailImageUrl: 'https://img/t.jpg',
      copyright: CopyrightType.type1,
      attributionText: 'Source: KTO',
      gallery: const <SpotImage>[
        // 항목과 같은 출처 → 제외.
        SpotImage(
          imageUrl: 'a',
          copyright: CopyrightType.type1,
          attributionText: 'Source: KTO',
        ),
        // 다른 출처 → 포함.
        SpotImage(
          imageUrl: 'b',
          copyright: CopyrightType.type3,
          attributionText: 'Photo: Someone',
        ),
        // 중복 → 한 번만.
        SpotImage(
          imageUrl: 'c',
          copyright: CopyrightType.type3,
          attributionText: 'Photo: Someone',
        ),
      ],
      likeCount: 0,
    );

    expect(detail.distinctImageAttributions, <String>['Photo: Someone']);
  });

  test('copyWithLikeCount changes only likeCount', () {
    final SpotDetail original = build(likeCount: 5);
    final SpotDetail updated = original.copyWithLikeCount(6);

    expect(updated.likeCount, 6);
    // 나머지 필드는 그대로.
    expect(updated.copyWithLikeCount(5), original);
  });
}
