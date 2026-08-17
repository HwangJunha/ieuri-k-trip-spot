import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../../../common/widget/image_placeholder.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../model/distance.dart';
import '../model/swipe_card_display.dart';
import '../model/swipe_card_metrics.dart';
import '../model/tourist_spot.dart';
import 'copyright_badge.dart';
import 'spot_display.dart';

/// Discover 스와이프 카드 한 장(SPEC-0025 R1·R2·R13). 사진 위에 정보가 겹친다.
///
/// **전체화면이라 둥근 모서리가 없다**(R1). 카드가 화면 가장자리에 닿으므로 모서리를
/// 깎으면 그 자리에 배경이 비쳐 오히려 어색하다.
///
/// **이미지 맞춤은 저작권 유형이 정한다**(R13, SPEC-0002 §4.7) — TYPE1만 크롭하고
/// 나머지는 원본을 유지한다. 그 판단은 [SwipeCardDisplay]에 있다.
class SwipeCard extends StatelessWidget {
  const SwipeCard({super.key, required this.spot, this.metrics});

  final TouristSpot spot;

  /// 하단 오버레이를 어디에 놓을지. 없으면 기기 인셋을 모르는 자리(다음 카드 대기
  /// 등)이므로 기본 여백을 쓴다.
  final SwipeCardMetrics? metrics;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);
    final SwipeCardDisplay display = SwipeCardDisplay.of(spot);

    // **사진을 화면 위쪽에만 둔다**(사용자 결정 2026-08-18).
    //
    // 전체화면으로 늘렸더니 원본(940×705)이 3.7배까지 확대돼 눈에 띄게 깨졌다.
    // 사진 영역을 줄이면 확대율이 절반 아래로 떨어져 선명해지고, 아래는 정보가
    // 자기 자리를 갖는다 — 사진 위에 글자를 얹지 않으니 스크림도 필요 없다.
    final double? photoHeight = metrics?.photoHeight;
    if (photoHeight == null) {
      // 배치 수치를 모르는 자리(다음 카드 대기 등)에서는 예전처럼 꽉 채운다.
      return Stack(
        fit: StackFit.expand,
        children: <Widget>[
          _CardImage(display: display),
          const _BottomScrim(),
        ],
      );
    }

    return ColoredBox(
      color: theme.colorScheme.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          // **사진이 밀려나도 좋다.** 화면이 작아 정보가 들어갈 자리가 모자라면
          // 사진 쪽을 줄인다 — 고정 높이로 두면 작은 기기에서 정보 영역이 넘쳐
          // 레이아웃이 터진다(테스트 화면 600×800에서 54px 넘침).
          Flexible(
            child: SizedBox(
              height: photoHeight,
              child: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  _CardImage(display: display),
                  // **출처는 사진 위에 둔다** — 밝히는 대상이 사진이므로 붙여 놓는
                  // 편이 뜻이 분명하고, 아래 정보 영역도 깔끔해진다. 배지 자체가
                  // 어두운 알약이라 사진 위에서 읽힌다.
                  if (display.showsAttribution)
                    Positioned(
                      left: 12,
                      right: 12,
                      bottom: 12,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: CopyrightBadge(
                          attributionText: display.attributionText!,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          // 정보는 **내용만큼만** 차지한다. `Expanded`로 남는 자리를 다 가져가면
          // 화면이 작을 때 사진이 밀리기는커녕 이쪽이 넘친다.
          Padding(
            padding: EdgeInsets.fromLTRB(
              20,
              16,
              20,
              metrics?.overlayBottomInset ?? 20,
            ),
            child: _Overlay(display: display, l10n: l10n, theme: theme),
          ),
        ],
      ),
    );
  }
}

/// 이미지 렌더. 맞춤 방식은 [SwipeCardDisplay.fit]이 정한다(R13).
///
/// 네트워크 URL이면 [Image.network](로딩 중·실패 시 색블록 플레이스홀더로 폴백),
/// URL이 아니면 (Home 목 참조 등) 색블록 플레이스홀더를 렌더한다.
class _CardImage extends StatelessWidget {
  const _CardImage({required this.display});

  final SwipeCardDisplay display;

  bool get _isUrl => display.imageRef.startsWith('http');

