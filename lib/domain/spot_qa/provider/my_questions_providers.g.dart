// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_questions_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 내가 올린 질문 목록.
///
/// **출처는 서버다**(2026-08-18). 서버가 `spotQuestions`에 `mine` 필터를 더하면서,
/// 질문 목록을 로컬에 쌓던 임시 저장소를 걷어냈다 — 서버가 정답을 주는데 클라이언트가
/// 따로 기록을 쥐면 어긋날 때 판단 근거가 없다.
///
/// 그래서 **기기를 바꿔도, 앱을 지웠다 깔아도 내 질문이 그대로 보인다.** 예전 로컬
/// 방식의 가장 큰 구멍이 그것이었다.
///
/// 로컬에 남은 것은 「마지막에 본 답변 수」 하나뿐이다. 서버에 읽음 지점이 없어
/// 새 답변 배지를 그것 없이는 만들 수 없다. 이 값이 비어도 목록은 정상이고 배지만
/// 안 뜬다 — **목록의 정확성을 로컬 상태에 걸지 않는다.**
///
/// **인증이 필요하다.** 비로그인이면 repository가 실패를 던지고 화면이 그대로
/// 오류/로그인 안내로 분기한다 — 빈 목록으로 접으면 "쓴 적 없음"으로 오해된다.

@ProviderFor(MyQuestionsController)
const myQuestionsControllerProvider = MyQuestionsControllerProvider._();

