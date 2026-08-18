// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_questions_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(myQuestionsStore)
const myQuestionsStoreProvider = MyQuestionsStoreProvider._();

final class MyQuestionsStoreProvider
    extends
        $FunctionalProvider<
          MyQuestionsStore,
          MyQuestionsStore,
          MyQuestionsStore
        >
    with $Provider<MyQuestionsStore> {
  const MyQuestionsStoreProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'myQuestionsStoreProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$myQuestionsStoreHash();

  @$internal
  @override
  $ProviderElement<MyQuestionsStore> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  MyQuestionsStore create(Ref ref) {
    return myQuestionsStore(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MyQuestionsStore value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MyQuestionsStore>(value),
    );
  }
}

String _$myQuestionsStoreHash() => r'e82a947821fa2408eec4ca14e9d0247e94cc46c2';

/// 내가 올린 질문 목록(로컬 기록 + 서버 되짚기).
///
/// **서버에 `myQuestions`가 없어서 이런 모양이다.** 로컬에 적어 둔 `catalogId`로 각
/// 장소의 질문 목록을 조회해 내 질문을 찾는다. 계약이 생기면 이 컨트롤러는 그 조회
/// 하나로 대체되고 로컬 저장소는 삭제된다(`MyQuestionRef` 주석 참고).
///
/// **장소당 한 번씩 조회한다.** 여러 질문이 같은 장소에 있으면 묶어서 한 번만 부른다 —
/// 질문 수가 아니라 장소 수만큼 왕복한다.
///
/// 일부 장소 조회가 실패해도 **나머지는 보여준다.** 전체를 오류로 만들면 장소 하나가
/// 죽었을 때 내 질문이 전부 안 보인다.

@ProviderFor(MyQuestionsController)
const myQuestionsControllerProvider = MyQuestionsControllerProvider._();

/// 내가 올린 질문 목록(로컬 기록 + 서버 되짚기).
///
/// **서버에 `myQuestions`가 없어서 이런 모양이다.** 로컬에 적어 둔 `catalogId`로 각
/// 장소의 질문 목록을 조회해 내 질문을 찾는다. 계약이 생기면 이 컨트롤러는 그 조회
/// 하나로 대체되고 로컬 저장소는 삭제된다(`MyQuestionRef` 주석 참고).
///
/// **장소당 한 번씩 조회한다.** 여러 질문이 같은 장소에 있으면 묶어서 한 번만 부른다 —
/// 질문 수가 아니라 장소 수만큼 왕복한다.
///
/// 일부 장소 조회가 실패해도 **나머지는 보여준다.** 전체를 오류로 만들면 장소 하나가
/// 죽었을 때 내 질문이 전부 안 보인다.
final class MyQuestionsControllerProvider
    extends
        $AsyncNotifierProvider<MyQuestionsController, List<MyQuestionItem>> {
  /// 내가 올린 질문 목록(로컬 기록 + 서버 되짚기).
  ///
  /// **서버에 `myQuestions`가 없어서 이런 모양이다.** 로컬에 적어 둔 `catalogId`로 각
  /// 장소의 질문 목록을 조회해 내 질문을 찾는다. 계약이 생기면 이 컨트롤러는 그 조회
  /// 하나로 대체되고 로컬 저장소는 삭제된다(`MyQuestionRef` 주석 참고).
  ///
  /// **장소당 한 번씩 조회한다.** 여러 질문이 같은 장소에 있으면 묶어서 한 번만 부른다 —
  /// 질문 수가 아니라 장소 수만큼 왕복한다.
  ///
  /// 일부 장소 조회가 실패해도 **나머지는 보여준다.** 전체를 오류로 만들면 장소 하나가
  /// 죽었을 때 내 질문이 전부 안 보인다.
  const MyQuestionsControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'myQuestionsControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$myQuestionsControllerHash();

  @$internal
  @override
  MyQuestionsController create() => MyQuestionsController();
}

String _$myQuestionsControllerHash() =>
    r'4423f78cfa64510e3624d7c88a2acd8aae52f39a';

/// 내가 올린 질문 목록(로컬 기록 + 서버 되짚기).
///
/// **서버에 `myQuestions`가 없어서 이런 모양이다.** 로컬에 적어 둔 `catalogId`로 각
/// 장소의 질문 목록을 조회해 내 질문을 찾는다. 계약이 생기면 이 컨트롤러는 그 조회
/// 하나로 대체되고 로컬 저장소는 삭제된다(`MyQuestionRef` 주석 참고).
///
/// **장소당 한 번씩 조회한다.** 여러 질문이 같은 장소에 있으면 묶어서 한 번만 부른다 —
/// 질문 수가 아니라 장소 수만큼 왕복한다.
///
/// 일부 장소 조회가 실패해도 **나머지는 보여준다.** 전체를 오류로 만들면 장소 하나가
/// 죽었을 때 내 질문이 전부 안 보인다.

abstract class _$MyQuestionsController
    extends $AsyncNotifier<List<MyQuestionItem>> {
  FutureOr<List<MyQuestionItem>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<AsyncValue<List<MyQuestionItem>>, List<MyQuestionItem>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<MyQuestionItem>>,
                List<MyQuestionItem>
              >,
              AsyncValue<List<MyQuestionItem>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// 못 본 답변이 있는 질문 수. 진입점 배지가 이것만 구독한다.

@ProviderFor(myQuestionsUnseenCount)
const myQuestionsUnseenCountProvider = MyQuestionsUnseenCountProvider._();

/// 못 본 답변이 있는 질문 수. 진입점 배지가 이것만 구독한다.

final class MyQuestionsUnseenCountProvider
    extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  /// 못 본 답변이 있는 질문 수. 진입점 배지가 이것만 구독한다.
  const MyQuestionsUnseenCountProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'myQuestionsUnseenCountProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$myQuestionsUnseenCountHash();

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    return myQuestionsUnseenCount(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$myQuestionsUnseenCountHash() =>
    r'4079b0af56047c358366af2648088fc284293764';
