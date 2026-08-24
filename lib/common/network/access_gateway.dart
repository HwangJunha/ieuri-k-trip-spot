/// Cloudflare Access 서비스 토큰(개발 서버 전용).
///
/// 개발 API(`api-dev.ieuri.co.kr`)는 Cloudflare Access 뒤에 있어, 두 헤더가 없으면
/// 로그인 화면 HTML이 돌아온다 — GraphQL 응답이 아니라서 앱은 파싱 오류로 본다.
///
/// ```
/// CF-Access-Client-Id: <id>
/// CF-Access-Client-Secret: <secret>
/// ```
///
/// **운영 빌드에는 들어가지 않는다.** 운영 API는 Access 뒤에 있지 않고, 값이 비면
/// 헤더 자체를 붙이지 않는다([headers]가 빈 맵을 돌려준다). 주입은 flavor별
/// `--dart-define-from-file`이 하며 `.env.prod`에는 이 키를 두지 않는다.
///
/// **이 토큰은 진짜 비밀이다.** Cloudflare 문서가 서버 간 통신용으로 규정하고,
/// 분실 시 재발급만 가능하다고 명시한다. 주입해도 컴파일된 바이너리 안에 문자열로
/// 남으므로 **dev 빌드를 외부에 배포하지 않는다** — 배포해야 한다면 그 빌드는
/// 운영 API를 보게 하거나, 서버가 Access 대신 다른 인증을 쓰게 해야 한다.
class AccessGateway {
  const AccessGateway._();

  static const String _clientId = String.fromEnvironment('CF_ACCESS_CLIENT_ID');
  static const String _clientSecret = String.fromEnvironment(
    'CF_ACCESS_CLIENT_SECRET',
  );

  /// 이 빌드가 Access 게이트웨이를 통과해야 하는가.
  ///
  /// **둘 다 있어야 참이다** — 하나만 있으면 Cloudflare가 거부하므로, 반쪽짜리
  /// 주입을 헤더 없는 것과 똑같이 취급해 원인을 헷갈리지 않게 한다.
  static bool get isConfigured =>
      _clientId.isNotEmpty && _clientSecret.isNotEmpty;

  /// 요청에 실을 헤더. 설정되지 않았으면 **빈 맵**이다.
  static Map<String, String> get headers => isConfigured
      ? <String, String>{
          'CF-Access-Client-Id': _clientId,
          'CF-Access-Client-Secret': _clientSecret,
        }
      : const <String, String>{};
}
