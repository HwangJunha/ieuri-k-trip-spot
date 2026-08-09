import 'package:shared_preferences/shared_preferences.dart';

/// 최근 검색어를 몇 개까지 들고 있을지(R12).
///
/// 목록이 길어질수록 최근 항목을 찾기 어려워지고, 화면에서도 접히지 않고 계속
/// 늘어난다. 10개면 직전 세션의 검색을 되짚기에 충분하다.
const int recentSearchesLimit = 10;

/// 최근 검색어의 로컬 저장소(R12).
///
/// **서버에 저장하지 않는다** — 계약에 해당 필드가 없고, 검색 기록 서버 저장은
/// 스펙 범위 밖이다. 토큰이 아니라 일반 설정 성격의 데이터라
/// `flutter_secure_storage`가 아니라 [SharedPreferences]를 쓴다(CLAUDE.md §7의
/// 대상은 토큰·비밀값이다).
///
/// **`common/`이 아니라 여기 있는 이유**는 최근 *spot* 검색어를 쓰는 곳이
/// `domain/spot` 하나이기 때문이다 — 둘 이상이 쓰기 전에는 기능 안에 둔다
/// (CLAUDE.md §4). 다른 표면이 검색 기록을 읽게 되면 그때 `common/`으로 올린다.
///
/// **인터페이스로 둔 이유**는 notifier 단위 테스트가 저장소를 교체할 수 있게
/// 하기 위해서다(설계 §3). AC-12.2("앱 재시작 후 유지")도 위젯을 재시작하는 대신
/// 저장소를 다시 읽어 검증한다.
///
/// provider 선언은 `provider/` 계층이 갖는다 — 다른 repository와 같은 자리다
/// (CLAUDE.md §3). 이 파일은 순수 Dart로 남는다.
abstract interface class RecentSearchesStore {
  /// 최근 검색어를 최신순으로 읽는다. 저장된 적이 없으면 빈 목록이다.
  List<String> read();

  /// 목록을 통째로 저장한다(호출부가 순서·상한을 이미 적용한 상태로 넘긴다).
  Future<void> write(List<String> queries);
}

/// [SharedPreferences] 기반 구현.
class SharedPreferencesRecentSearchesStore implements RecentSearchesStore {
  SharedPreferencesRecentSearchesStore(this._prefs);

  final SharedPreferences _prefs;

  static const String _key = 'recent_searches';

  @override
  List<String> read() => _prefs.getStringList(_key) ?? const <String>[];

  @override
  Future<void> write(List<String> queries) =>
      _prefs.setStringList(_key, queries);
}