  @override
  Widget build(BuildContext context) {
    if (!_isUrl) return ImagePlaceholder(imageRef: display.imageRef);

    final Widget image = Image.network(
      display.imageRef,
      fit: display.fit == SwipeCardFit.cover ? BoxFit.cover : BoxFit.contain,
      width: double.infinity,
      height: double.infinity,
      // 로딩 중에는 색블록을, 완료되면 이미지를 보여준다(빈 흰 화면 방지).
      loadingBuilder:
          (BuildContext context, Widget child, ImageChunkEvent? p) =>
              p == null ? child : ImagePlaceholder(imageRef: display.imageRef),
      // 깨진 URL·오프라인이어도 크래시 없이 플레이스홀더로 폴백.
      errorBuilder: (BuildContext context, Object error, StackTrace? stack) =>
          ImagePlaceholder(imageRef: display.imageRef),
    );

    if (!display.fit.needsBlurBackdrop) return image;

    // 크롭이 금지된 이미지는 원본 비율을 지키느라 여백이 생긴다. 그 여백을 같은
    // 사진의 확대·블러본으로 메운다 — 검은 띠보다 자연스럽고, 전체화면에서는 그
    // 띠가 화면 절반을 차지할 수도 있다.
    //
    // **블러 배경은 원본을 변형한 것이 아니다** — 원본은 위에 그대로 얹혀 있고,
    // 아래 깔린 것은 배경 처리다(SPEC-0002 §4.7이 정한 방식).
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[_BlurBackdrop(imageRef: display.imageRef), image],
    );
  }
}

/// `contain`으로 그릴 때 남는 여백을 메우는 블러 배경.
///
/// 블러 강도를 과하게 주지 않는다 — 전체화면이라 블러 면적이 크고, 시그마가 크면
/// 그만큼 비싸다(설계 §2.3). 어둡게 덮어 원본과 확실히 갈리게 한다.
class _BlurBackdrop extends StatelessWidget {
  const _BlurBackdrop({required this.imageRef});

  final String imageRef;

  @override
  Widget build(BuildContext context) {
    return ImageFiltered(
      imageFilter: ui.ImageFilter.blur(sigmaX: 24, sigmaY: 24),
      child: ColorFiltered(
        colorFilter: const ColorFilter.mode(Colors.black38, BlendMode.darken),
        child: Image.network(
          imageRef,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
          // 배경이 실패해도 카드는 성립한다 — 빈 색으로 떨어뜨린다.
          errorBuilder:
              (BuildContext context, Object error, StackTrace? stack) =>
                  const ColoredBox(color: Colors.black87),
        ),
      ),
    );
  }
}

/// 하단 스크림. 전체화면이라 정보가 화면 밑변에 붙으므로, 예전보다 위에서부터
/// 어두워지기 시작한다 — 밝은 사진에서도 읽혀야 한다(R2).
class _BottomScrim extends StatelessWidget {
  const _BottomScrim();

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.center,
          end: Alignment.bottomCenter,
          colors: <Color>[Colors.transparent, Colors.black87],
          stops: <double>[0, 0.85],
        ),
      ),
    );
  }
}

class _Overlay extends StatelessWidget {
  const _Overlay({
    required this.display,
    required this.l10n,
    required this.theme,
  });

  final SwipeCardDisplay display;
  final AppLocalizations l10n;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    // 사진 위가 아니라 **카드 배경 위**에 놓이므로 테마 색을 쓴다. 흰색으로 두면
    // 밝은 배경에서 그대로 사라진다.
    final ColorScheme scheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        // 출처 표기는 사진 위에 있다(→[SwipeCard.build]) — 밝히는 대상 옆이 맞다.
        Text(
          display.name,
          style: theme.textTheme.headlineSmall?.copyWith(
            color: scheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        if (display.showsAddress) ...<Widget>[
          const SizedBox(height: 6),
          Text(
            display.address!,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
        if (display.showsDistance) ...<Widget>[
          const SizedBox(height: 8),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(Icons.place_outlined, size: 16, color: scheme.primary),
              const SizedBox(width: 4),
              Text(
                distanceLabel(l10n, Distance(display.distanceMeters!)),
                style: theme.textTheme.labelLarge?.copyWith(
                  color: scheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
