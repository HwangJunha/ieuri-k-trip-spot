import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/domain/community/model/community_failure.dart';
import 'package:ieuri_k_trip_spot/domain/community/model/post_draft.dart';
import 'package:ieuri_k_trip_spot/domain/community/model/post_image_upload.dart';
import 'package:ieuri_k_trip_spot/domain/community/model/target_category.dart';
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

PickedPhoto _photo(String name) => PickedPhoto(
  bytes: Uint8List.fromList(<int>[1, 2, 3]),
  contentType: 'image/jpeg',
  name: name,
);

void main() {
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
      expect(repo.lastCreatePost?.spotId, isNull);
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

  group('사진 업로드 (가이드 §4)', () {
    test('발급 → PUT → 확인 순으로 돌고 확정 키를 초안에 넣는다', () async {
      final FakeCommunityRepository repo = FakeCommunityRepository()
        ..uploadUrls = const <PostImageUploadUrl>[
          PostImageUploadUrl(
            uploadUrl: 'https://storage/1',
            objectKey: 'pending/20/1',
            expiresAt: '2026-08-06T12:30:00Z',
          ),
        ]
        ..confirmation = const PostImageConfirmation(
          confirmed: <String>['images/20/1'],
        );
      final ProviderContainer container = _container(repo);

      final PhotoUploadResult result = await container
          .read(postComposerProvider().notifier)
          .uploadPhotos(<PickedPhoto>[_photo('a.jpg')]);

      expect(result.confirmedKeys, <String>['images/20/1']);
      expect(repo.uploadedUrls, <String>['https://storage/1']);
      // 4단계에 넘길 최종 키가 초안에 들어간다.
      expect(container.read(postComposerProvider()).photoKeys, <String>[
        'images/20/1',
      ]);
    });

    // 가이드 §4 — 1단계는 전부 아니면 전무다. 빈 목록은 "전부 거부"다.
    test('발급이 비면 전부 실패로 보고하고 PUT하지 않는다', () async {
      final FakeCommunityRepository repo = FakeCommunityRepository();
      final ProviderContainer container = _container(repo);

      final PhotoUploadResult result = await container
          .read(postComposerProvider().notifier)
          .uploadPhotos(<PickedPhoto>[_photo('a.jpg')]);

      expect(result.failedNames, <String>['a.jpg']);
      expect(repo.uploadedUrls, isEmpty);
    });

    // 가이드 §4의 핵심 — 실패한 장만 다시 올리게 하고 나머지는 살린다.
    test('확인 부분 실패에서도 통과한 키는 초안에 남는다', () async {
      final FakeCommunityRepository repo = FakeCommunityRepository()
        ..uploadUrls = const <PostImageUploadUrl>[
          PostImageUploadUrl(
            uploadUrl: 'https://storage/1',
            objectKey: 'pending/20/1',
            expiresAt: 'x',
          ),
          PostImageUploadUrl(
            uploadUrl: 'https://storage/2',
            objectKey: 'pending/20/2',
            expiresAt: 'x',
          ),
        ]
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

      final PhotoUploadResult result = await container
          .read(postComposerProvider().notifier)
          .uploadPhotos(<PickedPhoto>[_photo('a.jpg'), _photo('b.png')]);

      expect(result.confirmedKeys, <String>['images/20/1']);
      // 실패한 장은 키가 아니라 **이름**으로 알린다 — 사용자는 사진을 본다.
      expect(result.failedNames, <String>['b.png']);
      expect(container.read(postComposerProvider()).photoKeys, <String>[
        'images/20/1',
      ]);
    });

    // 스토리지 PUT 실패는 GraphQL 응답에 안 나온다 — 앱에서만 보인다.
    test('PUT이 실패한 장은 확인 단계로 넘기지 않는다', () async {
      final FakeCommunityRepository repo = FakeCommunityRepository()
        ..uploadUrls = const <PostImageUploadUrl>[
          PostImageUploadUrl(
            uploadUrl: 'https://storage/1',
            objectKey: 'pending/20/1',
            expiresAt: 'x',
          ),
        ]
        ..failingUploadUrls = <String>{'https://storage/1'};
      final ProviderContainer container = _container(repo);

      final PhotoUploadResult result = await container
          .read(postComposerProvider().notifier)
          .uploadPhotos(<PickedPhoto>[_photo('a.jpg')]);

      expect(result.confirmedKeys, isEmpty);
      expect(result.failedNames, <String>['a.jpg']);
    });

    test('사진을 빼면 오브젝트도 지운다 (고아 오브젝트를 남기지 않는다)', () async {
      final FakeCommunityRepository repo = FakeCommunityRepository()
        ..uploadUrls = const <PostImageUploadUrl>[
          PostImageUploadUrl(
            uploadUrl: 'https://storage/1',
            objectKey: 'pending/20/1',
            expiresAt: 'x',
          ),
        ]
        ..confirmation = const PostImageConfirmation(
          confirmed: <String>['images/20/1'],
        );
      final ProviderContainer container = _container(repo);
      final PostComposer notifier = container.read(
        postComposerProvider().notifier,
      );
      await notifier.uploadPhotos(<PickedPhoto>[_photo('a.jpg')]);

      await notifier.removePhoto('images/20/1');

      expect(container.read(postComposerProvider()).photoKeys, isEmpty);
      expect(repo.lastDeletedImageKey, 'images/20/1');
    });
  });
}
