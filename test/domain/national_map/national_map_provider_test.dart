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

  /// 몇 번 조회했는지. 재시도가 실제로 서버를 다시 치는지 본다(SPEC-0034 R1).
  int fetchCellsCallCount = 0;
  bool fetchCellsThrows = false;

  @override
  Future<List<MapCell>> fetchCells() async {
    fetchCellsCallCount++;
    if (fetchCellsThrows) throw Exception('조회 실패');
    return _cells;
  }

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

  /// 훑을 좌표. 등급을 바꿔 가며 대상이 늘어나는 것을 흉내 내려고 쓰기 가능하다.
  List<GeoPoint> coordinates;
  final bool granted;

  /// 이 start 값에서 예외를 던진다. -1이면 던지지 않는다.
  final int throwsAt;

  int requestCount = 0;

  /// 지금 등급. 설정에서 권한을 바꾼 것을 흉내 낼 때 테스트가 갈아 끼운다.
  /// null이면 [granted]를 따른다.
  PhotoAccess? access;

  PhotoAccess get _access =>
      access ?? (granted ? PhotoAccess.granted : PhotoAccess.denied);

  @override
  Future<PhotoAccess> requestAccess() async => _access;

  @override
  Future<void> presentLimitedPicker() async {}

  @override
  Future<void> openSettings() async {}

  @override
  Future<PhotoAccess> currentAccess() async => _access;

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

/// 미인증으로 시작해 [signIn]으로 세션이 복원되는 컨트롤러.
///
/// 앱 시작 직후 세션 복원보다 지도 provider가 먼저 평가되는 상황을 흉내 낸다
/// (SPEC-0034 R3).
class _RestorableAuthController extends AuthController {
  @override
  Future<AuthState> build() async => const AuthState();

