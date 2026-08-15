// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, unused_element
import 'package:gql/ast.dart';

class Variables$Query$OngoingFestivals {
  factory Variables$Query$OngoingFestivals({
    required double latitude,
    required double longitude,
    int? radiusMeters,
    bool? hasOrigin,
    int? first,
    String? after,
  }) => Variables$Query$OngoingFestivals._({
    r'latitude': latitude,
    r'longitude': longitude,
    if (radiusMeters != null) r'radiusMeters': radiusMeters,
    if (hasOrigin != null) r'hasOrigin': hasOrigin,
    if (first != null) r'first': first,
    if (after != null) r'after': after,
  });

  Variables$Query$OngoingFestivals._(this._$data);

  factory Variables$Query$OngoingFestivals.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$latitude = data['latitude'];
    result$data['latitude'] = (l$latitude as num).toDouble();
    final l$longitude = data['longitude'];
    result$data['longitude'] = (l$longitude as num).toDouble();
    if (data.containsKey('radiusMeters')) {
      final l$radiusMeters = data['radiusMeters'];
      result$data['radiusMeters'] = (l$radiusMeters as int?);
    }
    if (data.containsKey('hasOrigin')) {
      final l$hasOrigin = data['hasOrigin'];
      result$data['hasOrigin'] = (l$hasOrigin as bool?);
    }
    if (data.containsKey('first')) {
      final l$first = data['first'];
      result$data['first'] = (l$first as int?);
    }
    if (data.containsKey('after')) {
      final l$after = data['after'];
      result$data['after'] = (l$after as String?);
    }
    return Variables$Query$OngoingFestivals._(result$data);
  }

  Map<String, dynamic> _$data;

  double get latitude => (_$data['latitude'] as double);

  double get longitude => (_$data['longitude'] as double);

  int? get radiusMeters => (_$data['radiusMeters'] as int?);

  bool? get hasOrigin => (_$data['hasOrigin'] as bool?);

  int? get first => (_$data['first'] as int?);

  String? get after => (_$data['after'] as String?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$latitude = latitude;
    result$data['latitude'] = l$latitude;
    final l$longitude = longitude;
    result$data['longitude'] = l$longitude;
    if (_$data.containsKey('radiusMeters')) {
      final l$radiusMeters = radiusMeters;
      result$data['radiusMeters'] = l$radiusMeters;
    }
    if (_$data.containsKey('hasOrigin')) {
      final l$hasOrigin = hasOrigin;
      result$data['hasOrigin'] = l$hasOrigin;
    }
    if (_$data.containsKey('first')) {
      final l$first = first;
      result$data['first'] = l$first;
    }
    if (_$data.containsKey('after')) {
      final l$after = after;
      result$data['after'] = l$after;
    }
    return result$data;
  }

  CopyWith$Variables$Query$OngoingFestivals<Variables$Query$OngoingFestivals>
  get copyWith => CopyWith$Variables$Query$OngoingFestivals(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Query$OngoingFestivals ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$latitude = latitude;
    final lOther$latitude = other.latitude;
    if (l$latitude != lOther$latitude) {
      return false;
    }
    final l$longitude = longitude;
    final lOther$longitude = other.longitude;
    if (l$longitude != lOther$longitude) {
      return false;
    }
    final l$radiusMeters = radiusMeters;
    final lOther$radiusMeters = other.radiusMeters;
    if (_$data.containsKey('radiusMeters') !=
        other._$data.containsKey('radiusMeters')) {
      return false;
    }
    if (l$radiusMeters != lOther$radiusMeters) {
      return false;
    }
    final l$hasOrigin = hasOrigin;
    final lOther$hasOrigin = other.hasOrigin;
    if (_$data.containsKey('hasOrigin') !=
        other._$data.containsKey('hasOrigin')) {
      return false;
    }
    if (l$hasOrigin != lOther$hasOrigin) {
      return false;
    }
    final l$first = first;
    final lOther$first = other.first;
    if (_$data.containsKey('first') != other._$data.containsKey('first')) {
      return false;
    }
    if (l$first != lOther$first) {
      return false;
    }
    final l$after = after;
    final lOther$after = other.after;
    if (_$data.containsKey('after') != other._$data.containsKey('after')) {
      return false;
    }
    if (l$after != lOther$after) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$latitude = latitude;
    final l$longitude = longitude;
    final l$radiusMeters = radiusMeters;
    final l$hasOrigin = hasOrigin;
    final l$first = first;
    final l$after = after;
    return Object.hashAll([
      l$latitude,
      l$longitude,
      _$data.containsKey('radiusMeters') ? l$radiusMeters : const {},
      _$data.containsKey('hasOrigin') ? l$hasOrigin : const {},
      _$data.containsKey('first') ? l$first : const {},
      _$data.containsKey('after') ? l$after : const {},
    ]);
  }
}

