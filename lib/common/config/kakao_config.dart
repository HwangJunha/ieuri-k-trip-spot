/// 카카오 네이티브 앱 키. 빌드 시 `--dart-define`으로 주입한다.
///
/// ```
/// --dart-define-from-file=.env   # KAKAO_NATIVE_APP_KEY=...
/// ```
///
/// **로그인과 지도가 같은 값을 쓴다** — 카카오는 두 기능이 하나의 네이티브 앱 키를
/// 공유한다. 그래서 이 상수가 `domain/auth`가 아니라 `common/`에 있다: `domain/map`이
/// auth의 파일을 import하면 교차 feature 의존이 생긴다(CLAUDE.md §3·§4 — 둘 이상이
/// 쓰면 common).
///
/// ## 이 값의 성격
///
/// 네이티브 앱 키는 **숨길 수 있는 값이 아니다.** 카카오 SDK 규약상 Android 매니페스트에
/// `kakao{앱키}` 스킴 문자열로 박혀야 하고, APK를 열면 누구나 읽을 수 있다. 보호는
/// 키 은닉이 아니라 **키 해시(Android)·번들 id(iOS) 플랫폼 등록**이 담당한다 —
/// 카카오 서버가 등록된 앱 서명에서 온 요청만 받는다.
///
/// 그럼에도 소스에 하드코딩하지 않는 이유는 두 가지다. 노출 지점을 굳이 하나 더
/// 늘릴 이유가 없고, 무엇보다 키를 교체할 때 고칠 자리가 갈리면 한쪽이 남는다.
/// 매니페스트에 이미 박힌 것은 SDK 규약상 불가피해 그대로 둔다(설계 §10).
abstract final class KakaoConfig {
  static const String nativeAppKey = String.fromEnvironment(
    'KAKAO_NATIVE_APP_KEY',
  );

  /// 키가 주입됐는가. 비어 있으면 로그인·지도 SDK 초기화를 건너뛴다 — 앱 기동을
  /// 실패시키지 않고, 해당 기능만 안내를 띄운다.
  static bool get isConfigured => nativeAppKey.isNotEmpty;
}
