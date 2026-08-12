// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversation_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 로컬 메시지 캐시의 출처. 테스트가 이 provider를 오버라이드해 가짜 저장소를 준다.

@ProviderFor(messageCacheStore)
const messageCacheStoreProvider = MessageCacheStoreProvider._();

/// 로컬 메시지 캐시의 출처. 테스트가 이 provider를 오버라이드해 가짜 저장소를 준다.

final class MessageCacheStoreProvider
    extends
        $FunctionalProvider<
          MessageCacheStore,
          MessageCacheStore,
          MessageCacheStore
        >
    with $Provider<MessageCacheStore> {
  /// 로컬 메시지 캐시의 출처. 테스트가 이 provider를 오버라이드해 가짜 저장소를 준다.
  const MessageCacheStoreProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'messageCacheStoreProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$messageCacheStoreHash();

  @$internal
  @override
  $ProviderElement<MessageCacheStore> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  MessageCacheStore create(Ref ref) {
    return messageCacheStore(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MessageCacheStore value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MessageCacheStore>(value),
    );
  }
}

String _$messageCacheStoreHash() => r'07d53a3415e4d7f3220ab08d307a5e2039124bfe';

/// 한 대화의 메시지(R8·R9·R18).
///
/// **캐시를 먼저 그리고 서버 조회를 그 뒤에 얹는다**(AC18-1) — 빈 화면을 거치지
/// 않는다. 캐시가 비어 있어도 정상 동작하며(AC18-4), 서버에서 사라진 과거 메시지가
/// 로컬에 남아 있으면 그대로 보여준다(AC18-3).

@ProviderFor(ConversationController)
const conversationControllerProvider = ConversationControllerFamily._();

/// 한 대화의 메시지(R8·R9·R18).
///
/// **캐시를 먼저 그리고 서버 조회를 그 뒤에 얹는다**(AC18-1) — 빈 화면을 거치지
/// 않는다. 캐시가 비어 있어도 정상 동작하며(AC18-4), 서버에서 사라진 과거 메시지가
/// 로컬에 남아 있으면 그대로 보여준다(AC18-3).
final class ConversationControllerProvider
    extends $NotifierProvider<ConversationController, ConversationState> {
  /// 한 대화의 메시지(R8·R9·R18).
  ///
  /// **캐시를 먼저 그리고 서버 조회를 그 뒤에 얹는다**(AC18-1) — 빈 화면을 거치지
  /// 않는다. 캐시가 비어 있어도 정상 동작하며(AC18-4), 서버에서 사라진 과거 메시지가
  /// 로컬에 남아 있으면 그대로 보여준다(AC18-3).
  const ConversationControllerProvider._({
    required ConversationControllerFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'conversationControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$conversationControllerHash();

  @override
  String toString() {
    return r'conversationControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  ConversationController create() => ConversationController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ConversationState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ConversationState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ConversationControllerProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$conversationControllerHash() =>
    r'b1e6b8e8bda2a5c79046a5fbd40f9d08d93ebe90';

/// 한 대화의 메시지(R8·R9·R18).
///
/// **캐시를 먼저 그리고 서버 조회를 그 뒤에 얹는다**(AC18-1) — 빈 화면을 거치지
/// 않는다. 캐시가 비어 있어도 정상 동작하며(AC18-4), 서버에서 사라진 과거 메시지가
/// 로컬에 남아 있으면 그대로 보여준다(AC18-3).

final class ConversationControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          ConversationController,
          ConversationState,
          ConversationState,
          ConversationState,
          String
        > {
  const ConversationControllerFamily._()
    : super(
        retry: null,
        name: r'conversationControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// 한 대화의 메시지(R8·R9·R18).
  ///
  /// **캐시를 먼저 그리고 서버 조회를 그 뒤에 얹는다**(AC18-1) — 빈 화면을 거치지
  /// 않는다. 캐시가 비어 있어도 정상 동작하며(AC18-4), 서버에서 사라진 과거 메시지가
  /// 로컬에 남아 있으면 그대로 보여준다(AC18-3).

  ConversationControllerProvider call(String conversationId) =>
      ConversationControllerProvider._(argument: conversationId, from: this);

  @override
  String toString() => r'conversationControllerProvider';
}

/// 한 대화의 메시지(R8·R9·R18).
///
/// **캐시를 먼저 그리고 서버 조회를 그 뒤에 얹는다**(AC18-1) — 빈 화면을 거치지
/// 않는다. 캐시가 비어 있어도 정상 동작하며(AC18-4), 서버에서 사라진 과거 메시지가
/// 로컬에 남아 있으면 그대로 보여준다(AC18-3).

abstract class _$ConversationController extends $Notifier<ConversationState> {
  late final _$args = ref.$arg as String;
  String get conversationId => _$args;

  ConversationState build(String conversationId);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
    final ref = this.ref as $Ref<ConversationState, ConversationState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ConversationState, ConversationState>,
              ConversationState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
