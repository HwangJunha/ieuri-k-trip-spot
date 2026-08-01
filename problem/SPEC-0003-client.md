> spec: SPEC-0003 · source: `Specs/SPEC-0003/spec.md` (Obsidian) · status: draft (v1.1, 개정 반영됨)

# SPEC-0003 · 클라이언트 설계 — 관광지 상세보기

요구사항·수용 기준·컨트랙트는 스펙이 authority다. 이 문서는 **k-trip-spot에 국한된 설계 결정**만 담는다.
반복하지 않고 링크한다: 컨트랙트 초안 `Specs/SPEC-0003/contract.graphql`, 수용 기준(AC-1~49)·정책 판정은 `spec.md`.

관련 이슈: #18. 브랜치: `feature/SPEC-0003-spot-detail` (dev에서 컷).
선행: SPEC-0002가 세운 `spot` 도메인·`SpotRepository`·Discover 스와이프 뷰 위에 상세 뷰를 얹는다.

> **v1.1 개정(2026-08-02, 이슈 #23 [AMEND 정정])** — 서버가 상세를 **필드별 지연 조회**로 재설계하면서
> `intro`(운영 정보)·`infoItems`(이용안내)가 추가됐고, 두 필드는 `category`를 **필수 인자**로 받는다.
> 클라이언트에 미치는 영향은 세 가지다: (1) 상세 쿼리가 `$category` 변수를 받아야 하고, (2) 운영 정보·이용안내
> 두 섹션이 화면에 추가되며, (3) 요청하는 필드가 서버의 upstream 콜 수를 결정하므로 **필드 선택이 곧 비용 결정**이
> 됐다. 루트 `spotDetail(id:)` 시그니처는 그대로라 기존 호출 경로는 깨지지 않는다.

---

## 1. 도메인 배치 (feature-first)

`spot` 도메인에 상세 뷰를 추가한다. Discover(스와이프)와 같은 도메인.

```
lib/domain/spot/
  model/        SpotDetail(도메인 모델, 신규), SpotImage(값객체, 신규),
                SpotIntro + SpotIntroEntry/SpotIntroField(신규, v1.1), SpotInfoItem(신규, v1.1),
                tour_api_text.dart(표시용 텍스트 정리 규칙, 신규 — 아래 3.1)
                — 기존 CopyrightType/SpotReaction 재사용
  repository/   SpotRepository — spotDetail 조회 추가. spot_operations.graphql에 spotDetail 쿼리 추가
                (reactToSpot는 기존 오퍼레이션 재사용 — 신규 없음)
  provider/     SpotDetailController(Riverpod codegen) — 상세 로드·상태·좋아요 낙관적 갱신.
                build(contentId, category) — category가 provider 키의 일부다(아래 2.1)
  component/    SpotGallery(다중 이미지·이미지별 저작권), DetailSection(값 없으면 숨김),
                SpotIntroRows(운영 정보 행 목록, 신규), SpotInfoItemList(이용안내 목록, 신규),
                LikeCountBadge, DetailReactionBar, AttributionBlock(표준 문구 전문)
  view/         SpotDetailView
```

**POL-020 (생성 타입 누출 금지, AC-32)**: graphql_codegen 생성 타입(`SpotDetail`/`SpotImage`/`SpotIntro`/
`SpotInfoItem`)은 `repository/` 밖으로 나가지 않는다. `SpotRepository`가 생성 타입 → 도메인 모델로 매핑하고,
provider·view·component는 도메인 모델만 본다. 카테고리 enum도 마찬가지로 repository 경계에서
도메인 `SpotCategory` ↔ 생성 `Enum$SpotCategory`로 양방향 변환한다.

## 2. GraphQL 소비 (repository 계층)

- `spotDetail(id)`은 쿼리. 상세 반응은 **기존 `reactToSpot` 뮤테이션 재사용**(신규 오퍼레이션 없음, R12).
- 언어는 **인자로 보내지 않는다** — SPEC-0002와 동일하게 GraphQL 클라이언트의 `Accept-Language` 헤더로 전달(R2).
  앱 활성 언어를 헤더에 1회 설정하는 기존 경로를 그대로 쓴다.
- 쿼리 오류는 최상위 `errors[]`(`SPOT_NOT_FOUND`·`UPSTREAM_RATE_LIMITED`·`UPSTREAM_UNAVAILABLE`), 뮤테이션 오류는
  `userErrors[].code`. repository가 이를 도메인 결과/실패로 번역해 provider에 넘긴다(코드 문자열을 UI로 직접 흘리지
  않음, POL-016 대비).

### 2.1 `category` 인자 전달 (v1.1, R15·AC-49)

상세 쿼리는 `SpotDetail($id: ID!, $category: SpotCategory!)`로 **카테고리를 변수로 받는다.** 서버의
`intro`·`infoItems`가 이를 필수 인자로 요구하기 때문이다.

**같은 응답의 `category` 필드를 인자로 되쓸 수 없다** — GraphQL은 한 쿼리 안에서 응답 값을 인자로 참조하지
못한다. 따라서 값의 출처는 둘 중 하나다:

| 출처 | 판단 |
|---|---|
| **호출부가 넘긴다**(채택) | Discover 카드가 `Spot.category`를 이미 들고 있다. 추가 왕복 없이 한 번에 요청한다. |
| 상세를 두 번 조회한다 | 본문을 먼저 받아 카테고리를 얻고 다시 요청. **왕복이 2회로 늘고 화면이 두 단계로 뜬다** — 채택하지 않음. |

그래서 `SpotDetailView`·`SpotDetailController` 모두 `(contentId, category)` 쌍을 받는다. 카테고리는
**provider 키의 일부**이기도 하다 — 서버 캐시가 `intro`·`infoItems`를 카테고리별로 나눠 잡으므로(spec R7),
클라이언트 캐시도 같은 단위로 갈라져 있어야 값이 섞이지 않는다.

### 2.2 필드 선택이 곧 upstream 비용 (v1.1, spec `[TBD-4]`)

지연 조회로 **요청한 필드가 서버의 TourAPI 콜 수를 결정한다**(본문만 1콜, 전 필드 4콜). 상세 화면은 모든
섹션을 한 번에 보여주므로 현재 오퍼레이션은 전 필드를 요청한다 — 즉 진입당 최대 4콜이다.

이는 서버의 일일 한도를 클라이언트가 좌우한다는 뜻이고, spec은 이 책임 소재를 미결정(`[TBD-4]`)으로 둔 채
"클라가 필요한 것만 요청한다"를 전제로 한다. **필드를 습관적으로 다 넣지 않는 것이 이 전제를 지키는 방법이다** —
갤러리 프리뷰처럼 본문만 필요한 화면이 나중에 생기면 그 화면 전용으로 좁힌 오퍼레이션을 따로 두고, 이 쿼리를
재사용하지 않는다.

## 3. 화면 레이아웃 (Tinder 상세 참조, R1·R10)

전체화면 스크롤. 위에서 아래로:

- **갤러리**(`SpotGallery`): `SpotDetail.gallery`(최대 10장, TourAPI 순서)를 페이저/캐러셀로. 이미지별
  `SpotImage.copyright`로 저작권 배지. 빈 배열이면 `thumbnailImageUrl` 폴백/플레이스홀더(AC-27).
- **제목·카테고리·주소**: `title`(non-null) 항상, `address` 있으면 표시.
- **소개글**(`DetailSection`): `overview` 있으면 표시, null이면 섹션 숨김(AC-25·R4).
- **운영 정보**(`DetailSection` + `SpotIntroRows`, v1.1): 이용시간·휴무일·요금·주차·반려동물·카드·문의처를
  행 목록으로. `intro`가 null이거나 표시할 항목이 하나도 없으면 섹션 숨김(AC-46·AC-47).
- **이용안내**(`DetailSection` + `SpotInfoItemList`, v1.1): `{name, text}` 쌍 목록. 빈 배열이면 섹션 숨김(AC-48).
- **연락처**(`DetailSection`): `homepage`(링크)·`tel`(전화) 각각 값 있을 때만. 둘 다 null이면 연락처 블록 숨김.
- **저작권 전문**(`AttributionBlock`): `attributionText` 표준 문구 전문 노출(AC-28). SPEC-0002가 이 스펙에 넘긴 의무.
- **좋아요 개수 + 반응 바**(`LikeCountBadge`·`DetailReactionBar`): 아래 4.

값 없는 섹션은 렌더하지 않는다(빈 라벨/placeholder 금지). 부분 데이터를 빈 상세로 오인시키지 않는다.

**"값 없음" 판정은 모델이 한 곳에서 한다.** 운영 정보는 필드가 7개라 뷰가 각각 검사하면 조건문이 흩어진다.
`SpotIntro.presentEntries`가 표시 대상 항목만 순서대로 만들어 주고, 뷰는 그 목록이 비었는지만 본다.
같은 이유로 이용안내도 모델 쪽에서 표시 가능한 항목을 걸러 낸다.

**null만으로는 부족하다** — TourAPI는 값이 없을 때 빈 문자열을 주기도 해서, null만 검사하면 `"주차: "` 같은
빈 라벨이 화면에 남는다. 공백뿐인 값도 "없음"으로 친다.

### 3.1 TourAPI 텍스트 정리 (`tour_api_text.dart`)

TourAPI 원문에는 **HTML 조각이 섞여 온다.** 줄바꿈을 `<br>`로 주고(`<br/>`·`<BR>` 표기가 뒤섞인다),
`&amp;`·`&nbsp;` 같은 엔티티가 그대로 실려 온다. 그대로 그리면 태그가 리터럴로 노출되고 줄바꿈도 먹지 않는다.

정리는 **클라이언트 책임**이다(POL-024: 표시 규칙은 클라). 서버는 원문을 그대로 내려주고, `overview`·`intro`·
`infoItems` 여러 필드가 같은 규칙을 쓰므로 모델 계층 한 곳(`sanitizeTourApiText`)에 모아 위젯마다 반복하지 않는다.

- `<br>` 계열과 블록 태그 닫힘(`</p>`·`</li>` 등)은 **줄바꿈으로 바꾼다** — 운영시간처럼 줄 구분이 의미를 갖는
  데이터가 있어 보존해야 한다.
- 나머지 태그는 제거하되, **`<`로 시작해 영문자가 오는 경우로 좁힌다.** `<[^>]*>`로 넓게 잡으면 원문에 강조로
  쓰인 꺾쇠(`5세 미만 <무료>`, `11:00 <-> 22:00`)까지 삼켜 **내용이 조용히 사라진다.**
- 숫자 엔티티(`&#40;`)를 먼저 되돌린 뒤 명명 엔티티를 처리하고, `&amp;`는 마지막에 가깝게 둔다 —
  먼저 풀면 `&amp;lt;`가 `<`까지 이중 해제된다.
- **정리 후 비면 null을 돌려준다.** 호출부의 "값 없으면 안 그린다" 판단이 태그만 남은 문자열(`"<br>"`)에도
  그대로 적용되도록 하기 위해서다.

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

- Discover 카드 **탭** → `SpotDetailView`로 push(해당 `contentId`와 `category` 전달 — 위 2.1). SPEC-0002가 탭을
  상세 진입 제스처로 권장했음.
- 뒤로가기 시 Discover의 **스와이프 스택 위치·카테고리 필터가 보존**돼야 한다. `SwipeController` 상태를 상세 진입 중
  유지(파괴하지 않음) — GoRouter push/pop으로 Discover 뷰를 스택에 남긴다.

## 6. 상태 · 예외 (R10, AC-24·26)

| 상태 | 처리 |
|---|---|
| 로딩 | 상세 진입 직후 응답 대기 → 로딩 인디케이터(AC-24) |
| 정상 | 위 3의 레이아웃 |
| 부분 데이터 | 값 없는 섹션 숨김(AC-25) |
| 이미지 없음 | 갤러리 자리 썸네일 폴백/플레이스홀더(AC-27) |
| 운영 정보 없음 | `intro`가 null이거나 표시 항목 0개 → 운영 정보 섹션 숨김(AC-46·AC-47) |
| 이용안내 없음 | `infoItems` 빈 배열 → 이용안내 섹션 숨김(AC-48) |
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
- **운영 정보 항목 라벨도 클라이언트 몫이다.** 서버가 주는 것은 값(`businessHours` 등 문자열)뿐이고 "이용시간"·
  "휴무일" 같은 항목명은 내려오지 않는다. 모델은 `SpotIntroField` enum으로 **종류만** 갖고, 아이콘·다국어 라벨은
  뷰가 그 키로 고른다(POL-023: enum은 표시 문자열이 아니다).
- **반려동물·카드 가능 여부는 Boolean이 아니라 문장이다.** 서버가 TourAPI 원문("가능"/"불가"/"카드결제 가능")을
  그대로 내려주므로 클라이언트는 해석하지 않고 표시한다. 원문 값 집합이 확정되면 enum화를 재검토한다(spec POL-023).
- **표시 순서는 클라이언트가 정한다.** 여행자가 확인하는 순서 — 언제 여는가(이용시간) → 언제 닫는가(휴무일) →
  얼마인가(요금) → 부가 조건(주차·반려동물·카드) → 문의처. 서버 응답 필드 순서와 무관하며 `presentEntries`가 고정한다.

## 9. 미확정(클라이언트 관점)

권위 있는 목록은 spec.md 미결정·열린 질문이다(재기술하지 않음). 클라이언트 관점에서 값이 필요한 것:
- 갤러리 크롭 렌더링 유형별 분기 확정(`[TBD-1]`) — SPEC-0002 `/amend` 결정 대기.
- 갤러리 캐러셀 UX 세부(인디케이터·확대 뷰 여부) — 디자인 확정 대상. 이번 요구엔 "다중 이미지 표시"까지만 걸림.
- **하위 필드 부분 실패 시 화면 동작**(spec `[TBD-3]`) — 서버 결정 대기. 현행 초안 SDL에서는 `gallery`·`infoItems`가
  non-null이라 그 필드의 upstream이 실패하면 **쿼리 전체가 실패**해 본문까지 못 받는다. 즉 지금은 "일부 섹션만
  못 받은 상태"를 클라이언트가 표현할 수 없고, 오류 상태 화면(AC-26)으로 떨어진다. 서버가 두 필드를 nullable로
  바꾸면 그때 부분 렌더 분기를 넣는다 — **결정 전까지 부분 실패 UI를 만들지 않는다.**
- **필드 선택에 따른 upstream 비용 통제**(spec `[TBD-4]`) — 현재 상세 진입은 전 필드 요청(최대 4콜)이다.
  서버가 한도 보호를 넣으면 요청 필드를 좁히는 조정이 필요할 수 있다(위 2.2).
- 운영 정보 `petAllowed`·`creditCardAccepted`의 enum화 여부 — 원문 값 집합 확정 후(위 8).
