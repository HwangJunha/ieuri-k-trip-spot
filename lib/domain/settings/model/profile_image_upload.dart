/// 프로필 이미지 업로드 1단계가 돌려준 발급 결과(SPEC-0011 R6).
///
/// **[uploadUrl]에 서명이 들어 있다.** 2단계 PUT은 인증 헤더를 붙이지 않으며, 1단계에
/// 선언한 `contentType`·`contentLength`가 실제 요청과 정확히 일치해야 한다 — 어긋나면
/// 스토리지가 서명 불일치로 거부한다.
///
/// [objectKey]는 **3단계 확정 전까지 떠도는 임시 키다.** 중간에 실패하거나 화면을
/// 벗어나면 호출부가 이 키를 정리해야 한다(설계 §4).
///
/// 순수 도메인 모델 — flutter·graphql·riverpod 의존 없음.
class ProfileImageUploadUrl {
  const ProfileImageUploadUrl({
    required this.uploadUrl,
    required this.objectKey,
    this.expiresAt,
  });

  final String uploadUrl;
  final String objectKey;

  /// 서명 만료 시각(서버가 정하는 문자열). 표시·로깅용이며 파싱하지 않는다 —
  /// 만료 판정은 스토리지가 하고 클라이언트가 흉내 내면 어긋난다.
  final String? expiresAt;

  @override
  bool operator ==(Object other) =>
      other is ProfileImageUploadUrl &&
      other.uploadUrl == uploadUrl &&
      other.objectKey == objectKey &&
      other.expiresAt == expiresAt;

  @override
  int get hashCode => Object.hash(uploadUrl, objectKey, expiresAt);
}

/// 업로드할 이미지 바이트와 그 MIME 타입(SPEC-0011 R6).
///
/// **길이를 따로 담지 않는다** — `bytes.length`가 곧 `contentLength`이고, 둘을 따로
/// 들고 다니면 어긋날 수 있는 값이 하나 늘어난다. 어긋나는 순간 서명이 깨진다.
///
/// 사진을 고르는 경로(갤러리·카메라)는 이 값을 만드는 쪽의 관심사이고, 여기서는
/// **바이트만** 받는다 — 그래서 provider가 picker 없이도 테스트된다.
class ProfileImageBytes {
  const ProfileImageBytes({required this.bytes, required this.contentType});

  final List<int> bytes;

  /// `image/jpeg` 등. 1단계에 선언하는 값과 2단계 PUT 헤더가 **같아야 한다**.
  final String contentType;

  int get contentLength => bytes.length;
}
