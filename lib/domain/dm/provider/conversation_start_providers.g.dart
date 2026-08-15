// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversation_start_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 지정한 회원과 대화를 연다(SPEC-0021 R11).
///
/// **입력이 피드 id에서 회원 id로 바뀌었다** — 피드가 사라지면서 "이 글의 작성자와
/// 대화"라는 간접 지정이 성립하지 않는다. 이미 대화가 있으면 서버가 새로 만들지 않고
/// 기존 대화를 돌려주므로(AC7-2) 클라이언트가 중복을 확인할 필요가 없다.
///
/// **지금 이것을 부르는 화면이 없다.** 상대를 고르는 화면은 이 스펙의 범위 밖이고
/// ([TBD-2]) 후속 채팅 스펙이 만든다 — 그때 쓰려고 남겨 둔다.
///
/// 상태를 들지 않는 한 번짜리 동작이라 notifier가 아니라 함수 provider다 — 화면은
/// 돌려받은 conversationId로 대화 화면을 열고, null이면 실패를 알린다.

@ProviderFor(conversationStarter)
const conversationStarterProvider = ConversationStarterProvider._();

/// 지정한 회원과 대화를 연다(SPEC-0021 R11).
///
/// **입력이 피드 id에서 회원 id로 바뀌었다** — 피드가 사라지면서 "이 글의 작성자와
/// 대화"라는 간접 지정이 성립하지 않는다. 이미 대화가 있으면 서버가 새로 만들지 않고
/// 기존 대화를 돌려주므로(AC7-2) 클라이언트가 중복을 확인할 필요가 없다.
///
/// **지금 이것을 부르는 화면이 없다.** 상대를 고르는 화면은 이 스펙의 범위 밖이고
/// ([TBD-2]) 후속 채팅 스펙이 만든다 — 그때 쓰려고 남겨 둔다.
///
/// 상태를 들지 않는 한 번짜리 동작이라 notifier가 아니라 함수 provider다 — 화면은
/// 돌려받은 conversationId로 대화 화면을 열고, null이면 실패를 알린다.

final class ConversationStarterProvider
    extends
        $FunctionalProvider<
          ConversationStarter,
          ConversationStarter,
          ConversationStarter
        >
    with $Provider<ConversationStarter> {
  /// 지정한 회원과 대화를 연다(SPEC-0021 R11).
  ///
  /// **입력이 피드 id에서 회원 id로 바뀌었다** — 피드가 사라지면서 "이 글의 작성자와
  /// 대화"라는 간접 지정이 성립하지 않는다. 이미 대화가 있으면 서버가 새로 만들지 않고
  /// 기존 대화를 돌려주므로(AC7-2) 클라이언트가 중복을 확인할 필요가 없다.
  ///
  /// **지금 이것을 부르는 화면이 없다.** 상대를 고르는 화면은 이 스펙의 범위 밖이고
  /// ([TBD-2]) 후속 채팅 스펙이 만든다 — 그때 쓰려고 남겨 둔다.
  ///
  /// 상태를 들지 않는 한 번짜리 동작이라 notifier가 아니라 함수 provider다 — 화면은
  /// 돌려받은 conversationId로 대화 화면을 열고, null이면 실패를 알린다.
  const ConversationStarterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'conversationStarterProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$conversationStarterHash();

  @$internal
  @override
  $ProviderElement<ConversationStarter> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ConversationStarter create(Ref ref) {
    return conversationStarter(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ConversationStarter value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ConversationStarter>(value),
    );
  }
}

String _$conversationStarterHash() =>
    r'659c8cbba0085636a928ed61bb1ea5f43409fe81';
