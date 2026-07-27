# 이으리(ieuri) k-trip-spot 홈 스크린 개발 — 요구사항 분석서

> 로그인 이후 진입하는 **홈 스크린**과 앱 전역 **하단 5탭 플로팅 내비게이션**을 구현한다.
> 서버에 관광 데이터(spot/event/혼잡도/랭킹) API가 **아직 없으므로**, 이번 작업은 **UI 골격 + 목(mock) 데이터**로 만든다. 서버 API가 생기면 repository만 교체한다.
> 디자인 출처: **Google Stitch** 프로젝트 `K-Trip Spot`(project `8651053354437738829`, "Home Screen" 스크린) + `DESIGN.md`.

---

## 0. 문서 정보

| 항목 | 내용 |
|---|---|
| 대상 앱 | `ieuri_k_trip_spot` (Flutter, 외국인 대상 실시간 위치기반 한국 관광 앱) |
| 기능 | 홈 스크린 + 하단 내비 셸 |
| 상태 | **요구사항 분석 / 승인 대기** |
| 데이터 | **목 데이터**(서버 관광 API 부재). repository 경계 유지 → API 도입 시 repo만 교체 |
| 선행 | 앱 토대(테마·다국어·라우팅), 회원 기능(auth·로그인 게이트·온보딩) 완료 |
| 디자인 | Stitch `Home Screen` + `DESIGN.md`(색·타이포·간격·컴포넌트 규칙의 단일 진실 공급원) |
| 근거 규약 | 프로젝트 `CLAUDE.md`, `DESIGN.md` §12 에이전트 규칙 |

### 개정 이력
- **v1.0 — 초안: Stitch Home Screen 구조 반영, 5탭 셸, 목 데이터 범위 확정.**

---

## 1. 개요 & 목표

Step 2까지 인증 게이트를 통과하면 도달하는 첫 화면이 **홈**이다. 홈의 목표:

1. 앱의 가치를 한눈에 보여주는 **발견 허브** — 추천 spot, 지금 열리는 행사, 인기 spot을 카드로 노출.
2. 앱 전역 **하단 5탭 플로팅 내비게이션 셸**을 세운다: `Home · Map · Discover · Events · Chat`. 이후 단계의 화면들이 이 셸에 얹힌다.
3. 서버 관광 API가 없으므로 **목 데이터로 UI를 완성**하되, 데이터 접근을 repository 뒤에 격리해 API 도입 시 UI/provider 변경 없이 교체 가능하게 한다.

---

## 2. 범위 (Scope)

### 2.1 In Scope
- **홈 도메인** `lib/domain/home/` 신규 (model · repository · provider · component · view)
- **홈 스크린**(`home_screen.dart`): 앱바 + 검색바(비동작 placeholder) + 3개 섹션(추천/행사/인기)
- **하단 5탭 플로팅 내비 셸**: `common/` 또는 라우터 셸(ShellRoute)로 구현. 홈 외 4탭은 **플레이스홀더 화면**(이후 단계에서 채움)
- **목 데이터 repository**: spot/event 목록을 하드코딩 목으로 반환(비동기 인터페이스 유지)
- **혼잡도 시맨틱 색상**: `ThemeExtension`으로 도입(여유/보통/혼잡 — `DESIGN.md` §5). 홈 카드 배지에 사용
- 라우팅: 홈 및 셸 라우트를 GoRouter에 등록(인증 게이트 하위)
- 다국어: 신규 카피 4개 언어(EN/KO/JA/ZH)
- 테스트: 레이어별(model/repository/provider/view)

### 2.2 Out of Scope
- **실제 관광 데이터 서버 연동** — 서버 API 부재. 목으로 대체, API 도입 시 후속
- **Discover(스와이프)·Map(혼잡도 맵)·Events·Chat 화면 본체** — 각각 이후 단계. 이번엔 플레이스홀더만
- **Spot 상세·찜·프로필/설정 화면** — 이후
- 검색 기능(검색바는 UI만, 동작 없음 또는 비활성)
- 위치 권한/GPS 실측(카드의 "2.4km" 등은 목 값)

---

## 3. 디자인 참조 (Stitch Home Screen)

Stitch `Home Screen`(모바일) 구조를 위→아래로:

1. **앱바**: 좌측 앱 로고/타이틀 "K-Trip Spot", 우측 하트 아이콘(찜 목록 진입 — 이번엔 라우트 미구현이면 비활성/토스트).
2. **검색바**: placeholder "Search for spots, hidden gems…". 이번 작업 비동작.
3. **Recommended for You** 섹션: 헤더 + "View all" 링크. **가로 스크롤 카드**(이미지·타이틀·위치 배지·혼잡도 배지).
   - 예: Gyeongbokgung Palace / Seoul, Jongno-gu / Low. Seongsu-dong Cafe Street / Seongdong-gu / Moderate.
4. **Happening Now** 섹션: 행사 카드 리스트(카테고리 배지: Festival/Live/Art 등, 아이콘).
   - 예: Myeongdong Food Fest, K-Pop Dance Busking, Media Art Expo.
5. **Popular Spots** 섹션: 세로 카드(별점, 설명, "Very Busy · 2.4km away" 형태의 혼잡도+거리).
6. **하단 플로팅 내비(5탭)**: `Home · Map · Discover · Events · Chat`. Discover 중앙 강조(`DESIGN.md` §8).

