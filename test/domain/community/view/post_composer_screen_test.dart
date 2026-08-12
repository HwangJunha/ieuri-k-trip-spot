import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/common/location/coordinates.dart';
import 'package:ieuri_k_trip_spot/common/location/location_providers.dart';
import 'package:ieuri_k_trip_spot/common/location/location_service.dart';
import 'package:ieuri_k_trip_spot/domain/community/component/post_photo.dart';
import 'package:ieuri_k_trip_spot/domain/community/model/community_chip.dart';
import 'package:ieuri_k_trip_spot/domain/community/model/community_failure.dart';
import 'package:ieuri_k_trip_spot/common/model/composer_photo.dart';
import 'package:ieuri_k_trip_spot/domain/community/model/nearby_spot.dart';
import 'package:ieuri_k_trip_spot/domain/community/model/nearby_spot_category.dart';
import 'package:ieuri_k_trip_spot/domain/community/model/post_draft.dart';
import 'package:ieuri_k_trip_spot/common/model/post_image_upload.dart';
import 'package:ieuri_k_trip_spot/common/model/target_category.dart';
import 'package:ieuri_k_trip_spot/domain/community/provider/community_providers.dart';
import 'package:ieuri_k_trip_spot/domain/community/provider/photo_picker_providers.dart';
import 'package:ieuri_k_trip_spot/domain/community/view/post_composer_screen.dart';
import 'package:ieuri_k_trip_spot/l10n/gen/app_localizations.dart';

import '../community_test_doubles.dart';

/// 좌표를 정해 주는 [LocationService]. 장소 선택 시트가 `spots`를 부르려면 좌표가
/// 있어야 한다 — 실제 GPS를 타지 않도록 항상 오버라이드한다.
class _FakeLocationService implements LocationService {
  _FakeLocationService([this.error]);

  final Object? error;

  @override
  Future<Coordinates> currentCoordinates() async {
    if (error != null) throw error!;
    return const Coordinates(latitude: 37.5665, longitude: 126.9780);
  }

  /// 컴포저는 좌표를 한 번만 쓴다 — 실시간 스트림은 지도 화면 전용이라 여기서는
  /// 같은 값을 한 번 흘리는 것으로 족하다.
  @override
  Stream<Coordinates> watchCoordinates() async* {
    if (error != null) throw error!;
    yield const Coordinates(latitude: 37.5665, longitude: 126.9780);
  }
}

/// 커뮤니티 탭에서 진입한 컴포저 — 장소가 정해져 있지 않다(가이드 §5: 선택 항목).
Future<void> _pump(
  WidgetTester tester,
  FakeCommunityRepository repo, {
  String? spotId,
  String? spotTitle,
  String? editPostId,
  PhotoPicker? picker,
  Object? locationError,
}) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        communityRepositoryProvider.overrideWithValue(repo),
        locationServiceProvider.overrideWithValue(
          _FakeLocationService(locationError),
        ),
        // 실제 picker는 갤러리를 연다 — 테스트는 항상 override한다.
        if (picker != null) photoPickerProvider.overrideWithValue(picker),
      ],
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
        // **컴포저를 최상위 화면으로 두지 않는다.** 등록에 성공하면 화면이 스스로
        // 닫히는데(pop), 밑에 아무 라우트도 없으면 트리가 통째로 사라져 그 직후
        // 띄우는 안내(스낵바)를 검증할 수 없다. 실제 앱에서도 컴포저는 피드 위에
        // 얹히므로 이 배치가 실제와 같다.
        home: Scaffold(
          body: Builder(
            builder: (BuildContext context) => TextButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => PostComposerScreen(
                    initialSpotId: spotId,
                    initialSpotTitle: spotTitle,
                    editPostId: editPostId,
                  ),
                ),
              ),
              child: const Text('open composer'),
            ),
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
  await tester.tap(find.text('open composer'));
  await tester.pumpAndSettle();
}

Finder get _submit => find.widgetWithText(TextButton, 'Post');

/// 제목·본문 입력. 화면 가득 쓰는 배치라 둘 다 처음부터 보인다.
Finder get _titleField => find.byType(TextField).at(0);
Finder get _bodyField => find.byType(TextField).at(1);

Future<void> _fill(
  WidgetTester tester, {
  String title = '경복궁 야간개장',
  String body = '한복 입고 가면 무료예요',
}) async {
  await tester.tap(find.text('Attractions'));
  await tester.pumpAndSettle();
  await tester.enterText(_titleField, title);
  await tester.enterText(_bodyField, body);
  await tester.pumpAndSettle();
}

/// 하단 액션 바의 태그 시트를 연다.
Future<void> _openTagSheet(WidgetTester tester) async {
  await tester.tap(find.widgetWithText(TextButton, 'Tags').first);
  await tester.pumpAndSettle();
}

/// 하단 액션 바의 장소 선택 시트를 연다.
Future<void> _openSpotSheet(WidgetTester tester) async {
  await tester.tap(find.widgetWithIcon(TextButton, Icons.place_outlined));
  await tester.pumpAndSettle();
}

NearbySpot _spot({
  String id = '11915',
  String title = '서울갤러리',
  double distanceMeters = 16,
}) => NearbySpot(id: id, title: title, distanceMeters: distanceMeters);

/// 방금 고른 사진 한 장. 이름이 곧 식별자다.
LocalPhoto _local(String name, {int bytes = 3}) => LocalPhoto(
  id: name,
  // 1x1 PNG. `Image.memory`가 실제로 디코드하므로 아무 바이트나 주면 안 된다.
  bytes: bytes == 3 ? _onePixelPng : Uint8List(bytes),
  contentType: 'image/png',
  name: name,
);

/// 가장 작은 유효 PNG 한 장(1×1 투명). 위젯이 로컬 미리보기를 실제로 디코드한다.
final Uint8List _onePixelPng = Uint8List.fromList(<int>[
  0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, //
  0x00, 0x00, 0x00, 0x0D, 0x49, 0x48, 0x44, 0x52,
  0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01,
  0x08, 0x06, 0x00, 0x00, 0x00, 0x1F, 0x15, 0xC4,
  0x89, 0x00, 0x00, 0x00, 0x0A, 0x49, 0x44, 0x41,
  0x54, 0x78, 0x9C, 0x63, 0x00, 0x01, 0x00, 0x00,
  0x05, 0x00, 0x01, 0x0D, 0x0A, 0x2D, 0xB4, 0x00,
  0x00, 0x00, 0x00, 0x49, 0x45, 0x4E, 0x44, 0xAE,
  0x42, 0x60, 0x82,
]);

/// 고른 사진을 정해 주는 picker. 실제 picker는 갤러리를 연다.
PhotoPicker _picker(List<LocalPhoto> photos) =>
    ({required int limit}) async => photos;

/// 하단 액션 바의 사진 버튼을 눌러 고른다.
Future<void> _pickPhotos(WidgetTester tester) async {
  await tester.tap(find.widgetWithText(TextButton, 'Photos'));
  await tester.pumpAndSettle();
}

