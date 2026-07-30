> spec: SPEC-0001 · source: `Specs/SPEC-0001/spec.md` (Obsidian) · status: approved

# SPEC-0001 — 클라이언트 설계 (k-trip-spot)

요구사항·인수조건·정책은 스펙(위 링크)이 authority다. 이 문서는 그 요구사항을 **어떻게 실현하는지**만
다루며, 요구사항을 재기술하지 않고 번호로 인용한다.

**이 스펙의 범위는 "권한 요청 + 스토어 사용 목적 문자열"까지다.** 권한을 받은 뒤 위치를 읽거나 FCM/APNs
토큰을 획득하는 것은 전부 non-scope(후속 작업)이므로 이 문서도 그 설계를 담지 않는다.

## 도메인 배치

권한 요청은 특정 화면에 종속되지 않는 횡단 관심사이자 앱 부팅 시퀀스의 일부다. 2026-07-28 리팩토링
결정(map·chat·discover는 `spot` 도메인의 view)에 따라, 권한 로직은 화면에 흩뿌리지 않고 **`lib/common`**
아래 공용으로 둔다.

```
lib/common/permission/
  model/        PermissionKind(location|notification), PermissionState(granted|denied|permanentlyDenied|restricted)
  service/      PermissionService — permission_handler 위의 얇은 래퍼 (요청·상태조회·설정이동)
  provider/     Riverpod(codegen) provider
  component/    사전 설명(rationale) 시트, 영구거부 안내 위젯
```

- `permission_handler` 패키지가 iOS/Android 권한 요청·상태·`openAppSettings()`를 통일 처리한다
  (R1, R2, R5).
- **`geolocator`·`firebase_messaging`는 이번에 추가하지 않는다** — 위치를 읽거나 토큰을 받는 건 non-scope.
  권한만 요청하므로 `permission_handler` 하나로 충분하다.
- 플러그인의 `PermissionStatus`는 `service/` 밖으로 새지 않게 도메인 모델 `PermissionState`로 매핑한다.
  이 enum 값은 안정 식별자로만 쓰고 사용자 표시 문구와 분리한다 (POL-023).

## 최초 실행 권한 요청 시퀀스

R1·R2·R3·R6의 실현. 앱 부팅 시퀀스(스플래시 이후, 첫 화면 진입 전 또는 진입 직후)에서 한 번 실행한다.
각 OS 다이얼로그 **이전에 인앱 사전 설명 시트**를 노출한다(R3).

```
앱 부팅
  └─ 위치 상태 조회
       ├─ undetermined → [위치 사전 설명 시트]
       │      ├─ 진행 → OS 위치 요청("when in use") ──▶ granted | denied | permanentlyDenied
       │      └─ 닫기 → OS 요청 안 함 (R3 실패경로)
       └─ 이미 결정됨 → 스킵 (R6)
  └─ (위치 플로우 종료 후) 알림 상태 조회
       ├─ undetermined → [알림 사전 설명 시트]
       │      ├─ 진행 → OS 알림 요청 ──▶ granted | denied | permanentlyDenied
       │      └─ 닫기 → OS 요청 안 함 (R3 실패경로)
       └─ 이미 결정됨 → 스킵 (R6)
  └─ 결과와 무관하게 다음 화면으로 진입 (R4 — 거부해도 크래시/블로킹 없음)
```

- 위치·알림 플로우는 **순차** 진행한다(다이얼로그가 동시에 겹치지 않음, R2 두 번째 criterion). 위치
  플로우의 completer가 끝난 뒤 알림 플로우를 시작.
- 사전 설명 시트는 `showModalBottomSheet` 기반 공용 위젯. 위치용·알림용 카피를 `PermissionKind`로 분기.
  iOS는 OS 권한 다이얼로그를 생애 한 번만 띄우므로, 사용자가 "진행"을 택했을 때만 OS 요청을 호출한다.
- "이미 결정된 권한은 재요청 안 함"(R6)은 요청 전 `PermissionService.status(kind)`로 분기하여 보장.
  이미 결정된 상태에선 사전 설명 시트도 OS 다이얼로그도 노출하지 않는다.
- 백그라운드/"always" 위치는 요청하지 않는다 (R1 두 번째 criterion, R7).

## 영구거부 처리

R5의 실현. 거부만으로는 앱을 막지 않으며(R4), **영구거부/restricted일 때만** 설정 이동 경로를 노출한다.

- 부팅 시 요청 결과가 `permanentlyDenied`/`restricted`면, 즉시 모달을 띄우지 않고 상태만 보관한다.
  이후 해당 권한이 실제로 의미를 갖는 지점(후속 기능)에서 "설정에서 켜기" 액션을 노출하도록 상태를
  provider로 공개한다.
- 설정 이동은 `permission_handler`의 `openAppSettings()`.
- 설정에서 복귀 시(앱 `resumed` 라이프사이클) 상태를 재조회해 반영한다 — 앱 재시작 불필요
  (R5 두 번째 criterion).

## 로딩·에러 표현

권한은 서버 호출이 아니므로 네트워크 로딩·에러가 없다. 표현은:

- **사전 설명 시트** — 진행/닫기 두 액션 (R3).
- **OS 다이얼로그** — OS가 그림. 앱은 결과만 받음.
- **영구거부 안내** — 설정 이동 버튼이 있는 인라인 메시지/스낵바 (R5).

권한 상태는 서버 `UserError`가 아니라 플러그인 상태이므로 이슈 #5(UserError.code 매핑)와 무관하다.

## 네이티브 선언 (스토어 심사 대응)

R8·R7의 실현. 문구는 스펙이 요구하는 "구체적 사유"를 담고 EN+KO로 제공한다.

**iOS — `ios/Runner/Info.plist`**
- `NSLocationWhenInUseUsageDescription` (신규) — 위치 사용 사유. EN은 `Info.plist` 기본값,
  KO는 `ios/Runner/ko.lproj/InfoPlist.strings`.
- iOS 알림은 `Info.plist` 문자열 키가 필수는 아님(런타임 `UNUserNotificationCenter` 요청).
- `NSLocationAlwaysAndWhenInUseUsageDescription`·카메라·마이크·사진 키는 **추가하지 않음** (R7).

**Android — `android/app/src/main/AndroidManifest.xml`**
- `<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>` (신규)
- `<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>` (신규)
- `<uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>` (신규, Android 13+)
- `CAMERA`·`RECORD_AUDIO`·미디어 읽기·`ACCESS_BACKGROUND_LOCATION`은 **선언하지 않음** (R7).
- Play Console 데이터 안전성 폼에는 위치·알림 용도를 기재한다.

## i18n

- 사전 설명 카피는 `lib/l10n/app_{en,ko,ja,zh}.arb` 4개 언어 모두에 키 추가 (R9).
- 스토어 문자열은 EN+KO (R8) — iOS `InfoPlist.strings`(ko), Android는 런타임/스토어 폼으로 커버.

## 이 문서가 결정하지 않는 것

- 권한 허용 이후의 모든 처리 — 위치 획득/사용, FCM·APNs 토큰, 지도 센터링, 거리 계산 (전부 non-scope).
- Map/Discover/Chat 화면 본체 (이슈 #7).
