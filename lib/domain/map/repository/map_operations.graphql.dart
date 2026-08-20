// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, unused_element
import 'map_schema.graphql.dart';
import 'package:gql/ast.dart';

class Variables$Query$MapViewport {
  factory Variables$Query$MapViewport({
    required Input$MapBoundsInput bbox,
    required int zoom,
    List<String>? categories,
  }) => Variables$Query$MapViewport._({
    r'bbox': bbox,
    r'zoom': zoom,
    if (categories != null) r'categories': categories,
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
    if (data.containsKey('categories')) {
      final l$categories = data['categories'];
      result$data['categories'] = (l$categories as List<dynamic>?)
          ?.map((e) => (e as String))
          .toList();
    }
    return Variables$Query$MapViewport._(result$data);
  }

  Map<String, dynamic> _$data;

  Input$MapBoundsInput get bbox => (_$data['bbox'] as Input$MapBoundsInput);

  int get zoom => (_$data['zoom'] as int);

  List<String>? get categories => (_$data['categories'] as List<String>?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$bbox = bbox;
    result$data['bbox'] = l$bbox.toJson();
    final l$zoom = zoom;
    result$data['zoom'] = l$zoom;
    if (_$data.containsKey('categories')) {
      final l$categories = categories;
      result$data['categories'] = l$categories?.map((e) => e).toList();
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
    final l$categories = categories;
    final lOther$categories = other.categories;
    if (_$data.containsKey('categories') !=
        other._$data.containsKey('categories')) {
      return false;
    }
    if (l$categories != null && lOther$categories != null) {
      if (l$categories.length != lOther$categories.length) {
        return false;
      }
      for (int i = 0; i < l$categories.length; i++) {
        final l$categories$entry = l$categories[i];
        final lOther$categories$entry = lOther$categories[i];
        if (l$categories$entry != lOther$categories$entry) {
          return false;
        }
      }
    } else if (l$categories != lOther$categories) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$bbox = bbox;
    final l$zoom = zoom;
    final l$categories = categories;
    return Object.hashAll([
      l$bbox,
      l$zoom,
      _$data.containsKey('categories')
          ? l$categories == null
                ? null
                : Object.hashAll(l$categories.map((v) => v))
          : const {},
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

  TRes call({Input$MapBoundsInput? bbox, int? zoom, List<String>? categories});
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
    Object? categories = _undefined,
  }) => _then(
    Variables$Query$MapViewport._({
      ..._instance._$data,
      if (bbox != _undefined && bbox != null)
        'bbox': (bbox as Input$MapBoundsInput),
      if (zoom != _undefined && zoom != null) 'zoom': (zoom as int),
      if (categories != _undefined) 'categories': (categories as List<String>?),
    }),
  );
}

class _CopyWithStubImpl$Variables$Query$MapViewport<TRes>
    implements CopyWith$Variables$Query$MapViewport<TRes> {
  _CopyWithStubImpl$Variables$Query$MapViewport(this._res);

  TRes _res;

  call({Input$MapBoundsInput? bbox, int? zoom, List<String>? categories}) =>
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
          variable: VariableNode(name: NameNode(value: 'categories')),
          type: ListTypeNode(
            type: NamedTypeNode(
              name: NameNode(value: 'String'),
              isNonNull: true,
            ),
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
                name: NameNode(value: 'categories'),
                value: VariableNode(name: NameNode(value: 'categories')),
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
                        selectionSet: SelectionSetNode(
                          selections: [
                            FieldNode(
                              name: NameNode(value: 'code'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null,
                            ),
                            FieldNode(
                              name: NameNode(value: 'label'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null,
                            ),
                            FieldNode(
                              name: NameNode(value: 'iconUrl'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null,
                            ),
                          ],
                        ),
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
    required this.events,
    required this.truncated,
  });

  factory Query$MapViewport$mapViewport.fromJson(Map<String, dynamic> json) {
    final l$spots = json['spots'];
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

  final List<Query$MapViewport$mapViewport$events> events;

  final bool truncated;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$spots = spots;
    _resultData['spots'] = l$spots.map((e) => e.toJson()).toList();
    final l$events = events;
    _resultData['events'] = l$events.map((e) => e.toJson()).toList();
    final l$truncated = truncated;
    _resultData['truncated'] = l$truncated;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$spots = spots;
    final l$events = events;
    final l$truncated = truncated;
    return Object.hashAll([
      Object.hashAll(l$spots.map((v) => v)),
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
    Object? events = _undefined,
    Object? truncated = _undefined,
  }) => _then(
    Query$MapViewport$mapViewport(
      spots: spots == _undefined || spots == null
          ? _instance.spots
          : (spots as List<Query$MapViewport$mapViewport$spots>),
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
    List<Query$MapViewport$mapViewport$events>? events,
    bool? truncated,
  }) => _res;

  spots(_fn) => _res;

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
      category: Query$MapViewport$mapViewport$spots$category.fromJson(
        (l$category as Map<String, dynamic>),
      ),
      lng: (l$lng as num).toDouble(),
      lat: (l$lat as num).toDouble(),
    );
  }

  final String id;

  final String title;

  final String thumbnailImageUrl;

  final Query$MapViewport$mapViewport$spots$category category;

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
    _resultData['category'] = l$category.toJson();
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
    Query$MapViewport$mapViewport$spots$category? category,
    double? lng,
    double? lat,
  });
  CopyWith$Query$MapViewport$mapViewport$spots$category<TRes> get category;
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
          : (category as Query$MapViewport$mapViewport$spots$category),
      lng: lng == _undefined || lng == null ? _instance.lng : (lng as double),
      lat: lat == _undefined || lat == null ? _instance.lat : (lat as double),
    ),
  );

