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
import 'domain/auth/repository/sns_initializer.dart';
import 'l10n/gen/app_localizations.dart';
import 'router/app_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SnsInitializer.ensureInitialized();
  // 지도 SDK 초기화와 환경설정 로딩은 서로 독립이라 함께 기다린다. 키가 없으면
  // 초기화가 조용히 건너뛰어지고 지도 화면만 안내를 띄운다 — 앱 기동은 막지
  // 않는다(설계 §10).
  final (SharedPreferences prefs, _) = await (
    SharedPreferences.getInstance(),
    MapSdkInitializer.ensureInitialized(),
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
      builder: (BuildContext context, Widget? child) =>
          PermissionBootGate(child: child ?? const SizedBox.shrink()),
      routerConfig: router,
    );
  }
}
