import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// 질문별로 "마지막에 본 답변 수"를 적어 두는 로컬 저장소.
///
/// **서버에 읽음 지점이 없어서 존재한다.** `SpotQuestion.answerCount`는 누적값이라
/// 내가 어디까지 봤는지를 서버가 모른다 — 알림도 없는 지금, 「새 답변」을 알리려면
/// 마지막으로 본 수를 클라이언트가 들고 비교하는 수밖에 없다.
///
/// **질문 목록 자체는 여기 없다.** 목록은 서버(`spotQuestions(mine: true)`)가 소스이며,
/// 이 저장소가 비어 있어도 목록은 정상이고 배지만 안 뜬다 — 목록의 정확성을 로컬
/// 상태에 걸지 않는다.
///
/// 서버가 질문별 읽음 지점을 갖게 되면 이 파일은 삭제한다.
///
/// 토큰이 아니라 화면 표시용 카운터라 `flutter_secure_storage`가 아니라
/// [SharedPreferences]를 쓴다(CLAUDE.md §7의 대상은 토큰·비밀값이다).
abstract interface class SeenAnswerCountsStore {
  /// `questionId → 마지막에 본 답변 수`. 저장된 적이 없으면 빈 맵이다.
  Map<String, int> read();

  Future<void> write(Map<String, int> counts);
}

/// [SharedPreferences] 기반 구현.
class SharedPreferencesSeenAnswerCountsStore implements SeenAnswerCountsStore {
  SharedPreferencesSeenAnswerCountsStore(this._prefs);

  final SharedPreferences _prefs;

  static const String _key = 'spot_qa_seen_answer_counts';

  /// 질문 수가 늘어도 저장소가 무한정 자라지 않게 상한을 둔다. 넘으면 오래된 항목이
  /// 아니라 **임의로** 잘리는데, 어차피 목록에 없는 질문의 기록은 쓸모가 없다.
  static const int _maxEntries = 200;

  @override
  Map<String, int> read() {
    final String? raw = _prefs.getString(_key);
    if (raw == null || raw.isEmpty) return const <String, int>{};
    try {
      final Object? decoded = jsonDecode(raw);
      if (decoded is! Map<String, dynamic>) return const <String, int>{};
      return <String, int>{
        for (final MapEntry<String, dynamic> e in decoded.entries)
          if (e.value is int) e.key: e.value as int,
      };
    } on FormatException {
      // 깨진 기록은 버린다 — 배지가 한 번 잘못 뜨는 것이 화면이 죽는 것보다 낫다.
      return const <String, int>{};
    }
  }

  @override
  Future<void> write(Map<String, int> counts) {
    final Map<String, int> bounded = counts.length <= _maxEntries
        ? counts
        : Map<String, int>.fromEntries(counts.entries.take(_maxEntries));
    return _prefs.setString(_key, jsonEncode(bounded));
  }
}
