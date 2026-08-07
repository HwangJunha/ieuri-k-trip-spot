import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:ieuri_k_trip_spot/common/location/location_providers.dart';
import 'package:ieuri_k_trip_spot/common/navigation/settings_routes.dart';
import 'package:ieuri_k_trip_spot/common/widget/settings_button.dart';
import 'package:ieuri_k_trip_spot/domain/community/provider/community_providers.dart';
import 'package:ieuri_k_trip_spot/domain/community/view/community_screen.dart';
import 'package:ieuri_k_trip_spot/l10n/gen/app_localizations.dart';

import '../../community/community_test_doubles.dart';
import '../../spot/spot_test_doubles.dart';

/// SPEC-0011 R1·R2 — 설정 진입점이 생기고, 커뮤니티에서 차단 목록 진입점이 빠진다.

Future<void> _pumpCommunity(WidgetTester tester) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        communityRepositoryProvider.overrideWithValue(
          FakeCommunityRepository(),
        ),
        locationServiceProvider.overrideWithValue(FakeLocationService()),
      ],
      child: const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: Locale('en'),
        home: CommunityScreen(),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('커뮤니티 앱바에서 차단 목록 아이콘이 빠진다 (R2)', (WidgetTester tester) async {
    await _pumpCommunity(tester);

    expect(find.byIcon(Icons.block), findsNothing);
  });

  testWidgets('커뮤니티 앱바에 숨긴 글 아이콘은 남는다 (R2)', (WidgetTester tester) async {
    // 스펙의 결정이다 — 둘을 묶었던 근거는 깨지지만 숨김만 남긴다.
    await _pumpCommunity(tester);

    expect(find.byIcon(Icons.visibility_off_outlined), findsOneWidget);
  });

  testWidgets('홈 우상단 설정 버튼이 설정 라우트로 보낸다 (R1)', (WidgetTester tester) async {
    // 진입점이 실제로 설정에 닿는지 본다. 이름 상수는 `common/navigation`이 하나로
    // 들고 있으므로 문자열끼리 비교하는 대신 라우팅 결과를 확인한다.
    final GoRouter router = GoRouter(
      initialLocation: '/entry',
      routes: <RouteBase>[
        GoRoute(
          path: '/entry',
          builder: (_, _) =>
              const Scaffold(appBar: null, body: SettingsButton()),
        ),
        GoRoute(
          path: '/settings',
          name: settingsRouteName,
          builder: (_, _) => const Scaffold(body: Text('settings-landed')),
        ),
      ],
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp.router(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('en'),
          routerConfig: router,
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.settings_outlined));
    await tester.pumpAndSettle();

    expect(find.text('settings-landed'), findsOneWidget);
  });
}
