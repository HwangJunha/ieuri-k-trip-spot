import 'package:flutter/material.dart';

import '../../../l10n/gen/app_localizations.dart';

/// 추천 산출 근거 고지(개인정보보호법 §37조의2).
///
/// **자동화된 결정이라 근거를 밝혀야 한다.** 어떤 데이터로 어떤 순서를 매겼는지,
/// 각 항목이 언제 기준인지, 무엇이 추천에서 빠지는지를 적는다.
///
/// 카드마다 기준일을 반복해 적는 대신 이 한 곳에 모았다 — 항목마다 신선도가 달라
/// (예측·30일 지연·월 단위) 카드 한 줄로는 정확히 말할 수 없다.
void showRegionRecommendationAbout(BuildContext context) {
  showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (BuildContext context) => const _AboutSheet(),
  );
}

class _AboutSheet extends StatelessWidget {
  const _AboutSheet();

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final ThemeData theme = Theme.of(context);

    return SafeArea(
      child: ConstrainedBox(
        // 본문이 길어 화면을 넘기므로 스크롤에 맡기되, 시트가 화면을 다 덮지는
        // 않게 둔다 — 뒤의 목록이 조금 보여야 "덮개"로 읽힌다.
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.85,
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                l10n.mapRegionAboutTitle,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                l10n.mapRegionAboutIntro,
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 20),
              _Section(
                title: l10n.mapScoreFactorCongestion,
                body: l10n.mapRegionAboutCongestion,
              ),
              _Section(
                title: l10n.mapScoreFactorVisitorVolume,
                body: l10n.mapRegionAboutVisitorVolume,
              ),
              _Section(
                title: l10n.mapRegionAboutIntensityTitle,
                body: l10n.mapRegionAboutIntensity,
              ),
              _Section(
                title: l10n.mapScoreFactorDistance,
                body: l10n.mapRegionAboutDistance,
              ),
              const SizedBox(height: 4),
              const Divider(),
              const SizedBox(height: 16),
              // 점수 산정 방식(사용자 요청, 2026-08-12).
              //
              // **정규화가 상대값이라는 점을 반드시 밝힌다.** 카드에 "48" 같은 숫자를
              // 적기로 했는데(사용자 결정), 그 값은 같은 시·도 후보 안에서 최저=0,
              // 최고=100으로 늘린 값이라 다른 시·도의 같은 숫자와 뜻이 다르다 —
              // 서버도 이 점 때문에 값 노출을 권하지 않았다. 숫자를 보여주는 이상
              // 그 뜻을 여기서 설명해야 오해가 남지 않는다.
              Text(
                l10n.mapRegionAboutScoringTitle,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              _Note(text: l10n.mapRegionAboutScoringNormalize),
              _Note(text: l10n.mapRegionAboutScoringCongestion),
              _Note(text: l10n.mapRegionAboutScoringDistance),
              _Note(text: l10n.mapRegionAboutScoringDecay),
              _Note(text: l10n.mapRegionAboutScoringTotal),
              const SizedBox(height: 4),
              const Divider(),
              const SizedBox(height: 12),
              _Note(text: l10n.mapRegionAboutRankNote),
              _Note(text: l10n.mapRegionAboutMissingNote),
              _Note(text: l10n.mapRegionAboutExcludedNote),
            ],
          ),
        ),
      ),
    );
  }
}

/// 항목 하나의 설명 — 제목과 본문.
class _Section extends StatelessWidget {
  const _Section({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            body,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

/// 항목 설명 아래의 보충 문단.
class _Note extends StatelessWidget {
  const _Note({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        text,
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
          height: 1.5,
        ),
      ),
    );
  }
}
