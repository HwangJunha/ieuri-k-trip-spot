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

class Variables$Query$SpotDetail {
  factory Variables$Query$SpotDetail({
    required String id,
    required Enum$SpotCategory category,
  }) => Variables$Query$SpotDetail._({r'id': id, r'category': category});

  Variables$Query$SpotDetail._(this._$data);

  factory Variables$Query$SpotDetail.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$id = data['id'];
    result$data['id'] = (l$id as String);
    final l$category = data['category'];
    result$data['category'] = fromJson$Enum$SpotCategory(
      (l$category as String),
    );
    return Variables$Query$SpotDetail._(result$data);
  }

  Map<String, dynamic> _$data;

  String get id => (_$data['id'] as String);

  Enum$SpotCategory get category => (_$data['category'] as Enum$SpotCategory);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$id = id;
    result$data['id'] = l$id;
    final l$category = category;
    result$data['category'] = toJson$Enum$SpotCategory(l$category);
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
    final l$category = category;
    final lOther$category = other.category;
    if (l$category != lOther$category) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$category = category;
    return Object.hashAll([l$id, l$category]);
  }
}

abstract class CopyWith$Variables$Query$SpotDetail<TRes> {
  factory CopyWith$Variables$Query$SpotDetail(
    Variables$Query$SpotDetail instance,
    TRes Function(Variables$Query$SpotDetail) then,
  ) = _CopyWithImpl$Variables$Query$SpotDetail;

  factory CopyWith$Variables$Query$SpotDetail.stub(TRes res) =
      _CopyWithStubImpl$Variables$Query$SpotDetail;

  TRes call({String? id, Enum$SpotCategory? category});
}

class _CopyWithImpl$Variables$Query$SpotDetail<TRes>
    implements CopyWith$Variables$Query$SpotDetail<TRes> {
  _CopyWithImpl$Variables$Query$SpotDetail(this._instance, this._then);

  final Variables$Query$SpotDetail _instance;

  final TRes Function(Variables$Query$SpotDetail) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? id = _undefined, Object? category = _undefined}) => _then(
    Variables$Query$SpotDetail._({
      ..._instance._$data,
      if (id != _undefined && id != null) 'id': (id as String),
      if (category != _undefined && category != null)
        'category': (category as Enum$SpotCategory),
    }),
  );
}

