import 'package:flutter/material.dart';

import '../../../common/model/spot_qa_origin.dart';
import '../../../l10n/gen/app_localizations.dart';

/// 대화 상단의 질문/답변 출처 카드(SPEC-0026 R14).
///
/// ```
/// ┌──────────────────────────────────────┐
/// │ 이 질문에서 시작된 대화                 │
/// │ 경복궁 · "지금 사람 많나요?"          ›│
/// └──────────────────────────────────────┘
/// ```
///
/// **스냅샷을 그대로 그린다.** 원본 질문·답변이 삭제돼도 값은 남아 있으며 다시
/// 조회하지 않는다 — 맥락을 남기는 것이 이 값의 존재 이유다. 장소명도 스냅샷 시점의
/// 것이라 이후 이름이 바뀌어도 여기서는 고정이다.
///
/// 눌러 [onTap]을 부르면 그 장소 상세로 간다. `catalogId`는 예외적으로 항상 유효하다
/// (장소는 삭제되지 않는다).
class SpotQaOriginCard extends StatelessWidget {
  const SpotQaOriginCard({
    super.key,
    required this.origin,
    required this.onTap,
  });

  final SpotQaOrigin origin;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);

    return Material(
      color: theme.colorScheme.surfaceContainerHighest,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 8, 10),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      l10n.spotQaOriginCardTitle,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      origin.spotTitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.labelLarge,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      // 스냅샷은 서버가 이미 100자로 잘라 보낸다 — 여기서 다시
                      // 자르지 않고 줄 수만 제한한다.
                      origin.questionBodySnapshot,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                size: 20,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
