import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/congestion_level.dart';

void main() {
  group('CongestionLevel.fromWire', () {
    test('maps known wire tokens case-insensitively', () {
      expect(CongestionLevel.fromWire('LOW'), CongestionLevel.low);
      expect(CongestionLevel.fromWire('moderate'), CongestionLevel.moderate);
      expect(CongestionLevel.fromWire('High'), CongestionLevel.high);
    });

    test('defaults unknown or null to moderate', () {
      expect(CongestionLevel.fromWire(null), CongestionLevel.moderate);
      expect(CongestionLevel.fromWire('???'), CongestionLevel.moderate);
    });
  });
}
