// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'spot_qa_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 질문/답변 repository 하나의 출처(CLAUDE.md §5 — 위젯이 repository를 직접 만들지
/// 않는다). 테스트는 이 provider 하나만 오버라이드해 페이크를 주입한다.

@ProviderFor(spotQaRepository)
const spotQaRepositoryProvider = SpotQaRepositoryProvider._();

/// 질문/답변 repository 하나의 출처(CLAUDE.md §5 — 위젯이 repository를 직접 만들지
/// 않는다). 테스트는 이 provider 하나만 오버라이드해 페이크를 주입한다.

final class SpotQaRepositoryProvider
    extends
        $FunctionalProvider<
          SpotQaRepository,
          SpotQaRepository,
          SpotQaRepository
        >
    with $Provider<SpotQaRepository> {
  /// 질문/답변 repository 하나의 출처(CLAUDE.md §5 — 위젯이 repository를 직접 만들지
  /// 않는다). 테스트는 이 provider 하나만 오버라이드해 페이크를 주입한다.
  const SpotQaRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'spotQaRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$spotQaRepositoryHash();

  @$internal
  @override
  $ProviderElement<SpotQaRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SpotQaRepository create(Ref ref) {
    return spotQaRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SpotQaRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SpotQaRepository>(value),
    );
  }
}

String _$spotQaRepositoryHash() => r'18037d8e64e3e4ecb4c94df4d469793f7006bc1f';
