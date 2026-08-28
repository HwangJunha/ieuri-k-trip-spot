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
    this.showsLike = false,
    this.onLike,
    this.showsRefresh = false,
    this.onRefreshLocation,
  });

  final TouristSpot spot;

  /// 하단 오버레이를 어디에 놓을지. 없으면 기기 인셋을 모르는 자리(다음 카드 대기
  /// 등)이므로 기본 여백을 쓴다.
  final SwipeCardMetrics? metrics;

  /// 좋아요 버튼을 그릴지. **뒤에 깔린 다음 카드에도 켠다**(사용자 지적
  /// 2026-08-27).
  ///
  /// 처음에는 [onLike]가 있을 때만 그렸다 — 뒤 카드는 만질 수 없으니 버튼도 없어야
  /// 한다고 봤다. 그런데 뒤 카드는 0.92배로 축소돼 있다가 앞으로 나오면서 1.0으로
  /// 커지는데(`SwipeDrag.nextCardScale2D`), 하필 그 순간에 버튼이 새로 나타났다.
  /// 커지는 사진과 튀어나오는 버튼이 겹쳐 **사진이 버튼 때문에 줄었다 커지는 것처럼**
  /// 보였다.
  ///
  /// 처음부터 그려 두면 카드가 넘어가도 버튼은 제자리에 있고, 스케일 연출만 남는다.
  final bool showsLike;

  /// 좋아요를 눌렀을 때. **없으면 버튼이 눌리지 않는다**([showsLike]와 별개다) —
  /// 뒤 카드는 보이기만 하고 아직 만질 수 없다.
  ///
  /// 패스 콜백은 없다. 어느 방향으로 밀어도 패스라 손짓 경로가 이미 있다.
  final VoidCallback? onLike;

  /// 거리 옆의 위치 새로고침을 그릴지. **[showsLike]와 같은 이유로 뒤 카드에도
  /// 켠다**(사용자 지적 2026-08-28) — 앞으로 나올 때 아이콘이 새로 나타나면
  /// 원래 없던 것이 생긴 것처럼 보인다.
  ///
  /// 여기서는 튀는 것 말고 하나가 더 걸린다. 이 아이콘은 거리 **줄 안에** 있고
  /// `IconButton`의 최소 높이(36)가 그 줄의 높이를 지배하므로, 없는 카드는 거리
  /// 줄까지 낮아진다 — 정보 영역 높이를 고정한 이유와 같은 문제다.
  final bool showsRefresh;

  /// 새로고침을 눌렀을 때. **없으면 아이콘이 눌리지 않는다**([showsRefresh]와
  /// 별개다) — 뒤 카드는 보이기만 하고 아직 만질 수 없다.
  ///
  /// 거리가 "내 위치 기준"이라는 뜻이므로 그 옆이면 무엇을 다시 잡는지 설명 없이
  /// 읽힌다.
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
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                _CardImage(display: display, metrics: metrics!),
                // **좋아요는 사진 우하단에 얹는다**(사용자 결정 2026-08-27).
                //
                // 정보 영역에 두었더니 그만큼 사진이 밀려 사진:정보가 6:4에
                // 가까워졌다 — 장소를 구경하는 화면에서 장소가 줄어드는, R1이
                // 고치려던 문제로 되돌아간 셈이었다. 사진 위라면 세로를 뺏지
                // 않는다.
                //
                // 카드 **밖에** 겹쳤던 그 앞의 시도와 다른 점: 여기는 사진 영역
                // 안이라 하단 탭 바에 잘리지 않는다.
                if (showsLike)
                  Positioned(
                    right: 16,
                    bottom: 16,
                    child: _LikeButton(onPressed: onLike, l10n: l10n),
                  ),
              ],
            ),
          ),
          // **정보 영역 높이를 카드마다 같게 고정한다**(사용자 결정 2026-08-28).
          //
          // 예전에는 내용만큼만 차지했는데, 그러면 제목이 한 줄이냐 두 줄이냐에
          // 따라 높이가 달라지고 — 사진이 그 나머지를 가져가므로(`Expanded`) —
          // **카드가 넘어갈 때마다 사진이 커졌다 작아졌다** 했다. 사진 우하단의
          // 좋아요 버튼도 함께 오르내려 "버튼 때문에 사진이 줄어든다"처럼 보였다.
          //
          // 짧은 카드는 아래에 빈 자리가 남는다. 그래도 사진과 버튼이 제자리에
          // 있는 편이 낫다는 판단이다.
          Padding(
            padding: EdgeInsets.fromLTRB(
              20,
              14,
              20,
              metrics!.overlayBottomInset,
            ),
            child: SizedBox(
              height: metrics!.overlayContentHeight,
              // 내용이 고정 높이보다 짧으면 **위에 붙인다** — 가운데 정렬하면
              // 제목이 카드마다 다른 높이에 뜬다.
              child: Align(
                alignment: Alignment.topLeft,
                child: _Overlay(
                  display: display,
                  l10n: l10n,
                  theme: theme,
                  showsRefresh: showsRefresh,
                  onRefreshLocation: onRefreshLocation,
                ),
              ),
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
    this.showsRefresh = false,
    this.onRefreshLocation,
  });

  final SwipeCardDisplay display;
  final AppLocalizations l10n;
  final ThemeData theme;
  final bool showsRefresh;
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
              // **거리에 바짝 붙인다.** 거리는 "내 위치 기준 396m"라는 뜻이므로,
              // 그 옆의 새로고침은 "이 기준을 다시 잡는다"로 설명 없이 읽힌다.
              //
              // 처음에는 `Spacer()`로 화면 오른쪽 끝까지 밀었는데, 그러면 거리와
              // 아이콘 사이가 멀어 서로 무관한 두 요소로 보였다(사용자 지적
              // 2026-08-27). 붙여 놔야 하나의 문장으로 읽힌다.
              if (showsRefresh)
                IconButton(
                  onPressed: onRefreshLocation,
                  icon: const Icon(Icons.my_location, size: 18),
                  tooltip: l10n.homeRefreshLocation,
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 36,
                    minHeight: 36,
                  ),
                  color: scheme.primary,
                  // **못 누를 때도 같은 색이다**(사용자 결정 2026-08-28).
                  //
                  // `IconButton`은 `onPressed`가 null이면 `color`를 버리고 회색
                  // 비활성 색을 쓴다. 뒤에 깔린 카드가 그런데, 그러면 카드가
                  // 앞으로 나오는 순간 **회색에서 빨간색으로 색이 바뀌어** 아이콘이
                  // 새로 켜지는 것처럼 보였다.
                  //
                  // "지금 못 누른다"는 사용자가 알 필요 없는 내부 사정이다 — 뒤
                  // 카드는 만질 수 없을 뿐이고, 앞으로 나오면 바로 눌린다. 회색은
                  // 그 사정을 잘못된 신호로 내보내는 셈이다.
                  disabledColor: scheme.primary,
                ),
            ],
          ),
        ],
      ],
    );
  }
}

