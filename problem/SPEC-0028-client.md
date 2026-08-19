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

## 5. 앱 상태 3가지 (R15 개정 · R16)

> **R15를 뒤집었다 — 사용자 결정(2026-08-19, 실기기 확인 중).**
> 원안은 포그라운드에서 배너를 띄우지 않는 것이었고 근거는 홈 배지였다(DM은
> `Subscription.newMessage`가 화면을 갱신하고, 답변은 홈 상단 배지가 알린다 —
> SPEC-0026). **실기기에서 확인해 보니 그것만으로는 알림을 놓치기 쉬웠다.**
> 배지는 해당 화면을 봐야 눈에 들어오는데, 사용자가 다른 탭에 있으면 아무 신호도
> 받지 못한다. 그래서 카테고리 구분 없이 **전부 띄우는 쪽**으로 바꿨다.

| 상태 | 처리 |
|---|---|
| 포그라운드 | **알림을 띄운다.** 종류를 가리지 않고 DM·질문·답변 모두 표시한다 |
| 백그라운드 | 시스템이 알림을 표시. 탭하면 앱이 깨어나고 목적지로 이동 |
| 종료 | 시스템이 알림을 표시. 탭하면 앱이 기동하고 §3.3의 경로를 탄다 |

**세 경우 모두 탭하면 같은 곳으로 간다.** 포그라운드 알림은 앱이 직접 띄운 것이라
탭도 직접 받아야 하는데(FCM의 `onMessageOpenedApp`은 백그라운드에서 깨어난 경우만
흘린다), 사용자에게는 같은 동작이므로 목적지 스트림 하나로 합친다.

플랫폼별로 하는 일이 다르지만 **결과는 같아야 한다.**

- **iOS**: 앱이 떠 있으면 시스템이 배너를 자동으로 띄우지 않는 것이 기본이라,
  `setForegroundNotificationPresentationOptions`를 켜 준다. 그러면 시스템이 띄운다
- **Android**: 포그라운드 메시지가 시스템 트레이로 가지 않으므로 `onMessage`를 구독해
  `flutter_local_notifications`로 직접 띄운다. 채널은 `type`으로 고른다(§6)

iOS에서 `onMessage` 구독까지 하면 시스템 배너와 로컬 알림이 **둘 다** 떠서 두 번
보이므로, 직접 띄우는 경로는 Android로 한정한다.

같은 대화의 알림이 쌓이지 않도록 알림 id를 목적지(`conversationId`/`questionId`)로
접는다 — 새 메시지가 오면 같은 자리를 덮어쓴다.

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
알림이 실제로 뜨는지(R15 개정)는 OS 동작이라 단위 테스트로 확인할 수 없으며, 그 사실을
여기 남기고 테스트를 만들지 않는다 — 실기기 확인이 유일한 수단이다.

## 10.1 구현 기록 (2026-08-19)

이 절은 구현하며 내린 결정과 **확인하지 못한 것**을 남긴다.

### 서버 계약 — 검증 완료(2026-08-19, 2차)

