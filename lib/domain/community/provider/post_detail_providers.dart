import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../model/post.dart';
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
@Riverpod(retry: communityRetryPolicy)
Future<Post?> postDetail(Ref ref, String postId) =>
    ref.watch(communityRepositoryProvider).fetchPost(postId);
