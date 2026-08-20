# 전국 지도 칸 도형 (SPEC-0030)

`korea_cells.json` — 전국 161칸의 단순화된 경계 도형. 앱에 내장해 `CustomPainter`로
직접 그린다. 지도 타일 위에 얹지 않는다(설계 §3).

## 출처와 라이선스

원본은 **통계청(KOSTAT) 2013 시군구 경계**이며,
[southkorea/southkorea-maps](https://github.com/southkorea/southkorea-maps)의
`kostat/2013/json/skorea_municipalities_geo_simple.json`에서 받았다.

해당 저장소가 밝힌 KOSTAT 데이터의 라이선스는 **"Free to share or remix"**다.

> **같은 저장소의 GADM 데이터는 쓰지 않는다.** GADM은 비상업 용도로 한정되고
> 재배포가 금지되어 이 앱에 담을 수 없다. 반드시 `kostat/` 경로의 파일만 쓴다.

## 생성 방법

```sh
curl -sL -o /tmp/sigungu.json \
  https://raw.githubusercontent.com/southkorea/southkorea-maps/master/kostat/2013/json/skorea_municipalities_geo_simple.json
python3 tool/build_cells.py /tmp/sigungu.json asset/geo/korea_cells.json
```

`tool/build_cells.py`가 하는 일:

1. **칸으로 묶는다**(R7) — 광역시 전체가 1칸, 구를 가진 일반시 12곳은 시 단위 1칸,
   나머지는 시군 1칸
2. **칸 안의 경계를 지운다** — 공유 변을 상쇄해 외곽선 하나로 합친다(dissolve).
   서울 25개 구가 링 1개(51점)가 되며 면적은 보존된다
3. **Douglas-Peucker로 정점을 줄이고** 아주 작은 섬 링은 버린다
4. 칸별 대표 좌표(폴리곤 무게중심)를 계산한다

결과는 161칸 · 약 7,100점 · 약 180KB다.

## 2013년 기준 데이터의 보정

원본이 2013년 기준이라 현행 행정구역과 두 곳이 다르다. 생성기가 보정한다.

| 시군구 | 원본 | 현행 | 처리 |
|---|---|---|---|
| 청원군(33310) | 충북의 독립 군 | 2014년 청주시에 통합 | 청주시 칸에 합친다 |
| 군위군(37310) | 경북 소속 | 2023년 대구광역시로 편입 | 대구 칸에 합친다 |

보정 전 163칸, 보정 후 **161칸**으로 스펙과 일치한다. 경기도가 31칸인 것도
스펙의 예시("경기도 31칸 중 12칸")와 맞는다.

## 파일 형식

```jsonc
{
  "version": 1,
  "cells": [
    {
      "code": "11",                    // 칸 코드(서버 mapCells의 code와 대응시킬 키)
      "nameKo": "서울특별시",
      "nameEn": "Seoul",
      "provinceCode": "11",            // 현행 시도 코드 2자리
      "provinceNameKo": "서울특별시",
      "provinceNameEn": "Seoul",
      "districtCodes": ["11010", ...], // 이 칸이 포함하는 시군구 코드
      "center": [126.99, 37.55],       // [경도, 위도]
      "polygons": [[[126.9, 37.5], ...]]
    }
  ]
}
```

**칸 이름은 표시에 쓰지 않는다.** 화면에 보이는 명칭은 활성 언어로 서버가 준다(R8).
여기 담긴 `nameKo`/`nameEn`은 서버 응답과 칸을 맞추고 디버깅할 때 쓰는 값이다.

## 좌표계 주의

값은 WGS84 경위도 그대로다. 화면에 그릴 때 **경도를 `cos(위도)`로 보정하지 않으면
가로로 늘어진다** — 36°N에서 경도 1도는 위도 1도의 약 0.81배다. 보정은
`CellProjection`이 담당한다.
