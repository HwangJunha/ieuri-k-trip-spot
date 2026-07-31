// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, unused_element
import 'package:gql/ast.dart';
import 'spot_schema.graphql.dart';

class Variables$Query$Spots {
  factory Variables$Query$Spots({
    required double latitude,
    required double longitude,
    int? radiusMeters,
    Enum$SpotCategory? category,
    int? page,
    int? size,
  }) => Variables$Query$Spots._({
    r'latitude': latitude,
    r'longitude': longitude,
    if (radiusMeters != null) r'radiusMeters': radiusMeters,
    if (category != null) r'category': category,
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
    if (data.containsKey('category')) {
      final l$category = data['category'];
      result$data['category'] = l$category == null
          ? null
          : fromJson$Enum$SpotCategory((l$category as String));
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

  Enum$SpotCategory? get category => (_$data['category'] as Enum$SpotCategory?);

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
    if (_$data.containsKey('category')) {
      final l$category = category;
      result$data['category'] = l$category == null
          ? null
          : toJson$Enum$SpotCategory(l$category);
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
    final l$category = category;
    final lOther$category = other.category;
    if (_$data.containsKey('category') !=
        other._$data.containsKey('category')) {
      return false;
    }
    if (l$category != lOther$category) {
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
    final l$category = category;
    final l$page = page;
    final l$size = size;
    return Object.hashAll([
      l$latitude,
      l$longitude,
      _$data.containsKey('radiusMeters') ? l$radiusMeters : const {},
      _$data.containsKey('category') ? l$category : const {},
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
    Enum$SpotCategory? category,
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
    Object? category = _undefined,
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
      if (category != _undefined) 'category': (category as Enum$SpotCategory?),
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
    Enum$SpotCategory? category,
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
          variable: VariableNode(name: NameNode(value: 'category')),
          type: NamedTypeNode(
            name: NameNode(value: 'SpotCategory'),
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
                name: NameNode(value: 'category'),
                value: VariableNode(name: NameNode(value: 'category')),
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
      category: fromJson$Enum$SpotCategory((l$category as String)),
      copyright: fromJson$Enum$CopyrightType((l$copyright as String)),
      attributionText: (l$attributionText as String),
    );
  }

  final String id;

  final String title;

  final String? address;

  final String thumbnailImageUrl;

  final double distanceMeters;

  final Enum$SpotCategory category;

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
    _resultData['category'] = toJson$Enum$SpotCategory(l$category);
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
    Enum$SpotCategory? category,
    Enum$CopyrightType? copyright,
    String? attributionText,
  });
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
          : (category as Enum$SpotCategory),
      copyright: copyright == _undefined || copyright == null
          ? _instance.copyright
          : (copyright as Enum$CopyrightType),
      attributionText: attributionText == _undefined || attributionText == null
          ? _instance.attributionText
          : (attributionText as String),
    ),
  );
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
    Enum$SpotCategory? category,
    Enum$CopyrightType? copyright,
    String? attributionText,
  }) => _res;
}

class Query$AvailableSpotCategories {
  Query$AvailableSpotCategories({required this.availableSpotCategories});

  factory Query$AvailableSpotCategories.fromJson(Map<String, dynamic> json) {
    final l$availableSpotCategories = json['availableSpotCategories'];
    return Query$AvailableSpotCategories(
      availableSpotCategories: (l$availableSpotCategories as List<dynamic>)
          .map((e) => fromJson$Enum$SpotCategory((e as String)))
          .toList(),
    );
  }

  final List<Enum$SpotCategory> availableSpotCategories;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$availableSpotCategories = availableSpotCategories;
    _resultData['availableSpotCategories'] = l$availableSpotCategories
        .map((e) => toJson$Enum$SpotCategory(e))
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

  TRes call({List<Enum$SpotCategory>? availableSpotCategories});
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
          : (availableSpotCategories as List<Enum$SpotCategory>),
    ),
  );
}

class _CopyWithStubImpl$Query$AvailableSpotCategories<TRes>
    implements CopyWith$Query$AvailableSpotCategories<TRes> {
  _CopyWithStubImpl$Query$AvailableSpotCategories(this._res);

  TRes _res;

  call({List<Enum$SpotCategory>? availableSpotCategories}) => _res;
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
            selectionSet: null,
          ),
        ],
      ),
    ),
  ],
);

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
