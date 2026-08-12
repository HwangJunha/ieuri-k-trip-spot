import 'dart:typed_data';

/// 컴포저가 들고 있는 사진 한 장. **두 종류가 한 줄에 섞인다.**
///
/// 커뮤니티 글과 피드가 같은 업로드 프로토콜(사전 서명 URL + 확정)을 쓰므로
/// `common/`에 둔다(CLAUDE.md §4) — 기능마다 복제하면 같은 모양에 이름이 여럿 생긴다.
///
/// 수정 모드의 초안에는 이미 서버에 올라가 글에 붙어 있는 사진([RemotePhoto])과,
/// 방금 골라 아직 아무 데도 올라가지 않은 사진([LocalPhoto])이 함께 있다. 예전처럼
/// `List<String> photoKeys` 하나로는 후자를 담을 수 없었고, 그래서 고르는 즉시
/// 업로드해 키를 만들어야만 했다 — **글을 안 쓰고 나가면 그 오브젝트가 고아로 남아
/// 저장 비용이 든다.**
///
/// 업로드를 등록 시점으로 미루려면 초안이 "아직 키가 없는 사진"을 표현할 수 있어야
/// 하고, 그것이 이 타입의 존재 이유다.
///
/// **순서가 곧 표시 순서다**(가이드 §4) — 두 종류가 섞여도 목록의 순서를 그대로
/// 유지해야 하므로 하나의 리스트에 담는다.
sealed class ComposerPhoto {
  const ComposerPhoto();

  /// 목록에서 이 장을 가리키는 값. 원격은 오브젝트 키, 로컬은 고른 순간 부여한
  /// 식별자다. 제거 버튼이 이 값으로 한 장을 지목한다.
  String get id;
}

/// 이미 서버에 올라가 글에 붙어 있는 사진(`images/...`).
///
/// 수정 모드에서 `post(id:)`가 준 `photoKeys`가 이것으로 들어온다. **다시 올리지
/// 않는다** — 이미 확정된 키라 그대로 `editPost(photoKeys:)`에 실린다.
class RemotePhoto extends ComposerPhoto {
  const RemotePhoto(this.objectKey);

  /// 확정 키(`images/...`). `pending/...`은 서버가 `PHOTO_NOT_UPLOADED`로 거부한다.
  final String objectKey;

  @override
  String get id => objectKey;

  @override
  bool operator ==(Object other) =>
      other is RemotePhoto && other.objectKey == objectKey;

  @override
  int get hashCode => objectKey.hashCode;
}

/// 방금 고른 사진 — **바이트만 들고 있고 아직 어디에도 올라가지 않았다.**
///
/// 업로드는 등록/수정을 누를 때 일어난다. 그 사이 바이트를 그대로 들고 있으므로
/// [contentLength]는 실제로 PUT할 바이트 수와 항상 일치한다 — 그 값이 서명에
/// 들어가므로 1바이트만 달라도 스토리지가 403으로 거부한다(가이드 §4). **중간에
/// 재인코딩·리사이즈를 하면 안 되는 이유가 이것이다.**
class LocalPhoto extends ComposerPhoto {
  const LocalPhoto({
    required this.id,
    required this.bytes,
    required this.contentType,
    required this.name,
  });

  /// 고른 순간 부여하는 식별자. 같은 파일을 두 번 골라도 서로 다른 장이므로
  /// 이름으로는 구분할 수 없다.
  @override
  final String id;

  final Uint8List bytes;

  /// `image/jpeg` · `image/png` · `image/webp`. 그 밖이면 서버가
  /// `UNSUPPORTED_CONTENT_TYPE`으로 거부하므로 **고르는 단계에서 미리 거른다.**
  final String contentType;

  /// 실패를 알릴 때 쓰는 표시 이름. 서버에 보내지 않는다 — 사용자는 키가 아니라
  /// 사진 이름을 본다.
  final String name;

  /// **실제 바이트 수.** 1단계 선언과 2단계 PUT이 이 값으로 일치해야 한다.
  int get contentLength => bytes.length;

  @override
  bool operator ==(Object other) => other is LocalPhoto && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
