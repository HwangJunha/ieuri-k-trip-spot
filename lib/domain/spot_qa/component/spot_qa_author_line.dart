import 'package:flutter/material.dart';

import '../../../common/model/post_author.dart';
import '../../../common/network/media_cdn.dart';
import '../../../common/widget/post_labels.dart';
import '../../../l10n/gen/app_localizations.dart';

/// 아바타 + 닉네임 + 상대시각 한 줄. 질문 카드·답변 타일·답글 타일이 모두 같은
/// 머리글을 그리므로 한곳에 모은다(디자인 §1·§2 — 세 곳의 머리글 구성이 동일하다).
///
/// [now]를 인자로 받는 이유는 **한 화면의 모든 항목이 같은 기준으로 상대시각을
/// 계산해야** 하기 때문이다. 위젯마다 `DateTime.now()`를 부르면 목록 위아래가
/// 미세하게 다른 시각을 가리킨다.
///
/// [compact]는 답글용이다 — 아바타를 한 단계 줄여 답변과 시각적으로 구분한다.
class SpotQaAuthorLine extends StatelessWidget {
  const SpotQaAuthorLine({
    super.key,
    required this.author,
    required this.createdAt,
    required this.now,
    this.compact = false,
  });

  final PostAuthor author;
  final DateTime createdAt;
  final DateTime now;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);
    // 서버 값은 키일 수 있다 — 그대로 NetworkImage에 넘기면 페인트 중에 터진다.
    final String? avatar = MediaCdn.profileImage(author.profileImageUrl);

    return Row(
      children: <Widget>[
        CircleAvatar(
          radius: compact ? 11 : 14,
          backgroundColor: theme.colorScheme.surfaceContainerHighest,
          foregroundImage: avatar == null ? null : NetworkImage(avatar),
          child: Text(
            author.nickname.isEmpty ? '?' : author.nickname.characters.first,
            style: theme.textTheme.labelSmall,
          ),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            author.nickname,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.labelLarge,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          relativePostTime(l10n, createdAt, now),
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
