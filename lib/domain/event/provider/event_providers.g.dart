// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Exposes the [EventRepository]. Widgets never construct it (CLAUDE.md §5); the
/// section provider reads it from here, and tests override this one provider to
/// inject a fake.

@ProviderFor(eventRepository)
const eventRepositoryProvider = EventRepositoryProvider._();

/// Exposes the [EventRepository]. Widgets never construct it (CLAUDE.md §5); the
/// section provider reads it from here, and tests override this one provider to
/// inject a fake.

final class EventRepositoryProvider
    extends
        $FunctionalProvider<EventRepository, EventRepository, EventRepository>
    with $Provider<EventRepository> {
  /// Exposes the [EventRepository]. Widgets never construct it (CLAUDE.md §5); the
  /// section provider reads it from here, and tests override this one provider to
  /// inject a fake.
  const EventRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'eventRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$eventRepositoryHash();

  @$internal
  @override
  $ProviderElement<EventRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  EventRepository create(Ref ref) {
    return eventRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(EventRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<EventRepository>(value),
    );
  }
}

String _$eventRepositoryHash() => r'963679aaa335109fd431749ca4350fbd6fb9e859';

/// 홈 "Happening Now" 섹션(R17). 반경 안에서 오늘 진행 중인 축제만 온다.
///
/// 좌표와 반경을 `watch`하는 것은 Near you와 같은 이유다 — 설정에서 반경을 바꾸면
/// 다음 조회에 반영되어야 한다(AC-16.2와 같은 성질).
///
/// **홈의 세 섹션은 각각 독립된 provider다**(R19). 이 provider의 실패나 빈 결과가
/// 다른 섹션에 번지지 않고, 재시도도 이것 하나만 무효화한다(AC-20.2).

@ProviderFor(happeningNowEvents)
const happeningNowEventsProvider = HappeningNowEventsProvider._();

/// 홈 "Happening Now" 섹션(R17). 반경 안에서 오늘 진행 중인 축제만 온다.
///
/// 좌표와 반경을 `watch`하는 것은 Near you와 같은 이유다 — 설정에서 반경을 바꾸면
/// 다음 조회에 반영되어야 한다(AC-16.2와 같은 성질).
///
/// **홈의 세 섹션은 각각 독립된 provider다**(R19). 이 provider의 실패나 빈 결과가
/// 다른 섹션에 번지지 않고, 재시도도 이것 하나만 무효화한다(AC-20.2).

final class HappeningNowEventsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Festival>>,
          List<Festival>,
          FutureOr<List<Festival>>
        >
    with $FutureModifier<List<Festival>>, $FutureProvider<List<Festival>> {
  /// 홈 "Happening Now" 섹션(R17). 반경 안에서 오늘 진행 중인 축제만 온다.
  ///
  /// 좌표와 반경을 `watch`하는 것은 Near you와 같은 이유다 — 설정에서 반경을 바꾸면
  /// 다음 조회에 반영되어야 한다(AC-16.2와 같은 성질).
  ///
  /// **홈의 세 섹션은 각각 독립된 provider다**(R19). 이 provider의 실패나 빈 결과가
  /// 다른 섹션에 번지지 않고, 재시도도 이것 하나만 무효화한다(AC-20.2).
  const HappeningNowEventsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'happeningNowEventsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$happeningNowEventsHash();

  @$internal
  @override
  $FutureProviderElement<List<Festival>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Festival>> create(Ref ref) {
    return happeningNowEvents(ref);
  }
}

String _$happeningNowEventsHash() =>
    r'0fafcef4dfd6b9e790739e5f39550c1aab0023fe';
