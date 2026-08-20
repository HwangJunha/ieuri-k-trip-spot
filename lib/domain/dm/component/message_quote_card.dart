import 'package:flutter/material.dart';

import '../../../common/model/spot_qa_origin.dart';
import '../../../l10n/gen/app_localizations.dart';

/// 메시지 말풍선 안에 붙는 질문/답변 인용(SPEC-0026).
///
/// ```
/// ┌ 경복궁 ─────────────────────┐
/// │ "지금 사람 많나요?"           │   ← 말풍선 맨 위
/// └──────────────────────────────┘
///   오후엔 한산해요                    ← 본문
/// ```
///
/// **대화 상단의 고정 카드를 대체한다**(2026-08-18 서버가 인용을 메시지로 옮겼다).
/// 카드 하나로는 두 번째 인용을 표현할 수 없었고, 갈아끼우면 첫 인용이 사라졌다.
/// 말풍선에 붙이면 인용이 시간순으로 쌓이고 앞선 것이 그대로 남는다.
///
/// **스냅샷을 그대로 그린다.** 원본 질문·답변이 삭제돼도 값은 남아 있으며 다시
/// 조회하지 않는다 — 맥락을 남기는 것이 이 값의 존재 이유다. 장소명도 스냅샷 시점의
/// 것이라 이후 이름이 바뀌어도 여기서는 고정이다.
///
/// **장소 이름을 눌러도 상세로 가지 않는다. 미완성이 아니라 의도한 것이다**
/// (SPEC-0029 AC-27.2). `origin.catalogId`를 읽을 수 있지만 쓰지 않는다.
///
/// 이 인용은 **작성 시점의 스냅샷이고 목록 필터를 거치지 않는다.** 발신자의 언어에서
/// 해소되던 장소가 수신자의 언어에서는 해소되지 않을 수 있어, 그 id로 상세를 열면
/// `SPOT_NOT_FOUND_IN_LOCALE`로 실패한다. `spotTitle`은 스냅샷이라 항상 있으므로
/// **제목이 보인다고 열리는 것이 아니다.**
///
/// 목록에서 받은 장소 칩(`PostCard`)은 결론이 반대다 — 서버가 걸러 주므로 탭을
/// 허용한다. 두 경로를 하나로 뭉뚱그리면 안 된다.
class MessageQuoteCard extends StatelessWidget {
  const MessageQuoteCard({
    super.key,
    required this.origin,
    required this.onMine,
  });

  final SpotQaOrigin origin;

  /// 내가 보낸 말풍선인지. 배경이 진해 대비를 뒤집어야 한다.
  final bool onMine;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);

    // 말풍선 배경 위에 얹히므로 색을 그 위에서 고른다 — 내 말풍선은 진한 primary라
    // 흰 계열로, 받은 말풍선은 옅어 표준 전경색으로 간다.
    final Color line = onMine
        ? theme.colorScheme.onPrimary.withValues(alpha: 0.55)
        : theme.colorScheme.primary;
    final Color strong = onMine
        ? theme.colorScheme.onPrimary
        : theme.colorScheme.onSurface;
    final Color soft = onMine
        ? theme.colorScheme.onPrimary.withValues(alpha: 0.75)
        : theme.colorScheme.onSurfaceVariant;

    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
      child: Container(
        padding: const EdgeInsets.fromLTRB(10, 6, 10, 7),
        decoration: BoxDecoration(
          // 왼쪽 세로선 — 인용임을 알리는 가장 익숙한 표시다.
          border: BorderDirectional(start: BorderSide(color: line, width: 2.5)),
          color: onMine
              ? theme.colorScheme.onPrimary.withValues(alpha: 0.12)
              : theme.colorScheme.surfaceContainerHighest,
          borderRadius: const BorderRadius.all(Radius.circular(6)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              l10n.spotQaOriginCardTitle,
              style: theme.textTheme.labelSmall?.copyWith(color: soft),
            ),
            const SizedBox(height: 2),
            Text(
              origin.spotTitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.labelLarge?.copyWith(
                color: strong,
                fontWeight: FontWeight.w700,
              ),
            ),
            // 질문 발췌는 스냅샷이라 빈 문자열일 수 있다 — 그때는 줄째로 생략한다.
            if (origin.questionBodySnapshot.isNotEmpty) ...<Widget>[
              const SizedBox(height: 1),
              Text(
                origin.questionBodySnapshot,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall?.copyWith(color: soft),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
