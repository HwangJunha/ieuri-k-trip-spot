import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/common/location/coordinates.dart';
import 'package:ieuri_k_trip_spot/common/location/location_providers.dart';
import 'package:ieuri_k_trip_spot/common/location/location_service.dart';
import 'package:ieuri_k_trip_spot/domain/auth/model/auth_session.dart';
import 'package:ieuri_k_trip_spot/domain/auth/model/auth_state.dart';
import 'package:ieuri_k_trip_spot/domain/auth/model/me.dart';
import 'package:ieuri_k_trip_spot/domain/auth/provider/auth_controller.dart';
import 'package:ieuri_k_trip_spot/domain/national_map/model/cell_detail.dart';
import 'package:ieuri_k_trip_spot/domain/national_map/model/cell_geometry.dart';
import 'package:ieuri_k_trip_spot/domain/national_map/model/cell_shape_key.dart';
import 'package:ieuri_k_trip_spot/domain/national_map/model/current_location_check.dart';
import 'package:ieuri_k_trip_spot/domain/national_map/model/district_boundary.dart';
import 'package:ieuri_k_trip_spot/domain/national_map/model/district_resolver.dart';
import 'package:ieuri_k_trip_spot/domain/national_map/model/map_cell.dart';
import 'package:ieuri_k_trip_spot/domain/national_map/model/map_relation.dart';
import 'package:ieuri_k_trip_spot/domain/national_map/model/photo_scan_progress.dart';
import 'package:ieuri_k_trip_spot/domain/national_map/model/shared_map.dart';
import 'package:ieuri_k_trip_spot/domain/national_map/provider/current_location_provider.dart';
import 'package:ieuri_k_trip_spot/domain/national_map/provider/district_resolver_provider.dart';
import 'package:ieuri_k_trip_spot/domain/national_map/provider/national_map_providers.dart';
import 'package:ieuri_k_trip_spot/domain/national_map/provider/photo_scan_controller.dart';
import 'package:ieuri_k_trip_spot/domain/national_map/provider/photo_scan_checkpoint_provider.dart';
import 'package:ieuri_k_trip_spot/domain/national_map/repository/photo_scan_checkpoint_store.dart';
import 'package:ieuri_k_trip_spot/domain/national_map/provider/share_providers.dart';
import 'package:ieuri_k_trip_spot/domain/national_map/provider/visit_controller.dart';
import 'package:ieuri_k_trip_spot/domain/national_map/repository/national_map_repository.dart';
import 'package:ieuri_k_trip_spot/domain/national_map/service/photo_library_service.dart';
import 'package:ieuri_k_trip_spot/domain/national_map/service/share_sheet_service.dart';

/// 정사각형 시군구 하나. 판정기를 세우는 데 쓴다.
DistrictBoundary _district(
  String code, {
  required double lng,
  required double lat,
  double size = 1,
}) {
  final List<GeoPoint> ring = <GeoPoint>[
    GeoPoint(lng, lat),
    GeoPoint(lng + size, lat),
    GeoPoint(lng + size, lat + size),
    GeoPoint(lng, lat + size),
  ];
  return DistrictBoundary(
    code: code,
    provinceCode: code.substring(0, 2),
    nameKo: '테스트$code',
    nameEn: 'Test$code',
    polygons: <DistrictPolygon>[
      DistrictPolygon(
        outer: ring,
        holes: const <List<GeoPoint>>[],
        bounds: GeoBounds.of(ring),
      ),
    ],
    bounds: GeoBounds.of(ring),
  );
}

MapCell _cell(
  String id,
  List<String> districts, {
  bool visited = false,
  String name = 'cell',
}) => MapCell(
  id: id,
  districtCodes: districts,
  name: name,
  provinceName: '',
  provinceCode: districts.first.substring(0, 2),
  visited: visited,
  center: const GeoPoint(127, 37),
);

class _FakeRepository implements NationalMapRepository {
  _FakeRepository({List<MapCell>? cells}) : _cells = cells ?? <MapCell>[];

  final List<MapCell> _cells;

  /// 마지막으로 받은 등록 요청. 무엇을 보냈는지 확인한다.
  List<String>? lastRecorded;
  int recordCallCount = 0;
  String? lastRemovedCellId;
  String? lastRevokedUrl;
  bool shareLinkThrows = false;

  @override
  Future<List<MapCell>> fetchCells() async => _cells;

