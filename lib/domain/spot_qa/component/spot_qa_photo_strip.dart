import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../../../common/model/composer_photo.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../../community/component/post_photo.dart';
import '../provider/spot_qa_composer_providers.dart';

/// 작성 화면의 사진 첨부 줄(R9).
///
/// ```
/// [사진][사진][＋]        (가로 스크롤, 최대 5장)
/// ```
///
/// **두 종류가 한 줄에 섞인다.** 방금 고른 장은 바이트를 그대로 그리고
/// ([Image.memory]), 이미 올라간 장은 CDN에서 받아 그린다([PostPhoto]) — 제출이
/// 거부돼 다시 시도할 때 이미 올라간 장이 섞이기 때문이다. 사용자에게는 구분 없이
/// 같은 사진으로 보여야 한다.
///
/// **상한에 닿으면 ＋ 버튼이 사라진다.** 비활성으로 두면 눌러 보고 나서야 막힌 것을
/// 아는데, 이미 5장이 눈앞에 있으니 이유는 자명하다.
class SpotQaPhotoStrip extends StatelessWidget {
  const SpotQaPhotoStrip({
    super.key,
    required this.photos,
    required this.onAdd,
    required this.onRemove,
  });

  final List<ComposerPhoto> photos;

  /// 갤러리를 연다. 상한에 닿으면 호출되지 않는다.
  final VoidCallback onAdd;

  /// 한 장을 뺀다. 인자는 [ComposerPhoto.id]다.
  final ValueChanged<String> onRemove;

  static const double _size = 72;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final bool canAdd = photos.length < kSpotQaMaxPhotos;

    return SizedBox(
      height: _size,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: photos.length + (canAdd ? 1 : 0),
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (BuildContext context, int index) {
          if (index == photos.length) {
            return _AddButton(
              size: _size,
              label: l10n.communityComposePhotoAdd,
              onTap: onAdd,
            );
          }
          return _Thumb(
            photo: photos[index],
            size: _size,
            onRemove: () => onRemove(photos[index].id),
          );
        },
      ),
    );
  }
}

class _Thumb extends StatelessWidget {
  const _Thumb({
    required this.photo,
    required this.size,
    required this.onRemove,
  });

  final ComposerPhoto photo;
  final double size;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: switch (photo) {
              // 아직 올리지 않은 장 — 들고 있는 바이트를 그대로 그린다.
              LocalPhoto(:final Uint8List bytes) => Image.memory(
                bytes,
                fit: BoxFit.cover,
              ),
              // 이미 확정된 장 — 커뮤니티와 같은 CDN 경로로 받는다.
              RemotePhoto(:final String objectKey) => PostPhoto(
                photoKey: objectKey,
              ),
            },
          ),
          PositionedDirectional(
            top: -6,
            end: -6,
            child: IconButton(
              // 작은 썸네일 위라 기본 터치 영역을 줄인다.
              visualDensity: VisualDensity.compact,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
              icon: CircleAvatar(
                radius: 10,
                backgroundColor: theme.colorScheme.surface,
                child: Icon(
                  Icons.close,
                  size: 14,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              onPressed: onRemove,
            ),
          ),
        ],
      ),
    );
  }
}

class _AddButton extends StatelessWidget {
  const _AddButton({
    required this.size,
    required this.label,
    required this.onTap,
  });

  final double size;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: theme.colorScheme.outlineVariant),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.add_photo_alternate_outlined,
              size: 20,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
