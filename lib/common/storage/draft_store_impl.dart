import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';

import '../log/app_log.dart';
import '../model/composer_photo.dart';
import '../model/stored_draft.dart';
import 'app_preferences.dart';
import 'draft_store.dart';

part 'draft_store_impl.g.dart';

/// 초안 저장소. 화면 하나가 쓰는 자원이 아니라 앱 수명 내내 같은 디렉토리를 보므로
/// keepAlive다.
@Riverpod(keepAlive: true)
DraftStore draftStore(Ref ref) =>
    DraftStoreImpl(ref.watch(sharedPreferencesProvider));

/// [DraftStore]의 구현 — `shared_preferences` + 앱 전용 디렉토리(SPEC-0022 §2).
///
/// **두 저장소를 나눠 쓴다.** 텍스트 계열은 `shared_preferences`에 JSON 한 덩어리로,
/// 사진 바이트는 파일로 쓴다. 바이트를 JSON에 base64로 넣지 않는 이유는 사진 5장이면
/// 최대 50MiB이고 `shared_preferences`는 그 크기를 담으라고 만든 물건이 아니기
/// 때문이다 — 로드가 동기적으로 일어나 앱 시작이 느려진다.
class DraftStoreImpl implements DraftStore {
  DraftStoreImpl(this._prefs);

  static final Logger _logger = appLogger('DraftStore');

  final SharedPreferences _prefs;

  /// 텍스트 계열 JSON이 앉는 키. **초안은 단건이다** — 덮어쓰기가 누적을 막으므로
  /// 별도 정리 작업이 필요 없다(§5).
  static const String _key = 'community_post_draft';

  /// 사진 바이트가 모이는 하위 디렉토리. 앱 전용 디렉토리 안이라 OS가 다른 앱으로
  /// 부터 격리한다(R12).
  static const String _photoDirName = 'post_draft_photos';

  @override
  Future<void> save(StoredDraft draft, List<ComposerPhoto> photos) async {
    try {
      // 사진을 먼저 쓴다 — 메타가 가리키는 파일이 없는 창을 만들지 않기 위해서다.
      // 반대 순서면 메타를 쓴 직후 앱이 죽었을 때 복원 불가 초안이 남는다.
      await _writePhotos(draft.photos, photos);
      await _prefs.setString(_key, jsonEncode(draft.toJson()));
    } on Object catch (error) {
      // 내용은 남기지 않는다 — 본문·제목·태그가 로그에 실리면 안 된다(POL-013).
      // 원인과 초안 존재 여부까지만 남긴다(§7).
      _log('draft save failed', error);
    }
  }

  @override
  Future<DraftLoadResult> load() async {
    final String? raw = _prefs.getString(_key);
    if (raw == null) return const DraftAbsent();

    final StoredDraft? draft = _decode(raw);
    if (draft == null) {
      return const DraftUnrestorable(DraftUnrestorableReason.malformed);
    }

    final List<ComposerPhoto> photos = <ComposerPhoto>[];
    for (final StoredPhoto photo in draft.photos) {
      switch (photo) {
        case StoredRemotePhoto():
          photos.add(photo.toComposerPhoto());
        case StoredLocalPhoto():
          final Uint8List? bytes = await _readPhoto(photo.fileName);
          if (bytes == null) {
            return const DraftUnrestorable(
              DraftUnrestorableReason.missingPhotoFile,
            );
          }
          // **길이를 대조한다**(R10-1). 이 값이 사전 서명에 들어가므로 1바이트만
          // 달라도 스토리지가 403을 낸다 — 등록 시점이 아니라 여기서 잡는다.
          if (bytes.length != photo.contentLength) {
            return const DraftUnrestorable(
              DraftUnrestorableReason.photoLengthMismatch,
            );
          }
          photos.add(photo.toComposerPhoto(bytes));
      }
    }

    return DraftLoaded(draft, photos);
  }

  @override
  Future<void> clear() async {
    try {
      await _prefs.remove(_key);
      final Directory dir = await _photoDir();
      if (dir.existsSync()) await dir.delete(recursive: true);
    } on Object catch (error) {
      _log('draft clear failed', error);
    }
  }

  /// JSON 문자열을 초안으로 되돌린다. 파싱 자체가 실패하면 null이다 — 예전 버전이
  /// 쓴 형식이거나 저장소가 손상된 경우다.
  StoredDraft? _decode(String raw) {
    try {
      final Object? json = jsonDecode(raw);
      if (json is! Map<String, Object?>) return null;
      return StoredDraft.fromJson(json);
    } on FormatException {
      return null;
    }
  }

  /// 사진 바이트를 파일로 쓴다.
  ///
  /// **이미 있는 파일은 건너뛴다** — 파일 이름이 [StoredLocalPhoto.fileName]으로
  /// 안정적이라 제목 한 글자를 고쳤다고 50MiB를 다시 쓰지 않는다(§4).
  ///
  /// 목록에서 빠진 장의 파일은 지운다. 남겨 두면 사용자가 뺀 사진이 디스크를 계속
  /// 차지하고, 새 초안이 덮어쓸 때도 고아로 남는다(R4-2).
  Future<void> _writePhotos(
    List<StoredPhoto> stored,
    List<ComposerPhoto> photos,
  ) async {
    final Directory dir = await _photoDir();
    if (!dir.existsSync()) await dir.create(recursive: true);

    final Map<String, LocalPhoto> byId = <String, LocalPhoto>{
      for (final LocalPhoto p in photos.whereType<LocalPhoto>()) p.id: p,
    };

    final Set<String> keep = <String>{};
    for (final StoredPhoto photo in stored) {
      if (photo is! StoredLocalPhoto) continue;
      keep.add(photo.fileName);
      final File file = File('${dir.path}/${photo.fileName}');
      if (file.existsSync()) continue;
      final LocalPhoto? source = byId[photo.id];
      if (source == null) continue;
      await file.writeAsBytes(source.bytes, flush: true);
    }

    for (final FileSystemEntity entity in dir.listSync()) {
      if (entity is File && !keep.contains(entity.uri.pathSegments.last)) {
        await entity.delete();
      }
    }
  }

  /// 사진 파일을 읽는다. 없으면 null — 복원 불가의 한 갈래다(R10-2).
  Future<Uint8List?> _readPhoto(String fileName) async {
    try {
      final Directory dir = await _photoDir();
      final File file = File('${dir.path}/$fileName');
      if (!file.existsSync()) return null;
      return await file.readAsBytes();
    } on Object {
      return null;
    }
  }

  Future<Directory> _photoDir() async {
    final Directory base = await getApplicationSupportDirectory();
    return Directory('${base.path}/$_photoDirName');
  }

  /// 실패를 남긴다. **초안의 내용은 절대 싣지 않는다**(POL-013) — 제목·본문·태그가
  /// 로그에 실리면 안 되므로 원인의 타입까지만 남긴다(§7).
  void _log(String what, Object error) =>
      _logger.w('$what: ${error.runtimeType}');
}
