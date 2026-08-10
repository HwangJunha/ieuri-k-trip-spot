import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/domain/map/model/congestion_area.dart';
import 'package:ieuri_k_trip_spot/domain/map/model/congestion_layer_state.dart';
import 'package:ieuri_k_trip_spot/domain/map/model/congestion_level.dart';
import 'package:ieuri_k_trip_spot/domain/map/model/congestion_overlay.dart';

/// 출처 표기 조건(R30)과 레이어 독립(R29).
///
/// 공공누리 1유형의 출처 표시 의무는 **그 데이터를 실제로 쓸 때** 생긴다. 폴리곤이
/// 하나도 없는데 표기만 떠 있으면 무엇의 출처인지 알 수 없다 — 실제로 났던 문제라
/// 회귀를 막는다.
void main() {
  CongestionOverlay overlayOf(String id) => CongestionOverlay(
    area: CongestionArea(
      id: id,
      name: '구역 $id',
      congestion: CongestionSnapshot(
        level: CongestionLevel.normal,
        populationMin: 3000,
        populationMax: 3500,
        observedAt: DateTime.utc(2026, 8, 10, 3, 30),
      ),
    ),
    boundary: CongestionAreaBoundary(
      id: id,
      name: '구역 $id',
      category: '관광특구',
      polygon: const <List<double>>[],
    ),
  );

  group('출처 표기 (R30)', () {
    test('폴리곤을 그릴 때 출처를 노출한다', () {
      final CongestionLayerState state = CongestionShown(<CongestionOverlay>[
        overlayOf('POI014'),
      ]);

      expect(state.showsAttribution, isTrue);
    });

    test('줌 게이트로 숨겼으면 출처도 띄우지 않는다', () {
      expect(const CongestionHiddenByZoom().showsAttribution, isFalse);
    });

    test('그릴 구역이 하나도 없으면 출처를 띄우지 않는다 — 서울 밖이 여기 해당한다', () {
      const CongestionLayerState state = CongestionShown(<CongestionOverlay>[]);

      expect(state.showsAttribution, isFalse);
    });

    test('조회 중에는 출처를 띄우지 않는다', () {
      expect(const CongestionLoading().showsAttribution, isFalse);
    });

    test('성능 저하 상태에서는 출처를 띄우지 않는다', () {
      expect(const CongestionDegraded().showsAttribution, isFalse);
    });
  });
}
