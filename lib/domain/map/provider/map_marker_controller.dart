import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../model/map_bounds.dart';
import '../model/map_marker.dart';
import '../model/map_recommendation_result.dart';
import '../model/map_tuning.dart';
import '../model/map_viewport_result.dart';
import '../repository/map_repository.dart';
import 'map_providers.dart';
import '../../auth/provider/session_scope.dart';

part 'map_marker_controller.g.dart';

/// 지도에 떠 있는 마커를 소유한다.
///
/// **화면이 아니라 provider가 마커를 들고 있는 이유**: 지도를 옮길 때마다 마커를
/// 통째로 갈아 끼우면 이미 보고 있던 장소가 사라졌다 다시 나타나 화면이 깜빡인다.
/// 여기서 누적해 두면 지도를 움직여도 **이전 마커가 살아남는다**.
///
/// **`keepAlive`다.** 지도에서 검색 화면으로 넘어가는 동안 화면이 잠시 사라지는데,
/// autoDispose면 그때 provider가 폐기되어 마커가 통째로 비워진다 — 검색하고 돌아오면
/// 고정한 마커 하나만 남고 나머지가 사라졌다(실측: "고정: 삼성 강남 (총 1개)").
///
/// 지도 탭을 벗어나도 유지되지만, 다시 들어오면 그 위치를 조회해 채우므로 낡은 마커가
/// 오래 남지는 않는다.
@Riverpod(keepAlive: true)
class MapMarkerController extends _$MapMarkerController {
  @override
  List<MapMarker> build() {
    // **`watchSignedIn`이 아니라 `listenSignedOut`이다**(SPEC-0036).
    //
    // watch면 인증 판정이 `loading`에서 `data`로 자리잡는 것만으로도 build가 다시
    // 돌아 **쌓아 둔 것이 지워진다.** 이 컨트롤러는 마커와 표시 기록을 관측해
    // 쌓아 두는 쪽이라 그 대상이다 — 실제로 첫 조회 직후 기록이 통째로 날아가
    // 제외 목록이 늘 비어 있었고, 「다음 장소」가 매번 같은 장소를 다시 줬다
    // (FR-004·FR-005 위반).
    //
    // 로그아웃이라는 **사건**에만 반응하면 세션 경계는 지키면서 값이 살아남는다.
    ref.listenSignedOut(clear);
    return const <MapMarker>[];
  }


