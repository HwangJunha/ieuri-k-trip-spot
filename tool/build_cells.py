"""서버 경계 데이터(`district-boundaries.geojson`) -> 렌더링용 161칸 도형.

SPEC-0030. 자산이 둘인 이유는 **용도가 다르기 때문**이다.

  district-boundaries.geojson  252 시군구 원본  3.8MB  좌표 판정용(정확도)
  korea_cells.json             161칸 단순화     ~180KB 지도 렌더링용(가벼움)

판정은 서버 PostGIS와 결과가 같아야 하므로 원본을 그대로 쓴다. 반면 그리기는
13만 점을 매 프레임 훑을 이유가 없고, 칸 안의 시군구 경계는 보이면 안 된다.

**두 자산의 시군구 코드는 반드시 같은 체계여야 한다.** 그래서 렌더링본을
원본에서 생성한다 — 예전에는 KOSTAT 2013(종로구 `11010`)에서 만들었는데
서버는 현행 코드(종로구 `11110`)를 써서 `districtCodes` 대응이 불가능했다.
게다가 우연히 숫자가 겹치는 코드가 9개 있어(`31110`이 한쪽은 경기, 다른 쪽은
울산 중구) 조용히 틀릴 수 있었다.

사용법:
    python3 tool/build_cells.py \
        asset/geo/district-boundaries.geojson asset/geo/korea_cells.json
"""

import json
import math
import re
import sys
from collections import OrderedDict

import dissolve as _dis

# 광역시·특별시·특별자치시는 통째로 1칸이다(R7).
METRO = {'11', '26', '27', '28', '29', '30', '31', '36'}

# 시도 코드 -> (KO, EN). 서버 경계에 시도명이 없어 여기서 준다.
PROVINCE = {
    '11': ('서울특별시', 'Seoul'),
    '26': ('부산광역시', 'Busan'),
    '27': ('대구광역시', 'Daegu'),
    '28': ('인천광역시', 'Incheon'),
    '29': ('광주광역시', 'Gwangju'),
    '30': ('대전광역시', 'Daejeon'),
    '31': ('울산광역시', 'Ulsan'),
    '36': ('세종특별자치시', 'Sejong'),
    '41': ('경기도', 'Gyeonggi-do'),
    '43': ('충청북도', 'Chungcheongbuk-do'),
    '44': ('충청남도', 'Chungcheongnam-do'),
    '46': ('전라남도', 'Jeollanam-do'),
    '47': ('경상북도', 'Gyeongsangbuk-do'),
    '48': ('경상남도', 'Gyeongsangnam-do'),
    '50': ('제주특별자치도', 'Jeju-do'),
    '51': ('강원특별자치도', 'Gangwon-do'),
    '52': ('전북특별자치도', 'Jeonbuk-do'),
}

# "수원시 장안구" 처럼 일반시 + 자치구인 이름. 시 단위로 1칸이 된다(12곳).
_GU_OF_SI = re.compile(r'^(.+?시)\s+.+구$')


def cell_key(props):
    """이 시군구가 속할 칸의 (키, 표시명 KO, 표시명 EN)."""
    area = props['areaCd']
    if area in METRO:
        ko, en = PROVINCE[area]
        return area, ko, en

    m = _GU_OF_SI.match(props['nameKo'])
    if m:
        si_ko = m.group(1)
        # 영문도 같은 규칙으로 자른다: "Suwon-si Jangan-gu" -> "Suwon-si"
        si_en = props['nameEn'].split(' ')[0]
        return area + '_' + si_ko, si_ko, si_en

    return props['code'], props['nameKo'], props['nameEn']


def outer_rings(geom):
    """MultiPolygon/Polygon -> 외곽 링 목록. 구멍은 렌더링에 쓰지 않는다.

    구멍이 중요한 것은 **판정**이고, 그건 원본 파일이 담당한다. 칸을 칠할 때
    구멍까지 뚫으면 오히려 지도가 지저분해진다(전국 9개뿐이다).
    """
    if geom['type'] == 'Polygon':
        return [geom['coordinates'][0]]
    return [poly[0] for poly in geom['coordinates']]


def perp_dist(p, a, b):
    (px, py), (ax, ay), (bx, by) = p, a, b
    dx, dy = bx - ax, by - ay
    if dx == 0 and dy == 0:
        return math.hypot(px - ax, py - ay)
    t = ((px - ax) * dx + (py - ay) * dy) / (dx * dx + dy * dy)
    t = max(0.0, min(1.0, t))
    return math.hypot(px - (ax + t * dx), py - (ay + t * dy))


