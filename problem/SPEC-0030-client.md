> spec: SPEC-0030 · source: `Specs/SPEC-0030/spec.md` (Obsidian) · status: 클라이언트 전 범위 구현

## 구현 현황 (2026-08-22)

`problem/SPEC-0030-client-prompt.md`(v1.2)가 기준이다. 이 문서의 아래쪽 설계는
v1.0 기준이라 §4의 전송 단계 등 일부가 낡았다 — 아래 표가 우선한다.

### v1.0 설계에서 뒤집힌 것

| 항목 | 이 문서의 원래 설계 | 실제 |
|---|---|---|
| 좌표 판정 | 서버 `resolveDistricts`에 500건씩 전송 | **API 삭제.** 클라이언트가 로컬 판정 |
| 경계 데이터 | 서버 보유 | **앱 에셋**(3.8MB) |
| 칸 식별자 | `code: String`(`"11"`) | **`id: ID!`**(`"2"`) |
| 칸 도형 | 클라이언트가 묶음 규칙을 갖고 자산 생성 | **서버 `districtCodes`로 런타임 조립** |
| 공유 링크 | `token` | **`shareUrl`**(완성된 URL, 조립 금지) |
| 해제 입력 | `cellCode` | **`cellId`** |
| spot 노드 | `Spot` | **`CellSpot`**(거리 필드 없음) |

전송량 축약 3단계(§4)는 유효하나 **목적이 바뀌었다** — 서버 왕복이 아니라 로컬
판정 횟수를 줄이는 최적화다. 사진이 몇 장이든 `recordVisits`는 1회다.

### 스펙에서 바꾼 것 (사용자 결정, 2026-08-22)

| 스펙 | 바꾼 내용 | 근거 |
|---|---|---|
| R30 사진 판정 결과를 **확인을 거쳐** 등록 | 확인 단계를 없애고 스캔이 끝나면 바로 등록한다 | 스캔은 사용자가 버튼을 눌러 직접 시작한다 — 그 행위가 곧 동의이고, 한 번 더 묻는 것은 군더더기다 |

R33(현재 위치 등록)의 확인은 **그대로 둔다.** 그쪽은 버튼 한 번으로 기록이
생기므로 오작동 여지가 있다.

### 요구사항별 상태

| 요구사항 | 상태 |
|---|---|
| R17~R19 탭 재구성 · 보관함 토글 | 구현 |
| R20~R22 칸 렌더링 · 진척 · 칸 진입 | 구현 |
| R23·R24 저작권별 렌더링 · 출처 표기 | 구현 |
| R11 칸 상세 spot 목록 | 구현(커서 이어 읽기 포함) |
| R3·R4 방문 등록·해제 | 구현(낙관적 업데이트) |
| R21 시도 진척 | 구현 |
| R25~R32 사진 스캔 | 구현(`photo_manager`) |
| R33~R35 현재 위치 등록 | 구현 |
| R36~R38 공유 | 구현(`share_plus`, 딥링크 라우트 포함) |
| 좌표 로컬 판정 | 구현(서버 PostGIS와 일치 확인) |

### 칸 도형은 미리 만들지 않는다

**묶음 규칙은 서버 소유다.** `mapCells`가 칸마다 `districtCodes`를 주고,
클라이언트는 그것으로 원본 경계를 합쳐 런타임에 도형을 만든다
(`CellShapeBuilder`, ~73ms).

한때 `korea_cells.json`이라는 161칸 자산을 두었으나 **버렸다** — 클라이언트가
묶음 규칙을 추측해 복제한 것이었고, 출처가 달라 시군구 코드 체계까지 어긋났다.
자세한 것은 `asset/geo/README.md`.

### 검증

라이브 서버(`localhost:8888`)로 확인했다.

- 전체 오퍼레이션 스윕 — 불일치 0건
- 뮤테이션 리터럴 인자 전송 — `UNAUTHENTICATED`(형태 통과)
- 실제 서버 161칸 정의로 도형 조립 — 161/161 성공, 서울 폴리곤 1개, 면적 보존
- 로컬 판정이 서버와 일치 — 서울시청 `11140`, 수원 `41111`, 동해·도쿄 미판정
- `MapCell.center` 결함은 서버가 고쳤다(2026-08-22) — 오퍼레이션에 되살렸다

### 실기기 확인이 필요한 것

