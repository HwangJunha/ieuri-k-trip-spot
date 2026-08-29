import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/gen/app_localizations.dart';
import '../../app_assets.dart';
import '../../navigation/auth_route.dart';
import '../../permission/provider/permission_providers.dart';
import '../../storage/app_preferences.dart';
import '../../theme/app_colors.dart';
import 'language_selection_screen.dart';

/// 인앱 스플래시 (Stitch 디자인): 큰 흰색 앱 아이콘과 흰 글자가 있는 코랄 브랜드 화면.
/// 최소 브랜드 노출 시간 동안 보여준 뒤 라우터에 넘긴다. 테마 무관 — 브랜드
/// 스플래시는 항상 코랄. 현재 로케일로 렌더된다.
///
/// **위치를 기다리지 않는다**(2026-08-29). 2026-08-26에 위치를 필수로 보고
/// 허용될 때까지 여기 세워 뒀다가 App Store 심사에서 거절됐다(Guideline 5.1.5).
/// 위치는 SPEC-0001 R4대로 다시 선택 권한이다 — 거부해도 진행을 막지 않고,
/// 좌표가 필요한 화면이 각자 안내한다.
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  static String get routeName => 'splash';

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  static const Duration _minBrandDelay = Duration(milliseconds: 1500);

  /// 권한 부트 시퀀스를 기다리는 **최대** 시간. 넘기면 그냥 진행한다.
  ///
  /// 시퀀스는 `navigatorKey.currentContext`가 없으면 상태를 기록하지 못하고
  /// 중간에 빠져나가는데(`PermissionBootGate`), 그러면 완료 래치가 영원히
  /// 서지 않아 스플래시에 갇힌다 — 심사자가 본 화면이 이것이었을 수 있다.
  /// 권한 프롬프트는 놓쳐도 각 화면에서 다시 요청할 수 있지만, 앱이 열리지
  /// 않는 것은 회복할 방법이 없다.
  static const Duration _bootTimeout = Duration(seconds: 5);

  static const String _brand = 'K-Trip Spot';

  /// 최소 브랜드 노출 시간이 지났음 — 부트가 끝나는 대로 라우팅해도 됨.
  bool _minDelayElapsed = false;
  bool _routed = false;

  /// 부트 대기를 포기했음 — 완료 래치와 무관하게 진행한다.
  bool _bootTimedOut = false;

  /// **[dispose]에서 취소할 수 있도록 들고 있는다.** `Future.delayed`로 두면
  /// 화면이 사라진 뒤에도 타이머가 살아 있어, 위젯 테스트가 "A Timer is still
  /// pending"으로 실패한다(실제로 라우터 테스트 4개가 그렇게 깨졌다).
  Timer? _minDelayTimer;
  Timer? _bootTimeoutTimer;

  @override
  void initState() {
    super.initState();
    _minDelayTimer = Timer(_minBrandDelay, () {
      if (!mounted) return;
      _minDelayElapsed = true;
      _routeIfReady();
    });
    _bootTimeoutTimer = Timer(_bootTimeout, () {
      if (!mounted) return;
      _bootTimedOut = true;
      _routeIfReady();
    });
  }

  @override
  void dispose() {
    _minDelayTimer?.cancel();
    _bootTimeoutTimer?.cancel();
    super.dispose();
  }

  /// 브랜드 노출 시간이 지났고 권한 부트 시퀀스가 끝났을 때 라우팅한다(선택 권한인
  /// 알림 프롬프트가 건너뛰어지지 않도록, R2). 완료 신호는 `PermissionBootGate`가
  /// 구동하며, 이 화면은 [build]의 `ref.listen`으로 반응한다.
  ///
  /// **부트가 끝나지 않아도 [_bootTimeout] 뒤에는 진행한다** — 권한 프롬프트
  /// 한 번보다 앱이 열리는 것이 우선이다.
  void _routeIfReady() {
    if (_routed || !_minDelayElapsed) return;
    if (!_bootTimedOut && !ref.read(permissionBootCompleteProvider)) return;
    _routed = true;
    // 이미 떠나므로 남은 타임아웃은 할 일이 없다.
    _bootTimeoutTimer?.cancel();

    // **언어를 이미 골랐으면 언어 화면을 거치지 않는다**(2026-08-29).
    //
    // 예전에는 무조건 `/language`로 갔다. 게이트가 그 뒤에 걷어내 주긴 하지만,
    // 걷어내기 전에 **언어 화면이 한 프레임 이상 그려진다** — 앱이 빠르면
    // 스쳐 지나가 안 보이고 느리면 보인다. 재실행 때마다 언어 선택 화면이
    // 번쩍이던 것이 이것이다(사용자 지적).
    //
    // 게이트(`route_gate.dart` 1번)와 같은 값을 본다 — 판정이 갈리면 여기서
    // 보낸 곳을 게이트가 되돌리며 튕긴다.
    final bool languageChosen =
        ref.read(appPreferencesProvider).savedLanguage != null;
    context.goNamed(
      languageChosen ? loginRouteName : LanguageSelectionScreen.routeName,
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final TextTheme text = Theme.of(context).textTheme;
    const Color onCoral = Colors.white;

    // 부트 시퀀스 완료 래치에만 반응한다(PermissionBootGate가 구동). 위치 허용
    // 여부는 더 이상 라우팅 조건이 아니다 — 위 클래스 주석 참고.
    ref.listen(permissionBootCompleteProvider, (_, _) => _routeIfReady());

    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Padding(
          // 가로 여백을 화면 폭에 비례시킨다. 72로 고정하면 좁은 기기에서 문구가
          // 과하게 접히고, 넓은 기기에서는 상대적으로 좁아 보인다.
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.sizeOf(context).width * 0.12,
          ),
          child: Stack(
            children: <Widget>[
              // **로고·브랜드·진행 표시를 한 덩어리로 묶어 가운데 둔다.**
              //
              // 예전에는 `Spacer`를 3:2:2로 깔았는데, 그러면 세로가 긴 기기에서
              // 그 비율만큼 빈 공간이 커져 요소들이 화면 전체에 흩어졌다 —
              // iPhone Max에서 로고는 위쪽, 진행 표시는 한참 아래에 떨어져 보였다.
              // 고정 간격으로 묶으면 화면 크기와 무관하게 같은 덩어리로 보인다.
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SvgPicture.asset(AppAssets.appIconSplash, width: 150),
                    const SizedBox(height: 28),
                    Text(
                      _brand,
                      textAlign: TextAlign.center,
                      style: text.headlineMedium?.copyWith(
                        color: onCoral,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      l10n.splashTagline,
                      textAlign: TextAlign.center,
                      style: text.bodyLarge?.copyWith(
                        color: onCoral,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 48),
                    _Loading(onCoral: onCoral),
                  ],
                ),
              ),
              // 하단 문구는 바닥에 붙인다 — 가운데 덩어리와 섞이지 않는다.
              PositionedDirectional(
                start: 0,
                end: 0,
                bottom: 16,
                child: Text(
                  l10n.splashSubTagline,
                  textAlign: TextAlign.center,
                  style: text.bodySmall?.copyWith(color: Colors.white70),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 스플래시 진행 표시: 부트 시퀀스가 끝나기를 기다리는 동안 보여주는 얇은 바.
///
/// **문구를 두지 않는다**(2026-08-29). 예전에는 "계속하려면 위치 접근 권한이
/// 필요해요"를 띄웠는데, 이제 위치는 진행 조건이 아니라 사실과 다르다. 1.5초짜리
/// 대기에 설명이 필요하지도 않다.
class _Loading extends StatelessWidget {
  const _Loading({required this.onCoral});

  final Color onCoral;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 140,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(2),
        child: LinearProgressIndicator(
          color: onCoral,
          backgroundColor: Colors.white24,
          minHeight: 3,
        ),
      ),
    );
  }
}
