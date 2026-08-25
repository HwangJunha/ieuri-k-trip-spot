import 'package:gql/ast.dart' show DocumentNode;
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../../common/network/graphql_debug_log.dart';
import '../../../common/network/graphql_failure.dart';
import '../model/cell_detail.dart';
import '../model/cell_geometry.dart';
import '../model/cell_image.dart';
import '../model/map_cell.dart';
import '../model/map_relation.dart';
import '../model/national_map_failure.dart';
import '../model/shared_map.dart';
import 'national_map_operations.graphql.dart';
import 'national_map_repository.dart';
import 'national_map_schema.graphql.dart';

/// GraphQL 기반 [NationalMapRepository](SPEC-0030). 생성된 `*.graphql.dart`
/// 타입은 이 파일 밖으로 나가지 않는다(CLAUDE.md §3, POL-020).
class NationalMapRepositoryImpl implements NationalMapRepository {
  NationalMapRepositoryImpl(this._client);

  final GraphQLClient _client;

  @override
  Future<List<MapCell>> fetchCells() async {
    final Map<String, dynamic> data = await _query(
      documentNodeQueryMapCells,
      const <String, dynamic>{},
      'mapCells',
    );
    return <MapCell>[
      for (final Fragment$MapCellCore c in Query$MapCells.fromJson(data).mapCells)
        _cell(c),
    ];
  }

  @override
  Future<CellDetail> fetchCellDetail({
    required String cellId,
    int? first,
  }) async {
    final Map<String, dynamic> data = await _query(
      documentNodeQueryMapCellDetail,
      Variables$Query$MapCellDetail(id: cellId, first: first).toJson(),
      'mapCell',
    );
    final Query$MapCellDetail$mapCell cell = Query$MapCellDetail.fromJson(
      data,
    ).mapCell;

    // **커서 연결이 아니라 배열이다**(2026-08-25). `likeCount`가 edge에서
    // `CellSpot` 안으로 옮겨졌고, 이어 읽을 수단이 없어 페이지네이션도 사라졌다.
    return CellDetail(
      cell: _cell(cell, image: _image(cell.representativeImage)),
      spots: <CellSpot>[
        for (final Query$MapCellDetail$mapCell$spots s in cell.spots)
          CellSpot(
            id: s.id,
            title: s.title,
            thumbnailImageUrl: s.thumbnailImageUrl,
            categoryCode: s.category.code,
            categoryLabel: s.category.label,
            lat: s.lat,
            lng: s.lng,
            likeCount: s.likeCount,
          ),
      ],
    );
  }

  @override
  Future<RecordVisitsResult> recordVisits(List<String> districtCodes) async {
    final Map<String, dynamic> data = await _mutate(
      documentNodeMutationRecordVisits,
      Variables$Mutation$RecordVisits(
        input: Input$RecordVisitsInput(districtCodes: districtCodes),
      ).toJson(),
      'recordVisits',
    );
    final Mutation$RecordVisits$recordVisits payload =
        Mutation$RecordVisits.fromJson(data).recordVisits;

    // **부분 성공을 실패로 다루지 않는다.** 없는 코드가 섞여도 나머지는 기록된다.
    final List<String> unknown = <String>[
      for (final Mutation$RecordVisits$recordVisits$userErrors e
          in payload.userErrors)
        if (e.code == 'DISTRICT_NOT_FOUND') e.message,
    ];
    if (!payload.success && payload.updatedCells.isEmpty && unknown.isEmpty) {
      throw NationalMapFailure.network;
    }

    return RecordVisitsResult(
      updatedCells: <MapCell>[
        for (final Fragment$MapCellCore c in payload.updatedCells) _cell(c),
      ],
      unknownDistrictCodes: unknown,
    );
  }

  @override
  Future<MapCell?> removeVisit(String cellId) async {
    final Map<String, dynamic> data = await _mutate(
      documentNodeMutationRemoveVisit,
      Variables$Mutation$RemoveVisit(
        input: Input$RemoveVisitInput(cellId: cellId),
      ).toJson(),
      'removeVisit',
    );
    final Mutation$RemoveVisit$removeVisit payload =
        Mutation$RemoveVisit.fromJson(data).removeVisit;

    _check('removeVisit', payload.success, payload.userErrors.length);
    final Fragment$MapCellCore? updated = payload.updatedCell;
    return updated == null ? null : _cell(updated);
  }

