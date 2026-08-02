import 'package:shared_preferences/shared_preferences.dart';

/// 언어가 이미 선택된 상태의 앱 환경설정을 세운다(e2e-flow-testing skill §7 — 시작
/// 상태 명시적 확립). 민감한 값은 여기 들어가지 않는다: 인증에 필요한 값은 오직
/// SecureStorage를 통해서만 세운다(CLAUDE.md §7).
Future<SharedPreferences> seededLanguagePrefs() async {
  SharedPreferences.setMockInitialValues(<String, Object>{'locale': 'en'});
  return SharedPreferences.getInstance();
}
