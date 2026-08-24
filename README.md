# ieuri_k_trip_spot

A new Flutter project.

## 코드 생성 (클론 후 가장 먼저)

**생성 파일은 커밋되지 않는다**(`.gitignore` — `*.g.dart`, `*.graphql.dart`).
빌드 산출물이지 소스가 아니기 때문이다. 클론한 뒤 이걸 먼저 돌리지 않으면
**컴파일 자체가 되지 않는다.**

```sh
flutter pub get
dart run build_runner build --delete-conflicting-outputs
```

Riverpod provider(`@riverpod`)나 `.graphql` 오퍼레이션을 고쳤을 때도 다시 돌린다.
1~20초면 끝나며, 그보다 오래 걸리면 멈춘 것이다(CLAUDE.md §11.5).

손으로 쓰는 `.graphql`(오퍼레이션)과 `*_schema.graphql`(SDL)은 **커밋한다** —
생성물이 아니라 서버 계약의 출처다.

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

# 실기기에서만 필요하다 — 아래 "실기기로 로컬 서버에 붙기" 참고.
# GRAPHQL_ENDPOINT=http://192.168.0.10:8888/graphql
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

## 푸시 알림 설정 (선택 — 없으면 알림만 빠진다)

FCM 푸시(SPEC-0028)는 Firebase 설정 파일 두 개를 요구한다. `.env`와 같은 이유로
**커밋하지 않는다** — 환경마다 값이 다르다.

```
android/app/google-services.json
ios/Runner/GoogleService-Info.plist
```

Firebase 콘솔 → 프로젝트 설정 → 내 앱에서 받는다. 패키지·번들 id는
`kr.ieuri.ktripspot`이며, 다른 앱 것을 받으면 FCM이 `SENDER_ID_MISMATCH`를 낸다.

**두 파일은 비밀값이 아니다.** 앱 바이너리에 그대로 박혀 배포되는 공개 식별자라
유출 개념이 없고, 서버의 서비스 계정 키와는 성격이 다르다. 커밋하지 않는 것은
값이 환경마다 달라서다.

**없어도 빌드된다.** Gradle이 파일 존재를 검사해 있을 때만 `google-services`
플러그인을 붙이고(`android/app/build.gradle.kts`), Dart 쪽은 `Firebase.initializeApp()`
실패를 삼킨다. 그 상태의 앱은 **알림만 오지 않고 나머지는 정상 동작한다** — 사용자가
알림 권한을 거부했을 때와 같은 경로다. 알림이 안 올 때 이 파일들의 부재를 먼저
의심하면 된다.

CI에서는 빌드 전에 시크릿에서 복원한다:

```yaml
- run: |
    echo "${{ secrets.GOOGLE_SERVICES_JSON }}" | base64 -d > android/app/google-services.json
    echo "${{ secrets.GOOGLE_SERVICE_INFO_PLIST }}" | base64 -d > ios/Runner/GoogleService-Info.plist
```

시크릿 값은 로컬에서 `base64 -i <파일>`로 만든다. plist가 여러 줄 XML이라 base64를
거치지 않으면 개행이 깨진다.

### 실기기로 로컬 서버에 붙기

기본 엔드포인트는 **시뮬레이터/에뮬레이터 전용**이다(iOS는 `localhost`,
안드로이드 에뮬레이터는 `10.0.2.2`). 실기기에서는 둘 다 통하지 않는다 —
실기기의 `localhost`는 폰 자신이고 `10.0.2.2`는 아무 데도 가리키지 않는다.
증상은 `linkException: UnknownException`과 `data: null`이다.

개발 머신의 LAN IP를 `.env`에 넣는다. 폰과 **같은 Wi-Fi**여야 한다.

```sh
# 맥의 Wi-Fi IP 확인 — 아래 <MY_IP>에 이 결과를 넣는다.
ipconfig getifaddr en0
```

```sh
# .env — <MY_IP>를 위 명령의 출력으로 바꾼다. 예시를 그대로 두면 닿지 않는다.
GRAPHQL_ENDPOINT=http://<MY_IP>:8888/graphql
```

**앱이 어디로 보내는지는 APK에서 직접 확인할 수 있다.** 값이 반영됐는지
의심되면:

```sh
unzip -p build/app/outputs/flutter-apk/app-debug.apk \
  assets/flutter_assets/kernel_blob.bin | strings \
  | grep -oE "http://[0-9a-zA-Z.:_-]+/graphql" | sort -u
```

**폰에서 서버에 닿는지도 앱과 무관하게 확인할 수 있다:**

```sh
adb shell curl -s -o /dev/null -w "HTTP=%{http_code}\n" \
  -X POST http://<MY_IP>:8888/graphql \
  -H "Content-Type: application/json" -d '{"query":"{__typename}"}'
```

`HTTP=200`이면 네트워크는 정상이고 앱 설정 문제다.

닿지 않으면 순서대로 확인한다:

```sh
# 1. 서버가 루프백에만 묶여 있지 않은지 — `*:8888`이어야 한다.
#    `127.0.0.1:8888`이면 외부에서 붙을 수 없다.
lsof -nP -iTCP:8888 -sTCP:LISTEN

# 2. 그 IP:포트로 TCP가 열리는지
nc -z -v 192.168.0.10 8888
```

둘 다 정상인데 폰만 안 되면 맥의 방화벽이나 공유기의 AP 격리(클라이언트 간
통신 차단)를 본다.

### 카카오: 안드로이드 키 해시 등록

안드로이드에서 카카오 로그인이 이 오류로 실패하면:

```
[SNS] kakao 인증 실패: AuthErrorCause.misconfigured Android keyHash validation failed.
```

앱 서명의 키 해시가 카카오 개발자 콘솔에 등록되지 않은 것이다. 코드가 아니라
콘솔 설정 문제다.

등록 위치는 **앱 설정 → 앱 → 플랫폼 키 → 네이티브 앱 키 카드의 `Android 패키지`**
다(예전의 "플랫폼 → Android"가 여기로 옮겨졌다). 두 값을 넣는다:

- 패키지명: `kr.ieuri.ktripspot` (`android/app/build.gradle.kts`의 `applicationId`)
- 키 해시: 아래 명령의 출력

```sh
keytool -exportcert -alias androiddebugkey -keystore ~/.android/debug.keystore \
  -storepass android -keypass android | openssl sha1 -binary | openssl base64
```

**개발자마다 디버그 키스토어가 다르므로 각자의 해시를 등록해야 한다.** 배포용
키로 서명하면 그 키의 해시도 따로 등록한다. 실제 APK의 서명을 확인하려면:

```sh
apksigner verify --print-certs build/app/outputs/flutter-apk/app-debug.apk
```

### 안드로이드에서 애플 로그인은 제공하지 않는다

`sign_in_with_apple`은 애플 기기 밖에서 웹 흐름을 쓰는데, `webAuthenticationOptions`
(Apple Developer의 Service ID·리다이렉트 URL과 그 리다이렉트를 받아 앱으로
되돌려줄 서버 엔드포인트)가 필요하다. 그것이 없는 동안에는 안드로이드에서 애플
버튼을 노출하지 않는다 — 눌러도 예외만 나기 때문이다.

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
