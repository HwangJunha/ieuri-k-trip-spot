// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'spot_answers_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 질문 하나의 답변 목록(R7). [questionId]별 패밀리.
///
/// 답변은 커서 페이지네이션이고 **답글은 답변에 딸려 한 번에 내려온다** — 깊이가
/// 2단계라 화면을 넘길 만큼 커지지 않기 때문이다(계약 §SpotAnswer.replies).
///
/// 질문 조회와 분리된 provider인 이유는 실패가 서로를 가리지 않게 하기 위해서다 —
/// 답변 조회가 실패해도 질문 본문은 그대로 뜬다.

@ProviderFor(SpotAnswersController)
const spotAnswersControllerProvider = SpotAnswersControllerFamily._();

/// 질문 하나의 답변 목록(R7). [questionId]별 패밀리.
///
/// 답변은 커서 페이지네이션이고 **답글은 답변에 딸려 한 번에 내려온다** — 깊이가
/// 2단계라 화면을 넘길 만큼 커지지 않기 때문이다(계약 §SpotAnswer.replies).
///
/// 질문 조회와 분리된 provider인 이유는 실패가 서로를 가리지 않게 하기 위해서다 —
/// 답변 조회가 실패해도 질문 본문은 그대로 뜬다.
final class SpotAnswersControllerProvider
    extends $AsyncNotifierProvider<SpotAnswersController, SpotAnswersState> {
  /// 질문 하나의 답변 목록(R7). [questionId]별 패밀리.
  ///
  /// 답변은 커서 페이지네이션이고 **답글은 답변에 딸려 한 번에 내려온다** — 깊이가
  /// 2단계라 화면을 넘길 만큼 커지지 않기 때문이다(계약 §SpotAnswer.replies).
  ///
  /// 질문 조회와 분리된 provider인 이유는 실패가 서로를 가리지 않게 하기 위해서다 —
  /// 답변 조회가 실패해도 질문 본문은 그대로 뜬다.
  const SpotAnswersControllerProvider._({
    required SpotAnswersControllerFamily super.from,
    required String super.argument,
  }) : super(
         retry: spotQaRetryPolicy,
         name: r'spotAnswersControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$spotAnswersControllerHash();

  @override
  String toString() {
    return r'spotAnswersControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  SpotAnswersController create() => SpotAnswersController();

  @override
  bool operator ==(Object other) {
    return other is SpotAnswersControllerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$spotAnswersControllerHash() =>
    r'0ba2eac94c4c3157cae8cca777abb16b5efa4496';

/// 질문 하나의 답변 목록(R7). [questionId]별 패밀리.
///
/// 답변은 커서 페이지네이션이고 **답글은 답변에 딸려 한 번에 내려온다** — 깊이가
/// 2단계라 화면을 넘길 만큼 커지지 않기 때문이다(계약 §SpotAnswer.replies).
///
/// 질문 조회와 분리된 provider인 이유는 실패가 서로를 가리지 않게 하기 위해서다 —
/// 답변 조회가 실패해도 질문 본문은 그대로 뜬다.

final class SpotAnswersControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          SpotAnswersController,
          AsyncValue<SpotAnswersState>,
          SpotAnswersState,
          FutureOr<SpotAnswersState>,
          String
        > {
  const SpotAnswersControllerFamily._()
    : super(
        retry: spotQaRetryPolicy,
        name: r'spotAnswersControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// 질문 하나의 답변 목록(R7). [questionId]별 패밀리.
  ///
  /// 답변은 커서 페이지네이션이고 **답글은 답변에 딸려 한 번에 내려온다** — 깊이가
  /// 2단계라 화면을 넘길 만큼 커지지 않기 때문이다(계약 §SpotAnswer.replies).
  ///
  /// 질문 조회와 분리된 provider인 이유는 실패가 서로를 가리지 않게 하기 위해서다 —
  /// 답변 조회가 실패해도 질문 본문은 그대로 뜬다.

  SpotAnswersControllerProvider call(String questionId) =>
      SpotAnswersControllerProvider._(argument: questionId, from: this);

  @override
  String toString() => r'spotAnswersControllerProvider';
}

/// 질문 하나의 답변 목록(R7). [questionId]별 패밀리.
///
/// 답변은 커서 페이지네이션이고 **답글은 답변에 딸려 한 번에 내려온다** — 깊이가
/// 2단계라 화면을 넘길 만큼 커지지 않기 때문이다(계약 §SpotAnswer.replies).
///
/// 질문 조회와 분리된 provider인 이유는 실패가 서로를 가리지 않게 하기 위해서다 —
/// 답변 조회가 실패해도 질문 본문은 그대로 뜬다.

abstract class _$SpotAnswersController
    extends $AsyncNotifier<SpotAnswersState> {
  late final _$args = ref.$arg as String;
  String get questionId => _$args;

  FutureOr<SpotAnswersState> build(String questionId);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
    final ref =
        this.ref as $Ref<AsyncValue<SpotAnswersState>, SpotAnswersState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<SpotAnswersState>, SpotAnswersState>,
              AsyncValue<SpotAnswersState>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
