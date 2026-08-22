import 'map_cell.dart';

/// 시도 1곳의 방문 진척(R21). "경기도 31칸 중 12칸".
///
/// **방문 여부의 롤업이다.** 통계 수치를 합산하지 않는다.
class ProvinceProgress {
  const ProvinceProgress({
    required this.provinceCode,
    required this.provinceName,
    required this.visited,
    required this.total,
  });

  final String provinceCode;
  final String provinceName;

  /// 방문한 칸 수.
  final int visited;

  /// 이 시도의 전체 칸 수.
  final int total;

  /// 0.0~1.0. 칸이 없는 시도는 0이다(0으로 나누지 않는다).
  double get ratio => total == 0 ? 0 : visited / total;

  bool get isComplete => total > 0 && visited == total;

  @override
  bool operator ==(Object other) =>
      other is ProvinceProgress &&
      other.provinceCode == provinceCode &&
      other.provinceName == provinceName &&
      other.visited == visited &&
      other.total == total;

  @override
  int get hashCode => Object.hash(provinceCode, provinceName, visited, total);
}

/// 칸 목록에서 시도별 진척을 계산한다(R21).
///
/// **클라이언트가 계산한다** — 161칸을 이미 전량 갖고 있어 서버가 같은 값을 다시
/// 내려줄 이유가 없다(설계 §7).
///
/// 반환 순서는 시도 코드 오름차순이다(POL-019와 같은 결정성).
List<ProvinceProgress> provinceProgressOf(Iterable<MapCell> cells) {
  final Map<String, ({String name, int visited, int total})> acc =
      <String, ({String name, int visited, int total})>{};

  for (final MapCell cell in cells) {
    final ({String name, int visited, int total})? prev = acc[cell.provinceCode];
    acc[cell.provinceCode] = (
      name: prev?.name ?? cell.provinceName,
      visited: (prev?.visited ?? 0) + (cell.visited ? 1 : 0),
      total: (prev?.total ?? 0) + 1,
    );
  }

  final List<String> codes = acc.keys.toList()..sort();
  return <ProvinceProgress>[
    for (final String code in codes)
      ProvinceProgress(
        provinceCode: code,
        provinceName: acc[code]!.name,
        visited: acc[code]!.visited,
        total: acc[code]!.total,
      ),
  ];
}

/// 전국 진척(칸 161개 기준).
ProvinceProgress nationwideProgressOf(
  Iterable<MapCell> cells, {
  required String label,
}) {
  int visited = 0;
  int total = 0;
  for (final MapCell cell in cells) {
    total++;
    if (cell.visited) visited++;
  }
  return ProvinceProgress(
    provinceCode: '',
    provinceName: label,
    visited: visited,
    total: total,
  );
}
