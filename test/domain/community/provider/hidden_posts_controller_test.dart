import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/domain/community/model/community_failure.dart';
import 'package:ieuri_k_trip_spot/domain/community/model/post.dart';
import 'package:ieuri_k_trip_spot/domain/community/provider/community_providers.dart';
import 'package:ieuri_k_trip_spot/domain/community/provider/hidden_posts_providers.dart';

import '../community_test_doubles.dart';

ProviderContainer _container(FakeCommunityRepository repo) {
  final ProviderContainer container = ProviderContainer(
    overrides: [communityRepositoryProvider.overrideWithValue(repo)],
  );
  addTearDown(container.dispose);
  return container;
}

void main() {
  group('HiddenPostsController (2차 가이드 §2)', () {
    // 숨긴 글은 다른 모든 조회에서 빠지므로 이 인자로만 볼 수 있다.
    test('hiddenByViewer: true로 조회한다', () async {
      final FakeCommunityRepository repo = FakeCommunityRepository()
        ..hiddenPosts = <Post>[fakePost(id: 'p21', title: '경복궁 휴무일 주의하세요')];
      final ProviderContainer container = _container(repo);

      final HiddenPostsState state = await container.read(
        hiddenPostsControllerProvider.future,
      );

      expect(repo.lastFetchPosts?.hiddenByViewer, isTrue);
      expect(state.items.single.id, 'p21');
    });

    // 숨긴 글은 지역 피드가 아니라 "내가 숨긴 것" 전체다 — 좌표를 걸면 다른 도시에서
    // 숨긴 글을 풀 수 없다.
    test('좌표를 넘기지 않는다', () async {
      final FakeCommunityRepository repo = FakeCommunityRepository();
      final ProviderContainer container = _container(repo);

      await container.read(hiddenPostsControllerProvider.future);

      expect(repo.lastFetchPosts?.latitude, isNull);
      expect(repo.lastFetchPosts?.longitude, isNull);
    });

    test('숨긴 글이 없으면 빈 목록이다', () async {
      final ProviderContainer container = _container(FakeCommunityRepository());

      final HiddenPostsState state = await container.read(
        hiddenPostsControllerProvider.future,
      );

      expect(state.isEmpty, isTrue);
    });

    test('조회 실패는 오류 상태가 된다', () async {
      final ProviderContainer container = _container(
        FakeCommunityRepository(feedError: CommunityFailure.network),
      );
      container.listen(
        hiddenPostsControllerProvider,
        (_, _) {},
        fireImmediately: true,
      );

      await expectLater(
        container.read(hiddenPostsControllerProvider.future),
        throwsA(isA<CommunityFailure>()),
      );
    });
  });
}
