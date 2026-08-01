import 'package:flutter/widgets.dart';

/// 앱의 루트 [Navigator] 키. 라우팅되는 화면들보다 *위에* 있는 코드 — 예: `MaterialApp
/// .router`의 builder에서 사전설명 시트를 띄우는 권한 부트 게이트 — 가 Navigator 아래의
/// `BuildContext`에 닿을 수 있도록 공유한다. GoRouter도 같은 키로 설정된다
/// (app_router.dart 참고).
final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'rootNavigator',
);