  @override
  Future<CellDetail> fetchCellDetail({
    required String cellId,
    int? first,
  }) async => CellDetail(
    cell: _cells.first,
    spots: const <CellSpot>[
      CellSpot(
        id: 's1',
        title: '첫 장소',
        thumbnailImageUrl: '',
        categoryCode: 'c',
        categoryLabel: 'C',
        lat: 37,
        lng: 127,
        likeCount: 1,
      ),
    ],
  );

  @override
  Future<RecordVisitsResult> recordVisits(List<String> districtCodes) async {
    lastRecorded = districtCodes;
    recordCallCount++;
    return RecordVisitsResult(
      updatedCells: <MapCell>[
        for (final MapCell c in _cells)
          if (c.districtCodes.any(districtCodes.contains))
            c.copyWith(visited: true),
      ],
      unknownDistrictCodes: const <String>[],
    );
  }

  @override
  Future<MapCell?> removeVisit(String cellId) async {
    lastRemovedCellId = cellId;
    return _cells
        .firstWhere((MapCell c) => c.id == cellId)
        .copyWith(visited: false);
  }

  @override
  Future<MapShareLink> createShareLink() async {
    if (shareLinkThrows) throw Exception('nope');
    return MapShareLink(
      shareUrl: 'ieuri://shared/tok123',
      createdAt: DateTime(2026, 8, 22),
    );
  }

  @override
  Future<void> revokeShareLink(String shareUrl) async {
    lastRevokedUrl = shareUrl;
  }

  @override
  Future<SharedMap> fetchSharedMap(String token) async => SharedMap(
    ownerNickname: 'nick',
    visitedCellIds: const <String>['1'],
    visitedCount: 1,
  );

  /// 관계 목록. 기본은 비어 있고 테스트가 필요할 때 채운다.
  List<MapRelation> relations = <MapRelation>[];
  String? lastCreatedShareUrl;
  String? lastRemovedMemberId;

  @override
  Future<MapRelationPage> fetchRelations({int? first, String? after}) async =>
      MapRelationPage(relations: relations, hasMore: false);

  @override
  Future<void> createRelation(String shareUrl) async {
    lastCreatedShareUrl = shareUrl;
  }

  @override
  Future<void> removeRelation(String memberId) async {
    lastRemovedMemberId = memberId;
  }
}

class _FakeLibrary implements PhotoLibraryService {
  _FakeLibrary({
    required this.coordinates,
    this.granted = true,
    this.throwsAt = -1,
  });

  final List<GeoPoint> coordinates;
  final bool granted;

  /// 이 start 값에서 예외를 던진다. -1이면 던지지 않는다.
  final int throwsAt;

  int requestCount = 0;

  @override
  Future<PhotoAccess> requestAccess() async =>
      granted ? PhotoAccess.granted : PhotoAccess.denied;

  @override
  Future<void> presentLimitedPicker() async {}

  @override
  Future<void> openSettings() async {}

  @override
  Future<PhotoAccess> currentAccess() async =>
      granted ? PhotoAccess.granted : PhotoAccess.denied;

  @override
  Future<int> photoCount() async => coordinates.length;

  @override
  Future<List<GeoPoint>> coordinatesOf({
    required int start,
    required int count,
  }) async {
    requestCount++;
    if (start == throwsAt) throw Exception('read failed');
    if (start >= coordinates.length) return const <GeoPoint>[];
    final int end = (start + count) > coordinates.length
        ? coordinates.length
        : start + count;
    return coordinates.sublist(start, end);
  }

  @override
  Stream<PhotoCoordinate> streamCoordinates({
    required int start,
    required int count,
  }) async* {
    requestCount++;
    if (start == throwsAt) throw Exception('read failed');
    if (start >= coordinates.length) return;
    final int end = (start + count) > coordinates.length
        ? coordinates.length
        : start + count;
    // 페이크는 좌표 없는 사진을 흉내 내지 않는다 — 있는 것만 한 장씩 흘린다.
    for (final GeoPoint p in coordinates.sublist(start, end)) {
      yield PhotoCoordinate(p);
    }
  }
}

/// 메모리에만 담는 중단 지점 저장소.
class _FakeCheckpointStore implements PhotoScanCheckpointStore {
  PhotoScanCheckpoint? saved;

  @override
  PhotoScanCheckpoint? read() => saved;

  @override
  Future<void> write(PhotoScanCheckpoint checkpoint) async =>
      saved = checkpoint;

  @override
  Future<void> clear() async => saved = null;
}

