import 'package:flutter/widgets.dart';

import 'app_analytics.dart';

/// 화면 전환을 집계로 옮기는 observer.
///
/// `MaterialApp.router`의 `observers`에 얹으면 push/pop/replace가 전부 여기로 온다 —
/// 화면마다 `initState`에 한 줄씩 넣는 방식은 빠뜨리기 쉽고, 뒤로 가기로 되돌아온
/// 화면을 놓친다.
///
/// ## 경로를 화면 이름으로 정규화한다
///
/// 라우트 경로에는 id가 박혀 있다(`/spot/1234`·`/post/5678`). 그대로 실으면 **스팟
/// 하나하나가 다른 화면으로 잡혀** 콘솔에 수천 개의 화면이 생기고, "상세를 몇 번
/// 봤나"를 셀 수 없게 된다. 숫자로만 이뤄진 구간을 `:id`로 바꿔 하나로 묶는다.
///
/// **id를 지우는 것은 개인정보 측면에서도 맞다**(→`AnalyticsEvents` 주석). 어떤
/// 사용자가 어느 게시글을 봤는지는 집계에 필요 없다.
class AnalyticsRouteObserver extends NavigatorObserver {
  @override
  void didPush(Route<Object?> route, Route<Object?>? previousRoute) {
    super.didPush(route, previousRoute);
    _log(route);
  }

  @override
  void didReplace({Route<Object?>? newRoute, Route<Object?>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (newRoute != null) _log(newRoute);
  }

  /// 뒤로 가기로 **되돌아온** 화면도 조회다. 이것을 빼면 목록↔상세를 오간 사용자의
  /// 목록 조회가 한 번으로만 잡힌다.
  @override
  void didPop(Route<Object?> route, Route<Object?>? previousRoute) {
    super.didPop(route, previousRoute);
    if (previousRoute != null) _log(previousRoute);
  }

  void _log(Route<Object?> route) {
    final String? name = screenNameOf(route.settings.name);
    if (name != null) AppAnalytics.logScreen(name);
  }

  /// 라우트 경로를 화면 이름으로 바꾼다. 이름이 없으면 null(집계하지 않는다).
  ///
  /// 다이얼로그나 시트처럼 `settings.name`이 없는 라우트는 건너뛴다 — 화면이 아니라
  /// 화면 위의 겹침이라 조회로 세면 실제 화면 수가 부풀려진다.
  @visibleForTesting
  static String? screenNameOf(String? path) {
    if (path == null || path.isEmpty) return null;

    // 쿼리는 화면을 가르지 않는다. `/search?q=...`는 전부 같은 검색 화면이다.
    final String withoutQuery = path.split('?').first;
    if (withoutQuery == '/') return '/';

    // 숫자로만 된 구간은 id다 — 하나로 묶는다.
    final Iterable<String> normalized = withoutQuery
        .split('/')
        .map((String s) => _isId(s) ? ':id' : s);

    final String joined = normalized.join('/');
    return joined.isEmpty ? '/' : joined;
  }

  /// 숫자로만 이뤄졌으면 id로 본다.
  ///
  /// 문자가 섞인 구간은 화면 이름의 일부다(`/settings/profile`) — 그것까지 지우면
  /// 서로 다른 화면이 한 이름으로 뭉친다.
  static bool _isId(String segment) =>
      segment.isNotEmpty && int.tryParse(segment) != null;
}
