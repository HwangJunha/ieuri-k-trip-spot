# iOS Firebase 설정

Firebase 콘솔에서 받은 `GoogleService-Info.plist`를 여기 둔다.

```
ios/config/GoogleService-Info.plist   ← 번들 id kr.ieuri.ktripspot
```

**하나뿐이다.** 예전에는 개발 빌드의 번들이 `kr.ieuri.ktripspot.dev`라 flavor별로
`dev/`·`prod/`를 나눠 두었으나, 그 접미사를 걷어내면서(2026-08-25) 두 flavor가 같은
번들을 쓰게 되어 설정도 하나로 합쳤다. 콘솔의 `.dev` 앱도 지웠다.

접미사를 없앤 이유는 **스토어가 번들 하나를 앱 하나로 보기 때문**이다. Google Play
비공개 테스트로 프로덕션 자격(12명·14일)을 쌓으려면 그 빌드의 번들이 출시할 번들과
같아야 한다. 환경은 `--dart-define-from-file`이 가른다(→ `android/app/build.gradle.kts`).

**파일을 갈아 끼울 때는 `BUNDLE_ID`를 확인한다.** plist 안의 값이 실제 번들과 다르면
Firebase가 런타임에 거부한다.

빌드할 때 `ios/scripts/copy_google_service_info.sh`가 앱 번들로 복사한다. Android는
Gradle 플러그인이 알아서 하지만 **iOS에는 그런 규칙이 없어** 스크립트가 필요하다.

## 커밋한다

이 파일은 **추적한다**(`3fb0e81`). Google이 설정 파일을 비밀이 아니라고 명시하고 —
그 안의 `api_key`는 클라이언트에 배포되는 값이라 숨길 수 없다 — 없으면 빌드가
반쪽이 되어 새로 받는 사람이 매번 콘솔을 뒤져야 한다.

**`.env*`·`key.properties`·`*.jks`는 다르다.** 그쪽은 진짜 비밀이라 커밋하지 않는다.

설정 순서 전체는 `docs/ios-flavors.md`를 본다.
