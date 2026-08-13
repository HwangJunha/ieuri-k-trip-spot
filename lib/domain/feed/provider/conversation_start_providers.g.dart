// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversation_start_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 피드 항목에서 대화를 연다(R7).
///
/// **입력이 회원 id가 아니라 피드 id다** — 그래서 커뮤니티 글 작성자는 구조적으로
/// 상대가 될 수 없다(설계 §6). 이미 대화가 있으면 서버가 새로 만들지 않고 기존
/// 대화를 돌려주므로(AC7-2) 클라이언트가 중복을 확인할 필요가 없다.
///
/// 상태를 들지 않는 한 번짜리 동작이라 notifier가 아니라 함수 provider다 — 화면은
/// 돌려받은 conversationId로 대화 화면을 열고, null이면 실패를 알린다.

@ProviderFor(conversationStarter)
const conversationStarterProvider = ConversationStarterProvider._();

/// 피드 항목에서 대화를 연다(R7).
///
/// **입력이 회원 id가 아니라 피드 id다** — 그래서 커뮤니티 글 작성자는 구조적으로
/// 상대가 될 수 없다(설계 §6). 이미 대화가 있으면 서버가 새로 만들지 않고 기존
/// 대화를 돌려주므로(AC7-2) 클라이언트가 중복을 확인할 필요가 없다.
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
  /// 피드 항목에서 대화를 연다(R7).
  ///
  /// **입력이 회원 id가 아니라 피드 id다** — 그래서 커뮤니티 글 작성자는 구조적으로
  /// 상대가 될 수 없다(설계 §6). 이미 대화가 있으면 서버가 새로 만들지 않고 기존
  /// 대화를 돌려주므로(AC7-2) 클라이언트가 중복을 확인할 필요가 없다.
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
    r'0f59f23f60017d685c65e26c49afad39062893c8';