def simplify(points, eps):
    """Douglas-Peucker. 재귀 대신 스택으로 돈다 — 링 하나가 수천 점이라
    재귀로 하면 파이썬 기본 재귀 한도를 넘는다."""
    n = len(points)
    if n < 3:
        return points
    keep = [False] * n
    keep[0] = keep[n - 1] = True
    stack = [(0, n - 1)]
    while stack:
        lo, hi = stack.pop()
        if hi <= lo + 1:
            continue
        dmax, idx = 0.0, lo
        for i in range(lo + 1, hi):
            d = perp_dist(points[i], points[lo], points[hi])
            if d > dmax:
                dmax, idx = d, i
        if dmax > eps:
            keep[idx] = True
            stack.append((lo, idx))
            stack.append((idx, hi))
    return [p for p, k in zip(points, keep) if k]


def ring_area(ring):
    s = 0.0
    n = len(ring)
    for i in range(n):
        x1, y1 = ring[i]
        x2, y2 = ring[(i + 1) % n]
        s += x1 * y2 - x2 * y1
    return abs(s) / 2.0


def centroid(ring):
    a = cx = cy = 0.0
    n = len(ring)
    for i in range(n):
        x1, y1 = ring[i]
        x2, y2 = ring[(i + 1) % n]
        cross = x1 * y2 - x2 * y1
        a += cross
        cx += (x1 + x2) * cross
        cy += (y1 + y2) * cross
    if a == 0:
        return list(ring[0])
    a *= 0.5
    return [cx / (6 * a), cy / (6 * a)]


def main(src, dst, eps=0.004, min_area=0.0006, quant=5):
    data = json.load(open(src, encoding='utf-8'))

    cells = OrderedDict()
    for f in data['features']:
        p = f['properties']
        key, ko, en = cell_key(p)
        if key not in cells:
            pko, pen = PROVINCE[p['areaCd']]
            cells[key] = {
                'provinceCode': p['areaCd'],
                'provinceNameKo': pko,
                'provinceNameEn': pen,
                'nameKo': ko,
                'nameEn': en,
                'districtCodes': [],
                'rings': [],
            }
        cells[key]['districtCodes'].append(p['code'])
        cells[key]['rings'].extend(outer_rings(f['geometry']))

    print('cells:', len(cells), file=sys.stderr)

    out = []
    for key, c in cells.items():
        # 칸 안의 시군구 경계를 지운다 — 칸이 채워졌을 때 내부에 선이 보이면 안 된다.
        merged = _dis.dissolve(c['rings']) if len(c['rings']) > 1 else c['rings']
        if not merged:
            merged = c['rings']

        polys = []
        for r in merged:
            if ring_area(r) < min_area:
                continue
            s = simplify(r, eps)
            if len(s) < 4:
                continue
            polys.append([[round(x, quant), round(y, quant)] for x, y in s])

        if not polys:
            # 전부 걸러졌으면 가장 큰 링을 하나 남긴다(울릉군 등 작은 섬).
            biggest = max(merged, key=ring_area)
            s = simplify(biggest, eps / 4)
            polys.append([[round(x, quant), round(y, quant)] for x, y in s])

        polys.sort(key=ring_area, reverse=True)
        ctr = centroid(polys[0])
        out.append({
            'code': key,
            'nameKo': c['nameKo'],
            'nameEn': c['nameEn'],
            'provinceCode': c['provinceCode'],
            'provinceNameKo': c['provinceNameKo'],
            'provinceNameEn': c['provinceNameEn'],
            'districtCodes': sorted(c['districtCodes']),
            'center': [round(ctr[0], quant), round(ctr[1], quant)],
            'polygons': polys,
        })

    out.sort(key=lambda c: (c['provinceCode'], c['code']))
    payload = {
        'version': 1,
        'source': 'district-boundaries.geojson (server, SPEC-0030)',
        'cells': out,
    }
    with open(dst, 'w', encoding='utf-8') as fp:
        json.dump(payload, fp, ensure_ascii=False, separators=(',', ':'))

    print('points:', sum(len(p) for c in out for p in c['polygons']),
          file=sys.stderr)


if __name__ == '__main__':
    main(sys.argv[1], sys.argv[2],
         eps=float(sys.argv[3]) if len(sys.argv) > 3 else 0.004)
