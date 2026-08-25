import 'package:kakao_map_sdk/kakao_map_sdk.dart';
import 'package:logger/logger.dart';

import '../log/app_log.dart';
import 'kakao_config.dart';

/// 지도 SDK 1회 초기화. `main()`이 **시작만 시키고 기다리지 않는다**(설계 §10).
///
/// ## 왜 `runApp`을 막지 않는가 (2026-08-25)
///
/// 지도는 5개 탭 중 하나인데 예전에는 이 초기화가 끝나야 첫 프레임이 나왔다.
/// `KakaoMapSdk.initialize`는 네이티브 SDK 인증이라 **네트워크를 탈 수 있고**(아래
/// catch 주석이 그 사실을 이미 적고 있다), 그동안 홈·발견을 포함한 앱 전체가
/// 스플래시에 묶인다 — 지도 탭에 들어가지도 않았는데.
///
/// 그래서 `main`은 [start]로 발사만 하고, 실제로 지도가 필요한 화면이 [ready]를
/// 기다린다. **초기화 순서나 성공/실패 처리는 그대로다** — 기다리는 주체만 바뀐다.
///
/// **`common/`에 있는 이유**: 이것은 데이터 접근이 아니라 앱 부트스트랩이다.
/// `domain/map/repository/`에 두면 지도 화면이 자기 repository를 import하게 되어
/// 계층 규칙을 어긴다(CLAUDE.md §3 — view는 repository를 import하지 않는다).
/// 로그인의 `SnsInitializer`가 auth 도메인 안에 있는 것과 달리, 이 값은 화면이
/// 직접 읽어야 해서 자리가 다르다.
///
/// 초기화 방침은 `SnsInitializer`와 같다 — 키가 없으면 건너뛰고 앱은 정상 기동한다.
/// 지도 화면만 안내를 띄운다. 키 하나가 빠졌다고 앱 전체가 뜨지 않으면 다른 기능까지
/// 못 쓴다.
///
/// 로그인과 **같은 네이티브 앱 키**를 쓰지만 SDK가 달라 초기화도 각각 필요하다
/// (`KakaoSdk.init`은 로그인용, 이쪽은 지도용).
abstract final class MapSdkInitializer {
  static final Logger _log = appLogger('MapSdkInitializer');

  /// 초기화에 성공했는가. 지도 화면이 이 값을 보고 안내로 대체할지 정한다.
  ///
  /// 키가 없거나 SDK가 인증에 실패하면 거짓이다.
  ///
  /// **초기화가 끝나기 전에는 아직 거짓이다** — 이 값만 보고 화면을 그리면 초기화
  /// 중인 것과 실패한 것을 구별하지 못한다. 화면은 [ready]를 먼저 기다린다.
  static bool get isReady => _isReady;
  static bool _isReady = false;

  /// 진행 중이거나 완료된 초기화. [start] 전에는 null이다.
  static Future<void>? _initialization;

  /// 초기화를 시작한다(중복 호출은 같은 Future를 돌려준다). **기다리지 않는다** —
  /// `main`이 이것을 부르고 곧바로 `runApp`으로 간다.
  static Future<void> start() => _initialization ??= _initialize();

  /// 초기화가 끝날 때까지 기다린다. 지도가 필요한 화면이 부른다.
  ///
  /// [start]가 아직 안 불렸으면 여기서 시작한다 — 호출 순서에 의존하지 않는다.
  static Future<void> ready() => start();

  static Future<void> _initialize() async {
    if (!KakaoConfig.isConfigured) {
      // 키가 없으면 지도는 반드시 실패한다. `--dart-define-from-file` 인자가
      // 빠졌을 때 가장 먼저 확인할 신호다.
      _log.w(
        'KAKAO_NATIVE_APP_KEY가 비어 지도 SDK 초기화를 건너뛴다 — '
        '지도 화면은 안내를 표시한다',
      );
      return;
    }

    try {
      await KakaoMapSdk.instance.initialize(KakaoConfig.nativeAppKey);
      _isReady = true;
    } on Exception catch (error, stackTrace) {
      // 키 해시가 등록되지 않았거나 네트워크가 없으면 여기로 온다. 앱 기동을
      // 막지 않고 지도 화면이 안내를 띄우게 둔다.
      _log.e('지도 SDK 초기화 실패', error: error, stackTrace: stackTrace);
    }
  }
}
