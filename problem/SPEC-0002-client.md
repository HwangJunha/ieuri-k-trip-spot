> spec: SPEC-0002 · source: `Specs/SPEC-0002/spec.md` (Obsidian) · status: draft

# SPEC-0002 · 클라이언트 설계 — 관광지 스와이프 추천

요구사항·수용 기준·컨트랙트는 스펙이 authority다. 이 문서는 **k-trip-spot에 국한된 설계 결정**만 담는다.
반복하지 않고 링크한다: 컨트랙트 초안 `Specs/SPEC-0002/contract.graphql`, 수용 기준(AC-1~22)·정책 판정은 `spec.md`.

관련 이슈: #16. 브랜치: `feature/SPEC-0002-spot-swipe` (dev에서 컷).

---

## 1. 도메인 배치 (feature-first)

`spot` 도메인의 Discover(스와이프) 뷰. 기존 4개 도메인(auth/spot/event/onboarding) 중 `spot`에 들어간다.
`SpotRepository`는 이미 존재(현재 mock). 이번 스펙이 그 실 구현을 채운다.

```
lib/domain/spot/
  model/        TouristSpot(도메인 모델), SpotCategory, CopyrightType, SpotReaction, Distance 표시값
  repository/   SpotRepository(인터페이스), SpotRepositoryImpl(graphql_flutter + codegen)
                spot_operations.graphql (spots / availableSpotCategories / reactToSpot)
  provider/     SwipeController(Riverpod codegen) — 카드 스택·선제조회·낙관적 기록
  component/    SwipeCard, DragFeedbackOverlay(LIKE/NOPE 라벨·기울기), CategoryBar, CopyrightBadge
  view/         DiscoverSwipeView
```

**POL-020 (생성 타입 누출 금지, AC-22)**: graphql_codegen 생성 타입은 `repository/` 밖으로 나가지 않는다.
`SpotRepositoryImpl`이 생성 타입 → 도메인 모델(`TouristSpot`)로 매핑하고, provider·view·component는 도메인
모델만 본다.

## 2. GraphQL 소비 (repository 계층)

- `spots`·`availableSpotCategories`는 쿼리, `reactToSpot`은 뮤테이션. 언어는 **인자로 보내지 않는다** — GraphQL
  클라이언트의 `Accept-Language` 헤더로 전달(서버가 헤더에서 읽음). 앱 활성 언어를 링크/헤더에 1회 설정.
- 쿼리 오류는 최상위 `errors[]`(서버 §7), 뮤테이션 오류는 `userErrors[].code`. repository가 이를 도메인
  결과/실패로 번역해 provider에 넘긴다(코드 문자열을 UI로 직접 흘리지 않음, POL-016 대비).

## 3. 스와이프 UI · 제스처 (AC-16, AC-17)

- 카드 = 이미지 1장(`thumbnailImageUrl`). 좌측 하단 오버레이: `title` / `address` / 거리.
  - 거리 표시: `distanceMeters`(서버 계산)를 클라이언트가 현지화 포맷("1.2 km" / "1.2 km" / "1.2キロ" 등).
    표시 문자열은 클라이언트 책임(POL-024 신규: 콘텐츠는 서버, 표시 포맷·고정문구는 클라이언트).
- **제스처**: 오른쪽=LIKE, 왼쪽=DISLIKE. 상세보기 진입 제스처는 정의하지 않음(상세보기 범위 밖).
- **드래그 피드백**: 방향 라벨(LIKE 초록 / NOPE 적색) 페이드인 + 카드 기울기(변위 비례 회전) + 다음 카드 스케일업.
- **취소 임계값**: 가로폭 28%(시작값) 또는 fling 속도 임계 초과 시 확정, 미만이면 스프링백. **실측 튜닝 대상.**
- **되돌리기 없음**(spec §7). 직전 스와이프 취소 UI를 두지 않는다.

## 4. 카드 스택 · 선제 조회 · 소진 (AC-19)

- `SwipeController`가 카드 큐를 보유. **잔여 N장(시작값 5)** 도달 시 다음 페이지(`after` 커서)를 백그라운드 조회해
  스택 하단에 이어 붙인다.
- **낙관적 기록**: 스와이프 즉시 카드 제거 + `reactToSpot` 비동기 발사. 실패해도 카드 복원 안 함(좋아요 실패는
  비치명적). 실패는 조용히 로깅, 필요 시 재시도 큐.
- **소진**: `hasNextPage=false`에서 마지막 카드 소비 시 빈 상태(반경 확대/카테고리 변경 제안). 자동 재조회 안 함.

## 5. 카테고리 UI (AC-18)

- 상단 카테고리 바는 `availableSpotCategories` 결과만 렌더. 활성 언어=KO면 여행코스 포함·교통 제외, EN/JA/ZH면
  교통 포함·여행코스 제외. 없는 카테고리를 클라이언트가 하드코딩하지 않는다(서버가 가용성의 단일 출처).
- enum 라벨(표시명)은 클라이언트 현지화 키로 매핑(POL-023: enum은 식별자, 표시는 별도).

## 6. 저작권 렌더링 분기 (AC-15 소비, AC-21)

규칙·근거는 spec.md §4.7이 authority(재기술하지 않음). 이 문서는 Flutter 매핑만 담는다.

- `Spot.copyright`로 `BoxFit` 분기: **TYPE1 → `BoxFit.cover`**, **TYPE3·UNSPECIFIED → `BoxFit.contain` + 블러 배경**(크롭 회피).
- CopyrightBadge 컴포넌트가 모든 카드에 `attributionText` 기반 최소 출처 표기.
- 표준 문구 전문은 설정 내 저작권 정보 페이지(별도 화면)에 렌더 — 온라인 출처 링크는 `Uri`로 하이퍼링크.
- UI 일관성 트레이드오프·통일 여부 판단은 spec.md §4.7·§6 참조.

## 7. 상태 · 예외 (AC-20)

| 상태 | 처리 |
|---|---|
| 초기 로딩 | 위치 획득 → 첫 조회까지 스켈레톤/스피너 |
| 위치 권한 거부 | 권한 안내 + 설정 이동 CTA(크래시 없음). SPEC-0001이 권한·설정 이동 경로 제공. 수동 지역 선택 폴백은 범위 밖 |
| 결과 0건 | 빈 상태 안내(반경 확대/카테고리 변경 유도) |
| UPSTREAM_UNAVAILABLE | 재시도 배너(백오프), 기존 스택 유지 |
| 네트워크 오류 | graphql_flutter 레벨 오류 → 재시도 |

## 8. 미확정(클라이언트 관점)

미결정의 권위 있는 목록은 spec.md §6. 클라이언트 구현 착수 전 필요한 값:
- 취소 임계값·선제 조회 N장 실측 튜닝값 — 디바이스 실측(권장 시작값: 28%, 5장).

확정: 반경 슬라이더는 기본 20,000m·상한 100,000m(서버 실측 B-1).
