// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, unused_element
import '../../spot/repository/spot_schema.graphql.dart';
import 'national_map_schema.graphql.dart';
import 'package:gql/ast.dart';

class Fragment$MapRelationCore {
  Fragment$MapRelationCore({
    required this.memberId,
    required this.nickname,
    required this.overlappingCount,
    required this.overlappingCellIds,
    required this.theirVisitedCount,
  });

  factory Fragment$MapRelationCore.fromJson(Map<String, dynamic> json) {
    final l$memberId = json['memberId'];
    final l$nickname = json['nickname'];
    final l$overlappingCount = json['overlappingCount'];
    final l$overlappingCellIds = json['overlappingCellIds'];
    final l$theirVisitedCount = json['theirVisitedCount'];
    return Fragment$MapRelationCore(
      memberId: (l$memberId as String),
      nickname: (l$nickname as String),
      overlappingCount: (l$overlappingCount as int),
      overlappingCellIds: (l$overlappingCellIds as List<dynamic>)
          .map((e) => (e as String))
          .toList(),
      theirVisitedCount: (l$theirVisitedCount as int),
    );
  }

  final String memberId;

  final String nickname;

  final int overlappingCount;

  final List<String> overlappingCellIds;

  final int theirVisitedCount;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$memberId = memberId;
    _resultData['memberId'] = l$memberId;
    final l$nickname = nickname;
    _resultData['nickname'] = l$nickname;
    final l$overlappingCount = overlappingCount;
    _resultData['overlappingCount'] = l$overlappingCount;
    final l$overlappingCellIds = overlappingCellIds;
    _resultData['overlappingCellIds'] = l$overlappingCellIds
        .map((e) => e)
        .toList();
    final l$theirVisitedCount = theirVisitedCount;
    _resultData['theirVisitedCount'] = l$theirVisitedCount;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$memberId = memberId;
    final l$nickname = nickname;
    final l$overlappingCount = overlappingCount;
    final l$overlappingCellIds = overlappingCellIds;
    final l$theirVisitedCount = theirVisitedCount;
    return Object.hashAll([
      l$memberId,
      l$nickname,
      l$overlappingCount,
      Object.hashAll(l$overlappingCellIds.map((v) => v)),
      l$theirVisitedCount,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment$MapRelationCore ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$memberId = memberId;
    final lOther$memberId = other.memberId;
    if (l$memberId != lOther$memberId) {
      return false;
    }
    final l$nickname = nickname;
    final lOther$nickname = other.nickname;
    if (l$nickname != lOther$nickname) {
      return false;
    }
    final l$overlappingCount = overlappingCount;
    final lOther$overlappingCount = other.overlappingCount;
    if (l$overlappingCount != lOther$overlappingCount) {
      return false;
    }
    final l$overlappingCellIds = overlappingCellIds;
    final lOther$overlappingCellIds = other.overlappingCellIds;
    if (l$overlappingCellIds.length != lOther$overlappingCellIds.length) {
      return false;
    }
    for (int i = 0; i < l$overlappingCellIds.length; i++) {
      final l$overlappingCellIds$entry = l$overlappingCellIds[i];
      final lOther$overlappingCellIds$entry = lOther$overlappingCellIds[i];
      if (l$overlappingCellIds$entry != lOther$overlappingCellIds$entry) {
        return false;
      }
    }
    final l$theirVisitedCount = theirVisitedCount;
    final lOther$theirVisitedCount = other.theirVisitedCount;
    if (l$theirVisitedCount != lOther$theirVisitedCount) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Fragment$MapRelationCore
    on Fragment$MapRelationCore {
  CopyWith$Fragment$MapRelationCore<Fragment$MapRelationCore> get copyWith =>
      CopyWith$Fragment$MapRelationCore(this, (i) => i);
}

abstract class CopyWith$Fragment$MapRelationCore<TRes> {
  factory CopyWith$Fragment$MapRelationCore(
    Fragment$MapRelationCore instance,
    TRes Function(Fragment$MapRelationCore) then,
  ) = _CopyWithImpl$Fragment$MapRelationCore;

  factory CopyWith$Fragment$MapRelationCore.stub(TRes res) =
      _CopyWithStubImpl$Fragment$MapRelationCore;

  TRes call({
    String? memberId,
    String? nickname,
    int? overlappingCount,
    List<String>? overlappingCellIds,
    int? theirVisitedCount,
  });
}

class _CopyWithImpl$Fragment$MapRelationCore<TRes>
    implements CopyWith$Fragment$MapRelationCore<TRes> {
  _CopyWithImpl$Fragment$MapRelationCore(this._instance, this._then);

  final Fragment$MapRelationCore _instance;

  final TRes Function(Fragment$MapRelationCore) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? memberId = _undefined,
    Object? nickname = _undefined,
    Object? overlappingCount = _undefined,
    Object? overlappingCellIds = _undefined,
    Object? theirVisitedCount = _undefined,
  }) => _then(
    Fragment$MapRelationCore(
      memberId: memberId == _undefined || memberId == null
          ? _instance.memberId
          : (memberId as String),
      nickname: nickname == _undefined || nickname == null
          ? _instance.nickname
          : (nickname as String),
      overlappingCount:
          overlappingCount == _undefined || overlappingCount == null
          ? _instance.overlappingCount
          : (overlappingCount as int),
      overlappingCellIds:
          overlappingCellIds == _undefined || overlappingCellIds == null
          ? _instance.overlappingCellIds
          : (overlappingCellIds as List<String>),
      theirVisitedCount:
          theirVisitedCount == _undefined || theirVisitedCount == null
          ? _instance.theirVisitedCount
          : (theirVisitedCount as int),
    ),
  );
}

class _CopyWithStubImpl$Fragment$MapRelationCore<TRes>
    implements CopyWith$Fragment$MapRelationCore<TRes> {
  _CopyWithStubImpl$Fragment$MapRelationCore(this._res);

  TRes _res;

  call({
    String? memberId,
    String? nickname,
    int? overlappingCount,
    List<String>? overlappingCellIds,
    int? theirVisitedCount,
  }) => _res;
}

const fragmentDefinitionMapRelationCore = FragmentDefinitionNode(
  name: NameNode(value: 'MapRelationCore'),
  typeCondition: TypeConditionNode(
    on: NamedTypeNode(name: NameNode(value: 'MapRelation'), isNonNull: false),
  ),
  directives: [],
  selectionSet: SelectionSetNode(
    selections: [
      FieldNode(
        name: NameNode(value: 'memberId'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'nickname'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'overlappingCount'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'overlappingCellIds'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'theirVisitedCount'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
    ],
  ),
);
const documentNodeFragmentMapRelationCore = DocumentNode(
  definitions: [fragmentDefinitionMapRelationCore],
);

class Fragment$MapCellCore {
  Fragment$MapCellCore({
    required this.id,
    required this.districtCodes,
    required this.name,
    required this.provinceName,
    required this.provinceCode,
    required this.viewerVisited,
    required this.center,
  });

  factory Fragment$MapCellCore.fromJson(Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$districtCodes = json['districtCodes'];
    final l$name = json['name'];
    final l$provinceName = json['provinceName'];
    final l$provinceCode = json['provinceCode'];
    final l$viewerVisited = json['viewerVisited'];
    final l$center = json['center'];
    return Fragment$MapCellCore(
      id: (l$id as String),
      districtCodes: (l$districtCodes as List<dynamic>)
          .map((e) => (e as String))
          .toList(),
      name: (l$name as String),
      provinceName: (l$provinceName as String),
      provinceCode: (l$provinceCode as String),
      viewerVisited: (l$viewerVisited as bool),
      center: Fragment$MapCellCore$center.fromJson(
        (l$center as Map<String, dynamic>),
      ),
    );
  }

  final String id;

  final List<String> districtCodes;

  final String name;

  final String provinceName;

  final String provinceCode;

  final bool viewerVisited;

  final Fragment$MapCellCore$center center;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$districtCodes = districtCodes;
    _resultData['districtCodes'] = l$districtCodes.map((e) => e).toList();
    final l$name = name;
    _resultData['name'] = l$name;
    final l$provinceName = provinceName;
    _resultData['provinceName'] = l$provinceName;
    final l$provinceCode = provinceCode;
    _resultData['provinceCode'] = l$provinceCode;
    final l$viewerVisited = viewerVisited;
    _resultData['viewerVisited'] = l$viewerVisited;
    final l$center = center;
    _resultData['center'] = l$center.toJson();
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$districtCodes = districtCodes;
    final l$name = name;
    final l$provinceName = provinceName;
    final l$provinceCode = provinceCode;
    final l$viewerVisited = viewerVisited;
    final l$center = center;
    return Object.hashAll([
      l$id,
      Object.hashAll(l$districtCodes.map((v) => v)),
      l$name,
      l$provinceName,
      l$provinceCode,
      l$viewerVisited,
      l$center,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment$MapCellCore || runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$districtCodes = districtCodes;
    final lOther$districtCodes = other.districtCodes;
    if (l$districtCodes.length != lOther$districtCodes.length) {
      return false;
    }
    for (int i = 0; i < l$districtCodes.length; i++) {
      final l$districtCodes$entry = l$districtCodes[i];
      final lOther$districtCodes$entry = lOther$districtCodes[i];
      if (l$districtCodes$entry != lOther$districtCodes$entry) {
        return false;
      }
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
    final l$provinceCode = provinceCode;
    final lOther$provinceCode = other.provinceCode;
    if (l$provinceCode != lOther$provinceCode) {
      return false;
    }
    final l$viewerVisited = viewerVisited;
    final lOther$viewerVisited = other.viewerVisited;
    if (l$viewerVisited != lOther$viewerVisited) {
      return false;
    }
    final l$center = center;
    final lOther$center = other.center;
    if (l$center != lOther$center) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Fragment$MapCellCore on Fragment$MapCellCore {
  CopyWith$Fragment$MapCellCore<Fragment$MapCellCore> get copyWith =>
      CopyWith$Fragment$MapCellCore(this, (i) => i);
}

abstract class CopyWith$Fragment$MapCellCore<TRes> {
  factory CopyWith$Fragment$MapCellCore(
    Fragment$MapCellCore instance,
    TRes Function(Fragment$MapCellCore) then,
  ) = _CopyWithImpl$Fragment$MapCellCore;

  factory CopyWith$Fragment$MapCellCore.stub(TRes res) =
      _CopyWithStubImpl$Fragment$MapCellCore;

  TRes call({
    String? id,
    List<String>? districtCodes,
    String? name,
    String? provinceName,
    String? provinceCode,
    bool? viewerVisited,
    Fragment$MapCellCore$center? center,
  });
  CopyWith$Fragment$MapCellCore$center<TRes> get center;
}

class _CopyWithImpl$Fragment$MapCellCore<TRes>
    implements CopyWith$Fragment$MapCellCore<TRes> {
  _CopyWithImpl$Fragment$MapCellCore(this._instance, this._then);

  final Fragment$MapCellCore _instance;

  final TRes Function(Fragment$MapCellCore) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? districtCodes = _undefined,
    Object? name = _undefined,
    Object? provinceName = _undefined,
    Object? provinceCode = _undefined,
    Object? viewerVisited = _undefined,
    Object? center = _undefined,
  }) => _then(
    Fragment$MapCellCore(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      districtCodes: districtCodes == _undefined || districtCodes == null
          ? _instance.districtCodes
          : (districtCodes as List<String>),
      name: name == _undefined || name == null
          ? _instance.name
          : (name as String),
      provinceName: provinceName == _undefined || provinceName == null
          ? _instance.provinceName
          : (provinceName as String),
      provinceCode: provinceCode == _undefined || provinceCode == null
          ? _instance.provinceCode
          : (provinceCode as String),
      viewerVisited: viewerVisited == _undefined || viewerVisited == null
          ? _instance.viewerVisited
          : (viewerVisited as bool),
      center: center == _undefined || center == null
          ? _instance.center
          : (center as Fragment$MapCellCore$center),
    ),
  );

  CopyWith$Fragment$MapCellCore$center<TRes> get center {
    final local$center = _instance.center;
    return CopyWith$Fragment$MapCellCore$center(
      local$center,
      (e) => call(center: e),
    );
  }
}

class _CopyWithStubImpl$Fragment$MapCellCore<TRes>
    implements CopyWith$Fragment$MapCellCore<TRes> {
  _CopyWithStubImpl$Fragment$MapCellCore(this._res);

  TRes _res;

  call({
    String? id,
    List<String>? districtCodes,
    String? name,
    String? provinceName,
    String? provinceCode,
    bool? viewerVisited,
    Fragment$MapCellCore$center? center,
  }) => _res;

  CopyWith$Fragment$MapCellCore$center<TRes> get center =>
      CopyWith$Fragment$MapCellCore$center.stub(_res);
}

const fragmentDefinitionMapCellCore = FragmentDefinitionNode(
  name: NameNode(value: 'MapCellCore'),
  typeCondition: TypeConditionNode(
    on: NamedTypeNode(name: NameNode(value: 'MapCell'), isNonNull: false),
  ),
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
        name: NameNode(value: 'districtCodes'),
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
        name: NameNode(value: 'provinceCode'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'viewerVisited'),
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
    ],
  ),
);
const documentNodeFragmentMapCellCore = DocumentNode(
  definitions: [fragmentDefinitionMapCellCore],
);

class Fragment$MapCellCore$center {
  Fragment$MapCellCore$center({required this.lat, required this.lng});

  factory Fragment$MapCellCore$center.fromJson(Map<String, dynamic> json) {
    final l$lat = json['lat'];
    final l$lng = json['lng'];
    return Fragment$MapCellCore$center(
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
    if (other is! Fragment$MapCellCore$center ||
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

extension UtilityExtension$Fragment$MapCellCore$center
    on Fragment$MapCellCore$center {
  CopyWith$Fragment$MapCellCore$center<Fragment$MapCellCore$center>
  get copyWith => CopyWith$Fragment$MapCellCore$center(this, (i) => i);
}

abstract class CopyWith$Fragment$MapCellCore$center<TRes> {
  factory CopyWith$Fragment$MapCellCore$center(
    Fragment$MapCellCore$center instance,
    TRes Function(Fragment$MapCellCore$center) then,
  ) = _CopyWithImpl$Fragment$MapCellCore$center;

  factory CopyWith$Fragment$MapCellCore$center.stub(TRes res) =
      _CopyWithStubImpl$Fragment$MapCellCore$center;

  TRes call({double? lat, double? lng});
}

class _CopyWithImpl$Fragment$MapCellCore$center<TRes>
    implements CopyWith$Fragment$MapCellCore$center<TRes> {
  _CopyWithImpl$Fragment$MapCellCore$center(this._instance, this._then);

  final Fragment$MapCellCore$center _instance;

  final TRes Function(Fragment$MapCellCore$center) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? lat = _undefined, Object? lng = _undefined}) => _then(
    Fragment$MapCellCore$center(
      lat: lat == _undefined || lat == null ? _instance.lat : (lat as double),
      lng: lng == _undefined || lng == null ? _instance.lng : (lng as double),
    ),
  );
}

class _CopyWithStubImpl$Fragment$MapCellCore$center<TRes>
    implements CopyWith$Fragment$MapCellCore$center<TRes> {
  _CopyWithStubImpl$Fragment$MapCellCore$center(this._res);

  TRes _res;

  call({double? lat, double? lng}) => _res;
}

class Fragment$CellImageFields {
  Fragment$CellImageFields({
    required this.imageUrl,
    this.thumbnailUrl,
    required this.caption,
    required this.kind,
    required this.copyright,
    required this.attributionText,
  });

  factory Fragment$CellImageFields.fromJson(Map<String, dynamic> json) {
    final l$imageUrl = json['imageUrl'];
    final l$thumbnailUrl = json['thumbnailUrl'];
    final l$caption = json['caption'];
    final l$kind = json['kind'];
    final l$copyright = json['copyright'];
    final l$attributionText = json['attributionText'];
    return Fragment$CellImageFields(
      imageUrl: (l$imageUrl as String),
      thumbnailUrl: (l$thumbnailUrl as String?),
      caption: (l$caption as String),
      kind: fromJson$Enum$CellImageKind((l$kind as String)),
      copyright: fromJson$Enum$CopyrightType((l$copyright as String)),
      attributionText: (l$attributionText as String),
    );
  }

  final String imageUrl;

  final String? thumbnailUrl;

  final String caption;

  final Enum$CellImageKind kind;

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
    final l$kind = kind;
    _resultData['kind'] = toJson$Enum$CellImageKind(l$kind);
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
    final l$kind = kind;
    final l$copyright = copyright;
    final l$attributionText = attributionText;
    return Object.hashAll([
      l$imageUrl,
      l$thumbnailUrl,
      l$caption,
      l$kind,
      l$copyright,
      l$attributionText,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment$CellImageFields ||
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
    final l$kind = kind;
    final lOther$kind = other.kind;
    if (l$kind != lOther$kind) {
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

extension UtilityExtension$Fragment$CellImageFields
    on Fragment$CellImageFields {
  CopyWith$Fragment$CellImageFields<Fragment$CellImageFields> get copyWith =>
      CopyWith$Fragment$CellImageFields(this, (i) => i);
}

abstract class CopyWith$Fragment$CellImageFields<TRes> {
  factory CopyWith$Fragment$CellImageFields(
    Fragment$CellImageFields instance,
    TRes Function(Fragment$CellImageFields) then,
  ) = _CopyWithImpl$Fragment$CellImageFields;

  factory CopyWith$Fragment$CellImageFields.stub(TRes res) =
      _CopyWithStubImpl$Fragment$CellImageFields;

  TRes call({
    String? imageUrl,
    String? thumbnailUrl,
    String? caption,
    Enum$CellImageKind? kind,
    Enum$CopyrightType? copyright,
    String? attributionText,
  });
}

class _CopyWithImpl$Fragment$CellImageFields<TRes>
    implements CopyWith$Fragment$CellImageFields<TRes> {
  _CopyWithImpl$Fragment$CellImageFields(this._instance, this._then);

  final Fragment$CellImageFields _instance;

  final TRes Function(Fragment$CellImageFields) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? imageUrl = _undefined,
    Object? thumbnailUrl = _undefined,
    Object? caption = _undefined,
    Object? kind = _undefined,
    Object? copyright = _undefined,
    Object? attributionText = _undefined,
  }) => _then(
    Fragment$CellImageFields(
      imageUrl: imageUrl == _undefined || imageUrl == null
          ? _instance.imageUrl
          : (imageUrl as String),
      thumbnailUrl: thumbnailUrl == _undefined
          ? _instance.thumbnailUrl
          : (thumbnailUrl as String?),
      caption: caption == _undefined || caption == null
          ? _instance.caption
          : (caption as String),
      kind: kind == _undefined || kind == null
          ? _instance.kind
          : (kind as Enum$CellImageKind),
      copyright: copyright == _undefined || copyright == null
          ? _instance.copyright
          : (copyright as Enum$CopyrightType),
      attributionText: attributionText == _undefined || attributionText == null
          ? _instance.attributionText
          : (attributionText as String),
    ),
  );
}

class _CopyWithStubImpl$Fragment$CellImageFields<TRes>
    implements CopyWith$Fragment$CellImageFields<TRes> {
  _CopyWithStubImpl$Fragment$CellImageFields(this._res);

  TRes _res;

  call({
    String? imageUrl,
    String? thumbnailUrl,
    String? caption,
    Enum$CellImageKind? kind,
    Enum$CopyrightType? copyright,
    String? attributionText,
  }) => _res;
}

const fragmentDefinitionCellImageFields = FragmentDefinitionNode(
  name: NameNode(value: 'CellImageFields'),
  typeCondition: TypeConditionNode(
    on: NamedTypeNode(name: NameNode(value: 'CellImage'), isNonNull: false),
  ),
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
        name: NameNode(value: 'kind'),
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
);
const documentNodeFragmentCellImageFields = DocumentNode(
  definitions: [fragmentDefinitionCellImageFields],
);

class Query$MapCells {
  Query$MapCells({required this.mapCells});

  factory Query$MapCells.fromJson(Map<String, dynamic> json) {
    final l$mapCells = json['mapCells'];
    return Query$MapCells(
      mapCells: (l$mapCells as List<dynamic>)
          .map(
            (e) => Fragment$MapCellCore.fromJson((e as Map<String, dynamic>)),
          )
          .toList(),
    );
  }

  final List<Fragment$MapCellCore> mapCells;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$mapCells = mapCells;
    _resultData['mapCells'] = l$mapCells.map((e) => e.toJson()).toList();
    return _resultData;
  }

  @override
  int get hashCode {
    final l$mapCells = mapCells;
    return Object.hashAll([Object.hashAll(l$mapCells.map((v) => v))]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$MapCells || runtimeType != other.runtimeType) {
      return false;
    }
    final l$mapCells = mapCells;
    final lOther$mapCells = other.mapCells;
    if (l$mapCells.length != lOther$mapCells.length) {
      return false;
    }
    for (int i = 0; i < l$mapCells.length; i++) {
      final l$mapCells$entry = l$mapCells[i];
      final lOther$mapCells$entry = lOther$mapCells[i];
      if (l$mapCells$entry != lOther$mapCells$entry) {
        return false;
      }
    }
    return true;
  }
}

extension UtilityExtension$Query$MapCells on Query$MapCells {
  CopyWith$Query$MapCells<Query$MapCells> get copyWith =>
      CopyWith$Query$MapCells(this, (i) => i);
}

abstract class CopyWith$Query$MapCells<TRes> {
  factory CopyWith$Query$MapCells(
    Query$MapCells instance,
    TRes Function(Query$MapCells) then,
  ) = _CopyWithImpl$Query$MapCells;

  factory CopyWith$Query$MapCells.stub(TRes res) =
      _CopyWithStubImpl$Query$MapCells;

  TRes call({List<Fragment$MapCellCore>? mapCells});
  TRes mapCells(
    Iterable<Fragment$MapCellCore> Function(
      Iterable<CopyWith$Fragment$MapCellCore<Fragment$MapCellCore>>,
    )
    _fn,
  );
}

class _CopyWithImpl$Query$MapCells<TRes>
    implements CopyWith$Query$MapCells<TRes> {
  _CopyWithImpl$Query$MapCells(this._instance, this._then);

  final Query$MapCells _instance;

  final TRes Function(Query$MapCells) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? mapCells = _undefined}) => _then(
    Query$MapCells(
      mapCells: mapCells == _undefined || mapCells == null
          ? _instance.mapCells
          : (mapCells as List<Fragment$MapCellCore>),
    ),
  );

  TRes mapCells(
    Iterable<Fragment$MapCellCore> Function(
      Iterable<CopyWith$Fragment$MapCellCore<Fragment$MapCellCore>>,
    )
    _fn,
  ) => call(
    mapCells: _fn(
      _instance.mapCells.map((e) => CopyWith$Fragment$MapCellCore(e, (i) => i)),
    ).toList(),
  );
}

class _CopyWithStubImpl$Query$MapCells<TRes>
    implements CopyWith$Query$MapCells<TRes> {
  _CopyWithStubImpl$Query$MapCells(this._res);

  TRes _res;

  call({List<Fragment$MapCellCore>? mapCells}) => _res;

  mapCells(_fn) => _res;
}

const documentNodeQueryMapCells = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'MapCells'),
      variableDefinitions: [],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'mapCells'),
            alias: null,
            arguments: [],
            directives: [],
            selectionSet: SelectionSetNode(
              selections: [
                FragmentSpreadNode(
                  name: NameNode(value: 'MapCellCore'),
                  directives: [],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
    fragmentDefinitionMapCellCore,
  ],
);

class Variables$Query$MapCellDetail {
  factory Variables$Query$MapCellDetail({
    required String id,
    int? first,
    String? after,
  }) => Variables$Query$MapCellDetail._({
    r'id': id,
    if (first != null) r'first': first,
    if (after != null) r'after': after,
  });

  Variables$Query$MapCellDetail._(this._$data);

  factory Variables$Query$MapCellDetail.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$id = data['id'];
    result$data['id'] = (l$id as String);
    if (data.containsKey('first')) {
      final l$first = data['first'];
      result$data['first'] = (l$first as int?);
    }
    if (data.containsKey('after')) {
      final l$after = data['after'];
      result$data['after'] = (l$after as String?);
    }
    return Variables$Query$MapCellDetail._(result$data);
  }

  Map<String, dynamic> _$data;

  String get id => (_$data['id'] as String);

  int? get first => (_$data['first'] as int?);

  String? get after => (_$data['after'] as String?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$id = id;
    result$data['id'] = l$id;
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

  CopyWith$Variables$Query$MapCellDetail<Variables$Query$MapCellDetail>
  get copyWith => CopyWith$Variables$Query$MapCellDetail(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Query$MapCellDetail ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
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
    final l$id = id;
    final l$first = first;
    final l$after = after;
    return Object.hashAll([
      l$id,
      _$data.containsKey('first') ? l$first : const {},
      _$data.containsKey('after') ? l$after : const {},
    ]);
  }
}

abstract class CopyWith$Variables$Query$MapCellDetail<TRes> {
  factory CopyWith$Variables$Query$MapCellDetail(
    Variables$Query$MapCellDetail instance,
    TRes Function(Variables$Query$MapCellDetail) then,
  ) = _CopyWithImpl$Variables$Query$MapCellDetail;

  factory CopyWith$Variables$Query$MapCellDetail.stub(TRes res) =
      _CopyWithStubImpl$Variables$Query$MapCellDetail;

  TRes call({String? id, int? first, String? after});
}

class _CopyWithImpl$Variables$Query$MapCellDetail<TRes>
    implements CopyWith$Variables$Query$MapCellDetail<TRes> {
  _CopyWithImpl$Variables$Query$MapCellDetail(this._instance, this._then);

  final Variables$Query$MapCellDetail _instance;

  final TRes Function(Variables$Query$MapCellDetail) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? first = _undefined,
    Object? after = _undefined,
  }) => _then(
    Variables$Query$MapCellDetail._({
      ..._instance._$data,
      if (id != _undefined && id != null) 'id': (id as String),
      if (first != _undefined) 'first': (first as int?),
      if (after != _undefined) 'after': (after as String?),
    }),
  );
}

class _CopyWithStubImpl$Variables$Query$MapCellDetail<TRes>
    implements CopyWith$Variables$Query$MapCellDetail<TRes> {
  _CopyWithStubImpl$Variables$Query$MapCellDetail(this._res);

  TRes _res;

  call({String? id, int? first, String? after}) => _res;
}

class Query$MapCellDetail {
  Query$MapCellDetail({required this.mapCell});

