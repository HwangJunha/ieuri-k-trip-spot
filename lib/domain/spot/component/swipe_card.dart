import 'package:flutter/material.dart';

import '../../../common/widget/image_placeholder.dart';
import '../../../common/widget/network_photo.dart';
import 'blur_backdrop.dart';
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
  const SwipeCard({
    super.key,
    required this.spot,
    this.metrics,
    this.onPass,
    this.onLike,
    this.onRefreshLocation,
  });

  final TouristSpot spot;

  /// 하단 오버레이를 어디에 놓을지. 없으면 기기 인셋을 모르는 자리(다음 카드 대기
  /// 등)이므로 기본 여백을 쓴다.
  final SwipeCardMetrics? metrics;

  /// 액션 바 콜백. **둘 다 없으면 바를 그리지 않는다** — 뒤에 깔린 다음 카드는
  /// 만질 수 없으므로 버튼이 있을 이유가 없다.
  final VoidCallback? onPass;
  final VoidCallback? onLike;

  /// 거리 옆의 위치 새로고침. 거리가 "내 위치 기준"이라는 뜻이므로 그 옆이면
  /// 무엇을 다시 잡는지 설명 없이 읽힌다.
  final VoidCallback? onRefreshLocation;

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
            child: _Overlay(
              display: display,
              l10n: l10n,
              theme: theme,
              onPass: onPass,
              onLike: onLike,
              onRefreshLocation: onRefreshLocation,
            ),
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

    final Widget image = NetworkPhoto(
      url: display.imageRef,
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
        BlurBackdrop(imageRef: display.imageRef),
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
    this.onPass,
    this.onLike,
    this.onRefreshLocation,
  });

  final SwipeCardDisplay display;
  final AppLocalizations l10n;
  final ThemeData theme;
  final VoidCallback? onPass;
  final VoidCallback? onLike;
  final VoidCallback? onRefreshLocation;

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
        // **`headlineSmall`(24)에서 `titleLarge`(22)로 낮췄다.** 행사 이름은
        // "2023년 유니버설디자인 공감주간 <모두를 잇다, 있다>"처럼 길어서, 24로 두면
        // 두 줄을 꽉 채워 답답했다(사용자 지적 2026-08-18).
        //
        // 줄 간격도 함께 좁힌다 — 두 줄이 될 때 행간이 벌어지면 더 커 보인다.
        Text(
          display.name,
          style: theme.textTheme.titleLarge?.copyWith(
            color: scheme.onSurface,
            fontWeight: FontWeight.bold,
            height: 1.25,
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
              const Spacer(),
              // **거리 옆에 둔다.** 거리는 "내 위치 기준 849m"라는 뜻이므로, 그
              // 옆의 새로고침은 "이 기준을 다시 잡는다"로 설명 없이 읽힌다.
              // 카테고리 바나 앱바에 두면 무엇에 대한 조작인지 알 수 없다.
              if (onRefreshLocation != null)
                IconButton(
                  onPressed: onRefreshLocation,
                  icon: const Icon(Icons.my_location, size: 20),
                  tooltip: l10n.homeRefreshLocation,
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 40,
                    minHeight: 40,
                  ),
                  color: scheme.onSurfaceVariant,
                ),
            ],
          ),
        ],
        // **액션 바는 카드 정보 영역 안에 둔다**(2026-08-27).
        //
        // 처음에는 좋아요를 제목 옆에 붙였는데, 뒤에 깔린 카드에는 버튼이 없어
        // 제목이 쓸 수 있는 폭이 달랐다 — 카드가 넘어가는 순간 글자가 작아지는
        // 것처럼 보였다. 그다음에는 카드 밖에 겹쳐 놨더니 하단 탭 바에 잘렸다.
        //
        // 여기라면 둘 다 없다. 제목과 다른 줄이라 폭을 다투지 않고, 카드 안이라
        // 탭 바와 겹칠 일이 없다. 전체화면(R1)도 그대로다 — 정보 영역은 원래
        // 자기 내용만큼 차지하므로 한 줄이 늘 뿐이다.
        if (onPass != null && onLike != null) ...<Widget>[
          const SizedBox(height: 18),
          _ActionBar(onPass: onPass!, onLike: onLike!, l10n: l10n),
        ],
      ],
    );
  }
}

/// 카드 안의 패스·좋아요 버튼 줄.
///
/// **패스도 버튼으로 둔다.** 스와이프가 전부 패스가 된 뒤로 좋아요는 버튼뿐인데
/// 패스는 여전히 미는 것뿐이었다 — 스와이프를 모르는 사용자에게 카드를 넘길 길이
/// 없다.
///
/// 두 버튼의 무게를 다르게 둔다(패스는 테두리, 좋아요는 채움). 같으면 어느 쪽이
/// 기본 동작인지 알 수 없다.
class _ActionBar extends StatelessWidget {
  const _ActionBar({
    required this.onPass,
    required this.onLike,
    required this.l10n,
  });

  static const double _buttonSize = 56;

  final VoidCallback onPass;
  final VoidCallback onLike;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        _ActionButton(
          onPressed: onPass,
          icon: Icons.close,
          label: l10n.spotDetailDislikeAction,
          background: scheme.surface,
          foreground: scheme.onSurfaceVariant,
          border: scheme.outlineVariant,
          size: _buttonSize,
        ),
        const SizedBox(width: 24),
        _ActionButton(
          onPressed: onLike,
          icon: Icons.favorite,
          label: l10n.spotDetailLikeAction,
          background: scheme.primary,
          foreground: scheme.onPrimary,
          size: _buttonSize,
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.onPressed,
    required this.icon,
    required this.label,
    required this.background,
    required this.foreground,
    required this.size,
    this.border,
  });

  final VoidCallback onPressed;
  final IconData icon;
  final String label;
  final Color background;
  final Color foreground;
  final double size;
  final Color? border;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      child: Material(
        color: background,
        shape: border == null
            ? const CircleBorder()
            : CircleBorder(side: BorderSide(color: border!)),
        child: InkWell(
          onTap: onPressed,
          customBorder: const CircleBorder(),
          child: SizedBox(
            width: size,
            height: size,
            child: Icon(icon, color: foreground, size: 26),
          ),
        ),
      ),
    );
  }
}

