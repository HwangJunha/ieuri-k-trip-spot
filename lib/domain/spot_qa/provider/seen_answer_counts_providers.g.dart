// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'seen_answer_counts_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 「마지막에 본 답변 수」 저장소의 출처. 테스트는 이것만 오버라이드해 페이크를 준다.

@ProviderFor(seenAnswerCountsStore)
const seenAnswerCountsStoreProvider = SeenAnswerCountsStoreProvider._();

/// 「마지막에 본 답변 수」 저장소의 출처. 테스트는 이것만 오버라이드해 페이크를 준다.

final class SeenAnswerCountsStoreProvider
    extends
        $FunctionalProvider<
          SeenAnswerCountsStore,
          SeenAnswerCountsStore,
          SeenAnswerCountsStore
        >
    with $Provider<SeenAnswerCountsStore> {
  /// 「마지막에 본 답변 수」 저장소의 출처. 테스트는 이것만 오버라이드해 페이크를 준다.
  const SeenAnswerCountsStoreProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'seenAnswerCountsStoreProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$seenAnswerCountsStoreHash();

  @$internal
  @override
  $ProviderElement<SeenAnswerCountsStore> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SeenAnswerCountsStore create(Ref ref) {
    return seenAnswerCountsStore(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SeenAnswerCountsStore value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SeenAnswerCountsStore>(value),
    );
  }
}

String _$seenAnswerCountsStoreHash() =>
    r'd853b05dec311e32671c1bf3d25aeef2f9bbb6c7';
