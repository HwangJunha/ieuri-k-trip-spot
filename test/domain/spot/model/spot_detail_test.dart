import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/copyright_type.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/spot_category.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/spot_detail.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/spot_image.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/spot_info_item.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/spot_intro.dart';

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

  group('intro and infoItems presence', () {
    // 테스트 더블의 detailSpot()과 달리 갤러리를 비워 둔다 — 모델 테스트는 갤러리와
    // 무관하므로 여기선 별도 빌더를 쓴다.
    SpotDetail withExtras({SpotIntro? intro, List<SpotInfoItem>? infoItems}) =>
        SpotDetail(
          id: 'c1',
          title: 'T',
          category: SpotCategory.touristSpot,
          thumbnailImageUrl: 'https://img/t.jpg',
          copyright: CopyrightType.type1,
          attributionText: 'KTO',
          gallery: const <SpotImage>[],
          likeCount: 0,
          intro: intro,
          infoItems: infoItems ?? const <SpotInfoItem>[],
        );

    test('a missing intro hides the section', () {
      expect(withExtras().hasIntro, isFalse);
      expect(withExtras().introEntries, isEmpty);
    });

    test('an intro whose fields are all empty hides the section', () {
      // 서버가 카테고리에 따라 필드가 전부 null인 intro를 줄 수 있어, null 검사만으론
      // 부족하다 — 빈 껍데기도 숨긴다.
      expect(withExtras(intro: const SpotIntro()).hasIntro, isFalse);
      expect(
        withExtras(intro: const SpotIntro(parking: '   ')).hasIntro,
        isFalse,
      );
    });

    test('an intro with any value shows the section', () {
      final SpotDetail detail = withExtras(
        intro: const SpotIntro(businessHours: '09:00 ~ 18:00'),
      );

      expect(detail.hasIntro, isTrue);
      expect(detail.introEntries.single.value, '09:00 ~ 18:00');
    });

    test('blank info items are filtered out', () {
      final SpotDetail detail = withExtras(
        infoItems: const <SpotInfoItem>[
          SpotInfoItem(name: '입장료', text: '3,000원'),
          SpotInfoItem(name: '  ', text: ''),
        ],
      );

      expect(detail.presentInfoItems, hasLength(1));
      expect(detail.hasInfoItems, isTrue);
    });

    test('info items that are all blank hide the section', () {
      final SpotDetail detail = withExtras(
        infoItems: const <SpotInfoItem>[SpotInfoItem(name: '', text: '  ')],
      );

      expect(detail.presentInfoItems, isEmpty);
      expect(detail.hasInfoItems, isFalse);
    });
  });

  test('copyWithLikeCount preserves intro and infoItems', () {
    // 좋아요 낙관적 갱신이 운영 정보·이용안내를 지워버리면 안 된다.
    final SpotDetail original = SpotDetail(
      id: 'c1',
      title: 'T',
      category: SpotCategory.touristSpot,
      thumbnailImageUrl: 'https://img/t.jpg',
      copyright: CopyrightType.type1,
      attributionText: 'KTO',
      gallery: const <SpotImage>[],
      likeCount: 1,
      intro: const SpotIntro(fee: '무료'),
      infoItems: const <SpotInfoItem>[SpotInfoItem(name: 'a', text: 'b')],
    );

    final SpotDetail updated = original.copyWithLikeCount(2);

    expect(updated.intro, const SpotIntro(fee: '무료'));
    expect(updated.infoItems, hasLength(1));
    expect(updated.copyWithLikeCount(1), original);
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

  // --- 축약 상태 (SPEC-0008 R-11) --------------------------------------------

  /// 본문(`overview`)까지 없고 갤러리·운영정보·이용안내가 전부 비었을 때, 남는 것은
  /// 목록이 이미 준 값들뿐이다 — 제목·썸네일·주소·카테고리. 이것을 **오류가 아닌
  /// 정상 상태**로 다룬다(AC-34 · AC-35).
  ///
  /// 모델은 "숨김 판단"만 책임진다 — 화면은 이 게터들을 보고 섹션을 그리지 않을 뿐,
  /// 별도의 축약 분기를 만들지 않는다(§2 세 상태를 하나로 접는다).
  test('상세가 전부 비어도 목록이 준 값은 남고 정상 상태다 (AC-34·AC-35)', () {
    const SpotDetail sparse = SpotDetail(
      id: 'c1',
      title: 'Gyeongbokgung',
      category: SpotCategory.touristSpot,
      thumbnailImageUrl: 'https://img/thumb.jpg',
      address: 'Seoul',
      copyright: CopyrightType.type1,
      attributionText: 'Source: KTO',
      gallery: <SpotImage>[],
      likeCount: 3,
    );

    // 모든 섹션이 숨겨진다 — 오류 문구 없이.
    expect(sparse.hasOverview, isFalse);
    expect(sparse.hasIntro, isFalse);
    expect(sparse.hasInfoItems, isFalse);
    expect(sparse.hasContact, isFalse);

    // 카드에서 본 값들은 그대로 남는다 — 이것이 축약 화면이 보여주는 전부다.
    expect(sparse.title, 'Gyeongbokgung');
    expect(sparse.thumbnailImageUrl, isNotEmpty);
    expect(sparse.hasAddress, isTrue);
    expect(sparse.category, SpotCategory.touristSpot);

    // likeCount는 non-null이 유지되므로 축약 화면에서도 표시·반응이 가능하다(§3.2).
    expect(sparse.likeCount, 3);
    expect(sparse.copyWithLikeCount(4).likeCount, 4);
  });

  /// 갤러리가 비어도 썸네일 1장으로 대체된다 — null과 빈 배열을 구분하는 분기를
  /// 만들지 않는다(AC-26 · AC-27 · AC-28).
  test('빈 갤러리는 썸네일 폴백이고 출처 문구를 더하지 않는다 (AC-26·AC-27)', () {
    const SpotDetail sparse = SpotDetail(
      id: 'c1',
      title: 'T',
      category: SpotCategory.touristSpot,
      thumbnailImageUrl: 'https://img/thumb.jpg',
      copyright: CopyrightType.type1,
      attributionText: 'Source: KTO',
      gallery: <SpotImage>[],
      likeCount: 0,
    );

    expect(sparse.gallery, isEmpty);
    expect(sparse.distinctImageAttributions, isEmpty);
  });
}
