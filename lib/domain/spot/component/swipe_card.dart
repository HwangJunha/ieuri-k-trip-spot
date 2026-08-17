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
        // **정보를 사진 바로 아래 붙인다.** 남는 자리는 아래에 몰아 둔다 — 가운데로
        // 흩으면 사진과 글자 사이가 크게 비어 둘이 따로 노는 것으로 보인다.
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          // **사진이 밀려나도 좋다.** 화면이 작아 정보가 들어갈 자리가 모자라면
          // 사진 쪽을 줄인다 — 고정 높이로 두면 작은 기기에서 정보 영역이 넘쳐
          // 레이아웃이 터진다(테스트 화면 600×800에서 54px 넘침).
          //
          // `fit: FlexFit.loose`(기본)이라 **남는 자리를 가져가지 않는다** — 가져가게
          // 두면 사진이 제 비율보다 커지는 대신 정보가 아래로 밀려 사이가 빈다.
          // 그러면서도 자리가 **모자라면 줄어든다**(`Flexible`이라서) — 작은 화면에서
          // 넘치지 않으려면 이 축소가 필요하다(600×800에서 148px 넘쳤다).
          Flexible(
            child: _PhotoArea(
              display: display,
              maxHeight: photoHeight,
              // 하한을 두지 않는다. 하한에 걸리면 사진 영역이 실제 사진보다 커지고
              // 그 안에서 `contain`이 가운데로 놓여 **아래에 빈 띠가 남는다**
              // (실기기 확인 2026-08-18). 비율대로만 두면 사진이 끝나는 자리에서
              // 곧바로 정보가 시작된다.
              minHeight: 0,
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

/// 사진 영역. **높이를 사진 비율에 맞춰 정한다.**
///
/// 고정 높이로 두면 가로 사진(4:3)이 세로로 긴 영역에 들어가 아래쪽에 블러 여백이
/// 크게 남는다 — 화면 4분의 1이 흐릿한 띠가 됐다(실기기 확인 2026-08-18). 사진
/// 비율대로 높이를 잡으면 그 여백 자체가 생기지 않는다.
///
/// [maxHeight]는 상한일 뿐이다. 세로로 긴 포스터는 여기 걸려 그 안에서 `contain`으로
/// 들어가고(그때는 좌우에 여백이 남는다), 가로 사진은 상한에 닿지 않아 딱 맞게 그려진다.
class _PhotoArea extends StatelessWidget {
  const _PhotoArea({
    required this.display,
    required this.maxHeight,
    required this.minHeight,
  });

  final SwipeCardDisplay display;
  final double maxHeight;

  /// 사진이 아무리 납작해도 이만큼은 차지한다.
  ///
  /// 비율대로만 두면 가로로 넓은 사진이 낮게 깔려 **아래가 크게 빈다**(실기기
  /// 확인 2026-08-18). 하한을 두면 그런 사진은 좌우가 아니라 위아래로만 살짝
  /// 여백을 남기고 화면이 찬다.
  final double minHeight;

  @override
  Widget build(BuildContext context) {
    // 크롭이 허용되면 예전처럼 영역을 꽉 채운다 — 여백이 안 생기므로 비율을 잴
    // 이유가 없다.
    if (!display.fit.needsBlurBackdrop) {
      // 부모가 내준 자리가 더 좁으면 그쪽을 따른다 — 작은 화면에서 넘치지 않는다.
      return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) => SizedBox(
          height: constraints.maxHeight.isFinite
              ? (constraints.maxHeight < maxHeight
                    ? constraints.maxHeight
                    : maxHeight)
              : maxHeight,
          child: _CardImage(display: display),
        ),
      );
    }

    return _AspectPhoto(
      display: display,
      maxHeight: maxHeight,
      minHeight: minHeight,
    );
  }
}

