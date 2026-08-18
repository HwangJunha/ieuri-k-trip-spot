import 'package:shared_preferences/shared_preferences.dart';

import '../model/my_question_ref.dart';

/// 로컬에 들고 있을 내 질문 개수 상한.
///
/// 목록이 길어질수록 답을 기다리는 최근 질문을 찾기 어려워진다. 서버에 `myQuestions`가
/// 생기면 상한 자체가 필요 없어진다.
const int myQuestionsLimit = 50;

/// 내가 올린 질문의 로컬 기록(임시).
///
/// **서버에 작성자 기준 조회가 없어서 존재한다** — 자세한 근거와 폐기 계획은
/// [MyQuestionRef] 주석에 있다.
///
/// 토큰이 아니라 일반 기록이라 `flutter_secure_storage`가 아니라 [SharedPreferences]를
/// 쓴다(CLAUDE.md §7의 대상은 토큰·비밀값이다).
///
/// **인터페이스로 둔 이유**는 notifier 단위 테스트가 저장소를 교체할 수 있게 하기
/// 위해서다. provider 선언은 `provider/` 계층이 갖는다.
abstract interface class MyQuestionsStore {
  /// 최신순으로 읽는다. 저장된 적이 없으면 빈 목록이다.
  List<MyQuestionRef> read();

  /// 목록을 통째로 저장한다(호출부가 순서·상한을 이미 적용한 상태로 넘긴다).
  Future<void> write(List<MyQuestionRef> refs);
}

/// [SharedPreferences] 기반 구현.
class SharedPreferencesMyQuestionsStore implements MyQuestionsStore {
  SharedPreferencesMyQuestionsStore(this._prefs);

  final SharedPreferences _prefs;

  static const String _key = 'spot_qa_my_questions';

  @override
  List<MyQuestionRef> read() {
    final List<String>? raw = _prefs.getStringList(_key);
    if (raw == null) return const <MyQuestionRef>[];
    // 깨진 항목은 조용히 버린다 — 하나 때문에 목록 전체를 잃지 않는다.
    return raw
        .map(MyQuestionRef.decode)
        .whereType<MyQuestionRef>()
        .toList(growable: false);
  }

  @override
  Future<void> write(List<MyQuestionRef> refs) => _prefs.setStringList(
    _key,
    refs.map((MyQuestionRef r) => r.encode()).toList(growable: false),
  );
}
