> spec: SPEC-0003 · source: `Specs/SPEC-0003/spec.md` (Obsidian) · status: draft

# SPEC-0003 · 클라이언트 설계 — 관광지 상세보기

요구사항·수용 기준·컨트랙트는 스펙이 authority다. 이 문서는 **k-trip-spot에 국한된 설계 결정**만 담는다.
반복하지 않고 링크한다: 컨트랙트 초안 `Specs/SPEC-0003/contract.graphql`, 수용 기준(AC-1~32)·정책 판정은 `spec.md`.

관련 이슈: #18. 브랜치: `feature/SPEC-0003-spot-detail` (dev에서 컷).
선행: SPEC-0002가 세운 `spot` 도메인·`SpotRepository`·Discover 스와이프 뷰 위에 상세 뷰를 얹는다.

---

## 1. 도메인 배치 (feature-first)

`spot` 도메인에 상세 뷰를 추가한다. Discover(스와이프)와 같은 도메인.

```
lib/domain/spot/
  model/        SpotDetail(도메인 모델, 신규), SpotImage(값객체, 신규) — 기존 CopyrightType/SpotReaction 재사용
  repository/   SpotRepository — spotDetail 조회 추가. spot_operations.graphql에 spotDetail 쿼리 추가
                (reactToSpot는 기존 오퍼레이션 재사용 — 신규 없음)
  provider/     SpotDetailController(Riverpod codegen) — 상세 로드·상태·좋아요 낙관적 갱신
  component/    SpotGallery(다중 이미지·이미지별 저작권), DetailSection(값 없으면 숨김),
                LikeCountBadge, DetailReactionBar, AttributionBlock(표준 문구 전문)
  view/         SpotDetailView
```

**POL-020 (생성 타입 누출 금지, AC-32)**: graphql_codegen 생성 타입(`SpotDetail`/`SpotImage`)은 `repository/` 밖으로
나가지 않는다. `SpotRepository`가 생성 타입 → 도메인 모델로 매핑하고, provider·view·component는 도메인 모델만 본다.

## 2. GraphQL 소비 (repository 계층)

- `spotDetail(id)`은 쿼리. 상세 반응은 **기존 `reactToSpot` 뮤테이션 재사용**(신규 오퍼레이션 없음, R12).
- 언어는 **인자로 보내지 않는다** — SPEC-0002와 동일하게 GraphQL 클라이언트의 `Accept-Language` 헤더로 전달(R2).
  앱 활성 언어를 헤더에 1회 설정하는 기존 경로를 그대로 쓴다.
- 쿼리 오류는 최상위 `errors[]`(`SPOT_NOT_FOUND`·`UPSTREAM_RATE_LIMITED`·`UPSTREAM_UNAVAILABLE`), 뮤테이션 오류는
  `userErrors[].code`. repository가 이를 도메인 결과/실패로 번역해 provider에 넘긴다(코드 문자열을 UI로 직접 흘리지
  않음, POL-016 대비).

## 3. 화면 레이아웃 (Tinder 상세 참조, R1·R10)

전체화면 스크롤. 위에서 아래로:

- **갤러리**(`SpotGallery`): `SpotDetail.gallery`(최대 10장, TourAPI 순서)를 페이저/캐러셀로. 이미지별
  `SpotImage.copyright`로 저작권 배지. 빈 배열이면 `thumbnailImageUrl` 폴백/플레이스홀더(AC-27).
- **제목·카테고리·주소**: `title`(non-null) 항상, `address` 있으면 표시.
- **소개글**(`DetailSection`): `overview` 있으면 표시, null이면 섹션 숨김(AC-25·R4).
- **연락처**(`DetailSection`): `homepage`(링크)·`tel`(전화) 각각 값 있을 때만. 둘 다 null이면 연락처 블록 숨김.
- **저작권 전문**(`AttributionBlock`): `attributionText` 표준 문구 전문 노출(AC-28). SPEC-0002가 이 스펙에 넘긴 의무.
- **좋아요 개수 + 반응 바**(`LikeCountBadge`·`DetailReactionBar`): 아래 4.

