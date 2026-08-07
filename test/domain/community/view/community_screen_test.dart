import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/common/location/location_providers.dart';
import 'package:ieuri_k_trip_spot/common/widget/floating_bottom_nav_scaffold.dart';
import 'package:ieuri_k_trip_spot/domain/community/model/community_chip.dart';
import 'package:ieuri_k_trip_spot/domain/community/model/community_failure.dart';
import 'package:ieuri_k_trip_spot/common/model/post.dart';
import 'package:ieuri_k_trip_spot/domain/community/model/post_sort_order.dart';
import 'package:ieuri_k_trip_spot/domain/community/model/report_reason.dart';
import 'package:ieuri_k_trip_spot/common/model/target_category.dart';
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

  // 서버 `Post.viewCount`가 열려 실제 값이 내려온다 — 클라이언트가 세지 않고
  // 그대로 그린다.
  testWidgets('하단에 조회수가 보인다', (WidgetTester tester) async {
    await _pump(
      tester,
      FakeCommunityRepository(
        posts: <Post>[fakePost(viewCount: 330, likeCount: 12, commentCount: 4)],
      ),
    );

    expect(find.text('330'), findsOneWidget);
    expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);
  });

  // 사용자 요청으로 작성자를 목록에 드러낸다 — 당근이 닉네임을 카드 상단에 두는
  // 자리다.
  testWidgets('카드 상단에 작성자 닉네임이 보인다', (WidgetTester tester) async {
    await _pump(tester, FakeCommunityRepository(posts: <Post>[fakePost()]));

    final Finder nickname = find.text('Traveler');
    expect(nickname, findsOneWidget);
    // 제목보다 위에 있어야 한다.
    expect(
      tester.getTopLeft(nickname).dy,
      lessThan(tester.getTopLeft(find.text('Night opening was great')).dy),
    );
  });

  // 프로필 이미지는 nullable이고 개발 환경에서는 404가 정상이다 — 그래도 줄이
  // 깨지지 않고 첫 글자 아바타로 떨어져야 한다.
  testWidgets('프로필 이미지가 없어도 첫 글자 아바타로 그린다', (WidgetTester tester) async {
    await _pump(tester, FakeCommunityRepository(posts: <Post>[fakePost()]));

    expect(find.widgetWithText(CircleAvatar, 'T'), findsOneWidget);
    expect(tester.takeException(), isNull);
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

  group('당겨서 새로고침', () {
    // 글을 쓰고 돌아온 뒤 목록을 다시 받을 길이 없던 것이 이 화면의 구멍이었다.
    testWidgets('아래로 당기면 피드를 다시 조회한다', (WidgetTester tester) async {
      final FakeCommunityRepository repo = FakeCommunityRepository(
        posts: <Post>[fakePost(title: 'Old post')],
      )..refreshedPosts = <Post>[fakePost(id: 'p9', title: 'Fresh post')];
      await _pump(tester, repo);

      expect(repo.firstPageCalls, 1);
      expect(find.text('Old post'), findsOneWidget);

      await tester.fling(find.byType(ListView), const Offset(0, 400), 1000);
      await tester.pumpAndSettle();

      expect(repo.firstPageCalls, 2);
      expect(find.text('Fresh post'), findsOneWidget);
      expect(find.text('Old post'), findsNothing);
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

  // 셸이 `extendBody: true`라 이 화면의 body가 떠 있는 내비 바 **아래까지** 그려진다.
  // 기본 위치의 FAB은 그 바에 가려지므로, 바를 실제로 붙인 상태에서 글쓰기 버튼이
  // 바 위에 있는지 본다 — 화면만 단독으로 띄우면 이 어긋남이 드러나지 않는다.
  testWidgets('글쓰기 버튼은 하단 내비 바에 가리지 않는다', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          communityRepositoryProvider.overrideWithValue(
            FakeCommunityRepository(),
          ),
          locationServiceProvider.overrideWithValue(FakeLocationService()),
        ],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('en'),
          // 실제 셸과 같은 조건: body가 바 아래까지 그려진다.
          home: Scaffold(
            extendBody: true,
            body: const CommunityScreen(),
            bottomNavigationBar: Container(
              height: FloatingBottomNavScaffold.barExtent,
              color: const Color(0xFF000000),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final double fabBottom = tester
        .getRect(find.byType(FloatingActionButton))
        .bottom;
    final double barTop =
        tester.getRect(find.byType(Scaffold).last).bottom -
        FloatingBottomNavScaffold.barExtent;

    expect(
      fabBottom,
      lessThanOrEqualTo(barTop),
      reason: '글쓰기 버튼 아래끝이 내비 바 윗변보다 위에 있어야 한다',
    );
  });

  // 2차 가이드 §3 — 거리순/최신순 토글.
  group('정렬 토글', () {
    testWidgets('처음에는 최신순으로 조회한다', (WidgetTester tester) async {
      final FakeCommunityRepository repo = FakeCommunityRepository(
        posts: <Post>[fakePost()],
      );
      await _pump(tester, repo);

      expect(find.text('Latest'), findsOneWidget);
      expect(find.text('Nearby'), findsOneWidget);
      expect(repo.lastFetchPosts?.sort, PostSortOrder.latest);
    });

    // **커서를 버리고 첫 페이지부터 다시 조회한다** — 두 정렬의 커서 형식이 달라
    // 이전 커서를 그대로 넘기면 서버가 INVALID_INPUT을 준다.
    testWidgets('거리순으로 바꾸면 커서 없이 새 정렬로 다시 조회한다', (WidgetTester tester) async {
      final FakeCommunityRepository repo =
          FakeCommunityRepository(
              posts: <Post>[fakePost(id: 'p1', title: 'Latest post')],
              hasNextPage: true,
              nextPagePosts: <Post>[fakePost(id: 'p2')],
            )
            ..postsBySort = <PostSortOrder, List<Post>>{
              PostSortOrder.distance: <Post>[
                fakePost(id: 'p9', title: 'Nearby post'),
              ],
            };
      await _pump(tester, repo);

      await tester.tap(find.text('Nearby'));
      await tester.pumpAndSettle();

      expect(repo.lastFetchPosts?.sort, PostSortOrder.distance);
      expect(repo.lastFetchPosts?.after, isNull);
      // 목록도 서버가 준 거리순 결과로 갈린다 — 클라이언트가 다시 세우지 않는다.
      expect(find.text('Nearby post'), findsOneWidget);
      // 거리순 조회는 최신순 커서를 한 번도 재사용하지 않았다.
      expect(
        repo.fetchPostsCalls.where(
          (({PostSortOrder? sort, String? after, bool? hiddenByViewer}) c) =>
              c.sort == PostSortOrder.distance && c.after != null,
        ),
        isEmpty,
      );
    });
  });

  // 2차 가이드 §2 — 게시물 숨기기.
  group('글 숨기기', () {
    testWidgets('남의 글 ⋮ 메뉴에 보인다', (WidgetTester tester) async {
      await _pump(
        tester,
        FakeCommunityRepository(posts: <Post>[fakePost(ownedByViewer: false)]),
      );

      await tester.tap(find.byIcon(Icons.more_vert).first);
      await tester.pumpAndSettle();

      expect(find.text('Hide this post'), findsOneWidget);
      expect(find.text('Block this user'), findsOneWidget);
    });

    // 2차 가이드 §2의 표는 "항상"이라고 적었지만 **내 글에는 두지 않는다** — 내
    // 글을 내 화면에서만 감추는 것은 삭제가 이미 하는 일이라, 두 개를 나란히 두면
    // 무엇이 다른지 알 수 없다. 사용자 피드백에 따른 의도된 이탈이다.
    testWidgets('내 글 ⋮ 메뉴에는 없다 (삭제가 그 자리를 대신한다)', (WidgetTester tester) async {
      await _pump(
        tester,
        FakeCommunityRepository(posts: <Post>[fakePost(ownedByViewer: true)]),
      );

      await tester.tap(find.byIcon(Icons.more_vert).first);
      await tester.pumpAndSettle();

      expect(find.text('Hide this post'), findsNothing);
      expect(find.text('Block this user'), findsNothing);
      // 내 글에 남아야 하는 것은 수정·삭제다.
      expect(find.text('Delete post'), findsOneWidget);
    });

    testWidgets('숨기면 그 글로 hidePost가 나가고 피드를 다시 받는다', (
      WidgetTester tester,
    ) async {
      final FakeCommunityRepository repo = FakeCommunityRepository(
        posts: <Post>[fakePost(id: 'p1', title: 'Goes away')],
      )..refreshedPosts = <Post>[];
      await _pump(tester, repo);

      await tester.tap(find.byIcon(Icons.more_vert).first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Hide this post'));
      await tester.pumpAndSettle();

      expect(repo.lastHiddenPostId, 'p1');
      // **로컬에서 지우는 것이 아니라 서버가 거른 결과를 다시 받는다**(차단과 같은
      // 규약) — 재조회가 실제로 일어났고 그 결과 목록에서 빠졌다.
      expect(repo.firstPageCalls, greaterThan(1));
      expect(find.text('Goes away'), findsNothing);
    });
  });
}