  @override
  Future<MapShareLink> createShareLink() async {
    final Map<String, dynamic> data = await _mutate(
      documentNodeMutationCreateMapShareLink,
      const <String, dynamic>{},
      'createMapShareLink',
    );
    final Mutation$CreateMapShareLink$createMapShareLink payload =
        Mutation$CreateMapShareLink.fromJson(data).createMapShareLink;

    _check('createMapShareLink', payload.success, payload.userErrors.length);
    final Mutation$CreateMapShareLink$createMapShareLink$shareLink? link =
        payload.shareLink;
    if (link == null) throw NationalMapFailure.network;

    return MapShareLink(
      shareUrl: link.shareUrl,
      createdAt: DateTime.tryParse(link.createdAt)?.toLocal() ?? DateTime.now(),
    );
  }

  @override
  Future<void> revokeShareLink(String shareUrl) async {
    final Map<String, dynamic> data = await _mutate(
      documentNodeMutationRevokeMapShareLink,
      Variables$Mutation$RevokeMapShareLink(
        input: Input$RevokeMapShareLinkInput(shareUrl: shareUrl),
      ).toJson(),
      'revokeMapShareLink',
    );
    final Mutation$RevokeMapShareLink$revokeMapShareLink payload =
        Mutation$RevokeMapShareLink.fromJson(data).revokeMapShareLink;
    _check('revokeMapShareLink', payload.success, payload.userErrors.length);
  }

  @override
  Future<SharedMap> fetchSharedMap(String token) async {
    final Map<String, dynamic> data = await _query(
      documentNodeQuerySharedMap,
      Variables$Query$SharedMap(token: token).toJson(),
      'sharedMap',
    );
    final Query$SharedMap$sharedMap m = Query$SharedMap.fromJson(
      data,
    ).sharedMap;

    return SharedMap(
      ownerNickname: m.ownerNickname,
      visitedCellIds: List<String>.unmodifiable(m.visitedCellIds),
      // **null을 빈 목록으로 접지 않는다** — 비인증(비교 불가)과 겹침 없음이
      // 화면에서 다른 문구가 된다.
      overlappingCellIds: m.overlappingCellIds == null
          ? null
          : List<String>.unmodifiable(m.overlappingCellIds!),
      visitedCount: m.visitedCount,
    );
  }

  MapCell _cell(Fragment$MapCellCore c, {CellImage? image}) => MapCell(
    id: c.id,
    districtCodes: List<String>.unmodifiable(c.districtCodes),
    name: c.name,
    provinceName: c.provinceName,
    provinceCode: c.provinceCode,
    visited: c.viewerVisited,
    // 계약이 `[경도, 위도]`가 아니라 이름 있는 필드로 준다 — 순서를 헷갈릴 일이 없다.
    center: GeoPoint(c.center.lng, c.center.lat),
    representativeImage: image,
  );

  CellImage? _image(Fragment$CellImageFields? raw) => raw == null
      ? null
      : CellImage(
          imageUrl: raw.imageUrl,
          thumbnailUrl: raw.thumbnailUrl,
          caption: raw.caption,
          kind: switch (raw.kind) {
            Enum$CellImageKind.LANDMARK => CellImageKind.landmark,
            Enum$CellImageKind.SPECIALTY => CellImageKind.specialty,
            // 모르는 값은 랜드마크로 접는다 — 배지 문구가 달라질 뿐이다.
            Enum$CellImageKind.$unknown => CellImageKind.landmark,
          },
          // **모르는 유형은 UNSPECIFIED로 접는다.** 크롭을 막는 쪽이 안전하다(R23).
          //
          // `CopyrightType`은 spot 조각이 선언한 공용 enum이라 생성 타입이
          // `spot_schema.graphql.dart`에 산다. 그 파일을 import하면 이 도메인이
          // spot의 내부를 참조하게 되므로(§3) 이름 문자열로 맞춘다.
          copyright: switch (raw.copyright.name) {
            'TYPE1' => CellCopyrightType.type1,
            'TYPE3' => CellCopyrightType.type3,
            _ => CellCopyrightType.unspecified,
          },
          attributionText: raw.attributionText,
        );

