import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/common/localization/app_language.dart';
import 'package:ieuri_k_trip_spot/common/localization/locale_controller.dart';
import 'package:ieuri_k_trip_spot/common/storage/app_preferences.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/copyright_type.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/liked_spot.dart';
import 'package:ieuri_k_trip_spot/common/category/spot_category.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/spot_failure.dart';
import 'package:ieuri_k_trip_spot/domain/spot/provider/liked_spots_providers.dart';
import 'package:ieuri_k_trip_spot/domain/spot/provider/spot_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../spot_test_doubles.dart';

/// 좋아요 목록 커서 페이징 상태 전이(SPEC-0008 R-18, 설계 §6).
LikedSpot _liked(String id, {SpotCategory category = catTouristSpot}) =>
    LikedSpot(
      id: id,
      title: 'Spot $id',
      thumbnailImageUrl: 'https://img/$id.jpg',
      category: category,
      copyright: CopyrightType.type1,
      attributionText: 'KTO',
    );

/// 컨트롤러가 언어 전환 시 목록을 다시 받으려고 locale을 watch하므로, 그 뒤에 있는
/// 저장소도 덮어써야 한다(swipe_controller_test와 같은 규약).
late SharedPreferences _prefs;

ProviderContainer _container(FakeSpotRepository repo) {
  final ProviderContainer container = ProviderContainer(
    overrides: [
      spotRepositoryProvider.overrideWithValue(repo),
      sharedPreferencesProvider.overrideWithValue(_prefs),
    ],
  );
  addTearDown(container.dispose);
  return container;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    _prefs = await SharedPreferences.getInstance();
  });

  test('첫 빌드가 첫 페이지를 싣고 다음 페이지 유무를 알린다', () async {
    // 3건 · 페이지 크기 2 → 첫 장은 2건이고 다음이 있다.
    final FakeSpotRepository repo = FakeSpotRepository(
      liked: <LikedSpot>[_liked('a'), _liked('b'), _liked('c')],
    );

    final LikedSpotsState state = await _container(
      repo,
    ).read(likedSpotsControllerProvider(noCategories).future);

    expect(state.items.map((LikedSpot s) => s.id), <String>['a', 'b']);
    expect(state.hasMore, isTrue);
    expect(state.isEmpty, isFalse);
  });

  test('loadMore가 다음 장을 이어 붙인다 (재정렬하지 않는다)', () async {
    final FakeSpotRepository repo = FakeSpotRepository(
      liked: <LikedSpot>[_liked('a'), _liked('b'), _liked('c')],
    );
    final ProviderContainer container = _container(repo);
    await container.read(likedSpotsControllerProvider(noCategories).future);

    await container
        .read(likedSpotsControllerProvider(noCategories).notifier)
        .loadMore();

    final LikedSpotsState state = container
        .read(likedSpotsControllerProvider(noCategories))
        .requireValue;
    // 서버가 준 순서 그대로 이어 붙는다 — 클라이언트가 정렬하지 않는다(§5.2).
    expect(state.items.map((LikedSpot s) => s.id), <String>['a', 'b', 'c']);
    expect(state.hasMore, isFalse);
  });

  test('소진 후 loadMore는 조회하지 않는다', () async {
    final FakeSpotRepository repo = FakeSpotRepository(
      liked: <LikedSpot>[_liked('a')],
    );
    final ProviderContainer container = _container(repo);
    await container.read(likedSpotsControllerProvider(noCategories).future);
    expect(repo.likedSpotsCallCount, 1);

    await container
        .read(likedSpotsControllerProvider(noCategories).notifier)
        .loadMore();

    // hasMore=false이므로 호출이 늘지 않는다.
    expect(repo.likedSpotsCallCount, 1);
  });

  test('좋아요가 없으면 빈 상태다', () async {
    final LikedSpotsState state = await _container(
      FakeSpotRepository(),
    ).read(likedSpotsControllerProvider(noCategories).future);

    expect(state.items, isEmpty);
    expect(state.isEmpty, isTrue);
  });

  test('미인증이면 오류 상태로 노출된다', () async {
    // UNAUTHENTICATED는 SPEC-0005의 세션 갱신 경로가 처리한다 — 이 provider는
    // 실패를 그대로 드러내기만 한다(§5.2).
    final ProviderContainer container = _container(
      FakeSpotRepository(likedSpotsFailure: SpotFailure.unauthenticated),
    );
    // autoDispose라 구독을 유지해야 오류 상태를 읽는 동안 살아있다.
    container.listen(likedSpotsControllerProvider(noCategories), (_, _) {});

    // Future를 먼저 변수로 붙잡아 구독을 확정한 뒤 매처에 넘긴다 — expectLater에
    // `.future`를 바로 넘기면 구독이 한 틀 늦게 붙어 컨테이너 폐기와 경쟁한다.
    final Future<LikedSpotsState> pending = container.read(
      likedSpotsControllerProvider(noCategories).future,
    );

    await expectLater(
      pending,
      throwsA(
        isA<SpotFailure>().having(
          (SpotFailure f) => f.kind,
          'kind',
          SpotFailureKind.unauthenticated,
        ),
      ),
    );
  });

  // --- 카테고리 필터 ----------------------------------------------------------

  test('선택한 카테고리가 서버 조회에 실린다', () async {
    // 필터링은 서버가 한다 — 클라이언트가 받은 목록을 거르지 않는다.
    final FakeSpotRepository repo = FakeSpotRepository(
      liked: <LikedSpot>[
        _liked('a'),
        _liked('b', category: catRestaurant),
      ],
    );

    await _container(repo).read(
      likedSpotsControllerProvider(
        selectionOf(const <SpotCategory>[catRestaurant]),
      ).future,
    );

    expect(repo.lastLikedCategoryCodes, <String>[catRestaurant.code]);
  });

  test('카테고리마다 별개의 목록을 본다', () async {
    final FakeSpotRepository repo = FakeSpotRepository(
      liked: <LikedSpot>[
        _liked('a'),
        _liked('b', category: catRestaurant),
      ],
    );
    final ProviderContainer container = _container(repo);

    final LikedSpotsState all = await container.read(
      likedSpotsControllerProvider(noCategories).future,
    );
    final LikedSpotsState dining = await container.read(
      likedSpotsControllerProvider(
        selectionOf(const <SpotCategory>[catRestaurant]),
      ).future,
    );

    // 전체는 둘 다, 음식점은 하나만 — family 인스턴스가 서로 섞이지 않는다.
    expect(all.items.map((LikedSpot s) => s.id), <String>['a', 'b']);
    expect(dining.items.map((LikedSpot s) => s.id), <String>['b']);
  });

  test('전체(null)는 카테고리 인자를 보내지 않는다', () async {
    final FakeSpotRepository repo = FakeSpotRepository(
      liked: <LikedSpot>[_liked('a')],
    );

    await _container(
      repo,
    ).read(likedSpotsControllerProvider(noCategories).future);

    expect(repo.lastLikedCategoryCodes, isNull);
  });

  test('추가 로딩이 실패해도 이미 받은 목록은 지우지 않는다', () async {
    // 첫 장(호출 1회)은 성공하고, loadMore(호출 2회차)만 실패한다.
    final FakeSpotRepository repo = FakeSpotRepository(
      liked: <LikedSpot>[_liked('a'), _liked('b'), _liked('c')],
      likedSpotsFailure: SpotFailure.network,
      failLikedAfter: 1,
    );
    final ProviderContainer container = _container(repo);
    await container.read(likedSpotsControllerProvider(noCategories).future);

    await container
        .read(likedSpotsControllerProvider(noCategories).notifier)
        .loadMore();

    final LikedSpotsState state = container
        .read(likedSpotsControllerProvider(noCategories))
        .requireValue;
    // 보고 있던 목록은 그대로 남고 오류 화면으로 바뀌지 않는다.
    expect(state.items.map((LikedSpot s) => s.id), <String>['a', 'b']);
    // 인디케이터는 걷힌다 — 다시 스크롤하면 재시도된다.
    expect(state.isLoadingMore, isFalse);
  });

  // 좋아요 자체는 SPEC-0019 이후 언어를 넘어 유지되지만, 쌓아둔 항목의 제목·주소는
  // 이전 언어로 받아온 문장이다. 좋아요 탭은 셸 브랜치라 계속 mount되어 autoDispose가
  // 돌지 않으므로, locale을 watch하지 않으면 한국어 이름이 그대로 남는다.
  test('언어를 바꾸면 목록을 다시 받는다', () async {
    final FakeSpotRepository repo = FakeSpotRepository(
      liked: <LikedSpot>[_liked('a')],
    );
    final ProviderContainer container = _container(repo);
    await container.read(likedSpotsControllerProvider(noCategories).future);
    expect(repo.likedSpotsCallCount, 1);

    await container
        .read(localeControllerProvider.notifier)
        .select(AppLanguage.korean);
    await container.read(likedSpotsControllerProvider(noCategories).future);

    expect(repo.likedSpotsCallCount, 2);
  });
}