  /// 이 영역의 **다음 장소 한 묶음**을 받아 더한다(SPEC-0036 FR-001·FR-003).
  ///
  /// [bbox]는 조회할 영역, [visible]은 화면에 실제로 보이는 영역이다. 같은 영역에서
  /// 다시 부를 때 [bbox]가 첫 조회와 같아야 한다(FR-010) — 그 판정은 화면이 한다.
  ///
  /// **제외 목록은 이 컨트롤러가 들고 서버에 보낸다**(FR-004). 세션을 클라이언트가
  /// 쥐는 이유는 「봤다」가 *마커로 실제 그려졌는가*이기 때문이다 — 격자로 솎아
  /// 그리므로 서버가 보낸 10건과 그려진 10건이 다르고, 서버가 세션을 들면 그리지
  /// 않은 장소까지 「봤다」로 기록해 남은 후보를 잃는다(FR-009).
  ///
  /// 돌려주는 값은 **영역 안 후보가 소진되었는가**다(FR-008·FR-009). 서버가 요청한
  /// 수보다 적게 준 것이 유일한 근거이며, 클라이언트가 격자로 솎아 낸 뒤의 수로
  /// 판정하면 가짜 소진이 된다 — 솎여 못 그린 장소는 제외 목록에 없어 다음 요청에
  /// 다시 온다.
  ///
  /// 실패는 그대로 던진다. 화면이 잡아 기록하고, 소진으로 넘어가지 않는다 —
  /// 네트워크 오류를 「더 볼 것이 없음」으로 읽으면 버튼이 영영 사라진다.
  Future<bool> loadNextBatch({
    required MapBounds bbox,
    required MapBounds visible,
    required int batchSize,
  }) async {
    // **제외 목록을 화면에 떠 있는 것으로 맞춘다**(사용자 정정 2026-09-18).
    //
    // 「이미 봤다」의 범위는 사용자가 보고 있는 화면이다. 기록을 그냥 쌓아 두면
    // 화면 밖으로 밀려나 더 이상 보이지 않는 장소까지 계속 제외되어, 화면에는
    // 30개뿐인데 제외 목록만 48개로 자라고 새로고침해도 아무것도 안 바뀐다
    // (실측: 후보 100곳인 화면이 6회차부터 고정됐다).
    _syncServedToScreen(visible);

    // **보고 있는 화면으로 조회한다**(사용자 결정 2026-09-18).
    //
    // 예전에는 화면의 1.2배로 넓혀 조회했다(작은 이동에 재조회가 걸리지 않도록).
    // 그런데 서버는 그 넓은 영역 기준으로 점수순 앞에서부터 주므로, **받은 추천의
    // 상당수가 화면 밖이라 버려졌다** — 화면 안 후보에 닿기 전에 왕복만 늘다 결국
    // 막혔다(실측: 두어 번 바뀌고 고정). 화면으로 조회하면 받은 것이 전부 쓸 수
    // 있는 추천이다.
    //
    // 가장자리가 잠시 빌 수 있지만, 중심이 화면의
    // [MapTuning.areaChangeFraction]만큼 움직이면 자동으로 다시 받으므로
    // (→`MapScreen`) 오래 가지 않는다.
    final MapRepository repository = ref.read(mapRepositoryProvider);
    MapRecommendationResult result = await repository.fetchRecommendedSpots(
      bbox: visible,
      excludedIds: servedSpotIds,
      first: batchSize,
    );

    // **영역을 다 돌았으면 가장 오래된 것부터 교체한다**(사용자 결정 2026-09-18).
    //
    // 예전에는 여기서 끝이었다 — 소진 판정이 서면 재검색 수단이 사라지고, 지도를
    // 크게 움직이기 전까지 돌아오지 않았다. 한자리에서 계속 둘러보는 사용자에게는
    // 기능이 죽은 것으로 보인다.
    //
    // **화면 안 후보가 상한보다 적으면 그냥 다시 조회해도 소용없다.** 그 후보가 전부
    // 화면에 떠 있어 제외하고 나면 서버가 줄 것이 없다 — 강남 화면에서 새로고침을
    // 눌러도 아무것도 안 바뀌던 이유다(실측: 후보 25곳이 25개로 고정).
    //
    // 그래서 **화면에서 가장 오래된 한 묶음을 먼저 비운다.** 그만큼 자리가 나므로
    // 다음 추천이 그 자리에 들어오고, 화면은 서서히 돌아간다. 마커 수는 유지된다.
    //
    // 「이미 봤다」의 범위는 **사용자가 보고 있는 화면**이다(사용자 정정). 화면 밖
    // 마커까지 제외하면 다른 지역을 돌아다닌 뒤 이 화면에서 아무것도 못 받는다.
    if (result.exhausted) {
      final List<MapMarker> onScreen = state
          .where((MapMarker m) => m.kind == MapMarkerKind.spot)
          .where((MapMarker m) => _isInside(m, visible))
          .toList();

      // 화면 안에 아무것도 없으면 비울 것도 없다 — 영역 자체가 빈 것이므로 그대로
      // 소진이다.
      if (onScreen.isNotEmpty) {
        // **한 묶음을 통째로 비우지 않는다.** 화면에 딱 한 묶음만 있을 때 전부
        // 치우면 제외 목록까지 비어, 서버가 맨 앞 열 개를 그대로 돌려준다 — 같은
        // 열 곳이 영영 반복되고 나머지 후보는 못 본다(실측: 후보 12곳에서 2곳이
        // 영영 안 나왔다).
        //
        // 화면의 절반까지만 비우면 남은 절반이 제외로 남아 서버가 **그 다음**을
        // 준다. 적어도 하나는 비워야 자리가 생긴다.
        final int retireCount = (onScreen.length ~/ 2).clamp(1, batchSize);

        // 앞쪽이 오래된 것이다([absorb]가 뒤에 붙인다).
        final Set<String> retired = onScreen
            .take(retireCount)
            .map(_keyOf)
            .toSet();

        state = state
            .where((MapMarker m) => !retired.contains(_keyOf(m)))
            .toList();
        _syncServedToScreen(visible);

        result = await repository.fetchRecommendedSpots(
          bbox: visible,
          excludedIds: servedSpotIds,
          first: batchSize,
        );
      }
    }

    absorb(
      MapViewportResult(markers: result.markers, truncated: false),
      visible,
    );

    // **재순회 뒤에는 소진으로 보고하지 않는다.** 한 바퀴를 다시 돌 수 있다는 뜻이라
    // 더 보기 수단을 거둘 이유가 없다 — 영역 안에 후보가 정말 하나도 없을 때만
    // (첫 조회부터 빈 결과) 참이 된다.
    return result.exhausted && result.markers.isEmpty;
  }