/// 사진 우하단의 좋아요 버튼(2026-08-27).
///
/// **왜 사진 위인가.** 카드 정보 영역에 두면 그만큼 사진이 밀리고, 카드 밖에
/// 겹치면 하단 탭 바에 잘린다 — 둘 다 실제로 겪었다. 사진 오른쪽 아래는 두 문제가
/// 모두 없으면서 엄지가 닿는 자리다.
///
/// **좋아요만 있고 패스 버튼은 없다**(사용자 결정 2026-08-27). 스와이프는 어느
/// 방향으로 밀어도 패스이므로(`SwipeDrag.reaction`) 패스에는 이미 손짓 경로가
/// 있다. 반면 좋아요는 스와이프에서 떼어냈으므로 이 버튼이 유일한 경로다.
/// **버튼은 손짓으로 할 수 없는 것만 맡는다** — 둘을 나란히 두면 "두 버튼으로
/// 조작하는 화면"으로 읽혀 미는 동작 자체를 안 하게 된다.
class _LikeButton extends StatelessWidget {
  const _LikeButton({required this.onPressed, required this.l10n});

  /// null이면 **보이지만 눌리지 않는다** — 뒤에 깔린 다음 카드가 그렇다. 모양은
  /// 같아야 앞으로 나올 때 버튼이 튀어나오지 않는다.
  final VoidCallback? onPressed;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;

    return Tooltip(
      message: l10n.discoverLikeLabel,
      child: Material(
        color: scheme.primary,
        shape: const CircleBorder(),
        // 밝은 사진 위에서 묻히지 않도록 그림자를 준다.
        elevation: 3,
        child: InkWell(
          onTap: onPressed,
          customBorder: const CircleBorder(),
          // 지름 56 — Material 최소 터치 영역(48)보다 넉넉하다. 하나뿐인 버튼이라
          // 둘일 때(52)보다 조금 키워도 답답하지 않다.
          child: SizedBox(
            width: 56,
            height: 56,
            child: Icon(
              Icons.favorite_rounded,
              size: 28,
              color: scheme.onPrimary,
            ),
          ),
        ),
      ),
    );
  }
}

