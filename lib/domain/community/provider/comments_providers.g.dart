// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comments_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 글 하나의 최상위 댓글과 각 댓글의 답글(가이드 §2, 2차 가이드 §1). [postId]별
/// 패밀리 — id를 인자로 두면 codegen이 family를 만든다(CLAUDE.md §5).
///
/// **[CommentsState.items]는 최상위 댓글만 담는다** — 답글은 각 [Comment.replies]
/// 안에 있다. 그래서 목록 길이는 답글을 세지 않으며, `commentCount`는 답글까지
/// 포함하므로 둘이 다른 것이 정상이다(§6의 차단 불일치와 겹쳐 두 배로 어긋날 수
/// 있다).
///
/// **`comments`가 루트 쿼리라서 provider도 글과 분리돼 있다.** 예전에는 글 상세
/// 응답에 댓글이 중첩돼 있었는데, 그 구조에서는 목록 안의 목록을 페이지네이션해야 해
/// 어느 카드의 커서인지 추적할 수 없었다. 지금은 상세 화면이 글과 댓글을 각각
/// 받으며, **댓글 조회가 실패해도 글 본문은 그대로 뜬다.**
///
/// **`commentCount`와 이 목록의 길이가 달라도 오류가 아니다** — 숫자는 차단을
/// 반영하지 않고 목록은 반영하기 때문이다(가이드 §6).

@ProviderFor(CommentsController)
const commentsControllerProvider = CommentsControllerFamily._();

