import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/common/model/post.dart';
import 'package:ieuri_k_trip_spot/common/pagination/page.dart';
import 'package:ieuri_k_trip_spot/domain/settings/component/my_post_row.dart';
import 'package:ieuri_k_trip_spot/domain/settings/model/settings_failure.dart';
import 'package:ieuri_k_trip_spot/domain/settings/provider/profile_providers.dart';
import 'package:ieuri_k_trip_spot/domain/settings/view/my_posts_screen.dart';
import 'package:ieuri_k_trip_spot/l10n/gen/app_localizations.dart';

import '../../../common/post_fixtures.dart';
import '../profile_test_doubles.dart';

/// 내가 쓴 글 화면(SPEC-0011 R3) — 사용자가 무엇을 보는지만 본다.

Future<void> _pump(WidgetTester tester, FakeProfileRepository repo) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [profileRepositoryProvider.overrideWithValue(repo)],
      child: const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: Locale('en'),
        home: MyPostsScreen(),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('글이 없으면 빈 상태 안내를 보여준다', (WidgetTester tester) async {
    await _pump(tester, FakeProfileRepository());

    expect(find.text("You haven't written any posts yet"), findsOneWidget);
    expect(find.byType(MyPostRow), findsNothing);
  });

  testWidgets('글이 있으면 제목과 본문을 행으로 그린다', (WidgetTester tester) async {
    await _pump(
      tester,
      FakeProfileRepository(
        pages: <CursorPage<Post>>[
          CursorPage<Post>(
            items: <Post>[
              fakePost(id: 'p1', title: 'Best Bindaetteok in Seoul!'),
            ],
            hasNextPage: false,
          ),
        ],
      ),
    );

    expect(find.text('Best Bindaetteok in Seoul!'), findsOneWidget);
    expect(find.byType(MyPostRow), findsOneWidget);
  });

  testWidgets('카테고리와 장소를 한 줄로 대문자로 보여준다', (WidgetTester tester) async {
    await _pump(
      tester,
      FakeProfileRepository(
        pages: <CursorPage<Post>>[
          CursorPage<Post>(items: <Post>[fakePost()], hasNextPage: false),
        ],
      ),
    );

    // 픽스처의 기본 장소는 Gyeongbokgung, 카테고리는 TOURIST_SPOT이다.
    expect(find.textContaining('GYEONGBOKGUNG'), findsOneWidget);
  });

  testWidgets('조회가 실패하면 안내와 다시 시도를 보여준다', (WidgetTester tester) async {
    await _pump(
      tester,
      FakeProfileRepository()..fetchFailure = SettingsFailure.network,
    );

    expect(find.text('Retry'), findsOneWidget);
    expect(find.byType(MyPostRow), findsNothing);
  });
}
