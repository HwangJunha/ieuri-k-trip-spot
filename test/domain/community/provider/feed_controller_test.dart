import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/common/location/location_providers.dart';
import 'package:ieuri_k_trip_spot/domain/community/model/community_failure.dart';
import 'package:ieuri_k_trip_spot/domain/community/model/post.dart';
import 'package:ieuri_k_trip_spot/domain/community/model/target_category.dart';
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

void main() {
  group('SelectedCategory', () {
    test('처음에는 전체(null)다', () {
      final ProviderContainer container = _container(FakeCommunityRepository());
      expect(container.read(selectedCategoryProvider), isNull);
    });

    test('칩 선택이 상태에 반영된다', () {
      final ProviderContainer container = _container(FakeCommunityRepository());
      container
          .read(selectedCategoryProvider.notifier)
          .select(TargetCategory.restaurant);

      expect(
        container.read(selectedCategoryProvider),
        TargetCategory.restaurant,
      );
    });
  });

  group('FeedController', () {
    test('첫 페이지를 받아 누적 상태로 만든다', () async {
      final ProviderContainer container = _container(
        FakeCommunityRepository(posts: <Post>[fakePost(id: 'p1')]),
      );

      final FeedState state = await container.read(
        feedControllerProvider(null).future,
      );

      expect(state.items, hasLength(1));
      expect(state.hasMore, isFalse);
      expect(state.isEmpty, isFalse);
    });

    test('글이 없고 더 받을 것도 없으면 빈 피드다', () async {
      final ProviderContainer container = _container(FakeCommunityRepository());

      final FeedState state = await container.read(
        feedControllerProvider(null).future,
      );

      expect(state.isEmpty, isTrue);
    });

    // 가이드 §2 — 좌표는 함께 넘기고, 카테고리는 범위와 독립으로 함께 걸린다.
    test('좌표와 선택된 카테고리를 서버로 넘긴다', () async {
      final FakeCommunityRepository repo = FakeCommunityRepository();
      final ProviderContainer container = _container(repo);

      await container.read(
        feedControllerProvider(TargetCategory.lodging).future,
      );

      expect(repo.lastFetchPosts?.category, TargetCategory.lodging);
      expect(repo.lastFetchPosts?.latitude, isNotNull);
      expect(repo.lastFetchPosts?.longitude, isNotNull);
      // 커뮤니티 탭은 좌표 피드라 spotId를 주지 않는다 — 주면 좌표가 무시된다.
      expect(repo.lastFetchPosts?.spotId, isNull);
    });

    test('loadMore가 다음 페이지를 이어 붙인다', () async {
      final FakeCommunityRepository repo = FakeCommunityRepository(
        posts: <Post>[fakePost(id: 'p1')],
        hasNextPage: true,
        nextPagePosts: <Post>[fakePost(id: 'p2')],
      );
      final ProviderContainer container = _container(repo);
      await container.read(feedControllerProvider(null).future);

      await container.read(feedControllerProvider(null).notifier).loadMore();

      final FeedState state = container
          .read(feedControllerProvider(null))
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
      await container.read(feedControllerProvider(null).future);

      await container.read(feedControllerProvider(null).notifier).loadMore();

      expect(repo.lastFetchPosts?.after, isNull);
    });

    test('조회 실패는 오류 상태가 된다', () async {
      final ProviderContainer container = _container(
        FakeCommunityRepository(feedError: CommunityFailure.network),
      );
      container.listen(
        feedControllerProvider(null),
        (_, _) {},
        fireImmediately: true,
      );

      await expectLater(
        container.read(feedControllerProvider(null).future),
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
      await container.read(feedControllerProvider(null).future);

      await container
          .read(feedControllerProvider(null).notifier)
          .toggleLike('p1');

      final Post post = container
          .read(feedControllerProvider(null))
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
      await container.read(feedControllerProvider(null).future);

      await container
          .read(feedControllerProvider(null).notifier)
          .toggleLike('p1');

      expect(repo.unlikeCalls, 1);
      final Post post = container
          .read(feedControllerProvider(null))
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
      await container.read(feedControllerProvider(null).future);

      await expectLater(
        container.read(feedControllerProvider(null).notifier).toggleLike('p1'),
        throwsA(isA<CommunityFailure>()),
      );

      final Post post = container
          .read(feedControllerProvider(null))
          .value!
          .items
          .single;
      expect(post.likedByViewer, isFalse);
      expect(post.likeCount, 3);
    });
  });

  group('spotPosts', () {
    // 가이드 §2 — spotId를 주면 좌표는 무시되므로 아예 넘기지 않는다. 위치 권한이
    // 없어도 도는 것이 이 피드의 성질이다.
    test('spotId만 넘기고 좌표는 넘기지 않는다', () async {
      final FakeCommunityRepository repo = FakeCommunityRepository(
        posts: <Post>[fakePost()],
      );
      final ProviderContainer container = _container(repo);

      await container.read(spotPostsProvider('11094').future);

      expect(repo.lastFetchPosts?.spotId, '11094');
      expect(repo.lastFetchPosts?.latitude, isNull);
    });
  });
}
