# 디자인 참조 — 관광지 상세 (SPEC-0003)

> 설계 문서: `problem/SPEC-0003-client.md` · 수용 기준: `Specs/SPEC-0003/spec.md` (AC-22~32)
> Stitch 프로젝트: `projects/8651053354437738829` (K-Trip Spot Design System)
> Stitch 화면: `Spot Detail` — `screens/6e4432de9649459b879901f4c5610289`
> 디자인 시스템: `assets/073fee5b990e4b1eb2c918d7e9de2d8f`

이 문서는 **레이아웃·컴포넌트 분해 참조**다. 수용 기준과 어긋나면 스펙이 이긴다.
색·폰트·간격 값은 여기 적힌 것을 복사하지 말고 `Theme.of(context)`에서 읽는다 (DESIGN.md §12).

---

## 화면 구조 (위 → 아래, 전체화면 스크롤)

```
SafeArea + 스크롤
├── SpotGallery            화면 높이 ~45%, 캐러셀
│   ├── 페이지 인디케이터 (하단 중앙)
│   ├── 이미지별 CopyrightBadge (우하단)
│   └── 뒤로가기 원형 버튼 (좌상단 오버레이)
├── 제목 블록
│   ├── title              headline-sm
│   ├── 카테고리 pill       secondary 톤
│   └── address            body-md + 위치 아이콘
├── LikeCountBadge + DetailReactionBar
├── DetailSection "Overview"    overview 있을 때만
├── DetailSection "Contact"     homepage / tel 각각 있을 때만
└── AttributionBlock            표준 문구 전문
```

하단 내비 **없음** — push된 상세 페이지. 섹션 간 24px, 좌우 마진 16px, 섹션 사이 얇은 구분선.

## 컴포넌트

| 컴포넌트 | 역할 | 비고 |
|---|---|---|
| `SpotGallery` | `SpotDetail.gallery`(최대 10장, TourAPI 순서) 페이저 | 빈 배열이면 `thumbnailImageUrl` 폴백/플레이스홀더 (AC-27) |
| `DetailSection` | 섹션 헤더 + 본문. **값 없으면 섹션 자체를 렌더하지 않음** | 빈 라벨·placeholder 금지 (AC-25) |
| `LikeCountBadge` | 하트 아이콘 + "1,284 likes" | `label-lg`. 낙관적 갱신 대상 |
| `DetailReactionBar` | Like(filled primary) / Pass(outlined) 버튼 | 각각 ≥48dp |
| `AttributionBlock` | 표준 문구 전문 + 출처 링크 | `surface-container` 배경, 저강조 (AC-28) |

## 좋아요 낙관적 갱신 (AC-29~31)

스와이프와 **다르게 동작한다** — 상세에서는 좋아요 개수가 화면에 보이므로 실패 시 롤백이 필요:

1. 탭 즉시 `likeCount` 갱신 (LIKE → +1, 기존 LIKE에서 DISLIKE 탭 → −1)
2. `reactToSpot(spotId, reaction)` 발사
3. **실패 시 이전 값으로 롤백** + 오류 피드백 (AC-30)

비로그인 반응 → `UNAUTHENTICATED` → 로그인 유도.

## 상태 (설계 문서 §6)

| 상태 | 화면 |
|---|---|
| 로딩 | 진입 직후 로딩 인디케이터 (AC-24) |
| 부분 데이터 | 값 없는 섹션 숨김 (AC-25) |
| 이미지 없음 | 갤러리 자리 썸네일 폴백/플레이스홀더 (AC-27) |
| SPOT_NOT_FOUND | 오류 상태 화면(재시도). **빈 상세로 오인 금지** (AC-26) |
| UPSTREAM_RATE_LIMITED | "잠시 후 다시" 안내 |
| UPSTREAM_UNAVAILABLE | 재시도 가능한 오류 상태 (AC-26) |
| 반응 실패 | likeCount 롤백 + 오류 피드백 (AC-30) |

**Stitch 목업에는 정상 상태만 있다.** 위 상태 화면은 목업 없이 구현한다.

## 내비게이션 (AC-22·23)

- Discover 카드 **탭** → 상세 push (`contentId` 전달)
- 뒤로가기 시 Discover의 **스와이프 스택 위치·카테고리 필터 보존** — `SwipeController` 상태를 파괴하지 않고 GoRouter push/pop으로 Discover를 스택에 남긴다

## 갭 / 미확정

- **갤러리 크롭 렌더링 유형별 분기 (`[TBD-1]`)** — SPEC-0002에서 상속된 미해결. `/amend` 결정 전까지 확정 렌더링을 두지 않는다. Stitch 목업이 보여주는 크롭 방식은 임의 선택이며 **결정 근거가 아니다** (설계 문서 §7)
- 캐러셀 UX 세부(인디케이터 형태·확대 뷰 여부) — 이번 요구는 "다중 이미지 표시"까지만. 목업의 5점 인디케이터는 제안일 뿐
- 목업의 샘플 콘텐츠(경복궁)는 디자인 확인용 — 실제 데이터는 라이브 API
