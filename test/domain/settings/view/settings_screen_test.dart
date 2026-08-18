import 'package:ieuri_k_trip_spot/domain/spot_qa/provider/spot_qa_providers.dart';
import 'package:ieuri_k_trip_spot/domain/spot_qa/provider/seen_answer_counts_providers.dart';
import '../../spot_qa/spot_qa_test_doubles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/common/storage/app_preferences.dart';
import 'package:ieuri_k_trip_spot/common/storage/secure_storage.dart';
import 'package:ieuri_k_trip_spot/domain/auth/provider/auth_controller.dart';
import 'package:ieuri_k_trip_spot/domain/auth/provider/auth_repository_provider.dart';
import 'package:ieuri_k_trip_spot/domain/settings/view/settings_screen.dart';
import 'package:ieuri_k_trip_spot/l10n/gen/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../auth/auth_test_doubles.dart';

/// 설정 홈의 구성.

Future<void> _pump(WidgetTester tester) async {
  SharedPreferences.setMockInitialValues(<String, Object>{});
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final SecureStorage secure = await seededSecureStorage(
    authenticated: true,
    onboarded: true,
  );
  final ProviderContainer container = ProviderContainer(
    overrides: [
      sharedPreferencesProvider.overrideWithValue(prefs),
      secureStorageProvider.overrideWithValue(secure),
      authRepositoryProvider.overrideWithValue(FakeAuthRepository()),
      // SPEC-0026: 「내 질문」 배지가 로그인 상태에서 목록을 받는다. 오버라이드가
      // 없으면 실제 GraphQL 클라이언트로 나가 타이머가 남는다.
      spotQaRepositoryProvider.overrideWithValue(FakeSpotQaRepository()),
      seenAnswerCountsStoreProvider.overrideWithValue(FakeSeenAnswerCountsStore()),
    ],
  );
  addTearDown(container.dispose);
  await container.read(authControllerProvider.future);

  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: Locale('en'),
        home: SettingsScreen(),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  // 좋아요를 누른 장소가 곧 찜한 장소라, 하단 탭과 같은 목적지를 활동 항목에도
  // 두는 것은 중복이다. 사용자가 빼기로 정했다.
  testWidgets('활동 항목에 찜한 장소가 없다', (WidgetTester tester) async {
    await _pump(tester);

    expect(find.text('Liked Spots'), findsNothing);
  });

  testWidgets('활동 항목에 내가 쓴 글은 남는다', (WidgetTester tester) async {
    await _pump(tester);

    expect(find.text('My Posts'), findsOneWidget);
  });

  // 서버에 답변 알림이 없어 사용자가 자기 질문을 되찾아 갈 길이 여기뿐이다.
  testWidgets('활동 항목에 내 질문 진입점이 있다', (WidgetTester tester) async {
    await _pump(tester);

    expect(find.text('My questions'), findsOneWidget);
  });

  // 대화 목록 화면은 있었지만 진입점이 앱 어디에도 없었다.
  testWidgets('활동 항목에 메시지 진입점이 있다', (WidgetTester tester) async {
    await _pump(tester);

    expect(find.text('Messages'), findsOneWidget);
  });

  testWidgets('약관 관리 진입점이 있다', (WidgetTester tester) async {
    await _pump(tester);

    // 목록 아래쪽이라 화면 밖이다 — 찾을 때까지 스크롤한다.
    await tester.scrollUntilVisible(
      find.text('Terms & Agreements'),
      200,
      scrollable: find.byType(Scrollable).first,
    );

    expect(find.text('Terms & Agreements'), findsOneWidget);
  });
}
