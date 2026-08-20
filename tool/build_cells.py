"""KOSTAT 시군구 GeoJSON(2013) -> 161칸 단순화 지도 자산 생성기.

SPEC-0030. 원본은 southkorea/southkorea-maps의 KOSTAT 2013 simplified
municipalities(라이선스: free to share or remix)이며, 이 스크립트가
칸 묶음 규칙(R7)을 적용하고 좌표를 줄여 앱 자산으로 만든다.

2013 기준 데이터라 두 곳이 현재 행정구역과 다르다. 여기서 보정한다.
  - 청원군(33310)은 2014년 청주시에 통합됐다 -> 청주시 칸에 합친다
  - 군위군(37310)은 2023년 대구광역시로 편입됐다 -> 대구 칸에 합친다
이 둘을 반영하면 163칸이 161칸이 된다.
"""

import json
import math
import re
import sys
from collections import OrderedDict

METRO = {
    '11': ('11', '서울특별시', 'Seoul'),
    '21': ('26', '부산광역시', 'Busan'),
    '22': ('27', '대구광역시', 'Daegu'),
    '23': ('28', '인천광역시', 'Incheon'),
    '24': ('29', '광주광역시', 'Gwangju'),
    '25': ('30', '대전광역시', 'Daejeon'),
    '26': ('31', '울산광역시', 'Ulsan'),
    '29': ('36', '세종특별자치시', 'Sejong'),
}

# 원본 2자리 시도 코드 -> (현행 시도코드, KO, EN)
PROVINCE = {
    '11': ('11', '서울특별시', 'Seoul'),
    '21': ('26', '부산광역시', 'Busan'),
    '22': ('27', '대구광역시', 'Daegu'),
    '23': ('28', '인천광역시', 'Incheon'),
    '24': ('29', '광주광역시', 'Gwangju'),
    '25': ('30', '대전광역시', 'Daejeon'),
    '26': ('31', '울산광역시', 'Ulsan'),
    '29': ('36', '세종특별자치시', 'Sejong'),
    '31': ('41', '경기도', 'Gyeonggi-do'),
    '32': ('42', '강원특별자치도', 'Gangwon-do'),
    '33': ('43', '충청북도', 'Chungcheongbuk-do'),
    '34': ('44', '충청남도', 'Chungcheongnam-do'),
    '35': ('45', '전라북도', 'Jeonbuk-do'),
    '36': ('46', '전라남도', 'Jeollanam-do'),
    '37': ('47', '경상북도', 'Gyeongsangbuk-do'),
    '38': ('48', '경상남도', 'Gyeongsangnam-do'),
    '39': ('50', '제주특별자치도', 'Jeju-do'),
}

# 2013 -> 현행 보정
REASSIGN = {
    '33310': ('33', '청주시'),   # 청원군 -> 청주시 칸
    '37310': ('22', None),       # 군위군 -> 대구광역시 칸
}


def cell_of(code, name):
    """이 시군구가 속할 칸의 (키, 표시명 KO)."""
    if code in REASSIGN:
        prov, target = REASSIGN[code]
        if target is None:
            return prov, METRO[prov][1]
        return prov + '_' + target, target
    prov = code[:2]
    if prov in METRO:
        return prov, METRO[prov][1]
    m = re.match(r'^(.+?시)(.+구)$', name)
    if m:
        return prov + '_' + m.group(1), m.group(1)
    return code, name


def rings(geom):
    """Polygon/MultiPolygon -> 외곽 링 목록(구멍은 버린다)."""
    if geom['type'] == 'Polygon':
        return [geom['coordinates'][0]]
    out = []
    for poly in geom['coordinates']:
        out.append(poly[0])
    return out


def perp_dist(p, a, b):
    (px, py), (ax, ay), (bx, by) = p, a, b
    dx, dy = bx - ax, by - ay
    if dx == 0 and dy == 0:
        return math.hypot(px - ax, py - ay)
    t = ((px - ax) * dx + (py - ay) * dy) / (dx * dx + dy * dy)
    t = max(0.0, min(1.0, t))
    return math.hypot(px - (ax + t * dx), py - (ay + t * dy))


