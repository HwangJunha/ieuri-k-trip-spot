// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, unused_element
import '../../spot/repository/spot_schema.graphql.dart';
import 'map_schema.graphql.dart';
import 'package:gql/ast.dart';

class Variables$Query$MapViewport {
  factory Variables$Query$MapViewport({
    required Input$MapBoundsInput bbox,
    required int zoom,
    Enum$SpotCategory? category,
  }) => Variables$Query$MapViewport._({
    r'bbox': bbox,
    r'zoom': zoom,
    if (category != null) r'category': category,
  });

  Variables$Query$MapViewport._(this._$data);

  factory Variables$Query$MapViewport.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$bbox = data['bbox'];
    result$data['bbox'] = Input$MapBoundsInput.fromJson(
      (l$bbox as Map<String, dynamic>),
    );
    final l$zoom = data['zoom'];
    result$data['zoom'] = (l$zoom as int);
    if (data.containsKey('category')) {
      final l$category = data['category'];
      result$data['category'] = l$category == null
          ? null
          : fromJson$Enum$SpotCategory((l$category as String));
    }
    return Variables$Query$MapViewport._(result$data);
  }

  Map<String, dynamic> _$data;

  Input$MapBoundsInput get bbox => (_$data['bbox'] as Input$MapBoundsInput);

  int get zoom => (_$data['zoom'] as int);

  Enum$SpotCategory? get category => (_$data['category'] as Enum$SpotCategory?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$bbox = bbox;
    result$data['bbox'] = l$bbox.toJson();
    final l$zoom = zoom;
    result$data['zoom'] = l$zoom;
    if (_$data.containsKey('category')) {
      final l$category = category;
      result$data['category'] = l$category == null
          ? null
          : toJson$Enum$SpotCategory(l$category);
    }
    return result$data;
  }

  CopyWith$Variables$Query$MapViewport<Variables$Query$MapViewport>
  get copyWith => CopyWith$Variables$Query$MapViewport(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Query$MapViewport ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$bbox = bbox;
    final lOther$bbox = other.bbox;
    if (l$bbox != lOther$bbox) {
      return false;
    }
    final l$zoom = zoom;
    final lOther$zoom = other.zoom;
    if (l$zoom != lOther$zoom) {
      return false;
    }
    final l$category = category;
    final lOther$category = other.category;
    if (_$data.containsKey('category') !=
        other._$data.containsKey('category')) {
      return false;
    }
    if (l$category != lOther$category) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$bbox = bbox;
    final l$zoom = zoom;
    final l$category = category;
    return Object.hashAll([
      l$bbox,
      l$zoom,
      _$data.containsKey('category') ? l$category : const {},
    ]);
  }
}

abstract class CopyWith$Variables$Query$MapViewport<TRes> {
  factory CopyWith$Variables$Query$MapViewport(
    Variables$Query$MapViewport instance,
    TRes Function(Variables$Query$MapViewport) then,
  ) = _CopyWithImpl$Variables$Query$MapViewport;

  factory CopyWith$Variables$Query$MapViewport.stub(TRes res) =
      _CopyWithStubImpl$Variables$Query$MapViewport;

  TRes call({
    Input$MapBoundsInput? bbox,
    int? zoom,
    Enum$SpotCategory? category,
  });
}

class _CopyWithImpl$Variables$Query$MapViewport<TRes>
    implements CopyWith$Variables$Query$MapViewport<TRes> {
  _CopyWithImpl$Variables$Query$MapViewport(this._instance, this._then);

  final Variables$Query$MapViewport _instance;

  final TRes Function(Variables$Query$MapViewport) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? bbox = _undefined,
    Object? zoom = _undefined,
    Object? category = _undefined,
  }) => _then(
    Variables$Query$MapViewport._({
      ..._instance._$data,
      if (bbox != _undefined && bbox != null)
        'bbox': (bbox as Input$MapBoundsInput),
      if (zoom != _undefined && zoom != null) 'zoom': (zoom as int),
      if (category != _undefined) 'category': (category as Enum$SpotCategory?),
    }),
  );
}

class _CopyWithStubImpl$Variables$Query$MapViewport<TRes>
    implements CopyWith$Variables$Query$MapViewport<TRes> {
  _CopyWithStubImpl$Variables$Query$MapViewport(this._res);

  TRes _res;

  call({Input$MapBoundsInput? bbox, int? zoom, Enum$SpotCategory? category}) =>
      _res;
}

class Query$MapViewport {
  Query$MapViewport({required this.mapViewport});

  factory Query$MapViewport.fromJson(Map<String, dynamic> json) {
    final l$mapViewport = json['mapViewport'];
    return Query$MapViewport(
      mapViewport: Query$MapViewport$mapViewport.fromJson(
        (l$mapViewport as Map<String, dynamic>),
      ),
    );
  }

  final Query$MapViewport$mapViewport mapViewport;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$mapViewport = mapViewport;
    _resultData['mapViewport'] = l$mapViewport.toJson();
    return _resultData;
  }

  @override
  int get hashCode {
    final l$mapViewport = mapViewport;
    return Object.hashAll([l$mapViewport]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$MapViewport || runtimeType != other.runtimeType) {
      return false;
    }
    final l$mapViewport = mapViewport;
    final lOther$mapViewport = other.mapViewport;
    if (l$mapViewport != lOther$mapViewport) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Query$MapViewport on Query$MapViewport {
  CopyWith$Query$MapViewport<Query$MapViewport> get copyWith =>
      CopyWith$Query$MapViewport(this, (i) => i);
}

abstract class CopyWith$Query$MapViewport<TRes> {
  factory CopyWith$Query$MapViewport(
    Query$MapViewport instance,
    TRes Function(Query$MapViewport) then,
  ) = _CopyWithImpl$Query$MapViewport;

  factory CopyWith$Query$MapViewport.stub(TRes res) =
      _CopyWithStubImpl$Query$MapViewport;

  TRes call({Query$MapViewport$mapViewport? mapViewport});
  CopyWith$Query$MapViewport$mapViewport<TRes> get mapViewport;
}

class _CopyWithImpl$Query$MapViewport<TRes>
    implements CopyWith$Query$MapViewport<TRes> {
  _CopyWithImpl$Query$MapViewport(this._instance, this._then);

  final Query$MapViewport _instance;

  final TRes Function(Query$MapViewport) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? mapViewport = _undefined}) => _then(
    Query$MapViewport(
      mapViewport: mapViewport == _undefined || mapViewport == null
          ? _instance.mapViewport
          : (mapViewport as Query$MapViewport$mapViewport),
    ),
  );

  CopyWith$Query$MapViewport$mapViewport<TRes> get mapViewport {
    final local$mapViewport = _instance.mapViewport;
    return CopyWith$Query$MapViewport$mapViewport(
      local$mapViewport,
      (e) => call(mapViewport: e),
    );
  }
}

class _CopyWithStubImpl$Query$MapViewport<TRes>
    implements CopyWith$Query$MapViewport<TRes> {
  _CopyWithStubImpl$Query$MapViewport(this._res);

  TRes _res;

  call({Query$MapViewport$mapViewport? mapViewport}) => _res;

  CopyWith$Query$MapViewport$mapViewport<TRes> get mapViewport =>
      CopyWith$Query$MapViewport$mapViewport.stub(_res);
}

