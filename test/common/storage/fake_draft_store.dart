import 'package:ieuri_k_trip_spot/common/model/composer_photo.dart';
import 'package:ieuri_k_trip_spot/common/model/stored_draft.dart';
import 'package:ieuri_k_trip_spot/common/storage/draft_store.dart';

/// 메모리에 두는 [DraftStore]. **실제 파일 시스템이 필요 없다**(SPEC-0022 §8) —
/// 포트를 스텁으로 대체하므로 저장·삭제 호출 여부와 복원 후 상태만으로 수용 기준을
/// 판정한다.
class FakeDraftStore implements DraftStore {
  FakeDraftStore({this.loadResult = const DraftAbsent()});

  /// [load]가 돌려줄 값. 테스트가 복원 갈래를 직접 고른다.
  DraftLoadResult loadResult;

  /// 저장된 초안들 — 마지막 것만이 아니라 **호출 순서 전체**를 남긴다. 디바운스가
  /// 몇 번 썼는지 세는 테스트가 있기 때문이다.
  final List<StoredDraft> saved = <StoredDraft>[];

  /// 저장할 때 함께 넘어온 사진 목록. 순서 보존을 검증한다(R3-4).
  final List<List<ComposerPhoto>> savedPhotos = <List<ComposerPhoto>>[];

  int clearCount = 0;

  StoredDraft? get lastSaved => saved.isEmpty ? null : saved.last;

  @override
  Future<void> save(StoredDraft draft, List<ComposerPhoto> photos) async {
    saved.add(draft);
    savedPhotos.add(List<ComposerPhoto>.unmodifiable(photos));
  }

  @override
  Future<DraftLoadResult> load() async => loadResult;

  @override
  Future<void> clear() async {
    clearCount++;
    loadResult = const DraftAbsent();
  }
}
