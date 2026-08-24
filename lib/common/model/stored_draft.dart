import 'dart:typed_data';

import 'composer_photo.dart';
import 'list_equality.dart';
import 'target_category.dart';

/// 초안이 살아 있는 기간(SPEC-0022 R8). 넘긴 초안은 여는 시점에 지운다.
const Duration draftTimeToLive = Duration(days: 30);

/// [savedAt]에 저장한 초안이 [now] 기준으로 만료됐는지.
///
/// **순수 함수다** — 안에서 `DateTime.now()`를 부르면 경계값(29일/31일)을 테스트할
/// 수 없다. 기준 시각을 인자로 받아 그 판정을 밖에서 고정한다.
///
/// 경계는 열려 있다: 정확히 30일이면 아직 살아 있다.
bool isDraftExpired({required DateTime savedAt, required DateTime now}) =>
    now.difference(savedAt) > draftTimeToLive;

/// 디스크에 쓰는 초안 한 건(SPEC-0022 §3).
///
/// `PostDraft`를 그대로 직렬화하지 않는 이유는 [LocalPhoto]가 `Uint8List`를 들고
/// 있어 JSON이 되지 않기 때문이다. 저장 전용 모델을 따로 두어 **바이트를 메타에서
/// 떼어 낸다** — 텍스트는 `shared_preferences`에, 바이트는 파일에 간다(§2).
///
/// 순수 도메인 — flutter·graphql·riverpod 의존 없음.
class StoredDraft {
  const StoredDraft({
    required this.savedAt,
    this.category,
    this.languageCode,
    this.spotId,
    this.spotTitle,
    this.title = '',
    this.body = '',
    this.tags = const <String>[],
    this.photos = const <StoredPhoto>[],
  });

  /// 저장 시각. TTL 판정의 기준이다(R8).
  final DateTime savedAt;

  /// [TargetCategory.code] 문자열. **enum이 아니라 코드로 둔다** — 서버 주도
  /// 목록이라 저장 당시의 카테고리가 나중에 사라질 수 있고, 그때 초안 전체가 아니라
  /// 이 값만 null로 복원한다(§3).
  final String? category;

  /// 저장 당시의 활성 언어 코드(`en`·`ko`·…). **장소 참조의 유효 범위를 기록한다**
  /// (SPEC-0029 AC-26.2) — spot은 언어별로 갈리므로 다른 언어에서 복원하면 [spotId]가
  /// 해소되지 않을 수 있다.
  ///
  /// SPEC-0029 이전에 저장된 초안은 null이다. 그때는 언어를 알 수 없으므로 장소
  /// 참조를 믿지 않는다([restoredSpotId] 참조).
  final String? languageCode;

  final String? spotId;
  final String? spotTitle;
  final String title;
  final String body;
  final List<String> tags;

  /// **순서가 곧 표시 순서다**(R3-4) — 복원할 때 이 순서를 그대로 되돌린다.
  final List<StoredPhoto> photos;

  /// 저장할 것이 있는지. 여섯 요소가 모두 비면 저장 대신 삭제한다(R1-3) — 그래야
  /// "다 지웠는데도 이어쓰기를 묻는" 상태가 생기지 않는다.
  bool get isEmpty =>
      category == null &&
      spotId == null &&
      title.trim().isEmpty &&
      body.trim().isEmpty &&
      tags.isEmpty &&
      photos.isEmpty;

  bool get isNotEmpty => !isEmpty;

  /// 편집 중인 초안에서 저장 형식을 만든다. 바이트는 담기지 않는다 — 파일 이름만
  /// 남기고 실제 바이트는 [DraftStore]가 따로 쓴다.
  static StoredDraft fromDraft({
    required DateTime savedAt,
    TargetCategory? category,
    String? languageCode,
    String? spotId,
    String? spotTitle,
    String title = '',
    String body = '',
    List<String> tags = const <String>[],
    List<ComposerPhoto> photos = const <ComposerPhoto>[],
  }) => StoredDraft(
    savedAt: savedAt,
    category: category?.code,
    languageCode: languageCode,
    spotId: spotId,
    spotTitle: spotTitle,
    title: title,
    body: body,
    tags: List<String>.unmodifiable(tags),
    photos: photos
        .map(StoredPhoto.fromComposerPhoto)
        .toList(growable: false),
  );

  /// 복원한 카테고리. 서버가 목록에서 뺀 코드면 null이다 — 사용자가 다시 고른다(§3).
  TargetCategory? get restoredCategory {
    final String? code = category;
    return code == null ? null : TargetCategory.fromCode(code);
  }

