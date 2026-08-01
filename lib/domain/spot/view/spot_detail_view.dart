import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/gen/app_localizations.dart';
import '../component/attribution_block.dart';
import '../component/detail_reaction_bar.dart';
import '../component/detail_section.dart';
import '../component/like_count_badge.dart';
import '../component/spot_gallery.dart';
import '../model/spot_detail.dart';
import '../model/spot_failure.dart';
import '../model/spot_reaction.dart';
import '../provider/spot_detail_providers.dart';

/// 관광지 상세 화면(SPEC-0003). Discover 카드 탭 → 이 화면으로 push. 전체화면 스크롤로
/// 갤러리·제목·소개·연락처·저작권 전문·좋아요/반응을 위에서 아래로 쌓는다(§3).
///
/// 상태(§6): 로딩 → 스피너, 오류 → 유형별 오류 화면(재시도), 정상 → 레이아웃. 값 없는
/// 섹션은 렌더하지 않는다(AC-25). [contentId]는 라우트가 넘긴 Spot.id다.
class SpotDetailView extends ConsumerWidget {
  const SpotDetailView({super.key, required this.contentId});

  /// Discover 카드의 contentId(=Spot.id). 라우트 파라미터로 전달된다(R9).
  final String contentId;

  static String get routeName => 'spotDetail';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<SpotDetail> detail = ref.watch(
      spotDetailControllerProvider(contentId),
    );

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: detail.when(
          loading: () => const _LoadingState(),
          error: (Object error, _) => _ErrorState(
            failure: error is SpotFailure ? error : SpotFailure.network,
            onRetry: () => ref
                .read(spotDetailControllerProvider(contentId).notifier)
                .reload(),
          ),
          data: (SpotDetail data) =>
              _DetailBody(contentId: contentId, detail: data),
        ),
      ),
    );
  }
}

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(l10n.spotDetailLoading),
        ],
      ),
    );
  }
}

/// 조회 실패 화면(AC-26). 실패 유형별로 안내 문구를 달리하되, 빈 상세로 오인시키지
/// 않도록 항상 오류임을 명확히 하고 재시도 CTA를 준다.
class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.failure, required this.onRetry});

  final SpotFailure failure;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final ThemeData theme = Theme.of(context);
    final (IconData icon, String title, String body) = switch (failure.kind) {
      SpotFailureKind.notFound => (
        Icons.search_off_outlined,
        l10n.spotDetailNotFoundTitle,
        l10n.spotDetailNotFoundBody,
      ),
      SpotFailureKind.rateLimited => (
        Icons.hourglass_empty_outlined,
        l10n.spotDetailRateLimitedTitle,
        l10n.spotDetailRateLimitedBody,
      ),
      _ => (
        Icons.cloud_off_outlined,
        l10n.spotDetailUnavailableTitle,
        l10n.spotDetailUnavailableBody,
      ),
    };

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(icon, size: 48, color: theme.colorScheme.onSurfaceVariant),
            const SizedBox(height: 16),
            Text(title, style: theme.textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              body,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: onRetry,
              child: Text(l10n.spotDetailRetryButton),
            ),
          ],
        ),
      ),
    );
  }
}

/// 정상 상세 레이아웃(§3). 값 없는 섹션은 조건부로 렌더하지 않는다(AC-25).
class _DetailBody extends ConsumerWidget {
  const _DetailBody({required this.contentId, required this.detail});

  final String contentId;
  final SpotDetail detail;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SpotGallery(
            images: detail.gallery,
            fallbackImageUrl: detail.thumbnailImageUrl,
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(detail.title, style: theme.textTheme.headlineSmall),
                if (detail.address != null) ...<Widget>[
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Icon(
                        Icons.place_outlined,
                        size: 18,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          detail.address!,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 16),
                // 좋아요 개수만 좁게 watch 한다 — 낙관적 갱신/롤백 시 이 배지만
                // 다시 그리고, 갤러리·소개 등 정적 서브트리는 건드리지 않는다(§5 select).
                _LikeCount(contentId: contentId),

                // 소개글: overview 있을 때만(AC-25).
                if (detail.overview != null) ...<Widget>[
                  const SizedBox(height: 24),
                  DetailSection(
                    title: l10n.spotDetailOverviewTitle,
                    child: Text(
                      detail.overview!,
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                ],

                // 연락처: homepage·tel 중 하나라도 있을 때만.
                if (detail.homepage != null || detail.tel != null) ...<Widget>[
                  const SizedBox(height: 24),
                  DetailSection(
                    title: l10n.spotDetailContactTitle,
                    child: _ContactRows(
                      homepage: detail.homepage,
                      tel: detail.tel,
                    ),
                  ),
                ],

                const SizedBox(height: 24),
                AttributionBlock(attributionText: detail.attributionText),

                const SizedBox(height: 24),
                DetailReactionBar(
                  onReaction: (SpotReaction reaction) =>
                      _react(context, ref, reaction),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 반응을 provider에 위임하고, 실패(롤백 후 rethrow) 시 스낵바로 피드백한다(AC-30).
  Future<void> _react(
    BuildContext context,
    WidgetRef ref,
    SpotReaction reaction,
  ) async {
    final messenger = ScaffoldMessenger.of(context);
    final String failedText = AppLocalizations.of(
      context,
    ).spotDetailReactionFailed;
    try {
      await ref
          .read(spotDetailControllerProvider(contentId).notifier)
          .react(reaction);
    } catch (_) {
      messenger.showSnackBar(SnackBar(content: Text(failedText)));
    }
  }
}

/// 좋아요 개수 배지를 좁게 watch 하는 래퍼. `select`로 likeCount만 구독해 낙관적
/// 갱신/롤백 시 이 위젯만 다시 그린다(§5) — 갤러리·소개 등 정적 서브트리는 정지.
class _LikeCount extends ConsumerWidget {
  const _LikeCount({required this.contentId});

  final String contentId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final int likeCount = ref.watch(
      spotDetailControllerProvider(
        contentId,
      ).select((AsyncValue<SpotDetail> v) => v.value?.likeCount ?? 0),
    );
    return LikeCountBadge(likeCount: likeCount);
  }
}

/// 연락처 행들: 값 있는 것만 렌더한다(homepage/tel 각각).
class _ContactRows extends StatelessWidget {
  const _ContactRows({required this.homepage, required this.tel});

  final String? homepage;
  final String? tel;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (homepage != null)
          _ContactRow(
            icon: Icons.language_outlined,
            label: l10n.spotDetailHomepageLabel,
            value: homepage!,
          ),
        if (homepage != null && tel != null) const SizedBox(height: 8),
        if (tel != null)
          _ContactRow(
            icon: Icons.phone_outlined,
            label: l10n.spotDetailTelLabel,
            value: tel!,
          ),
      ],
    );
  }
}

class _ContactRow extends StatelessWidget {
  const _ContactRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Icon(icon, size: 18, color: theme.colorScheme.onSurfaceVariant),
        const SizedBox(width: 8),
        Text('$label: ', style: theme.textTheme.bodyMedium),
        Expanded(
          child: Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.primary,
            ),
          ),
        ),
      ],
    );
  }
}
