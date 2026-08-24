import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

/// 앱 로거. `package:logger`를 그대로 쓴다.
///
/// **직접 만들지 않는다.** 수준 체계(trace/debug/info/warning/error/fatal)와
/// 필터·출력이 이미 검증된 라이브러리에 있고, 그것을 흉내 내는 코드를 저장소가
/// 떠안을 이유가 없다.
///
/// ```dart
/// final Logger _log = appLogger('SwipeController');
/// _log.i('큐를 다시 채운다: ${cards.length}장');
/// _log.w('반응 전송 실패 — 낙관적 제거를 되돌린다', error: error);
/// _log.e('세션 복구 불가', error: error, stackTrace: stackTrace);
/// ```
///
/// 메서드는 라이브러리 관례를 따른다 — `t`(trace) `d`(debug) `i`(info)
/// `w`(warning) `e`(error) `f`(fatal). **호출부에 `if (kDebugMode)`를 두르지
/// 않는다** — 무엇을 내보낼지는 아래 필터가 정한다.
///
/// **본문·토큰·PII를 넘기지 않는다**(CLAUDE.md §7). 이 로거는 받은 값을 그대로
/// 내보낼 뿐 가려 주지 않는다. 서버 오류 메시지는 PII를 담을 수 있어 provider
/// 계층은 `error.runtimeType`만 싣는다(POL-013). GraphQL 요청/응답 본문은 전용
/// 통로(`GraphqlDebugLog`)가 마스킹과 디버그 전용 처리를 함께 맡는다.
Logger appLogger(String name) => Logger(
  filter: _AppLogFilter(),
  printer: AppLogPrinter(name),
  output: ConsoleOutput(),
);

/// 무엇을 내보낼지 정하는 단 한 곳.
///
/// **릴리스에서도 `warning` 이상은 남긴다.** 라이브러리 기본값([DevelopmentFilter])은
/// 릴리스에서 전부 끄는데, 그러면 실기기에서 무엇이 잘못됐는지 볼 방법이 사라진다 —
/// 지도가 조용히 비는 종류의 장애가 그렇게 묻혔다.
///
/// 반대로 `info`까지 내보내면 정상 흐름이 전부 기기 로그(안드로이드 logcat)에 쌓여
/// 다른 앱이 읽을 수 있고, 정작 필요한 오류가 그 안에 묻힌다.
class _AppLogFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) =>
      event.level.value >= (kDebugMode ? Level.debug : Level.warning).value;
}

/// 한 줄 출력. `[이름] 메시지` 뒤에 오류와 스택트레이스를 잇는다.
///
/// [PrettyPrinter]의 박스·이모지를 쓰지 않는 이유는 여러 줄로 늘어나 실기기
/// 로그에서 다른 로그와 뒤섞이기 때문이다. 출처를 이름으로 묶는 것으로 충분하다.
///
/// **공개해 둔 것은 형식이 계약이기 때문이다** — 테스트가 사본을 만들어 검사하면
/// 정작 실물이 바뀌어도 통과한다. 로거를 만드는 것은 [appLogger]를 쓰고, 이
/// 클래스를 직접 인스턴스화하지 않는다.
@visibleForTesting
class AppLogPrinter extends LogPrinter {
  AppLogPrinter(this.name);

  final String name;

  @override
  List<String> log(LogEvent event) => <String>[
    '[$name] ${event.message}',
    if (event.error != null) '  error: ${event.error}',
    if (event.stackTrace != null) '${event.stackTrace}',
  ];
}
