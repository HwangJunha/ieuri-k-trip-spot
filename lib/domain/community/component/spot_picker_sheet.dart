import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/location/location_service.dart';
import '../../../common/pagination/pagination_list_view.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../model/nearby_spot.dart';
import '../model/nearby_spot_category.dart';
import '../provider/nearby_spots_providers.dart';
import 'community_labels.dart';

/// 시트가 돌려주는 선택 결과.
///
/// 고르지 않고 닫으면 null이며 초안을 건드리지 않는다. **이미 붙어 있는 장소를 떼는
/// 것은 이 시트가 아니라 컴포저 하단 바의 지우기 버튼이 맡는다** — 장소는 선택
/// 항목이라 뗄 수단이 반드시 있어야 하고(가이드 §5), 그 수단을 고르는 목록 안에
/// 항목으로 섞어 두면 "장소 없음"이 장소인 것처럼 읽힌다.
sealed class SpotPickerResult {
  const SpotPickerResult();
}

/// 장소를 하나 골랐다.
class SpotPickerChosen extends SpotPickerResult {
  const SpotPickerChosen(this.spot);

  final NearbySpot spot;
}

/// 컴포저의 장소 선택 시트.
///
/// ```
/// ├── 출처 탭 (주변 / 좋아요한 장소)     ← 주변이 기본이다
/// ├── 카테고리 줄 (서버가 거른다 — 두 출처에 함께 걸린다)
/// ├── (16dp)
/// ├── 결과 내 재검색 (받아 둔 목록만 좁힌다 — 서버 검색이 아니다)
/// └── 장소 목록
/// ```
///
/// **출처가 둘이고 페이징도 다르다.** 주변은 `spots`(오프셋, 거리 있음), 좋아요한
/// 장소는 `likedSpots`(커서, 거리 없음)다. 컨트롤러가 각자 자기 페이지 모델을 쓰므로
/// 그 차이가 이 위젯까지 새지 않는다 — 여기서는 둘 다 같은 줄로 그린다.
///
/// **카테고리 줄은 두 출처에 함께 걸린다.** 서버 `spots`와 `likedSpots`가 같은
/// `SpotCategory` 인자를 받으므로 필터 하나로 족하다 — 탭마다 필터를 따로 두면
/// 탭을 옮길 때 왜 결과가 달라졌는지 알기 어렵다.
///
/// **두 필터는 성격이 다르다.** 카테고리는 서버로 가는 진짜 필터이고, 텍스트 칸은
/// **이름 검색 인자가 없어** 이미 받아 둔 것만 좁힌다.
///
/// 위치를 얻지 못하면 **빈 시트나 무한 스피너가 아니라** 사유와 재시도를 보여준다.
/// 그 상태에서도 좋아요한 장소 탭은 그대로 돈다 — 좌표를 쓰지 않기 때문이다.
Future<SpotPickerResult?> showSpotPickerSheet(BuildContext context) =>
    showModalBottomSheet<SpotPickerResult>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (BuildContext context) => const _SpotPickerSheet(),
    );

class _SpotPickerSheet extends ConsumerStatefulWidget {
  const _SpotPickerSheet();

  @override
  ConsumerState<_SpotPickerSheet> createState() => _SpotPickerSheetState();
}

class _SpotPickerSheetState extends ConsumerState<_SpotPickerSheet> {
  final TextEditingController _filter = TextEditingController();

