> spec: SPEC-0031 · source: `Specs/SPEC-0031/spec.md` (Obsidian) · issue: #73 · status: in-progress

## 구현 기록 (2026-08-22)

**결합 키가 검증됐다.** 서버 `MapCell.id`는 `"1"`~`"161"` 문자열이고 결합 테이블의
`cell_id`와 완전히 일치한다(라이브 서버 161칸 대조). 이 스펙 전체가 이 가정 위에
서 있었으므로 먼저 확인했다 — 울산=태화강, 서울=경복궁, 경주=불국사로 내용까지
맞는다.

**`ColorMapper` 가정도 검증됐다.** 실제 SVG를 디코딩해 픽셀을 확인하는 테스트
(`landmark_icon_render_test.dart`)를 두었다. 색 치환 함수를 직접 부르는 단위
테스트는 "함수가 옳은 색을 돌려준다"만 증명할 뿐 **flutter_svg가 그 함수를 실제로
부르는지**는 증명하지 못한다. 파이프라인 끝까지 통과시킨 결과:

- 방문 변형에 원색이 칠해지고, 미방문 변형에서는 사라진다
- 외곽선 `#2B2B45`는 두 변형 모두 불변이다(R10이 구조로 보장됨)
- **파랑 채널 1 차이로 구분한 조정 폴백값(rock `#5A6B8D` → `#5A6B8C`)도 통과한다.**
  여기가 깨졌으면 161개를 다시 칠해야 했다

**변경한 것 (§1 대비)**

| 파일 | 실제 조치 |
|---|---|
| `component/landmark_icons.dart` | 삭제함 |
| `model/landmark_kind.dart` | 삭제함 |
| `component/province_palette.dart` | **남겨 뒀다.** 칸 면 색은 `landmark_category_tint.dart`로 옮겼지만 시도 색은 진행률 바 등 다른 곳이 쓴다 |
| `component/cell_painter.dart` | 모든 칸에 아이콘, `Picture`로 그림, `minIconBox` 설정값화 |
| `model/cell_geometry.dart` | `landmark: LandmarkKind?` → `landmarkSlug` + `landmarkCategory` |
| `model/cell_shape_builder.dart` | 결합 테이블 조회로 교체 |
| `repository/national_map_operations.graphql` | `MapCellCore`에서 `representativeImage` 제거 |
| `model/map_cell.dart` | `landmarkCaption` 필드 삭제 |

**§4와 다르게 한 것**: 캐시가 `PictureInfo`를 그대로 담지 않고 `LandmarkIconPicture`
(그림 + 크기)를 쓴다. `PictureInfo`는 생성자가 private이라 테스트에서 만들 수 없어
디코딩 횟수를 셀 수 없었다.

### 실제로 그려 보고 고친 것 두 가지

단위 테스트는 전부 통과하는 상태에서 **렌더해 보고서야** 드러난 문제들이다.

**1. 아이콘이 칸을 가득 채웠다.** `iconSize`의 하한을 표시 하한(`minIconBox` 22)과
같게 두는 바람에, 22px 칸에 22px 아이콘이 들어가 이웃 칸까지 넘봤다. 지도가 아이콘
벽이 되어 칸 도형이 보이지 않았다. 하한을 12로 낮추고 비율도 0.62 → 0.52로 줄였다.

**2. 칸을 채워도 채운 티가 나지 않았다.** 카테고리 틴트를 디자인 시스템의
"20~25% 틴트" 그대로 잡았더니 휘도가 미방문 면(0.79)과 비슷하거나 **오히려
높았다**(park 0.83). 채우는 재미가 이 화면의 전부인데 그게 죽어 있었다.
0.62~0.75로 눌렀고, 「미방문 면보다 뚜렷이 진하다」를 테스트로 박았다.

### 배치를 다시 뒤집었다 — 배지가 아니라 **칸을 채우는 그림**이다

처음엔 §5를 "칸 가운데에 아이콘을 얹는다"로 읽고 고정 크기 배지로 구현했다.
실기기에서 보니 **채우는 재미가 없었다**(사용자 지적). 칸 대부분이 빈 면이라
아이콘이 칸 안의 스티커처럼 보이고, 채워도 면적 변화가 작아 성취감이 없었다.

