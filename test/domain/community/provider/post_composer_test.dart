import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/domain/community/model/community_failure.dart';
import 'package:ieuri_k_trip_spot/common/model/composer_photo.dart';
import 'package:ieuri_k_trip_spot/domain/community/model/post_draft.dart';
import 'package:ieuri_k_trip_spot/common/model/post_image_upload.dart';
import 'package:ieuri_k_trip_spot/common/model/target_category.dart';
import 'package:ieuri_k_trip_spot/domain/community/provider/community_providers.dart';
import 'package:ieuri_k_trip_spot/common/storage/draft_store_impl.dart';
import 'package:ieuri_k_trip_spot/domain/community/provider/post_composer_providers.dart';

import 'package:ieuri_k_trip_spot/common/storage/app_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../common/storage/fake_draft_store.dart';
import '../community_test_doubles.dart';

/// 초안 저장이 활성 언어를 기록하므로(SPEC-0029 AC-26.2) `LocaleController`가
/// 살아야 하고, 그것이 `SharedPreferences`를 읽는다. `main`이 채워 둔다.
late SharedPreferences _prefs;

/// 초안 저장소는 **항상 override한다**(SPEC-0022 §8) — 실제 구현은
/// `shared_preferences`와 파일 시스템을 잡는다.
ProviderContainer _container(
  FakeCommunityRepository repo, {
  FakeDraftStore? drafts,
}) {
  final ProviderContainer container = ProviderContainer(
    overrides: [
      sharedPreferencesProvider.overrideWithValue(_prefs),
      communityRepositoryProvider.overrideWithValue(repo),
      draftStoreProvider.overrideWithValue(drafts ?? FakeDraftStore()),
    ],
  );
  addTearDown(container.dispose);
  return container;
}

/// 방금 고른 사진 한 장. 이름이 곧 식별자다 — 한 테스트에서 같은 이름을 두 번 쓰지
/// 않는다.
LocalPhoto _photo(String name) => LocalPhoto(
  id: name,
  bytes: Uint8List.fromList(<int>[1, 2, 3]),
  contentType: 'image/jpeg',
  name: name,
);

/// 등록이 가능한 최소 초안을 채운다.
void _fill(PostComposer notifier) => notifier
  ..setCategory(TargetCategory.touristSpot)
  ..setTitle('제목')
  ..setBody('본문');

PostImageUploadUrl _url(int n) => PostImageUploadUrl(
  uploadUrl: 'https://storage/$n',
  objectKey: 'pending/20/$n',
  expiresAt: 'x',
);