값 없는 섹션은 렌더하지 않는다(빈 라벨/placeholder 금지). 부분 데이터를 빈 상세로 오인시키지 않는다.

## 4. 상세 반응 · 좋아요 낙관적 갱신 (R12, AC-29~31)

- `SpotDetailController`가 `likeCount`를 상태로 보유. 좋아요/싫어요 탭 시:
  1. **낙관적**: 응답 전 `likeCount`를 즉시 갱신(LIKE 탭 → +1). 재평가면 SPEC-0002 규약대로 이전 반응을 덮어쓰는
     것으로 계산(예: 기존 LIKE에서 DISLIKE 탭 → −1).
  2. `reactToSpot(spotId, reaction)` 발사.
  3. **실패 시 롤백**(AC-30): `likeCount`를 이전 값으로 되돌리고 오류 피드백 표시.
- Discover 스와이프의 "낙관적 기록·실패해도 복원 안 함"과 다른 점: 상세에서는 **좋아요 개수가 화면에 보이는 값**이라
  실패 시 롤백이 필요하다(스와이프는 카드가 이미 사라져 되돌릴 대상이 없음).
- 비로그인 반응 → `UNAUTHENTICATED`(SPEC-0002 규약). 로그인 유도.

## 5. 내비게이션 · 상태 보존 (R9, AC-22·23)

- Discover 카드 **탭** → `SpotDetailView`로 push(해당 `contentId` 전달). SPEC-0002가 탭을 상세 진입 제스처로 권장했음.
- 뒤로가기 시 Discover의 **스와이프 스택 위치·카테고리 필터가 보존**돼야 한다. `SwipeController` 상태를 상세 진입 중
  유지(파괴하지 않음) — GoRouter push/pop으로 Discover 뷰를 스택에 남긴다.

## 6. 상태 · 예외 (R10, AC-24·26)

| 상태 | 처리 |
|---|---|
| 로딩 | 상세 진입 직후 응답 대기 → 로딩 인디케이터(AC-24) |
| 정상 | 위 3의 레이아웃 |
| 부분 데이터 | 값 없는 섹션 숨김(AC-25) |
| 이미지 없음 | 갤러리 자리 썸네일 폴백/플레이스홀더(AC-27) |
| SPOT_NOT_FOUND | 오류 상태 화면(재시도), 빈 상세로 오인 금지(AC-26) |
| UPSTREAM_RATE_LIMITED | "잠시 후 다시" 안내 |
| UPSTREAM_UNAVAILABLE | 재시도 가능한 오류 상태(AC-26) |
| 반응 실패 | likeCount 롤백 + 오류 피드백(AC-30) |

## 7. 저작권 렌더링

- 규칙·근거는 spec.md가 authority. 갤러리 이미지의 **저작권 유형별 크롭 렌더링(TYPE3=contain 등)은 이번 미해결**
  (`[TBD-1]`, SPEC-0002 크롭 정책 미해결 상속) — `/amend` 결정 전까지 확정 렌더링을 두지 않는다. 초기 구현은 SPEC-0002
  클라이언트의 현행 방식과 일관되게 두되, 이 스펙 amend에서 유형별 분기를 확정한다.
- 이미지별 저작권 배지는 `SpotImage.copyright`/`attributionText`로 표기(AC-28). 표준 문구 전문은 `AttributionBlock`.

## 8. 표시 문자열 책임

- overview·attributionText 등 **콘텐츠는 서버가 언어별로 내려준다**(POL-024). UI 고정 문구(섹션 제목 "소개"·"연락처",
  좋아요 라벨 등)는 클라이언트 현지화 키. enum 라벨은 클라이언트 매핑(POL-023).

## 9. 미확정(클라이언트 관점)

권위 있는 목록은 spec.md 미결정·열린 질문이다(재기술하지 않음). 클라이언트 착수 전 필요한 값:
- 갤러리 크롭 렌더링 유형별 분기 확정(`[TBD-1]`) — SPEC-0002 `/amend` 결정 대기.
- 갤러리 캐러셀 UX 세부(인디케이터·확대 뷰 여부) — 디자인 확정 대상. 이번 요구엔 "다중 이미지 표시"까지만 걸림.
