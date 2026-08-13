// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversation_list_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 내가 참여한 대화 목록(R8).
///
/// **keepAlive가 아니다.** 대화 목록은 열 때마다 최신이어야 하고, 읽음 처리·새
/// 메시지로 배지가 수시로 바뀐다 — 세션에 붙들어 두면 낡은 미읽음 수가 남는다.

@ProviderFor(ConversationListController)
const conversationListControllerProvider =
    ConversationListControllerProvider._();

/// 내가 참여한 대화 목록(R8).
///
/// **keepAlive가 아니다.** 대화 목록은 열 때마다 최신이어야 하고, 읽음 처리·새
/// 메시지로 배지가 수시로 바뀐다 — 세션에 붙들어 두면 낡은 미읽음 수가 남는다.
final class ConversationListControllerProvider
    extends
        $AsyncNotifierProvider<
          ConversationListController,
          ConversationListState
        > {
  /// 내가 참여한 대화 목록(R8).
  ///
  /// **keepAlive가 아니다.** 대화 목록은 열 때마다 최신이어야 하고, 읽음 처리·새
  /// 메시지로 배지가 수시로 바뀐다 — 세션에 붙들어 두면 낡은 미읽음 수가 남는다.
  const ConversationListControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: feedRetryPolicy,
        name: r'conversationListControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$conversationListControllerHash();

  @$internal
  @override
  ConversationListController create() => ConversationListController();
}

String _$conversationListControllerHash() =>
    r'c73db23c2a9dbcfb841d0800e7eb3f96befc2d36';

/// 내가 참여한 대화 목록(R8).
///
/// **keepAlive가 아니다.** 대화 목록은 열 때마다 최신이어야 하고, 읽음 처리·새
/// 메시지로 배지가 수시로 바뀐다 — 세션에 붙들어 두면 낡은 미읽음 수가 남는다.

abstract class _$ConversationListController
    extends $AsyncNotifier<ConversationListState> {
  FutureOr<ConversationListState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<AsyncValue<ConversationListState>, ConversationListState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<ConversationListState>,
                ConversationListState
              >,
              AsyncValue<ConversationListState>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
