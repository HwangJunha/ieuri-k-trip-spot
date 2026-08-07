import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/common/model/terms_code.dart';
import 'package:ieuri_k_trip_spot/domain/settings/model/agreement_status.dart';
import 'package:ieuri_k_trip_spot/domain/settings/view/terms_screen.dart';
import 'package:ieuri_k_trip_spot/l10n/gen/app_localizations.dart';

import '../settings_test_doubles.dart';

/// 약관 관리 화면(SPEC-0011 R9·R10) — 사용자가 무엇을 보는지만 본다.

/// 약관 provider가 인증을 watch하므로 세션이 선 컨테이너 위에서 화면을 띄운다 —
/// 인증 없이는 provider가 loading에 매달린다.
Future<void> _pump(WidgetTester tester, FakeSettingsRepository repo) async {
  final ProviderContainer container = await authenticatedContainer(repo);
  addTearDown(container.dispose);
  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: Locale('en'),
        home: TermsScreen(),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('필수 항목에도 토글이 붙는다 (R9)', (WidgetTester tester) async {
    // 동의를 거두는 것을 막지 않는다 — 누를 수 없는 스위치는 고장으로 읽힌다.
    // 끄면 게이트(R11)가 걸려 서비스가 막히고, 그 사실은 부제로 미리 알린다.
    await _pump(
      tester,
      FakeSettingsRepository(
        agreements: <AgreementStatus>[
          agreement(
            TermsCode.service,
            required: true,
            agreed: true,
            agreedAt: '2026-01-12',
          ),
        ],
      ),
    );

    expect(find.text('Terms of Service'), findsOneWidget);
    expect(find.byType(SwitchListTile), findsOneWidget);
  });

  testWidgets('필수 항목을 끄면 서비스 이용 불가를 알린다 (R9)', (WidgetTester tester) async {
    await _pump(
      tester,
      FakeSettingsRepository(
        agreements: <AgreementStatus>[
          agreement(TermsCode.service, required: true),
        ],
      ),
    );

    expect(
      find.text("You can't use the service without agreeing."),
      findsOneWidget,
    );
  });

  testWidgets('필수 항목은 동의 일자를 보여준다 (R9)', (WidgetTester tester) async {
    await _pump(
      tester,
      FakeSettingsRepository(
        agreements: <AgreementStatus>[
          agreement(
            TermsCode.privacy,
            required: true,
            agreed: true,
            agreedAt: '2026-01-12',
          ),
        ],
      ),
    );

    expect(find.text('Agreed 2026-01-12'), findsOneWidget);
  });

  testWidgets('필수·선택 모두 토글할 수 있다 (R10)', (WidgetTester tester) async {
    await _pump(
      tester,
      FakeSettingsRepository(
        agreements: <AgreementStatus>[
          agreement(TermsCode.service, required: true, agreed: true),
          agreement(TermsCode.location),
          agreement(TermsCode.marketing),
        ],
      ),
    );

    expect(find.byType(SwitchListTile), findsNWidgets(3));
    expect(find.text('Location Data'), findsOneWidget);
    expect(find.text('Marketing Notifications'), findsOneWidget);
  });

  testWidgets('토글이 실패하면 스위치가 제자리로 돌아온다 (R10)', (WidgetTester tester) async {
    final FakeSettingsRepository repo = FakeSettingsRepository(
      agreements: <AgreementStatus>[agreement(TermsCode.marketing)],
    )..failUpdate = true;
    await _pump(tester, repo);

    await tester.tap(find.byType(SwitchListTile));
    await tester.pumpAndSettle();

    final SwitchListTile tile = tester.widget<SwitchListTile>(
      find.byType(SwitchListTile),
    );
    expect(tile.value, isFalse);
  });

  testWidgets('조회 실패는 재시도와 함께 안내한다', (WidgetTester tester) async {
    await _pump(tester, _FailingSettingsRepository());
    await tester.pumpAndSettle(const Duration(seconds: 2));

    expect(find.text("Couldn't load your agreements."), findsOneWidget);
    expect(find.text('Try again'), findsOneWidget);
  });
}

/// 조회가 항상 실패하는 저장소. 오류 상태만 관찰한다.
class _FailingSettingsRepository extends FakeSettingsRepository {
  @override
  Future<List<AgreementStatus>> fetchAgreements() async =>
      throw StateError('boom');
}
