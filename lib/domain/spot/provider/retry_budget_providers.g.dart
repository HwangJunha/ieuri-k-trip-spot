// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'retry_budget_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 조회 시도 횟수를 담는 provider(SPEC-0006 R4). [scope] 문자열 하나로 패밀리를
/// 이루며, 카운터를 세려는 조회 대상마다 고유한 scope를 쓴다(예:
/// `swipe:touristSpot`, `detail:126508`).
///
/// **`keepAlive`인 이유가 이 스펙의 핵심이다.** 폭주의 경로는 컨트롤러의 재빌드이므로,
/// 카운터가 컨트롤러와 같은 생명주기를 가지면 재빌드마다 0으로 돌아가 상한이 의미를
/// 잃는다(설계문서 §2.2). 이 provider는 재빌드·무효화를 넘어 살아남아야 하고, 따라서
/// autoDispose 기본값을 명시적으로 벗어난다.
///
/// 생명주기가 컨테이너와 같다는 것은 곧 카테고리를 바꿔도 이전 scope의 카운터가 남는다는
/// 뜻이다. 그것이 의도한 동작이다 — 카테고리별로 상한이 독립적으로 시작하고(AC-4),
/// 돌아왔을 때 이미 소진했던 카테고리는 소진 상태 그대로다.

@ProviderFor(SpotRetryBudget)
const spotRetryBudgetProvider = SpotRetryBudgetFamily._();

