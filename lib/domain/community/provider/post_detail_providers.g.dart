// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_detail_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 글 상세(R13). [postId]별 패밀리 — id를 인자로 두면 codegen이 family를 만든다
/// (CLAUDE.md §5, provider를 복제하지 않는다).
///
/// **`null`은 오류가 아니다.** 차단·숨김이면 서버가 오류 대신 null을 주므로(가이드 §6)
/// 그대로 데이터로 올리고, 화면이 "삭제되었거나 볼 수 없는 글" 안내를 띄운다.
/// `errors[]`를 기대하면 안 된다.
///
/// 댓글은 여기서만 함께 받는다 — 목록에서 요청하면 20건짜리 피드에 댓글 쿼리가
/// 20번 붙는다(가이드 §4).

@ProviderFor(postDetail)
const postDetailProvider = PostDetailFamily._();

/// 글 상세(R13). [postId]별 패밀리 — id를 인자로 두면 codegen이 family를 만든다
/// (CLAUDE.md §5, provider를 복제하지 않는다).
///
/// **`null`은 오류가 아니다.** 차단·숨김이면 서버가 오류 대신 null을 주므로(가이드 §6)
/// 그대로 데이터로 올리고, 화면이 "삭제되었거나 볼 수 없는 글" 안내를 띄운다.
/// `errors[]`를 기대하면 안 된다.
///
/// 댓글은 여기서만 함께 받는다 — 목록에서 요청하면 20건짜리 피드에 댓글 쿼리가
/// 20번 붙는다(가이드 §4).

final class PostDetailProvider
    extends $FunctionalProvider<AsyncValue<Post?>, Post?, FutureOr<Post?>>
    with $FutureModifier<Post?>, $FutureProvider<Post?> {
  /// 글 상세(R13). [postId]별 패밀리 — id를 인자로 두면 codegen이 family를 만든다
  /// (CLAUDE.md §5, provider를 복제하지 않는다).
  ///
  /// **`null`은 오류가 아니다.** 차단·숨김이면 서버가 오류 대신 null을 주므로(가이드 §6)
  /// 그대로 데이터로 올리고, 화면이 "삭제되었거나 볼 수 없는 글" 안내를 띄운다.
  /// `errors[]`를 기대하면 안 된다.
  ///
  /// 댓글은 여기서만 함께 받는다 — 목록에서 요청하면 20건짜리 피드에 댓글 쿼리가
  /// 20번 붙는다(가이드 §4).
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

String _$postDetailHash() => r'ad1c345d5a12d1f7d916af0e49a7c561b732f949';

/// 글 상세(R13). [postId]별 패밀리 — id를 인자로 두면 codegen이 family를 만든다
/// (CLAUDE.md §5, provider를 복제하지 않는다).
///
/// **`null`은 오류가 아니다.** 차단·숨김이면 서버가 오류 대신 null을 주므로(가이드 §6)
/// 그대로 데이터로 올리고, 화면이 "삭제되었거나 볼 수 없는 글" 안내를 띄운다.
/// `errors[]`를 기대하면 안 된다.
///
/// 댓글은 여기서만 함께 받는다 — 목록에서 요청하면 20건짜리 피드에 댓글 쿼리가
/// 20번 붙는다(가이드 §4).

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

  /// 글 상세(R13). [postId]별 패밀리 — id를 인자로 두면 codegen이 family를 만든다
  /// (CLAUDE.md §5, provider를 복제하지 않는다).
  ///
  /// **`null`은 오류가 아니다.** 차단·숨김이면 서버가 오류 대신 null을 주므로(가이드 §6)
  /// 그대로 데이터로 올리고, 화면이 "삭제되었거나 볼 수 없는 글" 안내를 띄운다.
  /// `errors[]`를 기대하면 안 된다.
  ///
  /// 댓글은 여기서만 함께 받는다 — 목록에서 요청하면 20건짜리 피드에 댓글 쿼리가
  /// 20번 붙는다(가이드 §4).

  PostDetailProvider call(String postId) =>
      PostDetailProvider._(argument: postId, from: this);

  @override
  String toString() => r'postDetailProvider';
}
