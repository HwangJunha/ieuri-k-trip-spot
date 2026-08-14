// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feed_composer_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 피드 작성 폼(R1·R2).
///
/// **spot과 사진이 갖춰지기 전에는 제출할 수 없다** — 판정은 [FeedDraft.canSubmit]이
/// 하고, 화면은 그 값으로 버튼을 활성화한다(설계 §4).
///
/// spot 피커는 커뮤니티가 이미 쓰는 `searchSpots` 흐름을 재사용한다(SPEC-0013) —
/// 새로 만들면 검색 동작이 두 벌이 된다. 여기서는 고른 결과를 받기만 한다.

@ProviderFor(FeedComposer)
const feedComposerProvider = FeedComposerProvider._();

/// 피드 작성 폼(R1·R2).
///
/// **spot과 사진이 갖춰지기 전에는 제출할 수 없다** — 판정은 [FeedDraft.canSubmit]이
/// 하고, 화면은 그 값으로 버튼을 활성화한다(설계 §4).
///
/// spot 피커는 커뮤니티가 이미 쓰는 `searchSpots` 흐름을 재사용한다(SPEC-0013) —
/// 새로 만들면 검색 동작이 두 벌이 된다. 여기서는 고른 결과를 받기만 한다.
final class FeedComposerProvider
    extends $NotifierProvider<FeedComposer, FeedDraft> {
  /// 피드 작성 폼(R1·R2).
  ///
  /// **spot과 사진이 갖춰지기 전에는 제출할 수 없다** — 판정은 [FeedDraft.canSubmit]이
  /// 하고, 화면은 그 값으로 버튼을 활성화한다(설계 §4).
  ///
  /// spot 피커는 커뮤니티가 이미 쓰는 `searchSpots` 흐름을 재사용한다(SPEC-0013) —
  /// 새로 만들면 검색 동작이 두 벌이 된다. 여기서는 고른 결과를 받기만 한다.
  const FeedComposerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'feedComposerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$feedComposerHash();

  @$internal
  @override
  FeedComposer create() => FeedComposer();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FeedDraft value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FeedDraft>(value),
    );
  }
}

String _$feedComposerHash() => r'2a8acff3b6f30301833055b5e6ff6b33db74791f';

/// 피드 작성 폼(R1·R2).
///
/// **spot과 사진이 갖춰지기 전에는 제출할 수 없다** — 판정은 [FeedDraft.canSubmit]이
/// 하고, 화면은 그 값으로 버튼을 활성화한다(설계 §4).
///
/// spot 피커는 커뮤니티가 이미 쓰는 `searchSpots` 흐름을 재사용한다(SPEC-0013) —
/// 새로 만들면 검색 동작이 두 벌이 된다. 여기서는 고른 결과를 받기만 한다.

abstract class _$FeedComposer extends $Notifier<FeedDraft> {
  FeedDraft build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<FeedDraft, FeedDraft>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<FeedDraft, FeedDraft>,
              FeedDraft,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
