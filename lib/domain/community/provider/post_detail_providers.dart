
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:logger/logger.dart';

import '../../../common/analytics/analytics_events.dart';
import '../../../common/analytics/app_analytics.dart';
import '../../../common/log/app_log.dart';
import '../../../common/model/post.dart';
import 'community_providers.dart';

part 'post_detail_providers.g.dart';

/// 글 상세. [postId]별 패밀리 — id를 인자로 두면 codegen이 family를 만든다
/// (CLAUDE.md §5, provider를 복제하지 않는다).
///
/// **`null`은 오류가 아니다.** 차단·숨김·삭제면 서버가 오류 대신 null을 주므로
/// (가이드 §6) 그대로 데이터로 올리고, 화면이 "삭제되었거나 볼 수 없는 글" 안내를
/// 띄운다. `errors[]`를 기대하면 안 된다.
///
/// **댓글은 여기 없다** — 루트 쿼리가 되면서 `commentsControllerProvider`가 따로
/// 받는다(가이드 §2). 덕분에 댓글 조회가 실패해도 글 본문은 그대로 뜬다.
/// **좋아요 토글을 위해 클래스 노티파이어다.** 함수형 provider는 상태를 밖에서
/// 바꿀 수 없어 낙관적 갱신을 할 수 없다. `postDetailProvider(id)` 이름과 family
/// 시그니처는 그대로라 기존 호출부(watch/invalidate)는 영향받지 않는다.
@Riverpod(retry: communityRetryPolicy)
class PostDetail extends _$PostDetail {
  static final Logger _log = appLogger('PostDetail');

  @override
  Future<Post?> build(String postId) =>
      ref.watch(communityRepositoryProvider).fetchPost(postId);

  /// 좋아요 토글.
  ///
  /// **목록의 `FeedController.toggleLike`를 상세에서 쓸 수 없어 따로 둔다** — 그쪽은
  /// `items` 리스트에서 postId를 찾아 갈아 끼우는 구조라, 상세로 딥링크 진입해 목록이
  /// 비어 있으면 `indexWhere`가 -1이라 조용히 아무 일도 하지 않는다.
  ///
  /// 낙관적 갱신 → 서버 `likeCount`로 되맞춤 → 실패 시 롤백. 규약은 목록과 같다
  /// (멱등이므로 서버 값이 정본이다).
  Future<void> toggleLike() async {
    final Post? original = state.value;
    if (original == null) return;
    final bool liking = !original.likedByViewer;

    state = AsyncData<Post?>(
      original.copyWith(
        likedByViewer: liking,
        likeCount: (original.likeCount + (liking ? 1 : -1)).clamp(0, 1 << 31),
      ),
    );

    try {
      final int? serverCount = liking
          ? await ref.read(communityRepositoryProvider).likePost(postId)
          : await ref.read(communityRepositoryProvider).unlikePost(postId);
      if (serverCount != null) {
        state = AsyncData<Post?>(
          original.copyWith(likedByViewer: liking, likeCount: serverCount),
        );
      }
      // 목록(`FeedController.toggleLike`)과 **의도적으로 분리된 별개 구현**이라
      // 양쪽에 심는다 — 딥링크로 상세에 바로 들어오면 목록이 비어 있어 이 경로만
      // 탄다.
      AppAnalytics.logEvent(AnalyticsEvents.likeToggle, <String, Object>{
        AnalyticsParams.target: 'post',
        AnalyticsParams.liked: liking,
      });
    } on Object catch (error) {
      // 실패 — 이전 값으로 롤백한다. 미인증 유도는 화면이 담당한다.
      _log.w('toggleLike failed: ${error.runtimeType}');
      state = AsyncData<Post?>(original);
      rethrow;
    }
  }
}
