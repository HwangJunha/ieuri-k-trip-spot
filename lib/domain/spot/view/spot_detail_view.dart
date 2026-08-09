import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../common/widget/failure_notice.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../component/attribution_block.dart';
import '../component/detail_reaction_bar.dart';
import '../component/detail_section.dart';
import '../component/like_count_badge.dart';
import '../component/spot_gallery.dart';
import '../component/spot_info_item_list.dart';
import '../component/spot_intro_rows.dart';
import '../model/retry_exhausted.dart';
import '../../../common/navigation/spot_detail_route.dart';
import '../model/spot_category.dart';
import '../model/spot_detail.dart';
import '../model/spot_failure.dart';
import '../model/spot_image.dart';
import '../model/spot_reaction.dart';
import '../provider/spot_detail_providers.dart';
import '../provider/swipe_providers.dart';

/// 관광지 상세 화면(SPEC-0003). Discover 카드 탭 → 이 화면으로 push. 전체화면 스크롤로
/// 갤러리·제목·소개·연락처·저작권 전문·좋아요/반응을 위에서 아래로 쌓는다(§3).
///
/// 상태(§6): 로딩 → 스피너, 오류 → 유형별 오류 화면(재시도), 정상 → 레이아웃. 값 없는
/// 섹션은 렌더하지 않는다(AC-25). [contentId]는 라우트가 넘긴 Spot.id다.
class SpotDetailView extends ConsumerWidget {
  const SpotDetailView({
    super.key,
    required this.contentId,
    required this.category,
    this.initialThumbnailUrl,
    this.feedCategory,
  });

  /// 스와이프 카드가 이미 가진 썸네일 URL(SPEC-0006 R8). 본문 조회가 끝나기 전에도
  /// 이 URL로 첫 이미지 자리를 채워, 같은 이미지를 다시 로드하며 깜빡이는 것을
  /// 막는다(AC-24). 직접 진입처럼 값이 없으면 조회 결과로 대체되며 오류가 아니다
  /// (AC-25). 조회가 끝나면 응답의 `thumbnailImageUrl`이 최종 값이다(AC-26).
  final String? initialThumbnailUrl;

  /// 이 상세가 어느 스와이프 피드에서 열렸는지(null=전체 피드, SPEC-0006 R11).
  /// 반응 후 그 피드에서 카드를 소비할 때 쓴다.
  ///
  /// [category]와 다른 값이다 — [category]는 **이 관광지의** 카테고리이고, 이 값은
  /// **피드의 필터**다. 전체 피드에서 식당 카드를 열면 앞은 restaurant, 뒤는 null이다.
  /// 현재 선택 상태를 다시 읽지 않는 이유는, 상세를 열어둔 채 카테고리를 바꾸면 그
  /// 선택이 이미 다른 피드를 가리켜 정작 카드가 있는 인스턴스를 놓치기 때문이다.
  final SpotCategory? feedCategory;

  /// Discover 카드의 contentId(=Spot.id). 라우트 파라미터로 전달된다(R9).
  final String contentId;

  /// 카드가 이미 알고 있는 카테고리. 서버의 `intro`/`infoItems`가 필수 인자로
  /// 요구하는데 조회 중인 응답의 필드를 인자로 참조할 수 없어, 스와이프 피드에서
  /// 받은 값을 그대로 넘긴다(추가 왕복 없음).
  final SpotCategory category;

  static String get routeName => spotDetailRouteName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<SpotDetail> detail = ref.watch(
      spotDetailControllerProvider(contentId, category),
    );

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: detail.when(
          loading: () => _LoadingState(thumbnailUrl: initialThumbnailUrl),
          error: (Object error, _) => _ErrorState(
            error: error,
            onRetry: () => ref
                .read(
                  spotDetailControllerProvider(contentId, category).notifier,
                )
                .reload(),
          ),
          data: (SpotDetail data) => _DetailBody(
            contentId: contentId,
            category: category,
            feedCategory: feedCategory,
            detail: data,
            initialThumbnailUrl: initialThumbnailUrl,
          ),
        ),
      ),
    );
  }
}

