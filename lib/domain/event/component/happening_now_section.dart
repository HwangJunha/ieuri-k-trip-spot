import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/navigation/spot_detail_route.dart';
import '../../../common/widget/home_section.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../model/festival.dart';
import '../provider/event_providers.dart';
import 'event_card.dart';

/// Self-contained "Happening Now" section (title + event cards). Reads the event
/// provider and renders its own loading/empty/error states, so any surface — the
/// Home tab today, an Events tab later — can embed it with a single widget and
/// without touching the event domain's internals.
///
/// 상태 경계는 홈의 다른 섹션과 같은 [HomeSection]을 쓴다. 세 섹션이 같은 규약으로
/// 로딩·빈 상태·실패를 보여야 한 섹션만 다른 모양으로 튀지 않는다(R19).
///
/// **빈 결과가 흔하다**(AC-17.4) — 반경 안에 진행 중인 축제가 없는 것은 정상이므로
/// 오류가 아니라 이유 문구를 띄운다.
class HappeningNowSection extends ConsumerWidget {
  const HappeningNowSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final AsyncValue<List<Festival>> events = ref.watch(
      happeningNowEventsProvider,
    );

    return HomeSection<Festival>(
      title: l10n.homeSectionHappeningNow,
      value: events,
      emptyMessage: l10n.homeHappeningNowEmpty,
      onRetry: () => ref.invalidate(happeningNowEventsProvider),
      builder: (List<Festival> items) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: <Widget>[
            for (final Festival f in items)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: EventCard(
                  festival: f,
                  // 축제도 관광지 상세로 연다 — `Festival.id`는 `Spot.id`(contentId)와
                  // 같은 식별자다.
                  //
                  // **카테고리는 넘기지 않는다**(SPEC-0020). 예전에는 서버의
                  // `intro`/`infoItems`가 요구해 축제 코드를 실어 보냈으나, 이제
                  // 서버가 spot 자신의 카테고리로 해석한다.
                  onTap: () => openSpotDetail(
                    context,
                    id: f.id,
                    thumbnailUrl: f.thumbnailImageUrl,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
