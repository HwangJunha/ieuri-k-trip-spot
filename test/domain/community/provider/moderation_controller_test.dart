import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/domain/community/model/community_failure.dart';
import 'package:ieuri_k_trip_spot/domain/community/model/report_reason.dart';
import 'package:ieuri_k_trip_spot/domain/community/provider/community_providers.dart';
import 'package:ieuri_k_trip_spot/domain/community/provider/moderation_providers.dart';

import '../community_test_doubles.dart';

ProviderContainer _container(FakeCommunityRepository repo) {
  final ProviderContainer container = ProviderContainer(
    overrides: [communityRepositoryProvider.overrideWithValue(repo)],
  );
  addTearDown(container.dispose);
  return container;
}

void main() {
  group('차단 (R15)', () {
    test('작성자 id로 차단 뮤테이션이 나간다', () async {
      final FakeCommunityRepository repo = FakeCommunityRepository();
      final ProviderContainer container = _container(repo);

      final ModerationOutcome outcome = await container
          .read(moderationControllerProvider.notifier)
          .block('19');

      expect(outcome, ModerationOutcome.success);
      expect(repo.lastBlockedMemberId, '19');
    });

    // 가이드 §13 — 쓰기는 전부 인증 필수다. 화면이 로그인으로 유도하려면 이 결과가
    // 일반 실패와 구분돼야 한다.
    test('미인증은 전용 결과로 구분된다', () async {
      final FakeCommunityRepository repo = FakeCommunityRepository()
        ..mutationError = CommunityFailure.unauthenticated;
      final ProviderContainer container = _container(repo);

      final ModerationOutcome outcome = await container
          .read(moderationControllerProvider.notifier)
          .block('19');

      expect(outcome, ModerationOutcome.unauthenticated);
    });

    test('전송 실패는 일반 실패로 접힌다', () async {
      final FakeCommunityRepository repo = FakeCommunityRepository()
        ..mutationError = CommunityFailure.network;
      final ProviderContainer container = _container(repo);

      expect(
        await container.read(moderationControllerProvider.notifier).block('19'),
        ModerationOutcome.failure,
      );
    });
  });

  group('신고 (R16)', () {
    test('사유와 상세가 그대로 넘어간다', () async {
      final FakeCommunityRepository repo = FakeCommunityRepository();
      final ProviderContainer container = _container(repo);

      await container
          .read(moderationControllerProvider.notifier)
          .report(
            targetType: ReportTargetType.post,
            targetId: 'p1',
            reason: ReportReason.other,
            detail: '기타 사유입니다',
          );

      expect(repo.lastReport?.reason, ReportReason.other);
      expect(repo.lastReport?.detail, '기타 사유입니다');
      expect(repo.lastReport?.targetType, ReportTargetType.post);
    });

    // 가이드 §7 — 재신고는 서버가 막는 정상 흐름이다. 오류 토스트로 띄우면
    // 사용자는 무언가 고장난 줄 안다.
    test('ALREADY_REPORTED는 실패가 아니라 안내용 결과다', () async {
      final FakeCommunityRepository repo = FakeCommunityRepository()
        ..mutationError = CommunityFailure.userError('ALREADY_REPORTED');
      final ProviderContainer container = _container(repo);

      final ModerationOutcome outcome = await container
          .read(moderationControllerProvider.notifier)
          .report(
            targetType: ReportTargetType.post,
            targetId: 'p1',
            reason: ReportReason.spam,
          );

      expect(outcome, ModerationOutcome.alreadyReported);
    });
  });

  test('삭제는 글 id로 나간다', () async {
    final FakeCommunityRepository repo = FakeCommunityRepository();
    final ProviderContainer container = _container(repo);

    final ModerationOutcome outcome = await container
        .read(moderationControllerProvider.notifier)
        .deletePost('p1');

    expect(outcome, ModerationOutcome.success);
    expect(repo.lastDeletedPostId, 'p1');
  });

  test('차단 해제도 같은 규약을 따른다', () async {
    final FakeCommunityRepository repo = FakeCommunityRepository();
    final ProviderContainer container = _container(repo);

    await container.read(moderationControllerProvider.notifier).unblock('19');

    expect(repo.lastUnblockedMemberId, '19');
  });
}