  factory Query$MapCellDetail.fromJson(Map<String, dynamic> json) {
    final l$mapCell = json['mapCell'];
    return Query$MapCellDetail(
      mapCell: Query$MapCellDetail$mapCell.fromJson(
        (l$mapCell as Map<String, dynamic>),
      ),
    );
  }

  final Query$MapCellDetail$mapCell mapCell;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$mapCell = mapCell;
    _resultData['mapCell'] = l$mapCell.toJson();
    return _resultData;
  }

  @override
  int get hashCode {
    final l$mapCell = mapCell;
    return Object.hashAll([l$mapCell]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$MapCellDetail || runtimeType != other.runtimeType) {
      return false;
    }
    final l$mapCell = mapCell;
    final lOther$mapCell = other.mapCell;
    if (l$mapCell != lOther$mapCell) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Query$MapCellDetail on Query$MapCellDetail {
  CopyWith$Query$MapCellDetail<Query$MapCellDetail> get copyWith =>
      CopyWith$Query$MapCellDetail(this, (i) => i);
}

abstract class CopyWith$Query$MapCellDetail<TRes> {
  factory CopyWith$Query$MapCellDetail(
    Query$MapCellDetail instance,
    TRes Function(Query$MapCellDetail) then,
  ) = _CopyWithImpl$Query$MapCellDetail;

  factory CopyWith$Query$MapCellDetail.stub(TRes res) =
      _CopyWithStubImpl$Query$MapCellDetail;

  TRes call({Query$MapCellDetail$mapCell? mapCell});
  CopyWith$Query$MapCellDetail$mapCell<TRes> get mapCell;
}

class _CopyWithImpl$Query$MapCellDetail<TRes>
    implements CopyWith$Query$MapCellDetail<TRes> {
  _CopyWithImpl$Query$MapCellDetail(this._instance, this._then);

  final Query$MapCellDetail _instance;

  final TRes Function(Query$MapCellDetail) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? mapCell = _undefined}) => _then(
    Query$MapCellDetail(
      mapCell: mapCell == _undefined || mapCell == null
          ? _instance.mapCell
          : (mapCell as Query$MapCellDetail$mapCell),
    ),
  );

  CopyWith$Query$MapCellDetail$mapCell<TRes> get mapCell {
    final local$mapCell = _instance.mapCell;
    return CopyWith$Query$MapCellDetail$mapCell(
      local$mapCell,
      (e) => call(mapCell: e),
    );
  }
}

class _CopyWithStubImpl$Query$MapCellDetail<TRes>
    implements CopyWith$Query$MapCellDetail<TRes> {
  _CopyWithStubImpl$Query$MapCellDetail(this._res);

  TRes _res;

  call({Query$MapCellDetail$mapCell? mapCell}) => _res;

  CopyWith$Query$MapCellDetail$mapCell<TRes> get mapCell =>
      CopyWith$Query$MapCellDetail$mapCell.stub(_res);
}

const documentNodeQueryMapCellDetail = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'MapCellDetail'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'id')),
          type: NamedTypeNode(name: NameNode(value: 'ID'), isNonNull: true),
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
            name: NameNode(value: 'mapCell'),
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
                FragmentSpreadNode(
                  name: NameNode(value: 'MapCellCore'),
                  directives: [],
                ),
                FieldNode(
                  name: NameNode(value: 'representativeImage'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: SelectionSetNode(
                    selections: [
                      FragmentSpreadNode(
                        name: NameNode(value: 'CellImageFields'),
                        directives: [],
                      ),
                    ],
                  ),
                ),
                FieldNode(
                  name: NameNode(value: 'spots'),
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
                              name: NameNode(value: 'likeCount'),
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
                                      ],
                                    ),
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
      ),
    ),
    fragmentDefinitionMapCellCore,
    fragmentDefinitionCellImageFields,
  ],
);

class Query$MapCellDetail$mapCell implements Fragment$MapCellCore {
  Query$MapCellDetail$mapCell({
    required this.id,
    required this.districtCodes,
    required this.name,
    required this.provinceName,
    required this.provinceCode,
    required this.viewerVisited,
    required this.center,
    this.representativeImage,
    required this.spots,
  });

  factory Query$MapCellDetail$mapCell.fromJson(Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$districtCodes = json['districtCodes'];
    final l$name = json['name'];
    final l$provinceName = json['provinceName'];
    final l$provinceCode = json['provinceCode'];
    final l$viewerVisited = json['viewerVisited'];
    final l$center = json['center'];
    final l$representativeImage = json['representativeImage'];
    final l$spots = json['spots'];
    return Query$MapCellDetail$mapCell(
      id: (l$id as String),
      districtCodes: (l$districtCodes as List<dynamic>)
          .map((e) => (e as String))
          .toList(),
      name: (l$name as String),
      provinceName: (l$provinceName as String),
      provinceCode: (l$provinceCode as String),
      viewerVisited: (l$viewerVisited as bool),
      center: Query$MapCellDetail$mapCell$center.fromJson(
        (l$center as Map<String, dynamic>),
      ),
      representativeImage: l$representativeImage == null
          ? null
          : Fragment$CellImageFields.fromJson(
              (l$representativeImage as Map<String, dynamic>),
            ),
      spots: Query$MapCellDetail$mapCell$spots.fromJson(
        (l$spots as Map<String, dynamic>),
      ),
    );
  }

  final String id;

  final List<String> districtCodes;

  final String name;

  final String provinceName;

  final String provinceCode;

  final bool viewerVisited;

  final Query$MapCellDetail$mapCell$center center;

  final Fragment$CellImageFields? representativeImage;