  /// 뮤테이션 도메인 실패 검사. 코드만 로깅하고(메시지는 PII 가능) 실패를 던진다.
  @override
  Future<MapRelationPage> fetchRelations({int? first, String? after}) async {
    final Map<String, dynamic> data = await _query(
      documentNodeQueryMapRelations,
      Variables$Query$MapRelations(first: first, after: after).toJson(),
      'mapRelations',
    );
    final Query$MapRelations$mapRelations c = Query$MapRelations.fromJson(
      data,
    ).mapRelations;

    return MapRelationPage(
      relations: <MapRelation>[
        for (final Query$MapRelations$mapRelations$edges e in c.edges)
          MapRelation(
            memberId: e.node.memberId,
            nickname: e.node.nickname,
            overlappingCount: e.node.overlappingCount,
            overlappingCellIds: List<String>.unmodifiable(
              e.node.overlappingCellIds,
            ),
            theirVisitedCount: e.node.theirVisitedCount,
          ),
      ],
      hasMore: c.pageInfo.hasNextPage,
      endCursor: c.pageInfo.endCursor,
    );
  }

  @override
  Future<void> createRelation(String shareUrl) async {
    final Map<String, dynamic> data = await _mutate(
      documentNodeMutationCreateMapRelation,
      Variables$Mutation$CreateMapRelation(
        input: Input$CreateMapRelationInput(shareUrl: shareUrl),
      ).toJson(),
      'createMapRelation',
    );
    final Mutation$CreateMapRelation$createMapRelation payload =
        Mutation$CreateMapRelation.fromJson(data).createMapRelation;

    _check('createMapRelation', payload.success, payload.userErrors.length);
  }

  @override
  Future<void> removeRelation(String memberId) async {
    final Map<String, dynamic> data = await _mutate(
      documentNodeMutationRemoveMapRelation,
      Variables$Mutation$RemoveMapRelation(
        input: Input$RemoveMapRelationInput(memberId: memberId),
      ).toJson(),
      'removeMapRelation',
    );
    final Mutation$RemoveMapRelation$removeMapRelation payload =
        Mutation$RemoveMapRelation.fromJson(data).removeMapRelation;

    _check('removeMapRelation', payload.success, payload.userErrors.length);
  }

  void _check(String operation, bool success, int userErrorCount) {
    if (userErrorCount > 0 || !success) {
      GraphqlDebugLog.request(operation, const <String, dynamic>{});
      throw NationalMapFailure.network;
    }
  }

  Future<Map<String, dynamic>> _query(
    DocumentNode document,
    Map<String, dynamic> variables,
    String operation,
  ) => _run(
    () => _client.query(QueryOptions(document: document, variables: variables)),
    operation,
    variables,
  );

  Future<Map<String, dynamic>> _mutate(
    DocumentNode document,
    Map<String, dynamic> variables,
    String operation,
  ) => _run(
    () => _client.mutate(
      MutationOptions(document: document, variables: variables),
    ),
    operation,
    variables,
  );

  Future<Map<String, dynamic>> _run(
    Future<QueryResult<Object?>> Function() call,
    String operation,
    Map<String, dynamic> variables,
  ) async {
    GraphqlDebugLog.request(operation, variables);
    late final QueryResult<Object?> result;
    try {
      result = await call();
    } on Exception catch (error) {
      GraphqlDebugLog.clientThrew(operation, error);
      throw NationalMapFailure.network;
    }

    GraphqlDebugLog.response(operation, result);

    // 범위 판별은 `path`로 한다 — 하위 필드 실패까지 전체 실패로 뭉개지 않는다.
    if (hasRootFailure(result, operation)) {
      GraphqlDebugLog.transportFailure(operation, result);
      throw NationalMapFailure(_rootErrorCode(result, operation));
    }

    final Object? data = result.data;
    if (data is! Map<String, dynamic>) throw NationalMapFailure.network;
    return data;
  }

  String? _rootErrorCode(QueryResult<Object?> result, String rootField) {
    final GraphQLError? error = firstRootError(result, rootField);
    if (error == null) return null;
    final Object? code = error.extensions?['code'];
    return code is String && code.isNotEmpty ? code : null;
  }
}
