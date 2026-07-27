import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/gen/app_localizations.dart';
import '../model/tour_event.dart';
import '../provider/event_providers.dart';
import 'event_card.dart';

/// Self-contained "Happening Now" events section (title + event cards). Reads
/// the event provider and renders its own loading/error/data states, so any
/// surface — the Home tab today, the Events tab later — can embed it with a
/// single widget and without touching the event domain's internals.
class HappeningNowSection extends ConsumerWidget {
  const HappeningNowSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final AsyncValue<List<TourEvent>> events = ref.watch(
      happeningNowEventsProvider,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            l10n.homeSectionHappeningNow,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          events.when(
            data: (List<TourEvent> items) => Column(
              children: <Widget>[
                for (final TourEvent e in items)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: EventCard(event: e),
                  ),
              ],
            ),
            loading: () => const Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: CircularProgressIndicator(),
              ),
            ),
            error: (Object error, _) => Padding(
              padding: const EdgeInsets.all(16),
              child: Text(l10n.errorUnknown),
            ),
          ),
        ],
      ),
    );
  }
}
