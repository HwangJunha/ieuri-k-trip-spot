import 'package:flutter/material.dart';

import '../../../common/widget/image_placeholder.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../model/distance.dart';
import '../model/tourist_spot.dart';
import 'copyright_badge.dart';
import 'spot_display.dart';

/// Discover 스와이프 카드 한 장(spec §3). 이미지 1장 + 하단 오버레이(출처·제목·주소·거리).
///
/// 이미지는 저작권 유형과 무관하게 [BoxFit.cover]로 카드를 꽉 채운다(여백·블러 없이
/// 일관된 카드 모양). 저작권 표기는 하단 [CopyrightBadge]로 최소 출처를 밝힌다(spec §6).
class SwipeCard extends StatelessWidget {
  const SwipeCard({super.key, required this.spot});

  final TouristSpot spot;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);

    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          _CardImage(imageRef: _imageRef),
          // 하단 그라데이션: 밝은 이미지 위에서도 흰 오버레이 텍스트가 읽히도록.
          const _BottomScrim(),
          // 출처 표기는 제목·주소와 함께 하단 오버레이에 둔다(제목 위).
          Positioned(
            left: 16,
            right: 16,
            bottom: 20,
            child: _Overlay(spot: spot, l10n: l10n, theme: theme),
          ),
        ],
      ),
    );
  }

  String get _imageRef => spot.thumbnailImageUrl ?? spot.imageRef;
}

/// 이미지 렌더. 저작권 유형과 무관하게 [BoxFit.cover]로 카드를 꽉 채운다. 네트워크
/// URL이면 [Image.network](로딩 중·실패 시 색블록 플레이스홀더로 폴백), URL이 아니면
/// (Home 목 참조 등) 색블록 플레이스홀더를 렌더한다.
class _CardImage extends StatelessWidget {
  const _CardImage({required this.imageRef});

  /// 서버가 준 썸네일 URL(http). 값이 없거나 URL이 아니면 색블록 플레이스홀더로 폴백.
  final String imageRef;

  bool get _isUrl => imageRef.startsWith('http');

  @override
  Widget build(BuildContext context) {
    if (!_isUrl) return ImagePlaceholder(imageRef: imageRef);
    return Image.network(
      imageRef,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      // 로딩 중에는 색블록을, 완료되면 이미지를 보여준다(빈 흰 화면 방지).
      loadingBuilder:
          (BuildContext context, Widget child, ImageChunkEvent? p) =>
              p == null ? child : ImagePlaceholder(imageRef: imageRef),
      // 깨진 URL·오프라인이어도 크래시 없이 플레이스홀더로 폴백.
      errorBuilder: (BuildContext context, Object error, StackTrace? stack) =>
          ImagePlaceholder(imageRef: imageRef),
    );
  }
}

class _BottomScrim extends StatelessWidget {
  const _BottomScrim();

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.center,
          end: Alignment.bottomCenter,
          colors: <Color>[Colors.transparent, Colors.black54],
        ),
      ),
    );
  }
}

class _Overlay extends StatelessWidget {
  const _Overlay({required this.spot, required this.l10n, required this.theme});

  final TouristSpot spot;
  final AppLocalizations l10n;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    final Distance? distance = spot.distance;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        if (spot.attributionText != null) ...<Widget>[
          CopyrightBadge(attributionText: spot.attributionText!),
          const SizedBox(height: 8),
        ],
        Text(
          spot.name,
          style: theme.textTheme.headlineSmall?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        if (spot.address != null) ...<Widget>[
          const SizedBox(height: 4),
          Text(
            spot.address!,
            style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white70),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
        if (distance != null) ...<Widget>[
          const SizedBox(height: 4),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Icon(Icons.place_outlined, size: 16, color: Colors.white70),
              const SizedBox(width: 4),
              Text(
                distanceLabel(l10n, distance),
                style: theme.textTheme.labelLarge?.copyWith(
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
