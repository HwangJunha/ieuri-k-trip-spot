import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/domain/map/model/sdk_screen_scale.dart';

/// 카카오 SDK `fromScreenPoint`에 넘길 좌표 배율.
///
/// Android만 물리 픽셀이다 — 배율을 빼먹으면 화면이 좌상단 1/devicePixelRatio로
/// 잡혀 마커가 왼쪽 위에만 몰린다(실기기 2026-09-23).
void main() {
  test('Android는 devicePixelRatio를 곱해 물리 픽셀로 넘긴다', () {
    expect(sdkScreenScale(TargetPlatform.android, 2.625), 2.625);
  });

  test('iOS는 point 단위라 논리 픽셀을 그대로 넘긴다', () {
    expect(sdkScreenScale(TargetPlatform.iOS, 3.0), 1.0);
  });
}