레퍼런스(스크래치 지도)를 다시 보면 그림이 **칸을 가득 채운다.** 칸 경계가 곧
그림의 테두리이고, 긁어내면 그 면적만큼 색이 드러난다. 재미가 **면적**에서 나온다.

그래서 셋을 바꿨다.

1. **칸을 덮도록 키우고 칸 도형으로 자른다.** 긴 변 대비 1.15배로 키워 네
   귀퉁이까지 덮고 `clipPath`로 이웃 침범을 막는다. 가장자리가 잘리는 것은
   의도다 — 작은 칸에서는 그림의 일부만 남고, 종이 스크래치 지도도 그렇다.
2. **미방문 그림은 55%로 낮춘다.** 미방문까지 진하게 채우면 방문해도 "드러나는"
   맛이 없고 지도가 회색으로 무거워진다. 디자인 시스템이 "투명도는 미방문
   아이콘 55%가 유일한 용도"라고 정해 둔 값이 정확히 이 경우다.
3. **칸 테두리를 그림 위에 그린다.** 먼저 그리면 그림에 덮여 칸 경계가 사라지고,
   그러면 무엇을 탭하는지 보이지 않는다. 굵기도 1.2 → 1.8로 올렸다.

`_minIconBox`(22)는 그대로 살아 있다 — 그보다 좁은 칸은 그림을 생략한다.

### 확인 방법

`landmark_icon_render_test.dart`가 실제 SVG를 디코딩해 픽셀을 본다. 색 치환 함수를
직접 부르는 검사는 "함수가 옳은 색을 돌려준다"만 증명하지 **flutter_svg가 그 함수를
부르는지**는 증명하지 못하므로, 한 번은 파이프라인 끝까지 통과시킨다.

지도 전체를 눈으로 보려면 위젯 테스트로 캔버스를 PNG로 뽑았다(일회성 도구라
저장소에 남기지 않았다). 시뮬레이터 자동 조작은 권한으로 막혀 쓰지 못했다.

**남은 것**: 실기기 확인. 위 렌더는 실제 서버 칸 161개 + 실제 경계 + 실제 아이콘을
쓰지만 시뮬레이터/실기기의 화면 밀도와 제스처까지 재현하지는 않는다.


# SPEC-0031 — 지역 랜드마크 아이콘과 칸 상태 시각 체계 (클라이언트)

요구사항·수용 기준·산출물 규약은 스펙 문서에 있다. 이 문서는 이 저장소에 한정된 설계만 담는다.

**이 작업은 신규 화면이 아니라 교체다.** SPEC-0030이 머지되어 `lib/domain/national_map/`가
동작하고 있고, 그 시각 계층을 바꾼다.

---

## 0. 아이콘 161종은 이 저장소가 그린다

기획 하네스가 넘기는 것은 **무엇을 그릴지와 어떤 색을 쓸지**뿐이다. SVG 제작은 여기서 한다.

### 무엇을 그리는가 — `map_cell_image`의 대표 행

칸의 대표 랜드마크는 **`map_cell_image` 테이블에서 `display_order = 0`인 161행**이다.
그 행의 `caption`이 그릴 대상이고 `cell_id`가 결합 키다.

```sql
SELECT cell_id, caption, copyright, content_id
FROM map_cell_image
WHERE display_order = 0
ORDER BY cell_id;   -- 161행
```

칸에 보이는 사진과 아이콘이 같은 장소여야 하므로 이것이 유일한 출처다.
**씨드 파일(`landmarks-161-with-images.json`)은 쓰지 않는다** — 칸 번호 체계가 다르다.

이 조회 결과를 그대로 옮긴 것이 `../ieuri-planner/out/landmark-icon-binding.json`이다.

| 키 | 뜻 |
|---|---|
| `cell_id` | 서버 칸 번호. **결합 키** (1~161 연속) |
| `slug` | 아이콘 파일명 |
| `caption` | 그릴 대상. `map_cell_image.caption` 그대로 |
| `category` | 면 색을 정하는 카테고리 5종 |
| `name_en` | slug의 근거가 된 영문명 |
| `copyright` · `content_id` | 원본 행 추적용 |
| `reuses_existing_icon` | 참이면 디자인 시스템 기존 아이콘을 그대로 쓴다 (4행) |

