import 'package:flutter/foundation.dart';

/// Flutter 논리 픽셀을 카카오 SDK `fromScreenPoint`가 받는 화면 좌표로 바꾸는 배율.
///
/// **SDK가 플랫폼마다 다른 단위를 받는다.** 플러그인은 값을 변환 없이 네이티브로
/// 넘기는데, iOS(`KakaoMap.getPosition(CGPoint)`)는 point라 논리 픽셀과 같고,
/// Android(`KakaoMap.fromScreenPoint(int, int)`)는 **물리 픽셀**이다.
///
/// 논리 픽셀을 그대로 넘기면 Android에서만 화면이 좌상단 1/devicePixelRatio로
/// 잡힌다 — 그 좁은 영역으로 추천을 조회하고 그 안의 마커만 그려, 마커가 화면
/// 왼쪽 위에만 몰리고 나머지는 사라졌다(실기기 2026-09-23, SPEC-0014부터 있던 결함).
double sdkScreenScale(TargetPlatform platform, double devicePixelRatio) =>
    platform == TargetPlatform.android ? devicePixelRatio : 1.0;
