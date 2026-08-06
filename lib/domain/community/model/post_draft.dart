import '../../../common/model/list_equality.dart';
import 'composer_photo.dart';
import 'target_category.dart';

/// 제목 최대 길이(코드포인트).
const int maxPostTitleRunes = 50;

/// 본문 최대 길이. **서버는 코드포인트로 센다**(가이드 §8) — `String.length`(UTF-16)나
/// grapheme으로 세면 이모지가 든 본문에서 "499자인데 거부됨"이 난다.
const int maxPostBodyRunes = 500;

/// 태그 하나의 최대 길이(코드포인트).
const int maxPostTagRunes = 30;

/// 글 하나에 붙일 수 있는 태그 수. 넘기면 서버가 `TOO_MANY_TAGS`로 거부하므로
/// **입력 단계에서 미리 막는다**(가이드 §7).
const int maxPostTags = 5;

/// 글 하나에 붙일 수 있는 사진 수. 넘기면 `TOO_MANY_PHOTOS`다.
const int maxPostPhotos = 5;

/// 사진 한 장의 크기 상한(10 MiB). 넘기면 서버가 `UNSUPPORTED_CONTENT_TYPE`으로
/// 거부하는데, **1단계 발급은 하나만 어긋나도 전부 거부한다**(부분 발급이 없다).
/// 그래서 고른 직후 여기서 걸러야 큰 장 하나가 나머지를 같이 죽이지 않는다(가이드 §4).
const int maxPostPhotoBytes = 10 * 1024 * 1024;

/// 컴포저가 편집 중인 글 한 건(SPEC-0010). 순수 도메인 — 위젯·GraphQL·Riverpod
/// 의존 없음.
///
/// **등록 가능 여부를 이 모델이 판정한다**([canSubmit]). 서버 검증을 기다렸다가
/// 에러를 보여주는 방식이 아니라 화면이 애초에 잘못된 상태를 만들지 못하게 하기
/// 위해서다(디자인 §3).
///
/// **카테고리가 필수이고 장소는 선택이다**(가이드 §5) — 장소 없는 글이 허용된다.
/// 다만 그 글은 좌표 반경 조회에 잡히지 않는다(§10).
class PostDraft {
  const PostDraft({
    this.category,
    this.spotId,
    this.spotTitle,
    this.title = '',
    this.body = '',
    this.tags = const <String>[],
    this.photos = const <ComposerPhoto>[],
  });

  /// **필수.** 미선택이면 등록이 막힌다.
  final TargetCategory? category;

  /// 어느 장소에 붙는 글인지. **선택이다** — null이면 장소 없는 글로 등록된다.
  final String? spotId;

  /// 선택된 장소의 표시 이름. 서버에 보내지 않고 화면 표시에만 쓴다.
  final String? spotTitle;

  final String title;
  final String body;

  /// 사용자가 입력한 태그. 각 태그는 **공백을 포함할 수 없고**(`INVALID_TAG`)
  /// 30 코드포인트 이내여야 한다(가이드 §5).
  final List<String> tags;

  /// 붙인 사진. **이미 올라간 것([RemotePhoto])과 방금 고른 것([LocalPhoto])이
  /// 섞여 있고 순서가 곧 표시 순서다**(가이드 §4).
  ///
  /// 로컬 장의 업로드는 **등록/수정을 누를 때** 일어난다 — 고를 때마다 올리면 글을
  /// 쓰지 않고 나간 사용자의 사진이 고아 오브젝트로 남아 저장 비용이 든다.
  final List<ComposerPhoto> photos;

  /// 이미 확정된 키만 추린 목록. 아직 올리지 않은 로컬 장은 여기 없다.
  List<String> get remoteKeys => photos
      .whereType<RemotePhoto>()
      .map((RemotePhoto p) => p.objectKey)
      .toList(growable: false);

  /// 등록 시점에 올려야 할 장들. 순서를 보존한다.
  List<LocalPhoto> get pendingPhotos =>
      photos.whereType<LocalPhoto>().toList(growable: false);

