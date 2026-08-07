import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/common/model/post.dart';
import 'package:ieuri_k_trip_spot/common/pagination/page.dart';
import 'package:ieuri_k_trip_spot/domain/settings/model/settings_failure.dart';
import 'package:ieuri_k_trip_spot/domain/settings/provider/my_posts_controller.dart';
import 'package:ieuri_k_trip_spot/domain/settings/provider/profile_providers.dart';

import '../../../common/post_fixtures.dart';
import '../profile_test_doubles.dart';

/// SPEC-0011 R3 — 첫 페이지·다음 페이지·빈 상태.

ProviderContainer _container(FakeProfileRepository repo) {
  final ProviderContainer container = ProviderContainer(
    overrides: [profileRepositoryProvider.overrideWithValue(repo)],
  );
  addTearDown(container.dispose);
  return container;
}

CursorPage<Post> _page(List<String> ids, {String? endCursor}) =>
    CursorPage<Post>(
      items: ids.map((String id) => fakePost(id: id)).toList(),
      hasNextPage: endCursor != null,
      endCursor: endCursor,
    );

void main() {
  test('첫 페이지를 싣고 커서를 보관한다', () async {
    final ProviderContainer container = _container(
      FakeProfileRepository(
        pages: <CursorPage<Post>>[
          _page(<String>['p1', 'p2'], endCursor: 'c1'),
        ],
      ),
    );

    final MyPostsState state = await container.read(
      myPostsControllerProvider.future,
    );

    expect(state.items.map((Post p) => p.id), <String>['p1', 'p2']);
    expect(state.hasMore, isTrue);
    expect(state.endCursor, 'c1');
  });

  test('다음 페이지를 이어 붙인다', () async {
    final FakeProfileRepository repo = FakeProfileRepository(
      pages: <CursorPage<Post>>[
        _page(<String>['p1'], endCursor: 'c1'),
        _page(<String>['p2']),
      ],
    );
    final ProviderContainer container = _container(repo);
    await container.read(myPostsControllerProvider.future);

    await container.read(myPostsControllerProvider.notifier).loadMore();

    final MyPostsState state = container.read(myPostsControllerProvider).value!;
    expect(state.items.map((Post p) => p.id), <String>['p1', 'p2']);
    expect(state.hasMore, isFalse);
    // 두 번째 조회는 첫 페이지가 준 커서를 실어야 한다.
    expect(repo.requestedCursors, <String?>[null, 'c1']);
  });

  test('빈 첫 페이지는 빈 상태다', () async {
    final ProviderContainer container = _container(FakeProfileRepository());

    final MyPostsState state = await container.read(
      myPostsControllerProvider.future,
    );

    expect(state.isEmpty, isTrue);
  });

  test('다음 페이지가 실패해도 이미 받은 목록은 남는다', () async {
    final FakeProfileRepository repo = FakeProfileRepository(
      pages: <CursorPage<Post>>[
        _page(<String>['p1'], endCursor: 'c1'),
      ],
    );
    final ProviderContainer container = _container(repo);
    await container.read(myPostsControllerProvider.future);

    // 첫 장을 받은 뒤에 다음 장만 실패시킨다.
    repo.fetchFailure = SettingsFailure.network;

    await container.read(myPostsControllerProvider.notifier).loadMore();

    final MyPostsState state = container.read(myPostsControllerProvider).value!;
    expect(state.items.map((Post p) => p.id), <String>['p1']);
    expect(state.isLoadingMore, isFalse);
  });
}
