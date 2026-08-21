import 'package:share_plus/share_plus.dart';

/// 시스템 공유 시트 경계(R36).
///
/// `share_plus`는 **이 파일 밖으로 나가지 않는다** — provider·view는 이
/// 인터페이스로만 대화한다(CLAUDE.md §3).
abstract interface class ShareSheetService {
  /// 실제 앱에서 쓰는 `share_plus` 기반 구현.
  const factory ShareSheetService() = SharePlusSheetService;

  /// 시스템 공유 시트를 띄운다.
  ///
  /// [text]는 링크와 안내 문구를 합친 것이다 — **링크를 조립하지 않는다**,
  /// 서버가 준 `shareUrl`을 그대로 담는다.
  Future<void> share({required String text, String? subject});
}

class SharePlusSheetService implements ShareSheetService {
  const SharePlusSheetService();

  @override
  Future<void> share({required String text, String? subject}) =>
      SharePlus.instance.share(ShareParams(text: text, subject: subject));
}
