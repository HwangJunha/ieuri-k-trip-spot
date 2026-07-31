import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/distance.dart';

void main() {
  test('kilometers converts meters and formats to one decimal', () {
    const Distance d = Distance(1234);
    expect(d.kilometers, closeTo(1.234, 1e-9));
    expect(d.kilometersLabel, '1.2');
  });

  test('sub-kilometer distances report meters', () {
    const Distance d = Distance(850);
    expect(d.isSubKilometer, isTrue);
    expect(d.metersLabel, '850');
  });

  test('one kilometer is not sub-kilometer', () {
    expect(const Distance(1000).isSubKilometer, isFalse);
  });

  test('equality is by meters', () {
    expect(const Distance(500), const Distance(500));
    expect(const Distance(500) == const Distance(501), isFalse);
  });
}
