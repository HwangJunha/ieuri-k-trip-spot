import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../common/navigation/discover_route.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../../spot/view/discover_swipe_view.dart';
import '../component/discover_mode_toggle.dart';
import '../component/messages_entry_button.dart';
import '../model/discover_segment.dart';
import '../provider/feed_providers.dart';
import 'conversation_list_screen.dart';
import 'feed_scroll_view.dart';

/// 둘러보기 탭 — 추천(스와이프)과 피드(세로 전면 스크롤)를 헤더 토글로 오간다(R5).
///
/// **기존 `DiscoverScreen`을 이 화면이 대체한다.** 라우트 이름과 AppBar 타이틀은
/// 그대로 유지하고, `DiscoverSwipeView` 내부는 손대지 않는다 — 피드 도입이 추천을
/// 대체하지 않는다(AC5-2).
///
/// **`IndexedStack`으로 양쪽 트리를 살려 둔다**(AC5-1) — 토글을 오갈 때 상대 쪽을
/// 버리면 돌아올 때마다 다시 로딩하고, 스와이프 카드는 보던 자리를 잃는다.
///
/// **토글은 헤더 안에 있다**(설계 §1) — 두 화면 모두 화면 전체를 제스처 표면으로
/// 쓰므로, 토글을 그 위에 겹치면 토글 탭과 드래그·스크롤 시작이 경합한다.
class DiscoverTabScreen extends ConsumerWidget {
  const DiscoverTabScreen({super.key});

  /// 라우트 이름은 기존 `DiscoverScreen`의 것을 그대로 물려받는다 — 셸과 내비게이션이
  /// 이 이름을 참조한다. 값 자체는 `common/navigation`이 쥔다(온보딩도 쓴다).
  static String get routeName => discoverRouteName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final DiscoverSegment segment = ref.watch(selectedDiscoverSegmentProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.navDiscover),
        actions: <Widget>[
          // DM 재진입점(디자인 §1.5). 피드 항목의 DM 아이콘은 **새 대화를 여는**
          // 입구일 뿐이라, 이것이 없으면 이미 나눈 대화로 돌아갈 길이 없다.
          MessagesEntryButton(
            onPressed: () =>
                context.pushNamed(ConversationListScreen.routeName),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            DiscoverModeToggle(
              selected: segment,
              onSelected: (DiscoverSegment next) => ref
                  .read(selectedDiscoverSegmentProvider.notifier)
                  .select(next),
            ),
            // 선택된 쪽만 보이고 **상대 쪽 트리도 살아 있다**(AC5-1). 두 화면은
            // 서로 다른 provider를 보므로 한쪽이 오류여도 다른 쪽이 무너지지
            // 않는다(AC5-3) — 이 위젯은 어느 쪽을 그릴지만 정한다.
            Expanded(
              child: IndexedStack(
                index: segment == DiscoverSegment.recommendation ? 0 : 1,
                sizing: StackFit.expand,
                children: const <Widget>[DiscoverSwipeView(), FeedScrollView()],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