/// 본문 조회 중 화면. 넘겨받은 썸네일이 있으면 갤러리 자리를 **먼저 채운다**(R8,
/// AC-24) — 리스트에서 이미 보던 이미지가 그대로 이어져, 조회가 끝난 뒤 같은 URL을
/// 다시 로드하며 깜빡이는 일이 없다. 값이 없으면(직접 진입) 기존 스피너만 보인다.
class _LoadingState extends StatelessWidget {
  const _LoadingState({this.thumbnailUrl});

  final String? thumbnailUrl;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final Widget spinner = Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const CircularProgressIndicator(),
        const SizedBox(height: 16),
        Text(l10n.spotDetailLoading),
      ],
    );

    if (thumbnailUrl == null) return Center(child: spinner);

    // 갤러리와 같은 컴포넌트를 쓴다 — 조회 완료 후 교체될 위젯과 같은 형이라야 같은
    // 자리·같은 크기에 그려지고, 이미지 캐시도 같은 URL로 적중한다.
    //
    // 스크롤 가능한 컨테이너에 담는 이유는 본문(`_DetailBody`)도 스크롤이기 때문이다.
    // 화면이 좁으면 갤러리 + 스피너가 세로를 넘겨 오버플로한다.
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SpotGallery(
            images: const <SpotImage>[],
            fallbackImageUrl: thumbnailUrl!,
          ),
          const SizedBox(height: 32),
          spinner,
        ],
      ),
    );
  }
}

/// 조회 실패 화면(AC-26). 자동 재시도 상한을 소진했으면 종료 상태를, 아니면 실패
/// 유형별 안내를 보여준다(SPEC-0006 AC-5·AC-6). 어느 쪽이든 빈 상세로 오인시키지
/// 않도록 오류임을 명확히 하고 명시적 재시도 CTA를 준다(AC-8).
class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.error, required this.onRetry});

  final Object error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);

    // 종료 상태는 실패 유형과 무관하게 하나의 문구다 — 사용자에게 필요한 정보는
    // "무엇이 실패했나"가 아니라 "자동 재시도가 끝났다"이기 때문이다.
    if (error is RetryExhausted) {
      return FailureNotice.terminal(
        title: l10n.retryExhaustedTitle,
        body: l10n.retryExhaustedBody,
        actionLabel: l10n.retryExhaustedAction,
        onAction: onRetry,
      );
    }

    final SpotFailure failure = error is SpotFailure
        ? error as SpotFailure
        : SpotFailure.network;
    final (String title, String body) = switch (failure.kind) {
      SpotFailureKind.notFound => (
        l10n.spotDetailNotFoundTitle,
        l10n.spotDetailNotFoundBody,
      ),
      SpotFailureKind.rateLimited => (
        l10n.spotDetailRateLimitedTitle,
        l10n.spotDetailRateLimitedBody,
      ),
      _ => (l10n.spotDetailUnavailableTitle, l10n.spotDetailUnavailableBody),
    };

    return FailureNotice.retryable(
      title: title,
      body: body,
      actionLabel: l10n.spotDetailRetryButton,
      onAction: onRetry,
    );
  }
}

/// 정상 상세 레이아웃(§3). 값 없는 섹션은 조건부로 렌더하지 않는다(AC-25).
class _DetailBody extends ConsumerWidget {
  const _DetailBody({
    required this.contentId,
    required this.category,
    required this.feedCategory,
    required this.detail,
    this.initialThumbnailUrl,
  });

  final String contentId;
  final SpotCategory category;

  /// 이 상세가 열린 스와이프 피드의 필터(null=전체). 반응 후 카드 소비 대상이다.
  final SpotCategory? feedCategory;

  final SpotDetail detail;

