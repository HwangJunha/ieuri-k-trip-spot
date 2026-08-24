import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';

/// 로그 수준. logback의 `TRACE < DEBUG < INFO < WARN < ERROR`와 같은 순서다.
///
/// `dart:developer`의 `log(level:)`은 정수를 받는데, 그 값은 `package:logging`의
/// 관례를 따른다 — DevTools가 그 눈금으로 색을 칠하므로 임의 값을 쓰지 않는다.
enum LogLevel {
  debug._(500),
  info._(800),
  warn._(900),
  error._(1000);

  const LogLevel._(this.value);

  /// `dart:developer`에 넘길 수준 값.
  final int value;
}

/// 앱 로거. **호출부는 수준만 고르고 조건은 걸지 않는다.**
///
/// 예전에는 로그마다 `if (kDebugMode) debugPrint('[Tag] ...')`를 손으로 둘렀다.
/// 그 방식의 문제는 셋이다 — 조건이 호출부에 흩어져 빠뜨리기 쉽고, 태그를 문자열로
/// 매번 다시 적어 표기가 갈리며, 수준 개념이 없어 "이건 경고인가 오류인가"가
/// 코드에 남지 않는다. **무엇을 내보낼지는 로거가 정한다**(서버의 log4j/logback과
/// 같은 구조다).
///
/// ```dart
/// final AppLog _log = AppLog('SwipeController');
/// _log.info('큐를 다시 채운다: ${cards.length}장');
/// _log.warn('반응 전송 실패 — 낙관적 제거를 되돌린다', error);
/// _log.error('세션 복구 불가', error, stackTrace);
/// ```
///
/// **릴리스에서 무엇이 나가는가.** 기본값은 `warn` 이상만 남긴다(§보안 규칙과
/// 맞물린다 — 아래 참고). 디버그 빌드는 `debug`부터 전부 낸다.
///
/// **본문·토큰·PII를 넘기지 않는다**(CLAUDE.md §7). 이 로거는 받은 문자열을
/// 그대로 내보낼 뿐 가려 주지 않는다. GraphQL 요청/응답 본문은 전용 통로
/// (`GraphqlDebugLog`)가 마스킹과 디버그 전용 처리를 함께 맡는다.
class AppLog {
  const AppLog(this.name);

  /// 로그 출처. DevTools가 이 이름으로 묶어 준다 — 클래스명을 그대로 쓴다.
  final String name;

  /// 릴리스 빌드에서 남길 최소 수준.
  ///
  /// **`warn`인 이유**: `info`까지 내보내면 정상 흐름이 전부 기기 로그에 쌓여
  /// 사용자 기기에서 다른 앱이 읽을 수 있고(안드로이드 logcat), 정작 필요한
  /// 오류가 그 안에 묻힌다. 릴리스에서 보고 싶은 것은 "무엇이 잘못됐나"다.
  static const LogLevel _releaseMinimum = LogLevel.warn;

  /// 상세 추적. 개발 중에만 의미 있는 값(좌표, 큐 길이 등)에 쓴다.
  void debug(String message) => _emit(LogLevel.debug, message);

  /// 정상 흐름의 이정표. "무엇이 일어났다"를 남긴다.
  void info(String message) => _emit(LogLevel.info, message);

  /// 예상 범위 안의 실패. 앱은 계속 동작하지만 알아 둘 값어치가 있는 것.
  void warn(String message, [Object? error, StackTrace? stackTrace]) =>
      _emit(LogLevel.warn, message, error, stackTrace);

  /// 기능이 실제로 깨진 실패.
  void error(String message, [Object? error, StackTrace? stackTrace]) =>
      _emit(LogLevel.error, message, error, stackTrace);

  void _emit(
    LogLevel level,
    String message, [
    Object? error,
    StackTrace? stackTrace,
  ]) {
    // **조건은 여기 한 곳뿐이다.** 호출부가 수준만 고르면 되도록.
    if (!kDebugMode && level.value < _releaseMinimum.value) return;
    developer.log(
      message,
      name: name,
      level: level.value,
      error: error,
      stackTrace: stackTrace,
    );
  }
}