  @override
  void dispose() {
    _filter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final ThemeData theme = Theme.of(context);
    final String query = ref.watch(nearbySpotQueryProvider);
    final SpotPickerSource source = ref.watch(spotPickerSourceTabProvider);

    return SafeArea(
      // 화면의 3/4까지만 차지한다 — 뒤의 컴포저가 조금 보여야 어디서 고르는
      // 중인지 알 수 있다. 키보드가 올라오면 그만큼 위로 밀린다.
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: SizedBox(
          height: MediaQuery.sizeOf(context).height * 0.75,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: Text(
                  l10n.communitySpotPickerTitle,
                  style: theme.textTheme.titleMedium,
                ),
              ),
              // 출처를 먼저 고른다 — 아래 카테고리·이름 필터가 무엇에 걸리는지가
              // 이 선택으로 정해진다.
              const _SourceTabs(),
              // 카테고리 줄이 텍스트 칸 **위**에 오는 이유: 이쪽이 서버가 거르는
              // 진짜 필터라 먼저 범위를 정하고, 그 결과 안에서 다시 찾는 순서가
              // 자연스럽다.
              const _SpotCategoryRow(),
              // 칩 줄과 검색 칸이 붙어 있으면 성격이 다른 두 필터가 한 덩어리로
              // 읽힌다 — 사이를 띄워 갈라 둔다.
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  controller: _filter,
                  decoration: InputDecoration(
                    isDense: true,
                    prefixIcon: const Icon(Icons.search),
                    hintText: l10n.communitySpotPickerFilterHint,
                    border: const OutlineInputBorder(),
                  ),
                  onChanged: (String value) =>
                      ref.read(nearbySpotQueryProvider.notifier).set(value),
                ),
              ),
              const SizedBox(height: 8),
              const Divider(height: 1),
              Expanded(
                child: switch (source) {
                  SpotPickerSource.nearby => _NearbySpotList(query: query),
                  SpotPickerSource.liked => _LikedSpotList(query: query),
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 카테고리 필터 줄.
///
/// **구성은 서버가 정한다** — `availableSpotCategories`가 현재 언어에서 쓰이는 값만
/// 내려주고(ko에는 여행코스가, en에는 그 자리에 교통이 있다) 앱은 표시 문구만
/// 매핑한다. 클라이언트가 8개를 하드코딩하면 언어를 바꾼 순간 없는 카테고리를
/// 보여주게 된다.
///
/// **비어도 정상이다** — 그때는 "전체" 하나만 남기는 것이 아니라 **줄 자체를 그리지
/// 않는다**: 고를 것이 하나뿐인 필터 줄은 자리만 차지한다. 조회가 실패하거나 아직
/// 오지 않은 동안도 같다 — 카테고리 줄 하나 때문에 장소 목록을 가리지 않는다.
class _SpotCategoryRow extends ConsumerWidget {
  const _SpotCategoryRow();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    // 목록은 있으면 그리고 없으면 안 그린다 — 로딩·오류에 자리를 내주지 않는다.
    final List<NearbySpotCategory> categories =
        ref.watch(nearbySpotCategoriesProvider).value ??
        const <NearbySpotCategory>[];
    if (categories.isEmpty) return const SizedBox.shrink();

    final NearbySpotCategory? selected = ref.watch(
      nearbySpotCategoryFilterProvider,
    );

    return SizedBox(
      height: 48,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: <Widget>[
          _CategoryChip(
            label: l10n.communityCategoryAll,
            selected: selected == null,
            onSelected: () =>
                ref.read(nearbySpotCategoryFilterProvider.notifier).set(null),
          ),
          for (final NearbySpotCategory category in categories)
            _CategoryChip(
              label: nearbySpotCategoryLabel(l10n, category),
              selected: selected == category,
              // 같은 칩을 다시 누르면 전체로 돌아간다 — 해제 수단이 따로 없으면
              // 한 번 고른 뒤 전체를 못 본다.
              onSelected: () => ref
                  .read(nearbySpotCategoryFilterProvider.notifier)
                  .set(selected == category ? null : category),
            ),
        ],
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  final String label;
  final bool selected;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(right: 8),
    child: ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onSelected(),
    ),
  );
}

/// 출처 탭 — 주변 / 좋아요한 장소.
///
/// **주변이 기본이다**(가장 흔한 경우). 좋아요한 장소는 주변 목록에 없는 곳을 다시
/// 찾아 붙이는 보조 경로이고, 좌표를 쓰지 않아 **위치를 못 얻은 상태에서도 돈다**.
class _SourceTabs extends ConsumerWidget {
  const _SourceTabs();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final SpotPickerSource selected = ref.watch(spotPickerSourceTabProvider);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: SegmentedButton<SpotPickerSource>(
        segments: <ButtonSegment<SpotPickerSource>>[
          ButtonSegment<SpotPickerSource>(
            value: SpotPickerSource.nearby,
            label: Text(l10n.communitySpotPickerSourceNearby),
            icon: const Icon(Icons.near_me_outlined, size: 18),
          ),
          ButtonSegment<SpotPickerSource>(
            value: SpotPickerSource.liked,
            label: Text(l10n.communitySpotPickerSourceLiked),
            icon: const Icon(Icons.favorite_border, size: 18),
          ),
        ],
        selected: <SpotPickerSource>{selected},
        showSelectedIcon: false,
        onSelectionChanged: (Set<SpotPickerSource> next) =>
            ref.read(spotPickerSourceTabProvider.notifier).set(next.first),
      ),
    );
  }
}

/// 주변 장소 목록. 로딩·위치 실패·조회 실패·빈 목록·필터 미일치가 **서로 다른
/// 상태**다 — 사용자가 할 일이 각각 다르기 때문이다.
class _NearbySpotList extends ConsumerWidget {
  const _NearbySpotList({required this.query});

  final String query;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final AsyncValue<NearbySpotsState> state = ref.watch(
      nearbySpotsControllerProvider,
    );

