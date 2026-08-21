# 전국 지도 지오 자산 (SPEC-0030)

**두 파일이고 용도가 다르다.** 하나로 합치지 않는다.

| 파일 | 내용 | 크기 | 용도 |
|---|---|---|---|
| `district-boundaries.geojson` | 252 시군구 **원본** 경계 | 3.8MB | **좌표 판정**(point-in-polygon) |
| `korea_cells.json` | 161칸 **단순화** 도형 | ~300KB | **지도 렌더링** |

판정은 서버 PostGIS와 결과가 같아야 하므로 단순화하지 않은 원본을 쓴다. 반면
그리기는 13만 점을 매 프레임 훑을 이유가 없고, 칸 안의 시군구 경계가 보이면
안 되므로 미리 합쳐 둔 단순화본을 쓴다.

## district-boundaries.geojson — 판정용

서버가 전달한 파일이다(SPEC-0030 클라이언트 지시 §0). `resolveDistricts` API가
삭제되면서 좌표 판정이 클라이언트로 왔고, **좌표는 이제 서버 경계를 넘지 않는다**
(POL-045를 약속이 아니라 구조로 보장).

- GeoJSON FeatureCollection, 252 feature, 전부 `MultiPolygon`
- 좌표는 **`[경도, 위도]`** (GeoJSON 표준). 뒤집으면 전 국토가 엉뚱한 곳으로 간다
- **구멍(hole)이 있다** — `polygon[0]`이 외곽 링, `polygon[1:]`이 구멍이다.
  전국에 9개뿐이지만 외곽 안이어도 구멍 안이면 **미포함**으로 처리해야 한다
- `properties`: `code`(시군구 5자리) · `areaCd`(시도 2자리) ·
  `nameKo` · `nameEn` · `nameJa` · `nameZh`

판정 정확도는 서버가 검증했고 이 레포에서도 확인했다(테스트에 고정):
서울시청 → `11140` 중구 · 수원 → `41111` 장안구 · 동해·도쿄 → 미판정.

## korea_cells.json — 렌더링용

`district-boundaries.geojson`에서 **생성한다.**

```sh
python3 tool/build_cells.py \
    asset/geo/district-boundaries.geojson asset/geo/korea_cells.json
```

`tool/build_cells.py`가 하는 일:

1. **칸으로 묶는다**(R7) — 광역시 전체가 1칸, 구를 가진 일반시 12곳은 시 단위
   1칸, 나머지는 시군 1칸. 결과는 161칸이고 경기도가 31칸이다
2. **칸 안의 경계를 지운다** — 공유 변을 상쇄해 외곽선으로 합친다(dissolve).
   서울 25개 구가 링 1개(82점)가 된다
3. Douglas-Peucker로 정점을 줄이고 아주 작은 섬 링은 버린다
4. 칸별 대표 좌표(가장 큰 폴리곤의 무게중심)를 계산한다

결과는 161칸 · 약 13,000점 · 약 300KB다.

### 반드시 원본에서 생성해야 하는 이유

**두 자산의 시군구 코드 체계가 같아야 한다.** 서버가 주는 `MapCell.districtCodes`를
렌더링 칸에 대응시키는 열쇠가 그것이기 때문이다.

한때 이 파일을 KOSTAT 2013 데이터에서 만들었는데, 그쪽은 종로구가 `11010`이고
서버는 현행 행정표준코드로 `11110`이라 252개 중 243개가 어긋났다. 더 나쁜 것은
**우연히 숫자가 겹치는 코드가 9개** 있었다는 점이다 — `31110`이 KOSTAT에서는
경기도의 어떤 시군구이고 현행 체계에서는 울산 중구다. 조용히 틀리는 종류의 버그라
자산을 하나의 출처에서 생성하도록 바꿨다.

KOSTAT 2013을 쓸 때 필요했던 청원군·군위군 보정도 사라졌다 — 서버 데이터가 이미
현행 행정구역이다.

### 파일 형식

```jsonc
{
  "version": 1,
  "cells": [
    {
      "code": "11",                    // 이 자산 안에서만 쓰는 칸 키
      "nameKo": "서울특별시",
      "nameEn": "Seoul",
      "provinceCode": "11",
      "provinceNameKo": "서울특별시",
      "provinceNameEn": "Seoul",
      "districtCodes": ["11110", ...], // 서버 MapCell과 잇는 열쇠
      "center": [126.99, 37.55],       // [경도, 위도]
      "polygons": [[[126.9, 37.5], ...]]
    }
  ]
}
```

**`code`는 서버의 `MapCell.id`가 아니다.** 서버 칸 id는 `1`~`161`의 `ID!`이고
이 자산과 대응하는 공식 키가 없다. 둘은 `districtCodes`가 겹치는지로 잇는다
(`CellGeometryIndex`).

**칸 이름은 표시에 쓰지 않는다.** 화면 명칭은 활성 언어로 서버가 준다(R8).
여기 담긴 `nameKo`/`nameEn`은 대응 확인과 디버깅용이다.

## 좌표계 주의

값은 WGS84 경위도 그대로다. 화면에 그릴 때 **경도를 `cos(위도)`로 보정하지 않으면
가로로 늘어진다** — 36°N에서 경도 1도는 위도 1도의 약 0.81배다. 보정은
`CellProjection`이 한다.