void main() {
  // 초안 저장이 활성 언어를 함께 남기므로 `SharedPreferences`가 필요하다.
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    _prefs = await SharedPreferences.getInstance();
  });

  group('초안 편집', () {
    test('장소 상세에서 진입하면 장소와 카테고리 제안이 채워져 있다', () {
      final ProviderContainer container = _container(FakeCommunityRepository());

      final PostDraft draft = container.read(
        postComposerProvider(
          initialSpotId: '11094',
          initialSpotTitle: '경복궁',
          initialCategory: TargetCategory.touristSpot,
        ),
      );

      expect(draft.spotId, '11094');
      expect(draft.spotTitle, '경복궁');
      // 서버가 PostSpot.category를 그 용도로 내려준다(가이드 §5).
      expect(draft.category, TargetCategory.touristSpot);
    });

    // 카테고리는 필수라 해제되면 등록이 막히는데 사용자는 왜인지 모른다.
    test('같은 카테고리를 다시 골라도 해제되지 않는다', () {
      final ProviderContainer container = _container(FakeCommunityRepository());
      final PostComposer notifier = container.read(
        postComposerProvider().notifier,
      );

      notifier.setCategory(TargetCategory.restaurant);
      notifier.setCategory(TargetCategory.restaurant);

      expect(
        container.read(postComposerProvider()).category,
        TargetCategory.restaurant,
      );
    });

    test('장소를 해제하면 장소 없는 글이 된다', () {
      final ProviderContainer container = _container(FakeCommunityRepository());
      final PostComposer notifier = container.read(
        postComposerProvider().notifier,
      );
      notifier.setSpot(id: '11094', title: '경복궁');

      notifier.clearSpot();

      expect(container.read(postComposerProvider()).spotId, isNull);
    });

    test('공백이 든 태그는 더해지지 않는다', () {
      final ProviderContainer container = _container(FakeCommunityRepository());

      final bool added = container
          .read(postComposerProvider().notifier)
          .addTag('맛집 추천');

      expect(added, isFalse);
      expect(container.read(postComposerProvider()).tags, isEmpty);
    });

    test('대소문자만 다른 태그는 중복으로 본다', () {
      final ProviderContainer container = _container(FakeCommunityRepository());
      final PostComposer notifier = container.read(
        postComposerProvider().notifier,
      );
      notifier.addTag('Seoul');

      expect(notifier.addTag('seoul'), isFalse);
      expect(container.read(postComposerProvider()).tags, <String>['Seoul']);
    });

    test('태그는 5개를 넘길 수 없다', () {
      final ProviderContainer container = _container(FakeCommunityRepository());
      final PostComposer notifier = container.read(
        postComposerProvider().notifier,
      );
      for (final String tag in <String>['a', 'b', 'c', 'd', 'e']) {
        notifier.addTag(tag);
      }

      expect(notifier.addTag('f'), isFalse);
      expect(container.read(postComposerProvider()).tags, hasLength(5));
    });
  });

  group('submit', () {
    test('카테고리·제목·본문을 서버에 넘긴다', () async {
      final FakeCommunityRepository repo = FakeCommunityRepository();
      final ProviderContainer container = _container(repo);
      final PostComposer notifier = container.read(
        postComposerProvider().notifier,
      );
      notifier
        ..setCategory(TargetCategory.restaurant)
        ..setTitle('  경복궁 야간개장  ')
        ..setBody('  한복 입고 가면 무료  ')
        ..addTag('야간개장');

      final ComposerResult result = await notifier.submit();

      expect(result, isA<ComposerSucceeded>());
      expect(repo.lastCreatePost?.category, TargetCategory.restaurant);
      expect(repo.lastCreatePost?.title, '경복궁 야간개장');
      expect(repo.lastCreatePost?.body, '한복 입고 가면 무료');
      expect(repo.lastCreatePost?.tags, <String>['야간개장']);
      // 가이드 §5 — 장소는 선택이라 없어도 등록된다.
      expect(repo.lastCreatePost?.catalogId, isNull);
    });

    test('조건이 갖춰지지 않으면 서버로 나가지 않는다', () async {
      final FakeCommunityRepository repo = FakeCommunityRepository();
      final ProviderContainer container = _container(repo);

      final ComposerResult result = await container
          .read(postComposerProvider().notifier)
          .submit();

      expect(result, isA<ComposerFailed>());
      expect(repo.lastCreatePost, isNull);
    });

    test('userErrors는 코드를 담은 거부로 온다', () async {
      final FakeCommunityRepository repo = FakeCommunityRepository()
        ..mutationError = CommunityFailure.userError(
          'POST_TITLE_LENGTH_INVALID',
        );
      final ProviderContainer container = _container(repo);
      final PostComposer notifier = container.read(
        postComposerProvider().notifier,
      );
      notifier
        ..setCategory(TargetCategory.touristSpot)
        ..setTitle('제목')
        ..setBody('본문');

      final ComposerResult result = await notifier.submit();

      expect(
        result,
        isA<ComposerRejected>().having(
          (ComposerRejected r) => r.code,
          'code',
          'POST_TITLE_LENGTH_INVALID',
        ),
      );
    });

    test('미인증은 전용 결과로 구분된다', () async {
      final FakeCommunityRepository repo = FakeCommunityRepository()
        ..mutationError = CommunityFailure.unauthenticated;
      final ProviderContainer container = _container(repo);
      final PostComposer notifier = container.read(
        postComposerProvider().notifier,
      );
      notifier
        ..setCategory(TargetCategory.touristSpot)
        ..setTitle('제목')
        ..setBody('본문');

      expect(await notifier.submit(), isA<ComposerUnauthenticated>());
    });
  });

  // 이 기능의 요지 — **고르는 것만으로는 아무것도 올라가지 않는다.** 예전에는 고른
  // 즉시 1~3단계를 돌려서, 글을 쓰지 않고 나간 사용자의 사진이 스토리지에 고아로
  // 남았다(실제 저장 비용).
  group('사진 선택 — 네트워크를 타지 않는다', () {
    test('사진을 골라도 업로드 호출이 하나도 나가지 않는다', () {
      final FakeCommunityRepository repo = FakeCommunityRepository();
      final ProviderContainer container = _container(repo);

      container.read(postComposerProvider().notifier).addPhotos(<LocalPhoto>[
        _photo('a.jpg'),
        _photo('b.png'),
      ]);

      expect(repo.uploadUrlCalls, isEmpty);
      expect(repo.uploadedUrls, isEmpty);
      expect(repo.confirmCalls, isEmpty);
      // 그래도 화면에 보여야 한다 — 무엇을 골랐는지 알 수 없으면 뺄 수도 없다.
      expect(container.read(postComposerProvider()).photos, hasLength(2));
    });

    test('올리기 전에 뺀 사진은 아무 호출도 남기지 않는다', () {
      final FakeCommunityRepository repo = FakeCommunityRepository();
      final ProviderContainer container = _container(repo);
      final PostComposer notifier = container.read(
        postComposerProvider().notifier,
      );
      notifier.addPhotos(<LocalPhoto>[_photo('a.jpg')]);

      notifier.removePhoto('a.jpg');

      expect(container.read(postComposerProvider()).photos, isEmpty);
      expect(repo.uploadUrlCalls, isEmpty);
      // 올린 적이 없으니 지울 오브젝트도 없다.
      expect(repo.lastDeletedImageKey, isNull);
    });

    // 상한은 글에 붙는 최종 개수에 걸린다(가이드 §4) — 원격·로컬을 구분하지 않는다.
    test('이미 붙은 원격 사진까지 합쳐 5장을 넘기지 않는다', () {
      final ProviderContainer container = _container(FakeCommunityRepository());
      final PostComposer notifier = container.read(
        postComposerProvider(editing: true).notifier,
      );
      notifier.seedFromPost(
        title: '제목',
        body: '본문',
        photoKeys: <String>['images/20/1', 'images/20/2', 'images/20/3'],
      );

      notifier.addPhotos(<LocalPhoto>[
        _photo('a.jpg'),
        _photo('b.jpg'),
        _photo('c.jpg'),
      ]);

      expect(
        container.read(postComposerProvider(editing: true)).photos,
        hasLength(5),
      );
    });
  });

  group('등록 시 업로드 (가이드 §4)', () {
    test('등록을 누르면 발급 → PUT → 확인이 돌고 확정 키가 createPost에 실린다', () async {
      final FakeCommunityRepository repo = FakeCommunityRepository()
        ..uploadUrls = <PostImageUploadUrl>[_url(1)]
        ..confirmation = const PostImageConfirmation(
          confirmed: <String>['images/20/1'],
        );
      final ProviderContainer container = _container(repo);
      final PostComposer notifier = container.read(
        postComposerProvider().notifier,
      );
      _fill(notifier);
      notifier.addPhotos(<LocalPhoto>[_photo('a.jpg')]);
      // 고른 시점까지는 여전히 아무것도 나가지 않았다.
      expect(repo.uploadUrlCalls, isEmpty);

      final ComposerResult result = await notifier.submit();

      expect(result, isA<ComposerSucceeded>());
      expect(repo.uploadedUrls, <String>['https://storage/1']);
      expect(repo.confirmCalls, <List<String>>[
        <String>['pending/20/1'],
      ]);
      expect(repo.lastCreatePost?.photoKeys, <String>['images/20/1']);
    });

    // 사용자가 정한 정책 — **사진 때문에 글을 버리지 않는다.**
    test('한 장이 실패해도 나머지 키로 글이 등록되고 실패가 보고된다', () async {
      final FakeCommunityRepository repo = FakeCommunityRepository()
        ..uploadUrls = <PostImageUploadUrl>[_url(1), _url(2)]
        ..failingUploadUrls = <String>{'https://storage/2'}
        ..confirmation = const PostImageConfirmation(
          confirmed: <String>['images/20/1'],
        );
      final ProviderContainer container = _container(repo);
      final PostComposer notifier = container.read(
        postComposerProvider().notifier,
      );
      _fill(notifier);
      notifier.addPhotos(<LocalPhoto>[_photo('a.jpg'), _photo('b.png')]);

      final ComposerResult result = await notifier.submit();

      expect(
        result,
        isA<ComposerSucceeded>().having(
          (ComposerSucceeded s) => s.failedPhotoNames,
          'failedPhotoNames',
          <String>['b.png'],
        ),
      );
      expect(repo.lastCreatePost?.photoKeys, <String>['images/20/1']);
    });

    // 확인 단계는 **장별로 갈린다** — `failed`가 있어도 `confirmed`는 유효하다.
    test('확인이 부분 실패해도 통과한 키로 등록된다', () async {
      final FakeCommunityRepository repo = FakeCommunityRepository()
        ..uploadUrls = <PostImageUploadUrl>[_url(1), _url(2)]
        ..confirmation = const PostImageConfirmation(
          confirmed: <String>['images/20/1'],
          failed: <PostImageUploadFailure>[
            PostImageUploadFailure(
              objectKey: 'pending/20/2',
              code: 'UNSUPPORTED_CONTENT_TYPE',
            ),
          ],
        );
      final ProviderContainer container = _container(repo);
      final PostComposer notifier = container.read(
        postComposerProvider().notifier,
      );
      _fill(notifier);
      notifier.addPhotos(<LocalPhoto>[_photo('a.jpg'), _photo('b.png')]);

      final ComposerResult result = await notifier.submit();

      expect((result as ComposerSucceeded).failedPhotoNames, <String>['b.png']);
      expect(repo.lastCreatePost?.photoKeys, <String>['images/20/1']);
    });

    // 1단계는 전부 아니면 전무다 — 빈 목록은 "전부 거부"다(가이드 §4).
    // 그래도 **사진 0장으로 글은 올라간다.** 사진은 선택 항목이다(가이드 §5).
    test('전부 실패해도 사진 없이 글은 등록된다', () async {
      final FakeCommunityRepository repo = FakeCommunityRepository();
      final ProviderContainer container = _container(repo);
      final PostComposer notifier = container.read(
        postComposerProvider().notifier,
      );
      _fill(notifier);
      notifier.addPhotos(<LocalPhoto>[_photo('a.jpg'), _photo('b.png')]);

      final ComposerResult result = await notifier.submit();

      expect(result, isA<ComposerSucceeded>());
      expect((result as ComposerSucceeded).failedPhotoNames, <String>[
        'a.jpg',
        'b.png',
      ]);
      expect(repo.lastCreatePost?.photoKeys, isEmpty);
      expect(repo.uploadedUrls, isEmpty);
    });

    // 발급 뮤테이션 자체가 던져도 글은 올라간다 — 사진이 글을 막지 않는다.
    test('발급이 오류를 던져도 글은 등록된다', () async {
      final FakeCommunityRepository repo = FakeCommunityRepository()
        ..uploadUrlError = CommunityFailure.network;
      final ProviderContainer container = _container(repo);
      final PostComposer notifier = container.read(
        postComposerProvider().notifier,
      );
      _fill(notifier);
      notifier.addPhotos(<LocalPhoto>[_photo('a.jpg')]);

      final ComposerResult result = await notifier.submit();

      expect((result as ComposerSucceeded).failedPhotoNames, <String>['a.jpg']);
      expect(repo.lastCreatePost?.photoKeys, isEmpty);
    });

    // 서버가 글을 거부했을 때 다시 누르면, 이미 올라간 장을 또 올리면 안 된다 —
    // 그것이 바로 이 변경이 없애려던 중복 업로드다.
    test('등록이 거부된 뒤 다시 눌러도 이미 올라간 장은 다시 올리지 않는다', () async {
      final FakeCommunityRepository repo = FakeCommunityRepository()
        ..uploadUrls = <PostImageUploadUrl>[_url(1)]
        ..confirmation = const PostImageConfirmation(
          confirmed: <String>['images/20/1'],
        )
        ..mutationError = CommunityFailure.userError('POST_TITLE_REQUIRED');
      final ProviderContainer container = _container(repo);
      final PostComposer notifier = container.read(
        postComposerProvider().notifier,
      );
      _fill(notifier);
      notifier.addPhotos(<LocalPhoto>[_photo('a.jpg')]);

      await notifier.submit();
      await notifier.submit();

      expect(repo.uploadedUrls, <String>['https://storage/1']);
      expect(repo.lastCreatePost?.photoKeys, <String>['images/20/1']);
    });

    test('사진이 없으면 업로드 단계를 아예 건너뛴다', () async {
      final FakeCommunityRepository repo = FakeCommunityRepository();
      final ProviderContainer container = _container(repo);
      final PostComposer notifier = container.read(
        postComposerProvider().notifier,
      );
      _fill(notifier);

      await notifier.submit();

      expect(repo.uploadUrlCalls, isEmpty);
      expect(repo.lastCreatePost?.photoKeys, isEmpty);
    });
  });

  group('수정 모드', () {
    // 이 화면의 본래 버그 — 사진 키가 초안에 들어오지 않아 수정 화면이 사진 없는
    // 새 글처럼 열렸다.
    test('서버가 준 제목·본문·사진이 초안에 들어간다', () {
      final ProviderContainer container = _container(FakeCommunityRepository());

      container
          .read(postComposerProvider(editing: true).notifier)
          .seedFromPost(
            title: '원래 제목',
            body: '원래 본문',
            photoKeys: <String>['images/20/1'],
          );

      final PostDraft draft = container.read(
        postComposerProvider(editing: true),
      );
      expect(draft.title, '원래 제목');
      expect(draft.body, '원래 본문');
      expect(draft.photos, <ComposerPhoto>[const RemotePhoto('images/20/1')]);
      expect(draft.remoteKeys, <String>['images/20/1']);
    });

    // 서버가 카테고리·장소·태그도 받기 시작했다 — 채우지 않으면 저장할 때 사용자가
    // 뜻하지 않은 값이 나간다.
    test('서버가 준 카테고리·태그·장소도 초안에 들어간다', () {
      final ProviderContainer container = _container(FakeCommunityRepository());

      container
          .read(postComposerProvider(editing: true).notifier)
          .seedFromPost(
            title: '원래 제목',
            body: '원래 본문',
            photoKeys: const <String>[],
            category: TargetCategory.restaurant,
            tags: <String>['야간개장'],
            spotId: '11094',
            spotTitle: '경복궁',
          );

      final PostDraft draft = container.read(
        postComposerProvider(editing: true),
      );
      expect(draft.category, TargetCategory.restaurant);
      expect(draft.tags, <String>['야간개장']);
      expect(draft.spotId, '11094');
      expect(draft.spotTitle, '경복궁');
    });

    // `changeSpot`은 `spotId: null` 하나로 구분되지 않는 "그대로"와 "떼기"를 가른다
    // (스키마에만 있고 문서에 없는 인자다).
    group('spotChanged', () {
      test('씨앗 그대로면 false다', () {
        final ProviderContainer container = _container(
          FakeCommunityRepository(),
        );
        final PostComposer notifier = container.read(
          postComposerProvider(editing: true).notifier,
        );
        notifier.seedFromPost(
          title: 't',
          body: 'b',
          photoKeys: const <String>[],
          spotId: '11094',
          spotTitle: '경복궁',
        );

        expect(notifier.spotChanged, isFalse);
      });

      test('다른 장소를 고르면 true다', () {
        final ProviderContainer container = _container(
          FakeCommunityRepository(),
        );
        final PostComposer notifier = container.read(
          postComposerProvider(editing: true).notifier,
        );
        notifier.seedFromPost(
          title: 't',
          body: 'b',
          photoKeys: const <String>[],
          spotId: '11094',
          spotTitle: '경복궁',
        );

        notifier.setSpot(id: '11915', title: '서울갤러리');

        expect(notifier.spotChanged, isTrue);
      });

      test('장소를 떼면 true다', () {
        final ProviderContainer container = _container(
          FakeCommunityRepository(),
        );
        final PostComposer notifier = container.read(
          postComposerProvider(editing: true).notifier,
        );
        notifier.seedFromPost(
          title: 't',
          body: 'b',
          photoKeys: const <String>[],
          spotId: '11094',
          spotTitle: '경복궁',
        );

        notifier.clearSpot();

        expect(notifier.spotChanged, isTrue);
      });

      // 장소 없던 글을 그대로 두는 것은 "떼기"가 아니다 — 둘을 섞으면 플래그가
      // 있을 이유가 없어진다.
      test('장소 없던 글을 그대로 두면 false다', () {
        final ProviderContainer container = _container(
          FakeCommunityRepository(),
        );
        final PostComposer notifier = container.read(
          postComposerProvider(editing: true).notifier,
        );
        notifier.seedFromPost(
          title: 't',
          body: 'b',
          photoKeys: const <String>[],
        );

        expect(notifier.spotChanged, isFalse);
      });

      // 새 글에는 바꿀 원본이 없다 — `createPost`는 이 플래그를 쓰지 않는다.
      test('씨앗이 없는 새 글은 장소를 골라도 false다', () {
        final ProviderContainer container = _container(
          FakeCommunityRepository(),
        );
        final PostComposer notifier = container.read(
          postComposerProvider().notifier,
        );

        notifier.setSpot(id: '11915', title: '서울갤러리');

        expect(notifier.spotChanged, isFalse);
      });
    });

    // 수정 중인 키는 **아직 서버의 글에 붙어 있다** — 여기서 지우면 저장을 취소하고
    // 나갔을 때 원래 글의 사진이 깨진다. 떨어져 나간 오브젝트 정리는 서버 lifecycle의
    // 몫이다(가이드 §4).
    test('수정 중에는 사진을 빼도 오브젝트를 지우지 않는다', () {
      final FakeCommunityRepository repo = FakeCommunityRepository();
      final ProviderContainer container = _container(repo);
      final PostComposer notifier = container.read(
        postComposerProvider(editing: true).notifier,
      );
      notifier.seedFromPost(
        title: '제목',
        body: '본문',
        photoKeys: <String>['images/20/1', 'images/20/2'],
      );

      notifier.removePhoto('images/20/1');

      expect(
        container.read(postComposerProvider(editing: true)).remoteKeys,
        <String>['images/20/2'],
      );
      expect(repo.lastDeletedImageKey, isNull);
    });

    // 두 종류가 섞여도 **순서가 곧 표시 순서다**(가이드 §4).
    test('기존 원격 키와 새로 고른 로컬 장이 순서대로 함께 확정된다', () async {
      final FakeCommunityRepository repo = FakeCommunityRepository()
        ..uploadUrls = <PostImageUploadUrl>[_url(9)]
        ..confirmation = const PostImageConfirmation(
          confirmed: <String>['images/20/9'],
        );
      final ProviderContainer container = _container(repo);
      final PostComposer notifier = container.read(
        postComposerProvider(editing: true).notifier,
      );
      notifier.seedFromPost(
        title: '제목',
        body: '본문',
        photoKeys: <String>['images/20/1'],
      );
      notifier.addPhotos(<LocalPhoto>[_photo('new.jpg')]);

      final PhotoUploadResult result = await notifier.uploadPending();

      expect(result.confirmedKeys, <String>['images/20/9']);
      // 기존 키가 앞, 새 키가 뒤 — 고른 순서 그대로다.
      expect(
        container.read(postComposerProvider(editing: true)).remoteKeys,
        <String>['images/20/1', 'images/20/9'],
      );
    });
  });
}
