> spec: SPEC-0028 · source: `Specs/SPEC-0028/spec.md` (Obsidian) · status: approved

# FCM 앱 푸시 알림 — 클라이언트 설계

요구사항·수용 기준·계약은 스펙에 있다. 이 문서는 이 저장소의 배선과 화면 결정만 담는다.

이슈 [#66](https://github.com/HwangJunha/ieuri-k-trip-spot/issues/66) · 브랜치 `feature/SPEC-0028-fcm-push`

## 1. 새 화면이 없다

목적지 3종이 전부 기존 라우트다. 이 기능이 만드는 화면은 **알림 설정 하나뿐**이고 그것도
설정 화면의 하위다.

| 알림 | 목적지 라우트 | 이미 있는 화면 |
|---|---|---|
| DM 새 메시지 | `/conversations/:id` | `ConversationScreen` |
| 내 질문에 답변 | `/spot/:spotId/qa/:questionId` | `SpotQuestionDetailScreen` |
| 내 답변에 답글 | 같음 | 같음 |

답글이 답변 화면이 아니라 질문 상세로 가는 이유: 답글 단독 화면이 없고 답변은 질문 상세
안에 렌더된다.

## 2. 새 feature — `lib/domain/alarm/`

기존 feature-first 구조를 따른다. `dm`이나 `spot_qa`에 넣지 않는다 — 둘 다에 걸치는
기능이라 한쪽에 넣으면 다른 쪽이 그것을 import하게 된다.

```
lib/domain/alarm/
  model/         PushDestination(페이로드에서 복원한 목적지), NotificationCategory,
                 NotificationPreference
  provider/      push_token_providers, notification_preference_providers,
                 push_permission_providers
  repository/    alarm_repository(+_impl), alarm_operations.graphql,
                 device_id_store(deviceId 보관), sent_language_store(직전 전송 언어)
  view/          notification_settings_screen
  component/     os_permission_notice(R21 안내)
```

**라우트 이름은 `lib/common/navigation/alarm_routes.dart`로 올린다.** 진입점이
`domain/settings`에 있고 화면은 `domain/alarm`이 소유하므로, `dm_routes.dart`·
`spot_qa_routes.dart`와 같은 이유로 이름만 공용으로 둔다.

**생성 타입은 repository 밖으로 내보내지 않는다**(POL-020). repository가 도메인 모델로
매핑한다.

## 3. 배선 — 어느 파일에 무엇이 붙는가

### 3.1 `lib/main.dart` — Firebase 초기화

`SnsInitializer.ensureInitialized()` · `MapSdkInitializer.ensureInitialized()` 옆에 붙는다.
지도 SDK가 "키가 없으면 조용히 건너뛰고 앱 기동은 막지 않는다"는 기존 판단을 그대로
따른다 — **Firebase 초기화 실패가 앱 기동을 막으면 안 된다.**

`SharedPreferences`·`MapSdkInitializer`가 이미 `.wait`로 병렬 대기하므로 그 자리에 함께
넣는다.

### 3.2 `lib/domain/auth/provider/auth_controller.dart` — 등록 시점

`AuthState.isAuthenticated` 전이를 듣는다. **`auth_controller` 자체를 고치지 않고**
`alarm`이 그것을 `ref.listen`으로 구독하는 방향이 낫다 — auth가 alarm을 알 이유가 없다.

로그아웃도 같은 전이에서 잡는다. 다만 **토큰 해제는 세션이 사라지기 전에** 보내야 한다 —
`deleteDeviceToken`이 인증을 요구하므로 순서가 뒤집히면 실패한다. 로그아웃 처리 안에서
해제를 먼저 부르고 그다음 세션을 지우는 순서가 필요하다.

### 3.3 `lib/router/app_router.dart` — cold start 딥링크 (R17)

**새 게이트를 만들지 않는다.** 파일 주석이 "게이트가 둘이면 서로를 되돌리며 무한히
튕긴다"고 이미 경고한다.

`PendingDestination`을 재사용한다. 그 클래스는 약관 게이트에서 "원래 가려던 곳"을
보관했다가 게이트가 풀리면 복귀시키는 일을 이미 하고 있고(SPEC-0011 R12), 푸시 목적지도
정확히 같은 문제다.

- 종료 상태에서 푸시로 열리면 목적지를 `PendingDestination.remember()`에 넣는다
- `AuthGateState.ready`가 되는 순간 `take()`로 꺼내 이동한다
- `take()`가 값을 비우므로 재소비가 자동으로 막힌다(AC17.4)
- 미인증으로 판정되면 `destinationAfterGate`가 이미 기본 착지점을 돌려주므로 목적지가
  자연히 버려진다(AC17.3)

`PendingDestination`이 provider가 아니라 평범한 클래스인 이유(리다이렉트가 빌드 중에
도므로 provider state를 쓰면 Riverpod이 던진다)가 푸시에도 그대로 적용된다. 그 구조를
바꾸지 않는다.

#### 슬롯이 하나라는 문제

`PendingDestination`은 `String? _location` **한 칸**이고, 지금 그 칸에 쓰는 주체는 약관
게이트 하나뿐이다. 푸시가 두 번째 주체가 되면 둘이 같은 칸을 다툰다.

실제로 겹치는 경우가 있다 — **필수 약관에 미동의한 사용자가 푸시로 앱을 여는 경우**다.
푸시 목적지를 넣어 둔 칸을 약관 게이트가 덮어쓰거나 그 반대가 되면, 사용자는 엉뚱한
곳에 착지하거나 아무 데도 가지 못한다.

**푸시 목적지가 이긴다.** 약관 게이트가 보관하는 값은 "게이트에 막히지 않았다면 갔을 곳"
인데, 푸시로 열린 경우 그곳이 바로 푸시 목적지다. 둘은 경쟁하는 두 목적지가 아니라 **같은
하나**다.

그래서 순서를 이렇게 둔다.

1. 푸시로 열렸으면 목적지를 **가장 먼저** `remember()`에 넣는다 — 게이트가 돌기 전이다
2. 약관 게이트가 막을 때는 이미 값이 있으면 **덮어쓰지 않는다**. 현재 코드가 무조건
   `remember(location)`을 부르는 자리에 조건이 하나 붙는다
3. 게이트가 전부 풀리면 `take()`가 그 값을 꺼내 소비한다. 한 번 꺼내면 비므로 재소비가
   막힌다(AC17.4)

`PendingDestination`에 "이미 값이 있으면 유지한다"는 동작을 더하는 것이 이 스펙이 그
클래스에 가하는 유일한 변경이다. 슬롯을 둘로 늘리지 않는다 — 목적지는 언제나 하나다.

**`take()`를 부르는 자리는 그대로 두지 않는다.** 현재는 약관 화면에서 나갈 때
(`location == requiredTermsPath && target == discoverPath`)만 꺼내는데, 푸시는 약관 화면을
거치지 않고 인증만 끝나면 되는 경우가 대부분이다. 게이트가 통과시키는 시점
(`resolveGate`가 null을 돌려주고 인증이 `ready`)에도 보관된 값이 있으면 꺼내도록 조건을
넓힌다.

### 3.4 `lib/domain/settings/view/settings_screen.dart` — 설정 진입점

「메시지」·「차단한 사용자」·「검색 반경」·「언어」가 있는 목록에 「알림」 항목을 추가하고
`alarm`의 설정 화면을 `pushNamed`한다. 기존 항목들과 같은 방식이다.

**이 파일이 이 기능이 건드리는 유일한 남의 화면이다.**

## 4. 페이로드 → 라우트 (R11 · R16)

```
type=DM              → conversationId       → /conversations/:id
type=SPOT_QA_ANSWER  → spotId, questionId   → /spot/:spotId/qa/:questionId
type=SPOT_QA_REPLY   → spotId, questionId   → 같음
```

질문 상세는 `spotId`와 `questionId`가 **둘 다** 경로 파라미터다. 하나만 오면 라우트를
만들 수 없으므로 그때는 기본 착지점으로 보낸다(AC16.4).

**복원은 순수 함수로 둔다.** `PushDestination.tryParse(Map<String, String>)`가 페이로드
맵을 받아 목적지 또는 null을 돌려주는 형태다. `route_gate.dart`가 게이트 판정을 순수
함수로 떼어 놓은 것과 같은 이유 — 딥링크가 틀리면 알림이 통째로 엉뚱한 데로 가는데,
그것을 위젯 테스트로 확인하는 것은 느리고 불안정하다.

알 수 없는 `type`은 오류가 아니라 null이다. 서버가 나중에 트리거를 더해도 구버전 앱이
죽지 않아야 한다.

## 5. 앱 상태 3가지 (R15 · R16)

| 상태 | 처리 |
|---|---|
| 포그라운드 | **아무것도 하지 않는다.** 배너를 띄우지 않고 화면도 바꾸지 않는다(AC15.2) |
| 백그라운드 | 시스템이 알림을 표시. 탭하면 앱이 깨어나고 목적지로 이동 |
| 종료 | 시스템이 알림을 표시. 탭하면 앱이 기동하고 §3.3의 경로를 탄다 |

포그라운드에서 배너를 안 띄우는 근거는 홈 배지다 — DM은 `Subscription.newMessage`가 이미
화면을 갱신하고, 답변은 홈 상단 배지가 도착을 알린다(SPEC-0026). 배너까지 띄우면 방금
본 것을 다시 알리는 꼴이다.

iOS는 앱이 떠 있으면 시스템이 배너를 자동으로 띄우지 않으므로 **아무것도 안 하면 된다.**
Android는 반대라 포그라운드 메시지를 가로채 표시하지 않도록 해야 한다. 결과가 양쪽에서
같아야 한다.

## 6. Android 알림 채널 2개

Android 8+는 채널 없이 보낸 알림을 표시하지 않으므로 필수다.

| 채널 | 담는 알림 |
|---|---|
| 메시지 | DM |
| 질문·답변 | 답변 · 답글 |

나누는 이유: DM은 상대가 보내는 만큼 오고 Q&A는 가끔 온다. 성가심의 정도가 달라, 하나로
묶으면 DM이 시끄러워 끄고 싶은 사람이 답변 알림까지 잃는다.

**채널은 앱 토글을 대체하지 않는다.** 채널은 Android에만 있고 OS가 소유해 앱이 프로그램으로
켜고 끌 수 없다. iOS 사용자에게는 앱 토글이 유일한 수단이다.

## 7. OS 설정과 앱 설정 (R21)

두 스위치가 직렬로 걸린다.

| 스위치 | 소유 | 막는 것 |
|---|---|---|
| 앱 토글(서버 저장) | 회원 | 발송 |
| OS 권한·채널 | 기기 OS | 표시 |

앱 토글이 켜져 있는데 OS가 꺼져 있으면 알림이 오지 않고, 사용자는 이것을 **고장으로
오해한다.** 그래서 설정 화면이 OS 상태를 읽어 꺼져 있으면 안내를 띄우고 OS 설정으로
보낸다.

**앱이 채널을 켤 수는 없다.** 구글이 막아 둔 동작이라(앱이 사용자가 끈 알림을 몰래 되켜는
것 방지) 안내와 이동이 할 수 있는 전부다.

OS 상태는 **서버에 보내지 않는다.** 기기 사실이지 회원 속성이 아니라 서버가 가질 값이
아니다 — 계약에도 해당 필드가 없다.

## 8. 기기 식별자와 언어 갱신 (R20)

- `deviceId`는 앱이 만들어 보관한다. 최초 1회 생성 후 `flutter_secure_storage`가 아니라
  일반 저장소면 충분하다 — 비밀값이 아니라 식별자다. `seen_answer_counts_store.dart`가
  같은 판단으로 `SharedPreferences`를 쓰고 있다
- **직전에 보낸 언어를 저장한다.** 포그라운드 복귀마다 무조건 재등록하면 불필요한 왕복이
  생기므로, 기기 언어가 저장값과 다를 때만 보낸다
- 재등록은 같은 `registerDeviceToken`을 다시 부르는 것이다. 갱신 전용 연산이 없다

앱 언어 설정(`AppPreferences.savedLanguage`)이 아니라 **기기 OS 언어**를 보낸다 — 알림은
앱 밖에서 표시되므로 사용자가 그 순간 읽는 언어는 OS 언어다.

## 9. 실패는 조용히 (R14 · AC12.3)

- 권한 거부 → 등록을 시도하지 않고 화면도 막지 않는다. **재요청 다이얼로그를 띄우지
  않는다**(AC14.2)
- 등록 실패 → 사용자에게 아무것도 보여주지 않고 로그만 남긴다
- 재시도는 다음 기동 시점이다. 즉시 재시도 루프를 만들지 않는다(POL-040 — 시간이 아니라
  횟수, 그리고 여기서는 아예 두지 않는다)

알림을 못 받는 것은 앱을 막을 이유가 되지 않는다.

## 10. 테스트

provider/notifier와 도메인 모델 로직만이다. 위젯·통합 테스트는 범위 밖이다
(CLAUDE.md 테스트 범위표).

| 단위 | 검증 대상 |
|---|---|
| `PushDestination.tryParse` | R11 · R16 — 3종 페이로드 복원, 식별자 누락, 알 수 없는 type |
| `resolveGate` (기존, 순수 함수) | R17 — 인증 상태별 목적지 처리. 이미 값 입력으로 검증 가능한 구조다 |
| 토큰 등록 notifier | R1 · R20 — 인증 전이 시 등록, 언어가 바뀔 때만 재등록 |
| 알림 설정 notifier | R19 — 토글, 응답으로 상태 갱신 |
| 권한 상태 provider | R14 · R21 — 거부 시 등록 미시도, 안내 표시 판정 |

FCM 플러그인·OS 권한 다이얼로그·실제 알림 표시는 인프라라 검증하지 않는다. 포그라운드에서
배너가 실제로 안 뜨는지(R15)는 OS 동작이라 단위 테스트로 확인할 수 없으며, 그 사실을
여기 남기고 테스트를 만들지 않는다.

## 10.1 구현 기록 (2026-08-19)

이 절은 구현하며 내린 결정과 **확인하지 못한 것**을 남긴다.

### 확인하지 못한 것

- **서버 계약을 라이브로 검증하지 못했다.** 작업 내내 `localhost:8888`이 응답하지
  않아(§13의 sweep이 `http_code=000`) `registerDeviceToken`·`deleteDeviceToken`·
  `updateNotificationPreference`·`me.notificationPreferences` 네 연산이 실제 서버에
  존재하는지, 인자 이름이 맞는지 **확인되지 않았다.** codegen이 통과한 것은 커밋된
  SDL 조각(`alarm_schema.graphql`)에 대한 검증일 뿐이며, 그 조각은 계약 초안을 보고
  손으로 쓴 것이다(§13의 경고 그대로다). 서버가 뜨면 sweep을 먼저 돌려야 한다.
- 스펙의 전달 순서상 S1(서버 토큰 계약)이 먼저인데, 그것이 실제로 배포됐는지도
  같은 이유로 확인하지 못했다.
- 포그라운드에서 배너가 실제로 안 뜨는지(R15)는 OS 동작이라 단위 테스트로 확인할 수
  없다(§10에 이미 적힌 대로 테스트를 만들지 않았다).

### 계약과 다르게 쓴 곳

- **`BaseResponse`를 쓰지 않았다.** 계약은 payload에 `implements BaseResponse`를
  달았으나 클라이언트 SDL 조각 어디에도 그 인터페이스가 없다. 인터페이스는 응답
  형태를 바꾸지 않고 이 앱은 `success`·`userErrors`를 직접 고르므로, 다른 payload와
  같이 평범한 타입으로 뒀다.
- **`Locale` enum을 alarm 조각에서 선언했다.** 서버는 tourism 스키마에 이미 갖고
  있지만 클라이언트 조각 중에는 선언한 곳이 없었다 — 지금까지 언어는
  `Accept-Language` 헤더로만 갔고 GraphQL 인자로 보낸 적이 없다. 다른 기능이 쓰게
  되면 `common/network/shared_schema.graphql`로 올린다.

### 설계와 다르게 구현한 곳

- **`push_token_store` 대신 지문(digest)만 저장한다.** 설계 §8은 "직전에 보낸 언어를
  저장한다"고 했으나, 등록값을 그대로 적으면 FCM 토큰이 일반 저장소에 남는다
  (`block-insecure-storage` 훅이 이것을 막는다). 필요한 것은 "달라졌는가" 하나뿐이라
  등록값 전체를 되돌릴 수 없는 지문으로 접어 한 칸에 적는다. 언어·토큰·deviceId 중
  무엇이 바뀌어도 같은 한 가지 동작(재등록)을 하므로 어느 필드가 바뀌었는지는 알
  필요가 없다.
- **로그아웃 해제는 `SessionTeardown` 콜백으로 건다.** 설계 §3.2는 "로그아웃 처리 안에서
  해제를 먼저 부르고 그다음 세션을 지운다"고 했는데, 그러려면 `auth`가 `alarm`을
  불러야 해서 기능 간 의존이 된다. `TokenRefreshBridge`가 네트워크↔auth 순환을 끊은
  방식 그대로, alarm이 자기 정리 작업을 공용 `SessionTeardown`에 등록하고 `signOut`은
  "등록된 것을 부른다"만 안다. 순서 요구(세션 삭제 **전**)는 그대로 지킨다.
- **푸시 목적지 소비 조건이 `target == null`보다 좁다.** 설계 §3.3은 "게이트가
  통과시키는 시점(`resolveGate`가 null을 돌려주고 인증이 `ready`)"이라고 했고, 그
  두 조건이 **둘 다** 필요하다는 것이 구현에서 확인됐다. `target == null`만 보면
  ① 스플래시(판정 전 무조건 null)에서 꺼내 AC17.1을 어기고, ② 미인증 상태의 로그인
  화면(`authPaths`라 null)에서 꺼내 로그인하던 사용자를 끌어낸다. 그래서
  `auth == ready && location != splashPath`를 함께 본다
  (`test/router/pending_destination_test.dart`가 두 경우를 고정한다).
- **`PendingDestination`을 `common/navigation/`으로 옮겼다.** 설계 §3.3은 그 클래스를
  `app_router.dart`에 둔 채로 동작만 더하라고 했으나, 푸시 목적지를 넣는 주체가
  `domain/alarm`의 component라 라우터 내부를 import하게 된다(계층 역방향). 보관
  자체는 경로 상수를 몰라도 되므로 `common/navigation/pending_destination.dart`로
  올리고, 진입 전 화면을 기본 착지점으로 바꾸는 판정(`destinationAfterGate`)만
  라우터에 남겼다. 슬롯이 하나라는 성질은 그대로다.
- **알림 탭 스트림에 provider를 한 겹 뒀다.** component가
  `pushMessagingServiceProvider`(repository 계층 인터페이스)를 직접 읽으면 계층을
  건너뛴다 — 이 저장소의 다른 어떤 view/component도 그러지 않는다.
  `push_deep_link_providers.dart`가 탭 스트림과 cold start 목적지만 노출한다.
- **OS 권한 안내에 `PermissionBlockedNotice`를 쓰지 않았다.** 그 위젯은 영구거부·
  restricted(`needsSettings`)일 때만 그리는데, R21은 **단순 거부도** 알려야 한다 —
  최초 시퀀스에서 "허용 안 함"을 한 번 누른 상태가 정확히 그것이고 그때도 알림은
  오지 않는다. `OsPermissionNotice`가 `granted`가 아닌 모든 상태를 다룬다.

### Firebase가 아직 없어서 생긴 구조

`google-services.json`·`GoogleService-Info.plist`가 저장소에 없고(§11), 그 상태에서
`firebase_messaging`을 추가하면 Android 빌드가 Gradle 단계에서 깨진다 — 지도 SDK 키처럼
조용히 건너뛰어지지 않는다. 그래서 **플러그인 의존을 아직 추가하지 않고**
`PushMessagingService` 포트만 뒀다.

- 현재 구현체는 `UnavailablePushMessagingService`로, 토큰을 돌려주지 않아 등록이
  일어나지 않는다. 그 상태는 사용자가 권한을 거부했을 때와 **같은 경로**를 탄다(R14) —
  앱은 알림 없이 정상 동작한다
- 설정 파일과 `firebase_core`·`firebase_messaging`이 들어오면 바뀌는 곳은 셋뿐이다:
  `PushInitializer.ensureInitialized()`, `pushMessagingServiceProvider`가 돌려주는
  구현체, 그리고 `PushInitializer.isReady`
- 그 구현체가 채워야 할 계약은 `push_messaging_service.dart`의 인터페이스에 적혀
  있다(채널 2개 생성·포그라운드 억제·탭 스트림·cold start 목적지)
- **아직 하지 않은 것:** Android 채널 2개의 실제 생성, 포그라운드 억제의 실제 배선,
  `Runner.entitlements`의 `aps-environment` 키 추가. 전부 플러그인이 있어야 의미가
  있어 함께 미뤘다

## 11. 플랫폼 설정 파일

코드가 아니라 빌드 설정이고, Firebase 콘솔 작업의 결과물이다.

| 파일 | 상태 |
|---|---|
| `android/app/google-services.json` | 없음 — 추가 필요 |
| `ios/Runner/GoogleService-Info.plist` | 없음 — 추가 필요 |
| `ios/Runner/Runner.entitlements` | 있음. `aps-environment` 키가 없어 **추가 필요** |

현재 `Runner.entitlements`에는 `com.apple.developer.applesignin`만 있다.

APNs `.p8` 키는 Firebase 콘솔에 업로드하는 것이고 **이 저장소에 넣지 않는다.** 앱은 FCM
토큰만 다루며 APNs를 직접 알지 않는다.

이 파일들은 자격증명을 담으므로 커밋 여부를 서버 자격증명과 같은 기준으로 판단한다.
