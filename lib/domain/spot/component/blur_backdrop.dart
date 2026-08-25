import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../../../common/widget/network_photo.dart';

/// `contain`으로 그릴 때 남는 여백을 채우는 블러 배경(SPEC-0002 §4.7).
///
/// 원본을 확대·블러해 뒤에 깔고 그 위에 원본을 온전히 얹는다 — **원본은 변형되지
/// 않는다**(TYPE3 변경금지를 지키는 방식). 배경색으로 비우면 가로로 넓은 사진에서
/// 위아래가 통째로 빈 띠가 된다(사용자 지적 2026-08-18).
///
/// **스와이프 카드와 상세 갤러리가 같은 것을 쓴다.** 두 곳에 복제돼 있었는데, 한쪽만
/// 성능을 고치면 다른 쪽이 그대로 남는다 — 실제로 그럴 뻔했다.
///
/// ## 왜 아주 작게 디코딩하는가
///
/// sigma 20으로 뭉갤 그림이라 40px로 줄여도 결과가 눈에 띄게 다르지 않은데, 비용은
/// 수백 분의 1이 된다. 예전에는 이 배경 한 장이 카드마다 3000×2000 디코딩이었다.
///
/// **작게 디코딩하면 블러 반경도 함께 줄여야 한다** — sigma는 픽셀 단위라 40px 그림에
/// sigma 20을 걸면 통째로 뭉개져 단색이 된다. 축소 비율만큼 낮춰 확대 후의 겉보기
/// 흐림이 예전과 같게 만든다.
class BlurBackdrop extends StatelessWidget {
  const BlurBackdrop({super.key, required this.imageRef});

  final String imageRef;

  /// 블러 배경을 디코딩할 논리 폭.
  static const double _decodeWidth = 40;

  /// 축소 전 기준 흐림 정도. 화면 폭 기준으로 정해져 있던 기존 값이다.
  static const double _referenceSigma = 20;

  @override
  Widget build(BuildContext context) {
    final double scale = _decodeWidth / MediaQuery.sizeOf(context).width;
    final double sigma = (_referenceSigma * scale).clamp(1.0, _referenceSigma);

    // **`RepaintBoundary`가 핵심이다.** 스와이프 카드에서 이 위젯은 드래그하는
    // `Transform` 안에 있어, 경계가 없으면 매 프레임 전체화면 블러가 다시
    // 래스터화된다 — 스와이프가 끊기는 가장 큰 원인이었다. 경계를 두면 블러 결과가
    // 레이어로 굳고 이후 프레임은 그 레이어를 옮기기만 한다.
    return RepaintBoundary(
      child: ImageFiltered(
        imageFilter: ui.ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
        child: ColorFiltered(
          colorFilter: const ColorFilter.mode(Colors.black26, BlendMode.darken),
          child: NetworkPhoto(
            url: imageRef,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            decodeWidth: _decodeWidth,
            // 배경이 실패해도 카드는 성립한다 — 빈 색으로 떨어뜨린다.
            errorBuilder:
                (BuildContext context, Object error, StackTrace? stack) =>
                    ColoredBox(color: Theme.of(context).colorScheme.surface),
          ),
        ),
      ),
    );
  }
}
