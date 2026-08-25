import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../common/network/network_retry_policy.dart';
import '../../auth/provider/session_scope.dart';
import '../model/map_relation.dart';
import 'national_map_providers.dart';

part 'relation_providers.g.dart';

/// 한 번에 받아 올 관계 수.
const int _relationPageSize = 30;

/// 내 관계 목록(관계 지도).
///
/// **캐시하지 않는다**(`keepAlive`를 쓰지 않는다). 겹침은 조회 시점에 재계산된
/// 값이라 오래 들고 있으면 낡는다 — 화면을 다시 열면 새 숫자가 나와야 한다
/// (사용자 결정, 2026-08-22).
///
/// 로그아웃하면 비운다 — 남의 관계 목록이 다음 사용자에게 보이면 안 된다.
@Riverpod(retry: defaultNetworkRetry)
class MapRelations extends _$MapRelations {
  @override
  Future<MapRelationPage> build() async {
    if (!ref.watchSignedIn()) {
      return const MapRelationPage(relations: <MapRelation>[], hasMore: false);
    }
    return ref
        .read(nationalMapRepositoryProvider)
        .fetchRelations(first: _relationPageSize);
  }

  /// 다음 페이지를 뒤에 붙인다. 더 없으면 아무 일도 하지 않는다.
  Future<void> loadMore() async {
    final MapRelationPage? current = state.value;
    if (current == null || !current.hasMore || current.endCursor == null) {
      return;
    }

    final MapRelationPage next = await ref
        .read(nationalMapRepositoryProvider)
        .fetchRelations(first: _relationPageSize, after: current.endCursor);

    state = AsyncData<MapRelationPage>(
      MapRelationPage(
        relations: <MapRelation>[...current.relations, ...next.relations],
        hasMore: next.hasMore,
        endCursor: next.endCursor,
      ),
    );
  }

  /// 관계를 **내 목록에서만** 지운다(사용자 결정, 2026-08-22).
  ///
  /// 목록에서 먼저 빼고 요청한다 — 실패하면 되돌린다.
  Future<void> remove(String memberId) async {
    final MapRelationPage? current = state.value;
    if (current == null) return;

    state = AsyncData<MapRelationPage>(
      MapRelationPage(
        relations: <MapRelation>[
          for (final MapRelation r in current.relations)
            if (r.memberId != memberId) r,
        ],
        hasMore: current.hasMore,
        endCursor: current.endCursor,
      ),
    );

    try {
      await ref.read(nationalMapRepositoryProvider).removeRelation(memberId);
    } on Object {
      state = AsyncData<MapRelationPage>(current);
      rethrow;
    }
  }
}

/// 공유 링크로 관계를 맺는다.
///
/// 성공하면 [MapRelations]를 무효화해 목록을 다시 받는다 — 새로 맺은 상대의
/// 겹침 수는 서버가 계산해 주므로 클라이언트가 만들어 낼 수 없다.
@riverpod
class RelationRegistration extends _$RelationRegistration {
  @override
  bool build() => false; // 등록이 도는 중인지

  /// [shareUrl]은 서버가 준 것을 **그대로** 넘긴다. 토큰 추출은 서버가 한다.
  Future<void> register(String shareUrl) async {
    state = true;
    try {
      await ref.read(nationalMapRepositoryProvider).createRelation(shareUrl);
      ref.invalidate(mapRelationsProvider);
    } finally {
      state = false;
    }
  }
}

/// 이 공유 지도의 주인이 이미 내 관계 목록에 있는지.
///
/// 「등록」 버튼을 「등록됨」으로 바꿀 때 쓴다. 목록을 아직 못 받았으면 false다 —
/// 모르는 동안 「등록됨」으로 보이는 것보다 한 번 더 눌리는 편이 낫다(멱등이라
/// 다시 눌러도 안전하다).
@riverpod
bool isRelatedNickname(Ref ref, String nickname) {
  final MapRelationPage? page = ref.watch(mapRelationsProvider).value;
  if (page == null) return false;
  return page.relations.any((MapRelation r) => r.nickname == nickname);
}
