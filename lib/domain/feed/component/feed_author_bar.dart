import 'package:flutter/material.dart';

import '../../../common/model/post_author.dart';
import '../../../common/network/media_cdn.dart';
import '../../../common/widget/post_labels.dart';
import '../../../l10n/gen/app_localizations.dart';

/// 사진 위에 얹히는 글자에 붙이는 그림자.
///
/// **스크림만으로는 부족하다.** 그라데이션은 사진 전체를 고르게 어둡게 할 뿐이라,
/// 글자 바로 뒤에 흰 구름·모래처럼 밝은 덩어리가 오면 흰 글자가 그대로 묻힌다.
/// 글자에 붙어 다니는 그림자는 그 국소적인 대비를 메운다 — Stitch 디자인
/// (`fd6c6669…`)이 스크림과 `drop-shadow`를 함께 쓰는 이유가 이것이다.
///
/// 색을 테마에서 읽지 않는 이유: 이것은 표면색이 아니라 **사진 위 가독성 보정**이라
/// 라이트/다크와 무관하게 항상 어두워야 한다.
const List<Shadow> overlayTextShadow = <Shadow>[
  Shadow(color: Color(0x99000000), blurRadius: 6, offset: Offset(0, 1)),
];

/// 피드 한 장의 상단 오버레이 — 아바타·닉네임·상대시각·DM 아이콘.
///
/// **DM 아이콘은 피드에만 존재한다**(설계 §6, R7). 커뮤니티 `PostCard`에는 없고
/// 앞으로도 두지 않는다 — 커뮤니티 글 작성자에게는 대화를 걸 수 없어서, 진입점만
/// 보여주고 서버가 거부하면 사용자에게는 고장으로 보인다.
///
/// **내 글이면 DM 아이콘을 그리지 않는다**(AC7-4) — 자기 자신과의 대화는 만들 수
/// 없다. [onMessage]가 null이면 아이콘 자체가 사라진다.
///
/// 사진 위에 얹히므로 반투명 스크림을 깔아 가독성을 확보한다 — Discover 스와이프
/// 카드의 텍스트 오버레이와 같은 처리다.
class FeedAuthorBar extends StatelessWidget {
  const FeedAuthorBar({
    super.key,
    required this.author,
    required this.createdAt,
    required this.now,
    this.onMessage,
    this.onOptions,
  });

  final PostAuthor author;
  final DateTime createdAt;

  /// 상대 시각 계산 기준. 인자로 받아 한 화면 안의 모든 항목이 같은 기준을 쓰게 한다.
  final DateTime now;

  /// 대화 시작. null이면 아이콘을 그리지 않는다(내 글이거나 미로그인).
  final VoidCallback? onMessage;

  /// 우상단 오버플로 — 신고 시트를 연다.
  final VoidCallback? onOptions;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);
    // 사진 위 텍스트라 표면색이 아니라 스크림 대비색을 쓴다.
    final Color foreground = theme.colorScheme.onPrimary;

    return DecoratedBox(
      decoration: BoxDecoration(
        // **헤더 스크림 위에 겹쳐 깔린다.** 둘 다 진하게 잡았더니 상단 1/5가
        // 잿빛으로 죽어 "위쪽만 색이 다른" 띠가 됐다 — 헤더가 이미 어둠을 깔아
        // 두므로 여기서는 글자 바로 뒤만 살짝 눌러 준다. 가독성은 글자 그림자가
        // 함께 책임진다(디자인 §2 — Stitch도 스크림 + drop-shadow를 같이 쓴다).
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: const <double>[0, 0.6, 1],
          colors: <Color>[
            theme.colorScheme.scrim.withValues(alpha: 0.28),
            theme.colorScheme.scrim.withValues(alpha: 0.12),
            theme.colorScheme.scrim.withValues(alpha: 0),
          ],
        ),
      ),
      // **`SafeArea`를 쓰지 않는다.** 헤더 아래에 배치되므로 상태바를 다시 피하면
      // 두 번 밀린다 — 위치는 이 위젯을 놓는 쪽이 정한다.
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 4, 20),
        child: Row(
          children: <Widget>[
            _AuthorAvatar(author: author, foreground: foreground),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    author.nickname,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: foreground,
                      fontWeight: FontWeight.w700,
                      shadows: overlayTextShadow,
                    ),
                  ),
                  Text(
                    relativePostTime(l10n, createdAt, now),
                    style: theme.textTheme.labelSmall?.copyWith(
                      // 0.8까지 흐리면 밝은 사진에서 시각이 먼저 사라진다 —
                      // 스크림이 있어도 작은 글씨는 대비를 더 필요로 한다.
                      color: foreground.withValues(alpha: 0.92),
                      shadows: overlayTextShadow,
                    ),
                  ),
                ],
              ),
            ),
            if (onMessage != null)
              IconButton(
                tooltip: l10n.feedMessageAuthorAction,
                color: foreground,
                onPressed: onMessage,
                // **헤더의 대화함 아이콘과 반드시 달라야 한다.** 둘 다
                // `Icons.mail_outline`이던 때는 같은 아이콘이 나란히 두 개 떠
                // "새 대화 걸기"와 "대화함 열기"가 구분되지 않았다. 보내기 계열
                // 아이콘은 이 버튼이 **행동(전송)**이라는 것을 드러내고,
                // 봉투는 **장소(받은 대화함)**로 남는다.
                icon: const Icon(Icons.send_outlined),
              ),
            if (onOptions != null)
              IconButton(
                tooltip: l10n.feedOptionsAction,
                color: foreground,
                onPressed: onOptions,
                icon: const Icon(Icons.more_vert),
              ),
          ],
        ),
      ),
    );
  }
}

/// 작성자 아바타. 이미지가 없거나 404여도 자리 크기가 같다 — `PostCard`의
/// `_AuthorAvatar`와 같은 폴백이며, 실패가 레이아웃을 밀지 않는다.
class _AuthorAvatar extends StatelessWidget {
  const _AuthorAvatar({required this.author, required this.foreground});

  final PostAuthor author;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    // 서버 값은 완전한 URL이 아니라 키일 수 있다 — 그대로 넘기면 페인트 중에 터진다.
    final String? url = MediaCdn.profileImage(author.profileImageUrl);
    return CircleAvatar(
      radius: 16,
      backgroundColor: theme.colorScheme.surfaceContainerHighest,
      foregroundImage: (url == null || url.isEmpty) ? null : NetworkImage(url),
      child: Text(
        author.nickname.isEmpty ? '?' : author.nickname.characters.first,
        style: theme.textTheme.labelMedium?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
