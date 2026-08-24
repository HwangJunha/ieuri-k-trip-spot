import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../model/photo_scan_progress.dart';

/// 사진 스캔이 어디까지 갔는지 디스크에 적어 두는 저장소(R28).
///
/// **iOS가 백그라운드 실행을 허락하지 않아서 존재한다.** 홈 버튼을 눌러 앱을
/// 내리면 iOS는 곧 앱을 정지시키고, 메모리가 필요하면 아예 종료한다
/// (`BGProcessingTask`는 "기기가 idle일 때만" 돌고 사용자가 기기를 만지는 순간
/// 종료되므로 이 용도에 못 쓴다). 그래서 진행 지점이 메모리에만 있으면 사진이
/// 3만 장인 사람은 앱을 내릴 때마다 처음부터 다시 훑게 된다.
///
/// 배치마다 여기에 적어 두면 앱이 어떻게 죽든 그 지점부터 이어 간다.
///
/// **판정 결과(`resolvedCellCodes`)도 같이 적는다** — 지점만 적으면 이어 갈 때
/// 앞서 찾은 지역을 잃는다.
///
/// 좌표가 아니라 시군구 코드와 진행 숫자만 담는다. 좌표는 기기를 떠나지도,
/// 디스크에 남지도 않는다.
abstract interface class PhotoScanCheckpointStore {
  /// 저장된 지점. 없으면 null이다.
  PhotoScanCheckpoint? read();

  Future<void> write(PhotoScanCheckpoint checkpoint);

  /// 스캔이 끝났거나 처음부터 다시 할 때 지운다.
  Future<void> clear();
}

/// 디스크에 남기는 중단 지점.
///
/// [PhotoScanProgress]를 통째로 담지 않는다 — `stage`처럼 다시 켜면 의미가 없는
/// 값이 섞이면 복원할 때 무엇을 믿어야 할지 모호해진다.
class PhotoScanCheckpoint {
  const PhotoScanCheckpoint({
    required this.processed,
    required this.total,
    required this.foundCoordinates,
    required this.resolvedCellCodes,
  });

  /// 여기까지 읽었다. 다음 시작점이다.
  final int processed;

  /// 적을 당시의 전체 사진 수. 이후 사진이 줄었으면 이어 가면 안 된다.
  final int total;

  final int foundCoordinates;
  final List<String> resolvedCellCodes;

  Map<String, Object?> toJson() => <String, Object?>{
    'processed': processed,
    'total': total,
    'foundCoordinates': foundCoordinates,
    'resolvedCellCodes': resolvedCellCodes,
  };

  static PhotoScanCheckpoint? fromJson(Map<String, dynamic> json) {
    final Object? processed = json['processed'];
    final Object? total = json['total'];
    if (processed is! int || total is! int) return null;
    return PhotoScanCheckpoint(
      processed: processed,
      total: total,
      foundCoordinates: json['foundCoordinates'] is int
          ? json['foundCoordinates'] as int
          : 0,
      resolvedCellCodes: <String>[
        for (final Object? c in (json['resolvedCellCodes'] as List<Object?>?) ??
            const <Object?>[])
          if (c is String) c,
      ],
    );
  }

  /// 화면이 이어서 보여 줄 상태로 되돌린다.
  PhotoScanProgress toProgress() => PhotoScanProgress(
    processed: processed,
    total: total,
    foundCoordinates: foundCoordinates,
    resolvedCellCodes: resolvedCellCodes,
  );
}

/// [SharedPreferences] 기반 구현.
///
/// 토큰이 아니라 진행 숫자라 `flutter_secure_storage`가 아니다
/// (CLAUDE.md §7의 대상은 토큰·비밀값이다).
class SharedPreferencesPhotoScanCheckpointStore
    implements PhotoScanCheckpointStore {
  SharedPreferencesPhotoScanCheckpointStore(this._prefs);

  final SharedPreferences _prefs;

  static const String _key = 'national_map_photo_scan_checkpoint';

  @override
  PhotoScanCheckpoint? read() {
    final String? raw = _prefs.getString(_key);
    if (raw == null || raw.isEmpty) return null;
    try {
      final Object? decoded = jsonDecode(raw);
      if (decoded is! Map<String, dynamic>) return null;
      return PhotoScanCheckpoint.fromJson(decoded);
    } on FormatException {
      // 깨진 기록은 버린다 — 처음부터 훑는 편이 잘못된 지점에서 이어 가는 것보다 낫다.
      return null;
    }
  }

  @override
  Future<void> write(PhotoScanCheckpoint checkpoint) =>
      _prefs.setString(_key, jsonEncode(checkpoint.toJson()));

  @override
  Future<void> clear() => _prefs.remove(_key);
}
