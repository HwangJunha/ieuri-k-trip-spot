import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/common/model/composer_photo.dart';
import 'package:ieuri_k_trip_spot/domain/feed/model/feed_draft.dart';
import 'package:ieuri_k_trip_spot/domain/feed/provider/feed_composer_providers.dart';
import 'package:ieuri_k_trip_spot/domain/feed/provider/feed_providers.dart';

import '../feed_test_doubles.dart';

ProviderContainer _container(FakeFeedRepository repo) {
  final ProviderContainer container = ProviderContainer(
    overrides: [feedRepositoryProvider.overrideWithValue(repo)],
  );
  addTearDown(container.dispose);
  return container;
}

LocalPhoto _photo(String name) => LocalPhoto(
  id: name,
  bytes: Uint8List.fromList(<int>[1, 2, 3]),
  contentType: 'image/jpeg',
  name: name,
);

/// 제출 가능한 최소 초안을 채운다.
void _fill(FeedComposer notifier) => notifier
  ..setBody('오늘 다녀왔습니다')
  ..setSpot(spot('11094'))
  ..addPhotos(<LocalPhoto>[_photo('a.jpg')]);

void main() {
  group('폼 편집 (R1·R2)', () {
    test('spot과 사진이 채워지면 제출할 수 있다', () {
      final ProviderContainer container = _container(FakeFeedRepository());
      _fill(container.read(feedComposerProvider.notifier));

      expect(container.read(feedComposerProvider).canSubmit, isTrue);
    });

    test('사진은 상한을 넘겨 담기지 않는다 (AC2-4)', () {
      final ProviderContainer container = _container(FakeFeedRepository());
      final FeedComposer notifier = container.read(feedComposerProvider.notifier)
        ..setBody('본문')
        ..setSpot(spot('1'));

      notifier.addPhotos(<LocalPhoto>[
        for (int i = 0; i < FeedDraft.maxPhotos + 3; i++) _photo('p$i.jpg'),
      ]);

      expect(
        container.read(feedComposerProvider).photos.length,
        FeedDraft.maxPhotos,
      );
    });

    test('사진을 지우면 제출할 수 없게 된다', () {
      final ProviderContainer container = _container(FakeFeedRepository());
      final FeedComposer notifier = container.read(feedComposerProvider.notifier);
      _fill(notifier);

      notifier.removePhoto('a.jpg');

      expect(container.read(feedComposerProvider).canSubmit, isFalse);
    });
  });

  group('제출 (R3)', () {
    test('확정된 키만 실려 나간다', () async {
      final FakeFeedRepository repo = FakeFeedRepository();
      final ProviderContainer container = _container(repo);
      _fill(container.read(feedComposerProvider.notifier));

      final FeedComposerResult result = await container
          .read(feedComposerProvider.notifier)
          .submit();

      expect(result, isA<FeedComposerSucceeded>());
      // pending/0 → images/0 으로 확정된 키가 실렸다.
      expect(repo.createdPhotoKeys, <String>['images/0']);
    });

    test('일부 사진이 실패해도 나머지로 등록하고 실패한 장을 알린다', () async {
      // 5장 중 3장째 실패를 "업로드 실패"로 뭉뚱그리지 않는다(설계 §4).
      final FakeFeedRepository repo = FakeFeedRepository()
        ..failingUploads.add('pending/1');
      final ProviderContainer container = _container(repo);
      container.read(feedComposerProvider.notifier)
        ..setBody('본문')
        ..setSpot(spot('1'))
        ..addPhotos(<LocalPhoto>[_photo('첫장.jpg'), _photo('둘째장.jpg')]);

      final FeedComposerResult result = await container
          .read(feedComposerProvider.notifier)
          .submit();

      expect(result, isA<FeedComposerSucceeded>());
      final FeedComposerSucceeded succeeded = result as FeedComposerSucceeded;
      expect(succeeded.failedPhotoNames, <String>['둘째장.jpg']);
      expect(repo.createdPhotoKeys, <String>['images/0']);
    });

    test('사진이 한 장도 올라가지 않으면 제출하지 않는다 (R2)', () async {
      final FakeFeedRepository repo = FakeFeedRepository()
        ..failingUploads.add('pending/0');
      final ProviderContainer container = _container(repo);
      _fill(container.read(feedComposerProvider.notifier));

      final FeedComposerResult result = await container
          .read(feedComposerProvider.notifier)
          .submit();

      expect(result, isA<FeedComposerPhotosFailed>());
      expect(
        (result as FeedComposerPhotosFailed).failedPhotoNames,
        <String>['a.jpg'],
      );
      // 사진 없는 피드는 만들지 않는다.
      expect(repo.createdPhotoKeys, isEmpty);
    });

    test('확인에서 떨어진 장도 이름으로 알린다', () async {
      final FakeFeedRepository repo = FakeFeedRepository()
        ..failingConfirms.add('pending/0');
      final ProviderContainer container = _container(repo);
      _fill(container.read(feedComposerProvider.notifier));

      final FeedComposerResult result = await container
          .read(feedComposerProvider.notifier)
          .submit();

      expect(result, isA<FeedComposerPhotosFailed>());
      expect(
        (result as FeedComposerPhotosFailed).failedPhotoNames,
        <String>['a.jpg'],
      );
    });

    test('서버가 거부하면 사유 코드를 돌려준다', () async {
      final FakeFeedRepository repo = FakeFeedRepository()
        ..createErrorCode = 'SPOT_NOT_FOUND';
      final ProviderContainer container = _container(repo);
      _fill(container.read(feedComposerProvider.notifier));

      final FeedComposerResult result = await container
          .read(feedComposerProvider.notifier)
          .submit();

      expect(result, isA<FeedComposerRejected>());
      expect((result as FeedComposerRejected).code, 'SPOT_NOT_FOUND');
    });

    test('제출할 수 없는 상태에서는 요청이 나가지 않는다', () async {
      final FakeFeedRepository repo = FakeFeedRepository();
      final ProviderContainer container = _container(repo);
      // spot도 사진도 없다.
      container.read(feedComposerProvider.notifier).setBody('본문');

      final FeedComposerResult result = await container
          .read(feedComposerProvider.notifier)
          .submit();

      expect(result, isA<FeedComposerFailed>());
      expect(repo.putObjectKeys, isEmpty);
    });

    test('제출이 끝나면 제출 중 표시가 풀린다', () async {
      final ProviderContainer container = _container(FakeFeedRepository());
      _fill(container.read(feedComposerProvider.notifier));

      await container.read(feedComposerProvider.notifier).submit();

      expect(container.read(feedComposerProvider).submitting, isFalse);
    });
  });
}
