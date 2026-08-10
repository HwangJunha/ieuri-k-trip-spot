import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/common/localization/locale_controller.dart';
import 'package:ieuri_k_trip_spot/common/storage/app_preferences.dart';
import 'package:ieuri_k_trip_spot/common/storage/search_radius_controller.dart';
import 'package:ieuri_k_trip_spot/domain/settings/view/preferences_screen.dart';
import 'package:ieuri_k_trip_spot/l10n/gen/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// SPEC-0011 R13·R14 — 반경 슬라이더와 언어 선택이 사용자에게 보이는 대로 동작한다.

Future<ProviderContainer> _pump(
  WidgetTester tester, {
  Map<String, Object>? initial,
}) async {
  SharedPreferences.setMockInitialValues(initial ?? <String, Object>{});
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final ProviderContainer container = ProviderContainer(
    overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
  );
  addTearDown(container.dispose);

  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: Locale('en'),
        home: PreferencesScreen(),
      ),
    ),
  );
  await tester.pumpAndSettle();
  return container;
}

void main() {
  testWidgets('저장된 반경이 화면에 그려진다 (R13)', (WidgetTester tester) async {
    await _pump(tester, initial: <String, Object>{'search_radius_km': 35.0});

    expect(find.text('35 km'), findsOneWidget);
  });

  testWidgets('반경을 저장한 적 없으면 20km로 보인다 (R13)', (WidgetTester tester) async {
    await _pump(tester);

    // 슬라이더 값 표시와 최솟값 라벨(0 km)·최댓값 라벨(100 km)이 함께 있다.
    expect(find.text('20 km'), findsOneWidget);
    expect(find.text('0 km'), findsOneWidget);
    expect(find.text('100 km'), findsOneWidget);
  });

  testWidgets('0km가 뜻하는 바를 화면에 드러낸다 (R13)', (WidgetTester tester) async {
    // 슬라이더만 보면 0이 "설정 안 함"으로 읽힌다 — 네 번째 인수 기준.
    await _pump(tester);

    expect(
      find.text('Set to 0 km to search only your current location.'),
      findsOneWidget,
    );
  });

  testWidgets('언어 목록에 지원 언어가 모두 보인다 (R14)', (WidgetTester tester) async {
    await _pump(tester);

    expect(find.text('English'), findsOneWidget);
    expect(find.text('한국어'), findsOneWidget);
    expect(find.text('日本語'), findsOneWidget);
    expect(find.text('繁體中文'), findsOneWidget);
  });

  testWidgets('언어를 고르면 앱 로케일이 바뀐다 (R14)', (WidgetTester tester) async {
    // 새 상태 관리를 만들지 않고 기존 LocaleController에 위임한다(설계 §6).
    final ProviderContainer container = await _pump(tester);

    await tester.tap(find.text('日本語'));
    await tester.pumpAndSettle();

    expect(container.read(localeControllerProvider).languageCode, 'ja');
  });

  testWidgets('슬라이더를 놓으면 반경이 저장된다 (R13)', (WidgetTester tester) async {
    final ProviderContainer container = await _pump(tester);
    final Offset center = tester.getCenter(find.byType(Slider));

    // 슬라이더 트랙의 가장 왼쪽으로 끌면 최솟값(0)이 된다.
    await tester.dragFrom(center, const Offset(-500, 0));
    await tester.pumpAndSettle();

    expect(container.read(searchRadiusControllerProvider), 0);
  });
}
