/// 사진 업로드에 쓰이는 값들(가이드 §4). **서버는 이미지 바이트를 받지 않는다** —
/// 앱이 오브젝트 스토리지로 직접 PUT하고, 그 PUT만 GraphQL이 아니다.
///
/// 커뮤니티 글과 피드가 같은 업로드 프로토콜을 쓰므로 `common/`에 둔다
/// (CLAUDE.md §4, POL-042) — 피드 전용 업로드 경로를 새로 만들지 않는다.
///
/// 전체 흐름은 넷이다:
/// 1. `createPostImageUploadUrls` → [PostImageUploadUrl]
/// 2. 각 `uploadUrl`로 HTTP PUT (GraphQL 아님)
/// 3. `confirmPostImageUploads` → [PostImageConfirmation]
/// 4. `createPost(photoKeys:)`에 **confirmed 키만** 넘긴다
library;

/// 올릴 사진 한 장의 선언(서버 `PostImageUploadRequest`).
///
/// **[contentLength]는 추정치가 아니라 실제 파일 바이트 수여야 한다.** 이 값이
/// 서명에 들어가므로 1바이트만 달라도 2단계에서 스토리지가 403으로 거부한다.
class PostImageUploadRequest {
  const PostImageUploadRequest({
    required this.contentType,
    required this.contentLength,
  });

  /// `image/jpeg` · `image/png` · `image/webp`만 허용된다. 그 밖이면
  /// `UNSUPPORTED_CONTENT_TYPE`.
  final String contentType;

  /// 1 ~ 10485760(10 MiB). 범위 밖이면 `UNSUPPORTED_CONTENT_TYPE`.
  final int contentLength;

  @override
  bool operator ==(Object other) =>
      other is PostImageUploadRequest &&
      other.contentType == contentType &&
      other.contentLength == contentLength;

  @override
  int get hashCode => Object.hash(contentType, contentLength);
}

/// 발급된 업로드 URL 하나(서버 `PostImageUploadUrl`).
///
/// **응답은 요청과 같은 순서로 온다**, 그리고 하나라도 어긋나면 전부 발급되지
/// 않는다(빈 목록) — 부분 발급은 클라이언트가 추적하기 어려워서다(가이드 §4).
class PostImageUploadUrl {
  const PostImageUploadUrl({
    required this.uploadUrl,
    required this.objectKey,
    required this.expiresAt,
  });

  /// 서명이 들어 있는 PUT 대상. **인증 헤더를 붙이지 않는다.**
  final String uploadUrl;

  /// 서버가 정한 임시 키(`pending/{memberId}/{uuid}`). 앱이 만들거나 바꿀 수 없다.
  final String objectKey;

  /// 만료 시각(발급 후 30분). 지나면 1단계부터 다시 한다.
  final String expiresAt;

  @override
  bool operator ==(Object other) =>
      other is PostImageUploadUrl &&
      other.uploadUrl == uploadUrl &&
      other.objectKey == objectKey &&
      other.expiresAt == expiresAt;

  @override
  int get hashCode => Object.hash(uploadUrl, objectKey, expiresAt);
}

/// 확인 실패한 사진 한 장.
class PostImageUploadFailure {
  const PostImageUploadFailure({required this.objectKey, required this.code});

  final String objectKey;
  final String code;

  @override
  bool operator ==(Object other) =>
      other is PostImageUploadFailure &&
      other.objectKey == objectKey &&
      other.code == code;

  @override
  int get hashCode => Object.hash(objectKey, code);
}

/// 3단계 확인의 결과(서버 `ConfirmPostImageUploadsPayload`).
///
/// **장별로 성패가 갈린다.** [failed]가 비어 있지 않으면 서버의 `success`는 false지만
/// **[confirmed]의 키는 여전히 유효하다** — 실패한 장만 다시 올리게 하고 나머지는
/// 살린다. 전부 버리면 사용자가 다 다시 올려야 한다(가이드 §4).
///
/// 그래서 이 결과는 실패로 **던지지 않고 값으로 돌려준다.**
class PostImageConfirmation {
  const PostImageConfirmation({
    this.confirmed = const <String>[],
    this.failed = const <PostImageUploadFailure>[],
  });

  /// 통과한 최종 키(`images/...`). **이 값만 `createPost`에 넘길 수 있다.**
  final List<String> confirmed;

  final List<PostImageUploadFailure> failed;

  bool get hasFailures => failed.isNotEmpty;
}