  CopyWith$Query$MapViewport$mapViewport$spots$category<TRes> get category {
    final local$category = _instance.category;
    return CopyWith$Query$MapViewport$mapViewport$spots$category(
      local$category,
      (e) => call(category: e),
    );
  }
}

class _CopyWithStubImpl$Query$MapViewport$mapViewport$spots<TRes>
    implements CopyWith$Query$MapViewport$mapViewport$spots<TRes> {
  _CopyWithStubImpl$Query$MapViewport$mapViewport$spots(this._res);

  TRes _res;

  call({
    String? id,
    String? title,
    String? thumbnailImageUrl,
    Query$MapViewport$mapViewport$spots$category? category,
    double? lng,
    double? lat,
  }) => _res;

  CopyWith$Query$MapViewport$mapViewport$spots$category<TRes> get category =>
      CopyWith$Query$MapViewport$mapViewport$spots$category.stub(_res);
}

class Query$MapViewport$mapViewport$spots$category {
  Query$MapViewport$mapViewport$spots$category({
    required this.code,
    required this.label,
    this.iconUrl,
  });

  factory Query$MapViewport$mapViewport$spots$category.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$code = json['code'];
    final l$label = json['label'];
    final l$iconUrl = json['iconUrl'];
    return Query$MapViewport$mapViewport$spots$category(
      code: (l$code as String),
      label: (l$label as String),
      iconUrl: (l$iconUrl as String?),
    );
  }

  final String code;

  final String label;

  final String? iconUrl;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$code = code;
    _resultData['code'] = l$code;
    final l$label = label;
    _resultData['label'] = l$label;
    final l$iconUrl = iconUrl;
    _resultData['iconUrl'] = l$iconUrl;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$code = code;
    final l$label = label;
    final l$iconUrl = iconUrl;
    return Object.hashAll([l$code, l$label, l$iconUrl]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$MapViewport$mapViewport$spots$category ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$code = code;
    final lOther$code = other.code;
    if (l$code != lOther$code) {
      return false;
    }
    final l$label = label;
    final lOther$label = other.label;
    if (l$label != lOther$label) {
      return false;
    }
    final l$iconUrl = iconUrl;
    final lOther$iconUrl = other.iconUrl;
    if (l$iconUrl != lOther$iconUrl) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Query$MapViewport$mapViewport$spots$category
    on Query$MapViewport$mapViewport$spots$category {
  CopyWith$Query$MapViewport$mapViewport$spots$category<
    Query$MapViewport$mapViewport$spots$category
  >
  get copyWith =>
      CopyWith$Query$MapViewport$mapViewport$spots$category(this, (i) => i);
}

abstract class CopyWith$Query$MapViewport$mapViewport$spots$category<TRes> {
  factory CopyWith$Query$MapViewport$mapViewport$spots$category(
    Query$MapViewport$mapViewport$spots$category instance,
    TRes Function(Query$MapViewport$mapViewport$spots$category) then,
  ) = _CopyWithImpl$Query$MapViewport$mapViewport$spots$category;

  factory CopyWith$Query$MapViewport$mapViewport$spots$category.stub(TRes res) =
      _CopyWithStubImpl$Query$MapViewport$mapViewport$spots$category;

  TRes call({String? code, String? label, String? iconUrl});
}

class _CopyWithImpl$Query$MapViewport$mapViewport$spots$category<TRes>
    implements CopyWith$Query$MapViewport$mapViewport$spots$category<TRes> {
  _CopyWithImpl$Query$MapViewport$mapViewport$spots$category(
    this._instance,
    this._then,
  );

  final Query$MapViewport$mapViewport$spots$category _instance;

  final TRes Function(Query$MapViewport$mapViewport$spots$category) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? code = _undefined,
    Object? label = _undefined,
    Object? iconUrl = _undefined,
  }) => _then(
    Query$MapViewport$mapViewport$spots$category(
      code: code == _undefined || code == null
          ? _instance.code
          : (code as String),
      label: label == _undefined || label == null
          ? _instance.label
          : (label as String),
      iconUrl: iconUrl == _undefined ? _instance.iconUrl : (iconUrl as String?),
    ),
  );
}

