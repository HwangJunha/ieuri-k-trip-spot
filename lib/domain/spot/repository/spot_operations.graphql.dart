// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, unused_element
import 'package:gql/ast.dart';
import 'spot_schema.graphql.dart';

class Variables$Query$Spots {
  factory Variables$Query$Spots({
    required double latitude,
    required double longitude,
    int? radiusMeters,
    List<String>? categories,
    bool? hasOrigin,
    int? page,
    int? size,
  }) => Variables$Query$Spots._({
    r'latitude': latitude,
    r'longitude': longitude,
    if (radiusMeters != null) r'radiusMeters': radiusMeters,
    if (categories != null) r'categories': categories,
    if (hasOrigin != null) r'hasOrigin': hasOrigin,
    if (page != null) r'page': page,
    if (size != null) r'size': size,
  });

  Variables$Query$Spots._(this._$data);

  factory Variables$Query$Spots.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$latitude = data['latitude'];
    result$data['latitude'] = (l$latitude as num).toDouble();
    final l$longitude = data['longitude'];
    result$data['longitude'] = (l$longitude as num).toDouble();
    if (data.containsKey('radiusMeters')) {
      final l$radiusMeters = data['radiusMeters'];
      result$data['radiusMeters'] = (l$radiusMeters as int?);
    }
    if (data.containsKey('categories')) {
      final l$categories = data['categories'];
      result$data['categories'] = (l$categories as List<dynamic>?)
          ?.map((e) => (e as String))
          .toList();
    }
    if (data.containsKey('hasOrigin')) {
      final l$hasOrigin = data['hasOrigin'];
      result$data['hasOrigin'] = (l$hasOrigin as bool?);
    }
    if (data.containsKey('page')) {
      final l$page = data['page'];
      result$data['page'] = (l$page as int?);
    }
    if (data.containsKey('size')) {
      final l$size = data['size'];
      result$data['size'] = (l$size as int?);
    }
    return Variables$Query$Spots._(result$data);
  }

  Map<String, dynamic> _$data;

  double get latitude => (_$data['latitude'] as double);

  double get longitude => (_$data['longitude'] as double);

  int? get radiusMeters => (_$data['radiusMeters'] as int?);

  List<String>? get categories => (_$data['categories'] as List<String>?);

  bool? get hasOrigin => (_$data['hasOrigin'] as bool?);

  int? get page => (_$data['page'] as int?);

  int? get size => (_$data['size'] as int?);

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
    if (_$data.containsKey('categories')) {
      final l$categories = categories;
      result$data['categories'] = l$categories?.map((e) => e).toList();
    }
    if (_$data.containsKey('hasOrigin')) {
      final l$hasOrigin = hasOrigin;
      result$data['hasOrigin'] = l$hasOrigin;
    }
    if (_$data.containsKey('page')) {
      final l$page = page;
      result$data['page'] = l$page;
    }
    if (_$data.containsKey('size')) {
      final l$size = size;
      result$data['size'] = l$size;
    }
    return result$data;
  }

  CopyWith$Variables$Query$Spots<Variables$Query$Spots> get copyWith =>
      CopyWith$Variables$Query$Spots(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Query$Spots || runtimeType != other.runtimeType) {
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
    final l$hasOrigin = hasOrigin;
    final lOther$hasOrigin = other.hasOrigin;
    if (_$data.containsKey('hasOrigin') !=
        other._$data.containsKey('hasOrigin')) {
      return false;
    }
    if (l$hasOrigin != lOther$hasOrigin) {
      return false;
    }
    final l$page = page;
    final lOther$page = other.page;
    if (_$data.containsKey('page') != other._$data.containsKey('page')) {
      return false;
    }
    if (l$page != lOther$page) {
      return false;
    }
    final l$size = size;
    final lOther$size = other.size;
    if (_$data.containsKey('size') != other._$data.containsKey('size')) {
      return false;
    }
    if (l$size != lOther$size) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$latitude = latitude;
    final l$longitude = longitude;
    final l$radiusMeters = radiusMeters;
    final l$categories = categories;
    final l$hasOrigin = hasOrigin;
    final l$page = page;
    final l$size = size;
    return Object.hashAll([
      l$latitude,
      l$longitude,
      _$data.containsKey('radiusMeters') ? l$radiusMeters : const {},
      _$data.containsKey('categories')
          ? l$categories == null
                ? null
                : Object.hashAll(l$categories.map((v) => v))
          : const {},
      _$data.containsKey('hasOrigin') ? l$hasOrigin : const {},
      _$data.containsKey('page') ? l$page : const {},
      _$data.containsKey('size') ? l$size : const {},
    ]);
  }
}

abstract class CopyWith$Variables$Query$Spots<TRes> {
  factory CopyWith$Variables$Query$Spots(
    Variables$Query$Spots instance,
    TRes Function(Variables$Query$Spots) then,
  ) = _CopyWithImpl$Variables$Query$Spots;

  factory CopyWith$Variables$Query$Spots.stub(TRes res) =
      _CopyWithStubImpl$Variables$Query$Spots;

  TRes call({
    double? latitude,
    double? longitude,
    int? radiusMeters,
    List<String>? categories,
    bool? hasOrigin,
    int? page,
    int? size,
  });
}

class _CopyWithImpl$Variables$Query$Spots<TRes>
    implements CopyWith$Variables$Query$Spots<TRes> {
  _CopyWithImpl$Variables$Query$Spots(this._instance, this._then);

  final Variables$Query$Spots _instance;

  final TRes Function(Variables$Query$Spots) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? latitude = _undefined,
    Object? longitude = _undefined,
    Object? radiusMeters = _undefined,
    Object? categories = _undefined,
    Object? hasOrigin = _undefined,
    Object? page = _undefined,
    Object? size = _undefined,
  }) => _then(
    Variables$Query$Spots._({
      ..._instance._$data,
      if (latitude != _undefined && latitude != null)
        'latitude': (latitude as double),
      if (longitude != _undefined && longitude != null)
        'longitude': (longitude as double),
      if (radiusMeters != _undefined) 'radiusMeters': (radiusMeters as int?),
      if (categories != _undefined) 'categories': (categories as List<String>?),
      if (hasOrigin != _undefined) 'hasOrigin': (hasOrigin as bool?),
      if (page != _undefined) 'page': (page as int?),
      if (size != _undefined) 'size': (size as int?),
    }),
  );
}

class _CopyWithStubImpl$Variables$Query$Spots<TRes>
    implements CopyWith$Variables$Query$Spots<TRes> {
  _CopyWithStubImpl$Variables$Query$Spots(this._res);

  TRes _res;

  call({
    double? latitude,
    double? longitude,
    int? radiusMeters,
    List<String>? categories,
    bool? hasOrigin,
    int? page,
    int? size,
  }) => _res;
}

class Query$Spots {
  Query$Spots({required this.spots});

  factory Query$Spots.fromJson(Map<String, dynamic> json) {
    final l$spots = json['spots'];
    return Query$Spots(
      spots: Query$Spots$spots.fromJson((l$spots as Map<String, dynamic>)),
    );
  }

  final Query$Spots$spots spots;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$spots = spots;
    _resultData['spots'] = l$spots.toJson();
    return _resultData;
  }

  @override
  int get hashCode {
    final l$spots = spots;
    return Object.hashAll([l$spots]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$Spots || runtimeType != other.runtimeType) {
      return false;
    }
    final l$spots = spots;
    final lOther$spots = other.spots;
    if (l$spots != lOther$spots) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Query$Spots on Query$Spots {
  CopyWith$Query$Spots<Query$Spots> get copyWith =>
      CopyWith$Query$Spots(this, (i) => i);
}

abstract class CopyWith$Query$Spots<TRes> {
  factory CopyWith$Query$Spots(
    Query$Spots instance,
    TRes Function(Query$Spots) then,
  ) = _CopyWithImpl$Query$Spots;

  factory CopyWith$Query$Spots.stub(TRes res) = _CopyWithStubImpl$Query$Spots;

  TRes call({Query$Spots$spots? spots});
  CopyWith$Query$Spots$spots<TRes> get spots;
}

class _CopyWithImpl$Query$Spots<TRes> implements CopyWith$Query$Spots<TRes> {
  _CopyWithImpl$Query$Spots(this._instance, this._then);

  final Query$Spots _instance;

  final TRes Function(Query$Spots) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? spots = _undefined}) => _then(
    Query$Spots(
      spots: spots == _undefined || spots == null
          ? _instance.spots
          : (spots as Query$Spots$spots),
    ),
  );

  CopyWith$Query$Spots$spots<TRes> get spots {
    final local$spots = _instance.spots;
    return CopyWith$Query$Spots$spots(local$spots, (e) => call(spots: e));
  }
}

class _CopyWithStubImpl$Query$Spots<TRes>
    implements CopyWith$Query$Spots<TRes> {
  _CopyWithStubImpl$Query$Spots(this._res);

  TRes _res;

  call({Query$Spots$spots? spots}) => _res;

  CopyWith$Query$Spots$spots<TRes> get spots =>
      CopyWith$Query$Spots$spots.stub(_res);
}

