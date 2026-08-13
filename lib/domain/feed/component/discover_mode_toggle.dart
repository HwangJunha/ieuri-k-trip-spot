import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';

import '../../../l10n/gen/app_localizations.dart';
import '../model/discover_segment.dart';

/// 둘러보기 탭의 추천↔피드 세그먼트 토글(R5).
///
/// **헤더 안에 산다 — 제스처 표면 위 오버레이가 아니다**(설계 §1). 두 화면 모두
/// 화면 전체를 제스처 표면으로 쓰기 때문에(추천은 카드 드래그, 피드는 세로 스크롤)
/// 토글을 그 위에 겹치면 토글 탭과 드래그 시작이 같은 영역에서 경합한다.
///
/// **Stitch 디자인(`fd6c6669…`)을 그대로 따른다** — 내용에 맞춘 **작은 알약**이고,
/// 선택된 쪽만 `primary`로 채운다. 전체 폭으로 펴면 헤더가 화면의 삼분의 일을
/// 먹고 사진이 밀려난다. 반투명 배경 + 블러라 사진 위에 떠 있어도 글자가 읽힌다.
///
/// **상태를 소유하지 않는다.** 선택 값은 화면 레벨 provider가 쥐고 이 위젯은 그리기만
/// 한다 — 토글이 상태를 가지면 두 화면의 격리(AC5-3)가 이 위젯을 거치게 된다.
class DiscoverModeToggle extends StatelessWidget {
  const DiscoverModeToggle({
    super.key,
    required this.selected,
    required this.onSelected,
    this.onPhoto = true,
  });

  final DiscoverSegment selected;
  final ValueChanged<DiscoverSegment> onSelected;

  /// 사진 위에 떠 있는지. 거짓이면 밝은 표면 위이므로 흰 글자·흰 판을 쓰지 않는다.
  final bool onPhoto;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            // 사진 위에 떠 있으므로 불투명 표면을 깔지 않는다 — 살짝 흐린 판만 둔다.
            color: onPhoto
                ? Colors.white.withValues(alpha: 0.22)
                : Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _Segment(
                label: l10n.feedSegmentForYou,
                selected: selected == DiscoverSegment.recommendation,
                onPhoto: onPhoto,
                onTap: () => onSelected(DiscoverSegment.recommendation),
              ),
              _Segment(
                label: l10n.feedSegmentFeed,
                selected: selected == DiscoverSegment.feed,
                onPhoto: onPhoto,
                onTap: () => onSelected(DiscoverSegment.feed),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Segment extends StatelessWidget {
  const _Segment({
    required this.label,
    required this.selected,
    required this.onPhoto,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final bool onPhoto;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Semantics(
      selected: selected,
      button: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 7),
          decoration: BoxDecoration(
            color: selected ? theme.colorScheme.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            label,
            style: theme.textTheme.labelLarge?.copyWith(
              // 선택된 쪽은 코랄 위의 글자. 나머지는 배경에 따라 갈린다 — 사진
              // 위면 흰 글자, 밝은 표면 위면 기본 전경색이다.
              color: selected
                  ? theme.colorScheme.onPrimary
                  : (onPhoto ? Colors.white : theme.colorScheme.onSurfaceVariant),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
