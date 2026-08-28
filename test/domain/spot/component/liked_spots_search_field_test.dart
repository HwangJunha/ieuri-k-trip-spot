import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/common/storage/app_preferences.dart';
import 'package:ieuri_k_trip_spot/domain/spot/component/liked_spots_search_field.dart';
import 'package:ieuri_k_trip_spot/domain/spot/provider/liked_spots_providers.dart';
import 'package:ieuri_k_trip_spot/l10n/gen/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 좋아요 목록 검색 입력의 **조회 트리거**(SPEC-0033, 사용자 결정 2026-08-29).
///
/// 위젯 테스트는 이 스펙의 범위 밖이지만 이 파일만 예외다 — "타자 중에는 조회하지
/// 않고 엔터로만 조회한다"는 규칙은 **위젯의 콜백 배선 그 자체**라, 그보다 아래
/// 계층에서는 검증할 자리가 없다. 실제로 디바운스가 엔터를 잡아먹어 "첫 엔터가 안
/// 먹는" 버그가 났던 자리다.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late SharedPreferences prefs;

  setUp(() async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    prefs = await SharedPreferences.getInstance();
  });

  /// 입력 위젯 하나만 띄운다 — 목록·조회는 이 테스트의 관심이 아니다.
  Future<ProviderContainer> pumpField(WidgetTester tester) async {
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
          home: Scaffold(body: LikedSpotsSearchField()),
        ),
      ),
    );
    return container;
  }

  testWidgets('타자 중에는 검색어가 확정되지 않는다', (WidgetTester tester) async {
    final ProviderContainer container = await pumpField(tester);

    await tester.enterText(find.byType(TextField), 'seoul');
    await tester.pump();

    // 디바운스가 있던 시절에는 여기서 시간이 지나면 확정됐다. 이제는 엔터 전까지
    // 아무 일도 일어나지 않는다 — 그래야 엔터가 조회를 일으킬 여지가 남는다.
    expect(container.read(likedSpotsSearchQueryProvider), '');
  });

  testWidgets('첫 엔터에 바로 검색어가 확정된다', (WidgetTester tester) async {
    // 사용자가 겪은 버그가 정확히 이것이다 — 디바운스가 먼저 같은 값을 확정해 두면
    // 엔터를 쳐도 상태가 그대로라 재조회가 일어나지 않았다.
    final ProviderContainer container = await pumpField(tester);

    await tester.enterText(find.byType(TextField), 'seoul');
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pump();

    expect(container.read(likedSpotsSearchQueryProvider), 'seoul');
  });

  testWidgets('엔터로 확정할 때 앞뒤 공백을 턴다', (WidgetTester tester) async {
    final ProviderContainer container = await pumpField(tester);

    await tester.enterText(find.byType(TextField), '  seoul  ');
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pump();

    expect(container.read(likedSpotsSearchQueryProvider), 'seoul');
  });

  testWidgets('입력을 다 지우면 엔터 없이 검색어를 버린다', (WidgetTester tester) async {
    // 지우는 것은 검색의 취소이지 새 조회가 아니다 — 엔터를 한 번 더 치게 할 이유가
    // 없다.
    final ProviderContainer container = await pumpField(tester);
    await tester.enterText(find.byType(TextField), 'seoul');
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pump();

    await tester.enterText(find.byType(TextField), '');
    await tester.pump();

    expect(container.read(likedSpotsSearchQueryProvider), '');
  });

  testWidgets('clear 버튼이 입력과 검색어를 함께 비운다', (WidgetTester tester) async {
    final ProviderContainer container = await pumpField(tester);
    await tester.enterText(find.byType(TextField), 'seoul');
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pump();

    await tester.tap(find.byKey(const Key('liked_spots_search_clear')));
    await tester.pump();

    expect(container.read(likedSpotsSearchQueryProvider), '');
    expect(tester.widget<TextField>(find.byType(TextField)).controller?.text, '');
  });

  testWidgets('검색어가 없으면 clear 버튼이 없다', (WidgetTester tester) async {
    await pumpField(tester);

    expect(find.byKey(const Key('liked_spots_search_clear')), findsNothing);
  });
}
