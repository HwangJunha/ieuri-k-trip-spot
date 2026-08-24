import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/common/model/composer_photo.dart';
import 'package:ieuri_k_trip_spot/common/model/stored_draft.dart';
import 'package:ieuri_k_trip_spot/common/model/target_category.dart';
import 'package:ieuri_k_trip_spot/common/storage/app_preferences.dart';
import 'package:ieuri_k_trip_spot/common/storage/draft_store.dart';
import 'package:ieuri_k_trip_spot/common/storage/draft_store_impl.dart';
import 'package:ieuri_k_trip_spot/domain/community/model/post_draft.dart';
import 'package:ieuri_k_trip_spot/domain/community/provider/community_providers.dart';
import 'package:ieuri_k_trip_spot/domain/community/provider/post_composer_providers.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../common/storage/fake_draft_store.dart';
import '../community_test_doubles.dart';

/// SPEC-0022 자동 저장. **디바운스 타이머의 실제 시간 경과는 테스트하지 않는다**
/// (§8) — 프레임워크의 동작이고 애플리케이션 경계 위에서 관찰할 수 없다. 대신
/// [PostComposer.flush]로 "대기 중인 변경을 지금 쓴다"는 경계만 두드린다.
/// 초안 저장이 활성 언어를 기록하므로(SPEC-0029 AC-26.2) `LocaleController`가
/// 살아야 하고, 그것이 `SharedPreferences`를 읽는다. `main`이 채워 둔다.
late SharedPreferences _prefs;

ProviderContainer _container(
  FakeDraftStore drafts, {
  FakeCommunityRepository? repo,
}) {
  final ProviderContainer container = ProviderContainer(
    overrides: [
      sharedPreferencesProvider.overrideWithValue(_prefs),
      communityRepositoryProvider.overrideWithValue(
        repo ?? FakeCommunityRepository(),
      ),
      draftStoreProvider.overrideWithValue(drafts),
    ],
  );
  addTearDown(container.dispose);
  return container;
}

PostComposer _notifier(ProviderContainer container, {bool editing = false}) =>
    container.read(postComposerProvider(editing: editing).notifier);

LocalPhoto _photo(String id) => LocalPhoto(
  id: id,
  bytes: Uint8List.fromList(<int>[1, 2, 3]),
  contentType: 'image/jpeg',
  name: '$id.jpg',
);

