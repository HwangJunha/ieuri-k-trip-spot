import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/copyright_type.dart';

void main() {
  test('fromWire maps known tokens', () {
    expect(CopyrightType.fromWire('TYPE1'), CopyrightType.type1);
    expect(CopyrightType.fromWire('type3'), CopyrightType.type3);
  });

  test('fromWire falls back to unspecified for unknown/null', () {
    expect(CopyrightType.fromWire(null), CopyrightType.unspecified);
    expect(CopyrightType.fromWire('TYPE_X'), CopyrightType.unspecified);
  });

  test(
    'only TYPE1 allows cropping (cover); others keep original (contain)',
    () {
      expect(CopyrightType.type1.cropAllowed, isTrue);
      expect(CopyrightType.type3.cropAllowed, isFalse);
      expect(CopyrightType.unspecified.cropAllowed, isFalse);
    },
  );
}
