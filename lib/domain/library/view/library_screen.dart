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
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: _LibraryToggle(
              selected: tab,
              likedLabel: l10n.navLiked,
              communityLabel: l10n.navCommunity,
              onSelect: (LibraryTab next) =>
                  ref.read(libraryTabControllerProvider.notifier).select(next),
            ),
          ),
        ),
        // 커뮤니티를 보고 있을 때만 숨긴 글 진입점을 둔다 — 좋아요 목록과는
        // 무관한 버튼이다.
        actions: tab == LibraryTab.community
            ? <Widget>[CommunityScreen.hiddenPostsAction(context)]
            : null,
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

/// 좋아요 ↔ 커뮤니티 세그먼트 토글.
class _LibraryToggle extends StatelessWidget {
  const _LibraryToggle({
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
    return SizedBox(
      width: double.infinity,
      child: SegmentedButton<LibraryTab>(
        key: const Key('library_toggle'),
        segments: <ButtonSegment<LibraryTab>>[
          ButtonSegment<LibraryTab>(
            value: LibraryTab.liked,
            label: Text(likedLabel),
            icon: const Icon(Icons.favorite_outline, size: 18),
          ),
          ButtonSegment<LibraryTab>(
            value: LibraryTab.community,
            label: Text(communityLabel),
            icon: const Icon(Icons.forum_outlined, size: 18),
          ),
        ],
        selected: <LibraryTab>{selected},
        onSelectionChanged: (Set<LibraryTab> next) => onSelect(next.first),
        showSelectedIcon: false,
        style: const ButtonStyle(
          visualDensity: VisualDensity.compact,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      ),
    );
  }
}
