# iOS flavor 설정 (dev / prod)

Android는 `build.gradle.kts` 한 곳으로 끝나지만, **iOS는 Xcode GUI로 해야 하는
부분이 있다.** 이 문서는 그 순서다. 코드로 미리 해 둔 것과 직접 하실 것을 나눠 적는다.

> **번들 ID는 두 flavor가 같다**(2026-08-25). 처음에는 dev에 `.dev` 접미사를 붙여
> 한 기기에 두 앱을 함께 깔았으나, 그러면 **스토어가 둘을 다른 앱으로 봐서** Google
> Play 비공개 테스트로 쌓은 프로덕션 자격(12명·14일)이 출시 빌드로 이어지지 않는다.
> 그래서 접미사를 걷어냈고, flavor는 이제 **앱 이름만** 가른다.
>
> 환경은 `--dart-define-from-file`이 가른다 — 번들과 서버는 원래 독립된 축이다.
> ```
> 테스트: --flavor prod --dart-define-from-file=.env.dev   (개발 서버)
> 출시  : --flavor prod --dart-define-from-file=.env.prod  (운영 서버)
> ```

## 이미 되어 있는 것

| 항목 | 위치 |
|---|---|
| Podfile에 flavor 구성 6개 등록 | `ios/Podfile` |
| Firebase 설정 복사 스크립트 | `ios/scripts/copy_google_service_info.sh` |
| `ios/config/GoogleService-Info.plist` (커밋됨 — 비밀이 아니다) | `ios/config/README.md` |

## 직접 하실 것

### 0. Firebase 설정 파일

`ieuri-d1127` 프로젝트의 iOS 앱은 `kr.ieuri.ktripspot` **하나뿐이다**(`.dev` 앱은
2026-08-25에 지웠다). 받은 `GoogleService-Info.plist`를 여기 둔다.

```
ios/config/GoogleService-Info.plist   ← 번들 id kr.ieuri.ktripspot
```

**파일을 갈아 끼울 때는 `BUNDLE_ID`를 확인한다.** 실제 번들과 다르면 Firebase가
런타임에 거부한다. 이 파일은 커밋한다(→ `ios/config/README.md`).

### 1. 빌드 구성 6개 만들기

Xcode를 연다 — **`.xcodeproj`가 아니라 `.xcworkspace`다**(CocoaPods 프로젝트).

```sh
open ios/Runner.xcworkspace
```

왼쪽 네비게이터에서 **Runner**(파란 아이콘) → **PROJECT ▸ Runner** → **Info** 탭 →
**Configurations**.

기존 `Debug`·`Profile`·`Release` 각각을 **+ → Duplicate "..." Configuration**으로
복제해 이름을 바꾼다. 총 6개가 된다.

| 원본 | 만들 것 |
|---|---|
| Debug | `Debug-dev`, `Debug-prod` |
| Profile | `Profile-dev`, `Profile-prod` |
| Release | `Release-dev`, `Release-prod` |

> **이름을 정확히 지킨다.** Flutter CLI가 `Debug-{flavor}` 형식을 문자 그대로
> 찾는다. **flavor는 소문자다** — `Debug-Dev`는 인식되지 않는다.

### 2. flavor별 번들 ID와 앱 이름

**PROJECT가 아니라 TARGETS ▸ Runner** → **Build Settings** 탭.
검색창에 `Product Bundle Identifier`를 친다. 왼쪽 삼각형을 펼치면 구성별로 값을
따로 줄 수 있다.

| 구성 | Bundle Identifier |
|---|---|
| **전부(6개 + 기본 3개)** | `kr.ieuri.ktripspot` |

**어느 구성에도 접미사를 붙이지 않는다.** 번들 ID는 스토어에서 앱의 정체성이라 한 번
올리면 바꿀 수 없고, dev에 붙이면 그 빌드가 스토어의 다른 앱이 되어 테스트로 쌓은
자격이 출시로 이어지지 않는다(위 상자).

앱 이름도 같은 방식으로 가른다. **Build Settings**에서 **+ → Add User-Defined
Setting**으로 `APP_DISPLAY_NAME`을 만들고 구성별로 채운다.

| 구성 | APP_DISPLAY_NAME |
|---|---|
| `*-dev` | `KTS Dev` |
| 나머지 | `K-Trip Spot` |

그런 다음 `ios/Runner/Info.plist`의 `CFBundleDisplayName` 값을
`$(APP_DISPLAY_NAME)`으로 바꾼다(이건 텍스트 편집이라 코드로 해도 된다 — 요청하면
반영한다).

### 3. scheme 2개 만들기

**Product ▸ Scheme ▸ New Scheme**, Target은 `Runner`, 이름은 **`dev`** 와 **`prod`**
(소문자 — `flutter run --flavor dev`가 이 이름을 그대로 찾는다).

만든 뒤 **Product ▸ Scheme ▸ Manage Schemes**에서 두 scheme의 **Shared** 체크박스를
켠다. **이걸 안 켜면 저장소에 안 들어가** 다른 사람 머신에서 flavor가 사라진다.

각 scheme을 **Edit Scheme**으로 열어 액션별 구성을 지정한다.

| 액션 | dev | prod |
|---|---|---|
| Run | `Debug-dev` | `Debug-prod` |
| Test | `Debug-dev` | `Debug-prod` |
| Profile | `Profile-dev` | `Profile-prod` |
| Analyze | `Debug-dev` | `Debug-prod` |
| Archive | `Release-dev` | `Release-prod` |

### 4. Firebase 복사 스크립트 등록

**TARGETS ▸ Runner** → **Build Phases** → **+ ▸ New Run Script Phase**.
이름을 `Copy GoogleService-Info.plist`로 바꾸고 내용에 이 한 줄을 넣는다.

```sh
"${PROJECT_DIR}/scripts/copy_google_service_info.sh"
```

**이 단계를 `Copy Bundle Resources`보다 위로 끌어 올린다.** 아래에 있으면 복사가
번들 구성 이후에 일어나 반영되지 않는다.

## 확인

```sh
flutter run --flavor dev  --dart-define-from-file=.env.dev
flutter run --flavor prod --dart-define-from-file=.env.prod
```

- 홈 화면의 이름이 **KTS Dev** / **K-Trip Spot**으로 바뀌면 성공이다
- **번들이 같으므로 서로 덮어쓴다** — 둘을 함께 두려면 접미사가 필요한데, 그것을
  포기한 이유는 위 상자에 있다
- 콘솔에 `[PushInitializer] Firebase 초기화를 건너뛴다`가 더는 뜨지 않아야 한다

## 안 될 때

| 증상 | 원인 |
|---|---|
| `Unable to find a target named Runner-dev` | scheme 이름이 소문자 `dev`가 아니다 |
| 링크 단계에서 Pods 관련 실패 | Podfile 목록에 그 구성이 없다 — 이미 6개를 넣어 뒀으니 구성 이름 오타를 본다 |
| 두 앱이 서로를 덮어씀 | **정상이다** — 번들을 일부러 통일했다(위 상자) |
| Firebase가 여전히 안 붙음 | 4번 스크립트가 `Copy Bundle Resources` 아래에 있거나, `ios/config/`에 파일이 없다 |
| Firebase가 런타임에 거부 | plist의 `BUNDLE_ID`가 실제 번들과 다르다 |
| 다른 머신에서 flavor가 없음 | scheme의 **Shared**가 꺼져 있다 |
