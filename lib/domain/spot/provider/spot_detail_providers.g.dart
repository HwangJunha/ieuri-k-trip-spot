// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'spot_detail_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 상세를 열기 직전에 목록이 알려주는 **spot의 카테고리 코드**(contentId → code).
///
/// **왜 필요한가.** `spotDetail`의 `intro`/`infoItems`는 카테고리마다 다른 TourAPI
/// 응답을 정규화하므로 서버가 `categoryCode`를 요구한다. 그런데 상세 응답의
/// `category.code`는 서버가 전 spot에서 null로 주므로 응답만으로는 채울 수 없다.
/// 목록(스와이프·검색·좋아요)은 그 코드를 이미 알고 있어서, 상세로 넘어가기 전에
/// 여기 적어 둔다.
///
/// **family 키가 아니라 별도 맵인 이유.** 카테고리는 같은 spot이면 늘 같은 값이라
/// 조회 결과를 가르지 않는다. `spotDetailController`의 family 키에 넣으면 딥링크
/// 진입(코드 없음)과 목록 진입(코드 있음)이 같은 spot에서 서로 다른 provider가 되어
/// 같은 상세를 두 번 조회한다.
///
/// keepAlive다 — 상세를 열고 닫는 동안 살아 있어야 하고, 항목 몇 개의 문자열이라
/// 비용이 없다.

@ProviderFor(SpotCategoryCodes)
const spotCategoryCodesProvider = SpotCategoryCodesProvider._();

/// 상세를 열기 직전에 목록이 알려주는 **spot의 카테고리 코드**(contentId → code).
///
/// **왜 필요한가.** `spotDetail`의 `intro`/`infoItems`는 카테고리마다 다른 TourAPI
/// 응답을 정규화하므로 서버가 `categoryCode`를 요구한다. 그런데 상세 응답의
/// `category.code`는 서버가 전 spot에서 null로 주므로 응답만으로는 채울 수 없다.
/// 목록(스와이프·검색·좋아요)은 그 코드를 이미 알고 있어서, 상세로 넘어가기 전에
/// 여기 적어 둔다.
///
/// **family 키가 아니라 별도 맵인 이유.** 카테고리는 같은 spot이면 늘 같은 값이라
/// 조회 결과를 가르지 않는다. `spotDetailController`의 family 키에 넣으면 딥링크
/// 진입(코드 없음)과 목록 진입(코드 있음)이 같은 spot에서 서로 다른 provider가 되어
/// 같은 상세를 두 번 조회한다.
///
/// keepAlive다 — 상세를 열고 닫는 동안 살아 있어야 하고, 항목 몇 개의 문자열이라
/// 비용이 없다.
final class SpotCategoryCodesProvider
    extends $NotifierProvider<SpotCategoryCodes, Map<String, String>> {
  /// 상세를 열기 직전에 목록이 알려주는 **spot의 카테고리 코드**(contentId → code).
  ///
  /// **왜 필요한가.** `spotDetail`의 `intro`/`infoItems`는 카테고리마다 다른 TourAPI
  /// 응답을 정규화하므로 서버가 `categoryCode`를 요구한다. 그런데 상세 응답의
  /// `category.code`는 서버가 전 spot에서 null로 주므로 응답만으로는 채울 수 없다.
  /// 목록(스와이프·검색·좋아요)은 그 코드를 이미 알고 있어서, 상세로 넘어가기 전에
  /// 여기 적어 둔다.
  ///
  /// **family 키가 아니라 별도 맵인 이유.** 카테고리는 같은 spot이면 늘 같은 값이라
  /// 조회 결과를 가르지 않는다. `spotDetailController`의 family 키에 넣으면 딥링크
  /// 진입(코드 없음)과 목록 진입(코드 있음)이 같은 spot에서 서로 다른 provider가 되어
  /// 같은 상세를 두 번 조회한다.
  ///
  /// keepAlive다 — 상세를 열고 닫는 동안 살아 있어야 하고, 항목 몇 개의 문자열이라
  /// 비용이 없다.
  const SpotCategoryCodesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'spotCategoryCodesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$spotCategoryCodesHash();

  @$internal
  @override
  SpotCategoryCodes create() => SpotCategoryCodes();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<String, String> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<String, String>>(value),
    );
  }
}

String _$spotCategoryCodesHash() => r'5c8de5910e665aebfd6aad90e2bd3e650de88278';