  /// 사진을 더 붙일 수 있는 수. **두 종류를 함께 센다** — 서버 상한(5장)은 글에 붙는
  /// 최종 개수에 걸리므로 원격·로컬을 구분하지 않는다(가이드 §4).
  int get remainingPhotoSlots => maxPostPhotos - photos.length;

  /// 제목 길이(코드포인트). 화면 카운터가 이 값을 쓴다.
  int get titleRunes => title.runes.length;

  /// 본문 길이(코드포인트).
  int get bodyRunes => body.runes.length;

  /// 남은 본문 글자 수. 음수면 초과분이다 — 화면은 이 값을 **드러내고** 입력을
  /// 자르지 않는다(디자인 §3: 붙여넣기한 유저가 무엇이 사라졌는지 모르면 안 된다).
  int get remainingBodyRunes => maxPostBodyRunes - bodyRunes;

  int get remainingTitleRunes => maxPostTitleRunes - titleRunes;

  bool get isTitleTooLong => titleRunes > maxPostTitleRunes;

  bool get isBodyTooLong => bodyRunes > maxPostBodyRunes;

  /// 공백만 있는 제목은 빈 것으로 본다 — 서버도 `POST_TITLE_REQUIRED`로 거부한다.
  bool get hasTitle => title.trim().isNotEmpty;

  bool get hasBody => body.trim().isNotEmpty;

  /// 태그를 더 넣을 수 있는지. 상한에 닿으면 입력 자체를 막는다(가이드 §7).
  bool get canAddTag => tags.length < maxPostTags;

  /// 등록 버튼 활성 조건(가이드 §5): 카테고리가 골라졌고, 제목·본문이 비지 않았고,
  /// 길이가 넘지 않을 것. **장소는 조건이 아니다** — 선택 항목이다.
  bool get canSubmit =>
      category != null &&
      hasTitle &&
      !isTitleTooLong &&
      hasBody &&
      !isBodyTooLong;

  /// [value]가 태그로 유효한지. 공백이 하나라도 있으면 거부다 — "맛집 추천"이 한
  /// 태그인지 둘인지 애매해서 서버가 `INVALID_TAG`로 막는다(가이드 §5).
  ///
  /// 앞의 `#`은 서버가 제거하므로 클라이언트가 정규화할 필요가 없다.
  static bool isValidTag(String value) {
    final String trimmed = value.trim();
    if (trimmed.isEmpty) return false;
    if (trimmed.contains(RegExp(r'\s'))) return false;
    return trimmed.runes.length <= maxPostTagRunes;
  }

  PostDraft copyWith({
    TargetCategory? category,
    String? spotId,
    String? spotTitle,
    String? title,
    String? body,
    List<String>? tags,
    List<ComposerPhoto>? photos,
  }) => PostDraft(
    category: category ?? this.category,
    spotId: spotId ?? this.spotId,
    spotTitle: spotTitle ?? this.spotTitle,
    title: title ?? this.title,
    body: body ?? this.body,
    tags: tags ?? this.tags,
    photos: photos ?? this.photos,
  );

  /// 장소를 비운다. [copyWith]는 null을 "안 바꿈"으로 보기 때문에 해제 전용
  /// 생성자가 따로 필요하다.
  PostDraft withoutSpot() => PostDraft(
    category: category,
    title: title,
    body: body,
    tags: tags,
    photos: photos,
  );

  @override
  bool operator ==(Object other) =>
      other is PostDraft &&
      other.category == category &&
      other.spotId == spotId &&
      other.spotTitle == spotTitle &&
      other.title == title &&
      other.body == body &&
      listEquals(other.tags, tags) &&
      listEquals(other.photos, photos);

  @override
  int get hashCode => Object.hash(
    category,
    spotId,
    spotTitle,
    title,
    body,
    Object.hashAll(tags),
    Object.hashAll(photos),
  );
}