  /// 리스트에서 넘겨받은 썸네일(SPEC-0006 R8). 로딩 화면이 이미 그린 이미지라,
  /// 본문에서도 이것을 갤러리 첫 장으로 유지해야 조회 완료 순간에 안 바뀐다.
  /// 직접 진입이면 null이고, 그때는 응답의 썸네일이 첫 장이 된다(AC-25).
  final String? initialThumbnailUrl;

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
            // 리스트에서 보던 썸네일이 있으면 그것을 첫 장으로 유지한다(R8·AC-24) —
            // 응답의 썸네일로 갈아끼우면 로딩 화면에서 본문으로 넘어가는 순간
            // 이미지가 바뀐다. 직접 진입이면 응답 값이 첫 장이다(AC-25).
            fallbackImageUrl: initialThumbnailUrl ?? detail.thumbnailImageUrl,
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(detail.title, style: theme.textTheme.headlineSmall),
                if (detail.hasAddress) ...<Widget>[
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
                          detail.displayAddress!,
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
                _LikeCount(contentId: contentId, category: category),

                // 소개글: overview 값이 있을 때만(AC-25).
                if (detail.hasOverview) ...<Widget>[
                  const SizedBox(height: 24),
                  DetailSection(
                    title: l10n.spotDetailOverviewTitle,
                    child: Text(
                      detail.displayOverview!,
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                ],

                // 운영 정보: 값이 있는 항목이 하나라도 있을 때만. 카테고리에 없는
                // 개념은 서버가 null로 주므로 여행코스처럼 항목이 전무한 상세에선
                // 섹션 자체가 사라진다(AC-25).
                if (detail.hasIntro) ...<Widget>[
                  const SizedBox(height: 24),
                  DetailSection(
                    title: l10n.spotDetailIntroTitle,
                    child: SpotIntroRows(entries: detail.introEntries),
                  ),
                ],

                // 이용안내: 내용이 있는 항목만 넘긴다(빈 항목은 모델이 걸러냈다).
                if (detail.hasInfoItems) ...<Widget>[
                  const SizedBox(height: 24),
                  DetailSection(
                    title: l10n.spotDetailInfoTitle,
                    child: SpotInfoItemList(items: detail.presentInfoItems),
                  ),
                ],

                // 연락처: homepage·tel 중 하나라도 값이 있을 때만(빈 문자열 제외).
                if (detail.hasContact) ...<Widget>[
                  const SizedBox(height: 24),
                  DetailSection(
                    title: l10n.spotDetailContactTitle,
                    child: _ContactRows(detail: detail),
                  ),
                ],

                const SizedBox(height: 24),
                AttributionBlock(
                  attributionText: detail.attributionText,
                  imageAttributions: detail.distinctImageAttributions,
                ),

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
  ///
  /// 성공하면 이 카드를 스와이프 스택에서 소비하고 Discover로 돌아간다(SPEC-0006
  /// R11·R12). 사용자가 이미 판단한 카드가 돌아왔을 때 맨 위에 다시 있으면 안 되기
  /// 때문이다 — 상세는 스와이프의 "자세히 보기" 단계다. 소비를 **pop 전에** 하는
  /// 이유는 R12다: 리스트가 이미 다음 카드를 맨 위에 둔 채로 드러나야 전진이
  /// 일어났음이 복귀 순간에 보인다(AC-38·AC-39).
  ///
  /// 실패하면 소비하지 않고 화면에 머물러 재시도할 수 있게 한다. 반응이 기록되지
  /// 않았는데 카드가 사라지면 사용자는 반응했다고 믿지만 서버는 모르는 상태가 된다.
  Future<void> _react(
    BuildContext context,
    WidgetRef ref,
    SpotReaction reaction,
  ) async {
    final messenger = ScaffoldMessenger.of(context);
    final NavigatorState navigator = Navigator.of(context);
    final String failedText = AppLocalizations.of(
      context,
    ).spotDetailReactionFailed;
    try {
      await ref
          .read(spotDetailControllerProvider(contentId, category).notifier)
          .react(reaction);
    } catch (_) {
      messenger.showSnackBar(SnackBar(content: Text(failedText)));
      return;
    }

    // 반응은 상세가 이미 보냈으므로 카드만 제거한다(중복 전송 금지).
    //
    // 어떤 피드에서 왔는지는 **현재 선택된 카테고리가 아니라** 이 화면이 열릴 때 받은
    // 값이 답이다 — 상세를 열어둔 채 카테고리를 바꾸면 선택 상태는 이미 다른 피드를
    // 가리켜, 정작 카드가 있는 인스턴스를 놓친다. 피드에 없는 id면 아무 일도 없다.
    ref.read(swipeControllerProvider(feedCategory).notifier).consume(contentId);

    if (navigator.canPop()) navigator.pop();
  }
}

/// 좋아요 개수 배지를 좁게 watch 하는 래퍼. `select`로 likeCount만 구독해 낙관적
/// 갱신/롤백 시 이 위젯만 다시 그린다(§5) — 갤러리·소개 등 정적 서브트리는 정지.
class _LikeCount extends ConsumerWidget {
  const _LikeCount({required this.contentId, required this.category});

  final String contentId;
  final SpotCategory category;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final int likeCount = ref.watch(
      spotDetailControllerProvider(
        contentId,
        category,
      ).select((AsyncValue<SpotDetail> v) => v.value?.likeCount ?? 0),
    );
    return LikeCountBadge(likeCount: likeCount);
  }
}

/// 홈페이지 [url]을 외부 브라우저로 연다. 열지 못하면(잘못된 URL·처리 앱 없음)
/// 스낵바로 알린다 — 탭했는데 아무 일도 안 일어나는 상태를 남기지 않는다.
Future<void> _openUrl(BuildContext context, String url) async {
  final messenger = ScaffoldMessenger.of(context);
  final String failedText = AppLocalizations.of(context).spotDetailLinkFailed;

  final Uri? uri = Uri.tryParse(url);
  bool opened = false;
  if (uri != null) {
    try {
      opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
    } on Exception {
      opened = false;
    }
  }
  if (!opened) messenger.showSnackBar(SnackBar(content: Text(failedText)));
}

/// 연락처 행들: 값 있는 것만 렌더한다(homepage/tel 각각). 값의 유무 판단은
/// [SpotDetail]의 게터에 맡겨 빈 문자열도 "없음"으로 처리한다.
class _ContactRows extends StatelessWidget {
  const _ContactRows({required this.detail});

  final SpotDetail detail;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // 홈페이지는 원문(앵커 태그)이 아니라 추출한 URL을 보여주고, 탭하면 브라우저로
        // 연다. URL을 못 뽑으면 hasHomepage가 false라 행 자체가 없다.
        if (detail.hasHomepage)
          _ContactRow(
            icon: Icons.language_outlined,
            label: l10n.spotDetailHomepageLabel,
            value: detail.homepageUrl!,
            onTap: () => _openUrl(context, detail.homepageUrl!),
          ),
        if (detail.hasHomepage && detail.hasTel) const SizedBox(height: 8),
        if (detail.hasTel)
          _ContactRow(
            icon: Icons.phone_outlined,
            label: l10n.spotDetailTelLabel,
            value: detail.displayTel!,
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
    this.onTap,
  });

  final IconData icon;
  final String label;
  final String value;

  /// 값을 탭했을 때 동작(홈페이지는 브라우저 열기). null이면 일반 텍스트.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    // 링크는 밑줄로 눌러지는 대상임을 알린다(색만으로 구분하지 않는다).
    final Text valueText = Text(
      value,
      style: theme.textTheme.bodyMedium?.copyWith(
        color: theme.colorScheme.primary,
        decoration: onTap == null ? null : TextDecoration.underline,
        decorationColor: theme.colorScheme.primary,
      ),
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Icon(icon, size: 18, color: theme.colorScheme.onSurfaceVariant),
        const SizedBox(width: 8),
        Text('$label: ', style: theme.textTheme.bodyMedium),
        Expanded(
          child: onTap == null
              ? valueText
              : InkWell(onTap: onTap, child: valueText),
        ),
      ],
    );
  }
}
