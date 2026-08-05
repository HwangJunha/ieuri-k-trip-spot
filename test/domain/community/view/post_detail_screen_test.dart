import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/domain/community/model/comment.dart';
import 'package:ieuri_k_trip_spot/domain/community/provider/community_providers.dart';
import 'package:ieuri_k_trip_spot/domain/community/view/post_detail_screen.dart';
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
        home: PostDetailScreen(postId: 'p1'),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('본문과 댓글이 보인다', (WidgetTester tester) async {
    await _pump(
      tester,
      FakeCommunityRepository(
        post: fakePost(
          body: 'A nice walk.',
          commentCount: 1,
          comments: <Comment>[fakeComment(body: 'Nice!')],
        ),
      ),
    );

    expect(find.text('A nice walk.'), findsOneWidget);
    expect(find.text('Nice!'), findsOneWidget);
  });

  // 가이드 §6 — commentCount는 서버 값을 그대로 쓴다. 차단 때문에 목록이 더 짧아도
  // 숫자를 다시 계산하지 않는다.
  testWidgets('댓글 수는 목록 길이가 아니라 서버 값을 쓴다', (WidgetTester tester) async {
    await _pump(
      tester,
      FakeCommunityRepository(
        post: fakePost(commentCount: 4, comments: <Comment>[fakeComment()]),
      ),
    );

    expect(find.text('Comments · 4'), findsOneWidget);
  });

  // 가이드 §6 — post(id:)가 null이면 오류가 아니라 "볼 수 없는 글"이다. 다시 조회해도
  // 같은 결과이므로 재시도 버튼을 두지 않는다.
  testWidgets('볼 수 없는 글은 안내만 하고 재시도를 권하지 않는다', (WidgetTester tester) async {
    await _pump(tester, FakeCommunityRepository());

    expect(
      find.text('This post was deleted or is unavailable.'),
      findsOneWidget,
    );
    expect(find.widgetWithText(FilledButton, 'Retry'), findsNothing);
  });

  // 댓글만 못 받은 경우(지금 서버의 커넥션 버그)와 "댓글이 없음"은 다른 상태다.
  testWidgets('댓글을 못 받은 것과 댓글이 없는 것을 구분한다', (WidgetTester tester) async {
    await _pump(tester, FakeCommunityRepository(post: fakePost()));
    expect(find.text("Comments couldn't be loaded."), findsOneWidget);

    await _pump(
      tester,
      FakeCommunityRepository(
        post: fakePost(commentCount: 0, comments: const <Comment>[]),
      ),
    );
    expect(find.text('No comments yet.'), findsOneWidget);
  });
}