사진 스캔은 **인프라로만 관찰 가능**하다(스펙 §8). 시뮬레이터·테스트에서는
`photo_manager`가 실제 EXIF를 주지 않으므로, 아래는 실기기에서 봐야 한다.

- Android `ACCESS_MEDIA_LOCATION` 하에서 EXIF 좌표가 실제로 읽히는지
- 수만 장 스캔의 실제 소요 시간과 배터리
- iOS "일부만 허용"에서의 동작

## 1. 탭 재구성 — 무엇이 어디로 가는가

현재 5개 탭(`lib/router/routes.dart:375-391`)에서 두 가지가 바뀐다.

| # | 지금 | 바뀐 뒤 |
|---|---|---|
| 0 | `/home` HomeScreen | 그대로 |
| 1 | `/map` MapScreen | **`/national-map` NationalMapScreen** — 신설 |
| 2 | `/discover` DiscoverScreen | 그대로 (가운데 강조 유지) |
| 3 | `/liked` LikedSpotsScreen | **`/library` LibraryScreen** — 상단 토글로 좋아요↔커뮤니티 |
| 4 | `/community` CommunityScreen | **`/map` MapScreen** — 기존 지도가 이 자리로 이동 |

`MapScreen`은 라우트 경로(`/map`)와 화면을 그대로 유지하고 **탭 위치만 1번에서 4번으로**
옮긴다. 전국 지도가 `/national-map`이라는 새 경로를 쓴다.

**탭 수 5개와 Discover의 가운데 강조는 유지한다**(SPEC-0008 AC-40, SPEC-0021 AC9.3,
SPEC-0025 R7이 세 번 확인한 결정이다).

### LibraryScreen — 껍데기만 새로 만든다

`LikedSpotsScreen`과 `CommunityScreen`의 **내부는 변경하지 않는다.** 두 화면을 그대로
자식으로 두고 상단 세그먼트 토글로 전환하는 컨테이너를 만든다.

```
lib/domain/library/view/library_screen.dart      // 토글 + 자식 배치만
```

기존 화면의 라우트 이름은 유지한다 — 딥링크(SPEC-0028)와 기존 네비게이션 경로가
`LikedSpotsScreen.routeName`을 참조하고 있다. 탭 진입점만 `LibraryScreen`으로 바뀐다.

토글 상태는 **탭을 떠나도 유지**한다. 탭 재진입 시 마지막으로 보던 쪽이 나온다.

## 2. 새 도메인 — `national_map`

기존 `map` 도메인은 뷰포트 지도·혼잡도·지역 추천을 갖고 있고 모델만 17개다.
전국 지도를 여기 넣으면 두 개의 다른 지도가 한 도메인에 섞인다. **별도 도메인으로 둔다.**

```
lib/domain/national_map/
  component/   cell_painter.dart, province_progress_bar.dart, sync_progress_sheet.dart
  model/       map_cell.dart, cell_image.dart, visit_state.dart, photo_scan_progress.dart
  provider/    national_map_providers.dart, photo_sync_providers.dart, share_providers.dart
  repository/  national_map_repository.dart
  view/        national_map_screen.dart, cell_detail_screen.dart, shared_map_screen.dart
```

생성된 GraphQL 타입은 repository 밖으로 나가지 않는다(POL-020).

## 3. 지도를 무엇으로 그리는가

**카카오맵 위에 폴리곤을 얹지 않는다.** 161칸을 자체 렌더링한다.

근거:
- 칸은 지리적 정확도가 목적이 아니다. 참조 제품(스크래치 지도)처럼 **단순화된 도형**이면 된다
- 카카오맵에 161개 폴리곤을 올리면 저줌에서 성능이 나빠지고, 지도 타일 위 색칠은
  시각적으로 지저분하다
- 스크래치 지도 느낌(칸을 채우는 경험)은 지도 타일이 없는 편이 낫다

칸 도형은 **앱에 내장한 단순화 GeoJSON**으로 그린다. 서버가 주는 것은 칸 목록과 방문 여부이고,
도형은 클라이언트 자산이다. 서버 응답에 폴리곤이 없는 이유가 이것이다.

`CustomPainter`로 그리고 탭 히트 테스트는 point-in-polygon으로 한다.

**카카오맵은 `MapScreen`(탭 4)에서 계속 쓴다.** 두 화면은 독립이며 렌더링 방식을
공유하지 않는다(§9).

