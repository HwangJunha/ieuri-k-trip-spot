import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/gen/app_localizations.dart';
import '../../app_assets.dart';
import '../../permission/model/permission_kind.dart';
import '../../permission/model/permission_state.dart';
import '../../permission/provider/permission_providers.dart';
import '../../theme/app_colors.dart';
import 'language_selection_screen.dart';

/// 인앱 스플래시 (Stitch 디자인): 큰 흰색 앱 아이콘과 흰 글자가 있는 코랄 브랜드 화면.
/// 최소 브랜드 노출 시간 동안 보여준 뒤, 온보딩(첫 실행) 또는 홈(재방문)으로 라우팅하기
/// 전에 필수인 위치 권한이 허용되기를 기다린다. 테마 무관 — 브랜드 스플래시는 항상 코랄.
/// 현재 로케일로 렌더된다.
///
/// [AMEND] SPEC-0001: 위치는 진행에 필수라 R4의 "거부해도 블로킹 없음"을 오버라이드한다 —
/// 스플래시는 위치가 허용될 때까지 대기한다. 알림은 선택 유지(이 화면을 막지 않음). 위치가
/// 영구거부되면 무한 대기 대신 "설정 열기" 경로를 보여준다 (R5).
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  static String get routeName => 'splash';

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  static const Duration _minBrandDelay = Duration(milliseconds: 1500);
  static const String _brand = 'K-Trip Spot';

  /// 최소 브랜드 노출 시간이 지났음 — 위치가 허용되는 대로 라우팅해도 됨.
  bool _minDelayElapsed = false;
  bool _routed = false;

  @override
  void initState() {
    super.initState();
    Future<void>.delayed(_minBrandDelay, () {
      if (!mounted) return;
      _minDelayElapsed = true;
      _routeIfReady();
    });
  }

  /// 브랜드 노출 시간이 지났고, 권한 부트 시퀀스가 끝났으며(선택 권한인 알림 프롬프트가
  /// 건너뛰어지지 않도록, R2), 그리고 필수 권한인 위치가 허용됐을 때에만 라우팅한다. 두
  /// 신호 모두 `PermissionBootGate`가 구동하며, 이 화면은 [build]의 `ref.listen`으로
  /// 반응한다.
  void _routeIfReady() {
    if (_routed || !_minDelayElapsed) return;
    if (!ref.read(permissionBootCompleteProvider)) return;
    // **위치 허용 여부로 막지 않는다**(2026-08-26). 예전에는 여기서 허용될 때까지
    // 스플래시에 세워 뒀는데, 그러면 거부한 사용자는 설정으로 갈 길이 스플래시의
    // 작은 안내뿐이고 로그아웃·언어 변경 같은 탈출구가 아예 없었다.
    //
    // 이제는 라우터 게이트(`route_gate.dart`)가 `/location-required`로 보낸다 —
    // 판정이 한곳에 모이고, 설정에서 위치를 켜고 돌아오면 게이트가 다시 평가돼
    // 앱이 그대로 열린다.
    _routed = true;
    // 라우터에 넘긴다: redirect(스펙 §10)가 auth/온보딩 상태로부터 언어 → 로그인 →
    // 온보딩 → 홈을 해소한다.
    context.goNamed(LanguageSelectionScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final TextTheme text = Theme.of(context).textTheme;
    const Color onCoral = Colors.white;

    // 두 부트 신호(모두 PermissionBootGate가 구동)에 반응한다: 위치 허용과 시퀀스 완료
    // 래치. 라우팅은 두 프롬프트가 모두 실행되고 위치가 허용됐을 때만 일어난다
    // (_routeIfReady 참고).
    ref.listen(
      permissionControllerProvider.select((s) => s[PermissionKind.location]),
      (_, _) => _routeIfReady(),
    );
    ref.listen(permissionBootCompleteProvider, (_, _) => _routeIfReady());
    final bool locationBlocked = ref.watch(
      permissionControllerProvider.select(
        (s) => (s[PermissionKind.location] ?? PermissionState.denied)
            .needsSettings,
      ),
    );

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
                    // 위치는 필수: 허용을 기다리는 동안엔 로딩 바를, 영구거부됐으면
                    // 무한 대기 대신 설정 경로를 제공한다 (R5).
                    if (locationBlocked)
                      _LocationBlocked(onCoral: onCoral)
                    else
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

/// 기본 스플래시 진행 표시: 필수 위치 허용을 기다리는 동안 보여주는 얇은 바.
class _Loading extends StatelessWidget {
  const _Loading({required this.onCoral});

  final Color onCoral;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final TextTheme text = Theme.of(context).textTheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SizedBox(
          width: 140,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: LinearProgressIndicator(
              color: onCoral,
              backgroundColor: Colors.white24,
              minHeight: 3,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          l10n.splashLocationRequired,
          textAlign: TextAlign.center,
          style: text.labelMedium?.copyWith(color: Colors.white70),
        ),
      ],
    );
  }
}

/// 위치가 영구거부됐을 때 보여준다: OS 다이얼로그가 더는 뜰 수 없으므로 스플래시가 설정
/// 진입 경로를 제공한다 (R5). 위치를 켠 채 돌아오면 앱이 resume되어 재조회 후 다음으로
/// 라우팅한다.
class _LocationBlocked extends ConsumerWidget {
  const _LocationBlocked({required this.onCoral});

  final Color onCoral;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final TextTheme text = Theme.of(context).textTheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          l10n.splashLocationBlockedHint,
          textAlign: TextAlign.center,
          style: text.bodyMedium?.copyWith(color: onCoral),
        ),
        const SizedBox(height: 16),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: onCoral,
            foregroundColor: AppColors.primary,
          ),
          onPressed: () =>
              ref.read(permissionControllerProvider.notifier).openSettings(),
          child: Text(l10n.permissionOpenSettings),
        ),
      ],
    );
  }
}