def simplify(points, eps):
    """Douglas-Peucker. 닫힌 링은 시작점을 고정한 채 줄인다."""
    if len(points) < 3:
        return points
    dmax, idx = 0.0, 0
    for i in range(1, len(points) - 1):
        d = perp_dist(points[i], points[0], points[-1])
        if d > dmax:
            dmax, idx = d, i
    if dmax <= eps:
        return [points[0], points[-1]]
    left = simplify(points[:idx + 1], eps)
    right = simplify(points[idx:], eps)
    return left[:-1] + right


def ring_area(ring):
    s = 0.0
    for i in range(len(ring)):
        x1, y1 = ring[i]
        x2, y2 = ring[(i + 1) % len(ring)]
        s += x1 * y2 - x2 * y1
    return abs(s) / 2.0


def centroid(ring):
    a = 0.0
    cx = cy = 0.0
    for i in range(len(ring)):
        x1, y1 = ring[i]
        x2, y2 = ring[(i + 1) % len(ring)]
        cross = x1 * y2 - x2 * y1
        a += cross
        cx += (x1 + x2) * cross
        cy += (y1 + y2) * cross
    if a == 0:
        return ring[0]
    a *= 0.5
    return [cx / (6 * a), cy / (6 * a)]


def main(src, dst, eps=0.004, min_area=0.0006, quant=5):
    data = json.load(open(src, encoding='utf-8'))

    cells = OrderedDict()
    for f in data['features']:
        p = f['properties']
        code, name = p['code'], p['name']
        key, label = cell_of(code, name)
        prov_raw = REASSIGN[code][0] if code in REASSIGN else code[:2]
        if key not in cells:
            pc, pko, pen = PROVINCE[prov_raw]
            cells[key] = {
                'provinceCode': pc,
                'provinceNameKo': pko,
                'provinceNameEn': pen,
                'nameKo': label,
                'nameEn': None,
                'districtCodes': [],
                'rings': [],
            }
        c = cells[key]
        c['districtCodes'].append(code)
        c['rings'].extend(rings(f['geometry']))
        # 칸 이름이 시군구 이름과 같으면 원본 영문명을 그대로 쓴다
        if c['nameEn'] is None and name == c['nameKo']:
            c['nameEn'] = p.get('name_eng')

    print('cells:', len(cells), file=sys.stderr)

    import dissolve as _dis

    out = []
    for key, c in cells.items():
        # 칸 안의 시군구 경계는 지운다 — 칸이 채워졌을 때 내부에 선이 보이면 안 된다.
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
            s = [[round(x, quant), round(y, quant)] for x, y in s]
            polys.append(s)
        if not polys:
            # 전부 걸러졌으면 가장 큰 링을 무조건 하나 남긴다(울릉군 등 작은 섬)
            biggest = max(merged, key=ring_area)
            s = simplify(biggest, eps / 4)
            polys.append([[round(x, quant), round(y, quant)] for x, y in s])
        polys.sort(key=ring_area, reverse=True)
        ctr = centroid(polys[0])
        out.append({
            'code': key,
            'nameKo': c['nameKo'],
            'nameEn': c['nameEn'] or c['nameKo'],
            'provinceCode': c['provinceCode'],
            'provinceNameKo': c['provinceNameKo'],
            'provinceNameEn': c['provinceNameEn'],
            'districtCodes': sorted(c['districtCodes']),
            'center': [round(ctr[0], quant), round(ctr[1], quant)],
            'polygons': polys,
        })

    out.sort(key=lambda c: (c['provinceCode'], c['code']))
    payload = {'version': 1, 'source': 'KOSTAT 2013 via southkorea/southkorea-maps',
               'cells': out}
    with open(dst, 'w', encoding='utf-8') as fp:
        json.dump(payload, fp, ensure_ascii=False, separators=(',', ':'))

    pts = sum(len(p) for c in out for p in c['polygons'])
    print('points:', pts, file=sys.stderr)


if __name__ == '__main__':
    main(sys.argv[1], sys.argv[2],
         eps=float(sys.argv[3]) if len(sys.argv) > 3 else 0.004)