  /// [activeLanguageCode]에서 이 초안의 장소 참조를 쓸 수 있는지(SPEC-0029 AC-26.2).
  ///
  /// spot이 언어별로 갈리므로 **저장 당시와 다른 언어면 믿을 수 없다.** 그 id를
  /// 그대로 제출하면 `SPOT_NOT_FOUND_IN_LOCALE`로 실패하는데, 사용자에겐 자기가 쓴
  /// 글이 이유 없이 거절당하는 것으로 보인다.
  ///
  /// SPEC-0029 이전 초안([languageCode]가 null)도 믿지 않는다 — 어느 언어에서
  /// 저장했는지 알 수 없어 안전한 쪽으로 판단한다. 카테고리와 같은 결이다: **초안
  /// 전체를 버리지 않고 그 값만 비운다.**
  bool spotIsUsableIn(String activeLanguageCode) =>
      languageCode != null && languageCode == activeLanguageCode;

  /// [activeLanguageCode]에서 복원할 장소 id. 쓸 수 없으면 null이다.
  String? restoredSpotId(String activeLanguageCode) =>
      spotIsUsableIn(activeLanguageCode) ? spotId : null;

  /// [restoredSpotId]와 짝을 이루는 장소명. **id와 함께 비운다** — 제목만 남으면
  /// 칩이 그려지는데 누르면 열리지 않는다.
  String? restoredSpotTitle(String activeLanguageCode) =>
      spotIsUsableIn(activeLanguageCode) ? spotTitle : null;

  Map<String, Object?> toJson() => <String, Object?>{
    'savedAt': savedAt.toIso8601String(),
    'category': category,
    'languageCode': languageCode,
    'spotId': spotId,
    'spotTitle': spotTitle,
    'title': title,
    'body': body,
    'tags': tags,
    'photos': photos
        .map((StoredPhoto p) => p.toJson())
        .toList(growable: false),
  };

