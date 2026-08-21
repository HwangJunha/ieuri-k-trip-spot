"""칸을 이루는 시군구 폴리곤들을 하나의 외곽선으로 합친다(dissolve).

라이브러리 없이 하기 위해 **원본 좌표가 공유 경계에서 정확히 일치한다**는 성질을
쓴다. 인접 시군구는 같은 정점을 공유하므로, 방향을 무시한 변(edge)이 짝수 번
나타나면 내부 경계이고 홀수 번이면 외곽이다. 홀수인 변만 남겨 이어 붙인다.

**정점이 아니라 변을 소비하며 걷는다.** 정점을 방문 표시하면 두 경로가 한 점에서
만나는 곳(핀치 포인트)에서 걷기가 일찍 끊긴다 — 서울이 두 조각으로 갈리던 원인이
그것이었다. 한 정점을 여러 번 지나는 것은 정상이고, 같은 변을 두 번 지나는 것이
비정상이다.
"""

from collections import defaultdict


def _key(pt, q=7):
    return (round(pt[0], q), round(pt[1], q))


def dissolve(rings):
    """여러 링 -> 공유 변을 제거한 외곽 링 목록."""
    count = defaultdict(int)
    for r in rings:
        pts = [_key(p) for p in r]
        if len(pts) > 1 and pts[0] == pts[-1]:
            pts = pts[:-1]
        n = len(pts)
        if n < 3:
            continue
        for i in range(n):
            a, b = pts[i], pts[(i + 1) % n]
            if a == b:
                continue
            count[(a, b) if a <= b else (b, a)] += 1

    # 인접 리스트는 **남은 변**으로만 만든다.
    adj = defaultdict(list)
    remaining = 0
    for (a, b), c in count.items():
        if c % 2 == 1:
            adj[a].append(b)
            adj[b].append(a)
            remaining += 1

    if not adj:
        return []

    used = set()  # 소비한 변 {frozenset 대신 정렬 튜플}

    def edge(a, b):
        return (a, b) if a <= b else (b, a)

    out = []
    for start in list(adj):
        while True:
            # 이 정점에서 아직 안 쓴 변이 있으면 거기서 링을 하나 시작한다.
            nxt0 = next((p for p in adj[start] if edge(start, p) not in used),
                        None)
            if nxt0 is None:
                break

            ring = [start]
            used.add(edge(start, nxt0))
            cur, prev = nxt0, start

            while cur != start:
                ring.append(cur)
                # 되돌아가는 변은 마지막 수단으로 남긴다(막다른 길에서만 쓴다).
                cand = [p for p in adj[cur]
                        if edge(cur, p) not in used and p != prev]
                if not cand:
                    cand = [p for p in adj[cur] if edge(cur, p) not in used]
                if not cand:
                    break  # 열린 경로 — 데이터가 깨진 경우
                nxt = cand[0]
                used.add(edge(cur, nxt))
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
