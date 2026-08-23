import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'common/localization/app_language.dart';
import 'common/localization/locale_controller.dart';
import 'common/permission/component/permission_boot_gate.dart';
import 'common/storage/app_preferences.dart';
import 'common/storage/secure_storage.dart';
import 'common/theme/app_theme.dart';
import 'common/config/map_sdk_initializer.dart';
import 'common/config/push_initializer.dart';
import 'domain/alarm/component/push_deep_link_gate.dart';
import 'domain/alarm/component/push_registration_gate.dart';
import 'domain/auth/repository/sns_initializer.dart';
import 'l10n/gen/app_localizations.dart';
import 'router/app_router.dart';
import 'router/deep_link_parser.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SnsInitializer.ensureInitialized();
  // 지도 SDK·푸시 초기화와 환경설정 로딩은 서로 독립이라 함께 기다린다. 키나 설정
  // 파일이 없으면 초기화가 조용히 건너뛰어지고 해당 화면만 안내를 띄운다 — 앱 기동은
  // 막지 않는다(설계 §10, SPEC-0028 §3.1).
  final (SharedPreferences prefs, _, _) = await (
    SharedPreferences.getInstance(),
    MapSdkInitializer.ensureInitialized(),
    PushInitializer.ensureInitialized(),
  ).wait;

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        secureStorageProvider.overrideWithValue(SecureStorage.platform()),
      ],
      child: const KTripSpotApp(),
    ),
  );
}

class KTripSpotApp extends ConsumerWidget {
  const KTripSpotApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final GoRouter router = ref.watch(goRouterProvider);
    final Locale locale = ref.watch(localeControllerProvider);

    return MaterialApp.router(
      onGenerateTitle: (BuildContext context) =>
          AppLocalizations.of(context).appTitle,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      locale: locale,
      supportedLocales: AppLanguage.supportedLocales,
      localizationsDelegates: const <LocalizationsDelegate<Object>>[
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      // 라우팅되는 화면들 위에서 최초 실행 권한 시퀀스(SPEC-0001)를 구동한다: 어떤
      // 화면이 떠 있든 무관하게, 사전설명 시트와 앱 resume 재조회를 담을 안정적인 자리.
      //
      // 알림 게이트 둘도 같은 자리에 얹는다(SPEC-0028 §3.2·§3.3) — 화면을 그리지 않고
      // 인증 전이와 알림 탭만 듣는다. **권한 게이트 안쪽에 둔다**: 등록은 권한 판정이
      // 끝난 뒤라야 의미가 있고, 권한 시퀀스가 먼저 돌아야 `check`가 실제 값을 준다.
      builder: (BuildContext context, Widget? child) => PermissionBootGate(
        child: PushRegistrationGate(
          child: PushDeepLinkGate(child: child ?? const SizedBox.shrink()),
        ),
      ),
      // **딥링크 URL을 파서 앞에서 정규화한다**([DeepLinkRouteInformationParser]).
      // 커스텀 스킴으로 열리면 URL이 통째로 location 이 되어 라우트에 걸리지
      // 않는다. `routerConfig` 로 통째로 넘기면 파서를 끼울 자리가 없어 구성
      // 요소를 하나씩 넘긴다 — 값은 전부 `router` 의 것 그대로다.
      routerDelegate: router.routerDelegate,
      routeInformationParser: DeepLinkRouteInformationParser(
        router.routeInformationParser,
      ),
      routeInformationProvider: router.routeInformationProvider,
      backButtonDispatcher: router.backButtonDispatcher,
    );
  }
}
