import '../model/composer_photo.dart';
import '../model/stored_draft.dart';

/// 작성 중인 글 초안을 디스크에 두는 포트(SPEC-0022 §2).
///
/// **커뮤니티 도메인 밖에 둔다.** 사진 바이트를 파일로 쓰는 일은 커뮤니티 고유의
/// 관심사가 아니고, [ComposerPhoto]가 이미 `common/model/`에 있어 피드 컴포저와
/// 공유되던 선례를 따른다(CLAUDE.md §4).
///
/// **저장·삭제는 예외를 던지지 않는다**(R9). 저장 공간 부족이나 파일 쓰기 실패가
/// 작성을 막아서는 안 된다 — 초안 저장 실패의 최악은 사용자가 원래 겪던 상태(초안이
/// 없는 것)로 돌아가는 것뿐이다. 이것은 fail-closed를 요구하는 POL-008의 토큰
/// 저장소와 정반대 방향이며 의도적이다(§7).
///
/// **`flutter_secure_storage`를 쓰지 않는다.** 토큰용이고(POL-008), 초안은 기기
/// 소유자 본인의 작성 중 콘텐츠라 암호화 저장 대상이 아니다. 앱 전용 디렉토리는 OS가
/// 이미 다른 앱으로부터 격리하므로 R12는 그것으로 충족된다(§2).
abstract interface class DraftStore {
  /// 초안을 저장한다. 사진 바이트는 [photos] 중 [LocalPhoto]인 장에서 가져온다.
  ///
  /// **이미 쓰여 있는 사진은 다시 쓰지 않는다** — 파일 이름이
  /// [StoredLocalPhoto.fileName]으로 안정적이라 제목 한 글자 때문에 50MiB를 다시
  /// 쓰는 일이 없다(§4). 목록에서 빠진 장의 파일은 지운다.
  ///
  /// 실패해도 예외를 던지지 않는다(R9).
  Future<void> save(StoredDraft draft, List<ComposerPhoto> photos);

  /// 저장된 초안을 읽는다. **결과가 타입으로 갈린다** — 파일 존재 여부와 길이
  /// 불일치는 파일 시스템의 사실이라 매핑 계층이 관찰할 수 없고, 포트가 알려 줘야
  /// notifier가 스텁만으로 R10-2를 판정할 수 있다(§3).
  Future<DraftLoadResult> load();

  /// 초안을 지운다 — **텍스트와 사진 파일을 함께** 지운다. 한쪽만 지우면 고아 파일이
  /// 남거나 참조가 깨진다(§6).
  ///
  /// 실패해도 예외를 던지지 않는다(R9).
  Future<void> clear();
}

/// [DraftStore.load]의 결과. 네 갈래를 구분한다(§3).
sealed class DraftLoadResult {
  const DraftLoadResult();
}

/// 저장된 초안이 없다. 빈 상태로 시작한다.
class DraftAbsent extends DraftLoadResult {
  const DraftAbsent();
}

/// 정상 복원. [draft]의 텍스트와 [photos]의 바이트가 모두 갖춰졌다.
class DraftLoaded extends DraftLoadResult {
  const DraftLoaded(this.draft, this.photos);

  final StoredDraft draft;

  /// 복원한 사진. **저장 당시의 순서 그대로다**(R3-4).
  final List<ComposerPhoto> photos;
}

/// 복원할 수 없다. 어느 갈래든 화면은 **조용히 빈 상태로 시작하고 초안을 지운다**
/// (R10) — "초안을 불러오지 못했습니다"는 사용자가 할 수 있는 일이 없는 오류이며,
/// 글을 쓰려고 화면을 연 사람에게 처리할 수 없는 실패를 알리는 것은 방해다.
class DraftUnrestorable extends DraftLoadResult {
  const DraftUnrestorable(this.reason);

  final DraftUnrestorableReason reason;
}

enum DraftUnrestorableReason {
  /// JSON이 아니거나 예전 형식이다.
  malformed,

  /// 메타는 있는데 사진 파일이 없다.
  missingPhotoFile,

  /// 파일은 있는데 길이가 저장 당시와 다르다. 그대로 올리면 사전 서명이 맞지 않아
  /// 스토리지가 403을 낸다(R10-1).
  photoLengthMismatch,
}
