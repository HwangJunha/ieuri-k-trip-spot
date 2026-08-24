import 'package:logger/logger.dart';

/// 앱 로거. `package:logger`를 그대로 쓴다.
///
/// ```dart
/// final Logger _log = appLogger('SwipeController');
/// _log.i('큐를 다시 채운다: ${cards.length}장');
/// _log.w('반응 전송 실패 — 낙관적 제거를 되돌린다', error: error);
/// _log.e('세션 복구 불가', error: error, stackTrace: stackTrace);
/// ```
///
/// 메서드는 라이브러리 관례를 따른다 — `t`(trace) `d`(debug) `i`(info)
/// `w`(warning) `e`(error) `f`(fatal).
///
/// **필터를 손대지 않는다.** 기본 [DevelopmentFilter]가 디버그 빌드에서는
/// `Logger.level` 이상을 내보내고 **릴리스에서는 전부 끈다** — 로그는 개발용이고
/// 사용자 기기에 남길 것이 아니다. 수준 조절이 필요하면 `Logger.level`을 바꾼다.
///
/// **본문·토큰·PII를 넘기지 않는다**(CLAUDE.md §7). 이 로거는 받은 값을 그대로
/// 내보낼 뿐 가려 주지 않는다. 서버 오류 메시지는 PII를 담을 수 있어 provider
/// 계층은 `error.runtimeType`만 싣는다(POL-013). GraphQL 요청/응답 본문은 전용
/// 통로(`GraphqlDebugLog`)가 마스킹과 디버그 전용 처리를 함께 맡는다.
Logger appLogger(String name) => Logger(printer: AppLogPrinter(name));

/// 한 줄 출력. `[이름] 메시지` 뒤에 오류와 스택트레이스를 잇는다.
///
/// [PrettyPrinter]의 박스·이모지를 쓰지 않는 이유는 여러 줄로 늘어나 실기기
/// 로그에서 다른 로그와 뒤섞이기 때문이다. 출처를 이름으로 묶는 것으로 충분하다.
///
/// **공개해 둔 것은 형식이 계약이기 때문이다** — 테스트가 사본을 만들어 검사하면
/// 정작 실물이 바뀌어도 통과한다. 로거를 만드는 것은 [appLogger]를 쓰고, 이
/// 클래스를 직접 인스턴스화하지 않는다.
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
