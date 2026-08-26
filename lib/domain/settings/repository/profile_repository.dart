import '../../../common/model/post.dart';
import '../../../common/pagination/page.dart';
import '../model/profile_image_upload.dart';

/// 프로필 수정(R4~R6)과 내가 쓴 글(R3)의 데이터 접근 경계. 구현은 GraphQL이고 생성
/// 타입은 이 인터페이스를 넘지 않는다(CLAUDE.md §3).
///
/// 약관(R9~R12)은 `SettingsRepository`가 따로 맡는다 — 둘을 한 인터페이스에 합치면
/// 약관 화면 테스트가 프로필 메서드까지 전부 스텁해야 한다.
///
/// 실패는 전부 `SettingsFailure`를 던진다.
abstract interface class ProfileRepository {
  /// 내가 쓴 글 한 페이지(R3). 커서 페이징이며 `common/pagination/`을 쓴다.
  ///
  /// **커뮤니티 피드와 같은 [Post]를 돌려준다** — `myPosts`가 같은 `PostConnection`을
  /// 주므로 마이페이지용 모델을 따로 만들지 않는다(설계 §10).
  Future<CursorPage<Post>> fetchMyPosts({int? first, String? after});

  /// 닉네임 변경(R5). 성공하면 서버가 확정한 닉네임을 돌려준다.
  ///
  /// **중복은 허용된다**(2026-08-25 서버 변경) — 형식 오류(`INVALID_NICKNAME`,
  /// 2~20자)만 `SettingsFailure.userError`로 온다.
  Future<String> changeNickname(String nickname);

  /// 프로필 이미지 업로드 1단계 — 서명 URL 발급(R6).
  ///
  /// 선언하는 [contentLength]는 2단계에서 실제로 보낼 바이트 수와 **정확히 같아야**
  /// 한다. 호출부가 파일을 먼저 읽어 실제 길이를 구한다.
  Future<ProfileImageUploadUrl> createProfileImageUploadUrl({
    required String contentType,
    required int contentLength,
  });

  /// 2단계 — 스토리지로 직접 PUT. **GraphQL이 아니다.**
  ///
  /// repository에 두는 이유는 이것이 데이터 접근이기 때문이다. provider나 위젯이
  /// HTTP를 직접 부르면 계층이 무너진다(커뮤니티 사진 업로드와 같은 판단).
  Future<void> uploadProfileImage({
    required String uploadUrl,
    required String contentType,
    required List<int> bytes,
  });

  /// 3단계 — 확정(R6). 성공하면 확정된 이미지 키를 돌려준다.
  Future<String?> confirmProfileImageUpload(String objectKey);

  /// 프로필 이미지 제거(R6). 교체와 **별도 동작**이며 인자가 없다.
  Future<void> removeProfileImage();
}
