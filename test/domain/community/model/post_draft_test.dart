import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/common/model/composer_photo.dart';
import 'package:ieuri_k_trip_spot/domain/community/model/post_draft.dart';
import 'package:ieuri_k_trip_spot/common/model/target_category.dart';

/// 등록 가능 판정과 **코드포인트 길이 세기**가 이 모델의 전부다(가이드 §5·§8).
void main() {
  const PostDraft valid = PostDraft(
    category: TargetCategory.touristSpot,
    title: 'Night opening',
    body: 'Wear a hanbok.',
  );

  group('canSubmit', () {
    test('카테고리·제목·본문이 갖춰지면 등록할 수 있다', () {
      expect(valid.canSubmit, isTrue);
    });

    // 가이드 §5 — 장소는 선택이다. 없어도 등록된다.
    test('장소가 없어도 등록할 수 있다', () {
      expect(valid.spotId, isNull);
      expect(valid.canSubmit, isTrue);
    });

    test('카테고리가 없으면 등록할 수 없다', () {
      expect(const PostDraft(title: 'a', body: 'b').canSubmit, isFalse);
    });

    test('제목이 공백뿐이면 등록할 수 없다', () {
      expect(valid.copyWith(title: '   ').canSubmit, isFalse);
    });

    test('본문이 공백뿐이면 등록할 수 없다', () {
      expect(valid.copyWith(body: '   ').canSubmit, isFalse);
    });

    test('제목이 50자를 넘으면 등록할 수 없다', () {
      expect(valid.copyWith(title: 'a' * 51).canSubmit, isFalse);
    });

    test('본문이 500자를 넘으면 등록할 수 없다', () {
      expect(valid.copyWith(body: 'a' * 501).canSubmit, isFalse);
    });
  });

  group('길이 세기 — 코드포인트', () {
    // 가이드 §8 — 서버는 코드포인트로 센다. String.length(UTF-16)로 세면
    // 이모지가 든 본문에서 "499자인데 거부됨"이 난다.
    test('서로게이트 쌍 이모지는 코드포인트 1로 센다', () {
      expect('🥲'.length, 2); // UTF-16 코드유닛으로는 2다
      expect(valid.copyWith(body: '🥲').bodyRunes, 1);
    });

    test('국기 이모지는 코드포인트 2로 센다 (서버와 같다)', () {
      expect(valid.copyWith(body: '🇰🇷').bodyRunes, 2);
    });

    test('ZWJ로 결합된 가족 이모지는 코드포인트 7로 센다', () {
      expect(valid.copyWith(body: '👨‍👩‍👧‍👦').bodyRunes, 7);
    });

    test('제목도 코드포인트로 센다', () {
      expect(valid.copyWith(title: '🥲🥲').titleRunes, 2);
    });

    test('남은 글자 수는 초과분을 음수로 드러낸다', () {
      // 자르지 않고 드러내는 것이 규약이다 — 붙여넣기한 유저가 무엇이 사라졌는지
      // 모르면 안 된다.
      expect(valid.copyWith(body: 'a' * 503).remainingBodyRunes, -3);
      expect(valid.copyWith(body: 'a' * 503).isBodyTooLong, isTrue);
    });
  });

  group('태그', () {
    test('공백이 든 태그는 거부된다 (INVALID_TAG를 미리 막는다)', () {
      expect(PostDraft.isValidTag('맛집 추천'), isFalse);
    });

    test('공백 없는 태그는 유효하다', () {
      expect(PostDraft.isValidTag('야간개장'), isTrue);
    });

    test('30 코드포인트를 넘는 태그는 거부된다', () {
      expect(PostDraft.isValidTag('a' * 31), isFalse);
      expect(PostDraft.isValidTag('a' * 30), isTrue);
    });

    test('빈 태그는 거부된다', () {
      expect(PostDraft.isValidTag('   '), isFalse);
    });

    test('태그가 5개면 더 넣을 수 없다', () {
      final PostDraft full = valid.copyWith(
        tags: const <String>['a', 'b', 'c', 'd', 'e'],
      );
      expect(full.canAddTag, isFalse);
      expect(valid.copyWith(tags: const <String>['a']).canAddTag, isTrue);
    });
  });

  test('withoutSpot은 장소를 비운다 (copyWith의 null은 "안 바꿈"이라서)', () {
    final PostDraft withSpot = valid.copyWith(
      spotId: '11094',
      spotTitle: '경복궁',
    );
    expect(withSpot.withoutSpot().spotId, isNull);
    expect(withSpot.withoutSpot().spotTitle, isNull);
    // 나머지는 유지된다.
    expect(withSpot.withoutSpot().title, valid.title);
  });

  // **두 종류가 한 목록에 섞인다** — 이미 올라간 키와 아직 안 올린 로컬 장이다.
  // 초안이 후자를 담을 수 있게 된 것이 업로드를 등록 시점으로 미룰 수 있는 근거다.
  group('사진 — 원격과 로컬', () {
    final LocalPhoto local = LocalPhoto(
      id: 'l1',
      bytes: Uint8List.fromList(<int>[1, 2, 3]),
      contentType: 'image/jpeg',
      name: 'a.jpg',
    );
    final PostDraft mixed = valid.copyWith(
      photos: <ComposerPhoto>[const RemotePhoto('images/20/1'), local],
    );

    test('확정 키만 서버로 나가고 로컬 장은 따로 추려진다', () {
      expect(mixed.remoteKeys, <String>['images/20/1']);
      expect(mixed.pendingPhotos, <LocalPhoto>[local]);
    });

    // 상한은 글에 붙는 최종 개수에 걸린다(가이드 §4) — 두 종류를 함께 센다.
    test('남은 자리는 원격·로컬을 합쳐 센다', () {
      expect(mixed.remainingPhotoSlots, maxPostPhotos - 2);
    });

    // **실제 바이트 수여야 한다** — 이 값이 서명에 들어가 1바이트만 달라도
    // 스토리지가 403으로 거부한다(가이드 §4).
    test('contentLength는 들고 있는 바이트 수 그대로다', () {
      expect(local.contentLength, 3);
    });
  });
}
