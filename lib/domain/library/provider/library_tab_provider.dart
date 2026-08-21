import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'library_tab_provider.g.dart';

/// 보관함이 지금 보여주는 쪽(R18).
enum LibraryTab {
  /// 좋아요한 여행지.
  liked,

  /// 커뮤니티.
  community,
}

/// 보관함의 상단 토글 상태(R18).
///
/// **탭을 떠나도 유지한다** — 다른 탭에 갔다 돌아오면 마지막으로 보던 쪽이 나온다.
/// 그래서 화면의 `State`가 아니라 provider가 들고 있고, `keepAlive`다.
///
/// 앱을 껐다 켜면 초기값으로 돌아간다. 스펙이 요구하는 것은 탭 사이 이동에서의
/// 유지이지 재실행 후 복원이 아니다(AC R17~R19).
@Riverpod(keepAlive: true)
class LibraryTabController extends _$LibraryTabController {
  @override
  LibraryTab build() => LibraryTab.liked;

  void select(LibraryTab tab) => state = tab;
}