  /// 새 조회 결과를 기존 마커에 **더한다**.
  ///
  /// [visible]은 **화면에 실제로 보이는 영역**이다. 조회는 그보다 넓게 하지만(작은
  /// 이동에 재조회가 걸리지 않도록), 마커를 고르고 격자를 나누는 기준은 화면이어야
  /// 한다 — 넓은 영역으로 격자를 나누면 칸 대부분이 화면 밖이라, 열 개를 뽑아도
  /// 화면에는 예닐곱만 남는다.
  ///
  /// **한 번에 [MapTuning.markersPerBatch]개를 더한다**(SPEC-0036 FR-003). 「이 지역
  /// 재검색」이 화면을 갈아 끼우던 동작은 없앴다 — 이제 누를 때마다 안 본 장소가
  /// 더해져 10 → 20 → 30으로 쌓인다.
  ///
  /// 더한 장소는 [_servedKeys]에 남아 이 세션 동안 다시 후보가 되지 않는다(FR-004).
  ///
  /// 더할 새 장소가 하나도 없으면 `false`를 준다 — 호출자가 「더 보기」 수단을 거두는
  /// 근거다(FR-008). **이것만으로 소진을 단정하지 않는다**: 서버가 준 후보 안에서
  /// 새것이 없었다는 뜻일 뿐, 영역 안 후보가 모두 소진되었다는 뜻은 아니다(FR-009).
  bool absorb(MapViewportResult result, MapBounds visible) {
    bool inView(MapMarker m) =>
        m.latitude >= visible.minLat &&
        m.latitude <= visible.maxLat &&
        m.longitude >= visible.minLng &&
        m.longitude <= visible.maxLng;

    // 이미 표시한 적 있는 장소는 후보에서 뺀다(FR-004).
    //
    // **[state]로 역산하지 않는다.** [_trim]이 화면 밖 오래된 마커를 버리므로,
    // 지금 들고 있는 것만으로 판정하면 버려진 장소가 다시 후보로 살아난다.
    // 기록과 표시는 수명이 다르다 — 기록은 세션이 끝날 때만 사라진다(FR-005).
    final List<MapMarker> unseen = result.markers
        .where(inView)
        .where((MapMarker m) => !_isServed(m))
        .toList();

    // **격자로 솎지 않는다**(사용자 결정 2026-09-18). 받은 추천은 전부 표시한다.
    //
    // 예전에는 4×4 격자로 칸마다 하나만 남겼다. 겹침을 막으려는 것이었는데 밀집
    // 지역에서는 추천이 좌표상 가까워 같은 칸에 몰린다 — **10개 중 2개만 남았다**
    // (실측). 칸을 늘려도 소용없었다(10×10에서도 4개). 버려진 장소는 표시 기록에
    // 없어 다음 조회에 다시 오고 또 같은 칸에서 솎이므로, 같은 추천만 반복해서
    // 보이고 새것은 영영 못 보는 상태가 됐다.
    //
    // **겹침은 격자가 아니라 보관 상한이 맡는다**([MapTuning.maxRetainedMarkers]).
    // 한때 격자를 없앴다가 마커가 튀어 되돌린 적이 있는데, 원인은 격자가 아니라
    // 렌더러가 목록 인덱스로 POI를 재사용하던 것이었다 — 그쪽을 고쳤으므로
    // (`map_overlay_painter.dart`) 이제 각 장소는 제 POI에 고정된다.
    //
    // **받은 순서를 섞지 않는다**(SPEC-0036 BR-001·QR-001). 예전에는 재검색 때
    // `shuffle()`을 걸었는데, 서버가 늘 같은 순서를 주어 같은 자리에서 다시 눌러도
    // 화면이 그대로였기 때문이다. 이제는 이미 본 장소를 빼서 「다음」을 만들므로
    // 섞을 이유가 없고, 섞으면 점수가 아닌 기준이 선택에 개입한다.
    if (unseen.isEmpty) return false;

    final List<MapMarker> added = unseen
        .take(MapTuning.markersPerBatch)
        .toList();
    for (final MapMarker m in added) {
      _servedKeys.add(_keyOf(m));
      _servedSpotIds.add(m.id);
    }

    // 화면 밖으로 나간 마커는 **버리지 않는다** — 축소하면 다시 화면에 들어오기
    // 때문이다. 이전에는 뷰포트 밖을 버렸더니 줌 아웃할 때마다 마커가 한꺼번에
    // 사라져 지도가 텅 비었다.
    final List<MapMarker> next = <MapMarker>[...state, ...added];

    // 오래 돌아다니면 마커가 무한히 쌓이므로 **보관량**에 상한을 둔다(표시 상한이
    // 아니다 — [MapTuning.maxRetainedMarkers] 참조). 화면 안의 것은 지키고, 넘치는
    // 만큼 가장 오래된 화면 밖 마커부터 버린다.
    state = next.length <= MapTuning.maxRetainedMarkers
        ? next
        : _trim(next, inView, MapTuning.maxRetainedMarkers);
    return true;
  }

