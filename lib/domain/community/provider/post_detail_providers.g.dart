// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_detail_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
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

@ProviderFor(PostDetail)
const postDetailProvider = PostDetailFamily._();

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
final class PostDetailProvider
    extends $AsyncNotifierProvider<PostDetail, Post?> {
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
  const PostDetailProvider._({
    required PostDetailFamily super.from,
    required String super.argument,
  }) : super(
         retry: communityRetryPolicy,
         name: r'postDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$postDetailHash();

  @override
  String toString() {
    return r'postDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  PostDetail create() => PostDetail();

  @override
  bool operator ==(Object other) {
    return other is PostDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$postDetailHash() => r'be8a5a74bbb7e4c72a3ff2d3f05590b079e0df0e';

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

final class PostDetailFamily extends $Family
    with
        $ClassFamilyOverride<
          PostDetail,
          AsyncValue<Post?>,
          Post?,
          FutureOr<Post?>,
          String
        > {
  const PostDetailFamily._()
    : super(
        retry: communityRetryPolicy,
        name: r'postDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

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

  PostDetailProvider call(String postId) =>
      PostDetailProvider._(argument: postId, from: this);

  @override
  String toString() => r'postDetailProvider';
}

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

abstract class _$PostDetail extends $AsyncNotifier<Post?> {
  late final _$args = ref.$arg as String;
  String get postId => _$args;

  FutureOr<Post?> build(String postId);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
    final ref = this.ref as $Ref<AsyncValue<Post?>, Post?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<Post?>, Post?>,
              AsyncValue<Post?>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
