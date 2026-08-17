import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/domain/spot/component/swipe_card.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/copyright_type.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/swipe_card_metrics.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/tourist_spot.dart';
import 'package:ieuri_k_trip_spot/l10n/gen/app_localizations.dart';

/// 카드가 화면을 어떻게 나눠 쓰는가(SPEC-0025 R1·R14).
///
/// **이 파일이 지키는 것은 "화면이 비지 않는다"이다.** 한때 사진 높이를 이미지 비율에
/// 맡겼더니 가로로 넓은 사진에서 사진이 납작해지고 화면 아래 절반이 빈 여백으로
/// 남았다 — 장소를 구경하는 화면에서 정작 장소가 안 보였다(사용자 지적 2026-08-18).
/// 개별 조건은 다 만족했지만 완성된 화면이 못 쓸 물건이었다.
void main() {
  const double cardWidth = 400;
  const double cardHeight = 800;

  const SwipeCardMetrics metrics = SwipeCardMetrics(
    width: cardWidth,
    height: cardHeight,
    overlayBottomInset: 36,
    topScrimHeight: 115,
  );

  TouristSpot spotWith(CopyrightType copyright) => TouristSpot(
    id: 's1',
    name: '경복궁',
    imageRef: 'mock:palace',
    location: '서울',
    address: '서울 종로구',
    distanceMeters: 850,
    copyright: copyright,
    attributionText: '한국관광공사',
  );

  Future<void> pumpCard(
    WidgetTester tester, {
    required TouristSpot spot,
    SwipeCardMetrics? cardMetrics,
  }) => tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: const <LocalizationsDelegate<Object>>[
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: Center(
          child: SizedBox(
            width: cardWidth,
            height: cardHeight,
            child: SwipeCard(spot: spot, metrics: cardMetrics),
          ),
        ),
      ),
    ),
  );

  /// **핵심 회귀 방지**: 정보는 자기 내용만큼만 쓰고 나머지는 사진 몫이다.
  ///
  /// 이름·주소·거리 세 줄이라 정보 블록은 200px 남짓이면 충분하다. 그보다 훨씬 큰
  /// 자리가 정보 쪽에 남아 있으면 **그것이 곧 빈 화면**이다 — 사진 높이를 이미지
  /// 비율에 맡겼을 때 실제로 카드 절반이 비었다.
  ///
  /// 저작권 유형을 모두 도는 이유는 `contain`(TYPE3·미지정)에서 특히 비기 쉬웠기
  /// 때문이다.
  testWidgets('정보가 카드를 독차지하지 않는다', (WidgetTester tester) async {
    for (final CopyrightType copyright in CopyrightType.values) {
      await pumpCard(
        tester,
        spot: spotWith(copyright),
        cardMetrics: metrics,
      );

      // 정보 블록의 위끝 = 사진이 끝나는 지점.
      final double infoTop = tester.getTopLeft(find.text('경복궁')).dy;
      final double cardTop = tester.getTopLeft(find.byType(SwipeCard)).dy;
      final double infoShare = cardHeight - (infoTop - cardTop);

      // 배지·제목·주소·거리와 여백을 합쳐 320px 남짓이 정상이다. 사진 높이를
      // 비율에 맡겼던 버그에서는 이 값이 400을 훌쩍 넘었다(카드 절반이 빔).
      expect(
        infoShare,
        lessThan(360),
        reason:
            '$copyright에서 정보 영역이 360px을 넘으면 그만큼이 빈 화면이다',
      );
    }
  });

  /// 저작권 유형과 무관하게 **정보는 늘 보인다.** 사진이 자리를 다 먹어 글자가
  /// 밀려나면 그것대로 못 쓴다.
  testWidgets('사진이 정보를 밀어내지 않는다', (WidgetTester tester) async {
    for (final CopyrightType copyright in CopyrightType.values) {
      await pumpCard(
        tester,
        spot: spotWith(copyright),
        cardMetrics: metrics,
      );

      expect(find.text('경복궁'), findsOneWidget, reason: '$copyright');
      expect(find.text('서울 종로구'), findsOneWidget, reason: '$copyright');
    }
  });

  /// 작은 화면에서도 넘치지 않는다 — 예전에 600×800에서 148px 넘쳐 레이아웃이
  /// 터진 적이 있다.
  testWidgets('좁은 카드에서도 넘치지 않는다', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: const <LocalizationsDelegate<Object>>[
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: 320,
              height: 420,
              child: SwipeCard(
                spot: spotWith(CopyrightType.type3),
                metrics: const SwipeCardMetrics(
                  width: 320,
                  height: 420,
                  overlayBottomInset: 36,
                  topScrimHeight: 115,
                ),
              ),
            ),
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
  });

  /// 배치 수치가 없는 자리(다음 카드 대기)에서는 사진만 그린다 — 그 카드는 위
  /// 카드에 거의 가려 있어 정보를 그릴 이유가 없다.
  testWidgets('배치 수치가 없으면 정보를 그리지 않는다', (WidgetTester tester) async {
    await pumpCard(tester, spot: spotWith(CopyrightType.type1));

    expect(find.text('경복궁'), findsNothing);
  });
}
