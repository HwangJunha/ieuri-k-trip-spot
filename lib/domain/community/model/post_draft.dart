import 'post_topic.dart';

/// 본문 최대 길이. **서버는 코드포인트로 센다**(가이드 §12) — `String.length`(UTF-16)나
/// grapheme으로 세면 이모지가 든 본문에서 "499자인데 거부됨"이 난다.
const int maxPostBodyRunes = 500;

/// 컴포저가 편집 중인 글 한 건(SPEC-0010 R1~R4). 순수 도메인 — 위젯·GraphQL·Riverpod
/// 의존 없음.
///
/// **등록 가능 여부를 이 모델이 판정한다**([canSubmit]). 서버 검증을 기다렸다가
/// 에러를 보여주는 방식이 아니라 화면이 애초에 잘못된 상태를 만들지 못하게 하기
/// 위해서다(설계 §3, R1-1).
class PostDraft {
  const PostDraft({
    this.targetType = 'SPOT',
    this.targetId,
    this.targetTitle,
    this.topic,
    this.body = '',
    this.photoKeys = const <String>[],
  });

  /// 대상 종류. **값으로 다룬다** — 지금은 `SPOT` 하나뿐이지만 늘어날 자리가 열려
  /// 있어 하드코딩하지 않는다(가이드 §1).
  final String targetType;

  /// 어느 대상(관광지)에 붙는 글인지. 미선택이면 null이고 등록이 막힌다.
  final String? targetId;

  /// 선택된 대상의 표시 이름. 서버에 보내지 않고 화면 표시에만 쓴다.
  final String? targetTitle;

  final PostTopic? topic;
  final String body;

  /// **최종 키**(`images/...`)만 담는다. 1단계가 준 `pending/...` 키를 그대로 넘기면
  /// 서버가 `PHOTO_NOT_UPLOADED`로 거부한다(가이드 §3-(2)).
  final List<String> photoKeys;

  /// 본문 길이(코드포인트). 화면의 잔여 카운터가 이 값을 쓴다.
  int get bodyRunes => body.runes.length;

  /// 남은 글자 수. 음수면 초과분이다 — 화면은 이 값을 **드러내고** 입력을 자르지
  /// 않는다(설계 §3: 붙여넣기한 유저가 무엇이 사라졌는지 모르면 안 된다).
  int get remainingRunes => maxPostBodyRunes - bodyRunes;

  bool get isBodyTooLong => bodyRunes > maxPostBodyRunes;

  /// 공백만 있는 본문은 빈 것으로 본다 — 서버도 `POST_BODY_REQUIRED`로 거부한다.
  bool get hasBody => body.trim().isNotEmpty;

  /// 등록 버튼 활성 조건: 대상·태그·본문이 모두 갖춰지고 길이가 넘지 않을 것(R1-1).
  bool get canSubmit =>
      targetId != null && topic != null && hasBody && !isBodyTooLong;

  PostDraft copyWith({
    String? targetType,
    String? targetId,
    String? targetTitle,
    PostTopic? topic,
    String? body,
    List<String>? photoKeys,
  }) => PostDraft(
    targetType: targetType ?? this.targetType,
    targetId: targetId ?? this.targetId,
    targetTitle: targetTitle ?? this.targetTitle,
    topic: topic ?? this.topic,
    body: body ?? this.body,
    photoKeys: photoKeys ?? this.photoKeys,
  );

  @override
  bool operator ==(Object other) =>
      other is PostDraft &&
      other.targetType == targetType &&
      other.targetId == targetId &&
      other.targetTitle == targetTitle &&
      other.topic == topic &&
      other.body == body;

  @override
  int get hashCode =>
      Object.hash(targetType, targetId, targetTitle, topic, body);
}
