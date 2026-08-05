import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/common/location/location_providers.dart';
import 'package:ieuri_k_trip_spot/domain/community/model/community_failure.dart';
import 'package:ieuri_k_trip_spot/domain/community/model/post.dart';
import 'package:ieuri_k_trip_spot/domain/community/model/post_topic.dart';
import 'package:ieuri_k_trip_spot/domain/community/provider/community_providers.dart';
import 'package:ieuri_k_trip_spot/domain/community/view/post_composer_screen.dart';
import 'package:ieuri_k_trip_spot/l10n/gen/app_localizations.dart';

import '../../spot/spot_test_doubles.dart';
import '../community_test_doubles.dart';

/// 관광지 상세에서 진입한 컴포저 — 대상이 이미 정해져 있다(디자인 §3).
Future<void> _pump(
  WidgetTester tester,
  FakeCommunityRepository repo, {
  String? targetId = '11094',
  String? targetTitle = 'Gyeongbokgung',
}) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        communityRepositoryProvider.overrideWithValue(repo),
        locationServiceProvider.overrideWithValue(FakeLocationService()),
      ],
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
        home: PostComposerScreen(
          initialTargetId: targetId,
          initialTargetTitle: targetTitle,
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

TextButton _submitButton(WidgetTester tester) =>
    tester.widget<TextButton>(find.widgetWithText(TextButton, 'Post'));

void main() {
  // R1-1 — 서버 검증을 기다렸다 에러를 보여주는 방식이 아니다. 화면이 애초에
  // 잘못된 상태를 만들지 못하게 한다.
  testWidgets('본문·태그가 갖춰지기 전까지 등록 버튼이 비활성이다', (WidgetTester tester) async {
    await _pump(tester, FakeCommunityRepository());

    expect(_submitButton(tester).onPressed, isNull);

    // 태그만 골라도 아직 안 된다.
    await tester.tap(find.text('Tips'));
    await tester.pumpAndSettle();
    expect(_submitButton(tester).onPressed, isNull);

    await tester.enterText(find.byType(TextField), '경복궁은 화요일 휴무예요.');
    await tester.pumpAndSettle();
    expect(_submitButton(tester).onPressed, isNotNull);
  });

  testWidgets('상세에서 진입하면 장소가 이미 채워져 있다', (WidgetTester tester) async {
    await _pump(tester, FakeCommunityRepository());

    expect(find.text('Gyeongbokgung'), findsOneWidget);
    expect(find.text('Select a spot'), findsNothing);
  });

  testWidgets('탭에서 진입하면 장소를 골라야 한다', (WidgetTester tester) async {
    await _pump(
      tester,
      FakeCommunityRepository(),
      targetId: null,
      targetTitle: null,
    );

    expect(find.text('Select a spot'), findsOneWidget);

    await tester.tap(find.text('Tips'));
    await tester.enterText(find.byType(TextField), '본문이 있다.');
    await tester.pumpAndSettle();

    // 본문·태그가 있어도 장소가 없으면 등록할 수 없다.
    expect(_submitButton(tester).onPressed, isNull);
  });

  // 설계 §3 — 입력을 자르는 것이 아니라 등록을 막고 초과분을 드러낸다.
  testWidgets('500자를 넘으면 초과분이 드러나고 등록이 막힌다', (WidgetTester tester) async {
    await _pump(tester, FakeCommunityRepository());

    await tester.tap(find.text('Tips'));
    await tester.enterText(find.byType(TextField), '가' * 503);
    await tester.pumpAndSettle();

    expect(find.text('3 characters over the limit.'), findsOneWidget);
    expect(_submitButton(tester).onPressed, isNull);
    // 입력은 잘리지 않는다.
    expect(
      tester.widget<TextField>(find.byType(TextField)).controller?.text.length,
      503,
    );
  });

  // 가이드 §12 — 서버가 코드포인트로 세므로 카운터도 같은 기준이어야 한다.
  testWidgets('글자 수를 코드포인트로 센다', (WidgetTester tester) async {
    await _pump(tester, FakeCommunityRepository());

    // ZWJ 결합 가족 이모지: 눈에는 1글자, 코드포인트로는 7.
    await tester.enterText(find.byType(TextField), '👨‍👩‍👧‍👦');
    await tester.pumpAndSettle();

    expect(find.text('7 / 500'), findsOneWidget);
  });

  testWidgets('등록하면 서버로 초안이 나가고 안내가 뜬다', (WidgetTester tester) async {
    final FakeCommunityRepository repo = FakeCommunityRepository();
    await _pump(tester, repo);

    await tester.tap(find.text('Tips'));
    await tester.enterText(find.byType(TextField), '경복궁은 화요일 휴무예요.');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Post'));
    await tester.pumpAndSettle();

    expect(repo.lastCreatePost?.targetId, '11094');
    expect(repo.lastCreatePost?.topic, PostTopic.tip);
    expect(repo.lastCreatePost?.body, '경복궁은 화요일 휴무예요.');
    // 사진 업로드는 이번 범위 밖 — 빈 배열로 등록한다.
    expect(repo.lastCreatePost?.photoKeys, isEmpty);
  });

  // 가이드 §7 — 서버 message가 아니라 코드로 화면 문구를 고른다(PII 방지).
  testWidgets('서버 거부 코드가 화면 문구로 옮겨진다', (WidgetTester tester) async {
    final FakeCommunityRepository repo = FakeCommunityRepository()
      ..mutationError = CommunityFailure.userError('SPOT_NOT_FOUND');
    await _pump(tester, repo);

    await tester.tap(find.text('Tips'));
    await tester.enterText(find.byType(TextField), '본문이 있다.');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Post'));
    await tester.pumpAndSettle();

    expect(find.text('That place is no longer available.'), findsOneWidget);
  });

  // 지금 서버는 커넥션 조회가 깨져 있어 이 목록도 실패한다 — 빈 화면이나 무한
  // 스피너가 아니라 사유가 보여야 한다.
  testWidgets('장소 목록 조회가 실패해도 시트가 사유를 보여준다', (WidgetTester tester) async {
    await _pump(
      tester,
      FakeCommunityRepository(feedError: CommunityFailure.network),
      targetId: null,
      targetTitle: null,
    );

    await tester.tap(find.text('Select a spot'));
    await tester.pumpAndSettle();

    expect(find.text("Couldn't load nearby posts"), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('장소 목록에서 고르면 초안에 반영된다', (WidgetTester tester) async {
    await _pump(
      tester,
      FakeCommunityRepository(posts: <Post>[fakePost()]),
      targetId: null,
      targetTitle: null,
    );

    await tester.tap(find.text('Select a spot'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Gyeongbokgung').last);
    await tester.pumpAndSettle();

    expect(find.text('Gyeongbokgung'), findsOneWidget);
    expect(find.text('Select a spot'), findsNothing);
  });
}