/// 로그인 상태만 흉내 내는 최소 컨트롤러. 세션 저장소를 세우지 않는다 —
/// 여기서 검증하는 것은 인증 흐름이 아니라 지도 동작이다.
class _AuthedController extends AuthController {
  @override
  Future<AuthState> build() async => AuthState(
    session: AuthSession(
      accessToken: 'a',
      refreshToken: 'r',
      user: const Me(id: 'me', nickname: '나', email: 'me@example.com'),
    ),
  );
}

class _FakeShareSheet implements ShareSheetService {
  String? lastText;

  @override
  Future<void> share({required String text, String? subject}) async {
    lastText = text;
  }
}

class _FakeLocationService implements LocationService {
  _FakeLocationService(this.coordinates);

  final Coordinates? coordinates;

  @override
  Future<Coordinates> currentCoordinates() async {
    final Coordinates? c = coordinates;
    if (c == null) throw Exception('no location');
    return c;
  }

  @override
  Stream<Coordinates> watchCoordinates() => const Stream<Coordinates>.empty();
}

ProviderContainer _container({
  required _FakeRepository repo,
  _FakeLibrary? library,
  _FakeShareSheet? sheet,
  Coordinates? location,
  List<DistrictBoundary>? boundaries,
  _FakeCheckpointStore? checkpoints,
}) {
  final ProviderContainer c = ProviderContainer(
    overrides: [
      // 지도 provider들이 로그아웃 시 캐시를 비우려고 인증을 watch한다
      // (`SessionScope`). 인증이 loading에 머물면 mapCells가 값을 내지 않는다.
      authControllerProvider.overrideWith(_AuthedController.new),
      nationalMapRepositoryProvider.overrideWithValue(repo),
      // 스캔 중단 지점 저장소는 SharedPreferences를 쓴다 — 테스트에서는
      // 메모리 페이크로 바꿔 준비 코드를 없앤다.
      photoScanCheckpointStoreProvider.overrideWithValue(
        checkpoints ?? _FakeCheckpointStore(),
      ),
      if (library != null)
        photoLibraryServiceProvider.overrideWithValue(library),
      if (sheet != null) shareSheetServiceProvider.overrideWithValue(sheet),
      locationServiceProvider.overrideWithValue(_FakeLocationService(location)),
      if (boundaries != null)
        districtResolverProvider.overrideWith(
          (Ref ref) async => DistrictResolver(boundaries),
        ),
    ],
  );
  addTearDown(c.dispose);
  return c;
}

