import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/common/permission/model/permission_state.dart';

void main() {
  group('isDecided (R6 gate)', () {
    test('denied is the only undecided state', () {
      expect(PermissionState.denied.isDecided, isFalse);
    });

    test('granted / permanentlyDenied / restricted are decided', () {
      expect(PermissionState.granted.isDecided, isTrue);
      expect(PermissionState.permanentlyDenied.isDecided, isTrue);
      expect(PermissionState.restricted.isDecided, isTrue);
    });
  });

  group('needsSettings (R5 path)', () {
    test('only permanentlyDenied and restricted need Settings', () {
      expect(PermissionState.permanentlyDenied.needsSettings, isTrue);
      expect(PermissionState.restricted.needsSettings, isTrue);
    });

    test('granted and denied do not surface the Settings path', () {
      expect(PermissionState.granted.needsSettings, isFalse);
      expect(PermissionState.denied.needsSettings, isFalse);
    });
  });
}
