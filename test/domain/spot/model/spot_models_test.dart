// 관광지 모델 테스트를 한 파일에 모았다.
//
// **파일을 쪼개지 않는 이유는 속도다** — flutter test는 파일마다 격리된 VM을 띄우므로
// 파일 수가 곧 실행 시간이다. 모델별 구분은 group으로 충분하다(CLAUDE.md §8).

import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/common/category/spot_category.dart';
import 'package:ieuri_k_trip_spot/common/category/spot_category_selection.dart';
import 'package:ieuri_k_trip_spot/common/location/coordinates.dart';
import 'package:ieuri_k_trip_spot/common/location/location_service.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/copyright_type.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/distance.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/liked_spot.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/retry_budget.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/retry_exhausted.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/spot_detail.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/spot_failure.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/spot_image.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/spot_info_item.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/spot_intro.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/swipe_feed_key.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/swipe_queue.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/tour_api_text.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/tourist_spot.dart';
import 'package:ieuri_k_trip_spot/domain/spot/provider/retry_counting.dart';

// ─── liked_spot ────────────────────────────────────────────────
const SpotCategory likedCatTouristSpot = SpotCategory(
  code: 'TOURIST_SPOT',
  label: 'Tourist Spots',
);
const SpotCategory likedCatRestaurant = SpotCategory(
  code: 'RESTAURANT',
  label: 'Restaurants',
);
const SpotCategory likedCatTravelCourse = SpotCategory(
  code: 'TRAVEL_COURSE',
  label: 'Travel Courses',
);
const SpotCategory likedCatTransport = SpotCategory(
  code: 'TRANSPORT',
  label: 'Transport',
);

// ─── spot_detail ───────────────────────────────────────────────
const SpotCategory detailCatTouristSpot = SpotCategory(
  code: 'TOURIST_SPOT',
  label: 'Tourist Spots',
);
const SpotCategory detailCatRestaurant = SpotCategory(
  code: 'RESTAURANT',
  label: 'Restaurants',
);
const SpotCategory detailCatTravelCourse = SpotCategory(
  code: 'TRAVEL_COURSE',
  label: 'Travel Courses',
);
const SpotCategory detailCatTransport = SpotCategory(
  code: 'TRANSPORT',
  label: 'Transport',
);

// ─── swipe_queue ───────────────────────────────────────────────
const TouristSpot _a = TouristSpot(
  id: 'a',
  name: 'A',
  imageRef: 'a',
  location: 'Seoul',
);

const TouristSpot _b = TouristSpot(
  id: 'b',
  name: 'B',
  imageRef: 'b',
  location: 'Seoul',
);