class _CopyWithStubImpl$Variables$Query$SpotDetail<TRes>
    implements CopyWith$Variables$Query$SpotDetail<TRes> {
  _CopyWithStubImpl$Variables$Query$SpotDetail(this._res);

  TRes _res;

  call({String? id, Enum$SpotCategory? category}) => _res;
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
          variable: VariableNode(name: NameNode(value: 'category')),
          type: NamedTypeNode(
            name: NameNode(value: 'SpotCategory'),
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
                      name: NameNode(value: 'category'),
                      value: VariableNode(name: NameNode(value: 'category')),
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
                      name: NameNode(value: 'category'),
                      value: VariableNode(name: NameNode(value: 'category')),
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
      category: fromJson$Enum$SpotCategory((l$category as String)),
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

  final Enum$SpotCategory category;

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
    _resultData['category'] = toJson$Enum$SpotCategory(l$category);
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
    Enum$SpotCategory? category,
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
          : (category as Enum$SpotCategory),
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
    Enum$SpotCategory? category,
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

  gallery(_fn) => _res;

  CopyWith$Query$SpotDetail$spotDetail$intro<TRes> get intro =>
      CopyWith$Query$SpotDetail$spotDetail$intro.stub(_res);

  infoItems(_fn) => _res;
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
  factory Variables$Query$LikedSpots({int? first, String? after}) =>
      Variables$Query$LikedSpots._({
        if (first != null) r'first': first,
        if (after != null) r'after': after,
      });

  Variables$Query$LikedSpots._(this._$data);

  factory Variables$Query$LikedSpots.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
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

  int? get first => (_$data['first'] as int?);

  String? get after => (_$data['after'] as String?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
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
    final l$first = first;
    final l$after = after;
    return Object.hashAll([
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

  TRes call({int? first, String? after});
}

class _CopyWithImpl$Variables$Query$LikedSpots<TRes>
    implements CopyWith$Variables$Query$LikedSpots<TRes> {
  _CopyWithImpl$Variables$Query$LikedSpots(this._instance, this._then);

  final Variables$Query$LikedSpots _instance;

  final TRes Function(Variables$Query$LikedSpots) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? first = _undefined, Object? after = _undefined}) => _then(
    Variables$Query$LikedSpots._({
      ..._instance._$data,
      if (first != _undefined) 'first': (first as int?),
      if (after != _undefined) 'after': (after as String?),
    }),
  );
}

class _CopyWithStubImpl$Variables$Query$LikedSpots<TRes>
    implements CopyWith$Variables$Query$LikedSpots<TRes> {
  _CopyWithStubImpl$Variables$Query$LikedSpots(this._res);

  TRes _res;

  call({int? first, String? after}) => _res;
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

class Query$LikedSpots$likedSpots {
  Query$LikedSpots$likedSpots({
    required this.edges,
    required this.pageInfo,
    this.totalCount,
  });

  factory Query$LikedSpots$likedSpots.fromJson(Map<String, dynamic> json) {
    final l$edges = json['edges'];
    final l$pageInfo = json['pageInfo'];
    final l$totalCount = json['totalCount'];
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
      totalCount: (l$totalCount as int?),
    );
  }

  final List<Query$LikedSpots$likedSpots$edges> edges;

  final Query$LikedSpots$likedSpots$pageInfo pageInfo;

  final int? totalCount;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$edges = edges;
    _resultData['edges'] = l$edges.map((e) => e.toJson()).toList();
    final l$pageInfo = pageInfo;
    _resultData['pageInfo'] = l$pageInfo.toJson();
    final l$totalCount = totalCount;
    _resultData['totalCount'] = l$totalCount;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$edges = edges;
    final l$pageInfo = pageInfo;
    final l$totalCount = totalCount;
    return Object.hashAll([
      Object.hashAll(l$edges.map((v) => v)),
      l$pageInfo,
      l$totalCount,
    ]);
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
    final l$totalCount = totalCount;
    final lOther$totalCount = other.totalCount;
    if (l$totalCount != lOther$totalCount) {
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
    int? totalCount,
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

  TRes call({
    Object? edges = _undefined,
    Object? pageInfo = _undefined,
    Object? totalCount = _undefined,
  }) => _then(
    Query$LikedSpots$likedSpots(
      edges: edges == _undefined || edges == null
          ? _instance.edges
          : (edges as List<Query$LikedSpots$likedSpots$edges>),
      pageInfo: pageInfo == _undefined || pageInfo == null
          ? _instance.pageInfo
          : (pageInfo as Query$LikedSpots$likedSpots$pageInfo),
      totalCount: totalCount == _undefined
          ? _instance.totalCount
          : (totalCount as int?),
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
    int? totalCount,
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
      category: fromJson$Enum$SpotCategory((l$category as String)),
      copyright: fromJson$Enum$CopyrightType((l$copyright as String)),
      attributionText: (l$attributionText as String),
    );
  }

  final String id;

  final String title;

  final String thumbnailImageUrl;

  final String? address;

  final Enum$SpotCategory category;

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
    Enum$SpotCategory? category,
    Enum$CopyrightType? copyright,
    String? attributionText,
  });
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

class _CopyWithStubImpl$Query$LikedSpots$likedSpots$edges$node<TRes>
    implements CopyWith$Query$LikedSpots$likedSpots$edges$node<TRes> {
  _CopyWithStubImpl$Query$LikedSpots$likedSpots$edges$node(this._res);

  TRes _res;

  call({
    String? id,
    String? title,
    String? thumbnailImageUrl,
    String? address,
    Enum$SpotCategory? category,
    Enum$CopyrightType? copyright,
    String? attributionText,
  }) => _res;
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