    return state.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (Object error, _) => _SheetMessage(
        // 위치 실패는 조회 실패와 사유가 다르다.
        text: error is LocationUnavailable
            ? l10n.communitySpotPickerLocationUnavailable
            : l10n.communitySpotPickerFailed,
        onRetry: () => ref.invalidate(nearbySpotsControllerProvider),
      ),
      data: (NearbySpotsState data) {
        if (data.isEmpty) {
          return _SheetMessage(text: l10n.communitySpotPickerEmpty);
        }
        final List<NearbySpot> visible = data.filtered(query);
        if (visible.isEmpty) {
          return _SheetMessage(text: l10n.communitySpotPickerNoMatch);
        }
        return PaginationListView(
          itemCount: visible.length,
          // 필터로 좁힌 동안에는 더 받지 않는다 — 보이는 것이 몇 건이든 다음
          // 페이지가 그 이름과 맞는다는 보장이 없어 무한히 당기게 된다.
          hasMore: query.trim().isEmpty && data.hasMore,
          isLoadingMore: data.isLoadingMore,
          onLoadMore: () =>
              ref.read(nearbySpotsControllerProvider.notifier).loadMore(),
          itemBuilder: (BuildContext context, int index) =>
              _SpotTile(spot: visible[index]),
        );
      },
    );
  }
}

/// 좋아요한 장소 목록.
///
/// **주변 목록과 상태가 하나 다르다** — 위치 실패가 없다. `likedSpots`는 좌표를
/// 받지 않으므로 위치가 꺼져 있어도 이 탭은 그대로 돈다.
///
/// **빈 목록은 오류가 아니다** — 아직 좋아요한 장소가 없는 계정이므로 재시도를
/// 권하지 않고 그 사실만 알린다.
///
/// 스크롤·추가 로딩은 주변 목록과 같이 공용 `common/pagination`의
/// [PaginationListView]가 담당한다(CLAUDE.md §4).
class _LikedSpotList extends ConsumerWidget {
  const _LikedSpotList({required this.query});

  final String query;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final AsyncValue<LikedSpotsState> state = ref.watch(
      likedSpotsControllerProvider,
    );

    return state.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, _) => _SheetMessage(
        text: l10n.communitySpotPickerLikedFailed,
        onRetry: () => ref.invalidate(likedSpotsControllerProvider),
      ),
      data: (LikedSpotsState data) {
        if (data.isEmpty) {
          return _SheetMessage(text: l10n.communitySpotPickerLikedEmpty);
        }
        final List<NearbySpot> visible = data.filtered(query);
        if (visible.isEmpty) {
          return _SheetMessage(text: l10n.communitySpotPickerLikedNoMatch);
        }
        return PaginationListView(
          itemCount: visible.length,
          // 주변 목록과 같은 규칙 — 필터로 좁힌 동안에는 더 받지 않는다.
          hasMore: query.trim().isEmpty && data.hasMore,
          isLoadingMore: data.isLoadingMore,
          onLoadMore: () =>
              ref.read(likedSpotsControllerProvider.notifier).loadMore(),
          itemBuilder: (BuildContext context, int index) =>
              _SpotTile(spot: visible[index]),
        );
      },
    );
  }
}

/// 장소 한 줄 — 이름과 썸네일, 그리고 거리(주변) 또는 주소(좋아요한 장소).
///
/// **부제가 출처에 따라 갈린다.** `likedSpots`는 좌표를 받지 않아 거리가 없으므로
/// (`distanceMeters == null`) 그 자리에 주소를 그린다. 둘 다 없으면 부제를 아예
/// 그리지 않는다 — 빈 줄을 남기면 줄 높이가 들쭉날쭉해진다.
class _SpotTile extends StatelessWidget {
  const _SpotTile({required this.spot});

  final NearbySpot spot;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final String? subtitle = spot.distanceMeters != null
        ? formatSpotDistance(l10n, spot.distanceMeters!)
        : spot.address;
    return ListTile(
      leading: SizedBox(
        width: 44,
        height: 44,
        child: spot.thumbnailImageUrl == null
            ? const Icon(Icons.place_outlined)
            : ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  spot.thumbnailImageUrl!,
                  fit: BoxFit.cover,
                  // 이미지 하나가 실패해도 줄은 그대로 고를 수 있어야 한다.
                  errorBuilder: (_, _, _) => const Icon(Icons.place_outlined),
                ),
              ),
      ),
      title: Text(spot.title, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: subtitle == null
          ? null
          : Text(subtitle, maxLines: 1, overflow: TextOverflow.ellipsis),
      onTap: () => Navigator.pop(context, SpotPickerChosen(spot)),
    );
  }
}

/// 거리 표시. 1km 미만은 미터로, 그 이상은 소수 한 자리 킬로미터로 — 그 경계에서
/// 사람이 읽는 단위가 바뀐다.
String formatSpotDistance(AppLocalizations l10n, double meters) => meters < 1000
    ? l10n.communitySpotDistanceMeters(meters.round())
    : l10n.communitySpotDistanceKilometers(meters / 1000);

/// 시트 안의 안내 자리. **빈 화면으로 두지 않는다** — 사유를 밝히고, 재시도가
/// 의미 있는 상태면 버튼도 함께 준다.
class _SheetMessage extends StatelessWidget {
  const _SheetMessage({required this.text, this.onRetry});

  final String text;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final ThemeData theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              text,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            if (onRetry != null) ...<Widget>[
              const SizedBox(height: 16),
              FilledButton(
                onPressed: onRetry,
                child: Text(l10n.communityRetry),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