역할 색표는 `../ieuri-planner/out/landmark-icon-roles.json` — 18역할 × (`fallback` · `full` ·
`grey`). **`fallback`은 표시색이 아니라 역할 식별자다.**

카테고리 분포(161칸): nature 66 · heritage 64 · culture 14 · park 13 · specialty 4.
재사용 4행(경복궁·전주한옥마을·한라산국립공원·성산일출봉) → **새로 그릴 것은 157종.**

> 적재 데이터가 바뀌면 위 쿼리를 다시 돌려 테이블을 재생성한다.

**그리는 순서를 렌더링보다 먼저 두지 않는다.** §3~§5의 렌더링 경로를 먼저 뚫고 첫 배치
5~10종을 실제 지도에 얹어 **22px에서 읽히는지 확인한 뒤** 나머지를 그린다. 161종을 다 그린
뒤 안 읽힌다는 것을 알면 전부 다시 그려야 한다.

제작 규약은 스펙 R1~R6이다. 요점만: 120×120 viewBox, 외곽선 `#2B2B45` 고정 `stroke-width="4"`,
모든 `fill`은 역할표의 **폴백값**을 쓴다(그 값으로 `ColorMapper`가 역할을 식별한다).
사진을 따라 그리지 않는다(POL-051).

## 1. 무엇을 지우고 무엇을 넣는가

| 파일 | 조치 |
|---|---|
| `component/landmark_icons.dart` | **삭제.** 하드코딩 `Path` 11종이 SVG 에셋 161종으로 대체된다 |
| `model/landmark_kind.dart` | **삭제.** caption 정규식 분류가 결합 테이블로 대체된다 |
| `component/province_palette.dart` | **교체.** 시도별 18색 → 카테고리 틴트 5종 |
| `component/cell_painter.dart` | **수정.** 미방문 칸에도 아이콘을 그린다. 아이콘 소재가 `Path`에서 `Picture`로 바뀐다 |
| `model/cell_geometry.dart` | **수정.** `landmark: LandmarkKind?` → slug/카테고리 |
| `model/cell_shape_builder.dart` | **수정.** `landmarkKindOf(caption)` 호출을 결합 테이블 조회로 바꾼다 |
| `repository/national_map_operations.graphql` | **수정.** `MapCellCore`의 `representativeImage { caption }`이 아이콘 결정에 더 이상 쓰이지 않는다 (§6) |

신규:

```
model/       landmark_icon_binding.dart   ← 칸 → slug·카테고리 (생성물)
             landmark_category.dart       ← enum 5종
             landmark_icon_role.dart      ← 18역할 → 폴백·전채색·무채색 (생성물)
component/   landmark_icon_cache.dart     ← (slug × 변형) → PictureInfo
             landmark_color_mapper.dart   ← ColorMapper 2종
asset/icon/landmark/<slug>.svg            ← 161개
```

`pubspec.yaml`의 `assets:`에 `- asset/icon/landmark/`를 더한다. 현재 `- asset/icon/`과
`- asset/geo/` 두 줄이며, Flutter의 assets 항목은 하위 디렉토리를 재귀 포함하지 않는다.

`AppAssets`에 161개 상수를 넣지 않는다. 그 파일은 소수의 브랜드 에셋용이고, 여기 필요한 것은
slug로 경로를 만드는 함수 하나다.

## 2. 계층 경계 — 색은 `component/`에 둔다

`model/**`은 `dart:ui`를 쓰지 않는다. 기존 `province_palette.dart`가 이 이유로 `component/`에
있고(파일 상단 주석), 같은 규칙을 따른다.

따라서:

- `landmark_icon_binding.dart`(slug·카테고리 문자열)와 `landmark_category.dart`(enum)는 `model/`
- 색이 들어가는 `landmark_icon_role.dart`와 `landmark_color_mapper.dart`는 `component/`

역할 대응표는 색을 담으므로 `component/`다. 다만 **무채색 변환 규칙 자체는 순수 함수로 두어야
스펙 §8의 R9 기준(명도 순서 보존, 채도 0)을 단위 테스트로 받을 수 있다.** 색값 상수와
변환 로직을 같은 파일에 두되 로직은 `Color`를 입출력으로 받는 최상위 함수로 노출한다.

## 3. 두 변형을 무엇으로 만드는가

