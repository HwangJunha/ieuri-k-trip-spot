import 'package:flutter/material.dart';

import '../../../common/widget/spot_thumbnail.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../model/festival.dart';

/// "Happening Now" 목록 행: 썸네일 + 제목 + 행사 기간(SPEC-0013 R17).
///
/// **카테고리 배지가 사라졌다.** `ongoingFestivals`는 축제만 반환하므로 모든 카드가
/// 같은 배지를 달게 되어 정보가 되지 못했다. 그 자리를 실제로 다른 값인 행사 기간이
/// 대신한다 — 오늘이 종료일이면 그것을 먼저 알린다.
class EventCard extends StatelessWidget {
  const EventCard({super.key, required this.festival, required this.onTap});

  final Festival festival;

  /// 카드를 누르면 호출된다. 이동은 화면이 맡는다 — `component`는 `view`를
  /// import하지 않는다(CLAUDE.md §3).
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      color: theme.colorScheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: <Widget>[
            SizedBox(
              width: 72,
              height: 72,
              child: SpotThumbnail(imageRef: festival.thumbnailImageUrl),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      festival.title,
                      style: theme.textTheme.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _periodLabel(context, l10n),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }

  /// 행사 기간 문구. 날짜 포맷은 [MaterialLocalizations]가 로케일에 맞게 만든다 —
  /// 모델은 [DateTime]만 들고 있고 문구는 위젯이 붙인다(다른 값 표시와 같은 규칙).
  String _periodLabel(BuildContext context, AppLocalizations l10n) {
    final MaterialLocalizations dates = MaterialLocalizations.of(context);
    return l10n.festivalPeriod(
      dates.formatShortDate(festival.startDate),
      dates.formatShortDate(festival.endDate),
    );
  }
}
