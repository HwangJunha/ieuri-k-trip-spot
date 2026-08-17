import 'package:flutter/material.dart';

import '../../../common/navigation/discover_route.dart';
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
    return Scaffold(
      // **`AppBar`를 두지 않는다**(실기기 확인 2026-08-18).
      //
      // 투명 앱바로 겹쳐 봤더니 제목("발견")이 카테고리 칩과 **같은 띠를 두고 다퉈**
      // 문화시설 아이콘 위에 그대로 겹쳤고, DM 아이콘도 맛집 칩에 끼었다. 앱바는
      // 자기 높이를 화면 맨 위에서 가져가는데 카테고리 바도 거기 있어야 하니
      // 구조적으로 겹칠 수밖에 없다.
      //
      // 제목은 없애도 잃는 것이 없다 — **하단 탭이 이미 "발견"으로 이 화면을
      // 이름 짓고 있고**, 그 한 줄이 사진 한 띠를 통째로 먹는다. DM 진입점은
      // 카테고리 바와 같은 줄로 옮겨 한 겹으로 합쳤다(→[DiscoverSwipeView]).
      //
      // 이렇게 하면 `extendBodyBehindAppBar`도 필요 없다. 카드는 그냥 화면 맨
      // 위에서 시작한다(AC R1-2).
      body: const DiscoverSwipeView(),
    );
  }
}