/// 조회 시도 횟수를 담는 provider(SPEC-0006 R4). [scope] 문자열 하나로 패밀리를
/// 이루며, 카운터를 세려는 조회 대상마다 고유한 scope를 쓴다(예:
/// `swipe:touristSpot`, `detail:126508`).
///
/// **`keepAlive`인 이유가 이 스펙의 핵심이다.** 폭주의 경로는 컨트롤러의 재빌드이므로,
/// 카운터가 컨트롤러와 같은 생명주기를 가지면 재빌드마다 0으로 돌아가 상한이 의미를
/// 잃는다(설계문서 §2.2). 이 provider는 재빌드·무효화를 넘어 살아남아야 하고, 따라서
/// autoDispose 기본값을 명시적으로 벗어난다.
///
/// 생명주기가 컨테이너와 같다는 것은 곧 카테고리를 바꿔도 이전 scope의 카운터가 남는다는
/// 뜻이다. 그것이 의도한 동작이다 — 카테고리별로 상한이 독립적으로 시작하고(AC-4),
/// 돌아왔을 때 이미 소진했던 카테고리는 소진 상태 그대로다.
final class SpotRetryBudgetProvider
    extends $NotifierProvider<SpotRetryBudget, RetryBudget> {
  /// 조회 시도 횟수를 담는 provider(SPEC-0006 R4). [scope] 문자열 하나로 패밀리를
  /// 이루며, 카운터를 세려는 조회 대상마다 고유한 scope를 쓴다(예:
  /// `swipe:touristSpot`, `detail:126508`).
  ///
  /// **`keepAlive`인 이유가 이 스펙의 핵심이다.** 폭주의 경로는 컨트롤러의 재빌드이므로,
  /// 카운터가 컨트롤러와 같은 생명주기를 가지면 재빌드마다 0으로 돌아가 상한이 의미를
  /// 잃는다(설계문서 §2.2). 이 provider는 재빌드·무효화를 넘어 살아남아야 하고, 따라서
  /// autoDispose 기본값을 명시적으로 벗어난다.
  ///
  /// 생명주기가 컨테이너와 같다는 것은 곧 카테고리를 바꿔도 이전 scope의 카운터가 남는다는
  /// 뜻이다. 그것이 의도한 동작이다 — 카테고리별로 상한이 독립적으로 시작하고(AC-4),
  /// 돌아왔을 때 이미 소진했던 카테고리는 소진 상태 그대로다.
  const SpotRetryBudgetProvider._({
    required SpotRetryBudgetFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'spotRetryBudgetProvider',
         isAutoDispose: false,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$spotRetryBudgetHash();

  @override
  String toString() {
    return r'spotRetryBudgetProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  SpotRetryBudget create() => SpotRetryBudget();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RetryBudget value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RetryBudget>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is SpotRetryBudgetProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$spotRetryBudgetHash() => r'2861acb4ee0d910725d0263670a47c7ab7a36c11';

/// 조회 시도 횟수를 담는 provider(SPEC-0006 R4). [scope] 문자열 하나로 패밀리를
/// 이루며, 카운터를 세려는 조회 대상마다 고유한 scope를 쓴다(예:
/// `swipe:touristSpot`, `detail:126508`).
///
/// **`keepAlive`인 이유가 이 스펙의 핵심이다.** 폭주의 경로는 컨트롤러의 재빌드이므로,
/// 카운터가 컨트롤러와 같은 생명주기를 가지면 재빌드마다 0으로 돌아가 상한이 의미를
/// 잃는다(설계문서 §2.2). 이 provider는 재빌드·무효화를 넘어 살아남아야 하고, 따라서
/// autoDispose 기본값을 명시적으로 벗어난다.
///
/// 생명주기가 컨테이너와 같다는 것은 곧 카테고리를 바꿔도 이전 scope의 카운터가 남는다는
/// 뜻이다. 그것이 의도한 동작이다 — 카테고리별로 상한이 독립적으로 시작하고(AC-4),
/// 돌아왔을 때 이미 소진했던 카테고리는 소진 상태 그대로다.

final class SpotRetryBudgetFamily extends $Family
    with
        $ClassFamilyOverride<
          SpotRetryBudget,
          RetryBudget,
          RetryBudget,
          RetryBudget,
          String
        > {
  const SpotRetryBudgetFamily._()
    : super(
        retry: null,
        name: r'spotRetryBudgetProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  /// 조회 시도 횟수를 담는 provider(SPEC-0006 R4). [scope] 문자열 하나로 패밀리를
  /// 이루며, 카운터를 세려는 조회 대상마다 고유한 scope를 쓴다(예:
  /// `swipe:touristSpot`, `detail:126508`).
  ///
  /// **`keepAlive`인 이유가 이 스펙의 핵심이다.** 폭주의 경로는 컨트롤러의 재빌드이므로,
  /// 카운터가 컨트롤러와 같은 생명주기를 가지면 재빌드마다 0으로 돌아가 상한이 의미를
  /// 잃는다(설계문서 §2.2). 이 provider는 재빌드·무효화를 넘어 살아남아야 하고, 따라서
  /// autoDispose 기본값을 명시적으로 벗어난다.
  ///
  /// 생명주기가 컨테이너와 같다는 것은 곧 카테고리를 바꿔도 이전 scope의 카운터가 남는다는
  /// 뜻이다. 그것이 의도한 동작이다 — 카테고리별로 상한이 독립적으로 시작하고(AC-4),
  /// 돌아왔을 때 이미 소진했던 카테고리는 소진 상태 그대로다.

  SpotRetryBudgetProvider call(String scope) =>
      SpotRetryBudgetProvider._(argument: scope, from: this);

  @override
  String toString() => r'spotRetryBudgetProvider';
}

/// 조회 시도 횟수를 담는 provider(SPEC-0006 R4). [scope] 문자열 하나로 패밀리를
/// 이루며, 카운터를 세려는 조회 대상마다 고유한 scope를 쓴다(예:
/// `swipe:touristSpot`, `detail:126508`).
///
/// **`keepAlive`인 이유가 이 스펙의 핵심이다.** 폭주의 경로는 컨트롤러의 재빌드이므로,
/// 카운터가 컨트롤러와 같은 생명주기를 가지면 재빌드마다 0으로 돌아가 상한이 의미를
/// 잃는다(설계문서 §2.2). 이 provider는 재빌드·무효화를 넘어 살아남아야 하고, 따라서
/// autoDispose 기본값을 명시적으로 벗어난다.
///
/// 생명주기가 컨테이너와 같다는 것은 곧 카테고리를 바꿔도 이전 scope의 카운터가 남는다는
/// 뜻이다. 그것이 의도한 동작이다 — 카테고리별로 상한이 독립적으로 시작하고(AC-4),
/// 돌아왔을 때 이미 소진했던 카테고리는 소진 상태 그대로다.

abstract class _$SpotRetryBudget extends $Notifier<RetryBudget> {
  late final _$args = ref.$arg as String;
  String get scope => _$args;

  RetryBudget build(String scope);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
    final ref = this.ref as $Ref<RetryBudget, RetryBudget>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<RetryBudget, RetryBudget>,
              RetryBudget,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
