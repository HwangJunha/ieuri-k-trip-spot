import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/domain/community/model/community_failure.dart';
import 'package:ieuri_k_trip_spot/domain/community/model/post_draft.dart';
import 'package:ieuri_k_trip_spot/domain/community/model/post_topic.dart';
import 'package:ieuri_k_trip_spot/domain/community/provider/community_providers.dart';
import 'package:ieuri_k_trip_spot/domain/community/provider/post_composer_providers.dart';

import '../community_test_doubles.dart';

ProviderContainer _container(FakeCommunityRepository repo) {
  final ProviderContainer container = ProviderContainer(
    overrides: [communityRepositoryProvider.overrideWithValue(repo)],
  );
  addTearDown(container.dispose);
  return container;
}

/// 대상이 이미 정해진 컴포저(관광지 상세에서 진입한 경우).
final PostComposerProvider _provider = postComposerProvider(
  initialTargetId: '11094',
  initialTargetTitle: '경복궁',
);

void main() {
  test('상세에서 진입하면 대상이 이미 정해진 채로 열린다', () {
    final ProviderContainer container = _container(FakeCommunityRepository());

    final PostDraft draft = container.read(_provider);

    expect(draft.targetId, '11094');
    expect(draft.targetTitle, '경복궁');
    // 태그는 미선택으로 시작한다(디자인 §3).
    expect(draft.topic, isNull);
    expect(draft.canSubmit, isFalse);
  });

  test('같은 태그를 다시 누르면 해제된다', () {
    final ProviderContainer container = _container(FakeCommunityRepository());
    final PostComposer notifier = container.read(_provider.notifier);

    notifier.setTopic(PostTopic.tip);
    expect(container.read(_provider).topic, PostTopic.tip);

    notifier.setTopic(PostTopic.tip);
    expect(container.read(_provider).topic, isNull);
  });

  // 설계 §3 — 입력을 자르면 붙여넣기한 유저가 무엇이 사라졌는지 모른다.
  test('500자를 넘겨도 본문을 자르지 않고 등록만 막는다', () {
    final ProviderContainer container = _container(FakeCommunityRepository());
    final PostComposer notifier = container.read(_provider.notifier)
      ..setTopic(PostTopic.review)
      ..setBody('가' * 501);

    final PostDraft draft = container.read(_provider);
    expect(draft.body.runes.length, 501);
    expect(draft.canSubmit, isFalse);
    expect(notifier, isNotNull);
  });

  group('등록', () {
    test('입력이 그대로 서버로 넘어가고 postId가 돌아온다', () async {
      final FakeCommunityRepository repo = FakeCommunityRepository()
        ..createdPostId = '42';
      final ProviderContainer container = _container(repo);
      container.read(_provider.notifier)
        ..setTopic(PostTopic.tip)
        ..setBody('  경복궁은 화요일 휴무예요.  ');

      final ComposerResult result = await container
          .read(_provider.notifier)
          .submit();

      expect(result, isA<ComposerSucceeded>());
      expect((result as ComposerSucceeded).postId, '42');
      expect(repo.lastCreatePost?.targetId, '11094');
      expect(repo.lastCreatePost?.topic, PostTopic.tip);
      // 앞뒤 공백은 다듬어 보낸다.
      expect(repo.lastCreatePost?.body, '경복궁은 화요일 휴무예요.');
      // 사진 업로드는 이번 범위 밖 — 빈 배열로 등록한다(가이드 §17).
      expect(repo.lastCreatePost?.photoKeys, isEmpty);
    });

    test('조건이 갖춰지지 않으면 서버로 나가지 않는다', () async {
      final FakeCommunityRepository repo = FakeCommunityRepository();
      final ProviderContainer container = _container(repo);
      // 태그를 고르지 않았다.
      container.read(_provider.notifier).setBody('본문만 있다.');

      final ComposerResult result = await container
          .read(_provider.notifier)
          .submit();

      expect(result, isA<ComposerFailed>());
      expect(repo.lastCreatePost, isNull);
    });

    // 가이드 §7 — 화면이 필드별 메시지로 옮길 수 있게 코드가 살아 있어야 한다.
    test('서버 userErrors 코드가 결과에 실린다', () async {
      final FakeCommunityRepository repo = FakeCommunityRepository()
        ..mutationError = CommunityFailure.userError(
          'POST_BODY_LENGTH_INVALID',
        );
      final ProviderContainer container = _container(repo);
      container.read(_provider.notifier)
        ..setTopic(PostTopic.tip)
        ..setBody('본문');

      final ComposerResult result = await container
          .read(_provider.notifier)
          .submit();

      expect(result, isA<ComposerRejected>());
      expect((result as ComposerRejected).code, 'POST_BODY_LENGTH_INVALID');
    });

    test('미인증은 전용 결과로 구분된다', () async {
      final FakeCommunityRepository repo = FakeCommunityRepository()
        ..mutationError = CommunityFailure.unauthenticated;
      final ProviderContainer container = _container(repo);
      container.read(_provider.notifier)
        ..setTopic(PostTopic.tip)
        ..setBody('본문');

      final ComposerResult result = await container
          .read(_provider.notifier)
          .submit();

      expect(result, isA<ComposerUnauthenticated>());
    });
  });

  // 커뮤니티 탭에서 진입하면 대상을 골라야 등록할 수 있다(디자인 §3).
  test('탭에서 진입하면 대상을 고른 뒤에야 등록할 수 있다', () {
    final ProviderContainer container = _container(FakeCommunityRepository());
    final PostComposerProvider provider = postComposerProvider();
    container.read(provider.notifier)
      ..setTopic(PostTopic.question)
      ..setBody('주차 가능한가요?');

    expect(container.read(provider).canSubmit, isFalse);

    container.read(provider.notifier).setTarget(id: '11094', title: '경복궁');

    expect(container.read(provider).canSubmit, isTrue);
  });
}
