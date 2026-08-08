# ieuri_k_trip_spot

A new Flutter project.

## SNS 설정 (실행 전 필수)

SNS 로그인에 쓰는 클라이언트 식별자는 `.env`에서 읽어 `--dart-define`으로
주입한다. `.env`는 커밋되지 않으므로 처음 받은 사람은 직접 만든다.

프로젝트 루트에 `.env`를 만들고 아래 세 값을 채운다:

```sh
# 구글 웹 애플리케이션 OAuth 클라이언트 ID
# Google Cloud 콘솔 → 사용자 인증 정보에서 유형이 "웹 애플리케이션"인 것.
# iOS/Android 클라이언트 ID가 아니다 — 그걸 넣으면 authorization code가 오지 않는다.
GOOGLE_SERVER_CLIENT_ID=000000000000-xxxxxxxx.apps.googleusercontent.com

# 구글 iOS OAuth 클라이언트 ID (선택). 비우면 Info.plist의 GIDClientID를 쓴다.
GOOGLE_IOS_CLIENT_ID=

# 카카오 네이티브 앱 키. Info.plist의 `kakao{키}` URL scheme과 같은 값이어야 한다.
KAKAO_NATIVE_APP_KEY=
```

여기 값들은 전부 **공개 클라이언트 식별자**이지 시크릿이 아니다. 그럼에도
커밋하지 않는 것은 환경(개발/운영)마다 다르기 때문이다. 구글 웹 클라이언트의
**시크릿은 서버만 가지며 클라이언트에 두지 않는다.**

실행할 때 `--dart-define-from-file`로 `.env`를 읽힌다(Flutter 기본 기능이라
별도 스크립트가 필요 없다):

```sh
flutter run --dart-define-from-file=.env
flutter build apk --dart-define-from-file=.env
flutter build ipa --dart-define-from-file=.env
```

IDE에서는 실행 구성의 추가 인자에 `--dart-define-from-file=.env` 한 줄을
넣어 둔다. **이 인자가 빠지면 SNS 로그인이 동작하지 않는다.**

CI에서는 `.env`가 없으므로 값을 시크릿에서 직접 넘긴다:

```yaml
- run: |
    flutter build apk \
      --dart-define=GOOGLE_SERVER_CLIENT_ID=${{ secrets.GOOGLE_SERVER_CLIENT_ID }} \
      --dart-define=KAKAO_NATIVE_APP_KEY=${{ secrets.KAKAO_NATIVE_APP_KEY }}
```

### GOOGLE_SERVER_CLIENT_ID가 왜 필요한가

이 값이 없으면 로그인은 되더라도 **authorization code가 오지 않는다**(SPEC-0012).
서버는 이 code로 refresh token을 받아 회원 탈퇴 시 구글 연동을 해제하므로,
값이 빠지면 연동 해제가 조용히 실패한다.

안드로이드는 이 값이 없으면 네이티브가 `requestOfflineAccess`를 호출하지 않아
code를 요청조차 하지 않는다. **서버가 id_token의 `aud`를 검증하고 code를
교환할 때 쓰는 클라이언트와 반드시 같은 값**이어야 한다.

code가 비었는지는 디버그 빌드 로그로 확인한다:

```
[SNS] google server auth code 없음 (serverClientId 미설정)
```

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
