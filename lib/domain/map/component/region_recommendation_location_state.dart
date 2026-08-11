import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/permission/model/permission_kind.dart';
import '../../../common/permission/model/permission_state.dart';
import '../../../common/permission/provider/permission_providers.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../provider/region_recommendation_provider.dart';

/// 위치가 없어 추천을 요청할 수 없을 때의 안내(설계 §9.3).
///
/// **오류 화면이 아니다.** 서버가 `origin`을 필수로 두어 좌표 없이는 조회 자체가
/// 불가능한데(이 쿼리는 "내 시도 안에서 내 시군구를 뺀 곳"을 답한다), 이를 실패로
/// 그리면 사용자가 재시도만 반복하게 된다 — 권한을 주는 것이 유일한 해결이다.
/// 그래서 오류 색도 재시도 버튼도 쓰지 않고, 권한으로 가는 길만 연다.
class RegionRecommendationLocationState extends ConsumerStatefulWidget {
  const RegionRecommendationLocationState({super.key});

  @override
  ConsumerState<RegionRecommendationLocationState> createState() =>
      _RegionRecommendationLocationStateState();
}

class _RegionRecommendationLocationStateState
    extends ConsumerState<RegionRecommendationLocationState> {
  bool _busy = false;

  /// 권한을 요청하고, 얻었으면 조회를 다시 연다.
  ///
  /// **영구거부는 앱이 다시 물을 수 없다**(R6) — 그때는 OS 설정으로 보낸다.
  Future<void> _grant() async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      final permissions = ref.read(permissionServiceProvider);
      final PermissionState state = await permissions.status(
        PermissionKind.location,
      );

      final PermissionState result = state == PermissionState.denied
          ? await permissions.request(PermissionKind.location)
          : state;

      if (result == PermissionState.granted) {
        // 권한이 생겼으니 조회를 다시 건다. **재시도 상한을 쓰지 않는다** — 상한은
        // 실패하는 조회를 막기 위한 것이고, 이것은 조건이 바뀌어 다시 여는 것이다.
        ref.invalidate(regionRecommendationsProvider);
        return;
      }
      // 거부가 확정된 상태면 앱이 더 물을 수 없다. 설정으로 보낸다.
      if (result.isDecided && result != PermissionState.granted) {
        await permissions.openSettings();
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final ThemeData theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            // 오류 색(`error` 롤)을 쓰지 않는다 — 잘못된 상태가 아니라 아직 못 받은
            // 권한일 뿐이다.
            Icon(
              Icons.my_location_outlined,
              size: 56,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              l10n.mapRegionRecommendationsNeedsLocationTitle,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.mapRegionRecommendationsNeedsLocation,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: _busy ? null : _grant,
              child: Text(l10n.mapRegionRecommendationsAllowLocation),
            ),
          ],
        ),
      ),
    );
  }
}