## 4. 사진 스캔 — 플랫폼이 갈린다

이 기능의 구현 난이도가 가장 높은 지점이고, **iOS와 Android가 근본적으로 다르다.**

| | iOS | Android |
|---|---|---|
| 좌표 획득 | `PHAsset.location` — Photos DB에 인덱싱됨 | 파일을 열어 EXIF 파싱 |
| 파일 I/O | **불필요** | 사진 수만큼 발생 |
| 권한 | 사진 라이브러리 접근 | `READ_MEDIA_IMAGES` + `ACCESS_MEDIA_LOCATION` |
| 심사 | 목적 문자열 명확히 | **Play 선언 심사 대상** |

**Android가 위험 지점이다.**
- Android 10+ 는 MediaStore·File API 양쪽 모두에서 GPS EXIF를 제거한다(FUSE 계층)
- `ACCESS_MEDIA_LOCATION`이 있어야 redaction이 꺼진다
- **Photo Picker는 쓸 수 없다** — 권한과 무관하게 GPS를 무조건 제거한다
- `MediaStore`의 위경도 컬럼은 deprecated이며 항상 null이다 → 지름길이 없다

### 구현 방침

- **네이티브에서 일괄 스캔하고 결과만 배치로 Dart에 넘긴다.** 사진 20만 장에 대해
  플랫폼 채널을 건별로 왕복하면 치명적이다
- 스캔은 백그라운드 isolate에서 돌고 UI를 막지 않는다(R29)
- 진행 상태를 로컬 DB에 남겨 중단·재개한다(R28) — 키는 사진 식별자 + 수정시각
- EXIF는 파일 선두 수십 KB에 있으므로 **전체를 읽지 않는다**. HEIC는 더 읽어야 한다

### 전송량을 줄이는 세 단계 (R26·R27)

1. 좌표를 **0.01도 격자로 반올림해 중복 제거** — 같은 장소 사진 100장이 1건이 된다
2. **이미 방문 확정된 칸의 bounding box에 들어오는 좌표는 버린다** — 서버에 보내지 않는다
3. 남은 것만 500건씩 나눠 `resolveDistricts`에 보낸다

161칸이 모두 채워지면 스캔을 중단한다.

### 패키지

- `photo_manager` — 라이브러리 순회. `AssetEntity.latlngAsync()`가 Android 10+ 필수 경로다
- EXIF 직접 파싱이 필요하면 `native_exif`(네이티브 구현, GPS 지원). 단 **GPS 위경도를
  양수로만 반환하므로 `GPSLatitudeRef`/`GPSLongitudeRef`로 부호를 결정**해야 한다

## 5. 사진 권한 — SPEC-0001의 결정을 뒤집는다

`lib/common/permission/model/permission_kind.dart`가 지금 이렇다.

```dart
/// 실제로 필요한 두 가지만 둔다: 포그라운드 위치("사용 중에만")와 알림. 백그라운드
/// /"항상" 위치, 카메라, 마이크, 사진은 의도적으로 제외한다 (R1, R7).
enum PermissionKind { location, notification }
```

`photos`를 추가한다. **주석의 "사진은 의도적으로 제외한다"를 함께 고쳐야 한다** —
근거가 사라진 주석을 남기면 다음 사람이 오판한다.

다만 **부팅 시퀀스에는 넣지 않는다.** 사진 권한은 앱 진입 조건이 아니라 지도 탭에서
동기화를 시도할 때 요청한다. 거부해도 앱의 다른 기능은 정상 동작한다(R31).

Android 매니페스트와 iOS `Info.plist` 문자열도 함께 갱신한다. iOS는 이미
`NSPhotoLibraryUsageDescription`이 있으나 문구가 "커뮤니티 글 사진 첨부"라 목적이 달라졌다.

## 6. 이미지 렌더링 — 저작권 유형으로 분기한다

`CellImage.copyright`에 따라 표시가 갈린다(R23). **이건 UI 취향이 아니라 법적 제약이다.**

| 유형 | 표시 |
|---|---|
| `TYPE1` | `BoxFit.cover` — 카드에 꽉 채워 크롭 가능 |
| `TYPE3` · `UNSPECIFIED` | `BoxFit.contain` — 원본 비율 유지, 여백 허용 |

