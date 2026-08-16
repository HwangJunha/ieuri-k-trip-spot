// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_composer_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 컴포저가 편집 중인 초안.
///
/// **autoDispose(codegen 기본)를 유지하되 초안은 디스크에 남는다**(SPEC-0022 §1).
/// 예전에는 "컴포저를 닫으면 초안이 사라지는 것이 맞다"고 보았지만 SPEC-0022가 그
/// 판단을 철회했다. 그렇다고 `keepAlive`로 바꾸지는 않는다 — 프로바이더 수명은 앱
/// 종료를 견디지 못해 R3를 만족하지 못하고, 화면 밖에서 컴포저 상태가 계속 살아 있는
/// 부작용만 생긴다. 초안이 살아남는 곳을 **수명이 아니라 디스크로** 옮긴 것이 이
/// 설계의 요지다.
///
/// **수정 모드는 저장도 복원도 하지 않는다**(R11). 서버에 이미 있는 글을 고치는
/// 중이라 초안이라는 개념이 성립하지 않고, 수정 모드 진입이 새 글 초안을 지우지도
/// 않는다(R11-3).
///
/// **등록 가능 여부는 [PostDraft.canSubmit]이 판정한다.** 서버 검증을 기다렸다가
/// 에러를 보여주는 방식이 아니라 화면이 애초에 잘못된 상태를 만들지 못하게 한다
/// (디자인 §3).

@ProviderFor(PostComposer)
const postComposerProvider = PostComposerFamily._();

