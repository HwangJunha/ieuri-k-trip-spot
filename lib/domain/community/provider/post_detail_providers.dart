import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../model/post.dart';
import 'community_providers.dart';

part 'post_detail_providers.g.dart';

/// 상세에서 함께 받는 댓글 첫 페이지 크기.
const int _commentPageSize = 20;

/// 글 상세(R13). [postId]별 패밀리 — id를 인자로 두면 codegen이 family를 만든다
/// (CLAUDE.md §5, provider를 복제하지 않는다).
///
/// **`null`은 오류가 아니다.** 차단·숨김이면 서버가 오류 대신 null을 주므로(가이드 §6)
/// 그대로 데이터로 올리고, 화면이 "삭제되었거나 볼 수 없는 글" 안내를 띄운다.
/// `errors[]`를 기대하면 안 된다.
///
/// 댓글은 여기서만 함께 받는다 — 목록에서 요청하면 20건짜리 피드에 댓글 쿼리가
/// 20번 붙는다(가이드 §4).
@Riverpod(retry: communityRetryPolicy)
Future<Post?> postDetail(Ref ref, String postId) => ref
    .watch(communityRepositoryProvider)
    .fetchPost(postId, commentCount: _commentPageSize);
