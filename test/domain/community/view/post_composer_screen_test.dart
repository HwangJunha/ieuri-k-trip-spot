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
import 'package:ieuri_k_trip_spot/domain/community/model/nearby_spot.dart';
import 'package:ieuri_k_trip_spot/domain/community/model/nearby_spot_category.dart';
import 'package:ieuri_k_trip_spot/domain/community/model/post_draft.dart';
import 'package:ieuri_k_trip_spot/domain/community/model/post_image_upload.dart';
import 'package:ieuri_k_trip_spot/domain/community/model/target_category.dart';
import 'package:ieuri_k_trip_spot/domain/community/provider/community_providers.dart';
import 'package:ieuri_k_trip_spot/domain/community/provider/photo_picker_providers.dart';
import 'package:ieuri_k_trip_spot/domain/community/provider/post_composer_providers.dart';
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
        home: PostComposerScreen(
          initialSpotId: spotId,
          initialSpotTitle: spotTitle,
          editPostId: editPostId,
        ),
      ),
    ),
  );
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

/// 수정 모드가 조회할 글을 세운 저장소. 수정 컴포저는 라우트 파라미터가 아니라
/// `post(id:)`로 제목·본문·**사진 키**를 받아 채운다.
FakeCommunityRepository _editRepo({
  List<String> photoKeys = const <String>[],
}) => FakeCommunityRepository()
  ..postById = fakePost(
    id: '42',
    title: '원래 제목',
    body: '원래 본문',
    ownedByViewer: true,
    photoKeys: photoKeys,
  );

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

    // 서버에 이름 검색 인자가 없어 **받아 둔 목록만** 좁힌다.
    testWidgets('이름 필터가 받아 둔 목록을 좁힌다', (WidgetTester tester) async {
      final FakeCommunityRepository repo = FakeCommunityRepository()
        ..nearbySpots = <NearbySpot>[
          _spot(id: '1', title: '서울갤러리'),
          _spot(id: '2', title: '경복궁'),
        ];
      await _pump(tester, repo);

      await _openSpotSheet(tester);
      await tester.enterText(find.byType(TextField).last, '경복');
      await tester.pumpAndSettle();

      expect(find.text('경복궁'), findsOneWidget);
      expect(find.text('서울갤러리'), findsNothing);
    });

    testWidgets('대소문자를 가리지 않는다', (WidgetTester tester) async {
      final FakeCommunityRepository repo = FakeCommunityRepository()
        ..nearbySpots = <NearbySpot>[
          _spot(id: '1', title: 'Seoul Gallery'),
          _spot(id: '2', title: 'Gyeongbokgung'),
        ];
      await _pump(tester, repo);

      await _openSpotSheet(tester);
      await tester.enterText(find.byType(TextField).last, 'seoul');
      await tester.pumpAndSettle();

      expect(find.text('Seoul Gallery'), findsOneWidget);
      expect(find.text('Gyeongbokgung'), findsNothing);
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

    // 두 필터는 성격이 다르다 — 카테고리로 좁힌 결과 안에서 텍스트가 다시 거른다.
    testWidgets('텍스트 칸은 카테고리로 받아 온 결과 안에서 좁힌다', (WidgetTester tester) async {
      final FakeCommunityRepository repo = FakeCommunityRepository()
        ..spotCategories = <NearbySpotCategory>[NearbySpotCategory.restaurant]
        ..nearbySpots = <NearbySpot>[_spot(id: '1', title: '경복궁')]
        ..nearbySpotsByCategory = <NearbySpotCategory, List<NearbySpot>>{
          NearbySpotCategory.restaurant: <NearbySpot>[
            _spot(id: '2', title: '무교동 북어국집'),
            _spot(id: '3', title: '참숯골'),
          ],
        };
      await _pump(tester, repo);

      await _openSpotSheet(tester);
      await tester.tap(_sheetChips('Food'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField).last, '참숯');
      await tester.pumpAndSettle();

      expect(find.text('참숯골'), findsOneWidget);
      expect(find.text('무교동 북어국집'), findsNothing);
      // 텍스트 칸은 서버로 가지 않는다 — 마지막 조회는 여전히 카테고리 것이다.
      expect(repo.nearbySpotsCalls, 2);
    });
  });

  group('사진', () {
    // 10 MiB를 넘는 장은 **고른 직후 거른다.** 그대로 1단계에 넘기면 서버가 하나만
    // 어긋나도 전부 거부해(부분 발급 없음) 멀쩡한 장까지 같이 죽는다(가이드 §4).
    testWidgets('10MiB를 넘는 사진은 제외하고 그 사실을 알린다', (WidgetTester tester) async {
      await _pump(
        tester,
        FakeCommunityRepository(),
        picker: ({required int limit}) async => <PickedPhoto>[
          PickedPhoto(
            bytes: Uint8List(maxPostPhotoBytes + 1),
            contentType: 'image/jpeg',
            name: 'huge.jpg',
          ),
        ],
      );

      await tester.tap(find.widgetWithText(TextButton, 'Photos'));
      await tester.pumpAndSettle();

      expect(find.text('1 photo was too large (max 10MB).'), findsOneWidget);
    });

    // 사용자가 갤러리에서 취소하면 **아무 안내도 하지 않는다** — 스스로 한 일이라
    // 토스트가 뜨면 오히려 오류로 읽힌다.
    testWidgets('선택을 취소하면 조용히 돌아온다', (WidgetTester tester) async {
      await _pump(
        tester,
        FakeCommunityRepository(),
        picker: ({required int limit}) async => null,
      );

      await tester.tap(find.widgetWithText(TextButton, 'Photos'));
      await tester.pumpAndSettle();

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

  group('수정 모드 (가이드 §5)', () {
    // 수정은 제목·본문·사진만 바꾼다. 카테고리·태그·장소를 만지게 하면 안 된다 —
    // 서버 `EditPostInput`이 그 셋을 아예 받지 않는다.
    //
    // **사진은 예외다** — `photoKeys`가 입력에 있으므로 바꿀 수 있고, 따라서 하단
    // 바의 사진 버튼이 남는다(이 기대는 원래 "사진도 숨긴다"였다가 뒤집혔다).
    testWidgets('카테고리·태그·장소 입력이 보이지 않고 사진만 남는다', (WidgetTester tester) async {
      await _pump(tester, _editRepo(), editPostId: '42');

      expect(find.text('Edit post'), findsOneWidget);
      expect(find.byType(ChoiceChip), findsNothing);
      expect(find.widgetWithText(TextButton, 'Tags'), findsNothing);
      expect(
        find.widgetWithIcon(TextButton, Icons.place_outlined),
        findsNothing,
      );
      expect(find.widgetWithText(TextButton, 'Photos'), findsOneWidget);
    });

    // 입력이 그냥 사라지면 고장으로 읽힌다 — 왜 못 바꾸는지 한 줄로 알린다.
    testWidgets('바꿀 수 없는 항목이 있다는 안내가 보인다', (WidgetTester tester) async {
      await _pump(tester, _editRepo(), editPostId: '42');

      expect(
        find.text("Category, place, and tags can't be changed after posting."),
        findsOneWidget,
      );
    });

    // 새 글에는 그 안내를 두지 않는다 — 거기서는 셋 다 고를 수 있다.
    testWidgets('새 글 작성에는 그 안내가 없다', (WidgetTester tester) async {
      await _pump(tester, FakeCommunityRepository());

      expect(
        find.textContaining("can't be changed after posting"),
        findsNothing,
      );
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

    testWidgets('사진을 더 붙이면 기존 목록 뒤에 실린다', (WidgetTester tester) async {
      final FakeCommunityRepository repo =
          _editRepo(photoKeys: <String>['images/20/1'])
            ..uploadUrls = const <PostImageUploadUrl>[
              PostImageUploadUrl(
                uploadUrl: 'https://storage/2',
                objectKey: 'pending/20/2',
                expiresAt: 'x',
              ),
            ]
            ..confirmation = const PostImageConfirmation(
              confirmed: <String>['images/20/2'],
            );
      await _pump(
        tester,
        repo,
        editPostId: '42',
        picker: ({required int limit}) async => <PickedPhoto>[
          PickedPhoto(
            bytes: Uint8List.fromList(<int>[1, 2, 3]),
            contentType: 'image/jpeg',
            name: 'b.jpg',
          ),
        ],
      );

      await tester.tap(find.widgetWithText(TextButton, 'Photos'));
      await tester.pumpAndSettle();
      await tester.tap(_submit);
      await tester.pumpAndSettle();

      expect(repo.lastEditPost?.photoKeys, <String>[
        'images/20/1',
        'images/20/2',
      ]);
    });
  });
}