  final Query$MapCellDetail$mapCell$spots spots;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$districtCodes = districtCodes;
    _resultData['districtCodes'] = l$districtCodes.map((e) => e).toList();
    final l$name = name;
    _resultData['name'] = l$name;
    final l$provinceName = provinceName;
    _resultData['provinceName'] = l$provinceName;
    final l$provinceCode = provinceCode;
    _resultData['provinceCode'] = l$provinceCode;
    final l$viewerVisited = viewerVisited;
    _resultData['viewerVisited'] = l$viewerVisited;
    final l$center = center;
    _resultData['center'] = l$center.toJson();
    final l$representativeImage = representativeImage;
    _resultData['representativeImage'] = l$representativeImage?.toJson();
    final l$spots = spots;
    _resultData['spots'] = l$spots.toJson();
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$districtCodes = districtCodes;
    final l$name = name;
    final l$provinceName = provinceName;
    final l$provinceCode = provinceCode;
    final l$viewerVisited = viewerVisited;
    final l$center = center;
    final l$representativeImage = representativeImage;
    final l$spots = spots;
    return Object.hashAll([
      l$id,
      Object.hashAll(l$districtCodes.map((v) => v)),
      l$name,
      l$provinceName,
      l$provinceCode,
      l$viewerVisited,
      l$center,
      l$representativeImage,
      l$spots,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$MapCellDetail$mapCell ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$districtCodes = districtCodes;
    final lOther$districtCodes = other.districtCodes;
    if (l$districtCodes.length != lOther$districtCodes.length) {
      return false;
    }
    for (int i = 0; i < l$districtCodes.length; i++) {
      final l$districtCodes$entry = l$districtCodes[i];
      final lOther$districtCodes$entry = lOther$districtCodes[i];
      if (l$districtCodes$entry != lOther$districtCodes$entry) {
        return false;
      }
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
    final l$provinceCode = provinceCode;
    final lOther$provinceCode = other.provinceCode;
    if (l$provinceCode != lOther$provinceCode) {
      return false;
    }
    final l$viewerVisited = viewerVisited;
    final lOther$viewerVisited = other.viewerVisited;
    if (l$viewerVisited != lOther$viewerVisited) {
      return false;
    }
    final l$center = center;
    final lOther$center = other.center;
    if (l$center != lOther$center) {
      return false;
    }
    final l$representativeImage = representativeImage;
    final lOther$representativeImage = other.representativeImage;
    if (l$representativeImage != lOther$representativeImage) {
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

extension UtilityExtension$Query$MapCellDetail$mapCell
    on Query$MapCellDetail$mapCell {
  CopyWith$Query$MapCellDetail$mapCell<Query$MapCellDetail$mapCell>
  get copyWith => CopyWith$Query$MapCellDetail$mapCell(this, (i) => i);
}

abstract class CopyWith$Query$MapCellDetail$mapCell<TRes> {
  factory CopyWith$Query$MapCellDetail$mapCell(
    Query$MapCellDetail$mapCell instance,
    TRes Function(Query$MapCellDetail$mapCell) then,
  ) = _CopyWithImpl$Query$MapCellDetail$mapCell;

  factory CopyWith$Query$MapCellDetail$mapCell.stub(TRes res) =
      _CopyWithStubImpl$Query$MapCellDetail$mapCell;

  TRes call({
    String? id,
    List<String>? districtCodes,
    String? name,
    String? provinceName,
    String? provinceCode,
    bool? viewerVisited,
    Query$MapCellDetail$mapCell$center? center,
    Fragment$CellImageFields? representativeImage,
    Query$MapCellDetail$mapCell$spots? spots,
  });
  CopyWith$Query$MapCellDetail$mapCell$center<TRes> get center;
  CopyWith$Fragment$CellImageFields<TRes> get representativeImage;
  CopyWith$Query$MapCellDetail$mapCell$spots<TRes> get spots;
}

class _CopyWithImpl$Query$MapCellDetail$mapCell<TRes>
    implements CopyWith$Query$MapCellDetail$mapCell<TRes> {
  _CopyWithImpl$Query$MapCellDetail$mapCell(this._instance, this._then);

  final Query$MapCellDetail$mapCell _instance;

  final TRes Function(Query$MapCellDetail$mapCell) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? districtCodes = _undefined,
    Object? name = _undefined,
    Object? provinceName = _undefined,
    Object? provinceCode = _undefined,
    Object? viewerVisited = _undefined,
    Object? center = _undefined,
    Object? representativeImage = _undefined,
    Object? spots = _undefined,
  }) => _then(
    Query$MapCellDetail$mapCell(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      districtCodes: districtCodes == _undefined || districtCodes == null
          ? _instance.districtCodes
          : (districtCodes as List<String>),
      name: name == _undefined || name == null
          ? _instance.name
          : (name as String),
      provinceName: provinceName == _undefined || provinceName == null
          ? _instance.provinceName
          : (provinceName as String),
      provinceCode: provinceCode == _undefined || provinceCode == null
          ? _instance.provinceCode
          : (provinceCode as String),
      viewerVisited: viewerVisited == _undefined || viewerVisited == null
          ? _instance.viewerVisited
          : (viewerVisited as bool),
      center: center == _undefined || center == null
          ? _instance.center
          : (center as Query$MapCellDetail$mapCell$center),
      representativeImage: representativeImage == _undefined
          ? _instance.representativeImage
          : (representativeImage as Fragment$CellImageFields?),
      spots: spots == _undefined || spots == null
          ? _instance.spots
          : (spots as Query$MapCellDetail$mapCell$spots),
    ),
  );

  CopyWith$Query$MapCellDetail$mapCell$center<TRes> get center {
    final local$center = _instance.center;
    return CopyWith$Query$MapCellDetail$mapCell$center(
      local$center,
      (e) => call(center: e),
    );
  }

  CopyWith$Fragment$CellImageFields<TRes> get representativeImage {
    final local$representativeImage = _instance.representativeImage;
    return local$representativeImage == null
        ? CopyWith$Fragment$CellImageFields.stub(_then(_instance))
        : CopyWith$Fragment$CellImageFields(
            local$representativeImage,
            (e) => call(representativeImage: e),
          );
  }

  CopyWith$Query$MapCellDetail$mapCell$spots<TRes> get spots {
    final local$spots = _instance.spots;
    return CopyWith$Query$MapCellDetail$mapCell$spots(
      local$spots,
      (e) => call(spots: e),
    );
  }
}

class _CopyWithStubImpl$Query$MapCellDetail$mapCell<TRes>
    implements CopyWith$Query$MapCellDetail$mapCell<TRes> {
  _CopyWithStubImpl$Query$MapCellDetail$mapCell(this._res);

  TRes _res;

  call({
    String? id,
    List<String>? districtCodes,
    String? name,
    String? provinceName,
    String? provinceCode,
    bool? viewerVisited,
    Query$MapCellDetail$mapCell$center? center,
    Fragment$CellImageFields? representativeImage,
    Query$MapCellDetail$mapCell$spots? spots,
  }) => _res;

  CopyWith$Query$MapCellDetail$mapCell$center<TRes> get center =>
      CopyWith$Query$MapCellDetail$mapCell$center.stub(_res);

  CopyWith$Fragment$CellImageFields<TRes> get representativeImage =>
      CopyWith$Fragment$CellImageFields.stub(_res);

  CopyWith$Query$MapCellDetail$mapCell$spots<TRes> get spots =>
      CopyWith$Query$MapCellDetail$mapCell$spots.stub(_res);
}

class Query$MapCellDetail$mapCell$center
    implements Fragment$MapCellCore$center {
  Query$MapCellDetail$mapCell$center({required this.lat, required this.lng});

  factory Query$MapCellDetail$mapCell$center.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$lat = json['lat'];
    final l$lng = json['lng'];
    return Query$MapCellDetail$mapCell$center(
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
    if (other is! Query$MapCellDetail$mapCell$center ||
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

extension UtilityExtension$Query$MapCellDetail$mapCell$center
    on Query$MapCellDetail$mapCell$center {
  CopyWith$Query$MapCellDetail$mapCell$center<
    Query$MapCellDetail$mapCell$center
  >
  get copyWith => CopyWith$Query$MapCellDetail$mapCell$center(this, (i) => i);
}

abstract class CopyWith$Query$MapCellDetail$mapCell$center<TRes> {
  factory CopyWith$Query$MapCellDetail$mapCell$center(
    Query$MapCellDetail$mapCell$center instance,
    TRes Function(Query$MapCellDetail$mapCell$center) then,
  ) = _CopyWithImpl$Query$MapCellDetail$mapCell$center;

  factory CopyWith$Query$MapCellDetail$mapCell$center.stub(TRes res) =
      _CopyWithStubImpl$Query$MapCellDetail$mapCell$center;

  TRes call({double? lat, double? lng});
}

class _CopyWithImpl$Query$MapCellDetail$mapCell$center<TRes>
    implements CopyWith$Query$MapCellDetail$mapCell$center<TRes> {
  _CopyWithImpl$Query$MapCellDetail$mapCell$center(this._instance, this._then);

  final Query$MapCellDetail$mapCell$center _instance;

  final TRes Function(Query$MapCellDetail$mapCell$center) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? lat = _undefined, Object? lng = _undefined}) => _then(
    Query$MapCellDetail$mapCell$center(
      lat: lat == _undefined || lat == null ? _instance.lat : (lat as double),
      lng: lng == _undefined || lng == null ? _instance.lng : (lng as double),
    ),
  );
}

class _CopyWithStubImpl$Query$MapCellDetail$mapCell$center<TRes>
    implements CopyWith$Query$MapCellDetail$mapCell$center<TRes> {
  _CopyWithStubImpl$Query$MapCellDetail$mapCell$center(this._res);

  TRes _res;

  call({double? lat, double? lng}) => _res;
}

class Query$MapCellDetail$mapCell$spots {
  Query$MapCellDetail$mapCell$spots({
    required this.edges,
    required this.pageInfo,
  });

  factory Query$MapCellDetail$mapCell$spots.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$edges = json['edges'];
    final l$pageInfo = json['pageInfo'];
    return Query$MapCellDetail$mapCell$spots(
      edges: (l$edges as List<dynamic>)
          .map(
            (e) => Query$MapCellDetail$mapCell$spots$edges.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      pageInfo: Query$MapCellDetail$mapCell$spots$pageInfo.fromJson(
        (l$pageInfo as Map<String, dynamic>),
      ),
    );
  }

  final List<Query$MapCellDetail$mapCell$spots$edges> edges;

  final Query$MapCellDetail$mapCell$spots$pageInfo pageInfo;

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
    if (other is! Query$MapCellDetail$mapCell$spots ||
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

extension UtilityExtension$Query$MapCellDetail$mapCell$spots
    on Query$MapCellDetail$mapCell$spots {
  CopyWith$Query$MapCellDetail$mapCell$spots<Query$MapCellDetail$mapCell$spots>
  get copyWith => CopyWith$Query$MapCellDetail$mapCell$spots(this, (i) => i);
}

abstract class CopyWith$Query$MapCellDetail$mapCell$spots<TRes> {
  factory CopyWith$Query$MapCellDetail$mapCell$spots(
    Query$MapCellDetail$mapCell$spots instance,
    TRes Function(Query$MapCellDetail$mapCell$spots) then,
  ) = _CopyWithImpl$Query$MapCellDetail$mapCell$spots;

  factory CopyWith$Query$MapCellDetail$mapCell$spots.stub(TRes res) =
      _CopyWithStubImpl$Query$MapCellDetail$mapCell$spots;

  TRes call({
    List<Query$MapCellDetail$mapCell$spots$edges>? edges,
    Query$MapCellDetail$mapCell$spots$pageInfo? pageInfo,
  });
  TRes edges(
    Iterable<Query$MapCellDetail$mapCell$spots$edges> Function(
      Iterable<
        CopyWith$Query$MapCellDetail$mapCell$spots$edges<
          Query$MapCellDetail$mapCell$spots$edges
        >
      >,
    )
    _fn,
  );
  CopyWith$Query$MapCellDetail$mapCell$spots$pageInfo<TRes> get pageInfo;
}

class _CopyWithImpl$Query$MapCellDetail$mapCell$spots<TRes>
    implements CopyWith$Query$MapCellDetail$mapCell$spots<TRes> {
  _CopyWithImpl$Query$MapCellDetail$mapCell$spots(this._instance, this._then);

  final Query$MapCellDetail$mapCell$spots _instance;

  final TRes Function(Query$MapCellDetail$mapCell$spots) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? edges = _undefined, Object? pageInfo = _undefined}) =>
      _then(
        Query$MapCellDetail$mapCell$spots(
          edges: edges == _undefined || edges == null
              ? _instance.edges
              : (edges as List<Query$MapCellDetail$mapCell$spots$edges>),
          pageInfo: pageInfo == _undefined || pageInfo == null
              ? _instance.pageInfo
              : (pageInfo as Query$MapCellDetail$mapCell$spots$pageInfo),
        ),
      );

  TRes edges(
    Iterable<Query$MapCellDetail$mapCell$spots$edges> Function(
      Iterable<
        CopyWith$Query$MapCellDetail$mapCell$spots$edges<
          Query$MapCellDetail$mapCell$spots$edges
        >
      >,
    )
    _fn,
  ) => call(
    edges: _fn(
      _instance.edges.map(
        (e) => CopyWith$Query$MapCellDetail$mapCell$spots$edges(e, (i) => i),
      ),
    ).toList(),
  );

  CopyWith$Query$MapCellDetail$mapCell$spots$pageInfo<TRes> get pageInfo {
    final local$pageInfo = _instance.pageInfo;
    return CopyWith$Query$MapCellDetail$mapCell$spots$pageInfo(
      local$pageInfo,
      (e) => call(pageInfo: e),
    );
  }
}

class _CopyWithStubImpl$Query$MapCellDetail$mapCell$spots<TRes>
    implements CopyWith$Query$MapCellDetail$mapCell$spots<TRes> {
  _CopyWithStubImpl$Query$MapCellDetail$mapCell$spots(this._res);

  TRes _res;

  call({
    List<Query$MapCellDetail$mapCell$spots$edges>? edges,
    Query$MapCellDetail$mapCell$spots$pageInfo? pageInfo,
  }) => _res;

  edges(_fn) => _res;

  CopyWith$Query$MapCellDetail$mapCell$spots$pageInfo<TRes> get pageInfo =>
      CopyWith$Query$MapCellDetail$mapCell$spots$pageInfo.stub(_res);
}

class Query$MapCellDetail$mapCell$spots$edges {
  Query$MapCellDetail$mapCell$spots$edges({
    required this.cursor,
    required this.likeCount,
    required this.node,
  });

  factory Query$MapCellDetail$mapCell$spots$edges.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$cursor = json['cursor'];
    final l$likeCount = json['likeCount'];
    final l$node = json['node'];
    return Query$MapCellDetail$mapCell$spots$edges(
      cursor: (l$cursor as String),
      likeCount: (l$likeCount as int),
      node: Query$MapCellDetail$mapCell$spots$edges$node.fromJson(
        (l$node as Map<String, dynamic>),
      ),
    );
  }

  final String cursor;

  final int likeCount;

  final Query$MapCellDetail$mapCell$spots$edges$node node;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$cursor = cursor;
    _resultData['cursor'] = l$cursor;
    final l$likeCount = likeCount;
    _resultData['likeCount'] = l$likeCount;
    final l$node = node;
    _resultData['node'] = l$node.toJson();
    return _resultData;
  }

  @override
  int get hashCode {
    final l$cursor = cursor;
    final l$likeCount = likeCount;
    final l$node = node;
    return Object.hashAll([l$cursor, l$likeCount, l$node]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$MapCellDetail$mapCell$spots$edges ||
        runtimeType != other.runtimeType) {
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
    final l$node = node;
    final lOther$node = other.node;
    if (l$node != lOther$node) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Query$MapCellDetail$mapCell$spots$edges
    on Query$MapCellDetail$mapCell$spots$edges {
  CopyWith$Query$MapCellDetail$mapCell$spots$edges<
    Query$MapCellDetail$mapCell$spots$edges
  >
  get copyWith =>
      CopyWith$Query$MapCellDetail$mapCell$spots$edges(this, (i) => i);
}

abstract class CopyWith$Query$MapCellDetail$mapCell$spots$edges<TRes> {
  factory CopyWith$Query$MapCellDetail$mapCell$spots$edges(
    Query$MapCellDetail$mapCell$spots$edges instance,
    TRes Function(Query$MapCellDetail$mapCell$spots$edges) then,
  ) = _CopyWithImpl$Query$MapCellDetail$mapCell$spots$edges;

  factory CopyWith$Query$MapCellDetail$mapCell$spots$edges.stub(TRes res) =
      _CopyWithStubImpl$Query$MapCellDetail$mapCell$spots$edges;

  TRes call({
    String? cursor,
    int? likeCount,
    Query$MapCellDetail$mapCell$spots$edges$node? node,
  });
  CopyWith$Query$MapCellDetail$mapCell$spots$edges$node<TRes> get node;
}

class _CopyWithImpl$Query$MapCellDetail$mapCell$spots$edges<TRes>
    implements CopyWith$Query$MapCellDetail$mapCell$spots$edges<TRes> {
  _CopyWithImpl$Query$MapCellDetail$mapCell$spots$edges(
    this._instance,
    this._then,
  );

  final Query$MapCellDetail$mapCell$spots$edges _instance;

  final TRes Function(Query$MapCellDetail$mapCell$spots$edges) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? cursor = _undefined,
    Object? likeCount = _undefined,
    Object? node = _undefined,
  }) => _then(
    Query$MapCellDetail$mapCell$spots$edges(
      cursor: cursor == _undefined || cursor == null
          ? _instance.cursor
          : (cursor as String),
      likeCount: likeCount == _undefined || likeCount == null
          ? _instance.likeCount
          : (likeCount as int),
      node: node == _undefined || node == null
          ? _instance.node
          : (node as Query$MapCellDetail$mapCell$spots$edges$node),
    ),
  );

  CopyWith$Query$MapCellDetail$mapCell$spots$edges$node<TRes> get node {
    final local$node = _instance.node;
    return CopyWith$Query$MapCellDetail$mapCell$spots$edges$node(
      local$node,
      (e) => call(node: e),
    );
  }
}

class _CopyWithStubImpl$Query$MapCellDetail$mapCell$spots$edges<TRes>
    implements CopyWith$Query$MapCellDetail$mapCell$spots$edges<TRes> {
  _CopyWithStubImpl$Query$MapCellDetail$mapCell$spots$edges(this._res);

  TRes _res;

  call({
    String? cursor,
    int? likeCount,
    Query$MapCellDetail$mapCell$spots$edges$node? node,
  }) => _res;

  CopyWith$Query$MapCellDetail$mapCell$spots$edges$node<TRes> get node =>
      CopyWith$Query$MapCellDetail$mapCell$spots$edges$node.stub(_res);
}

class Query$MapCellDetail$mapCell$spots$edges$node {
  Query$MapCellDetail$mapCell$spots$edges$node({
    required this.id,
    required this.title,
    required this.thumbnailImageUrl,
    required this.lat,
    required this.lng,
    required this.category,
  });

  factory Query$MapCellDetail$mapCell$spots$edges$node.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$title = json['title'];
    final l$thumbnailImageUrl = json['thumbnailImageUrl'];
    final l$lat = json['lat'];
    final l$lng = json['lng'];
    final l$category = json['category'];
    return Query$MapCellDetail$mapCell$spots$edges$node(
      id: (l$id as String),
      title: (l$title as String),
      thumbnailImageUrl: (l$thumbnailImageUrl as String),
      lat: (l$lat as num).toDouble(),
      lng: (l$lng as num).toDouble(),
      category: Query$MapCellDetail$mapCell$spots$edges$node$category.fromJson(
        (l$category as Map<String, dynamic>),
      ),
    );
  }

  final String id;

  final String title;

  final String thumbnailImageUrl;

  final double lat;

  final double lng;

  final Query$MapCellDetail$mapCell$spots$edges$node$category category;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$title = title;
    _resultData['title'] = l$title;
    final l$thumbnailImageUrl = thumbnailImageUrl;
    _resultData['thumbnailImageUrl'] = l$thumbnailImageUrl;
    final l$lat = lat;
    _resultData['lat'] = l$lat;
    final l$lng = lng;
    _resultData['lng'] = l$lng;
    final l$category = category;
    _resultData['category'] = l$category.toJson();
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$title = title;
    final l$thumbnailImageUrl = thumbnailImageUrl;
    final l$lat = lat;
    final l$lng = lng;
    final l$category = category;
    return Object.hashAll([
      l$id,
      l$title,
      l$thumbnailImageUrl,
      l$lat,
      l$lng,
      l$category,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$MapCellDetail$mapCell$spots$edges$node ||
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
    final l$category = category;
    final lOther$category = other.category;
    if (l$category != lOther$category) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Query$MapCellDetail$mapCell$spots$edges$node
    on Query$MapCellDetail$mapCell$spots$edges$node {
  CopyWith$Query$MapCellDetail$mapCell$spots$edges$node<
    Query$MapCellDetail$mapCell$spots$edges$node
  >
  get copyWith =>
      CopyWith$Query$MapCellDetail$mapCell$spots$edges$node(this, (i) => i);
}

abstract class CopyWith$Query$MapCellDetail$mapCell$spots$edges$node<TRes> {
  factory CopyWith$Query$MapCellDetail$mapCell$spots$edges$node(
    Query$MapCellDetail$mapCell$spots$edges$node instance,
    TRes Function(Query$MapCellDetail$mapCell$spots$edges$node) then,
  ) = _CopyWithImpl$Query$MapCellDetail$mapCell$spots$edges$node;

  factory CopyWith$Query$MapCellDetail$mapCell$spots$edges$node.stub(TRes res) =
      _CopyWithStubImpl$Query$MapCellDetail$mapCell$spots$edges$node;

  TRes call({
    String? id,
    String? title,
    String? thumbnailImageUrl,
    double? lat,
    double? lng,
    Query$MapCellDetail$mapCell$spots$edges$node$category? category,
  });
  CopyWith$Query$MapCellDetail$mapCell$spots$edges$node$category<TRes>
  get category;
}

class _CopyWithImpl$Query$MapCellDetail$mapCell$spots$edges$node<TRes>
    implements CopyWith$Query$MapCellDetail$mapCell$spots$edges$node<TRes> {
  _CopyWithImpl$Query$MapCellDetail$mapCell$spots$edges$node(
    this._instance,
    this._then,
  );

  final Query$MapCellDetail$mapCell$spots$edges$node _instance;

  final TRes Function(Query$MapCellDetail$mapCell$spots$edges$node) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? title = _undefined,
    Object? thumbnailImageUrl = _undefined,
    Object? lat = _undefined,
    Object? lng = _undefined,
    Object? category = _undefined,
  }) => _then(
    Query$MapCellDetail$mapCell$spots$edges$node(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      title: title == _undefined || title == null
          ? _instance.title
          : (title as String),
      thumbnailImageUrl:
          thumbnailImageUrl == _undefined || thumbnailImageUrl == null
          ? _instance.thumbnailImageUrl
          : (thumbnailImageUrl as String),
      lat: lat == _undefined || lat == null ? _instance.lat : (lat as double),
      lng: lng == _undefined || lng == null ? _instance.lng : (lng as double),
      category: category == _undefined || category == null
          ? _instance.category
          : (category as Query$MapCellDetail$mapCell$spots$edges$node$category),
    ),
  );

  CopyWith$Query$MapCellDetail$mapCell$spots$edges$node$category<TRes>
  get category {
    final local$category = _instance.category;
    return CopyWith$Query$MapCellDetail$mapCell$spots$edges$node$category(
      local$category,
      (e) => call(category: e),
    );
  }
}

class _CopyWithStubImpl$Query$MapCellDetail$mapCell$spots$edges$node<TRes>
    implements CopyWith$Query$MapCellDetail$mapCell$spots$edges$node<TRes> {
  _CopyWithStubImpl$Query$MapCellDetail$mapCell$spots$edges$node(this._res);

  TRes _res;

  call({
    String? id,
    String? title,
    String? thumbnailImageUrl,
    double? lat,
    double? lng,
    Query$MapCellDetail$mapCell$spots$edges$node$category? category,
  }) => _res;

  CopyWith$Query$MapCellDetail$mapCell$spots$edges$node$category<TRes>
  get category =>
      CopyWith$Query$MapCellDetail$mapCell$spots$edges$node$category.stub(_res);
}

class Query$MapCellDetail$mapCell$spots$edges$node$category {
  Query$MapCellDetail$mapCell$spots$edges$node$category({
    required this.code,
    required this.label,
  });

  factory Query$MapCellDetail$mapCell$spots$edges$node$category.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$code = json['code'];
    final l$label = json['label'];
    return Query$MapCellDetail$mapCell$spots$edges$node$category(
      code: (l$code as String),
      label: (l$label as String),
    );
  }

  final String code;

  final String label;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$code = code;
    _resultData['code'] = l$code;
    final l$label = label;
    _resultData['label'] = l$label;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$code = code;
    final l$label = label;
    return Object.hashAll([l$code, l$label]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$MapCellDetail$mapCell$spots$edges$node$category ||
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
    return true;
  }
}

extension UtilityExtension$Query$MapCellDetail$mapCell$spots$edges$node$category
    on Query$MapCellDetail$mapCell$spots$edges$node$category {
  CopyWith$Query$MapCellDetail$mapCell$spots$edges$node$category<
    Query$MapCellDetail$mapCell$spots$edges$node$category
  >
  get copyWith =>
      CopyWith$Query$MapCellDetail$mapCell$spots$edges$node$category(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Query$MapCellDetail$mapCell$spots$edges$node$category<
  TRes
> {
  factory CopyWith$Query$MapCellDetail$mapCell$spots$edges$node$category(
    Query$MapCellDetail$mapCell$spots$edges$node$category instance,
    TRes Function(Query$MapCellDetail$mapCell$spots$edges$node$category) then,
  ) = _CopyWithImpl$Query$MapCellDetail$mapCell$spots$edges$node$category;

  factory CopyWith$Query$MapCellDetail$mapCell$spots$edges$node$category.stub(
    TRes res,
  ) = _CopyWithStubImpl$Query$MapCellDetail$mapCell$spots$edges$node$category;

  TRes call({String? code, String? label});
}

class _CopyWithImpl$Query$MapCellDetail$mapCell$spots$edges$node$category<TRes>
    implements
        CopyWith$Query$MapCellDetail$mapCell$spots$edges$node$category<TRes> {
  _CopyWithImpl$Query$MapCellDetail$mapCell$spots$edges$node$category(
    this._instance,
    this._then,
  );

  final Query$MapCellDetail$mapCell$spots$edges$node$category _instance;

  final TRes Function(Query$MapCellDetail$mapCell$spots$edges$node$category)
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? code = _undefined, Object? label = _undefined}) => _then(
    Query$MapCellDetail$mapCell$spots$edges$node$category(
      code: code == _undefined || code == null
          ? _instance.code
          : (code as String),
      label: label == _undefined || label == null
          ? _instance.label
          : (label as String),
    ),
  );
}

class _CopyWithStubImpl$Query$MapCellDetail$mapCell$spots$edges$node$category<
  TRes
>
    implements
        CopyWith$Query$MapCellDetail$mapCell$spots$edges$node$category<TRes> {
  _CopyWithStubImpl$Query$MapCellDetail$mapCell$spots$edges$node$category(
    this._res,
  );

  TRes _res;

  call({String? code, String? label}) => _res;
}

class Query$MapCellDetail$mapCell$spots$pageInfo {
  Query$MapCellDetail$mapCell$spots$pageInfo({
    required this.hasNextPage,
    this.endCursor,
  });

  factory Query$MapCellDetail$mapCell$spots$pageInfo.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$hasNextPage = json['hasNextPage'];
    final l$endCursor = json['endCursor'];
    return Query$MapCellDetail$mapCell$spots$pageInfo(
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
    if (other is! Query$MapCellDetail$mapCell$spots$pageInfo ||
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

extension UtilityExtension$Query$MapCellDetail$mapCell$spots$pageInfo
    on Query$MapCellDetail$mapCell$spots$pageInfo {
  CopyWith$Query$MapCellDetail$mapCell$spots$pageInfo<
    Query$MapCellDetail$mapCell$spots$pageInfo
  >
  get copyWith =>
      CopyWith$Query$MapCellDetail$mapCell$spots$pageInfo(this, (i) => i);
}

abstract class CopyWith$Query$MapCellDetail$mapCell$spots$pageInfo<TRes> {
  factory CopyWith$Query$MapCellDetail$mapCell$spots$pageInfo(
    Query$MapCellDetail$mapCell$spots$pageInfo instance,
    TRes Function(Query$MapCellDetail$mapCell$spots$pageInfo) then,
  ) = _CopyWithImpl$Query$MapCellDetail$mapCell$spots$pageInfo;

  factory CopyWith$Query$MapCellDetail$mapCell$spots$pageInfo.stub(TRes res) =
      _CopyWithStubImpl$Query$MapCellDetail$mapCell$spots$pageInfo;

  TRes call({bool? hasNextPage, String? endCursor});
}

class _CopyWithImpl$Query$MapCellDetail$mapCell$spots$pageInfo<TRes>
    implements CopyWith$Query$MapCellDetail$mapCell$spots$pageInfo<TRes> {
  _CopyWithImpl$Query$MapCellDetail$mapCell$spots$pageInfo(
    this._instance,
    this._then,
  );

  final Query$MapCellDetail$mapCell$spots$pageInfo _instance;

  final TRes Function(Query$MapCellDetail$mapCell$spots$pageInfo) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? hasNextPage = _undefined,
    Object? endCursor = _undefined,
  }) => _then(
    Query$MapCellDetail$mapCell$spots$pageInfo(
      hasNextPage: hasNextPage == _undefined || hasNextPage == null
          ? _instance.hasNextPage
          : (hasNextPage as bool),
      endCursor: endCursor == _undefined
          ? _instance.endCursor
          : (endCursor as String?),
    ),
  );
}

class _CopyWithStubImpl$Query$MapCellDetail$mapCell$spots$pageInfo<TRes>
    implements CopyWith$Query$MapCellDetail$mapCell$spots$pageInfo<TRes> {
  _CopyWithStubImpl$Query$MapCellDetail$mapCell$spots$pageInfo(this._res);

  TRes _res;

  call({bool? hasNextPage, String? endCursor}) => _res;
}

class Variables$Query$SharedMap {
  factory Variables$Query$SharedMap({required String token}) =>
      Variables$Query$SharedMap._({r'token': token});

  Variables$Query$SharedMap._(this._$data);

  factory Variables$Query$SharedMap.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$token = data['token'];
    result$data['token'] = (l$token as String);
    return Variables$Query$SharedMap._(result$data);
  }

  Map<String, dynamic> _$data;

  String get token => (_$data['token'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$token = token;
    result$data['token'] = l$token;
    return result$data;
  }

  CopyWith$Variables$Query$SharedMap<Variables$Query$SharedMap> get copyWith =>
      CopyWith$Variables$Query$SharedMap(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Query$SharedMap ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$token = token;
    final lOther$token = other.token;
    if (l$token != lOther$token) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$token = token;
    return Object.hashAll([l$token]);
  }
}

abstract class CopyWith$Variables$Query$SharedMap<TRes> {
  factory CopyWith$Variables$Query$SharedMap(
    Variables$Query$SharedMap instance,
    TRes Function(Variables$Query$SharedMap) then,
  ) = _CopyWithImpl$Variables$Query$SharedMap;

  factory CopyWith$Variables$Query$SharedMap.stub(TRes res) =
      _CopyWithStubImpl$Variables$Query$SharedMap;

  TRes call({String? token});
}

class _CopyWithImpl$Variables$Query$SharedMap<TRes>
    implements CopyWith$Variables$Query$SharedMap<TRes> {
  _CopyWithImpl$Variables$Query$SharedMap(this._instance, this._then);

  final Variables$Query$SharedMap _instance;

  final TRes Function(Variables$Query$SharedMap) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? token = _undefined}) => _then(
    Variables$Query$SharedMap._({
      ..._instance._$data,
      if (token != _undefined && token != null) 'token': (token as String),
    }),
  );
}

class _CopyWithStubImpl$Variables$Query$SharedMap<TRes>
    implements CopyWith$Variables$Query$SharedMap<TRes> {
  _CopyWithStubImpl$Variables$Query$SharedMap(this._res);

  TRes _res;

  call({String? token}) => _res;
}

class Query$SharedMap {
  Query$SharedMap({required this.sharedMap});

  factory Query$SharedMap.fromJson(Map<String, dynamic> json) {
    final l$sharedMap = json['sharedMap'];
    return Query$SharedMap(
      sharedMap: Query$SharedMap$sharedMap.fromJson(
        (l$sharedMap as Map<String, dynamic>),
      ),
    );
  }

  final Query$SharedMap$sharedMap sharedMap;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$sharedMap = sharedMap;
    _resultData['sharedMap'] = l$sharedMap.toJson();
    return _resultData;
  }

  @override
  int get hashCode {
    final l$sharedMap = sharedMap;
    return Object.hashAll([l$sharedMap]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$SharedMap || runtimeType != other.runtimeType) {
      return false;
    }
    final l$sharedMap = sharedMap;
    final lOther$sharedMap = other.sharedMap;
    if (l$sharedMap != lOther$sharedMap) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Query$SharedMap on Query$SharedMap {
  CopyWith$Query$SharedMap<Query$SharedMap> get copyWith =>
      CopyWith$Query$SharedMap(this, (i) => i);
}

abstract class CopyWith$Query$SharedMap<TRes> {
  factory CopyWith$Query$SharedMap(
    Query$SharedMap instance,
    TRes Function(Query$SharedMap) then,
  ) = _CopyWithImpl$Query$SharedMap;

  factory CopyWith$Query$SharedMap.stub(TRes res) =
      _CopyWithStubImpl$Query$SharedMap;

  TRes call({Query$SharedMap$sharedMap? sharedMap});
  CopyWith$Query$SharedMap$sharedMap<TRes> get sharedMap;
}

class _CopyWithImpl$Query$SharedMap<TRes>
    implements CopyWith$Query$SharedMap<TRes> {
  _CopyWithImpl$Query$SharedMap(this._instance, this._then);

  final Query$SharedMap _instance;

  final TRes Function(Query$SharedMap) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? sharedMap = _undefined}) => _then(
    Query$SharedMap(
      sharedMap: sharedMap == _undefined || sharedMap == null
          ? _instance.sharedMap
          : (sharedMap as Query$SharedMap$sharedMap),
    ),
  );

  CopyWith$Query$SharedMap$sharedMap<TRes> get sharedMap {
    final local$sharedMap = _instance.sharedMap;
    return CopyWith$Query$SharedMap$sharedMap(
      local$sharedMap,
      (e) => call(sharedMap: e),
    );
  }
}

class _CopyWithStubImpl$Query$SharedMap<TRes>
    implements CopyWith$Query$SharedMap<TRes> {
  _CopyWithStubImpl$Query$SharedMap(this._res);

  TRes _res;

  call({Query$SharedMap$sharedMap? sharedMap}) => _res;

  CopyWith$Query$SharedMap$sharedMap<TRes> get sharedMap =>
      CopyWith$Query$SharedMap$sharedMap.stub(_res);
}

