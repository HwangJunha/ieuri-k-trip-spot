import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../model/map_bounds.dart';
import '../model/map_marker.dart';
import '../model/map_tuning.dart';
import '../model/map_viewport_result.dart';
import '../model/marker_thinning.dart';
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
    // 로그아웃하면 쌓인 마커를 버린다. 이 컨트롤러는 `add` 의미라 스스로
    // 비워지지 않는다.
    ref.watchSignedIn();
    // 표시 기록도 함께 버린다 — 계정이 바뀌면 「이 세션에서 본 장소」의 주체가
    // 달라진다.
    _servedKeys.clear();
    _pinnedKey = null;
    return const <MapMarker>[];
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
    //
    // **문화행사는 기록하지도 제외하지도 않는다**(FR-012). 이 변경의 대상이 아니라
    // 기존대로 매번 전량 표시되어야 하는데, 제외 목록에 넣으면 재검색 한 번에
    // 행사가 지도에서 영구히 사라진다.
    final List<MapMarker> unseen = result.markers
        .where(inView)
        .where((MapMarker m) => !_isServed(m))
        .toList();

    // 격자로 솎아 골고루 퍼뜨린다. 상한을 넉넉히 주는 이유는 아래에서 한 묶음만큼만
    // 가져가기 때문이다.
    //
    // **받은 순서를 섞지 않는다**(SPEC-0036 BR-001·QR-001). 예전에는 재검색 때
    // `shuffle()`을 걸었는데, 서버가 늘 같은 순서를 주어 같은 자리에서 다시 눌러도
    // 화면이 그대로였기 때문이다. 이제는 이미 본 장소를 빼서 「다음」을 만들므로
    // 섞을 이유가 없고, 섞으면 점수가 아닌 기준이 선택에 개입한다.
    final List<MapMarker> fresh = thinMarkers(
      markers: unseen,
      viewport: visible,
      columns: MapTuning.markerGridColumns,
      maxCount: MapTuning.markersPerBatch * 3,
    );

    if (fresh.isEmpty) return false;

    final List<MapMarker> added = fresh
        .take(MapTuning.markersPerBatch)
        .toList();
    for (final MapMarker m in added) {
      if (m.kind == MapMarkerKind.spot) _servedKeys.add(_keyOf(m));
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

  /// 이미 표시한 적 있는 장소인가. 고정한 마커도 후보에서 뺀다 — 재검색 때 강조가
  /// 꺼진 같은 장소가 새로 들어오면 빨간 테두리가 사라진다.
  ///
  /// **문화행사는 [_servedKeys]가 아니라 지금 들고 있는 것과만 견준다.** 기록에 넣으면
  /// 한 번 표시된 행사가 이 세션 내내 후보에서 빠져 지도에서 영구히 사라지고(FR-012
  /// 위반), 아무것도 안 견주면 재검색할 때마다 같은 행사가 [state]에 쌓여 같은 자리에
  /// SDK 핀이 겹쳐 박힌다.
  bool _isServed(MapMarker m) {
    final String key = _keyOf(m);
    if (key == _pinnedKey) return true;
    if (m.kind != MapMarkerKind.spot) {
      return state.any((MapMarker held) => _keyOf(held) == key);
    }
    return _servedKeys.contains(key);
  }

  /// 이 세션에서 이미 표시한 장소의 키(FR-004).
  ///
  /// **세션 경계는 이 provider의 수명이다**(FR-005). `keepAlive`라 앱이 살아 있는
  /// 동안 유지되고 프로세스가 끝나면 함께 사라진다 — 디스크에 남기지 않는다.
  ///
  /// **영역을 옮겨도 비우지 않는다**(FR-006). 앞 영역에서 본 장소가 새 영역에도
  /// 있으면 다시 고르지 않는다.
  final Set<String> _servedKeys = <String>{};

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
