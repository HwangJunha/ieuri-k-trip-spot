import 'dart:convert';

/// 내가 올린 질문 하나의 로컬 기록.
///
/// **서버에 `myQuestions`가 없어서 존재한다.** 라이브 스키마에 작성자로 질문을 찾는
/// 수단이 전혀 없다(`myQuestions`·`myAnswers`·`spotQuestions(authorId:)` 모두 없음).
/// 그래서 클라이언트가 작성 시점에 스스로 적어 두지 않으면 **내가 어디에 질문했는지
/// 영영 알 수 없다** — 답변이 달려도 확인할 경로가 없다.
///
/// 계약 변경을 요청해 두었고
/// (`problem/SPEC-0026-SERVER-question-eligibility-and-my-questions.md`),
/// `myQuestions`가 생기면 이 저장소는 **삭제한다.** 서버가 정답을 주는데 클라이언트가
/// 따로 기록을 쥐고 있으면 둘이 어긋날 때 판단 근거가 없다.
///
/// 한계를 분명히 해 둔다: 기기를 바꾸거나 앱을 지우면 사라지고, 같은 계정을 두 기기에서
/// 쓰면 각자 다른 목록을 본다. 임시방편이다.
///
/// 순수 도메인 모델 — 위젯·GraphQL·Riverpod 의존 없음.
class MyQuestionRef {
  const MyQuestionRef({
    required this.catalogId,
    required this.questionId,
    required this.spotTitle,
    required this.askedAt,
    this.seenAnswerCount = 0,
  });

  /// 이 질문이 달린 장소. 다시 조회할 때 `spotQuestions(catalogId:)`에 넘긴다.
  final String catalogId;

  final String questionId;

  /// 작성 시점의 장소명. 목록에서 바로 보여줘 다시 조회하기 전에도 무엇인지 알린다 —
  /// 장소명이 나중에 바뀌어도 이 값이 틀렸다고 볼 일은 없다(내가 물었던 그 장소다).
  final String spotTitle;

  final DateTime askedAt;

  /// 마지막으로 이 질문을 열어 봤을 때의 답변 수.
  ///
  /// 지금 서버 값이 이보다 크면 **내가 못 본 답변이 있다**는 뜻이다. 알림이 없는
  /// 상태에서 "답이 달렸다"를 알리는 유일한 신호라 이 값을 들고 있는다.
  final int seenAnswerCount;

  MyQuestionRef copyWith({int? seenAnswerCount}) => MyQuestionRef(
    catalogId: catalogId,
    questionId: questionId,
    spotTitle: spotTitle,
    askedAt: askedAt,
    seenAnswerCount: seenAnswerCount ?? this.seenAnswerCount,
  );

  /// 한 줄 JSON으로 저장한다. **구분자를 쓰지 않는 이유**는 장소명에 무엇이 들어올지
  /// 알 수 없기 때문이다 — 쉼표든 제어문자든 언젠가 섞이면 형식이 깨진다.
  String encode() => jsonEncode(<String, Object>{
    'c': catalogId,
    'q': questionId,
    't': spotTitle,
    'a': askedAt.toUtc().toIso8601String(),
    's': seenAnswerCount,
  });

  /// 형식이 깨진 항목은 null이다 — 하나가 망가졌다고 목록 전체를 잃지 않는다.
  static MyQuestionRef? decode(String raw) {
    final Object? decoded = _tryJson(raw);
    if (decoded is! Map<String, dynamic>) return null;

    final Object? catalogId = decoded['c'];
    final Object? questionId = decoded['q'];
    final Object? askedAtRaw = decoded['a'];
    if (catalogId is! String ||
        questionId is! String ||
        askedAtRaw is! String) {
      return null;
    }
    final DateTime? askedAt = DateTime.tryParse(askedAtRaw);
    if (askedAt == null) return null;

    return MyQuestionRef(
      catalogId: catalogId,
      questionId: questionId,
      // 장소명이 유실돼도 질문 자체는 살린다 — 목록에서 장소명만 비어 보인다.
      spotTitle: decoded['t'] is String ? decoded['t'] as String : '',
      askedAt: askedAt.toLocal(),
      seenAnswerCount: decoded['s'] is int ? decoded['s'] as int : 0,
    );
  }

  static Object? _tryJson(String raw) {
    try {
      return jsonDecode(raw);
    } on FormatException {
      return null;
    }
  }

  @override
  bool operator ==(Object other) =>
      other is MyQuestionRef &&
      other.catalogId == catalogId &&
      other.questionId == questionId &&
      other.spotTitle == spotTitle &&
      // **시각은 순간으로 비교한다.** `DateTime.==`는 UTC 플래그까지 보는데
      // [encode]는 UTC로 쓰고 [decode]는 로컬로 읽으므로, 그대로 비교하면 같은
      // 순간을 저장했다 읽은 값이 서로 다르다고 나온다.
      other.askedAt.isAtSameMomentAs(askedAt) &&
      other.seenAnswerCount == seenAnswerCount;

  @override
  int get hashCode => Object.hash(
    catalogId,
    questionId,
    spotTitle,
    askedAt.microsecondsSinceEpoch,
    seenAnswerCount,
  );
}
