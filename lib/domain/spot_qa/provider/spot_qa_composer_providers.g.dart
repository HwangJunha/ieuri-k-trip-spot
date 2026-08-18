// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'spot_qa_composer_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 질문·답변·답글 작성 폼(R3·R4·R7).
///
/// **낙관적으로 목록에 넣지 않는다**(설계 §상태 관리). 서버가 자격을 판정하므로
/// 거부 시 롤백이 필요한데, 그 사이 사용자가 자기 글을 이미 본 상태가 된다. 작성은
/// 서버 응답을 기다린 뒤 목록을 갱신한다.
///
/// [targetId]는 대상에 따라 다르다 — 질문이면 `catalogId`, 답변이면 `questionId`,
/// 답글이면 `parentAnswerId`.

@ProviderFor(SpotQaComposer)
const spotQaComposerProvider = SpotQaComposerFamily._();

/// 질문·답변·답글 작성 폼(R3·R4·R7).
///
/// **낙관적으로 목록에 넣지 않는다**(설계 §상태 관리). 서버가 자격을 판정하므로
/// 거부 시 롤백이 필요한데, 그 사이 사용자가 자기 글을 이미 본 상태가 된다. 작성은
/// 서버 응답을 기다린 뒤 목록을 갱신한다.
///
/// [targetId]는 대상에 따라 다르다 — 질문이면 `catalogId`, 답변이면 `questionId`,
/// 답글이면 `parentAnswerId`.
final class SpotQaComposerProvider
    extends $NotifierProvider<SpotQaComposer, SpotQaComposerState> {
  /// 질문·답변·답글 작성 폼(R3·R4·R7).
  ///
  /// **낙관적으로 목록에 넣지 않는다**(설계 §상태 관리). 서버가 자격을 판정하므로
  /// 거부 시 롤백이 필요한데, 그 사이 사용자가 자기 글을 이미 본 상태가 된다. 작성은
  /// 서버 응답을 기다린 뒤 목록을 갱신한다.
  ///
  /// [targetId]는 대상에 따라 다르다 — 질문이면 `catalogId`, 답변이면 `questionId`,
  /// 답글이면 `parentAnswerId`.
  const SpotQaComposerProvider._({
    required SpotQaComposerFamily super.from,
    required (SpotQaComposerTarget, String) super.argument,
  }) : super(
         retry: null,
         name: r'spotQaComposerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$spotQaComposerHash();

  @override
  String toString() {
    return r'spotQaComposerProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  SpotQaComposer create() => SpotQaComposer();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SpotQaComposerState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SpotQaComposerState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is SpotQaComposerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$spotQaComposerHash() => r'979c8b97e70933bdaa9ae6a3fb2fcb346bfa7bc1';

/// 질문·답변·답글 작성 폼(R3·R4·R7).
///
/// **낙관적으로 목록에 넣지 않는다**(설계 §상태 관리). 서버가 자격을 판정하므로
/// 거부 시 롤백이 필요한데, 그 사이 사용자가 자기 글을 이미 본 상태가 된다. 작성은
/// 서버 응답을 기다린 뒤 목록을 갱신한다.
///
/// [targetId]는 대상에 따라 다르다 — 질문이면 `catalogId`, 답변이면 `questionId`,
/// 답글이면 `parentAnswerId`.

final class SpotQaComposerFamily extends $Family
    with
        $ClassFamilyOverride<
          SpotQaComposer,
          SpotQaComposerState,
          SpotQaComposerState,
          SpotQaComposerState,
          (SpotQaComposerTarget, String)
        > {
  const SpotQaComposerFamily._()
    : super(
        retry: null,
        name: r'spotQaComposerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// 질문·답변·답글 작성 폼(R3·R4·R7).
  ///
  /// **낙관적으로 목록에 넣지 않는다**(설계 §상태 관리). 서버가 자격을 판정하므로
  /// 거부 시 롤백이 필요한데, 그 사이 사용자가 자기 글을 이미 본 상태가 된다. 작성은
  /// 서버 응답을 기다린 뒤 목록을 갱신한다.
  ///
  /// [targetId]는 대상에 따라 다르다 — 질문이면 `catalogId`, 답변이면 `questionId`,
  /// 답글이면 `parentAnswerId`.

  SpotQaComposerProvider call(SpotQaComposerTarget target, String targetId) =>
      SpotQaComposerProvider._(argument: (target, targetId), from: this);

  @override
  String toString() => r'spotQaComposerProvider';
}

/// 질문·답변·답글 작성 폼(R3·R4·R7).
///
/// **낙관적으로 목록에 넣지 않는다**(설계 §상태 관리). 서버가 자격을 판정하므로
/// 거부 시 롤백이 필요한데, 그 사이 사용자가 자기 글을 이미 본 상태가 된다. 작성은
/// 서버 응답을 기다린 뒤 목록을 갱신한다.
///
/// [targetId]는 대상에 따라 다르다 — 질문이면 `catalogId`, 답변이면 `questionId`,
/// 답글이면 `parentAnswerId`.

abstract class _$SpotQaComposer extends $Notifier<SpotQaComposerState> {
  late final _$args = ref.$arg as (SpotQaComposerTarget, String);
  SpotQaComposerTarget get target => _$args.$1;
  String get targetId => _$args.$2;

  SpotQaComposerState build(SpotQaComposerTarget target, String targetId);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args.$1, _$args.$2);
    final ref = this.ref as $Ref<SpotQaComposerState, SpotQaComposerState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SpotQaComposerState, SpotQaComposerState>,
              SpotQaComposerState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
