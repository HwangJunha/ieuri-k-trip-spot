import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/common/model/composer_photo.dart';
import 'package:ieuri_k_trip_spot/domain/feed/model/feed_draft.dart';

import '../feed_test_doubles.dart';

LocalPhoto _photo(String name) => LocalPhoto(
  id: name,
  bytes: Uint8List.fromList(<int>[1, 2, 3]),
  contentType: 'image/jpeg',
  name: name,
);

void main() {
  group('제출 가능 판정 (R1·R2)', () {
    test('spot과 사진과 본문이 모두 있으면 제출할 수 있다', () {
      final FeedDraft draft = FeedDraft(
        body: '오늘 다녀왔습니다',
        spot: spot('1'),
        photos: <ComposerPhoto>[_photo('a')],
      );

      expect(draft.canSubmit, isTrue);
    });

    test('spot이 없으면 제출할 수 없다', () {
      final FeedDraft draft = FeedDraft(
        body: '본문',
        photos: <ComposerPhoto>[_photo('a')],
      );

      expect(draft.canSubmit, isFalse);
    });

    test('사진이 없으면 제출할 수 없다', () {
      final FeedDraft draft = FeedDraft(body: '본문', spot: spot('1'));

      expect(draft.canSubmit, isFalse);
    });

    test('본문이 공백뿐이면 제출할 수 없다', () {
      final FeedDraft draft = FeedDraft(
        body: '   ',
        spot: spot('1'),
        photos: <ComposerPhoto>[_photo('a')],
      );

      expect(draft.canSubmit, isFalse);
    });

    test('본문이 상한을 넘으면 제출할 수 없다', () {
      final FeedDraft draft = FeedDraft(
        body: 'x' * (FeedDraft.maxBodyLength + 1),
        spot: spot('1'),
        photos: <ComposerPhoto>[_photo('a')],
      );

      expect(draft.canSubmit, isFalse);
    });

    test('사진이 상한을 넘으면 제출할 수 없다', () {
      final FeedDraft draft = FeedDraft(
        body: '본문',
        spot: spot('1'),
        photos: <ComposerPhoto>[
          for (int i = 0; i <= FeedDraft.maxPhotos; i++) _photo('p$i'),
        ],
      );

      expect(draft.canSubmit, isFalse);
    });

    test('제출 중이면 다시 제출할 수 없다', () {
      final FeedDraft draft = FeedDraft(
        body: '본문',
        spot: spot('1'),
        photos: <ComposerPhoto>[_photo('a')],
        submitting: true,
      );

      expect(draft.canSubmit, isFalse);
    });
  });

  test('사진 1장은 하한이라 제출할 수 있다 (AC2-1)', () {
    final FeedDraft draft = FeedDraft(
      body: '본문',
      spot: spot('1'),
      photos: <ComposerPhoto>[_photo('a')],
    );

    expect(draft.canSubmit, isTrue);
  });

  test('사진 5장은 상한이라 제출할 수 있다 (AC2-2)', () {
    final FeedDraft draft = FeedDraft(
      body: '본문',
      spot: spot('1'),
      photos: <ComposerPhoto>[
        for (int i = 0; i < FeedDraft.maxPhotos; i++) _photo('p$i'),
      ],
    );

    expect(draft.canSubmit, isTrue);
    expect(draft.remainingPhotoSlots, 0);
  });

  test('spot을 지우면 다시 제출할 수 없다', () {
    final FeedDraft draft = FeedDraft(
      body: '본문',
      spot: spot('1'),
      photos: <ComposerPhoto>[_photo('a')],
    );

    expect(draft.copyWith(clearSpot: true).canSubmit, isFalse);
  });
}
