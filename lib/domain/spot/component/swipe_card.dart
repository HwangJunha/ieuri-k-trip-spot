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

    // **사진이 남는 자리를 전부 가져간다.**
    //
    // 한동안 사진 높이를 이미지 비율에 맡겼는데, 가로로 넓은 사진이 걸리면 사진이
    // 납작해지고 화면 아래 절반이 빈 여백으로 남았다 — 장소를 구경하는 화면에서
    // 정작 장소가 안 보였다(사용자 지적 2026-08-18).
    //
    // 순서를 뒤집는다. **정보가 자기 내용만큼만 차지하고 사진이 나머지 전부를
    // 가져간다.** 빈 공간이 생길 자리가 없어진다.
    if (metrics == null) {
      // 배치 수치를 모르는 자리(다음 카드 대기 등)에서는 꽉 채운다.
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
          // 사진이 남는 세로를 다 쓴다. 그 안을 채우는 방식만 저작권이 가른다 —
          // TYPE1은 잘라서 채우고, TYPE3·미지정은 잘리지 않게 넣는다(R13).
          Expanded(child: _CardImage(display: display, metrics: metrics!)),
          // 정보는 **내용만큼만** 차지한다.
          Padding(
            padding: EdgeInsets.fromLTRB(
              20,
              14,
              20,
              metrics!.overlayBottomInset,
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
  const _CardImage({required this.display, this.metrics});

  final SwipeCardDisplay display;

  /// 배치 수치. 있으면 **카테고리 바에 가리는 만큼 사진을 아래로 민다.**
  final SwipeCardMetrics? metrics;

  bool get _isUrl => display.imageRef.startsWith('http');

  @override
  Widget build(BuildContext context) {
    if (!_isUrl) return _inset(ImagePlaceholder(imageRef: display.imageRef));

    final bool crops = display.fit == SwipeCardFit.cover;

    final Widget image = Image.network(
      display.imageRef,
      // 크롭이 허용되면 영역을 채운다. 아니면 `contain`이라 **어느 쪽으로도 잘리지
      // 않는다** — 가로 사진은 폭이 꽉 차고 세로 포스터는 높이가 꽉 찬다.
      fit: crops ? BoxFit.cover : BoxFit.contain,
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

    if (!display.fit.needsBlurBackdrop) return _inset(image);

    // 크롭이 금지된 이미지는 원본 비율을 지키느라 여백이 생긴다. **그 여백을 같은
    // 사진의 블러본으로 채운다**(SPEC-0002 §4.7이 정한 방식).
    //
    // 배경색으로 비워도 봤지만, 사진 비율과 화면 비율이 다르면 그 여백이 화면 절반에
    // 이른다 — 가로로 넓은 사진(16:9)에서 위아래가 통째로 빈 띠가 됐다(사용자 지적
    // 2026-08-18). 장소를 구경하는 화면에서 장소가 안 보이면 안 된다.
    //
    // **원본을 변형하는 것이 아니다** — 원본은 위에 잘리지 않은 채로 그대로 얹혀
    // 있고, 아래 깔린 블러본은 배경 처리다. TYPE3 변경금지를 지키면서 화면도 채운다.
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        _BlurBackdrop(imageRef: display.imageRef),
        _inset(image),
      ],
    );
  }

  /// 카테고리 바가 덮는 만큼 사진을 아래로 민다.
  ///
  /// 칩이 사진 **위에 겹쳐** 있으므로(R14) 사진 맨 위는 늘 가려진다 — 그대로 두면
  /// 사진의 주요 부분이 칩 뒤로 숨는다(사용자 지적 2026-08-18: "사진은 카테고리에
  /// 다 짤려서 안 보인다").
  ///
  /// 겹침 자체는 R14가 정한 것이라 되돌리지 않는다. 대신 사진을 그만큼 내려 **가려도
  /// 되는 자리**를 위에 만든다 — 그 자리는 배경색이라 칩이 얹혀도 잃는 것이 없다.
  Widget _inset(Widget child) {
    final double top = metrics?.topScrimHeight ?? 0;
    if (top <= 0) return child;
    return Padding(padding: EdgeInsets.only(top: top), child: child);
  }
}

/// `contain`으로 그릴 때 남는 여백을 채우는 블러 배경.
///
/// 원본을 확대·블러해 뒤에 깔고 그 위에 원본을 온전히 얹는다 — **원본은 변형되지
/// 않는다**(TYPE3 변경금지를 지키는 방식, SPEC-0002 §4.7).
///
/// 강하게 어둡게 덮지 않는다. 여백이 화면의 상당 부분을 차지하므로 과하게 누르면
/// 그 자체가 시커먼 띠로 읽힌다 — 원본과 갈릴 만큼만 눌러 준다.
class _BlurBackdrop extends StatelessWidget {
  const _BlurBackdrop({required this.imageRef});

  final String imageRef;

  @override
  Widget build(BuildContext context) {
    return ImageFiltered(
      imageFilter: ui.ImageFilter.blur(sigmaX: 20, sigmaY: 20),
      child: ColorFiltered(
        colorFilter: const ColorFilter.mode(Colors.black26, BlendMode.darken),
        child: Image.network(
          imageRef,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
          // 배경이 실패해도 카드는 성립한다 — 빈 색으로 떨어뜨린다.
          errorBuilder:
              (BuildContext context, Object error, StackTrace? stack) =>
                  ColoredBox(color: Theme.of(context).colorScheme.surface),
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
        // **출처는 정보 영역 맨 위에 둔다.** 사진 위에 얹었더니 `contain` 여백
        // (블러) 위에 떠서 어색했다 — 사진이 어디서 끝나는지에 따라 배지가 사진
        // 위였다 여백 위였다 한다. 여기 두면 배경이 늘 일정하다.
        if (display.showsAttribution) ...<Widget>[
          CopyrightBadge(attributionText: display.attributionText!),
          const SizedBox(height: 10),
        ],
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
