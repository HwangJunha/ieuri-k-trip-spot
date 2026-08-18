// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'spot_question_by_id_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// id 하나로 질문을 집어 온다(2026-08-18 서버가 `ids` 필터를 더했다).
///
/// **딥링크·알림 진입의 폴백이다.** 상세 화면은 보통 목록 provider가 이미 받아 둔
/// 항목에서 질문을 찾는데, 목록을 거치지 않고 들어오거나 아직 받지 못한 페이지의
/// 질문이면 거기 없다. 예전에는 그 경우 "불러오지 못했습니다"로 끝났지만 이제
/// 서버에 직접 물어 연다.
///
/// **없으면 null이다. 오류가 아니다.** 차단·숨김·삭제로 가려진 질문은 결과에서
/// 빠지도록 서버가 정해 두었고, 그 구분은 클라이언트에 오지 않는다 — "없거나 볼 수
/// 없음"을 하나로 다룬다.

@ProviderFor(spotQuestionById)
const spotQuestionByIdProvider = SpotQuestionByIdFamily._();

/// id 하나로 질문을 집어 온다(2026-08-18 서버가 `ids` 필터를 더했다).
///
/// **딥링크·알림 진입의 폴백이다.** 상세 화면은 보통 목록 provider가 이미 받아 둔
/// 항목에서 질문을 찾는데, 목록을 거치지 않고 들어오거나 아직 받지 못한 페이지의
/// 질문이면 거기 없다. 예전에는 그 경우 "불러오지 못했습니다"로 끝났지만 이제
/// 서버에 직접 물어 연다.
///
/// **없으면 null이다. 오류가 아니다.** 차단·숨김·삭제로 가려진 질문은 결과에서
/// 빠지도록 서버가 정해 두었고, 그 구분은 클라이언트에 오지 않는다 — "없거나 볼 수
/// 없음"을 하나로 다룬다.

final class SpotQuestionByIdProvider
    extends
        $FunctionalProvider<
          AsyncValue<SpotQuestion?>,
          SpotQuestion?,
          FutureOr<SpotQuestion?>
        >
    with $FutureModifier<SpotQuestion?>, $FutureProvider<SpotQuestion?> {
  /// id 하나로 질문을 집어 온다(2026-08-18 서버가 `ids` 필터를 더했다).
  ///
  /// **딥링크·알림 진입의 폴백이다.** 상세 화면은 보통 목록 provider가 이미 받아 둔
  /// 항목에서 질문을 찾는데, 목록을 거치지 않고 들어오거나 아직 받지 못한 페이지의
  /// 질문이면 거기 없다. 예전에는 그 경우 "불러오지 못했습니다"로 끝났지만 이제
  /// 서버에 직접 물어 연다.
  ///
  /// **없으면 null이다. 오류가 아니다.** 차단·숨김·삭제로 가려진 질문은 결과에서
  /// 빠지도록 서버가 정해 두었고, 그 구분은 클라이언트에 오지 않는다 — "없거나 볼 수
  /// 없음"을 하나로 다룬다.
  const SpotQuestionByIdProvider._({
    required SpotQuestionByIdFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'spotQuestionByIdProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$spotQuestionByIdHash();

  @override
  String toString() {
    return r'spotQuestionByIdProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<SpotQuestion?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<SpotQuestion?> create(Ref ref) {
    final argument = this.argument as String;
    return spotQuestionById(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is SpotQuestionByIdProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$spotQuestionByIdHash() => r'43459313f13dc00d315974df06ac0d8301727b0d';

/// id 하나로 질문을 집어 온다(2026-08-18 서버가 `ids` 필터를 더했다).
///
/// **딥링크·알림 진입의 폴백이다.** 상세 화면은 보통 목록 provider가 이미 받아 둔
/// 항목에서 질문을 찾는데, 목록을 거치지 않고 들어오거나 아직 받지 못한 페이지의
/// 질문이면 거기 없다. 예전에는 그 경우 "불러오지 못했습니다"로 끝났지만 이제
/// 서버에 직접 물어 연다.
///
/// **없으면 null이다. 오류가 아니다.** 차단·숨김·삭제로 가려진 질문은 결과에서
/// 빠지도록 서버가 정해 두었고, 그 구분은 클라이언트에 오지 않는다 — "없거나 볼 수
/// 없음"을 하나로 다룬다.

final class SpotQuestionByIdFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<SpotQuestion?>, String> {
  const SpotQuestionByIdFamily._()
    : super(
        retry: null,
        name: r'spotQuestionByIdProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// id 하나로 질문을 집어 온다(2026-08-18 서버가 `ids` 필터를 더했다).
  ///
  /// **딥링크·알림 진입의 폴백이다.** 상세 화면은 보통 목록 provider가 이미 받아 둔
  /// 항목에서 질문을 찾는데, 목록을 거치지 않고 들어오거나 아직 받지 못한 페이지의
  /// 질문이면 거기 없다. 예전에는 그 경우 "불러오지 못했습니다"로 끝났지만 이제
  /// 서버에 직접 물어 연다.
  ///
  /// **없으면 null이다. 오류가 아니다.** 차단·숨김·삭제로 가려진 질문은 결과에서
  /// 빠지도록 서버가 정해 두었고, 그 구분은 클라이언트에 오지 않는다 — "없거나 볼 수
  /// 없음"을 하나로 다룬다.

  SpotQuestionByIdProvider call(String questionId) =>
      SpotQuestionByIdProvider._(argument: questionId, from: this);

  @override
  String toString() => r'spotQuestionByIdProvider';
}