/// 글 하나의 최상위 댓글과 각 댓글의 답글(가이드 §2, 2차 가이드 §1). [postId]별
/// 패밀리 — id를 인자로 두면 codegen이 family를 만든다(CLAUDE.md §5).
///
/// **[CommentsState.items]는 최상위 댓글만 담는다** — 답글은 각 [Comment.replies]
/// 안에 있다. 그래서 목록 길이는 답글을 세지 않으며, `commentCount`는 답글까지
/// 포함하므로 둘이 다른 것이 정상이다(§6의 차단 불일치와 겹쳐 두 배로 어긋날 수
/// 있다).
///
/// **`comments`가 루트 쿼리라서 provider도 글과 분리돼 있다.** 예전에는 글 상세
/// 응답에 댓글이 중첩돼 있었는데, 그 구조에서는 목록 안의 목록을 페이지네이션해야 해
/// 어느 카드의 커서인지 추적할 수 없었다. 지금은 상세 화면이 글과 댓글을 각각
/// 받으며, **댓글 조회가 실패해도 글 본문은 그대로 뜬다.**
///
/// **`commentCount`와 이 목록의 길이가 달라도 오류가 아니다** — 숫자는 차단을
/// 반영하지 않고 목록은 반영하기 때문이다(가이드 §6).
final class CommentsControllerProvider
    extends $AsyncNotifierProvider<CommentsController, CommentsState> {
  /// 글 하나의 최상위 댓글과 각 댓글의 답글(가이드 §2, 2차 가이드 §1). [postId]별
  /// 패밀리 — id를 인자로 두면 codegen이 family를 만든다(CLAUDE.md §5).
  ///
  /// **[CommentsState.items]는 최상위 댓글만 담는다** — 답글은 각 [Comment.replies]
  /// 안에 있다. 그래서 목록 길이는 답글을 세지 않으며, `commentCount`는 답글까지
  /// 포함하므로 둘이 다른 것이 정상이다(§6의 차단 불일치와 겹쳐 두 배로 어긋날 수
  /// 있다).
  ///
  /// **`comments`가 루트 쿼리라서 provider도 글과 분리돼 있다.** 예전에는 글 상세
  /// 응답에 댓글이 중첩돼 있었는데, 그 구조에서는 목록 안의 목록을 페이지네이션해야 해
  /// 어느 카드의 커서인지 추적할 수 없었다. 지금은 상세 화면이 글과 댓글을 각각
  /// 받으며, **댓글 조회가 실패해도 글 본문은 그대로 뜬다.**
  ///
  /// **`commentCount`와 이 목록의 길이가 달라도 오류가 아니다** — 숫자는 차단을
  /// 반영하지 않고 목록은 반영하기 때문이다(가이드 §6).
  const CommentsControllerProvider._({
    required CommentsControllerFamily super.from,
    required String super.argument,
  }) : super(
         retry: communityRetryPolicy,
         name: r'commentsControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$commentsControllerHash();

  @override
  String toString() {
    return r'commentsControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  CommentsController create() => CommentsController();

  @override
  bool operator ==(Object other) {
    return other is CommentsControllerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$commentsControllerHash() =>
    r'bdf2c46bfcf1676cf400e97fdebbca19b85eae03';

/// 글 하나의 최상위 댓글과 각 댓글의 답글(가이드 §2, 2차 가이드 §1). [postId]별
/// 패밀리 — id를 인자로 두면 codegen이 family를 만든다(CLAUDE.md §5).
///
/// **[CommentsState.items]는 최상위 댓글만 담는다** — 답글은 각 [Comment.replies]
/// 안에 있다. 그래서 목록 길이는 답글을 세지 않으며, `commentCount`는 답글까지
/// 포함하므로 둘이 다른 것이 정상이다(§6의 차단 불일치와 겹쳐 두 배로 어긋날 수
/// 있다).
///
/// **`comments`가 루트 쿼리라서 provider도 글과 분리돼 있다.** 예전에는 글 상세
/// 응답에 댓글이 중첩돼 있었는데, 그 구조에서는 목록 안의 목록을 페이지네이션해야 해
/// 어느 카드의 커서인지 추적할 수 없었다. 지금은 상세 화면이 글과 댓글을 각각
/// 받으며, **댓글 조회가 실패해도 글 본문은 그대로 뜬다.**
///
/// **`commentCount`와 이 목록의 길이가 달라도 오류가 아니다** — 숫자는 차단을
/// 반영하지 않고 목록은 반영하기 때문이다(가이드 §6).

final class CommentsControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          CommentsController,
          AsyncValue<CommentsState>,
          CommentsState,
          FutureOr<CommentsState>,
          String
        > {
  const CommentsControllerFamily._()
    : super(
        retry: communityRetryPolicy,
        name: r'commentsControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// 글 하나의 최상위 댓글과 각 댓글의 답글(가이드 §2, 2차 가이드 §1). [postId]별
  /// 패밀리 — id를 인자로 두면 codegen이 family를 만든다(CLAUDE.md §5).
  ///
  /// **[CommentsState.items]는 최상위 댓글만 담는다** — 답글은 각 [Comment.replies]
  /// 안에 있다. 그래서 목록 길이는 답글을 세지 않으며, `commentCount`는 답글까지
  /// 포함하므로 둘이 다른 것이 정상이다(§6의 차단 불일치와 겹쳐 두 배로 어긋날 수
  /// 있다).
  ///
  /// **`comments`가 루트 쿼리라서 provider도 글과 분리돼 있다.** 예전에는 글 상세
  /// 응답에 댓글이 중첩돼 있었는데, 그 구조에서는 목록 안의 목록을 페이지네이션해야 해
  /// 어느 카드의 커서인지 추적할 수 없었다. 지금은 상세 화면이 글과 댓글을 각각
  /// 받으며, **댓글 조회가 실패해도 글 본문은 그대로 뜬다.**
  ///
  /// **`commentCount`와 이 목록의 길이가 달라도 오류가 아니다** — 숫자는 차단을
  /// 반영하지 않고 목록은 반영하기 때문이다(가이드 §6).

  CommentsControllerProvider call(String postId) =>
      CommentsControllerProvider._(argument: postId, from: this);

  @override
  String toString() => r'commentsControllerProvider';
}

/// 글 하나의 최상위 댓글과 각 댓글의 답글(가이드 §2, 2차 가이드 §1). [postId]별
/// 패밀리 — id를 인자로 두면 codegen이 family를 만든다(CLAUDE.md §5).
///
/// **[CommentsState.items]는 최상위 댓글만 담는다** — 답글은 각 [Comment.replies]
/// 안에 있다. 그래서 목록 길이는 답글을 세지 않으며, `commentCount`는 답글까지
/// 포함하므로 둘이 다른 것이 정상이다(§6의 차단 불일치와 겹쳐 두 배로 어긋날 수
/// 있다).
///
/// **`comments`가 루트 쿼리라서 provider도 글과 분리돼 있다.** 예전에는 글 상세
/// 응답에 댓글이 중첩돼 있었는데, 그 구조에서는 목록 안의 목록을 페이지네이션해야 해
/// 어느 카드의 커서인지 추적할 수 없었다. 지금은 상세 화면이 글과 댓글을 각각
/// 받으며, **댓글 조회가 실패해도 글 본문은 그대로 뜬다.**
///
/// **`commentCount`와 이 목록의 길이가 달라도 오류가 아니다** — 숫자는 차단을
/// 반영하지 않고 목록은 반영하기 때문이다(가이드 §6).

abstract class _$CommentsController extends $AsyncNotifier<CommentsState> {
  late final _$args = ref.$arg as String;
  String get postId => _$args;

  FutureOr<CommentsState> build(String postId);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
    final ref = this.ref as $Ref<AsyncValue<CommentsState>, CommentsState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<CommentsState>, CommentsState>,
              AsyncValue<CommentsState>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