const documentNodeQueryMapViewport = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'MapViewport'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'bbox')),
          type: NamedTypeNode(
            name: NameNode(value: 'MapBoundsInput'),
            isNonNull: true,
          ),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'zoom')),
          type: NamedTypeNode(name: NameNode(value: 'Int'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'category')),
          type: NamedTypeNode(
            name: NameNode(value: 'SpotCategory'),
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
            name: NameNode(value: 'mapViewport'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'bbox'),
                value: VariableNode(name: NameNode(value: 'bbox')),
              ),
              ArgumentNode(
                name: NameNode(value: 'zoom'),
                value: VariableNode(name: NameNode(value: 'zoom')),
              ),
              ArgumentNode(
                name: NameNode(value: 'category'),
                value: VariableNode(name: NameNode(value: 'category')),
              ),
            ],
            directives: [],
            selectionSet: SelectionSetNode(
              selections: [
                FieldNode(
                  name: NameNode(value: 'spots'),
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
                        name: NameNode(value: 'thumbnailImageUrl'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'category'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'lng'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'lat'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                    ],
                  ),
                ),
                FieldNode(
                  name: NameNode(value: 'clusters'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: SelectionSetNode(
                    selections: [
                      FieldNode(
                        name: NameNode(value: 'centerLng'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'centerLat'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'count'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'dominantCategory'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                    ],
                  ),
                ),
                FieldNode(
                  name: NameNode(value: 'events'),
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
                        name: NameNode(value: 'place'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'period'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'lng'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'lat'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'url'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                    ],
                  ),
                ),
                FieldNode(
                  name: NameNode(value: 'truncated'),
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
);

class Query$MapViewport$mapViewport {
  Query$MapViewport$mapViewport({
    required this.spots,
    required this.clusters,
    required this.events,
    required this.truncated,
  });

  factory Query$MapViewport$mapViewport.fromJson(Map<String, dynamic> json) {
    final l$spots = json['spots'];
    final l$clusters = json['clusters'];
    final l$events = json['events'];
    final l$truncated = json['truncated'];
    return Query$MapViewport$mapViewport(
      spots: (l$spots as List<dynamic>)
          .map(
            (e) => Query$MapViewport$mapViewport$spots.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      clusters: (l$clusters as List<dynamic>)
          .map(
            (e) => Query$MapViewport$mapViewport$clusters.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      events: (l$events as List<dynamic>)
          .map(
            (e) => Query$MapViewport$mapViewport$events.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      truncated: (l$truncated as bool),
    );
  }

  final List<Query$MapViewport$mapViewport$spots> spots;

  final List<Query$MapViewport$mapViewport$clusters> clusters;

  final List<Query$MapViewport$mapViewport$events> events;

  final bool truncated;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$spots = spots;
    _resultData['spots'] = l$spots.map((e) => e.toJson()).toList();
    final l$clusters = clusters;
    _resultData['clusters'] = l$clusters.map((e) => e.toJson()).toList();
    final l$events = events;
    _resultData['events'] = l$events.map((e) => e.toJson()).toList();
    final l$truncated = truncated;
    _resultData['truncated'] = l$truncated;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$spots = spots;
    final l$clusters = clusters;
    final l$events = events;
    final l$truncated = truncated;
    return Object.hashAll([
      Object.hashAll(l$spots.map((v) => v)),
      Object.hashAll(l$clusters.map((v) => v)),
      Object.hashAll(l$events.map((v) => v)),
      l$truncated,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$MapViewport$mapViewport ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$spots = spots;
    final lOther$spots = other.spots;
    if (l$spots.length != lOther$spots.length) {
      return false;
    }
    for (int i = 0; i < l$spots.length; i++) {
      final l$spots$entry = l$spots[i];
      final lOther$spots$entry = lOther$spots[i];
      if (l$spots$entry != lOther$spots$entry) {
        return false;
      }
    }
    final l$clusters = clusters;
    final lOther$clusters = other.clusters;
    if (l$clusters.length != lOther$clusters.length) {
      return false;
    }
    for (int i = 0; i < l$clusters.length; i++) {
      final l$clusters$entry = l$clusters[i];
      final lOther$clusters$entry = lOther$clusters[i];
      if (l$clusters$entry != lOther$clusters$entry) {
        return false;
      }
    }
    final l$events = events;
    final lOther$events = other.events;
    if (l$events.length != lOther$events.length) {
      return false;
    }
    for (int i = 0; i < l$events.length; i++) {
      final l$events$entry = l$events[i];
      final lOther$events$entry = lOther$events[i];
      if (l$events$entry != lOther$events$entry) {
        return false;
      }
    }
    final l$truncated = truncated;
    final lOther$truncated = other.truncated;
    if (l$truncated != lOther$truncated) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Query$MapViewport$mapViewport
    on Query$MapViewport$mapViewport {
  CopyWith$Query$MapViewport$mapViewport<Query$MapViewport$mapViewport>
  get copyWith => CopyWith$Query$MapViewport$mapViewport(this, (i) => i);
}

abstract class CopyWith$Query$MapViewport$mapViewport<TRes> {
  factory CopyWith$Query$MapViewport$mapViewport(
    Query$MapViewport$mapViewport instance,
    TRes Function(Query$MapViewport$mapViewport) then,
  ) = _CopyWithImpl$Query$MapViewport$mapViewport;

  factory CopyWith$Query$MapViewport$mapViewport.stub(TRes res) =
      _CopyWithStubImpl$Query$MapViewport$mapViewport;

  TRes call({
    List<Query$MapViewport$mapViewport$spots>? spots,
    List<Query$MapViewport$mapViewport$clusters>? clusters,
    List<Query$MapViewport$mapViewport$events>? events,
    bool? truncated,
  });
  TRes spots(
    Iterable<Query$MapViewport$mapViewport$spots> Function(
      Iterable<
        CopyWith$Query$MapViewport$mapViewport$spots<
          Query$MapViewport$mapViewport$spots
        >
      >,
    )
    _fn,
  );
  TRes clusters(
    Iterable<Query$MapViewport$mapViewport$clusters> Function(
      Iterable<
        CopyWith$Query$MapViewport$mapViewport$clusters<
          Query$MapViewport$mapViewport$clusters
        >
      >,
    )
    _fn,
  );
  TRes events(
    Iterable<Query$MapViewport$mapViewport$events> Function(
      Iterable<
        CopyWith$Query$MapViewport$mapViewport$events<
          Query$MapViewport$mapViewport$events
        >
      >,
    )
    _fn,
  );
}

class _CopyWithImpl$Query$MapViewport$mapViewport<TRes>
    implements CopyWith$Query$MapViewport$mapViewport<TRes> {
  _CopyWithImpl$Query$MapViewport$mapViewport(this._instance, this._then);

  final Query$MapViewport$mapViewport _instance;

  final TRes Function(Query$MapViewport$mapViewport) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? spots = _undefined,
    Object? clusters = _undefined,
    Object? events = _undefined,
    Object? truncated = _undefined,
  }) => _then(
    Query$MapViewport$mapViewport(
      spots: spots == _undefined || spots == null
          ? _instance.spots
          : (spots as List<Query$MapViewport$mapViewport$spots>),
      clusters: clusters == _undefined || clusters == null
          ? _instance.clusters
          : (clusters as List<Query$MapViewport$mapViewport$clusters>),
      events: events == _undefined || events == null
          ? _instance.events
          : (events as List<Query$MapViewport$mapViewport$events>),
      truncated: truncated == _undefined || truncated == null
          ? _instance.truncated
          : (truncated as bool),
    ),
  );

  TRes spots(
    Iterable<Query$MapViewport$mapViewport$spots> Function(
      Iterable<
        CopyWith$Query$MapViewport$mapViewport$spots<
          Query$MapViewport$mapViewport$spots
        >
      >,
    )
    _fn,
  ) => call(
    spots: _fn(
      _instance.spots.map(
        (e) => CopyWith$Query$MapViewport$mapViewport$spots(e, (i) => i),
      ),
    ).toList(),
  );

  TRes clusters(
    Iterable<Query$MapViewport$mapViewport$clusters> Function(
      Iterable<
        CopyWith$Query$MapViewport$mapViewport$clusters<
          Query$MapViewport$mapViewport$clusters
        >
      >,
    )
    _fn,
  ) => call(
    clusters: _fn(
      _instance.clusters.map(
        (e) => CopyWith$Query$MapViewport$mapViewport$clusters(e, (i) => i),
      ),
    ).toList(),
  );

  TRes events(
    Iterable<Query$MapViewport$mapViewport$events> Function(
      Iterable<
        CopyWith$Query$MapViewport$mapViewport$events<
          Query$MapViewport$mapViewport$events
        >
      >,
    )
    _fn,
  ) => call(
    events: _fn(
      _instance.events.map(
        (e) => CopyWith$Query$MapViewport$mapViewport$events(e, (i) => i),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl$Query$MapViewport$mapViewport<TRes>
    implements CopyWith$Query$MapViewport$mapViewport<TRes> {
  _CopyWithStubImpl$Query$MapViewport$mapViewport(this._res);

  TRes _res;

  call({
    List<Query$MapViewport$mapViewport$spots>? spots,
    List<Query$MapViewport$mapViewport$clusters>? clusters,
    List<Query$MapViewport$mapViewport$events>? events,
    bool? truncated,
  }) => _res;

  spots(_fn) => _res;

  clusters(_fn) => _res;

  events(_fn) => _res;
}

class Query$MapViewport$mapViewport$spots {
  Query$MapViewport$mapViewport$spots({
    required this.id,
    required this.title,
    required this.thumbnailImageUrl,
    required this.category,
    required this.lng,
    required this.lat,
  });

  factory Query$MapViewport$mapViewport$spots.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$title = json['title'];
    final l$thumbnailImageUrl = json['thumbnailImageUrl'];
    final l$category = json['category'];
    final l$lng = json['lng'];
    final l$lat = json['lat'];
    return Query$MapViewport$mapViewport$spots(
      id: (l$id as String),
      title: (l$title as String),
      thumbnailImageUrl: (l$thumbnailImageUrl as String),
      category: fromJson$Enum$SpotCategory((l$category as String)),
      lng: (l$lng as num).toDouble(),
      lat: (l$lat as num).toDouble(),
    );
  }

  final String id;

  final String title;

  final String thumbnailImageUrl;

  final Enum$SpotCategory category;

  final double lng;

  final double lat;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$title = title;
    _resultData['title'] = l$title;
    final l$thumbnailImageUrl = thumbnailImageUrl;
    _resultData['thumbnailImageUrl'] = l$thumbnailImageUrl;
    final l$category = category;
    _resultData['category'] = toJson$Enum$SpotCategory(l$category);
    final l$lng = lng;
    _resultData['lng'] = l$lng;
    final l$lat = lat;
    _resultData['lat'] = l$lat;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$title = title;
    final l$thumbnailImageUrl = thumbnailImageUrl;
    final l$category = category;
    final l$lng = lng;
    final l$lat = lat;
    return Object.hashAll([
      l$id,
      l$title,
      l$thumbnailImageUrl,
      l$category,
      l$lng,
      l$lat,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$MapViewport$mapViewport$spots ||
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
    final l$thumbnailImageUrl = thumbnailImageUrl;
    final lOther$thumbnailImageUrl = other.thumbnailImageUrl;
    if (l$thumbnailImageUrl != lOther$thumbnailImageUrl) {
      return false;
    }
    final l$category = category;
    final lOther$category = other.category;
    if (l$category != lOther$category) {
      return false;
    }
    final l$lng = lng;
    final lOther$lng = other.lng;
    if (l$lng != lOther$lng) {
      return false;
    }
    final l$lat = lat;
    final lOther$lat = other.lat;
    if (l$lat != lOther$lat) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Query$MapViewport$mapViewport$spots
    on Query$MapViewport$mapViewport$spots {
  CopyWith$Query$MapViewport$mapViewport$spots<
    Query$MapViewport$mapViewport$spots
  >
  get copyWith => CopyWith$Query$MapViewport$mapViewport$spots(this, (i) => i);
}

abstract class CopyWith$Query$MapViewport$mapViewport$spots<TRes> {
  factory CopyWith$Query$MapViewport$mapViewport$spots(
    Query$MapViewport$mapViewport$spots instance,
    TRes Function(Query$MapViewport$mapViewport$spots) then,
  ) = _CopyWithImpl$Query$MapViewport$mapViewport$spots;

  factory CopyWith$Query$MapViewport$mapViewport$spots.stub(TRes res) =
      _CopyWithStubImpl$Query$MapViewport$mapViewport$spots;

  TRes call({
    String? id,
    String? title,
    String? thumbnailImageUrl,
    Enum$SpotCategory? category,
    double? lng,
    double? lat,
  });
}

class _CopyWithImpl$Query$MapViewport$mapViewport$spots<TRes>
    implements CopyWith$Query$MapViewport$mapViewport$spots<TRes> {
  _CopyWithImpl$Query$MapViewport$mapViewport$spots(this._instance, this._then);

  final Query$MapViewport$mapViewport$spots _instance;

  final TRes Function(Query$MapViewport$mapViewport$spots) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? title = _undefined,
    Object? thumbnailImageUrl = _undefined,
    Object? category = _undefined,
    Object? lng = _undefined,
    Object? lat = _undefined,
  }) => _then(
    Query$MapViewport$mapViewport$spots(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      title: title == _undefined || title == null
          ? _instance.title
          : (title as String),
      thumbnailImageUrl:
          thumbnailImageUrl == _undefined || thumbnailImageUrl == null
          ? _instance.thumbnailImageUrl
          : (thumbnailImageUrl as String),
      category: category == _undefined || category == null
          ? _instance.category
          : (category as Enum$SpotCategory),
      lng: lng == _undefined || lng == null ? _instance.lng : (lng as double),
      lat: lat == _undefined || lat == null ? _instance.lat : (lat as double),
    ),
  );
}

class _CopyWithStubImpl$Query$MapViewport$mapViewport$spots<TRes>
    implements CopyWith$Query$MapViewport$mapViewport$spots<TRes> {
  _CopyWithStubImpl$Query$MapViewport$mapViewport$spots(this._res);

  TRes _res;

  call({
    String? id,
    String? title,
    String? thumbnailImageUrl,
    Enum$SpotCategory? category,
    double? lng,
    double? lat,
  }) => _res;
}

class Query$MapViewport$mapViewport$clusters {
  Query$MapViewport$mapViewport$clusters({
    required this.centerLng,
    required this.centerLat,
    required this.count,
    this.dominantCategory,
  });

  factory Query$MapViewport$mapViewport$clusters.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$centerLng = json['centerLng'];
    final l$centerLat = json['centerLat'];
    final l$count = json['count'];
    final l$dominantCategory = json['dominantCategory'];
    return Query$MapViewport$mapViewport$clusters(
      centerLng: (l$centerLng as num).toDouble(),
      centerLat: (l$centerLat as num).toDouble(),
      count: (l$count as int),
      dominantCategory: l$dominantCategory == null
          ? null
          : fromJson$Enum$SpotCategory((l$dominantCategory as String)),
    );
  }

  final double centerLng;

  final double centerLat;

  final int count;

  final Enum$SpotCategory? dominantCategory;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$centerLng = centerLng;
    _resultData['centerLng'] = l$centerLng;
    final l$centerLat = centerLat;
    _resultData['centerLat'] = l$centerLat;
    final l$count = count;
    _resultData['count'] = l$count;
    final l$dominantCategory = dominantCategory;
    _resultData['dominantCategory'] = l$dominantCategory == null
        ? null
        : toJson$Enum$SpotCategory(l$dominantCategory);
    return _resultData;
  }

  @override
  int get hashCode {
    final l$centerLng = centerLng;
    final l$centerLat = centerLat;
    final l$count = count;
    final l$dominantCategory = dominantCategory;
    return Object.hashAll([
      l$centerLng,
      l$centerLat,
      l$count,
      l$dominantCategory,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$MapViewport$mapViewport$clusters ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$centerLng = centerLng;
    final lOther$centerLng = other.centerLng;
    if (l$centerLng != lOther$centerLng) {
      return false;
    }
    final l$centerLat = centerLat;
    final lOther$centerLat = other.centerLat;
    if (l$centerLat != lOther$centerLat) {
      return false;
    }
    final l$count = count;
    final lOther$count = other.count;
    if (l$count != lOther$count) {
      return false;
    }
    final l$dominantCategory = dominantCategory;
    final lOther$dominantCategory = other.dominantCategory;
    if (l$dominantCategory != lOther$dominantCategory) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Query$MapViewport$mapViewport$clusters
    on Query$MapViewport$mapViewport$clusters {
  CopyWith$Query$MapViewport$mapViewport$clusters<
    Query$MapViewport$mapViewport$clusters
  >
  get copyWith =>
      CopyWith$Query$MapViewport$mapViewport$clusters(this, (i) => i);
}

abstract class CopyWith$Query$MapViewport$mapViewport$clusters<TRes> {
  factory CopyWith$Query$MapViewport$mapViewport$clusters(
    Query$MapViewport$mapViewport$clusters instance,
    TRes Function(Query$MapViewport$mapViewport$clusters) then,
  ) = _CopyWithImpl$Query$MapViewport$mapViewport$clusters;

  factory CopyWith$Query$MapViewport$mapViewport$clusters.stub(TRes res) =
      _CopyWithStubImpl$Query$MapViewport$mapViewport$clusters;

  TRes call({
    double? centerLng,
    double? centerLat,
    int? count,
    Enum$SpotCategory? dominantCategory,
  });
}

class _CopyWithImpl$Query$MapViewport$mapViewport$clusters<TRes>
    implements CopyWith$Query$MapViewport$mapViewport$clusters<TRes> {
  _CopyWithImpl$Query$MapViewport$mapViewport$clusters(
    this._instance,
    this._then,
  );

  final Query$MapViewport$mapViewport$clusters _instance;

  final TRes Function(Query$MapViewport$mapViewport$clusters) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? centerLng = _undefined,
    Object? centerLat = _undefined,
    Object? count = _undefined,
    Object? dominantCategory = _undefined,
  }) => _then(
    Query$MapViewport$mapViewport$clusters(
      centerLng: centerLng == _undefined || centerLng == null
          ? _instance.centerLng
          : (centerLng as double),
      centerLat: centerLat == _undefined || centerLat == null
          ? _instance.centerLat
          : (centerLat as double),
      count: count == _undefined || count == null
          ? _instance.count
          : (count as int),
      dominantCategory: dominantCategory == _undefined
          ? _instance.dominantCategory
          : (dominantCategory as Enum$SpotCategory?),
    ),
  );
}

class _CopyWithStubImpl$Query$MapViewport$mapViewport$clusters<TRes>
    implements CopyWith$Query$MapViewport$mapViewport$clusters<TRes> {
  _CopyWithStubImpl$Query$MapViewport$mapViewport$clusters(this._res);

  TRes _res;

  call({
    double? centerLng,
    double? centerLat,
    int? count,
    Enum$SpotCategory? dominantCategory,
  }) => _res;
}

class Query$MapViewport$mapViewport$events {
  Query$MapViewport$mapViewport$events({
    required this.id,
    required this.title,
    required this.place,
    required this.period,
    required this.lng,
    required this.lat,
    this.url,
  });

  factory Query$MapViewport$mapViewport$events.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$title = json['title'];
    final l$place = json['place'];
    final l$period = json['period'];
    final l$lng = json['lng'];
    final l$lat = json['lat'];
    final l$url = json['url'];
    return Query$MapViewport$mapViewport$events(
      id: (l$id as String),
      title: (l$title as String),
      place: (l$place as String),
      period: (l$period as String),
      lng: (l$lng as num).toDouble(),
      lat: (l$lat as num).toDouble(),
      url: (l$url as String?),
    );
  }

  final String id;

  final String title;

  final String place;

  final String period;

  final double lng;

  final double lat;

  final String? url;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$title = title;
    _resultData['title'] = l$title;
    final l$place = place;
    _resultData['place'] = l$place;
    final l$period = period;
    _resultData['period'] = l$period;
    final l$lng = lng;
    _resultData['lng'] = l$lng;
    final l$lat = lat;
    _resultData['lat'] = l$lat;
    final l$url = url;
    _resultData['url'] = l$url;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$title = title;
    final l$place = place;
    final l$period = period;
    final l$lng = lng;
    final l$lat = lat;
    final l$url = url;
    return Object.hashAll([
      l$id,
      l$title,
      l$place,
      l$period,
      l$lng,
      l$lat,
      l$url,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$MapViewport$mapViewport$events ||
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
    final l$place = place;
    final lOther$place = other.place;
    if (l$place != lOther$place) {
      return false;
    }
    final l$period = period;
    final lOther$period = other.period;
    if (l$period != lOther$period) {
      return false;
    }
    final l$lng = lng;
    final lOther$lng = other.lng;
    if (l$lng != lOther$lng) {
      return false;
    }
    final l$lat = lat;
    final lOther$lat = other.lat;
    if (l$lat != lOther$lat) {
      return false;
    }
    final l$url = url;
    final lOther$url = other.url;
    if (l$url != lOther$url) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Query$MapViewport$mapViewport$events
    on Query$MapViewport$mapViewport$events {
  CopyWith$Query$MapViewport$mapViewport$events<
    Query$MapViewport$mapViewport$events
  >
  get copyWith => CopyWith$Query$MapViewport$mapViewport$events(this, (i) => i);
}

abstract class CopyWith$Query$MapViewport$mapViewport$events<TRes> {
  factory CopyWith$Query$MapViewport$mapViewport$events(
    Query$MapViewport$mapViewport$events instance,
    TRes Function(Query$MapViewport$mapViewport$events) then,
  ) = _CopyWithImpl$Query$MapViewport$mapViewport$events;

  factory CopyWith$Query$MapViewport$mapViewport$events.stub(TRes res) =
      _CopyWithStubImpl$Query$MapViewport$mapViewport$events;

  TRes call({
    String? id,
    String? title,
    String? place,
    String? period,
    double? lng,
    double? lat,
    String? url,
  });
}

class _CopyWithImpl$Query$MapViewport$mapViewport$events<TRes>
    implements CopyWith$Query$MapViewport$mapViewport$events<TRes> {
  _CopyWithImpl$Query$MapViewport$mapViewport$events(
    this._instance,
    this._then,
  );

  final Query$MapViewport$mapViewport$events _instance;

  final TRes Function(Query$MapViewport$mapViewport$events) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? title = _undefined,
    Object? place = _undefined,
    Object? period = _undefined,
    Object? lng = _undefined,
    Object? lat = _undefined,
    Object? url = _undefined,
  }) => _then(
    Query$MapViewport$mapViewport$events(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      title: title == _undefined || title == null
          ? _instance.title
          : (title as String),
      place: place == _undefined || place == null
          ? _instance.place
          : (place as String),
      period: period == _undefined || period == null
          ? _instance.period
          : (period as String),
      lng: lng == _undefined || lng == null ? _instance.lng : (lng as double),
      lat: lat == _undefined || lat == null ? _instance.lat : (lat as double),
      url: url == _undefined ? _instance.url : (url as String?),
    ),
  );
}

class _CopyWithStubImpl$Query$MapViewport$mapViewport$events<TRes>
    implements CopyWith$Query$MapViewport$mapViewport$events<TRes> {
  _CopyWithStubImpl$Query$MapViewport$mapViewport$events(this._res);

  TRes _res;

  call({
    String? id,
    String? title,
    String? place,
    String? period,
    double? lng,
    double? lat,
    String? url,
  }) => _res;
}

class Variables$Query$SeoulCongestion {
  factory Variables$Query$SeoulCongestion({
    required Input$MapBoundsInput bbox,
  }) => Variables$Query$SeoulCongestion._({r'bbox': bbox});

  Variables$Query$SeoulCongestion._(this._$data);

  factory Variables$Query$SeoulCongestion.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$bbox = data['bbox'];
    result$data['bbox'] = Input$MapBoundsInput.fromJson(
      (l$bbox as Map<String, dynamic>),
    );
    return Variables$Query$SeoulCongestion._(result$data);
  }

  Map<String, dynamic> _$data;

  Input$MapBoundsInput get bbox => (_$data['bbox'] as Input$MapBoundsInput);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$bbox = bbox;
    result$data['bbox'] = l$bbox.toJson();
    return result$data;
  }

  CopyWith$Variables$Query$SeoulCongestion<Variables$Query$SeoulCongestion>
  get copyWith => CopyWith$Variables$Query$SeoulCongestion(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Query$SeoulCongestion ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$bbox = bbox;
    final lOther$bbox = other.bbox;
    if (l$bbox != lOther$bbox) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$bbox = bbox;
    return Object.hashAll([l$bbox]);
  }
}

abstract class CopyWith$Variables$Query$SeoulCongestion<TRes> {
  factory CopyWith$Variables$Query$SeoulCongestion(
    Variables$Query$SeoulCongestion instance,
    TRes Function(Variables$Query$SeoulCongestion) then,
  ) = _CopyWithImpl$Variables$Query$SeoulCongestion;

  factory CopyWith$Variables$Query$SeoulCongestion.stub(TRes res) =
      _CopyWithStubImpl$Variables$Query$SeoulCongestion;

  TRes call({Input$MapBoundsInput? bbox});
}

class _CopyWithImpl$Variables$Query$SeoulCongestion<TRes>
    implements CopyWith$Variables$Query$SeoulCongestion<TRes> {
  _CopyWithImpl$Variables$Query$SeoulCongestion(this._instance, this._then);

  final Variables$Query$SeoulCongestion _instance;

  final TRes Function(Variables$Query$SeoulCongestion) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? bbox = _undefined}) => _then(
    Variables$Query$SeoulCongestion._({
      ..._instance._$data,
      if (bbox != _undefined && bbox != null)
        'bbox': (bbox as Input$MapBoundsInput),
    }),
  );
}

class _CopyWithStubImpl$Variables$Query$SeoulCongestion<TRes>
    implements CopyWith$Variables$Query$SeoulCongestion<TRes> {
  _CopyWithStubImpl$Variables$Query$SeoulCongestion(this._res);

  TRes _res;

  call({Input$MapBoundsInput? bbox}) => _res;
}

class Query$SeoulCongestion {
  Query$SeoulCongestion({required this.seoulCongestion});

  factory Query$SeoulCongestion.fromJson(Map<String, dynamic> json) {
    final l$seoulCongestion = json['seoulCongestion'];
    return Query$SeoulCongestion(
      seoulCongestion: Query$SeoulCongestion$seoulCongestion.fromJson(
        (l$seoulCongestion as Map<String, dynamic>),
      ),
    );
  }

  final Query$SeoulCongestion$seoulCongestion seoulCongestion;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$seoulCongestion = seoulCongestion;
    _resultData['seoulCongestion'] = l$seoulCongestion.toJson();
    return _resultData;
  }

  @override
  int get hashCode {
    final l$seoulCongestion = seoulCongestion;
    return Object.hashAll([l$seoulCongestion]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$SeoulCongestion || runtimeType != other.runtimeType) {
      return false;
    }
    final l$seoulCongestion = seoulCongestion;
    final lOther$seoulCongestion = other.seoulCongestion;
    if (l$seoulCongestion != lOther$seoulCongestion) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Query$SeoulCongestion on Query$SeoulCongestion {
  CopyWith$Query$SeoulCongestion<Query$SeoulCongestion> get copyWith =>
      CopyWith$Query$SeoulCongestion(this, (i) => i);
}

abstract class CopyWith$Query$SeoulCongestion<TRes> {
  factory CopyWith$Query$SeoulCongestion(
    Query$SeoulCongestion instance,
    TRes Function(Query$SeoulCongestion) then,
  ) = _CopyWithImpl$Query$SeoulCongestion;

  factory CopyWith$Query$SeoulCongestion.stub(TRes res) =
      _CopyWithStubImpl$Query$SeoulCongestion;

  TRes call({Query$SeoulCongestion$seoulCongestion? seoulCongestion});
  CopyWith$Query$SeoulCongestion$seoulCongestion<TRes> get seoulCongestion;
}

class _CopyWithImpl$Query$SeoulCongestion<TRes>
    implements CopyWith$Query$SeoulCongestion<TRes> {
  _CopyWithImpl$Query$SeoulCongestion(this._instance, this._then);

  final Query$SeoulCongestion _instance;

  final TRes Function(Query$SeoulCongestion) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? seoulCongestion = _undefined}) => _then(
    Query$SeoulCongestion(
      seoulCongestion: seoulCongestion == _undefined || seoulCongestion == null
          ? _instance.seoulCongestion
          : (seoulCongestion as Query$SeoulCongestion$seoulCongestion),
    ),
  );

  CopyWith$Query$SeoulCongestion$seoulCongestion<TRes> get seoulCongestion {
    final local$seoulCongestion = _instance.seoulCongestion;
    return CopyWith$Query$SeoulCongestion$seoulCongestion(
      local$seoulCongestion,
      (e) => call(seoulCongestion: e),
    );
  }
}

class _CopyWithStubImpl$Query$SeoulCongestion<TRes>
    implements CopyWith$Query$SeoulCongestion<TRes> {
  _CopyWithStubImpl$Query$SeoulCongestion(this._res);

  TRes _res;

  call({Query$SeoulCongestion$seoulCongestion? seoulCongestion}) => _res;

  CopyWith$Query$SeoulCongestion$seoulCongestion<TRes> get seoulCongestion =>
      CopyWith$Query$SeoulCongestion$seoulCongestion.stub(_res);
}

const documentNodeQuerySeoulCongestion = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'SeoulCongestion'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'bbox')),
          type: NamedTypeNode(
            name: NameNode(value: 'MapBoundsInput'),
            isNonNull: true,
          ),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
      ],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'seoulCongestion'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'bbox'),
                value: VariableNode(name: NameNode(value: 'bbox')),
              ),
            ],
            directives: [],
            selectionSet: SelectionSetNode(
              selections: [
                FieldNode(
                  name: NameNode(value: 'areas'),
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
                        name: NameNode(value: 'name'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'congestion'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: SelectionSetNode(
                          selections: [
                            FieldNode(
                              name: NameNode(value: 'level'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null,
                            ),
                            FieldNode(
                              name: NameNode(value: 'populationMin'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null,
                            ),
                            FieldNode(
                              name: NameNode(value: 'populationMax'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null,
                            ),
                            FieldNode(
                              name: NameNode(value: 'observedAt'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null,
                            ),
                          ],
                        ),
                      ),
                      FieldNode(
                        name: NameNode(value: 'commercial'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: SelectionSetNode(
                          selections: [
                            FieldNode(
                              name: NameNode(value: 'level'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null,
                            ),
                            FieldNode(
                              name: NameNode(value: 'isDefaulted'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null,
                            ),
                            FieldNode(
                              name: NameNode(value: 'observedAt'),
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
                FieldNode(
                  name: NameNode(value: 'degraded'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: 'staleSince'),
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
);

class Query$SeoulCongestion$seoulCongestion {
  Query$SeoulCongestion$seoulCongestion({
    required this.areas,
    required this.degraded,
    this.staleSince,
  });

  factory Query$SeoulCongestion$seoulCongestion.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$areas = json['areas'];
    final l$degraded = json['degraded'];
    final l$staleSince = json['staleSince'];
    return Query$SeoulCongestion$seoulCongestion(
      areas: (l$areas as List<dynamic>)
          .map(
            (e) => Query$SeoulCongestion$seoulCongestion$areas.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      degraded: (l$degraded as bool),
      staleSince: (l$staleSince as String?),
    );
  }

  final List<Query$SeoulCongestion$seoulCongestion$areas> areas;

  final bool degraded;

  final String? staleSince;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$areas = areas;
    _resultData['areas'] = l$areas.map((e) => e.toJson()).toList();
    final l$degraded = degraded;
    _resultData['degraded'] = l$degraded;
    final l$staleSince = staleSince;
    _resultData['staleSince'] = l$staleSince;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$areas = areas;
    final l$degraded = degraded;
    final l$staleSince = staleSince;
    return Object.hashAll([
      Object.hashAll(l$areas.map((v) => v)),
      l$degraded,
      l$staleSince,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$SeoulCongestion$seoulCongestion ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$areas = areas;
    final lOther$areas = other.areas;
    if (l$areas.length != lOther$areas.length) {
      return false;
    }
    for (int i = 0; i < l$areas.length; i++) {
      final l$areas$entry = l$areas[i];
      final lOther$areas$entry = lOther$areas[i];
      if (l$areas$entry != lOther$areas$entry) {
        return false;
      }
    }
    final l$degraded = degraded;
    final lOther$degraded = other.degraded;
    if (l$degraded != lOther$degraded) {
      return false;
    }
    final l$staleSince = staleSince;
    final lOther$staleSince = other.staleSince;
    if (l$staleSince != lOther$staleSince) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Query$SeoulCongestion$seoulCongestion
    on Query$SeoulCongestion$seoulCongestion {
  CopyWith$Query$SeoulCongestion$seoulCongestion<
    Query$SeoulCongestion$seoulCongestion
  >
  get copyWith =>
      CopyWith$Query$SeoulCongestion$seoulCongestion(this, (i) => i);
}

abstract class CopyWith$Query$SeoulCongestion$seoulCongestion<TRes> {
  factory CopyWith$Query$SeoulCongestion$seoulCongestion(
    Query$SeoulCongestion$seoulCongestion instance,
    TRes Function(Query$SeoulCongestion$seoulCongestion) then,
  ) = _CopyWithImpl$Query$SeoulCongestion$seoulCongestion;

  factory CopyWith$Query$SeoulCongestion$seoulCongestion.stub(TRes res) =
      _CopyWithStubImpl$Query$SeoulCongestion$seoulCongestion;

  TRes call({
    List<Query$SeoulCongestion$seoulCongestion$areas>? areas,
    bool? degraded,
    String? staleSince,
  });
  TRes areas(
    Iterable<Query$SeoulCongestion$seoulCongestion$areas> Function(
      Iterable<
        CopyWith$Query$SeoulCongestion$seoulCongestion$areas<
          Query$SeoulCongestion$seoulCongestion$areas
        >
      >,
    )
    _fn,
  );
}

class _CopyWithImpl$Query$SeoulCongestion$seoulCongestion<TRes>
    implements CopyWith$Query$SeoulCongestion$seoulCongestion<TRes> {
  _CopyWithImpl$Query$SeoulCongestion$seoulCongestion(
    this._instance,
    this._then,
  );

  final Query$SeoulCongestion$seoulCongestion _instance;

  final TRes Function(Query$SeoulCongestion$seoulCongestion) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? areas = _undefined,
    Object? degraded = _undefined,
    Object? staleSince = _undefined,
  }) => _then(
    Query$SeoulCongestion$seoulCongestion(
      areas: areas == _undefined || areas == null
          ? _instance.areas
          : (areas as List<Query$SeoulCongestion$seoulCongestion$areas>),
      degraded: degraded == _undefined || degraded == null
          ? _instance.degraded
          : (degraded as bool),
      staleSince: staleSince == _undefined
          ? _instance.staleSince
          : (staleSince as String?),
    ),
  );

  TRes areas(
    Iterable<Query$SeoulCongestion$seoulCongestion$areas> Function(
      Iterable<
        CopyWith$Query$SeoulCongestion$seoulCongestion$areas<
          Query$SeoulCongestion$seoulCongestion$areas
        >
      >,
    )
    _fn,
  ) => call(
    areas: _fn(
      _instance.areas.map(
        (e) =>
            CopyWith$Query$SeoulCongestion$seoulCongestion$areas(e, (i) => i),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl$Query$SeoulCongestion$seoulCongestion<TRes>
    implements CopyWith$Query$SeoulCongestion$seoulCongestion<TRes> {
  _CopyWithStubImpl$Query$SeoulCongestion$seoulCongestion(this._res);

  TRes _res;

  call({
    List<Query$SeoulCongestion$seoulCongestion$areas>? areas,
    bool? degraded,
    String? staleSince,
  }) => _res;

  areas(_fn) => _res;
}

class Query$SeoulCongestion$seoulCongestion$areas {
  Query$SeoulCongestion$seoulCongestion$areas({
    required this.id,
    required this.name,
    required this.congestion,
    this.commercial,
  });

  factory Query$SeoulCongestion$seoulCongestion$areas.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$name = json['name'];
    final l$congestion = json['congestion'];
    final l$commercial = json['commercial'];
    return Query$SeoulCongestion$seoulCongestion$areas(
      id: (l$id as String),
      name: (l$name as String),
      congestion:
          Query$SeoulCongestion$seoulCongestion$areas$congestion.fromJson(
            (l$congestion as Map<String, dynamic>),
          ),
      commercial: l$commercial == null
          ? null
          : Query$SeoulCongestion$seoulCongestion$areas$commercial.fromJson(
              (l$commercial as Map<String, dynamic>),
            ),
    );
  }

  final String id;

  final String name;

  final Query$SeoulCongestion$seoulCongestion$areas$congestion congestion;

  final Query$SeoulCongestion$seoulCongestion$areas$commercial? commercial;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$name = name;
    _resultData['name'] = l$name;
    final l$congestion = congestion;
    _resultData['congestion'] = l$congestion.toJson();
    final l$commercial = commercial;
    _resultData['commercial'] = l$commercial?.toJson();
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$name = name;
    final l$congestion = congestion;
    final l$commercial = commercial;
    return Object.hashAll([l$id, l$name, l$congestion, l$commercial]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$SeoulCongestion$seoulCongestion$areas ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$name = name;
    final lOther$name = other.name;
    if (l$name != lOther$name) {
      return false;
    }
    final l$congestion = congestion;
    final lOther$congestion = other.congestion;
    if (l$congestion != lOther$congestion) {
      return false;
    }
    final l$commercial = commercial;
    final lOther$commercial = other.commercial;
    if (l$commercial != lOther$commercial) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Query$SeoulCongestion$seoulCongestion$areas
    on Query$SeoulCongestion$seoulCongestion$areas {
  CopyWith$Query$SeoulCongestion$seoulCongestion$areas<
    Query$SeoulCongestion$seoulCongestion$areas
  >
  get copyWith =>
      CopyWith$Query$SeoulCongestion$seoulCongestion$areas(this, (i) => i);
}

abstract class CopyWith$Query$SeoulCongestion$seoulCongestion$areas<TRes> {
  factory CopyWith$Query$SeoulCongestion$seoulCongestion$areas(
    Query$SeoulCongestion$seoulCongestion$areas instance,
    TRes Function(Query$SeoulCongestion$seoulCongestion$areas) then,
  ) = _CopyWithImpl$Query$SeoulCongestion$seoulCongestion$areas;

  factory CopyWith$Query$SeoulCongestion$seoulCongestion$areas.stub(TRes res) =
      _CopyWithStubImpl$Query$SeoulCongestion$seoulCongestion$areas;

  TRes call({
    String? id,
    String? name,
    Query$SeoulCongestion$seoulCongestion$areas$congestion? congestion,
    Query$SeoulCongestion$seoulCongestion$areas$commercial? commercial,
  });
  CopyWith$Query$SeoulCongestion$seoulCongestion$areas$congestion<TRes>
  get congestion;
  CopyWith$Query$SeoulCongestion$seoulCongestion$areas$commercial<TRes>
  get commercial;
}

class _CopyWithImpl$Query$SeoulCongestion$seoulCongestion$areas<TRes>
    implements CopyWith$Query$SeoulCongestion$seoulCongestion$areas<TRes> {
  _CopyWithImpl$Query$SeoulCongestion$seoulCongestion$areas(
    this._instance,
    this._then,
  );

  final Query$SeoulCongestion$seoulCongestion$areas _instance;

  final TRes Function(Query$SeoulCongestion$seoulCongestion$areas) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? name = _undefined,
    Object? congestion = _undefined,
    Object? commercial = _undefined,
  }) => _then(
    Query$SeoulCongestion$seoulCongestion$areas(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      name: name == _undefined || name == null
          ? _instance.name
          : (name as String),
      congestion: congestion == _undefined || congestion == null
          ? _instance.congestion
          : (congestion
                as Query$SeoulCongestion$seoulCongestion$areas$congestion),
      commercial: commercial == _undefined
          ? _instance.commercial
          : (commercial
                as Query$SeoulCongestion$seoulCongestion$areas$commercial?),
    ),
  );

  CopyWith$Query$SeoulCongestion$seoulCongestion$areas$congestion<TRes>
  get congestion {
    final local$congestion = _instance.congestion;
    return CopyWith$Query$SeoulCongestion$seoulCongestion$areas$congestion(
      local$congestion,
      (e) => call(congestion: e),
    );
  }

  CopyWith$Query$SeoulCongestion$seoulCongestion$areas$commercial<TRes>
  get commercial {
    final local$commercial = _instance.commercial;
    return local$commercial == null
        ? CopyWith$Query$SeoulCongestion$seoulCongestion$areas$commercial.stub(
            _then(_instance),
          )
        : CopyWith$Query$SeoulCongestion$seoulCongestion$areas$commercial(
            local$commercial,
            (e) => call(commercial: e),
          );
  }
}

class _CopyWithStubImpl$Query$SeoulCongestion$seoulCongestion$areas<TRes>
    implements CopyWith$Query$SeoulCongestion$seoulCongestion$areas<TRes> {
  _CopyWithStubImpl$Query$SeoulCongestion$seoulCongestion$areas(this._res);

  TRes _res;

  call({
    String? id,
    String? name,
    Query$SeoulCongestion$seoulCongestion$areas$congestion? congestion,
    Query$SeoulCongestion$seoulCongestion$areas$commercial? commercial,
  }) => _res;

  CopyWith$Query$SeoulCongestion$seoulCongestion$areas$congestion<TRes>
  get congestion =>
      CopyWith$Query$SeoulCongestion$seoulCongestion$areas$congestion.stub(
        _res,
      );

  CopyWith$Query$SeoulCongestion$seoulCongestion$areas$commercial<TRes>
  get commercial =>
      CopyWith$Query$SeoulCongestion$seoulCongestion$areas$commercial.stub(
        _res,
      );
}

class Query$SeoulCongestion$seoulCongestion$areas$congestion {
  Query$SeoulCongestion$seoulCongestion$areas$congestion({
    required this.level,
    required this.populationMin,
    required this.populationMax,
    required this.observedAt,
  });

  factory Query$SeoulCongestion$seoulCongestion$areas$congestion.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$level = json['level'];
    final l$populationMin = json['populationMin'];
    final l$populationMax = json['populationMax'];
    final l$observedAt = json['observedAt'];
    return Query$SeoulCongestion$seoulCongestion$areas$congestion(
      level: fromJson$Enum$CongestionLevel((l$level as String)),
      populationMin: (l$populationMin as int),
      populationMax: (l$populationMax as int),
      observedAt: (l$observedAt as String),
    );
  }

  final Enum$CongestionLevel level;

  final int populationMin;

  final int populationMax;

  final String observedAt;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$level = level;
    _resultData['level'] = toJson$Enum$CongestionLevel(l$level);
    final l$populationMin = populationMin;
    _resultData['populationMin'] = l$populationMin;
    final l$populationMax = populationMax;
    _resultData['populationMax'] = l$populationMax;
    final l$observedAt = observedAt;
    _resultData['observedAt'] = l$observedAt;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$level = level;
    final l$populationMin = populationMin;
    final l$populationMax = populationMax;
    final l$observedAt = observedAt;
    return Object.hashAll([
      l$level,
      l$populationMin,
      l$populationMax,
      l$observedAt,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$SeoulCongestion$seoulCongestion$areas$congestion ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$level = level;
    final lOther$level = other.level;
    if (l$level != lOther$level) {
      return false;
    }
    final l$populationMin = populationMin;
    final lOther$populationMin = other.populationMin;
    if (l$populationMin != lOther$populationMin) {
      return false;
    }
    final l$populationMax = populationMax;
    final lOther$populationMax = other.populationMax;
    if (l$populationMax != lOther$populationMax) {
      return false;
    }
    final l$observedAt = observedAt;
    final lOther$observedAt = other.observedAt;
    if (l$observedAt != lOther$observedAt) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Query$SeoulCongestion$seoulCongestion$areas$congestion
    on Query$SeoulCongestion$seoulCongestion$areas$congestion {
  CopyWith$Query$SeoulCongestion$seoulCongestion$areas$congestion<
    Query$SeoulCongestion$seoulCongestion$areas$congestion
  >
  get copyWith =>
      CopyWith$Query$SeoulCongestion$seoulCongestion$areas$congestion(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Query$SeoulCongestion$seoulCongestion$areas$congestion<
  TRes
> {
  factory CopyWith$Query$SeoulCongestion$seoulCongestion$areas$congestion(
    Query$SeoulCongestion$seoulCongestion$areas$congestion instance,
    TRes Function(Query$SeoulCongestion$seoulCongestion$areas$congestion) then,
  ) = _CopyWithImpl$Query$SeoulCongestion$seoulCongestion$areas$congestion;

  factory CopyWith$Query$SeoulCongestion$seoulCongestion$areas$congestion.stub(
    TRes res,
  ) = _CopyWithStubImpl$Query$SeoulCongestion$seoulCongestion$areas$congestion;

  TRes call({
    Enum$CongestionLevel? level,
    int? populationMin,
    int? populationMax,
    String? observedAt,
  });
}

class _CopyWithImpl$Query$SeoulCongestion$seoulCongestion$areas$congestion<TRes>
    implements
        CopyWith$Query$SeoulCongestion$seoulCongestion$areas$congestion<TRes> {
  _CopyWithImpl$Query$SeoulCongestion$seoulCongestion$areas$congestion(
    this._instance,
    this._then,
  );

  final Query$SeoulCongestion$seoulCongestion$areas$congestion _instance;

  final TRes Function(Query$SeoulCongestion$seoulCongestion$areas$congestion)
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? level = _undefined,
    Object? populationMin = _undefined,
    Object? populationMax = _undefined,
    Object? observedAt = _undefined,
  }) => _then(
    Query$SeoulCongestion$seoulCongestion$areas$congestion(
      level: level == _undefined || level == null
          ? _instance.level
          : (level as Enum$CongestionLevel),
      populationMin: populationMin == _undefined || populationMin == null
          ? _instance.populationMin
          : (populationMin as int),
      populationMax: populationMax == _undefined || populationMax == null
          ? _instance.populationMax
          : (populationMax as int),
      observedAt: observedAt == _undefined || observedAt == null
          ? _instance.observedAt
          : (observedAt as String),
    ),
  );
}

class _CopyWithStubImpl$Query$SeoulCongestion$seoulCongestion$areas$congestion<
  TRes
>
    implements
        CopyWith$Query$SeoulCongestion$seoulCongestion$areas$congestion<TRes> {
  _CopyWithStubImpl$Query$SeoulCongestion$seoulCongestion$areas$congestion(
    this._res,
  );

  TRes _res;

  call({
    Enum$CongestionLevel? level,
    int? populationMin,
    int? populationMax,
    String? observedAt,
  }) => _res;
}

class Query$SeoulCongestion$seoulCongestion$areas$commercial {
  Query$SeoulCongestion$seoulCongestion$areas$commercial({
    required this.level,
    required this.isDefaulted,
    required this.observedAt,
  });

  factory Query$SeoulCongestion$seoulCongestion$areas$commercial.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$level = json['level'];
    final l$isDefaulted = json['isDefaulted'];
    final l$observedAt = json['observedAt'];
    return Query$SeoulCongestion$seoulCongestion$areas$commercial(
      level: fromJson$Enum$CommercialActivityLevel((l$level as String)),
      isDefaulted: (l$isDefaulted as bool),
      observedAt: (l$observedAt as String),
    );
  }

  final Enum$CommercialActivityLevel level;

  final bool isDefaulted;

  final String observedAt;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$level = level;
    _resultData['level'] = toJson$Enum$CommercialActivityLevel(l$level);
    final l$isDefaulted = isDefaulted;
    _resultData['isDefaulted'] = l$isDefaulted;
    final l$observedAt = observedAt;
    _resultData['observedAt'] = l$observedAt;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$level = level;
    final l$isDefaulted = isDefaulted;
    final l$observedAt = observedAt;
    return Object.hashAll([l$level, l$isDefaulted, l$observedAt]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$SeoulCongestion$seoulCongestion$areas$commercial ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$level = level;
    final lOther$level = other.level;
    if (l$level != lOther$level) {
      return false;
    }
    final l$isDefaulted = isDefaulted;
    final lOther$isDefaulted = other.isDefaulted;
    if (l$isDefaulted != lOther$isDefaulted) {
      return false;
    }
    final l$observedAt = observedAt;
    final lOther$observedAt = other.observedAt;
    if (l$observedAt != lOther$observedAt) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Query$SeoulCongestion$seoulCongestion$areas$commercial
    on Query$SeoulCongestion$seoulCongestion$areas$commercial {
  CopyWith$Query$SeoulCongestion$seoulCongestion$areas$commercial<
    Query$SeoulCongestion$seoulCongestion$areas$commercial
  >
  get copyWith =>
      CopyWith$Query$SeoulCongestion$seoulCongestion$areas$commercial(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Query$SeoulCongestion$seoulCongestion$areas$commercial<
  TRes
> {
  factory CopyWith$Query$SeoulCongestion$seoulCongestion$areas$commercial(
    Query$SeoulCongestion$seoulCongestion$areas$commercial instance,
    TRes Function(Query$SeoulCongestion$seoulCongestion$areas$commercial) then,
  ) = _CopyWithImpl$Query$SeoulCongestion$seoulCongestion$areas$commercial;

  factory CopyWith$Query$SeoulCongestion$seoulCongestion$areas$commercial.stub(
    TRes res,
  ) = _CopyWithStubImpl$Query$SeoulCongestion$seoulCongestion$areas$commercial;

  TRes call({
    Enum$CommercialActivityLevel? level,
    bool? isDefaulted,
    String? observedAt,
  });
}

class _CopyWithImpl$Query$SeoulCongestion$seoulCongestion$areas$commercial<TRes>
    implements
        CopyWith$Query$SeoulCongestion$seoulCongestion$areas$commercial<TRes> {
  _CopyWithImpl$Query$SeoulCongestion$seoulCongestion$areas$commercial(
    this._instance,
    this._then,
  );

  final Query$SeoulCongestion$seoulCongestion$areas$commercial _instance;

  final TRes Function(Query$SeoulCongestion$seoulCongestion$areas$commercial)
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? level = _undefined,
    Object? isDefaulted = _undefined,
    Object? observedAt = _undefined,
  }) => _then(
    Query$SeoulCongestion$seoulCongestion$areas$commercial(
      level: level == _undefined || level == null
          ? _instance.level
          : (level as Enum$CommercialActivityLevel),
      isDefaulted: isDefaulted == _undefined || isDefaulted == null
          ? _instance.isDefaulted
          : (isDefaulted as bool),
      observedAt: observedAt == _undefined || observedAt == null
          ? _instance.observedAt
          : (observedAt as String),
    ),
  );
}

class _CopyWithStubImpl$Query$SeoulCongestion$seoulCongestion$areas$commercial<
  TRes
>
    implements
        CopyWith$Query$SeoulCongestion$seoulCongestion$areas$commercial<TRes> {
  _CopyWithStubImpl$Query$SeoulCongestion$seoulCongestion$areas$commercial(
    this._res,
  );

  TRes _res;

  call({
    Enum$CommercialActivityLevel? level,
    bool? isDefaulted,
    String? observedAt,
  }) => _res;
}

class Query$SeoulCongestionAreas {
  Query$SeoulCongestionAreas({required this.seoulCongestionAreas});

  factory Query$SeoulCongestionAreas.fromJson(Map<String, dynamic> json) {
    final l$seoulCongestionAreas = json['seoulCongestionAreas'];
    return Query$SeoulCongestionAreas(
      seoulCongestionAreas: (l$seoulCongestionAreas as List<dynamic>)
          .map(
            (e) => Query$SeoulCongestionAreas$seoulCongestionAreas.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
    );
  }

  final List<Query$SeoulCongestionAreas$seoulCongestionAreas>
  seoulCongestionAreas;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$seoulCongestionAreas = seoulCongestionAreas;
    _resultData['seoulCongestionAreas'] = l$seoulCongestionAreas
        .map((e) => e.toJson())
        .toList();
    return _resultData;
  }

  @override
  int get hashCode {
    final l$seoulCongestionAreas = seoulCongestionAreas;
    return Object.hashAll([
      Object.hashAll(l$seoulCongestionAreas.map((v) => v)),
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$SeoulCongestionAreas ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$seoulCongestionAreas = seoulCongestionAreas;
    final lOther$seoulCongestionAreas = other.seoulCongestionAreas;
    if (l$seoulCongestionAreas.length != lOther$seoulCongestionAreas.length) {
      return false;
    }
    for (int i = 0; i < l$seoulCongestionAreas.length; i++) {
      final l$seoulCongestionAreas$entry = l$seoulCongestionAreas[i];
      final lOther$seoulCongestionAreas$entry = lOther$seoulCongestionAreas[i];
      if (l$seoulCongestionAreas$entry != lOther$seoulCongestionAreas$entry) {
        return false;
      }
    }
    return true;
  }
}

extension UtilityExtension$Query$SeoulCongestionAreas
    on Query$SeoulCongestionAreas {
  CopyWith$Query$SeoulCongestionAreas<Query$SeoulCongestionAreas>
  get copyWith => CopyWith$Query$SeoulCongestionAreas(this, (i) => i);
}

abstract class CopyWith$Query$SeoulCongestionAreas<TRes> {
  factory CopyWith$Query$SeoulCongestionAreas(
    Query$SeoulCongestionAreas instance,
    TRes Function(Query$SeoulCongestionAreas) then,
  ) = _CopyWithImpl$Query$SeoulCongestionAreas;

  factory CopyWith$Query$SeoulCongestionAreas.stub(TRes res) =
      _CopyWithStubImpl$Query$SeoulCongestionAreas;

  TRes call({
    List<Query$SeoulCongestionAreas$seoulCongestionAreas>? seoulCongestionAreas,
  });
  TRes seoulCongestionAreas(
    Iterable<Query$SeoulCongestionAreas$seoulCongestionAreas> Function(
      Iterable<
        CopyWith$Query$SeoulCongestionAreas$seoulCongestionAreas<
          Query$SeoulCongestionAreas$seoulCongestionAreas
        >
      >,
    )
    _fn,
  );
}

class _CopyWithImpl$Query$SeoulCongestionAreas<TRes>
    implements CopyWith$Query$SeoulCongestionAreas<TRes> {
  _CopyWithImpl$Query$SeoulCongestionAreas(this._instance, this._then);

  final Query$SeoulCongestionAreas _instance;

  final TRes Function(Query$SeoulCongestionAreas) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? seoulCongestionAreas = _undefined}) => _then(
    Query$SeoulCongestionAreas(
      seoulCongestionAreas:
          seoulCongestionAreas == _undefined || seoulCongestionAreas == null
          ? _instance.seoulCongestionAreas
          : (seoulCongestionAreas
                as List<Query$SeoulCongestionAreas$seoulCongestionAreas>),
    ),
  );

  TRes seoulCongestionAreas(
    Iterable<Query$SeoulCongestionAreas$seoulCongestionAreas> Function(
      Iterable<
        CopyWith$Query$SeoulCongestionAreas$seoulCongestionAreas<
          Query$SeoulCongestionAreas$seoulCongestionAreas
        >
      >,
    )
    _fn,
  ) => call(
    seoulCongestionAreas: _fn(
      _instance.seoulCongestionAreas.map(
        (e) => CopyWith$Query$SeoulCongestionAreas$seoulCongestionAreas(
          e,
          (i) => i,
        ),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl$Query$SeoulCongestionAreas<TRes>
    implements CopyWith$Query$SeoulCongestionAreas<TRes> {
  _CopyWithStubImpl$Query$SeoulCongestionAreas(this._res);

  TRes _res;

  call({
    List<Query$SeoulCongestionAreas$seoulCongestionAreas>? seoulCongestionAreas,
  }) => _res;

  seoulCongestionAreas(_fn) => _res;
}

const documentNodeQuerySeoulCongestionAreas = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'SeoulCongestionAreas'),
      variableDefinitions: [],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'seoulCongestionAreas'),
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
                  name: NameNode(value: 'name'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: 'category'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: 'polygon'),
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
);

class Query$SeoulCongestionAreas$seoulCongestionAreas {
  Query$SeoulCongestionAreas$seoulCongestionAreas({
    required this.id,
    required this.name,
    required this.category,
    required this.polygon,
  });

  factory Query$SeoulCongestionAreas$seoulCongestionAreas.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$name = json['name'];
    final l$category = json['category'];
    final l$polygon = json['polygon'];
    return Query$SeoulCongestionAreas$seoulCongestionAreas(
      id: (l$id as String),
      name: (l$name as String),
      category: (l$category as String),
      polygon: (l$polygon as List<dynamic>)
          .map(
            (e) =>
                (e as List<dynamic>).map((e) => (e as num).toDouble()).toList(),
          )
          .toList(),
    );
  }

  final String id;

  final String name;

  final String category;

  final List<List<double>> polygon;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$name = name;
    _resultData['name'] = l$name;
    final l$category = category;
    _resultData['category'] = l$category;
    final l$polygon = polygon;
    _resultData['polygon'] = l$polygon
        .map((e) => e.map((e) => e).toList())
        .toList();
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$name = name;
    final l$category = category;
    final l$polygon = polygon;
    return Object.hashAll([
      l$id,
      l$name,
      l$category,
      Object.hashAll(l$polygon.map((v) => Object.hashAll(v.map((v) => v)))),
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$SeoulCongestionAreas$seoulCongestionAreas ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$name = name;
    final lOther$name = other.name;
    if (l$name != lOther$name) {
      return false;
    }
    final l$category = category;
    final lOther$category = other.category;
    if (l$category != lOther$category) {
      return false;
    }
    final l$polygon = polygon;
    final lOther$polygon = other.polygon;
    if (l$polygon.length != lOther$polygon.length) {
      return false;
    }
    for (int i = 0; i < l$polygon.length; i++) {
      final l$polygon$entry = l$polygon[i];
      final lOther$polygon$entry = lOther$polygon[i];
      if (l$polygon$entry.length != lOther$polygon$entry.length) {
        return false;
      }
      for (int i = 0; i < l$polygon$entry.length; i++) {
        final l$polygon$entry$entry = l$polygon$entry[i];
        final lOther$polygon$entry$entry = lOther$polygon$entry[i];
        if (l$polygon$entry$entry != lOther$polygon$entry$entry) {
          return false;
        }
      }
    }
    return true;
  }
}

extension UtilityExtension$Query$SeoulCongestionAreas$seoulCongestionAreas
    on Query$SeoulCongestionAreas$seoulCongestionAreas {
  CopyWith$Query$SeoulCongestionAreas$seoulCongestionAreas<
    Query$SeoulCongestionAreas$seoulCongestionAreas
  >
  get copyWith =>
      CopyWith$Query$SeoulCongestionAreas$seoulCongestionAreas(this, (i) => i);
}

abstract class CopyWith$Query$SeoulCongestionAreas$seoulCongestionAreas<TRes> {
  factory CopyWith$Query$SeoulCongestionAreas$seoulCongestionAreas(
    Query$SeoulCongestionAreas$seoulCongestionAreas instance,
    TRes Function(Query$SeoulCongestionAreas$seoulCongestionAreas) then,
  ) = _CopyWithImpl$Query$SeoulCongestionAreas$seoulCongestionAreas;

  factory CopyWith$Query$SeoulCongestionAreas$seoulCongestionAreas.stub(
    TRes res,
  ) = _CopyWithStubImpl$Query$SeoulCongestionAreas$seoulCongestionAreas;

  TRes call({
    String? id,
    String? name,
    String? category,
    List<List<double>>? polygon,
  });
}

class _CopyWithImpl$Query$SeoulCongestionAreas$seoulCongestionAreas<TRes>
    implements CopyWith$Query$SeoulCongestionAreas$seoulCongestionAreas<TRes> {
  _CopyWithImpl$Query$SeoulCongestionAreas$seoulCongestionAreas(
    this._instance,
    this._then,
  );

  final Query$SeoulCongestionAreas$seoulCongestionAreas _instance;

  final TRes Function(Query$SeoulCongestionAreas$seoulCongestionAreas) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? name = _undefined,
    Object? category = _undefined,
    Object? polygon = _undefined,
  }) => _then(
    Query$SeoulCongestionAreas$seoulCongestionAreas(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      name: name == _undefined || name == null
          ? _instance.name
          : (name as String),
      category: category == _undefined || category == null
          ? _instance.category
          : (category as String),
      polygon: polygon == _undefined || polygon == null
          ? _instance.polygon
          : (polygon as List<List<double>>),
    ),
  );
}

class _CopyWithStubImpl$Query$SeoulCongestionAreas$seoulCongestionAreas<TRes>
    implements CopyWith$Query$SeoulCongestionAreas$seoulCongestionAreas<TRes> {
  _CopyWithStubImpl$Query$SeoulCongestionAreas$seoulCongestionAreas(this._res);

  TRes _res;

  call({
    String? id,
    String? name,
    String? category,
    List<List<double>>? polygon,
  }) => _res;
}
