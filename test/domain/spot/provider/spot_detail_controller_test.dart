import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/spot_category.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/spot_detail.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/spot_reaction.dart';
import 'package:ieuri_k_trip_spot/domain/spot/provider/spot_detail_providers.dart';
import 'package:ieuri_k_trip_spot/domain/spot/provider/spot_providers.dart';

import '../spot_test_doubles.dart';

/// [repo]로 SpotDetailController를 로드해 첫 상세를 반환한다.
Future<(ProviderContainer, SpotDetail)> _load(FakeSpotRepository repo) async {
  final container = ProviderContainer(
    overrides: [spotRepositoryProvider.overrideWithValue(repo)],
  );
  addTearDown(container.dispose);
  container.listen(
    spotDetailControllerProvider('c1', SpotCategory.touristSpot),
    (_, _) {},
    fireImmediately: true,
  );
  final SpotDetail detail = await container.read(
    spotDetailControllerProvider('c1', SpotCategory.touristSpot).future,
  );
  return (container, detail);
}

void main() {
  test('build loads the detail as data', () async {
    final repo = FakeSpotRepository(detail: detailSpot('c1', likeCount: 10));
    final (container, detail) = await _load(repo);

    expect(detail.id, 'c1');
    expect(detail.likeCount, 10);
  });

  // NOTE: 빌드 실패(fetch 실패)가 AsyncError로 노출되는 경로는 위젯 테스트
  // (spot_detail_view_test.dart의 'shows the not-found error state')가 실제 위젯
  // 라이프사이클로 검증한다. 여기 provider 단위 테스트는 낙관적/롤백 로직에 집중한다.

  test(
    'like optimistically increments likeCount and records the reaction',
    () async {
      final repo = FakeSpotRepository(detail: detailSpot('c1', likeCount: 10));
      final (container, _) = await _load(repo);

      await container
          .read(
            spotDetailControllerProvider(
              'c1',
              SpotCategory.touristSpot,
            ).notifier,
          )
          .react(SpotReaction.like);

      expect(
        container
            .read(spotDetailControllerProvider('c1', SpotCategory.touristSpot))
            .value!
            .likeCount,
        11,
      );
      expect(repo.recordedReactions, <(String, SpotReaction)>[
        ('c1', SpotReaction.like),
      ]);
    },
  );

  test('re-evaluating LIKE→DISLIKE overwrites: net −1', () async {
    final repo = FakeSpotRepository(detail: detailSpot('c1', likeCount: 10));
    final (container, _) = await _load(repo);
    final notifier = container.read(
      spotDetailControllerProvider('c1', SpotCategory.touristSpot).notifier,
    );

    await notifier.react(SpotReaction.like); // 10 → 11
    await notifier.react(SpotReaction.dislike); // 이전 LIKE 취소 → 10

    expect(
      container
          .read(spotDetailControllerProvider('c1', SpotCategory.touristSpot))
          .value!
          .likeCount,
      10,
    );
  });

  test('react rolls back likeCount and rethrows on failure (AC-30)', () async {
    final repo = FakeSpotRepository(
      detail: detailSpot('c1', likeCount: 10),
      reactShouldFail: true,
    );
    final (container, _) = await _load(repo);
    final notifier = container.read(
      spotDetailControllerProvider('c1', SpotCategory.touristSpot).notifier,
    );

    await expectLater(
      () => notifier.react(SpotReaction.like),
      throwsA(isA<StateError>()),
    );
    // 낙관적 +1이 롤백돼 원래 값으로 복귀.
    expect(
      container
          .read(spotDetailControllerProvider('c1', SpotCategory.touristSpot))
          .value!
          .likeCount,
      10,
    );
  });

  // §4.4 — 상세도 스와이프와 동일하게 링크 계층 재시도에 의존한다. 갱신이 성공하면
  // 요청이 성공하므로 **롤백이 발동하지 않는다**(AC-43). 별도의 재전송 장치는 없다.
  test('a reaction that succeeds after a token refresh keeps the optimistic count', () async {
    final repo = _RetryOnceDetailRepository(
      detail: detailSpot('c1', likeCount: 10),
    );
    final (container, _) = await _load(repo);
    final notifier = container.read(
      spotDetailControllerProvider('c1', SpotCategory.touristSpot).notifier,
    );

    // 인증 실패로 시작했지만 갱신 후 재시도가 성공하므로 예외가 나오지 않는다.
    await notifier.react(SpotReaction.like);

    // 낙관적 +1이 그대로 유지된다 — 롤백 없음.
    expect(
      container
          .read(spotDetailControllerProvider('c1', SpotCategory.touristSpot))
          .value!
          .likeCount,
      11,
    );
  });
}

/// 첫 `reactToSpot`은 인증 실패로 끝나고 재시도에서 성공하는 저장소(§4.4).
/// 링크 계층의 갱신·재시도를 provider 관점에서 관찰한 모습이다.
class _RetryOnceDetailRepository extends FakeSpotRepository {
  _RetryOnceDetailRepository({required super.detail});

  bool _refreshed = false;

  @override
  Future<void> reactToSpot(String spotId, SpotReaction reaction) async {
    if (!_refreshed) {
      _refreshed = true;
      return reactToSpot(spotId, reaction);
    }
    return super.reactToSpot(spotId, reaction);
  }
}
