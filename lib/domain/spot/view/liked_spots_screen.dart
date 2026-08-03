import 'package:flutter/material.dart';

import '../../../l10n/gen/app_localizations.dart';

/// 좋아요 목록 탭(SPEC-0008 R-12).
///
/// 지금은 빈 껍데기다 — 서버의 `likedSpots` 커서 페이징이 배포된 뒤 목록을 채운다
/// (설계 §7 작업 3번). 항목 선택 시 기존 `/spot/:id`로 진입하며 상세 화면을 새로
/// 만들지 않는다(§5.1).
///
/// 좋아요는 spot에 대한 반응이라 spot 도메인의 화면이다 — 별도 도메인이 아니다.
class LikedSpotsScreen extends StatelessWidget {
  const LikedSpotsScreen({super.key});

  static String get routeName => 'liked';

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.navLiked)),
      body: Center(child: Text(l10n.likedSpotsEmpty)),
    );
  }
}