const documentNodeQuerySharedMap = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'SharedMap'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'token')),
          type: NamedTypeNode(name: NameNode(value: 'String'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
      ],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'sharedMap'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'token'),
                value: VariableNode(name: NameNode(value: 'token')),
              ),
            ],
            directives: [],
            selectionSet: SelectionSetNode(
              selections: [
                FieldNode(
                  name: NameNode(value: 'ownerNickname'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: 'visitedCellIds'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: 'overlappingCellIds'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: 'overlappingCells'),
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
                    ],
                  ),
                ),
                FieldNode(
                  name: NameNode(value: 'visitedCount'),
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

class Query$SharedMap$sharedMap {
  Query$SharedMap$sharedMap({
    required this.ownerNickname,
    required this.visitedCellIds,
    this.overlappingCellIds,
    this.overlappingCells,
    required this.visitedCount,
  });

  factory Query$SharedMap$sharedMap.fromJson(Map<String, dynamic> json) {
    final l$ownerNickname = json['ownerNickname'];
    final l$visitedCellIds = json['visitedCellIds'];
    final l$overlappingCellIds = json['overlappingCellIds'];
    final l$overlappingCells = json['overlappingCells'];
    final l$visitedCount = json['visitedCount'];
    return Query$SharedMap$sharedMap(
      ownerNickname: (l$ownerNickname as String),
      visitedCellIds: (l$visitedCellIds as List<dynamic>)
          .map((e) => (e as String))
          .toList(),
      overlappingCellIds: (l$overlappingCellIds as List<dynamic>?)
          ?.map((e) => (e as String))
          .toList(),
      overlappingCells: (l$overlappingCells as List<dynamic>?)
          ?.map(
            (e) => Query$SharedMap$sharedMap$overlappingCells.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      visitedCount: (l$visitedCount as int),
    );
  }

  final String ownerNickname;

  final List<String> visitedCellIds;

  final List<String>? overlappingCellIds;

  final List<Query$SharedMap$sharedMap$overlappingCells>? overlappingCells;

  final int visitedCount;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$ownerNickname = ownerNickname;
    _resultData['ownerNickname'] = l$ownerNickname;
    final l$visitedCellIds = visitedCellIds;
    _resultData['visitedCellIds'] = l$visitedCellIds.map((e) => e).toList();
    final l$overlappingCellIds = overlappingCellIds;
    _resultData['overlappingCellIds'] = l$overlappingCellIds
        ?.map((e) => e)
        .toList();
    final l$overlappingCells = overlappingCells;
    _resultData['overlappingCells'] = l$overlappingCells
        ?.map((e) => e.toJson())
        .toList();
    final l$visitedCount = visitedCount;
    _resultData['visitedCount'] = l$visitedCount;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$ownerNickname = ownerNickname;
    final l$visitedCellIds = visitedCellIds;
    final l$overlappingCellIds = overlappingCellIds;
    final l$overlappingCells = overlappingCells;
    final l$visitedCount = visitedCount;
    return Object.hashAll([
      l$ownerNickname,
      Object.hashAll(l$visitedCellIds.map((v) => v)),
      l$overlappingCellIds == null
          ? null
          : Object.hashAll(l$overlappingCellIds.map((v) => v)),
      l$overlappingCells == null
          ? null
          : Object.hashAll(l$overlappingCells.map((v) => v)),
      l$visitedCount,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$SharedMap$sharedMap ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$ownerNickname = ownerNickname;
    final lOther$ownerNickname = other.ownerNickname;
    if (l$ownerNickname != lOther$ownerNickname) {
      return false;
    }
    final l$visitedCellIds = visitedCellIds;
    final lOther$visitedCellIds = other.visitedCellIds;
    if (l$visitedCellIds.length != lOther$visitedCellIds.length) {
      return false;
    }
    for (int i = 0; i < l$visitedCellIds.length; i++) {
      final l$visitedCellIds$entry = l$visitedCellIds[i];
      final lOther$visitedCellIds$entry = lOther$visitedCellIds[i];
      if (l$visitedCellIds$entry != lOther$visitedCellIds$entry) {
        return false;
      }
    }
    final l$overlappingCellIds = overlappingCellIds;
    final lOther$overlappingCellIds = other.overlappingCellIds;
    if (l$overlappingCellIds != null && lOther$overlappingCellIds != null) {
      if (l$overlappingCellIds.length != lOther$overlappingCellIds.length) {
        return false;
      }
      for (int i = 0; i < l$overlappingCellIds.length; i++) {
        final l$overlappingCellIds$entry = l$overlappingCellIds[i];
        final lOther$overlappingCellIds$entry = lOther$overlappingCellIds[i];
        if (l$overlappingCellIds$entry != lOther$overlappingCellIds$entry) {
          return false;
        }
      }
    } else if (l$overlappingCellIds != lOther$overlappingCellIds) {
      return false;
    }
    final l$overlappingCells = overlappingCells;
    final lOther$overlappingCells = other.overlappingCells;
    if (l$overlappingCells != null && lOther$overlappingCells != null) {
      if (l$overlappingCells.length != lOther$overlappingCells.length) {
        return false;
      }
      for (int i = 0; i < l$overlappingCells.length; i++) {
        final l$overlappingCells$entry = l$overlappingCells[i];
        final lOther$overlappingCells$entry = lOther$overlappingCells[i];
        if (l$overlappingCells$entry != lOther$overlappingCells$entry) {
          return false;
        }
      }
    } else if (l$overlappingCells != lOther$overlappingCells) {
      return false;
    }
    final l$visitedCount = visitedCount;
    final lOther$visitedCount = other.visitedCount;
    if (l$visitedCount != lOther$visitedCount) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Query$SharedMap$sharedMap
    on Query$SharedMap$sharedMap {
  CopyWith$Query$SharedMap$sharedMap<Query$SharedMap$sharedMap> get copyWith =>
      CopyWith$Query$SharedMap$sharedMap(this, (i) => i);
}

abstract class CopyWith$Query$SharedMap$sharedMap<TRes> {
  factory CopyWith$Query$SharedMap$sharedMap(
    Query$SharedMap$sharedMap instance,
    TRes Function(Query$SharedMap$sharedMap) then,
  ) = _CopyWithImpl$Query$SharedMap$sharedMap;

  factory CopyWith$Query$SharedMap$sharedMap.stub(TRes res) =
      _CopyWithStubImpl$Query$SharedMap$sharedMap;

  TRes call({
    String? ownerNickname,
    List<String>? visitedCellIds,
    List<String>? overlappingCellIds,
    List<Query$SharedMap$sharedMap$overlappingCells>? overlappingCells,
    int? visitedCount,
  });
  TRes overlappingCells(
    Iterable<Query$SharedMap$sharedMap$overlappingCells>? Function(
      Iterable<
        CopyWith$Query$SharedMap$sharedMap$overlappingCells<
          Query$SharedMap$sharedMap$overlappingCells
        >
      >?,
    )
    _fn,
  );
}

class _CopyWithImpl$Query$SharedMap$sharedMap<TRes>
    implements CopyWith$Query$SharedMap$sharedMap<TRes> {
  _CopyWithImpl$Query$SharedMap$sharedMap(this._instance, this._then);

  final Query$SharedMap$sharedMap _instance;

  final TRes Function(Query$SharedMap$sharedMap) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? ownerNickname = _undefined,
    Object? visitedCellIds = _undefined,
    Object? overlappingCellIds = _undefined,
    Object? overlappingCells = _undefined,
    Object? visitedCount = _undefined,
  }) => _then(
    Query$SharedMap$sharedMap(
      ownerNickname: ownerNickname == _undefined || ownerNickname == null
          ? _instance.ownerNickname
          : (ownerNickname as String),
      visitedCellIds: visitedCellIds == _undefined || visitedCellIds == null
          ? _instance.visitedCellIds
          : (visitedCellIds as List<String>),
      overlappingCellIds: overlappingCellIds == _undefined
          ? _instance.overlappingCellIds
          : (overlappingCellIds as List<String>?),
      overlappingCells: overlappingCells == _undefined
          ? _instance.overlappingCells
          : (overlappingCells
                as List<Query$SharedMap$sharedMap$overlappingCells>?),
      visitedCount: visitedCount == _undefined || visitedCount == null
          ? _instance.visitedCount
          : (visitedCount as int),
    ),
  );

  TRes overlappingCells(
    Iterable<Query$SharedMap$sharedMap$overlappingCells>? Function(
      Iterable<
        CopyWith$Query$SharedMap$sharedMap$overlappingCells<
          Query$SharedMap$sharedMap$overlappingCells
        >
      >?,
    )
    _fn,
  ) => call(
    overlappingCells: _fn(
      _instance.overlappingCells?.map(
        (e) => CopyWith$Query$SharedMap$sharedMap$overlappingCells(e, (i) => i),
      ),
    )?.toList(),
  );
}

class _CopyWithStubImpl$Query$SharedMap$sharedMap<TRes>
    implements CopyWith$Query$SharedMap$sharedMap<TRes> {
  _CopyWithStubImpl$Query$SharedMap$sharedMap(this._res);

  TRes _res;

  call({
    String? ownerNickname,
    List<String>? visitedCellIds,
    List<String>? overlappingCellIds,
    List<Query$SharedMap$sharedMap$overlappingCells>? overlappingCells,
    int? visitedCount,
  }) => _res;

  overlappingCells(_fn) => _res;
}

class Query$SharedMap$sharedMap$overlappingCells {
  Query$SharedMap$sharedMap$overlappingCells({
    required this.id,
    required this.name,
  });

  factory Query$SharedMap$sharedMap$overlappingCells.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$name = json['name'];
    return Query$SharedMap$sharedMap$overlappingCells(
      id: (l$id as String),
      name: (l$name as String),
    );
  }

  final String id;

  final String name;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$name = name;
    _resultData['name'] = l$name;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$name = name;
    return Object.hashAll([l$id, l$name]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$SharedMap$sharedMap$overlappingCells ||
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
    return true;
  }
}

extension UtilityExtension$Query$SharedMap$sharedMap$overlappingCells
    on Query$SharedMap$sharedMap$overlappingCells {
  CopyWith$Query$SharedMap$sharedMap$overlappingCells<
    Query$SharedMap$sharedMap$overlappingCells
  >
  get copyWith =>
      CopyWith$Query$SharedMap$sharedMap$overlappingCells(this, (i) => i);
}

abstract class CopyWith$Query$SharedMap$sharedMap$overlappingCells<TRes> {
  factory CopyWith$Query$SharedMap$sharedMap$overlappingCells(
    Query$SharedMap$sharedMap$overlappingCells instance,
    TRes Function(Query$SharedMap$sharedMap$overlappingCells) then,
  ) = _CopyWithImpl$Query$SharedMap$sharedMap$overlappingCells;

  factory CopyWith$Query$SharedMap$sharedMap$overlappingCells.stub(TRes res) =
      _CopyWithStubImpl$Query$SharedMap$sharedMap$overlappingCells;

  TRes call({String? id, String? name});
}

class _CopyWithImpl$Query$SharedMap$sharedMap$overlappingCells<TRes>
    implements CopyWith$Query$SharedMap$sharedMap$overlappingCells<TRes> {
  _CopyWithImpl$Query$SharedMap$sharedMap$overlappingCells(
    this._instance,
    this._then,
  );

  final Query$SharedMap$sharedMap$overlappingCells _instance;

  final TRes Function(Query$SharedMap$sharedMap$overlappingCells) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? id = _undefined, Object? name = _undefined}) => _then(
    Query$SharedMap$sharedMap$overlappingCells(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      name: name == _undefined || name == null
          ? _instance.name
          : (name as String),
    ),
  );
}

class _CopyWithStubImpl$Query$SharedMap$sharedMap$overlappingCells<TRes>
    implements CopyWith$Query$SharedMap$sharedMap$overlappingCells<TRes> {
  _CopyWithStubImpl$Query$SharedMap$sharedMap$overlappingCells(this._res);

  TRes _res;

  call({String? id, String? name}) => _res;
}

class Variables$Query$MapRelations {
  factory Variables$Query$MapRelations({int? first, String? after}) =>
      Variables$Query$MapRelations._({
        if (first != null) r'first': first,
        if (after != null) r'after': after,
      });

  Variables$Query$MapRelations._(this._$data);

  factory Variables$Query$MapRelations.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    if (data.containsKey('first')) {
      final l$first = data['first'];
      result$data['first'] = (l$first as int?);
    }
    if (data.containsKey('after')) {
      final l$after = data['after'];
      result$data['after'] = (l$after as String?);
    }
    return Variables$Query$MapRelations._(result$data);
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

  CopyWith$Variables$Query$MapRelations<Variables$Query$MapRelations>
  get copyWith => CopyWith$Variables$Query$MapRelations(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Query$MapRelations ||
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

abstract class CopyWith$Variables$Query$MapRelations<TRes> {
  factory CopyWith$Variables$Query$MapRelations(
    Variables$Query$MapRelations instance,
    TRes Function(Variables$Query$MapRelations) then,
  ) = _CopyWithImpl$Variables$Query$MapRelations;

  factory CopyWith$Variables$Query$MapRelations.stub(TRes res) =
      _CopyWithStubImpl$Variables$Query$MapRelations;

  TRes call({int? first, String? after});
}

class _CopyWithImpl$Variables$Query$MapRelations<TRes>
    implements CopyWith$Variables$Query$MapRelations<TRes> {
  _CopyWithImpl$Variables$Query$MapRelations(this._instance, this._then);

  final Variables$Query$MapRelations _instance;

  final TRes Function(Variables$Query$MapRelations) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? first = _undefined, Object? after = _undefined}) => _then(
    Variables$Query$MapRelations._({
      ..._instance._$data,
      if (first != _undefined) 'first': (first as int?),
      if (after != _undefined) 'after': (after as String?),
    }),
  );
}

class _CopyWithStubImpl$Variables$Query$MapRelations<TRes>
    implements CopyWith$Variables$Query$MapRelations<TRes> {
  _CopyWithStubImpl$Variables$Query$MapRelations(this._res);

  TRes _res;

  call({int? first, String? after}) => _res;
}

class Query$MapRelations {
  Query$MapRelations({required this.mapRelations});

  factory Query$MapRelations.fromJson(Map<String, dynamic> json) {
    final l$mapRelations = json['mapRelations'];
    return Query$MapRelations(
      mapRelations: Query$MapRelations$mapRelations.fromJson(
        (l$mapRelations as Map<String, dynamic>),
      ),
    );
  }

  final Query$MapRelations$mapRelations mapRelations;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$mapRelations = mapRelations;
    _resultData['mapRelations'] = l$mapRelations.toJson();
    return _resultData;
  }

  @override
  int get hashCode {
    final l$mapRelations = mapRelations;
    return Object.hashAll([l$mapRelations]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$MapRelations || runtimeType != other.runtimeType) {
      return false;
    }
    final l$mapRelations = mapRelations;
    final lOther$mapRelations = other.mapRelations;
    if (l$mapRelations != lOther$mapRelations) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Query$MapRelations on Query$MapRelations {
  CopyWith$Query$MapRelations<Query$MapRelations> get copyWith =>
      CopyWith$Query$MapRelations(this, (i) => i);
}

abstract class CopyWith$Query$MapRelations<TRes> {
  factory CopyWith$Query$MapRelations(
    Query$MapRelations instance,
    TRes Function(Query$MapRelations) then,
  ) = _CopyWithImpl$Query$MapRelations;

  factory CopyWith$Query$MapRelations.stub(TRes res) =
      _CopyWithStubImpl$Query$MapRelations;

  TRes call({Query$MapRelations$mapRelations? mapRelations});
  CopyWith$Query$MapRelations$mapRelations<TRes> get mapRelations;
}

class _CopyWithImpl$Query$MapRelations<TRes>
    implements CopyWith$Query$MapRelations<TRes> {
  _CopyWithImpl$Query$MapRelations(this._instance, this._then);

  final Query$MapRelations _instance;

  final TRes Function(Query$MapRelations) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? mapRelations = _undefined}) => _then(
    Query$MapRelations(
      mapRelations: mapRelations == _undefined || mapRelations == null
          ? _instance.mapRelations
          : (mapRelations as Query$MapRelations$mapRelations),
    ),
  );

  CopyWith$Query$MapRelations$mapRelations<TRes> get mapRelations {
    final local$mapRelations = _instance.mapRelations;
    return CopyWith$Query$MapRelations$mapRelations(
      local$mapRelations,
      (e) => call(mapRelations: e),
    );
  }
}

class _CopyWithStubImpl$Query$MapRelations<TRes>
    implements CopyWith$Query$MapRelations<TRes> {
  _CopyWithStubImpl$Query$MapRelations(this._res);

  TRes _res;

  call({Query$MapRelations$mapRelations? mapRelations}) => _res;

  CopyWith$Query$MapRelations$mapRelations<TRes> get mapRelations =>
      CopyWith$Query$MapRelations$mapRelations.stub(_res);
}

