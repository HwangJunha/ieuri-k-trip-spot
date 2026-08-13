import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/common/pagination/page.dart';
import 'package:ieuri_k_trip_spot/domain/feed/model/discover_segment.dart';
import 'package:ieuri_k_trip_spot/domain/feed/model/feed_item.dart';
import 'package:ieuri_k_trip_spot/domain/feed/provider/feed_list_providers.dart';
import 'package:ieuri_k_trip_spot/domain/feed/provider/feed_providers.dart';

import '../feed_test_doubles.dart';

ProviderContainer _container(FakeFeedRepository repo) {
  final ProviderContainer container = ProviderContainer(
    overrides: [feedRepositoryProvider.overrideWithValue(repo)],
  );
  addTearDown(container.dispose);
  return container;
}

void main() {
  group('세그먼트 토글 (R5)', () {
    test('기본은 추천이다 — 피드가 추천을 대체하지 않는다 (AC5-2)', () {
      final ProviderContainer container = _container(FakeFeedRepository());

      expect(
        container.read(selectedDiscoverSegmentProvider),
        DiscoverSegment.recommendation,
      );
    });

    test('피드로 전환하고 되돌릴 수 있다', () {
      final ProviderContainer container = _container(FakeFeedRepository());
      final SelectedDiscoverSegment notifier = container.read(
        selectedDiscoverSegmentProvider.notifier,
      );

      notifier.select(DiscoverSegment.feed);
      expect(
        container.read(selectedDiscoverSegmentProvider),
        DiscoverSegment.feed,
      );

      notifier.select(DiscoverSegment.recommendation);
      expect(
        container.read(selectedDiscoverSegmentProvider),
        DiscoverSegment.recommendation,
      );
    });

    test('토글을 오가도 피드 상태가 유지된다 (AC5-1)', () async {
      final FakeFeedRepository repo = FakeFeedRepository()
        ..feedPages.add(
          CursorPage<FeedItem>(
            items: <FeedItem>[feedItem('1')],
            hasNextPage: false,
          ),
        );
      final ProviderContainer container = _container(repo);
      await container.read(feedListControllerProvider.future);

      container
        ..read(
          selectedDiscoverSegmentProvider.notifier,
        ).select(DiscoverSegment.recommendation)
        ..read(
          selectedDiscoverSegmentProvider.notifier,
        ).select(DiscoverSegment.feed);

      // 다시 조회하지 않았고, 목록도 그대로다 — 토글은 어느 쪽을 그릴지만 정한다.
      expect(repo.feedAfterCursors.length, 1);
      expect(
        container.read(feedListControllerProvider).requireValue.items.single.id,
        '1',
      );
    });

    test('피드가 실패해도 토글 상태는 정상 동작한다 (AC5-3)', () async {
      final FakeFeedRepository repo = FakeFeedRepository()
        ..fetchFeedThrows = StateError('feed down');
      final ProviderContainer container = _container(repo);
      // 화면이 구독하고 있는 상황을 흉내낸다 — 구독이 없으면 autoDispose가 오류
      // 상태를 버리고 다시 build한다.
      container.listen(feedListControllerProvider, (_, _) {});

      await expectLater(
        container.read(feedListControllerProvider.future),
        throwsA(isA<StateError>()),
      );

      // 피드 provider가 오류 상태여도 토글은 추천으로 넘어간다 — 두 화면이 서로
      // 다른 provider를 보기 때문이다.
      container
          .read(selectedDiscoverSegmentProvider.notifier)
          .select(DiscoverSegment.recommendation);
      expect(
        container.read(selectedDiscoverSegmentProvider),
        DiscoverSegment.recommendation,
      );
      expect(container.read(feedListControllerProvider).hasError, isTrue);
    });
  });
}
