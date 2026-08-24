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
    return const <MapMarker>[];
  }


  /// 새 조회 결과를 기존 마커에 **더한다**.
  ///
  /// [visible]은 **화면에 실제로 보이는 영역**이다. 조회는 그보다 넓게 하지만(작은
  /// 이동에 재조회가 걸리지 않도록), 마커를 고르고 격자를 나누는 기준은 화면이어야
  /// 한다 — 넓은 영역으로 격자를 나누면 칸 대부분이 화면 밖이라, 열 개를 뽑아도
  /// 화면에는 예닐곱만 남는다.
  void absorb(
    MapViewportResult result,
    MapBounds visible, {
    bool replaceShown = false,
  }) {
    bool inView(MapMarker m) =>
        m.latitude >= visible.minLat &&
        m.latitude <= visible.maxLat &&
        m.longitude >= visible.minLng &&
        m.longitude <= visible.maxLng;

    // **고정 마커는 상한 계산에서 아예 뺀다.**
    //
    // 검색으로 찾은 곳은 항상 보여야 하는 것이라, 상한을 두고 예외를 다는 대신
    // 처음부터 셈에서 제외한다 — 예외로 처리했더니 `room`이 0이 되어 조기 반환하는
    // 경로에서 조용히 밀려났다. 상한은 **조회로 채우는 마커**에만 적용된다.
    bool isPinned(MapMarker m) => _keyOf(m) == _pinnedKey;

    final List<MapMarker> shown = state
        .where((MapMarker m) => inView(m) && !isPinned(m))
        .toList();

    // 화면 밖으로 나간 마커는 자리를 차지하지 않지만 **버리지도 않는다** — 축소하면
    // 다시 화면에 들어오기 때문이다. 이전에는 뷰포트 밖을 버렸더니 줌 아웃할 때마다
    // 마커가 한꺼번에 사라져 지도가 텅 비었다.
    //
    // [replaceShown]이면 자리가 없어도 **화면 안의 것을 비워 새 장소를 넣는다** —
    // "이 지역 재검색"을 눌렀는데 아무것도 안 바뀌면 버튼이 동작하지 않는 것으로
    // 보인다. 화면 밖의 것은 그대로 둔다.
    final int room = replaceShown
        ? MapTuning.maxDrawnMarkers
        : MapTuning.maxDrawnMarkers - shown.length;
    if (room <= 0) return;

    // 교체할 때는 화면 안의 것을 후보에서 빼지 않는다 — 그래야 그 자리에 다른
    // 장소가 들어올 수 있다. 대신 화면 밖의 것과는 여전히 중복을 피한다.
    final Set<String> known = <String>{
      ...replaceShown
          ? state.where((MapMarker m) => !inView(m)).map(_keyOf)
          : state.map(_keyOf),
      // **고정 마커는 항상 후보에서 뺀다.** 재검색 때 화면 안의 것을 후보로 되돌리는데
      // 거기 섞이면, 강조가 꺼진 같은 장소가 새로 들어와 빨간 테두리가 사라진다.
      if (_pinnedKey case final String key) key,
    };

    // 화면 안에 있는 것만 후보다 — 화면 밖까지 고르면 사용자가 보고 있는 곳이 비고
    // 가장자리 밖에만 마커가 찍힌다.
    //
    // **이미 가진 것을 격자에 넣기 전에 뺀다.** 순서가 반대면(격자 → 제외) 격자가
    // 칸마다 늘 같은 첫 번째를 고르므로, 같은 자리에서 재검색해도 결과가 그대로였다 —
    // 사용자가 "똑같은 데이터가 나온다"고 지적한 지점이다. 먼저 걸러 내면 두 번째
    // 검색은 그 칸의 **다음** 장소를 고른다.
    final List<MapMarker> unseen = result.markers
        .where(inView)
        .where((MapMarker m) => !known.contains(_keyOf(m)))
        .toList();

    // **재검색이면 순서를 섞는다**(사용자 요청, 2026-08-10).
    //
    // 서버는 관련도 순으로 늘 같은 500건을 주고 격자도 칸마다 첫 번째를 고르므로,
    // 같은 자리에서 다시 눌러도 결과가 그대로였다. 섞으면 매번 다른 곳이 뽑혀
    // "재검색"이 실제로 새로운 것을 보여 준다.
    //
    // 지도 이동으로 인한 흡수는 섞지 않는다 — 그때는 새 영역이라 이미 다른 후보이고,
    // 섞으면 남아 있던 마커 옆에 엉뚱한 것이 끼어 화면이 어수선해진다.
    if (replaceShown) unseen.shuffle();

    // 격자로 솎아 골고루 퍼뜨린다. 상한을 넉넉히 주는 이유는 아래에서 남은 자리만큼만
    // 가져가기 때문이다.
    final List<MapMarker> fresh = thinMarkers(
      markers: unseen,
      viewport: visible,
      columns: MapTuning.markerGridColumns,
      maxCount: MapTuning.maxDrawnMarkers * 3,
    );

    if (fresh.isEmpty) return;

    // 교체할 때는 화면 안의 이전 마커를 비우고 새것으로 채운다. 화면 밖의 것은
    // 그대로 둔다 — 축소하면 다시 보여야 한다.
    //
    // **검색으로 고정한 마커는 예외다** — 화면 안에 있어도 지우지 않는다. 사용자가
    // 방금 찾은 곳이 재검색 한 번에 사라지면 검색이 헛일이 된다.
    final List<MapMarker> kept = replaceShown
        ? state.where((MapMarker m) => !inView(m) || isPinned(m)).toList()
        : state;

    final List<MapMarker> next = <MapMarker>[...kept, ...fresh.take(room)];

    // 오래 돌아다니면 화면 밖 마커가 쌓이므로 보관량에 상한을 둔다. 화면 안의 것은
    // 지키고, 넘치는 만큼 **가장 오래된 화면 밖 마커**부터 버린다.
    state = next.length <= MapTuning.maxRetainedMarkers
        ? next
        : _trim(next, inView, MapTuning.maxRetainedMarkers);
  }

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
  void clear() {
    _pinnedKey = null;
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
