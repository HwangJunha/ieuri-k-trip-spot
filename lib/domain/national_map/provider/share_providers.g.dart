// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'share_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(shareSheetService)
const shareSheetServiceProvider = ShareSheetServiceProvider._();

final class ShareSheetServiceProvider
    extends
        $FunctionalProvider<
          ShareSheetService,
          ShareSheetService,
          ShareSheetService
        >
    with $Provider<ShareSheetService> {
  const ShareSheetServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'shareSheetServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$shareSheetServiceHash();

  @$internal
  @override
  $ProviderElement<ShareSheetService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ShareSheetService create(Ref ref) {
    return shareSheetService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ShareSheetService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ShareSheetService>(value),
    );
  }
}

String _$shareSheetServiceHash() => r'f58f83f52fb74e3a88fe4d2b2af7c0479ada6c08';

/// 공유 링크 발급과 시스템 공유 시트 전달(R36).
///
/// **링크를 조립하지 않는다** — 서버가 완성된 `shareUrl`을 준다. 지금은
/// `ieuri://shared/<token>`이고 웹이 생기면 Universal Link로 바뀌는데, 서버가
/// 조립하므로 그때 앱 배포가 필요 없다.

@ProviderFor(ShareController)
const shareControllerProvider = ShareControllerProvider._();

/// 공유 링크 발급과 시스템 공유 시트 전달(R36).
///
/// **링크를 조립하지 않는다** — 서버가 완성된 `shareUrl`을 준다. 지금은
/// `ieuri://shared/<token>`이고 웹이 생기면 Universal Link로 바뀌는데, 서버가
/// 조립하므로 그때 앱 배포가 필요 없다.
final class ShareControllerProvider
    extends $NotifierProvider<ShareController, bool> {
  /// 공유 링크 발급과 시스템 공유 시트 전달(R36).
  ///
  /// **링크를 조립하지 않는다** — 서버가 완성된 `shareUrl`을 준다. 지금은
  /// `ieuri://shared/<token>`이고 웹이 생기면 Universal Link로 바뀌는데, 서버가
  /// 조립하므로 그때 앱 배포가 필요 없다.
  const ShareControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'shareControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$shareControllerHash();

  @$internal
  @override
  ShareController create() => ShareController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$shareControllerHash() => r'4382a3197771d11dcd5fb10aef1f70db6f297eaf';

/// 공유 링크 발급과 시스템 공유 시트 전달(R36).
///
/// **링크를 조립하지 않는다** — 서버가 완성된 `shareUrl`을 준다. 지금은
/// `ieuri://shared/<token>`이고 웹이 생기면 Universal Link로 바뀌는데, 서버가
/// 조립하므로 그때 앱 배포가 필요 없다.

abstract class _$ShareController extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// 공유 링크로 조회한 남의 지도(R37·R38).

@ProviderFor(sharedMap)
const sharedMapProvider = SharedMapFamily._();

/// 공유 링크로 조회한 남의 지도(R37·R38).

final class SharedMapProvider
    extends
        $FunctionalProvider<
          AsyncValue<SharedMap>,
          SharedMap,
          FutureOr<SharedMap>
        >
    with $FutureModifier<SharedMap>, $FutureProvider<SharedMap> {
  /// 공유 링크로 조회한 남의 지도(R37·R38).
  const SharedMapProvider._({
    required SharedMapFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'sharedMapProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$sharedMapHash();

  @override
  String toString() {
    return r'sharedMapProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<SharedMap> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<SharedMap> create(Ref ref) {
    final argument = this.argument as String;
    return sharedMap(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is SharedMapProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$sharedMapHash() => r'aff16e8472616bb57375206181330df55836caa3';

/// 공유 링크로 조회한 남의 지도(R37·R38).

final class SharedMapFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<SharedMap>, String> {
  const SharedMapFamily._()
    : super(
        retry: null,
        name: r'sharedMapProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// 공유 링크로 조회한 남의 지도(R37·R38).

  SharedMapProvider call(String token) =>
      SharedMapProvider._(argument: token, from: this);

  @override
  String toString() => r'sharedMapProvider';
}
