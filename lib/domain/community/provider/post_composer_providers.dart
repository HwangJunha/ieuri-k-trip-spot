import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../model/community_failure.dart';
import '../model/post_draft.dart';
import '../model/post_topic.dart';
import '../repository/community_repository.dart';
import 'community_providers.dart';

part 'post_composer_providers.g.dart';

/// 등록 시도의 결과. 화면이 이 값으로 다음 행동을 고른다.
sealed class ComposerResult {
  const ComposerResult();
}

/// 등록 성공. [postId]로 상세를 다시 조회하거나 피드를 새로 고친다 —
/// **`createPost`는 `postId`만 주고 `post`는 항상 null이다**(가이드 §11).
class ComposerSucceeded extends ComposerResult {
  const ComposerSucceeded(this.postId);

  /// 서버가 준 새 글 id. 스키마상 nullable이라 null일 수 있고, 그때는 상세로 가는
  /// 대신 피드만 새로 고친다.
  final String? postId;
}

/// 서버가 `userErrors`로 거부했다. [code]를 화면이 필드별 메시지로 옮긴다 —
/// `POST_BODY_REQUIRED`·`POST_BODY_LENGTH_INVALID`·`SPOT_NOT_FOUND`·
/// `TOO_MANY_PHOTOS`(가이드 §7).
class ComposerRejected extends ComposerResult {
  const ComposerRejected(this.code);

  final String? code;
}

/// 로그인이 필요하다(가이드 §13). 화면이 로그인으로 유도한다.
class ComposerUnauthenticated extends ComposerResult {
  const ComposerUnauthenticated();
}

/// 전송 실패. 재시도 안내를 띄운다.
class ComposerFailed extends ComposerResult {
  const ComposerFailed();
}

/// 컴포저가 편집 중인 초안(R1~R4). 화면 하나에 속한 상태라 autoDispose(codegen 기본)로
/// 둔다 — 컴포저를 닫으면 초안이 사라지는 것이 맞다.
///
/// **등록 가능 여부는 [PostDraft.canSubmit]이 판정한다.** 서버 검증을 기다렸다가
/// 에러를 보여주는 방식이 아니라 화면이 애초에 잘못된 상태를 만들지 못하게 한다
/// (설계 §3, R1-1).
@riverpod
class PostComposer extends _$PostComposer {
  /// [initialTargetId]가 주어지면 관광지 상세에서 진입한 것이라 대상이 이미
  /// 정해져 있다. 커뮤니티 탭에서 진입하면 null이고 화면이 대상 선택을 요구한다
  /// (디자인 §3).
  @override
  PostDraft build({String? initialTargetId, String? initialTargetTitle}) =>
      PostDraft(targetId: initialTargetId, targetTitle: initialTargetTitle);

  void setTopic(PostTopic? topic) => state = PostDraft(
    targetType: state.targetType,
    targetId: state.targetId,
    targetTitle: state.targetTitle,
    // 같은 태그를 다시 누르면 해제 — 칩 행과 같은 규약이다.
    topic: state.topic == topic ? null : topic,
    body: state.body,
    photoKeys: state.photoKeys,
  );

  /// 본문을 갱신한다. **500자를 넘어도 자르지 않는다** — 초과분을 드러내고 등록만
  /// 막는다(설계 §3: 붙여넣기한 유저가 무엇이 사라졌는지 모르면 안 된다).
  void setBody(String body) => state = state.copyWith(body: body);

  void setTarget({required String id, required String title}) =>
      state = state.copyWith(targetId: id, targetTitle: title);

  CommunityRepository get _repository => ref.read(communityRepositoryProvider);

  /// 등록한다. [PostDraft.canSubmit]이 false면 아무것도 하지 않는다 — 버튼이 이미
  /// 비활성이지만, 상태와 판정을 한 곳에 두어 화면이 우회할 수 없게 한다.
  Future<ComposerResult> submit() async {
    final PostDraft draft = state;
    if (!draft.canSubmit) return const ComposerFailed();

    try {
      final String? postId = await _repository.createPost(
        targetType: draft.targetType,
        targetId: draft.targetId!,
        topic: draft.topic!,
        body: draft.body.trim(),
        photoKeys: draft.photoKeys,
      );
      return ComposerSucceeded(postId);
    } on CommunityFailure catch (failure) {
      if (failure.kind == CommunityFailureKind.unauthenticated) {
        return const ComposerUnauthenticated();
      }
      if (failure.kind == CommunityFailureKind.userError) {
        return ComposerRejected(failure.code);
      }
      return const ComposerFailed();
    } on Object {
      return const ComposerFailed();
    }
  }
}
