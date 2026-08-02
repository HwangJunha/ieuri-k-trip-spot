import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/common/location/location_providers.dart';
import 'package:ieuri_k_trip_spot/common/permission/provider/permission_providers.dart';
import 'package:ieuri_k_trip_spot/common/storage/app_preferences.dart';
import 'package:ieuri_k_trip_spot/common/storage/secure_storage.dart';
import 'package:ieuri_k_trip_spot/domain/auth/provider/auth_repository_provider.dart';
import 'package:ieuri_k_trip_spot/domain/auth/repository/auth_repository.dart';
import 'package:ieuri_k_trip_spot/domain/spot/provider/spot_providers.dart';
import 'package:ieuri_k_trip_spot/main.dart';

import 'app_prefs_doubles.dart';
import 'spot_swipe_test_doubles.dart';

/// 실제 앱을 콜드 스타트시키는 공용 하네스. 여정별로 달라지는 것은 auth
/// repository와 미리 세운 저장소뿐이고, 나머지 시작 상태(언어 선택 완료, 위치 권한
/// 허용, 관광지 목록)는 모든 여정이 동일하게 쓴다(e2e-flow-testing skill §7).
///
/// [storage]는 호출자가 미리 세워 넘긴다 — 인증에 필요한 값은 오직 SecureStorage를
/// 통해서만 세운다(CLAUDE.md §7).
Future<void> bootAppWith(
  WidgetTester tester, {
  required SecureStorage storage,
  required AuthRepository authRepo,
}) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(
          await seededLanguagePrefs(),
        ),
        secureStorageProvider.overrideWithValue(storage),
        authRepositoryProvider.overrideWithValue(authRepo),
        spotRepositoryProvider.overrideWithValue(
          FakeSpotRepository(feed: swipeSpots(3)),
        ),
        locationServiceProvider.overrideWithValue(const FixedLocationService()),
        permissionServiceProvider.overrideWithValue(
          const GrantedPermissionService(),
        ),
      ],
      child: const KTripSpotApp(),
    ),
  );
}
