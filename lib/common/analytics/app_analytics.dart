import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:logger/logger.dart';

import '../log/app_log.dart';

/// 사용량 집계(DAU·MAU·유지율·화면 조회·주요 행동).
///
/// ## 설정이 없으면 조용히 빠진다
///
/// `PushInitializer`와 **같은 규칙**이다. Firebase 설정 파일(`google-services.json` ·
/// `GoogleService-Info.plist`)은 환경마다 값이 달라 커밋하지 않으므로, 파일이 없는
/// 상태가 정상적으로 일어난다. 그때 집계는 빠지고 앱은 그대로 동작한다 — 통계를 위해
/// 앱이 죽는 것은 본말전도다.
///
/// **모든 호출이 실패해도 안전하다.** 각 메소드가 예외를 삼키므로 호출부는 성공을
/// 따지지 않는다. 집계 실패로 사용자 행동이 막히면 안 된다.
///
/// ## 개인정보를 싣지 않는다
///
/// 이벤트 파라미터에 **회원 id·이메일·닉네임·좌표를 넣지 않는다**(§7과 같은 취지).
/// Firebase는 국가·기기·앱 버전을 자동으로 붙이므로 사용자를 특정할 값을 더할 이유가
/// 없다. 검색어처럼 사용자가 입력한 문자열도 그대로 싣지 않는다 — 어떤 종류의
/// 검색이었는지와 결과 유무만 남긴다.
abstract final class AppAnalytics {
  static final Logger _log = appLogger('AppAnalytics');

  /// 집계가 실제로 붙었는지. Firebase 설정이 없으면 거짓이다.
  static bool get isReady => _analytics != null;
  static FirebaseAnalytics? _analytics;

  /// Firebase 초기화 **뒤에** 부른다(`PushInitializer.ensureInitialized` 다음).
  ///
  /// 앱 기동을 막지 않는다 — 실패하면 [isReady]가 거짓으로 남고 이후 호출이 전부
  /// 무시된다.
  static void ensureInitialized() {
    if (_analytics != null) return;
    try {
      _analytics = FirebaseAnalytics.instance;
    } on Object catch (error, stackTrace) {
      _log.w(
        '집계를 건너뛴다 — Firebase 설정이 없거나 잘못됐다. 앱은 그대로 동작한다',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  /// 화면 조회. 라우터 observer가 부른다(→[AnalyticsRouteObserver]).
  static Future<void> logScreen(String name) => _guard(
    () => _analytics!.logScreenView(screenName: name),
    what: 'screen:$name',
  );

  /// 주요 행동 하나.
  ///
  /// [name]은 Firebase 표준 이벤트가 있으면 그 이름을 쓴다(`login`·`search`·`share`
  /// 등) — 표준 이름이어야 콘솔이 별도 설정 없이 리포트를 만든다.
  static Future<void> logEvent(
    String name, [
    Map<String, Object>? parameters,
  ]) => _guard(
    () => _analytics!.logEvent(name: name, parameters: parameters),
    what: name,
  );

  /// **집계 실패는 앱의 실패가 아니다.** 네트워크·설정·플랫폼 어느 쪽이 터지든
  /// 삼키고, 디버그로만 남긴다 — 경고로 남기면 오프라인일 때 진짜 오류를 로그에서
  /// 밀어낸다.
  static Future<void> _guard(
    Future<void> Function() action, {
    required String what,
  }) async {
    if (_analytics == null) return;
    try {
      await action();
    } on Object catch (error) {
      _log.d('집계 실패($what): ${error.runtimeType}');
    }
  }
}
