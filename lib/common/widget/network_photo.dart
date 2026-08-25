import 'package:flutter/material.dart';

/// 네트워크 사진을 디코딩할 **물리 픽셀** 폭.
///
/// [NetworkPhoto]와 [precacheImage] 호출부가 **반드시 같은 값을 써야 한다** —
/// 이미지 캐시는 (URL, 디코딩 크기)로 키를 잡으므로, 미리 받을 때와 그릴 때 폭이
/// 다르면 캐시가 갈려 두 벌이 메모리에 남고 프리캐시는 헛수고가 된다. 그래서 계산을
/// 위젯 안이 아니라 여기 둔다.
///
/// [decodeWidth]는 논리 폭이며, 주지 않으면 화면 폭을 쓴다. **배치용 `width`는
/// 쓰지 않는다** — `double.infinity`가 흔히 들어오는 값이라 디코딩 힌트가 될 수 없다.
int decodeWidthFor(BuildContext context, {double? decodeWidth}) {
  final double logical = decodeWidth ?? MediaQuery.sizeOf(context).width;
  // 디코딩은 물리 픽셀 기준이라 DPR을 곱한다. 논리 폭 그대로 주면 고DPI 기기에서
  // 흐릿해진다.
  final double physical = logical * MediaQuery.devicePixelRatioOf(context);
  // 유한하지 않은 값(`double.infinity`)이 흘러들면 `round()`가 터진다.
  if (!physical.isFinite) return 4096;
  return physical.round().clamp(1, 4096);
}

/// 네트워크 사진을 **화면에 그릴 크기로만 디코딩해서** 그린다.
///
/// ## 왜 `Image.network`를 직접 부르지 않는가
///
/// `width`/`height`는 **배치 제약이지 디코딩 제약이 아니다.** 그 둘만 주면 Flutter는
/// 서버가 준 원본 해상도 그대로 디코딩해 래스터 캐시에 올린다 — 관광 API 사진은 흔히
/// 2000~4000px라, 3000×2000 한 장이 RGBA로 **24MB**다. 화면에는 1080px로 그리면서
/// 메모리에는 원본을 얹는 셈이다.
///
/// Flutter 기본 이미지 캐시는 100MB라 그 크기면 **네 장이면 찬다.** 다섯 번째가 들어올
/// 때마다 앞의 것이 밀려나고, 되돌아오면 다시 디코딩한다. 목록을 위아래로 훑을 때
/// 끊기는 체감이 여기서 나온다.
///
/// `cacheWidth`를 주면 디코딩 단계에서 줄여서 올린다. 1080px로 줄이면 같은 사진이
/// 24MB → 3MB 남짓이 되어 캐시에 30장 넘게 남는다.
///
/// ## 왜 위젯으로 묶는가
///
/// 호출부마다 `cacheWidth`를 손으로 적으면 **반드시 빠뜨린다** — 실제로 이 저장소는
/// `Image.network` 15곳 중 단 한 곳도 지정하지 않은 상태였다. 계산에 필요한
/// `devicePixelRatio`도 매번 다시 읽어야 한다. 한 곳에 두면 규칙이 하나로 유지된다.
class NetworkPhoto extends StatelessWidget {
  const NetworkPhoto({
    super.key,
    required this.url,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.loadingBuilder,
    this.errorBuilder,
    this.decodeWidth,
    this.filterQuality = FilterQuality.medium,
  });

  final String url;
  final BoxFit fit;

  /// 배치 크기. 디코딩 크기와 별개다(위 설명 참고).
  final double? width;
  final double? height;

  final Widget Function(BuildContext, Widget, ImageChunkEvent?)? loadingBuilder;
  final Widget Function(BuildContext, Object, StackTrace?)? errorBuilder;

  /// 디코딩할 논리 폭(px 아님). 주지 않으면 화면 폭을 쓴다.
  ///
  /// 블러 배경처럼 **원본 화질이 필요 없는 자리**는 아주 작은 값을 준다 — 어차피
  /// 뭉개지므로 40px로 디코딩해도 눈에 띄지 않고 비용은 수백 분의 일이 된다.
  final double? decodeWidth;

  /// 확대·축소 시 보간 품질.
  ///
  /// [decodeWidth]로 작게 디코딩한 그림을 크게 늘리는 자리(블러 배경 등)에서는
  /// `low`가 맞다 — 바이리니어라 사실상 공짜이고, 부드럽게 뭉개지는 것이 목적이다.
  final FilterQuality filterQuality;

  @override
  Widget build(BuildContext context) {
    return Image.network(
      url,
      fit: fit,
      width: width,
      height: height,
      cacheWidth: decodeWidthFor(context, decodeWidth: decodeWidth),
      filterQuality: filterQuality,
      // 디코딩된 프레임이 준비되기 전 한 프레임 깜빡이는 것을 막는다. 같은 위젯이
      // 다른 URL로 바뀔 때 이전 사진을 유지해 흰 칸이 끼지 않게 한다.
      gaplessPlayback: true,
      loadingBuilder: loadingBuilder,
      errorBuilder: errorBuilder,
    );
  }
}
