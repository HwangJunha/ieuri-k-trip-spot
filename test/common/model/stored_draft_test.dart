import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/common/model/composer_photo.dart';
import 'package:ieuri_k_trip_spot/common/model/stored_draft.dart';
import 'package:ieuri_k_trip_spot/common/model/target_category.dart';

LocalPhoto _local(String id, {int size = 3}) => LocalPhoto(
  id: id,
  bytes: Uint8List.fromList(List<int>.filled(size, 1)),
  contentType: 'image/jpeg',
  name: '$id.jpg',
);

void main() {
  group('직렬화 왕복 (R2)', () {
    test('텍스트 계열이 JSON을 왕복해도 그대로다', () {
      final StoredDraft draft = StoredDraft.fromDraft(
        savedAt: DateTime.utc(2026, 8, 16, 10),
        category: TargetCategory.restaurant,
        spotId: 'spot-1',
        spotTitle: '경복궁',
        title: '제목',
        body: '본문',
        tags: <String>['맛집', '서울'],
      );

      final StoredDraft? restored = StoredDraft.fromJson(draft.toJson());

      expect(restored, draft);
    });

    test('카테고리는 서버 코드 문자열로 저장된다', () {
      final StoredDraft draft = StoredDraft.fromDraft(
        savedAt: DateTime.utc(2026, 8, 16),
        category: TargetCategory.restaurant,
      );

      expect(draft.category, 'RESTAURANT');
      expect(draft.restoredCategory, TargetCategory.restaurant);
    });

    test('서버 목록에서 사라진 카테고리는 그 값만 null로 복원된다', () {
      // 초안 전체를 버리지 않는다 — 사용자가 카테고리만 다시 고른다(§3).
      final StoredDraft draft = StoredDraft(
        savedAt: DateTime.utc(2026, 8, 16),
        category: 'NO_LONGER_A_CATEGORY',
        title: '제목',
      );

      expect(draft.restoredCategory, isNull);
      expect(draft.title, '제목');
    });
  });

  group('사진 순서와 종류 (R3)', () {
    test('원격과 로컬이 섞여도 저장 순서가 그대로다', () {
      final StoredDraft draft = StoredDraft.fromDraft(
        savedAt: DateTime.utc(2026, 8, 16),
        photos: <ComposerPhoto>[
          _local('a'),
          const RemotePhoto('images/b'),
          _local('c'),
        ],
      );

      final StoredDraft restored = StoredDraft.fromJson(draft.toJson())!;

      expect(restored.photos, hasLength(3));
      expect((restored.photos[0] as StoredLocalPhoto).id, 'a');
      expect((restored.photos[1] as StoredRemotePhoto).objectKey, 'images/b');
      expect((restored.photos[2] as StoredLocalPhoto).id, 'c');
    });

    test('로컬 사진은 바이트가 아니라 메타만 저장한다', () {
      final StoredDraft draft = StoredDraft.fromDraft(
        savedAt: DateTime.utc(2026, 8, 16),
        photos: <ComposerPhoto>[_local('a', size: 1024)],
      );

      final StoredLocalPhoto photo = draft.photos.single as StoredLocalPhoto;
      expect(photo.contentLength, 1024);
      // 바이트가 JSON에 실리지 않는다 — 5장이면 최대 50MiB다(§2).
      expect(draft.toJson().toString(), isNot(contains('bytes')));
    });

    test('파일 이름은 id에서 유도되고 경로 구분자가 섞이지 않는다', () {
      // 사진 선택기가 만든 id에 경로가 섞여도 앱 전용 디렉토리 밖을 가리키면 안
      // 된다 — 구분자가 없으면 그대로 이어 붙여도 한 겹 안에 머문다.
      const StoredLocalPhoto photo = StoredLocalPhoto(
        id: '../../etc/passwd',
        name: 'x.jpg',
        contentType: 'image/jpeg',
        contentLength: 1,
      );

      expect(photo.fileName, isNot(contains('/')));
      expect(photo.fileName, isNot(contains(r'\')));
    });

    test('같은 사진은 늘 같은 파일 이름을 얻는다', () {
      // 이름이 안정적이라야 이미 쓴 장을 다시 쓰지 않는다(§4).
      const StoredLocalPhoto a = StoredLocalPhoto(
        id: 'photo-1',
        name: 'a.jpg',
        contentType: 'image/jpeg',
        contentLength: 1,
      );
      const StoredLocalPhoto b = StoredLocalPhoto(
        id: 'photo-1',
        name: 'b.jpg',
        contentType: 'image/png',
        contentLength: 99,
      );

      expect(a.fileName, b.fileName);
    });
  });

  group('해석 불가 (R10-1)', () {
    test('savedAt이 없으면 복원 불가다', () {
      expect(StoredDraft.fromJson(<String, Object?>{'title': 'x'}), isNull);
    });

    test('사진 한 장이라도 해석되지 않으면 초안 전체가 복원 불가다', () {
      // 중간을 건너뛰면 사용자가 붙인 것과 다른 목록이 된다(R3-4).
      final Map<String, Object?> json = <String, Object?>{
        'savedAt': DateTime.utc(2026, 8, 16).toIso8601String(),
        'photos': <Object?>[
          <String, Object?>{'type': 'remote', 'objectKey': 'images/a'},
          <String, Object?>{'type': 'unknown'},
        ],
      };

      expect(StoredDraft.fromJson(json), isNull);
    });
  });

  group('빈 초안 판정 (R1-3)', () {
    test('여섯 요소가 모두 비면 빈 초안이다', () {
      expect(StoredDraft(savedAt: DateTime.utc(2026, 8, 16)).isEmpty, isTrue);
    });

    test('공백만 있는 제목·본문도 빈 것으로 본다', () {
      final StoredDraft draft = StoredDraft.fromDraft(
        savedAt: DateTime.utc(2026, 8, 16),
        title: '   ',
        body: '\n',
      );

      expect(draft.isEmpty, isTrue);
    });

    test('사진 한 장만 있어도 빈 초안이 아니다', () {
      final StoredDraft draft = StoredDraft.fromDraft(
        savedAt: DateTime.utc(2026, 8, 16),
        photos: <ComposerPhoto>[_local('a')],
      );

      expect(draft.isEmpty, isFalse);
    });
  });

  group('TTL 판정 (R8)', () {
    final DateTime savedAt = DateTime.utc(2026, 7, 1);

    test('29일 지난 초안은 아직 살아 있다', () {
      expect(
        isDraftExpired(
          savedAt: savedAt,
          now: savedAt.add(const Duration(days: 29)),
        ),
        isFalse,
      );
    });

    test('정확히 30일이면 아직 살아 있다', () {
      expect(
        isDraftExpired(savedAt: savedAt, now: savedAt.add(draftTimeToLive)),
        isFalse,
      );
    });

    test('31일 지난 초안은 만료다', () {
      expect(
        isDraftExpired(
          savedAt: savedAt,
          now: savedAt.add(const Duration(days: 31)),
        ),
        isTrue,
      );
    });
  });
}