> `DESIGN.md` §12 절대 규칙: 색·폰트·간격·반경은 전부 테마/토큰에서(하드코딩 금지), 아이콘은 `Icons.*`만, 텍스트는 전부 l10n 키, Stitch export는 **레이아웃/구조 참고용**(색·크기 값 복사 금지).

---

## 4. 데이터 계층 (목 → 서버 교체 가능)

- **`HomeRepository`**(인터페이스) + **`HomeRepositoryImpl`**(현재: 목 반환). 반환은 도메인 `model`.
- 모델(순수 Dart): `TouristSpot`(id·name·imageUrl·location·congestion·rating?·distanceKm?), `TourEvent`(id·title·category·imageUrl), `CongestionLevel`(enum: low/moderate/high) 등. 필드는 Stitch 카드가 요구하는 최소값.
- **목 데이터**는 repository 내부 상수/팩토리로 둔다. 비동기 시그니처(`Future`)를 유지해 서버 도입 시 GraphQL 호출로 교체해도 provider/UI 무변경.
- 이미지: 목은 자산 placeholder 또는 색 블록(외부 네트워크 이미지는 지양 — 오프라인/테스트 안정성).

---

## 5. 상태관리 (Riverpod)

- 섹션별 `FutureProvider`/`AsyncNotifier`(codegen)로 목 데이터를 노출, UI엔 `AsyncValue`.
- repository는 provider로 노출, 위젯이 직접 생성 금지.
- 리스트가 길어질 여지가 있으면 `common/pagination` 재사용(이번 목은 소량이라 미적용 가능 — 재구현 금지).
- 하단 탭 인덱스 등 셸 상태는 `autoDispose` 기본.

---

## 6. 라우팅 (GoRouter · 하단 내비 셸)

- **StatefulShellRoute**(또는 ShellRoute + IndexedStack)로 5탭 셸 구성. 각 탭이 자체 네비게이션 스택 유지.
- 탭 라우트: `home`, `map`, `discover`, `events`, `chat`. Home 외 4개는 플레이스홀더 화면.
- 인증 게이트(Step 2 §10) 하위에 위치: 미인증/온보딩 미완료는 셸 진입 불가. 기존 `Routes.home`을 셸의 첫 탭으로 대체.
- 임시 디버그 뒤로가기 버튼(Step 1)과의 정합성 확인.

---

## 7. 아키텍처 배치

```
lib/
├── common/
│   └── widget/                 # (필요시) 플로팅 내비 등 진짜 공용 위젯
├── domain/
│   └── home/                   # (신규)
│       ├── model/              # TouristSpot, TourEvent, CongestionLevel
│       ├── repository/         # HomeRepository(+Impl, 목)
│       ├── provider/           # 섹션 provider들
│       ├── component/          # spot_card, event_card, section_header, home_search_bar
│       └── view/               # home_screen
├── (탭 플레이스홀더) domain/{map,discover,events,chat}/view/*_placeholder or common
└── router/                     # 셸 라우트 + 탭
```

- 혼잡도 색은 `ThemeExtension`(공용) — Map/카드 공유하므로 `common/theme`에 둔다.
- cross-feature import 금지. 탭 플레이스홀더는 각 도메인 최소 스텁 또는 공용 플레이스홀더.

---

## 8. 다국어 (i18n)
- 신규 카피(섹션 제목 "Recommended for You"/"Happening Now"/"Popular Spots", "View all", 검색 placeholder, 탭 라벨, 혼잡도 라벨 Low/Moderate/High)를 `app_{ko,en,ja,zh}.arb`에 추가, gen-l10n 재생성.
- 소스 KO, 기본 EN. 하드코딩 금지.

---

## 9. 테스트 전략 (레이어별)

| 대상 | 테스트 |
|---|---|
| `model` | 순수 단위: 동등성/직렬화(있으면)/CongestionLevel 매핑. |
| `repository`(목) | 목 반환 형태 검증(개수·필드 채워짐). 서버 도입 후엔 mock GraphQL로 교체. |
| `provider` | `ProviderContainer` + repo override. `AsyncValue` 로딩→데이터 검증. |
| `view` | 위젯 테스트 + provider override: 3개 섹션 헤더 표시, 카드 렌더, 혼잡도 배지 색/라벨, 탭 전환. |

- 생성 코드·프레임워크 코드는 테스트 안 함.

---

## 10. 인수 조건 (Acceptance Criteria)
1. 인증+온보딩을 마친 사용자는 홈 스크린을 보고, 하단 5탭 플로팅 내비가 나타난다.
2. 홈에 Recommended/Happening Now/Popular Spots 3개 섹션이 목 데이터로 렌더된다.
3. 혼잡도 배지가 `ThemeExtension` 색(여유/보통/혼잡)으로 표시된다.
4. 5탭 전환이 동작하고, Home 외 탭은 플레이스홀더가 뜬다.
5. 색·폰트·간격은 테마/토큰 경유(하드코딩 없음), 텍스트는 전부 l10n(4개 언어).
6. 데이터 접근이 `HomeRepository` 뒤에 격리되어, 서버 API 도입 시 provider/UI 변경 없이 교체 가능하다.
7. 레이어 경계·의존 방향이 지켜지고 레이어별 테스트가 통과한다.

---

## 11. 향후 단계
- 서버 관광 데이터 API(spot/event/혼잡도/랭킹) 도입 → `HomeRepositoryImpl`을 GraphQL로 교체.
- Discover(스와이프)·Map(혼잡도)·Events·Chat 화면 본체, Spot 상세, 찜, 프로필/설정.
