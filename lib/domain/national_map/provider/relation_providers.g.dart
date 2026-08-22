// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'relation_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 내 관계 목록(관계 지도).
///
/// **캐시하지 않는다**(`keepAlive`를 쓰지 않는다). 겹침은 조회 시점에 재계산된
/// 값이라 오래 들고 있으면 낡는다 — 화면을 다시 열면 새 숫자가 나와야 한다
/// (사용자 결정, 2026-08-22).
///
/// 로그아웃하면 비운다 — 남의 관계 목록이 다음 사용자에게 보이면 안 된다.

@ProviderFor(MapRelations)
const mapRelationsProvider = MapRelationsProvider._();

/// 내 관계 목록(관계 지도).
///
/// **캐시하지 않는다**(`keepAlive`를 쓰지 않는다). 겹침은 조회 시점에 재계산된
/// 값이라 오래 들고 있으면 낡는다 — 화면을 다시 열면 새 숫자가 나와야 한다
/// (사용자 결정, 2026-08-22).
///
/// 로그아웃하면 비운다 — 남의 관계 목록이 다음 사용자에게 보이면 안 된다.
final class MapRelationsProvider
    extends $AsyncNotifierProvider<MapRelations, MapRelationPage> {
  /// 내 관계 목록(관계 지도).
  ///
  /// **캐시하지 않는다**(`keepAlive`를 쓰지 않는다). 겹침은 조회 시점에 재계산된
  /// 값이라 오래 들고 있으면 낡는다 — 화면을 다시 열면 새 숫자가 나와야 한다
  /// (사용자 결정, 2026-08-22).
  ///
  /// 로그아웃하면 비운다 — 남의 관계 목록이 다음 사용자에게 보이면 안 된다.
  const MapRelationsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mapRelationsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mapRelationsHash();

  @$internal
  @override
  MapRelations create() => MapRelations();
}

String _$mapRelationsHash() => r'6a43cccfd4989566185f030fb93dfcaf39282d88';

/// 내 관계 목록(관계 지도).
///
/// **캐시하지 않는다**(`keepAlive`를 쓰지 않는다). 겹침은 조회 시점에 재계산된
/// 값이라 오래 들고 있으면 낡는다 — 화면을 다시 열면 새 숫자가 나와야 한다
/// (사용자 결정, 2026-08-22).
///
/// 로그아웃하면 비운다 — 남의 관계 목록이 다음 사용자에게 보이면 안 된다.

abstract class _$MapRelations extends $AsyncNotifier<MapRelationPage> {
  FutureOr<MapRelationPage> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<MapRelationPage>, MapRelationPage>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<MapRelationPage>, MapRelationPage>,
              AsyncValue<MapRelationPage>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// 공유 링크로 관계를 맺는다.
///
/// 성공하면 [MapRelations]를 무효화해 목록을 다시 받는다 — 새로 맺은 상대의
/// 겹침 수는 서버가 계산해 주므로 클라이언트가 만들어 낼 수 없다.

@ProviderFor(RelationRegistration)
const relationRegistrationProvider = RelationRegistrationProvider._();

/// 공유 링크로 관계를 맺는다.
///
/// 성공하면 [MapRelations]를 무효화해 목록을 다시 받는다 — 새로 맺은 상대의
/// 겹침 수는 서버가 계산해 주므로 클라이언트가 만들어 낼 수 없다.
final class RelationRegistrationProvider
    extends $NotifierProvider<RelationRegistration, bool> {
  /// 공유 링크로 관계를 맺는다.
  ///
  /// 성공하면 [MapRelations]를 무효화해 목록을 다시 받는다 — 새로 맺은 상대의
  /// 겹침 수는 서버가 계산해 주므로 클라이언트가 만들어 낼 수 없다.
  const RelationRegistrationProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'relationRegistrationProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$relationRegistrationHash();

  @$internal
  @override
  RelationRegistration create() => RelationRegistration();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$relationRegistrationHash() =>
    r'c92cf5821336c052b5673427e241c2471b54dff2';

/// 공유 링크로 관계를 맺는다.
///
/// 성공하면 [MapRelations]를 무효화해 목록을 다시 받는다 — 새로 맺은 상대의
/// 겹침 수는 서버가 계산해 주므로 클라이언트가 만들어 낼 수 없다.

abstract class _$RelationRegistration extends $Notifier<bool> {
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

/// 이 공유 지도의 주인이 이미 내 관계 목록에 있는지.
///
/// 「등록」 버튼을 「등록됨」으로 바꿀 때 쓴다. 목록을 아직 못 받았으면 false다 —
/// 모르는 동안 「등록됨」으로 보이는 것보다 한 번 더 눌리는 편이 낫다(멱등이라
/// 다시 눌러도 안전하다).

@ProviderFor(isRelatedNickname)
const isRelatedNicknameProvider = IsRelatedNicknameFamily._();

/// 이 공유 지도의 주인이 이미 내 관계 목록에 있는지.
///
/// 「등록」 버튼을 「등록됨」으로 바꿀 때 쓴다. 목록을 아직 못 받았으면 false다 —
/// 모르는 동안 「등록됨」으로 보이는 것보다 한 번 더 눌리는 편이 낫다(멱등이라
/// 다시 눌러도 안전하다).

final class IsRelatedNicknameProvider
    extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  /// 이 공유 지도의 주인이 이미 내 관계 목록에 있는지.
  ///
  /// 「등록」 버튼을 「등록됨」으로 바꿀 때 쓴다. 목록을 아직 못 받았으면 false다 —
  /// 모르는 동안 「등록됨」으로 보이는 것보다 한 번 더 눌리는 편이 낫다(멱등이라
  /// 다시 눌러도 안전하다).
  const IsRelatedNicknameProvider._({
    required IsRelatedNicknameFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'isRelatedNicknameProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$isRelatedNicknameHash();

  @override
  String toString() {
    return r'isRelatedNicknameProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    final argument = this.argument as String;
    return isRelatedNickname(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is IsRelatedNicknameProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$isRelatedNicknameHash() => r'07493cdbd500c9f85ac1f8d8d7970dfa26f0168f';

/// 이 공유 지도의 주인이 이미 내 관계 목록에 있는지.
///
/// 「등록」 버튼을 「등록됨」으로 바꿀 때 쓴다. 목록을 아직 못 받았으면 false다 —
/// 모르는 동안 「등록됨」으로 보이는 것보다 한 번 더 눌리는 편이 낫다(멱등이라
/// 다시 눌러도 안전하다).

final class IsRelatedNicknameFamily extends $Family
    with $FunctionalFamilyOverride<bool, String> {
  const IsRelatedNicknameFamily._()
    : super(
        retry: null,
        name: r'isRelatedNicknameProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// 이 공유 지도의 주인이 이미 내 관계 목록에 있는지.
  ///
  /// 「등록」 버튼을 「등록됨」으로 바꿀 때 쓴다. 목록을 아직 못 받았으면 false다 —
  /// 모르는 동안 「등록됨」으로 보이는 것보다 한 번 더 눌리는 편이 낫다(멱등이라
  /// 다시 눌러도 안전하다).

  IsRelatedNicknameProvider call(String nickname) =>
      IsRelatedNicknameProvider._(argument: nickname, from: this);

  @override
  String toString() => r'isRelatedNicknameProvider';
}