공공누리 제3유형의 "변경금지"가 **형식의 변경까지 포함**하므로 크롭이 저촉될 수 있다.
해석이 갈리는 지점이라 안전한 쪽으로 간다.

`attributionText`는 유형과 무관하게 항상 노출한다. 이미지 하단이나 상세 화면에 둔다.

전체 데이터의 약 62%가 TYPE1이라 대부분은 크롭할 수 있다.

## 7. 상태 관리

Riverpod 코드젠을 쓴다(기존 관례).

| provider | 성격 | 비고 |
|---|---|---|
| `mapCellsProvider` | 161칸 + 방문 여부 | 앱 세션당 1회 조회 후 캐시. 방문 등록 시 갱신 |
| `cellDetailProvider(cellCode)` | 칸 상세 | family |
| `photoScanProvider` | 스캔 진행 상태 | 중단·재개를 담는다 |
| `visitMutationProvider` | 등록·해제 | 뮤테이션 응답의 `updatedCells`로 캐시를 고친다 |

방문 등록 뮤테이션이 변경된 칸을 돌려주므로(계약 §7.1) **재조회하지 않는다.**

낙관적 업데이트를 적용한다 — 사용자가 등록을 누르면 즉시 칸을 채우고, 실패하면 되돌린다.

## 8. 단위 테스트가 붙는 지점

provider와 도메인 모델만 대상이다. 위젯·통합 테스트는 작성하지 않는다.

| 대상 | 검증 |
|---|---|
| 좌표 격자 축약 | 같은 격자의 좌표 100건이 1건으로 줄어든다 |
| 방문 칸 필터 | 이미 방문한 칸의 bbox 안 좌표가 전송 목록에서 빠진다 |
| 스캔 재개 상태 | 400장 처리 후 중단하면 다음 시작점이 401이다 |
| 시도 진척 계산 | 31칸 중 12칸 방문 시 12/31이다 |
| 저작권 → BoxFit 매핑 | TYPE1이 cover, TYPE3·UNSPECIFIED가 contain이다 |
| 겹침 표시 모델 | `overlappingCellCodes`가 null이면 겹침 UI를 그리지 않는다 |
| 토글 상태 유지 | 탭을 떠났다 돌아와도 마지막 선택이 유지된다 |

실제 사진 라이브러리 접근, EXIF 파싱 결과, 권한 다이얼로그 동작은
**인프라로만 관찰 가능**하며 테스트하지 않는다.

## 9. 두 지도를 왜 합치지 않는가

전국 지도와 spot 지도는 성격이 다르다. 하나로 묶어 모드 전환시키는 안을 검토했으나
**독립 탭으로 분리**했다.

| | 전국 지도 | spot 지도 |
|---|---|---|
| 보는 것 | 내가 채운 기록 | 지금 주변에 뭐가 있나 |
| 데이터 | 161칸 고정, 전량 캐시 | 뷰포트마다 새 질의 |
| 렌더링 | 자체 도형 | 카카오맵 타일 |
| 상호작용 | 칸을 채운다 | 마커를 탐색한다 |

같은 탭에 두면 사용자가 "지도"를 눌렀을 때 무엇이 나올지 예측할 수 없다. 데이터 수명과
렌더링 방식도 공유하지 않아 코드상 이점도 없다.

## 9.5 관계 지도 — 여러 명과의 겹침 (설계, 2026-08-22)

**구현했다(2026-08-22).** 서버 오퍼레이션 4개가 들어왔다
(`problem/SPEC-0030-SERVER-relation-map.md` — 해소됨).

| 파일 | 역할 |
|---|---|
| `model/map_relation.dart` | `MapRelation` · `MapRelationPage` |
| `provider/relation_providers.dart` | 목록·등록·삭제 |
| `component/relation_orbit.dart` | 방사형 배치 |
| `view/relation_map_screen.dart` | 화면(`/relations`) |

**목록을 캐시하지 않는다**(`keepAlive`를 쓰지 않는다). 겹침이 조회 시점에
재계산되는 값이라 오래 들고 있으면 낡는다 — 화면을 다시 열면 새 숫자가 나와야
한다.

**거리는 겹친 수가 아니라 비율로 정한다**(`MapRelation.overlapRatio`). 수만 쓰면
많이 다닌 사람이 무조건 가까워져 "취향이 비슷하다"는 뜻이 흐려진다.