const documentNodeQuerySpots = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'Spots'),
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
          variable: VariableNode(name: NameNode(value: 'page')),
          type: NamedTypeNode(name: NameNode(value: 'Int'), isNonNull: false),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'size')),
          type: NamedTypeNode(name: NameNode(value: 'Int'), isNonNull: false),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
      ],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'spots'),
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
                name: NameNode(value: 'categories'),
                value: VariableNode(name: NameNode(value: 'categories')),
              ),
              ArgumentNode(
                name: NameNode(value: 'hasOrigin'),
                value: VariableNode(name: NameNode(value: 'hasOrigin')),
              ),
              ArgumentNode(
                name: NameNode(value: 'page'),
                value: VariableNode(name: NameNode(value: 'page')),
              ),
              ArgumentNode(
                name: NameNode(value: 'size'),
                value: VariableNode(name: NameNode(value: 'size')),
              ),
            ],
            directives: [],
            selectionSet: SelectionSetNode(
              selections: [
                FieldNode(
                  name: NameNode(value: 'items'),
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
                        name: NameNode(value: 'copyright'),
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
                    ],
                  ),
                ),
                FieldNode(
                  name: NameNode(value: 'page'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: 'hasNext'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: 'totalCount'),
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

class Query$Spots$spots {
  Query$Spots$spots({
    required this.items,
    required this.page,
    required this.hasNext,
    this.totalCount,
  });

  factory Query$Spots$spots.fromJson(Map<String, dynamic> json) {
    final l$items = json['items'];
    final l$page = json['page'];
    final l$hasNext = json['hasNext'];
    final l$totalCount = json['totalCount'];
    return Query$Spots$spots(
      items: (l$items as List<dynamic>)
          .map(
            (e) =>
                Query$Spots$spots$items.fromJson((e as Map<String, dynamic>)),
          )
          .toList(),
      page: (l$page as int),
      hasNext: (l$hasNext as bool),
      totalCount: (l$totalCount as int?),
    );
  }

  final List<Query$Spots$spots$items> items;

  final int page;

  final bool hasNext;

  final int? totalCount;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$items = items;
    _resultData['items'] = l$items.map((e) => e.toJson()).toList();
    final l$page = page;
    _resultData['page'] = l$page;
    final l$hasNext = hasNext;
    _resultData['hasNext'] = l$hasNext;
    final l$totalCount = totalCount;
    _resultData['totalCount'] = l$totalCount;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$items = items;
    final l$page = page;
    final l$hasNext = hasNext;
    final l$totalCount = totalCount;
    return Object.hashAll([
      Object.hashAll(l$items.map((v) => v)),
      l$page,
      l$hasNext,
      l$totalCount,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$Spots$spots || runtimeType != other.runtimeType) {
      return false;
    }
    final l$items = items;
    final lOther$items = other.items;
    if (l$items.length != lOther$items.length) {
      return false;
    }
    for (int i = 0; i < l$items.length; i++) {
      final l$items$entry = l$items[i];
      final lOther$items$entry = lOther$items[i];
      if (l$items$entry != lOther$items$entry) {
        return false;
      }
    }
    final l$page = page;
    final lOther$page = other.page;
    if (l$page != lOther$page) {
      return false;
    }
    final l$hasNext = hasNext;
    final lOther$hasNext = other.hasNext;
    if (l$hasNext != lOther$hasNext) {
      return false;
    }
    final l$totalCount = totalCount;
    final lOther$totalCount = other.totalCount;
    if (l$totalCount != lOther$totalCount) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Query$Spots$spots on Query$Spots$spots {
  CopyWith$Query$Spots$spots<Query$Spots$spots> get copyWith =>
      CopyWith$Query$Spots$spots(this, (i) => i);
}

abstract class CopyWith$Query$Spots$spots<TRes> {
  factory CopyWith$Query$Spots$spots(
    Query$Spots$spots instance,
    TRes Function(Query$Spots$spots) then,
  ) = _CopyWithImpl$Query$Spots$spots;

  factory CopyWith$Query$Spots$spots.stub(TRes res) =
      _CopyWithStubImpl$Query$Spots$spots;

  TRes call({
    List<Query$Spots$spots$items>? items,
    int? page,
    bool? hasNext,
    int? totalCount,
  });
  TRes items(
    Iterable<Query$Spots$spots$items> Function(
      Iterable<CopyWith$Query$Spots$spots$items<Query$Spots$spots$items>>,
    )
    _fn,
  );
}

class _CopyWithImpl$Query$Spots$spots<TRes>
    implements CopyWith$Query$Spots$spots<TRes> {
  _CopyWithImpl$Query$Spots$spots(this._instance, this._then);

  final Query$Spots$spots _instance;

  final TRes Function(Query$Spots$spots) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? items = _undefined,
    Object? page = _undefined,
    Object? hasNext = _undefined,
    Object? totalCount = _undefined,
  }) => _then(
    Query$Spots$spots(
      items: items == _undefined || items == null
          ? _instance.items
          : (items as List<Query$Spots$spots$items>),
      page: page == _undefined || page == null ? _instance.page : (page as int),
      hasNext: hasNext == _undefined || hasNext == null
          ? _instance.hasNext
          : (hasNext as bool),
      totalCount: totalCount == _undefined
          ? _instance.totalCount
          : (totalCount as int?),
    ),
  );

  TRes items(
    Iterable<Query$Spots$spots$items> Function(
      Iterable<CopyWith$Query$Spots$spots$items<Query$Spots$spots$items>>,
    )
    _fn,
  ) => call(
    items: _fn(
      _instance.items.map((e) => CopyWith$Query$Spots$spots$items(e, (i) => i)),
    ).toList(),
  );
}

class _CopyWithStubImpl$Query$Spots$spots<TRes>
    implements CopyWith$Query$Spots$spots<TRes> {
  _CopyWithStubImpl$Query$Spots$spots(this._res);

  TRes _res;

  call({
    List<Query$Spots$spots$items>? items,
    int? page,
    bool? hasNext,
    int? totalCount,
  }) => _res;

  items(_fn) => _res;
}

class Query$Spots$spots$items {
  Query$Spots$spots$items({
    required this.id,
    required this.title,
    this.address,
    required this.thumbnailImageUrl,
    required this.distanceMeters,
    required this.category,
    required this.copyright,
    required this.attributionText,
  });

  factory Query$Spots$spots$items.fromJson(Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$title = json['title'];
    final l$address = json['address'];
    final l$thumbnailImageUrl = json['thumbnailImageUrl'];
    final l$distanceMeters = json['distanceMeters'];
    final l$category = json['category'];
    final l$copyright = json['copyright'];
    final l$attributionText = json['attributionText'];
    return Query$Spots$spots$items(
      id: (l$id as String),
      title: (l$title as String),
      address: (l$address as String?),
      thumbnailImageUrl: (l$thumbnailImageUrl as String),
      distanceMeters: (l$distanceMeters as num).toDouble(),
      category: Query$Spots$spots$items$category.fromJson(
        (l$category as Map<String, dynamic>),
      ),
      copyright: fromJson$Enum$CopyrightType((l$copyright as String)),
      attributionText: (l$attributionText as String),
    );
  }

  final String id;

  final String title;

  final String? address;

  final String thumbnailImageUrl;

  final double distanceMeters;

  final Query$Spots$spots$items$category category;

  final Enum$CopyrightType copyright;

  final String attributionText;

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
    final l$category = category;
    _resultData['category'] = l$category.toJson();
    final l$copyright = copyright;
    _resultData['copyright'] = toJson$Enum$CopyrightType(l$copyright);
    final l$attributionText = attributionText;
    _resultData['attributionText'] = l$attributionText;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$title = title;
    final l$address = address;
    final l$thumbnailImageUrl = thumbnailImageUrl;
    final l$distanceMeters = distanceMeters;
    final l$category = category;
    final l$copyright = copyright;
    final l$attributionText = attributionText;
    return Object.hashAll([
      l$id,
      l$title,
      l$address,
      l$thumbnailImageUrl,
      l$distanceMeters,
      l$category,
      l$copyright,
      l$attributionText,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$Spots$spots$items || runtimeType != other.runtimeType) {
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
    final l$category = category;
    final lOther$category = other.category;
    if (l$category != lOther$category) {
      return false;
    }
    final l$copyright = copyright;
    final lOther$copyright = other.copyright;
    if (l$copyright != lOther$copyright) {
      return false;
    }
    final l$attributionText = attributionText;
    final lOther$attributionText = other.attributionText;
    if (l$attributionText != lOther$attributionText) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Query$Spots$spots$items on Query$Spots$spots$items {
  CopyWith$Query$Spots$spots$items<Query$Spots$spots$items> get copyWith =>
      CopyWith$Query$Spots$spots$items(this, (i) => i);
}

abstract class CopyWith$Query$Spots$spots$items<TRes> {
  factory CopyWith$Query$Spots$spots$items(
    Query$Spots$spots$items instance,
    TRes Function(Query$Spots$spots$items) then,
  ) = _CopyWithImpl$Query$Spots$spots$items;

  factory CopyWith$Query$Spots$spots$items.stub(TRes res) =
      _CopyWithStubImpl$Query$Spots$spots$items;

  TRes call({
    String? id,
    String? title,
    String? address,
    String? thumbnailImageUrl,
    double? distanceMeters,
    Query$Spots$spots$items$category? category,
    Enum$CopyrightType? copyright,
    String? attributionText,
  });
  CopyWith$Query$Spots$spots$items$category<TRes> get category;
}

class _CopyWithImpl$Query$Spots$spots$items<TRes>
    implements CopyWith$Query$Spots$spots$items<TRes> {
  _CopyWithImpl$Query$Spots$spots$items(this._instance, this._then);

  final Query$Spots$spots$items _instance;

  final TRes Function(Query$Spots$spots$items) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? title = _undefined,
    Object? address = _undefined,
    Object? thumbnailImageUrl = _undefined,
    Object? distanceMeters = _undefined,
    Object? category = _undefined,
    Object? copyright = _undefined,
    Object? attributionText = _undefined,
  }) => _then(
    Query$Spots$spots$items(
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
      category: category == _undefined || category == null
          ? _instance.category
          : (category as Query$Spots$spots$items$category),
      copyright: copyright == _undefined || copyright == null
          ? _instance.copyright
          : (copyright as Enum$CopyrightType),
      attributionText: attributionText == _undefined || attributionText == null
          ? _instance.attributionText
          : (attributionText as String),
    ),
  );

  CopyWith$Query$Spots$spots$items$category<TRes> get category {
    final local$category = _instance.category;
    return CopyWith$Query$Spots$spots$items$category(
      local$category,
      (e) => call(category: e),
    );
  }
}

class _CopyWithStubImpl$Query$Spots$spots$items<TRes>
    implements CopyWith$Query$Spots$spots$items<TRes> {
  _CopyWithStubImpl$Query$Spots$spots$items(this._res);

  TRes _res;

  call({
    String? id,
    String? title,
    String? address,
    String? thumbnailImageUrl,
    double? distanceMeters,
    Query$Spots$spots$items$category? category,
    Enum$CopyrightType? copyright,
    String? attributionText,
  }) => _res;

  CopyWith$Query$Spots$spots$items$category<TRes> get category =>
      CopyWith$Query$Spots$spots$items$category.stub(_res);
}

class Query$Spots$spots$items$category {
  Query$Spots$spots$items$category({
    required this.code,
    required this.label,
    this.iconUrl,
  });

  factory Query$Spots$spots$items$category.fromJson(Map<String, dynamic> json) {
    final l$code = json['code'];
    final l$label = json['label'];
    final l$iconUrl = json['iconUrl'];
    return Query$Spots$spots$items$category(
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
    if (other is! Query$Spots$spots$items$category ||
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

extension UtilityExtension$Query$Spots$spots$items$category
    on Query$Spots$spots$items$category {
  CopyWith$Query$Spots$spots$items$category<Query$Spots$spots$items$category>
  get copyWith => CopyWith$Query$Spots$spots$items$category(this, (i) => i);
}

abstract class CopyWith$Query$Spots$spots$items$category<TRes> {
  factory CopyWith$Query$Spots$spots$items$category(
    Query$Spots$spots$items$category instance,
    TRes Function(Query$Spots$spots$items$category) then,
  ) = _CopyWithImpl$Query$Spots$spots$items$category;

  factory CopyWith$Query$Spots$spots$items$category.stub(TRes res) =
      _CopyWithStubImpl$Query$Spots$spots$items$category;

  TRes call({String? code, String? label, String? iconUrl});
}

class _CopyWithImpl$Query$Spots$spots$items$category<TRes>
    implements CopyWith$Query$Spots$spots$items$category<TRes> {
  _CopyWithImpl$Query$Spots$spots$items$category(this._instance, this._then);

  final Query$Spots$spots$items$category _instance;

  final TRes Function(Query$Spots$spots$items$category) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? code = _undefined,
    Object? label = _undefined,
    Object? iconUrl = _undefined,
  }) => _then(
    Query$Spots$spots$items$category(
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

class _CopyWithStubImpl$Query$Spots$spots$items$category<TRes>
    implements CopyWith$Query$Spots$spots$items$category<TRes> {
  _CopyWithStubImpl$Query$Spots$spots$items$category(this._res);

  TRes _res;

  call({String? code, String? label, String? iconUrl}) => _res;
}

class Query$AvailableSpotCategories {
  Query$AvailableSpotCategories({required this.availableSpotCategories});

  factory Query$AvailableSpotCategories.fromJson(Map<String, dynamic> json) {
    final l$availableSpotCategories = json['availableSpotCategories'];
    return Query$AvailableSpotCategories(
      availableSpotCategories: (l$availableSpotCategories as List<dynamic>)
          .map(
            (e) =>
                Query$AvailableSpotCategories$availableSpotCategories.fromJson(
                  (e as Map<String, dynamic>),
                ),
          )
          .toList(),
    );
  }

  final List<Query$AvailableSpotCategories$availableSpotCategories>
  availableSpotCategories;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$availableSpotCategories = availableSpotCategories;
    _resultData['availableSpotCategories'] = l$availableSpotCategories
        .map((e) => e.toJson())
        .toList();
    return _resultData;
  }

  @override
  int get hashCode {
    final l$availableSpotCategories = availableSpotCategories;
    return Object.hashAll([
      Object.hashAll(l$availableSpotCategories.map((v) => v)),
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$AvailableSpotCategories ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$availableSpotCategories = availableSpotCategories;
    final lOther$availableSpotCategories = other.availableSpotCategories;
    if (l$availableSpotCategories.length !=
        lOther$availableSpotCategories.length) {
      return false;
    }
    for (int i = 0; i < l$availableSpotCategories.length; i++) {
      final l$availableSpotCategories$entry = l$availableSpotCategories[i];
      final lOther$availableSpotCategories$entry =
          lOther$availableSpotCategories[i];
      if (l$availableSpotCategories$entry !=
          lOther$availableSpotCategories$entry) {
        return false;
      }
    }
    return true;
  }
}

extension UtilityExtension$Query$AvailableSpotCategories
    on Query$AvailableSpotCategories {
  CopyWith$Query$AvailableSpotCategories<Query$AvailableSpotCategories>
  get copyWith => CopyWith$Query$AvailableSpotCategories(this, (i) => i);
}

abstract class CopyWith$Query$AvailableSpotCategories<TRes> {
  factory CopyWith$Query$AvailableSpotCategories(
    Query$AvailableSpotCategories instance,
    TRes Function(Query$AvailableSpotCategories) then,
  ) = _CopyWithImpl$Query$AvailableSpotCategories;

  factory CopyWith$Query$AvailableSpotCategories.stub(TRes res) =
      _CopyWithStubImpl$Query$AvailableSpotCategories;

  TRes call({
    List<Query$AvailableSpotCategories$availableSpotCategories>?
    availableSpotCategories,
  });
  TRes availableSpotCategories(
    Iterable<Query$AvailableSpotCategories$availableSpotCategories> Function(
      Iterable<
        CopyWith$Query$AvailableSpotCategories$availableSpotCategories<
          Query$AvailableSpotCategories$availableSpotCategories
        >
      >,
    )
    _fn,
  );
}

class _CopyWithImpl$Query$AvailableSpotCategories<TRes>
    implements CopyWith$Query$AvailableSpotCategories<TRes> {
  _CopyWithImpl$Query$AvailableSpotCategories(this._instance, this._then);

  final Query$AvailableSpotCategories _instance;

  final TRes Function(Query$AvailableSpotCategories) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? availableSpotCategories = _undefined}) => _then(
    Query$AvailableSpotCategories(
      availableSpotCategories:
          availableSpotCategories == _undefined ||
              availableSpotCategories == null
          ? _instance.availableSpotCategories
          : (availableSpotCategories
                as List<Query$AvailableSpotCategories$availableSpotCategories>),
    ),
  );

  TRes availableSpotCategories(
    Iterable<Query$AvailableSpotCategories$availableSpotCategories> Function(
      Iterable<
        CopyWith$Query$AvailableSpotCategories$availableSpotCategories<
          Query$AvailableSpotCategories$availableSpotCategories
        >
      >,
    )
    _fn,
  ) => call(
    availableSpotCategories: _fn(
      _instance.availableSpotCategories.map(
        (e) => CopyWith$Query$AvailableSpotCategories$availableSpotCategories(
          e,
          (i) => i,
        ),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl$Query$AvailableSpotCategories<TRes>
    implements CopyWith$Query$AvailableSpotCategories<TRes> {
  _CopyWithStubImpl$Query$AvailableSpotCategories(this._res);

  TRes _res;

  call({
    List<Query$AvailableSpotCategories$availableSpotCategories>?
    availableSpotCategories,
  }) => _res;

  availableSpotCategories(_fn) => _res;
}

const documentNodeQueryAvailableSpotCategories = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'AvailableSpotCategories'),
      variableDefinitions: [],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'availableSpotCategories'),
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
        ],
      ),
    ),
  ],
);

class Query$AvailableSpotCategories$availableSpotCategories {
  Query$AvailableSpotCategories$availableSpotCategories({
    required this.code,
    required this.label,
    this.iconUrl,
  });

  factory Query$AvailableSpotCategories$availableSpotCategories.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$code = json['code'];
    final l$label = json['label'];
    final l$iconUrl = json['iconUrl'];
    return Query$AvailableSpotCategories$availableSpotCategories(
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
    if (other is! Query$AvailableSpotCategories$availableSpotCategories ||
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

extension UtilityExtension$Query$AvailableSpotCategories$availableSpotCategories
    on Query$AvailableSpotCategories$availableSpotCategories {
  CopyWith$Query$AvailableSpotCategories$availableSpotCategories<
    Query$AvailableSpotCategories$availableSpotCategories
  >
  get copyWith =>
      CopyWith$Query$AvailableSpotCategories$availableSpotCategories(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Query$AvailableSpotCategories$availableSpotCategories<
  TRes
> {
  factory CopyWith$Query$AvailableSpotCategories$availableSpotCategories(
    Query$AvailableSpotCategories$availableSpotCategories instance,
    TRes Function(Query$AvailableSpotCategories$availableSpotCategories) then,
  ) = _CopyWithImpl$Query$AvailableSpotCategories$availableSpotCategories;

  factory CopyWith$Query$AvailableSpotCategories$availableSpotCategories.stub(
    TRes res,
  ) = _CopyWithStubImpl$Query$AvailableSpotCategories$availableSpotCategories;

  TRes call({String? code, String? label, String? iconUrl});
}

class _CopyWithImpl$Query$AvailableSpotCategories$availableSpotCategories<TRes>
    implements
        CopyWith$Query$AvailableSpotCategories$availableSpotCategories<TRes> {
  _CopyWithImpl$Query$AvailableSpotCategories$availableSpotCategories(
    this._instance,
    this._then,
  );

  final Query$AvailableSpotCategories$availableSpotCategories _instance;

  final TRes Function(Query$AvailableSpotCategories$availableSpotCategories)
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? code = _undefined,
    Object? label = _undefined,
    Object? iconUrl = _undefined,
  }) => _then(
    Query$AvailableSpotCategories$availableSpotCategories(
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

class _CopyWithStubImpl$Query$AvailableSpotCategories$availableSpotCategories<
  TRes
>
    implements
        CopyWith$Query$AvailableSpotCategories$availableSpotCategories<TRes> {
  _CopyWithStubImpl$Query$AvailableSpotCategories$availableSpotCategories(
    this._res,
  );

  TRes _res;

  call({String? code, String? label, String? iconUrl}) => _res;
}

class Variables$Query$SpotDetail {
  factory Variables$Query$SpotDetail({
    required String id,
    required String categoryCode,
  }) =>
      Variables$Query$SpotDetail._({r'id': id, r'categoryCode': categoryCode});

  Variables$Query$SpotDetail._(this._$data);

  factory Variables$Query$SpotDetail.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$id = data['id'];
    result$data['id'] = (l$id as String);
    final l$categoryCode = data['categoryCode'];
    result$data['categoryCode'] = (l$categoryCode as String);
    return Variables$Query$SpotDetail._(result$data);
  }

  Map<String, dynamic> _$data;

  String get id => (_$data['id'] as String);

  String get categoryCode => (_$data['categoryCode'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$id = id;
    result$data['id'] = l$id;
    final l$categoryCode = categoryCode;
    result$data['categoryCode'] = l$categoryCode;
    return result$data;
  }

  CopyWith$Variables$Query$SpotDetail<Variables$Query$SpotDetail>
  get copyWith => CopyWith$Variables$Query$SpotDetail(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Query$SpotDetail ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$categoryCode = categoryCode;
    final lOther$categoryCode = other.categoryCode;
    if (l$categoryCode != lOther$categoryCode) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$categoryCode = categoryCode;
    return Object.hashAll([l$id, l$categoryCode]);
  }
}

abstract class CopyWith$Variables$Query$SpotDetail<TRes> {
  factory CopyWith$Variables$Query$SpotDetail(
    Variables$Query$SpotDetail instance,
    TRes Function(Variables$Query$SpotDetail) then,
  ) = _CopyWithImpl$Variables$Query$SpotDetail;

  factory CopyWith$Variables$Query$SpotDetail.stub(TRes res) =
      _CopyWithStubImpl$Variables$Query$SpotDetail;

  TRes call({String? id, String? categoryCode});
}

class _CopyWithImpl$Variables$Query$SpotDetail<TRes>
    implements CopyWith$Variables$Query$SpotDetail<TRes> {
  _CopyWithImpl$Variables$Query$SpotDetail(this._instance, this._then);

  final Variables$Query$SpotDetail _instance;

  final TRes Function(Variables$Query$SpotDetail) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? id = _undefined, Object? categoryCode = _undefined}) =>
      _then(
        Variables$Query$SpotDetail._({
          ..._instance._$data,
          if (id != _undefined && id != null) 'id': (id as String),
          if (categoryCode != _undefined && categoryCode != null)
            'categoryCode': (categoryCode as String),
        }),
      );
}

class _CopyWithStubImpl$Variables$Query$SpotDetail<TRes>
    implements CopyWith$Variables$Query$SpotDetail<TRes> {
  _CopyWithStubImpl$Variables$Query$SpotDetail(this._res);

  TRes _res;

  call({String? id, String? categoryCode}) => _res;
}

class Query$SpotDetail {
  Query$SpotDetail({required this.spotDetail});

  factory Query$SpotDetail.fromJson(Map<String, dynamic> json) {
    final l$spotDetail = json['spotDetail'];
    return Query$SpotDetail(
      spotDetail: Query$SpotDetail$spotDetail.fromJson(
        (l$spotDetail as Map<String, dynamic>),
      ),
    );
  }

  final Query$SpotDetail$spotDetail spotDetail;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$spotDetail = spotDetail;
    _resultData['spotDetail'] = l$spotDetail.toJson();
    return _resultData;
  }

  @override
  int get hashCode {
    final l$spotDetail = spotDetail;
    return Object.hashAll([l$spotDetail]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$SpotDetail || runtimeType != other.runtimeType) {
      return false;
    }
    final l$spotDetail = spotDetail;
    final lOther$spotDetail = other.spotDetail;
    if (l$spotDetail != lOther$spotDetail) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Query$SpotDetail on Query$SpotDetail {
  CopyWith$Query$SpotDetail<Query$SpotDetail> get copyWith =>
      CopyWith$Query$SpotDetail(this, (i) => i);
}

abstract class CopyWith$Query$SpotDetail<TRes> {
  factory CopyWith$Query$SpotDetail(
    Query$SpotDetail instance,
    TRes Function(Query$SpotDetail) then,
  ) = _CopyWithImpl$Query$SpotDetail;

  factory CopyWith$Query$SpotDetail.stub(TRes res) =
      _CopyWithStubImpl$Query$SpotDetail;

  TRes call({Query$SpotDetail$spotDetail? spotDetail});
  CopyWith$Query$SpotDetail$spotDetail<TRes> get spotDetail;
}

class _CopyWithImpl$Query$SpotDetail<TRes>
    implements CopyWith$Query$SpotDetail<TRes> {
  _CopyWithImpl$Query$SpotDetail(this._instance, this._then);

  final Query$SpotDetail _instance;

  final TRes Function(Query$SpotDetail) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? spotDetail = _undefined}) => _then(
    Query$SpotDetail(
      spotDetail: spotDetail == _undefined || spotDetail == null
          ? _instance.spotDetail
          : (spotDetail as Query$SpotDetail$spotDetail),
    ),
  );

  CopyWith$Query$SpotDetail$spotDetail<TRes> get spotDetail {
    final local$spotDetail = _instance.spotDetail;
    return CopyWith$Query$SpotDetail$spotDetail(
      local$spotDetail,
      (e) => call(spotDetail: e),
    );
  }
}

class _CopyWithStubImpl$Query$SpotDetail<TRes>
    implements CopyWith$Query$SpotDetail<TRes> {
  _CopyWithStubImpl$Query$SpotDetail(this._res);

  TRes _res;

  call({Query$SpotDetail$spotDetail? spotDetail}) => _res;

  CopyWith$Query$SpotDetail$spotDetail<TRes> get spotDetail =>
      CopyWith$Query$SpotDetail$spotDetail.stub(_res);
}

const documentNodeQuerySpotDetail = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'SpotDetail'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'id')),
          type: NamedTypeNode(name: NameNode(value: 'ID'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'categoryCode')),
          type: NamedTypeNode(name: NameNode(value: 'String'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
      ],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'spotDetail'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'id'),
                value: VariableNode(name: NameNode(value: 'id')),
              ),
            ],
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
                  name: NameNode(value: 'thumbnailImageUrl'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: 'overview'),
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
                  name: NameNode(value: 'homepage'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: 'tel'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: 'copyright'),
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
                  name: NameNode(value: 'gallery'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: SelectionSetNode(
                    selections: [
                      FieldNode(
                        name: NameNode(value: 'imageUrl'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'thumbnailUrl'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'caption'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'copyright'),
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
                    ],
                  ),
                ),
                FieldNode(
                  name: NameNode(value: 'likeCount'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: 'intro'),
                  alias: null,
                  arguments: [
                    ArgumentNode(
                      name: NameNode(value: 'categoryCode'),
                      value: VariableNode(
                        name: NameNode(value: 'categoryCode'),
                      ),
                    ),
                  ],
                  directives: [],
                  selectionSet: SelectionSetNode(
                    selections: [
                      FieldNode(
                        name: NameNode(value: 'businessHours'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'closedDays'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'parking'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'inquiryPhone'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'fee'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'petAllowed'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'creditCardAccepted'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                    ],
                  ),
                ),
                FieldNode(
                  name: NameNode(value: 'infoItems'),
                  alias: null,
                  arguments: [
                    ArgumentNode(
                      name: NameNode(value: 'categoryCode'),
                      value: VariableNode(
                        name: NameNode(value: 'categoryCode'),
                      ),
                    ),
                  ],
                  directives: [],
                  selectionSet: SelectionSetNode(
                    selections: [
                      FieldNode(
                        name: NameNode(value: 'name'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'text'),
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

class Query$SpotDetail$spotDetail {
  Query$SpotDetail$spotDetail({
    required this.id,
    required this.title,
    required this.category,
    required this.thumbnailImageUrl,
    this.overview,
    this.address,
    this.homepage,
    this.tel,
    required this.copyright,
    required this.attributionText,
    this.gallery,
    required this.likeCount,
    this.intro,
    this.infoItems,
  });

  factory Query$SpotDetail$spotDetail.fromJson(Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$title = json['title'];
    final l$category = json['category'];
    final l$thumbnailImageUrl = json['thumbnailImageUrl'];
    final l$overview = json['overview'];
    final l$address = json['address'];
    final l$homepage = json['homepage'];
    final l$tel = json['tel'];
    final l$copyright = json['copyright'];
    final l$attributionText = json['attributionText'];
    final l$gallery = json['gallery'];
    final l$likeCount = json['likeCount'];
    final l$intro = json['intro'];
    final l$infoItems = json['infoItems'];
    return Query$SpotDetail$spotDetail(
      id: (l$id as String),
      title: (l$title as String),
      category: Query$SpotDetail$spotDetail$category.fromJson(
        (l$category as Map<String, dynamic>),
      ),
      thumbnailImageUrl: (l$thumbnailImageUrl as String),
      overview: (l$overview as String?),
      address: (l$address as String?),
      homepage: (l$homepage as String?),
      tel: (l$tel as String?),
      copyright: fromJson$Enum$CopyrightType((l$copyright as String)),
      attributionText: (l$attributionText as String),
      gallery: (l$gallery as List<dynamic>?)
          ?.map(
            (e) => Query$SpotDetail$spotDetail$gallery.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      likeCount: (l$likeCount as int),
      intro: l$intro == null
          ? null
          : Query$SpotDetail$spotDetail$intro.fromJson(
              (l$intro as Map<String, dynamic>),
            ),
      infoItems: (l$infoItems as List<dynamic>?)
          ?.map(
            (e) => Query$SpotDetail$spotDetail$infoItems.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
    );
  }

  final String id;

  final String title;

  final Query$SpotDetail$spotDetail$category category;

  final String thumbnailImageUrl;

  final String? overview;

  final String? address;

  final String? homepage;

  final String? tel;

  final Enum$CopyrightType copyright;

  final String attributionText;

  final List<Query$SpotDetail$spotDetail$gallery>? gallery;

  final int likeCount;

  final Query$SpotDetail$spotDetail$intro? intro;

  final List<Query$SpotDetail$spotDetail$infoItems>? infoItems;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$title = title;
    _resultData['title'] = l$title;
    final l$category = category;
    _resultData['category'] = l$category.toJson();
    final l$thumbnailImageUrl = thumbnailImageUrl;
    _resultData['thumbnailImageUrl'] = l$thumbnailImageUrl;
    final l$overview = overview;
    _resultData['overview'] = l$overview;
    final l$address = address;
    _resultData['address'] = l$address;
    final l$homepage = homepage;
    _resultData['homepage'] = l$homepage;
    final l$tel = tel;
    _resultData['tel'] = l$tel;
    final l$copyright = copyright;
    _resultData['copyright'] = toJson$Enum$CopyrightType(l$copyright);
    final l$attributionText = attributionText;
    _resultData['attributionText'] = l$attributionText;
    final l$gallery = gallery;
    _resultData['gallery'] = l$gallery?.map((e) => e.toJson()).toList();
    final l$likeCount = likeCount;
    _resultData['likeCount'] = l$likeCount;
    final l$intro = intro;
    _resultData['intro'] = l$intro?.toJson();
    final l$infoItems = infoItems;
    _resultData['infoItems'] = l$infoItems?.map((e) => e.toJson()).toList();
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$title = title;
    final l$category = category;
    final l$thumbnailImageUrl = thumbnailImageUrl;
    final l$overview = overview;
    final l$address = address;
    final l$homepage = homepage;
    final l$tel = tel;
    final l$copyright = copyright;
    final l$attributionText = attributionText;
    final l$gallery = gallery;
    final l$likeCount = likeCount;
    final l$intro = intro;
    final l$infoItems = infoItems;
    return Object.hashAll([
      l$id,
      l$title,
      l$category,
      l$thumbnailImageUrl,
      l$overview,
      l$address,
      l$homepage,
      l$tel,
      l$copyright,
      l$attributionText,
      l$gallery == null ? null : Object.hashAll(l$gallery.map((v) => v)),
      l$likeCount,
      l$intro,
      l$infoItems == null ? null : Object.hashAll(l$infoItems.map((v) => v)),
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$SpotDetail$spotDetail ||
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
    final l$category = category;
    final lOther$category = other.category;
    if (l$category != lOther$category) {
      return false;
    }
    final l$thumbnailImageUrl = thumbnailImageUrl;
    final lOther$thumbnailImageUrl = other.thumbnailImageUrl;
    if (l$thumbnailImageUrl != lOther$thumbnailImageUrl) {
      return false;
    }
    final l$overview = overview;
    final lOther$overview = other.overview;
    if (l$overview != lOther$overview) {
      return false;
    }
    final l$address = address;
    final lOther$address = other.address;
    if (l$address != lOther$address) {
      return false;
    }
    final l$homepage = homepage;
    final lOther$homepage = other.homepage;
    if (l$homepage != lOther$homepage) {
      return false;
    }
    final l$tel = tel;
    final lOther$tel = other.tel;
    if (l$tel != lOther$tel) {
      return false;
    }
    final l$copyright = copyright;
    final lOther$copyright = other.copyright;
    if (l$copyright != lOther$copyright) {
      return false;
    }
    final l$attributionText = attributionText;
    final lOther$attributionText = other.attributionText;
    if (l$attributionText != lOther$attributionText) {
      return false;
    }
    final l$gallery = gallery;
    final lOther$gallery = other.gallery;
    if (l$gallery != null && lOther$gallery != null) {
      if (l$gallery.length != lOther$gallery.length) {
        return false;
      }
      for (int i = 0; i < l$gallery.length; i++) {
        final l$gallery$entry = l$gallery[i];
        final lOther$gallery$entry = lOther$gallery[i];
        if (l$gallery$entry != lOther$gallery$entry) {
          return false;
        }
      }
    } else if (l$gallery != lOther$gallery) {
      return false;
    }
    final l$likeCount = likeCount;
    final lOther$likeCount = other.likeCount;
    if (l$likeCount != lOther$likeCount) {
      return false;
    }
    final l$intro = intro;
    final lOther$intro = other.intro;
    if (l$intro != lOther$intro) {
      return false;
    }
    final l$infoItems = infoItems;
    final lOther$infoItems = other.infoItems;
    if (l$infoItems != null && lOther$infoItems != null) {
      if (l$infoItems.length != lOther$infoItems.length) {
        return false;
      }
      for (int i = 0; i < l$infoItems.length; i++) {
        final l$infoItems$entry = l$infoItems[i];
        final lOther$infoItems$entry = lOther$infoItems[i];
        if (l$infoItems$entry != lOther$infoItems$entry) {
          return false;
        }
      }
    } else if (l$infoItems != lOther$infoItems) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Query$SpotDetail$spotDetail
    on Query$SpotDetail$spotDetail {
  CopyWith$Query$SpotDetail$spotDetail<Query$SpotDetail$spotDetail>
  get copyWith => CopyWith$Query$SpotDetail$spotDetail(this, (i) => i);
}

abstract class CopyWith$Query$SpotDetail$spotDetail<TRes> {
  factory CopyWith$Query$SpotDetail$spotDetail(
    Query$SpotDetail$spotDetail instance,
    TRes Function(Query$SpotDetail$spotDetail) then,
  ) = _CopyWithImpl$Query$SpotDetail$spotDetail;

  factory CopyWith$Query$SpotDetail$spotDetail.stub(TRes res) =
      _CopyWithStubImpl$Query$SpotDetail$spotDetail;

  TRes call({
    String? id,
    String? title,
    Query$SpotDetail$spotDetail$category? category,
    String? thumbnailImageUrl,
    String? overview,
    String? address,
    String? homepage,
    String? tel,
    Enum$CopyrightType? copyright,
    String? attributionText,
    List<Query$SpotDetail$spotDetail$gallery>? gallery,
    int? likeCount,
    Query$SpotDetail$spotDetail$intro? intro,
    List<Query$SpotDetail$spotDetail$infoItems>? infoItems,
  });
  CopyWith$Query$SpotDetail$spotDetail$category<TRes> get category;
  TRes gallery(
    Iterable<Query$SpotDetail$spotDetail$gallery>? Function(
      Iterable<
        CopyWith$Query$SpotDetail$spotDetail$gallery<
          Query$SpotDetail$spotDetail$gallery
        >
      >?,
    )
    _fn,
  );
  CopyWith$Query$SpotDetail$spotDetail$intro<TRes> get intro;
  TRes infoItems(
    Iterable<Query$SpotDetail$spotDetail$infoItems>? Function(
      Iterable<
        CopyWith$Query$SpotDetail$spotDetail$infoItems<
          Query$SpotDetail$spotDetail$infoItems
        >
      >?,
    )
    _fn,
  );
}

class _CopyWithImpl$Query$SpotDetail$spotDetail<TRes>
    implements CopyWith$Query$SpotDetail$spotDetail<TRes> {
  _CopyWithImpl$Query$SpotDetail$spotDetail(this._instance, this._then);

  final Query$SpotDetail$spotDetail _instance;

  final TRes Function(Query$SpotDetail$spotDetail) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? title = _undefined,
    Object? category = _undefined,
    Object? thumbnailImageUrl = _undefined,
    Object? overview = _undefined,
    Object? address = _undefined,
    Object? homepage = _undefined,
    Object? tel = _undefined,
    Object? copyright = _undefined,
    Object? attributionText = _undefined,
    Object? gallery = _undefined,
    Object? likeCount = _undefined,
    Object? intro = _undefined,
    Object? infoItems = _undefined,
  }) => _then(
    Query$SpotDetail$spotDetail(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      title: title == _undefined || title == null
          ? _instance.title
          : (title as String),
      category: category == _undefined || category == null
          ? _instance.category
          : (category as Query$SpotDetail$spotDetail$category),
      thumbnailImageUrl:
          thumbnailImageUrl == _undefined || thumbnailImageUrl == null
          ? _instance.thumbnailImageUrl
          : (thumbnailImageUrl as String),
      overview: overview == _undefined
          ? _instance.overview
          : (overview as String?),
      address: address == _undefined ? _instance.address : (address as String?),
      homepage: homepage == _undefined
          ? _instance.homepage
          : (homepage as String?),
      tel: tel == _undefined ? _instance.tel : (tel as String?),
      copyright: copyright == _undefined || copyright == null
          ? _instance.copyright
          : (copyright as Enum$CopyrightType),
      attributionText: attributionText == _undefined || attributionText == null
          ? _instance.attributionText
          : (attributionText as String),
      gallery: gallery == _undefined
          ? _instance.gallery
          : (gallery as List<Query$SpotDetail$spotDetail$gallery>?),
      likeCount: likeCount == _undefined || likeCount == null
          ? _instance.likeCount
          : (likeCount as int),
      intro: intro == _undefined
          ? _instance.intro
          : (intro as Query$SpotDetail$spotDetail$intro?),
      infoItems: infoItems == _undefined
          ? _instance.infoItems
          : (infoItems as List<Query$SpotDetail$spotDetail$infoItems>?),
    ),
  );

  CopyWith$Query$SpotDetail$spotDetail$category<TRes> get category {
    final local$category = _instance.category;
    return CopyWith$Query$SpotDetail$spotDetail$category(
      local$category,
      (e) => call(category: e),
    );
  }

  TRes gallery(
    Iterable<Query$SpotDetail$spotDetail$gallery>? Function(
      Iterable<
        CopyWith$Query$SpotDetail$spotDetail$gallery<
          Query$SpotDetail$spotDetail$gallery
        >
      >?,
    )
    _fn,
  ) => call(
    gallery: _fn(
      _instance.gallery?.map(
        (e) => CopyWith$Query$SpotDetail$spotDetail$gallery(e, (i) => i),
      ),
    )?.toList(),
  );

  CopyWith$Query$SpotDetail$spotDetail$intro<TRes> get intro {
    final local$intro = _instance.intro;
    return local$intro == null
        ? CopyWith$Query$SpotDetail$spotDetail$intro.stub(_then(_instance))
        : CopyWith$Query$SpotDetail$spotDetail$intro(
            local$intro,
            (e) => call(intro: e),
          );
  }

  TRes infoItems(
    Iterable<Query$SpotDetail$spotDetail$infoItems>? Function(
      Iterable<
        CopyWith$Query$SpotDetail$spotDetail$infoItems<
          Query$SpotDetail$spotDetail$infoItems
        >
      >?,
    )
    _fn,
  ) => call(
    infoItems: _fn(
      _instance.infoItems?.map(
        (e) => CopyWith$Query$SpotDetail$spotDetail$infoItems(e, (i) => i),
      ),
    )?.toList(),
  );
}

class _CopyWithStubImpl$Query$SpotDetail$spotDetail<TRes>
    implements CopyWith$Query$SpotDetail$spotDetail<TRes> {
  _CopyWithStubImpl$Query$SpotDetail$spotDetail(this._res);

  TRes _res;

  call({
    String? id,
    String? title,
    Query$SpotDetail$spotDetail$category? category,
    String? thumbnailImageUrl,
    String? overview,
    String? address,
    String? homepage,
    String? tel,
    Enum$CopyrightType? copyright,
    String? attributionText,
    List<Query$SpotDetail$spotDetail$gallery>? gallery,
    int? likeCount,
    Query$SpotDetail$spotDetail$intro? intro,
    List<Query$SpotDetail$spotDetail$infoItems>? infoItems,
  }) => _res;

  CopyWith$Query$SpotDetail$spotDetail$category<TRes> get category =>
      CopyWith$Query$SpotDetail$spotDetail$category.stub(_res);

  gallery(_fn) => _res;

  CopyWith$Query$SpotDetail$spotDetail$intro<TRes> get intro =>
      CopyWith$Query$SpotDetail$spotDetail$intro.stub(_res);

  infoItems(_fn) => _res;
}

class Query$SpotDetail$spotDetail$category {
  Query$SpotDetail$spotDetail$category({
    required this.code,
    required this.label,
    this.iconUrl,
  });

  factory Query$SpotDetail$spotDetail$category.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$code = json['code'];
    final l$label = json['label'];
    final l$iconUrl = json['iconUrl'];
    return Query$SpotDetail$spotDetail$category(
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
    if (other is! Query$SpotDetail$spotDetail$category ||
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

extension UtilityExtension$Query$SpotDetail$spotDetail$category
    on Query$SpotDetail$spotDetail$category {
  CopyWith$Query$SpotDetail$spotDetail$category<
    Query$SpotDetail$spotDetail$category
  >
  get copyWith => CopyWith$Query$SpotDetail$spotDetail$category(this, (i) => i);
}

abstract class CopyWith$Query$SpotDetail$spotDetail$category<TRes> {
  factory CopyWith$Query$SpotDetail$spotDetail$category(
    Query$SpotDetail$spotDetail$category instance,
    TRes Function(Query$SpotDetail$spotDetail$category) then,
  ) = _CopyWithImpl$Query$SpotDetail$spotDetail$category;

  factory CopyWith$Query$SpotDetail$spotDetail$category.stub(TRes res) =
      _CopyWithStubImpl$Query$SpotDetail$spotDetail$category;

  TRes call({String? code, String? label, String? iconUrl});
}

class _CopyWithImpl$Query$SpotDetail$spotDetail$category<TRes>
    implements CopyWith$Query$SpotDetail$spotDetail$category<TRes> {
  _CopyWithImpl$Query$SpotDetail$spotDetail$category(
    this._instance,
    this._then,
  );

  final Query$SpotDetail$spotDetail$category _instance;

  final TRes Function(Query$SpotDetail$spotDetail$category) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? code = _undefined,
    Object? label = _undefined,
    Object? iconUrl = _undefined,
  }) => _then(
    Query$SpotDetail$spotDetail$category(
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

class _CopyWithStubImpl$Query$SpotDetail$spotDetail$category<TRes>
    implements CopyWith$Query$SpotDetail$spotDetail$category<TRes> {
  _CopyWithStubImpl$Query$SpotDetail$spotDetail$category(this._res);

  TRes _res;

  call({String? code, String? label, String? iconUrl}) => _res;
}

class Query$SpotDetail$spotDetail$gallery {
  Query$SpotDetail$spotDetail$gallery({
    required this.imageUrl,
    this.thumbnailUrl,
    this.caption,
    required this.copyright,
    required this.attributionText,
  });

  factory Query$SpotDetail$spotDetail$gallery.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$imageUrl = json['imageUrl'];
    final l$thumbnailUrl = json['thumbnailUrl'];
    final l$caption = json['caption'];
    final l$copyright = json['copyright'];
    final l$attributionText = json['attributionText'];
    return Query$SpotDetail$spotDetail$gallery(
      imageUrl: (l$imageUrl as String),
      thumbnailUrl: (l$thumbnailUrl as String?),
      caption: (l$caption as String?),
      copyright: fromJson$Enum$CopyrightType((l$copyright as String)),
      attributionText: (l$attributionText as String),
    );
  }

  final String imageUrl;

  final String? thumbnailUrl;

  final String? caption;

  final Enum$CopyrightType copyright;

  final String attributionText;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$imageUrl = imageUrl;
    _resultData['imageUrl'] = l$imageUrl;
    final l$thumbnailUrl = thumbnailUrl;
    _resultData['thumbnailUrl'] = l$thumbnailUrl;
    final l$caption = caption;
    _resultData['caption'] = l$caption;
    final l$copyright = copyright;
    _resultData['copyright'] = toJson$Enum$CopyrightType(l$copyright);
    final l$attributionText = attributionText;
    _resultData['attributionText'] = l$attributionText;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$imageUrl = imageUrl;
    final l$thumbnailUrl = thumbnailUrl;
    final l$caption = caption;
    final l$copyright = copyright;
    final l$attributionText = attributionText;
    return Object.hashAll([
      l$imageUrl,
      l$thumbnailUrl,
      l$caption,
      l$copyright,
      l$attributionText,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$SpotDetail$spotDetail$gallery ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$imageUrl = imageUrl;
    final lOther$imageUrl = other.imageUrl;
    if (l$imageUrl != lOther$imageUrl) {
      return false;
    }
    final l$thumbnailUrl = thumbnailUrl;
    final lOther$thumbnailUrl = other.thumbnailUrl;
    if (l$thumbnailUrl != lOther$thumbnailUrl) {
      return false;
    }
    final l$caption = caption;
    final lOther$caption = other.caption;
    if (l$caption != lOther$caption) {
      return false;
    }
    final l$copyright = copyright;
    final lOther$copyright = other.copyright;
    if (l$copyright != lOther$copyright) {
      return false;
    }
    final l$attributionText = attributionText;
    final lOther$attributionText = other.attributionText;
    if (l$attributionText != lOther$attributionText) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Query$SpotDetail$spotDetail$gallery
    on Query$SpotDetail$spotDetail$gallery {
  CopyWith$Query$SpotDetail$spotDetail$gallery<
    Query$SpotDetail$spotDetail$gallery
  >
  get copyWith => CopyWith$Query$SpotDetail$spotDetail$gallery(this, (i) => i);
}

abstract class CopyWith$Query$SpotDetail$spotDetail$gallery<TRes> {
  factory CopyWith$Query$SpotDetail$spotDetail$gallery(
    Query$SpotDetail$spotDetail$gallery instance,
    TRes Function(Query$SpotDetail$spotDetail$gallery) then,
  ) = _CopyWithImpl$Query$SpotDetail$spotDetail$gallery;

  factory CopyWith$Query$SpotDetail$spotDetail$gallery.stub(TRes res) =
      _CopyWithStubImpl$Query$SpotDetail$spotDetail$gallery;

  TRes call({
    String? imageUrl,
    String? thumbnailUrl,
    String? caption,
    Enum$CopyrightType? copyright,
    String? attributionText,
  });
}

class _CopyWithImpl$Query$SpotDetail$spotDetail$gallery<TRes>
    implements CopyWith$Query$SpotDetail$spotDetail$gallery<TRes> {
  _CopyWithImpl$Query$SpotDetail$spotDetail$gallery(this._instance, this._then);

  final Query$SpotDetail$spotDetail$gallery _instance;

  final TRes Function(Query$SpotDetail$spotDetail$gallery) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? imageUrl = _undefined,
    Object? thumbnailUrl = _undefined,
    Object? caption = _undefined,
    Object? copyright = _undefined,
    Object? attributionText = _undefined,
  }) => _then(
    Query$SpotDetail$spotDetail$gallery(
      imageUrl: imageUrl == _undefined || imageUrl == null
          ? _instance.imageUrl
          : (imageUrl as String),
      thumbnailUrl: thumbnailUrl == _undefined
          ? _instance.thumbnailUrl
          : (thumbnailUrl as String?),
      caption: caption == _undefined ? _instance.caption : (caption as String?),
      copyright: copyright == _undefined || copyright == null
          ? _instance.copyright
          : (copyright as Enum$CopyrightType),
      attributionText: attributionText == _undefined || attributionText == null
          ? _instance.attributionText
          : (attributionText as String),
    ),
  );
}

class _CopyWithStubImpl$Query$SpotDetail$spotDetail$gallery<TRes>
    implements CopyWith$Query$SpotDetail$spotDetail$gallery<TRes> {
  _CopyWithStubImpl$Query$SpotDetail$spotDetail$gallery(this._res);

  TRes _res;

  call({
    String? imageUrl,
    String? thumbnailUrl,
    String? caption,
    Enum$CopyrightType? copyright,
    String? attributionText,
  }) => _res;
}

class Query$SpotDetail$spotDetail$intro {
  Query$SpotDetail$spotDetail$intro({
    this.businessHours,
    this.closedDays,
    this.parking,
    this.inquiryPhone,
    this.fee,
    this.petAllowed,
    this.creditCardAccepted,
  });

  factory Query$SpotDetail$spotDetail$intro.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$businessHours = json['businessHours'];
    final l$closedDays = json['closedDays'];
    final l$parking = json['parking'];
    final l$inquiryPhone = json['inquiryPhone'];
    final l$fee = json['fee'];
    final l$petAllowed = json['petAllowed'];
    final l$creditCardAccepted = json['creditCardAccepted'];
    return Query$SpotDetail$spotDetail$intro(
      businessHours: (l$businessHours as String?),
      closedDays: (l$closedDays as String?),
      parking: (l$parking as String?),
      inquiryPhone: (l$inquiryPhone as String?),
      fee: (l$fee as String?),
      petAllowed: (l$petAllowed as String?),
      creditCardAccepted: (l$creditCardAccepted as String?),
    );
  }

  final String? businessHours;

  final String? closedDays;

  final String? parking;

  final String? inquiryPhone;

  final String? fee;

  final String? petAllowed;

  final String? creditCardAccepted;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$businessHours = businessHours;
    _resultData['businessHours'] = l$businessHours;
    final l$closedDays = closedDays;
    _resultData['closedDays'] = l$closedDays;
    final l$parking = parking;
    _resultData['parking'] = l$parking;
    final l$inquiryPhone = inquiryPhone;
    _resultData['inquiryPhone'] = l$inquiryPhone;
    final l$fee = fee;
    _resultData['fee'] = l$fee;
    final l$petAllowed = petAllowed;
    _resultData['petAllowed'] = l$petAllowed;
    final l$creditCardAccepted = creditCardAccepted;
    _resultData['creditCardAccepted'] = l$creditCardAccepted;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$businessHours = businessHours;
    final l$closedDays = closedDays;
    final l$parking = parking;
    final l$inquiryPhone = inquiryPhone;
    final l$fee = fee;
    final l$petAllowed = petAllowed;
    final l$creditCardAccepted = creditCardAccepted;
    return Object.hashAll([
      l$businessHours,
      l$closedDays,
      l$parking,
      l$inquiryPhone,
      l$fee,
      l$petAllowed,
      l$creditCardAccepted,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$SpotDetail$spotDetail$intro ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$businessHours = businessHours;
    final lOther$businessHours = other.businessHours;
    if (l$businessHours != lOther$businessHours) {
      return false;
    }
    final l$closedDays = closedDays;
    final lOther$closedDays = other.closedDays;
    if (l$closedDays != lOther$closedDays) {
      return false;
    }
    final l$parking = parking;
    final lOther$parking = other.parking;
    if (l$parking != lOther$parking) {
      return false;
    }
    final l$inquiryPhone = inquiryPhone;
    final lOther$inquiryPhone = other.inquiryPhone;
    if (l$inquiryPhone != lOther$inquiryPhone) {
      return false;
    }
    final l$fee = fee;
    final lOther$fee = other.fee;
    if (l$fee != lOther$fee) {
      return false;
    }
    final l$petAllowed = petAllowed;
    final lOther$petAllowed = other.petAllowed;
    if (l$petAllowed != lOther$petAllowed) {
      return false;
    }
    final l$creditCardAccepted = creditCardAccepted;
    final lOther$creditCardAccepted = other.creditCardAccepted;
    if (l$creditCardAccepted != lOther$creditCardAccepted) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Query$SpotDetail$spotDetail$intro
    on Query$SpotDetail$spotDetail$intro {
  CopyWith$Query$SpotDetail$spotDetail$intro<Query$SpotDetail$spotDetail$intro>
  get copyWith => CopyWith$Query$SpotDetail$spotDetail$intro(this, (i) => i);
}

abstract class CopyWith$Query$SpotDetail$spotDetail$intro<TRes> {
  factory CopyWith$Query$SpotDetail$spotDetail$intro(
    Query$SpotDetail$spotDetail$intro instance,
    TRes Function(Query$SpotDetail$spotDetail$intro) then,
  ) = _CopyWithImpl$Query$SpotDetail$spotDetail$intro;

  factory CopyWith$Query$SpotDetail$spotDetail$intro.stub(TRes res) =
      _CopyWithStubImpl$Query$SpotDetail$spotDetail$intro;

  TRes call({
    String? businessHours,
    String? closedDays,
    String? parking,
    String? inquiryPhone,
    String? fee,
    String? petAllowed,
    String? creditCardAccepted,
  });
}

class _CopyWithImpl$Query$SpotDetail$spotDetail$intro<TRes>
    implements CopyWith$Query$SpotDetail$spotDetail$intro<TRes> {
  _CopyWithImpl$Query$SpotDetail$spotDetail$intro(this._instance, this._then);

  final Query$SpotDetail$spotDetail$intro _instance;

  final TRes Function(Query$SpotDetail$spotDetail$intro) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? businessHours = _undefined,
    Object? closedDays = _undefined,
    Object? parking = _undefined,
    Object? inquiryPhone = _undefined,
    Object? fee = _undefined,
    Object? petAllowed = _undefined,
    Object? creditCardAccepted = _undefined,
  }) => _then(
    Query$SpotDetail$spotDetail$intro(
      businessHours: businessHours == _undefined
          ? _instance.businessHours
          : (businessHours as String?),
      closedDays: closedDays == _undefined
          ? _instance.closedDays
          : (closedDays as String?),
      parking: parking == _undefined ? _instance.parking : (parking as String?),
      inquiryPhone: inquiryPhone == _undefined
          ? _instance.inquiryPhone
          : (inquiryPhone as String?),
      fee: fee == _undefined ? _instance.fee : (fee as String?),
      petAllowed: petAllowed == _undefined
          ? _instance.petAllowed
          : (petAllowed as String?),
      creditCardAccepted: creditCardAccepted == _undefined
          ? _instance.creditCardAccepted
          : (creditCardAccepted as String?),
    ),
  );
}

class _CopyWithStubImpl$Query$SpotDetail$spotDetail$intro<TRes>
    implements CopyWith$Query$SpotDetail$spotDetail$intro<TRes> {
  _CopyWithStubImpl$Query$SpotDetail$spotDetail$intro(this._res);

  TRes _res;

  call({
    String? businessHours,
    String? closedDays,
    String? parking,
    String? inquiryPhone,
    String? fee,
    String? petAllowed,
    String? creditCardAccepted,
  }) => _res;
}

class Query$SpotDetail$spotDetail$infoItems {
  Query$SpotDetail$spotDetail$infoItems({
    required this.name,
    required this.text,
  });

  factory Query$SpotDetail$spotDetail$infoItems.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$name = json['name'];
    final l$text = json['text'];
    return Query$SpotDetail$spotDetail$infoItems(
      name: (l$name as String),
      text: (l$text as String),
    );
  }

  final String name;

  final String text;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$name = name;
    _resultData['name'] = l$name;
    final l$text = text;
    _resultData['text'] = l$text;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$name = name;
    final l$text = text;
    return Object.hashAll([l$name, l$text]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$SpotDetail$spotDetail$infoItems ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$name = name;
    final lOther$name = other.name;
    if (l$name != lOther$name) {
      return false;
    }
    final l$text = text;
    final lOther$text = other.text;
    if (l$text != lOther$text) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Query$SpotDetail$spotDetail$infoItems
    on Query$SpotDetail$spotDetail$infoItems {
  CopyWith$Query$SpotDetail$spotDetail$infoItems<
    Query$SpotDetail$spotDetail$infoItems
  >
  get copyWith =>
      CopyWith$Query$SpotDetail$spotDetail$infoItems(this, (i) => i);
}

abstract class CopyWith$Query$SpotDetail$spotDetail$infoItems<TRes> {
  factory CopyWith$Query$SpotDetail$spotDetail$infoItems(
    Query$SpotDetail$spotDetail$infoItems instance,
    TRes Function(Query$SpotDetail$spotDetail$infoItems) then,
  ) = _CopyWithImpl$Query$SpotDetail$spotDetail$infoItems;

  factory CopyWith$Query$SpotDetail$spotDetail$infoItems.stub(TRes res) =
      _CopyWithStubImpl$Query$SpotDetail$spotDetail$infoItems;

  TRes call({String? name, String? text});
}

class _CopyWithImpl$Query$SpotDetail$spotDetail$infoItems<TRes>
    implements CopyWith$Query$SpotDetail$spotDetail$infoItems<TRes> {
  _CopyWithImpl$Query$SpotDetail$spotDetail$infoItems(
    this._instance,
    this._then,
  );

  final Query$SpotDetail$spotDetail$infoItems _instance;

  final TRes Function(Query$SpotDetail$spotDetail$infoItems) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? name = _undefined, Object? text = _undefined}) => _then(
    Query$SpotDetail$spotDetail$infoItems(
      name: name == _undefined || name == null
          ? _instance.name
          : (name as String),
      text: text == _undefined || text == null
          ? _instance.text
          : (text as String),
    ),
  );
}

class _CopyWithStubImpl$Query$SpotDetail$spotDetail$infoItems<TRes>
    implements CopyWith$Query$SpotDetail$spotDetail$infoItems<TRes> {
  _CopyWithStubImpl$Query$SpotDetail$spotDetail$infoItems(this._res);

  TRes _res;

  call({String? name, String? text}) => _res;
}

class Variables$Query$LikedSpots {
  factory Variables$Query$LikedSpots({
    List<String>? categories,
    int? first,
    String? after,
  }) => Variables$Query$LikedSpots._({
    if (categories != null) r'categories': categories,
    if (first != null) r'first': first,
    if (after != null) r'after': after,
  });

  Variables$Query$LikedSpots._(this._$data);

  factory Variables$Query$LikedSpots.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    if (data.containsKey('categories')) {
      final l$categories = data['categories'];
      result$data['categories'] = (l$categories as List<dynamic>?)
          ?.map((e) => (e as String))
          .toList();
    }
    if (data.containsKey('first')) {
      final l$first = data['first'];
      result$data['first'] = (l$first as int?);
    }
    if (data.containsKey('after')) {
      final l$after = data['after'];
      result$data['after'] = (l$after as String?);
    }
    return Variables$Query$LikedSpots._(result$data);
  }

  Map<String, dynamic> _$data;

  List<String>? get categories => (_$data['categories'] as List<String>?);

  int? get first => (_$data['first'] as int?);

  String? get after => (_$data['after'] as String?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    if (_$data.containsKey('categories')) {
      final l$categories = categories;
      result$data['categories'] = l$categories?.map((e) => e).toList();
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

  CopyWith$Variables$Query$LikedSpots<Variables$Query$LikedSpots>
  get copyWith => CopyWith$Variables$Query$LikedSpots(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Query$LikedSpots ||
        runtimeType != other.runtimeType) {
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
    final l$categories = categories;
    final l$first = first;
    final l$after = after;
    return Object.hashAll([
      _$data.containsKey('categories')
          ? l$categories == null
                ? null
                : Object.hashAll(l$categories.map((v) => v))
          : const {},
      _$data.containsKey('first') ? l$first : const {},
      _$data.containsKey('after') ? l$after : const {},
    ]);
  }
}

abstract class CopyWith$Variables$Query$LikedSpots<TRes> {
  factory CopyWith$Variables$Query$LikedSpots(
    Variables$Query$LikedSpots instance,
    TRes Function(Variables$Query$LikedSpots) then,
  ) = _CopyWithImpl$Variables$Query$LikedSpots;

  factory CopyWith$Variables$Query$LikedSpots.stub(TRes res) =
      _CopyWithStubImpl$Variables$Query$LikedSpots;

  TRes call({List<String>? categories, int? first, String? after});
}

class _CopyWithImpl$Variables$Query$LikedSpots<TRes>
    implements CopyWith$Variables$Query$LikedSpots<TRes> {
  _CopyWithImpl$Variables$Query$LikedSpots(this._instance, this._then);

  final Variables$Query$LikedSpots _instance;

  final TRes Function(Variables$Query$LikedSpots) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? categories = _undefined,
    Object? first = _undefined,
    Object? after = _undefined,
  }) => _then(
    Variables$Query$LikedSpots._({
      ..._instance._$data,
      if (categories != _undefined) 'categories': (categories as List<String>?),
      if (first != _undefined) 'first': (first as int?),
      if (after != _undefined) 'after': (after as String?),
    }),
  );
}

class _CopyWithStubImpl$Variables$Query$LikedSpots<TRes>
    implements CopyWith$Variables$Query$LikedSpots<TRes> {
  _CopyWithStubImpl$Variables$Query$LikedSpots(this._res);

  TRes _res;

  call({List<String>? categories, int? first, String? after}) => _res;
}

class Query$LikedSpots {
  Query$LikedSpots({required this.likedSpots});

  factory Query$LikedSpots.fromJson(Map<String, dynamic> json) {
    final l$likedSpots = json['likedSpots'];
    return Query$LikedSpots(
      likedSpots: Query$LikedSpots$likedSpots.fromJson(
        (l$likedSpots as Map<String, dynamic>),
      ),
    );
  }

  final Query$LikedSpots$likedSpots likedSpots;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$likedSpots = likedSpots;
    _resultData['likedSpots'] = l$likedSpots.toJson();
    return _resultData;
  }

  @override
  int get hashCode {
    final l$likedSpots = likedSpots;
    return Object.hashAll([l$likedSpots]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$LikedSpots || runtimeType != other.runtimeType) {
      return false;
    }
    final l$likedSpots = likedSpots;
    final lOther$likedSpots = other.likedSpots;
    if (l$likedSpots != lOther$likedSpots) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Query$LikedSpots on Query$LikedSpots {
  CopyWith$Query$LikedSpots<Query$LikedSpots> get copyWith =>
      CopyWith$Query$LikedSpots(this, (i) => i);
}

abstract class CopyWith$Query$LikedSpots<TRes> {
  factory CopyWith$Query$LikedSpots(
    Query$LikedSpots instance,
    TRes Function(Query$LikedSpots) then,
  ) = _CopyWithImpl$Query$LikedSpots;

  factory CopyWith$Query$LikedSpots.stub(TRes res) =
      _CopyWithStubImpl$Query$LikedSpots;

  TRes call({Query$LikedSpots$likedSpots? likedSpots});
  CopyWith$Query$LikedSpots$likedSpots<TRes> get likedSpots;
}

class _CopyWithImpl$Query$LikedSpots<TRes>
    implements CopyWith$Query$LikedSpots<TRes> {
  _CopyWithImpl$Query$LikedSpots(this._instance, this._then);

  final Query$LikedSpots _instance;

  final TRes Function(Query$LikedSpots) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? likedSpots = _undefined}) => _then(
    Query$LikedSpots(
      likedSpots: likedSpots == _undefined || likedSpots == null
          ? _instance.likedSpots
          : (likedSpots as Query$LikedSpots$likedSpots),
    ),
  );

  CopyWith$Query$LikedSpots$likedSpots<TRes> get likedSpots {
    final local$likedSpots = _instance.likedSpots;
    return CopyWith$Query$LikedSpots$likedSpots(
      local$likedSpots,
      (e) => call(likedSpots: e),
    );
  }
}

class _CopyWithStubImpl$Query$LikedSpots<TRes>
    implements CopyWith$Query$LikedSpots<TRes> {
  _CopyWithStubImpl$Query$LikedSpots(this._res);

  TRes _res;

  call({Query$LikedSpots$likedSpots? likedSpots}) => _res;

  CopyWith$Query$LikedSpots$likedSpots<TRes> get likedSpots =>
      CopyWith$Query$LikedSpots$likedSpots.stub(_res);
}

const documentNodeQueryLikedSpots = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'LikedSpots'),
      variableDefinitions: [
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
            name: NameNode(value: 'likedSpots'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'categories'),
                value: VariableNode(name: NameNode(value: 'categories')),
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
                        name: NameNode(value: 'cursor'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
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
                              name: NameNode(value: 'thumbnailImageUrl'),
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
                              name: NameNode(value: 'copyright'),
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
                          ],
                        ),
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

class Query$LikedSpots$likedSpots {
  Query$LikedSpots$likedSpots({required this.edges, required this.pageInfo});

  factory Query$LikedSpots$likedSpots.fromJson(Map<String, dynamic> json) {
    final l$edges = json['edges'];
    final l$pageInfo = json['pageInfo'];
    return Query$LikedSpots$likedSpots(
      edges: (l$edges as List<dynamic>)
          .map(
            (e) => Query$LikedSpots$likedSpots$edges.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      pageInfo: Query$LikedSpots$likedSpots$pageInfo.fromJson(
        (l$pageInfo as Map<String, dynamic>),
      ),
    );
  }

  final List<Query$LikedSpots$likedSpots$edges> edges;

  final Query$LikedSpots$likedSpots$pageInfo pageInfo;

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
    if (other is! Query$LikedSpots$likedSpots ||
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

extension UtilityExtension$Query$LikedSpots$likedSpots
    on Query$LikedSpots$likedSpots {
  CopyWith$Query$LikedSpots$likedSpots<Query$LikedSpots$likedSpots>
  get copyWith => CopyWith$Query$LikedSpots$likedSpots(this, (i) => i);
}

abstract class CopyWith$Query$LikedSpots$likedSpots<TRes> {
  factory CopyWith$Query$LikedSpots$likedSpots(
    Query$LikedSpots$likedSpots instance,
    TRes Function(Query$LikedSpots$likedSpots) then,
  ) = _CopyWithImpl$Query$LikedSpots$likedSpots;

  factory CopyWith$Query$LikedSpots$likedSpots.stub(TRes res) =
      _CopyWithStubImpl$Query$LikedSpots$likedSpots;

  TRes call({
    List<Query$LikedSpots$likedSpots$edges>? edges,
    Query$LikedSpots$likedSpots$pageInfo? pageInfo,
  });
  TRes edges(
    Iterable<Query$LikedSpots$likedSpots$edges> Function(
      Iterable<
        CopyWith$Query$LikedSpots$likedSpots$edges<
          Query$LikedSpots$likedSpots$edges
        >
      >,
    )
    _fn,
  );
  CopyWith$Query$LikedSpots$likedSpots$pageInfo<TRes> get pageInfo;
}

class _CopyWithImpl$Query$LikedSpots$likedSpots<TRes>
    implements CopyWith$Query$LikedSpots$likedSpots<TRes> {
  _CopyWithImpl$Query$LikedSpots$likedSpots(this._instance, this._then);

  final Query$LikedSpots$likedSpots _instance;

  final TRes Function(Query$LikedSpots$likedSpots) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? edges = _undefined, Object? pageInfo = _undefined}) =>
      _then(
        Query$LikedSpots$likedSpots(
          edges: edges == _undefined || edges == null
              ? _instance.edges
              : (edges as List<Query$LikedSpots$likedSpots$edges>),
          pageInfo: pageInfo == _undefined || pageInfo == null
              ? _instance.pageInfo
              : (pageInfo as Query$LikedSpots$likedSpots$pageInfo),
        ),
      );

  TRes edges(
    Iterable<Query$LikedSpots$likedSpots$edges> Function(
      Iterable<
        CopyWith$Query$LikedSpots$likedSpots$edges<
          Query$LikedSpots$likedSpots$edges
        >
      >,
    )
    _fn,
  ) => call(
    edges: _fn(
      _instance.edges.map(
        (e) => CopyWith$Query$LikedSpots$likedSpots$edges(e, (i) => i),
      ),
    ).toList(),
  );

  CopyWith$Query$LikedSpots$likedSpots$pageInfo<TRes> get pageInfo {
    final local$pageInfo = _instance.pageInfo;
    return CopyWith$Query$LikedSpots$likedSpots$pageInfo(
      local$pageInfo,
      (e) => call(pageInfo: e),
    );
  }
}

class _CopyWithStubImpl$Query$LikedSpots$likedSpots<TRes>
    implements CopyWith$Query$LikedSpots$likedSpots<TRes> {
  _CopyWithStubImpl$Query$LikedSpots$likedSpots(this._res);

  TRes _res;

  call({
    List<Query$LikedSpots$likedSpots$edges>? edges,
    Query$LikedSpots$likedSpots$pageInfo? pageInfo,
  }) => _res;

  edges(_fn) => _res;

  CopyWith$Query$LikedSpots$likedSpots$pageInfo<TRes> get pageInfo =>
      CopyWith$Query$LikedSpots$likedSpots$pageInfo.stub(_res);
}

class Query$LikedSpots$likedSpots$edges {
  Query$LikedSpots$likedSpots$edges({required this.cursor, required this.node});

  factory Query$LikedSpots$likedSpots$edges.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$cursor = json['cursor'];
    final l$node = json['node'];
    return Query$LikedSpots$likedSpots$edges(
      cursor: (l$cursor as String),
      node: Query$LikedSpots$likedSpots$edges$node.fromJson(
        (l$node as Map<String, dynamic>),
      ),
    );
  }

  final String cursor;

  final Query$LikedSpots$likedSpots$edges$node node;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$cursor = cursor;
    _resultData['cursor'] = l$cursor;
    final l$node = node;
    _resultData['node'] = l$node.toJson();
    return _resultData;
  }

  @override
  int get hashCode {
    final l$cursor = cursor;
    final l$node = node;
    return Object.hashAll([l$cursor, l$node]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$LikedSpots$likedSpots$edges ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$cursor = cursor;
    final lOther$cursor = other.cursor;
    if (l$cursor != lOther$cursor) {
      return false;
    }
    final l$node = node;
    final lOther$node = other.node;
    if (l$node != lOther$node) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Query$LikedSpots$likedSpots$edges
    on Query$LikedSpots$likedSpots$edges {
  CopyWith$Query$LikedSpots$likedSpots$edges<Query$LikedSpots$likedSpots$edges>
  get copyWith => CopyWith$Query$LikedSpots$likedSpots$edges(this, (i) => i);
}

abstract class CopyWith$Query$LikedSpots$likedSpots$edges<TRes> {
  factory CopyWith$Query$LikedSpots$likedSpots$edges(
    Query$LikedSpots$likedSpots$edges instance,
    TRes Function(Query$LikedSpots$likedSpots$edges) then,
  ) = _CopyWithImpl$Query$LikedSpots$likedSpots$edges;

  factory CopyWith$Query$LikedSpots$likedSpots$edges.stub(TRes res) =
      _CopyWithStubImpl$Query$LikedSpots$likedSpots$edges;

  TRes call({String? cursor, Query$LikedSpots$likedSpots$edges$node? node});
  CopyWith$Query$LikedSpots$likedSpots$edges$node<TRes> get node;
}

class _CopyWithImpl$Query$LikedSpots$likedSpots$edges<TRes>
    implements CopyWith$Query$LikedSpots$likedSpots$edges<TRes> {
  _CopyWithImpl$Query$LikedSpots$likedSpots$edges(this._instance, this._then);

  final Query$LikedSpots$likedSpots$edges _instance;

  final TRes Function(Query$LikedSpots$likedSpots$edges) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? cursor = _undefined, Object? node = _undefined}) => _then(
    Query$LikedSpots$likedSpots$edges(
      cursor: cursor == _undefined || cursor == null
          ? _instance.cursor
          : (cursor as String),
      node: node == _undefined || node == null
          ? _instance.node
          : (node as Query$LikedSpots$likedSpots$edges$node),
    ),
  );

  CopyWith$Query$LikedSpots$likedSpots$edges$node<TRes> get node {
    final local$node = _instance.node;
    return CopyWith$Query$LikedSpots$likedSpots$edges$node(
      local$node,
      (e) => call(node: e),
    );
  }
}

class _CopyWithStubImpl$Query$LikedSpots$likedSpots$edges<TRes>
    implements CopyWith$Query$LikedSpots$likedSpots$edges<TRes> {
  _CopyWithStubImpl$Query$LikedSpots$likedSpots$edges(this._res);

  TRes _res;

  call({String? cursor, Query$LikedSpots$likedSpots$edges$node? node}) => _res;

  CopyWith$Query$LikedSpots$likedSpots$edges$node<TRes> get node =>
      CopyWith$Query$LikedSpots$likedSpots$edges$node.stub(_res);
}

class Query$LikedSpots$likedSpots$edges$node {
  Query$LikedSpots$likedSpots$edges$node({
    required this.id,
    required this.title,
    required this.thumbnailImageUrl,
    this.address,
    required this.category,
    required this.copyright,
    required this.attributionText,
  });

  factory Query$LikedSpots$likedSpots$edges$node.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$title = json['title'];
    final l$thumbnailImageUrl = json['thumbnailImageUrl'];
    final l$address = json['address'];
    final l$category = json['category'];
    final l$copyright = json['copyright'];
    final l$attributionText = json['attributionText'];
    return Query$LikedSpots$likedSpots$edges$node(
      id: (l$id as String),
      title: (l$title as String),
      thumbnailImageUrl: (l$thumbnailImageUrl as String),
      address: (l$address as String?),
      category: Query$LikedSpots$likedSpots$edges$node$category.fromJson(
        (l$category as Map<String, dynamic>),
      ),
      copyright: fromJson$Enum$CopyrightType((l$copyright as String)),
      attributionText: (l$attributionText as String),
    );
  }

  final String id;

  final String title;

  final String thumbnailImageUrl;

  final String? address;

  final Query$LikedSpots$likedSpots$edges$node$category category;

  final Enum$CopyrightType copyright;

  final String attributionText;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$title = title;
    _resultData['title'] = l$title;
    final l$thumbnailImageUrl = thumbnailImageUrl;
    _resultData['thumbnailImageUrl'] = l$thumbnailImageUrl;
    final l$address = address;
    _resultData['address'] = l$address;
    final l$category = category;
    _resultData['category'] = l$category.toJson();
    final l$copyright = copyright;
    _resultData['copyright'] = toJson$Enum$CopyrightType(l$copyright);
    final l$attributionText = attributionText;
    _resultData['attributionText'] = l$attributionText;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$title = title;
    final l$thumbnailImageUrl = thumbnailImageUrl;
    final l$address = address;
    final l$category = category;
    final l$copyright = copyright;
    final l$attributionText = attributionText;
    return Object.hashAll([
      l$id,
      l$title,
      l$thumbnailImageUrl,
      l$address,
      l$category,
      l$copyright,
      l$attributionText,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$LikedSpots$likedSpots$edges$node ||
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
    final l$address = address;
    final lOther$address = other.address;
    if (l$address != lOther$address) {
      return false;
    }
    final l$category = category;
    final lOther$category = other.category;
    if (l$category != lOther$category) {
      return false;
    }
    final l$copyright = copyright;
    final lOther$copyright = other.copyright;
    if (l$copyright != lOther$copyright) {
      return false;
    }
    final l$attributionText = attributionText;
    final lOther$attributionText = other.attributionText;
    if (l$attributionText != lOther$attributionText) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Query$LikedSpots$likedSpots$edges$node
    on Query$LikedSpots$likedSpots$edges$node {
  CopyWith$Query$LikedSpots$likedSpots$edges$node<
    Query$LikedSpots$likedSpots$edges$node
  >
  get copyWith =>
      CopyWith$Query$LikedSpots$likedSpots$edges$node(this, (i) => i);
}

abstract class CopyWith$Query$LikedSpots$likedSpots$edges$node<TRes> {
  factory CopyWith$Query$LikedSpots$likedSpots$edges$node(
    Query$LikedSpots$likedSpots$edges$node instance,
    TRes Function(Query$LikedSpots$likedSpots$edges$node) then,
  ) = _CopyWithImpl$Query$LikedSpots$likedSpots$edges$node;

  factory CopyWith$Query$LikedSpots$likedSpots$edges$node.stub(TRes res) =
      _CopyWithStubImpl$Query$LikedSpots$likedSpots$edges$node;

  TRes call({
    String? id,
    String? title,
    String? thumbnailImageUrl,
    String? address,
    Query$LikedSpots$likedSpots$edges$node$category? category,
    Enum$CopyrightType? copyright,
    String? attributionText,
  });
  CopyWith$Query$LikedSpots$likedSpots$edges$node$category<TRes> get category;
}

class _CopyWithImpl$Query$LikedSpots$likedSpots$edges$node<TRes>
    implements CopyWith$Query$LikedSpots$likedSpots$edges$node<TRes> {
  _CopyWithImpl$Query$LikedSpots$likedSpots$edges$node(
    this._instance,
    this._then,
  );

  final Query$LikedSpots$likedSpots$edges$node _instance;

  final TRes Function(Query$LikedSpots$likedSpots$edges$node) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? title = _undefined,
    Object? thumbnailImageUrl = _undefined,
    Object? address = _undefined,
    Object? category = _undefined,
    Object? copyright = _undefined,
    Object? attributionText = _undefined,
  }) => _then(
    Query$LikedSpots$likedSpots$edges$node(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      title: title == _undefined || title == null
          ? _instance.title
          : (title as String),
      thumbnailImageUrl:
          thumbnailImageUrl == _undefined || thumbnailImageUrl == null
          ? _instance.thumbnailImageUrl
          : (thumbnailImageUrl as String),
      address: address == _undefined ? _instance.address : (address as String?),
      category: category == _undefined || category == null
          ? _instance.category
          : (category as Query$LikedSpots$likedSpots$edges$node$category),
      copyright: copyright == _undefined || copyright == null
          ? _instance.copyright
          : (copyright as Enum$CopyrightType),
      attributionText: attributionText == _undefined || attributionText == null
          ? _instance.attributionText
          : (attributionText as String),
    ),
  );

  CopyWith$Query$LikedSpots$likedSpots$edges$node$category<TRes> get category {
    final local$category = _instance.category;
    return CopyWith$Query$LikedSpots$likedSpots$edges$node$category(
      local$category,
      (e) => call(category: e),
    );
  }
}

class _CopyWithStubImpl$Query$LikedSpots$likedSpots$edges$node<TRes>
    implements CopyWith$Query$LikedSpots$likedSpots$edges$node<TRes> {
  _CopyWithStubImpl$Query$LikedSpots$likedSpots$edges$node(this._res);

  TRes _res;

  call({
    String? id,
    String? title,
    String? thumbnailImageUrl,
    String? address,
    Query$LikedSpots$likedSpots$edges$node$category? category,
    Enum$CopyrightType? copyright,
    String? attributionText,
  }) => _res;

  CopyWith$Query$LikedSpots$likedSpots$edges$node$category<TRes> get category =>
      CopyWith$Query$LikedSpots$likedSpots$edges$node$category.stub(_res);
}

class Query$LikedSpots$likedSpots$edges$node$category {
  Query$LikedSpots$likedSpots$edges$node$category({
    required this.code,
    required this.label,
    this.iconUrl,
  });

  factory Query$LikedSpots$likedSpots$edges$node$category.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$code = json['code'];
    final l$label = json['label'];
    final l$iconUrl = json['iconUrl'];
    return Query$LikedSpots$likedSpots$edges$node$category(
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
    if (other is! Query$LikedSpots$likedSpots$edges$node$category ||
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

extension UtilityExtension$Query$LikedSpots$likedSpots$edges$node$category
    on Query$LikedSpots$likedSpots$edges$node$category {
  CopyWith$Query$LikedSpots$likedSpots$edges$node$category<
    Query$LikedSpots$likedSpots$edges$node$category
  >
  get copyWith =>
      CopyWith$Query$LikedSpots$likedSpots$edges$node$category(this, (i) => i);
}

abstract class CopyWith$Query$LikedSpots$likedSpots$edges$node$category<TRes> {
  factory CopyWith$Query$LikedSpots$likedSpots$edges$node$category(
    Query$LikedSpots$likedSpots$edges$node$category instance,
    TRes Function(Query$LikedSpots$likedSpots$edges$node$category) then,
  ) = _CopyWithImpl$Query$LikedSpots$likedSpots$edges$node$category;

  factory CopyWith$Query$LikedSpots$likedSpots$edges$node$category.stub(
    TRes res,
  ) = _CopyWithStubImpl$Query$LikedSpots$likedSpots$edges$node$category;

  TRes call({String? code, String? label, String? iconUrl});
}

class _CopyWithImpl$Query$LikedSpots$likedSpots$edges$node$category<TRes>
    implements CopyWith$Query$LikedSpots$likedSpots$edges$node$category<TRes> {
  _CopyWithImpl$Query$LikedSpots$likedSpots$edges$node$category(
    this._instance,
    this._then,
  );

  final Query$LikedSpots$likedSpots$edges$node$category _instance;

  final TRes Function(Query$LikedSpots$likedSpots$edges$node$category) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? code = _undefined,
    Object? label = _undefined,
    Object? iconUrl = _undefined,
  }) => _then(
    Query$LikedSpots$likedSpots$edges$node$category(
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

class _CopyWithStubImpl$Query$LikedSpots$likedSpots$edges$node$category<TRes>
    implements CopyWith$Query$LikedSpots$likedSpots$edges$node$category<TRes> {
  _CopyWithStubImpl$Query$LikedSpots$likedSpots$edges$node$category(this._res);

  TRes _res;

  call({String? code, String? label, String? iconUrl}) => _res;
}

class Query$LikedSpots$likedSpots$pageInfo {
  Query$LikedSpots$likedSpots$pageInfo({
    required this.hasNextPage,
    this.endCursor,
  });

  factory Query$LikedSpots$likedSpots$pageInfo.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$hasNextPage = json['hasNextPage'];
    final l$endCursor = json['endCursor'];
    return Query$LikedSpots$likedSpots$pageInfo(
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
    if (other is! Query$LikedSpots$likedSpots$pageInfo ||
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

extension UtilityExtension$Query$LikedSpots$likedSpots$pageInfo
    on Query$LikedSpots$likedSpots$pageInfo {
  CopyWith$Query$LikedSpots$likedSpots$pageInfo<
    Query$LikedSpots$likedSpots$pageInfo
  >
  get copyWith => CopyWith$Query$LikedSpots$likedSpots$pageInfo(this, (i) => i);
}

abstract class CopyWith$Query$LikedSpots$likedSpots$pageInfo<TRes> {
  factory CopyWith$Query$LikedSpots$likedSpots$pageInfo(
    Query$LikedSpots$likedSpots$pageInfo instance,
    TRes Function(Query$LikedSpots$likedSpots$pageInfo) then,
  ) = _CopyWithImpl$Query$LikedSpots$likedSpots$pageInfo;

  factory CopyWith$Query$LikedSpots$likedSpots$pageInfo.stub(TRes res) =
      _CopyWithStubImpl$Query$LikedSpots$likedSpots$pageInfo;

  TRes call({bool? hasNextPage, String? endCursor});
}

class _CopyWithImpl$Query$LikedSpots$likedSpots$pageInfo<TRes>
    implements CopyWith$Query$LikedSpots$likedSpots$pageInfo<TRes> {
  _CopyWithImpl$Query$LikedSpots$likedSpots$pageInfo(
    this._instance,
    this._then,
  );

  final Query$LikedSpots$likedSpots$pageInfo _instance;

  final TRes Function(Query$LikedSpots$likedSpots$pageInfo) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? hasNextPage = _undefined,
    Object? endCursor = _undefined,
  }) => _then(
    Query$LikedSpots$likedSpots$pageInfo(
      hasNextPage: hasNextPage == _undefined || hasNextPage == null
          ? _instance.hasNextPage
          : (hasNextPage as bool),
      endCursor: endCursor == _undefined
          ? _instance.endCursor
          : (endCursor as String?),
    ),
  );
}

class _CopyWithStubImpl$Query$LikedSpots$likedSpots$pageInfo<TRes>
    implements CopyWith$Query$LikedSpots$likedSpots$pageInfo<TRes> {
  _CopyWithStubImpl$Query$LikedSpots$likedSpots$pageInfo(this._res);

  TRes _res;

  call({bool? hasNextPage, String? endCursor}) => _res;
}

class Variables$Mutation$ReactToSpot {
  factory Variables$Mutation$ReactToSpot({
    required Input$ReactToSpotInput input,
  }) => Variables$Mutation$ReactToSpot._({r'input': input});

  Variables$Mutation$ReactToSpot._(this._$data);

  factory Variables$Mutation$ReactToSpot.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$input = data['input'];
    result$data['input'] = Input$ReactToSpotInput.fromJson(
      (l$input as Map<String, dynamic>),
    );
    return Variables$Mutation$ReactToSpot._(result$data);
  }

  Map<String, dynamic> _$data;

  Input$ReactToSpotInput get input =>
      (_$data['input'] as Input$ReactToSpotInput);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$input = input;
    result$data['input'] = l$input.toJson();
    return result$data;
  }

  CopyWith$Variables$Mutation$ReactToSpot<Variables$Mutation$ReactToSpot>
  get copyWith => CopyWith$Variables$Mutation$ReactToSpot(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Mutation$ReactToSpot ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$input = input;
    final lOther$input = other.input;
    if (l$input != lOther$input) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$input = input;
    return Object.hashAll([l$input]);
  }
}

abstract class CopyWith$Variables$Mutation$ReactToSpot<TRes> {
  factory CopyWith$Variables$Mutation$ReactToSpot(
    Variables$Mutation$ReactToSpot instance,
    TRes Function(Variables$Mutation$ReactToSpot) then,
  ) = _CopyWithImpl$Variables$Mutation$ReactToSpot;

  factory CopyWith$Variables$Mutation$ReactToSpot.stub(TRes res) =
      _CopyWithStubImpl$Variables$Mutation$ReactToSpot;

  TRes call({Input$ReactToSpotInput? input});
}

class _CopyWithImpl$Variables$Mutation$ReactToSpot<TRes>
    implements CopyWith$Variables$Mutation$ReactToSpot<TRes> {
  _CopyWithImpl$Variables$Mutation$ReactToSpot(this._instance, this._then);

  final Variables$Mutation$ReactToSpot _instance;

  final TRes Function(Variables$Mutation$ReactToSpot) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? input = _undefined}) => _then(
    Variables$Mutation$ReactToSpot._({
      ..._instance._$data,
      if (input != _undefined && input != null)
        'input': (input as Input$ReactToSpotInput),
    }),
  );
}

class _CopyWithStubImpl$Variables$Mutation$ReactToSpot<TRes>
    implements CopyWith$Variables$Mutation$ReactToSpot<TRes> {
  _CopyWithStubImpl$Variables$Mutation$ReactToSpot(this._res);

  TRes _res;

  call({Input$ReactToSpotInput? input}) => _res;
}

class Mutation$ReactToSpot {
  Mutation$ReactToSpot({required this.reactToSpot});

  factory Mutation$ReactToSpot.fromJson(Map<String, dynamic> json) {
    final l$reactToSpot = json['reactToSpot'];
    return Mutation$ReactToSpot(
      reactToSpot: Mutation$ReactToSpot$reactToSpot.fromJson(
        (l$reactToSpot as Map<String, dynamic>),
      ),
    );
  }

  final Mutation$ReactToSpot$reactToSpot reactToSpot;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$reactToSpot = reactToSpot;
    _resultData['reactToSpot'] = l$reactToSpot.toJson();
    return _resultData;
  }

  @override
  int get hashCode {
    final l$reactToSpot = reactToSpot;
    return Object.hashAll([l$reactToSpot]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$ReactToSpot || runtimeType != other.runtimeType) {
      return false;
    }
    final l$reactToSpot = reactToSpot;
    final lOther$reactToSpot = other.reactToSpot;
    if (l$reactToSpot != lOther$reactToSpot) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Mutation$ReactToSpot on Mutation$ReactToSpot {
  CopyWith$Mutation$ReactToSpot<Mutation$ReactToSpot> get copyWith =>
      CopyWith$Mutation$ReactToSpot(this, (i) => i);
}

abstract class CopyWith$Mutation$ReactToSpot<TRes> {
  factory CopyWith$Mutation$ReactToSpot(
    Mutation$ReactToSpot instance,
    TRes Function(Mutation$ReactToSpot) then,
  ) = _CopyWithImpl$Mutation$ReactToSpot;

  factory CopyWith$Mutation$ReactToSpot.stub(TRes res) =
      _CopyWithStubImpl$Mutation$ReactToSpot;

  TRes call({Mutation$ReactToSpot$reactToSpot? reactToSpot});
  CopyWith$Mutation$ReactToSpot$reactToSpot<TRes> get reactToSpot;
}

class _CopyWithImpl$Mutation$ReactToSpot<TRes>
    implements CopyWith$Mutation$ReactToSpot<TRes> {
  _CopyWithImpl$Mutation$ReactToSpot(this._instance, this._then);

  final Mutation$ReactToSpot _instance;

  final TRes Function(Mutation$ReactToSpot) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? reactToSpot = _undefined}) => _then(
    Mutation$ReactToSpot(
      reactToSpot: reactToSpot == _undefined || reactToSpot == null
          ? _instance.reactToSpot
          : (reactToSpot as Mutation$ReactToSpot$reactToSpot),
    ),
  );

  CopyWith$Mutation$ReactToSpot$reactToSpot<TRes> get reactToSpot {
    final local$reactToSpot = _instance.reactToSpot;
    return CopyWith$Mutation$ReactToSpot$reactToSpot(
      local$reactToSpot,
      (e) => call(reactToSpot: e),
    );
  }
}

class _CopyWithStubImpl$Mutation$ReactToSpot<TRes>
    implements CopyWith$Mutation$ReactToSpot<TRes> {
  _CopyWithStubImpl$Mutation$ReactToSpot(this._res);

  TRes _res;

  call({Mutation$ReactToSpot$reactToSpot? reactToSpot}) => _res;

  CopyWith$Mutation$ReactToSpot$reactToSpot<TRes> get reactToSpot =>
      CopyWith$Mutation$ReactToSpot$reactToSpot.stub(_res);
}

const documentNodeMutationReactToSpot = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'ReactToSpot'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'input')),
          type: NamedTypeNode(
            name: NameNode(value: 'ReactToSpotInput'),
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
            name: NameNode(value: 'reactToSpot'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'input'),
                value: VariableNode(name: NameNode(value: 'input')),
              ),
            ],
            directives: [],
            selectionSet: SelectionSetNode(
              selections: [
                FieldNode(
                  name: NameNode(value: 'success'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: 'userErrors'),
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
                        name: NameNode(value: 'message'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'field'),
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

class Mutation$ReactToSpot$reactToSpot {
  Mutation$ReactToSpot$reactToSpot({
    required this.success,
    required this.userErrors,
  });

  factory Mutation$ReactToSpot$reactToSpot.fromJson(Map<String, dynamic> json) {
    final l$success = json['success'];
    final l$userErrors = json['userErrors'];
    return Mutation$ReactToSpot$reactToSpot(
      success: (l$success as bool),
      userErrors: (l$userErrors as List<dynamic>)
          .map(
            (e) => Mutation$ReactToSpot$reactToSpot$userErrors.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
    );
  }

  final bool success;

  final List<Mutation$ReactToSpot$reactToSpot$userErrors> userErrors;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$success = success;
    _resultData['success'] = l$success;
    final l$userErrors = userErrors;
    _resultData['userErrors'] = l$userErrors.map((e) => e.toJson()).toList();
    return _resultData;
  }

  @override
  int get hashCode {
    final l$success = success;
    final l$userErrors = userErrors;
    return Object.hashAll([
      l$success,
      Object.hashAll(l$userErrors.map((v) => v)),
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$ReactToSpot$reactToSpot ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$success = success;
    final lOther$success = other.success;
    if (l$success != lOther$success) {
      return false;
    }
    final l$userErrors = userErrors;
    final lOther$userErrors = other.userErrors;
    if (l$userErrors.length != lOther$userErrors.length) {
      return false;
    }
    for (int i = 0; i < l$userErrors.length; i++) {
      final l$userErrors$entry = l$userErrors[i];
      final lOther$userErrors$entry = lOther$userErrors[i];
      if (l$userErrors$entry != lOther$userErrors$entry) {
        return false;
      }
    }
    return true;
  }
}

extension UtilityExtension$Mutation$ReactToSpot$reactToSpot
    on Mutation$ReactToSpot$reactToSpot {
  CopyWith$Mutation$ReactToSpot$reactToSpot<Mutation$ReactToSpot$reactToSpot>
  get copyWith => CopyWith$Mutation$ReactToSpot$reactToSpot(this, (i) => i);
}

abstract class CopyWith$Mutation$ReactToSpot$reactToSpot<TRes> {
  factory CopyWith$Mutation$ReactToSpot$reactToSpot(
    Mutation$ReactToSpot$reactToSpot instance,
    TRes Function(Mutation$ReactToSpot$reactToSpot) then,
  ) = _CopyWithImpl$Mutation$ReactToSpot$reactToSpot;

  factory CopyWith$Mutation$ReactToSpot$reactToSpot.stub(TRes res) =
      _CopyWithStubImpl$Mutation$ReactToSpot$reactToSpot;

  TRes call({
    bool? success,
    List<Mutation$ReactToSpot$reactToSpot$userErrors>? userErrors,
  });
  TRes userErrors(
    Iterable<Mutation$ReactToSpot$reactToSpot$userErrors> Function(
      Iterable<
        CopyWith$Mutation$ReactToSpot$reactToSpot$userErrors<
          Mutation$ReactToSpot$reactToSpot$userErrors
        >
      >,
    )
    _fn,
  );
}

class _CopyWithImpl$Mutation$ReactToSpot$reactToSpot<TRes>
    implements CopyWith$Mutation$ReactToSpot$reactToSpot<TRes> {
  _CopyWithImpl$Mutation$ReactToSpot$reactToSpot(this._instance, this._then);

  final Mutation$ReactToSpot$reactToSpot _instance;

  final TRes Function(Mutation$ReactToSpot$reactToSpot) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? success = _undefined, Object? userErrors = _undefined}) =>
      _then(
        Mutation$ReactToSpot$reactToSpot(
          success: success == _undefined || success == null
              ? _instance.success
              : (success as bool),
          userErrors: userErrors == _undefined || userErrors == null
              ? _instance.userErrors
              : (userErrors
                    as List<Mutation$ReactToSpot$reactToSpot$userErrors>),
        ),
      );

  TRes userErrors(
    Iterable<Mutation$ReactToSpot$reactToSpot$userErrors> Function(
      Iterable<
        CopyWith$Mutation$ReactToSpot$reactToSpot$userErrors<
          Mutation$ReactToSpot$reactToSpot$userErrors
        >
      >,
    )
    _fn,
  ) => call(
    userErrors: _fn(
      _instance.userErrors.map(
        (e) =>
            CopyWith$Mutation$ReactToSpot$reactToSpot$userErrors(e, (i) => i),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl$Mutation$ReactToSpot$reactToSpot<TRes>
    implements CopyWith$Mutation$ReactToSpot$reactToSpot<TRes> {
  _CopyWithStubImpl$Mutation$ReactToSpot$reactToSpot(this._res);

  TRes _res;

  call({
    bool? success,
    List<Mutation$ReactToSpot$reactToSpot$userErrors>? userErrors,
  }) => _res;

  userErrors(_fn) => _res;
}

class Mutation$ReactToSpot$reactToSpot$userErrors {
  Mutation$ReactToSpot$reactToSpot$userErrors({
    required this.code,
    required this.message,
    this.field,
  });

  factory Mutation$ReactToSpot$reactToSpot$userErrors.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$code = json['code'];
    final l$message = json['message'];
    final l$field = json['field'];
    return Mutation$ReactToSpot$reactToSpot$userErrors(
      code: (l$code as String),
      message: (l$message as String),
      field: (l$field as String?),
    );
  }

  final String code;

  final String message;

  final String? field;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$code = code;
    _resultData['code'] = l$code;
    final l$message = message;
    _resultData['message'] = l$message;
    final l$field = field;
    _resultData['field'] = l$field;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$code = code;
    final l$message = message;
    final l$field = field;
    return Object.hashAll([l$code, l$message, l$field]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$ReactToSpot$reactToSpot$userErrors ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$code = code;
    final lOther$code = other.code;
    if (l$code != lOther$code) {
      return false;
    }
    final l$message = message;
    final lOther$message = other.message;
    if (l$message != lOther$message) {
      return false;
    }
    final l$field = field;
    final lOther$field = other.field;
    if (l$field != lOther$field) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Mutation$ReactToSpot$reactToSpot$userErrors
    on Mutation$ReactToSpot$reactToSpot$userErrors {
  CopyWith$Mutation$ReactToSpot$reactToSpot$userErrors<
    Mutation$ReactToSpot$reactToSpot$userErrors
  >
  get copyWith =>
      CopyWith$Mutation$ReactToSpot$reactToSpot$userErrors(this, (i) => i);
}

abstract class CopyWith$Mutation$ReactToSpot$reactToSpot$userErrors<TRes> {
  factory CopyWith$Mutation$ReactToSpot$reactToSpot$userErrors(
    Mutation$ReactToSpot$reactToSpot$userErrors instance,
    TRes Function(Mutation$ReactToSpot$reactToSpot$userErrors) then,
  ) = _CopyWithImpl$Mutation$ReactToSpot$reactToSpot$userErrors;

  factory CopyWith$Mutation$ReactToSpot$reactToSpot$userErrors.stub(TRes res) =
      _CopyWithStubImpl$Mutation$ReactToSpot$reactToSpot$userErrors;

  TRes call({String? code, String? message, String? field});
}

class _CopyWithImpl$Mutation$ReactToSpot$reactToSpot$userErrors<TRes>
    implements CopyWith$Mutation$ReactToSpot$reactToSpot$userErrors<TRes> {
  _CopyWithImpl$Mutation$ReactToSpot$reactToSpot$userErrors(
    this._instance,
    this._then,
  );

  final Mutation$ReactToSpot$reactToSpot$userErrors _instance;

  final TRes Function(Mutation$ReactToSpot$reactToSpot$userErrors) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? code = _undefined,
    Object? message = _undefined,
    Object? field = _undefined,
  }) => _then(
    Mutation$ReactToSpot$reactToSpot$userErrors(
      code: code == _undefined || code == null
          ? _instance.code
          : (code as String),
      message: message == _undefined || message == null
          ? _instance.message
          : (message as String),
      field: field == _undefined ? _instance.field : (field as String?),
    ),
  );
}

class _CopyWithStubImpl$Mutation$ReactToSpot$reactToSpot$userErrors<TRes>
    implements CopyWith$Mutation$ReactToSpot$reactToSpot$userErrors<TRes> {
  _CopyWithStubImpl$Mutation$ReactToSpot$reactToSpot$userErrors(this._res);

  TRes _res;

  call({String? code, String? message, String? field}) => _res;
}

class Variables$Query$SearchSpots {
  factory Variables$Query$SearchSpots({
    required String query,
    required double latitude,
    required double longitude,
    int? radiusMeters,
    List<String>? categories,
    int? page,
    int? size,
  }) => Variables$Query$SearchSpots._({
    r'query': query,
    r'latitude': latitude,
    r'longitude': longitude,
    if (radiusMeters != null) r'radiusMeters': radiusMeters,
    if (categories != null) r'categories': categories,
    if (page != null) r'page': page,
    if (size != null) r'size': size,
  });

  Variables$Query$SearchSpots._(this._$data);

  factory Variables$Query$SearchSpots.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$query = data['query'];
    result$data['query'] = (l$query as String);
    final l$latitude = data['latitude'];
    result$data['latitude'] = (l$latitude as num).toDouble();
    final l$longitude = data['longitude'];
    result$data['longitude'] = (l$longitude as num).toDouble();
    if (data.containsKey('radiusMeters')) {
      final l$radiusMeters = data['radiusMeters'];
      result$data['radiusMeters'] = (l$radiusMeters as int?);
    }
    if (data.containsKey('categories')) {
      final l$categories = data['categories'];
      result$data['categories'] = (l$categories as List<dynamic>?)
          ?.map((e) => (e as String))
          .toList();
    }
    if (data.containsKey('page')) {
      final l$page = data['page'];
      result$data['page'] = (l$page as int?);
    }
    if (data.containsKey('size')) {
      final l$size = data['size'];
      result$data['size'] = (l$size as int?);
    }
    return Variables$Query$SearchSpots._(result$data);
  }

  Map<String, dynamic> _$data;

  String get query => (_$data['query'] as String);

  double get latitude => (_$data['latitude'] as double);

  double get longitude => (_$data['longitude'] as double);

  int? get radiusMeters => (_$data['radiusMeters'] as int?);

  List<String>? get categories => (_$data['categories'] as List<String>?);

  int? get page => (_$data['page'] as int?);

  int? get size => (_$data['size'] as int?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$query = query;
    result$data['query'] = l$query;
    final l$latitude = latitude;
    result$data['latitude'] = l$latitude;
    final l$longitude = longitude;
    result$data['longitude'] = l$longitude;
    if (_$data.containsKey('radiusMeters')) {
      final l$radiusMeters = radiusMeters;
      result$data['radiusMeters'] = l$radiusMeters;
    }
    if (_$data.containsKey('categories')) {
      final l$categories = categories;
      result$data['categories'] = l$categories?.map((e) => e).toList();
    }
    if (_$data.containsKey('page')) {
      final l$page = page;
      result$data['page'] = l$page;
    }
    if (_$data.containsKey('size')) {
      final l$size = size;
      result$data['size'] = l$size;
    }
    return result$data;
  }

  CopyWith$Variables$Query$SearchSpots<Variables$Query$SearchSpots>
  get copyWith => CopyWith$Variables$Query$SearchSpots(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Query$SearchSpots ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$query = query;
    final lOther$query = other.query;
    if (l$query != lOther$query) {
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
    final l$page = page;
    final lOther$page = other.page;
    if (_$data.containsKey('page') != other._$data.containsKey('page')) {
      return false;
    }
    if (l$page != lOther$page) {
      return false;
    }
    final l$size = size;
    final lOther$size = other.size;
    if (_$data.containsKey('size') != other._$data.containsKey('size')) {
      return false;
    }
    if (l$size != lOther$size) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$query = query;
    final l$latitude = latitude;
    final l$longitude = longitude;
    final l$radiusMeters = radiusMeters;
    final l$categories = categories;
    final l$page = page;
    final l$size = size;
    return Object.hashAll([
      l$query,
      l$latitude,
      l$longitude,
      _$data.containsKey('radiusMeters') ? l$radiusMeters : const {},
      _$data.containsKey('categories')
          ? l$categories == null
                ? null
                : Object.hashAll(l$categories.map((v) => v))
          : const {},
      _$data.containsKey('page') ? l$page : const {},
      _$data.containsKey('size') ? l$size : const {},
    ]);
  }
}

abstract class CopyWith$Variables$Query$SearchSpots<TRes> {
  factory CopyWith$Variables$Query$SearchSpots(
    Variables$Query$SearchSpots instance,
    TRes Function(Variables$Query$SearchSpots) then,
  ) = _CopyWithImpl$Variables$Query$SearchSpots;

  factory CopyWith$Variables$Query$SearchSpots.stub(TRes res) =
      _CopyWithStubImpl$Variables$Query$SearchSpots;

  TRes call({
    String? query,
    double? latitude,
    double? longitude,
    int? radiusMeters,
    List<String>? categories,
    int? page,
    int? size,
  });
}

class _CopyWithImpl$Variables$Query$SearchSpots<TRes>
    implements CopyWith$Variables$Query$SearchSpots<TRes> {
  _CopyWithImpl$Variables$Query$SearchSpots(this._instance, this._then);

  final Variables$Query$SearchSpots _instance;

  final TRes Function(Variables$Query$SearchSpots) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? query = _undefined,
    Object? latitude = _undefined,
    Object? longitude = _undefined,
    Object? radiusMeters = _undefined,
    Object? categories = _undefined,
    Object? page = _undefined,
    Object? size = _undefined,
  }) => _then(
    Variables$Query$SearchSpots._({
      ..._instance._$data,
      if (query != _undefined && query != null) 'query': (query as String),
      if (latitude != _undefined && latitude != null)
        'latitude': (latitude as double),
      if (longitude != _undefined && longitude != null)
        'longitude': (longitude as double),
      if (radiusMeters != _undefined) 'radiusMeters': (radiusMeters as int?),
      if (categories != _undefined) 'categories': (categories as List<String>?),
      if (page != _undefined) 'page': (page as int?),
      if (size != _undefined) 'size': (size as int?),
    }),
  );
}

class _CopyWithStubImpl$Variables$Query$SearchSpots<TRes>
    implements CopyWith$Variables$Query$SearchSpots<TRes> {
  _CopyWithStubImpl$Variables$Query$SearchSpots(this._res);

  TRes _res;

  call({
    String? query,
    double? latitude,
    double? longitude,
    int? radiusMeters,
    List<String>? categories,
    int? page,
    int? size,
  }) => _res;
}

class Query$SearchSpots {
  Query$SearchSpots({required this.searchSpots});

  factory Query$SearchSpots.fromJson(Map<String, dynamic> json) {
    final l$searchSpots = json['searchSpots'];
    return Query$SearchSpots(
      searchSpots: Query$SearchSpots$searchSpots.fromJson(
        (l$searchSpots as Map<String, dynamic>),
      ),
    );
  }

  final Query$SearchSpots$searchSpots searchSpots;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$searchSpots = searchSpots;
    _resultData['searchSpots'] = l$searchSpots.toJson();
    return _resultData;
  }

  @override
  int get hashCode {
    final l$searchSpots = searchSpots;
    return Object.hashAll([l$searchSpots]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$SearchSpots || runtimeType != other.runtimeType) {
      return false;
    }
    final l$searchSpots = searchSpots;
    final lOther$searchSpots = other.searchSpots;
    if (l$searchSpots != lOther$searchSpots) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Query$SearchSpots on Query$SearchSpots {
  CopyWith$Query$SearchSpots<Query$SearchSpots> get copyWith =>
      CopyWith$Query$SearchSpots(this, (i) => i);
}

abstract class CopyWith$Query$SearchSpots<TRes> {
  factory CopyWith$Query$SearchSpots(
    Query$SearchSpots instance,
    TRes Function(Query$SearchSpots) then,
  ) = _CopyWithImpl$Query$SearchSpots;

  factory CopyWith$Query$SearchSpots.stub(TRes res) =
      _CopyWithStubImpl$Query$SearchSpots;

  TRes call({Query$SearchSpots$searchSpots? searchSpots});
  CopyWith$Query$SearchSpots$searchSpots<TRes> get searchSpots;
}

class _CopyWithImpl$Query$SearchSpots<TRes>
    implements CopyWith$Query$SearchSpots<TRes> {
  _CopyWithImpl$Query$SearchSpots(this._instance, this._then);

  final Query$SearchSpots _instance;

  final TRes Function(Query$SearchSpots) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? searchSpots = _undefined}) => _then(
    Query$SearchSpots(
      searchSpots: searchSpots == _undefined || searchSpots == null
          ? _instance.searchSpots
          : (searchSpots as Query$SearchSpots$searchSpots),
    ),
  );

  CopyWith$Query$SearchSpots$searchSpots<TRes> get searchSpots {
    final local$searchSpots = _instance.searchSpots;
    return CopyWith$Query$SearchSpots$searchSpots(
      local$searchSpots,
      (e) => call(searchSpots: e),
    );
  }
}

class _CopyWithStubImpl$Query$SearchSpots<TRes>
    implements CopyWith$Query$SearchSpots<TRes> {
  _CopyWithStubImpl$Query$SearchSpots(this._res);

  TRes _res;

  call({Query$SearchSpots$searchSpots? searchSpots}) => _res;

  CopyWith$Query$SearchSpots$searchSpots<TRes> get searchSpots =>
      CopyWith$Query$SearchSpots$searchSpots.stub(_res);
}

const documentNodeQuerySearchSpots = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'SearchSpots'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'query')),
          type: NamedTypeNode(name: NameNode(value: 'String'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
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
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'page')),
          type: NamedTypeNode(name: NameNode(value: 'Int'), isNonNull: false),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'size')),
          type: NamedTypeNode(name: NameNode(value: 'Int'), isNonNull: false),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
      ],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'searchSpots'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'query'),
                value: VariableNode(name: NameNode(value: 'query')),
              ),
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
                name: NameNode(value: 'categories'),
                value: VariableNode(name: NameNode(value: 'categories')),
              ),
              ArgumentNode(
                name: NameNode(value: 'page'),
                value: VariableNode(name: NameNode(value: 'page')),
              ),
              ArgumentNode(
                name: NameNode(value: 'size'),
                value: VariableNode(name: NameNode(value: 'size')),
              ),
            ],
            directives: [],
            selectionSet: SelectionSetNode(
              selections: [
                FieldNode(
                  name: NameNode(value: 'success'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: 'userErrors'),
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
                        name: NameNode(value: 'field'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                    ],
                  ),
                ),
                FieldNode(
                  name: NameNode(value: 'connection'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: SelectionSetNode(
                    selections: [
                      FieldNode(
                        name: NameNode(value: 'items'),
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
                              name: NameNode(value: 'copyright'),
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
                              name: NameNode(value: 'mapX'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null,
                            ),
                            FieldNode(
                              name: NameNode(value: 'mapY'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null,
                            ),
                          ],
                        ),
                      ),
                      FieldNode(
                        name: NameNode(value: 'page'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'hasNext'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'totalCount'),
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

class Query$SearchSpots$searchSpots {
  Query$SearchSpots$searchSpots({
    required this.success,
    required this.userErrors,
    required this.connection,
  });

  factory Query$SearchSpots$searchSpots.fromJson(Map<String, dynamic> json) {
    final l$success = json['success'];
    final l$userErrors = json['userErrors'];
    final l$connection = json['connection'];
    return Query$SearchSpots$searchSpots(
      success: (l$success as bool),
      userErrors: (l$userErrors as List<dynamic>)
          .map(
            (e) => Query$SearchSpots$searchSpots$userErrors.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      connection: Query$SearchSpots$searchSpots$connection.fromJson(
        (l$connection as Map<String, dynamic>),
      ),
    );
  }

  final bool success;

  final List<Query$SearchSpots$searchSpots$userErrors> userErrors;

  final Query$SearchSpots$searchSpots$connection connection;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$success = success;
    _resultData['success'] = l$success;
    final l$userErrors = userErrors;
    _resultData['userErrors'] = l$userErrors.map((e) => e.toJson()).toList();
    final l$connection = connection;
    _resultData['connection'] = l$connection.toJson();
    return _resultData;
  }

  @override
  int get hashCode {
    final l$success = success;
    final l$userErrors = userErrors;
    final l$connection = connection;
    return Object.hashAll([
      l$success,
      Object.hashAll(l$userErrors.map((v) => v)),
      l$connection,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$SearchSpots$searchSpots ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$success = success;
    final lOther$success = other.success;
    if (l$success != lOther$success) {
      return false;
    }
    final l$userErrors = userErrors;
    final lOther$userErrors = other.userErrors;
    if (l$userErrors.length != lOther$userErrors.length) {
      return false;
    }
    for (int i = 0; i < l$userErrors.length; i++) {
      final l$userErrors$entry = l$userErrors[i];
      final lOther$userErrors$entry = lOther$userErrors[i];
      if (l$userErrors$entry != lOther$userErrors$entry) {
        return false;
      }
    }
    final l$connection = connection;
    final lOther$connection = other.connection;
    if (l$connection != lOther$connection) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Query$SearchSpots$searchSpots
    on Query$SearchSpots$searchSpots {
  CopyWith$Query$SearchSpots$searchSpots<Query$SearchSpots$searchSpots>
  get copyWith => CopyWith$Query$SearchSpots$searchSpots(this, (i) => i);
}

abstract class CopyWith$Query$SearchSpots$searchSpots<TRes> {
  factory CopyWith$Query$SearchSpots$searchSpots(
    Query$SearchSpots$searchSpots instance,
    TRes Function(Query$SearchSpots$searchSpots) then,
  ) = _CopyWithImpl$Query$SearchSpots$searchSpots;

  factory CopyWith$Query$SearchSpots$searchSpots.stub(TRes res) =
      _CopyWithStubImpl$Query$SearchSpots$searchSpots;

  TRes call({
    bool? success,
    List<Query$SearchSpots$searchSpots$userErrors>? userErrors,
    Query$SearchSpots$searchSpots$connection? connection,
  });
  TRes userErrors(
    Iterable<Query$SearchSpots$searchSpots$userErrors> Function(
      Iterable<
        CopyWith$Query$SearchSpots$searchSpots$userErrors<
          Query$SearchSpots$searchSpots$userErrors
        >
      >,
    )
    _fn,
  );
  CopyWith$Query$SearchSpots$searchSpots$connection<TRes> get connection;
}

class _CopyWithImpl$Query$SearchSpots$searchSpots<TRes>
    implements CopyWith$Query$SearchSpots$searchSpots<TRes> {
  _CopyWithImpl$Query$SearchSpots$searchSpots(this._instance, this._then);

  final Query$SearchSpots$searchSpots _instance;

  final TRes Function(Query$SearchSpots$searchSpots) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? success = _undefined,
    Object? userErrors = _undefined,
    Object? connection = _undefined,
  }) => _then(
    Query$SearchSpots$searchSpots(
      success: success == _undefined || success == null
          ? _instance.success
          : (success as bool),
      userErrors: userErrors == _undefined || userErrors == null
          ? _instance.userErrors
          : (userErrors as List<Query$SearchSpots$searchSpots$userErrors>),
      connection: connection == _undefined || connection == null
          ? _instance.connection
          : (connection as Query$SearchSpots$searchSpots$connection),
    ),
  );

  TRes userErrors(
    Iterable<Query$SearchSpots$searchSpots$userErrors> Function(
      Iterable<
        CopyWith$Query$SearchSpots$searchSpots$userErrors<
          Query$SearchSpots$searchSpots$userErrors
        >
      >,
    )
    _fn,
  ) => call(
    userErrors: _fn(
      _instance.userErrors.map(
        (e) => CopyWith$Query$SearchSpots$searchSpots$userErrors(e, (i) => i),
      ),
    ).toList(),
  );

  CopyWith$Query$SearchSpots$searchSpots$connection<TRes> get connection {
    final local$connection = _instance.connection;
    return CopyWith$Query$SearchSpots$searchSpots$connection(
      local$connection,
      (e) => call(connection: e),
    );
  }
}

class _CopyWithStubImpl$Query$SearchSpots$searchSpots<TRes>
    implements CopyWith$Query$SearchSpots$searchSpots<TRes> {
  _CopyWithStubImpl$Query$SearchSpots$searchSpots(this._res);

  TRes _res;

  call({
    bool? success,
    List<Query$SearchSpots$searchSpots$userErrors>? userErrors,
    Query$SearchSpots$searchSpots$connection? connection,
  }) => _res;

  userErrors(_fn) => _res;

  CopyWith$Query$SearchSpots$searchSpots$connection<TRes> get connection =>
      CopyWith$Query$SearchSpots$searchSpots$connection.stub(_res);
}

class Query$SearchSpots$searchSpots$userErrors {
  Query$SearchSpots$searchSpots$userErrors({required this.code, this.field});

  factory Query$SearchSpots$searchSpots$userErrors.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$code = json['code'];
    final l$field = json['field'];
    return Query$SearchSpots$searchSpots$userErrors(
      code: (l$code as String),
      field: (l$field as String?),
    );
  }

  final String code;

  final String? field;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$code = code;
    _resultData['code'] = l$code;
    final l$field = field;
    _resultData['field'] = l$field;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$code = code;
    final l$field = field;
    return Object.hashAll([l$code, l$field]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$SearchSpots$searchSpots$userErrors ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$code = code;
    final lOther$code = other.code;
    if (l$code != lOther$code) {
      return false;
    }
    final l$field = field;
    final lOther$field = other.field;
    if (l$field != lOther$field) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Query$SearchSpots$searchSpots$userErrors
    on Query$SearchSpots$searchSpots$userErrors {
  CopyWith$Query$SearchSpots$searchSpots$userErrors<
    Query$SearchSpots$searchSpots$userErrors
  >
  get copyWith =>
      CopyWith$Query$SearchSpots$searchSpots$userErrors(this, (i) => i);
}

abstract class CopyWith$Query$SearchSpots$searchSpots$userErrors<TRes> {
  factory CopyWith$Query$SearchSpots$searchSpots$userErrors(
    Query$SearchSpots$searchSpots$userErrors instance,
    TRes Function(Query$SearchSpots$searchSpots$userErrors) then,
  ) = _CopyWithImpl$Query$SearchSpots$searchSpots$userErrors;

  factory CopyWith$Query$SearchSpots$searchSpots$userErrors.stub(TRes res) =
      _CopyWithStubImpl$Query$SearchSpots$searchSpots$userErrors;

  TRes call({String? code, String? field});
}

class _CopyWithImpl$Query$SearchSpots$searchSpots$userErrors<TRes>
    implements CopyWith$Query$SearchSpots$searchSpots$userErrors<TRes> {
  _CopyWithImpl$Query$SearchSpots$searchSpots$userErrors(
    this._instance,
    this._then,
  );

  final Query$SearchSpots$searchSpots$userErrors _instance;

  final TRes Function(Query$SearchSpots$searchSpots$userErrors) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? code = _undefined, Object? field = _undefined}) => _then(
    Query$SearchSpots$searchSpots$userErrors(
      code: code == _undefined || code == null
          ? _instance.code
          : (code as String),
      field: field == _undefined ? _instance.field : (field as String?),
    ),
  );
}

class _CopyWithStubImpl$Query$SearchSpots$searchSpots$userErrors<TRes>
    implements CopyWith$Query$SearchSpots$searchSpots$userErrors<TRes> {
  _CopyWithStubImpl$Query$SearchSpots$searchSpots$userErrors(this._res);

  TRes _res;

  call({String? code, String? field}) => _res;
}

class Query$SearchSpots$searchSpots$connection {
  Query$SearchSpots$searchSpots$connection({
    required this.items,
    required this.page,
    required this.hasNext,
    required this.totalCount,
  });

  factory Query$SearchSpots$searchSpots$connection.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$items = json['items'];
    final l$page = json['page'];
    final l$hasNext = json['hasNext'];
    final l$totalCount = json['totalCount'];
    return Query$SearchSpots$searchSpots$connection(
      items: (l$items as List<dynamic>)
          .map(
            (e) => Query$SearchSpots$searchSpots$connection$items.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      page: (l$page as int),
      hasNext: (l$hasNext as bool),
      totalCount: (l$totalCount as int),
    );
  }

  final List<Query$SearchSpots$searchSpots$connection$items> items;

  final int page;

  final bool hasNext;

  final int totalCount;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$items = items;
    _resultData['items'] = l$items.map((e) => e.toJson()).toList();
    final l$page = page;
    _resultData['page'] = l$page;
    final l$hasNext = hasNext;
    _resultData['hasNext'] = l$hasNext;
    final l$totalCount = totalCount;
    _resultData['totalCount'] = l$totalCount;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$items = items;
    final l$page = page;
    final l$hasNext = hasNext;
    final l$totalCount = totalCount;
    return Object.hashAll([
      Object.hashAll(l$items.map((v) => v)),
      l$page,
      l$hasNext,
      l$totalCount,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$SearchSpots$searchSpots$connection ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$items = items;
    final lOther$items = other.items;
    if (l$items.length != lOther$items.length) {
      return false;
    }
    for (int i = 0; i < l$items.length; i++) {
      final l$items$entry = l$items[i];
      final lOther$items$entry = lOther$items[i];
      if (l$items$entry != lOther$items$entry) {
        return false;
      }
    }
    final l$page = page;
    final lOther$page = other.page;
    if (l$page != lOther$page) {
      return false;
    }
    final l$hasNext = hasNext;
    final lOther$hasNext = other.hasNext;
    if (l$hasNext != lOther$hasNext) {
      return false;
    }
    final l$totalCount = totalCount;
    final lOther$totalCount = other.totalCount;
    if (l$totalCount != lOther$totalCount) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Query$SearchSpots$searchSpots$connection
    on Query$SearchSpots$searchSpots$connection {
  CopyWith$Query$SearchSpots$searchSpots$connection<
    Query$SearchSpots$searchSpots$connection
  >
  get copyWith =>
      CopyWith$Query$SearchSpots$searchSpots$connection(this, (i) => i);
}

abstract class CopyWith$Query$SearchSpots$searchSpots$connection<TRes> {
  factory CopyWith$Query$SearchSpots$searchSpots$connection(
    Query$SearchSpots$searchSpots$connection instance,
    TRes Function(Query$SearchSpots$searchSpots$connection) then,
  ) = _CopyWithImpl$Query$SearchSpots$searchSpots$connection;

  factory CopyWith$Query$SearchSpots$searchSpots$connection.stub(TRes res) =
      _CopyWithStubImpl$Query$SearchSpots$searchSpots$connection;

  TRes call({
    List<Query$SearchSpots$searchSpots$connection$items>? items,
    int? page,
    bool? hasNext,
    int? totalCount,
  });
  TRes items(
    Iterable<Query$SearchSpots$searchSpots$connection$items> Function(
      Iterable<
        CopyWith$Query$SearchSpots$searchSpots$connection$items<
          Query$SearchSpots$searchSpots$connection$items
        >
      >,
    )
    _fn,
  );
}

class _CopyWithImpl$Query$SearchSpots$searchSpots$connection<TRes>
    implements CopyWith$Query$SearchSpots$searchSpots$connection<TRes> {
  _CopyWithImpl$Query$SearchSpots$searchSpots$connection(
    this._instance,
    this._then,
  );

  final Query$SearchSpots$searchSpots$connection _instance;

  final TRes Function(Query$SearchSpots$searchSpots$connection) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? items = _undefined,
    Object? page = _undefined,
    Object? hasNext = _undefined,
    Object? totalCount = _undefined,
  }) => _then(
    Query$SearchSpots$searchSpots$connection(
      items: items == _undefined || items == null
          ? _instance.items
          : (items as List<Query$SearchSpots$searchSpots$connection$items>),
      page: page == _undefined || page == null ? _instance.page : (page as int),
      hasNext: hasNext == _undefined || hasNext == null
          ? _instance.hasNext
          : (hasNext as bool),
      totalCount: totalCount == _undefined || totalCount == null
          ? _instance.totalCount
          : (totalCount as int),
    ),
  );

  TRes items(
    Iterable<Query$SearchSpots$searchSpots$connection$items> Function(
      Iterable<
        CopyWith$Query$SearchSpots$searchSpots$connection$items<
          Query$SearchSpots$searchSpots$connection$items
        >
      >,
    )
    _fn,
  ) => call(
    items: _fn(
      _instance.items.map(
        (e) => CopyWith$Query$SearchSpots$searchSpots$connection$items(
          e,
          (i) => i,
        ),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl$Query$SearchSpots$searchSpots$connection<TRes>
    implements CopyWith$Query$SearchSpots$searchSpots$connection<TRes> {
  _CopyWithStubImpl$Query$SearchSpots$searchSpots$connection(this._res);

  TRes _res;

  call({
    List<Query$SearchSpots$searchSpots$connection$items>? items,
    int? page,
    bool? hasNext,
    int? totalCount,
  }) => _res;

  items(_fn) => _res;
}

class Query$SearchSpots$searchSpots$connection$items {
  Query$SearchSpots$searchSpots$connection$items({
    required this.id,
    required this.title,
    this.address,
    required this.thumbnailImageUrl,
    required this.distanceMeters,
    required this.category,
    required this.copyright,
    required this.attributionText,
    required this.mapX,
    required this.mapY,
  });

  factory Query$SearchSpots$searchSpots$connection$items.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$title = json['title'];
    final l$address = json['address'];
    final l$thumbnailImageUrl = json['thumbnailImageUrl'];
    final l$distanceMeters = json['distanceMeters'];
    final l$category = json['category'];
    final l$copyright = json['copyright'];
    final l$attributionText = json['attributionText'];
    final l$mapX = json['mapX'];
    final l$mapY = json['mapY'];
    return Query$SearchSpots$searchSpots$connection$items(
      id: (l$id as String),
      title: (l$title as String),
      address: (l$address as String?),
      thumbnailImageUrl: (l$thumbnailImageUrl as String),
      distanceMeters: (l$distanceMeters as num).toDouble(),
      category:
          Query$SearchSpots$searchSpots$connection$items$category.fromJson(
            (l$category as Map<String, dynamic>),
          ),
      copyright: fromJson$Enum$CopyrightType((l$copyright as String)),
      attributionText: (l$attributionText as String),
      mapX: (l$mapX as num).toDouble(),
      mapY: (l$mapY as num).toDouble(),
    );
  }

  final String id;

  final String title;

  final String? address;

  final String thumbnailImageUrl;

  final double distanceMeters;

  final Query$SearchSpots$searchSpots$connection$items$category category;

  final Enum$CopyrightType copyright;

  final String attributionText;

  final double mapX;

  final double mapY;

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
    final l$category = category;
    _resultData['category'] = l$category.toJson();
    final l$copyright = copyright;
    _resultData['copyright'] = toJson$Enum$CopyrightType(l$copyright);
    final l$attributionText = attributionText;
    _resultData['attributionText'] = l$attributionText;
    final l$mapX = mapX;
    _resultData['mapX'] = l$mapX;
    final l$mapY = mapY;
    _resultData['mapY'] = l$mapY;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$title = title;
    final l$address = address;
    final l$thumbnailImageUrl = thumbnailImageUrl;
    final l$distanceMeters = distanceMeters;
    final l$category = category;
    final l$copyright = copyright;
    final l$attributionText = attributionText;
    final l$mapX = mapX;
    final l$mapY = mapY;
    return Object.hashAll([
      l$id,
      l$title,
      l$address,
      l$thumbnailImageUrl,
      l$distanceMeters,
      l$category,
      l$copyright,
      l$attributionText,
      l$mapX,
      l$mapY,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$SearchSpots$searchSpots$connection$items ||
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
    final l$category = category;
    final lOther$category = other.category;
    if (l$category != lOther$category) {
      return false;
    }
    final l$copyright = copyright;
    final lOther$copyright = other.copyright;
    if (l$copyright != lOther$copyright) {
      return false;
    }
    final l$attributionText = attributionText;
    final lOther$attributionText = other.attributionText;
    if (l$attributionText != lOther$attributionText) {
      return false;
    }
    final l$mapX = mapX;
    final lOther$mapX = other.mapX;
    if (l$mapX != lOther$mapX) {
      return false;
    }
    final l$mapY = mapY;
    final lOther$mapY = other.mapY;
    if (l$mapY != lOther$mapY) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Query$SearchSpots$searchSpots$connection$items
    on Query$SearchSpots$searchSpots$connection$items {
  CopyWith$Query$SearchSpots$searchSpots$connection$items<
    Query$SearchSpots$searchSpots$connection$items
  >
  get copyWith =>
      CopyWith$Query$SearchSpots$searchSpots$connection$items(this, (i) => i);
}

abstract class CopyWith$Query$SearchSpots$searchSpots$connection$items<TRes> {
  factory CopyWith$Query$SearchSpots$searchSpots$connection$items(
    Query$SearchSpots$searchSpots$connection$items instance,
    TRes Function(Query$SearchSpots$searchSpots$connection$items) then,
  ) = _CopyWithImpl$Query$SearchSpots$searchSpots$connection$items;

  factory CopyWith$Query$SearchSpots$searchSpots$connection$items.stub(
    TRes res,
  ) = _CopyWithStubImpl$Query$SearchSpots$searchSpots$connection$items;

  TRes call({
    String? id,
    String? title,
    String? address,
    String? thumbnailImageUrl,
    double? distanceMeters,
    Query$SearchSpots$searchSpots$connection$items$category? category,
    Enum$CopyrightType? copyright,
    String? attributionText,
    double? mapX,
    double? mapY,
  });
  CopyWith$Query$SearchSpots$searchSpots$connection$items$category<TRes>
  get category;
}

class _CopyWithImpl$Query$SearchSpots$searchSpots$connection$items<TRes>
    implements CopyWith$Query$SearchSpots$searchSpots$connection$items<TRes> {
  _CopyWithImpl$Query$SearchSpots$searchSpots$connection$items(
    this._instance,
    this._then,
  );

  final Query$SearchSpots$searchSpots$connection$items _instance;

  final TRes Function(Query$SearchSpots$searchSpots$connection$items) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? title = _undefined,
    Object? address = _undefined,
    Object? thumbnailImageUrl = _undefined,
    Object? distanceMeters = _undefined,
    Object? category = _undefined,
    Object? copyright = _undefined,
    Object? attributionText = _undefined,
    Object? mapX = _undefined,
    Object? mapY = _undefined,
  }) => _then(
    Query$SearchSpots$searchSpots$connection$items(
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
      category: category == _undefined || category == null
          ? _instance.category
          : (category
                as Query$SearchSpots$searchSpots$connection$items$category),
      copyright: copyright == _undefined || copyright == null
          ? _instance.copyright
          : (copyright as Enum$CopyrightType),
      attributionText: attributionText == _undefined || attributionText == null
          ? _instance.attributionText
          : (attributionText as String),
      mapX: mapX == _undefined || mapX == null
          ? _instance.mapX
          : (mapX as double),
      mapY: mapY == _undefined || mapY == null
          ? _instance.mapY
          : (mapY as double),
    ),
  );

  CopyWith$Query$SearchSpots$searchSpots$connection$items$category<TRes>
  get category {
    final local$category = _instance.category;
    return CopyWith$Query$SearchSpots$searchSpots$connection$items$category(
      local$category,
      (e) => call(category: e),
    );
  }
}

class _CopyWithStubImpl$Query$SearchSpots$searchSpots$connection$items<TRes>
    implements CopyWith$Query$SearchSpots$searchSpots$connection$items<TRes> {
  _CopyWithStubImpl$Query$SearchSpots$searchSpots$connection$items(this._res);

  TRes _res;

  call({
    String? id,
    String? title,
    String? address,
    String? thumbnailImageUrl,
    double? distanceMeters,
    Query$SearchSpots$searchSpots$connection$items$category? category,
    Enum$CopyrightType? copyright,
    String? attributionText,
    double? mapX,
    double? mapY,
  }) => _res;

  CopyWith$Query$SearchSpots$searchSpots$connection$items$category<TRes>
  get category =>
      CopyWith$Query$SearchSpots$searchSpots$connection$items$category.stub(
        _res,
      );
}

class Query$SearchSpots$searchSpots$connection$items$category {
  Query$SearchSpots$searchSpots$connection$items$category({
    required this.code,
    required this.label,
    this.iconUrl,
  });

  factory Query$SearchSpots$searchSpots$connection$items$category.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$code = json['code'];
    final l$label = json['label'];
    final l$iconUrl = json['iconUrl'];
    return Query$SearchSpots$searchSpots$connection$items$category(
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
    if (other is! Query$SearchSpots$searchSpots$connection$items$category ||
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

extension UtilityExtension$Query$SearchSpots$searchSpots$connection$items$category
    on Query$SearchSpots$searchSpots$connection$items$category {
  CopyWith$Query$SearchSpots$searchSpots$connection$items$category<
    Query$SearchSpots$searchSpots$connection$items$category
  >
  get copyWith =>
      CopyWith$Query$SearchSpots$searchSpots$connection$items$category(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Query$SearchSpots$searchSpots$connection$items$category<
  TRes
> {
  factory CopyWith$Query$SearchSpots$searchSpots$connection$items$category(
    Query$SearchSpots$searchSpots$connection$items$category instance,
    TRes Function(Query$SearchSpots$searchSpots$connection$items$category) then,
  ) = _CopyWithImpl$Query$SearchSpots$searchSpots$connection$items$category;

  factory CopyWith$Query$SearchSpots$searchSpots$connection$items$category.stub(
    TRes res,
  ) = _CopyWithStubImpl$Query$SearchSpots$searchSpots$connection$items$category;

  TRes call({String? code, String? label, String? iconUrl});
}

class _CopyWithImpl$Query$SearchSpots$searchSpots$connection$items$category<
  TRes
>
    implements
        CopyWith$Query$SearchSpots$searchSpots$connection$items$category<TRes> {
  _CopyWithImpl$Query$SearchSpots$searchSpots$connection$items$category(
    this._instance,
    this._then,
  );

  final Query$SearchSpots$searchSpots$connection$items$category _instance;

  final TRes Function(Query$SearchSpots$searchSpots$connection$items$category)
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? code = _undefined,
    Object? label = _undefined,
    Object? iconUrl = _undefined,
  }) => _then(
    Query$SearchSpots$searchSpots$connection$items$category(
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

class _CopyWithStubImpl$Query$SearchSpots$searchSpots$connection$items$category<
  TRes
>
    implements
        CopyWith$Query$SearchSpots$searchSpots$connection$items$category<TRes> {
  _CopyWithStubImpl$Query$SearchSpots$searchSpots$connection$items$category(
    this._res,
  );

  TRes _res;

  call({String? code, String? label, String? iconUrl}) => _res;
}

class Variables$Query$SpotSearchSuggestions {
  factory Variables$Query$SpotSearchSuggestions({
    required String query,
    required double latitude,
    required double longitude,
    int? radiusMeters,
    int? limit,
  }) => Variables$Query$SpotSearchSuggestions._({
    r'query': query,
    r'latitude': latitude,
    r'longitude': longitude,
    if (radiusMeters != null) r'radiusMeters': radiusMeters,
    if (limit != null) r'limit': limit,
  });

  Variables$Query$SpotSearchSuggestions._(this._$data);

  factory Variables$Query$SpotSearchSuggestions.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    final l$query = data['query'];
    result$data['query'] = (l$query as String);
    final l$latitude = data['latitude'];
    result$data['latitude'] = (l$latitude as num).toDouble();
    final l$longitude = data['longitude'];
    result$data['longitude'] = (l$longitude as num).toDouble();
    if (data.containsKey('radiusMeters')) {
      final l$radiusMeters = data['radiusMeters'];
      result$data['radiusMeters'] = (l$radiusMeters as int?);
    }
    if (data.containsKey('limit')) {
      final l$limit = data['limit'];
      result$data['limit'] = (l$limit as int?);
    }
    return Variables$Query$SpotSearchSuggestions._(result$data);
  }

  Map<String, dynamic> _$data;

  String get query => (_$data['query'] as String);

  double get latitude => (_$data['latitude'] as double);

  double get longitude => (_$data['longitude'] as double);

  int? get radiusMeters => (_$data['radiusMeters'] as int?);

  int? get limit => (_$data['limit'] as int?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$query = query;
    result$data['query'] = l$query;
    final l$latitude = latitude;
    result$data['latitude'] = l$latitude;
    final l$longitude = longitude;
    result$data['longitude'] = l$longitude;
    if (_$data.containsKey('radiusMeters')) {
      final l$radiusMeters = radiusMeters;
      result$data['radiusMeters'] = l$radiusMeters;
    }
    if (_$data.containsKey('limit')) {
      final l$limit = limit;
      result$data['limit'] = l$limit;
    }
    return result$data;
  }

  CopyWith$Variables$Query$SpotSearchSuggestions<
    Variables$Query$SpotSearchSuggestions
  >
  get copyWith =>
      CopyWith$Variables$Query$SpotSearchSuggestions(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Query$SpotSearchSuggestions ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$query = query;
    final lOther$query = other.query;
    if (l$query != lOther$query) {
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
    final l$query = query;
    final l$latitude = latitude;
    final l$longitude = longitude;
    final l$radiusMeters = radiusMeters;
    final l$limit = limit;
    return Object.hashAll([
      l$query,
      l$latitude,
      l$longitude,
      _$data.containsKey('radiusMeters') ? l$radiusMeters : const {},
      _$data.containsKey('limit') ? l$limit : const {},
    ]);
  }
}

abstract class CopyWith$Variables$Query$SpotSearchSuggestions<TRes> {
  factory CopyWith$Variables$Query$SpotSearchSuggestions(
    Variables$Query$SpotSearchSuggestions instance,
    TRes Function(Variables$Query$SpotSearchSuggestions) then,
  ) = _CopyWithImpl$Variables$Query$SpotSearchSuggestions;

  factory CopyWith$Variables$Query$SpotSearchSuggestions.stub(TRes res) =
      _CopyWithStubImpl$Variables$Query$SpotSearchSuggestions;

  TRes call({
    String? query,
    double? latitude,
    double? longitude,
    int? radiusMeters,
    int? limit,
  });
}

class _CopyWithImpl$Variables$Query$SpotSearchSuggestions<TRes>
    implements CopyWith$Variables$Query$SpotSearchSuggestions<TRes> {
  _CopyWithImpl$Variables$Query$SpotSearchSuggestions(
    this._instance,
    this._then,
  );

  final Variables$Query$SpotSearchSuggestions _instance;

  final TRes Function(Variables$Query$SpotSearchSuggestions) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? query = _undefined,
    Object? latitude = _undefined,
    Object? longitude = _undefined,
    Object? radiusMeters = _undefined,
    Object? limit = _undefined,
  }) => _then(
    Variables$Query$SpotSearchSuggestions._({
      ..._instance._$data,
      if (query != _undefined && query != null) 'query': (query as String),
      if (latitude != _undefined && latitude != null)
        'latitude': (latitude as double),
      if (longitude != _undefined && longitude != null)
        'longitude': (longitude as double),
      if (radiusMeters != _undefined) 'radiusMeters': (radiusMeters as int?),
      if (limit != _undefined) 'limit': (limit as int?),
    }),
  );
}

class _CopyWithStubImpl$Variables$Query$SpotSearchSuggestions<TRes>
    implements CopyWith$Variables$Query$SpotSearchSuggestions<TRes> {
  _CopyWithStubImpl$Variables$Query$SpotSearchSuggestions(this._res);

  TRes _res;

  call({
    String? query,
    double? latitude,
    double? longitude,
    int? radiusMeters,
    int? limit,
  }) => _res;
}

class Query$SpotSearchSuggestions {
  Query$SpotSearchSuggestions({required this.spotSearchSuggestions});

  factory Query$SpotSearchSuggestions.fromJson(Map<String, dynamic> json) {
    final l$spotSearchSuggestions = json['spotSearchSuggestions'];
    return Query$SpotSearchSuggestions(
      spotSearchSuggestions: (l$spotSearchSuggestions as List<dynamic>)
          .map(
            (e) => Query$SpotSearchSuggestions$spotSearchSuggestions.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
    );
  }

  final List<Query$SpotSearchSuggestions$spotSearchSuggestions>
  spotSearchSuggestions;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$spotSearchSuggestions = spotSearchSuggestions;
    _resultData['spotSearchSuggestions'] = l$spotSearchSuggestions
        .map((e) => e.toJson())
        .toList();
    return _resultData;
  }

  @override
  int get hashCode {
    final l$spotSearchSuggestions = spotSearchSuggestions;
    return Object.hashAll([
      Object.hashAll(l$spotSearchSuggestions.map((v) => v)),
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$SpotSearchSuggestions ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$spotSearchSuggestions = spotSearchSuggestions;
    final lOther$spotSearchSuggestions = other.spotSearchSuggestions;
    if (l$spotSearchSuggestions.length != lOther$spotSearchSuggestions.length) {
      return false;
    }
    for (int i = 0; i < l$spotSearchSuggestions.length; i++) {
      final l$spotSearchSuggestions$entry = l$spotSearchSuggestions[i];
      final lOther$spotSearchSuggestions$entry =
          lOther$spotSearchSuggestions[i];
      if (l$spotSearchSuggestions$entry != lOther$spotSearchSuggestions$entry) {
        return false;
      }
    }
    return true;
  }
}

extension UtilityExtension$Query$SpotSearchSuggestions
    on Query$SpotSearchSuggestions {
  CopyWith$Query$SpotSearchSuggestions<Query$SpotSearchSuggestions>
  get copyWith => CopyWith$Query$SpotSearchSuggestions(this, (i) => i);
}

abstract class CopyWith$Query$SpotSearchSuggestions<TRes> {
  factory CopyWith$Query$SpotSearchSuggestions(
    Query$SpotSearchSuggestions instance,
    TRes Function(Query$SpotSearchSuggestions) then,
  ) = _CopyWithImpl$Query$SpotSearchSuggestions;

  factory CopyWith$Query$SpotSearchSuggestions.stub(TRes res) =
      _CopyWithStubImpl$Query$SpotSearchSuggestions;

  TRes call({
    List<Query$SpotSearchSuggestions$spotSearchSuggestions>?
    spotSearchSuggestions,
  });
  TRes spotSearchSuggestions(
    Iterable<Query$SpotSearchSuggestions$spotSearchSuggestions> Function(
      Iterable<
        CopyWith$Query$SpotSearchSuggestions$spotSearchSuggestions<
          Query$SpotSearchSuggestions$spotSearchSuggestions
        >
      >,
    )
    _fn,
  );
}

class _CopyWithImpl$Query$SpotSearchSuggestions<TRes>
    implements CopyWith$Query$SpotSearchSuggestions<TRes> {
  _CopyWithImpl$Query$SpotSearchSuggestions(this._instance, this._then);

  final Query$SpotSearchSuggestions _instance;

  final TRes Function(Query$SpotSearchSuggestions) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? spotSearchSuggestions = _undefined}) => _then(
    Query$SpotSearchSuggestions(
      spotSearchSuggestions:
          spotSearchSuggestions == _undefined || spotSearchSuggestions == null
          ? _instance.spotSearchSuggestions
          : (spotSearchSuggestions
                as List<Query$SpotSearchSuggestions$spotSearchSuggestions>),
    ),
  );

  TRes spotSearchSuggestions(
    Iterable<Query$SpotSearchSuggestions$spotSearchSuggestions> Function(
      Iterable<
        CopyWith$Query$SpotSearchSuggestions$spotSearchSuggestions<
          Query$SpotSearchSuggestions$spotSearchSuggestions
        >
      >,
    )
    _fn,
  ) => call(
    spotSearchSuggestions: _fn(
      _instance.spotSearchSuggestions.map(
        (e) => CopyWith$Query$SpotSearchSuggestions$spotSearchSuggestions(
          e,
          (i) => i,
        ),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl$Query$SpotSearchSuggestions<TRes>
    implements CopyWith$Query$SpotSearchSuggestions<TRes> {
  _CopyWithStubImpl$Query$SpotSearchSuggestions(this._res);

  TRes _res;

  call({
    List<Query$SpotSearchSuggestions$spotSearchSuggestions>?
    spotSearchSuggestions,
  }) => _res;

  spotSearchSuggestions(_fn) => _res;
}

const documentNodeQuerySpotSearchSuggestions = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'SpotSearchSuggestions'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'query')),
          type: NamedTypeNode(name: NameNode(value: 'String'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
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
            name: NameNode(value: 'spotSearchSuggestions'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'query'),
                value: VariableNode(name: NameNode(value: 'query')),
              ),
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
                name: NameNode(value: 'limit'),
                value: VariableNode(name: NameNode(value: 'limit')),
              ),
            ],
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
              ],
            ),
          ),
        ],
      ),
    ),
  ],
);

class Query$SpotSearchSuggestions$spotSearchSuggestions {
  Query$SpotSearchSuggestions$spotSearchSuggestions({
    required this.id,
    required this.title,
    required this.category,
  });

  factory Query$SpotSearchSuggestions$spotSearchSuggestions.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$title = json['title'];
    final l$category = json['category'];
    return Query$SpotSearchSuggestions$spotSearchSuggestions(
      id: (l$id as String),
      title: (l$title as String),
      category:
          Query$SpotSearchSuggestions$spotSearchSuggestions$category.fromJson(
            (l$category as Map<String, dynamic>),
          ),
    );
  }

  final String id;

  final String title;

  final Query$SpotSearchSuggestions$spotSearchSuggestions$category category;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$title = title;
    _resultData['title'] = l$title;
    final l$category = category;
    _resultData['category'] = l$category.toJson();
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$title = title;
    final l$category = category;
    return Object.hashAll([l$id, l$title, l$category]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$SpotSearchSuggestions$spotSearchSuggestions ||
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
    final l$category = category;
    final lOther$category = other.category;
    if (l$category != lOther$category) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Query$SpotSearchSuggestions$spotSearchSuggestions
    on Query$SpotSearchSuggestions$spotSearchSuggestions {
  CopyWith$Query$SpotSearchSuggestions$spotSearchSuggestions<
    Query$SpotSearchSuggestions$spotSearchSuggestions
  >
  get copyWith => CopyWith$Query$SpotSearchSuggestions$spotSearchSuggestions(
    this,
    (i) => i,
  );
}

abstract class CopyWith$Query$SpotSearchSuggestions$spotSearchSuggestions<
  TRes
> {
  factory CopyWith$Query$SpotSearchSuggestions$spotSearchSuggestions(
    Query$SpotSearchSuggestions$spotSearchSuggestions instance,
    TRes Function(Query$SpotSearchSuggestions$spotSearchSuggestions) then,
  ) = _CopyWithImpl$Query$SpotSearchSuggestions$spotSearchSuggestions;

  factory CopyWith$Query$SpotSearchSuggestions$spotSearchSuggestions.stub(
    TRes res,
  ) = _CopyWithStubImpl$Query$SpotSearchSuggestions$spotSearchSuggestions;

  TRes call({
    String? id,
    String? title,
    Query$SpotSearchSuggestions$spotSearchSuggestions$category? category,
  });
  CopyWith$Query$SpotSearchSuggestions$spotSearchSuggestions$category<TRes>
  get category;
}

class _CopyWithImpl$Query$SpotSearchSuggestions$spotSearchSuggestions<TRes>
    implements
        CopyWith$Query$SpotSearchSuggestions$spotSearchSuggestions<TRes> {
  _CopyWithImpl$Query$SpotSearchSuggestions$spotSearchSuggestions(
    this._instance,
    this._then,
  );

  final Query$SpotSearchSuggestions$spotSearchSuggestions _instance;

  final TRes Function(Query$SpotSearchSuggestions$spotSearchSuggestions) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? title = _undefined,
    Object? category = _undefined,
  }) => _then(
    Query$SpotSearchSuggestions$spotSearchSuggestions(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      title: title == _undefined || title == null
          ? _instance.title
          : (title as String),
      category: category == _undefined || category == null
          ? _instance.category
          : (category
                as Query$SpotSearchSuggestions$spotSearchSuggestions$category),
    ),
  );

  CopyWith$Query$SpotSearchSuggestions$spotSearchSuggestions$category<TRes>
  get category {
    final local$category = _instance.category;
    return CopyWith$Query$SpotSearchSuggestions$spotSearchSuggestions$category(
      local$category,
      (e) => call(category: e),
    );
  }
}

class _CopyWithStubImpl$Query$SpotSearchSuggestions$spotSearchSuggestions<TRes>
    implements
        CopyWith$Query$SpotSearchSuggestions$spotSearchSuggestions<TRes> {
  _CopyWithStubImpl$Query$SpotSearchSuggestions$spotSearchSuggestions(
    this._res,
  );

  TRes _res;

  call({
    String? id,
    String? title,
    Query$SpotSearchSuggestions$spotSearchSuggestions$category? category,
  }) => _res;

  CopyWith$Query$SpotSearchSuggestions$spotSearchSuggestions$category<TRes>
  get category =>
      CopyWith$Query$SpotSearchSuggestions$spotSearchSuggestions$category.stub(
        _res,
      );
}

class Query$SpotSearchSuggestions$spotSearchSuggestions$category {
  Query$SpotSearchSuggestions$spotSearchSuggestions$category({
    required this.code,
    required this.label,
    this.iconUrl,
  });

  factory Query$SpotSearchSuggestions$spotSearchSuggestions$category.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$code = json['code'];
    final l$label = json['label'];
    final l$iconUrl = json['iconUrl'];
    return Query$SpotSearchSuggestions$spotSearchSuggestions$category(
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
    if (other is! Query$SpotSearchSuggestions$spotSearchSuggestions$category ||
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

extension UtilityExtension$Query$SpotSearchSuggestions$spotSearchSuggestions$category
    on Query$SpotSearchSuggestions$spotSearchSuggestions$category {
  CopyWith$Query$SpotSearchSuggestions$spotSearchSuggestions$category<
    Query$SpotSearchSuggestions$spotSearchSuggestions$category
  >
  get copyWith =>
      CopyWith$Query$SpotSearchSuggestions$spotSearchSuggestions$category(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Query$SpotSearchSuggestions$spotSearchSuggestions$category<
  TRes
> {
  factory CopyWith$Query$SpotSearchSuggestions$spotSearchSuggestions$category(
    Query$SpotSearchSuggestions$spotSearchSuggestions$category instance,
    TRes Function(Query$SpotSearchSuggestions$spotSearchSuggestions$category)
    then,
  ) = _CopyWithImpl$Query$SpotSearchSuggestions$spotSearchSuggestions$category;

  factory CopyWith$Query$SpotSearchSuggestions$spotSearchSuggestions$category.stub(
    TRes res,
  ) = _CopyWithStubImpl$Query$SpotSearchSuggestions$spotSearchSuggestions$category;

  TRes call({String? code, String? label, String? iconUrl});
}

class _CopyWithImpl$Query$SpotSearchSuggestions$spotSearchSuggestions$category<
  TRes
>
    implements
        CopyWith$Query$SpotSearchSuggestions$spotSearchSuggestions$category<
          TRes
        > {
  _CopyWithImpl$Query$SpotSearchSuggestions$spotSearchSuggestions$category(
    this._instance,
    this._then,
  );

  final Query$SpotSearchSuggestions$spotSearchSuggestions$category _instance;

  final TRes Function(
    Query$SpotSearchSuggestions$spotSearchSuggestions$category,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? code = _undefined,
    Object? label = _undefined,
    Object? iconUrl = _undefined,
  }) => _then(
    Query$SpotSearchSuggestions$spotSearchSuggestions$category(
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

class _CopyWithStubImpl$Query$SpotSearchSuggestions$spotSearchSuggestions$category<
  TRes
>
    implements
        CopyWith$Query$SpotSearchSuggestions$spotSearchSuggestions$category<
          TRes
        > {
  _CopyWithStubImpl$Query$SpotSearchSuggestions$spotSearchSuggestions$category(
    this._res,
  );

  TRes _res;

  call({String? code, String? label, String? iconUrl}) => _res;
}

class Variables$Query$PopularSpots {
  factory Variables$Query$PopularSpots({
    required double latitude,
    required double longitude,
    int? radiusMeters,
    List<String>? categories,
    bool? hasOrigin,
    int? first,
    String? after,
  }) => Variables$Query$PopularSpots._({
    r'latitude': latitude,
    r'longitude': longitude,
    if (radiusMeters != null) r'radiusMeters': radiusMeters,
    if (categories != null) r'categories': categories,
    if (hasOrigin != null) r'hasOrigin': hasOrigin,
    if (first != null) r'first': first,
    if (after != null) r'after': after,
  });

  Variables$Query$PopularSpots._(this._$data);

  factory Variables$Query$PopularSpots.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$latitude = data['latitude'];
    result$data['latitude'] = (l$latitude as num).toDouble();
    final l$longitude = data['longitude'];
    result$data['longitude'] = (l$longitude as num).toDouble();
    if (data.containsKey('radiusMeters')) {
      final l$radiusMeters = data['radiusMeters'];
      result$data['radiusMeters'] = (l$radiusMeters as int?);
    }
    if (data.containsKey('categories')) {
      final l$categories = data['categories'];
      result$data['categories'] = (l$categories as List<dynamic>?)
          ?.map((e) => (e as String))
          .toList();
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
    return Variables$Query$PopularSpots._(result$data);
  }

  Map<String, dynamic> _$data;

  double get latitude => (_$data['latitude'] as double);

  double get longitude => (_$data['longitude'] as double);

  int? get radiusMeters => (_$data['radiusMeters'] as int?);

  List<String>? get categories => (_$data['categories'] as List<String>?);

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
    if (_$data.containsKey('categories')) {
      final l$categories = categories;
      result$data['categories'] = l$categories?.map((e) => e).toList();
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

  CopyWith$Variables$Query$PopularSpots<Variables$Query$PopularSpots>
  get copyWith => CopyWith$Variables$Query$PopularSpots(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Query$PopularSpots ||
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
    final l$categories = categories;
    final l$hasOrigin = hasOrigin;
    final l$first = first;
    final l$after = after;
    return Object.hashAll([
      l$latitude,
      l$longitude,
      _$data.containsKey('radiusMeters') ? l$radiusMeters : const {},
      _$data.containsKey('categories')
          ? l$categories == null
                ? null
                : Object.hashAll(l$categories.map((v) => v))
          : const {},
      _$data.containsKey('hasOrigin') ? l$hasOrigin : const {},
      _$data.containsKey('first') ? l$first : const {},
      _$data.containsKey('after') ? l$after : const {},
    ]);
  }
}

abstract class CopyWith$Variables$Query$PopularSpots<TRes> {
  factory CopyWith$Variables$Query$PopularSpots(
    Variables$Query$PopularSpots instance,
    TRes Function(Variables$Query$PopularSpots) then,
  ) = _CopyWithImpl$Variables$Query$PopularSpots;

  factory CopyWith$Variables$Query$PopularSpots.stub(TRes res) =
      _CopyWithStubImpl$Variables$Query$PopularSpots;

  TRes call({
    double? latitude,
    double? longitude,
    int? radiusMeters,
    List<String>? categories,
    bool? hasOrigin,
    int? first,
    String? after,
  });
}

class _CopyWithImpl$Variables$Query$PopularSpots<TRes>
    implements CopyWith$Variables$Query$PopularSpots<TRes> {
  _CopyWithImpl$Variables$Query$PopularSpots(this._instance, this._then);

  final Variables$Query$PopularSpots _instance;

  final TRes Function(Variables$Query$PopularSpots) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? latitude = _undefined,
    Object? longitude = _undefined,
    Object? radiusMeters = _undefined,
    Object? categories = _undefined,
    Object? hasOrigin = _undefined,
    Object? first = _undefined,
    Object? after = _undefined,
  }) => _then(
    Variables$Query$PopularSpots._({
      ..._instance._$data,
      if (latitude != _undefined && latitude != null)
        'latitude': (latitude as double),
      if (longitude != _undefined && longitude != null)
        'longitude': (longitude as double),
      if (radiusMeters != _undefined) 'radiusMeters': (radiusMeters as int?),
      if (categories != _undefined) 'categories': (categories as List<String>?),
      if (hasOrigin != _undefined) 'hasOrigin': (hasOrigin as bool?),
      if (first != _undefined) 'first': (first as int?),
      if (after != _undefined) 'after': (after as String?),
    }),
  );
}

class _CopyWithStubImpl$Variables$Query$PopularSpots<TRes>
    implements CopyWith$Variables$Query$PopularSpots<TRes> {
  _CopyWithStubImpl$Variables$Query$PopularSpots(this._res);

  TRes _res;

  call({
    double? latitude,
    double? longitude,
    int? radiusMeters,
    List<String>? categories,
    bool? hasOrigin,
    int? first,
    String? after,
  }) => _res;
}

class Query$PopularSpots {
  Query$PopularSpots({required this.popularSpots});

  factory Query$PopularSpots.fromJson(Map<String, dynamic> json) {
    final l$popularSpots = json['popularSpots'];
    return Query$PopularSpots(
      popularSpots: Query$PopularSpots$popularSpots.fromJson(
        (l$popularSpots as Map<String, dynamic>),
      ),
    );
  }

  final Query$PopularSpots$popularSpots popularSpots;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$popularSpots = popularSpots;
    _resultData['popularSpots'] = l$popularSpots.toJson();
    return _resultData;
  }

  @override
  int get hashCode {
    final l$popularSpots = popularSpots;
    return Object.hashAll([l$popularSpots]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$PopularSpots || runtimeType != other.runtimeType) {
      return false;
    }
    final l$popularSpots = popularSpots;
    final lOther$popularSpots = other.popularSpots;
    if (l$popularSpots != lOther$popularSpots) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Query$PopularSpots on Query$PopularSpots {
  CopyWith$Query$PopularSpots<Query$PopularSpots> get copyWith =>
      CopyWith$Query$PopularSpots(this, (i) => i);
}

abstract class CopyWith$Query$PopularSpots<TRes> {
  factory CopyWith$Query$PopularSpots(
    Query$PopularSpots instance,
    TRes Function(Query$PopularSpots) then,
  ) = _CopyWithImpl$Query$PopularSpots;

  factory CopyWith$Query$PopularSpots.stub(TRes res) =
      _CopyWithStubImpl$Query$PopularSpots;

  TRes call({Query$PopularSpots$popularSpots? popularSpots});
  CopyWith$Query$PopularSpots$popularSpots<TRes> get popularSpots;
}

class _CopyWithImpl$Query$PopularSpots<TRes>
    implements CopyWith$Query$PopularSpots<TRes> {
  _CopyWithImpl$Query$PopularSpots(this._instance, this._then);

  final Query$PopularSpots _instance;

  final TRes Function(Query$PopularSpots) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? popularSpots = _undefined}) => _then(
    Query$PopularSpots(
      popularSpots: popularSpots == _undefined || popularSpots == null
          ? _instance.popularSpots
          : (popularSpots as Query$PopularSpots$popularSpots),
    ),
  );

  CopyWith$Query$PopularSpots$popularSpots<TRes> get popularSpots {
    final local$popularSpots = _instance.popularSpots;
    return CopyWith$Query$PopularSpots$popularSpots(
      local$popularSpots,
      (e) => call(popularSpots: e),
    );
  }
}

class _CopyWithStubImpl$Query$PopularSpots<TRes>
    implements CopyWith$Query$PopularSpots<TRes> {
  _CopyWithStubImpl$Query$PopularSpots(this._res);

  TRes _res;

  call({Query$PopularSpots$popularSpots? popularSpots}) => _res;

  CopyWith$Query$PopularSpots$popularSpots<TRes> get popularSpots =>
      CopyWith$Query$PopularSpots$popularSpots.stub(_res);
}

const documentNodeQueryPopularSpots = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'PopularSpots'),
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
            name: NameNode(value: 'popularSpots'),
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
                name: NameNode(value: 'categories'),
                value: VariableNode(name: NameNode(value: 'categories')),
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
                              name: NameNode(value: 'copyright'),
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
                      FieldNode(
                        name: NameNode(value: 'likeCount'),
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

class Query$PopularSpots$popularSpots {
  Query$PopularSpots$popularSpots({
    required this.edges,
    required this.pageInfo,
  });

  factory Query$PopularSpots$popularSpots.fromJson(Map<String, dynamic> json) {
    final l$edges = json['edges'];
    final l$pageInfo = json['pageInfo'];
    return Query$PopularSpots$popularSpots(
      edges: (l$edges as List<dynamic>)
          .map(
            (e) => Query$PopularSpots$popularSpots$edges.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      pageInfo: Query$PopularSpots$popularSpots$pageInfo.fromJson(
        (l$pageInfo as Map<String, dynamic>),
      ),
    );
  }

  final List<Query$PopularSpots$popularSpots$edges> edges;

  final Query$PopularSpots$popularSpots$pageInfo pageInfo;

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
    if (other is! Query$PopularSpots$popularSpots ||
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

extension UtilityExtension$Query$PopularSpots$popularSpots
    on Query$PopularSpots$popularSpots {
  CopyWith$Query$PopularSpots$popularSpots<Query$PopularSpots$popularSpots>
  get copyWith => CopyWith$Query$PopularSpots$popularSpots(this, (i) => i);
}

abstract class CopyWith$Query$PopularSpots$popularSpots<TRes> {
  factory CopyWith$Query$PopularSpots$popularSpots(
    Query$PopularSpots$popularSpots instance,
    TRes Function(Query$PopularSpots$popularSpots) then,
  ) = _CopyWithImpl$Query$PopularSpots$popularSpots;

  factory CopyWith$Query$PopularSpots$popularSpots.stub(TRes res) =
      _CopyWithStubImpl$Query$PopularSpots$popularSpots;

  TRes call({
    List<Query$PopularSpots$popularSpots$edges>? edges,
    Query$PopularSpots$popularSpots$pageInfo? pageInfo,
  });
  TRes edges(
    Iterable<Query$PopularSpots$popularSpots$edges> Function(
      Iterable<
        CopyWith$Query$PopularSpots$popularSpots$edges<
          Query$PopularSpots$popularSpots$edges
        >
      >,
    )
    _fn,
  );
  CopyWith$Query$PopularSpots$popularSpots$pageInfo<TRes> get pageInfo;
}

class _CopyWithImpl$Query$PopularSpots$popularSpots<TRes>
    implements CopyWith$Query$PopularSpots$popularSpots<TRes> {
  _CopyWithImpl$Query$PopularSpots$popularSpots(this._instance, this._then);

  final Query$PopularSpots$popularSpots _instance;

  final TRes Function(Query$PopularSpots$popularSpots) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? edges = _undefined, Object? pageInfo = _undefined}) =>
      _then(
        Query$PopularSpots$popularSpots(
          edges: edges == _undefined || edges == null
              ? _instance.edges
              : (edges as List<Query$PopularSpots$popularSpots$edges>),
          pageInfo: pageInfo == _undefined || pageInfo == null
              ? _instance.pageInfo
              : (pageInfo as Query$PopularSpots$popularSpots$pageInfo),
        ),
      );

  TRes edges(
    Iterable<Query$PopularSpots$popularSpots$edges> Function(
      Iterable<
        CopyWith$Query$PopularSpots$popularSpots$edges<
          Query$PopularSpots$popularSpots$edges
        >
      >,
    )
    _fn,
  ) => call(
    edges: _fn(
      _instance.edges.map(
        (e) => CopyWith$Query$PopularSpots$popularSpots$edges(e, (i) => i),
      ),
    ).toList(),
  );

  CopyWith$Query$PopularSpots$popularSpots$pageInfo<TRes> get pageInfo {
    final local$pageInfo = _instance.pageInfo;
    return CopyWith$Query$PopularSpots$popularSpots$pageInfo(
      local$pageInfo,
      (e) => call(pageInfo: e),
    );
  }
}

class _CopyWithStubImpl$Query$PopularSpots$popularSpots<TRes>
    implements CopyWith$Query$PopularSpots$popularSpots<TRes> {
  _CopyWithStubImpl$Query$PopularSpots$popularSpots(this._res);

  TRes _res;

  call({
    List<Query$PopularSpots$popularSpots$edges>? edges,
    Query$PopularSpots$popularSpots$pageInfo? pageInfo,
  }) => _res;

  edges(_fn) => _res;

  CopyWith$Query$PopularSpots$popularSpots$pageInfo<TRes> get pageInfo =>
      CopyWith$Query$PopularSpots$popularSpots$pageInfo.stub(_res);
}

class Query$PopularSpots$popularSpots$edges {
  Query$PopularSpots$popularSpots$edges({
    required this.node,
    required this.cursor,
    required this.likeCount,
  });

  factory Query$PopularSpots$popularSpots$edges.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$node = json['node'];
    final l$cursor = json['cursor'];
    final l$likeCount = json['likeCount'];
    return Query$PopularSpots$popularSpots$edges(
      node: Query$PopularSpots$popularSpots$edges$node.fromJson(
        (l$node as Map<String, dynamic>),
      ),
      cursor: (l$cursor as String),
      likeCount: (l$likeCount as int),
    );
  }

  final Query$PopularSpots$popularSpots$edges$node node;

  final String cursor;

  final int likeCount;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$node = node;
    _resultData['node'] = l$node.toJson();
    final l$cursor = cursor;
    _resultData['cursor'] = l$cursor;
    final l$likeCount = likeCount;
    _resultData['likeCount'] = l$likeCount;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$node = node;
    final l$cursor = cursor;
    final l$likeCount = likeCount;
    return Object.hashAll([l$node, l$cursor, l$likeCount]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$PopularSpots$popularSpots$edges ||
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
    final l$likeCount = likeCount;
    final lOther$likeCount = other.likeCount;
    if (l$likeCount != lOther$likeCount) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Query$PopularSpots$popularSpots$edges
    on Query$PopularSpots$popularSpots$edges {
  CopyWith$Query$PopularSpots$popularSpots$edges<
    Query$PopularSpots$popularSpots$edges
  >
  get copyWith =>
      CopyWith$Query$PopularSpots$popularSpots$edges(this, (i) => i);
}

abstract class CopyWith$Query$PopularSpots$popularSpots$edges<TRes> {
  factory CopyWith$Query$PopularSpots$popularSpots$edges(
    Query$PopularSpots$popularSpots$edges instance,
    TRes Function(Query$PopularSpots$popularSpots$edges) then,
  ) = _CopyWithImpl$Query$PopularSpots$popularSpots$edges;

  factory CopyWith$Query$PopularSpots$popularSpots$edges.stub(TRes res) =
      _CopyWithStubImpl$Query$PopularSpots$popularSpots$edges;

  TRes call({
    Query$PopularSpots$popularSpots$edges$node? node,
    String? cursor,
    int? likeCount,
  });
  CopyWith$Query$PopularSpots$popularSpots$edges$node<TRes> get node;
}

class _CopyWithImpl$Query$PopularSpots$popularSpots$edges<TRes>
    implements CopyWith$Query$PopularSpots$popularSpots$edges<TRes> {
  _CopyWithImpl$Query$PopularSpots$popularSpots$edges(
    this._instance,
    this._then,
  );

  final Query$PopularSpots$popularSpots$edges _instance;

  final TRes Function(Query$PopularSpots$popularSpots$edges) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? node = _undefined,
    Object? cursor = _undefined,
    Object? likeCount = _undefined,
  }) => _then(
    Query$PopularSpots$popularSpots$edges(
      node: node == _undefined || node == null
          ? _instance.node
          : (node as Query$PopularSpots$popularSpots$edges$node),
      cursor: cursor == _undefined || cursor == null
          ? _instance.cursor
          : (cursor as String),
      likeCount: likeCount == _undefined || likeCount == null
          ? _instance.likeCount
          : (likeCount as int),
    ),
  );

  CopyWith$Query$PopularSpots$popularSpots$edges$node<TRes> get node {
    final local$node = _instance.node;
    return CopyWith$Query$PopularSpots$popularSpots$edges$node(
      local$node,
      (e) => call(node: e),
    );
  }
}

class _CopyWithStubImpl$Query$PopularSpots$popularSpots$edges<TRes>
    implements CopyWith$Query$PopularSpots$popularSpots$edges<TRes> {
  _CopyWithStubImpl$Query$PopularSpots$popularSpots$edges(this._res);

  TRes _res;

  call({
    Query$PopularSpots$popularSpots$edges$node? node,
    String? cursor,
    int? likeCount,
  }) => _res;

  CopyWith$Query$PopularSpots$popularSpots$edges$node<TRes> get node =>
      CopyWith$Query$PopularSpots$popularSpots$edges$node.stub(_res);
}

class Query$PopularSpots$popularSpots$edges$node {
  Query$PopularSpots$popularSpots$edges$node({
    required this.id,
    required this.title,
    this.address,
    required this.thumbnailImageUrl,
    required this.distanceMeters,
    required this.category,
    required this.copyright,
    required this.attributionText,
  });

  factory Query$PopularSpots$popularSpots$edges$node.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$title = json['title'];
    final l$address = json['address'];
    final l$thumbnailImageUrl = json['thumbnailImageUrl'];
    final l$distanceMeters = json['distanceMeters'];
    final l$category = json['category'];
    final l$copyright = json['copyright'];
    final l$attributionText = json['attributionText'];
    return Query$PopularSpots$popularSpots$edges$node(
      id: (l$id as String),
      title: (l$title as String),
      address: (l$address as String?),
      thumbnailImageUrl: (l$thumbnailImageUrl as String),
      distanceMeters: (l$distanceMeters as num).toDouble(),
      category: Query$PopularSpots$popularSpots$edges$node$category.fromJson(
        (l$category as Map<String, dynamic>),
      ),
      copyright: fromJson$Enum$CopyrightType((l$copyright as String)),
      attributionText: (l$attributionText as String),
    );
  }

  final String id;

  final String title;

  final String? address;

  final String thumbnailImageUrl;

  final double distanceMeters;

  final Query$PopularSpots$popularSpots$edges$node$category category;

  final Enum$CopyrightType copyright;

  final String attributionText;

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
    final l$category = category;
    _resultData['category'] = l$category.toJson();
    final l$copyright = copyright;
    _resultData['copyright'] = toJson$Enum$CopyrightType(l$copyright);
    final l$attributionText = attributionText;
    _resultData['attributionText'] = l$attributionText;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$title = title;
    final l$address = address;
    final l$thumbnailImageUrl = thumbnailImageUrl;
    final l$distanceMeters = distanceMeters;
    final l$category = category;
    final l$copyright = copyright;
    final l$attributionText = attributionText;
    return Object.hashAll([
      l$id,
      l$title,
      l$address,
      l$thumbnailImageUrl,
      l$distanceMeters,
      l$category,
      l$copyright,
      l$attributionText,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$PopularSpots$popularSpots$edges$node ||
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
    final l$category = category;
    final lOther$category = other.category;
    if (l$category != lOther$category) {
      return false;
    }
    final l$copyright = copyright;
    final lOther$copyright = other.copyright;
    if (l$copyright != lOther$copyright) {
      return false;
    }
    final l$attributionText = attributionText;
    final lOther$attributionText = other.attributionText;
    if (l$attributionText != lOther$attributionText) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Query$PopularSpots$popularSpots$edges$node
    on Query$PopularSpots$popularSpots$edges$node {
  CopyWith$Query$PopularSpots$popularSpots$edges$node<
    Query$PopularSpots$popularSpots$edges$node
  >
  get copyWith =>
      CopyWith$Query$PopularSpots$popularSpots$edges$node(this, (i) => i);
}

abstract class CopyWith$Query$PopularSpots$popularSpots$edges$node<TRes> {
  factory CopyWith$Query$PopularSpots$popularSpots$edges$node(
    Query$PopularSpots$popularSpots$edges$node instance,
    TRes Function(Query$PopularSpots$popularSpots$edges$node) then,
  ) = _CopyWithImpl$Query$PopularSpots$popularSpots$edges$node;

  factory CopyWith$Query$PopularSpots$popularSpots$edges$node.stub(TRes res) =
      _CopyWithStubImpl$Query$PopularSpots$popularSpots$edges$node;

  TRes call({
    String? id,
    String? title,
    String? address,
    String? thumbnailImageUrl,
    double? distanceMeters,
    Query$PopularSpots$popularSpots$edges$node$category? category,
    Enum$CopyrightType? copyright,
    String? attributionText,
  });
  CopyWith$Query$PopularSpots$popularSpots$edges$node$category<TRes>
  get category;
}

class _CopyWithImpl$Query$PopularSpots$popularSpots$edges$node<TRes>
    implements CopyWith$Query$PopularSpots$popularSpots$edges$node<TRes> {
  _CopyWithImpl$Query$PopularSpots$popularSpots$edges$node(
    this._instance,
    this._then,
  );

  final Query$PopularSpots$popularSpots$edges$node _instance;

  final TRes Function(Query$PopularSpots$popularSpots$edges$node) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? title = _undefined,
    Object? address = _undefined,
    Object? thumbnailImageUrl = _undefined,
    Object? distanceMeters = _undefined,
    Object? category = _undefined,
    Object? copyright = _undefined,
    Object? attributionText = _undefined,
  }) => _then(
    Query$PopularSpots$popularSpots$edges$node(
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
      category: category == _undefined || category == null
          ? _instance.category
          : (category as Query$PopularSpots$popularSpots$edges$node$category),
      copyright: copyright == _undefined || copyright == null
          ? _instance.copyright
          : (copyright as Enum$CopyrightType),
      attributionText: attributionText == _undefined || attributionText == null
          ? _instance.attributionText
          : (attributionText as String),
    ),
  );

  CopyWith$Query$PopularSpots$popularSpots$edges$node$category<TRes>
  get category {
    final local$category = _instance.category;
    return CopyWith$Query$PopularSpots$popularSpots$edges$node$category(
      local$category,
      (e) => call(category: e),
    );
  }
}

class _CopyWithStubImpl$Query$PopularSpots$popularSpots$edges$node<TRes>
    implements CopyWith$Query$PopularSpots$popularSpots$edges$node<TRes> {
  _CopyWithStubImpl$Query$PopularSpots$popularSpots$edges$node(this._res);

  TRes _res;

  call({
    String? id,
    String? title,
    String? address,
    String? thumbnailImageUrl,
    double? distanceMeters,
    Query$PopularSpots$popularSpots$edges$node$category? category,
    Enum$CopyrightType? copyright,
    String? attributionText,
  }) => _res;

  CopyWith$Query$PopularSpots$popularSpots$edges$node$category<TRes>
  get category =>
      CopyWith$Query$PopularSpots$popularSpots$edges$node$category.stub(_res);
}

class Query$PopularSpots$popularSpots$edges$node$category {
  Query$PopularSpots$popularSpots$edges$node$category({
    required this.code,
    required this.label,
    this.iconUrl,
  });

  factory Query$PopularSpots$popularSpots$edges$node$category.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$code = json['code'];
    final l$label = json['label'];
    final l$iconUrl = json['iconUrl'];
    return Query$PopularSpots$popularSpots$edges$node$category(
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
    if (other is! Query$PopularSpots$popularSpots$edges$node$category ||
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

extension UtilityExtension$Query$PopularSpots$popularSpots$edges$node$category
    on Query$PopularSpots$popularSpots$edges$node$category {
  CopyWith$Query$PopularSpots$popularSpots$edges$node$category<
    Query$PopularSpots$popularSpots$edges$node$category
  >
  get copyWith => CopyWith$Query$PopularSpots$popularSpots$edges$node$category(
    this,
    (i) => i,
  );
}

abstract class CopyWith$Query$PopularSpots$popularSpots$edges$node$category<
  TRes
> {
  factory CopyWith$Query$PopularSpots$popularSpots$edges$node$category(
    Query$PopularSpots$popularSpots$edges$node$category instance,
    TRes Function(Query$PopularSpots$popularSpots$edges$node$category) then,
  ) = _CopyWithImpl$Query$PopularSpots$popularSpots$edges$node$category;

  factory CopyWith$Query$PopularSpots$popularSpots$edges$node$category.stub(
    TRes res,
  ) = _CopyWithStubImpl$Query$PopularSpots$popularSpots$edges$node$category;

  TRes call({String? code, String? label, String? iconUrl});
}

class _CopyWithImpl$Query$PopularSpots$popularSpots$edges$node$category<TRes>
    implements
        CopyWith$Query$PopularSpots$popularSpots$edges$node$category<TRes> {
  _CopyWithImpl$Query$PopularSpots$popularSpots$edges$node$category(
    this._instance,
    this._then,
  );

  final Query$PopularSpots$popularSpots$edges$node$category _instance;

  final TRes Function(Query$PopularSpots$popularSpots$edges$node$category)
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? code = _undefined,
    Object? label = _undefined,
    Object? iconUrl = _undefined,
  }) => _then(
    Query$PopularSpots$popularSpots$edges$node$category(
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

class _CopyWithStubImpl$Query$PopularSpots$popularSpots$edges$node$category<
  TRes
>
    implements
        CopyWith$Query$PopularSpots$popularSpots$edges$node$category<TRes> {
  _CopyWithStubImpl$Query$PopularSpots$popularSpots$edges$node$category(
    this._res,
  );

  TRes _res;

  call({String? code, String? label, String? iconUrl}) => _res;
}

class Query$PopularSpots$popularSpots$pageInfo {
  Query$PopularSpots$popularSpots$pageInfo({
    required this.hasNextPage,
    this.endCursor,
  });

  factory Query$PopularSpots$popularSpots$pageInfo.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$hasNextPage = json['hasNextPage'];
    final l$endCursor = json['endCursor'];
    return Query$PopularSpots$popularSpots$pageInfo(
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
    if (other is! Query$PopularSpots$popularSpots$pageInfo ||
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

extension UtilityExtension$Query$PopularSpots$popularSpots$pageInfo
    on Query$PopularSpots$popularSpots$pageInfo {
  CopyWith$Query$PopularSpots$popularSpots$pageInfo<
    Query$PopularSpots$popularSpots$pageInfo
  >
  get copyWith =>
      CopyWith$Query$PopularSpots$popularSpots$pageInfo(this, (i) => i);
}

abstract class CopyWith$Query$PopularSpots$popularSpots$pageInfo<TRes> {
  factory CopyWith$Query$PopularSpots$popularSpots$pageInfo(
    Query$PopularSpots$popularSpots$pageInfo instance,
    TRes Function(Query$PopularSpots$popularSpots$pageInfo) then,
  ) = _CopyWithImpl$Query$PopularSpots$popularSpots$pageInfo;

  factory CopyWith$Query$PopularSpots$popularSpots$pageInfo.stub(TRes res) =
      _CopyWithStubImpl$Query$PopularSpots$popularSpots$pageInfo;

  TRes call({bool? hasNextPage, String? endCursor});
}

class _CopyWithImpl$Query$PopularSpots$popularSpots$pageInfo<TRes>
    implements CopyWith$Query$PopularSpots$popularSpots$pageInfo<TRes> {
  _CopyWithImpl$Query$PopularSpots$popularSpots$pageInfo(
    this._instance,
    this._then,
  );

  final Query$PopularSpots$popularSpots$pageInfo _instance;

  final TRes Function(Query$PopularSpots$popularSpots$pageInfo) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? hasNextPage = _undefined,
    Object? endCursor = _undefined,
  }) => _then(
    Query$PopularSpots$popularSpots$pageInfo(
      hasNextPage: hasNextPage == _undefined || hasNextPage == null
          ? _instance.hasNextPage
          : (hasNextPage as bool),
      endCursor: endCursor == _undefined
          ? _instance.endCursor
          : (endCursor as String?),
    ),
  );
}

class _CopyWithStubImpl$Query$PopularSpots$popularSpots$pageInfo<TRes>
    implements CopyWith$Query$PopularSpots$popularSpots$pageInfo<TRes> {
  _CopyWithStubImpl$Query$PopularSpots$popularSpots$pageInfo(this._res);

  TRes _res;

  call({bool? hasNextPage, String? endCursor}) => _res;
}
