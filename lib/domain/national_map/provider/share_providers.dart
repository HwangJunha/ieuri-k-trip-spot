import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../common/analytics/analytics_events.dart';
import '../../../common/analytics/app_analytics.dart';
import '../../../common/network/network_retry_policy.dart';
import '../model/shared_map.dart';
import '../service/share_sheet_service.dart';
import 'national_map_providers.dart';

part 'share_providers.g.dart';

@riverpod
ShareSheetService shareSheetService(Ref ref) => const ShareSheetService();

/// 공유 링크 발급과 시스템 공유 시트 전달(R36).
///
/// **링크를 조립하지 않는다** — 서버가 완성된 `shareUrl`을 준다. 지금은
/// `https://www.ieuri.co.kr/tour/korea-map/<token>`이며, 서버가 조립하므로
/// 형태가 바뀌어도 앱 배포가 필요 없다.
@riverpod
class ShareController extends _$ShareController {
  @override
  bool build() => false; // 발급이 도는 중인지

  /// 링크를 발급해 공유 시트로 넘긴다.
  ///
  /// **링크만 보낸다.** 안내 문구를 앞에 붙이면 받는 사람에게는 잡음이고, 링크
  /// 미리보기(OG 태그)가 뜨는 곳에서는 그 미리보기가 설명을 대신한다.
  Future<MapShareLink> share() async {
    // **공유 시트 서비스를 진입부에서 잡아 둔다.** 시트는 사용자가 다른 앱으로
    // 나갔다 돌아올 때까지 열려 있어 대기가 사실상 무제한이고, 그동안 지도 화면을
    // 떠나면 autoDispose인 이 provider는 폐기된다 — 그 뒤에 `ref.read`를 부르면
    // `UnmountedRefException`이다. 링크 발급은 이미 성공한 뒤라 더 나쁘다.
    final ShareSheetService sheet = ref.read(shareSheetServiceProvider);
    state = true;
    try {
      final MapShareLink link = await ref
          .read(nationalMapRepositoryProvider)
          .createShareLink();
      await sheet.share(text: link.shareUrl);
      // **"공유 시트를 열었다"까지만 잡힌다.** 시트에서 사용자가 취소해도
      // `SharePlus`는 성공으로 돌아온다 — 실제 전송 여부는 알 수 없다.
      // URL은 싣지 않는다(공유 링크에 식별자가 들어 있다).
      AppAnalytics.logEvent(AnalyticsEvents.share, <String, Object>{
        AnalyticsParams.contentType: 'national_map',
      });
      return link;
    } finally {
      // 시트가 열려 있는 동안 화면을 나가면 폐기된 뒤에 여기가 돈다. 상태는
      // "발급이 도는 중인지"뿐이라 폐기됐다면 되돌릴 대상도 없다.
      if (ref.mounted) state = false;
    }
  }

  /// 링크를 폐기한다(R14). 받았던 `shareUrl`을 그대로 되돌려준다.
  Future<void> revoke(String shareUrl) async {
    state = true;
    try {
      await ref.read(nationalMapRepositoryProvider).revokeShareLink(shareUrl);
    } finally {
      // 폐기는 보통 시트나 관리 화면에서 부르는데, 응답을 기다리는 동안 그 화면을
      // 닫으면 구독이 끊긴다. 서버에서는 이미 폐기됐는데 예외로 실패처럼 보이는
      // 것을 막는다.
      if (ref.mounted) state = false;
    }
  }
}

/// 공유 링크로 조회한 남의 지도(R37·R38).
@Riverpod(retry: defaultNetworkRetry)
Future<SharedMap> sharedMap(Ref ref, String token) =>
    ref.watch(nationalMapRepositoryProvider).fetchSharedMap(token);
