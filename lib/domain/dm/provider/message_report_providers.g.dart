// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_report_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// DM 메시지 다중 선택 신고의 선택 상태(R15).
///
/// 대화별 family인 이유는 **한 신고가 한 대화에 대한 것이기 때문이다** — 화면 구조상
/// 대화 혼재(AC15-4)가 생기지 않게 선택 자체를 대화 안에 가둔다.

@ProviderFor(MessageReportSelectionController)
const messageReportSelectionControllerProvider =
    MessageReportSelectionControllerFamily._();

/// DM 메시지 다중 선택 신고의 선택 상태(R15).
///
/// 대화별 family인 이유는 **한 신고가 한 대화에 대한 것이기 때문이다** — 화면 구조상
/// 대화 혼재(AC15-4)가 생기지 않게 선택 자체를 대화 안에 가둔다.
final class MessageReportSelectionControllerProvider
    extends
        $NotifierProvider<
          MessageReportSelectionController,
          MessageReportSelection
        > {
  /// DM 메시지 다중 선택 신고의 선택 상태(R15).
  ///
  /// 대화별 family인 이유는 **한 신고가 한 대화에 대한 것이기 때문이다** — 화면 구조상
  /// 대화 혼재(AC15-4)가 생기지 않게 선택 자체를 대화 안에 가둔다.
  const MessageReportSelectionControllerProvider._({
    required MessageReportSelectionControllerFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'messageReportSelectionControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$messageReportSelectionControllerHash();

  @override
  String toString() {
    return r'messageReportSelectionControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  MessageReportSelectionController create() =>
      MessageReportSelectionController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MessageReportSelection value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MessageReportSelection>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is MessageReportSelectionControllerProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$messageReportSelectionControllerHash() =>
    r'bfdc676439fb870df4fc10d112debeb2d7729ebd';

/// DM 메시지 다중 선택 신고의 선택 상태(R15).
///
/// 대화별 family인 이유는 **한 신고가 한 대화에 대한 것이기 때문이다** — 화면 구조상
/// 대화 혼재(AC15-4)가 생기지 않게 선택 자체를 대화 안에 가둔다.

final class MessageReportSelectionControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          MessageReportSelectionController,
          MessageReportSelection,
          MessageReportSelection,
          MessageReportSelection,
          String
        > {
  const MessageReportSelectionControllerFamily._()
    : super(
        retry: null,
        name: r'messageReportSelectionControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// DM 메시지 다중 선택 신고의 선택 상태(R15).
  ///
  /// 대화별 family인 이유는 **한 신고가 한 대화에 대한 것이기 때문이다** — 화면 구조상
  /// 대화 혼재(AC15-4)가 생기지 않게 선택 자체를 대화 안에 가둔다.

  MessageReportSelectionControllerProvider call(String conversationId) =>
      MessageReportSelectionControllerProvider._(
        argument: conversationId,
        from: this,
      );

  @override
  String toString() => r'messageReportSelectionControllerProvider';
}

/// DM 메시지 다중 선택 신고의 선택 상태(R15).
///
/// 대화별 family인 이유는 **한 신고가 한 대화에 대한 것이기 때문이다** — 화면 구조상
/// 대화 혼재(AC15-4)가 생기지 않게 선택 자체를 대화 안에 가둔다.

abstract class _$MessageReportSelectionController
    extends $Notifier<MessageReportSelection> {
  late final _$args = ref.$arg as String;
  String get conversationId => _$args;

  MessageReportSelection build(String conversationId);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
    final ref =
        this.ref as $Ref<MessageReportSelection, MessageReportSelection>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<MessageReportSelection, MessageReportSelection>,
              MessageReportSelection,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