/// 내가 올린 질문 목록.
///
/// **출처는 서버다**(2026-08-18). 서버가 `spotQuestions`에 `mine` 필터를 더하면서,
/// 질문 목록을 로컬에 쌓던 임시 저장소를 걷어냈다 — 서버가 정답을 주는데 클라이언트가
/// 따로 기록을 쥐면 어긋날 때 판단 근거가 없다.
///
/// 그래서 **기기를 바꿔도, 앱을 지웠다 깔아도 내 질문이 그대로 보인다.** 예전 로컬
/// 방식의 가장 큰 구멍이 그것이었다.
///
/// 로컬에 남은 것은 「마지막에 본 답변 수」 하나뿐이다. 서버에 읽음 지점이 없어
/// 새 답변 배지를 그것 없이는 만들 수 없다. 이 값이 비어도 목록은 정상이고 배지만
/// 안 뜬다 — **목록의 정확성을 로컬 상태에 걸지 않는다.**
///
/// **인증이 필요하다.** 비로그인이면 repository가 실패를 던지고 화면이 그대로
/// 오류/로그인 안내로 분기한다 — 빈 목록으로 접으면 "쓴 적 없음"으로 오해된다.
final class MyQuestionsControllerProvider
    extends
        $AsyncNotifierProvider<MyQuestionsController, List<MyQuestionItem>> {
  /// 내가 올린 질문 목록.
  ///
  /// **출처는 서버다**(2026-08-18). 서버가 `spotQuestions`에 `mine` 필터를 더하면서,
  /// 질문 목록을 로컬에 쌓던 임시 저장소를 걷어냈다 — 서버가 정답을 주는데 클라이언트가
  /// 따로 기록을 쥐면 어긋날 때 판단 근거가 없다.
  ///
  /// 그래서 **기기를 바꿔도, 앱을 지웠다 깔아도 내 질문이 그대로 보인다.** 예전 로컬
  /// 방식의 가장 큰 구멍이 그것이었다.
  ///
  /// 로컬에 남은 것은 「마지막에 본 답변 수」 하나뿐이다. 서버에 읽음 지점이 없어
  /// 새 답변 배지를 그것 없이는 만들 수 없다. 이 값이 비어도 목록은 정상이고 배지만
  /// 안 뜬다 — **목록의 정확성을 로컬 상태에 걸지 않는다.**
  ///
  /// **인증이 필요하다.** 비로그인이면 repository가 실패를 던지고 화면이 그대로
  /// 오류/로그인 안내로 분기한다 — 빈 목록으로 접으면 "쓴 적 없음"으로 오해된다.
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
    r'5eb366d3b3c8d2adf99ec60cb536c5c46b2535f1';

/// 내가 올린 질문 목록.
///
/// **출처는 서버다**(2026-08-18). 서버가 `spotQuestions`에 `mine` 필터를 더하면서,
/// 질문 목록을 로컬에 쌓던 임시 저장소를 걷어냈다 — 서버가 정답을 주는데 클라이언트가
/// 따로 기록을 쥐면 어긋날 때 판단 근거가 없다.
///
/// 그래서 **기기를 바꿔도, 앱을 지웠다 깔아도 내 질문이 그대로 보인다.** 예전 로컬
/// 방식의 가장 큰 구멍이 그것이었다.
///
/// 로컬에 남은 것은 「마지막에 본 답변 수」 하나뿐이다. 서버에 읽음 지점이 없어
/// 새 답변 배지를 그것 없이는 만들 수 없다. 이 값이 비어도 목록은 정상이고 배지만
/// 안 뜬다 — **목록의 정확성을 로컬 상태에 걸지 않는다.**
///
/// **인증이 필요하다.** 비로그인이면 repository가 실패를 던지고 화면이 그대로
/// 오류/로그인 안내로 분기한다 — 빈 목록으로 접으면 "쓴 적 없음"으로 오해된다.

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
///
/// **로그인 상태에서만 목록을 조회한다.** 서버에 알림이 없어 이 배지가 "답이 달렸다"를
/// 알리는 유일한 채널이라, 사용자가 「내 질문」을 열기 전에도 떠야 한다 — 답변을
/// 확인하려고 여는 화면이 배지의 전제 조건이면 알림 역할을 못 한다.
///
/// 예전에는 `ref.exists`로 걸러 이미 살아 있을 때만 읽었는데, 그러면 화면을 한 번
/// 열어 본 뒤부터만 배지가 떴다. 홈이 앱을 열면 늘 지나는 화면이라 여기서 한 번
/// 받아 두는 편이 낫다(DM 배지와 같은 판단).
///
/// **비로그인이면 조회하지 않는다** — 인증이 필요한 조회라 반드시 실패하고, 홈에서
/// 매번 그 왕복이 나가면 낭비다. 실패해도 0이라 배지가 오류를 끌고 다니지 않는다.

@ProviderFor(myQuestionsUnseenCount)
const myQuestionsUnseenCountProvider = MyQuestionsUnseenCountProvider._();

/// 못 본 답변이 있는 질문 수. 진입점 배지가 이것만 구독한다.
///
/// **로그인 상태에서만 목록을 조회한다.** 서버에 알림이 없어 이 배지가 "답이 달렸다"를
/// 알리는 유일한 채널이라, 사용자가 「내 질문」을 열기 전에도 떠야 한다 — 답변을
/// 확인하려고 여는 화면이 배지의 전제 조건이면 알림 역할을 못 한다.
///
/// 예전에는 `ref.exists`로 걸러 이미 살아 있을 때만 읽었는데, 그러면 화면을 한 번
/// 열어 본 뒤부터만 배지가 떴다. 홈이 앱을 열면 늘 지나는 화면이라 여기서 한 번
/// 받아 두는 편이 낫다(DM 배지와 같은 판단).
///
/// **비로그인이면 조회하지 않는다** — 인증이 필요한 조회라 반드시 실패하고, 홈에서
/// 매번 그 왕복이 나가면 낭비다. 실패해도 0이라 배지가 오류를 끌고 다니지 않는다.

final class MyQuestionsUnseenCountProvider
    extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  /// 못 본 답변이 있는 질문 수. 진입점 배지가 이것만 구독한다.
  ///
  /// **로그인 상태에서만 목록을 조회한다.** 서버에 알림이 없어 이 배지가 "답이 달렸다"를
  /// 알리는 유일한 채널이라, 사용자가 「내 질문」을 열기 전에도 떠야 한다 — 답변을
  /// 확인하려고 여는 화면이 배지의 전제 조건이면 알림 역할을 못 한다.
  ///
  /// 예전에는 `ref.exists`로 걸러 이미 살아 있을 때만 읽었는데, 그러면 화면을 한 번
  /// 열어 본 뒤부터만 배지가 떴다. 홈이 앱을 열면 늘 지나는 화면이라 여기서 한 번
  /// 받아 두는 편이 낫다(DM 배지와 같은 판단).
  ///
  /// **비로그인이면 조회하지 않는다** — 인증이 필요한 조회라 반드시 실패하고, 홈에서
  /// 매번 그 왕복이 나가면 낭비다. 실패해도 0이라 배지가 오류를 끌고 다니지 않는다.
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
    r'89e36196bba4aaaaa821f75a996d535a16c78e5d';