class _CopyWithStubImpl$Query$MapViewport$mapViewport$spots$category<TRes>
    implements CopyWith$Query$MapViewport$mapViewport$spots$category<TRes> {
  _CopyWithStubImpl$Query$MapViewport$mapViewport$spots$category(this._res);

  TRes _res;

  call({String? code, String? label, String? iconUrl}) => _res;
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

class Variables$Query$RecommendedRegions {
  factory Variables$Query$RecommendedRegions({
    required Input$CoordinatesInput origin,
    int? limit,
  }) => Variables$Query$RecommendedRegions._({
    r'origin': origin,
    if (limit != null) r'limit': limit,
  });

  Variables$Query$RecommendedRegions._(this._$data);

  factory Variables$Query$RecommendedRegions.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    final l$origin = data['origin'];
    result$data['origin'] = Input$CoordinatesInput.fromJson(
      (l$origin as Map<String, dynamic>),
    );
    if (data.containsKey('limit')) {
      final l$limit = data['limit'];
      result$data['limit'] = (l$limit as int?);
    }
    return Variables$Query$RecommendedRegions._(result$data);
  }

  Map<String, dynamic> _$data;

  Input$CoordinatesInput get origin =>
      (_$data['origin'] as Input$CoordinatesInput);

  int? get limit => (_$data['limit'] as int?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$origin = origin;
    result$data['origin'] = l$origin.toJson();
    if (_$data.containsKey('limit')) {
      final l$limit = limit;
      result$data['limit'] = l$limit;
    }
    return result$data;
  }

  CopyWith$Variables$Query$RecommendedRegions<
    Variables$Query$RecommendedRegions
  >
  get copyWith => CopyWith$Variables$Query$RecommendedRegions(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Query$RecommendedRegions ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$origin = origin;
    final lOther$origin = other.origin;
    if (l$origin != lOther$origin) {
      return false;
    }
    final l$limit = limit;
    final lOther$limit = other.limit;
    if (_$data.containsKey('limit') != other._$data.containsKey('limit')) {
      return false;
    }
    if (l$limit != lOther$limit) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$origin = origin;
    final l$limit = limit;
    return Object.hashAll([
      l$origin,
      _$data.containsKey('limit') ? l$limit : const {},
    ]);
  }
}

abstract class CopyWith$Variables$Query$RecommendedRegions<TRes> {
  factory CopyWith$Variables$Query$RecommendedRegions(
    Variables$Query$RecommendedRegions instance,
    TRes Function(Variables$Query$RecommendedRegions) then,
  ) = _CopyWithImpl$Variables$Query$RecommendedRegions;

  factory CopyWith$Variables$Query$RecommendedRegions.stub(TRes res) =
      _CopyWithStubImpl$Variables$Query$RecommendedRegions;

  TRes call({Input$CoordinatesInput? origin, int? limit});
}

class _CopyWithImpl$Variables$Query$RecommendedRegions<TRes>
    implements CopyWith$Variables$Query$RecommendedRegions<TRes> {
  _CopyWithImpl$Variables$Query$RecommendedRegions(this._instance, this._then);

  final Variables$Query$RecommendedRegions _instance;

  final TRes Function(Variables$Query$RecommendedRegions) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? origin = _undefined, Object? limit = _undefined}) => _then(
    Variables$Query$RecommendedRegions._({
      ..._instance._$data,
      if (origin != _undefined && origin != null)
        'origin': (origin as Input$CoordinatesInput),
      if (limit != _undefined) 'limit': (limit as int?),
    }),
  );
}

class _CopyWithStubImpl$Variables$Query$RecommendedRegions<TRes>
    implements CopyWith$Variables$Query$RecommendedRegions<TRes> {
  _CopyWithStubImpl$Variables$Query$RecommendedRegions(this._res);

  TRes _res;

  call({Input$CoordinatesInput? origin, int? limit}) => _res;
}

class Query$RecommendedRegions {
  Query$RecommendedRegions({required this.recommendedRegions});

  factory Query$RecommendedRegions.fromJson(Map<String, dynamic> json) {
    final l$recommendedRegions = json['recommendedRegions'];
    return Query$RecommendedRegions(
      recommendedRegions: Query$RecommendedRegions$recommendedRegions.fromJson(
        (l$recommendedRegions as Map<String, dynamic>),
      ),
    );
  }

