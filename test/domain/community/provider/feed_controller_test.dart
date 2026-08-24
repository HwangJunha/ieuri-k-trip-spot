import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/common/location/location_providers.dart';
import 'package:ieuri_k_trip_spot/domain/community/model/community_failure.dart';
import 'package:ieuri_k_trip_spot/common/model/post.dart';
import 'package:ieuri_k_trip_spot/domain/community/model/post_sort_order.dart';
import 'package:ieuri_k_trip_spot/domain/community/model/target_category_selection.dart';
import 'package:ieuri_k_trip_spot/common/model/target_category.dart';
import 'package:ieuri_k_trip_spot/domain/community/provider/community_providers.dart';
import 'package:ieuri_k_trip_spot/domain/community/provider/feed_providers.dart';

import '../../spot/spot_test_doubles.dart';
import '../community_test_doubles.dart';

/// 커뮤니티 repository와 좌표만 페이크로 갈아끼운 컨테이너. 피드 컨트롤러가
/// **전이적으로** 위치 provider를 watch하므로 그것까지 오버라이드해야 컨테이너가
/// 선다 — 빠뜨리면 provider가 오류 상태로 떠 `.future`가 완결되지 않는다.
ProviderContainer _container(FakeCommunityRepository repo) {
  final ProviderContainer container = ProviderContainer(
    overrides: [
      communityRepositoryProvider.overrideWithValue(repo),
      locationServiceProvider.overrideWithValue(FakeLocationService()),
    ],
  );
  addTearDown(container.dispose);
  return container;
}

/// 필터 없음("전체") — 서버에는 `categories` 인자가 나가지 않는다.
final TargetCategorySelection _allCategories = TargetCategorySelection(
  const <TargetCategory>[],
);

