import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/common/location/location_providers.dart';
import 'package:ieuri_k_trip_spot/domain/community/model/community_failure.dart';
import 'package:ieuri_k_trip_spot/domain/community/model/discovery_tile.dart';
import 'package:ieuri_k_trip_spot/domain/community/model/post.dart';
import 'package:ieuri_k_trip_spot/domain/community/model/post_topic.dart';
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
  testWidgets('피드의 글이 카드로 보인다', (WidgetTester tester) async {
    await _pump(
      tester,
      FakeCommunityRepository(
        posts: <Post>[fakePost(body: 'A nice walk around the palace.')],
      ),
    );

    expect(find.text('Spot Talk'), findsOneWidget);
    expect(find.text('A nice walk around the palace.'), findsOneWidget);
    // 대상 pill은 어느 spot의 글인지 보여준다.
    expect(find.text('Gyeongbokgung'), findsOneWidget);
  });

  testWidgets('글이 없으면 빈 피드 안내가 뜬다', (WidgetTester tester) async {
    await _pump(tester, FakeCommunityRepository());

    expect(find.text('No posts around you yet.'), findsOneWidget);
  });

  // 지금 서버는 커넥션 조회가 통째로 실패한다. 그때 빈 흰 화면이나 무한 스피너가
  // 아니라 **사유와 재시도 수단**이 보여야 한다.
  testWidgets('피드 조회가 실패하면 오류와 재시도 버튼이 보인다', (WidgetTester tester) async {
    await _pump(
      tester,
      FakeCommunityRepository(feedError: CommunityFailure.network),
    );

    expect(find.text("Couldn't load nearby posts"), findsOneWidget);
    expect(find.widgetWithText(FilledButton, 'Retry'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  // 타일과 피드는 서로 다른 provider다 — 피드가 실패해도 타일과 칩은 남는다.
  testWidgets('피드가 실패해도 타일과 주제 칩은 그대로 보인다', (WidgetTester tester) async {
    await _pump(
      tester,
      FakeCommunityRepository(
        feedError: CommunityFailure.network,
        tiles: <DiscoveryTile>[
          const DiscoveryTile(
            id: '5',
            title: 'Travel Tips',
            filterTopic: PostTopic.tip,
          ),
        ],
      ),
    );

    // 타일 제목은 서버 문자열 그대로다 (가이드 §10).
    expect(find.text('Travel Tips'), findsOneWidget);
    expect(find.text('All'), findsOneWidget);
    expect(find.text("Couldn't load nearby posts"), findsOneWidget);
  });

  // 가이드 §15 — 빈 타일 목록은 정상이며 레이아웃이 그 경우를 허용해야 한다.
  testWidgets('타일이 비어도 화면이 정상 동작한다', (WidgetTester tester) async {
    await _pump(tester, FakeCommunityRepository(posts: <Post>[fakePost()]));

    expect(find.text('Nearby'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  // R11-3 — 타일 진입과 칩 선택이 같은 상태를 쓴다. 타일을 누르면 상단 칩이 그
  // 태그로 선택된 것처럼 보인다.
  testWidgets('타일을 누르면 그 태그로 피드가 필터된다 (R11-3)', (WidgetTester tester) async {
    final FakeCommunityRepository repo = FakeCommunityRepository(
      posts: <Post>[fakePost()],
      tiles: <DiscoveryTile>[
        const DiscoveryTile(
          id: '5',
          title: 'Travel Tips',
          filterTopic: PostTopic.tip,
        ),
      ],
    );
    await _pump(tester, repo);

    await tester.tap(find.text('Travel Tips'));
    await tester.pumpAndSettle();

    expect(repo.lastTopic, PostTopic.tip);
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
}
