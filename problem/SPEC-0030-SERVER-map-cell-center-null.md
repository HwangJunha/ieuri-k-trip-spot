# SPEC-0030 — `MapCell.center`가 항상 null이라 조회가 통째로 실패한다

- 대상 오퍼레이션: `mapCells`, `mapCell(id:)`
- 확인 환경: `http://localhost:8888/graphql` (2026-08-22)
- 상태: **해소됨(2026-08-22, 서버 수정 확인)**

## 증상

`MapCell.center`를 고르면 **161칸 전부**에서 `lat`·`lng`가 null로 와서 응답이
통째로 무너진다. `Coordinates!`가 non-null이라 null이 위로 전파되어 `mapCells`
전체가 `null`이 된다 — 한 칸만 깨지는 게 아니라 지도를 아예 못 그린다.

```sh
jq -n '{query:"{ mapCells { id center { lat lng } } }"}' \
  | curl -s -X POST http://localhost:8888/graphql \
      -H 'Content-Type: application/json' -d @-
```

```
errors: 322          # 161칸 × (lat, lng)
data.mapCells: null
```

에러 메시지:

> The field at path '/mapCells[0]/center/lat' was declared as a non null type,
> but the code involved in retrieving data has wrongly returned a null value.

`mapCell(id: "2")` 단건도 같다.

## 나머지는 정상이다

`center`만 빼면 전부 제대로 온다 — 161칸, 17개 시도, `districtCodes`도 현행
행정표준코드이고, `representativeImage`(경복궁, TYPE1, 출처 문구)와 `spots`
페이지네이션까지 확인했다.

```
{"id":"2","name":"Seoul","provinceCode":"11",
 "districtCodes":["11110","11140",...],"viewerVisited":false}
```

## 해소

2026-08-22 재확인 결과 161칸 전부 `center`가 정상이다(에러 0건, 서울
`37.5988916 / 126.9676545`). 오퍼레이션의 `MapCellCore` 조각에 `center`를
되살렸고, 칸으로 지도를 옮기는 데 이 값을 쓴다.

아래는 결함이 있던 동안의 기록이다.

## 결함이 있던 동안 클라이언트가 한 것

**`center`를 고르지 않았다.** 계약상 "지도를 이 칸으로 옮길 때 쓰는 대표 좌표"인데,
클라이언트가 칸 도형 자산(`asset/geo/korea_cells.json`)을 갖고 있어 폴리곤
무게중심을 자체 계산할 수 있다. 그래서 이 결함이 기능을 막지는 않는다.

서버가 고치면 오퍼레이션에 `center`를 되살릴지 정한다 — 자체 계산값과 서버값이
다르면(계약은 "항상 이 칸의 경계 안"이라고만 한다) 어느 쪽을 쓸지도 함께 정해야
한다.

## 스키마 쪽에서 함께 봐줬으면 하는 것

`center`가 정말 항상 있어야 하는 값이면 지금처럼 `Coordinates!`가 맞다. 다만
지금은 **값이 없는데 non-null로 선언**되어 있어 한 칸의 결측이 전체 조회를
무너뜨린다. 데이터를 채우는 것이 근본 해결이고, 채울 수 없는 칸이 생길 수 있다면
nullable로 낮추는 편이 안전하다.