void main() {
  group('SelectedCategory', () {
    test('처음에는 전체(빈 집합)다', () {
      final ProviderContainer container = _container(FakeCommunityRepository());
      expect(container.read(selectedCategoryProvider), isEmpty);
    });

    test('칩 선택이 상태에 반영된다', () {
      final ProviderContainer container = _container(FakeCommunityRepository());
      container
          .read(selectedCategoryProvider.notifier)
          .toggle(TargetCategory.restaurant);

      expect(container.read(selectedCategoryProvider), <TargetCategory>{
        TargetCategory.restaurant,
      });
    });
  });

  group('FeedController', () {
    test('첫 페이지를 받아 누적 상태로 만든다', () async {
      final ProviderContainer container = _container(
        FakeCommunityRepository(posts: <Post>[fakePost(id: 'p1')]),
      );

      final FeedState state = await container.read(
        feedControllerProvider(_allCategories, PostSortOrder.latest).future,
      );

      expect(state.items, hasLength(1));
      expect(state.hasMore, isFalse);
      expect(state.isEmpty, isFalse);
    });

    test('글이 없고 더 받을 것도 없으면 빈 피드다', () async {
      final ProviderContainer container = _container(FakeCommunityRepository());

      final FeedState state = await container.read(
        feedControllerProvider(_allCategories, PostSortOrder.latest).future,
      );

      expect(state.isEmpty, isTrue);
    });

    // 가이드 §2 — 좌표는 함께 넘기고, 카테고리는 범위와 독립으로 함께 걸린다.
    test('좌표와 선택된 카테고리를 서버로 넘긴다', () async {
      final FakeCommunityRepository repo = FakeCommunityRepository();
      final ProviderContainer container = _container(repo);

      await container.read(
        feedControllerProvider(
          TargetCategorySelection(const <TargetCategory>[
            TargetCategory.lodging,
            TargetCategory.restaurant,
          ]),
          PostSortOrder.latest,
        ).future,
      );

      expect(repo.lastFetchPosts?.categories, <TargetCategory>[
        TargetCategory.lodging,
        TargetCategory.restaurant,
      ]);
      expect(repo.lastFetchPosts?.latitude, isNotNull);
      expect(repo.lastFetchPosts?.longitude, isNotNull);
      // 커뮤니티 탭은 좌표 피드라 catalogId를 주지 않는다 — 주면 좌표가 무시된다.
      expect(repo.lastFetchPosts?.catalogId, isNull);
    });

    test('loadMore가 다음 페이지를 이어 붙인다', () async {
      final FakeCommunityRepository repo = FakeCommunityRepository(
        posts: <Post>[fakePost(id: 'p1')],
        hasNextPage: true,
        nextPagePosts: <Post>[fakePost(id: 'p2')],
      );
      final ProviderContainer container = _container(repo);
      await container.read(
        feedControllerProvider(_allCategories, PostSortOrder.latest).future,
      );

      await container
          .read(
            feedControllerProvider(
              _allCategories,
              PostSortOrder.latest,
            ).notifier,
          )
          .loadMore();

      final FeedState state = container
          .read(feedControllerProvider(_allCategories, PostSortOrder.latest))
          .value!;
      expect(state.items.map((Post p) => p.id), <String>['p1', 'p2']);
      expect(state.hasMore, isFalse);
      // 커서를 다음 조회의 after로 넘긴다(가이드 §2).
      expect(repo.lastFetchPosts?.after, 'cursor-1');
    });

    test('더 받을 것이 없으면 loadMore가 조회하지 않는다', () async {
      final FakeCommunityRepository repo = FakeCommunityRepository(
        posts: <Post>[fakePost()],
      );
      final ProviderContainer container = _container(repo);
      await container.read(
        feedControllerProvider(_allCategories, PostSortOrder.latest).future,
      );

      await container
          .read(
            feedControllerProvider(
              _allCategories,
              PostSortOrder.latest,
            ).notifier,
          )
          .loadMore();

      expect(repo.lastFetchPosts?.after, isNull);
    });

    test('조회 실패는 오류 상태가 된다', () async {
      final ProviderContainer container = _container(
        FakeCommunityRepository(feedError: CommunityFailure.network),
      );
      container.listen(
        feedControllerProvider(_allCategories, PostSortOrder.latest),
        (_, _) {},
        fireImmediately: true,
      );

      await expectLater(
        container.read(
          feedControllerProvider(_allCategories, PostSortOrder.latest).future,
        ),
        throwsA(isA<CommunityFailure>()),
      );
    });
  });

  group('toggleLike (낙관적)', () {
    test('즉시 반영하고 서버 likeCount로 되맞춘다', () async {
      final FakeCommunityRepository repo = FakeCommunityRepository(
        posts: <Post>[fakePost(likeCount: 3, likedByViewer: false)],
        // 멱등이라 서버 값이 낙관적 예측(4)과 다를 수 있다. 서버 값이 정본이다.
        serverLikeCount: 9,
      );
      final ProviderContainer container = _container(repo);
      await container.read(
        feedControllerProvider(_allCategories, PostSortOrder.latest).future,
      );

      await container
          .read(
            feedControllerProvider(
              _allCategories,
              PostSortOrder.latest,
            ).notifier,
          )
          .toggleLike('p1');

      final Post post = container
          .read(feedControllerProvider(_allCategories, PostSortOrder.latest))
          .value!
          .items
          .single;
      expect(post.likedByViewer, isTrue);
      expect(post.likeCount, 9);
      expect(repo.likeCalls, 1);
    });

    test('이미 좋아요한 글은 해제 뮤테이션이 나간다', () async {
      final FakeCommunityRepository repo = FakeCommunityRepository(
        posts: <Post>[fakePost(likeCount: 3, likedByViewer: true)],
        serverLikeCount: 2,
      );
      final ProviderContainer container = _container(repo);
      await container.read(
        feedControllerProvider(_allCategories, PostSortOrder.latest).future,
      );

      await container
          .read(
            feedControllerProvider(
              _allCategories,
              PostSortOrder.latest,
            ).notifier,
          )
          .toggleLike('p1');

      expect(repo.unlikeCalls, 1);
      final Post post = container
          .read(feedControllerProvider(_allCategories, PostSortOrder.latest))
          .value!
          .items
          .single;
      expect(post.likedByViewer, isFalse);
      expect(post.likeCount, 2);
    });

    test('실패하면 이전 값으로 롤백한다', () async {
      final FakeCommunityRepository repo = FakeCommunityRepository(
        posts: <Post>[fakePost(likeCount: 3, likedByViewer: false)],
        likeError: CommunityFailure.network,
      );
      final ProviderContainer container = _container(repo);
      await container.read(
        feedControllerProvider(_allCategories, PostSortOrder.latest).future,
      );

      await expectLater(
        container
            .read(
              feedControllerProvider(
                _allCategories,
                PostSortOrder.latest,
              ).notifier,
            )
            .toggleLike('p1'),
        throwsA(isA<CommunityFailure>()),
      );

      final Post post = container
          .read(feedControllerProvider(_allCategories, PostSortOrder.latest))
          .value!
          .items
          .single;
      expect(post.likedByViewer, isFalse);
      expect(post.likeCount, 3);
    });
  });

  // 2차 가이드 §3 — 정렬 토글.
  group('SelectedSort', () {
    test('처음에는 최신순이다', () {
      final ProviderContainer container = _container(FakeCommunityRepository());
      expect(container.read(selectedSortProvider), PostSortOrder.latest);
    });

    test('선택이 상태에 반영된다', () {
      final ProviderContainer container = _container(FakeCommunityRepository());
      container
          .read(selectedSortProvider.notifier)
          .select(PostSortOrder.distance);

      expect(container.read(selectedSortProvider), PostSortOrder.distance);
    });
  });

  group('정렬 전환 (2차 가이드 §3)', () {
    test('정렬을 서버로 넘긴다', () async {
      final FakeCommunityRepository repo = FakeCommunityRepository();
      final ProviderContainer container = _container(repo);

      await container.read(
        feedControllerProvider(_allCategories, PostSortOrder.distance).future,
      );

      expect(repo.lastFetchPosts?.sort, PostSortOrder.distance);
    });

    // **정렬을 바꾸면 커서를 버리고 첫 페이지부터 다시 조회한다.** 두 정렬의 커서
    // 형식이 달라 이전 커서를 그대로 넘기면 서버가 INVALID_INPUT을 준다.
    test('정렬을 바꾸면 이전 커서를 재사용하지 않고 처음부터 받는다', () async {
      final FakeCommunityRepository repo = FakeCommunityRepository(
        posts: <Post>[fakePost(id: 'p1')],
        hasNextPage: true,
        nextPagePosts: <Post>[fakePost(id: 'p2')],
      );
      final ProviderContainer container = _container(repo);

      // 최신순으로 첫 페이지 + 다음 페이지까지 받아 커서를 소진한다.
      await container.read(
        feedControllerProvider(_allCategories, PostSortOrder.latest).future,
      );
      await container
          .read(
            feedControllerProvider(
              _allCategories,
              PostSortOrder.latest,
            ).notifier,
          )
          .loadMore();

      // 거리순으로 옮긴다 — 다른 family 인스턴스라 커서 없이 처음부터 받는다.
      await container.read(
        feedControllerProvider(_allCategories, PostSortOrder.distance).future,
      );

      final ({PostSortOrder? sort, String? after, bool? hiddenByViewer}) last =
          repo.fetchPostsCalls.last;
      expect(last.sort, PostSortOrder.distance);
      expect(last.after, isNull);
      // 거리순 조회는 최신순 커서('cursor-1')를 한 번도 쓰지 않았다.
      expect(
        repo.fetchPostsCalls.where(
          (({PostSortOrder? sort, String? after, bool? hiddenByViewer}) c) =>
              c.sort == PostSortOrder.distance && c.after != null,
        ),
        isEmpty,
      );
    });

    test('추가 로딩은 첫 페이지와 같은 정렬로 나간다', () async {
      final FakeCommunityRepository repo = FakeCommunityRepository(
        posts: <Post>[fakePost(id: 'p1')],
        hasNextPage: true,
        nextPagePosts: <Post>[fakePost(id: 'p2')],
      );
      final ProviderContainer container = _container(repo);
      await container.read(
        feedControllerProvider(_allCategories, PostSortOrder.distance).future,
      );

      await container
          .read(
            feedControllerProvider(
              _allCategories,
              PostSortOrder.distance,
            ).notifier,
          )
          .loadMore();

      expect(repo.lastFetchPosts?.sort, PostSortOrder.distance);
      expect(repo.lastFetchPosts?.after, 'cursor-1');
    });

    // 좌표를 못 얻어도 DISTANCE는 오류가 아니다 — 서버가 LATEST처럼 동작한다.
    test('거리순도 좌표 없이 오류가 되지 않는다', () async {
      final FakeCommunityRepository repo = FakeCommunityRepository(
        posts: <Post>[fakePost(id: 'p1')],
      );
      final ProviderContainer container = _container(repo);

      final FeedState state = await container.read(
        feedControllerProvider(_allCategories, PostSortOrder.distance).future,
      );

      expect(state.items, hasLength(1));
    });
  });

  group('spotPosts', () {
    // 가이드 §2 — catalogId를 주면 좌표는 무시되므로 아예 넘기지 않는다. 위치 권한이
    // 없어도 도는 것이 이 피드의 성질이다.
    test('catalogId만 넘기고 좌표는 넘기지 않는다', () async {
      final FakeCommunityRepository repo = FakeCommunityRepository(
        posts: <Post>[fakePost()],
      );
      final ProviderContainer container = _container(repo);

      await container.read(spotPostsProvider('11094').future);

      expect(repo.lastFetchPosts?.catalogId, '11094');
      expect(repo.lastFetchPosts?.latitude, isNull);
    });
  });
}
