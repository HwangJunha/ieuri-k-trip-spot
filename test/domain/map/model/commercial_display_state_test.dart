import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/domain/map/model/commercial_activity_level.dart';
import 'package:ieuri_k_trip_spot/domain/map/model/commercial_display_state.dart';

/// 상권 3상태(R28). 부재 · 기본값 · 실측을 구분하지 못하면 39곳의 가짜 "보통"이
/// 실측값과 섞인다(spec §4.5).
void main() {
  CommercialStatus statusOf({
    required bool isDefaulted,
    CommercialActivityLevel level = CommercialActivityLevel.normal,
  }) => CommercialStatus(
    level: level,
    isDefaulted: isDefaulted,
    observedAt: DateTime.utc(2026, 8, 9, 23, 50),
  );

  test('상권 정보가 부재면 정보 없음이다', () {
    expect(commercialDisplayStateOf(null), CommercialDisplayState.unavailable);
  });

  test('기본값 표식이 참이면 실측과 구분되는 상태다', () {
    expect(
      commercialDisplayStateOf(statusOf(isDefaulted: true)),
      CommercialDisplayState.estimated,
    );
  });

  test('기본값 표식이 거짓이면 실측이다', () {
    expect(
      commercialDisplayStateOf(statusOf(isDefaulted: false)),
      CommercialDisplayState.measured,
    );
  });

  /// 이것이 3상태를 두는 이유 그 자체다. 값이 같아도 신뢰도가 다르다.
  test('같은 보통이라도 실측과 기본값은 다른 상태다', () {
    final CommercialDisplayState measured = commercialDisplayStateOf(
      statusOf(isDefaulted: false),
    );
    final CommercialDisplayState defaulted = commercialDisplayStateOf(
      statusOf(isDefaulted: true),
    );

    expect(measured, isNot(defaulted));
  });

  test('부재와 기본값도 서로 다른 상태다 — 하나로 뭉뚱그리지 않는다', () {
    expect(
      commercialDisplayStateOf(null),
      isNot(commercialDisplayStateOf(statusOf(isDefaulted: true))),
    );
  });
}