  /// 세션이 복원됐다. 이름이 `signIn`이면 실제 로그인 API를 덮어쓴다.
  void restoreSession() => state = AsyncData<AuthState>(
    AuthState(
      session: AuthSession(
        accessToken: 'a',
        refreshToken: 'r',
        user: const Me(id: 'me', nickname: '나', email: 'me@example.com'),
      ),
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

      final List<String> updated = await c
          .read(visitControllerProvider.notifier)
          .record(const <String>[]);

      expect(repo.recordCallCount, 0);
      expect(updated, isEmpty);
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
      expect(p.resolvedDistrictCodes, <String>['11110', '26110']);
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

      expect(c.read(photoScanControllerProvider).resolvedDistrictCodes, <String>[
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

      controller.confirmed(const <String>[]);
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
      expect(p.resolvedDistrictCodes, <String>['26110']);
      // 등록 대상에서는 빠지되 **세기는 한다** — 안 그러면 이미 방문한 곳만
      // 나온 스캔이 "0곳을 찾았어요"가 되어 실패로 읽힌다.
      expect(p.alreadyOnMapCellCount, 1);
    });

    // 시트가 시군구 코드 수를 세어, 지도는 칸 하나를 칠하면서 "3곳"이라고
    // 말했다(SPEC-0034 R5). 테스트가 없어서 잡히지 않았다.
    test('표시용 수는 칸 단위다 — 서울 3개 구는 1곳 (R5)', () async {
      final List<DistrictBoundary> seoul = <DistrictBoundary>[
        _district('11110', lng: 127, lat: 37),
        _district('11140', lng: 128, lat: 37),
        _district('11170', lng: 129, lat: 37),
      ];
      final _FakeLibrary library = _FakeLibrary(
        coordinates: <GeoPoint>[
          const GeoPoint(127.5, 37.5), // 11110
          const GeoPoint(128.5, 37.5), // 11140
          const GeoPoint(129.5, 37.5), // 11170
        ],
      );
      final ProviderContainer c = _container(
        // 세 구가 **한 칸**이다.
        repo: _FakeRepository(
          cells: <MapCell>[
            _cell('seoul', <String>['11110', '11140', '11170']),
          ],
        ),
        library: library,
        boundaries: seoul,
      );
      await _readCells(c);

      await c.read(photoScanControllerProvider.notifier).start();

      final PhotoScanProgress p = c.read(photoScanControllerProvider);
      // 보내는 값은 시군구 코드 그대로다 — 서버가 시군구 단위로 저장한다.
      expect(p.resolvedDistrictCodes.length, 3);
      // 표시하는 수는 칸 단위다.
      expect(p.newCellCount, 1, reason: '세 구가 한 칸이므로 1곳이다');
    });

    test('서로 다른 칸이면 칸 수 그대로다 (R5)', () async {
      final List<DistrictBoundary> three = <DistrictBoundary>[
        _district('11110', lng: 127, lat: 37),
        _district('26110', lng: 129, lat: 35),
        _district('30110', lng: 131, lat: 33),
      ];
      final ProviderContainer c = _container(
        repo: _FakeRepository(
          cells: <MapCell>[
            _cell('1', <String>['11110']),
            _cell('2', <String>['26110']),
            _cell('3', <String>['30110']),
          ],
        ),
        library: _FakeLibrary(
          coordinates: <GeoPoint>[
            const GeoPoint(127.5, 37.5),
            const GeoPoint(129.5, 35.5),
            const GeoPoint(131.5, 33.5),
          ],
        ),
        boundaries: three,
      );
      await _readCells(c);

      await c.read(photoScanControllerProvider.notifier).start();

      expect(c.read(photoScanControllerProvider).newCellCount, 3);
    });

    // R6: 같은 칸이 신규와 기존으로 갈려 이중 계상되던 것을 막는다.
    test('이미 있던 칸과 겹치면 신규에서 빠진다 (R6)', () async {
      final List<DistrictBoundary> seoul = <DistrictBoundary>[
        _district('11110', lng: 127, lat: 37),
        _district('11140', lng: 128, lat: 37),
      ];
      final ProviderContainer c = _container(
        // 강남(11110)을 이미 방문했고 서초(11140)는 아직인데 **같은 칸이다.**
        repo: _FakeRepository(
          cells: <MapCell>[
            _cell('seoul', <String>['11110', '11140'], visited: true),
          ],
        ),
        library: _FakeLibrary(
          coordinates: <GeoPoint>[
            const GeoPoint(127.5, 37.5), // 이미 방문한 구
            const GeoPoint(128.5, 37.5), // 아직 아닌 구, 그러나 같은 칸
          ],
        ),
        boundaries: seoul,
      );
      await _readCells(c);

      await c.read(photoScanControllerProvider.notifier).start();

      final PhotoScanProgress p = c.read(photoScanControllerProvider);
      // 이미 칠해진 칸이므로 새로 칠할 것이 없다. 예전 셈으로는
      // 신규 1 + 기존 1 = 2가 됐다.
      expect(p.newCellCount, 0);
      expect(p.alreadyOnMapCellCount, 1);
    });

    // R7: 완료 문구의 수는 등록 응답이 정한다.
    test('완료 시 수의 근거는 등록 응답이다 (R7)', () async {
      final ProviderContainer c = _container(
        repo: _FakeRepository(cells: <MapCell>[_cell('1', <String>['11110'])]),
        library: _FakeLibrary(coordinates: const <GeoPoint>[]),
        boundaries: boundaries,
      );
      await _readCells(c);
      final PhotoScanController controller = c.read(
        photoScanControllerProvider.notifier,
      );

      // 서버가 두 칸을 갱신했다고 답했다.
      controller.confirmed(const <String>['1', '2']);

      final PhotoScanProgress p = c.read(photoScanControllerProvider);
      expect(p.stage, PhotoScanStage.completed);
      expect(p.registeredCellCount, 2);
    });

    test('같은 칸이 두 번 와도 한 번만 센다 (R7)', () async {
      final ProviderContainer c = _container(
        repo: _FakeRepository(),
        library: _FakeLibrary(coordinates: const <GeoPoint>[]),
        boundaries: boundaries,
      );
      c.read(photoScanControllerProvider.notifier).confirmed(
        const <String>['1', '1', '2'],
      );

      expect(c.read(photoScanControllerProvider).registeredCellCount, 2);
    });

    test('등록이 실패하면 수를 표시하지 않는다 (R7)', () async {
      final ProviderContainer c = _container(
        repo: _FakeRepository(),
        library: _FakeLibrary(coordinates: const <GeoPoint>[]),
        boundaries: boundaries,
      );
      final PhotoScanController controller = c.read(
        photoScanControllerProvider.notifier,
      );

      // 한 번 성공해 수가 남은 뒤 다시 실패하는 경우까지 본다 — 지난 회차의
      // 수가 남으면 실패 화면에 "N곳을 확인했어요"가 뜬다.
      controller.confirmed(const <String>['1']);
      expect(c.read(photoScanControllerProvider).registeredCellCount, 1);

      controller.registrationFailed();

      final PhotoScanProgress p = c.read(photoScanControllerProvider);
      expect(p.stage, PhotoScanStage.failed);
      expect(p.registeredCellCount, isNull, reason: '실패했으면 수가 없어야 한다');
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
      expect(p.resolvedDistrictCodes, isEmpty);
    });

    // "위치 정보가 있는 사진을 찾지 못했어요" 화면에서 설정만 바꾸고 돌아오면
    // 화면이 굳어 있었다 — 그 화면에는 다시 채우기 버튼도 없었다(사용자 지적
    // 2026-08-26).
    test('설정에서 권한을 넓혀 돌아오면 좌표를 못 찾았어도 다시 훑는다', () async {
      // 좌표가 하나도 없는 사진첩 — 화면에 "위치 정보가 있는 사진을 찾지
      // 못했어요"가 뜨는 그 상태다.
      final _FakeLibrary library = _FakeLibrary(coordinates: const <GeoPoint>[])
        ..access = PhotoAccess.limited;
      final ProviderContainer c = _container(
        repo: _FakeRepository(
          cells: <MapCell>[_cell('1', <String>['11110'])],
        ),
        library: library,
        boundaries: boundaries,
      );

      final PhotoScanController controller = c.read(
        photoScanControllerProvider.notifier,
      );
      await controller.start();
      expect(
        c.read(photoScanControllerProvider).finishedWithoutCoordinates,
        isTrue,
      );

      // 설정에서 전체 허용으로 바꾸고, 그 사이 국내 좌표 사진이 대상에 들어왔다.
      library
        ..access = PhotoAccess.granted
        ..coordinates = <GeoPoint>[const GeoPoint(127.0, 37.5)];

      await controller.handleAppRestart();

      final PhotoScanProgress p = c.read(photoScanControllerProvider);
      expect(p.stage, PhotoScanStage.awaitingConfirmation);
      expect(p.resolvedDistrictCodes, <String>['11110']);
    });

    test('거부에서 허용으로 바뀌어 돌아와도 다시 훑는다', () async {
      final _FakeLibrary library = _FakeLibrary(
        coordinates: const <GeoPoint>[],
      )..access = PhotoAccess.denied;
      final ProviderContainer c = _container(
        repo: _FakeRepository(
          cells: <MapCell>[_cell('1', <String>['11110'])],
        ),
        library: library,
        boundaries: boundaries,
      );

      final PhotoScanController controller = c.read(
        photoScanControllerProvider.notifier,
      );
      await controller.start();
      expect(
        c.read(photoScanControllerProvider).stage,
        PhotoScanStage.permissionDenied,
      );

      library
        ..access = PhotoAccess.granted
        ..coordinates = <GeoPoint>[const GeoPoint(127.0, 37.5)];

      await controller.handleAppRestart();

      expect(
        c.read(photoScanControllerProvider).resolvedDistrictCodes,
        <String>['11110'],
      );
    });

    test('등급이 그대로면 돌아와도 다시 훑지 않는다', () async {
      final _FakeLibrary library = _FakeLibrary(
        coordinates: <GeoPoint>[const GeoPoint(139.7, 35.68)],
      );
      final ProviderContainer c = _container(
        repo: _FakeRepository(),
        library: library,
        boundaries: boundaries,
      );

      final PhotoScanController controller = c.read(
        photoScanControllerProvider.notifier,
      );
      await controller.start();
      final int before = library.requestCount;

      await controller.handleAppRestart();

      // 같은 사진을 다시 훑는 것은 낭비다.
      expect(library.requestCount, before);
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

  // 지도가 안 그려지는데 재시도 버튼이 아무 일도 하지 않았다(SPEC-0034 R1·R3).
  group('지도 데이터 재조회 (SPEC-0034 R1·R3)', () {
    test('재시도는 조회를 다시 일으킨다 (R1)', () async {
      final _FakeRepository repo = _FakeRepository(
        cells: <MapCell>[
          _cell('1', <String>['11110']),
        ],
      );
      final ProviderContainer c = _container(repo: repo);
      await _readCells(c);
      expect(repo.fetchCellsCallCount, 1);

      // 화면의 재시도 버튼이 하는 일 — 지도에 필요한 것을 전부 버린다.
      c.invalidateNationalMap();
      await _readCells(c);

      expect(
        repo.fetchCellsCallCount,
        2,
        reason: '무효화했으면 서버를 다시 쳐야 한다',
      );
    });

    test('실패한 결과는 붙들지 않는다 (R1)', () async {
      // 예전에는 실패가 keepAlive로 남아, 버튼을 눌러도 같은 실패가 재사용됐다.
      final _FakeRepository repo = _FakeRepository(
        cells: <MapCell>[
          _cell('1', <String>['11110']),
        ],
      )..fetchCellsThrows = true;
      final ProviderContainer c = _container(repo: repo);
      await c.read(authControllerProvider.future);

      await expectLater(c.read(mapCellsProvider.future), throwsA(anything));

      // 서버가 회복됐다. 재시도가 실제로 새 조회를 내야 한다.
      repo.fetchCellsThrows = false;
      c.invalidateNationalMap();

      expect((await c.read(mapCellsProvider.future)).single.id, '1');
    });

    test('미인증이 돌려준 빈 목록은 캐시로 남지 않는다 (R3)', () async {
      // 앱 시작 직후 세션 복원보다 이 provider가 먼저 평가되는 경우다.
      // 예전에는 그 빈 목록이 keepAlive로 남아 **세션이 복원돼도 빈 지도였다.**
      final _FakeRepository repo = _FakeRepository(
        cells: <MapCell>[
          _cell('1', <String>['11110']),
        ],
      );
      final _RestorableAuthController auth = _RestorableAuthController();
      final ProviderContainer c = ProviderContainer(
        overrides: [
          authControllerProvider.overrideWith(() => auth),
          nationalMapRepositoryProvider.overrideWithValue(repo),
          photoScanCheckpointStoreProvider.overrideWithValue(
            _FakeCheckpointStore(),
          ),
          locationServiceProvider.overrideWithValue(_FakeLocationService(null)),
        ],
      );
      addTearDown(c.dispose);

      await c.read(authControllerProvider.future);
      expect(await c.read(mapCellsProvider.future), isEmpty);
      expect(repo.fetchCellsCallCount, 0, reason: '미인증이면 부르지 않는다');

      // 세션이 복원됐다.
      auth.restoreSession();

      expect((await c.read(mapCellsProvider.future)).single.id, '1');
      expect(repo.fetchCellsCallCount, 1);
    });
  });

  // `asset/geo/cell-shapes.json`은 파일도 없고 pubspec에도 없는데, 로더가 모든
  // 예외를 삼켜 **그 부재가 아무 신호도 내지 않았다**(SPEC-0034 R4).
  group('칸 도형 출처 (SPEC-0034 R4)', () {
    test('자산이 없으면 조립 결과가 경계 폴백이라고 밝힌다', () async {
      final ProviderContainer c = _container(
        repo: _FakeRepository(
          cells: <MapCell>[
            _cell('1', <String>['11110']),
          ],
        ),
      );
      await _readCells(c);

      final CellGeometrySet set = await c.read(cellGeometriesProvider.future);

      // 자산이 실제로 없는 것이 현재 상태다. 폴백은 끊기지 않아야 한다 —
      // 자산 생성은 이 스펙의 범위 밖이고(SPEC-0034 §7) 지도는 그려져야 한다.
      expect(set.origin, CellShapeOrigin.boundaryFallback);
    });

    test('자산 부재가 빈 값으로 둔갑하지 않는다', () async {
      final ProviderContainer c = _container(
        repo: _FakeRepository(
          cells: <MapCell>[
            _cell('1', <String>['11110']),
          ],
        ),
      );
      await _readCells(c);

      // 자산 로더는 빈 맵을 주지만, 그것이 곧 "그릴 도형이 없다"는 아니다.
      expect(await c.read(cellShapesProvider.future), isEmpty);
      final CellGeometrySet set = await c.read(cellGeometriesProvider.future);
      expect(set.geometries, isNotEmpty, reason: '폴백이 실제로 그려야 한다');
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