/// 상세를 열기 직전에 목록이 알려주는 **spot의 카테고리 코드**(contentId → code).
///
/// **왜 필요한가.** `spotDetail`의 `intro`/`infoItems`는 카테고리마다 다른 TourAPI
/// 응답을 정규화하므로 서버가 `categoryCode`를 요구한다. 그런데 상세 응답의
/// `category.code`는 서버가 전 spot에서 null로 주므로 응답만으로는 채울 수 없다.
/// 목록(스와이프·검색·좋아요)은 그 코드를 이미 알고 있어서, 상세로 넘어가기 전에
/// 여기 적어 둔다.
///
/// **family 키가 아니라 별도 맵인 이유.** 카테고리는 같은 spot이면 늘 같은 값이라
/// 조회 결과를 가르지 않는다. `spotDetailController`의 family 키에 넣으면 딥링크
/// 진입(코드 없음)과 목록 진입(코드 있음)이 같은 spot에서 서로 다른 provider가 되어
/// 같은 상세를 두 번 조회한다.
///
/// keepAlive다 — 상세를 열고 닫는 동안 살아 있어야 하고, 항목 몇 개의 문자열이라
/// 비용이 없다.

abstract class _$SpotCategoryCodes extends $Notifier<Map<String, String>> {
  Map<String, String> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<Map<String, String>, Map<String, String>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Map<String, String>, Map<String, String>>,
              Map<String, String>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// 관광지 상세 컨트롤러(SPEC-0003). [contentId]별 패밀리 — 상세 진입마다 해당 id의
/// 인스턴스를 로드한다.
///
/// - 첫 빌드: `spotDetail(id)`을 조회해 [SpotDetail]을 상태로 둔다. 실패는 `AsyncError`로
///   노출돼 뷰가 SPOT_NOT_FOUND·UPSTREAM_* 등 오류 상태를 그린다(spec §6).
/// - [react]: 좋아요/싫어요 탭 시 `likeCount`를 **낙관적으로 즉시** 갱신하고
///   `reactToSpot`을 발사한다. 실패 시 이전 값으로 **롤백**한다(AC-30) — 스와이프와 달리
///   개수가 화면에 보이는 값이라 되돌려야 한다(spec §4).
/// - 재평가는 이전 반응을 덮어쓰는 것으로 계산한다(SPEC-0002 규약): LIKE→DISLIKE면
///   직전 +1을 되돌려 순변화 −1. 같은 반응 반복은 순변화 0.
/// [retry]로 자동 재시도를 1회로 묶는다(SPEC-0006 R1) — 스와이프와 같은 정책이다.

@ProviderFor(SpotDetailController)
const spotDetailControllerProvider = SpotDetailControllerFamily._();

/// 관광지 상세 컨트롤러(SPEC-0003). [contentId]별 패밀리 — 상세 진입마다 해당 id의
/// 인스턴스를 로드한다.
///
/// - 첫 빌드: `spotDetail(id)`을 조회해 [SpotDetail]을 상태로 둔다. 실패는 `AsyncError`로
///   노출돼 뷰가 SPOT_NOT_FOUND·UPSTREAM_* 등 오류 상태를 그린다(spec §6).
/// - [react]: 좋아요/싫어요 탭 시 `likeCount`를 **낙관적으로 즉시** 갱신하고
///   `reactToSpot`을 발사한다. 실패 시 이전 값으로 **롤백**한다(AC-30) — 스와이프와 달리
///   개수가 화면에 보이는 값이라 되돌려야 한다(spec §4).
/// - 재평가는 이전 반응을 덮어쓰는 것으로 계산한다(SPEC-0002 규약): LIKE→DISLIKE면
///   직전 +1을 되돌려 순변화 −1. 같은 반응 반복은 순변화 0.
/// [retry]로 자동 재시도를 1회로 묶는다(SPEC-0006 R1) — 스와이프와 같은 정책이다.
final class SpotDetailControllerProvider
    extends $AsyncNotifierProvider<SpotDetailController, SpotDetail> {
  /// 관광지 상세 컨트롤러(SPEC-0003). [contentId]별 패밀리 — 상세 진입마다 해당 id의
  /// 인스턴스를 로드한다.
  ///
  /// - 첫 빌드: `spotDetail(id)`을 조회해 [SpotDetail]을 상태로 둔다. 실패는 `AsyncError`로
  ///   노출돼 뷰가 SPOT_NOT_FOUND·UPSTREAM_* 등 오류 상태를 그린다(spec §6).
  /// - [react]: 좋아요/싫어요 탭 시 `likeCount`를 **낙관적으로 즉시** 갱신하고
  ///   `reactToSpot`을 발사한다. 실패 시 이전 값으로 **롤백**한다(AC-30) — 스와이프와 달리
  ///   개수가 화면에 보이는 값이라 되돌려야 한다(spec §4).
  /// - 재평가는 이전 반응을 덮어쓰는 것으로 계산한다(SPEC-0002 규약): LIKE→DISLIKE면
  ///   직전 +1을 되돌려 순변화 −1. 같은 반응 반복은 순변화 0.
  /// [retry]로 자동 재시도를 1회로 묶는다(SPEC-0006 R1) — 스와이프와 같은 정책이다.
  const SpotDetailControllerProvider._({
    required SpotDetailControllerFamily super.from,
    required String super.argument,
  }) : super(
         retry: spotRetryPolicy,
         name: r'spotDetailControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$spotDetailControllerHash();

  @override
  String toString() {
    return r'spotDetailControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  SpotDetailController create() => SpotDetailController();

  @override
  bool operator ==(Object other) {
    return other is SpotDetailControllerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$spotDetailControllerHash() =>
    r'80142b9ee625a39020f1861daa7cf4f41233254f';

/// 관광지 상세 컨트롤러(SPEC-0003). [contentId]별 패밀리 — 상세 진입마다 해당 id의
/// 인스턴스를 로드한다.
///
/// - 첫 빌드: `spotDetail(id)`을 조회해 [SpotDetail]을 상태로 둔다. 실패는 `AsyncError`로
///   노출돼 뷰가 SPOT_NOT_FOUND·UPSTREAM_* 등 오류 상태를 그린다(spec §6).
/// - [react]: 좋아요/싫어요 탭 시 `likeCount`를 **낙관적으로 즉시** 갱신하고
///   `reactToSpot`을 발사한다. 실패 시 이전 값으로 **롤백**한다(AC-30) — 스와이프와 달리
///   개수가 화면에 보이는 값이라 되돌려야 한다(spec §4).
/// - 재평가는 이전 반응을 덮어쓰는 것으로 계산한다(SPEC-0002 규약): LIKE→DISLIKE면
///   직전 +1을 되돌려 순변화 −1. 같은 반응 반복은 순변화 0.
/// [retry]로 자동 재시도를 1회로 묶는다(SPEC-0006 R1) — 스와이프와 같은 정책이다.

final class SpotDetailControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          SpotDetailController,
          AsyncValue<SpotDetail>,
          SpotDetail,
          FutureOr<SpotDetail>,
          String
        > {
  const SpotDetailControllerFamily._()
    : super(
        retry: spotRetryPolicy,
        name: r'spotDetailControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// 관광지 상세 컨트롤러(SPEC-0003). [contentId]별 패밀리 — 상세 진입마다 해당 id의
  /// 인스턴스를 로드한다.
  ///
  /// - 첫 빌드: `spotDetail(id)`을 조회해 [SpotDetail]을 상태로 둔다. 실패는 `AsyncError`로
  ///   노출돼 뷰가 SPOT_NOT_FOUND·UPSTREAM_* 등 오류 상태를 그린다(spec §6).
  /// - [react]: 좋아요/싫어요 탭 시 `likeCount`를 **낙관적으로 즉시** 갱신하고
  ///   `reactToSpot`을 발사한다. 실패 시 이전 값으로 **롤백**한다(AC-30) — 스와이프와 달리
  ///   개수가 화면에 보이는 값이라 되돌려야 한다(spec §4).
  /// - 재평가는 이전 반응을 덮어쓰는 것으로 계산한다(SPEC-0002 규약): LIKE→DISLIKE면
  ///   직전 +1을 되돌려 순변화 −1. 같은 반응 반복은 순변화 0.
  /// [retry]로 자동 재시도를 1회로 묶는다(SPEC-0006 R1) — 스와이프와 같은 정책이다.

  SpotDetailControllerProvider call(String contentId) =>
      SpotDetailControllerProvider._(argument: contentId, from: this);

  @override
  String toString() => r'spotDetailControllerProvider';
}

/// 관광지 상세 컨트롤러(SPEC-0003). [contentId]별 패밀리 — 상세 진입마다 해당 id의
/// 인스턴스를 로드한다.
///
/// - 첫 빌드: `spotDetail(id)`을 조회해 [SpotDetail]을 상태로 둔다. 실패는 `AsyncError`로
///   노출돼 뷰가 SPOT_NOT_FOUND·UPSTREAM_* 등 오류 상태를 그린다(spec §6).
/// - [react]: 좋아요/싫어요 탭 시 `likeCount`를 **낙관적으로 즉시** 갱신하고
///   `reactToSpot`을 발사한다. 실패 시 이전 값으로 **롤백**한다(AC-30) — 스와이프와 달리
///   개수가 화면에 보이는 값이라 되돌려야 한다(spec §4).
/// - 재평가는 이전 반응을 덮어쓰는 것으로 계산한다(SPEC-0002 규약): LIKE→DISLIKE면
///   직전 +1을 되돌려 순변화 −1. 같은 반응 반복은 순변화 0.
/// [retry]로 자동 재시도를 1회로 묶는다(SPEC-0006 R1) — 스와이프와 같은 정책이다.

abstract class _$SpotDetailController extends $AsyncNotifier<SpotDetail> {
  late final _$args = ref.$arg as String;
  String get contentId => _$args;

  FutureOr<SpotDetail> build(String contentId);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
    final ref = this.ref as $Ref<AsyncValue<SpotDetail>, SpotDetail>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<SpotDetail>, SpotDetail>,
              AsyncValue<SpotDetail>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
