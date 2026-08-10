import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/domain/map/model/congestion_level.dart';
import 'package:ieuri_k_trip_spot/domain/map/model/congestion_palette.dart';

/// 4단계 채색(R24). 색 자체는 디자인 재량이지만 **서로 달라야 한다**는 것과
/// **명도가 순서를 따라야 한다**는 것은 수용 기준이다.
void main() {
  test('네 단계의 채우기 색이 서로 다르다', () {
    final Set<int> fills = CongestionLevel.values
        .map(CongestionPalette.fillOf)
        .toSet();

    expect(fills, hasLength(CongestionLevel.values.length));
  });

  test('붐빔과 여유는 다른 색이다', () {
    expect(
      CongestionPalette.fillOf(CongestionLevel.crowded),
      isNot(CongestionPalette.fillOf(CongestionLevel.relaxed)),
    );
  });

  test('채우기는 반투명이라 아래 지도가 비친다', () {
    for (final CongestionLevel level in CongestionLevel.values) {
      final int alpha = CongestionPalette.fillOf(level) >>> 24;

      expect(alpha, lessThan(0xFF), reason: '$level의 채우기가 불투명하다');
      expect(alpha, greaterThan(0), reason: '$level의 채우기가 완전 투명하다');
    }
  });

  test('테두리는 불투명해 인접 구역의 경계가 뭉개지지 않는다', () {
    for (final CongestionLevel level in CongestionLevel.values) {
      expect(CongestionPalette.strokeOf(level) >>> 24, 0xFF, reason: '$level');
    }
  });

  /// 적록 대비에만 의존하지 않는다는 요구(R24)를 검증한다. 색상을 못 봐도 밝기만으로
  /// 순서를 읽을 수 있어야 하므로, 단계가 올라갈수록 명도가 낮아져야 한다.
  test('단계가 올라갈수록 어두워진다 — 색각과 무관하게 순서를 읽을 수 있다', () {
    double luminanceOf(CongestionLevel level) {
      final int argb = CongestionPalette.strokeOf(level);
      final int r = (argb >> 16) & 0xFF;
      final int g = (argb >> 8) & 0xFF;
      final int b = argb & 0xFF;
      // ITU-R BT.601 가중치. 정확한 지각 명도가 아니라 단조성만 보면 된다.
      return 0.299 * r + 0.587 * g + 0.114 * b;
    }

    final List<double> luminances = CongestionLevel.values
        .map(luminanceOf)
        .toList();

    for (int i = 1; i < luminances.length; i++) {
      expect(
        luminances[i],
        lessThan(luminances[i - 1]),
        reason: '${CongestionLevel.values[i]}가 앞 단계보다 어둡지 않다',
      );
    }
  });
}
