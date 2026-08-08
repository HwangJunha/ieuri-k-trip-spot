/// The SNS identity providers the server accepts (schema `Provider`). Pure
/// domain enum so the login buttons, the SNS sign-up form, and the repository
/// share one source of truth without importing the generated GraphQL enum
/// (spec §6.1, CLAUDE.md §3).
enum SnsProvider {
  google,
  apple,
  kakao;

  /// The wire string the server expects (matches the schema `Provider` names).
  String get wireName => switch (this) {
    SnsProvider.google => 'GOOGLE',
    SnsProvider.apple => 'APPLE',
    SnsProvider.kakao => 'KAKAO',
  };
}

/// 이 플랫폼에서 실제로 로그인할 수 있는 provider 목록.
///
/// **애플은 안드로이드에서 제외한다.** `sign_in_with_apple`은 애플 기기 밖에서는
/// 웹 흐름을 쓰는데, 그러려면 `webAuthenticationOptions`(Apple Developer의
/// Service ID와 리다이렉트 URL, 그리고 그 리다이렉트를 받아 앱으로 되돌려줄 서버
/// 엔드포인트)가 필요하다. 그것 없이 호출하면 무조건 예외가 난다 — 눌러도 실패만
/// 하는 버튼을 보여주느니 감춘다.
///
/// [isApplePlatform]은 `Platform.isIOS || Platform.isMacOS`를 넘긴다. 모델을
/// 순수하게 두기 위해(CLAUDE.md §3) `dart:io`를 여기서 읽지 않는다.
List<SnsProvider> snsProvidersFor({required bool isApplePlatform}) =>
    <SnsProvider>[
      SnsProvider.google,
      if (isApplePlatform) SnsProvider.apple,
      SnsProvider.kakao,
    ];