/// 사진의 실제 비율을 알아내 그만큼만 높이를 차지한다.
///
/// 비율은 이미지가 실제로 도착해야 알 수 있으므로 [Image.resolve]로 받아 온다.
/// 아직 모르는 동안에는 상한 높이를 그대로 쓴다 — 도착하면 제 비율로 줄어든다.
class _AspectPhoto extends StatefulWidget {
  const _AspectPhoto({
    required this.display,
    required this.maxHeight,
    required this.minHeight,
  });

  final SwipeCardDisplay display;
  final double maxHeight;
  final double minHeight;

  @override
  State<_AspectPhoto> createState() => _AspectPhotoState();
}

class _AspectPhotoState extends State<_AspectPhoto> {
  /// 사진의 가로/세로 비. 아직 모르면 null.
  double? _ratio;

  ImageStream? _stream;
  ImageStreamListener? _listener;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _resolve();
  }

  @override
  void didUpdateWidget(_AspectPhoto old) {
    super.didUpdateWidget(old);
    if (old.display.imageRef != widget.display.imageRef) {
      _ratio = null;
      _resolve();
    }
  }

  /// 이미지 비율을 받아 온다. URL이 아니면(목 참조) 잴 것이 없다.
  void _resolve() {
    final String ref = widget.display.imageRef;
    if (!ref.startsWith('http')) return;

    _dropListener();

    final ImageStream stream = NetworkImage(
      ref,
    ).resolve(createLocalImageConfiguration(context));
    final ImageStreamListener listener = ImageStreamListener((
      ImageInfo info,
      bool _,
    ) {
      final double ratio = info.image.width / info.image.height;
      info.image.dispose();
      if (!mounted) return;
      setState(() => _ratio = ratio);
      // 사진 하나를 못 재도 카드는 그려져야 한다 — 상한 높이로 떨어진다.
    }, onError: (Object error, StackTrace? stack) {});

    _stream = stream..addListener(listener);
    _listener = listener;
  }

  void _dropListener() {
    if (_stream != null && _listener != null) {
      _stream!.removeListener(_listener!);
    }
    _stream = null;
    _listener = null;
  }

  @override
  void dispose() {
    _dropListener();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double? ratio = _ratio;

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        // 상한은 둘 중 작은 쪽이다 — 설계가 정한 [maxHeight]와, 부모가 실제로 내준
        // 자리. 작은 화면에서는 후자가 더 작고, 그때 사진이 줄어야 정보가 넘치지
        // 않는다.
        final double cap = constraints.maxHeight.isFinite
            ? (constraints.maxHeight < widget.maxHeight
                  ? constraints.maxHeight
                  : widget.maxHeight)
            : widget.maxHeight;

        // 비율을 아직 모르면 상한을 쓴다. 알면 폭에 맞춘 높이를 쓰되 상한을 넘지
        // 않는다 — 세로로 긴 포스터가 화면을 다 먹으면 정보가 밀린다.
        final double height = ratio == null
            ? cap
            : (constraints.maxWidth / ratio).clamp(
                widget.minHeight.clamp(0.0, cap),
                cap,
              );

        return SizedBox(
          height: height,
          child: _CardImage(display: widget.display),
        );
      },
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

    if (!display.fit.needsBlurBackdrop) return image;

    // 크롭이 금지된 이미지는 원본 비율을 지키느라 여백이 생긴다. **그 여백은 카드
    // 배경색으로 둔다.**
    //
    // 처음에는 같은 사진의 블러본을 깔았는데(SPEC-0002 §4.7이 예로 든 방식), 사진
    // 높이를 비율에 맞춘 뒤로는 여백이 얇은 띠만 남아 **그 띠만 흐릿하게 도드라졌다**
    // (실기기 확인 2026-08-18). 배경색과 같게 두면 사진이 끝나는 자리가 아래 정보
    // 영역으로 그대로 이어진다.
    //
    // 어느 쪽이든 **원본을 변형하지 않는다**는 점은 같다 — 원본은 그대로 얹혀 있고
    // 아래 깔린 것은 배경 처리다.
    return ColoredBox(
      color: Theme.of(context).colorScheme.surface,
      child: image,
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
