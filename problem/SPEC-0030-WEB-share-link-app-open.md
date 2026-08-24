# SPEC-0030 — 공유 링크가 앱을 열게 하려면 (웹 할 일)

- 대상: **`www.ieuri.co.kr`을 띄우는 쪽.** GraphQL 서버가 아니다
- 상태: **대기 중** — 도메인에 사이트가 아직 없다(2026-08-22 루트도 404)

## GraphQL 서버는 할 일이 없다

먼저 분명히 해 둔다. 이 문서의 요청은 **전부 웹 인프라 일**이며 GraphQL
서버에 요청할 것은 **하나도 없다.**

| | 상태 |
|---|---|
| `createMapShareLink`가 `https://` 링크를 준다 | ✅ 완료 |
| `sharedMap(token:)` 조회 | ✅ 완료 |
| 관계 지도 오퍼레이션 4개 | ✅ 완료(`SPEC-0030-SERVER-relation-map.md`) |
| 클라이언트 수신 설정(iOS·Android) | ✅ 완료 |
| **웹: `.well-known` 파일 2개** | ❌ 남음 |
| **웹: 중간 페이지** | ❌ 남음 |

## 지금 무엇이 막혀 있나

```
카톡에서 https://www.ieuri.co.kr/tour/korea-map/xxx 누름
        │
        ▼
   Safari 404          ← 그 도메인에 아무것도 없다
```

`www.ieuri.co.kr`은 Cloudflare에 연결돼 있으나 **뒤에 사이트가 없다.**
루트(`/`)조차 404다. OCI까지 연결은 돼 있는 상태.

## 할 일 (순서대로)

### 1. `www.ieuri.co.kr`에 정적 사이트를 띄운다 ← **지금 막힌 곳**

계획된 내용: 메인 페이지, 개인정보처리방침, 서비스이용약관, 위치정보 이용약관.
본격적인 웹은 서브도메인으로 분리한다.

**이게 되기 전에는 아래가 전부 대기다.**

### 2. `.well-known` 파일 2개를 그 사이트 루트에 올린다

파일은 이미 만들어 뒀다 — `web-wellknown/.well-known/`.

```
https://www.ieuri.co.kr/.well-known/apple-app-site-association   ← 완성
https://www.ieuri.co.kr/.well-known/assetlinks.json              ← 지문 한 줄 비어 있음
```

주의할 점은 `web-wellknown/README.md`에 정리했다(경로·Content-Type·확장자·
Nginx가 점 폴더를 막는 문제).

**`.well-known`과 중간 페이지는 반드시 `www` 쪽에 둔다.** 서브도메인에 두면
동작하지 않는다 — 공유 링크의 호스트가 `www.ieuri.co.kr`이고 앱 설정
(entitlements, AndroidManifest)도 그 호스트로 박혀 있다.

### 3. 중간 페이지 — `/tour/korea-map/<token>`

**앱을 자동으로 열려고 하면 안 된다.** 버튼을 하나 두고 사용자가 누르게 한다.

```
인앱 브라우저에서 이 페이지가 열린다
  · "N곳을 다녀왔어요" (sharedMap(token:)으로 채운다. 인증 불필요)
  · [앱에서 열기]  ← 사용자가 누른다
        ├─ 앱 있음  → 앱이 열린다
        └─ 앱 없음  → 스토어로
```

**왜 버튼이어야 하는가.** 카카오톡·인스타그램은 링크를 인앱 브라우저(WebView)로
여는데, OS의 링크 가로채기가 WebView 안에서는 일어나지 않는다. 사용자가 누른
이동만 가로채진다 — 자바스크립트 자동 리다이렉트는 Apple의 "click-gate" 요건상
사용자 개시 탭으로 치지 않아 막힌다.

> "Universal Links와 App Links는 1차 브라우저에서 눌리는 링크를 위해 설계됐고,
> SNS 앱이 인앱 브라우저로 쓰는 임베디드 WebView에서는 안정적으로 동작하지
> 않는다" — [Linkrunner](https://linkrunner.io/blog/universal-links-app-links-break-in-app-browsers)

| 앱 | 동작 |
|---|---|
| 카카오톡 | ❌ 인앱 브라우저([카카오 데브톡](https://devtalk.kakao.com/t/topic/136252)) |
| 인스타그램 | ❌ WKWebView. 2025년 변경으로 자동 리다이렉트도 차단 |
| X(트위터) | ⭕ `SFSafariViewController`라 대체로 동작 |

### 4. OG 태그

카카오톡 미리보기 카드. 클라이언트는 **URL만** 보내므로(안내 문구를 뺐다)
미리보기가 설명을 대신한다.

### 5. Play Console 등록 후 — `assetlinks.json` 지문 채우기

**출시 준비 단계 일이다.** 지금은 할 수 없다(출시 서명 키가 아직 없다).

```
Play Console → 앱 → 테스트 및 출시 → 설정 → 앱 서명
→ "앱 서명 키 인증서"의 SHA-256 인증서 지문
```

직접 만든 키의 지문을 넣으면 안 된다 — Play App Signing은 구글이 재서명하므로
지문이 다르다. 넣어도 오류 없이 조용히 실패한다.

## 확정된 값

| 항목 | 값 |
|---|---|
| Apple 팀 id | `55FV692492` |
| iOS 번들 id / Android applicationId | `kr.ieuri.ktripspot` (양쪽 동일) |
| 공유 링크 (주 경로) | `https://www.ieuri.co.kr/tour/korea-map/<token>` |
| 앱 스킴 (폴백) | `ktripspot://tour/korea-map/<token>` |
| App Links 도메인 | `www.ieuri.co.kr`, `ieuri.co.kr` |

**스킴은 공유에 쓰지 않는다.** 메신저가 커스텀 스킴을 링크로 인식조차 하지
않는다. 중간 페이지의 버튼이 App Links로도 열리지 않을 때를 위한 대비다.

## 클라이언트는 끝났다

- iOS `Runner.entitlements` — `applinks:www.ieuri.co.kr`, `applinks:ieuri.co.kr`
- iOS `Info.plist` — `CFBundleURLSchemes: [ktripspot]`
- Android `AndroidManifest.xml` — `autoVerify="true"` App Links 필터 +
  `ktripspot` 스킴 필터 (빌드된 APK에서 확인)
- 라우트가 서버 URL과 일치(`/tour/korea-map/:token`)
- 게이트보다 앞서 열린다 — 비회원·첫 실행도 통과

**미해결:** Android `intent://` 스킴이 인앱 브라우저에서 동작하는지는 확인하지
못했다. 중간 페이지가 있으면 필요 없을 것으로 보나, 카카오톡에서 버튼조차
막히면 그때 조사한다.