  final Query$RecommendedRegions$recommendedRegions recommendedRegions;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$recommendedRegions = recommendedRegions;
    _resultData['recommendedRegions'] = l$recommendedRegions.toJson();
    return _resultData;
  }

  @override
  int get hashCode {
    final l$recommendedRegions = recommendedRegions;
    return Object.hashAll([l$recommendedRegions]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$RecommendedRegions ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$recommendedRegions = recommendedRegions;
    final lOther$recommendedRegions = other.recommendedRegions;
    if (l$recommendedRegions != lOther$recommendedRegions) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Query$RecommendedRegions
    on Query$RecommendedRegions {
  CopyWith$Query$RecommendedRegions<Query$RecommendedRegions> get copyWith =>
      CopyWith$Query$RecommendedRegions(this, (i) => i);
}

abstract class CopyWith$Query$RecommendedRegions<TRes> {
  factory CopyWith$Query$RecommendedRegions(
    Query$RecommendedRegions instance,
    TRes Function(Query$RecommendedRegions) then,
  ) = _CopyWithImpl$Query$RecommendedRegions;

  factory CopyWith$Query$RecommendedRegions.stub(TRes res) =
      _CopyWithStubImpl$Query$RecommendedRegions;

  TRes call({Query$RecommendedRegions$recommendedRegions? recommendedRegions});
  CopyWith$Query$RecommendedRegions$recommendedRegions<TRes>
  get recommendedRegions;
}

class _CopyWithImpl$Query$RecommendedRegions<TRes>
    implements CopyWith$Query$RecommendedRegions<TRes> {
  _CopyWithImpl$Query$RecommendedRegions(this._instance, this._then);

  final Query$RecommendedRegions _instance;

  final TRes Function(Query$RecommendedRegions) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? recommendedRegions = _undefined}) => _then(
    Query$RecommendedRegions(
      recommendedRegions:
          recommendedRegions == _undefined || recommendedRegions == null
          ? _instance.recommendedRegions
          : (recommendedRegions as Query$RecommendedRegions$recommendedRegions),
    ),
  );

  CopyWith$Query$RecommendedRegions$recommendedRegions<TRes>
  get recommendedRegions {
    final local$recommendedRegions = _instance.recommendedRegions;
    return CopyWith$Query$RecommendedRegions$recommendedRegions(
      local$recommendedRegions,
      (e) => call(recommendedRegions: e),
    );
  }
}

class _CopyWithStubImpl$Query$RecommendedRegions<TRes>
    implements CopyWith$Query$RecommendedRegions<TRes> {
  _CopyWithStubImpl$Query$RecommendedRegions(this._res);

  TRes _res;

  call({Query$RecommendedRegions$recommendedRegions? recommendedRegions}) =>
      _res;

  CopyWith$Query$RecommendedRegions$recommendedRegions<TRes>
  get recommendedRegions =>
      CopyWith$Query$RecommendedRegions$recommendedRegions.stub(_res);
}

