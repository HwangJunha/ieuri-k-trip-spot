import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../common/navigation/discover_route.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../../dm/component/messages_entry_button.dart';
import '../../dm/view/conversation_list_screen.dart';
import 'discover_swipe_view.dart';

/// 둘러보기 탭 — 실시간·위치 기반 추천을 스와이프 카드로 보여준다(SPEC-0002).
///
/// **SPEC-0017의 세그먼트 토글이 사라졌다**(SPEC-0021 R9). 피드가 걷히면서 토글할
/// 상대가 없어져, 추천 스와이프가 다시 이 탭의 전부가 되었다. 화면 소유권도
/// `domain/feed`에서 이 도메인으로 돌아왔다 — 추천만 남으면 다른 곳에 둘 이유가 없다.
///
/// **라우트 이름은 그대로다**(AC9.4) — 온보딩과 로그인 후 착지가 이 이름을 쓰므로
/// 바꾸면 그 경로가 끊긴다. 값은 `common/navigation`이 쥔다.
class DiscoverScreen extends StatelessWidget {
  const DiscoverScreen({super.key});

  /// 값 자체는 `common/navigation`이 쥔다 — 온보딩도 쓰기 때문이다(CLAUDE.md §4).
  static String get routeName => discoverRouteName;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.navDiscover),
        actions: <Widget>[
          // **DM 재진입점이 여기 남았다**(SPEC-0021). 피드 항목의 DM 아이콘이
          // 사라지면서 이미 나눈 대화로 돌아갈 길이 이것뿐이다.
          //
          // 관광 추천 화면에 메일 아이콘이 붙어 있는 것은 어색하지만, 자리를
          // 옮기는 것은 후속 채팅 스펙의 몫이라 **임시로 유지한다** — 지금 옮기면
          // 그 스펙이 다시 옮겨야 한다.
          MessagesEntryButton(
            onPressed: () =>
                context.pushNamed(ConversationListScreen.routeName),
          ),
        ],
      ),
      body: const SafeArea(child: DiscoverSwipeView()),
    );
  }
}