  /// 표시 기록을 **지금 화면에 떠 있는 장소**로 맞춘다.
  ///
  /// 화면 밖으로 밀려났거나 보관 상한에 버려진 장소는 더 이상 눈에 없으므로 제외할
  /// 이유가 없다 — 그것들을 계속 들고 있으면 서버가 줄 수 있는 후보가 말라, 화면이
  /// 그대로인데 새로고침만 도는 상태가 된다.
  void _syncServedToScreen(MapBounds visible) {
    final List<MapMarker> onScreen = state
        .where((MapMarker m) => m.kind == MapMarkerKind.spot)
        .where((MapMarker m) => _isInside(m, visible))
        .toList();

    _servedKeys
      ..clear()
      ..addAll(onScreen.map(_keyOf));
    _servedSpotIds
      ..clear()
      ..addAll(onScreen.map((MapMarker m) => m.id));
  }

  /// [bounds] 안에 있는가. 화면 기준 판정을 여러 곳에서 쓰므로 한 자리에 둔다.
  static bool _isInside(MapMarker m, MapBounds bounds) =>
      m.latitude >= bounds.minLat &&
      m.latitude <= bounds.maxLat &&
      m.longitude >= bounds.minLng &&
      m.longitude <= bounds.maxLng;

  /// 이미 표시한 적 있는 장소인가. 고정한 마커도 후보에서 뺀다 — 재검색 때 강조가
  /// 꺼진 같은 장소가 새로 들어오면 빨간 테두리가 사라진다.
  ///
  /// 문화행사를 따로 판정하던 분기는 걷어냈다 — 그 마커를 더 이상 만들지 않는다
  /// (사용자 결정 2026-09-18).
  bool _isServed(MapMarker m) {
    final String key = _keyOf(m);
    return key == _pinnedKey || _servedKeys.contains(key);
  }

  /// 이 세션에서 이미 표시한 **spot의 id**(FR-004). 서버에 제외 목록으로 보낸다.
  ///
  /// 계약의 `excludedIds`가 `[ID!]`라 키가 아니라 id다. 문화행사는 애초에 여기
  /// 들어가지 않는다(FR-012).
  ///
  /// **키에서 잘라내지 않고 따로 든다.** `'kind:id'`를 파싱해 복원하면 id에 콜론이
  /// 들어가는 순간 조용히 틀린 값을 보내게 된다 — 지금은 숫자 문자열이지만 그것은
  /// 계약이 보장하는 바가 아니다.
  List<String> get servedSpotIds => _servedSpotIds.toList();