const documentNodeQueryRecommendedRegions = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'RecommendedRegions'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'origin')),
          type: NamedTypeNode(
            name: NameNode(value: 'CoordinatesInput'),
            isNonNull: true,
          ),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'limit')),
          type: NamedTypeNode(name: NameNode(value: 'Int'), isNonNull: false),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
      ],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'recommendedRegions'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'origin'),
                value: VariableNode(name: NameNode(value: 'origin')),
              ),
              ArgumentNode(
                name: NameNode(value: 'limit'),
                value: VariableNode(name: NameNode(value: 'limit')),
              ),
            ],
            directives: [],
            selectionSet: SelectionSetNode(
              selections: [
                FieldNode(
                  name: NameNode(value: 'regions'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: SelectionSetNode(
                    selections: [
                      FieldNode(
                        name: NameNode(value: 'code'),
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
                        name: NameNode(value: 'provinceName'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'scoreFactorCount'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'center'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: SelectionSetNode(
                          selections: [
                            FieldNode(
                              name: NameNode(value: 'lat'),
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
                          ],
                        ),
                      ),
                      FieldNode(
                        name: NameNode(value: 'scores'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: SelectionSetNode(
                          selections: [
                            FieldNode(
                              name: NameNode(value: 'factor'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null,
                            ),
                            FieldNode(
                              name: NameNode(value: 'value'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null,
                            ),
                            FieldNode(
                              name: NameNode(value: 'rank'),
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
      ),
    ),
  ],
);

class Query$RecommendedRegions$recommendedRegions {
  Query$RecommendedRegions$recommendedRegions({required this.regions});

  factory Query$RecommendedRegions$recommendedRegions.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$regions = json['regions'];
    return Query$RecommendedRegions$recommendedRegions(
      regions: (l$regions as List<dynamic>)
          .map(
            (e) => Query$RecommendedRegions$recommendedRegions$regions.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
    );
  }

  final List<Query$RecommendedRegions$recommendedRegions$regions> regions;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$regions = regions;
    _resultData['regions'] = l$regions.map((e) => e.toJson()).toList();
    return _resultData;
  }

  @override
  int get hashCode {
    final l$regions = regions;
    return Object.hashAll([Object.hashAll(l$regions.map((v) => v))]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$RecommendedRegions$recommendedRegions ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$regions = regions;
    final lOther$regions = other.regions;
    if (l$regions.length != lOther$regions.length) {
      return false;
    }
    for (int i = 0; i < l$regions.length; i++) {
      final l$regions$entry = l$regions[i];
      final lOther$regions$entry = lOther$regions[i];
      if (l$regions$entry != lOther$regions$entry) {
        return false;
      }
    }
    return true;
  }
}

extension UtilityExtension$Query$RecommendedRegions$recommendedRegions
    on Query$RecommendedRegions$recommendedRegions {
  CopyWith$Query$RecommendedRegions$recommendedRegions<
    Query$RecommendedRegions$recommendedRegions
  >
  get copyWith =>
      CopyWith$Query$RecommendedRegions$recommendedRegions(this, (i) => i);
}

abstract class CopyWith$Query$RecommendedRegions$recommendedRegions<TRes> {
  factory CopyWith$Query$RecommendedRegions$recommendedRegions(
    Query$RecommendedRegions$recommendedRegions instance,
    TRes Function(Query$RecommendedRegions$recommendedRegions) then,
  ) = _CopyWithImpl$Query$RecommendedRegions$recommendedRegions;

  factory CopyWith$Query$RecommendedRegions$recommendedRegions.stub(TRes res) =
      _CopyWithStubImpl$Query$RecommendedRegions$recommendedRegions;

  TRes call({
    List<Query$RecommendedRegions$recommendedRegions$regions>? regions,
  });
  TRes regions(
    Iterable<Query$RecommendedRegions$recommendedRegions$regions> Function(
      Iterable<
        CopyWith$Query$RecommendedRegions$recommendedRegions$regions<
          Query$RecommendedRegions$recommendedRegions$regions
        >
      >,
    )
    _fn,
  );
}

class _CopyWithImpl$Query$RecommendedRegions$recommendedRegions<TRes>
    implements CopyWith$Query$RecommendedRegions$recommendedRegions<TRes> {
  _CopyWithImpl$Query$RecommendedRegions$recommendedRegions(
    this._instance,
    this._then,
  );

  final Query$RecommendedRegions$recommendedRegions _instance;

  final TRes Function(Query$RecommendedRegions$recommendedRegions) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? regions = _undefined}) => _then(
    Query$RecommendedRegions$recommendedRegions(
      regions: regions == _undefined || regions == null
          ? _instance.regions
          : (regions
                as List<Query$RecommendedRegions$recommendedRegions$regions>),
    ),
  );

  TRes regions(
    Iterable<Query$RecommendedRegions$recommendedRegions$regions> Function(
      Iterable<
        CopyWith$Query$RecommendedRegions$recommendedRegions$regions<
          Query$RecommendedRegions$recommendedRegions$regions
        >
      >,
    )
    _fn,
  ) => call(
    regions: _fn(
      _instance.regions.map(
        (e) => CopyWith$Query$RecommendedRegions$recommendedRegions$regions(
          e,
          (i) => i,
        ),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl$Query$RecommendedRegions$recommendedRegions<TRes>
    implements CopyWith$Query$RecommendedRegions$recommendedRegions<TRes> {
  _CopyWithStubImpl$Query$RecommendedRegions$recommendedRegions(this._res);

  TRes _res;

  call({List<Query$RecommendedRegions$recommendedRegions$regions>? regions}) =>
      _res;

  regions(_fn) => _res;
}

class Query$RecommendedRegions$recommendedRegions$regions {
  Query$RecommendedRegions$recommendedRegions$regions({
    required this.code,
    required this.name,
    required this.provinceName,
    required this.scoreFactorCount,
    required this.center,
    required this.scores,
  });

  factory Query$RecommendedRegions$recommendedRegions$regions.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$code = json['code'];
    final l$name = json['name'];
    final l$provinceName = json['provinceName'];
    final l$scoreFactorCount = json['scoreFactorCount'];
    final l$center = json['center'];
    final l$scores = json['scores'];
    return Query$RecommendedRegions$recommendedRegions$regions(
      code: (l$code as String),
      name: (l$name as String),
      provinceName: (l$provinceName as String),
      scoreFactorCount: (l$scoreFactorCount as int),
      center:
          Query$RecommendedRegions$recommendedRegions$regions$center.fromJson(
            (l$center as Map<String, dynamic>),
          ),
      scores: (l$scores as List<dynamic>)
          .map(
            (e) =>
                Query$RecommendedRegions$recommendedRegions$regions$scores.fromJson(
                  (e as Map<String, dynamic>),
                ),
          )
          .toList(),
    );
  }

  final String code;

  final String name;

  final String provinceName;

  final int scoreFactorCount;

  final Query$RecommendedRegions$recommendedRegions$regions$center center;

  final List<Query$RecommendedRegions$recommendedRegions$regions$scores> scores;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$code = code;
    _resultData['code'] = l$code;
    final l$name = name;
    _resultData['name'] = l$name;
    final l$provinceName = provinceName;
    _resultData['provinceName'] = l$provinceName;
    final l$scoreFactorCount = scoreFactorCount;
    _resultData['scoreFactorCount'] = l$scoreFactorCount;
    final l$center = center;
    _resultData['center'] = l$center.toJson();
    final l$scores = scores;
    _resultData['scores'] = l$scores.map((e) => e.toJson()).toList();
    return _resultData;
  }

  @override
  int get hashCode {
    final l$code = code;
    final l$name = name;
    final l$provinceName = provinceName;
    final l$scoreFactorCount = scoreFactorCount;
    final l$center = center;
    final l$scores = scores;
    return Object.hashAll([
      l$code,
      l$name,
      l$provinceName,
      l$scoreFactorCount,
      l$center,
      Object.hashAll(l$scores.map((v) => v)),
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$RecommendedRegions$recommendedRegions$regions ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$code = code;
    final lOther$code = other.code;
    if (l$code != lOther$code) {
      return false;
    }
    final l$name = name;
    final lOther$name = other.name;
    if (l$name != lOther$name) {
      return false;
    }
    final l$provinceName = provinceName;
    final lOther$provinceName = other.provinceName;
    if (l$provinceName != lOther$provinceName) {
      return false;
    }
    final l$scoreFactorCount = scoreFactorCount;
    final lOther$scoreFactorCount = other.scoreFactorCount;
    if (l$scoreFactorCount != lOther$scoreFactorCount) {
      return false;
    }
    final l$center = center;
    final lOther$center = other.center;
    if (l$center != lOther$center) {
      return false;
    }
    final l$scores = scores;
    final lOther$scores = other.scores;
    if (l$scores.length != lOther$scores.length) {
      return false;
    }
    for (int i = 0; i < l$scores.length; i++) {
      final l$scores$entry = l$scores[i];
      final lOther$scores$entry = lOther$scores[i];
      if (l$scores$entry != lOther$scores$entry) {
        return false;
      }
    }
    return true;
  }
}

extension UtilityExtension$Query$RecommendedRegions$recommendedRegions$regions
    on Query$RecommendedRegions$recommendedRegions$regions {
  CopyWith$Query$RecommendedRegions$recommendedRegions$regions<
    Query$RecommendedRegions$recommendedRegions$regions
  >
  get copyWith => CopyWith$Query$RecommendedRegions$recommendedRegions$regions(
    this,
    (i) => i,
  );
}

abstract class CopyWith$Query$RecommendedRegions$recommendedRegions$regions<
  TRes
> {
  factory CopyWith$Query$RecommendedRegions$recommendedRegions$regions(
    Query$RecommendedRegions$recommendedRegions$regions instance,
    TRes Function(Query$RecommendedRegions$recommendedRegions$regions) then,
  ) = _CopyWithImpl$Query$RecommendedRegions$recommendedRegions$regions;

  factory CopyWith$Query$RecommendedRegions$recommendedRegions$regions.stub(
    TRes res,
  ) = _CopyWithStubImpl$Query$RecommendedRegions$recommendedRegions$regions;

  TRes call({
    String? code,
    String? name,
    String? provinceName,
    int? scoreFactorCount,
    Query$RecommendedRegions$recommendedRegions$regions$center? center,
    List<Query$RecommendedRegions$recommendedRegions$regions$scores>? scores,
  });
  CopyWith$Query$RecommendedRegions$recommendedRegions$regions$center<TRes>
  get center;
  TRes scores(
    Iterable<Query$RecommendedRegions$recommendedRegions$regions$scores>
    Function(
      Iterable<
        CopyWith$Query$RecommendedRegions$recommendedRegions$regions$scores<
          Query$RecommendedRegions$recommendedRegions$regions$scores
        >
      >,
    )
    _fn,
  );
}

class _CopyWithImpl$Query$RecommendedRegions$recommendedRegions$regions<TRes>
    implements
        CopyWith$Query$RecommendedRegions$recommendedRegions$regions<TRes> {
  _CopyWithImpl$Query$RecommendedRegions$recommendedRegions$regions(
    this._instance,
    this._then,
  );

  final Query$RecommendedRegions$recommendedRegions$regions _instance;

  final TRes Function(Query$RecommendedRegions$recommendedRegions$regions)
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? code = _undefined,
    Object? name = _undefined,
    Object? provinceName = _undefined,
    Object? scoreFactorCount = _undefined,
    Object? center = _undefined,
    Object? scores = _undefined,
  }) => _then(
    Query$RecommendedRegions$recommendedRegions$regions(
      code: code == _undefined || code == null
          ? _instance.code
          : (code as String),
      name: name == _undefined || name == null
          ? _instance.name
          : (name as String),
      provinceName: provinceName == _undefined || provinceName == null
          ? _instance.provinceName
          : (provinceName as String),
      scoreFactorCount:
          scoreFactorCount == _undefined || scoreFactorCount == null
          ? _instance.scoreFactorCount
          : (scoreFactorCount as int),
      center: center == _undefined || center == null
          ? _instance.center
          : (center
                as Query$RecommendedRegions$recommendedRegions$regions$center),
      scores: scores == _undefined || scores == null
          ? _instance.scores
          : (scores
                as List<
                  Query$RecommendedRegions$recommendedRegions$regions$scores
                >),
    ),
  );

  CopyWith$Query$RecommendedRegions$recommendedRegions$regions$center<TRes>
  get center {
    final local$center = _instance.center;
    return CopyWith$Query$RecommendedRegions$recommendedRegions$regions$center(
      local$center,
      (e) => call(center: e),
    );
  }

  TRes scores(
    Iterable<Query$RecommendedRegions$recommendedRegions$regions$scores>
    Function(
      Iterable<
        CopyWith$Query$RecommendedRegions$recommendedRegions$regions$scores<
          Query$RecommendedRegions$recommendedRegions$regions$scores
        >
      >,
    )
    _fn,
  ) => call(
    scores: _fn(
      _instance.scores.map(
        (e) =>
            CopyWith$Query$RecommendedRegions$recommendedRegions$regions$scores(
              e,
              (i) => i,
            ),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl$Query$RecommendedRegions$recommendedRegions$regions<
  TRes
>
    implements
        CopyWith$Query$RecommendedRegions$recommendedRegions$regions<TRes> {
  _CopyWithStubImpl$Query$RecommendedRegions$recommendedRegions$regions(
    this._res,
  );

  TRes _res;

  call({
    String? code,
    String? name,
    String? provinceName,
    int? scoreFactorCount,
    Query$RecommendedRegions$recommendedRegions$regions$center? center,
    List<Query$RecommendedRegions$recommendedRegions$regions$scores>? scores,
  }) => _res;

  CopyWith$Query$RecommendedRegions$recommendedRegions$regions$center<TRes>
  get center =>
      CopyWith$Query$RecommendedRegions$recommendedRegions$regions$center.stub(
        _res,
      );

  scores(_fn) => _res;
}

class Query$RecommendedRegions$recommendedRegions$regions$center {
  Query$RecommendedRegions$recommendedRegions$regions$center({
    required this.lat,
    required this.lng,
  });

  factory Query$RecommendedRegions$recommendedRegions$regions$center.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$lat = json['lat'];
    final l$lng = json['lng'];
    return Query$RecommendedRegions$recommendedRegions$regions$center(
      lat: (l$lat as num).toDouble(),
      lng: (l$lng as num).toDouble(),
    );
  }

  final double lat;

  final double lng;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$lat = lat;
    _resultData['lat'] = l$lat;
    final l$lng = lng;
    _resultData['lng'] = l$lng;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$lat = lat;
    final l$lng = lng;
    return Object.hashAll([l$lat, l$lng]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$RecommendedRegions$recommendedRegions$regions$center ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$lat = lat;
    final lOther$lat = other.lat;
    if (l$lat != lOther$lat) {
      return false;
    }
    final l$lng = lng;
    final lOther$lng = other.lng;
    if (l$lng != lOther$lng) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Query$RecommendedRegions$recommendedRegions$regions$center
    on Query$RecommendedRegions$recommendedRegions$regions$center {
  CopyWith$Query$RecommendedRegions$recommendedRegions$regions$center<
    Query$RecommendedRegions$recommendedRegions$regions$center
  >
  get copyWith =>
      CopyWith$Query$RecommendedRegions$recommendedRegions$regions$center(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Query$RecommendedRegions$recommendedRegions$regions$center<
  TRes
> {
  factory CopyWith$Query$RecommendedRegions$recommendedRegions$regions$center(
    Query$RecommendedRegions$recommendedRegions$regions$center instance,
    TRes Function(Query$RecommendedRegions$recommendedRegions$regions$center)
    then,
  ) = _CopyWithImpl$Query$RecommendedRegions$recommendedRegions$regions$center;

  factory CopyWith$Query$RecommendedRegions$recommendedRegions$regions$center.stub(
    TRes res,
  ) = _CopyWithStubImpl$Query$RecommendedRegions$recommendedRegions$regions$center;

  TRes call({double? lat, double? lng});
}

class _CopyWithImpl$Query$RecommendedRegions$recommendedRegions$regions$center<
  TRes
>
    implements
        CopyWith$Query$RecommendedRegions$recommendedRegions$regions$center<
          TRes
        > {
  _CopyWithImpl$Query$RecommendedRegions$recommendedRegions$regions$center(
    this._instance,
    this._then,
  );

  final Query$RecommendedRegions$recommendedRegions$regions$center _instance;

  final TRes Function(
    Query$RecommendedRegions$recommendedRegions$regions$center,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? lat = _undefined, Object? lng = _undefined}) => _then(
    Query$RecommendedRegions$recommendedRegions$regions$center(
      lat: lat == _undefined || lat == null ? _instance.lat : (lat as double),
      lng: lng == _undefined || lng == null ? _instance.lng : (lng as double),
    ),
  );
}

class _CopyWithStubImpl$Query$RecommendedRegions$recommendedRegions$regions$center<
  TRes
>
    implements
        CopyWith$Query$RecommendedRegions$recommendedRegions$regions$center<
          TRes
        > {
  _CopyWithStubImpl$Query$RecommendedRegions$recommendedRegions$regions$center(
    this._res,
  );

  TRes _res;

  call({double? lat, double? lng}) => _res;
}

class Query$RecommendedRegions$recommendedRegions$regions$scores {
  Query$RecommendedRegions$recommendedRegions$regions$scores({
    required this.factor,
    required this.value,
    required this.rank,
  });

  factory Query$RecommendedRegions$recommendedRegions$regions$scores.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$factor = json['factor'];
    final l$value = json['value'];
    final l$rank = json['rank'];
    return Query$RecommendedRegions$recommendedRegions$regions$scores(
      factor: fromJson$Enum$RegionScoreFactor((l$factor as String)),
      value: (l$value as num).toDouble(),
      rank: (l$rank as int),
    );
  }

  final Enum$RegionScoreFactor factor;

  final double value;

  final int rank;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$factor = factor;
    _resultData['factor'] = toJson$Enum$RegionScoreFactor(l$factor);
    final l$value = value;
    _resultData['value'] = l$value;
    final l$rank = rank;
    _resultData['rank'] = l$rank;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$factor = factor;
    final l$value = value;
    final l$rank = rank;
    return Object.hashAll([l$factor, l$value, l$rank]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$RecommendedRegions$recommendedRegions$regions$scores ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$factor = factor;
    final lOther$factor = other.factor;
    if (l$factor != lOther$factor) {
      return false;
    }
    final l$value = value;
    final lOther$value = other.value;
    if (l$value != lOther$value) {
      return false;
    }
    final l$rank = rank;
    final lOther$rank = other.rank;
    if (l$rank != lOther$rank) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Query$RecommendedRegions$recommendedRegions$regions$scores
    on Query$RecommendedRegions$recommendedRegions$regions$scores {
  CopyWith$Query$RecommendedRegions$recommendedRegions$regions$scores<
    Query$RecommendedRegions$recommendedRegions$regions$scores
  >
  get copyWith =>
      CopyWith$Query$RecommendedRegions$recommendedRegions$regions$scores(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Query$RecommendedRegions$recommendedRegions$regions$scores<
  TRes
> {
  factory CopyWith$Query$RecommendedRegions$recommendedRegions$regions$scores(
    Query$RecommendedRegions$recommendedRegions$regions$scores instance,
    TRes Function(Query$RecommendedRegions$recommendedRegions$regions$scores)
    then,
  ) = _CopyWithImpl$Query$RecommendedRegions$recommendedRegions$regions$scores;

  factory CopyWith$Query$RecommendedRegions$recommendedRegions$regions$scores.stub(
    TRes res,
  ) = _CopyWithStubImpl$Query$RecommendedRegions$recommendedRegions$regions$scores;

  TRes call({Enum$RegionScoreFactor? factor, double? value, int? rank});
}

class _CopyWithImpl$Query$RecommendedRegions$recommendedRegions$regions$scores<
  TRes
>
    implements
        CopyWith$Query$RecommendedRegions$recommendedRegions$regions$scores<
          TRes
        > {
  _CopyWithImpl$Query$RecommendedRegions$recommendedRegions$regions$scores(
    this._instance,
    this._then,
  );

  final Query$RecommendedRegions$recommendedRegions$regions$scores _instance;

  final TRes Function(
    Query$RecommendedRegions$recommendedRegions$regions$scores,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? factor = _undefined,
    Object? value = _undefined,
    Object? rank = _undefined,
  }) => _then(
    Query$RecommendedRegions$recommendedRegions$regions$scores(
      factor: factor == _undefined || factor == null
          ? _instance.factor
          : (factor as Enum$RegionScoreFactor),
      value: value == _undefined || value == null
          ? _instance.value
          : (value as double),
      rank: rank == _undefined || rank == null ? _instance.rank : (rank as int),
    ),
  );
}

class _CopyWithStubImpl$Query$RecommendedRegions$recommendedRegions$regions$scores<
  TRes
>
    implements
        CopyWith$Query$RecommendedRegions$recommendedRegions$regions$scores<
          TRes
        > {
  _CopyWithStubImpl$Query$RecommendedRegions$recommendedRegions$regions$scores(
    this._res,
  );

  TRes _res;

  call({Enum$RegionScoreFactor? factor, double? value, int? rank}) => _res;
}
