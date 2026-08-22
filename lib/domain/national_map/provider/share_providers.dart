import 'package:riverpod_annotation/riverpod_annotation.dart';

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
    state = true;
    try {
      final MapShareLink link = await ref
          .read(nationalMapRepositoryProvider)
          .createShareLink();
      await ref.read(shareSheetServiceProvider).share(text: link.shareUrl);
      return link;
    } finally {
      state = false;
    }
  }

  /// 링크를 폐기한다(R14). 받았던 `shareUrl`을 그대로 되돌려준다.
  Future<void> revoke(String shareUrl) async {
    state = true;
    try {
      await ref.read(nationalMapRepositoryProvider).revokeShareLink(shareUrl);
    } finally {
      state = false;
    }
  }
}

/// 공유 링크로 조회한 남의 지도(R37·R38).
@riverpod
Future<SharedMap> sharedMap(Ref ref, String token) =>
    ref.watch(nationalMapRepositoryProvider).fetchSharedMap(token);