스펙 §7.1이 정한 `ColorMapper`다. **SVG 파일은 한 벌이고 변형은 실행 시점에 만든다.**

`flutter_svg` 2.3.0 (`lib/src/loaders.dart`) 확인:

```dart
abstract class ColorMapper {
  Color substitute(String? id, String elementName, String attributeName, Color color);
}
```

색을 파싱할 때마다 호출되므로 path별 분기가 된다. `ColorFilter`나 `SvgTheme.currentColor`로는
안 된다 — 전역 틴트라 역할별로 다른 색을 줄 수 없다.

`landmark_color_mapper.dart`에 두 개를 둔다.

- `VisitedColorMapper` — 입력색(역할 폴백값)을 그 역할의 전채색으로
- `UnvisitedColorMapper` — 입력색을 그 역할의 무채색으로
- 둘 다 `attributeName == 'stroke'`이면 `#2B2B45`를 그대로 돌려준다 → 스펙 R10이 구조로 보장된다

폴백값이 역할 대응표에 없으면 **입력색을 그대로 돌려준다.** 알 수 없는 색을 임의로 바꾸면
아이콘이 조용히 망가진다.

`ColorMapper`는 `SvgCacheKey`에 포함되므로(`loaders.dart`) 두 변형이 서로를 밀어내지 않는다.

## 4. CustomPainter에서 SVG를 어떻게 그리는가

`SvgPicture`는 위젯이라 `CustomPainter.paint()` 안에서 합성할 수 없다. `vector_graphics`의
`PictureInfo.picture`가 `dart:ui`의 `Picture`이며 `canvas.drawPicture()`로 직접 그려진다.

`vector_graphics`·`vector_graphics_compiler`는 **이미 `pubspec.lock`에 `flutter_svg`의 전이
의존성으로 들어 있다.** 새 의존성을 추가하지 않는다.

`landmark_icon_cache.dart`가 `Map<(String slug, bool visited), PictureInfo>`를 들고 있는다.

- 채우는 시점은 **지도 진입 시 비동기 프리로드**
- `paint()`는 캐시에서 꺼내 `drawPicture`만 한다. **`paint()`에서 `await`하지 않는다**
- 캐시 미스면 그 칸은 이번 프레임에 아이콘을 생략하고 면 색만 그린다

**프리로드 대상이 SPEC-0030과 달라진다.** 지금은 방문 칸에만 아이콘을 그리므로 방문 칸만
있으면 됐지만, 이제 **161칸 전부에 아이콘이 필요하다**(미방문은 무채색). 방문 여부에 따라
어느 변형이 필요한지 갈릴 뿐 전 칸이 대상이다.

`drawPicture`는 `PictureInfo.size`(120×120) 기준이므로 칸 크기에 맞춰 `canvas.save()` →
`translate` → `scale` → `restore`로 감싼다. 기존 `LandmarkIcons.paint`가 `canvas.scale(size/24)`로
하던 것과 같은 방식이며 분모만 120이 된다.

이 저장소에는 캐시하지 않아 생긴 선례가 있다 — `map_overlay_painter.dart`가 스타일 인스턴스
재사용 문제를 주석으로 남기고 있다. 161개를 매 프레임 디코딩하면 같은 문제가 훨씬 큰 규모로
재현된다.

## 5. `cell_painter.dart`에서 바뀌는 것

현재 `_paintLandmark`는 `overlappingCellIds ?? visitedCellIds`에 속한 칸에만 그린다.
**모든 칸에 그리도록 바꾸고, 어느 변형을 쓸지는 그 집합으로 정한다.**

```
현재: 방문 칸 → 흰색 도형 / 미방문 칸 → 아무것도 안 그림
변경: 방문 칸 → 전채색 Picture / 미방문 칸 → 무채색 Picture
```

`_fillOf`는 시도 코드 대신 **카테고리**로 분기한다. `CellGeometry`가 `provinceCode`와 함께
카테고리를 들고 있어야 하므로 `cell_shape_builder.dart`에서 결합 테이블을 조회해 채운다.

**바꾸지 않는 것** (스펙 §7.6):

- 제주 오프셋 `Offset(0, -12)` — `screenOffsetOf`를 아이콘 위치에도 그대로 적용한다.
  그리기와 히트테스트가 어긋나면 제주만 탭이 빗나간다