  /// JSON에서 되돌린다. 해석할 수 없으면 null이다 — 예전 버전이 쓴 형식이거나
  /// 저장소가 손상된 경우이며, 그때는 조용히 빈 상태로 시작한다(R10-3).
  static StoredDraft? fromJson(Map<String, Object?> json) {
    final Object? savedAt = json['savedAt'];
    if (savedAt is! String) return null;
    final DateTime? parsed = DateTime.tryParse(savedAt);
    if (parsed == null) return null;

    final List<StoredPhoto> photos = <StoredPhoto>[];
    final Object? rawPhotos = json['photos'];
    if (rawPhotos is List) {
      for (final Object? entry in rawPhotos) {
        if (entry is! Map) return null;
        final StoredPhoto? photo = StoredPhoto.fromJson(
          entry.cast<String, Object?>(),
        );
        // 한 장이라도 해석되지 않으면 초안 전체가 복원 불가다 — 순서가 곧 표시
        // 순서라 중간을 건너뛰면 사용자가 붙인 것과 다른 목록이 된다(R3-4).
        if (photo == null) return null;
        photos.add(photo);
      }
    }

    return StoredDraft(
      savedAt: parsed,
      category: json['category'] as String?,
      // SPEC-0029 이전에 저장된 초안엔 없다 — null이면 장소 참조를 믿지 않는다.
      languageCode: json['languageCode'] as String?,
      spotId: json['spotId'] as String?,
      spotTitle: json['spotTitle'] as String?,
      title: json['title'] as String? ?? '',
      body: json['body'] as String? ?? '',
      tags:
          (json['tags'] as List<Object?>?)
              ?.whereType<String>()
              .toList(growable: false) ??
          const <String>[],
      photos: photos,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is StoredDraft &&
      other.savedAt == savedAt &&
      other.category == category &&
      other.languageCode == languageCode &&
      other.spotId == spotId &&
      other.spotTitle == spotTitle &&
      other.title == title &&
      other.body == body &&
      listEquals(other.tags, tags) &&
      listEquals(other.photos, photos);

  @override
  int get hashCode => Object.hash(
    savedAt,
    category,
    languageCode,
    spotId,
    spotTitle,
    title,
    body,
    Object.hashAll(tags),
    Object.hashAll(photos),
  );
}

/// 저장된 사진 한 장. [ComposerPhoto]와 1:1로 대응한다.
sealed class StoredPhoto {
  const StoredPhoto();

  static StoredPhoto fromComposerPhoto(ComposerPhoto photo) => switch (photo) {
    RemotePhoto(:final String objectKey) => StoredRemotePhoto(objectKey),
    LocalPhoto(
      :final String id,
      :final String name,
      :final String contentType,
      :final int contentLength,
    ) =>
      StoredLocalPhoto(
        id: id,
        name: name,
        contentType: contentType,
        contentLength: contentLength,
      ),
  };

  Map<String, Object?> toJson();

  /// 해석할 수 없으면 null. 알 수 없는 `type`도 여기 해당한다.
  static StoredPhoto? fromJson(Map<String, Object?> json) =>
      switch (json['type']) {
        'remote' => StoredRemotePhoto.fromJson(json),
        'local' => StoredLocalPhoto.fromJson(json),
        _ => null,
      };
}

/// 이미 서버에 올라간 사진. 키만 있으면 되고 파일이 따로 없다.
class StoredRemotePhoto extends StoredPhoto {
  const StoredRemotePhoto(this.objectKey);

  final String objectKey;

  @override
  Map<String, Object?> toJson() => <String, Object?>{
    'type': 'remote',
    'objectKey': objectKey,
  };

  static StoredRemotePhoto? fromJson(Map<String, Object?> json) {
    final Object? key = json['objectKey'];
    return key is String && key.isNotEmpty ? StoredRemotePhoto(key) : null;
  }

  RemotePhoto toComposerPhoto() => RemotePhoto(objectKey);

  @override
  bool operator ==(Object other) =>
      other is StoredRemotePhoto && other.objectKey == objectKey;

  @override
  int get hashCode => objectKey.hashCode;
}

/// 아직 올리지 않은 사진의 **메타만**. 바이트는 [id]에서 유도한 이름의 파일에 있다.
///
/// [contentLength]를 함께 두는 이유는 복원 후 실제 읽은 바이트 길이와 **대조하기**
/// 위해서다(R10-1). 이 값은 사전 서명에 들어가므로 1바이트만 달라도 스토리지가 403을
/// 낸다 — 등록 시점이 아니라 복원 시점에 잡아야 사용자가 업로드 실패를 겪지 않는다.
class StoredLocalPhoto extends StoredPhoto {
  const StoredLocalPhoto({
    required this.id,
    required this.name,
    required this.contentType,
    required this.contentLength,
  });

  /// 고를 때 부여한 식별자. 파일 이름이 이 값에서 나온다([fileName]).
  final String id;

  /// 표시 이름. 실패를 알릴 때 쓴다.
  final String name;

  final String contentType;

  /// 저장 당시의 실제 바이트 수.
  final int contentLength;

  /// 바이트를 담은 파일의 이름. **[id]에서 유도한다** — 이미 쓰여 있는 장을 다시
  /// 쓰지 않기 위해 이름이 안정적이어야 한다(§4).
  ///
  /// [id]는 사진 선택기가 만든 값이라 경로 구분자가 섞일 수 있으므로, 파일 이름으로
  /// 쓸 수 없는 문자는 `_`로 바꾼다 — 그대로 이어 붙이면 앱 전용 디렉토리 밖을
  /// 가리킬 수 있다.
  String get fileName => '${id.replaceAll(RegExp(r'[^A-Za-z0-9._-]'), '_')}.bin';

  @override
  Map<String, Object?> toJson() => <String, Object?>{
    'type': 'local',
    'id': id,
    'name': name,
    'contentType': contentType,
    'contentLength': contentLength,
  };

  static StoredLocalPhoto? fromJson(Map<String, Object?> json) {
    final Object? id = json['id'];
    final Object? contentType = json['contentType'];
    final Object? contentLength = json['contentLength'];
    if (id is! String || id.isEmpty) return null;
    if (contentType is! String || contentType.isEmpty) return null;
    if (contentLength is! int || contentLength < 0) return null;
    return StoredLocalPhoto(
      id: id,
      name: json['name'] as String? ?? '',
      contentType: contentType,
      contentLength: contentLength,
    );
  }

  /// 읽어 온 [bytes]로 편집용 사진을 되돌린다.
  LocalPhoto toComposerPhoto(Uint8List bytes) =>
      LocalPhoto(id: id, bytes: bytes, contentType: contentType, name: name);

  @override
  bool operator ==(Object other) =>
      other is StoredLocalPhoto &&
      other.id == id &&
      other.name == name &&
      other.contentType == contentType &&
      other.contentLength == contentLength;

  @override
  int get hashCode => Object.hash(id, name, contentType, contentLength);
}
