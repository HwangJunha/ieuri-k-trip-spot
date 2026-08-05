import 'dart:developer' as developer;

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../common/location/coordinates.dart';
import '../../../common/location/location_providers.dart';
import '../../../common/pagination/page.dart';
import '../model/post.dart';
import '../model/post_topic.dart';
import '../repository/community_repository.dart';
import 'community_providers.dart';

part 'nearby_feed_providers.g.dart';

/// 한 번에 받아오는 글 수. 서버 기본값 20 / 상한 50이며, 초과해도 오류가 아니라
/// 50으로 잘린다(가이드 §5).
const int _pageSize = 20;

/// 커뮤니티 탭에서 선택된 주제 태그(null=전체).
///
/// **상태는 이것 하나뿐이다** — 정렬 선택도, 추가 필터도, 검색도 없다(설계 §3).
/// 타일에서 진입해도 같은 상태에 반영되어 상단 칩이 그 태그로 선택된 것처럼 보인다
/// (R11-3) — 타일 진입과 칩 선택이 서로 다른 화면 상태를 만들지 않는다.
///
/// keepAlive인 이유는 좋아요 목록의 카테고리 필터와 같다 — 사용자가 고른 필터는
/// 화면이 아니라 세션에 속한다. autoDispose면 상세에 다녀오는 것만으로 "전체"로
/// 되돌아간다.
@Riverpod(keepAlive: true)
class SelectedPostTopic extends _$SelectedPostTopic {
  @override
  PostTopic? build() => null;

  /// 칩을 선택한다. 같은 칩을 다시 누르면 해제(전체)다.
  void select(PostTopic? topic) => state = topic;

  /// 탐색 타일에서 진입했을 때(R11-3). 칩 선택과 **같은 상태**를 쓴다.
  void applyFromTile(PostTopic? topic) => state = topic;
}

/// 지역 피드의 누적 상태. 커서 페이징이라 [CursorPage]의 `endCursor`를 다음 조회의
/// `after`로 넘긴다(가이드 §5). `hasPreviousPage`는 쓰지 않는다 — 앞으로만 가는
/// 피드라 신뢰할 수 없는 값이다.
class NearbyFeedState {
  const NearbyFeedState({
    required this.items,
    required this.hasMore,
    this.endCursor,
    this.isLoadingMore = false,
  });

  /// 지금까지 받은 글 전부(페이지 경계 없이 이어 붙인 것).
  final List<Post> items;
  final bool hasMore;
  final String? endCursor;

  /// 추가 페이지를 받는 중인지. 첫 로딩(`AsyncValue.loading`)과 구분해 하단
  /// 인디케이터만 띄우기 위한 값이다.
  final bool isLoadingMore;

  /// 글이 하나도 없고 더 받을 것도 없는 상태 — 빈 피드 문구를 띄운다. 위치 실패와는
  /// **다른 상태**이며 화면이 둘을 구분해 보여준다(설계 §3).
  bool get isEmpty => items.isEmpty && !hasMore;

  NearbyFeedState copyWith({
    List<Post>? items,
    bool? hasMore,
    String? endCursor,
    bool? isLoadingMore,
  }) => NearbyFeedState(
    items: items ?? this.items,
    hasMore: hasMore ?? this.hasMore,
    endCursor: endCursor ?? this.endCursor,
    isLoadingMore: isLoadingMore ?? this.isLoadingMore,
  );
}

/// 좌표 기반 지역 피드(R7·R8). [topic]별 패밀리 — 태그를 바꾸면 다른 인스턴스가
/// 로딩되고 **필터링은 서버가 한다**(클라이언트가 받은 목록을 거르지 않는다).
///
/// 좌표는 앱이 이미 쓰고 있는 [currentCoordinatesProvider]를 그대로 쓴다 — 이 스펙이
/// 새로 수집하는 항목은 없다(설계 §3). 위치를 얻지 못하면 그 실패가 `AsyncValue.error`로
/// 올라와 화면이 **빈 피드와 구분되는 사유**를 보여준다.
///
/// 조회는 미인증으로도 되므로(가이드 §13) 로그인 여부로 분기하지 않는다.
/// `likedByViewer`·`ownedByViewer`가 false로 올 뿐이다.
@Riverpod(retry: communityRetryPolicy)
class NearbyFeedController extends _$NearbyFeedController {
  CommunityRepository get _repository => ref.read(communityRepositoryProvider);

