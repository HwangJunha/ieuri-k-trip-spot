import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/domain/map/model/congestion_display.dart';
import 'package:intl/date_symbol_data_local.dart';

/// 신선도·인구 범위 표시(R27). 데이터가 약 30분 지연되므로(spec §4.2) 기준 시각을
/// 그대로 노출하고 "지금"으로 읽히게 두지 않는다.
void main() {
  setUpAll(() async {
    // intl의 로케일별 날짜 심볼을 올린다. 앱에서는 flutter_localizations가 하지만
    // 순수 단위 테스트에는 그 초기화가 없다.
    await initializeDateFormatting();
  });

  final DateTime observedAt = DateTime(2026, 8, 10, 3, 30);

  group('기준 시각 (R27)', () {
    test('기준 시각의 시와 분이 문자열에 담긴다', () {
      final String label = CongestionDisplay.observedAtLabel(observedAt, 'en');

      expect(label, contains('3'));
      expect(label, contains('30'));
    });

    test('"지금"에 해당하는 표현을 쓰지 않는다', () {
      final String en = CongestionDisplay.observedAtLabel(observedAt, 'en');
      final String ko = CongestionDisplay.observedAtLabel(observedAt, 'ko');

      expect(en.toLowerCase(), isNot(contains('now')));
      expect(ko, isNot(contains('지금')));
      expect(ko, isNot(contains('현재')));
    });

    test('로케일에 따라 표기가 달라진다', () {
      expect(
        CongestionDisplay.observedAtLabel(observedAt, 'ko'),
        isNot(CongestionDisplay.observedAtLabel(observedAt, 'en')),
      );
    });

    test('영어 로케일에 한국어가 섞이지 않는다', () {
      final String en = CongestionDisplay.observedAtLabel(observedAt, 'en');

      expect(RegExp(r'[가-힣]').hasMatch(en), isFalse);
    });
  });

  group('인구 범위 (R27)', () {
    test('하한과 상한이 모두 담긴다', () {
      final ({String max, String min}) range =
          CongestionDisplay.populationRange(3000, 3500, 'en');

      expect(range.min, contains('3'));
      expect(range.max, contains('3'));
      expect(range.min, isNot(range.max));
    });

    test('천 단위를 끊어 준다', () {
      final ({String max, String min}) range =
          CongestionDisplay.populationRange(3000, 3500, 'en');

      expect(range.min, '3,000');
      expect(range.max, '3,500');
    });
  });
}
