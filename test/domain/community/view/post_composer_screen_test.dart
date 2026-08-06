import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/domain/community/model/community_chip.dart';
import 'package:ieuri_k_trip_spot/domain/community/model/community_failure.dart';
import 'package:ieuri_k_trip_spot/domain/community/model/target_category.dart';
import 'package:ieuri_k_trip_spot/domain/community/provider/community_providers.dart';
import 'package:ieuri_k_trip_spot/domain/community/view/post_composer_screen.dart';
import 'package:ieuri_k_trip_spot/l10n/gen/app_localizations.dart';

import '../community_test_doubles.dart';

/// 커뮤니티 탭에서 진입한 컴포저 — 장소가 정해져 있지 않다(가이드 §5: 선택 항목).
Future<void> _pump(
  WidgetTester tester,
  FakeCommunityRepository repo, {
  String? spotId,
  String? spotTitle,
  String? editPostId,
  String? initialTitle,
  String? initialBody,
}) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [communityRepositoryProvider.overrideWithValue(repo)],
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
        home: PostComposerScreen(
          initialSpotId: spotId,
          initialSpotTitle: spotTitle,
          editPostId: editPostId,
          initialTitle: initialTitle,
          initialBody: initialBody,
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

Finder get _submit => find.widgetWithText(TextButton, 'Post');

/// 컴포저는 한 화면보다 길다 — 아래쪽 섹션(태그·장소·사진)을 보려면 스크롤한다.
Future<void> _scrollToBottom(WidgetTester tester) async {
  await tester.drag(find.byType(ListView), const Offset(0, -600));
  await tester.pumpAndSettle();
}

Future<void> _fill(
  WidgetTester tester, {
  String title = '경복궁 야간개장',
  String body = '한복 입고 가면 무료예요',
}) async {
  await tester.tap(find.text('Attractions'));
  await tester.pumpAndSettle();
  await tester.enterText(find.byType(TextField).at(0), title);
  await tester.enterText(find.byType(TextField).at(1), body);
  await tester.pumpAndSettle();
}

void main() {
  group('등록 버튼 활성 조건 (가이드 §5)', () {
    testWidgets('아무것도 안 넣으면 비활성이다', (WidgetTester tester) async {
      await _pump(tester, FakeCommunityRepository());

      expect(tester.widget<TextButton>(_submit).onPressed, isNull);
    });

    testWidgets('카테고리·제목·본문이 갖춰지면 활성이다', (WidgetTester tester) async {
      await _pump(tester, FakeCommunityRepository());
      await _fill(tester);

      expect(tester.widget<TextButton>(_submit).onPressed, isNotNull);
    });

    // 가이드 §5 — 장소는 선택이다. 없어도 등록할 수 있어야 한다.
    testWidgets('장소가 없어도 등록할 수 있다', (WidgetTester tester) async {
      final FakeCommunityRepository repo = FakeCommunityRepository();
      await _pump(tester, repo);
      await _fill(tester);

      await tester.tap(_submit);
      await tester.pumpAndSettle();

      expect(repo.lastCreatePost?.spotId, isNull);
      expect(repo.lastCreatePost?.title, '경복궁 야간개장');
    });

    testWidgets('제목이 비면 비활성이다', (WidgetTester tester) async {
      await _pump(tester, FakeCommunityRepository());
      await _fill(tester, title: '   ');

      expect(tester.widget<TextButton>(_submit).onPressed, isNull);
    });
  });

  group('길이 카운터 — 코드포인트 (가이드 §8)', () {
    testWidgets('제목 카운터가 코드포인트를 센다', (WidgetTester tester) async {
      await _pump(tester, FakeCommunityRepository());

      // 🥲는 UTF-16 코드유닛 2개지만 서버는 1로 센다.
      await tester.enterText(find.byType(TextField).at(0), '🥲');
      await tester.pumpAndSettle();

      expect(find.text('1 / 50'), findsOneWidget);
    });

    testWidgets('본문 카운터가 코드포인트를 센다', (WidgetTester tester) async {
      await _pump(tester, FakeCommunityRepository());

      await tester.enterText(find.byType(TextField).at(1), '🇰🇷');
      await tester.pumpAndSettle();

      // 국기는 코드포인트 2개다 — 서버와 같은 숫자를 보여줘야 한다.
      expect(find.text('2 / 500'), findsOneWidget);
    });

    // 입력을 자르지 않는다 — 붙여넣기한 유저가 무엇이 사라졌는지 모르면 안 된다.
    testWidgets('본문이 500자를 넘으면 초과분을 드러내고 등록을 막는다', (WidgetTester tester) async {
      await _pump(tester, FakeCommunityRepository());
      await _fill(tester, body: 'A' * 503);

      expect(find.text('3 characters over the limit.'), findsOneWidget);
      expect(tester.widget<TextButton>(_submit).onPressed, isNull);
      // 입력은 그대로 남아 있다.
      expect(
        tester.widget<TextField>(find.byType(TextField).at(1)).controller?.text,
        hasLength(503),
      );
    });
  });

  group('카테고리 (가이드 §2)', () {
    testWidgets('서버가 준 칩이 있으면 그것만 고를 수 있다', (WidgetTester tester) async {
      await _pump(
        tester,
        FakeCommunityRepository(
          chips: const <CommunityChip>[
            CommunityChip(category: TargetCategory.restaurant, position: 0),
          ],
        ),
      );

      expect(find.widgetWithText(ChoiceChip, 'Food'), findsOneWidget);
      expect(find.widgetWithText(ChoiceChip, 'Stays'), findsNothing);
    });

    // 카테고리가 필수라 고를 수단이 없으면 글을 아예 쓸 수 없다.
    testWidgets('칩이 비면 전체 카테고리로 떨어진다', (WidgetTester tester) async {
      await _pump(tester, FakeCommunityRepository());

      expect(
        find.byType(ChoiceChip),
        findsNWidgets(TargetCategory.values.length),
      );
    });
  });

  group('태그 (가이드 §5)', () {
    testWidgets('공백이 든 태그는 거부하고 이유를 알린다', (WidgetTester tester) async {
      await _pump(tester, FakeCommunityRepository());

      // 태그 입력은 제목·본문 다음이다.
      await tester.enterText(find.byType(TextField).at(2), '맛집 추천');
      await _scrollToBottom(tester);
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      expect(find.text("Tags can't contain spaces."), findsOneWidget);
      expect(find.text('#맛집 추천'), findsNothing);
    });

    testWidgets('공백 없는 태그는 칩으로 붙는다', (WidgetTester tester) async {
      final FakeCommunityRepository repo = FakeCommunityRepository();
      await _pump(tester, repo);
      await _fill(tester);

      await tester.enterText(find.byType(TextField).at(2), '야간개장');
      await _scrollToBottom(tester);
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      expect(find.text('#야간개장'), findsOneWidget);

      await tester.tap(_submit);
      await tester.pumpAndSettle();

      expect(repo.lastCreatePost?.tags, <String>['야간개장']);
    });
  });

  group('사진', () {
    // 사진 선택 패키지가 아직 없어 기본 picker가 null을 돌려준다. 그때 조용히
    // 아무 일도 없는 것이 아니라 **고를 수 없다는 사실**을 알린다.
    testWidgets('사진 선택 수단이 없으면 그 사실을 알린다', (WidgetTester tester) async {
      await _pump(tester, FakeCommunityRepository());

      await _scrollToBottom(tester);
      await tester.tap(find.text('Add photo'));
      await tester.pumpAndSettle();

      expect(
        find.text('Photo picking is not available in this build.'),
        findsOneWidget,
      );
    });
  });

  group('서버 거부 처리 (가이드 §7)', () {
    testWidgets('제목 길이 위반 코드는 해당 문구로 옮긴다', (WidgetTester tester) async {
      final FakeCommunityRepository repo = FakeCommunityRepository()
        ..mutationError = CommunityFailure.userError(
          'POST_TITLE_LENGTH_INVALID',
        );
      await _pump(tester, repo);
      await _fill(tester);

      await tester.tap(_submit);
      await tester.pumpAndSettle();

      expect(
        find.text('Your title is too long. Keep it under 50 characters.'),
        findsOneWidget,
      );
    });

    testWidgets('모르는 코드는 일반 실패 문구로 떨어진다', (WidgetTester tester) async {
      final FakeCommunityRepository repo = FakeCommunityRepository()
        ..mutationError = CommunityFailure.userError('SOMETHING_NEW');
      await _pump(tester, repo);
      await _fill(tester);

      await tester.tap(_submit);
      await tester.pumpAndSettle();

      expect(
        find.text('Something went wrong. Please try again.'),
        findsOneWidget,
      );
    });
  });

  group('수정 모드 (가이드 §5)', () {
    // 수정은 제목·본문·사진만 바꾼다. 카테고리·태그·장소를 만지게 하면 안 된다 —
    // 서버가 받지 않는 값이다.
    testWidgets('카테고리·태그·장소 입력이 보이지 않는다', (WidgetTester tester) async {
      await _pump(
        tester,
        FakeCommunityRepository(),
        editPostId: '42',
        initialTitle: '원래 제목',
        initialBody: '원래 본문',
      );

      expect(find.text('Edit post'), findsOneWidget);
      expect(find.byType(ChoiceChip), findsNothing);
      expect(find.text('Tags (optional)'), findsNothing);
      expect(find.text('Where'), findsNothing);
    });

    testWidgets('제목·본문을 채워 열고 저장하면 editPost가 나간다', (WidgetTester tester) async {
      final FakeCommunityRepository repo = FakeCommunityRepository();
      await _pump(
        tester,
        repo,
        editPostId: '42',
        initialTitle: '원래 제목',
        initialBody: '원래 본문',
      );

      await tester.enterText(find.byType(TextField).at(0), '새 제목');
      await tester.pumpAndSettle();
      await tester.tap(_submit);
      await tester.pumpAndSettle();

      expect(repo.lastEditPost?.postId, '42');
      expect(repo.lastEditPost?.title, '새 제목');
      expect(repo.lastEditPost?.body, '원래 본문');
      // 사진을 건드리지 않았으면 변수를 보내지 않는다(빈 배열과 다른 뜻이다).
      expect(repo.lastEditPost?.photoKeys, isNull);
    });

    testWidgets('숨겨진 글 수정 거부는 그 이유를 알린다', (WidgetTester tester) async {
      final FakeCommunityRepository repo = FakeCommunityRepository()
        ..mutationError = CommunityFailure.userError('POST_NOT_EDITABLE');
      await _pump(
        tester,
        repo,
        editPostId: '42',
        initialTitle: '원래 제목',
        initialBody: '원래 본문',
      );

      await tester.tap(_submit);
      await tester.pumpAndSettle();

      expect(find.text("Hidden posts can't be edited."), findsOneWidget);
    });
  });
}
