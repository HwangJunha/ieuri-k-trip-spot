# K-Trip Spot

한국을 찾는 외국인 방문객을 위한 **위치 기반 관광 앱**입니다. 한국관광공사 데이터를 영어, 한국어, 일본어, 중국어 4개 언어로 보여 주고, 장소 탐색, 지도와 혼잡도, 지역 추천, 장소 이야기와 대화, 푸시 알림을 제공합니다.

[App Store](https://apps.apple.com/us/app/k-trip-spot/id6805503140) · [Google Play](https://play.google.com/store/apps/details?id=kr.ieuri.ktripspot)

1인 개발 프로젝트입니다. 앱(이 저장소), 서버([ieuri-server](https://github.com/HwangJunha/ieuri-server)), 인프라를 한 사람이 설계하고 출시와 운영까지 맡습니다.

## 주요 기능

| 도메인 | 기능 |
|---|---|
| `spot` | 장소를 카드로 넘기며 탐색하고, 검색, 장소 상세, 좋아요한 장소 목록 |
| `map`, `national_map` | 지도에서 장소와 혼잡도를 보고, 지역 추천을 받고, 전국 지도로 지역을 둘러보기 |
| `community`, `dm` | 장소별 이야기(글과 댓글), 회원 간 대화 |
| `spot_qa` | 장소에 대한 질문과 답변 |
| `library` | 저장한 장소 모음 |
| `alarm` | FCM 푸시와 알림 수신 설정 |
| `auth`, `settings` | 구글, 애플, 카카오 로그인, 회원 탈퇴, 언어와 알림 설정 |
| `event`, `onboarding` | 이벤트, 첫 실행 안내 |

## 기술 스택

| 영역 | 사용 기술 |
|---|---|
| 프레임워크 | Flutter (Dart 3.12), Material 3 |
| 상태 관리 | Riverpod 3 (`riverpod_annotation`, 코드 생성) |
| 라우팅 | go_router |
| 서버 통신 | GraphQL. `graphql_codegen`이 `.graphql` 오퍼레이션에서 클라이언트 코드를 생성 |
| 지도, 위치 | kakao_map_sdk, geolocator |
| 로그인 | google_sign_in, sign_in_with_apple, kakao_flutter_sdk_user. 토큰은 flutter_secure_storage |
| 푸시, 분석 | Firebase Messaging, Firebase Analytics |
| 다국어 | Flutter l10n (`lib/l10n/app_{en,ko,ja,zh}.arb`) |
| 정적 분석 | flutter_lints |

## 프로젝트 구조

화면 단위가 아니라 **도메인 단위**로 나누고, 각 도메인 안에서 역할별 폴더를 둡니다.

```
lib/
├── main.dart
├── router/              go_router 라우트, 딥링크 해석, 로그인 상태에 따른 진입 제어
├── l10n/                ARB 번역 파일과 생성물
├── common/              도메인이 함께 쓰는 것
│   ├── network/         GraphQL 클라이언트, 인증 오류 분류
│   ├── storage/         앱 설정, 작성 중인 글 임시 저장
│   ├── config/          카카오, 지도 SDK, 푸시 초기화
│   ├── location/        현재 위치
│   ├── permission/      권한 요청
│   ├── navigation/      도메인 사이를 잇는 라우트 경로
│   ├── localization/    언어 선택
│   ├── analytics/       분석 이벤트
│   ├── pagination/      페이지네이션과 목록 위젯
│   ├── theme/           색과 테마
│   ├── category/, model/, widget/, media/, log/
│   └── onboarding/
└── domain/              auth, spot, map, national_map, community, dm,
                         spot_qa, library, alarm, event, onboarding, settings
```

도메인 폴더는 모두 같은 모양입니다.

```
domain/<도메인>/
├── view/          화면
├── component/     그 도메인에서만 쓰는 위젯
├── provider/      Riverpod provider (상태와 화면 흐름)
├── repository/    서버 호출. .graphql 오퍼레이션과 서버 스키마 사본
└── model/         화면과 provider가 쓰는 모델
```

**서버 계약의 출처는 GraphQL입니다.** 직접 쓰는 `*_operations.graphql`과 서버에서 가져온 `*_schema.graphql`은 커밋하고, 거기서 만들어지는 `*.graphql.dart`, `*.g.dart`는 커밋하지 않습니다. 서버 스키마가 바뀌면 코드 생성이나 컴파일 단계에서 드러납니다.

## 시작하기

```sh
flutter pub get
dart run build_runner build --delete-conflicting-outputs   # 생성 파일. 이 단계 없이는 컴파일되지 않습니다
flutter run --dart-define-from-file=.env
```

로그인에 쓰는 클라이언트 식별자는 `.env`에 두고 `--dart-define-from-file`로 주입합니다. `.env`는 저장소에 없으므로 직접 만들어야 합니다. 값의 의미, 실기기에서 로컬 서버에 붙는 방법, 로그인이 실패할 때 확인할 순서는 [docs/local-development.md](docs/local-development.md)에 있습니다.

| 명령 | 용도 |
|---|---|
| `flutter analyze` | 정적 분석 |
| `flutter test` | 테스트 |
| `dart run build_runner build --delete-conflicting-outputs` | `@riverpod`나 `.graphql`을 고친 뒤 생성 파일 갱신 |

개발 서버와 운영 서버는 `--dart-define-from-file=.env.dev`와 `.env.prod`로 나눕니다. 번들 ID는 두 환경이 같고, flavor는 앱 이름만 가릅니다. iOS 설정 순서는 [docs/ios-flavors.md](docs/ios-flavors.md)에 있습니다.

## 문서

| 위치 | 내용 |
|---|---|
| `docs/design/` | 화면 설계 문서 (홈, 탐색, 장소 상세, 지도와 혼잡도, 지역 추천, 커뮤니티, 대화, 장소 Q&A) |
| `docs/local-development.md` | 로컬 개발 환경 설정과 문제 해결 |
| `docs/ios-flavors.md` | iOS flavor 설정 |
| `problem/` | 기능별 요구사항과 설계 결정 기록 (`SPEC-NNNN-client.md`) |
| `CLAUDE.md` | AI 코딩 에이전트와 일하는 규칙 |

## 서버

서버는 [ieuri-server](https://github.com/HwangJunha/ieuri-server)(Kotlin, Spring Boot, GraphQL)입니다. 앱의 `auth`, `community`, `alarm`이 서버의 같은 이름의 도메인과 대응하고, `spot`, `map`, `national_map`은 서버의 `tourism`과 대응합니다.
