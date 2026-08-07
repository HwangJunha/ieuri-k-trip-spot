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

  // 찜한 장소는 하단 탭(셸 브랜치)이라 **push하면 안 된다.** 셸이 이미 그 라우트의
  // 페이지 키를 잡고 있어, 루트 내비게이터에 같은 것을 얹으면
  // `!keyReservation.contains(key)` assertion으로 앱이 빨간 화면이 된다.
  // 실제로 그렇게 터졌다.
  testWidgets('설정에서 찜한 장소로 가면 탭으로 전환되고 크래시하지 않는다 (R1)', (
    WidgetTester tester,
  ) async {
    final GoRouter router = GoRouter(
      initialLocation: '/settings',
      routes: <RouteBase>[
        GoRoute(
          path: '/settings',
          name: settingsRouteName,
          builder: (_, _) => Scaffold(
            body: Builder(
              builder: (BuildContext context) => TextButton(
                onPressed: () => context.goNamed(likedSpotsRouteName),
                child: const Text('liked'),
              ),
            ),
          ),
        ),
        StatefulShellRoute.indexedStack(
          builder: (_, _, StatefulNavigationShell shell) =>
              Scaffold(body: shell),
          branches: <StatefulShellBranch>[
            StatefulShellBranch(
              routes: <RouteBase>[
                GoRoute(
                  path: '/liked',
                  name: likedSpotsRouteName,
                  builder: (_, _) =>
                      const Scaffold(body: Text('liked-landed')),
                ),
              ],
            ),
          ],
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

    await tester.tap(find.text('liked'));
    await tester.pumpAndSettle();

    // 예외 없이 도착해야 한다 — push였다면 여기서 assertion이 터진다.
    expect(tester.takeException(), isNull);
    expect(find.text('liked-landed'), findsOneWidget);
  });
}