  @override
  Future<NearbyFeedState> build(PostTopic? topic) async {
    final Coordinates coords = await ref.watch(
      currentCoordinatesProvider.future,
    );
    final CursorPage<Post> page = await _repository.fetchNearbyPosts(
      latitude: coords.latitude,
      longitude: coords.longitude,
      topic: topic,
      first: _pageSize,
    );
    return NearbyFeedState(
      items: page.items,
      hasMore: page.hasNextPage,
      endCursor: page.endCursor,
    );
  }

  /// 다음 페이지를 이어 붙인다. 더 받을 것이 없거나 이미 받는 중이면 아무것도 하지
  /// 않는다 — 스크롤 끝에서 중복 호출이 들어와도 안전하다.
  Future<void> loadMore() async {
    final NearbyFeedState? current = state.value;
    if (current == null || !current.hasMore || current.isLoadingMore) return;

    final Coordinates? coords = ref.read(currentCoordinatesProvider).value;
    // 첫 페이지를 받은 뒤이므로 좌표는 이미 있다. 없다면 조용히 멈춘다 — 여기서
    // 좌표를 새로 얻으려 들면 걸어 다니는 사용자의 피드 순서가 페이지마다 어긋난다.
    if (coords == null) return;

    state = AsyncData<NearbyFeedState>(current.copyWith(isLoadingMore: true));
    try {
      final CursorPage<Post> next = await _repository.fetchNearbyPosts(
        latitude: coords.latitude,
        longitude: coords.longitude,
        topic: topic,
        first: _pageSize,
        after: current.endCursor,
      );
      state = AsyncData<NearbyFeedState>(
        NearbyFeedState(
          items: <Post>[...current.items, ...next.items],
          hasMore: next.hasNextPage,
          endCursor: next.endCursor,
        ),
      );
    } on Object catch (error) {
      // 추가 로딩 실패는 이미 보고 있는 목록을 지우지 않는다 — 인디케이터만 걷는다.
      // hasMore가 그대로라 다시 스크롤하면 재시도된다. 서버 message는 PII를 담을 수
      // 있어 싣지 않고 실패 유형만 남긴다(POL-013).
      developer.log(
        'nearbyPosts loadMore failed: ${error.runtimeType}',
        name: 'NearbyFeedController',
      );
      state = AsyncData<NearbyFeedState>(
        current.copyWith(isLoadingMore: false),
      );
    }
  }

  /// 좋아요 토글(R12, 낙관적). 즉시 눌림 상태와 수를 바꾸고, 뮤테이션이 실패하면
  /// 이전 값으로 되돌린다(설계 §5).
  ///
  /// 성공 시에는 **서버가 돌려준 `likeCount`로 되맞춘다** — 멱등이라 이미 좋아요한
  /// 글에 다시 눌러도 성공이고, 그때 서버 값이 낙관적 예측과 다를 수 있다. 서버 값이
  /// 정본이다(가이드 §8).
  Future<void> toggleLike(String postId) async {
    final NearbyFeedState? current = state.value;
    if (current == null) return;

    final int index = current.items.indexWhere((Post p) => p.id == postId);
    if (index < 0) return;
    final Post original = current.items[index];
    final bool liking = !original.likedByViewer;

    void replace(Post post) {
      final NearbyFeedState? latest = state.value;
      if (latest == null) return;
      final List<Post> items = <Post>[...latest.items];
      final int at = items.indexWhere((Post p) => p.id == postId);
      if (at < 0) return;
      items[at] = post;
      state = AsyncData<NearbyFeedState>(latest.copyWith(items: items));
    }

    replace(
      original.copyWith(
        likedByViewer: liking,
        likeCount: (original.likeCount + (liking ? 1 : -1)).clamp(0, 1 << 31),
      ),
    );

    try {
      final int? serverCount = liking
          ? await _repository.likePost(postId)
          : await _repository.unlikePost(postId);
      if (serverCount != null) {
        replace(
          original.copyWith(likedByViewer: liking, likeCount: serverCount),
        );
      }
    } on Object catch (error) {
      // 실패 — 이전 값으로 롤백한다. 미인증이면 CommunityFailure.unauthenticated가
      // 오고, 로그인 유도는 화면이 담당한다(설계 §3).
      developer.log(
        'toggleLike failed: ${error.runtimeType}',
        name: 'NearbyFeedController',
      );
      replace(original);
      rethrow;
    }
  }
}
