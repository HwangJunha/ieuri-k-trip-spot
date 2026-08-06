import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/domain/community/model/blocked_user.dart';
import 'package:ieuri_k_trip_spot/domain/community/model/post_author.dart';
import 'package:ieuri_k_trip_spot/domain/community/provider/community_providers.dart';
import 'package:ieuri_k_trip_spot/domain/community/view/blocked_users_screen.dart';
import 'package:ieuri_k_trip_spot/l10n/gen/app_localizations.dart';

import '../community_test_doubles.dart';

Future<void> _pump(WidgetTester tester, FakeCommunityRepository repo) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [communityRepositoryProvider.overrideWithValue(repo)],
      child: const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: Locale('en'),
        home: BlockedUsersScreen(),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

BlockedUser _blocked(String nickname) => BlockedUser(
  member: PostAuthor(id: '19', nickname: nickname),
  blockedAt: DateTime.utc(2026, 8, 1),
);

void main() {
  testWidgets('차단한 사용자가 목록에 보인다', (WidgetTester tester) async {
    await _pump(
      tester,
      FakeCommunityRepository(
        blockedUsers: <BlockedUser>[_blocked('Blocked One')],
      ),
    );

    expect(find.text('Blocked One'), findsOneWidget);
    expect(find.text('Unblock'), findsOneWidget);
  });

  // 가이드 §6 — 내가 건 차단만 나온다. "안 보이는데 목록에 없다"는 정상이므로
  // 화면이 그 사실을 미리 말한다.
  testWidgets('내가 건 차단만 보인다는 안내가 늘 붙는다', (WidgetTester tester) async {
    await _pump(tester, FakeCommunityRepository());

    expect(find.textContaining('Only blocks you made'), findsOneWidget);
    expect(find.text("You haven't blocked anyone."), findsOneWidget);
  });

  testWidgets('차단 해제를 누르면 뮤테이션이 나간다', (WidgetTester tester) async {
    final FakeCommunityRepository repo = FakeCommunityRepository(
      blockedUsers: <BlockedUser>[_blocked('Blocked One')],
    );
    await _pump(tester, repo);

    await tester.tap(find.text('Unblock'));
    await tester.pumpAndSettle();

    expect(repo.lastUnblockedMemberId, '19');
    expect(find.text('Unblocked.'), findsOneWidget);
  });
}
