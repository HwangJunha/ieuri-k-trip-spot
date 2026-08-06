import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/common/location/location_providers.dart';
import 'package:ieuri_k_trip_spot/domain/community/model/community_chip.dart';
import 'package:ieuri_k_trip_spot/domain/community/model/community_failure.dart';
import 'package:ieuri_k_trip_spot/domain/community/model/post.dart';
import 'package:ieuri_k_trip_spot/domain/community/model/report_reason.dart';
import 'package:ieuri_k_trip_spot/domain/community/model/target_category.dart';
import 'package:ieuri_k_trip_spot/domain/community/provider/community_providers.dart';
import 'package:ieuri_k_trip_spot/domain/community/view/community_screen.dart';
import 'package:ieuri_k_trip_spot/l10n/gen/app_localizations.dart';

import '../../spot/spot_test_doubles.dart';
import '../community_test_doubles.dart';

Future<void> _pump(WidgetTester tester, FakeCommunityRepository repo) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        communityRepositoryProvider.overrideWithValue(repo),
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
  // 사용자가 지정한 카드 배치: 좌상단 카테고리, 굵은 제목, 그 아래 본문.
  testWidgets('카드는 카테고리·제목·본문 순으로 그려진다', (WidgetTester tester) async {
    await _pump(
      tester,
      FakeCommunityRepository(
        posts: <Post>[
          fakePost(
            title: 'Night opening was great',
            body: 'Wear a hanbok and get in free.',
            category: TargetCategory.touristSpot,
          ),
        ],
      ),
    );

    final Finder category = find.text('Attractions');
    final Finder title = find.text('Night opening was great');
    final Finder body = find.text('Wear a hanbok and get in free.');
    expect(category, findsOneWidget);
    expect(title, findsOneWidget);
    expect(body, findsOneWidget);

    // 위계가 위→아래로 서 있어야 한다.
    expect(
      tester.getTopLeft(category).dy,
      lessThan(tester.getTopLeft(title).dy),
    );
    expect(tester.getTopLeft(title).dy, lessThan(tester.getTopLeft(body).dy));
    // 제목은 본문보다 굵다.
    expect(tester.widget<Text>(title).style?.fontWeight, FontWeight.w700);
  });

  // 본문은 잘린다 — 카드 높이가 글 길이에 따라 달라지면 목록 리듬이 깨진다.
  testWidgets('목록 카드의 본문은 잘려서 그려진다', (WidgetTester tester) async {
    await _pump(
      tester,
      FakeCommunityRepository(posts: <Post>[fakePost(body: 'A' * 400)]),
    );

    final Text body = tester.widget<Text>(find.text('A' * 400));
    expect(body.overflow, TextOverflow.ellipsis);
    expect(body.maxLines, isNotNull);
  });

  testWidgets('하단에 좋아요 수와 댓글 수가 보인다', (WidgetTester tester) async {
    await _pump(
      tester,
      FakeCommunityRepository(
        posts: <Post>[fakePost(likeCount: 12, commentCount: 4)],
      ),
    );

    expect(find.text('12'), findsOneWidget);
    expect(find.text('4'), findsOneWidget);
  });

  testWidgets('장소가 있으면 하단에 장소명과 태그가 붙는다', (WidgetTester tester) async {
    await _pump(
      tester,
      FakeCommunityRepository(
        posts: <Post>[
          fakePost(tags: const <String>['야경']),
        ],
      ),
    );

    expect(find.text('Gyeongbokgung'), findsOneWidget);
    // 태그는 사용자가 입력한 원문 그대로다(가이드 §9).
    expect(find.text('#야경'), findsOneWidget);
  });

  // 가이드 §5 — 장소 없는 글이 허용된다. 그 자리를 아예 그리지 않는다.
  testWidgets('장소가 없는 글은 장소명을 그리지 않는다', (WidgetTester tester) async {
    await _pump(
      tester,
      FakeCommunityRepository(posts: <Post>[fakePost(withoutSpot: true)]),
    );

    expect(find.text('Gyeongbokgung'), findsNothing);
    expect(find.text('Night opening was great'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  // 가이드 §5 — 수정 이력은 없고 "수정됨" 표시만 있다.
  testWidgets('수정된 글에는 수정됨 표시가 붙는다', (WidgetTester tester) async {
    await _pump(
      tester,
      FakeCommunityRepository(posts: <Post>[fakePost(edited: true)]),
    );

    expect(find.text('Edited'), findsOneWidget);
  });

  // 신고 누적으로 숨겨진 글은 작성자 본인에게만 내려온다. 배지가 없으면 작성자는
  // 서버 장애로 오해한다(가이드 §6).
  testWidgets('숨겨진 글에는 사유 배지가 붙는다', (WidgetTester tester) async {
    await _pump(
      tester,
      FakeCommunityRepository(posts: <Post>[fakePost(hidden: true)]),
    );

    expect(find.text('Hidden after multiple reports'), findsOneWidget);
  });

  group('⋮ 메뉴 (가이드 §5)', () {
    testWidgets('남의 글에는 신고와 차단이 보인다', (WidgetTester tester) async {
      await _pump(tester, FakeCommunityRepository(posts: <Post>[fakePost()]));

      await tester.tap(find.byIcon(Icons.more_vert).first);
      await tester.pumpAndSettle();

      expect(find.text('Report'), findsOneWidget);
      expect(find.text('Block this user'), findsOneWidget);
      // 남의 글이라 수정·삭제는 없다.
      expect(find.text('Delete post'), findsNothing);
      expect(find.text('Edit post'), findsNothing);
    });

    testWidgets('내 글에는 수정과 삭제가 보인다', (WidgetTester tester) async {
      await _pump(
        tester,
        FakeCommunityRepository(posts: <Post>[fakePost(ownedByViewer: true)]),
      );

      await tester.tap(find.byIcon(Icons.more_vert).first);
      await tester.pumpAndSettle();

      expect(find.text('Edit post'), findsOneWidget);
      expect(find.text('Delete post'), findsOneWidget);
      // 자기 자신은 차단할 수 없다(CANNOT_BLOCK_SELF).
      expect(find.text('Block this user'), findsNothing);
    });

    // 가이드 §5 — 숨겨진 글은 POST_NOT_EDITABLE이다. 눌러서 오류를 보는 것보다
    // 애초에 못 누르는 편이 낫다.
    testWidgets('숨겨진 내 글은 수정이 비활성이고 이유가 보인다', (WidgetTester tester) async {
      await _pump(
        tester,
        FakeCommunityRepository(
          posts: <Post>[fakePost(ownedByViewer: true, hidden: true)],
        ),
      );

      await tester.tap(find.byIcon(Icons.more_vert).first);
      await tester.pumpAndSettle();

      expect(
        tester
            .widget<ListTile>(find.widgetWithText(ListTile, 'Edit post'))
            .enabled,
        isFalse,
      );
      expect(find.text("Hidden posts can't be edited."), findsOneWidget);
    });
  });

  // 가이드 §6 — 차단은 양방향이므로 확인 문구가 그 사실을 말해야 한다.
  testWidgets('차단은 양방향임을 밝히는 확인을 거친다', (WidgetTester tester) async {
    final FakeCommunityRepository repo = FakeCommunityRepository(
      posts: <Post>[fakePost()],
    );
    await _pump(tester, repo);

    await tester.tap(find.byIcon(Icons.more_vert).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Block this user'));
    await tester.pumpAndSettle();

    expect(find.textContaining('both ways'), findsOneWidget);
    // 확인 전에는 뮤테이션이 나가지 않는다.
    expect(repo.lastBlockedMemberId, isNull);

    await tester.tap(find.widgetWithText(FilledButton, 'Block'));
    await tester.pumpAndSettle();

    expect(repo.lastBlockedMemberId, '20');
  });

  testWidgets('신고 시트에서 기타를 고르면 상세가 필수가 된다', (WidgetTester tester) async {
    final FakeCommunityRepository repo = FakeCommunityRepository(
      posts: <Post>[fakePost()],
    );
    await _pump(tester, repo);

    await tester.tap(find.byIcon(Icons.more_vert).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Report').last);
    await tester.pumpAndSettle();

    // 사유를 고르기 전에는 제출할 수 없다.
    expect(
      tester
          .widget<FilledButton>(find.widgetWithText(FilledButton, 'Submit'))
          .onPressed,
      isNull,
    );

    await tester.tap(find.text('Something else'));
    await tester.pumpAndSettle();

    // 기타를 골랐는데 상세가 비어 있으면 여전히 제출할 수 없다 —
    // REPORT_DETAIL_REQUIRED를 왕복 없이 미리 막는다.
    expect(
      tester
          .widget<FilledButton>(find.widgetWithText(FilledButton, 'Submit'))
          .onPressed,
      isNull,
    );

    await tester.enterText(find.byType(TextField), '광고성 글이에요');
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(FilledButton, 'Submit'));
    await tester.pumpAndSettle();

    expect(repo.lastReport?.reason, ReportReason.other);
    expect(repo.lastReport?.detail, '광고성 글이에요');
    expect(find.text('Your report was received.'), findsOneWidget);
  });

  // 가이드 §7 — 재신고는 오류가 아니라 안내다.
  testWidgets('이미 신고한 대상은 오류가 아니라 안내가 뜬다', (WidgetTester tester) async {
    final FakeCommunityRepository repo = FakeCommunityRepository(
      posts: <Post>[fakePost()],
    )..mutationError = CommunityFailure.userError('ALREADY_REPORTED');
    await _pump(tester, repo);

    await tester.tap(find.byIcon(Icons.more_vert).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Report').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Spam or advertising'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Submit'));
    await tester.pumpAndSettle();

    expect(find.text("You've already reported this."), findsOneWidget);
  });

  group('상단 칩 (가이드 §2)', () {
    testWidgets('서버가 준 칩만 그린다', (WidgetTester tester) async {
      await _pump(
        tester,
        FakeCommunityRepository(
          posts: <Post>[fakePost()],
          chips: const <CommunityChip>[
            CommunityChip(category: TargetCategory.restaurant, position: 0),
          ],
        ),
      );

      expect(find.text('All'), findsOneWidget);
      expect(find.text('Food'), findsOneWidget);
      // 서버가 주지 않은 카테고리는 그리지 않는다 — 언어마다 가용 목록이 다르다.
      expect(find.text('Stays'), findsNothing);
    });

    // **빈 목록이 정상이다.** 오류가 아니므로 줄이 비어도 화면이 돈다.
    testWidgets('칩이 비어도 피드는 그대로 보인다', (WidgetTester tester) async {
      await _pump(tester, FakeCommunityRepository(posts: <Post>[fakePost()]));

      expect(find.text('All'), findsNothing);
      expect(find.text('Night opening was great'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('칩을 누르면 그 카테고리로 서버에 다시 조회한다', (WidgetTester tester) async {
      final FakeCommunityRepository repo = FakeCommunityRepository(
        posts: <Post>[fakePost()],
        chips: const <CommunityChip>[
          CommunityChip(category: TargetCategory.restaurant, position: 0),
        ],
      );
      await _pump(tester, repo);

      await tester.tap(find.text('Food'));
      await tester.pumpAndSettle();

      expect(repo.lastFetchPosts?.category, TargetCategory.restaurant);
    });
  });

  testWidgets('글이 없으면 빈 피드 안내가 뜬다', (WidgetTester tester) async {
    await _pump(tester, FakeCommunityRepository());

    expect(find.text('No posts around you yet.'), findsOneWidget);
  });

  // 조회가 실패했을 때 빈 흰 화면이나 무한 스피너가 아니라 **사유와 재시도 수단**이
  // 보여야 한다.
  testWidgets('피드 조회가 실패하면 오류와 재시도 버튼이 보인다', (WidgetTester tester) async {
    await _pump(
      tester,
      FakeCommunityRepository(feedError: CommunityFailure.network),
    );

    expect(find.text("Couldn't load nearby posts"), findsOneWidget);
    expect(find.widgetWithText(FilledButton, 'Retry'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  // 칩과 피드는 서로 다른 provider다 — 피드가 실패해도 칩 줄은 남아 다른 카테고리로
  // 옮겨갈 수 있다.
  testWidgets('피드가 실패해도 칩 줄은 그대로 보인다', (WidgetTester tester) async {
    await _pump(
      tester,
      FakeCommunityRepository(
        feedError: CommunityFailure.network,
        chips: const <CommunityChip>[
          CommunityChip(category: TargetCategory.restaurant, position: 0),
        ],
      ),
    );

    expect(find.text('Food'), findsOneWidget);
    expect(find.text("Couldn't load nearby posts"), findsOneWidget);
  });
}
