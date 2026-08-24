import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/domain/community/model/community_failure.dart';
import 'package:ieuri_k_trip_spot/common/model/post.dart';
import 'package:ieuri_k_trip_spot/domain/community/provider/community_providers.dart';
import 'package:ieuri_k_trip_spot/domain/community/provider/post_detail_providers.dart';

import '../community_test_doubles.dart';

ProviderContainer _container(FakeCommunityRepository repo) {
  final ProviderContainer container = ProviderContainer(
    overrides: [communityRepositoryProvider.overrideWithValue(repo)],
  );
  addTearDown(container.dispose);
  return container;
}

void main() {
  test('글을 데이터로 노출한다', () async {
    final ProviderContainer container = _container(
      FakeCommunityRepository(post: fakePost()),
    );

    final Post? post = await container.read(postDetailProvider('p1').future);

    expect(post, isNotNull);
    expect(post!.title, isNotEmpty);
  });

  // 가이드 §6 — 차단·숨김·삭제는 **오류가 아니라 null**이다. AsyncValue.error가
  // 아니라 data(null)로 와야 화면이 "볼 수 없는 글" 안내를 띄울 수 있다.
  test('차단·숨김이면 오류가 아니라 data(null)이다', () async {
    final ProviderContainer container = _container(FakeCommunityRepository());

    final Post? post = await container.read(postDetailProvider('p1').future);

    expect(post, isNull);
    expect(container.read(postDetailProvider('p1')).hasError, isFalse);
  });

  test('조회 실패는 오류 상태가 된다', () async {
    final ProviderContainer container = _container(
      FakeCommunityRepository(feedError: CommunityFailure.network),
    );
    // 구독을 걸어야 autoDispose provider가 로딩 중 폐기되지 않는다.
    container.listen(
      postDetailProvider('p1'),
      (_, _) {},
      fireImmediately: true,
    );

    await expectLater(
      container.read(postDetailProvider('p1').future),
      throwsA(isA<CommunityFailure>()),
    );
    expect(container.read(postDetailProvider('p1')).hasError, isTrue);
  });
}
