import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../common/navigation/discover_route.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../../spot/view/discover_swipe_view.dart';
import '../component/discover_mode_toggle.dart';
import '../component/feed_action_rail.dart';
import '../component/messages_entry_button.dart';
import '../model/discover_segment.dart';
import '../provider/feed_providers.dart';
import 'conversation_list_screen.dart';
import 'feed_scroll_view.dart';

/// 둘러보기 탭 — 추천(스와이프)과 피드(세로 전면 스크롤)를 헤더 토글로 오간다(R5).
///
/// **기존 `DiscoverScreen`을 이 화면이 대체한다.** 라우트 이름과 타이틀은 그대로
/// 유지하고, `DiscoverSwipeView` 내부는 손대지 않는다 — 피드 도입이 추천을 대체하지
/// 않는다(AC5-2).
///
/// **`IndexedStack`으로 양쪽 트리를 살려 둔다**(AC5-1) — 토글을 오갈 때 상대 쪽을
/// 버리면 돌아올 때마다 다시 로딩하고, 스와이프 카드는 보던 자리를 잃는다.
///
/// **헤더가 사진 위에 뜬다(피드일 때).** Stitch 디자인(`fd6c6669…`)은 사진을 화면
/// 끝까지 채우고 그 위에 반투명 헤더를 얹는다 — 흰 띠를 얹으면 사진이 밀려나고
/// "전면 스크롤"이라는 이 화면의 성격이 죽는다. 추천 쪽은 밝은 배경에 카테고리 바가
/// 있어 흰 글자가 안 보이므로, **세그먼트에 따라 헤더 표현을 바꾼다.**
class DiscoverTabScreen extends ConsumerStatefulWidget {
  const DiscoverTabScreen({super.key});

  /// 라우트 이름은 기존 `DiscoverScreen`의 것을 그대로 물려받는다 — 셸과 내비게이션이
  /// 이 이름을 참조한다. 값 자체는 `common/navigation`이 쥔다(온보딩도 쓴다).
  static String get routeName => discoverRouteName;

  @override
  ConsumerState<DiscoverTabScreen> createState() => _DiscoverTabScreenState();
}

class _DiscoverTabScreenState extends ConsumerState<DiscoverTabScreen> {
  /// 피드를 **한 번이라도 골랐는지.**
  ///
  /// `IndexedStack`은 숨은 자식도 build하므로, 처음부터 두 쪽을 다 넣으면 둘러보기
  /// 탭에 들어서는 것만으로 피드 조회가 나간다 — 추천만 보는 사용자에게는 쓰지 않을
  /// 데이터를 받는 비용이다. 한 번 고른 뒤에는 계속 살려 둔다(AC5-1).
  bool _feedTouched = false;

  @override
  Widget build(BuildContext context) {
    final DiscoverSegment segment = ref.watch(selectedDiscoverSegmentProvider);
    if (segment == DiscoverSegment.feed) _feedTouched = true;
    final bool overPhoto = segment == DiscoverSegment.feed;

    // **두 쪽의 레이아웃이 다르다.**
    // - 피드: 사진이 화면 끝까지 차고 헤더가 그 위에 뜬다(Stack)
    // - 추천: 카테고리 바 + 카드가 남은 높이를 나눠 가진다(Column)
    //
    // 추천을 Stack에 넣고 padding으로 밀면 카드가 받을 높이가 줄어 하단이 잘린다 —
    // 실제로 그렇게 만들었다가 카드가 내비게이션 바 뒤로 숨었다. 그래서 세그먼트마다
    // 배치 자체를 달리한다.
    final Widget header = _DiscoverHeader(
      segment: segment,
      overPhoto: overPhoto,
    );

    // 양쪽 트리를 **항상 살려 둔다**(AC5-1) — 토글을 오갈 때 상대 쪽을 버리면
    // 돌아올 때마다 다시 로딩하고, 스와이프 카드는 보던 자리를 잃는다. 두 화면은
    // 서로 다른 provider를 보므로 한쪽이 오류여도 다른 쪽이 무너지지 않는다(AC5-3).
    final Widget stack = IndexedStack(
      index: segment == DiscoverSegment.recommendation ? 0 : 1,
      sizing: StackFit.expand,
      children: <Widget>[
        // 기존 `DiscoverScreen`이 감싸던 `SafeArea`를 그대로 유지한다 — 빼면 카드
        // 하단이 홈 인디케이터와 겹친다.
        const SafeArea(top: false, child: DiscoverSwipeView()),
        // 고르기 전에는 자리만 잡아 둔다(위 `_feedTouched` 참고).
        if (_feedTouched) const FeedScrollView() else const SizedBox.shrink(),
      ],
    );

    return Scaffold(
      // **피드일 때는 배경을 비운다.** Scaffold의 기본 배경색이 깔려 있으면 사진이
      // 화면 끝까지 차도 그 위를 표면색이 덮어, 헤더 아래에 흰 띠가 남는다 —
      // 실제로 그 띠가 보였다.
      backgroundColor: overPhoto ? Colors.transparent : null,
      body: overPhoto
          ? Stack(
              children: <Widget>[
                Positioned.fill(child: stack),
                // **어둠은 여기 한 겹뿐이다.** 헤더와 작성자 줄이 각자 그라데이션을
                // 깔던 때는 두 블록의 경계에서 알파가 갑자기 튀어, 화면을 가로지르는
                // 선이 보였다(측정: y=472 rgb(228,231,239) → y=476 rgb(70,71,74)).
                // 두 줄을 모두 덮는 하나의 그라데이션으로 이어서 깐다.
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height:
                      MediaQuery.paddingOf(context).top +
                      discoverHeaderExtent +
                      _authorRowExtent,
                  child: const IgnorePointer(child: _TopScrim()),
                ),
                // 헤더는 배치를 모른다 — 어디에 놓을지는 이 화면이 정한다.
                Positioned(top: 0, left: 0, right: 0, child: header),
              ],
            )
          : Column(
              children: <Widget>[
                header,
                Expanded(child: stack),
              ],
            ),
    );
  }
}