abstract class CopyWith$Variables$Query$OngoingFestivals<TRes> {
  factory CopyWith$Variables$Query$OngoingFestivals(
    Variables$Query$OngoingFestivals instance,
    TRes Function(Variables$Query$OngoingFestivals) then,
  ) = _CopyWithImpl$Variables$Query$OngoingFestivals;

  factory CopyWith$Variables$Query$OngoingFestivals.stub(TRes res) =
      _CopyWithStubImpl$Variables$Query$OngoingFestivals;

  TRes call({
    double? latitude,
    double? longitude,
    int? radiusMeters,
    bool? hasOrigin,
    int? first,
    String? after,
  });
}

class _CopyWithImpl$Variables$Query$OngoingFestivals<TRes>
    implements CopyWith$Variables$Query$OngoingFestivals<TRes> {
  _CopyWithImpl$Variables$Query$OngoingFestivals(this._instance, this._then);

  final Variables$Query$OngoingFestivals _instance;

  final TRes Function(Variables$Query$OngoingFestivals) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? latitude = _undefined,
    Object? longitude = _undefined,
    Object? radiusMeters = _undefined,
    Object? hasOrigin = _undefined,
    Object? first = _undefined,
    Object? after = _undefined,
  }) => _then(
    Variables$Query$OngoingFestivals._({
      ..._instance._$data,
      if (latitude != _undefined && latitude != null)
        'latitude': (latitude as double),
      if (longitude != _undefined && longitude != null)
        'longitude': (longitude as double),
      if (radiusMeters != _undefined) 'radiusMeters': (radiusMeters as int?),
      if (hasOrigin != _undefined) 'hasOrigin': (hasOrigin as bool?),
      if (first != _undefined) 'first': (first as int?),
      if (after != _undefined) 'after': (after as String?),
    }),
  );
}

class _CopyWithStubImpl$Variables$Query$OngoingFestivals<TRes>
    implements CopyWith$Variables$Query$OngoingFestivals<TRes> {
  _CopyWithStubImpl$Variables$Query$OngoingFestivals(this._res);

  TRes _res;

  call({
    double? latitude,
    double? longitude,
    int? radiusMeters,
    bool? hasOrigin,
    int? first,
    String? after,
  }) => _res;
}

class Query$OngoingFestivals {
  Query$OngoingFestivals({required this.ongoingFestivals});

  factory Query$OngoingFestivals.fromJson(Map<String, dynamic> json) {
    final l$ongoingFestivals = json['ongoingFestivals'];
    return Query$OngoingFestivals(
      ongoingFestivals: Query$OngoingFestivals$ongoingFestivals.fromJson(
        (l$ongoingFestivals as Map<String, dynamic>),
      ),
    );
  }

  final Query$OngoingFestivals$ongoingFestivals ongoingFestivals;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$ongoingFestivals = ongoingFestivals;
    _resultData['ongoingFestivals'] = l$ongoingFestivals.toJson();
    return _resultData;
  }

  @override
  int get hashCode {
    final l$ongoingFestivals = ongoingFestivals;
    return Object.hashAll([l$ongoingFestivals]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$OngoingFestivals || runtimeType != other.runtimeType) {
      return false;
    }
    final l$ongoingFestivals = ongoingFestivals;
    final lOther$ongoingFestivals = other.ongoingFestivals;
    if (l$ongoingFestivals != lOther$ongoingFestivals) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Query$OngoingFestivals on Query$OngoingFestivals {
  CopyWith$Query$OngoingFestivals<Query$OngoingFestivals> get copyWith =>
      CopyWith$Query$OngoingFestivals(this, (i) => i);
}

abstract class CopyWith$Query$OngoingFestivals<TRes> {
  factory CopyWith$Query$OngoingFestivals(
    Query$OngoingFestivals instance,
    TRes Function(Query$OngoingFestivals) then,
  ) = _CopyWithImpl$Query$OngoingFestivals;

  factory CopyWith$Query$OngoingFestivals.stub(TRes res) =
      _CopyWithStubImpl$Query$OngoingFestivals;

  TRes call({Query$OngoingFestivals$ongoingFestivals? ongoingFestivals});
  CopyWith$Query$OngoingFestivals$ongoingFestivals<TRes> get ongoingFestivals;
}

class _CopyWithImpl$Query$OngoingFestivals<TRes>
    implements CopyWith$Query$OngoingFestivals<TRes> {
  _CopyWithImpl$Query$OngoingFestivals(this._instance, this._then);

  final Query$OngoingFestivals _instance;

  final TRes Function(Query$OngoingFestivals) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? ongoingFestivals = _undefined}) => _then(
    Query$OngoingFestivals(
      ongoingFestivals:
          ongoingFestivals == _undefined || ongoingFestivals == null
          ? _instance.ongoingFestivals
          : (ongoingFestivals as Query$OngoingFestivals$ongoingFestivals),
    ),
  );

  CopyWith$Query$OngoingFestivals$ongoingFestivals<TRes> get ongoingFestivals {
    final local$ongoingFestivals = _instance.ongoingFestivals;
    return CopyWith$Query$OngoingFestivals$ongoingFestivals(
      local$ongoingFestivals,
      (e) => call(ongoingFestivals: e),
    );
  }
}