void main() {
  // 초안 저장이 활성 언어를 함께 남기므로 `SharedPreferences`가 필요하다.
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    _prefs = await SharedPreferences.getInstance();
  });

  group('저장 (R1)', () {
    test('작성 중인 내용이 저장된다', () {
      final FakeDraftStore drafts = FakeDraftStore();
      final PostComposer notifier = _notifier(_container(drafts));

      notifier
        ..setTitle('제목')
        ..setBody('본문')
        ..flush();

      expect(drafts.lastSaved?.title, '제목');
      expect(drafts.lastSaved?.body, '본문');
    });

    test('카테고리·장소·태그·사진도 함께 저장된다', () {
      final FakeDraftStore drafts = FakeDraftStore();
      final PostComposer notifier = _notifier(_container(drafts));

      notifier
        ..setCategory(TargetCategory.restaurant)
        ..setSpot(id: 'spot-1', title: '경복궁')
        ..addTag('맛집')
        ..addPhotos(<LocalPhoto>[_photo('a')])
        ..flush();

      final StoredDraft saved = drafts.lastSaved!;
      expect(saved.category, 'RESTAURANT');
      expect(saved.spotId, 'spot-1');
      expect(saved.spotTitle, '경복궁');
      expect(saved.tags, <String>['맛집']);
      expect(saved.photos, hasLength(1));
      // 바이트는 별도 파일로 나간다 — 저장 호출에 원본이 함께 실린다.
      expect(drafts.savedPhotos.last, hasLength(1));
    });

    test('빈 초안은 저장 대신 삭제한다 (R1-3)', () {
      // 그래야 "다 지웠는데도 이어쓰기를 묻는" 상태가 생기지 않는다.
      final FakeDraftStore drafts = FakeDraftStore();
      final PostComposer notifier = _notifier(_container(drafts));

      notifier
        ..setTitle('제목')
        ..flush();
      expect(drafts.saved, hasLength(1));

      notifier
        ..setTitle('')
        ..flush();

      expect(drafts.saved, hasLength(1), reason: '빈 초안은 저장되지 않는다');
      expect(drafts.clearCount, 1);
    });
  });

  group('복원 (R5)', () {
    // 기본 언어는 컨테이너의 활성 언어(en)와 같다 — 그래야 장소 참조가 살아남고,
    // 언어가 다른 경우는 아래 SPEC-0029 테스트가 따로 본다.
    StoredDraft stored({DateTime? savedAt, String? languageCode = 'en'}) =>
        StoredDraft(
          savedAt: savedAt ?? DateTime.utc(2026, 8, 16),
          category: 'RESTAURANT',
          languageCode: languageCode,
          spotId: 'spot-1',
          spotTitle: '경복궁',
          title: '저장된 제목',
          body: '저장된 본문',
          tags: const <String>['맛집'],
        );

    test('저장된 초안이 있으면 이어쓰기를 제안한다', () async {
      final FakeDraftStore drafts = FakeDraftStore(
        loadResult: DraftLoaded(stored(), const <ComposerPhoto>[]),
      );
      final PostComposer notifier = _notifier(_container(drafts));

      await notifier.considerDraft(now: DateTime.utc(2026, 8, 16));

      expect(notifier.restorePrompt, DraftRestorePrompt.offered);
      expect(drafts.clearCount, 0, reason: '제안 단계에서는 지우지 않는다');
    });

    test('이어쓰기를 고르면 상태가 채워진다', () async {
      final FakeDraftStore drafts = FakeDraftStore(
        loadResult: DraftLoaded(stored(), <ComposerPhoto>[
          const RemotePhoto('images/a'),
        ]),
      );
      final ProviderContainer container = _container(drafts);
      final PostComposer notifier = _notifier(container);

      await notifier.considerDraft(now: DateTime.utc(2026, 8, 16));
      notifier.restoreDraft();

      final PostDraft draft = container.read(postComposerProvider());
      expect(draft.title, '저장된 제목');
      expect(draft.body, '저장된 본문');
      expect(draft.category, TargetCategory.restaurant);
      expect(draft.spotId, 'spot-1');
      expect(draft.tags, <String>['맛집']);
      expect(draft.photos, <ComposerPhoto>[const RemotePhoto('images/a')]);
    });

    // SPEC-0029 AC-26.2 — spot이 언어별로 갈리므로 다른 언어에서 저장한 장소
    // 참조는 지금 해소되지 않을 수 있다. **본문·사진은 사용자가 쓴 것이라 지키고
    // 장소만 비운다.**
    test('다른 언어에서 저장한 초안은 장소만 비우고 본문·사진은 복원한다', () async {
      final FakeDraftStore drafts = FakeDraftStore(
        loadResult: DraftLoaded(stored(languageCode: 'ja'), <ComposerPhoto>[
          const RemotePhoto('images/a'),
        ]),
      );
      final ProviderContainer container = _container(drafts);
      final PostComposer notifier = _notifier(container);

      await notifier.considerDraft(now: DateTime.utc(2026, 8, 16));
      notifier.restoreDraft();

      final PostDraft draft = container.read(postComposerProvider());
      expect(draft.spotId, isNull, reason: '이 언어에서 해소된다는 보장이 없다');
      expect(draft.spotTitle, isNull, reason: '제목만 남으면 누를 수 없는 칩이 뜬다');
      expect(draft.title, '저장된 제목');
      expect(draft.body, '저장된 본문');
      expect(draft.photos, <ComposerPhoto>[const RemotePhoto('images/a')]);
    });

    // SPEC-0029 이전에 저장된 초안은 언어를 모른다 — 안전한 쪽으로 판단한다.
    test('언어를 모르는 예전 초안도 장소를 비운다', () async {
      final FakeDraftStore drafts = FakeDraftStore(
        loadResult: DraftLoaded(
          stored(languageCode: null),
          const <ComposerPhoto>[],
        ),
      );
      final ProviderContainer container = _container(drafts);
      final PostComposer notifier = _notifier(container);

      await notifier.considerDraft(now: DateTime.utc(2026, 8, 16));
      notifier.restoreDraft();

      final PostDraft draft = container.read(postComposerProvider());
      expect(draft.spotId, isNull);
      expect(draft.body, '저장된 본문');
    });

    test('복원 이후의 저장이 제안을 되살리지 않는다 (R5-4)', () async {
      // 복원한 초안은 곧바로 다시 저장되므로, 판정이 끝났다는 표시가 없으면
      // "초안 있음" 조건이 계속 참이 된다.
      final FakeDraftStore drafts = FakeDraftStore(
        loadResult: DraftLoaded(stored(), const <ComposerPhoto>[]),
      );
      final PostComposer notifier = _notifier(_container(drafts));

      await notifier.considerDraft(now: DateTime.utc(2026, 8, 16));
      notifier
        ..restoreDraft()
        ..setBody('이어서 쓴 본문')
        ..flush();
      await notifier.considerDraft(now: DateTime.utc(2026, 8, 16));

      expect(notifier.restorePrompt, DraftRestorePrompt.settled);
    });

    test('버리기를 고르면 저장된 초안이 지워지고 빈 상태로 시작한다 (R6-3)', () async {
      final FakeDraftStore drafts = FakeDraftStore(
        loadResult: DraftLoaded(stored(), const <ComposerPhoto>[]),
      );
      final ProviderContainer container = _container(drafts);
      final PostComposer notifier = _notifier(container);

      await notifier.considerDraft(now: DateTime.utc(2026, 8, 16));
      await notifier.discardDraft();

      expect(drafts.clearCount, 1);
      expect(container.read(postComposerProvider()).title, isEmpty);
      expect(notifier.restorePrompt, DraftRestorePrompt.settled);
    });

    test('저장된 초안이 없으면 묻지 않는다', () async {
      final FakeDraftStore drafts = FakeDraftStore();
      final PostComposer notifier = _notifier(_container(drafts));

      await notifier.considerDraft(now: DateTime.utc(2026, 8, 16));

      expect(notifier.restorePrompt, DraftRestorePrompt.settled);
      expect(drafts.clearCount, 0, reason: '없는 초안을 지울 일도 없다');
    });

    test('만료된 초안은 묻지 않고 지운다 (R8-1)', () async {
      final FakeDraftStore drafts = FakeDraftStore(
        loadResult: DraftLoaded(
          stored(savedAt: DateTime.utc(2026, 7, 1)),
          const <ComposerPhoto>[],
        ),
      );
      final PostComposer notifier = _notifier(_container(drafts));

      await notifier.considerDraft(now: DateTime.utc(2026, 8, 16));

      expect(notifier.restorePrompt, DraftRestorePrompt.settled);
      expect(drafts.clearCount, 1);
    });
  });

  group('복원 불가 (R10)', () {
    for (final DraftUnrestorableReason reason
        in DraftUnrestorableReason.values) {
      test('$reason이면 조용히 지우고 빈 상태로 시작한다', () async {
        // 사용자가 할 수 있는 일이 없는 오류라 알리지 않는다(R10-3).
        final FakeDraftStore drafts = FakeDraftStore(
          loadResult: DraftUnrestorable(reason),
        );
        final ProviderContainer container = _container(drafts);
        final PostComposer notifier = _notifier(container);

        await notifier.considerDraft(now: DateTime.utc(2026, 8, 16));

        expect(notifier.restorePrompt, DraftRestorePrompt.settled);
        expect(drafts.clearCount, 1);
        expect(container.read(postComposerProvider()).title, isEmpty);
      });
    }
  });

  group('수정 모드 (R11)', () {
    test('수정 모드는 저장하지 않는다', () {
      final FakeDraftStore drafts = FakeDraftStore();
      final PostComposer notifier = _notifier(
        _container(drafts),
        editing: true,
      );

      notifier
        ..setTitle('고친 제목')
        ..setBody('고친 본문')
        ..flush();

      expect(drafts.saved, isEmpty);
    });

    test('수정 모드는 복원을 묻지 않는다', () async {
      final FakeDraftStore drafts = FakeDraftStore(
        loadResult: DraftLoaded(
          StoredDraft(savedAt: DateTime.utc(2026, 8, 16), title: '초안'),
          const <ComposerPhoto>[],
        ),
      );
      final PostComposer notifier = _notifier(
        _container(drafts),
        editing: true,
      );

      await notifier.considerDraft(now: DateTime.utc(2026, 8, 16));

      expect(notifier.restorePrompt, DraftRestorePrompt.undecided);
    });

    test('수정 모드 진입이 기존 초안을 지우지 않는다 (R11-3)', () async {
      final FakeDraftStore drafts = FakeDraftStore(
        loadResult: DraftLoaded(
          StoredDraft(savedAt: DateTime.utc(2026, 8, 16), title: '초안'),
          const <ComposerPhoto>[],
        ),
      );
      final PostComposer notifier = _notifier(
        _container(drafts),
        editing: true,
      );

      await notifier.considerDraft(now: DateTime.utc(2026, 8, 16));
      notifier
        ..setTitle('고친 제목')
        ..flush();

      expect(drafts.clearCount, 0);
    });
  });

  group('등록 후 (R6)', () {
    test('등록에 성공하면 초안을 지운다 (R6-1)', () async {
      final FakeDraftStore drafts = FakeDraftStore();
      final FakeCommunityRepository repo = FakeCommunityRepository()
        ..createdPostId = 'post-1';
      final PostComposer notifier = _notifier(
        _container(drafts, repo: repo),
      );

      notifier
        ..setCategory(TargetCategory.touristSpot)
        ..setTitle('제목')
        ..setBody('본문')
        ..flush();
      final ComposerResult result = await notifier.submit();

      expect(result, isA<ComposerSucceeded>());
      expect(drafts.clearCount, 1);
    });

    test('등록에 실패하면 초안을 남긴다 (R6-2)', () async {
      // 업로드가 중간에 실패한 상황이 오히려 초안이 가장 필요한 순간이다.
      final FakeDraftStore drafts = FakeDraftStore();
      final FakeCommunityRepository repo = FakeCommunityRepository()
        ..mutationError = Exception('boom');
      final PostComposer notifier = _notifier(
        _container(drafts, repo: repo),
      );

      notifier
        ..setCategory(TargetCategory.touristSpot)
        ..setTitle('제목')
        ..setBody('본문')
        ..flush();
      final ComposerResult result = await notifier.submit();

      expect(result, isA<ComposerFailed>());
      expect(drafts.clearCount, 0);
      expect(drafts.lastSaved?.title, '제목');
    });
  });

  group('저장 실패 (R9)', () {
    test('저장이 실패해도 작성이 막히지 않는다', () {
      final _ThrowingDraftStore drafts = _ThrowingDraftStore();
      final ProviderContainer container = ProviderContainer(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(_prefs),
          communityRepositoryProvider.overrideWithValue(
            FakeCommunityRepository(),
          ),
          draftStoreProvider.overrideWithValue(drafts),
        ],
      );
      addTearDown(container.dispose);
      final PostComposer notifier = container.read(
        postComposerProvider().notifier,
      );

      // 저장 경로가 던져도 상태 갱신은 그대로 이어진다.
      notifier
        ..setTitle('제목')
        ..flush();

      expect(container.read(postComposerProvider()).title, '제목');
    });
  });
}

/// 저장이 늘 실패하는 저장소. 실제 구현은 예외를 삼키지만(R9), 포트가 던지더라도
/// 작성이 막히지 않아야 한다.
class _ThrowingDraftStore implements DraftStore {
  @override
  Future<void> save(StoredDraft draft, List<ComposerPhoto> photos) async =>
      throw Exception('disk full');

  @override
  Future<DraftLoadResult> load() async => const DraftAbsent();

  @override
  Future<void> clear() async => throw Exception('disk full');
}