/// 등록을 누르고 **스낵바가 살아 있는 동안** 멈춘다.
///
/// `pumpAndSettle`은 스낵바의 4초 표시 시간까지 흘려보내 문구를 지운다 — 등록 성공
/// 안내를 검증하려면 그 전에 멈춰야 한다.
Future<void> _tapSubmitAndHoldToast(WidgetTester tester) async {
  await tester.tap(_submit);
  // 업로드·등록의 비동기 완결(pump 한 번) + 스낵바 등장 애니메이션.
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 500));
}

PostImageUploadUrl _url(int n) => PostImageUploadUrl(
  uploadUrl: 'https://storage/$n',
  objectKey: 'pending/20/$n',
  expiresAt: 'x',
);

/// 수정 모드가 조회할 글을 세운 저장소. 수정 컴포저는 라우트 파라미터가 아니라
/// `post(id:)`로 제목·본문·**사진 키·카테고리·태그·장소**를 받아 채운다.
FakeCommunityRepository _editRepo({
  List<String> photoKeys = const <String>[],
  TargetCategory? category = TargetCategory.touristSpot,
  List<String> tags = const <String>[],
  bool withoutSpot = false,
}) => FakeCommunityRepository()
  ..postById = fakePost(
    id: '42',
    title: '원래 제목',
    body: '원래 본문',
    ownedByViewer: true,
    photoKeys: photoKeys,
    category: category,
    tags: tags,
    withoutSpot: withoutSpot,
  );

/// 카테고리 칩 줄의 스크롤러. 아홉 개를 가로 스크롤 [ListView]로 두므로 뒤쪽 칩은
/// 스크롤하기 전까지 **만들어지지도 않는다**(lazy build).
Finder get _categoryStrip => find
    .descendant(
      of: find.byType(PostComposerScreen),
      matching: find.byType(Scrollable),
    )
    .first;

