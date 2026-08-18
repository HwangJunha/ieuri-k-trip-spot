// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'spot_questions_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 장소 하나의 질문 목록(R1·R2·R16). [catalogId]별 패밀리 — id를 인자로 두면
/// codegen이 family를 만든다(CLAUDE.md §5).
///
/// **정렬을 클라이언트가 하지 않는다.** 미해결 우선·최신순은 서버가 고정하며 정렬을
/// 바꾸는 인자가 계약에 없다. 받은 순서를 그대로 쌓는다.
///
/// **차단·숨김도 클라이언트가 거르지 않는다**(R12). 서버가 이미 뺀 것을 다시 거르면
/// 서버 규칙이 바뀔 때 어긋난다.
///
/// **로그인하지 않아도 조회된다**(AC-1.4) — 읽기 화면에서 인증을 요구하지 않는다.

@ProviderFor(SpotQuestionsController)
const spotQuestionsControllerProvider = SpotQuestionsControllerFamily._();

/// 장소 하나의 질문 목록(R1·R2·R16). [catalogId]별 패밀리 — id를 인자로 두면
/// codegen이 family를 만든다(CLAUDE.md §5).
///
/// **정렬을 클라이언트가 하지 않는다.** 미해결 우선·최신순은 서버가 고정하며 정렬을
/// 바꾸는 인자가 계약에 없다. 받은 순서를 그대로 쌓는다.
///
/// **차단·숨김도 클라이언트가 거르지 않는다**(R12). 서버가 이미 뺀 것을 다시 거르면
/// 서버 규칙이 바뀔 때 어긋난다.
///
/// **로그인하지 않아도 조회된다**(AC-1.4) — 읽기 화면에서 인증을 요구하지 않는다.
final class SpotQuestionsControllerProvider
    extends
        $AsyncNotifierProvider<SpotQuestionsController, SpotQuestionsState> {
  /// 장소 하나의 질문 목록(R1·R2·R16). [catalogId]별 패밀리 — id를 인자로 두면
  /// codegen이 family를 만든다(CLAUDE.md §5).
  ///
  /// **정렬을 클라이언트가 하지 않는다.** 미해결 우선·최신순은 서버가 고정하며 정렬을
  /// 바꾸는 인자가 계약에 없다. 받은 순서를 그대로 쌓는다.
  ///
  /// **차단·숨김도 클라이언트가 거르지 않는다**(R12). 서버가 이미 뺀 것을 다시 거르면
  /// 서버 규칙이 바뀔 때 어긋난다.
  ///
  /// **로그인하지 않아도 조회된다**(AC-1.4) — 읽기 화면에서 인증을 요구하지 않는다.
  const SpotQuestionsControllerProvider._({
    required SpotQuestionsControllerFamily super.from,
    required String super.argument,
  }) : super(
         retry: spotQaRetryPolicy,
         name: r'spotQuestionsControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$spotQuestionsControllerHash();

  @override
  String toString() {
    return r'spotQuestionsControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  SpotQuestionsController create() => SpotQuestionsController();

  @override
  bool operator ==(Object other) {
    return other is SpotQuestionsControllerProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$spotQuestionsControllerHash() =>
    r'0f509dc1117676c1d7981584a1d7317f025e7830';

/// 장소 하나의 질문 목록(R1·R2·R16). [catalogId]별 패밀리 — id를 인자로 두면
/// codegen이 family를 만든다(CLAUDE.md §5).
///
/// **정렬을 클라이언트가 하지 않는다.** 미해결 우선·최신순은 서버가 고정하며 정렬을
/// 바꾸는 인자가 계약에 없다. 받은 순서를 그대로 쌓는다.
///
/// **차단·숨김도 클라이언트가 거르지 않는다**(R12). 서버가 이미 뺀 것을 다시 거르면
/// 서버 규칙이 바뀔 때 어긋난다.
///
/// **로그인하지 않아도 조회된다**(AC-1.4) — 읽기 화면에서 인증을 요구하지 않는다.

final class SpotQuestionsControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          SpotQuestionsController,
          AsyncValue<SpotQuestionsState>,
          SpotQuestionsState,
          FutureOr<SpotQuestionsState>,
          String
        > {
  const SpotQuestionsControllerFamily._()
    : super(
        retry: spotQaRetryPolicy,
        name: r'spotQuestionsControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// 장소 하나의 질문 목록(R1·R2·R16). [catalogId]별 패밀리 — id를 인자로 두면
  /// codegen이 family를 만든다(CLAUDE.md §5).
  ///
  /// **정렬을 클라이언트가 하지 않는다.** 미해결 우선·최신순은 서버가 고정하며 정렬을
  /// 바꾸는 인자가 계약에 없다. 받은 순서를 그대로 쌓는다.
  ///
  /// **차단·숨김도 클라이언트가 거르지 않는다**(R12). 서버가 이미 뺀 것을 다시 거르면
  /// 서버 규칙이 바뀔 때 어긋난다.
  ///
  /// **로그인하지 않아도 조회된다**(AC-1.4) — 읽기 화면에서 인증을 요구하지 않는다.

  SpotQuestionsControllerProvider call(String catalogId) =>
      SpotQuestionsControllerProvider._(argument: catalogId, from: this);

  @override
  String toString() => r'spotQuestionsControllerProvider';
}

/// 장소 하나의 질문 목록(R1·R2·R16). [catalogId]별 패밀리 — id를 인자로 두면
/// codegen이 family를 만든다(CLAUDE.md §5).
///
/// **정렬을 클라이언트가 하지 않는다.** 미해결 우선·최신순은 서버가 고정하며 정렬을
/// 바꾸는 인자가 계약에 없다. 받은 순서를 그대로 쌓는다.
///
/// **차단·숨김도 클라이언트가 거르지 않는다**(R12). 서버가 이미 뺀 것을 다시 거르면
/// 서버 규칙이 바뀔 때 어긋난다.
///
/// **로그인하지 않아도 조회된다**(AC-1.4) — 읽기 화면에서 인증을 요구하지 않는다.

abstract class _$SpotQuestionsController
    extends $AsyncNotifier<SpotQuestionsState> {
  late final _$args = ref.$arg as String;
  String get catalogId => _$args;

  FutureOr<SpotQuestionsState> build(String catalogId);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
    final ref =
        this.ref as $Ref<AsyncValue<SpotQuestionsState>, SpotQuestionsState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<SpotQuestionsState>, SpotQuestionsState>,
              AsyncValue<SpotQuestionsState>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
