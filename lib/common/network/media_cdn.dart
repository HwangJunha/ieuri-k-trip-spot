/// 업로드된 미디어의 CDN 베이스 URL(SPEC-0010 가이드 §3).
///
/// 서버는 사진의 **키**만 내려주고 URL을 내려주지 않는다 — 그래야 CDN이 바뀌어도
/// 서버 배포 없이 앱만 고치면 된다. 베이스는 앱 설정에 두고 위젯 안에 문자열로
/// 박지 않는다.
///
/// [GraphqlEndpoint]와 같은 방식으로 `--dart-define=MEDIA_CDN_BASE=...` 로 덮어쓸 수
/// 있다. `common/network`에 두는 이유는 이 값이 기능이 아니라 인프라 설정이기
/// 때문이다(CLAUDE.md §4).
class MediaCdn {
  const MediaCdn._();

  static const String _override = String.fromEnvironment('MEDIA_CDN_BASE');

  static const String _defaultBase = 'https://cdn.ieuri.co.kr';

  static String get base => _override.isEmpty ? _defaultBase : _override;

  /// 사진 키 하나를 표시 가능한 URL로 조합한다.
  ///
  /// 개발 환경 시드의 키는 실제 오브젝트가 없어 **404가 정상**이다(가이드 §3) —
  /// 표시 계층은 이 URL이 실패해도 레이아웃을 유지해야 한다.
  static String urlFor(String photoKey) {
    final String key = photoKey.startsWith('/')
        ? photoKey.substring(1)
        : photoKey;
    return '$base/$key';
  }
}
