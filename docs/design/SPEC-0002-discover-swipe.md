# 디자인 참조 — Discover 스와이프 (SPEC-0002)

> 설계 문서: `problem/SPEC-0002-client.md` · 수용 기준: `Specs/SPEC-0002/spec.md` (AC-15~22)
> Stitch 프로젝트: `projects/8651053354437738829` (K-Trip Spot Design System)
> Stitch 화면: `Discover Swipe` — `screens/ce4b1aa7c3d947a6baac44f8d6bbcf19`
> 디자인 시스템: `assets/073fee5b990e4b1eb2c918d7e9de2d8f`

이 문서는 **레이아웃·컴포넌트 분해 참조**다. 수용 기준과 어긋나면 스펙이 이긴다.
색·폰트·간격 값은 여기 적힌 것을 복사하지 말고 `Theme.of(context)`에서 읽는다 (DESIGN.md §12).

---

## 화면 구조 (위 → 아래)

```
SafeArea
├── CategoryBar          가로 스크롤 pill 칩
├── (Expanded) 카드 스택   앞 카드 + 뒤 카드 peek
│   └── SwipeCard
│       ├── 이미지 (BoxFit은 저작권 유형 분기 — 아래 참조)
│       ├── 하단 그라데이션 스크림 + 텍스트 오버레이 (좌하단)
│       ├── CopyrightBadge (우하단)
│       └── DragFeedbackOverlay (좌상단 LIKE / 우상단 NOPE)
└── 플로팅 라운드 NavigationBar (5탭, Discover 활성)
```

## 컴포넌트

| 컴포넌트 | 역할 | 비고 |
|---|---|---|
| `CategoryBar` | `availableSpotCategories` 결과만 렌더하는 가로 칩 목록 | 선택 칩 = primary 채움 + onPrimary 텍스트 / 비선택 = outlined. **카테고리를 하드코딩하지 않는다** (AC-18) |
| `SwipeCard` | 이미지 1장 중심 카드, radius `xl`(28) | 뒤 카드는 스케일 다운해 아래로 살짝 노출 |
| `DragFeedbackOverlay` | LIKE(초록)/NOPE(적색) 라벨 페이드인 + 카드 기울기 | 변위 비례 회전. Stitch 목업은 우스와이프 진행 중 상태를 정적으로 표현한 것 |
| `CopyrightBadge` | `attributionText` 기반 최소 출처 표기 | 반투명 배경, `label-sm` 스케일. 모든 카드에 노출 |

### 텍스트 오버레이 (좌하단)
- `title` — `title-lg` 스케일, non-null
- `address` — `body-md`
- 거리 — `label-lg`, `distanceMeters`를 클라이언트가 현지화 포맷 ("1.2 km away")

스크림은 가독성 확보용 소프트 다크 그라데이션. 다국어 텍스트 확장 대비해 고정 폭 금지, overflow ellipsis (DESIGN.md §10).

## 저작권 렌더링 분기 (AC-21)

`Spot.copyright`로 이미지 `BoxFit` 분기 — 설계 문서 §6:
- `TYPE1` → `BoxFit.cover`
- `TYPE3` · `UNSPECIFIED` → `BoxFit.contain` + 블러 배경 (크롭 회피)

Stitch 목업은 cover 케이스만 보여준다. contain + 블러 배경 케이스는 목업에 없으니 구현 시 별도 처리.

## 상태 (설계 문서 §7)

| 상태 | 화면 |
|---|---|
| 초기 로딩 | 위치 획득 → 첫 조회까지 스켈레톤/스피너 |
| 위치 권한 거부 | 권한 안내 + 설정 이동 CTA (SPEC-0001 경로 재사용) |
| 결과 0건 | 빈 상태 — 반경 확대/카테고리 변경 유도 |
| 소진 (`hasNextPage=false`) | 빈 상태. 자동 재조회 없음 |
| UPSTREAM_UNAVAILABLE | 재시도 배너(백오프), 기존 스택 유지 |

**Stitch 목업에는 정상 상태만 있다.** 위 4개 상태 화면은 목업 없이 구현한다.

## 제스처 (AC-16·17)

- 오른쪽 = LIKE / 왼쪽 = DISLIKE / 탭 = 상세 진입 (SPEC-0003)
- 확정 임계값: 가로폭 28% 또는 fling 속도 초과 — **실측 튜닝 대상**
- 되돌리기 UI 없음 (spec §7)

## 갭 / 미확정

- 임계값 28%·선제조회 5장은 시작값이며 디바이스 실측으로 조정 (설계 문서 §8)
- 목업의 샘플 콘텐츠(해운대)는 디자인 확인용 — 실제 데이터는 라이브 API