/// 타이틀·메시지 아이콘·토글을 담은 떠 있는 헤더.
class _DiscoverHeader extends ConsumerWidget {
  const _DiscoverHeader({required this.segment, required this.overPhoto});

  final DiscoverSegment segment;

  /// 사진 위에 떠 있는지. 참이면 흰 글자 + 그라데이션 스크림, 거짓이면 평범한
  /// 표면 위의 헤더다.
  final bool overPhoto;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final ThemeData theme = Theme.of(context);
    final Color foreground = overPhoto
        ? Colors.white
        : theme.colorScheme.onSurface;

    return DecoratedBox(
      decoration: BoxDecoration(
        // **사진 위에서는 여기서 어둠을 깔지 않는다.** 화면 전체를 덮는 `_TopScrim`
        // 하나가 맡는다 — 블록마다 그라데이션을 깔면 경계에서 알파가 튀어 선이 보인다.
        color: overPhoto ? null : theme.colorScheme.surface,
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 4, 8, 14),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              // 타이틀은 가운데, 메시지 아이콘은 오른쪽 끝. Stack으로 겹쳐야
              // 타이틀이 아이콘 폭만큼 밀리지 않고 정확히 가운데 온다.
              Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Text(
                    l10n.navDiscover,
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: foreground,
                      fontWeight: FontWeight.w600,
                      shadows: overPhoto ? _titleShadow : null,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    // DM 재진입점(디자인 §1.5). 피드 항목의 DM 아이콘은 **새 대화를
                    // 여는** 입구일 뿐이라, 이것이 없으면 이미 나눈 대화로 돌아갈
                    // 길이 없다.
                    child: MessagesEntryButton(
                      foregroundColor: foreground,
                      onPressed: () =>
                          context.pushNamed(ConversationListScreen.routeName),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              DiscoverModeToggle(
                selected: segment,
                onPhoto: overPhoto,
                onSelected: (DiscoverSegment next) => ref
                    .read(selectedDiscoverSegmentProvider.notifier)
                    .select(next),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 사진 위 흰 글자가 밝은 배경에서도 읽히게 하는 그림자.
const List<Shadow> _titleShadow = <Shadow>[
  Shadow(color: Color(0x66000000), blurRadius: 8, offset: Offset(0, 1)),
];

/// 작성자 줄이 차지하는 높이(대략). 상단 스크림이 그 줄까지 덮게 하는 데 쓴다.
const double _authorRowExtent = 76;

/// 화면 상단을 한 겹으로 덮는 어둠.
///
/// **블록마다 그라데이션을 깔지 않는 이유가 여기 있다.** 헤더와 작성자 줄이 각각
/// 자기 스크림을 최대 알파로 시작하면 두 블록이 만나는 지점에서 알파가 갑자기 튀고,
/// 그 경계가 화면을 가로지르는 선으로 보인다 — 실제로 보였다.
class _TopScrim extends StatelessWidget {
  const _TopScrim();

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        // 위는 글자가 얹히므로 눌러 주고, 아래로는 완전히 사라져 사진을 살린다.
        stops: const <double>[0, 0.45, 1],
        colors: <Color>[
          Colors.black.withValues(alpha: 0.5),
          Colors.black.withValues(alpha: 0.28),
          Colors.black.withValues(alpha: 0),
        ],
      ),
    ),
  );
}
