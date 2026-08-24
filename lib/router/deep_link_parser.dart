import 'package:flutter/widgets.dart';

/// 딥링크 URL에서 **경로만 남겨** 라우터에 넘긴다.
///
/// 커스텀 스킴(`ktripspot://tour/korea-map/<token>`)으로 앱이 열리면 URL이
/// **통째로** location이 되어 `/tour/korea-map/:token`과 매칭되지 않는다. 실제로
/// `GoException: no routes for location: ktripspot://tour/korea-map/...`이 떴다.
///
/// **리다이렉트로는 고칠 수 없다.** go_router는 매칭을 먼저 하고 그 다음
/// 리다이렉트를 부른다(`parser.dart`에서 `findMatch` → `_redirect` 순). 매칭이
/// 이미 실패한 뒤라 손댈 자리가 없다. 그래서 파서 앞에서 URL을 정규화한다.
///
/// Universal Link(`https://www.ieuri.co.kr/tour/korea-map/<token>`)는 iOS가
/// 경로만 넘겨 주므로 원래 잘 동작한다 — 이 래퍼는 그 경우 아무것도 하지 않는다.
/// **웹 중간 경로가 생겨도 이 코드는 그대로 둔다**: 두 경로가 같은 라우트로
/// 모이므로 어느 쪽으로 들어와도 같은 화면이 열린다.
class DeepLinkRouteInformationParser
    extends RouteInformationParser<Object> {
  DeepLinkRouteInformationParser(this._inner);

  final RouteInformationParser<Object> _inner;

  /// 앱이 자기 것으로 아는 스킴. 여기 없는 스킴은 건드리지 않는다 —
  /// 모르는 링크를 임의로 잘라 내면 엉뚱한 화면이 열린다.
  static const Set<String> _appSchemes = <String>{'ktripspot'};

  /// 서버가 링크에 쓰는 호스트. `https`로 들어온 링크에서 경로만 남길 때 쓴다.
  static const Set<String> _webHosts = <String>{
    'www.ieuri.co.kr',
    'ieuri.co.kr',
  };

  /// 스킴·호스트를 벗겨 경로만 남긴다. 이미 경로면 그대로 돌려준다.
  ///
  /// 커스텀 스킴은 호스트 자리에 첫 경로 조각이 들어간다 —
  /// `ktripspot://tour/korea-map/x`의 `host`는 `tour`, `path`는 `/korea-map/x`다.
  /// 그래서 호스트를 경로 앞에 다시 붙여야 원래 경로가 된다.
  @visibleForTesting
  static Uri normalize(Uri uri) {
    if (uri.scheme.isEmpty) return uri;

    if (_appSchemes.contains(uri.scheme)) {
      final String path = uri.host.isEmpty
          ? uri.path
          : '/${uri.host}${uri.path}';
      return Uri(
        path: path.isEmpty ? '/' : path,
        queryParameters: uri.queryParameters.isEmpty
            ? null
            : uri.queryParameters,
        fragment: uri.fragment.isEmpty ? null : uri.fragment,
      );
    }

    // 웹 링크는 우리 호스트일 때만 경로를 뽑는다. 남의 도메인을 열어 주면 안 된다.
    if ((uri.scheme == 'https' || uri.scheme == 'http') &&
        _webHosts.contains(uri.host)) {
      return Uri(
        path: uri.path.isEmpty ? '/' : uri.path,
        queryParameters: uri.queryParameters.isEmpty
            ? null
            : uri.queryParameters,
        fragment: uri.fragment.isEmpty ? null : uri.fragment,
      );
    }

    return uri;
  }

  @override
  Future<Object> parseRouteInformationWithDependencies(
    RouteInformation routeInformation,
    BuildContext context,
  ) => _inner.parseRouteInformationWithDependencies(
    RouteInformation(
      uri: normalize(routeInformation.uri),
      state: routeInformation.state,
    ),
    context,
  );

  @override
  Future<Object> parseRouteInformation(RouteInformation routeInformation) =>
      _inner.parseRouteInformation(
        RouteInformation(
          uri: normalize(routeInformation.uri),
          state: routeInformation.state,
        ),
      );

  @override
  RouteInformation? restoreRouteInformation(Object configuration) =>
      _inner.restoreRouteInformation(configuration);
}
