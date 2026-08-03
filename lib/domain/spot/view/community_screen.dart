import 'package:flutter/material.dart';

import '../../../l10n/gen/app_localizations.dart';

/// 커뮤니티 탭(SPEC-0008 R-13).
///
/// **라벨·아이콘·라우트 이름만 바뀌고 화면 내용은 그대로다**(§4.1, AC-42). 게시글·
/// 댓글·신고 같은 커뮤니티 기능은 이 스펙의 비스코프이며 `domain: community`로
/// 별도 스펙에서 열린다 — 이 저장소는 GraphQL에 `Community` 타입을 만들지 않는다.
class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  static String get routeName => 'community';

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.navCommunity)),
      body: Center(child: Text(l10n.comingSoon)),
    );
  }
}
