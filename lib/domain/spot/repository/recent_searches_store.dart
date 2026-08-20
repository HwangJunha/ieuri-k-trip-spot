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
///
/// **저장 키에 언어를 포함한다**(SPEC-0029 R-21). 검색 결과가 활성 언어의 장소로
/// 한정되므로, 한 목록을 언어끼리 공유하면 EN에서 남긴 질의가 JA에서 아무것도 찾지
/// 못하는 항목으로 남는다.
///
/// **언어가 바뀔 때 비우지 않고 가른다.** 비우면 EN으로 돌아왔을 때 이력이 사라지는데,
/// 사용자가 지운 적이 없는 기록이다. 언어별로 따로 두면 오갈 때마다 각자의 이력이
/// 그대로 있다.
class SharedPreferencesRecentSearchesStore implements RecentSearchesStore {
  SharedPreferencesRecentSearchesStore(this._prefs, this._languageCode);

  final SharedPreferences _prefs;

  /// 활성 언어 코드(`en`·`ko`·`ja`·`zh`). 저장 키의 접미사가 된다.
  final String _languageCode;

  static const String _keyPrefix = 'recent_searches';

  /// SPEC-0029 이전의 언어 무관 키. 여기 남아 있던 이력은 읽지 않는다 — 그때의
  /// 결과는 번역본이 섞인 다른 축의 목록이라, 지금 언어의 이력이라고 주장할 근거가
  /// 없다.
  String get _key => '${_keyPrefix}_$_languageCode';

  @override
  List<String> read() => _prefs.getStringList(_key) ?? const <String>[];

  @override
  Future<void> write(List<String> queries) =>
      _prefs.setStringList(_key, queries);
}
