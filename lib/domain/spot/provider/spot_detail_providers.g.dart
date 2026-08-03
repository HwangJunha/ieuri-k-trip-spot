// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'spot_detail_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
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
    required (String, SpotCategory) super.argument,
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
        '$argument';
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
    r'6dc979421ac9eeff273423159424b048e442f45c';

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
          (String, SpotCategory)
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

  SpotDetailControllerProvider call(String contentId, SpotCategory category) =>
      SpotDetailControllerProvider._(
        argument: (contentId, category),
        from: this,
      );

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
  late final _$args = ref.$arg as (String, SpotCategory);
  String get contentId => _$args.$1;
  SpotCategory get category => _$args.$2;

  FutureOr<SpotDetail> build(String contentId, SpotCategory category);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args.$1, _$args.$2);
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
