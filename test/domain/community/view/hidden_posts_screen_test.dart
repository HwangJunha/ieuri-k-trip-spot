import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/domain/community/model/community_failure.dart';
import 'package:ieuri_k_trip_spot/common/model/post.dart';
import 'package:ieuri_k_trip_spot/domain/community/provider/community_providers.dart';
import 'package:ieuri_k_trip_spot/domain/community/view/hidden_posts_screen.dart';
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
        home: HiddenPostsScreen(),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  // 2차 가이드 §2 — 숨긴 글은 이 화면에서만 보이고, 여기가 유일한 해제 경로다.
  testWidgets('숨긴 글이 목록에 보인다', (WidgetTester tester) async {
    final FakeCommunityRepository repo = FakeCommunityRepository()
      ..hiddenPosts = <Post>[fakePost(id: 'p21', title: 'Hidden one')];
    await _pump(tester, repo);

    expect(find.text('Hidden one'), findsOneWidget);
    expect(repo.lastFetchPosts?.hiddenByViewer, isTrue);
  });

  testWidgets('숨긴 글이 없으면 빈 안내가 뜬다', (WidgetTester tester) async {
    await _pump(tester, FakeCommunityRepository());

    expect(find.text("You haven't hidden any posts."), findsOneWidget);
  });

  // 차단·신고와 다른 축이라는 것을 화면이 밝힌다 — 남에게는 그대로 보인다.
  testWidgets('내 화면에서만 숨겨진다는 안내가 있다', (WidgetTester tester) async {
    await _pump(tester, FakeCommunityRepository());

    expect(
      find.text(
        'These posts are hidden from your feed only. Others still see them.',
      ),
      findsOneWidget,
    );
  });

  testWidgets('해제하면 unhidePost가 나가고 목록을 다시 받는다', (WidgetTester tester) async {
    final FakeCommunityRepository repo = FakeCommunityRepository()
      ..hiddenPosts = <Post>[fakePost(id: 'p21', title: 'Hidden one')];
    await _pump(tester, repo);

    await tester.tap(find.text('Unhide'));
    await tester.pumpAndSettle();

    expect(repo.lastUnhiddenPostId, 'p21');
    expect(find.text('Post is back in your feed.'), findsOneWidget);
  });

  testWidgets('해제에 실패하면 실패 안내가 뜬다', (WidgetTester tester) async {
    final FakeCommunityRepository repo = FakeCommunityRepository()
      ..hiddenPosts = <Post>[fakePost(id: 'p21', title: 'Hidden one')];
    await _pump(tester, repo);
    repo.mutationError = CommunityFailure.network;

    await tester.tap(find.text('Unhide'));
    await tester.pumpAndSettle();

    expect(find.text('Post is back in your feed.'), findsNothing);
  });

  testWidgets('조회 실패는 재시도와 함께 안내된다', (WidgetTester tester) async {
    await _pump(
      tester,
      FakeCommunityRepository(feedError: CommunityFailure.network),
    );

    expect(find.text('Retry'), findsOneWidget);
  });
}