const documentNodeQueryMapRelations = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'MapRelations'),
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
            name: NameNode(value: 'mapRelations'),
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
                        name: NameNode(value: 'node'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: SelectionSetNode(
                          selections: [
                            FragmentSpreadNode(
                              name: NameNode(value: 'MapRelationCore'),
                              directives: [],
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
    fragmentDefinitionMapRelationCore,
  ],
);

class Query$MapRelations$mapRelations {
  Query$MapRelations$mapRelations({
    required this.edges,
    required this.pageInfo,
  });

  factory Query$MapRelations$mapRelations.fromJson(Map<String, dynamic> json) {
    final l$edges = json['edges'];
    final l$pageInfo = json['pageInfo'];
    return Query$MapRelations$mapRelations(
      edges: (l$edges as List<dynamic>)
          .map(
            (e) => Query$MapRelations$mapRelations$edges.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      pageInfo: Query$MapRelations$mapRelations$pageInfo.fromJson(
        (l$pageInfo as Map<String, dynamic>),
      ),
    );
  }

  final List<Query$MapRelations$mapRelations$edges> edges;

  final Query$MapRelations$mapRelations$pageInfo pageInfo;

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
    if (other is! Query$MapRelations$mapRelations ||
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

extension UtilityExtension$Query$MapRelations$mapRelations
    on Query$MapRelations$mapRelations {
  CopyWith$Query$MapRelations$mapRelations<Query$MapRelations$mapRelations>
  get copyWith => CopyWith$Query$MapRelations$mapRelations(this, (i) => i);
}

abstract class CopyWith$Query$MapRelations$mapRelations<TRes> {
  factory CopyWith$Query$MapRelations$mapRelations(
    Query$MapRelations$mapRelations instance,
    TRes Function(Query$MapRelations$mapRelations) then,
  ) = _CopyWithImpl$Query$MapRelations$mapRelations;

  factory CopyWith$Query$MapRelations$mapRelations.stub(TRes res) =
      _CopyWithStubImpl$Query$MapRelations$mapRelations;

  TRes call({
    List<Query$MapRelations$mapRelations$edges>? edges,
    Query$MapRelations$mapRelations$pageInfo? pageInfo,
  });
  TRes edges(
    Iterable<Query$MapRelations$mapRelations$edges> Function(
      Iterable<
        CopyWith$Query$MapRelations$mapRelations$edges<
          Query$MapRelations$mapRelations$edges
        >
      >,
    )
    _fn,
  );
  CopyWith$Query$MapRelations$mapRelations$pageInfo<TRes> get pageInfo;
}

class _CopyWithImpl$Query$MapRelations$mapRelations<TRes>
    implements CopyWith$Query$MapRelations$mapRelations<TRes> {
  _CopyWithImpl$Query$MapRelations$mapRelations(this._instance, this._then);

  final Query$MapRelations$mapRelations _instance;

  final TRes Function(Query$MapRelations$mapRelations) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? edges = _undefined, Object? pageInfo = _undefined}) =>
      _then(
        Query$MapRelations$mapRelations(
          edges: edges == _undefined || edges == null
              ? _instance.edges
              : (edges as List<Query$MapRelations$mapRelations$edges>),
          pageInfo: pageInfo == _undefined || pageInfo == null
              ? _instance.pageInfo
              : (pageInfo as Query$MapRelations$mapRelations$pageInfo),
        ),
      );

  TRes edges(
    Iterable<Query$MapRelations$mapRelations$edges> Function(
      Iterable<
        CopyWith$Query$MapRelations$mapRelations$edges<
          Query$MapRelations$mapRelations$edges
        >
      >,
    )
    _fn,
  ) => call(
    edges: _fn(
      _instance.edges.map(
        (e) => CopyWith$Query$MapRelations$mapRelations$edges(e, (i) => i),
      ),
    ).toList(),
  );

  CopyWith$Query$MapRelations$mapRelations$pageInfo<TRes> get pageInfo {
    final local$pageInfo = _instance.pageInfo;
    return CopyWith$Query$MapRelations$mapRelations$pageInfo(
      local$pageInfo,
      (e) => call(pageInfo: e),
    );
  }
}

class _CopyWithStubImpl$Query$MapRelations$mapRelations<TRes>
    implements CopyWith$Query$MapRelations$mapRelations<TRes> {
  _CopyWithStubImpl$Query$MapRelations$mapRelations(this._res);

  TRes _res;

  call({
    List<Query$MapRelations$mapRelations$edges>? edges,
    Query$MapRelations$mapRelations$pageInfo? pageInfo,
  }) => _res;

  edges(_fn) => _res;

  CopyWith$Query$MapRelations$mapRelations$pageInfo<TRes> get pageInfo =>
      CopyWith$Query$MapRelations$mapRelations$pageInfo.stub(_res);
}

class Query$MapRelations$mapRelations$edges {
  Query$MapRelations$mapRelations$edges({
    required this.node,
    required this.cursor,
  });

  factory Query$MapRelations$mapRelations$edges.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$node = json['node'];
    final l$cursor = json['cursor'];
    return Query$MapRelations$mapRelations$edges(
      node: Fragment$MapRelationCore.fromJson((l$node as Map<String, dynamic>)),
      cursor: (l$cursor as String),
    );
  }

  final Fragment$MapRelationCore node;

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
    if (other is! Query$MapRelations$mapRelations$edges ||
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

extension UtilityExtension$Query$MapRelations$mapRelations$edges
    on Query$MapRelations$mapRelations$edges {
  CopyWith$Query$MapRelations$mapRelations$edges<
    Query$MapRelations$mapRelations$edges
  >
  get copyWith =>
      CopyWith$Query$MapRelations$mapRelations$edges(this, (i) => i);
}

abstract class CopyWith$Query$MapRelations$mapRelations$edges<TRes> {
  factory CopyWith$Query$MapRelations$mapRelations$edges(
    Query$MapRelations$mapRelations$edges instance,
    TRes Function(Query$MapRelations$mapRelations$edges) then,
  ) = _CopyWithImpl$Query$MapRelations$mapRelations$edges;

  factory CopyWith$Query$MapRelations$mapRelations$edges.stub(TRes res) =
      _CopyWithStubImpl$Query$MapRelations$mapRelations$edges;

  TRes call({Fragment$MapRelationCore? node, String? cursor});
  CopyWith$Fragment$MapRelationCore<TRes> get node;
}

class _CopyWithImpl$Query$MapRelations$mapRelations$edges<TRes>
    implements CopyWith$Query$MapRelations$mapRelations$edges<TRes> {
  _CopyWithImpl$Query$MapRelations$mapRelations$edges(
    this._instance,
    this._then,
  );

  final Query$MapRelations$mapRelations$edges _instance;

  final TRes Function(Query$MapRelations$mapRelations$edges) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? node = _undefined, Object? cursor = _undefined}) => _then(
    Query$MapRelations$mapRelations$edges(
      node: node == _undefined || node == null
          ? _instance.node
          : (node as Fragment$MapRelationCore),
      cursor: cursor == _undefined || cursor == null
          ? _instance.cursor
          : (cursor as String),
    ),
  );

  CopyWith$Fragment$MapRelationCore<TRes> get node {
    final local$node = _instance.node;
    return CopyWith$Fragment$MapRelationCore(local$node, (e) => call(node: e));
  }
}

class _CopyWithStubImpl$Query$MapRelations$mapRelations$edges<TRes>
    implements CopyWith$Query$MapRelations$mapRelations$edges<TRes> {
  _CopyWithStubImpl$Query$MapRelations$mapRelations$edges(this._res);

  TRes _res;

  call({Fragment$MapRelationCore? node, String? cursor}) => _res;

  CopyWith$Fragment$MapRelationCore<TRes> get node =>
      CopyWith$Fragment$MapRelationCore.stub(_res);
}

class Query$MapRelations$mapRelations$pageInfo {
  Query$MapRelations$mapRelations$pageInfo({
    required this.hasNextPage,
    this.endCursor,
  });

  factory Query$MapRelations$mapRelations$pageInfo.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$hasNextPage = json['hasNextPage'];
    final l$endCursor = json['endCursor'];
    return Query$MapRelations$mapRelations$pageInfo(
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
    if (other is! Query$MapRelations$mapRelations$pageInfo ||
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

extension UtilityExtension$Query$MapRelations$mapRelations$pageInfo
    on Query$MapRelations$mapRelations$pageInfo {
  CopyWith$Query$MapRelations$mapRelations$pageInfo<
    Query$MapRelations$mapRelations$pageInfo
  >
  get copyWith =>
      CopyWith$Query$MapRelations$mapRelations$pageInfo(this, (i) => i);
}

abstract class CopyWith$Query$MapRelations$mapRelations$pageInfo<TRes> {
  factory CopyWith$Query$MapRelations$mapRelations$pageInfo(
    Query$MapRelations$mapRelations$pageInfo instance,
    TRes Function(Query$MapRelations$mapRelations$pageInfo) then,
  ) = _CopyWithImpl$Query$MapRelations$mapRelations$pageInfo;

  factory CopyWith$Query$MapRelations$mapRelations$pageInfo.stub(TRes res) =
      _CopyWithStubImpl$Query$MapRelations$mapRelations$pageInfo;

  TRes call({bool? hasNextPage, String? endCursor});
}

class _CopyWithImpl$Query$MapRelations$mapRelations$pageInfo<TRes>
    implements CopyWith$Query$MapRelations$mapRelations$pageInfo<TRes> {
  _CopyWithImpl$Query$MapRelations$mapRelations$pageInfo(
    this._instance,
    this._then,
  );

  final Query$MapRelations$mapRelations$pageInfo _instance;

  final TRes Function(Query$MapRelations$mapRelations$pageInfo) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? hasNextPage = _undefined,
    Object? endCursor = _undefined,
  }) => _then(
    Query$MapRelations$mapRelations$pageInfo(
      hasNextPage: hasNextPage == _undefined || hasNextPage == null
          ? _instance.hasNextPage
          : (hasNextPage as bool),
      endCursor: endCursor == _undefined
          ? _instance.endCursor
          : (endCursor as String?),
    ),
  );
}

class _CopyWithStubImpl$Query$MapRelations$mapRelations$pageInfo<TRes>
    implements CopyWith$Query$MapRelations$mapRelations$pageInfo<TRes> {
  _CopyWithStubImpl$Query$MapRelations$mapRelations$pageInfo(this._res);

  TRes _res;

  call({bool? hasNextPage, String? endCursor}) => _res;
}

class Variables$Mutation$CreateMapRelation {
  factory Variables$Mutation$CreateMapRelation({
    required Input$CreateMapRelationInput input,
  }) => Variables$Mutation$CreateMapRelation._({r'input': input});

  Variables$Mutation$CreateMapRelation._(this._$data);

  factory Variables$Mutation$CreateMapRelation.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    final l$input = data['input'];
    result$data['input'] = Input$CreateMapRelationInput.fromJson(
      (l$input as Map<String, dynamic>),
    );
    return Variables$Mutation$CreateMapRelation._(result$data);
  }

  Map<String, dynamic> _$data;

  Input$CreateMapRelationInput get input =>
      (_$data['input'] as Input$CreateMapRelationInput);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$input = input;
    result$data['input'] = l$input.toJson();
    return result$data;
  }

  CopyWith$Variables$Mutation$CreateMapRelation<
    Variables$Mutation$CreateMapRelation
  >
  get copyWith => CopyWith$Variables$Mutation$CreateMapRelation(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Mutation$CreateMapRelation ||
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

abstract class CopyWith$Variables$Mutation$CreateMapRelation<TRes> {
  factory CopyWith$Variables$Mutation$CreateMapRelation(
    Variables$Mutation$CreateMapRelation instance,
    TRes Function(Variables$Mutation$CreateMapRelation) then,
  ) = _CopyWithImpl$Variables$Mutation$CreateMapRelation;

  factory CopyWith$Variables$Mutation$CreateMapRelation.stub(TRes res) =
      _CopyWithStubImpl$Variables$Mutation$CreateMapRelation;

  TRes call({Input$CreateMapRelationInput? input});
}

class _CopyWithImpl$Variables$Mutation$CreateMapRelation<TRes>
    implements CopyWith$Variables$Mutation$CreateMapRelation<TRes> {
  _CopyWithImpl$Variables$Mutation$CreateMapRelation(
    this._instance,
    this._then,
  );

  final Variables$Mutation$CreateMapRelation _instance;

  final TRes Function(Variables$Mutation$CreateMapRelation) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? input = _undefined}) => _then(
    Variables$Mutation$CreateMapRelation._({
      ..._instance._$data,
      if (input != _undefined && input != null)
        'input': (input as Input$CreateMapRelationInput),
    }),
  );
}

class _CopyWithStubImpl$Variables$Mutation$CreateMapRelation<TRes>
    implements CopyWith$Variables$Mutation$CreateMapRelation<TRes> {
  _CopyWithStubImpl$Variables$Mutation$CreateMapRelation(this._res);

  TRes _res;

  call({Input$CreateMapRelationInput? input}) => _res;
}

class Mutation$CreateMapRelation {
  Mutation$CreateMapRelation({required this.createMapRelation});

  factory Mutation$CreateMapRelation.fromJson(Map<String, dynamic> json) {
    final l$createMapRelation = json['createMapRelation'];
    return Mutation$CreateMapRelation(
      createMapRelation: Mutation$CreateMapRelation$createMapRelation.fromJson(
        (l$createMapRelation as Map<String, dynamic>),
      ),
    );
  }

  final Mutation$CreateMapRelation$createMapRelation createMapRelation;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$createMapRelation = createMapRelation;
    _resultData['createMapRelation'] = l$createMapRelation.toJson();
    return _resultData;
  }

  @override
  int get hashCode {
    final l$createMapRelation = createMapRelation;
    return Object.hashAll([l$createMapRelation]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$CreateMapRelation ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$createMapRelation = createMapRelation;
    final lOther$createMapRelation = other.createMapRelation;
    if (l$createMapRelation != lOther$createMapRelation) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Mutation$CreateMapRelation
    on Mutation$CreateMapRelation {
  CopyWith$Mutation$CreateMapRelation<Mutation$CreateMapRelation>
  get copyWith => CopyWith$Mutation$CreateMapRelation(this, (i) => i);
}

abstract class CopyWith$Mutation$CreateMapRelation<TRes> {
  factory CopyWith$Mutation$CreateMapRelation(
    Mutation$CreateMapRelation instance,
    TRes Function(Mutation$CreateMapRelation) then,
  ) = _CopyWithImpl$Mutation$CreateMapRelation;

  factory CopyWith$Mutation$CreateMapRelation.stub(TRes res) =
      _CopyWithStubImpl$Mutation$CreateMapRelation;

  TRes call({Mutation$CreateMapRelation$createMapRelation? createMapRelation});
  CopyWith$Mutation$CreateMapRelation$createMapRelation<TRes>
  get createMapRelation;
}

class _CopyWithImpl$Mutation$CreateMapRelation<TRes>
    implements CopyWith$Mutation$CreateMapRelation<TRes> {
  _CopyWithImpl$Mutation$CreateMapRelation(this._instance, this._then);

  final Mutation$CreateMapRelation _instance;

  final TRes Function(Mutation$CreateMapRelation) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? createMapRelation = _undefined}) => _then(
    Mutation$CreateMapRelation(
      createMapRelation:
          createMapRelation == _undefined || createMapRelation == null
          ? _instance.createMapRelation
          : (createMapRelation as Mutation$CreateMapRelation$createMapRelation),
    ),
  );

  CopyWith$Mutation$CreateMapRelation$createMapRelation<TRes>
  get createMapRelation {
    final local$createMapRelation = _instance.createMapRelation;
    return CopyWith$Mutation$CreateMapRelation$createMapRelation(
      local$createMapRelation,
      (e) => call(createMapRelation: e),
    );
  }
}

class _CopyWithStubImpl$Mutation$CreateMapRelation<TRes>
    implements CopyWith$Mutation$CreateMapRelation<TRes> {
  _CopyWithStubImpl$Mutation$CreateMapRelation(this._res);

  TRes _res;

  call({Mutation$CreateMapRelation$createMapRelation? createMapRelation}) =>
      _res;

  CopyWith$Mutation$CreateMapRelation$createMapRelation<TRes>
  get createMapRelation =>
      CopyWith$Mutation$CreateMapRelation$createMapRelation.stub(_res);
}

const documentNodeMutationCreateMapRelation = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'CreateMapRelation'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'input')),
          type: NamedTypeNode(
            name: NameNode(value: 'CreateMapRelationInput'),
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
            name: NameNode(value: 'createMapRelation'),
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
                  name: NameNode(value: 'counterpartMemberId'),
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

class Mutation$CreateMapRelation$createMapRelation {
  Mutation$CreateMapRelation$createMapRelation({
    required this.success,
    this.counterpartMemberId,
    required this.userErrors,
  });

  factory Mutation$CreateMapRelation$createMapRelation.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$success = json['success'];
    final l$counterpartMemberId = json['counterpartMemberId'];
    final l$userErrors = json['userErrors'];
    return Mutation$CreateMapRelation$createMapRelation(
      success: (l$success as bool),
      counterpartMemberId: (l$counterpartMemberId as String?),
      userErrors: (l$userErrors as List<dynamic>)
          .map(
            (e) =>
                Mutation$CreateMapRelation$createMapRelation$userErrors.fromJson(
                  (e as Map<String, dynamic>),
                ),
          )
          .toList(),
    );
  }

  final bool success;

  final String? counterpartMemberId;

  final List<Mutation$CreateMapRelation$createMapRelation$userErrors>
  userErrors;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$success = success;
    _resultData['success'] = l$success;
    final l$counterpartMemberId = counterpartMemberId;
    _resultData['counterpartMemberId'] = l$counterpartMemberId;
    final l$userErrors = userErrors;
    _resultData['userErrors'] = l$userErrors.map((e) => e.toJson()).toList();
    return _resultData;
  }

  @override
  int get hashCode {
    final l$success = success;
    final l$counterpartMemberId = counterpartMemberId;
    final l$userErrors = userErrors;
    return Object.hashAll([
      l$success,
      l$counterpartMemberId,
      Object.hashAll(l$userErrors.map((v) => v)),
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$CreateMapRelation$createMapRelation ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$success = success;
    final lOther$success = other.success;
    if (l$success != lOther$success) {
      return false;
    }
    final l$counterpartMemberId = counterpartMemberId;
    final lOther$counterpartMemberId = other.counterpartMemberId;
    if (l$counterpartMemberId != lOther$counterpartMemberId) {
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

extension UtilityExtension$Mutation$CreateMapRelation$createMapRelation
    on Mutation$CreateMapRelation$createMapRelation {
  CopyWith$Mutation$CreateMapRelation$createMapRelation<
    Mutation$CreateMapRelation$createMapRelation
  >
  get copyWith =>
      CopyWith$Mutation$CreateMapRelation$createMapRelation(this, (i) => i);
}

abstract class CopyWith$Mutation$CreateMapRelation$createMapRelation<TRes> {
  factory CopyWith$Mutation$CreateMapRelation$createMapRelation(
    Mutation$CreateMapRelation$createMapRelation instance,
    TRes Function(Mutation$CreateMapRelation$createMapRelation) then,
  ) = _CopyWithImpl$Mutation$CreateMapRelation$createMapRelation;

  factory CopyWith$Mutation$CreateMapRelation$createMapRelation.stub(TRes res) =
      _CopyWithStubImpl$Mutation$CreateMapRelation$createMapRelation;

  TRes call({
    bool? success,
    String? counterpartMemberId,
    List<Mutation$CreateMapRelation$createMapRelation$userErrors>? userErrors,
  });
  TRes userErrors(
    Iterable<Mutation$CreateMapRelation$createMapRelation$userErrors> Function(
      Iterable<
        CopyWith$Mutation$CreateMapRelation$createMapRelation$userErrors<
          Mutation$CreateMapRelation$createMapRelation$userErrors
        >
      >,
    )
    _fn,
  );
}

class _CopyWithImpl$Mutation$CreateMapRelation$createMapRelation<TRes>
    implements CopyWith$Mutation$CreateMapRelation$createMapRelation<TRes> {
  _CopyWithImpl$Mutation$CreateMapRelation$createMapRelation(
    this._instance,
    this._then,
  );

  final Mutation$CreateMapRelation$createMapRelation _instance;

  final TRes Function(Mutation$CreateMapRelation$createMapRelation) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? success = _undefined,
    Object? counterpartMemberId = _undefined,
    Object? userErrors = _undefined,
  }) => _then(
    Mutation$CreateMapRelation$createMapRelation(
      success: success == _undefined || success == null
          ? _instance.success
          : (success as bool),
      counterpartMemberId: counterpartMemberId == _undefined
          ? _instance.counterpartMemberId
          : (counterpartMemberId as String?),
      userErrors: userErrors == _undefined || userErrors == null
          ? _instance.userErrors
          : (userErrors
                as List<
                  Mutation$CreateMapRelation$createMapRelation$userErrors
                >),
    ),
  );

  TRes userErrors(
    Iterable<Mutation$CreateMapRelation$createMapRelation$userErrors> Function(
      Iterable<
        CopyWith$Mutation$CreateMapRelation$createMapRelation$userErrors<
          Mutation$CreateMapRelation$createMapRelation$userErrors
        >
      >,
    )
    _fn,
  ) => call(
    userErrors: _fn(
      _instance.userErrors.map(
        (e) => CopyWith$Mutation$CreateMapRelation$createMapRelation$userErrors(
          e,
          (i) => i,
        ),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl$Mutation$CreateMapRelation$createMapRelation<TRes>
    implements CopyWith$Mutation$CreateMapRelation$createMapRelation<TRes> {
  _CopyWithStubImpl$Mutation$CreateMapRelation$createMapRelation(this._res);

  TRes _res;

  call({
    bool? success,
    String? counterpartMemberId,
    List<Mutation$CreateMapRelation$createMapRelation$userErrors>? userErrors,
  }) => _res;

  userErrors(_fn) => _res;
}

class Mutation$CreateMapRelation$createMapRelation$userErrors {
  Mutation$CreateMapRelation$createMapRelation$userErrors({
    required this.code,
    required this.message,
    this.field,
  });

  factory Mutation$CreateMapRelation$createMapRelation$userErrors.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$code = json['code'];
    final l$message = json['message'];
    final l$field = json['field'];
    return Mutation$CreateMapRelation$createMapRelation$userErrors(
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
    if (other is! Mutation$CreateMapRelation$createMapRelation$userErrors ||
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

extension UtilityExtension$Mutation$CreateMapRelation$createMapRelation$userErrors
    on Mutation$CreateMapRelation$createMapRelation$userErrors {
  CopyWith$Mutation$CreateMapRelation$createMapRelation$userErrors<
    Mutation$CreateMapRelation$createMapRelation$userErrors
  >
  get copyWith =>
      CopyWith$Mutation$CreateMapRelation$createMapRelation$userErrors(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Mutation$CreateMapRelation$createMapRelation$userErrors<
  TRes
> {
  factory CopyWith$Mutation$CreateMapRelation$createMapRelation$userErrors(
    Mutation$CreateMapRelation$createMapRelation$userErrors instance,
    TRes Function(Mutation$CreateMapRelation$createMapRelation$userErrors) then,
  ) = _CopyWithImpl$Mutation$CreateMapRelation$createMapRelation$userErrors;

  factory CopyWith$Mutation$CreateMapRelation$createMapRelation$userErrors.stub(
    TRes res,
  ) = _CopyWithStubImpl$Mutation$CreateMapRelation$createMapRelation$userErrors;

  TRes call({String? code, String? message, String? field});
}

class _CopyWithImpl$Mutation$CreateMapRelation$createMapRelation$userErrors<
  TRes
>
    implements
        CopyWith$Mutation$CreateMapRelation$createMapRelation$userErrors<TRes> {
  _CopyWithImpl$Mutation$CreateMapRelation$createMapRelation$userErrors(
    this._instance,
    this._then,
  );

  final Mutation$CreateMapRelation$createMapRelation$userErrors _instance;

  final TRes Function(Mutation$CreateMapRelation$createMapRelation$userErrors)
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? code = _undefined,
    Object? message = _undefined,
    Object? field = _undefined,
  }) => _then(
    Mutation$CreateMapRelation$createMapRelation$userErrors(
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

class _CopyWithStubImpl$Mutation$CreateMapRelation$createMapRelation$userErrors<
  TRes
>
    implements
        CopyWith$Mutation$CreateMapRelation$createMapRelation$userErrors<TRes> {
  _CopyWithStubImpl$Mutation$CreateMapRelation$createMapRelation$userErrors(
    this._res,
  );

  TRes _res;

  call({String? code, String? message, String? field}) => _res;
}

class Variables$Mutation$RemoveMapRelation {
  factory Variables$Mutation$RemoveMapRelation({
    required Input$RemoveMapRelationInput input,
  }) => Variables$Mutation$RemoveMapRelation._({r'input': input});

  Variables$Mutation$RemoveMapRelation._(this._$data);

  factory Variables$Mutation$RemoveMapRelation.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    final l$input = data['input'];
    result$data['input'] = Input$RemoveMapRelationInput.fromJson(
      (l$input as Map<String, dynamic>),
    );
    return Variables$Mutation$RemoveMapRelation._(result$data);
  }

  Map<String, dynamic> _$data;

  Input$RemoveMapRelationInput get input =>
      (_$data['input'] as Input$RemoveMapRelationInput);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$input = input;
    result$data['input'] = l$input.toJson();
    return result$data;
  }

  CopyWith$Variables$Mutation$RemoveMapRelation<
    Variables$Mutation$RemoveMapRelation
  >
  get copyWith => CopyWith$Variables$Mutation$RemoveMapRelation(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Mutation$RemoveMapRelation ||
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

abstract class CopyWith$Variables$Mutation$RemoveMapRelation<TRes> {
  factory CopyWith$Variables$Mutation$RemoveMapRelation(
    Variables$Mutation$RemoveMapRelation instance,
    TRes Function(Variables$Mutation$RemoveMapRelation) then,
  ) = _CopyWithImpl$Variables$Mutation$RemoveMapRelation;

  factory CopyWith$Variables$Mutation$RemoveMapRelation.stub(TRes res) =
      _CopyWithStubImpl$Variables$Mutation$RemoveMapRelation;

  TRes call({Input$RemoveMapRelationInput? input});
}

class _CopyWithImpl$Variables$Mutation$RemoveMapRelation<TRes>
    implements CopyWith$Variables$Mutation$RemoveMapRelation<TRes> {
  _CopyWithImpl$Variables$Mutation$RemoveMapRelation(
    this._instance,
    this._then,
  );

  final Variables$Mutation$RemoveMapRelation _instance;

  final TRes Function(Variables$Mutation$RemoveMapRelation) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? input = _undefined}) => _then(
    Variables$Mutation$RemoveMapRelation._({
      ..._instance._$data,
      if (input != _undefined && input != null)
        'input': (input as Input$RemoveMapRelationInput),
    }),
  );
}

class _CopyWithStubImpl$Variables$Mutation$RemoveMapRelation<TRes>
    implements CopyWith$Variables$Mutation$RemoveMapRelation<TRes> {
  _CopyWithStubImpl$Variables$Mutation$RemoveMapRelation(this._res);

  TRes _res;

  call({Input$RemoveMapRelationInput? input}) => _res;
}

class Mutation$RemoveMapRelation {
  Mutation$RemoveMapRelation({required this.removeMapRelation});

  factory Mutation$RemoveMapRelation.fromJson(Map<String, dynamic> json) {
    final l$removeMapRelation = json['removeMapRelation'];
    return Mutation$RemoveMapRelation(
      removeMapRelation: Mutation$RemoveMapRelation$removeMapRelation.fromJson(
        (l$removeMapRelation as Map<String, dynamic>),
      ),
    );
  }

  final Mutation$RemoveMapRelation$removeMapRelation removeMapRelation;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$removeMapRelation = removeMapRelation;
    _resultData['removeMapRelation'] = l$removeMapRelation.toJson();
    return _resultData;
  }

  @override
  int get hashCode {
    final l$removeMapRelation = removeMapRelation;
    return Object.hashAll([l$removeMapRelation]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$RemoveMapRelation ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$removeMapRelation = removeMapRelation;
    final lOther$removeMapRelation = other.removeMapRelation;
    if (l$removeMapRelation != lOther$removeMapRelation) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Mutation$RemoveMapRelation
    on Mutation$RemoveMapRelation {
  CopyWith$Mutation$RemoveMapRelation<Mutation$RemoveMapRelation>
  get copyWith => CopyWith$Mutation$RemoveMapRelation(this, (i) => i);
}

abstract class CopyWith$Mutation$RemoveMapRelation<TRes> {
  factory CopyWith$Mutation$RemoveMapRelation(
    Mutation$RemoveMapRelation instance,
    TRes Function(Mutation$RemoveMapRelation) then,
  ) = _CopyWithImpl$Mutation$RemoveMapRelation;

  factory CopyWith$Mutation$RemoveMapRelation.stub(TRes res) =
      _CopyWithStubImpl$Mutation$RemoveMapRelation;

  TRes call({Mutation$RemoveMapRelation$removeMapRelation? removeMapRelation});
  CopyWith$Mutation$RemoveMapRelation$removeMapRelation<TRes>
  get removeMapRelation;
}

class _CopyWithImpl$Mutation$RemoveMapRelation<TRes>
    implements CopyWith$Mutation$RemoveMapRelation<TRes> {
  _CopyWithImpl$Mutation$RemoveMapRelation(this._instance, this._then);

  final Mutation$RemoveMapRelation _instance;

  final TRes Function(Mutation$RemoveMapRelation) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? removeMapRelation = _undefined}) => _then(
    Mutation$RemoveMapRelation(
      removeMapRelation:
          removeMapRelation == _undefined || removeMapRelation == null
          ? _instance.removeMapRelation
          : (removeMapRelation as Mutation$RemoveMapRelation$removeMapRelation),
    ),
  );

  CopyWith$Mutation$RemoveMapRelation$removeMapRelation<TRes>
  get removeMapRelation {
    final local$removeMapRelation = _instance.removeMapRelation;
    return CopyWith$Mutation$RemoveMapRelation$removeMapRelation(
      local$removeMapRelation,
      (e) => call(removeMapRelation: e),
    );
  }
}

class _CopyWithStubImpl$Mutation$RemoveMapRelation<TRes>
    implements CopyWith$Mutation$RemoveMapRelation<TRes> {
  _CopyWithStubImpl$Mutation$RemoveMapRelation(this._res);

  TRes _res;

  call({Mutation$RemoveMapRelation$removeMapRelation? removeMapRelation}) =>
      _res;

  CopyWith$Mutation$RemoveMapRelation$removeMapRelation<TRes>
  get removeMapRelation =>
      CopyWith$Mutation$RemoveMapRelation$removeMapRelation.stub(_res);
}

const documentNodeMutationRemoveMapRelation = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'RemoveMapRelation'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'input')),
          type: NamedTypeNode(
            name: NameNode(value: 'RemoveMapRelationInput'),
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
            name: NameNode(value: 'removeMapRelation'),
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

class Mutation$RemoveMapRelation$removeMapRelation {
  Mutation$RemoveMapRelation$removeMapRelation({
    required this.success,
    required this.userErrors,
  });

  factory Mutation$RemoveMapRelation$removeMapRelation.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$success = json['success'];
    final l$userErrors = json['userErrors'];
    return Mutation$RemoveMapRelation$removeMapRelation(
      success: (l$success as bool),
      userErrors: (l$userErrors as List<dynamic>)
          .map(
            (e) =>
                Mutation$RemoveMapRelation$removeMapRelation$userErrors.fromJson(
                  (e as Map<String, dynamic>),
                ),
          )
          .toList(),
    );
  }

  final bool success;

  final List<Mutation$RemoveMapRelation$removeMapRelation$userErrors>
  userErrors;

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
    if (other is! Mutation$RemoveMapRelation$removeMapRelation ||
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

extension UtilityExtension$Mutation$RemoveMapRelation$removeMapRelation
    on Mutation$RemoveMapRelation$removeMapRelation {
  CopyWith$Mutation$RemoveMapRelation$removeMapRelation<
    Mutation$RemoveMapRelation$removeMapRelation
  >
  get copyWith =>
      CopyWith$Mutation$RemoveMapRelation$removeMapRelation(this, (i) => i);
}

abstract class CopyWith$Mutation$RemoveMapRelation$removeMapRelation<TRes> {
  factory CopyWith$Mutation$RemoveMapRelation$removeMapRelation(
    Mutation$RemoveMapRelation$removeMapRelation instance,
    TRes Function(Mutation$RemoveMapRelation$removeMapRelation) then,
  ) = _CopyWithImpl$Mutation$RemoveMapRelation$removeMapRelation;

  factory CopyWith$Mutation$RemoveMapRelation$removeMapRelation.stub(TRes res) =
      _CopyWithStubImpl$Mutation$RemoveMapRelation$removeMapRelation;

  TRes call({
    bool? success,
    List<Mutation$RemoveMapRelation$removeMapRelation$userErrors>? userErrors,
  });
  TRes userErrors(
    Iterable<Mutation$RemoveMapRelation$removeMapRelation$userErrors> Function(
      Iterable<
        CopyWith$Mutation$RemoveMapRelation$removeMapRelation$userErrors<
          Mutation$RemoveMapRelation$removeMapRelation$userErrors
        >
      >,
    )
    _fn,
  );
}

class _CopyWithImpl$Mutation$RemoveMapRelation$removeMapRelation<TRes>
    implements CopyWith$Mutation$RemoveMapRelation$removeMapRelation<TRes> {
  _CopyWithImpl$Mutation$RemoveMapRelation$removeMapRelation(
    this._instance,
    this._then,
  );

  final Mutation$RemoveMapRelation$removeMapRelation _instance;

  final TRes Function(Mutation$RemoveMapRelation$removeMapRelation) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? success = _undefined, Object? userErrors = _undefined}) =>
      _then(
        Mutation$RemoveMapRelation$removeMapRelation(
          success: success == _undefined || success == null
              ? _instance.success
              : (success as bool),
          userErrors: userErrors == _undefined || userErrors == null
              ? _instance.userErrors
              : (userErrors
                    as List<
                      Mutation$RemoveMapRelation$removeMapRelation$userErrors
                    >),
        ),
      );

  TRes userErrors(
    Iterable<Mutation$RemoveMapRelation$removeMapRelation$userErrors> Function(
      Iterable<
        CopyWith$Mutation$RemoveMapRelation$removeMapRelation$userErrors<
          Mutation$RemoveMapRelation$removeMapRelation$userErrors
        >
      >,
    )
    _fn,
  ) => call(
    userErrors: _fn(
      _instance.userErrors.map(
        (e) => CopyWith$Mutation$RemoveMapRelation$removeMapRelation$userErrors(
          e,
          (i) => i,
        ),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl$Mutation$RemoveMapRelation$removeMapRelation<TRes>
    implements CopyWith$Mutation$RemoveMapRelation$removeMapRelation<TRes> {
  _CopyWithStubImpl$Mutation$RemoveMapRelation$removeMapRelation(this._res);

  TRes _res;

  call({
    bool? success,
    List<Mutation$RemoveMapRelation$removeMapRelation$userErrors>? userErrors,
  }) => _res;

  userErrors(_fn) => _res;
}

class Mutation$RemoveMapRelation$removeMapRelation$userErrors {
  Mutation$RemoveMapRelation$removeMapRelation$userErrors({
    required this.code,
    required this.message,
    this.field,
  });

  factory Mutation$RemoveMapRelation$removeMapRelation$userErrors.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$code = json['code'];
    final l$message = json['message'];
    final l$field = json['field'];
    return Mutation$RemoveMapRelation$removeMapRelation$userErrors(
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
    if (other is! Mutation$RemoveMapRelation$removeMapRelation$userErrors ||
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

extension UtilityExtension$Mutation$RemoveMapRelation$removeMapRelation$userErrors
    on Mutation$RemoveMapRelation$removeMapRelation$userErrors {
  CopyWith$Mutation$RemoveMapRelation$removeMapRelation$userErrors<
    Mutation$RemoveMapRelation$removeMapRelation$userErrors
  >
  get copyWith =>
      CopyWith$Mutation$RemoveMapRelation$removeMapRelation$userErrors(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Mutation$RemoveMapRelation$removeMapRelation$userErrors<
  TRes
> {
  factory CopyWith$Mutation$RemoveMapRelation$removeMapRelation$userErrors(
    Mutation$RemoveMapRelation$removeMapRelation$userErrors instance,
    TRes Function(Mutation$RemoveMapRelation$removeMapRelation$userErrors) then,
  ) = _CopyWithImpl$Mutation$RemoveMapRelation$removeMapRelation$userErrors;

  factory CopyWith$Mutation$RemoveMapRelation$removeMapRelation$userErrors.stub(
    TRes res,
  ) = _CopyWithStubImpl$Mutation$RemoveMapRelation$removeMapRelation$userErrors;

  TRes call({String? code, String? message, String? field});
}

class _CopyWithImpl$Mutation$RemoveMapRelation$removeMapRelation$userErrors<
  TRes
>
    implements
        CopyWith$Mutation$RemoveMapRelation$removeMapRelation$userErrors<TRes> {
  _CopyWithImpl$Mutation$RemoveMapRelation$removeMapRelation$userErrors(
    this._instance,
    this._then,
  );

  final Mutation$RemoveMapRelation$removeMapRelation$userErrors _instance;

  final TRes Function(Mutation$RemoveMapRelation$removeMapRelation$userErrors)
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? code = _undefined,
    Object? message = _undefined,
    Object? field = _undefined,
  }) => _then(
    Mutation$RemoveMapRelation$removeMapRelation$userErrors(
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

class _CopyWithStubImpl$Mutation$RemoveMapRelation$removeMapRelation$userErrors<
  TRes
>
    implements
        CopyWith$Mutation$RemoveMapRelation$removeMapRelation$userErrors<TRes> {
  _CopyWithStubImpl$Mutation$RemoveMapRelation$removeMapRelation$userErrors(
    this._res,
  );

  TRes _res;

  call({String? code, String? message, String? field}) => _res;
}

class Variables$Mutation$RecordVisits {
  factory Variables$Mutation$RecordVisits({
    required Input$RecordVisitsInput input,
  }) => Variables$Mutation$RecordVisits._({r'input': input});

  Variables$Mutation$RecordVisits._(this._$data);

  factory Variables$Mutation$RecordVisits.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$input = data['input'];
    result$data['input'] = Input$RecordVisitsInput.fromJson(
      (l$input as Map<String, dynamic>),
    );
    return Variables$Mutation$RecordVisits._(result$data);
  }

  Map<String, dynamic> _$data;

  Input$RecordVisitsInput get input =>
      (_$data['input'] as Input$RecordVisitsInput);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$input = input;
    result$data['input'] = l$input.toJson();
    return result$data;
  }

  CopyWith$Variables$Mutation$RecordVisits<Variables$Mutation$RecordVisits>
  get copyWith => CopyWith$Variables$Mutation$RecordVisits(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Mutation$RecordVisits ||
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

abstract class CopyWith$Variables$Mutation$RecordVisits<TRes> {
  factory CopyWith$Variables$Mutation$RecordVisits(
    Variables$Mutation$RecordVisits instance,
    TRes Function(Variables$Mutation$RecordVisits) then,
  ) = _CopyWithImpl$Variables$Mutation$RecordVisits;

  factory CopyWith$Variables$Mutation$RecordVisits.stub(TRes res) =
      _CopyWithStubImpl$Variables$Mutation$RecordVisits;

  TRes call({Input$RecordVisitsInput? input});
}

class _CopyWithImpl$Variables$Mutation$RecordVisits<TRes>
    implements CopyWith$Variables$Mutation$RecordVisits<TRes> {
  _CopyWithImpl$Variables$Mutation$RecordVisits(this._instance, this._then);

  final Variables$Mutation$RecordVisits _instance;

  final TRes Function(Variables$Mutation$RecordVisits) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? input = _undefined}) => _then(
    Variables$Mutation$RecordVisits._({
      ..._instance._$data,
      if (input != _undefined && input != null)
        'input': (input as Input$RecordVisitsInput),
    }),
  );
}

class _CopyWithStubImpl$Variables$Mutation$RecordVisits<TRes>
    implements CopyWith$Variables$Mutation$RecordVisits<TRes> {
  _CopyWithStubImpl$Variables$Mutation$RecordVisits(this._res);

  TRes _res;

  call({Input$RecordVisitsInput? input}) => _res;
}

class Mutation$RecordVisits {
  Mutation$RecordVisits({required this.recordVisits});

  factory Mutation$RecordVisits.fromJson(Map<String, dynamic> json) {
    final l$recordVisits = json['recordVisits'];
    return Mutation$RecordVisits(
      recordVisits: Mutation$RecordVisits$recordVisits.fromJson(
        (l$recordVisits as Map<String, dynamic>),
      ),
    );
  }

  final Mutation$RecordVisits$recordVisits recordVisits;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$recordVisits = recordVisits;
    _resultData['recordVisits'] = l$recordVisits.toJson();
    return _resultData;
  }

  @override
  int get hashCode {
    final l$recordVisits = recordVisits;
    return Object.hashAll([l$recordVisits]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$RecordVisits || runtimeType != other.runtimeType) {
      return false;
    }
    final l$recordVisits = recordVisits;
    final lOther$recordVisits = other.recordVisits;
    if (l$recordVisits != lOther$recordVisits) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Mutation$RecordVisits on Mutation$RecordVisits {
  CopyWith$Mutation$RecordVisits<Mutation$RecordVisits> get copyWith =>
      CopyWith$Mutation$RecordVisits(this, (i) => i);
}

abstract class CopyWith$Mutation$RecordVisits<TRes> {
  factory CopyWith$Mutation$RecordVisits(
    Mutation$RecordVisits instance,
    TRes Function(Mutation$RecordVisits) then,
  ) = _CopyWithImpl$Mutation$RecordVisits;

  factory CopyWith$Mutation$RecordVisits.stub(TRes res) =
      _CopyWithStubImpl$Mutation$RecordVisits;

  TRes call({Mutation$RecordVisits$recordVisits? recordVisits});
  CopyWith$Mutation$RecordVisits$recordVisits<TRes> get recordVisits;
}

class _CopyWithImpl$Mutation$RecordVisits<TRes>
    implements CopyWith$Mutation$RecordVisits<TRes> {
  _CopyWithImpl$Mutation$RecordVisits(this._instance, this._then);

  final Mutation$RecordVisits _instance;

  final TRes Function(Mutation$RecordVisits) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? recordVisits = _undefined}) => _then(
    Mutation$RecordVisits(
      recordVisits: recordVisits == _undefined || recordVisits == null
          ? _instance.recordVisits
          : (recordVisits as Mutation$RecordVisits$recordVisits),
    ),
  );

  CopyWith$Mutation$RecordVisits$recordVisits<TRes> get recordVisits {
    final local$recordVisits = _instance.recordVisits;
    return CopyWith$Mutation$RecordVisits$recordVisits(
      local$recordVisits,
      (e) => call(recordVisits: e),
    );
  }
}

class _CopyWithStubImpl$Mutation$RecordVisits<TRes>
    implements CopyWith$Mutation$RecordVisits<TRes> {
  _CopyWithStubImpl$Mutation$RecordVisits(this._res);

  TRes _res;

  call({Mutation$RecordVisits$recordVisits? recordVisits}) => _res;

  CopyWith$Mutation$RecordVisits$recordVisits<TRes> get recordVisits =>
      CopyWith$Mutation$RecordVisits$recordVisits.stub(_res);
}

const documentNodeMutationRecordVisits = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'RecordVisits'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'input')),
          type: NamedTypeNode(
            name: NameNode(value: 'RecordVisitsInput'),
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
            name: NameNode(value: 'recordVisits'),
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
                FieldNode(
                  name: NameNode(value: 'updatedCells'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: SelectionSetNode(
                    selections: [
                      FragmentSpreadNode(
                        name: NameNode(value: 'MapCellCore'),
                        directives: [],
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
    fragmentDefinitionMapCellCore,
  ],
);

class Mutation$RecordVisits$recordVisits {
  Mutation$RecordVisits$recordVisits({
    required this.success,
    required this.userErrors,
    required this.updatedCells,
  });

  factory Mutation$RecordVisits$recordVisits.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$success = json['success'];
    final l$userErrors = json['userErrors'];
    final l$updatedCells = json['updatedCells'];
    return Mutation$RecordVisits$recordVisits(
      success: (l$success as bool),
      userErrors: (l$userErrors as List<dynamic>)
          .map(
            (e) => Mutation$RecordVisits$recordVisits$userErrors.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      updatedCells: (l$updatedCells as List<dynamic>)
          .map(
            (e) => Fragment$MapCellCore.fromJson((e as Map<String, dynamic>)),
          )
          .toList(),
    );
  }

  final bool success;

  final List<Mutation$RecordVisits$recordVisits$userErrors> userErrors;

  final List<Fragment$MapCellCore> updatedCells;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$success = success;
    _resultData['success'] = l$success;
    final l$userErrors = userErrors;
    _resultData['userErrors'] = l$userErrors.map((e) => e.toJson()).toList();
    final l$updatedCells = updatedCells;
    _resultData['updatedCells'] = l$updatedCells
        .map((e) => e.toJson())
        .toList();
    return _resultData;
  }

  @override
  int get hashCode {
    final l$success = success;
    final l$userErrors = userErrors;
    final l$updatedCells = updatedCells;
    return Object.hashAll([
      l$success,
      Object.hashAll(l$userErrors.map((v) => v)),
      Object.hashAll(l$updatedCells.map((v) => v)),
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$RecordVisits$recordVisits ||
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
    final l$updatedCells = updatedCells;
    final lOther$updatedCells = other.updatedCells;
    if (l$updatedCells.length != lOther$updatedCells.length) {
      return false;
    }
    for (int i = 0; i < l$updatedCells.length; i++) {
      final l$updatedCells$entry = l$updatedCells[i];
      final lOther$updatedCells$entry = lOther$updatedCells[i];
      if (l$updatedCells$entry != lOther$updatedCells$entry) {
        return false;
      }
    }
    return true;
  }
}

extension UtilityExtension$Mutation$RecordVisits$recordVisits
    on Mutation$RecordVisits$recordVisits {
  CopyWith$Mutation$RecordVisits$recordVisits<
    Mutation$RecordVisits$recordVisits
  >
  get copyWith => CopyWith$Mutation$RecordVisits$recordVisits(this, (i) => i);
}

abstract class CopyWith$Mutation$RecordVisits$recordVisits<TRes> {
  factory CopyWith$Mutation$RecordVisits$recordVisits(
    Mutation$RecordVisits$recordVisits instance,
    TRes Function(Mutation$RecordVisits$recordVisits) then,
  ) = _CopyWithImpl$Mutation$RecordVisits$recordVisits;

  factory CopyWith$Mutation$RecordVisits$recordVisits.stub(TRes res) =
      _CopyWithStubImpl$Mutation$RecordVisits$recordVisits;

  TRes call({
    bool? success,
    List<Mutation$RecordVisits$recordVisits$userErrors>? userErrors,
    List<Fragment$MapCellCore>? updatedCells,
  });
  TRes userErrors(
    Iterable<Mutation$RecordVisits$recordVisits$userErrors> Function(
      Iterable<
        CopyWith$Mutation$RecordVisits$recordVisits$userErrors<
          Mutation$RecordVisits$recordVisits$userErrors
        >
      >,
    )
    _fn,
  );
  TRes updatedCells(
    Iterable<Fragment$MapCellCore> Function(
      Iterable<CopyWith$Fragment$MapCellCore<Fragment$MapCellCore>>,
    )
    _fn,
  );
}

class _CopyWithImpl$Mutation$RecordVisits$recordVisits<TRes>
    implements CopyWith$Mutation$RecordVisits$recordVisits<TRes> {
  _CopyWithImpl$Mutation$RecordVisits$recordVisits(this._instance, this._then);

  final Mutation$RecordVisits$recordVisits _instance;

  final TRes Function(Mutation$RecordVisits$recordVisits) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? success = _undefined,
    Object? userErrors = _undefined,
    Object? updatedCells = _undefined,
  }) => _then(
    Mutation$RecordVisits$recordVisits(
      success: success == _undefined || success == null
          ? _instance.success
          : (success as bool),
      userErrors: userErrors == _undefined || userErrors == null
          ? _instance.userErrors
          : (userErrors as List<Mutation$RecordVisits$recordVisits$userErrors>),
      updatedCells: updatedCells == _undefined || updatedCells == null
          ? _instance.updatedCells
          : (updatedCells as List<Fragment$MapCellCore>),
    ),
  );

  TRes userErrors(
    Iterable<Mutation$RecordVisits$recordVisits$userErrors> Function(
      Iterable<
        CopyWith$Mutation$RecordVisits$recordVisits$userErrors<
          Mutation$RecordVisits$recordVisits$userErrors
        >
      >,
    )
    _fn,
  ) => call(
    userErrors: _fn(
      _instance.userErrors.map(
        (e) =>
            CopyWith$Mutation$RecordVisits$recordVisits$userErrors(e, (i) => i),
      ),
    ).toList(),
  );

  TRes updatedCells(
    Iterable<Fragment$MapCellCore> Function(
      Iterable<CopyWith$Fragment$MapCellCore<Fragment$MapCellCore>>,
    )
    _fn,
  ) => call(
    updatedCells: _fn(
      _instance.updatedCells.map(
        (e) => CopyWith$Fragment$MapCellCore(e, (i) => i),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl$Mutation$RecordVisits$recordVisits<TRes>
    implements CopyWith$Mutation$RecordVisits$recordVisits<TRes> {
  _CopyWithStubImpl$Mutation$RecordVisits$recordVisits(this._res);

  TRes _res;

  call({
    bool? success,
    List<Mutation$RecordVisits$recordVisits$userErrors>? userErrors,
    List<Fragment$MapCellCore>? updatedCells,
  }) => _res;

  userErrors(_fn) => _res;

  updatedCells(_fn) => _res;
}

class Mutation$RecordVisits$recordVisits$userErrors {
  Mutation$RecordVisits$recordVisits$userErrors({
    required this.code,
    required this.message,
    this.field,
  });

  factory Mutation$RecordVisits$recordVisits$userErrors.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$code = json['code'];
    final l$message = json['message'];
    final l$field = json['field'];
    return Mutation$RecordVisits$recordVisits$userErrors(
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
    if (other is! Mutation$RecordVisits$recordVisits$userErrors ||
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

extension UtilityExtension$Mutation$RecordVisits$recordVisits$userErrors
    on Mutation$RecordVisits$recordVisits$userErrors {
  CopyWith$Mutation$RecordVisits$recordVisits$userErrors<
    Mutation$RecordVisits$recordVisits$userErrors
  >
  get copyWith =>
      CopyWith$Mutation$RecordVisits$recordVisits$userErrors(this, (i) => i);
}

abstract class CopyWith$Mutation$RecordVisits$recordVisits$userErrors<TRes> {
  factory CopyWith$Mutation$RecordVisits$recordVisits$userErrors(
    Mutation$RecordVisits$recordVisits$userErrors instance,
    TRes Function(Mutation$RecordVisits$recordVisits$userErrors) then,
  ) = _CopyWithImpl$Mutation$RecordVisits$recordVisits$userErrors;

  factory CopyWith$Mutation$RecordVisits$recordVisits$userErrors.stub(
    TRes res,
  ) = _CopyWithStubImpl$Mutation$RecordVisits$recordVisits$userErrors;

  TRes call({String? code, String? message, String? field});
}

class _CopyWithImpl$Mutation$RecordVisits$recordVisits$userErrors<TRes>
    implements CopyWith$Mutation$RecordVisits$recordVisits$userErrors<TRes> {
  _CopyWithImpl$Mutation$RecordVisits$recordVisits$userErrors(
    this._instance,
    this._then,
  );

  final Mutation$RecordVisits$recordVisits$userErrors _instance;

  final TRes Function(Mutation$RecordVisits$recordVisits$userErrors) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? code = _undefined,
    Object? message = _undefined,
    Object? field = _undefined,
  }) => _then(
    Mutation$RecordVisits$recordVisits$userErrors(
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

class _CopyWithStubImpl$Mutation$RecordVisits$recordVisits$userErrors<TRes>
    implements CopyWith$Mutation$RecordVisits$recordVisits$userErrors<TRes> {
  _CopyWithStubImpl$Mutation$RecordVisits$recordVisits$userErrors(this._res);

  TRes _res;

  call({String? code, String? message, String? field}) => _res;
}

class Variables$Mutation$RemoveVisit {
  factory Variables$Mutation$RemoveVisit({
    required Input$RemoveVisitInput input,
  }) => Variables$Mutation$RemoveVisit._({r'input': input});

  Variables$Mutation$RemoveVisit._(this._$data);

  factory Variables$Mutation$RemoveVisit.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$input = data['input'];
    result$data['input'] = Input$RemoveVisitInput.fromJson(
      (l$input as Map<String, dynamic>),
    );
    return Variables$Mutation$RemoveVisit._(result$data);
  }

  Map<String, dynamic> _$data;

  Input$RemoveVisitInput get input =>
      (_$data['input'] as Input$RemoveVisitInput);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$input = input;
    result$data['input'] = l$input.toJson();
    return result$data;
  }

  CopyWith$Variables$Mutation$RemoveVisit<Variables$Mutation$RemoveVisit>
  get copyWith => CopyWith$Variables$Mutation$RemoveVisit(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Mutation$RemoveVisit ||
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

abstract class CopyWith$Variables$Mutation$RemoveVisit<TRes> {
  factory CopyWith$Variables$Mutation$RemoveVisit(
    Variables$Mutation$RemoveVisit instance,
    TRes Function(Variables$Mutation$RemoveVisit) then,
  ) = _CopyWithImpl$Variables$Mutation$RemoveVisit;

  factory CopyWith$Variables$Mutation$RemoveVisit.stub(TRes res) =
      _CopyWithStubImpl$Variables$Mutation$RemoveVisit;

  TRes call({Input$RemoveVisitInput? input});
}

class _CopyWithImpl$Variables$Mutation$RemoveVisit<TRes>
    implements CopyWith$Variables$Mutation$RemoveVisit<TRes> {
  _CopyWithImpl$Variables$Mutation$RemoveVisit(this._instance, this._then);

  final Variables$Mutation$RemoveVisit _instance;

  final TRes Function(Variables$Mutation$RemoveVisit) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? input = _undefined}) => _then(
    Variables$Mutation$RemoveVisit._({
      ..._instance._$data,
      if (input != _undefined && input != null)
        'input': (input as Input$RemoveVisitInput),
    }),
  );
}

class _CopyWithStubImpl$Variables$Mutation$RemoveVisit<TRes>
    implements CopyWith$Variables$Mutation$RemoveVisit<TRes> {
  _CopyWithStubImpl$Variables$Mutation$RemoveVisit(this._res);

  TRes _res;

  call({Input$RemoveVisitInput? input}) => _res;
}

class Mutation$RemoveVisit {
  Mutation$RemoveVisit({required this.removeVisit});

  factory Mutation$RemoveVisit.fromJson(Map<String, dynamic> json) {
    final l$removeVisit = json['removeVisit'];
    return Mutation$RemoveVisit(
      removeVisit: Mutation$RemoveVisit$removeVisit.fromJson(
        (l$removeVisit as Map<String, dynamic>),
      ),
    );
  }

  final Mutation$RemoveVisit$removeVisit removeVisit;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$removeVisit = removeVisit;
    _resultData['removeVisit'] = l$removeVisit.toJson();
    return _resultData;
  }

  @override
  int get hashCode {
    final l$removeVisit = removeVisit;
    return Object.hashAll([l$removeVisit]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$RemoveVisit || runtimeType != other.runtimeType) {
      return false;
    }
    final l$removeVisit = removeVisit;
    final lOther$removeVisit = other.removeVisit;
    if (l$removeVisit != lOther$removeVisit) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Mutation$RemoveVisit on Mutation$RemoveVisit {
  CopyWith$Mutation$RemoveVisit<Mutation$RemoveVisit> get copyWith =>
      CopyWith$Mutation$RemoveVisit(this, (i) => i);
}

abstract class CopyWith$Mutation$RemoveVisit<TRes> {
  factory CopyWith$Mutation$RemoveVisit(
    Mutation$RemoveVisit instance,
    TRes Function(Mutation$RemoveVisit) then,
  ) = _CopyWithImpl$Mutation$RemoveVisit;

  factory CopyWith$Mutation$RemoveVisit.stub(TRes res) =
      _CopyWithStubImpl$Mutation$RemoveVisit;

  TRes call({Mutation$RemoveVisit$removeVisit? removeVisit});
  CopyWith$Mutation$RemoveVisit$removeVisit<TRes> get removeVisit;
}

class _CopyWithImpl$Mutation$RemoveVisit<TRes>
    implements CopyWith$Mutation$RemoveVisit<TRes> {
  _CopyWithImpl$Mutation$RemoveVisit(this._instance, this._then);

  final Mutation$RemoveVisit _instance;

  final TRes Function(Mutation$RemoveVisit) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? removeVisit = _undefined}) => _then(
    Mutation$RemoveVisit(
      removeVisit: removeVisit == _undefined || removeVisit == null
          ? _instance.removeVisit
          : (removeVisit as Mutation$RemoveVisit$removeVisit),
    ),
  );

  CopyWith$Mutation$RemoveVisit$removeVisit<TRes> get removeVisit {
    final local$removeVisit = _instance.removeVisit;
    return CopyWith$Mutation$RemoveVisit$removeVisit(
      local$removeVisit,
      (e) => call(removeVisit: e),
    );
  }
}

class _CopyWithStubImpl$Mutation$RemoveVisit<TRes>
    implements CopyWith$Mutation$RemoveVisit<TRes> {
  _CopyWithStubImpl$Mutation$RemoveVisit(this._res);

  TRes _res;

  call({Mutation$RemoveVisit$removeVisit? removeVisit}) => _res;

  CopyWith$Mutation$RemoveVisit$removeVisit<TRes> get removeVisit =>
      CopyWith$Mutation$RemoveVisit$removeVisit.stub(_res);
}

const documentNodeMutationRemoveVisit = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'RemoveVisit'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'input')),
          type: NamedTypeNode(
            name: NameNode(value: 'RemoveVisitInput'),
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
            name: NameNode(value: 'removeVisit'),
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
                FieldNode(
                  name: NameNode(value: 'updatedCell'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: SelectionSetNode(
                    selections: [
                      FragmentSpreadNode(
                        name: NameNode(value: 'MapCellCore'),
                        directives: [],
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
    fragmentDefinitionMapCellCore,
  ],
);

class Mutation$RemoveVisit$removeVisit {
  Mutation$RemoveVisit$removeVisit({
    required this.success,
    required this.userErrors,
    this.updatedCell,
  });

  factory Mutation$RemoveVisit$removeVisit.fromJson(Map<String, dynamic> json) {
    final l$success = json['success'];
    final l$userErrors = json['userErrors'];
    final l$updatedCell = json['updatedCell'];
    return Mutation$RemoveVisit$removeVisit(
      success: (l$success as bool),
      userErrors: (l$userErrors as List<dynamic>)
          .map(
            (e) => Mutation$RemoveVisit$removeVisit$userErrors.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      updatedCell: l$updatedCell == null
          ? null
          : Fragment$MapCellCore.fromJson(
              (l$updatedCell as Map<String, dynamic>),
            ),
    );
  }

  final bool success;

  final List<Mutation$RemoveVisit$removeVisit$userErrors> userErrors;

  final Fragment$MapCellCore? updatedCell;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$success = success;
    _resultData['success'] = l$success;
    final l$userErrors = userErrors;
    _resultData['userErrors'] = l$userErrors.map((e) => e.toJson()).toList();
    final l$updatedCell = updatedCell;
    _resultData['updatedCell'] = l$updatedCell?.toJson();
    return _resultData;
  }

  @override
  int get hashCode {
    final l$success = success;
    final l$userErrors = userErrors;
    final l$updatedCell = updatedCell;
    return Object.hashAll([
      l$success,
      Object.hashAll(l$userErrors.map((v) => v)),
      l$updatedCell,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$RemoveVisit$removeVisit ||
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
    final l$updatedCell = updatedCell;
    final lOther$updatedCell = other.updatedCell;
    if (l$updatedCell != lOther$updatedCell) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Mutation$RemoveVisit$removeVisit
    on Mutation$RemoveVisit$removeVisit {
  CopyWith$Mutation$RemoveVisit$removeVisit<Mutation$RemoveVisit$removeVisit>
  get copyWith => CopyWith$Mutation$RemoveVisit$removeVisit(this, (i) => i);
}

abstract class CopyWith$Mutation$RemoveVisit$removeVisit<TRes> {
  factory CopyWith$Mutation$RemoveVisit$removeVisit(
    Mutation$RemoveVisit$removeVisit instance,
    TRes Function(Mutation$RemoveVisit$removeVisit) then,
  ) = _CopyWithImpl$Mutation$RemoveVisit$removeVisit;

  factory CopyWith$Mutation$RemoveVisit$removeVisit.stub(TRes res) =
      _CopyWithStubImpl$Mutation$RemoveVisit$removeVisit;

  TRes call({
    bool? success,
    List<Mutation$RemoveVisit$removeVisit$userErrors>? userErrors,
    Fragment$MapCellCore? updatedCell,
  });
  TRes userErrors(
    Iterable<Mutation$RemoveVisit$removeVisit$userErrors> Function(
      Iterable<
        CopyWith$Mutation$RemoveVisit$removeVisit$userErrors<
          Mutation$RemoveVisit$removeVisit$userErrors
        >
      >,
    )
    _fn,
  );
  CopyWith$Fragment$MapCellCore<TRes> get updatedCell;
}

class _CopyWithImpl$Mutation$RemoveVisit$removeVisit<TRes>
    implements CopyWith$Mutation$RemoveVisit$removeVisit<TRes> {
  _CopyWithImpl$Mutation$RemoveVisit$removeVisit(this._instance, this._then);

  final Mutation$RemoveVisit$removeVisit _instance;

  final TRes Function(Mutation$RemoveVisit$removeVisit) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? success = _undefined,
    Object? userErrors = _undefined,
    Object? updatedCell = _undefined,
  }) => _then(
    Mutation$RemoveVisit$removeVisit(
      success: success == _undefined || success == null
          ? _instance.success
          : (success as bool),
      userErrors: userErrors == _undefined || userErrors == null
          ? _instance.userErrors
          : (userErrors as List<Mutation$RemoveVisit$removeVisit$userErrors>),
      updatedCell: updatedCell == _undefined
          ? _instance.updatedCell
          : (updatedCell as Fragment$MapCellCore?),
    ),
  );

  TRes userErrors(
    Iterable<Mutation$RemoveVisit$removeVisit$userErrors> Function(
      Iterable<
        CopyWith$Mutation$RemoveVisit$removeVisit$userErrors<
          Mutation$RemoveVisit$removeVisit$userErrors
        >
      >,
    )
    _fn,
  ) => call(
    userErrors: _fn(
      _instance.userErrors.map(
        (e) =>
            CopyWith$Mutation$RemoveVisit$removeVisit$userErrors(e, (i) => i),
      ),
    ).toList(),
  );

  CopyWith$Fragment$MapCellCore<TRes> get updatedCell {
    final local$updatedCell = _instance.updatedCell;
    return local$updatedCell == null
        ? CopyWith$Fragment$MapCellCore.stub(_then(_instance))
        : CopyWith$Fragment$MapCellCore(
            local$updatedCell,
            (e) => call(updatedCell: e),
          );
  }
}

class _CopyWithStubImpl$Mutation$RemoveVisit$removeVisit<TRes>
    implements CopyWith$Mutation$RemoveVisit$removeVisit<TRes> {
  _CopyWithStubImpl$Mutation$RemoveVisit$removeVisit(this._res);

  TRes _res;

  call({
    bool? success,
    List<Mutation$RemoveVisit$removeVisit$userErrors>? userErrors,
    Fragment$MapCellCore? updatedCell,
  }) => _res;

  userErrors(_fn) => _res;

  CopyWith$Fragment$MapCellCore<TRes> get updatedCell =>
      CopyWith$Fragment$MapCellCore.stub(_res);
}

class Mutation$RemoveVisit$removeVisit$userErrors {
  Mutation$RemoveVisit$removeVisit$userErrors({
    required this.code,
    required this.message,
    this.field,
  });

  factory Mutation$RemoveVisit$removeVisit$userErrors.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$code = json['code'];
    final l$message = json['message'];
    final l$field = json['field'];
    return Mutation$RemoveVisit$removeVisit$userErrors(
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
    if (other is! Mutation$RemoveVisit$removeVisit$userErrors ||
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

extension UtilityExtension$Mutation$RemoveVisit$removeVisit$userErrors
    on Mutation$RemoveVisit$removeVisit$userErrors {
  CopyWith$Mutation$RemoveVisit$removeVisit$userErrors<
    Mutation$RemoveVisit$removeVisit$userErrors
  >
  get copyWith =>
      CopyWith$Mutation$RemoveVisit$removeVisit$userErrors(this, (i) => i);
}

abstract class CopyWith$Mutation$RemoveVisit$removeVisit$userErrors<TRes> {
  factory CopyWith$Mutation$RemoveVisit$removeVisit$userErrors(
    Mutation$RemoveVisit$removeVisit$userErrors instance,
    TRes Function(Mutation$RemoveVisit$removeVisit$userErrors) then,
  ) = _CopyWithImpl$Mutation$RemoveVisit$removeVisit$userErrors;

  factory CopyWith$Mutation$RemoveVisit$removeVisit$userErrors.stub(TRes res) =
      _CopyWithStubImpl$Mutation$RemoveVisit$removeVisit$userErrors;

  TRes call({String? code, String? message, String? field});
}

class _CopyWithImpl$Mutation$RemoveVisit$removeVisit$userErrors<TRes>
    implements CopyWith$Mutation$RemoveVisit$removeVisit$userErrors<TRes> {
  _CopyWithImpl$Mutation$RemoveVisit$removeVisit$userErrors(
    this._instance,
    this._then,
  );

  final Mutation$RemoveVisit$removeVisit$userErrors _instance;

  final TRes Function(Mutation$RemoveVisit$removeVisit$userErrors) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? code = _undefined,
    Object? message = _undefined,
    Object? field = _undefined,
  }) => _then(
    Mutation$RemoveVisit$removeVisit$userErrors(
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

class _CopyWithStubImpl$Mutation$RemoveVisit$removeVisit$userErrors<TRes>
    implements CopyWith$Mutation$RemoveVisit$removeVisit$userErrors<TRes> {
  _CopyWithStubImpl$Mutation$RemoveVisit$removeVisit$userErrors(this._res);

  TRes _res;

  call({String? code, String? message, String? field}) => _res;
}

class Mutation$CreateMapShareLink {
  Mutation$CreateMapShareLink({required this.createMapShareLink});

  factory Mutation$CreateMapShareLink.fromJson(Map<String, dynamic> json) {
    final l$createMapShareLink = json['createMapShareLink'];
    return Mutation$CreateMapShareLink(
      createMapShareLink:
          Mutation$CreateMapShareLink$createMapShareLink.fromJson(
            (l$createMapShareLink as Map<String, dynamic>),
          ),
    );
  }

  final Mutation$CreateMapShareLink$createMapShareLink createMapShareLink;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$createMapShareLink = createMapShareLink;
    _resultData['createMapShareLink'] = l$createMapShareLink.toJson();
    return _resultData;
  }

  @override
  int get hashCode {
    final l$createMapShareLink = createMapShareLink;
    return Object.hashAll([l$createMapShareLink]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$CreateMapShareLink ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$createMapShareLink = createMapShareLink;
    final lOther$createMapShareLink = other.createMapShareLink;
    if (l$createMapShareLink != lOther$createMapShareLink) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Mutation$CreateMapShareLink
    on Mutation$CreateMapShareLink {
  CopyWith$Mutation$CreateMapShareLink<Mutation$CreateMapShareLink>
  get copyWith => CopyWith$Mutation$CreateMapShareLink(this, (i) => i);
}

abstract class CopyWith$Mutation$CreateMapShareLink<TRes> {
  factory CopyWith$Mutation$CreateMapShareLink(
    Mutation$CreateMapShareLink instance,
    TRes Function(Mutation$CreateMapShareLink) then,
  ) = _CopyWithImpl$Mutation$CreateMapShareLink;

  factory CopyWith$Mutation$CreateMapShareLink.stub(TRes res) =
      _CopyWithStubImpl$Mutation$CreateMapShareLink;

  TRes call({
    Mutation$CreateMapShareLink$createMapShareLink? createMapShareLink,
  });
  CopyWith$Mutation$CreateMapShareLink$createMapShareLink<TRes>
  get createMapShareLink;
}

class _CopyWithImpl$Mutation$CreateMapShareLink<TRes>
    implements CopyWith$Mutation$CreateMapShareLink<TRes> {
  _CopyWithImpl$Mutation$CreateMapShareLink(this._instance, this._then);

  final Mutation$CreateMapShareLink _instance;

  final TRes Function(Mutation$CreateMapShareLink) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? createMapShareLink = _undefined}) => _then(
    Mutation$CreateMapShareLink(
      createMapShareLink:
          createMapShareLink == _undefined || createMapShareLink == null
          ? _instance.createMapShareLink
          : (createMapShareLink
                as Mutation$CreateMapShareLink$createMapShareLink),
    ),
  );

  CopyWith$Mutation$CreateMapShareLink$createMapShareLink<TRes>
  get createMapShareLink {
    final local$createMapShareLink = _instance.createMapShareLink;
    return CopyWith$Mutation$CreateMapShareLink$createMapShareLink(
      local$createMapShareLink,
      (e) => call(createMapShareLink: e),
    );
  }
}

class _CopyWithStubImpl$Mutation$CreateMapShareLink<TRes>
    implements CopyWith$Mutation$CreateMapShareLink<TRes> {
  _CopyWithStubImpl$Mutation$CreateMapShareLink(this._res);

  TRes _res;

  call({Mutation$CreateMapShareLink$createMapShareLink? createMapShareLink}) =>
      _res;

  CopyWith$Mutation$CreateMapShareLink$createMapShareLink<TRes>
  get createMapShareLink =>
      CopyWith$Mutation$CreateMapShareLink$createMapShareLink.stub(_res);
}

const documentNodeMutationCreateMapShareLink = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'CreateMapShareLink'),
      variableDefinitions: [],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'createMapShareLink'),
            alias: null,
            arguments: [],
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
                FieldNode(
                  name: NameNode(value: 'shareLink'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: SelectionSetNode(
                    selections: [
                      FieldNode(
                        name: NameNode(value: 'shareUrl'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'createdAt'),
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

class Mutation$CreateMapShareLink$createMapShareLink {
  Mutation$CreateMapShareLink$createMapShareLink({
    required this.success,
    required this.userErrors,
    this.shareLink,
  });

  factory Mutation$CreateMapShareLink$createMapShareLink.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$success = json['success'];
    final l$userErrors = json['userErrors'];
    final l$shareLink = json['shareLink'];
    return Mutation$CreateMapShareLink$createMapShareLink(
      success: (l$success as bool),
      userErrors: (l$userErrors as List<dynamic>)
          .map(
            (e) =>
                Mutation$CreateMapShareLink$createMapShareLink$userErrors.fromJson(
                  (e as Map<String, dynamic>),
                ),
          )
          .toList(),
      shareLink: l$shareLink == null
          ? null
          : Mutation$CreateMapShareLink$createMapShareLink$shareLink.fromJson(
              (l$shareLink as Map<String, dynamic>),
            ),
    );
  }

  final bool success;

  final List<Mutation$CreateMapShareLink$createMapShareLink$userErrors>
  userErrors;

  final Mutation$CreateMapShareLink$createMapShareLink$shareLink? shareLink;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$success = success;
    _resultData['success'] = l$success;
    final l$userErrors = userErrors;
    _resultData['userErrors'] = l$userErrors.map((e) => e.toJson()).toList();
    final l$shareLink = shareLink;
    _resultData['shareLink'] = l$shareLink?.toJson();
    return _resultData;
  }

  @override
  int get hashCode {
    final l$success = success;
    final l$userErrors = userErrors;
    final l$shareLink = shareLink;
    return Object.hashAll([
      l$success,
      Object.hashAll(l$userErrors.map((v) => v)),
      l$shareLink,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$CreateMapShareLink$createMapShareLink ||
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
    final l$shareLink = shareLink;
    final lOther$shareLink = other.shareLink;
    if (l$shareLink != lOther$shareLink) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Mutation$CreateMapShareLink$createMapShareLink
    on Mutation$CreateMapShareLink$createMapShareLink {
  CopyWith$Mutation$CreateMapShareLink$createMapShareLink<
    Mutation$CreateMapShareLink$createMapShareLink
  >
  get copyWith =>
      CopyWith$Mutation$CreateMapShareLink$createMapShareLink(this, (i) => i);
}

abstract class CopyWith$Mutation$CreateMapShareLink$createMapShareLink<TRes> {
  factory CopyWith$Mutation$CreateMapShareLink$createMapShareLink(
    Mutation$CreateMapShareLink$createMapShareLink instance,
    TRes Function(Mutation$CreateMapShareLink$createMapShareLink) then,
  ) = _CopyWithImpl$Mutation$CreateMapShareLink$createMapShareLink;

  factory CopyWith$Mutation$CreateMapShareLink$createMapShareLink.stub(
    TRes res,
  ) = _CopyWithStubImpl$Mutation$CreateMapShareLink$createMapShareLink;

  TRes call({
    bool? success,
    List<Mutation$CreateMapShareLink$createMapShareLink$userErrors>? userErrors,
    Mutation$CreateMapShareLink$createMapShareLink$shareLink? shareLink,
  });
  TRes userErrors(
    Iterable<Mutation$CreateMapShareLink$createMapShareLink$userErrors>
    Function(
      Iterable<
        CopyWith$Mutation$CreateMapShareLink$createMapShareLink$userErrors<
          Mutation$CreateMapShareLink$createMapShareLink$userErrors
        >
      >,
    )
    _fn,
  );
  CopyWith$Mutation$CreateMapShareLink$createMapShareLink$shareLink<TRes>
  get shareLink;
}

class _CopyWithImpl$Mutation$CreateMapShareLink$createMapShareLink<TRes>
    implements CopyWith$Mutation$CreateMapShareLink$createMapShareLink<TRes> {
  _CopyWithImpl$Mutation$CreateMapShareLink$createMapShareLink(
    this._instance,
    this._then,
  );

  final Mutation$CreateMapShareLink$createMapShareLink _instance;

  final TRes Function(Mutation$CreateMapShareLink$createMapShareLink) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? success = _undefined,
    Object? userErrors = _undefined,
    Object? shareLink = _undefined,
  }) => _then(
    Mutation$CreateMapShareLink$createMapShareLink(
      success: success == _undefined || success == null
          ? _instance.success
          : (success as bool),
      userErrors: userErrors == _undefined || userErrors == null
          ? _instance.userErrors
          : (userErrors
                as List<
                  Mutation$CreateMapShareLink$createMapShareLink$userErrors
                >),
      shareLink: shareLink == _undefined
          ? _instance.shareLink
          : (shareLink
                as Mutation$CreateMapShareLink$createMapShareLink$shareLink?),
    ),
  );

  TRes userErrors(
    Iterable<Mutation$CreateMapShareLink$createMapShareLink$userErrors>
    Function(
      Iterable<
        CopyWith$Mutation$CreateMapShareLink$createMapShareLink$userErrors<
          Mutation$CreateMapShareLink$createMapShareLink$userErrors
        >
      >,
    )
    _fn,
  ) => call(
    userErrors: _fn(
      _instance.userErrors.map(
        (e) =>
            CopyWith$Mutation$CreateMapShareLink$createMapShareLink$userErrors(
              e,
              (i) => i,
            ),
      ),
    ).toList(),
  );

  CopyWith$Mutation$CreateMapShareLink$createMapShareLink$shareLink<TRes>
  get shareLink {
    final local$shareLink = _instance.shareLink;
    return local$shareLink == null
        ? CopyWith$Mutation$CreateMapShareLink$createMapShareLink$shareLink.stub(
            _then(_instance),
          )
        : CopyWith$Mutation$CreateMapShareLink$createMapShareLink$shareLink(
            local$shareLink,
            (e) => call(shareLink: e),
          );
  }
}

class _CopyWithStubImpl$Mutation$CreateMapShareLink$createMapShareLink<TRes>
    implements CopyWith$Mutation$CreateMapShareLink$createMapShareLink<TRes> {
  _CopyWithStubImpl$Mutation$CreateMapShareLink$createMapShareLink(this._res);

  TRes _res;

  call({
    bool? success,
    List<Mutation$CreateMapShareLink$createMapShareLink$userErrors>? userErrors,
    Mutation$CreateMapShareLink$createMapShareLink$shareLink? shareLink,
  }) => _res;

  userErrors(_fn) => _res;

  CopyWith$Mutation$CreateMapShareLink$createMapShareLink$shareLink<TRes>
  get shareLink =>
      CopyWith$Mutation$CreateMapShareLink$createMapShareLink$shareLink.stub(
        _res,
      );
}

class Mutation$CreateMapShareLink$createMapShareLink$userErrors {
  Mutation$CreateMapShareLink$createMapShareLink$userErrors({
    required this.code,
    required this.message,
    this.field,
  });

  factory Mutation$CreateMapShareLink$createMapShareLink$userErrors.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$code = json['code'];
    final l$message = json['message'];
    final l$field = json['field'];
    return Mutation$CreateMapShareLink$createMapShareLink$userErrors(
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
    if (other is! Mutation$CreateMapShareLink$createMapShareLink$userErrors ||
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

extension UtilityExtension$Mutation$CreateMapShareLink$createMapShareLink$userErrors
    on Mutation$CreateMapShareLink$createMapShareLink$userErrors {
  CopyWith$Mutation$CreateMapShareLink$createMapShareLink$userErrors<
    Mutation$CreateMapShareLink$createMapShareLink$userErrors
  >
  get copyWith =>
      CopyWith$Mutation$CreateMapShareLink$createMapShareLink$userErrors(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Mutation$CreateMapShareLink$createMapShareLink$userErrors<
  TRes
> {
  factory CopyWith$Mutation$CreateMapShareLink$createMapShareLink$userErrors(
    Mutation$CreateMapShareLink$createMapShareLink$userErrors instance,
    TRes Function(Mutation$CreateMapShareLink$createMapShareLink$userErrors)
    then,
  ) = _CopyWithImpl$Mutation$CreateMapShareLink$createMapShareLink$userErrors;

  factory CopyWith$Mutation$CreateMapShareLink$createMapShareLink$userErrors.stub(
    TRes res,
  ) = _CopyWithStubImpl$Mutation$CreateMapShareLink$createMapShareLink$userErrors;

  TRes call({String? code, String? message, String? field});
}

class _CopyWithImpl$Mutation$CreateMapShareLink$createMapShareLink$userErrors<
  TRes
>
    implements
        CopyWith$Mutation$CreateMapShareLink$createMapShareLink$userErrors<
          TRes
        > {
  _CopyWithImpl$Mutation$CreateMapShareLink$createMapShareLink$userErrors(
    this._instance,
    this._then,
  );

  final Mutation$CreateMapShareLink$createMapShareLink$userErrors _instance;

  final TRes Function(Mutation$CreateMapShareLink$createMapShareLink$userErrors)
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? code = _undefined,
    Object? message = _undefined,
    Object? field = _undefined,
  }) => _then(
    Mutation$CreateMapShareLink$createMapShareLink$userErrors(
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

class _CopyWithStubImpl$Mutation$CreateMapShareLink$createMapShareLink$userErrors<
  TRes
>
    implements
        CopyWith$Mutation$CreateMapShareLink$createMapShareLink$userErrors<
          TRes
        > {
  _CopyWithStubImpl$Mutation$CreateMapShareLink$createMapShareLink$userErrors(
    this._res,
  );

  TRes _res;

  call({String? code, String? message, String? field}) => _res;
}

class Mutation$CreateMapShareLink$createMapShareLink$shareLink {
  Mutation$CreateMapShareLink$createMapShareLink$shareLink({
    required this.shareUrl,
    required this.createdAt,
  });

  factory Mutation$CreateMapShareLink$createMapShareLink$shareLink.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$shareUrl = json['shareUrl'];
    final l$createdAt = json['createdAt'];
    return Mutation$CreateMapShareLink$createMapShareLink$shareLink(
      shareUrl: (l$shareUrl as String),
      createdAt: (l$createdAt as String),
    );
  }

  final String shareUrl;

  final String createdAt;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$shareUrl = shareUrl;
    _resultData['shareUrl'] = l$shareUrl;
    final l$createdAt = createdAt;
    _resultData['createdAt'] = l$createdAt;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$shareUrl = shareUrl;
    final l$createdAt = createdAt;
    return Object.hashAll([l$shareUrl, l$createdAt]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$CreateMapShareLink$createMapShareLink$shareLink ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$shareUrl = shareUrl;
    final lOther$shareUrl = other.shareUrl;
    if (l$shareUrl != lOther$shareUrl) {
      return false;
    }
    final l$createdAt = createdAt;
    final lOther$createdAt = other.createdAt;
    if (l$createdAt != lOther$createdAt) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Mutation$CreateMapShareLink$createMapShareLink$shareLink
    on Mutation$CreateMapShareLink$createMapShareLink$shareLink {
  CopyWith$Mutation$CreateMapShareLink$createMapShareLink$shareLink<
    Mutation$CreateMapShareLink$createMapShareLink$shareLink
  >
  get copyWith =>
      CopyWith$Mutation$CreateMapShareLink$createMapShareLink$shareLink(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Mutation$CreateMapShareLink$createMapShareLink$shareLink<
  TRes
> {
  factory CopyWith$Mutation$CreateMapShareLink$createMapShareLink$shareLink(
    Mutation$CreateMapShareLink$createMapShareLink$shareLink instance,
    TRes Function(Mutation$CreateMapShareLink$createMapShareLink$shareLink)
    then,
  ) = _CopyWithImpl$Mutation$CreateMapShareLink$createMapShareLink$shareLink;

  factory CopyWith$Mutation$CreateMapShareLink$createMapShareLink$shareLink.stub(
    TRes res,
  ) = _CopyWithStubImpl$Mutation$CreateMapShareLink$createMapShareLink$shareLink;

  TRes call({String? shareUrl, String? createdAt});
}

class _CopyWithImpl$Mutation$CreateMapShareLink$createMapShareLink$shareLink<
  TRes
>
    implements
        CopyWith$Mutation$CreateMapShareLink$createMapShareLink$shareLink<
          TRes
        > {
  _CopyWithImpl$Mutation$CreateMapShareLink$createMapShareLink$shareLink(
    this._instance,
    this._then,
  );

  final Mutation$CreateMapShareLink$createMapShareLink$shareLink _instance;

  final TRes Function(Mutation$CreateMapShareLink$createMapShareLink$shareLink)
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? shareUrl = _undefined, Object? createdAt = _undefined}) =>
      _then(
        Mutation$CreateMapShareLink$createMapShareLink$shareLink(
          shareUrl: shareUrl == _undefined || shareUrl == null
              ? _instance.shareUrl
              : (shareUrl as String),
          createdAt: createdAt == _undefined || createdAt == null
              ? _instance.createdAt
              : (createdAt as String),
        ),
      );
}

class _CopyWithStubImpl$Mutation$CreateMapShareLink$createMapShareLink$shareLink<
  TRes
>
    implements
        CopyWith$Mutation$CreateMapShareLink$createMapShareLink$shareLink<
          TRes
        > {
  _CopyWithStubImpl$Mutation$CreateMapShareLink$createMapShareLink$shareLink(
    this._res,
  );

  TRes _res;

  call({String? shareUrl, String? createdAt}) => _res;
}

class Variables$Mutation$RevokeMapShareLink {
  factory Variables$Mutation$RevokeMapShareLink({
    required Input$RevokeMapShareLinkInput input,
  }) => Variables$Mutation$RevokeMapShareLink._({r'input': input});

  Variables$Mutation$RevokeMapShareLink._(this._$data);

  factory Variables$Mutation$RevokeMapShareLink.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    final l$input = data['input'];
    result$data['input'] = Input$RevokeMapShareLinkInput.fromJson(
      (l$input as Map<String, dynamic>),
    );
    return Variables$Mutation$RevokeMapShareLink._(result$data);
  }

  Map<String, dynamic> _$data;

  Input$RevokeMapShareLinkInput get input =>
      (_$data['input'] as Input$RevokeMapShareLinkInput);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$input = input;
    result$data['input'] = l$input.toJson();
    return result$data;
  }

  CopyWith$Variables$Mutation$RevokeMapShareLink<
    Variables$Mutation$RevokeMapShareLink
  >
  get copyWith =>
      CopyWith$Variables$Mutation$RevokeMapShareLink(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Mutation$RevokeMapShareLink ||
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

abstract class CopyWith$Variables$Mutation$RevokeMapShareLink<TRes> {
  factory CopyWith$Variables$Mutation$RevokeMapShareLink(
    Variables$Mutation$RevokeMapShareLink instance,
    TRes Function(Variables$Mutation$RevokeMapShareLink) then,
  ) = _CopyWithImpl$Variables$Mutation$RevokeMapShareLink;

  factory CopyWith$Variables$Mutation$RevokeMapShareLink.stub(TRes res) =
      _CopyWithStubImpl$Variables$Mutation$RevokeMapShareLink;

  TRes call({Input$RevokeMapShareLinkInput? input});
}

class _CopyWithImpl$Variables$Mutation$RevokeMapShareLink<TRes>
    implements CopyWith$Variables$Mutation$RevokeMapShareLink<TRes> {
  _CopyWithImpl$Variables$Mutation$RevokeMapShareLink(
    this._instance,
    this._then,
  );

  final Variables$Mutation$RevokeMapShareLink _instance;

  final TRes Function(Variables$Mutation$RevokeMapShareLink) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? input = _undefined}) => _then(
    Variables$Mutation$RevokeMapShareLink._({
      ..._instance._$data,
      if (input != _undefined && input != null)
        'input': (input as Input$RevokeMapShareLinkInput),
    }),
  );
}

class _CopyWithStubImpl$Variables$Mutation$RevokeMapShareLink<TRes>
    implements CopyWith$Variables$Mutation$RevokeMapShareLink<TRes> {
  _CopyWithStubImpl$Variables$Mutation$RevokeMapShareLink(this._res);

  TRes _res;

  call({Input$RevokeMapShareLinkInput? input}) => _res;
}

class Mutation$RevokeMapShareLink {
  Mutation$RevokeMapShareLink({required this.revokeMapShareLink});

  factory Mutation$RevokeMapShareLink.fromJson(Map<String, dynamic> json) {
    final l$revokeMapShareLink = json['revokeMapShareLink'];
    return Mutation$RevokeMapShareLink(
      revokeMapShareLink:
          Mutation$RevokeMapShareLink$revokeMapShareLink.fromJson(
            (l$revokeMapShareLink as Map<String, dynamic>),
          ),
    );
  }

  final Mutation$RevokeMapShareLink$revokeMapShareLink revokeMapShareLink;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$revokeMapShareLink = revokeMapShareLink;
    _resultData['revokeMapShareLink'] = l$revokeMapShareLink.toJson();
    return _resultData;
  }

  @override
  int get hashCode {
    final l$revokeMapShareLink = revokeMapShareLink;
    return Object.hashAll([l$revokeMapShareLink]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$RevokeMapShareLink ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$revokeMapShareLink = revokeMapShareLink;
    final lOther$revokeMapShareLink = other.revokeMapShareLink;
    if (l$revokeMapShareLink != lOther$revokeMapShareLink) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Mutation$RevokeMapShareLink
    on Mutation$RevokeMapShareLink {
  CopyWith$Mutation$RevokeMapShareLink<Mutation$RevokeMapShareLink>
  get copyWith => CopyWith$Mutation$RevokeMapShareLink(this, (i) => i);
}

abstract class CopyWith$Mutation$RevokeMapShareLink<TRes> {
  factory CopyWith$Mutation$RevokeMapShareLink(
    Mutation$RevokeMapShareLink instance,
    TRes Function(Mutation$RevokeMapShareLink) then,
  ) = _CopyWithImpl$Mutation$RevokeMapShareLink;

  factory CopyWith$Mutation$RevokeMapShareLink.stub(TRes res) =
      _CopyWithStubImpl$Mutation$RevokeMapShareLink;

  TRes call({
    Mutation$RevokeMapShareLink$revokeMapShareLink? revokeMapShareLink,
  });
  CopyWith$Mutation$RevokeMapShareLink$revokeMapShareLink<TRes>
  get revokeMapShareLink;
}

class _CopyWithImpl$Mutation$RevokeMapShareLink<TRes>
    implements CopyWith$Mutation$RevokeMapShareLink<TRes> {
  _CopyWithImpl$Mutation$RevokeMapShareLink(this._instance, this._then);

  final Mutation$RevokeMapShareLink _instance;

  final TRes Function(Mutation$RevokeMapShareLink) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? revokeMapShareLink = _undefined}) => _then(
    Mutation$RevokeMapShareLink(
      revokeMapShareLink:
          revokeMapShareLink == _undefined || revokeMapShareLink == null
          ? _instance.revokeMapShareLink
          : (revokeMapShareLink
                as Mutation$RevokeMapShareLink$revokeMapShareLink),
    ),
  );

  CopyWith$Mutation$RevokeMapShareLink$revokeMapShareLink<TRes>
  get revokeMapShareLink {
    final local$revokeMapShareLink = _instance.revokeMapShareLink;
    return CopyWith$Mutation$RevokeMapShareLink$revokeMapShareLink(
      local$revokeMapShareLink,
      (e) => call(revokeMapShareLink: e),
    );
  }
}

class _CopyWithStubImpl$Mutation$RevokeMapShareLink<TRes>
    implements CopyWith$Mutation$RevokeMapShareLink<TRes> {
  _CopyWithStubImpl$Mutation$RevokeMapShareLink(this._res);

  TRes _res;

  call({Mutation$RevokeMapShareLink$revokeMapShareLink? revokeMapShareLink}) =>
      _res;

  CopyWith$Mutation$RevokeMapShareLink$revokeMapShareLink<TRes>
  get revokeMapShareLink =>
      CopyWith$Mutation$RevokeMapShareLink$revokeMapShareLink.stub(_res);
}

const documentNodeMutationRevokeMapShareLink = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'RevokeMapShareLink'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'input')),
          type: NamedTypeNode(
            name: NameNode(value: 'RevokeMapShareLinkInput'),
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
            name: NameNode(value: 'revokeMapShareLink'),
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

class Mutation$RevokeMapShareLink$revokeMapShareLink {
  Mutation$RevokeMapShareLink$revokeMapShareLink({
    required this.success,
    required this.userErrors,
  });

  factory Mutation$RevokeMapShareLink$revokeMapShareLink.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$success = json['success'];
    final l$userErrors = json['userErrors'];
    return Mutation$RevokeMapShareLink$revokeMapShareLink(
      success: (l$success as bool),
      userErrors: (l$userErrors as List<dynamic>)
          .map(
            (e) =>
                Mutation$RevokeMapShareLink$revokeMapShareLink$userErrors.fromJson(
                  (e as Map<String, dynamic>),
                ),
          )
          .toList(),
    );
  }

  final bool success;

  final List<Mutation$RevokeMapShareLink$revokeMapShareLink$userErrors>
  userErrors;

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
    if (other is! Mutation$RevokeMapShareLink$revokeMapShareLink ||
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

extension UtilityExtension$Mutation$RevokeMapShareLink$revokeMapShareLink
    on Mutation$RevokeMapShareLink$revokeMapShareLink {
  CopyWith$Mutation$RevokeMapShareLink$revokeMapShareLink<
    Mutation$RevokeMapShareLink$revokeMapShareLink
  >
  get copyWith =>
      CopyWith$Mutation$RevokeMapShareLink$revokeMapShareLink(this, (i) => i);
}

abstract class CopyWith$Mutation$RevokeMapShareLink$revokeMapShareLink<TRes> {
  factory CopyWith$Mutation$RevokeMapShareLink$revokeMapShareLink(
    Mutation$RevokeMapShareLink$revokeMapShareLink instance,
    TRes Function(Mutation$RevokeMapShareLink$revokeMapShareLink) then,
  ) = _CopyWithImpl$Mutation$RevokeMapShareLink$revokeMapShareLink;

  factory CopyWith$Mutation$RevokeMapShareLink$revokeMapShareLink.stub(
    TRes res,
  ) = _CopyWithStubImpl$Mutation$RevokeMapShareLink$revokeMapShareLink;

  TRes call({
    bool? success,
    List<Mutation$RevokeMapShareLink$revokeMapShareLink$userErrors>? userErrors,
  });
  TRes userErrors(
    Iterable<Mutation$RevokeMapShareLink$revokeMapShareLink$userErrors>
    Function(
      Iterable<
        CopyWith$Mutation$RevokeMapShareLink$revokeMapShareLink$userErrors<
          Mutation$RevokeMapShareLink$revokeMapShareLink$userErrors
        >
      >,
    )
    _fn,
  );
}

class _CopyWithImpl$Mutation$RevokeMapShareLink$revokeMapShareLink<TRes>
    implements CopyWith$Mutation$RevokeMapShareLink$revokeMapShareLink<TRes> {
  _CopyWithImpl$Mutation$RevokeMapShareLink$revokeMapShareLink(
    this._instance,
    this._then,
  );

  final Mutation$RevokeMapShareLink$revokeMapShareLink _instance;

  final TRes Function(Mutation$RevokeMapShareLink$revokeMapShareLink) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? success = _undefined, Object? userErrors = _undefined}) =>
      _then(
        Mutation$RevokeMapShareLink$revokeMapShareLink(
          success: success == _undefined || success == null
              ? _instance.success
              : (success as bool),
          userErrors: userErrors == _undefined || userErrors == null
              ? _instance.userErrors
              : (userErrors
                    as List<
                      Mutation$RevokeMapShareLink$revokeMapShareLink$userErrors
                    >),
        ),
      );

  TRes userErrors(
    Iterable<Mutation$RevokeMapShareLink$revokeMapShareLink$userErrors>
    Function(
      Iterable<
        CopyWith$Mutation$RevokeMapShareLink$revokeMapShareLink$userErrors<
          Mutation$RevokeMapShareLink$revokeMapShareLink$userErrors
        >
      >,
    )
    _fn,
  ) => call(
    userErrors: _fn(
      _instance.userErrors.map(
        (e) =>
            CopyWith$Mutation$RevokeMapShareLink$revokeMapShareLink$userErrors(
              e,
              (i) => i,
            ),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl$Mutation$RevokeMapShareLink$revokeMapShareLink<TRes>
    implements CopyWith$Mutation$RevokeMapShareLink$revokeMapShareLink<TRes> {
  _CopyWithStubImpl$Mutation$RevokeMapShareLink$revokeMapShareLink(this._res);

  TRes _res;

  call({
    bool? success,
    List<Mutation$RevokeMapShareLink$revokeMapShareLink$userErrors>? userErrors,
  }) => _res;

  userErrors(_fn) => _res;
}

class Mutation$RevokeMapShareLink$revokeMapShareLink$userErrors {
  Mutation$RevokeMapShareLink$revokeMapShareLink$userErrors({
    required this.code,
    required this.message,
    this.field,
  });

  factory Mutation$RevokeMapShareLink$revokeMapShareLink$userErrors.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$code = json['code'];
    final l$message = json['message'];
    final l$field = json['field'];
    return Mutation$RevokeMapShareLink$revokeMapShareLink$userErrors(
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
    if (other is! Mutation$RevokeMapShareLink$revokeMapShareLink$userErrors ||
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

extension UtilityExtension$Mutation$RevokeMapShareLink$revokeMapShareLink$userErrors
    on Mutation$RevokeMapShareLink$revokeMapShareLink$userErrors {
  CopyWith$Mutation$RevokeMapShareLink$revokeMapShareLink$userErrors<
    Mutation$RevokeMapShareLink$revokeMapShareLink$userErrors
  >
  get copyWith =>
      CopyWith$Mutation$RevokeMapShareLink$revokeMapShareLink$userErrors(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Mutation$RevokeMapShareLink$revokeMapShareLink$userErrors<
  TRes
> {
  factory CopyWith$Mutation$RevokeMapShareLink$revokeMapShareLink$userErrors(
    Mutation$RevokeMapShareLink$revokeMapShareLink$userErrors instance,
    TRes Function(Mutation$RevokeMapShareLink$revokeMapShareLink$userErrors)
    then,
  ) = _CopyWithImpl$Mutation$RevokeMapShareLink$revokeMapShareLink$userErrors;

  factory CopyWith$Mutation$RevokeMapShareLink$revokeMapShareLink$userErrors.stub(
    TRes res,
  ) = _CopyWithStubImpl$Mutation$RevokeMapShareLink$revokeMapShareLink$userErrors;

  TRes call({String? code, String? message, String? field});
}

class _CopyWithImpl$Mutation$RevokeMapShareLink$revokeMapShareLink$userErrors<
  TRes
>
    implements
        CopyWith$Mutation$RevokeMapShareLink$revokeMapShareLink$userErrors<
          TRes
        > {
  _CopyWithImpl$Mutation$RevokeMapShareLink$revokeMapShareLink$userErrors(
    this._instance,
    this._then,
  );

  final Mutation$RevokeMapShareLink$revokeMapShareLink$userErrors _instance;

  final TRes Function(Mutation$RevokeMapShareLink$revokeMapShareLink$userErrors)
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? code = _undefined,
    Object? message = _undefined,
    Object? field = _undefined,
  }) => _then(
    Mutation$RevokeMapShareLink$revokeMapShareLink$userErrors(
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

class _CopyWithStubImpl$Mutation$RevokeMapShareLink$revokeMapShareLink$userErrors<
  TRes
>
    implements
        CopyWith$Mutation$RevokeMapShareLink$revokeMapShareLink$userErrors<
          TRes
        > {
  _CopyWithStubImpl$Mutation$RevokeMapShareLink$revokeMapShareLink$userErrors(
    this._res,
  );

  TRes _res;

  call({String? code, String? message, String? field}) => _res;
}
