"""칸을 이루는 시군구 폴리곤들을 하나의 외곽선으로 합친다(dissolve).

라이브러리 없이 하기 위해 **원본 좌표가 공유 경계에서 정확히 일치한다**는 성질을 쓴다.
KOSTAT 폴리곤은 인접 구역이 같은 정점을 공유하므로, 방향을 무시한 변(edge)이
두 번 나타나면 내부 경계다. 한 번만 나타난 변만 남기면 외곽선이 된다.

남은 변들을 이어 붙여 링을 만든다. 섬이 있으면 링이 여러 개 나온다.
"""

import json
import math
from collections import defaultdict


def _key(pt, q=7):
    return (round(pt[0], q), round(pt[1], q))


def dissolve(rings):
    """여러 링 -> 공유 변을 제거한 외곽 링 목록."""
    count = defaultdict(int)
    for r in rings:
        pts = [_key(p) for p in r]
        if pts[0] == pts[-1]:
            pts = pts[:-1]
        n = len(pts)
        for i in range(n):
            a, b = pts[i], pts[(i + 1) % n]
            count[(a, b) if a <= b else (b, a)] += 1

    # 홀수 번 나온 변만 외곽이다(보통 1회). 짝수는 내부에서 상쇄된다.
    adj = defaultdict(list)
    for (a, b), c in count.items():
        if c % 2 == 1:
            adj[a].append(b)
            adj[b].append(a)

    if not adj:
        return []

    out = []
    used = set()
    for start in list(adj):
        if start in used or not adj[start]:
            continue
        ring = [start]
        used.add(start)
        cur, prev = start, None
        while True:
            nxts = [p for p in adj[cur] if p != prev]
            nxts = [p for p in nxts if p not in used or p == start]
            if not nxts:
                break
            nxt = nxts[0]
            if nxt == start:
                break
            ring.append(nxt)
            used.add(nxt)
            prev, cur = cur, nxt
        if len(ring) >= 4:
            out.append([list(p) for p in ring])
    return out


def ring_area(ring):
    s = 0.0
    n = len(ring)
    for i in range(n):
        x1, y1 = ring[i]
        x2, y2 = ring[(i + 1) % n]
        s += x1 * y2 - x2 * y1
    return abs(s) / 2.0