### 왜 지금 구조로는 안 되는가

공유 링크는 **단방향 스냅샷**이다. 링크를 뿌린 사람은 누가 열었는지도, 무엇이
겹쳤는지도 모른다 — 열람 사실이 돌아오지 않기 때문이다. 그래서 "여러 명과
겹치는 곳"이 원리적으로 불가능하다. **관계가 저장되어야 한다.**

### 정해진 규칙 (사용자 결정, 2026-08-22)

| 항목 | 결정 | 이유 |
|---|---|---|
| 등록하는 쪽 | **공유받은 사람** | 자기 기록을 자기 의사로 내놓으므로 링크 주인의 허락이 필요 없다 |
| 링크 주인 | **삭제만** | 넣을 권한은 들어온 사람에게, 뺄 권한은 목록 주인에게 |
| 보는 쪽 | **양쪽 다** (앱 설치 필요) | |
| 겹침 수 | **볼 때마다 재계산** | 서로 더 다니면 겹침이 늘어야 다시 열어볼 이유가 된다 |
| 삭제 | **각자 자기 목록만** | 대칭으로 만들면 상대가 내 화면을 바꾼다 |

### 흐름

```
나 ──[링크 공유]──▶ 상대가 링크 열람
                      ├─ 비로그인 → 겹침 못 봄 → 앱 설치 유도
                      └─ 로그인 → 겹침 보임 → [등록] → 양쪽 목록에 추가
```

### 화면

- **관계 지도**(신규) — 가운데 나, 주변에 등록된 사람들. **겹친 칸이 많을수록
  가운데에 가깝게** 둔다. 각자 닉네임과 겹친 수를 붙인다
- **공유 지도**(기존 `SharedMapScreen`) — 상대 한 명과의 겹침. 하단에 「등록」 추가
- 진입점은 전국 지도 상단 또는 하단 탭

### 이미 갖춘 것

### 공유 지도는 전국 지도와 같다 (사용자 결정, 2026-08-22)

**겹치는 칸만 primary로 칠하고 나머지는 비운다.** 처음에는 상대의 방문 칸을
시도별 색으로 칠하고 겹침에 테두리를 둘렀으나, 색이 많아 겹침이 묻혔다. 겹치는
곳만 칠하면 테두리 자체가 필요 없어진다 — 칠해진 것이 곧 겹친 것이다.

나머지 동작은 **전국 지도와 똑같다**: 화면을 채우고, 확대·이동이 되고, 칸을
누르면 같은 상세 시트가 열린다. 지도만 봐서는 어디를 함께 갔는지 알 수 없어
칸을 눌러 확인할 수 있어야 한다.

하단 여백은 `barExtent + 28`로 전국 지도와 같은 값이다 — 제주가 지도 맨
아래라 이만큼 비켜서지 않으면 하단 바에 잘린다.

## 9.6 사진 스캔 — iOS 백그라운드는 불가하다 (2026-08-22)

사진이 3만 장인 사용자를 위해 백그라운드 실행을 검토했으나 **애플 문서상
불가능하다.**

- `beginBackgroundTask` — "finite amount of time", 끝내지 않으면 앱을 죽인다.
  파일 쓰기 마무리용이지 긴 작업용이 아니다
- `BGProcessingTask` — "기기가 idle일 때만 돌고, **사용자가 기기를 만지는 순간
  종료**된다". 사용자가 버튼을 누르고 기다리는 흐름과 정반대다

그래서 **포그라운드 + 이어하기**로 푼다.

- 배치마다 중단 지점을 **디스크에 적는다**(`PhotoScanCheckpointStore`). 앱이
  정지·종료돼도 그 지점부터 이어 간다
- 앱이 내려갈 때(`AppLifecycleListener.onPause`) 스캔을 **스스로 멈춘다** —
  정지당하면 배치 중간에 끊긴다. 이 리스너는 **시트가 아니라 컨트롤러**에
  둔다(시트는 모달이라 닫히면 사라지지만 스캔은 `keepAlive`로 계속 돈다)

### 진행률이 계단처럼 뛰던 원인

판정이 아니라 **읽기**였다. `photo_manager`는 좌표를 사진 한 장마다 비동기
호출(`latlngAsync`)로 읽는데, 200장을 다 모아 반환하는 동안 막대가 멈춰 있었다.
`streamCoordinates`로 **한 장씩 흘려보내** 해결했다(3120장 기준 갱신 16→391회,
점프 200→8장).

