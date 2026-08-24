import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/common/analytics/analytics_route_observer.dart';

void main() {
  group('화면 이름 정규화', () {
    test('id가 박힌 경로는 하나로 묶인다 — 스팟마다 다른 화면이 되면 안 된다', () {
      expect(
        AnalyticsRouteObserver.screenNameOf('/spot/126508'),
        AnalyticsRouteObserver.screenNameOf('/spot/294265'),
      );
      expect(AnalyticsRouteObserver.screenNameOf('/spot/126508'), '/spot/:id');
    });

    test('문자가 섞인 구간은 화면 이름이라 남긴다', () {
      // 이것까지 지우면 서로 다른 설정 화면이 한 이름으로 뭉친다.
      expect(
        AnalyticsRouteObserver.screenNameOf('/settings/profile'),
        '/settings/profile',
      );
    });

    test('쿼리는 화면을 가르지 않는다', () {
      expect(
        AnalyticsRouteObserver.screenNameOf('/search?q=seoul'),
        AnalyticsRouteObserver.screenNameOf('/search'),
      );
    });

    test('중첩 경로의 id도 묶인다', () {
      expect(
        AnalyticsRouteObserver.screenNameOf('/spot/1/qa/99'),
        '/spot/:id/qa/:id',
      );
    });

    test('루트는 그대로다', () {
      expect(AnalyticsRouteObserver.screenNameOf('/'), '/');
    });

    test('이름 없는 라우트는 집계하지 않는다 — 다이얼로그는 화면이 아니다', () {
      expect(AnalyticsRouteObserver.screenNameOf(null), isNull);
      expect(AnalyticsRouteObserver.screenNameOf(''), isNull);
    });
  });
}
