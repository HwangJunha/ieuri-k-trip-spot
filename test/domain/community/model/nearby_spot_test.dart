import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/domain/community/model/nearby_spot.dart';

NearbySpot _spot(String title) =>
    NearbySpot(id: '1', title: title, distanceMeters: 10);

void main() {
  group('matches — 시트의 이름 필터 (서버에 검색 인자가 없다)', () {
    test('제목 일부가 들어 있으면 맞는다', () {
      expect(_spot('경복궁 야간개장').matches('경복'), isTrue);
    });

    test('대소문자를 가리지 않는다', () {
      expect(_spot('Seoul Gallery').matches('SEOUL'), isTrue);
      expect(_spot('Seoul Gallery').matches('gallery'), isTrue);
    });

    test('없는 이름이면 걸러진다', () {
      expect(_spot('경복궁').matches('덕수'), isFalse);
    });

    // 필터가 비면 목록 전체가 보여야 한다 — 빈 입력은 "안 좁힘"이다.
    test('빈 질의는 전부 통과시킨다', () {
      expect(_spot('경복궁').matches(''), isTrue);
      expect(_spot('경복궁').matches('   '), isTrue);
    });
  });

  test('값이 같으면 같다', () {
    expect(
      const NearbySpot(id: '1', title: 'A', distanceMeters: 10),
      const NearbySpot(id: '1', title: 'A', distanceMeters: 10),
    );
    expect(
      const NearbySpot(id: '1', title: 'A', distanceMeters: 10),
      isNot(const NearbySpot(id: '2', title: 'A', distanceMeters: 10)),
    );
  });
}
