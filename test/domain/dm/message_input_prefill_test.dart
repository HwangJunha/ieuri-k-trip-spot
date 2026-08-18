import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/domain/dm/component/message_input_bar.dart';
import 'package:ieuri_k_trip_spot/l10n/gen/app_localizations.dart';

/// 입력창 프리필(SPEC-0026).
///
/// 대화는 상대별로 하나인데 서버가 남기는 출처는 최초 하나뿐이라, 다른 질문에서
/// 같은 사람에게 말을 걸면 상단 카드가 계속 첫 질문을 가리킨다. 그 두 번째 맥락을
/// **메시지로** 남기기 위한 장치다 — 카드를 갈아끼우면 첫 맥락이 사라진다.
Future<void> _pump(WidgetTester tester, {String? initialText}) async {
  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('en'),
      home: Scaffold(
        body: MessageInputBar(
          onSend: (_) {},
          onChanged: () {},
          initialText: initialText,
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  group('MessageInputBar 프리필', () {
    testWidgets('프리필이 있으면 입력창에 채워진다', (WidgetTester tester) async {
      await _pump(tester, initialText: "I'm asking about 'Relax Work'. ");

      expect(
        find.text("I'm asking about 'Relax Work'. "),
        findsOneWidget,
        reason: '보내는 순간 맥락이 양쪽 기록에 남는다',
      );
    });

    testWidgets('프리필이 없으면 빈 입력창이다', (WidgetTester tester) async {
      await _pump(tester);

      final TextField field = tester.widget<TextField>(find.byType(TextField));
      expect(field.controller?.text, isEmpty);
    });

    // **채워만 두고 보내지 않는다** — 사용자가 지우고 자기 말로 쓸 수 있어야 한다.
    testWidgets('프리필은 자동으로 전송되지 않는다', (WidgetTester tester) async {
      final List<String> sent = <String>[];
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('en'),
          home: Scaffold(
            body: MessageInputBar(
              onSend: sent.add,
              onChanged: () {},
              initialText: 'prefilled',
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(sent, isEmpty);
    });

    testWidgets('프리필을 지우고 쓸 수 있다', (WidgetTester tester) async {
      await _pump(tester, initialText: 'prefilled');

      await tester.enterText(find.byType(TextField), '내 말로 쓴다');
      await tester.pumpAndSettle();

      expect(find.text('prefilled'), findsNothing);
      expect(find.text('내 말로 쓴다'), findsOneWidget);
    });
  });
}