**지도도 스캔 도중에 칠한다.** 판정 결과는 시군구 코드이고 지도는 칸 id로
칠하므로 `MapCell.districtCodes`로 변환해 `setVisitedOptimistically`를 부른다.
서버 등록 요청은 종전대로 **끝날 때 한 번만** 나간다.

## 9.7 안드로이드에서 전체 허용이 "일부만 허용"으로 잡히던 것 (2026-08-26)

같은 조건(둘 다 사진 전체 허용)에서 **iOS는 정상인데 안드로이드만** "일부만
허용" 안내가 떴다(사용자 스크린샷 비교).

원인은 **권한 요청 타입의 기본값**이다.

- `requestAccess()`가 `requestPermissionExtend()`를 옵션 없이 불렀다.
  `PermissionRequestOption`의 기본 `androidPermission.type`은
  **`RequestType.common`, 곧 이미지+동영상**이다(`photo_manager` 3.12.0
  `lib/src/types/types.dart`).
- 매니페스트에는 `READ_MEDIA_IMAGES`만 있고 `READ_MEDIA_VIDEO`는 없다 —
  우리가 훑는 것은 사진뿐이라 당연하다.
- Android 14+ 경로인 `PermissionDelegate34.getAuthValue`는 이미지·동영상을 각각
  판정한 뒤 `changeResult`로 합치는데, **"하나는 Authorized · 하나는 Denied"를
  `Limited`로 만든다.** 그래서 사진을 전체 허용해도 결과가 `limited`였다.
- iOS는 이 합산 로직을 타지 않고 `PHAuthorizationStatus`를 그대로 쓰므로 정상이었다.

`requestAccess()`와 `currentAccess()`가 **같은 옵션**(`permissionOption`,
`type: image` + `mediaLocation: true`)을 쓰도록 고쳤다. 요청과 조회가 다른 타입을
쓰면 서로 다른 등급을 답하므로 한 상수로 묶었다.

`presentLimitedPicker()`도 같은 종류의 문제가 있었다 — `presentLimited()`의 기본
`type`이 `RequestType.all`(이미지+동영상+오디오)이라 재선택 화면이 동영상까지
대상으로 잡았다. `type: image`를 명시한다.

**인터페이스 주석도 틀렸다.** `presentLimitedPicker`를 "iOS 14+ 전용"이라고 적어
두었는데 `PermissionDelegate34.presentLimited`가 안드로이드 구현이다. 바로잡았다.

### 안내 문구가 iOS 경로를 그대로 썼다

"설정 > 앱 > K-Trip Spot > 사진 > 전체 접근"은 **iOS 경로인데 안드로이드에도 그대로
나왔다**(사용자 지적). 안드로이드용 `photoSyncLimitedNoticeAndroid`를 4개 언어에
추가하고 `Platform.isIOS`로 고른다.

안드로이드 문구에는 **설정 경로를 적지 않는다.** 제조사 스킨마다 메뉴 이름이 달라
틀린 길을 알려 줄 위험이 크고, 바로 아래 "설정에서 전체 허용" 버튼이 설정 화면을
직접 열어 준다. 문구는 무엇이 일어났고 무엇을 바꾸면 되는지만 말한다.

회귀 테스트는 `map_design_test.dart`에 넣었다 — 요청 타입이 이미지만인지, 요청하는
권한이 매니페스트에 전부 있는지, 동영상 권한을 선언하지 않았는지를 본다. 요청 타입을
`common`으로 되돌리면 실제로 실패하는 것까지 확인했다.

**확인하지 못한 것:** 실기기 재현은 사용자만 할 수 있다. 여기서 증명한 것은 요청
타입과 매니페스트가 맞물린다는 것까지이고, 전체 허용한 안드로이드 기기가 이제
`granted`로 잡히는지는 기기에서 봐야 한다.

## 10. 이 스펙이 건드리지 않는 것

- `LikedSpotsScreen`과 `CommunityScreen`의 **내부 동작** — 배치만 바뀐다
- `MapScreen`의 뷰포트 조회·혼잡도·마커 로직 — 진입 경로만 바뀐다
- `DiscoverScreen`, `HomeScreen` — 무관하다
- 기존 라우트 이름 — 딥링크 호환을 위해 유지한다