void main() {
  // 사진 스캔 컨트롤러가 앱 생명주기를 듣는다(`AppLifecycleListener`) —
  // 바인딩이 없으면 provider를 만드는 것만으로 실패한다.
  TestWidgetsFlutterBinding.ensureInitialized();

  group('방문 등록 (R3·R30)', () {
    test('시군구 코드를 보내고 응답으로 캐시를 고친다', () async {
      final _FakeRepository repo = _FakeRepository(
        cells: <MapCell>[
          _cell('1', <String>['11110']),
        ],
      );
      final ProviderContainer c = _container(repo: repo);
      await _readCells(c);

      await c.read(visitControllerProvider.notifier).record(<String>['11110']);

      expect(repo.lastRecorded, <String>['11110']);
      // 재조회 없이 응답의 updatedCells로 고쳐야 한다.
      expect(c.read(mapCellsProvider).value!.single.visited, isTrue);
    });

    test('빈 목록은 요청을 보내지 않는다', () async {
      final _FakeRepository repo = _FakeRepository();
      final ProviderContainer c = _container(repo: repo);

      final RecordVisitsResult r = await c
          .read(visitControllerProvider.notifier)
          .record(const <String>[]);

      expect(repo.recordCallCount, 0);
      expect(r.updatedCells, isEmpty);
    });

    test('해제는 칸 id를 보낸다', () async {
      final _FakeRepository repo = _FakeRepository(
        cells: <MapCell>[
          _cell('7', <String>['11110'], visited: true),
        ],
      );
      final ProviderContainer c = _container(repo: repo);
      await _readCells(c);

      await c.read(visitControllerProvider.notifier).remove('7');

      expect(repo.lastRemovedCellId, '7');
      expect(c.read(mapCellsProvider).value!.single.visited, isFalse);
    });
  });

  group('사진 스캔 (R25~R32)', () {
    final List<DistrictBoundary> boundaries = <DistrictBoundary>[
      _district('11110', lng: 127, lat: 37),
      _district('26110', lng: 129, lat: 35),
    ];

    test('좌표를 판정해 시군구 코드를 모은다', () async {
      final _FakeLibrary library = _FakeLibrary(
        coordinates: <GeoPoint>[
          const GeoPoint(127.5, 37.5), // 11110
          const GeoPoint(129.5, 35.5), // 26110
        ],
      );
      final ProviderContainer c = _container(
        repo: _FakeRepository(),
        library: library,
        boundaries: boundaries,
      );

      await c.read(photoScanControllerProvider.notifier).start();
      final PhotoScanProgress p = c.read(photoScanControllerProvider);

      expect(p.stage, PhotoScanStage.awaitingConfirmation);
      expect(p.resolvedCellCodes, <String>['11110', '26110']);
      expect(p.processed, 2);
    });

    test('같은 지역 좌표가 여러 건이어도 코드는 하나다', () async {
      final _FakeLibrary library = _FakeLibrary(
        coordinates: <GeoPoint>[
          for (int i = 0; i < 50; i++) GeoPoint(127.5 + i * 0.0001, 37.5),
        ],
      );
      final ProviderContainer c = _container(
        repo: _FakeRepository(),
        library: library,
        boundaries: boundaries,
      );

      await c.read(photoScanControllerProvider.notifier).start();

      expect(c.read(photoScanControllerProvider).resolvedCellCodes, <String>[
        '11110',
      ]);
    });

    test('등록 가드는 성공·실패 어느 쪽으로 끝나도 풀린다', () async {
      final ProviderContainer c = _container(
        repo: _FakeRepository(cells: <MapCell>[_cell('1', <String>['11110'])]),
        library: _FakeLibrary(coordinates: const <GeoPoint>[]),
        boundaries: boundaries,
      );
      await _readCells(c);
      final PhotoScanController controller = c.read(
        photoScanControllerProvider.notifier,
      );

      // 한 번 잡으면 두 번째는 막힌다 — 리빌드마다 등록이 나가지 않게.
      expect(controller.beginRegistration(), isTrue);
      expect(controller.beginRegistration(), isFalse);

      // 실패로 끝나도 풀린다. **예전에는 이걸 푸는 자리가 시트의 버튼뿐이라,
      // awaitingConfirmation 단계에서는 영영 풀리지 않고 스피너만 돌았다.**
      controller.registrationFailed();
      expect(controller.beginRegistration(), isTrue);

      controller.confirmed();
      expect(controller.beginRegistration(), isTrue);
    });

    test('이미 방문한 시군구는 결과에서 빠진다 (R27)', () async {
      final _FakeLibrary library = _FakeLibrary(
        coordinates: <GeoPoint>[
          const GeoPoint(127.5, 37.5), // 이미 방문
          const GeoPoint(129.5, 35.5), // 새로
        ],
      );
      final ProviderContainer c = _container(
        repo: _FakeRepository(
          cells: <MapCell>[
            _cell('1', <String>['11110'], visited: true),
            _cell('2', <String>['26110']),
          ],
        ),
        library: library,
        boundaries: boundaries,
      );
      await _readCells(c);

      await c.read(photoScanControllerProvider.notifier).start();

      final PhotoScanProgress p = c.read(photoScanControllerProvider);
      expect(p.resolvedCellCodes, <String>['26110']);
      // 등록 대상에서는 빠지되 **세기는 한다** — 안 그러면 이미 방문한 곳만
      // 나온 스캔이 "0곳을 찾았어요"가 되어 실패로 읽힌다.
      expect(p.alreadyOnMapCount, 1);
    });

    test('한국 밖 좌표는 판정하지 않는다 (R25)', () async {
      final _FakeLibrary library = _FakeLibrary(
        coordinates: <GeoPoint>[
          const GeoPoint(139.7, 35.68), // 도쿄
          const GeoPoint(-74.0, 40.7), // 뉴욕
        ],
      );
      final ProviderContainer c = _container(
        repo: _FakeRepository(),
        library: library,
        boundaries: boundaries,
      );

      await c.read(photoScanControllerProvider.notifier).start();
      final PhotoScanProgress p = c.read(photoScanControllerProvider);

      // 좌표가 하나도 안 잡혀도 오류가 아니다(R32).
      expect(p.stage, PhotoScanStage.completed);
      expect(p.resolvedCellCodes, isEmpty);
    });

    test('권한을 거부하면 오류가 아니라 안내 상태다 (R31·R32)', () async {
      final ProviderContainer c = _container(
        repo: _FakeRepository(),
        library: _FakeLibrary(coordinates: const <GeoPoint>[], granted: false),
        boundaries: boundaries,
      );

      await c.read(photoScanControllerProvider.notifier).start();

      expect(
        c.read(photoScanControllerProvider).stage,
        PhotoScanStage.permissionDenied,
      );
    });

    test('사진이 0장이면 그대로 끝난다', () async {
      final ProviderContainer c = _container(
        repo: _FakeRepository(),
        library: _FakeLibrary(coordinates: const <GeoPoint>[]),
        boundaries: boundaries,
      );

      await c.read(photoScanControllerProvider.notifier).start();
      final PhotoScanProgress p = c.read(photoScanControllerProvider);

      expect(p.stage, PhotoScanStage.completed);
      expect(p.total, 0);
    });

    test('읽기에 실패하면 실패 상태로 남고 재시도 횟수가 는다 (POL-040)', () async {
      final ProviderContainer c = _container(
        repo: _FakeRepository(),
        library: _FakeLibrary(
          coordinates: <GeoPoint>[const GeoPoint(127.5, 37.5)],
          throwsAt: 0,
        ),
        boundaries: boundaries,
      );

      await c.read(photoScanControllerProvider.notifier).start();
      final PhotoScanProgress p = c.read(photoScanControllerProvider);

      expect(p.stage, PhotoScanStage.failed);
      expect(p.retryCount, 1);
    });

    test('reset하면 처음 상태로 돌아간다', () async {
      final ProviderContainer c = _container(
        repo: _FakeRepository(),
        library: _FakeLibrary(
          coordinates: <GeoPoint>[const GeoPoint(127.5, 37.5)],
        ),
        boundaries: boundaries,
      );
      await c.read(photoScanControllerProvider.notifier).start();

      c.read(photoScanControllerProvider.notifier).reset();

      expect(c.read(photoScanControllerProvider), const PhotoScanProgress());
    });
  });

  group('현재 위치 등록 (R33~R35)', () {
    final List<DistrictBoundary> boundaries = <DistrictBoundary>[
      _district('11110', lng: 127, lat: 37),
    ];

    test('미방문 지역이면 등록할 수 있다', () async {
      final ProviderContainer c = _container(
        repo: _FakeRepository(
          cells: <MapCell>[
            _cell('1', <String>['11110']),
          ],
        ),
        location: const Coordinates(latitude: 37.5, longitude: 127.5),
        boundaries: boundaries,
      );

      final CurrentLocationCheck check = await c.read(
        currentLocationCheckProvider.future,
      );

      expect(check, isA<LocationRegistrable>());
      expect((check as LocationRegistrable).districtCode, '11110');
    });

    test('이미 방문한 칸이면 알리고 등록하지 않는다 (R34)', () async {
      final ProviderContainer c = _container(
        repo: _FakeRepository(
          cells: <MapCell>[
            _cell('1', <String>['11110'], visited: true, name: '서울'),
          ],
        ),
        location: const Coordinates(latitude: 37.5, longitude: 127.5),
        boundaries: boundaries,
      );

      final CurrentLocationCheck check = await c.read(
        currentLocationCheckProvider.future,
      );

      expect(check, isA<LocationAlreadyVisited>());
      expect((check as LocationAlreadyVisited).cellName, '서울');
    });

    test('한국 밖이면 국내만 가능함을 알린다 (R35)', () async {
      final ProviderContainer c = _container(
        repo: _FakeRepository(
          cells: <MapCell>[
            _cell('1', <String>['11110']),
          ],
        ),
        location: const Coordinates(latitude: 35.68, longitude: 139.7),
        boundaries: boundaries,
      );

      expect(
        await c.read(currentLocationCheckProvider.future),
        isA<LocationOutsideKorea>(),
      );
    });

    test('위치를 얻지 못하면 사유를 남긴다 (R35)', () async {
      final ProviderContainer c = _container(
        repo: _FakeRepository(
          cells: <MapCell>[
            _cell('1', <String>['11110']),
          ],
        ),
        boundaries: boundaries,
      );

      expect(
        await c.read(currentLocationCheckProvider.future),
        isA<LocationNotAvailable>(),
      );
    });
  });

  group('공유 (R36)', () {
    test('서버가 준 링크를 그대로 공유 시트에 넘긴다', () async {
      final _FakeShareSheet sheet = _FakeShareSheet();
      final ProviderContainer c = _container(
        repo: _FakeRepository(),
        sheet: sheet,
      );

      await c.read(shareControllerProvider.notifier).share();

      // **조립하지 않는다** — 서버가 준 URL이 그대로 들어가야 한다.
      expect(sheet.lastText, contains('ieuri://shared/tok123'));
    });

    test('폐기는 받았던 shareUrl을 그대로 되돌려준다', () async {
      final _FakeRepository repo = _FakeRepository();
      final ProviderContainer c = _container(repo: repo);

      await c
          .read(shareControllerProvider.notifier)
          .revoke('ieuri://shared/tok123');

      expect(repo.lastRevokedUrl, 'ieuri://shared/tok123');
    });

    test('발급이 실패해도 상태가 풀린다', () async {
      final _FakeRepository repo = _FakeRepository()..shareLinkThrows = true;
      final ProviderContainer c = _container(
        repo: repo,
        sheet: _FakeShareSheet(),
      );

      await expectLater(
        c.read(shareControllerProvider.notifier).share(),
        throwsA(isA<Exception>()),
      );
      expect(c.read(shareControllerProvider), isFalse);
    });
  });

  // 사진 스캔이 지역을 하나 찾을 때마다 지도가 통째로 사라지고 로딩 스피너가
  // 떴다(사용자 지적 2026-08-26). 도형이 칸 목록을 통째로 watch한 탓에 방문
  // 표시만 바뀌어도 161칸이 다시 조립됐다.
  group('방문 표시가 도형을 다시 만들지 않는다', () {
    test('낙관적 방문 표시 뒤에도 도형 키가 같은 인스턴스다', () async {
      final ProviderContainer c = _container(
        repo: _FakeRepository(
          cells: <MapCell>[
            _cell('1', <String>['11110']),
            _cell('2', <String>['26110']),
          ],
        ),
      );

      await c.read(authControllerProvider.future);
      final List<CellShapeKey> before = await c.read(
        cellShapeKeysProvider.future,
      );

      c
          .read(mapCellsProvider.notifier)
          .setVisitedOptimistically(<String>{'1'}, visited: true);

      final List<CellShapeKey> after = await c.read(
        cellShapeKeysProvider.future,
      );

      // 인스턴스가 같아야 한다 — 내용만 같으면 아래 도형 provider가 또 돈다.
      expect(identical(before, after), isTrue);
    });

    test('뮤테이션 응답을 반영해도 도형 키가 같은 인스턴스다', () async {
      final ProviderContainer c = _container(
        repo: _FakeRepository(
          cells: <MapCell>[
            _cell('1', <String>['11110']),
          ],
        ),
      );

      await c.read(authControllerProvider.future);
      final List<CellShapeKey> before = await c.read(
        cellShapeKeysProvider.future,
      );

      c.read(mapCellsProvider.notifier).applyUpdated(<MapCell>[
        _cell('1', <String>['11110'], visited: true),
      ]);

      expect(
        identical(before, await c.read(cellShapeKeysProvider.future)),
        isTrue,
      );
    });

    test('방문 표시는 칸 쪽에 그대로 반영된다', () async {
      final ProviderContainer c = _container(
        repo: _FakeRepository(
          cells: <MapCell>[
            _cell('1', <String>['11110']),
          ],
        ),
      );

      await c.read(authControllerProvider.future);
      await c.read(cellShapeKeysProvider.future);

      c
          .read(mapCellsProvider.notifier)
          .setVisitedOptimistically(<String>{'1'}, visited: true);

      // 도형이 안 바뀐다고 색칠까지 멈추면 기능이 죽은 것이다.
      final List<MapCell> cells = await c.read(mapCellsProvider.future);
      expect(cells.single.visited, isTrue);
    });

    test('도형 키는 방문 여부를 담지 않는다', () {
      final CellShapeKey unvisited = CellShapeKey.of(
        _cell('1', <String>['11110']),
      );
      final CellShapeKey visited = CellShapeKey.of(
        _cell('1', <String>['11110'], visited: true),
      );

      expect(unvisited, visited);
      expect(unvisited.hashCode, visited.hashCode);
    });
  });
}

/// 인증이 확정된 뒤 칸을 읽는다.
///
/// 지도 provider들은 인증을 **watch**한다. 인증이 loading인 동안에는 미로그인으로
/// 보여 `mapCells`가 빈 목록으로 한 번 확정되므로, 먼저 인증을 확정시켜야 한다.
Future<List<MapCell>> _readCells(ProviderContainer c) async {
  await c.read(authControllerProvider.future);
  return c.read(mapCellsProvider.future);
}
