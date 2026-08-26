# 번들 폰트

전부 **가변 폰트(variable font)** 다. `wght` 축 하나로 모든 웨이트를 낸다 —
Flutter가 `TextStyle.fontWeight`를 그 축의 값으로 그대로 넘기기 때문에
(`docs.flutter.dev/release/breaking-changes/font-weight-variation`) pubspec에
웨이트를 여러 줄 적을 필요가 없다.

| 파일 | 크기 | 쓰임 |
|---|---|---|
| `Latin/NotoSans-VF.ttf` | 2.0MB | 기본 패밀리(`NotoSans`) |
| `Latin/NotoSans-Italic-VF.ttf` | 2.2MB | 이탤릭 |
| `KR/NotoSansKR-VF.ttf` | 9.9MB | 한글 폴백 |
| `JP/NotoSansJP-VF.ttf` | 9.2MB | 일본어 폴백 |
| `TC/NotoSansTC-VF.ttf` | 11.4MB | **번체** 중국어 폴백 |

폴백 순서는 `lib/common/theme/app_theme.dart`가 정한다: KR → JP → TC.

## 중국어는 TC(번체)다

앱이 스스로 `繁體中文`이라 표시하고 서버에도 `TW`를 보낸다
(`lib/common/localization/app_language.dart`). **SC(간체)를 쓰면 안 된다** —
TC 폰트에는 간체 글리프가 없어 `关`·`闭` 같은 글자가 두부(□)로 깨진다.

`lib/l10n/app_zh.arb`에 간체가 섞이지 않았는지는
`test/l10n/nav_arb_keys_test.dart`가 번들 폰트의 cmap과 대조해 검사한다.
눈으로 훑지 말고 그 테스트를 믿으면 된다.

## 갱신하는 법

출처는 Google Fonts의 공식 저장소다:

```
https://github.com/google/fonts/tree/main/ofl/notosans
https://github.com/google/fonts/tree/main/ofl/notosanskr
https://github.com/google/fonts/tree/main/ofl/notosansjp
https://github.com/google/fonts/tree/main/ofl/notosanstc
```

각 디렉터리의 `NotoSans*[wght].ttf`(라틴은 `[wdth,wght]`)를 받아 위 표의 이름으로
바꿔 넣는다. 받은 뒤 `flutter test test/l10n/`으로 커버리지를 확인한다.

`fonts.google.com/download`는 HTML을 돌려주므로 쓰지 않는다.

## 라이선스

SIL Open Font License 1.1 — `OFL.txt`. 재배포 시 이 파일이 함께 있어야 한다.

이 디렉터리는 `pubspec.yaml`의 `assets:`에 폴더로 선언되어 있지 않고 `fonts:`가
파일을 하나씩 가리키므로, `OFL.txt`와 이 문서는 APK/IPA에 들어가지 않는다.