/// 시트 **안의** 카테고리 칩. 컴포저 화면 자체도 글 카테고리를 `ChoiceChip`으로
/// 그리므로, 시트 밖의 칩과 섞이지 않도록 [BottomSheet] 아래로 범위를 좁힌다.
Finder _sheetChips([String? label]) => find.descendant(
  of: find.byType(BottomSheet),
  matching: label == null
      ? find.byType(ChoiceChip)
      : find.widgetWithText(ChoiceChip, label),
);

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

    // 위치를 못 얻어 주변 장소를 못 부르는 상황에서도 등록이 막히면 안 된다.
    testWidgets('위치를 못 얻어도 장소 없이 등록된다', (WidgetTester tester) async {
      final FakeCommunityRepository repo = FakeCommunityRepository();
      await _pump(
        tester,
        repo,
        locationError: const LocationUnavailable(
          LocationUnavailableReason.permissionDenied,
        ),
      );
      await _fill(tester);

      await tester.tap(_submit);
      await tester.pumpAndSettle();

      expect(repo.lastCreatePost?.spotId, isNull);
      expect(repo.lastCreatePost?.body, '한복 입고 가면 무료예요');
    });

    testWidgets('제목이 비면 비활성이다', (WidgetTester tester) async {
      await _pump(tester, FakeCommunityRepository());
      await _fill(tester, title: '   ');

      expect(tester.widget<TextButton>(_submit).onPressed, isNull);
    });
  });

  group('본문 입력 영역', () {
    // 짧은 상자가 아니라 **남은 높이를 전부 채운다** — 컴포저가 답답해 보이던 원인이
    // 이것이었다.
    testWidgets('본문은 남은 세로 공간을 채운다', (WidgetTester tester) async {
      await _pump(tester, FakeCommunityRepository());

      final TextField body = tester.widget<TextField>(_bodyField);
      expect(body.expands, isTrue);
      expect(body.maxLines, isNull);

      // 고정된 짧은 높이가 아니라 화면 대부분을 차지한다.
      final double bodyHeight = tester.getSize(_bodyField).height;
      final double screenHeight = tester.getSize(find.byType(Scaffold)).height;
      expect(bodyHeight, greaterThan(screenHeight * 0.4));
    });

    // 테두리 있는 상자를 걷어 내는 것이 이 재설계의 요지다.
    testWidgets('제목·본문에 테두리가 없다', (WidgetTester tester) async {
      await _pump(tester, FakeCommunityRepository());

      expect(
        tester.widget<TextField>(_titleField).decoration?.border,
        InputBorder.none,
      );
      expect(
        tester.widget<TextField>(_bodyField).decoration?.border,
        InputBorder.none,
      );
    });
  });

  group('길이 카운터 — 코드포인트 (가이드 §8)', () {
    // 카운터는 한계 근처에서만 드러난다. 그래도 세는 단위는 코드포인트여야 한다 —
    // `String.length`로 세면 서버와 숫자가 어긋난다.
    testWidgets('제목 카운터가 코드포인트를 센다', (WidgetTester tester) async {
      await _pump(tester, FakeCommunityRepository());

      // 🥲는 UTF-16 코드유닛 2개지만 서버는 1로 센다. 45자 + 🥲 = 46 코드포인트.
      await tester.enterText(_titleField, '${'A' * 45}🥲');
      await tester.pumpAndSettle();

      expect(find.text('46 / 50'), findsOneWidget);
    });

    testWidgets('본문 카운터가 코드포인트를 센다', (WidgetTester tester) async {
      await _pump(tester, FakeCommunityRepository());

      // 국기는 코드포인트 2개다 — 서버와 같은 숫자를 보여줘야 한다.
      await tester.enterText(_bodyField, '${'A' * 450}🇰🇷');
      await tester.pumpAndSettle();

      expect(find.text('452 / 500'), findsOneWidget);
    });

    // 평소에는 조용하다 — 500자 중 12자를 쓴 사람에게 분량을 재촉할 이유가 없다.
    testWidgets('한계에서 멀면 카운터를 감춘다', (WidgetTester tester) async {
      await _pump(tester, FakeCommunityRepository());
      await _fill(tester);

      expect(find.textContaining('/ 500'), findsNothing);
      expect(find.textContaining('/ 50'), findsNothing);
    });

    // 입력을 자르지 않는다 — 붙여넣기한 유저가 무엇이 사라졌는지 모르면 안 된다.
    testWidgets('본문이 500자를 넘으면 초과분을 드러내고 등록을 막는다', (WidgetTester tester) async {
      await _pump(tester, FakeCommunityRepository());
      await _fill(tester, body: 'A' * 503);

      expect(find.text('3 characters over the limit.'), findsOneWidget);
      expect(tester.widget<TextButton>(_submit).onPressed, isNull);
      // 입력은 그대로 남아 있다.
      expect(
        tester.widget<TextField>(_bodyField).controller?.text,
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

      // 한 줄 가로 스크롤이라 전부가 동시에 그려지지는 않는다 — 몇 개는 보여야 한다.
      expect(find.byType(ChoiceChip), findsWidgets);
      expect(find.widgetWithText(ChoiceChip, 'Attractions'), findsOneWidget);
    });
  });

  group('태그 (가이드 §5)', () {
    testWidgets('공백이 든 태그는 거부하고 이유를 알린다', (WidgetTester tester) async {
      await _pump(tester, FakeCommunityRepository());

      await _openTagSheet(tester);
      await tester.enterText(find.byType(TextField).last, '맛집 추천');
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      expect(find.text("Tags can't contain spaces."), findsOneWidget);
      expect(find.text('#맛집 추천'), findsNothing);
    });

    testWidgets('공백 없는 태그는 칩으로 붙어 등록에 실린다', (WidgetTester tester) async {
      final FakeCommunityRepository repo = FakeCommunityRepository();
      await _pump(tester, repo);
      await _fill(tester);

      await _openTagSheet(tester);
      await tester.enterText(find.byType(TextField).last, '야간개장');
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();
      // 시트를 닫아도 붙은 태그가 화면에 남아야 뺄 수 있다.
      await tester.tap(find.widgetWithText(FilledButton, 'Done'));
      await tester.pumpAndSettle();

      expect(find.text('#야간개장'), findsOneWidget);

      await tester.tap(_submit);
      await tester.pumpAndSettle();

      expect(repo.lastCreatePost?.tags, <String>['야간개장']);
    });
  });

  group('장소 선택 시트', () {
    // 이 화면의 버그였던 지점 — 고를 수단이 아예 없어 장소 칸이 영영 비어 있었다.
    testWidgets('주변 장소를 가까운 순으로 보여주고 고르면 초안에 붙는다', (WidgetTester tester) async {
      final FakeCommunityRepository repo = FakeCommunityRepository()
        ..nearbySpots = <NearbySpot>[
          _spot(id: '11915', title: '서울갤러리', distanceMeters: 16),
          _spot(id: '11094', title: '경복궁', distanceMeters: 1200),
        ];
      await _pump(tester, repo);
      await _fill(tester);

      await _openSpotSheet(tester);
      expect(find.text('서울갤러리'), findsOneWidget);
      // 1km 미만은 미터, 그 이상은 킬로미터로 읽힌다.
      expect(find.text('16 m'), findsOneWidget);
      expect(find.text('1.2 km'), findsOneWidget);

      await tester.tap(find.text('경복궁'));
      await tester.pumpAndSettle();

      // 고른 장소가 하단 바에 드러나고 등록에 실린다.
      expect(find.text('경복궁'), findsOneWidget);
      await tester.tap(_submit);
      await tester.pumpAndSettle();
      expect(repo.lastCreatePost?.spotId, '11094');
    });

    // SPEC-0013 R14 — 검색어를 넣으면 서버가 찾은 결과로 갈아 끼운다.
    testWidgets('AC-14.1 · 검색어를 넣으면 서버 검색 결과를 보여준다', (
      WidgetTester tester,
    ) async {
      final FakeCommunityRepository repo = FakeCommunityRepository()
        // 주변 목록에 '경복궁'은 없다 — 클라이언트 필터였다면 아무것도 안 나온다.
        ..nearbySpots = <NearbySpot>[_spot(id: '1', title: '서울갤러리')]
        ..searchResults = <NearbySpot>[_spot(id: '2', title: '경복궁')];
      await _pump(tester, repo);

      await _openSpotSheet(tester);
      await tester.enterText(find.byType(TextField).last, '경복');
      // **제출해야 검색이 나간다** — 한 글자마다 서버를 부르지 않는다.
      await tester.testTextInput.receiveAction(TextInputAction.search);
      await tester.pumpAndSettle();

      expect(repo.lastSearchQuery, '경복');
      expect(find.text('경복궁'), findsOneWidget);
      expect(find.text('서울갤러리'), findsNothing);
    });

    testWidgets('AC-14.3 · 검색어를 지우면 주변 목록으로 돌아온다', (WidgetTester tester) async {
      final FakeCommunityRepository repo = FakeCommunityRepository()
        ..nearbySpots = <NearbySpot>[_spot(id: '1', title: '서울갤러리')]
        ..searchResults = <NearbySpot>[_spot(id: '2', title: '경복궁')];
      await _pump(tester, repo);

      await _openSpotSheet(tester);
      await tester.enterText(find.byType(TextField).last, '경복');
      await tester.testTextInput.receiveAction(TextInputAction.search);
      await tester.pumpAndSettle();
      // 지우는 것은 제출 없이 즉시 반영된다 — 서버를 부르지 않는 방향이라.
      await tester.enterText(find.byType(TextField).last, '');
      await tester.pumpAndSettle();

      expect(find.text('서울갤러리'), findsOneWidget);
      expect(find.text('경복궁'), findsNothing);
    });

    // 빈 시트나 무한 스피너로 두지 않는다 — 사유와 재시도를 함께 보여준다.
    testWidgets('위치를 못 얻으면 사유와 재시도를 보여준다', (WidgetTester tester) async {
      await _pump(
        tester,
        FakeCommunityRepository(),
        locationError: const LocationUnavailable(
          LocationUnavailableReason.serviceDisabled,
        ),
      );

      await _openSpotSheet(tester);

      expect(
        find.textContaining("nearby places can't be listed"),
        findsOneWidget,
      );
      expect(find.widgetWithText(FilledButton, 'Retry'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    // 장소는 선택 항목이라 뗄 수단이 반드시 있어야 한다(가이드 §5).
    //
    // 시트 안의 "장소 없이" 항목을 걷어 냈으므로 **해제는 하단 바의 지우기 버튼이
    // 맡는다** — 검증하는 인수 기준(붙인 장소를 뗄 수 있다)은 그대로다.
    testWidgets('지우기 버튼을 누르면 붙어 있던 장소가 떨어진다', (WidgetTester tester) async {
      final FakeCommunityRepository repo = FakeCommunityRepository()
        ..nearbySpots = <NearbySpot>[_spot(id: '11094', title: '경복궁')];
      await _pump(tester, repo);
      await _fill(tester);

      await _openSpotSheet(tester);
      await tester.tap(find.text('경복궁'));
      await tester.pumpAndSettle();
      expect(find.text('경복궁'), findsOneWidget);

      await tester.tap(find.byTooltip('Remove place'));
      await tester.pumpAndSettle();

      await tester.tap(_submit);
      await tester.pumpAndSettle();
      expect(repo.lastCreatePost?.spotId, isNull);
    });

    // 붙은 장소가 없으면 지울 것도 없다 — 버튼이 늘 떠 있으면 무엇을 지우는지
    // 알 수 없다.
    testWidgets('장소가 없으면 지우기 버튼이 없다', (WidgetTester tester) async {
      await _pump(tester, FakeCommunityRepository());

      expect(find.byTooltip('Remove place'), findsNothing);
    });

    // 시트는 고르는 곳이지 해제하는 곳이 아니다 — 목록에 "장소 없음"을 섞으면
    // 그것이 장소인 것처럼 읽힌다.
    testWidgets('시트에는 "장소 없이" 항목이 없다', (WidgetTester tester) async {
      final FakeCommunityRepository repo = FakeCommunityRepository()
        ..nearbySpots = <NearbySpot>[_spot(title: '경복궁')];
      await _pump(tester, repo);

      await _openSpotSheet(tester);

      expect(find.text('No place'), findsNothing);
      expect(find.text('경복궁'), findsOneWidget);
    });

    // 서버에 이름 검색 인자가 없다는 설명 문구는 걷어 냈다 — 칩 줄과 검색 칸의
    // 간격으로 두 필터가 다르다는 것을 드러낸다.
    testWidgets('검색 칸 아래 설명 문구가 없다', (WidgetTester tester) async {
      final FakeCommunityRepository repo = FakeCommunityRepository()
        ..nearbySpots = <NearbySpot>[_spot(title: '경복궁')];
      await _pump(tester, repo);

      await _openSpotSheet(tester);

      expect(find.textContaining('not all places'), findsNothing);
    });

    // 장소 상세에서 진입하면 그 화면의 글이라는 것이 전제라 바꿀 수 없다.
    testWidgets('상세에서 진입해 고정된 장소는 시트를 열 수 없다', (WidgetTester tester) async {
      await _pump(
        tester,
        FakeCommunityRepository(),
        spotId: '11094',
        spotTitle: '경복궁',
      );

      final Finder spotButton = find.widgetWithIcon(
        TextButton,
        Icons.place_outlined,
      );
      expect(tester.widget<TextButton>(spotButton).onPressed, isNull);
    });
  });

  group('사진', () {
    // 10 MiB를 넘는 장은 **고른 직후 거른다.** 업로드를 등록 시점으로 미뤄도 이
    // 검사는 여기 남는다 — 사용자는 글을 다 쓰고 나서가 아니라 그 자리에서 알아야
    // 한다. 서버 쪽 이유도 그대로다: 하나만 어긋나도 1단계가 전부 거부한다(가이드 §4).
    testWidgets('10MiB를 넘는 사진은 제외하고 그 사실을 알린다', (WidgetTester tester) async {
      await _pump(
        tester,
        FakeCommunityRepository(),
        picker: _picker(<LocalPhoto>[
          _local('huge.jpg', bytes: maxPostPhotoBytes + 1),
        ]),
      );

      await _pickPhotos(tester);

      expect(find.text('1 photo was too large (max 10MB).'), findsOneWidget);
    });

    // 미지원 형식은 picker가 걸러 아예 목록에 들어오지 않는다(§4). 화면은 빈 결과를
    // 조용히 받는다 — 이 검사도 **고르는 자리**에 남아 있다.
    testWidgets('미지원 형식만 골랐으면 아무것도 붙지 않는다', (WidgetTester tester) async {
      final FakeCommunityRepository repo = FakeCommunityRepository();
      await _pump(tester, repo, picker: _picker(const <LocalPhoto>[]));

      await _pickPhotos(tester);

      expect(find.byType(Image), findsNothing);
      expect(repo.uploadUrlCalls, isEmpty);
    });

    // 이 기능의 요지 — 고르는 것만으로는 **한 바이트도 나가지 않는다.**
    testWidgets('사진을 골라도 업로드 호출이 나가지 않고 미리보기만 뜬다', (WidgetTester tester) async {
      final FakeCommunityRepository repo = FakeCommunityRepository();
      await _pump(
        tester,
        repo,
        picker: _picker(<LocalPhoto>[_local('a.png'), _local('b.png')]),
      );

      await _pickPhotos(tester);

      expect(repo.uploadUrlCalls, isEmpty);
      expect(repo.uploadedUrls, isEmpty);
      expect(repo.confirmCalls, isEmpty);
      // 손에 든 바이트로 그린다 — CDN을 타지 않는다.
      expect(find.byType(PostPhoto), findsNothing);
      expect(find.byType(Image), findsNWidgets(2));
    });

    // 올린 적이 없으니 지울 오브젝트도 없다.
    testWidgets('등록 전에 뺀 사진은 아무 호출도 남기지 않는다', (WidgetTester tester) async {
      final FakeCommunityRepository repo = FakeCommunityRepository();
      await _pump(tester, repo, picker: _picker(<LocalPhoto>[_local('a.png')]));

      await _pickPhotos(tester);
      await tester.tap(find.byIcon(Icons.cancel).first);
      await tester.pumpAndSettle();

      expect(find.byType(Image), findsNothing);
      expect(repo.uploadUrlCalls, isEmpty);
      expect(repo.lastDeletedImageKey, isNull);
    });

    // 업로드가 등록 안으로 들어왔으므로 **진행 표시와 중복 방지가 그 구간까지
    // 덮어야 한다.** 안 덮으면 업로드가 도는 몇 초 동안 버튼이 멀쩡히 눌려 같은 글이
    // 두 번 올라간다.
    testWidgets('업로드가 도는 동안 등록 버튼이 스피너로 바뀌어 다시 눌리지 않는다', (
      WidgetTester tester,
    ) async {
      final Completer<void> gate = Completer<void>();
      final FakeCommunityRepository repo = FakeCommunityRepository()
        ..uploadGate = gate.future
        ..uploadUrls = <PostImageUploadUrl>[_url(1)]
        ..confirmation = const PostImageConfirmation(
          confirmed: <String>['images/20/1'],
        );
      await _pump(tester, repo, picker: _picker(<LocalPhoto>[_local('a.png')]));
      await _fill(tester);
      await _pickPhotos(tester);

      await tester.tap(_submit);
      await tester.pump();

      // 업로드가 아직 안 끝났다 — 버튼 자리에 진행 표시가 서 있다.
      expect(repo.uploadUrlCalls, hasLength(1));
      expect(_submit, findsNothing);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      gate.complete();
      await tester.pumpAndSettle();

      // 발급은 딱 한 번만 나갔고 글도 한 번만 만들어졌다.
      expect(repo.uploadUrlCalls, hasLength(1));
      expect(repo.lastCreatePost?.photoKeys, <String>['images/20/1']);
    });

    testWidgets('등록을 누르면 그때 올리고 확정 키로 글이 만들어진다', (WidgetTester tester) async {
      final FakeCommunityRepository repo = FakeCommunityRepository()
        ..uploadUrls = <PostImageUploadUrl>[_url(1)]
        ..confirmation = const PostImageConfirmation(
          confirmed: <String>['images/20/1'],
        );
      await _pump(tester, repo, picker: _picker(<LocalPhoto>[_local('a.png')]));
      await _fill(tester);

      await _pickPhotos(tester);
      expect(repo.uploadUrlCalls, isEmpty);

      await tester.tap(_submit);
      await tester.pumpAndSettle();

      expect(repo.uploadUrlCalls, hasLength(1));
      expect(repo.uploadedUrls, <String>['https://storage/1']);
      expect(repo.lastCreatePost?.photoKeys, <String>['images/20/1']);
    });

    // 사용자가 정한 정책 — **사진 때문에 글을 버리지 않는다.**
    testWidgets('한 장이 실패해도 글은 등록되고 실패만 알린다', (WidgetTester tester) async {
      final FakeCommunityRepository repo = FakeCommunityRepository()
        ..uploadUrls = <PostImageUploadUrl>[_url(1), _url(2)]
        ..failingUploadUrls = <String>{'https://storage/2'}
        ..confirmation = const PostImageConfirmation(
          confirmed: <String>['images/20/1'],
        );
      await _pump(
        tester,
        repo,
        picker: _picker(<LocalPhoto>[_local('a.png'), _local('b.png')]),
      );
      await _fill(tester);

      await _pickPhotos(tester);
      await _tapSubmitAndHoldToast(tester);

      expect(repo.lastCreatePost?.photoKeys, <String>['images/20/1']);
      expect(
        find.text("Your post is up, but 1 photo couldn't be uploaded."),
        findsOneWidget,
      );
    });

    // 사진은 선택 항목이다(가이드 §5) — 전부 실패해도 글은 올라간다.
    testWidgets('전부 실패해도 사진 없이 글은 등록된다', (WidgetTester tester) async {
      // uploadUrls를 비워 두면 1단계 "전부 거부"다(가이드 §4).
      final FakeCommunityRepository repo = FakeCommunityRepository();
      await _pump(
        tester,
        repo,
        picker: _picker(<LocalPhoto>[_local('a.png'), _local('b.png')]),
      );
      await _fill(tester);

      await _pickPhotos(tester);
      await _tapSubmitAndHoldToast(tester);

      expect(repo.lastCreatePost, isNotNull);
      expect(repo.lastCreatePost?.photoKeys, isEmpty);
      expect(
        find.text("Your post is up, but 2 photos couldn't be uploaded."),
        findsOneWidget,
      );
    });

    // 사용자가 갤러리에서 취소하면 **아무 안내도 하지 않는다** — 스스로 한 일이라
    // 토스트가 뜨면 오히려 오류로 읽힌다.
    testWidgets('선택을 취소하면 조용히 돌아온다', (WidgetTester tester) async {
      await _pump(
        tester,
        FakeCommunityRepository(),
        picker: ({required int limit}) async => null,
      );

      await _pickPhotos(tester);

      expect(find.byType(SnackBar), findsNothing);
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

  group('수정 모드', () {
    // **이 기대는 뒤집혔다.** 원래는 "카테고리·태그·장소 입력이 보이지 않는다"였다 —
    // 서버 `EditPostInput`이 그 셋을 받지 않던 시절의 기대다. 지금은 받으므로
    // 수정도 새 글과 같은 입력을 준다.
    testWidgets('새 글과 같은 입력을 모두 준다', (WidgetTester tester) async {
      await _pump(tester, _editRepo(), editPostId: '42');

      expect(find.text('Edit post'), findsOneWidget);
      expect(find.byType(ChoiceChip), findsWidgets);
      expect(find.widgetWithText(TextButton, 'Tags'), findsOneWidget);
      expect(
        find.widgetWithIcon(TextButton, Icons.place_outlined),
        findsOneWidget,
      );
      expect(find.widgetWithText(TextButton, 'Photos'), findsOneWidget);
    });

    // **이 기대도 뒤집혔다.** 원래는 "바꿀 수 없는 항목이 있다는 안내가 보인다"였다.
    // 이제 다 바꿀 수 있으므로 그 안내는 거짓말이고, 문구 자체를 지웠다.
    testWidgets('못 바꾼다는 안내를 더는 띄우지 않는다', (WidgetTester tester) async {
      await _pump(tester, _editRepo(), editPostId: '42');

      expect(
        find.textContaining("can't be changed after posting"),
        findsNothing,
      );
    });

    // 서버가 이제 카테고리·태그·장소를 받으므로, 빈 채로 열면 사용자가 뜻하지 않은
    // 값이 저장된다 — 현재 값을 보고 고치게 한다.
    testWidgets('카테고리·태그·장소를 조회한 글에서 채운다', (WidgetTester tester) async {
      await _pump(tester, _editRepo(tags: <String>['야간개장']), editPostId: '42');

      // 글의 카테고리 칩이 선택된 채로 열린다.
      final ChoiceChip selected = tester.widget<ChoiceChip>(
        find.widgetWithText(ChoiceChip, 'Attractions'),
      );
      expect(selected.selected, isTrue);
      // 태그 줄과 장소 버튼 라벨에 현재 값이 드러난다.
      expect(find.text('#야간개장'), findsOneWidget);
      expect(find.text('Gyeongbokgung'), findsOneWidget);
    });

    // 수정도 카테고리를 요구한다. 서버 입력에서는 nullable이지만 null이 "지우기"인지
    // "그대로"인지 불분명해 화면이 그 애매함을 만들지 않는다.
    testWidgets('카테고리 없는 글은 고르기 전까지 저장할 수 없다', (WidgetTester tester) async {
      await _pump(tester, _editRepo(category: null), editPostId: '42');

      expect(tester.widget<TextButton>(_submit).onPressed, isNull);

      await tester.tap(find.text('Attractions'));
      await tester.pumpAndSettle();

      expect(tester.widget<TextButton>(_submit).onPressed, isNotNull);
    });

    testWidgets('카테고리를 바꿔 저장하면 새 카테고리가 나간다', (WidgetTester tester) async {
      final FakeCommunityRepository repo = _editRepo();
      await _pump(tester, repo, editPostId: '42');

      // 칩 줄은 가로 스크롤 [ListView]라 뒤쪽 칩은 **아직 만들어지지도 않았다** —
      // 스크롤해서 붙여 온 뒤에 누른다.
      final Finder food = find.widgetWithText(ChoiceChip, 'Food');
      await tester.scrollUntilVisible(food, 100, scrollable: _categoryStrip);
      await tester.pumpAndSettle();
      await tester.tap(food);
      await tester.pumpAndSettle();
      await tester.tap(_submit);
      await tester.pumpAndSettle();

      expect(repo.lastEditPost?.category, TargetCategory.restaurant);
    });

    // `tags`는 전체 교체다 — 더한 뒤에도 원래 태그가 함께 실려야 한다.
    testWidgets('태그를 더해 저장하면 늘어난 목록이 나간다', (WidgetTester tester) async {
      final FakeCommunityRepository repo = _editRepo(tags: <String>['야간개장']);
      await _pump(tester, repo, editPostId: '42');

      await _openTagSheet(tester);
      await tester.enterText(find.byType(TextField).last, '한복');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(FilledButton, 'Done'));
      await tester.pumpAndSettle();

      await tester.tap(_submit);
      await tester.pumpAndSettle();

      expect(repo.lastEditPost?.tags, <String>['야간개장', '한복']);
    });

    testWidgets('태그를 빼고 저장하면 줄어든 목록이 나간다', (WidgetTester tester) async {
      final FakeCommunityRepository repo = _editRepo(
        tags: <String>['야간개장', '한복'],
      );
      await _pump(tester, repo, editPostId: '42');

      // 태그 줄의 첫 칩을 뗀다 — 칩의 삭제 버튼이 사용자가 누르는 자리다.
      await tester.tap(
        find.descendant(
          of: find.widgetWithText(InputChip, '#야간개장'),
          matching: find.byTooltip('Delete'),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(_submit);
      await tester.pumpAndSettle();

      expect(repo.lastEditPost?.tags, <String>['한복']);
    });

    testWidgets('제목·본문을 서버에서 받아 채운다', (WidgetTester tester) async {
      final FakeCommunityRepository repo = _editRepo();
      await _pump(tester, repo, editPostId: '42');

      // 라우트 파라미터가 아니라 `post(id:)` 조회가 출처다.
      expect(repo.lastFetchedPostId, '42');
      expect(tester.widget<TextField>(_titleField).controller?.text, '원래 제목');
      expect(tester.widget<TextField>(_bodyField).controller?.text, '원래 본문');
    });

    testWidgets('저장하면 editPost가 나간다', (WidgetTester tester) async {
      final FakeCommunityRepository repo = _editRepo();
      await _pump(tester, repo, editPostId: '42');

      await tester.enterText(_titleField, '새 제목');
      await tester.pumpAndSettle();
      await tester.tap(_submit);
      await tester.pumpAndSettle();

      expect(repo.lastEditPost?.postId, '42');
      expect(repo.lastEditPost?.title, '새 제목');
      expect(repo.lastEditPost?.body, '원래 본문');
    });

    testWidgets('숨겨진 글 수정 거부는 그 이유를 알린다', (WidgetTester tester) async {
      final FakeCommunityRepository repo = _editRepo()
        ..mutationError = CommunityFailure.userError('POST_NOT_EDITABLE');
      await _pump(tester, repo, editPostId: '42');

      await tester.tap(_submit);
      await tester.pumpAndSettle();

      expect(find.text("Hidden posts can't be edited."), findsOneWidget);
    });

    // 삭제·차단된 글은 서버가 오류가 아니라 null을 준다(가이드 §6) — 빈 편집기를
    // 열어 저장하게 두면 안 된다.
    testWidgets('볼 수 없는 글이면 편집기 대신 안내가 뜬다', (WidgetTester tester) async {
      await _pump(tester, FakeCommunityRepository(), editPostId: '42');

      expect(find.text('Post unavailable'), findsOneWidget);
      expect(find.byType(TextField), findsNothing);
    });
  });

  // `changeSpot`은 스키마에만 있고 문서에 없는 인자다. `spotId: null` 하나로는
  // "장소를 그대로 두기"와 "장소를 떼기"가 구분되지 않아 이 플래그가 가른다.
  group('수정 모드의 장소 (changeSpot)', () {
    testWidgets('장소를 건드리지 않으면 changeSpot: false로 나간다', (
      WidgetTester tester,
    ) async {
      final FakeCommunityRepository repo = _editRepo();
      await _pump(tester, repo, editPostId: '42');

      await tester.tap(_submit);
      await tester.pumpAndSettle();

      expect(repo.lastEditPost?.changeSpot, isFalse);
      // false면 서버가 무시하는 값이라 아예 싣지 않는다.
      expect(repo.lastEditPost?.spotId, isNull);
    });

    testWidgets('다른 장소를 고르면 changeSpot: true와 새 spotId가 나간다', (
      WidgetTester tester,
    ) async {
      final FakeCommunityRepository repo = _editRepo()
        ..nearbySpots = <NearbySpot>[_spot(id: '11915', title: '서울갤러리')];
      await _pump(tester, repo, editPostId: '42');

      await _openSpotSheet(tester);
      await tester.tap(find.text('서울갤러리'));
      await tester.pumpAndSettle();
      await tester.tap(_submit);
      await tester.pumpAndSettle();

      expect(repo.lastEditPost?.changeSpot, isTrue);
      expect(repo.lastEditPost?.spotId, '11915');
    });

    testWidgets('장소를 떼면 changeSpot: true와 spotId: null이 나간다', (
      WidgetTester tester,
    ) async {
      final FakeCommunityRepository repo = _editRepo();
      await _pump(tester, repo, editPostId: '42');

      // 하단 바의 지우기 버튼이 장소를 떼는 유일한 수단이다. 앱바의 닫기도 같은
      // 아이콘이라 툴팁으로 지목한다.
      await tester.tap(find.byTooltip('Remove place'));
      await tester.pumpAndSettle();
      await tester.tap(_submit);
      await tester.pumpAndSettle();

      expect(repo.lastEditPost?.changeSpot, isTrue);
      expect(repo.lastEditPost?.spotId, isNull);
    });

    // 원래 장소 없던 글에 장소를 붙이는 것도 "바꾼 것"이다.
    testWidgets('장소 없던 글에 장소를 붙이면 changeSpot: true가 나간다', (
      WidgetTester tester,
    ) async {
      final FakeCommunityRepository repo = _editRepo(withoutSpot: true)
        ..nearbySpots = <NearbySpot>[_spot(id: '11915', title: '서울갤러리')];
      await _pump(tester, repo, editPostId: '42');

      await _openSpotSheet(tester);
      await tester.tap(find.text('서울갤러리'));
      await tester.pumpAndSettle();
      await tester.tap(_submit);
      await tester.pumpAndSettle();

      expect(repo.lastEditPost?.changeSpot, isTrue);
      expect(repo.lastEditPost?.spotId, '11915');
    });

    // 장소 없던 글을 그대로 저장하는 것은 "떼기"가 아니다 — 그 둘을 섞으면
    // changeSpot이 있을 이유가 없어진다.
    testWidgets('장소 없던 글을 그대로 저장하면 changeSpot: false다', (
      WidgetTester tester,
    ) async {
      final FakeCommunityRepository repo = _editRepo(withoutSpot: true);
      await _pump(tester, repo, editPostId: '42');

      await tester.tap(_submit);
      await tester.pumpAndSettle();

      expect(repo.lastEditPost?.changeSpot, isFalse);
      expect(repo.lastEditPost?.spotId, isNull);
    });
  });

  // 이 화면의 본래 문제 — 수정 화면이 사진 없는 새 글처럼 열려 기존 사진을 보지도
  // 지키지도 못했다.
  group('수정 모드의 사진', () {
    testWidgets('기존 사진을 채워 열고 그대로 저장하면 같은 목록이 나간다', (
      WidgetTester tester,
    ) async {
      final FakeCommunityRepository repo = _editRepo(
        photoKeys: <String>['images/20/1', 'images/20/2'],
      );
      await _pump(tester, repo, editPostId: '42');

      // 붙어 있던 사진이 화면에 보인다 — 보이지 않으면 뺄 수도 없다.
      expect(find.byType(PostPhoto), findsNWidgets(2));

      await tester.tap(_submit);
      await tester.pumpAndSettle();

      expect(repo.lastEditPost?.photoKeys, <String>[
        'images/20/1',
        'images/20/2',
      ]);
    });

    // `photoKeys`는 전체 교체다(가이드 §5) — 뺀 뒤 저장하면 줄어든 목록이 나가야
    // 한다.
    testWidgets('한 장을 빼고 저장하면 줄어든 목록이 나간다', (WidgetTester tester) async {
      final FakeCommunityRepository repo = _editRepo(
        photoKeys: <String>['images/20/1', 'images/20/2'],
      );
      await _pump(tester, repo, editPostId: '42');

      await tester.tap(find.byIcon(Icons.cancel).first);
      await tester.pumpAndSettle();
      await tester.tap(_submit);
      await tester.pumpAndSettle();

      expect(repo.lastEditPost?.photoKeys, <String>['images/20/2']);
    });

    // 전부 빼면 **빈 배열**이 나간다. 생략(null)은 "사진을 건드리지 않음"이라
    // 뜻이 정반대다.
    testWidgets('전부 빼면 빈 목록이 나간다 (생략이 아니다)', (WidgetTester tester) async {
      final FakeCommunityRepository repo = _editRepo(
        photoKeys: <String>['images/20/1'],
      );
      await _pump(tester, repo, editPostId: '42');

      await tester.tap(find.byIcon(Icons.cancel).first);
      await tester.pumpAndSettle();
      await tester.tap(_submit);
      await tester.pumpAndSettle();

      expect(repo.lastEditPost?.photoKeys, isEmpty);
    });

    // **오브젝트를 지우지 않는다** — 그 키는 아직 서버의 글에 붙어 있고, 저장을
    // 취소하고 나가면 원래 사진이 그대로 살아 있어야 한다. 떨어져 나간 오브젝트
    // 정리는 서버 lifecycle의 몫이다(가이드 §4).
    testWidgets('사진을 빼도 deletePostImage를 부르지 않는다', (WidgetTester tester) async {
      final FakeCommunityRepository repo = _editRepo(
        photoKeys: <String>['images/20/1'],
      );
      await _pump(tester, repo, editPostId: '42');

      await tester.tap(find.byIcon(Icons.cancel).first);
      await tester.pumpAndSettle();

      expect(repo.lastDeletedImageKey, isNull);
    });

    // 수정 모드는 **두 종류가 섞이는 유일한 자리**다 — 이미 올라간 키와 방금 고른
    // 로컬 장이 한 줄에 있고, 순서가 곧 표시 순서다(가이드 §4).
    testWidgets('사진을 더 붙이면 저장할 때 올라가 기존 목록 뒤에 실린다', (
      WidgetTester tester,
    ) async {
      final FakeCommunityRepository repo =
          _editRepo(photoKeys: <String>['images/20/1'])
            ..uploadUrls = <PostImageUploadUrl>[_url(2)]
            ..confirmation = const PostImageConfirmation(
              confirmed: <String>['images/20/2'],
            );
      await _pump(
        tester,
        repo,
        editPostId: '42',
        picker: _picker(<LocalPhoto>[_local('b.png')]),
      );

      await _pickPhotos(tester);
      // 고른 것만으로는 나가지 않는다. 기존 원격 장 1개 + 새 로컬 장 1개가 보인다.
      expect(repo.uploadUrlCalls, isEmpty);
      expect(find.byType(PostPhoto), findsOneWidget);

      await tester.tap(_submit);
      await tester.pumpAndSettle();

      expect(repo.uploadedUrls, <String>['https://storage/2']);
      expect(repo.lastEditPost?.photoKeys, <String>[
        'images/20/1',
        'images/20/2',
      ]);
    });

    // 수정에서도 정책은 같다 — 사진 한 장 때문에 수정 자체를 되돌리지 않는다.
    testWidgets('새로 붙인 장이 실패해도 저장은 되고 실패만 알린다', (WidgetTester tester) async {
      // uploadUrls를 비워 두면 1단계 "전부 거부"다.
      final FakeCommunityRepository repo = _editRepo(
        photoKeys: <String>['images/20/1'],
      );
      await _pump(
        tester,
        repo,
        editPostId: '42',
        picker: _picker(<LocalPhoto>[_local('b.png')]),
      );

      await _pickPhotos(tester);
      await _tapSubmitAndHoldToast(tester);

      // 원래 사진은 그대로 남고 새 장만 빠진다.
      expect(repo.lastEditPost?.photoKeys, <String>['images/20/1']);
      expect(
        find.text("Your post was updated, but 1 photo couldn't be uploaded."),
        findsOneWidget,
      );
    });
  });

  group('장소 선택 시트의 좋아요한 장소 탭', () {
    // 주변 목록에 없는 곳을 다시 찾아 붙이는 경로다. 서버 `likedSpots`는 커서
    // 페이징이고 좌표를 받지 않는다.
    testWidgets('탭을 바꾸면 좋아요한 장소가 뜨고 고르면 초안에 붙는다', (WidgetTester tester) async {
      final FakeCommunityRepository repo = FakeCommunityRepository()
        ..nearbySpots = <NearbySpot>[_spot(id: '1', title: '서울갤러리')]
        ..likedSpots = <NearbySpot>[
          NearbySpot(id: '5092', title: '국회박물관', address: '서울 영등포구'),
        ];
      await _pump(tester, repo);
      await _fill(tester);

      await _openSpotSheet(tester);
      // 주변이 기본이다.
      expect(find.text('서울갤러리'), findsOneWidget);
      expect(find.text('국회박물관'), findsNothing);

      await tester.tap(find.text('Liked places'));
      await tester.pumpAndSettle();

      expect(find.text('국회박물관'), findsOneWidget);
      // 거리가 없으므로 그 자리에 주소를 그린다.
      expect(find.text('서울 영등포구'), findsOneWidget);
      expect(find.text('서울갤러리'), findsNothing);

      await tester.tap(find.text('국회박물관'));
      await tester.pumpAndSettle();
      await tester.tap(_submit);
      await tester.pumpAndSettle();

      expect(repo.lastCreatePost?.spotId, '5092');
    });

    // 좋아요한 장소가 없는 계정이 정상 상태다 — 오류로 처리하면 안 된다.
    testWidgets('좋아요한 장소가 없으면 오류가 아니라 빈 안내다', (WidgetTester tester) async {
      await _pump(tester, FakeCommunityRepository());

      await _openSpotSheet(tester);
      await tester.tap(find.text('Liked places'));
      await tester.pumpAndSettle();

      expect(find.text("You haven't liked any places yet."), findsOneWidget);
      expect(find.widgetWithText(FilledButton, 'Retry'), findsNothing);
    });

    // 좌표를 받지 않는 쿼리라 위치가 꺼져 있어도 이 탭은 그대로 돈다 — 위치 실패
    // 상태에서 장소를 붙일 수 있는 유일한 길이다.
    testWidgets('위치를 못 얻어도 좋아요한 장소 탭은 뜬다', (WidgetTester tester) async {
      final FakeCommunityRepository repo = FakeCommunityRepository()
        ..likedSpots = <NearbySpot>[NearbySpot(id: '5092', title: '국회박물관')];
      await _pump(
        tester,
        repo,
        locationError: const LocationUnavailable(
          LocationUnavailableReason.serviceDisabled,
        ),
      );

      await _openSpotSheet(tester);
      await tester.tap(find.text('Liked places'));
      await tester.pumpAndSettle();

      expect(find.text('국회박물관'), findsOneWidget);
    });

    // 카테고리 줄 하나가 두 출처에 함께 걸린다 — 탭마다 필터를 따로 두면 옮길 때
    // 왜 결과가 달라졌는지 알 수 없다.
    testWidgets('카테고리 칩이 좋아요한 장소에도 걸린다', (WidgetTester tester) async {
      final FakeCommunityRepository repo = FakeCommunityRepository()
        ..spotCategories = <NearbySpotCategory>[NearbySpotCategory.restaurant]
        ..likedSpots = <NearbySpot>[NearbySpot(id: '1', title: '국회박물관')]
        ..likedSpotsByCategory = <NearbySpotCategory, List<NearbySpot>>{
          NearbySpotCategory.restaurant: <NearbySpot>[
            NearbySpot(id: '2', title: '무교동 북어국집'),
          ],
        };
      await _pump(tester, repo);

      await _openSpotSheet(tester);
      await tester.tap(find.text('Liked places'));
      await tester.pumpAndSettle();
      await tester.tap(_sheetChips('Food'));
      await tester.pumpAndSettle();

      expect(repo.lastFetchLiked?.category, NearbySpotCategory.restaurant);
      expect(find.text('무교동 북어국집'), findsOneWidget);
      expect(find.text('국회박물관'), findsNothing);
    });

    testWidgets('조회가 실패하면 사유와 재시도가 보인다', (WidgetTester tester) async {
      final FakeCommunityRepository repo = FakeCommunityRepository()
        ..likedSpotsError = CommunityFailure.network;
      await _pump(tester, repo);

      await _openSpotSheet(tester);
      await tester.tap(find.text('Liked places'));
      await tester.pumpAndSettle();

      expect(find.text("Couldn't load your liked places."), findsOneWidget);
      expect(find.widgetWithText(FilledButton, 'Retry'), findsOneWidget);
    });
  });

  group('장소 선택 시트의 카테고리 줄', () {
    // **구성은 서버가 정한다** — 언어마다 가용 카테고리가 달라(ko는 여행코스, en은
    // 교통) 클라이언트가 하드코딩하면 없는 카테고리를 보여주게 된다.
    testWidgets('칩은 서버가 준 목록으로 그린다', (WidgetTester tester) async {
      final FakeCommunityRepository repo = FakeCommunityRepository()
        ..spotCategories = <NearbySpotCategory>[
          NearbySpotCategory.touristSpot,
          NearbySpotCategory.restaurant,
        ]
        ..nearbySpots = <NearbySpot>[_spot()];
      await _pump(tester, repo);

      await _openSpotSheet(tester);

      expect(_sheetChips('All'), findsOneWidget);
      expect(_sheetChips('Attractions'), findsOneWidget);
      expect(_sheetChips('Food'), findsOneWidget);
      // 서버가 주지 않은 카테고리는 그리지 않는다.
      expect(_sheetChips('Stays'), findsNothing);
    });

    testWidgets('처음에는 전체가 선택돼 있다', (WidgetTester tester) async {
      final FakeCommunityRepository repo = FakeCommunityRepository()
        ..spotCategories = <NearbySpotCategory>[NearbySpotCategory.restaurant]
        ..nearbySpots = <NearbySpot>[_spot()];
      await _pump(tester, repo);

      await _openSpotSheet(tester);

      expect(tester.widget<ChoiceChip>(_sheetChips('All')).selected, isTrue);
      expect(repo.lastFetchNearbySpots?.category, isNull);
    });

    // 이름 필터와 달리 **서버가 거른다** — 고른 순간 페이지 0부터 다시 받는다.
    testWidgets('칩을 고르면 그 카테고리로 페이지 0부터 다시 조회한다', (WidgetTester tester) async {
      final FakeCommunityRepository repo = FakeCommunityRepository()
        ..spotCategories = <NearbySpotCategory>[NearbySpotCategory.restaurant]
        ..nearbySpots = <NearbySpot>[_spot(id: '1', title: '경복궁')]
        ..nearbySpotsByCategory = <NearbySpotCategory, List<NearbySpot>>{
          NearbySpotCategory.restaurant: <NearbySpot>[
            _spot(id: '2', title: '무교동 북어국집'),
          ],
        };
      await _pump(tester, repo);

      await _openSpotSheet(tester);
      await tester.tap(_sheetChips('Food'));
      await tester.pumpAndSettle();

      expect(
        repo.lastFetchNearbySpots?.category,
        NearbySpotCategory.restaurant,
      );
      expect(repo.lastFetchNearbySpots?.page, 0);
      expect(find.text('무교동 북어국집'), findsOneWidget);
      expect(find.text('경복궁'), findsNothing);
    });

    // 고를 것이 하나뿐인 필터 줄은 자리만 차지한다 — 줄 자체를 그리지 않는다.
    testWidgets('서버가 빈 목록을 주면 줄을 아예 그리지 않는다', (WidgetTester tester) async {
      final FakeCommunityRepository repo = FakeCommunityRepository()
        ..nearbySpots = <NearbySpot>[_spot(title: '경복궁')];
      await _pump(tester, repo);

      await _openSpotSheet(tester);

      expect(_sheetChips(), findsNothing);
      // 칩이 없어도 장소 목록은 그대로 뜬다.
      expect(find.text('경복궁'), findsOneWidget);
    });

    // 카테고리 결과가 비는 것은 오류가 아니다 — 빈 안내를 보여준다.
    testWidgets('카테고리 결과가 비면 오류가 아니라 빈 안내다', (WidgetTester tester) async {
      final FakeCommunityRepository repo = FakeCommunityRepository()
        ..spotCategories = <NearbySpotCategory>[NearbySpotCategory.lodging]
        ..nearbySpots = <NearbySpot>[_spot(title: '경복궁')]
        ..nearbySpotsByCategory = <NearbySpotCategory, List<NearbySpot>>{
          NearbySpotCategory.lodging: <NearbySpot>[],
        };
      await _pump(tester, repo);

      await _openSpotSheet(tester);
      await tester.tap(_sheetChips('Stays'));
      await tester.pumpAndSettle();

      expect(find.text('No places found nearby.'), findsOneWidget);
      expect(find.widgetWithText(FilledButton, 'Retry'), findsNothing);
    });
    // SPEC-0013 R14 이후 텍스트 칸은 **서버 검색**이다. 카테고리 칩은 여전히
    // 주변 목록의 필터이고, 둘은 함께 서버로 나간다.
    testWidgets('텍스트 칸은 서버 검색으로 나가고 카테고리도 함께 실린다', (WidgetTester tester) async {
      final FakeCommunityRepository repo = FakeCommunityRepository()
        ..spotCategories = <NearbySpotCategory>[NearbySpotCategory.restaurant]
        ..nearbySpots = <NearbySpot>[_spot(id: '1', title: '경복궁')]
        ..nearbySpotsByCategory = <NearbySpotCategory, List<NearbySpot>>{
          NearbySpotCategory.restaurant: <NearbySpot>[
            _spot(id: '2', title: '무교동 북어국집'),
          ],
        }
        ..searchResults = <NearbySpot>[_spot(id: '3', title: '참숯골')];
      await _pump(tester, repo);

      await _openSpotSheet(tester);
      await tester.tap(_sheetChips('Food'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField).last, '참숯');
      await tester.testTextInput.receiveAction(TextInputAction.search);
      await tester.pumpAndSettle();

      expect(repo.lastSearchQuery, '참숯');
      expect(repo.lastSearchCategory, NearbySpotCategory.restaurant);
      expect(find.text('참숯골'), findsOneWidget);
    });
  });
}
