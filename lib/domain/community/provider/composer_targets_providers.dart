import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../common/location/coordinates.dart';
import '../../../common/location/location_providers.dart';
import '../../../common/pagination/page.dart';
import '../model/post.dart';
import '../model/post_target.dart';
import 'community_providers.dart';

part 'composer_targets_providers.g.dart';

/// 컴포저에서 고를 수 있는 주변 대상(관광지) 목록.
///
/// **왜 spot 도메인을 쓰지 않는가.** 관광지 검색·좋아요 목록은 `domain/spot`에 있지만
/// 커뮤니티가 그것을 import하면 기능 간 의존이 생긴다(CLAUDE.md §3 — 교차 import
/// 금지). 그렇다고 공용으로 끌어올릴 만큼 둘이 공유하는 것도 아니다.
///
/// 그래서 **커뮤니티가 이미 가진 데이터로 목록을 만든다**: 주변 글들의
/// [PostTarget]을 모아 중복을 없앤 것이다. "사람들이 글을 쓰고 있는 근처 장소"라
/// 컴포저의 선택지로도 자연스럽다.
///
/// 한계는 분명하다 — **글이 하나도 없는 장소는 고를 수 없다.** 지금 서버는 커넥션
/// 조회가 깨져 있어(피드가 오류 상태) 이 목록도 비는데, 그때 컴포저는 대상을
/// 고를 수 없다는 사실을 화면에 드러낸다. 관광지 검색이 필요해지면 그 시점에
/// `common/`으로 올릴 대상을 정하는 것이 순서다.
@Riverpod(retry: communityRetryPolicy)
Future<List<PostTarget>> composerTargets(Ref ref) async {
  final Coordinates coords = await ref.watch(currentCoordinatesProvider.future);
  final CursorPage<Post> page = await ref
      .watch(communityRepositoryProvider)
      .fetchNearbyPosts(
        latitude: coords.latitude,
        longitude: coords.longitude,
        // 선택지를 넉넉히 확보하려고 한 장을 크게 받는다. 상한 50을 넘겨도 오류가
        // 아니라 잘린다(가이드 §5).
        first: 50,
      );

  final Map<String, PostTarget> unique = <String, PostTarget>{};
  for (final Post post in page.items) {
    unique.putIfAbsent(post.target.id, () => post.target);
  }
  return unique.values.toList(growable: false);
}