  /// 이 세션에서 이미 표시한 장소의 키(FR-004).
  ///
  /// **세션 경계는 이 provider의 수명이다**(FR-005). `keepAlive`라 앱이 살아 있는
  /// 동안 유지되고 프로세스가 끝나면 함께 사라진다 — 디스크에 남기지 않는다.
  ///
  /// **영역을 옮겨도 비우지 않는다**(FR-006). 앞 영역에서 본 장소가 새 영역에도
  /// 있으면 다시 고르지 않는다.
  final Set<String> _servedKeys = <String>{};

  /// [_servedKeys] 중 spot의 id만. 서버로 보낼 형태 그대로 든다.
  final Set<String> _servedSpotIds = <String>{};

  /// 검색으로 찾은 장소를 **맨 앞에 고정한다**.
  ///
  /// 이동만 하고 표시가 없으면 사용자는 검색이 제대로 됐는지 알 수 없다 — 지도
  /// 한복판에 아무것도 없으면 "여기가 그 장소인가?"를 확인할 방법이 없다.
  ///
  /// **[_trim]이 이 마커만은 버리지 않는다** — 사용자가 방금 찾은 곳이 다음 조회에
  /// 밀려 사라지면 검색이 헛일이 된다.
  void pin(MapMarker marker) {
    final String key = _keyOf(marker);
    final String? previous = _pinnedKey;
    _pinnedKey = key;

    state = <MapMarker>[
      marker,
      // **이전에 고정한 곳은 강조를 끈다**(사용자 요청, 2026-08-10). 안 그러면
      // 검색할 때마다 빨간 테두리가 하나씩 늘어, 어느 것이 방금 찾은 곳인지
      // 알 수 없다. 마커 자체는 남긴다 — 지웠다 사라지면 화면이 깜빡인다.
      ...state.where((MapMarker m) => _keyOf(m) != key).map((MapMarker m) {
        if (previous == null || _keyOf(m) != previous) return m;
        return MapMarker(
          id: m.id,
          name: m.name,
          latitude: m.latitude,
          longitude: m.longitude,
          kind: m.kind,
          categoryName: m.categoryName,
          subtitle: m.subtitle,
          thumbnailUrl: m.thumbnailUrl,
        );
      }),
    ];
  }

  /// 고정된 마커의 키. 검색으로 찾은 곳 하나만 유지한다 — 여러 개를 고정하면 화면
  /// 상한이 그것들로 차 버린다.
  String? _pinnedKey;

  /// 지도를 벗어나거나 새로 시작할 때 비운다.
  ///
  /// **제외 목록도 함께 비운다** — 로그아웃으로 마커를 버리는 경로(→[build])에서
  /// 기록만 남으면, 다음 사용자가 이 세션에서 본 적 없는 장소를 못 보게 된다.
  void clear() {
    _pinnedKey = null;
    _servedKeys.clear();
    _servedSpotIds.clear();
    state = const <MapMarker>[];
  }

  /// [limit]개가 되도록 줄인다. **화면 안의 것을 지키고** 화면 밖에서 오래된 것부터
  /// 버린다 — 보고 있는 마커가 사라지면 방금 나타난 것이 없어지는 것으로 보인다.
  List<MapMarker> _trim(
    List<MapMarker> markers,
    bool Function(MapMarker) inView,
    int limit,
  ) {
    // 검색으로 찾은 곳은 **어떤 경우에도 지키고** 나머지로 남은 자리를 채운다.
    final List<MapMarker> pinned = markers
        .where((MapMarker m) => _keyOf(m) == _pinnedKey)
        .toList();
    final List<MapMarker> rest = markers
        .where((MapMarker m) => _keyOf(m) != _pinnedKey)
        .toList();
    final int room = (limit - pinned.length).clamp(0, limit);

    final List<MapMarker> shown = rest.where(inView).toList();
    if (shown.length >= room) {
      return <MapMarker>[...pinned, ...shown.sublist(shown.length - room)];
    }

    final List<MapMarker> offscreen = rest
        .where((MapMarker m) => !inView(m))
        .toList();
    final int spare = room - shown.length;
    return <MapMarker>[
      ...pinned,
      ...offscreen.sublist(offscreen.length - spare.clamp(0, offscreen.length)),
      ...shown,
    ];
  }

  /// 종류가 다르면 같은 id라도 다른 마커다.
  String _keyOf(MapMarker m) => '${m.kind.name}:${m.id}';
}
