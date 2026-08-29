import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/location/coordinates.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../component/region_card.dart';
import '../component/region_recommendation_about_sheet.dart';
import '../component/region_recommendation_empty_state.dart';
import '../component/region_recommendation_error_state.dart';
import '../component/region_recommendation_location_state.dart';
import '../model/region_recommendation.dart';
import '../provider/region_recommendation_provider.dart';

/// 지역 추천 목록(SPEC-0015).
///
/// **지도 위 오버레이가 아니라 별도 라우트의 전체 화면이다**(디자인 §화면 구조).
/// 카드가 여러 장 쌓이고 스크롤이 필요해 `AreaInfoCard`처럼 지도 하단에 얹는 형태로는
/// 담기지 않는다.
///
/// 지역을 고르면 그 좌표를 **돌려주고 닫는다**. 여기서 직접 카메라를 움직이지 않는
/// 이유는 지도 컨트롤러를 지도 화면이 소유하기 때문이다 — 검색 화면이 고른 장소를
/// 돌려주는 것(`pick=1`)과 같은 규약이라 지도 쪽 이동 경로가 하나로 유지된다.
class RegionRecommendationScreen extends ConsumerStatefulWidget {
  const RegionRecommendationScreen({this.mapCenter, super.key});

  /// 지도가 보고 있던 중심 좌표. 지도를 거치지 않고 들어오면 null이다.
  final Coordinates? mapCenter;

  static String get routeName => 'region-recommendations';

  @override
  ConsumerState<RegionRecommendationScreen> createState() =>
      _RegionRecommendationScreenState();
}

class _RegionRecommendationScreenState
    extends ConsumerState<RegionRecommendationScreen> {
  /// 지도 중심을 기준으로 볼 것인가. false면 내 위치다.
  ///
  /// **기본은 내 위치다.** 서버가 "지금 있는 곳 근처"를 답하도록 설계돼 있고, 지도를
  /// 옮겨 둔 채 화면을 열었더라도 사용자가 먼저 기대하는 것은 자기 주변이다.
  bool _useMapCenter = false;

  /// 이번 조회의 기준 좌표. null이면 provider가 내 위치를 얻는다.
  Coordinates? get _origin => _useMapCenter ? widget.mapCenter : null;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final AsyncValue<RegionRecommendationResult> state = ref.watch(
      regionRecommendationsProvider(_origin),
    );

    return Scaffold(
      appBar: AppBar(
        // 제목 오른쪽 위에 작은 물음표를 붙인다(사용자 결정, 2026-08-12) —
        // 각주처럼 읽혀 "이 화면이 무엇인지"에 바로 이어진다.
        title: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // **제목이 기준을 말한다**(사용자 지적 2026-08-29).
            //
            // 두 기준(내 위치 / 지도 중심)이 제목은 "추천 지역"으로 같아서,
            // 화면만 봐서는 무엇을 기준으로 한 추천인지 알 수 없었다. 기준은
            // 우측 아이콘의 툴팁에만 있었는데 툴팁은 길게 눌러야 나온다.
            //
            // 토글이 없을 때(지도를 거치지 않고 들어왔을 때)는 기준이 하나뿐이라
            // 굳이 밝히지 않는다 — 고를 것이 없는데 "내 위치 기준"이라고 적으면
            // 다른 기준이 있는 것처럼 읽힌다.
            Text(
              widget.mapCenter == null
                  ? l10n.mapRegionRecommendationsTitle
                  : _useMapCenter
                  ? l10n.mapRegionRecommendationsTitleMapCenter
                  : l10n.mapRegionRecommendationsTitleMyLocation,
            ),
            const SizedBox(width: 2),
            // 제목 글자 높이 안에서 위로 올려 붙인다.
            Transform.translate(
              offset: const Offset(0, -6),
              child: InkResponse(
                onTap: () => showRegionRecommendationAbout(context),
                radius: 18,
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Icon(
                    Icons.help_outline,
                    size: 15,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),
          ],
        ),
        actions: <Widget>[
          // 기준 위치 토글(사용자 요청 — 아이콘 하나로). **지도를 거쳐 들어왔을
          // 때만 띄운다** — 지도 중심을 모르면 고를 것이 하나뿐이다.
          //
          // 아이콘은 **지금 무엇을 기준으로 보고 있는지**를 가리킨다. 누르면 다른
          // 기준으로 바뀌며, 어느 쪽인지는 툴팁이 말한다 — 아이콘만으로는 그것이
          // 현재 상태인지 누르면 될 상태인지 읽히지 않기 때문이다.
          if (widget.mapCenter != null)
            IconButton(
              onPressed: () => setState(() => _useMapCenter = !_useMapCenter),
              icon: Icon(
                _useMapCenter ? Icons.map_outlined : Icons.my_location,
                // 앱의 강조색(코랄)을 쓴다 — 지도 화면의 컨트롤 버튼들과 같은 색이라
                // "지도를 어디로 볼 것인가"를 다루는 조작으로 함께 읽힌다.
                color: Theme.of(context).colorScheme.primary,
              ),
              tooltip: _useMapCenter
                  ? l10n.mapRegionRecommendationsOriginMapCenter
                  : l10n.mapRegionRecommendationsOriginMyLocation,
            ),
        ],
      ),
      body: SafeArea(
        child: state.when(
          // 앱의 다른 목록 화면(찜·커뮤니티·숨긴 글)과 같은 중앙 스피너를 쓴다.
          // 이 화면만 스켈레톤을 두면 로딩 모양이 화면마다 달라진다(디자인 §6).
          loading: () => const Center(child: CircularProgressIndicator()),
          // **위치 부재를 일반 오류와 가른다**(설계 §9.3). 서버가 origin을 필수로
          // 두어 좌표 없이는 조회 자체가 불가능한데, 이것을 실패로 그리면 사용자가
          // 재시도만 반복한다 — 권한이 유일한 해결이다.
          error: (Object error, _) => error is RegionRecommendationNeedsLocation
              ? const RegionRecommendationLocationState()
              : _ErrorBody(origin: _origin),
          data: (RegionRecommendationResult result) => result.isEmpty
              // **빈 결과를 오류로 그리지 않는다**(R15 · §5.1). 재시도 버튼도 두지
              // 않는다 — 몇 번을 눌러도 같은 결과다.
              ? const RegionRecommendationEmptyState()
              : _RegionList(result: result),
        ),
      ),
    );
  }
}

