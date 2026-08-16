// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversation_list_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 헤더의 미읽음 점 배지가 보는 값.
///
/// **대화 목록 provider를 직접 watch하지 않기 위해 존재한다.** 배지가 목록을 구독하면
/// 둘러보기 탭에 들어서는 것만으로 대화 20건 조회가 나간다 — 점 하나 그리자고 낼
/// 비용이 아니다. 목록을 실제로 불러온 화면이 이 값을 갱신하고, 배지는 값만 읽는다.
///
/// 그래서 **앱을 켜고 대화 목록에 한 번도 안 들어갔으면 점이 뜨지 않는다.** 서버가
/// 전체 미읽음 합계를 주지 않는 이상(계약에 없다) 이보다 정확하게 만들 수 없다.

@ProviderFor(UnreadConversationsFlag)
const unreadConversationsFlagProvider = UnreadConversationsFlagProvider._();

/// 헤더의 미읽음 점 배지가 보는 값.
///
/// **대화 목록 provider를 직접 watch하지 않기 위해 존재한다.** 배지가 목록을 구독하면
/// 둘러보기 탭에 들어서는 것만으로 대화 20건 조회가 나간다 — 점 하나 그리자고 낼
/// 비용이 아니다. 목록을 실제로 불러온 화면이 이 값을 갱신하고, 배지는 값만 읽는다.
///
/// 그래서 **앱을 켜고 대화 목록에 한 번도 안 들어갔으면 점이 뜨지 않는다.** 서버가
/// 전체 미읽음 합계를 주지 않는 이상(계약에 없다) 이보다 정확하게 만들 수 없다.
final class UnreadConversationsFlagProvider
    extends $NotifierProvider<UnreadConversationsFlag, bool> {
  /// 헤더의 미읽음 점 배지가 보는 값.
  ///
  /// **대화 목록 provider를 직접 watch하지 않기 위해 존재한다.** 배지가 목록을 구독하면
  /// 둘러보기 탭에 들어서는 것만으로 대화 20건 조회가 나간다 — 점 하나 그리자고 낼
  /// 비용이 아니다. 목록을 실제로 불러온 화면이 이 값을 갱신하고, 배지는 값만 읽는다.
  ///
  /// 그래서 **앱을 켜고 대화 목록에 한 번도 안 들어갔으면 점이 뜨지 않는다.** 서버가
  /// 전체 미읽음 합계를 주지 않는 이상(계약에 없다) 이보다 정확하게 만들 수 없다.
  const UnreadConversationsFlagProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'unreadConversationsFlagProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$unreadConversationsFlagHash();

  @$internal
  @override
  UnreadConversationsFlag create() => UnreadConversationsFlag();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$unreadConversationsFlagHash() =>
    r'e43ee1435544550174d249bda3340aba2baf7a41';

/// 헤더의 미읽음 점 배지가 보는 값.
///
/// **대화 목록 provider를 직접 watch하지 않기 위해 존재한다.** 배지가 목록을 구독하면
/// 둘러보기 탭에 들어서는 것만으로 대화 20건 조회가 나간다 — 점 하나 그리자고 낼
/// 비용이 아니다. 목록을 실제로 불러온 화면이 이 값을 갱신하고, 배지는 값만 읽는다.
///
/// 그래서 **앱을 켜고 대화 목록에 한 번도 안 들어갔으면 점이 뜨지 않는다.** 서버가
/// 전체 미읽음 합계를 주지 않는 이상(계약에 없다) 이보다 정확하게 만들 수 없다.

abstract class _$UnreadConversationsFlag extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

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
        retry: dmRetryPolicy,
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
    r'b93295ac1aa9ff5fed5a07b2ee7e2f95ea3fb638';

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