- 투영 `_padding = 4` · `cover` — 그리기와 탭 판정이 같은 투영을 재구성하는 구조를 유지한다
- 3패스 구조(면 → 아이콘 → 선택 테두리)와 `border: scheme.surface`의 "잘라낸 종이" 처리

최소 표시 크기 `_minIconBox`는 설정값으로 뺀다(스펙 R15). 기본값은 현재 값 22를 승계한다.

## 6. GraphQL 쿼리에서 빠지는 것

`MapCellCore`의 `representativeImage { caption }`은 **아이콘 결정 용도로는 더 이상 쓰이지
않는다.** 아이콘은 결합 테이블이 정한다.

확인한 결과 `landmarkCaption`의 소비처는 `cell_shape_builder.dart`의 `landmarkKindOf()` 호출
**한 곳뿐이다**(그 외는 생성자·필드 선언·`copyWith`). 정규식 분류가 사라지면 이 필드는 죽는다.

따라서 `MapCellCore`에서 `representativeImage { caption }`을 제거하고 `MapCell.landmarkCaption`
필드도 함께 지운다. 칸 상세 화면은 별도 쿼리(`MapCellDetail`)로 이미지를 다시 받으므로 영향이 없다.

**계약 자체는 바꾸지 않는다** — 클라이언트가 덜 조회할 뿐 서버 스키마는 그대로다.

## 7. 접근성

칸은 `Semantics`로 **칸 이름과 방문 여부**를 읽는다(스펙 R20). 랜드마크 이름과 slug는 읽지
않는다 — 아이콘은 장식이고 칸 이름이 정보다.

칸 이름은 서버의 `MapCell.name`을 쓴다(스펙 R21). `l10n` ARB에 지역명을 넣지 않는다(POL-039).
"방문함"/"미방문"에 해당하는 문구만 ARB에 추가하며 EN/KO/JA/ZH 네 파일 전부에 넣는다.
`app_ko.arb`가 template이므로 여기부터 추가한다.

## 8. 테스트

CLAUDE.md의 테스트 범위에 따라 **위젯 테스트를 만들지 않는다.** 아래 순수 Dart 단위가
스펙 §8의 기준을 받는다.

| 단위 | 받는 기준 |
|---|---|
| 무채색 변환 함수 (`component/landmark_icon_role.dart`) | R7·R8·R9(두 변형이 다름, 채도 0, 명도 순서 보존, 투명 없음) |
| `landmark_color_mapper.dart` | R10(외곽선 불변), 미등록 색은 그대로 통과 |
| 카테고리 틴트 조회 | R12·R13(landmark→culture 정규화), R14(미방문 단일 면) |
| `landmark_icon_binding.dart` | R19(미등록 slug → 카테고리 기본, 칸이 목록에서 빠지지 않음) |
| `landmark_icon_cache.dart` | R16(같은 키 2회 → 디코딩 1회, 두 변형 별개 항목) |
| 최소 크기 판정 | R18 |

`landmark_icon_cache`의 디코딩 횟수를 세려면 디코딩이 주입 가능해야 한다. 캐시가 `flutter_svg`를
직접 부르지 않고 디코더를 생성자로 받는 형태여야 테스트에서 셀 수 있다.

**기존 테스트 개정** — `test/domain/national_map/map_design_test.dart`:

- 「161개 이름이 전부 분류된다」 → **삭제.** 정규식 분류가 사라진다
- 「인접 시도 색 거리 ≥ 58」·「시도 색이 서로 다르다」 → **카테고리 틴트 5종의 구분**으로 대체
- 「경계 자산이 리포에 있다」 → 그대로 둔다

`national_map_canvas_test.dart`의 제주 히트테스트는 **그대로 통과해야 한다.** 통과하지 않으면
오프셋을 아이콘에만 적용하고 히트테스트에 빠뜨린 것이다.

**R11(전환 애니메이션)은 위젯 테스트로만 관측된다. 테스트하지 않는다.**

## 9. 이 문서가 정하지 않는 것

- 칸 도형·투영·히트테스트 — SPEC-0030이 구현했고 이 스펙은 건드리지 않는다
- 아이콘의 화풍과 세부 수준 — 기획 하네스의 산출물이며 22px 가독성 확인 후 확정된다
  (스펙 §7.4 TBD)