/// 추천 목록. 총점 내림차순 그대로 그린다 — 화면이 다시 정렬하지 않는다(R22).
class _RegionList extends StatelessWidget {
  const _RegionList({required this.result});

  final RegionRecommendationResult result;

  @override
  Widget build(BuildContext context) => ListView.separated(
    padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
    // **정렬 안내 칩을 두지 않는다**(사용자 결정, 2026-08-12). 목록이 순위대로
    // 번호가 매겨져 있어 "무엇 순인지"는 이미 드러나고, 자세한 기준은 앱바의 산출
    // 근거 고지가 설명한다.
    itemCount: result.regions.length,
    separatorBuilder: (_, _) => const SizedBox(height: 12),
    itemBuilder: (BuildContext context, int index) {
      final RegionRecommendation region = result.regions[index];
      return RegionCard(
        region: region,
        rank: index + 1,
        origin: result.origin,
        onTap: () => Navigator.of(context).pop(
          Coordinates(latitude: region.centerLat, longitude: region.centerLng),
        ),
      );
    },
  );
}

/// 오류 + 재시도. 상한을 센 뒤 조회를 다시 연다.
///
/// **횟수는 provider가 아니라 별도 카운터가 센다**(provider 주석 참조) — 조회
/// provider의 생명주기에 횟수를 얹으면 "몇 번 조회됐나"가 구독 상태에 따라 달라진다.
class _ErrorBody extends ConsumerWidget {
  const _ErrorBody({required this.origin});

  final Coordinates? origin;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // **상태를 watch하고 notifier는 read한다.** 남은 횟수가 0이 되면 버튼이 사라져야
    // 하므로 다시 그려질 계기가 필요하고, 그 계기는 notifier가 아니라 state다.
    ref.watch(regionRecommendationRetryCountProvider);
    final RegionRecommendationRetryCount counter = ref.read(
      regionRecommendationRetryCountProvider.notifier,
    );

    return RegionRecommendationErrorState(
      canRetry: counter.canRetry,
      onRetry: () {
        if (!counter.canRetry) return;
        counter.record();
        ref.invalidate(regionRecommendationsProvider(origin));
      },
    );
  }
}
