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

  /// 프로필 이미지 값을 **표시 가능한 URL로** 만든다. 값이 없거나 비었으면 null이다.
  ///
  /// 서버의 `profileImageUrl`은 이름과 달리 **완전한 URL이 아닐 수 있다** — 업로드
  /// 확정이 돌려주는 것은 오브젝트 키(`confirmProfileImageUpload.profileImageKey`)이고,
  /// 그 값이 그대로 이 필드로 나온다. 키를 `NetworkImage`에 그대로 넘기면
  /// `_HttpClient._openUrl`에서 예외가 나 **위젯 페인트 중에 터진다**(스킴이 없어
  /// 호스트를 못 정한다).
  ///
  /// 그래서 스킴이 있으면 그대로 쓰고, 없으면 키로 보고 CDN 베이스를 붙인다. 서버가
  /// 나중에 완전한 URL을 주도록 바뀌어도 이 함수는 그대로 맞는다.
  static String? profileImage(String? value) {
    if (value == null) return null;
    final String trimmed = value.trim();
    if (trimmed.isEmpty) return null;
    final Uri? parsed = Uri.tryParse(trimmed);
    if (parsed != null && parsed.hasScheme) return trimmed;
    return urlFor(trimmed);
  }
}
