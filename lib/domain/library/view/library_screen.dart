import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/gen/app_localizations.dart';
import '../../community/view/community_screen.dart';
import '../../spot/view/liked_spots_screen.dart';
import '../provider/library_tab_provider.dart';

/// 보관함 — 좋아요와 커뮤니티를 상단 토글로 오가는 탭(R17·R18).
///
/// **껍데기만 새로 만든다.** 두 화면의 내부 동작은 건드리지 않고 배치만 바꾼다.
/// 상단바는 이 화면이 갖고(토글을 거기 둔다) 자식은 본문만 그린다.
///
/// **교차 도메인 import는 여기서 의도한 것이다.** CLAUDE.md §3은 도메인끼리
/// 서로의 내부를 참조하지 말라고 하지만, 이 화면의 존재 이유 자체가 "두 화면을
/// 그대로 자식으로 두는 컨테이너"다(설계 §1). 공유하는 것은 로직이 아니라 배치라
/// `common/`으로 끌어올릴 것이 없고, 올리면 spot·community의 화면이 자기 도메인을
/// 떠나 오히려 경계가 무너진다. 의존은 이 방향으로만 흐르고(보관함 → 두 화면)
/// 역방향은 없다.
///
/// 자식을 [IndexedStack]에 둔다 — 토글을 오갈 때마다 목록을 다시 읽고 스크롤
/// 위치를 잃으면 "보관함"이라는 이름값을 못 한다.
class LibraryScreen extends ConsumerWidget {
  const LibraryScreen({super.key});

  static String get routeName => 'library';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final LibraryTab tab = ref.watch(libraryTabControllerProvider);

    return Scaffold(
      appBar: AppBar(
        // 자식의 상단바를 걷었으므로 화면 이름은 여기서 잇는다 — 커뮤니티는
        // "Spot Talk"라는 고유 이름을 갖고 있어 토글 라벨("커뮤니티")만으로는
        // 그 이름이 화면에서 사라진다.
        title: Text(
          tab == LibraryTab.liked ? l10n.navLiked : l10n.communityTitle,
        ),
        // **토글은 우측 상단 아이콘 버튼이다**(사용자 결정 2026-08-24). 예전에는
        // 앱바 아래 폭을 꽉 채운 세그먼트 버튼이라 목록이 시작되기 전에 48px을
        // 통째로 먹었다 — 두 곳뿐인 전환에 그만한 자리를 줄 이유가 없다.
        actions: <Widget>[
          // 커뮤니티를 보고 있을 때만 숨긴 글 진입점을 둔다 — 좋아요 목록과는
          // 무관한 버튼이다.
          if (tab == LibraryTab.community)
            CommunityScreen.hiddenPostsAction(context),
          _LibraryToggleAction(
            selected: tab,
            likedLabel: l10n.navLiked,
            communityLabel: l10n.navCommunity,
            onSelect: (LibraryTab next) =>
                ref.read(libraryTabControllerProvider.notifier).select(next),
          ),
        ],
      ),
      body: IndexedStack(
        index: tab.index,
        children: const <Widget>[
          LikedSpotsScreen(showAppBar: false),
          CommunityScreen(showAppBar: false),
        ],
      ),
    );
  }
}

/// 좋아요 ↔ 커뮤니티 토글(앱바 액션).
///
/// **아이콘은 "지금 무엇을 보고 있는지"가 아니라 "누르면 무엇으로 가는지"를
/// 가리킨다.** 두 곳뿐인 전환이라 이 편이 짧고, 툴팁도 목적지를 읽어 준다.
class _LibraryToggleAction extends StatelessWidget {
  const _LibraryToggleAction({
    required this.selected,
    required this.likedLabel,
    required this.communityLabel,
    required this.onSelect,
  });

  final LibraryTab selected;
  final String likedLabel;
  final String communityLabel;
  final ValueChanged<LibraryTab> onSelect;

  @override
  Widget build(BuildContext context) {
    final bool onLiked = selected == LibraryTab.liked;
    final LibraryTab target = onLiked
        ? LibraryTab.community
        : LibraryTab.liked;
    return IconButton(
      key: const Key('library_toggle'),
      tooltip: onLiked ? communityLabel : likedLabel,
      // 가려는 쪽의 아이콘을 보여 준다.
      icon: Icon(onLiked ? Icons.forum_outlined : Icons.favorite_outline),
      onPressed: () => onSelect(target),
    );
  }
}
