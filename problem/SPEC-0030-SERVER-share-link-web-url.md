# SPEC-0030 — 공유 링크를 `https://` 웹 URL로 바꿔 주세요

- 대상: `createMapShareLink`가 주는 `MapShareLink.shareUrl`
- 확인 환경: 실기기(Android, 카카오톡 공유) 2026-08-22
- 상태: **부분 해소(2026-08-22)** — 서버가 이미 `https://` 링크를 준다. 남은 것은 검증 파일 배치다.

## 지금 무슨 일이 일어나는가

서버가 주는 `ieuri://shared/<token>`을 그대로 공유하면 **카카오톡이 링크로 인식조차
하지 않는다.** 파란 링크가 아니라 검은 텍스트로 나가서 받는 사람이 누를 수가 없다.

앱이 깔려 있어도 마찬가지다 — 메신저가 텍스트에서 링크를 찾을 때 `http`/`https`만
보기 때문이다. **클라이언트 코드로는 고칠 수 없다.**

## 근거

Android 공식 문서(App Links)가 정리한 차이다.

| | 커스텀 스킴(`ieuri://`) | App Links(`https://`) |
|---|---|---|
| 메신저에서 | 링크로 인식 안 됨 | 링크로 인식 |
| 앱 설치 시 | (누를 수 있으면) 열림 | **브라우저를 거치지 않고 앱이 바로 열림** |
| 앱 미설치 시 | 실패, 대안 없음 | 웹으로 폴백 |
| 권장 | "내부 이동·비웹 URI용" | **"공유에는 App Links를 쓰라"** |

Firebase Dynamic Links는 대안이 될 수 없다 — **2025년 8월 25일 종료**됐고 기존
링크도 404를 반환한다. Flutter 3.24부터 discontinued이며 공식 권장이 App Links다.

## 해소된 것

서버가 이미 웹 URL을 준다(2026-08-22 확인).

```
https://www.ieuri.co.kr/tour/korea-map/7EDr_f2JlFcVev2PcQqZm1-t5pVUOe1A
```

`sharedMap(token:)` 조회도 정상이다 — 닉네임·방문 칸 17개를 받았다.

클라이언트도 맞췄다.

- 라우트를 `/tour/korea-map/:token`으로 바꿨다. 예전 `/shared/:token`으로 두면
  링크를 눌러 앱이 열려도 **매칭되지 않는다**
- iOS `Runner.entitlements`에 `applinks:www.ieuri.co.kr`을 넣었다
- Flutter 3.44라 `Info.plist`의 `FlutterDeepLinkingEnabled`는 필요 없다
  (3.27+ 기본 활성, 딥링크 플러그인도 쓰지 않는다)

## 남은 요청

- 그 도메인에 **`assetlinks.json`**(Android)과 **`apple-app-site-association`**(iOS)
  배치 — 이게 있어야 앱이 깔린 기기에서 브라우저를 거치지 않는다
- 미설치자가 열었을 때 보여줄 **웹 페이지** — 최소한 스토어로 안내해야 한다
- 링크 미리보기(OG 태그)가 있으면 좋다. 클라이언트는 이제 **URL만** 보내므로
  (안내 문구를 뺐다) 미리보기가 설명을 대신한다

## 클라이언트는 준비돼 있다

`shareUrl`을 **조립하지 않고 그대로** 공유 시트에 넘기고, 링크를 열 때는 경로의
마지막 조각만 꺼내 `sharedMap(token:)`에 넣는다. 스킴이 바뀌어도 이 코드는 그대로다.

다만 **수신 설정은 아직 없다.** 도메인이 정해지면 클라이언트가 넣어야 한다.

- iOS: Associated Domains에 `applinks:<도메인>`
- Android: `intent-filter` + `android:autoVerify="true"`

> 참고로 지금은 `ieuri://` 스킴조차 등록돼 있지 않다(iOS `CFBundleURLTypes`에는
> 구글·카카오만, Android에는 카카오 로그인 intent-filter만 있다). 그래서 현재
> 공유 링크는 **앱이 설치돼 있어도 열리지 않는다.** 어차피 `https://`로 갈 것이라
> 커스텀 스킴 등록은 하지 않고 이 문서로 남긴다.
