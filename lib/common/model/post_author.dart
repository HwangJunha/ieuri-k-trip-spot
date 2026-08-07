/// 글·댓글 작성자(서버 `PostAuthor`).
///
/// 프로필 화면이 비범위라 **작성자를 눌러도 이동할 곳이 없다** — 닉네임과 프로필
/// 이미지는 표시만 한다(설계 §6). 순수 도메인 모델.
class PostAuthor {
  const PostAuthor({
    required this.id,
    required this.nickname,
    this.profileImageUrl,
  });

  final String id;
  final String nickname;

  /// 프로필 이미지. 없으면(null) 이니셜/기본 아바타로 대체한다.
  final String? profileImageUrl;

  @override
  bool operator ==(Object other) =>
      other is PostAuthor &&
      other.id == id &&
      other.nickname == nickname &&
      other.profileImageUrl == profileImageUrl;

  @override
  int get hashCode => Object.hash(id, nickname, profileImageUrl);
}
