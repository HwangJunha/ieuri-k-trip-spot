import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/common/location/location_providers.dart';
import 'package:ieuri_k_trip_spot/domain/community/model/community_failure.dart';
import 'package:ieuri_k_trip_spot/domain/community/model/post.dart';
import 'package:ieuri_k_trip_spot/domain/community/model/post_topic.dart';
import 'package:ieuri_k_trip_spot/domain/community/provider/community_providers.dart';
import 'package:ieuri_k_trip_spot/domain/community/provider/nearby_feed_providers.dart';

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
  group('SelectedPostTopic', () {
    test('처음에는 전체(null)다', () {
      final ProviderContainer container = _container(FakeCommunityRepository());
      expect(container.read(selectedPostTopicProvider), isNull);
    });

    test('칩 선택이 상태에 반영된다 (R8)', () {
      final ProviderContainer container = _container(FakeCommunityRepository());
      container.read(selectedPostTopicProvider.notifier).select(PostTopic.tip);

      expect(container.read(selectedPostTopicProvider), PostTopic.tip);
    });

    // R11-3 — 타일 진입과 칩 선택이 서로 다른 화면 상태를 만들지 않는다.
    test('타일 진입도 칩과 같은 상태에 반영된다 (R11-3)', () {
      final ProviderContainer container = _container(FakeCommunityRepository());
      container
          .read(selectedPostTopicProvider.notifier)
          .applyFromTile(PostTopic.question);

      expect(container.read(selectedPostTopicProvider), PostTopic.question);
    });
  });

  group('NearbyFeedController', () {
    test('첫 페이지를 받아 누적 상태로 만든다', () async {
      final ProviderContainer container = _container(
        FakeCommunityRepository(posts: <Post>[fakePost(id: 'p1')]),
      );

      final NearbyFeedState state = await container.read(
        nearbyFeedControllerProvider(null).future,
      );

      expect(state.items, hasLength(1));
      expect(state.hasMore, isFalse);
      expect(state.isEmpty, isFalse);
    });

    test('글이 없고 더 받을 것도 없으면 빈 상태다', () async {
      final ProviderContainer container = _container(FakeCommunityRepository());

      final NearbyFeedState state = await container.read(
        nearbyFeedControllerProvider(null).future,
      );

      expect(state.isEmpty, isTrue);
    });

    // R8 — 태그별로 다른 인스턴스가 서버에 필터를 넘긴다. 클라이언트가 받은 목록을
    // 거르지 않는다.
    test('선택한 태그가 그대로 서버로 넘어간다 (R8)', () async {
      final FakeCommunityRepository repo = FakeCommunityRepository(
        posts: <Post>[fakePost()],
      );
      final ProviderContainer container = _container(repo);

      await container.read(
        nearbyFeedControllerProvider(PostTopic.companion).future,
      );

      expect(repo.lastTopic, PostTopic.companion);
    });

    test('loadMore가 endCursor를 넘겨 다음 장을 이어 붙인다', () async {
      final FakeCommunityRepository repo = FakeCommunityRepository(
        posts: <Post>[fakePost(id: 'p1')],
        hasNextPage: true,
        nextPagePosts: <Post>[fakePost(id: 'p2')],
      );
      final ProviderContainer container = _container(repo);

      await container.read(nearbyFeedControllerProvider(null).future);
      await container
          .read(nearbyFeedControllerProvider(null).notifier)
          .loadMore();

      final NearbyFeedState state = container
          .read(nearbyFeedControllerProvider(null))
          .requireValue;
      expect(repo.lastAfter, 'cursor-1');
      expect(state.items.map((Post p) => p.id), <String>['p1', 'p2']);
      expect(state.hasMore, isFalse);
    });

    test('더 받을 것이 없으면 loadMore가 아무것도 하지 않는다', () async {
      final FakeCommunityRepository repo = FakeCommunityRepository(
        posts: <Post>[fakePost()],
      );
      final ProviderContainer container = _container(repo);

      await container.read(nearbyFeedControllerProvider(null).future);
      await container
          .read(nearbyFeedControllerProvider(null).notifier)
          .loadMore();

      expect(repo.lastAfter, isNull);
    });

    // 조회가 실패하면 화면이 오류 상태를 보여줄 수 있도록 AsyncValue.error가 돼야
    // 한다 — 빈 화면이나 영원한 로딩으로 남으면 안 된다. 지금 서버의 커넥션 어댑터
    // 예외가 정확히 이 경로다.
    test('조회 실패는 AsyncValue.error로 노출된다', () async {
      final ProviderContainer container = _container(
        FakeCommunityRepository(feedError: CommunityFailure.network),
      );
      // 구독을 걸어 두어야 autoDispose provider가 로딩 중 폐기되지 않는다.
      container.listen(
        nearbyFeedControllerProvider(null),
        (_, _) {},
        fireImmediately: true,
      );

      await expectLater(
        container.read(nearbyFeedControllerProvider(null).future),
        throwsA(isA<CommunityFailure>()),
      );
      expect(
        container.read(nearbyFeedControllerProvider(null)).hasError,
        isTrue,
      );
    });
  });

  group('좋아요 낙관적 갱신 (R12)', () {
    test('탭 즉시 반영하고 서버가 준 수로 되맞춘다', () async {
      final FakeCommunityRepository repo = FakeCommunityRepository(
        posts: <Post>[fakePost(id: 'p1', likeCount: 3, likedByViewer: false)],
        // 가이드 §8 — 멱등이라 서버 값이 낙관적 예측(4)과 다를 수 있다. 서버가 정본.
        serverLikeCount: 9,
      );
      final ProviderContainer container = _container(repo);

      await container.read(nearbyFeedControllerProvider(null).future);
      await container
          .read(nearbyFeedControllerProvider(null).notifier)
          .toggleLike('p1');

      final Post post = container
          .read(nearbyFeedControllerProvider(null))
          .requireValue
          .items
          .single;
      expect(repo.likeCalls, 1);
      expect(post.likedByViewer, isTrue);
      expect(post.likeCount, 9);
    });

    test('실패하면 이전 값으로 롤백한다', () async {
      final FakeCommunityRepository repo = FakeCommunityRepository(
        posts: <Post>[fakePost(id: 'p1', likeCount: 3, likedByViewer: false)],
        likeError: CommunityFailure.network,
      );
      final ProviderContainer container = _container(repo);

      await container.read(nearbyFeedControllerProvider(null).future);
      await expectLater(
        container
            .read(nearbyFeedControllerProvider(null).notifier)
            .toggleLike('p1'),
        throwsA(isA<CommunityFailure>()),
      );

      final Post post = container
          .read(nearbyFeedControllerProvider(null))
          .requireValue
          .items
          .single;
      expect(post.likedByViewer, isFalse);
      expect(post.likeCount, 3);
    });

    test('이미 좋아요한 글은 해제 뮤테이션으로 간다', () async {
      final FakeCommunityRepository repo = FakeCommunityRepository(
        posts: <Post>[fakePost(id: 'p1', likeCount: 3, likedByViewer: true)],
        serverLikeCount: 2,
      );
      final ProviderContainer container = _container(repo);

      await container.read(nearbyFeedControllerProvider(null).future);
      await container
          .read(nearbyFeedControllerProvider(null).notifier)
          .toggleLike('p1');

      expect(repo.unlikeCalls, 1);
      expect(repo.likeCalls, 0);
      expect(
        container
            .read(nearbyFeedControllerProvider(null))
            .requireValue
            .items
            .single
            .likeCount,
        2,
      );
    });
  });
}