/// 컴포저가 편집 중인 초안.
///
/// **autoDispose(codegen 기본)를 유지하되 초안은 디스크에 남는다**(SPEC-0022 §1).
/// 예전에는 "컴포저를 닫으면 초안이 사라지는 것이 맞다"고 보았지만 SPEC-0022가 그
/// 판단을 철회했다. 그렇다고 `keepAlive`로 바꾸지는 않는다 — 프로바이더 수명은 앱
/// 종료를 견디지 못해 R3를 만족하지 못하고, 화면 밖에서 컴포저 상태가 계속 살아 있는
/// 부작용만 생긴다. 초안이 살아남는 곳을 **수명이 아니라 디스크로** 옮긴 것이 이
/// 설계의 요지다.
///
/// **수정 모드는 저장도 복원도 하지 않는다**(R11). 서버에 이미 있는 글을 고치는
/// 중이라 초안이라는 개념이 성립하지 않고, 수정 모드 진입이 새 글 초안을 지우지도
/// 않는다(R11-3).
///
/// **등록 가능 여부는 [PostDraft.canSubmit]이 판정한다.** 서버 검증을 기다렸다가
/// 에러를 보여주는 방식이 아니라 화면이 애초에 잘못된 상태를 만들지 못하게 한다
/// (디자인 §3).
final class PostComposerProvider
    extends $NotifierProvider<PostComposer, PostDraft> {
  /// 컴포저가 편집 중인 초안.
  ///
  /// **autoDispose(codegen 기본)를 유지하되 초안은 디스크에 남는다**(SPEC-0022 §1).
  /// 예전에는 "컴포저를 닫으면 초안이 사라지는 것이 맞다"고 보았지만 SPEC-0022가 그
  /// 판단을 철회했다. 그렇다고 `keepAlive`로 바꾸지는 않는다 — 프로바이더 수명은 앱
  /// 종료를 견디지 못해 R3를 만족하지 못하고, 화면 밖에서 컴포저 상태가 계속 살아 있는
  /// 부작용만 생긴다. 초안이 살아남는 곳을 **수명이 아니라 디스크로** 옮긴 것이 이
  /// 설계의 요지다.
  ///
  /// **수정 모드는 저장도 복원도 하지 않는다**(R11). 서버에 이미 있는 글을 고치는
  /// 중이라 초안이라는 개념이 성립하지 않고, 수정 모드 진입이 새 글 초안을 지우지도
  /// 않는다(R11-3).
  ///
  /// **등록 가능 여부는 [PostDraft.canSubmit]이 판정한다.** 서버 검증을 기다렸다가
  /// 에러를 보여주는 방식이 아니라 화면이 애초에 잘못된 상태를 만들지 못하게 한다
  /// (디자인 §3).
  const PostComposerProvider._({
    required PostComposerFamily super.from,
    required ({
      String? initialSpotId,
      String? initialSpotTitle,
      TargetCategory? initialCategory,
      bool editing,
    })
    super.argument,
  }) : super(
         retry: null,
         name: r'postComposerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$postComposerHash();

  @override
  String toString() {
    return r'postComposerProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  PostComposer create() => PostComposer();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PostDraft value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PostDraft>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is PostComposerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$postComposerHash() => r'8ce71afc744d1e429601ec7b3777f57013d7c48a';

/// 컴포저가 편집 중인 초안.
///
/// **autoDispose(codegen 기본)를 유지하되 초안은 디스크에 남는다**(SPEC-0022 §1).
/// 예전에는 "컴포저를 닫으면 초안이 사라지는 것이 맞다"고 보았지만 SPEC-0022가 그
/// 판단을 철회했다. 그렇다고 `keepAlive`로 바꾸지는 않는다 — 프로바이더 수명은 앱
/// 종료를 견디지 못해 R3를 만족하지 못하고, 화면 밖에서 컴포저 상태가 계속 살아 있는
/// 부작용만 생긴다. 초안이 살아남는 곳을 **수명이 아니라 디스크로** 옮긴 것이 이
/// 설계의 요지다.
///
/// **수정 모드는 저장도 복원도 하지 않는다**(R11). 서버에 이미 있는 글을 고치는
/// 중이라 초안이라는 개념이 성립하지 않고, 수정 모드 진입이 새 글 초안을 지우지도
/// 않는다(R11-3).
///
/// **등록 가능 여부는 [PostDraft.canSubmit]이 판정한다.** 서버 검증을 기다렸다가
/// 에러를 보여주는 방식이 아니라 화면이 애초에 잘못된 상태를 만들지 못하게 한다
/// (디자인 §3).

final class PostComposerFamily extends $Family
    with
        $ClassFamilyOverride<
          PostComposer,
          PostDraft,
          PostDraft,
          PostDraft,
          ({
            String? initialSpotId,
            String? initialSpotTitle,
            TargetCategory? initialCategory,
            bool editing,
          })
        > {
  const PostComposerFamily._()
    : super(
        retry: null,
        name: r'postComposerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// 컴포저가 편집 중인 초안.
  ///
  /// **autoDispose(codegen 기본)를 유지하되 초안은 디스크에 남는다**(SPEC-0022 §1).
  /// 예전에는 "컴포저를 닫으면 초안이 사라지는 것이 맞다"고 보았지만 SPEC-0022가 그
  /// 판단을 철회했다. 그렇다고 `keepAlive`로 바꾸지는 않는다 — 프로바이더 수명은 앱
  /// 종료를 견디지 못해 R3를 만족하지 못하고, 화면 밖에서 컴포저 상태가 계속 살아 있는
  /// 부작용만 생긴다. 초안이 살아남는 곳을 **수명이 아니라 디스크로** 옮긴 것이 이
  /// 설계의 요지다.
  ///
  /// **수정 모드는 저장도 복원도 하지 않는다**(R11). 서버에 이미 있는 글을 고치는
  /// 중이라 초안이라는 개념이 성립하지 않고, 수정 모드 진입이 새 글 초안을 지우지도
  /// 않는다(R11-3).
  ///
  /// **등록 가능 여부는 [PostDraft.canSubmit]이 판정한다.** 서버 검증을 기다렸다가
  /// 에러를 보여주는 방식이 아니라 화면이 애초에 잘못된 상태를 만들지 못하게 한다
  /// (디자인 §3).

  PostComposerProvider call({
    String? initialSpotId,
    String? initialSpotTitle,
    TargetCategory? initialCategory,
    bool editing = false,
  }) => PostComposerProvider._(
    argument: (
      initialSpotId: initialSpotId,
      initialSpotTitle: initialSpotTitle,
      initialCategory: initialCategory,
      editing: editing,
    ),
    from: this,
  );

  @override
  String toString() => r'postComposerProvider';
}

/// 컴포저가 편집 중인 초안.
///
/// **autoDispose(codegen 기본)를 유지하되 초안은 디스크에 남는다**(SPEC-0022 §1).
/// 예전에는 "컴포저를 닫으면 초안이 사라지는 것이 맞다"고 보았지만 SPEC-0022가 그
/// 판단을 철회했다. 그렇다고 `keepAlive`로 바꾸지는 않는다 — 프로바이더 수명은 앱
/// 종료를 견디지 못해 R3를 만족하지 못하고, 화면 밖에서 컴포저 상태가 계속 살아 있는
/// 부작용만 생긴다. 초안이 살아남는 곳을 **수명이 아니라 디스크로** 옮긴 것이 이
/// 설계의 요지다.
///
/// **수정 모드는 저장도 복원도 하지 않는다**(R11). 서버에 이미 있는 글을 고치는
/// 중이라 초안이라는 개념이 성립하지 않고, 수정 모드 진입이 새 글 초안을 지우지도
/// 않는다(R11-3).
///
/// **등록 가능 여부는 [PostDraft.canSubmit]이 판정한다.** 서버 검증을 기다렸다가
/// 에러를 보여주는 방식이 아니라 화면이 애초에 잘못된 상태를 만들지 못하게 한다
/// (디자인 §3).

abstract class _$PostComposer extends $Notifier<PostDraft> {
  late final _$args =
      ref.$arg
          as ({
            String? initialSpotId,
            String? initialSpotTitle,
            TargetCategory? initialCategory,
            bool editing,
          });
  String? get initialSpotId => _$args.initialSpotId;
  String? get initialSpotTitle => _$args.initialSpotTitle;
  TargetCategory? get initialCategory => _$args.initialCategory;
  bool get editing => _$args.editing;

  PostDraft build({
    String? initialSpotId,
    String? initialSpotTitle,
    TargetCategory? initialCategory,
    bool editing = false,
  });
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(
      initialSpotId: _$args.initialSpotId,
      initialSpotTitle: _$args.initialSpotTitle,
      initialCategory: _$args.initialCategory,
      editing: _$args.editing,
    );
    final ref = this.ref as $Ref<PostDraft, PostDraft>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<PostDraft, PostDraft>,
              PostDraft,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
