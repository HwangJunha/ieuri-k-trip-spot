import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/domain/community/component/comment_tile.dart';
import 'package:ieuri_k_trip_spot/domain/community/model/comment.dart';
import 'package:ieuri_k_trip_spot/domain/community/model/community_failure.dart';
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
  testWidgets('제목·본문과 댓글이 보인다', (WidgetTester tester) async {
    await _pump(
      tester,
      FakeCommunityRepository(
        post: fakePost(title: 'A nice walk', body: 'Around the palace.'),
        comments: <Comment>[fakeComment(body: 'Nice!')],
      ),
    );

    expect(find.text('A nice walk'), findsOneWidget);
    expect(find.text('Around the palace.'), findsOneWidget);
    expect(find.text('Nice!'), findsOneWidget);
  });

  // 상세에서는 본문을 자르지 않는다 — 읽으러 들어온 화면이다.
  testWidgets('상세의 본문은 잘리지 않는다', (WidgetTester tester) async {
    await _pump(
      tester,
      FakeCommunityRepository(post: fakePost(body: 'B' * 300)),
    );

    final Text body = tester.widget<Text>(find.text('B' * 300));
    expect(body.maxLines, isNull);
    expect(body.overflow, isNull);
  });

  // 가이드 §6 — commentCount는 서버 값을 그대로 쓴다. 차단 때문에 목록이 더 짧아도
  // 숫자를 다시 계산하지 않는다.
  testWidgets('댓글 수는 목록 길이가 아니라 서버 값을 쓴다', (WidgetTester tester) async {
    await _pump(
      tester,
      FakeCommunityRepository(
        post: fakePost(commentCount: 4),
        comments: <Comment>[fakeComment()],
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

  // 댓글이 루트 쿼리로 갈리면서 얻은 것: **댓글이 실패해도 글 본문은 남는다.**
  testWidgets('댓글 조회가 실패해도 글 본문은 보인다', (WidgetTester tester) async {
    await _pump(
      tester,
      FakeCommunityRepository(
        post: fakePost(title: 'A nice walk'),
        commentsError: CommunityFailure.network,
      ),
    );

    expect(find.text('A nice walk'), findsOneWidget);
    expect(find.text("Comments couldn't be loaded."), findsOneWidget);
  });

  testWidgets('댓글이 없으면 빈 상태 안내가 뜬다', (WidgetTester tester) async {
    await _pump(tester, FakeCommunityRepository(post: fakePost()));

    expect(find.text('No comments yet.'), findsOneWidget);
  });

  group('댓글 작성', () {
    testWidgets('입력 전에는 전송할 수 없다', (WidgetTester tester) async {
      await _pump(tester, FakeCommunityRepository(post: fakePost()));

      expect(
        tester
            .widget<IconButton>(find.widgetWithIcon(IconButton, Icons.send))
            .onPressed,
        isNull,
      );
    });

    testWidgets('본문을 넣고 보내면 서버로 나간다', (WidgetTester tester) async {
      final FakeCommunityRepository repo = FakeCommunityRepository(
        post: fakePost(),
      );
      await _pump(tester, repo);

      await tester.enterText(find.byType(TextField), '좋은 글이네요');
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithIcon(IconButton, Icons.send));
      await tester.pumpAndSettle();

      expect(repo.lastCreateComment?.postId, 'p1');
      expect(repo.lastCreateComment?.body, '좋은 글이네요');
      expect(find.text('Comment posted.'), findsOneWidget);
    });
  });

  group('댓글 ⋮ 메뉴', () {
    testWidgets('내 댓글에는 삭제가 보인다', (WidgetTester tester) async {
      final FakeCommunityRepository repo = FakeCommunityRepository(
        post: fakePost(),
        comments: <Comment>[fakeComment(ownedByViewer: true)],
      );
      await _pump(tester, repo);

      // 앱바(글)와 댓글 타일 둘 다 ⋮ 를 갖는다 — 댓글 타일 쪽을 고른다.
      await tester.tap(
        find.descendant(
          of: find.byType(CommentTile),
          matching: find.byIcon(Icons.more_vert),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Delete comment'), findsOneWidget);

      await tester.tap(find.text('Delete comment'));
      await tester.pumpAndSettle();

      expect(repo.lastDeletedCommentId, 'c1');
    });

    testWidgets('남의 댓글에는 신고가 보인다', (WidgetTester tester) async {
      await _pump(
        tester,
        FakeCommunityRepository(
          post: fakePost(),
          comments: <Comment>[fakeComment()],
        ),
      );

      // 앱바(글)와 댓글 타일 둘 다 ⋮ 를 갖는다 — 댓글 타일 쪽을 고른다.
      await tester.tap(
        find.descendant(
          of: find.byType(CommentTile),
          matching: find.byIcon(Icons.more_vert),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Report comment'), findsOneWidget);
      expect(find.text('Delete comment'), findsNothing);
    });
  });
}