class _CopyWithStubImpl$Query$OngoingFestivals<TRes>
    implements CopyWith$Query$OngoingFestivals<TRes> {
  _CopyWithStubImpl$Query$OngoingFestivals(this._res);

  TRes _res;

  call({Query$OngoingFestivals$ongoingFestivals? ongoingFestivals}) => _res;

  CopyWith$Query$OngoingFestivals$ongoingFestivals<TRes> get ongoingFestivals =>
      CopyWith$Query$OngoingFestivals$ongoingFestivals.stub(_res);
}

const documentNodeQueryOngoingFestivals = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'OngoingFestivals'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'latitude')),
          type: NamedTypeNode(name: NameNode(value: 'Float'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'longitude')),
          type: NamedTypeNode(name: NameNode(value: 'Float'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'radiusMeters')),
          type: NamedTypeNode(name: NameNode(value: 'Int'), isNonNull: false),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'hasOrigin')),
          type: NamedTypeNode(
            name: NameNode(value: 'Boolean'),
            isNonNull: false,
          ),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'first')),
          type: NamedTypeNode(name: NameNode(value: 'Int'), isNonNull: false),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'after')),
          type: NamedTypeNode(
            name: NameNode(value: 'String'),
            isNonNull: false,
          ),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
      ],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'ongoingFestivals'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'latitude'),
                value: VariableNode(name: NameNode(value: 'latitude')),
              ),
              ArgumentNode(
                name: NameNode(value: 'longitude'),
                value: VariableNode(name: NameNode(value: 'longitude')),
              ),
              ArgumentNode(
                name: NameNode(value: 'radiusMeters'),
                value: VariableNode(name: NameNode(value: 'radiusMeters')),
              ),
              ArgumentNode(
                name: NameNode(value: 'hasOrigin'),
                value: VariableNode(name: NameNode(value: 'hasOrigin')),
              ),
              ArgumentNode(
                name: NameNode(value: 'first'),
                value: VariableNode(name: NameNode(value: 'first')),
              ),
              ArgumentNode(
                name: NameNode(value: 'after'),
                value: VariableNode(name: NameNode(value: 'after')),
              ),
            ],
            directives: [],
            selectionSet: SelectionSetNode(
              selections: [
                FieldNode(
                  name: NameNode(value: 'edges'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: SelectionSetNode(
                    selections: [
                      FieldNode(
                        name: NameNode(value: 'node'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: SelectionSetNode(
                          selections: [
                            FieldNode(
                              name: NameNode(value: 'id'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null,
                            ),
                            FieldNode(
                              name: NameNode(value: 'title'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null,
                            ),
                            FieldNode(
                              name: NameNode(value: 'address'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null,
                            ),
                            FieldNode(
                              name: NameNode(value: 'thumbnailImageUrl'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null,
                            ),
                            FieldNode(
                              name: NameNode(value: 'distanceMeters'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null,
                            ),
                            FieldNode(
                              name: NameNode(value: 'attributionText'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null,
                            ),
                            FieldNode(
                              name: NameNode(value: 'eventStartDate'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null,
                            ),
                            FieldNode(
                              name: NameNode(value: 'eventEndDate'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null,
                            ),
                          ],
                        ),
                      ),
                      FieldNode(
                        name: NameNode(value: 'cursor'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                    ],
                  ),
                ),
                FieldNode(
                  name: NameNode(value: 'pageInfo'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: SelectionSetNode(
                    selections: [
                      FieldNode(
                        name: NameNode(value: 'hasNextPage'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'endCursor'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  ],
);

class Query$OngoingFestivals$ongoingFestivals {
  Query$OngoingFestivals$ongoingFestivals({
    required this.edges,
    required this.pageInfo,
  });

  factory Query$OngoingFestivals$ongoingFestivals.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$edges = json['edges'];
    final l$pageInfo = json['pageInfo'];
    return Query$OngoingFestivals$ongoingFestivals(
      edges: (l$edges as List<dynamic>)
          .map(
            (e) => Query$OngoingFestivals$ongoingFestivals$edges.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      pageInfo: Query$OngoingFestivals$ongoingFestivals$pageInfo.fromJson(
        (l$pageInfo as Map<String, dynamic>),
      ),
    );
  }

  final List<Query$OngoingFestivals$ongoingFestivals$edges> edges;

  final Query$OngoingFestivals$ongoingFestivals$pageInfo pageInfo;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$edges = edges;
    _resultData['edges'] = l$edges.map((e) => e.toJson()).toList();
    final l$pageInfo = pageInfo;
    _resultData['pageInfo'] = l$pageInfo.toJson();
    return _resultData;
  }

  @override
  int get hashCode {
    final l$edges = edges;
    final l$pageInfo = pageInfo;
    return Object.hashAll([Object.hashAll(l$edges.map((v) => v)), l$pageInfo]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$OngoingFestivals$ongoingFestivals ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$edges = edges;
    final lOther$edges = other.edges;
    if (l$edges.length != lOther$edges.length) {
      return false;
    }
    for (int i = 0; i < l$edges.length; i++) {
      final l$edges$entry = l$edges[i];
      final lOther$edges$entry = lOther$edges[i];
      if (l$edges$entry != lOther$edges$entry) {
        return false;
      }
    }
    final l$pageInfo = pageInfo;
    final lOther$pageInfo = other.pageInfo;
    if (l$pageInfo != lOther$pageInfo) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Query$OngoingFestivals$ongoingFestivals
    on Query$OngoingFestivals$ongoingFestivals {
  CopyWith$Query$OngoingFestivals$ongoingFestivals<
    Query$OngoingFestivals$ongoingFestivals
  >
  get copyWith =>
      CopyWith$Query$OngoingFestivals$ongoingFestivals(this, (i) => i);
}

abstract class CopyWith$Query$OngoingFestivals$ongoingFestivals<TRes> {
  factory CopyWith$Query$OngoingFestivals$ongoingFestivals(
    Query$OngoingFestivals$ongoingFestivals instance,
    TRes Function(Query$OngoingFestivals$ongoingFestivals) then,
  ) = _CopyWithImpl$Query$OngoingFestivals$ongoingFestivals;

  factory CopyWith$Query$OngoingFestivals$ongoingFestivals.stub(TRes res) =
      _CopyWithStubImpl$Query$OngoingFestivals$ongoingFestivals;

  TRes call({
    List<Query$OngoingFestivals$ongoingFestivals$edges>? edges,
    Query$OngoingFestivals$ongoingFestivals$pageInfo? pageInfo,
  });
  TRes edges(
    Iterable<Query$OngoingFestivals$ongoingFestivals$edges> Function(
      Iterable<
        CopyWith$Query$OngoingFestivals$ongoingFestivals$edges<
          Query$OngoingFestivals$ongoingFestivals$edges
        >
      >,
    )
    _fn,
  );
  CopyWith$Query$OngoingFestivals$ongoingFestivals$pageInfo<TRes> get pageInfo;
}

class _CopyWithImpl$Query$OngoingFestivals$ongoingFestivals<TRes>
    implements CopyWith$Query$OngoingFestivals$ongoingFestivals<TRes> {
  _CopyWithImpl$Query$OngoingFestivals$ongoingFestivals(
    this._instance,
    this._then,
  );

  final Query$OngoingFestivals$ongoingFestivals _instance;

  final TRes Function(Query$OngoingFestivals$ongoingFestivals) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? edges = _undefined, Object? pageInfo = _undefined}) =>
      _then(
        Query$OngoingFestivals$ongoingFestivals(
          edges: edges == _undefined || edges == null
              ? _instance.edges
              : (edges as List<Query$OngoingFestivals$ongoingFestivals$edges>),
          pageInfo: pageInfo == _undefined || pageInfo == null
              ? _instance.pageInfo
              : (pageInfo as Query$OngoingFestivals$ongoingFestivals$pageInfo),
        ),
      );

  TRes edges(
    Iterable<Query$OngoingFestivals$ongoingFestivals$edges> Function(
      Iterable<
        CopyWith$Query$OngoingFestivals$ongoingFestivals$edges<
          Query$OngoingFestivals$ongoingFestivals$edges
        >
      >,
    )
    _fn,
  ) => call(
    edges: _fn(
      _instance.edges.map(
        (e) =>
            CopyWith$Query$OngoingFestivals$ongoingFestivals$edges(e, (i) => i),
      ),
    ).toList(),
  );

  CopyWith$Query$OngoingFestivals$ongoingFestivals$pageInfo<TRes> get pageInfo {
    final local$pageInfo = _instance.pageInfo;
    return CopyWith$Query$OngoingFestivals$ongoingFestivals$pageInfo(
      local$pageInfo,
      (e) => call(pageInfo: e),
    );
  }
}

class _CopyWithStubImpl$Query$OngoingFestivals$ongoingFestivals<TRes>
    implements CopyWith$Query$OngoingFestivals$ongoingFestivals<TRes> {
  _CopyWithStubImpl$Query$OngoingFestivals$ongoingFestivals(this._res);

  TRes _res;

  call({
    List<Query$OngoingFestivals$ongoingFestivals$edges>? edges,
    Query$OngoingFestivals$ongoingFestivals$pageInfo? pageInfo,
  }) => _res;

  edges(_fn) => _res;

  CopyWith$Query$OngoingFestivals$ongoingFestivals$pageInfo<TRes>
  get pageInfo =>
      CopyWith$Query$OngoingFestivals$ongoingFestivals$pageInfo.stub(_res);
}

class Query$OngoingFestivals$ongoingFestivals$edges {
  Query$OngoingFestivals$ongoingFestivals$edges({
    required this.node,
    required this.cursor,
  });

  factory Query$OngoingFestivals$ongoingFestivals$edges.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$node = json['node'];
    final l$cursor = json['cursor'];
    return Query$OngoingFestivals$ongoingFestivals$edges(
      node: Query$OngoingFestivals$ongoingFestivals$edges$node.fromJson(
        (l$node as Map<String, dynamic>),
      ),
      cursor: (l$cursor as String),
    );
  }

  final Query$OngoingFestivals$ongoingFestivals$edges$node node;

  final String cursor;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$node = node;
    _resultData['node'] = l$node.toJson();
    final l$cursor = cursor;
    _resultData['cursor'] = l$cursor;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$node = node;
    final l$cursor = cursor;
    return Object.hashAll([l$node, l$cursor]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$OngoingFestivals$ongoingFestivals$edges ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$node = node;
    final lOther$node = other.node;
    if (l$node != lOther$node) {
      return false;
    }
    final l$cursor = cursor;
    final lOther$cursor = other.cursor;
    if (l$cursor != lOther$cursor) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Query$OngoingFestivals$ongoingFestivals$edges
    on Query$OngoingFestivals$ongoingFestivals$edges {
  CopyWith$Query$OngoingFestivals$ongoingFestivals$edges<
    Query$OngoingFestivals$ongoingFestivals$edges
  >
  get copyWith =>
      CopyWith$Query$OngoingFestivals$ongoingFestivals$edges(this, (i) => i);
}

abstract class CopyWith$Query$OngoingFestivals$ongoingFestivals$edges<TRes> {
  factory CopyWith$Query$OngoingFestivals$ongoingFestivals$edges(
    Query$OngoingFestivals$ongoingFestivals$edges instance,
    TRes Function(Query$OngoingFestivals$ongoingFestivals$edges) then,
  ) = _CopyWithImpl$Query$OngoingFestivals$ongoingFestivals$edges;

  factory CopyWith$Query$OngoingFestivals$ongoingFestivals$edges.stub(
    TRes res,
  ) = _CopyWithStubImpl$Query$OngoingFestivals$ongoingFestivals$edges;

  TRes call({
    Query$OngoingFestivals$ongoingFestivals$edges$node? node,
    String? cursor,
  });
  CopyWith$Query$OngoingFestivals$ongoingFestivals$edges$node<TRes> get node;
}

class _CopyWithImpl$Query$OngoingFestivals$ongoingFestivals$edges<TRes>
    implements CopyWith$Query$OngoingFestivals$ongoingFestivals$edges<TRes> {
  _CopyWithImpl$Query$OngoingFestivals$ongoingFestivals$edges(
    this._instance,
    this._then,
  );

  final Query$OngoingFestivals$ongoingFestivals$edges _instance;

  final TRes Function(Query$OngoingFestivals$ongoingFestivals$edges) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? node = _undefined, Object? cursor = _undefined}) => _then(
    Query$OngoingFestivals$ongoingFestivals$edges(
      node: node == _undefined || node == null
          ? _instance.node
          : (node as Query$OngoingFestivals$ongoingFestivals$edges$node),
      cursor: cursor == _undefined || cursor == null
          ? _instance.cursor
          : (cursor as String),
    ),
  );

  CopyWith$Query$OngoingFestivals$ongoingFestivals$edges$node<TRes> get node {
    final local$node = _instance.node;
    return CopyWith$Query$OngoingFestivals$ongoingFestivals$edges$node(
      local$node,
      (e) => call(node: e),
    );
  }
}

class _CopyWithStubImpl$Query$OngoingFestivals$ongoingFestivals$edges<TRes>
    implements CopyWith$Query$OngoingFestivals$ongoingFestivals$edges<TRes> {
  _CopyWithStubImpl$Query$OngoingFestivals$ongoingFestivals$edges(this._res);

  TRes _res;

  call({
    Query$OngoingFestivals$ongoingFestivals$edges$node? node,
    String? cursor,
  }) => _res;

  CopyWith$Query$OngoingFestivals$ongoingFestivals$edges$node<TRes> get node =>
      CopyWith$Query$OngoingFestivals$ongoingFestivals$edges$node.stub(_res);
}

class Query$OngoingFestivals$ongoingFestivals$edges$node {
  Query$OngoingFestivals$ongoingFestivals$edges$node({
    required this.id,
    required this.title,
    this.address,
    required this.thumbnailImageUrl,
    required this.distanceMeters,
    required this.attributionText,
    required this.eventStartDate,
    required this.eventEndDate,
  });

  factory Query$OngoingFestivals$ongoingFestivals$edges$node.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$title = json['title'];
    final l$address = json['address'];
    final l$thumbnailImageUrl = json['thumbnailImageUrl'];
    final l$distanceMeters = json['distanceMeters'];
    final l$attributionText = json['attributionText'];
    final l$eventStartDate = json['eventStartDate'];
    final l$eventEndDate = json['eventEndDate'];
    return Query$OngoingFestivals$ongoingFestivals$edges$node(
      id: (l$id as String),
      title: (l$title as String),
      address: (l$address as String?),
      thumbnailImageUrl: (l$thumbnailImageUrl as String),
      distanceMeters: (l$distanceMeters as num).toDouble(),
      attributionText: (l$attributionText as String),
      eventStartDate: (l$eventStartDate as String),
      eventEndDate: (l$eventEndDate as String),
    );
  }

  final String id;

  final String title;

  final String? address;

  final String thumbnailImageUrl;

  final double distanceMeters;

  final String attributionText;

  final String eventStartDate;

  final String eventEndDate;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$title = title;
    _resultData['title'] = l$title;
    final l$address = address;
    _resultData['address'] = l$address;
    final l$thumbnailImageUrl = thumbnailImageUrl;
    _resultData['thumbnailImageUrl'] = l$thumbnailImageUrl;
    final l$distanceMeters = distanceMeters;
    _resultData['distanceMeters'] = l$distanceMeters;
    final l$attributionText = attributionText;
    _resultData['attributionText'] = l$attributionText;
    final l$eventStartDate = eventStartDate;
    _resultData['eventStartDate'] = l$eventStartDate;
    final l$eventEndDate = eventEndDate;
    _resultData['eventEndDate'] = l$eventEndDate;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$title = title;
    final l$address = address;
    final l$thumbnailImageUrl = thumbnailImageUrl;
    final l$distanceMeters = distanceMeters;
    final l$attributionText = attributionText;
    final l$eventStartDate = eventStartDate;
    final l$eventEndDate = eventEndDate;
    return Object.hashAll([
      l$id,
      l$title,
      l$address,
      l$thumbnailImageUrl,
      l$distanceMeters,
      l$attributionText,
      l$eventStartDate,
      l$eventEndDate,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$OngoingFestivals$ongoingFestivals$edges$node ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$title = title;
    final lOther$title = other.title;
    if (l$title != lOther$title) {
      return false;
    }
    final l$address = address;
    final lOther$address = other.address;
    if (l$address != lOther$address) {
      return false;
    }
    final l$thumbnailImageUrl = thumbnailImageUrl;
    final lOther$thumbnailImageUrl = other.thumbnailImageUrl;
    if (l$thumbnailImageUrl != lOther$thumbnailImageUrl) {
      return false;
    }
    final l$distanceMeters = distanceMeters;
    final lOther$distanceMeters = other.distanceMeters;
    if (l$distanceMeters != lOther$distanceMeters) {
      return false;
    }
    final l$attributionText = attributionText;
    final lOther$attributionText = other.attributionText;
    if (l$attributionText != lOther$attributionText) {
      return false;
    }
    final l$eventStartDate = eventStartDate;
    final lOther$eventStartDate = other.eventStartDate;
    if (l$eventStartDate != lOther$eventStartDate) {
      return false;
    }
    final l$eventEndDate = eventEndDate;
    final lOther$eventEndDate = other.eventEndDate;
    if (l$eventEndDate != lOther$eventEndDate) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Query$OngoingFestivals$ongoingFestivals$edges$node
    on Query$OngoingFestivals$ongoingFestivals$edges$node {
  CopyWith$Query$OngoingFestivals$ongoingFestivals$edges$node<
    Query$OngoingFestivals$ongoingFestivals$edges$node
  >
  get copyWith => CopyWith$Query$OngoingFestivals$ongoingFestivals$edges$node(
    this,
    (i) => i,
  );
}

abstract class CopyWith$Query$OngoingFestivals$ongoingFestivals$edges$node<
  TRes
> {
  factory CopyWith$Query$OngoingFestivals$ongoingFestivals$edges$node(
    Query$OngoingFestivals$ongoingFestivals$edges$node instance,
    TRes Function(Query$OngoingFestivals$ongoingFestivals$edges$node) then,
  ) = _CopyWithImpl$Query$OngoingFestivals$ongoingFestivals$edges$node;

  factory CopyWith$Query$OngoingFestivals$ongoingFestivals$edges$node.stub(
    TRes res,
  ) = _CopyWithStubImpl$Query$OngoingFestivals$ongoingFestivals$edges$node;

  TRes call({
    String? id,
    String? title,
    String? address,
    String? thumbnailImageUrl,
    double? distanceMeters,
    String? attributionText,
    String? eventStartDate,
    String? eventEndDate,
  });
}

class _CopyWithImpl$Query$OngoingFestivals$ongoingFestivals$edges$node<TRes>
    implements
        CopyWith$Query$OngoingFestivals$ongoingFestivals$edges$node<TRes> {
  _CopyWithImpl$Query$OngoingFestivals$ongoingFestivals$edges$node(
    this._instance,
    this._then,
  );

  final Query$OngoingFestivals$ongoingFestivals$edges$node _instance;

  final TRes Function(Query$OngoingFestivals$ongoingFestivals$edges$node) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? title = _undefined,
    Object? address = _undefined,
    Object? thumbnailImageUrl = _undefined,
    Object? distanceMeters = _undefined,
    Object? attributionText = _undefined,
    Object? eventStartDate = _undefined,
    Object? eventEndDate = _undefined,
  }) => _then(
    Query$OngoingFestivals$ongoingFestivals$edges$node(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      title: title == _undefined || title == null
          ? _instance.title
          : (title as String),
      address: address == _undefined ? _instance.address : (address as String?),
      thumbnailImageUrl:
          thumbnailImageUrl == _undefined || thumbnailImageUrl == null
          ? _instance.thumbnailImageUrl
          : (thumbnailImageUrl as String),
      distanceMeters: distanceMeters == _undefined || distanceMeters == null
          ? _instance.distanceMeters
          : (distanceMeters as double),
      attributionText: attributionText == _undefined || attributionText == null
          ? _instance.attributionText
          : (attributionText as String),
      eventStartDate: eventStartDate == _undefined || eventStartDate == null
          ? _instance.eventStartDate
          : (eventStartDate as String),
      eventEndDate: eventEndDate == _undefined || eventEndDate == null
          ? _instance.eventEndDate
          : (eventEndDate as String),
    ),
  );
}

class _CopyWithStubImpl$Query$OngoingFestivals$ongoingFestivals$edges$node<TRes>
    implements
        CopyWith$Query$OngoingFestivals$ongoingFestivals$edges$node<TRes> {
  _CopyWithStubImpl$Query$OngoingFestivals$ongoingFestivals$edges$node(
    this._res,
  );

  TRes _res;

  call({
    String? id,
    String? title,
    String? address,
    String? thumbnailImageUrl,
    double? distanceMeters,
    String? attributionText,
    String? eventStartDate,
    String? eventEndDate,
  }) => _res;
}

class Query$OngoingFestivals$ongoingFestivals$pageInfo {
  Query$OngoingFestivals$ongoingFestivals$pageInfo({
    required this.hasNextPage,
    this.endCursor,
  });

  factory Query$OngoingFestivals$ongoingFestivals$pageInfo.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$hasNextPage = json['hasNextPage'];
    final l$endCursor = json['endCursor'];
    return Query$OngoingFestivals$ongoingFestivals$pageInfo(
      hasNextPage: (l$hasNextPage as bool),
      endCursor: (l$endCursor as String?),
    );
  }

  final bool hasNextPage;

  final String? endCursor;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$hasNextPage = hasNextPage;
    _resultData['hasNextPage'] = l$hasNextPage;
    final l$endCursor = endCursor;
    _resultData['endCursor'] = l$endCursor;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$hasNextPage = hasNextPage;
    final l$endCursor = endCursor;
    return Object.hashAll([l$hasNextPage, l$endCursor]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$OngoingFestivals$ongoingFestivals$pageInfo ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$hasNextPage = hasNextPage;
    final lOther$hasNextPage = other.hasNextPage;
    if (l$hasNextPage != lOther$hasNextPage) {
      return false;
    }
    final l$endCursor = endCursor;
    final lOther$endCursor = other.endCursor;
    if (l$endCursor != lOther$endCursor) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Query$OngoingFestivals$ongoingFestivals$pageInfo
    on Query$OngoingFestivals$ongoingFestivals$pageInfo {
  CopyWith$Query$OngoingFestivals$ongoingFestivals$pageInfo<
    Query$OngoingFestivals$ongoingFestivals$pageInfo
  >
  get copyWith =>
      CopyWith$Query$OngoingFestivals$ongoingFestivals$pageInfo(this, (i) => i);
}

abstract class CopyWith$Query$OngoingFestivals$ongoingFestivals$pageInfo<TRes> {
  factory CopyWith$Query$OngoingFestivals$ongoingFestivals$pageInfo(
    Query$OngoingFestivals$ongoingFestivals$pageInfo instance,
    TRes Function(Query$OngoingFestivals$ongoingFestivals$pageInfo) then,
  ) = _CopyWithImpl$Query$OngoingFestivals$ongoingFestivals$pageInfo;

  factory CopyWith$Query$OngoingFestivals$ongoingFestivals$pageInfo.stub(
    TRes res,
  ) = _CopyWithStubImpl$Query$OngoingFestivals$ongoingFestivals$pageInfo;

  TRes call({bool? hasNextPage, String? endCursor});
}

class _CopyWithImpl$Query$OngoingFestivals$ongoingFestivals$pageInfo<TRes>
    implements CopyWith$Query$OngoingFestivals$ongoingFestivals$pageInfo<TRes> {
  _CopyWithImpl$Query$OngoingFestivals$ongoingFestivals$pageInfo(
    this._instance,
    this._then,
  );

  final Query$OngoingFestivals$ongoingFestivals$pageInfo _instance;

  final TRes Function(Query$OngoingFestivals$ongoingFestivals$pageInfo) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? hasNextPage = _undefined,
    Object? endCursor = _undefined,
  }) => _then(
    Query$OngoingFestivals$ongoingFestivals$pageInfo(
      hasNextPage: hasNextPage == _undefined || hasNextPage == null
          ? _instance.hasNextPage
          : (hasNextPage as bool),
      endCursor: endCursor == _undefined
          ? _instance.endCursor
          : (endCursor as String?),
    ),
  );
}

class _CopyWithStubImpl$Query$OngoingFestivals$ongoingFestivals$pageInfo<TRes>
    implements CopyWith$Query$OngoingFestivals$ongoingFestivals$pageInfo<TRes> {
  _CopyWithStubImpl$Query$OngoingFestivals$ongoingFestivals$pageInfo(this._res);

  TRes _res;

  call({bool? hasNextPage, String? endCursor}) => _res;
}
