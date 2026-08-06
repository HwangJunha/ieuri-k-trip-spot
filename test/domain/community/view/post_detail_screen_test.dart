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

    // 기본 스낵바는 Scaffold 바닥에 붙는데 그 자리가 곧 댓글 입력줄이라, 안내가
    // 입력창을 덮었다. 떠 있는 형태로 두고 입력줄 위로 올린다.
    testWidgets('완료 안내가 댓글 입력창을 가리지 않는다', (WidgetTester tester) async {
      await _pump(tester, FakeCommunityRepository(post: fakePost()));

      await tester.enterText(find.byType(TextField), '좋은 글이네요');
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithIcon(IconButton, Icons.send));
      await tester.pumpAndSettle();

      final SnackBar bar = tester.widget<SnackBar>(find.byType(SnackBar));
      expect(bar.behavior, SnackBarBehavior.floating);

      // `find.byType(SnackBar)`는 화면 폭을 채우는 애니메이션 래퍼라 실제로 보이는
      // 카드가 아니다 — 안내 문구를 감싼 Material로 눈에 보이는 사각형을 잰다.
      final Rect card = tester.getRect(
        find
            .ancestor(
              of: find.text('Comment posted.'),
              matching: find.byType(Material),
            )
            .first,
      );
      // 카드 아래끝이 입력줄 윗변보다 위에 있어야 겹치지 않는다.
      expect(
        card.bottom,
        lessThanOrEqualTo(tester.getRect(find.byType(TextField)).top),
      );
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

  // 2차 가이드 §1 — 대댓글은 깊이 2단계다.
  group('대댓글', () {
    FakeCommunityRepository withReplies() => FakeCommunityRepository(
      post: fakePost(commentCount: 3),
      comments: <Comment>[
        fakeComment(
          id: 'c1',
          body: 'When does it open?',
          nickname: 'Minji',
          replies: <Comment>[
            fakeComment(
              id: 'c2',
              body: 'Ten and two.',
              nickname: 'Jisoo',
              parentCommentId: 'c1',
            ),
          ],
        ),
        fakeComment(id: 'c9', body: 'Parking is rough.', nickname: 'Minsu'),
      ],
    );

    testWidgets('답글이 부모 아래에 들여쓰여 보인다', (WidgetTester tester) async {
      await _pump(tester, withReplies());

      expect(find.text('When does it open?'), findsOneWidget);
      expect(find.text('Ten and two.'), findsOneWidget);

      final CommentTile parent = tester.widget<CommentTile>(
        find.ancestor(
          of: find.text('When does it open?'),
          matching: find.byType(CommentTile),
        ),
      );
      final CommentTile reply = tester.widget<CommentTile>(
        find.ancestor(
          of: find.text('Ten and two.'),
          matching: find.byType(CommentTile),
        ),
      );
      expect(parent.isReply, isFalse);
      expect(reply.isReply, isTrue);

      // 답글이 부모 바로 아래에 온다 — 목록 끝으로 밀리지 않는다.
      final double parentY = tester
          .getTopLeft(find.text('When does it open?'))
          .dy;
      final double replyY = tester.getTopLeft(find.text('Ten and two.')).dy;
      final double otherY = tester
          .getTopLeft(find.text('Parking is rough.'))
          .dy;
      expect(replyY, greaterThan(parentY));
      expect(replyY, lessThan(otherY));

      // 왼쪽으로 더 들어가 있다.
      expect(
        tester.getTopLeft(find.text('Ten and two.')).dx,
        greaterThan(tester.getTopLeft(find.text('When does it open?')).dx),
      );
    });

    // 답글에 답글을 달면 서버가 최상위 부모로 눕히므로, 버튼을 두면 사용자가 믿은
    // 부모와 실제 부모가 어긋난다.
    testWidgets('답글 달기는 최상위 댓글에만 보인다', (WidgetTester tester) async {
      await _pump(tester, withReplies());

      // 최상위 2건에만 붙는다 — 답글 1건에는 없다.
      expect(find.text('Reply'), findsNWidgets(2));

      final CommentTile reply = tester.widget<CommentTile>(
        find.ancestor(
          of: find.text('Ten and two.'),
          matching: find.byType(CommentTile),
        ),
      );
      expect(reply.onReply, isNull);
    });

    testWidgets('답글을 달면 parentCommentId가 함께 나간다', (WidgetTester tester) async {
      final FakeCommunityRepository repo = withReplies();
      await _pump(tester, repo);

      // 첫 최상위 댓글의 "답글 달기"를 누른다.
      await tester.tap(
        find.descendant(
          of: find.ancestor(
            of: find.text('When does it open?'),
            matching: find.byType(CommentTile),
          ),
          matching: find.text('Reply'),
        ),
      );
      await tester.pumpAndSettle();

      // 누구에게 다는지 밝힌다.
      expect(find.text('Reply to Minji'), findsWidgets);

      await tester.enterText(find.byType(TextField), 'Thanks!');
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.send));
      await tester.pumpAndSettle();

      expect(repo.lastCreateComment?.body, 'Thanks!');
      expect(repo.lastCreateComment?.parentCommentId, 'c1');
    });

    // 부모가 삭제돼도 답글은 남는다 — 서버가 부모 자리를 여전히 내려준다.
    testWidgets('삭제된 부모의 답글도 그려진다', (WidgetTester tester) async {
      await _pump(
        tester,
        FakeCommunityRepository(
          post: fakePost(),
          comments: <Comment>[
            fakeComment(
              id: 'c1',
              body: 'Deleted comment',
              replies: <Comment>[
                fakeComment(
                  id: 'c2',
                  body: 'Still here',
                  parentCommentId: 'c1',
                ),
              ],
            ),
          ],
        ),
      );

      expect(find.text('Still here'), findsOneWidget);
    });
  });
}
