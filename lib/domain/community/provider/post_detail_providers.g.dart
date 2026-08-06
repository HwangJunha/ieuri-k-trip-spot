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

@ProviderFor(postDetail)
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

final class PostDetailProvider
    extends $FunctionalProvider<AsyncValue<Post?>, Post?, FutureOr<Post?>>
    with $FutureModifier<Post?>, $FutureProvider<Post?> {
  /// 글 상세. [postId]별 패밀리 — id를 인자로 두면 codegen이 family를 만든다
  /// (CLAUDE.md §5, provider를 복제하지 않는다).
  ///
  /// **`null`은 오류가 아니다.** 차단·숨김·삭제면 서버가 오류 대신 null을 주므로
  /// (가이드 §6) 그대로 데이터로 올리고, 화면이 "삭제되었거나 볼 수 없는 글" 안내를
  /// 띄운다. `errors[]`를 기대하면 안 된다.
  ///
  /// **댓글은 여기 없다** — 루트 쿼리가 되면서 `commentsControllerProvider`가 따로
  /// 받는다(가이드 §2). 덕분에 댓글 조회가 실패해도 글 본문은 그대로 뜬다.
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
  $FutureProviderElement<Post?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Post?> create(Ref ref) {
    final argument = this.argument as String;
    return postDetail(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is PostDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$postDetailHash() => r'8ec7bfa0ec2c6190a76bb706fd9eed237392fd61';

/// 글 상세. [postId]별 패밀리 — id를 인자로 두면 codegen이 family를 만든다
/// (CLAUDE.md §5, provider를 복제하지 않는다).
///
/// **`null`은 오류가 아니다.** 차단·숨김·삭제면 서버가 오류 대신 null을 주므로
/// (가이드 §6) 그대로 데이터로 올리고, 화면이 "삭제되었거나 볼 수 없는 글" 안내를
/// 띄운다. `errors[]`를 기대하면 안 된다.
///
/// **댓글은 여기 없다** — 루트 쿼리가 되면서 `commentsControllerProvider`가 따로
/// 받는다(가이드 §2). 덕분에 댓글 조회가 실패해도 글 본문은 그대로 뜬다.

final class PostDetailFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Post?>, String> {
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

  PostDetailProvider call(String postId) =>
      PostDetailProvider._(argument: postId, from: this);

  @override
  String toString() => r'postDetailProvider';
}