서버 S1·S3가 배포되어(ieuri-server#95) 라이브로 확인했다.

- **§13 sweep 통과** — 모든 오퍼레이션 문서에 validation error 없음
- **뮤테이션 3종 + `me.notificationPreferences`를 리터럴 인자로 직접 발사** → 전부
  `UNAUTHENTICATED`. 인증만 걸렸다는 뜻이므로 **입력 형태가 통과했다.** sweep이 못
  잡는 "새로 생긴 필수 필드"도 이 방법으로 없음을 확인했다(§13의 SPEC-0026 선례)
- **introspection으로 대조** — `Locale`(EN·KO·JA·ZH), `DevicePlatform`(IOS·ANDROID),
  `RegisterDeviceTokenInput`의 네 필드(`deviceId`·`fcmToken`·`language`·`platform`,
  전부 NON_NULL)가 `alarm_schema.graphql`과 정확히 일치

`problem/SPEC-0028-SERVER-device-token-contract.md`의 상태를 해소됨으로 바꿨다.

## 10.2 실기기 검증 결과 (2026-08-20)

Android(갤럭시 S931N, Android 16)와 iOS(iPad Air 5, iOS 16.6) 실기기에서 확인했다.

| 항목 | Android | iOS |
|---|---|---|
| Firebase 초기화 | 확인 | 확인 |
| FCM 토큰 발급 → `registerDeviceToken` | 확인(`success: true`) | 확인(`success: true`) |
| 언어 매핑(`KO`)·플랫폼 값 | 확인 | 확인(`IOS`) |
| 토큰 로그 마스킹(POL-013) | 확인(`***`) | 확인(`***`) |
| 알림 채널 2개 | 확인(HIGH/DEFAULT) | 해당 없음 |
| 백그라운드·종료 알림 수신 | 확인 | 확인 |
| **포그라운드 알림 표시** | 확인 | **실패 — 아래 참조** |
| 딥링크(탭 → 목적지) | 미확인 | 미확인 |
| 설정 화면 토글 | 미확인 | 미확인 |

### iOS 포그라운드 알림 — 해결하지 못했다

**증상.** 앱이 떠 있는 동안 도착한 알림이 표시되지 않는다. 백그라운드·종료 상태에서는
정상이다. Android는 같은 코드로 표시된다.

**확인된 사실.** 실기기 로그로 아래까지는 정상임을 확인했다.

- 실제 구현체가 선택된다(`service=FcmMessagingService`)
- `setForegroundNotificationPresentationOptions`가 적용된다
- `FirebaseMessaging.onMessage` 구독이 완료된다
- 그런데 **알림이 도착해도 `onMessage`가 발화하지 않는다** — 구독 콜백에 진단 로그를
  넣고 Firebase 콘솔에서 발송했으나 아무것도 찍히지 않았다

**시도했고 전부 실패한 것 셋.**

1. iOS 시스템 표시 옵션을 켜기(`alert: true`) — 변화 없음
2. Android처럼 앱이 직접 `flutter_local_notifications`로 띄우기 — `onMessage`가 오지
   않으므로 애초에 실행되지 않음
3. `AppDelegate`에 `UNUserNotificationCenter.current().delegate = self` 지정 —
   변화 없음

**원인 추정과 그 한계.** 검색으로 찾은 근거는 flutterfire#1644("Dart side callbacks for
FCM are not called on iOS if a message has a notification field")이며, `notification`
필드가 실린 메시지는 iOS에서 APNs가 직접 처리해 `onMessage`를 우회한다는 내용이다.
Firebase 문서도 포그라운드 전달이 `userNotificationCenter(_:willPresent:)`를 거친다고
적고 있다.

**다만 이 설명은 실기기에서 확정되지 않았다.** 3번(delegate 지정)이 그 가설에 따른
수정이었는데 그래도 오지 않았기 때문이다. 즉 "서버가 data-only로 보내면 해결된다"는
것도 아직 검증된 결론이 아니다.

**그래서 이 기능은 되돌렸다.** 포그라운드 표시 관련 변경(`enableForegroundNotifications`의
iOS 경로, `AppDelegate`의 delegate 지정)은 전부 커밋 `37da556` 상태로 복구했고, 현재
동작은 다음과 같다.

- Android: 포그라운드에서도 앱이 직접 표시한다(R15 개정 그대로)
- iOS: 포그라운드에서 표시하지 않는다(원안 R15와 같은 결과)

**다음에 이어서 할 때의 순서.** 코드를 먼저 고치지 말고 아래를 확정한 뒤에 손댄다.

1. 서버가 실제로 내보내는 APNs 페이로드를 확인한다(`aps` 안에 `alert`·
   `content-available`가 어떻게 들어가는지)
2. `userNotificationCenter(_:willPresent:)`가 불리는지를 Swift 쪽 로그로 확인한다 —
   이것이 불리지 않으면 Dart 쪽은 어떻게 고쳐도 소용이 없다
3. 그 두 가지가 확정된 뒤에 클라이언트/서버 어느 쪽을 고칠지 정한다

### 여전히 확인하지 못한 것

- **딥링크가 실제 알림 탭으로 도는지** 양쪽 모두 미확인이다. 순수 함수
  (`PushDestination.tryParse`)와 게이트 판정은 단위 테스트로 고정했으나, 실제 탭 →
  목적지 이동은 확인하지 못했다
- **설정 화면 토글**(R19)도 실기기에서 열어 보지 않았다
- iOS 포그라운드는 위 §10.2 참조

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

### Firebase 설정 파일이 없어도 빌드된다 — 조건부 적용

`google-services.json`·`GoogleService-Info.plist`는 **환경마다 값이 달라 커밋하지
않는다**(.gitignore 317~320줄, "keep local only"). SNS 클라이언트 id를 `.env`로 빼둔
것과 같은 취급이다. 그래서 **파일이 없는 상태가 정상적으로 일어난다.**

문제는 Gradle의 `google-services` 플러그인이 파일을 못 찾으면 **Android 빌드를 통째로
실패시킨다**는 것이다. 지도 SDK 키처럼 조용히 넘어가지 않는다. 이 기능의 원칙이
"알림을 못 받는 것이 앱을 막을 이유가 되지 않는다"(설계 §9 · R14)인데 빌드 차단은
그보다 훨씬 강한 차단이라, **파일이 있을 때만 플러그인을 붙인다.**

- `android/settings.gradle.kts`는 버전만 선언한다(`apply false`)
- `android/app/build.gradle.kts`가 `file("google-services.json").exists()`로 검사해
  있을 때만 `apply(plugin=)` 한다. 없으면 안내 한 줄을 찍고 넘어간다
- Dart 쪽은 `PushInitializer`가 `Firebase.initializeApp()` 실패를 삼키고 `isReady`를
  거짓으로 둔다. 그러면 `pushMessagingServiceProvider`가
  `UnavailablePushMessagingService`를 골라 토큰을 발급하지 않고, 앱은 사용자가 알림
  권한을 거부했을 때와 **같은 경로**를 탄다

**양쪽 다 실제로 확인했다.** 파일 없이 `flutter build apk --debug` 성공, 더미 파일을
넣으면 `processDebugGoogleServices`가 돌아 `google_app_id`가 병합 리소스에 주입되는
것까지 확인한 뒤 더미를 지웠다.

CI에서는 빌드 전에 시크릿에서 복원하면 그대로 붙는다(`.env`와 같은 방식):

```sh
echo "$GOOGLE_SERVICES_JSON" | base64 -d > android/app/google-services.json
echo "$GOOGLE_SERVICE_INFO_PLIST" | base64 -d > ios/Runner/GoogleService-Info.plist
```

현재 이 저장소에는 CI가 없어(`.github/` 부재) 로컬 빌드가 곧 배포 빌드다.

### 서버 안내 문서(2026-08-19) 반영

- **기동 시 등록은 `force: true`다.** 서버가 FCM `UNREGISTERED` 응답을 보고 토큰 행을
  **조용히 지울 수 있는데** 클라이언트는 알 방법이 없다(안내 §5-8). 지문만 믿으면
  "안 바뀌었으니 건너뛴다"가 영원히 반복되어 그 계정은 알림을 영영 못 받는다. 기동당
  왕복 한 번이 그 위험보다 싸다. 포그라운드 복귀는 훨씬 잦아 지문을 그대로 쓴다
- **`onTokenRefresh`를 구독한다**(안내 §2의 재등록 시점). 새 토큰이 오면 지문이 달라져
  재등록이 실제로 나간다
- **알림 채널은 클라이언트가 만든다** — 서버가 채널을 지정하지 않는다(안내 §1).
  메시지(high)와 질문·답변(default) 둘이며, `pushNotificationSetup`이 기동 시 한 번
  만든다. 인증과 무관하다
- **`deleteDeviceToken`의 `success: true`는 삭제를 뜻하지 않는다**(안내 §3 — 없었거나
  남의 기기여도 참이다). 해제 경로가 이미 응답을 믿지 않고 지문을 무조건 지우므로
  동작은 그대로다
- **세 뮤테이션이 이메일 인증 게이트에 걸린다**(안내 §7). 등록은 `emailVerified &&
  onboardingCompleted` 이후에만 시도하며, `me`와 한 문서로 묶지 않는다(배치 금지)

## 11. 플랫폼 설정 파일

코드가 아니라 빌드 설정이고, Firebase 콘솔 작업의 결과물이다.

| 파일 | 상태 |
|---|---|
| `android/app/google-services.json` | **커밋하지 않는다**(.gitignore 318). 각 빌드 머신에 두거나 CI 시크릿에서 복원. 없으면 FCM만 빠지고 빌드는 된다 |
| `ios/Runner/GoogleService-Info.plist` | 같음(.gitignore 319) |
| `ios/Runner/Runner.entitlements` | **`aps-environment: development` 추가함.** 배포 시 Xcode가 `production`으로 바꿔 서명한다 |

`Runner.entitlements`에는 이제 `com.apple.developer.applesignin`과 `aps-environment`가
있다.

APNs `.p8` 키는 Firebase 콘솔에 업로드하는 것이고 **이 저장소에 넣지 않는다.** 앱은 FCM
토큰만 다루며 APNs를 직접 알지 않는다.

이 파일들은 자격증명을 담으므로 커밋 여부를 서버 자격증명과 같은 기준으로 판단한다.
