import 'package:flutter/material.dart';

/// A deterministic color-block stand-in for a spot/event image. Mock data has no
/// network images (spec §4 — offline/test stability), so this derives a stable
/// tinted block from [imageRef] with an image icon overlay.
///
/// Lives in `common/widget/` because more than one domain (spot, event) renders
/// these placeholders (CLAUDE.md §4).
class ImagePlaceholder extends StatelessWidget {
  const ImagePlaceholder({super.key, required this.imageRef});

  final String imageRef;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    // Blend the seed hue toward a neutral surface so it reads as a placeholder,
    // not a brand color. All values flow through the theme (no hardcoded hex).
    // abs(): String.hashCode can be negative, and `%` keeps the sign, which
    // would hand Color.lerp an out-of-range t.
    final double t = (imageRef.hashCode.abs() % 100) / 100;
    final Color base = Color.lerp(
      theme.colorScheme.surfaceContainerHighest,
      theme.colorScheme.surfaceContainerHigh,
      t,
    )!;

    return ColoredBox(
      color: base,
      child: Center(
        child: Icon(
          Icons.image_outlined,
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
