import 'package:flutter/material.dart';

import '../model/post_author.dart';
import '../network/media_cdn.dart';

/// 작성자 아바타. 이미지가 없거나 404여도 자리 크기가 같다.
///
/// 대화 목록 타일과 메시지 말풍선이 **같은 위젯을 쓴다** — 같은 사람이 두 화면에서
/// 다른 모양으로 보이면 안 되고, 프로필 URL 조합 규칙([MediaCdn.profileImage])도 한
/// 곳에만 있어야 한다. 크기만 [radius]로 다르게 준다.
class AuthorAvatar extends StatelessWidget {
  const AuthorAvatar({super.key, required this.author, this.radius = 24});

  final PostAuthor author;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final String? url = MediaCdn.profileImage(author.profileImageUrl);
    return CircleAvatar(
      radius: radius,
      backgroundColor: theme.colorScheme.surfaceContainerHighest,
      foregroundImage: (url == null || url.isEmpty) ? null : NetworkImage(url),
      child: Text(
        author.nickname.isEmpty ? '?' : author.nickname.characters.first,
        style: (radius >= 20
                ? theme.textTheme.titleMedium
                : theme.textTheme.labelMedium)
            ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
      ),
    );
  }
}