void main() {
  // ─── copyright_type ──────────────────────────────────────────

  test('fromWire maps known tokens', () {
    expect(CopyrightType.fromWire('TYPE1'), CopyrightType.type1);
    expect(CopyrightType.fromWire('type3'), CopyrightType.type3);
  });

  test('fromWire falls back to unspecified for unknown/null', () {
    expect(CopyrightType.fromWire(null), CopyrightType.unspecified);
    expect(CopyrightType.fromWire('TYPE_X'), CopyrightType.unspecified);
  });

  test(
    'only TYPE1 allows cropping (cover); others keep original (contain)',
    () {
      expect(CopyrightType.type1.cropAllowed, isTrue);
      expect(CopyrightType.type3.cropAllowed, isFalse);
      expect(CopyrightType.unspecified.cropAllowed, isFalse);
    },
  );

  // ─── distance ────────────────────────────────────────────────

  test('kilometers converts meters and formats to one decimal', () {
    const Distance d = Distance(1234);
    expect(d.kilometers, closeTo(1.234, 1e-9));
    expect(d.kilometersLabel, '1.2');
  });

  test('sub-kilometer distances report meters', () {
    const Distance d = Distance(850);
    expect(d.isSubKilometer, isTrue);
    expect(d.metersLabel, '850');
  });

  test('one kilometer is not sub-kilometer', () {
    expect(const Distance(1000).isSubKilometer, isFalse);
  });

  test('equality is by meters', () {
    expect(const Distance(500), const Distance(500));
    expect(const Distance(500) == const Distance(501), isFalse);
  });

  // ─── liked_spot ──────────────────────────────────────────────

  LikedSpot buildLikedSpot({String id = 'spot-1', String? address = 'Seoul'}) =>
      LikedSpot(
        id: id,
        title: 'Gyeongbokgung',
        thumbnailImageUrl: 'https://img/1.jpg',
        address: address,
        category: likedCatTouristSpot,
        copyright: CopyrightType.type1,
        attributionText: 'KTO',
      );

  test('LikedSpot equality is value-based', () {
    expect(buildLikedSpot(), buildLikedSpot());
    expect(buildLikedSpot().hashCode, buildLikedSpot().hashCode);
    expect(buildLikedSpot(), isNot(buildLikedSpot(id: 'spot-2')));
  });

  test('주소는 없을 수 있다', () {
    // 서버가 주소를 안 주는 항목이 있다 — 카드가 주소 행을 그리지 않을 뿐 오류가 아니다.
    expect(buildLikedSpot(address: null).address, isNull);
  });

  // ─── retry_budget ────────────────────────────────────────────

  group('RetryBudget', () {
    test('기본 상한은 최초 1회 + 자동 재시도 1회 = 총 2회다 (AC-2)', () {
      const RetryBudget budget = RetryBudget();
      expect(budget.isExhausted, isFalse);
      expect(budget.countFailure(SpotFailure.network).isExhausted, isFalse);
      expect(
        budget
            .countFailure(SpotFailure.network)
            .countFailure(SpotFailure.network)
            .isExhausted,
        isTrue,
      );
    });

    test('상한을 넘겨 카운터가 계속 커지지 않는다', () {
      RetryBudget budget = const RetryBudget();
      for (int i = 0; i < 5; i++) {
        budget = budget.countFailure(SpotFailure.network);
      }
      expect(budget.attempts, RetryBudget.defaultMaxAttempts);
    });

    test('소진시킨 실패를 보존해 원인을 지어내지 않는다', () {
      final RetryBudget exhausted = const RetryBudget()
          .countFailure(SpotFailure.network)
          .countFailure(SpotFailure.upstreamUnavailable);
      expect(exhausted.isExhausted, isTrue);
      expect(exhausted.lastFailure, SpotFailure.upstreamUnavailable);
    });

    test('reset은 카운터를 0으로 되돌린다 (AC-9)', () {
      final RetryBudget exhausted = const RetryBudget()
          .countFailure(SpotFailure.network)
          .countFailure(SpotFailure.network);
      expect(exhausted.isExhausted, isTrue);
      expect(exhausted.reset().isExhausted, isFalse);
      expect(exhausted.reset().attempts, 0);
    });

    test('자동 재시도 허용 횟수는 상한에서 파생되어 어긋나지 않는다', () {
      expect(maxAutoRetries, RetryBudget.defaultMaxAttempts - 1);
    });
  });

  group('countsTowardRetryBudget', () {
    test('인증 실패는 계상하지 않는다 (AC-14)', () {
      expect(countsTowardRetryBudget(SpotFailure.unauthenticated), isFalse);
    });

    test('위치 실패는 계상하지 않는다', () {
      expect(
        countsTowardRetryBudget(
          const LocationUnavailable(LocationUnavailableReason.permissionDenied),
        ),
        isFalse,
      );
    });

    test('네트워크·업스트림 실패는 계상한다 (AC-16)', () {
      expect(countsTowardRetryBudget(SpotFailure.network), isTrue);
      expect(countsTowardRetryBudget(SpotFailure.upstreamUnavailable), isTrue);
      expect(countsTowardRetryBudget(SpotFailure.notFound), isTrue);
    });
  });

  group('spotRetryPolicy', () {
    test('자동 재시도를 1회만 허용한다 (AC-1·AC-2)', () {
      expect(spotRetryPolicy(0, SpotFailure.network), isNotNull);
      expect(spotRetryPolicy(1, SpotFailure.network), isNull);
    });

    test('계상하지 않는 실패에는 자동 재시도를 붙이지 않는다 (AC-15)', () {
      expect(spotRetryPolicy(0, SpotFailure.unauthenticated), isNull);
    });
  });

  test('RetryExhausted는 원인을 보존한다', () {
    const RetryExhausted exhausted = RetryExhausted(SpotFailure.network);
    expect(exhausted.cause, SpotFailure.network);
  });

  // ─── spot_detail ─────────────────────────────────────────────

  const SpotImage image = SpotImage(
    imageUrl: 'https://img/1.jpg',
    copyright: CopyrightType.type1,
    attributionText: 'KTO',
  );

  SpotDetail buildSpotDetail({int likeCount = 5}) => SpotDetail(
    id: 'c1',
    title: 'Gyeongbokgung',
    thumbnailImageUrl: 'https://img/thumb.jpg',
    coordinates: const Coordinates(latitude: 37.5665, longitude: 126.9780),
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
    expect(buildSpotDetail(), buildSpotDetail());
    expect(buildSpotDetail().hashCode, buildSpotDetail().hashCode);
    expect(buildSpotDetail(likeCount: 5), isNot(buildSpotDetail(likeCount: 6)));
  });

  test('blank or whitespace-only values count as absent', () {
    // TourAPI는 값이 없을 때 null이 아니라 빈 문자열/공백을 주기도 한다 —
    // 그 경우에도 섹션이 숨겨져야 한다(빈 라벨 금지, AC-25).
    final SpotDetail blank = SpotDetail(
      id: 'c1',
      title: 'T',
      thumbnailImageUrl: 'https://img/t.jpg',
      coordinates: const Coordinates(latitude: 37.5665, longitude: 126.9780),
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
    final SpotDetail full = buildSpotDetail();

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
      thumbnailImageUrl: 'https://img/t.jpg',
      coordinates: const Coordinates(latitude: 37.5665, longitude: 126.9780),
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
          thumbnailImageUrl: 'https://img/t.jpg',
          coordinates: const Coordinates(latitude: 37.5665, longitude: 126.9780),
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
      thumbnailImageUrl: 'https://img/t.jpg',
      coordinates: const Coordinates(latitude: 37.5665, longitude: 126.9780),
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
      thumbnailImageUrl: 'https://img/t.jpg',
      coordinates: const Coordinates(latitude: 37.5665, longitude: 126.9780),
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
    final SpotDetail original = buildSpotDetail(likeCount: 5);
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
      thumbnailImageUrl: 'https://img/thumb.jpg',
      coordinates: Coordinates(latitude: 37.5665, longitude: 126.9780),
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
      thumbnailImageUrl: 'https://img/thumb.jpg',
      coordinates: Coordinates(latitude: 37.5665, longitude: 126.9780),
      copyright: CopyrightType.type1,
      attributionText: 'Source: KTO',
      gallery: <SpotImage>[],
      likeCount: 0,
    );

    expect(sparse.gallery, isEmpty);
    expect(sparse.distinctImageAttributions, isEmpty);
  });

  // ─── spot_failure ────────────────────────────────────────────

  test('fromQueryErrorCode maps known codes to kinds', () {
    expect(
      SpotFailure.fromQueryErrorCode('SPOT_NOT_FOUND').kind,
      SpotFailureKind.notFound,
    );
    expect(
      SpotFailure.fromQueryErrorCode('UPSTREAM_RATE_LIMITED').kind,
      SpotFailureKind.rateLimited,
    );
    expect(
      SpotFailure.fromQueryErrorCode('UPSTREAM_UNAVAILABLE').kind,
      SpotFailureKind.upstreamUnavailable,
    );
  });

  test('fromQueryErrorCode is case-insensitive', () {
    expect(
      SpotFailure.fromQueryErrorCode('spot_not_found').kind,
      SpotFailureKind.notFound,
    );
  });

  test('isSpotMissing covers both the query and the mutation shape', () {
    // 상세 조회: 최상위 errors[] → notFound로 번역된 형태.
    expect(SpotFailure.notFound.isSpotMissing, isTrue);
    // 반응 전송: payload userErrors[] → userError + 코드 형태(대소문자 무관).
    expect(
      const SpotFailure(
        SpotFailureKind.userError,
        code: 'spot_not_found',
      ).isSpotMissing,
      isTrue,
    );
    expect(SpotFailure.rateLimited.isSpotMissing, isFalse);
  });

  // SPEC-0029 R-20 — "없다"와 "이 언어에서 못 본다"는 안내가 달라야 한다.
  test('SPOT_NOT_FOUND_IN_LOCALE은 notFound와 다른 종류로 번역된다', () {
    expect(
      SpotFailure.fromQueryErrorCode('SPOT_NOT_FOUND_IN_LOCALE').kind,
      SpotFailureKind.notFoundInLocale,
    );
    // 접두사가 겹치므로 SPOT_NOT_FOUND로 흘러가면 안 된다.
    expect(
      SpotFailure.fromQueryErrorCode('SPOT_NOT_FOUND').kind,
      SpotFailureKind.notFound,
    );
    expect(
      SpotFailure.fromQueryErrorCode('spot_not_found_in_locale').kind,
      SpotFailureKind.notFoundInLocale,
    );
  });

  test('isSpotMissingInLocale이 안내를 가른다', () {
    // 안내 문구를 가르는 판정 — 언어를 바꾸면 볼 수 있는 장소인지.
    expect(SpotFailure.notFoundInLocale.isSpotMissingInLocale, isTrue);
    expect(SpotFailure.notFound.isSpotMissingInLocale, isFalse);
    // 뮤테이션의 userErrors 형태로도 온다(reactToSpot·createPost 등).
    expect(
      const SpotFailure(
        SpotFailureKind.userError,
        code: 'SPOT_NOT_FOUND_IN_LOCALE',
      ).isSpotMissingInLocale,
      isTrue,
    );
  });

  test('두 코드 모두 카드를 큐에서 걷어낸다', () {
    // 스와이프 큐에서 빼는 판단에는 둘이 같은 결론이다 — 어느 쪽이든 지금 그 카드는
    // 열리지 않으므로, 남겨 두면 같은 카드가 계속 돌아온다.
    expect(SpotFailure.notFoundInLocale.isSpotMissing, isTrue);
    expect(
      const SpotFailure(
        SpotFailureKind.userError,
        code: 'SPOT_NOT_FOUND_IN_LOCALE',
      ).isSpotMissing,
      isTrue,
    );
  });

  test('fromQueryErrorCode falls back to network for unknown/null', () {
    expect(
      SpotFailure.fromQueryErrorCode('WHATEVER').kind,
      SpotFailureKind.network,
    );
    expect(SpotFailure.fromQueryErrorCode(null).kind, SpotFailureKind.network);
  });

  // ─── spot_info_item ──────────────────────────────────────────

  test('an item with a name or text has content', () {
    expect(const SpotInfoItem(name: '입장료', text: '3,000원').hasContent, isTrue);
    // 한쪽만 있어도 보여줄 값은 있다.
    expect(const SpotInfoItem(name: '입장료', text: '').hasContent, isTrue);
    expect(const SpotInfoItem(name: '', text: '3,000원').hasContent, isTrue);
  });

  test('an item that is blank on both sides has nothing to show', () {
    // non-null이지만 공백뿐인 항목 — 그리면 빈 줄만 남으므로 제외 대상이다.
    expect(const SpotInfoItem(name: '', text: '').hasContent, isFalse);
    expect(const SpotInfoItem(name: '  ', text: '\n').hasContent, isFalse);
  });

  test('display getters strip the markup TourAPI sends', () {
    const SpotInfoItem item = SpotInfoItem(
      name: '이용시간',
      text: '[평일]<br>09:00~18:00 &amp; 예약제',
    );

    expect(item.displayName, '이용시간');
    expect(item.displayText, '[평일]\n09:00~18:00 & 예약제');
  });

  test('an item that is only markup has nothing to show', () {
    // 태그만 남은 항목은 정리 후 비므로 "값 없음"과 같게 다뤄야 한다.
    expect(const SpotInfoItem(name: '<br>', text: '<br>').hasContent, isFalse);
  });

  test('SpotInfoItem equality is value-based', () {
    expect(
      const SpotInfoItem(name: 'a', text: 'b'),
      const SpotInfoItem(name: 'a', text: 'b'),
    );
    expect(
      const SpotInfoItem(name: 'a', text: 'b'),
      isNot(const SpotInfoItem(name: 'a', text: 'c')),
    );
  });

  // ─── spot_intro ──────────────────────────────────────────────

  test('presentEntries keeps only fields that have a value', () {
    const SpotIntro intro = SpotIntro(
      businessHours: '09:00 ~ 18:00',
      closedDays: null,
      fee: '3,000원',
    );

    expect(
      intro.presentEntries.map((SpotIntroEntry e) => e.field),
      <SpotIntroField>[SpotIntroField.businessHours, SpotIntroField.fee],
    );
    expect(intro.hasAny, isTrue);
  });

  test('blank and whitespace-only values count as absent', () {
    // 서버가 null 대신 빈 문자열을 줘도 빈 라벨("주차: ")이 남으면 안 된다(AC-25).
    const SpotIntro intro = SpotIntro(
      businessHours: '',
      parking: '   ',
      fee: '\n',
    );

    expect(intro.presentEntries, isEmpty);
    expect(intro.hasAny, isFalse);
  });

  test('values are trimmed for display', () {
    const SpotIntro intro = SpotIntro(businessHours: '  09:00 ~ 18:00  ');

    expect(intro.presentEntries.single.value, '09:00 ~ 18:00');
  });

  test('an intro with no fields at all reports nothing to show', () {
    // 여행코스처럼 운영 정보 개념이 없는 카테고리 — 섹션을 통째로 숨긴다.
    expect(const SpotIntro().hasAny, isFalse);
    expect(const SpotIntro().presentEntries, isEmpty);
  });

  test('entries follow the display order, not the declaration order', () {
    // 여행자가 확인하는 순서: 언제 여는가 → 닫는가 → 얼마인가 → 부가 조건.
    const SpotIntro intro = SpotIntro(
      businessHours: '09:00',
      closedDays: '월요일',
      parking: '가능',
      inquiryPhone: '02-000',
      fee: '무료',
      petAllowed: '불가',
      creditCardAccepted: '가능',
    );

    expect(
      intro.presentEntries.map((SpotIntroEntry e) => e.field),
      <SpotIntroField>[
        SpotIntroField.businessHours,
        SpotIntroField.closedDays,
        SpotIntroField.fee,
        SpotIntroField.parking,
        SpotIntroField.petAllowed,
        SpotIntroField.creditCardAccepted,
        SpotIntroField.inquiryPhone,
      ],
    );
  });

  test('SpotIntro equality is value-based', () {
    expect(const SpotIntro(fee: '무료'), const SpotIntro(fee: '무료'));
    expect(const SpotIntro(fee: '무료'), isNot(const SpotIntro(fee: '유료')));
  });

  // ─── swipe_queue ─────────────────────────────────────────────

  test('top returns the first card, null when empty', () {
    const SwipeQueue full = SwipeQueue(
      cards: <TouristSpot>[_a],
      loadedPage: 0,
      hasNextPage: false,
    );
    expect(full.top, _a);

    const SwipeQueue empty = SwipeQueue(
      cards: <TouristSpot>[],
      loadedPage: 0,
      hasNextPage: false,
    );
    expect(empty.top, isNull);
  });

  test('isExhausted only when empty and no next page', () {
    expect(
      // SPEC-0029에서 원문/번역 두 구간이 사라져 소진 판정이 한 줄로 돌아왔다.
      const SwipeQueue(
        cards: <TouristSpot>[],
        loadedPage: 0,
        hasNextPage: false,
      ).isExhausted,
      isTrue,
    );
    expect(
      const SwipeQueue(
        cards: <TouristSpot>[],
        loadedPage: 0,
        hasNextPage: true,
      ).isExhausted,
      isFalse,
    );
    expect(
      const SwipeQueue(
        cards: <TouristSpot>[_a],
        loadedPage: 0,
        hasNextPage: false,
      ).isExhausted,
      isFalse,
    );
  });

  test('nextPage is the page after loadedPage, null when exhausted', () {
    const SwipeQueue more = SwipeQueue(
      cards: <TouristSpot>[_a],
      loadedPage: 2,
      hasNextPage: true,
    );
    expect(more.nextPage, 3);

    const SwipeQueue done = SwipeQueue(
      cards: <TouristSpot>[_a],
      loadedPage: 2,
      hasNextPage: false,
    );
    expect(done.nextPage, isNull);
  });

  // SPEC-0029 — 원문/번역 구간이 사라져 페이지 번호가 한 줄로 이어진다. 마지막
  // 페이지를 받은 뒤 0으로 되감기던 전환점이 없다.
  test('마지막 페이지 뒤에 되감기지 않는다', () {
    const SwipeQueue lastPage = SwipeQueue(
      cards: <TouristSpot>[_a],
      loadedPage: 3,
      hasNextPage: false,
    );

    expect(lastPage.nextPage, isNull, reason: '이어 받을 구간이 없다');
    expect(lastPage.isExhausted, isFalse, reason: '카드가 남아 있다');
  });

  // SPEC-0035 — 추천 묶음 소스에는 페이지가 없다. loadedPage가 null이면 hasNextPage가
  // 참이어도 넘길 페이지 번호가 없고, 보충은 컨트롤러가 같은 인자로 다시 부른다.
  test('묶음 소스(loadedPage null)는 nextPage가 없다', () {
    const SwipeQueue bundle = SwipeQueue(
      cards: <TouristSpot>[_a],
      loadedPage: null,
      hasNextPage: true,
    );

    expect(bundle.nextPage, isNull);
    expect(bundle.isExhausted, isFalse);
    expect(bundle.copyWith(hasNextPage: false).loadedPage, isNull);
  });

  test('copyWith replaces only given fields', () {
    const SwipeQueue q = SwipeQueue(
      cards: <TouristSpot>[_a],
      loadedPage: 1,
      hasNextPage: true,
    );
    final SwipeQueue next = q.copyWith(cards: const <TouristSpot>[]);
    expect(next.cards, isEmpty);
    expect(next.loadedPage, 1);
    expect(next.hasNextPage, isTrue);
  });

  test('removeCard drops every occurrence of the id', () {
    const SwipeQueue q = SwipeQueue(
      cards: <TouristSpot>[_a, _b, _a],
      loadedPage: 0,
      hasNextPage: false,
    );

    final SwipeQueue next = q.removeCard(_a.id);

    expect(next.cards.map((TouristSpot s) => s.id), <String>[_b.id]);
  });

  test('removeCard returns the same queue when the id is absent', () {
    const SwipeQueue q = SwipeQueue(
      cards: <TouristSpot>[_a],
      loadedPage: 0,
      hasNextPage: false,
    );

    expect(identical(q.removeCard('missing'), q), isTrue);
  });

  // ─── swipe_feed_key (SPEC-0035) ──────────────────────────────

  test('SwipeFeedKey는 소스와 선택 둘 다로 같음을 판정한다', () {
    final SpotCategorySelection sel = SpotCategorySelection(
      const <SpotCategory>[SpotCategory(code: 'TOURIST_SPOT', label: 'T')],
    );
    final SwipeFeedKey rec = SwipeFeedKey(recommended: true, selection: sel);

    expect(rec, SwipeFeedKey(recommended: true, selection: sel));
    expect(rec, isNot(SwipeFeedKey(recommended: false, selection: sel)));
    expect(
      rec,
      isNot(
        SwipeFeedKey(recommended: true, selection: SpotCategorySelection.empty),
      ),
    );
    expect(
      rec.hashCode,
      SwipeFeedKey(recommended: true, selection: sel).hashCode,
    );
  });

  test('SwipeFeedKey.scopeKey는 소스 접두로 같은 필터의 두 소스를 가른다', () {
    expect(
      SwipeFeedKey(
        recommended: true,
        selection: SpotCategorySelection.empty,
      ).scopeKey,
      'recommended/',
    );
    expect(
      SwipeFeedKey(
        recommended: false,
        selection: SpotCategorySelection(const <SpotCategory>[
          SpotCategory(code: 'TOURIST_SPOT', label: 'T'),
        ]),
      ).scopeKey,
      'all/TOURIST_SPOT',
    );
  });

  // ─── tour_api_text ───────────────────────────────────────────

  test('converts <br> to line breaks in a real opentimefood value', () {
    // 서버가 실제로 내려준 형태.
    const String raw =
        '[평일]<br>- 11:30~22:00<br>- 준비시간 15:00~17:30<br>'
        '- 점심 마지막 주문 14:00 / 저녁 마지막 주문 21:00<br>'
        '[주말]<br>- 11:30~21:00';

    expect(sanitizeTourApiText(raw), '''
[평일]
- 11:30~22:00
- 준비시간 15:00~17:30
- 점심 마지막 주문 14:00 / 저녁 마지막 주문 21:00
[주말]
- 11:30~21:00''');
  });

  test('handles every <br> spelling', () {
    expect(sanitizeTourApiText('a<br>b<br/>c<br />d<BR>e'), 'a\nb\nc\nd\ne');
  });

  test('strips other tags but keeps their text', () {
    expect(sanitizeTourApiText('<b>굵게</b> 보통'), '굵게 보통');
  });

  test('treats block tag closings as line breaks', () {
    // 문단이 서로 붙어버리지 않게.
    expect(sanitizeTourApiText('<p>첫 줄</p><p>둘째 줄</p>'), '첫 줄\n둘째 줄');
  });

  test('decodes the entities TourAPI actually sends', () {
    expect(
      sanitizeTourApiText('커피&amp;디저트&nbsp;안내 &lt;주의&gt;'),
      '커피&디저트 안내 <주의>',
    );
  });

  test('trims each line and collapses runs of blank lines', () {
    // 원문에 줄 끝 공백과 <br><br><br>이 흔하다.
    expect(sanitizeTourApiText('a  <br>  b<br><br><br>c'), 'a\nb\n\nc');
  });

  test('keeps angle brackets that are not tags', () {
    // 원문에 꺾쇠가 강조 용도로 그냥 쓰인다 — 태그로 오인해 지우면 내용이 사라진다.
    expect(sanitizeTourApiText('5세 미만 <무료> 입장'), '5세 미만 <무료> 입장');
    expect(sanitizeTourApiText('11:00 <-> 22:00'), '11:00 <-> 22:00');
    expect(sanitizeTourApiText('가격 < 10000원'), '가격 < 10000원');
  });

  test('decodes numeric entities too', () {
    // 명명 엔티티만 처리하면 &#40;가 화면에 그대로 남아 뒤섞인다.
    expect(sanitizeTourApiText('&#40;주차 가능&#41;'), '(주차 가능)');
    expect(sanitizeTourApiText('09:00 &#8211; 18:00'), '09:00 – 18:00');
  });

  test('returns null when nothing displayable remains', () {
    // "값 없으면 안 그린다" 판단이 태그만 남은 값에도 적용되도록 null을 돌려준다.
    expect(sanitizeTourApiText(null), isNull);
    expect(sanitizeTourApiText(''), isNull);
    expect(sanitizeTourApiText('   '), isNull);
    expect(sanitizeTourApiText('<br>'), isNull);
    expect(sanitizeTourApiText('<br><br>&nbsp;'), isNull);
  });

  test('leaves plain text untouched apart from trimming', () {
    expect(sanitizeTourApiText('  09:00 ~ 18:00  '), '09:00 ~ 18:00');
  });

  // ─── tourist_spot ────────────────────────────────────────────

  test('TouristSpot equality is value-based', () {
    const TouristSpot a = TouristSpot(
      id: '1',
      name: 'N Seoul Tower',
      imageRef: 'nseoul',
      location: 'Seoul, Yongsan-gu',
      distanceMeters: 2400,
    );
    const TouristSpot b = TouristSpot(
      id: '1',
      name: 'N Seoul Tower',
      imageRef: 'nseoul',
      location: 'Seoul, Yongsan-gu',
      distanceMeters: 2400,
    );
    const TouristSpot different = TouristSpot(
      id: '2',
      name: 'N Seoul Tower',
      imageRef: 'nseoul',
      location: 'Seoul, Yongsan-gu',
      distanceMeters: 2400,
    );

    expect(a, b);
    expect(a.hashCode, b.hashCode);
    expect(a, isNot(different));
  });

  // AC-15.2·AC-15.3 — 홈 화면 모델에 별점·혼잡도 필드가 **없다**.
  //
  // 없어진 필드는 런타임 단언으로 잡을 수 없다. 그 이름을 쓰는 코드는 애초에
  // 컴파일되지 않기 때문이다 — **이 테스트 파일이 컴파일된다는 사실 자체가
  // 필드가 없다는 증거**이고, 누군가 rating을 되살리면 아래 목록이 어긋나 깨진다.
  //
  // 리플렉션(dart:mirrors)은 Flutter에서 못 쓰므로, 모델이 노출하는 값 집합을
  // 여기에 고정하는 것이 실질적인 방어선이다.
  test('TouristSpot carries only server-backed values', () {
    const TouristSpot spot = TouristSpot(
      id: '1',
      name: 'N Seoul Tower',
      imageRef: 'nseoul',
      location: 'Seoul, Yongsan-gu',
      thumbnailImageUrl: 'https://example.test/n.jpg',
      address: '105 Namsangongwon-gil',
      distanceMeters: 2400,
      attributionText: 'KTO',
    );

    // 서버가 실제로 주는 값들.
    expect(spot.id, '1');
    expect(spot.name, 'N Seoul Tower');
    expect(spot.location, 'Seoul, Yongsan-gu');
    expect(spot.thumbnailImageUrl, 'https://example.test/n.jpg');
    expect(spot.address, '105 Namsangongwon-gil');
    expect(spot.attributionText, 'KTO');
    // 거리는 서버 계산값이라 남는다 — 미터 단위이며 표시 포맷은 위젯이 붙인다.
    expect(spot.distance?.meters, 2400);
  });

}
