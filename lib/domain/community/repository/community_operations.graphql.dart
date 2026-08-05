// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, unused_element
import 'community_schema.graphql.dart';
import 'package:gql/ast.dart';

class Fragment$PostCardFields {
  Fragment$PostCardFields({
    required this.id,
    required this.body,
    required this.topic,
    required this.createdAt,
    required this.photoKeys,
    required this.likeCount,
    required this.commentCount,
    required this.likedByViewer,
    required this.ownedByViewer,
    required this.hidden,
    required this.target,
    required this.author,
  });

  factory Fragment$PostCardFields.fromJson(Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$body = json['body'];
    final l$topic = json['topic'];
    final l$createdAt = json['createdAt'];
    final l$photoKeys = json['photoKeys'];
    final l$likeCount = json['likeCount'];
    final l$commentCount = json['commentCount'];
    final l$likedByViewer = json['likedByViewer'];
    final l$ownedByViewer = json['ownedByViewer'];
    final l$hidden = json['hidden'];
    final l$target = json['target'];
    final l$author = json['author'];
    return Fragment$PostCardFields(
      id: (l$id as String),
      body: (l$body as String),
      topic: fromJson$Enum$PostTopic((l$topic as String)),
      createdAt: (l$createdAt as String),
      photoKeys: (l$photoKeys as List<dynamic>)
          .map((e) => (e as String))
          .toList(),
      likeCount: (l$likeCount as int),
      commentCount: (l$commentCount as int),
      likedByViewer: (l$likedByViewer as bool),
      ownedByViewer: (l$ownedByViewer as bool),
      hidden: (l$hidden as bool),
      target: Fragment$PostCardFields$target.fromJson(
        (l$target as Map<String, dynamic>),
      ),
      author: Fragment$PostCardFields$author.fromJson(
        (l$author as Map<String, dynamic>),
      ),
    );
  }

  final String id;

  final String body;

  final Enum$PostTopic topic;

  final String createdAt;

  final List<String> photoKeys;

  final int likeCount;

  final int commentCount;

  final bool likedByViewer;

  final bool ownedByViewer;

  final bool hidden;

  final Fragment$PostCardFields$target target;

  final Fragment$PostCardFields$author author;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$body = body;
    _resultData['body'] = l$body;
    final l$topic = topic;
    _resultData['topic'] = toJson$Enum$PostTopic(l$topic);
    final l$createdAt = createdAt;
    _resultData['createdAt'] = l$createdAt;
    final l$photoKeys = photoKeys;
    _resultData['photoKeys'] = l$photoKeys.map((e) => e).toList();
    final l$likeCount = likeCount;
    _resultData['likeCount'] = l$likeCount;
    final l$commentCount = commentCount;
    _resultData['commentCount'] = l$commentCount;
    final l$likedByViewer = likedByViewer;
    _resultData['likedByViewer'] = l$likedByViewer;
    final l$ownedByViewer = ownedByViewer;
    _resultData['ownedByViewer'] = l$ownedByViewer;
    final l$hidden = hidden;
    _resultData['hidden'] = l$hidden;
    final l$target = target;
    _resultData['target'] = l$target.toJson();
    final l$author = author;
    _resultData['author'] = l$author.toJson();
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$body = body;
    final l$topic = topic;
    final l$createdAt = createdAt;
    final l$photoKeys = photoKeys;
    final l$likeCount = likeCount;
    final l$commentCount = commentCount;
    final l$likedByViewer = likedByViewer;
    final l$ownedByViewer = ownedByViewer;
    final l$hidden = hidden;
    final l$target = target;
    final l$author = author;
    return Object.hashAll([
      l$id,
      l$body,
      l$topic,
      l$createdAt,
      Object.hashAll(l$photoKeys.map((v) => v)),
      l$likeCount,
      l$commentCount,
      l$likedByViewer,
      l$ownedByViewer,
      l$hidden,
      l$target,
      l$author,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment$PostCardFields || runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$body = body;
    final lOther$body = other.body;
    if (l$body != lOther$body) {
      return false;
    }
    final l$topic = topic;
    final lOther$topic = other.topic;
    if (l$topic != lOther$topic) {
      return false;
    }
    final l$createdAt = createdAt;
    final lOther$createdAt = other.createdAt;
    if (l$createdAt != lOther$createdAt) {
      return false;
    }
    final l$photoKeys = photoKeys;
    final lOther$photoKeys = other.photoKeys;
    if (l$photoKeys.length != lOther$photoKeys.length) {
      return false;
    }
    for (int i = 0; i < l$photoKeys.length; i++) {
      final l$photoKeys$entry = l$photoKeys[i];
      final lOther$photoKeys$entry = lOther$photoKeys[i];
      if (l$photoKeys$entry != lOther$photoKeys$entry) {
        return false;
      }
    }
    final l$likeCount = likeCount;
    final lOther$likeCount = other.likeCount;
    if (l$likeCount != lOther$likeCount) {
      return false;
    }
    final l$commentCount = commentCount;
    final lOther$commentCount = other.commentCount;
    if (l$commentCount != lOther$commentCount) {
      return false;
    }
    final l$likedByViewer = likedByViewer;
    final lOther$likedByViewer = other.likedByViewer;
    if (l$likedByViewer != lOther$likedByViewer) {
      return false;
    }
    final l$ownedByViewer = ownedByViewer;
    final lOther$ownedByViewer = other.ownedByViewer;
    if (l$ownedByViewer != lOther$ownedByViewer) {
      return false;
    }
    final l$hidden = hidden;
    final lOther$hidden = other.hidden;
    if (l$hidden != lOther$hidden) {
      return false;
    }
    final l$target = target;
    final lOther$target = other.target;
    if (l$target != lOther$target) {
      return false;
    }
    final l$author = author;
    final lOther$author = other.author;
    if (l$author != lOther$author) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Fragment$PostCardFields on Fragment$PostCardFields {
  CopyWith$Fragment$PostCardFields<Fragment$PostCardFields> get copyWith =>
      CopyWith$Fragment$PostCardFields(this, (i) => i);
}

abstract class CopyWith$Fragment$PostCardFields<TRes> {
  factory CopyWith$Fragment$PostCardFields(
    Fragment$PostCardFields instance,
    TRes Function(Fragment$PostCardFields) then,
  ) = _CopyWithImpl$Fragment$PostCardFields;

  factory CopyWith$Fragment$PostCardFields.stub(TRes res) =
      _CopyWithStubImpl$Fragment$PostCardFields;

  TRes call({
    String? id,
    String? body,
    Enum$PostTopic? topic,
    String? createdAt,
    List<String>? photoKeys,
    int? likeCount,
    int? commentCount,
    bool? likedByViewer,
    bool? ownedByViewer,
    bool? hidden,
    Fragment$PostCardFields$target? target,
    Fragment$PostCardFields$author? author,
  });
  CopyWith$Fragment$PostCardFields$target<TRes> get target;
  CopyWith$Fragment$PostCardFields$author<TRes> get author;
}

class _CopyWithImpl$Fragment$PostCardFields<TRes>
    implements CopyWith$Fragment$PostCardFields<TRes> {
  _CopyWithImpl$Fragment$PostCardFields(this._instance, this._then);

  final Fragment$PostCardFields _instance;

  final TRes Function(Fragment$PostCardFields) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? body = _undefined,
    Object? topic = _undefined,
    Object? createdAt = _undefined,
    Object? photoKeys = _undefined,
    Object? likeCount = _undefined,
    Object? commentCount = _undefined,
    Object? likedByViewer = _undefined,
    Object? ownedByViewer = _undefined,
    Object? hidden = _undefined,
    Object? target = _undefined,
    Object? author = _undefined,
  }) => _then(
    Fragment$PostCardFields(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      body: body == _undefined || body == null
          ? _instance.body
          : (body as String),
      topic: topic == _undefined || topic == null
          ? _instance.topic
          : (topic as Enum$PostTopic),
      createdAt: createdAt == _undefined || createdAt == null
          ? _instance.createdAt
          : (createdAt as String),
      photoKeys: photoKeys == _undefined || photoKeys == null
          ? _instance.photoKeys
          : (photoKeys as List<String>),
      likeCount: likeCount == _undefined || likeCount == null
          ? _instance.likeCount
          : (likeCount as int),
      commentCount: commentCount == _undefined || commentCount == null
          ? _instance.commentCount
          : (commentCount as int),
      likedByViewer: likedByViewer == _undefined || likedByViewer == null
          ? _instance.likedByViewer
          : (likedByViewer as bool),
      ownedByViewer: ownedByViewer == _undefined || ownedByViewer == null
          ? _instance.ownedByViewer
          : (ownedByViewer as bool),
      hidden: hidden == _undefined || hidden == null
          ? _instance.hidden
          : (hidden as bool),
      target: target == _undefined || target == null
          ? _instance.target
          : (target as Fragment$PostCardFields$target),
      author: author == _undefined || author == null
          ? _instance.author
          : (author as Fragment$PostCardFields$author),
    ),
  );

  CopyWith$Fragment$PostCardFields$target<TRes> get target {
    final local$target = _instance.target;
    return CopyWith$Fragment$PostCardFields$target(
      local$target,
      (e) => call(target: e),
    );
  }

  CopyWith$Fragment$PostCardFields$author<TRes> get author {
    final local$author = _instance.author;
    return CopyWith$Fragment$PostCardFields$author(
      local$author,
      (e) => call(author: e),
    );
  }
}

class _CopyWithStubImpl$Fragment$PostCardFields<TRes>
    implements CopyWith$Fragment$PostCardFields<TRes> {
  _CopyWithStubImpl$Fragment$PostCardFields(this._res);

  TRes _res;

  call({
    String? id,
    String? body,
    Enum$PostTopic? topic,
    String? createdAt,
    List<String>? photoKeys,
    int? likeCount,
    int? commentCount,
    bool? likedByViewer,
    bool? ownedByViewer,
    bool? hidden,
    Fragment$PostCardFields$target? target,
    Fragment$PostCardFields$author? author,
  }) => _res;

  CopyWith$Fragment$PostCardFields$target<TRes> get target =>
      CopyWith$Fragment$PostCardFields$target.stub(_res);

  CopyWith$Fragment$PostCardFields$author<TRes> get author =>
      CopyWith$Fragment$PostCardFields$author.stub(_res);
}

const fragmentDefinitionPostCardFields = FragmentDefinitionNode(
  name: NameNode(value: 'PostCardFields'),
  typeCondition: TypeConditionNode(
    on: NamedTypeNode(name: NameNode(value: 'Post'), isNonNull: false),
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
        name: NameNode(value: 'body'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'topic'),
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
      FieldNode(
        name: NameNode(value: 'photoKeys'),
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
        name: NameNode(value: 'commentCount'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'likedByViewer'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'ownedByViewer'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'hidden'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'target'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: SelectionSetNode(
          selections: [
            FieldNode(
              name: NameNode(value: 'type'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null,
            ),
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
          ],
        ),
      ),
      FieldNode(
        name: NameNode(value: 'author'),
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
              name: NameNode(value: 'nickname'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null,
            ),
            FieldNode(
              name: NameNode(value: 'profileImageUrl'),
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
const documentNodeFragmentPostCardFields = DocumentNode(
  definitions: [fragmentDefinitionPostCardFields],
);

class Fragment$PostCardFields$target {
  Fragment$PostCardFields$target({
    required this.type,
    required this.id,
    required this.title,
    required this.thumbnailImageUrl,
  });

  factory Fragment$PostCardFields$target.fromJson(Map<String, dynamic> json) {
    final l$type = json['type'];
    final l$id = json['id'];
    final l$title = json['title'];
    final l$thumbnailImageUrl = json['thumbnailImageUrl'];
    return Fragment$PostCardFields$target(
      type: fromJson$Enum$PostTargetType((l$type as String)),
      id: (l$id as String),
      title: (l$title as String),
      thumbnailImageUrl: (l$thumbnailImageUrl as String),
    );
  }

  final Enum$PostTargetType type;

  final String id;

  final String title;

  final String thumbnailImageUrl;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$type = type;
    _resultData['type'] = toJson$Enum$PostTargetType(l$type);
    final l$id = id;
    _resultData['id'] = l$id;
    final l$title = title;
    _resultData['title'] = l$title;
    final l$thumbnailImageUrl = thumbnailImageUrl;
    _resultData['thumbnailImageUrl'] = l$thumbnailImageUrl;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$type = type;
    final l$id = id;
    final l$title = title;
    final l$thumbnailImageUrl = thumbnailImageUrl;
    return Object.hashAll([l$type, l$id, l$title, l$thumbnailImageUrl]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment$PostCardFields$target ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$type = type;
    final lOther$type = other.type;
    if (l$type != lOther$type) {
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
    return true;
  }
}

extension UtilityExtension$Fragment$PostCardFields$target
    on Fragment$PostCardFields$target {
  CopyWith$Fragment$PostCardFields$target<Fragment$PostCardFields$target>
  get copyWith => CopyWith$Fragment$PostCardFields$target(this, (i) => i);
}

abstract class CopyWith$Fragment$PostCardFields$target<TRes> {
  factory CopyWith$Fragment$PostCardFields$target(
    Fragment$PostCardFields$target instance,
    TRes Function(Fragment$PostCardFields$target) then,
  ) = _CopyWithImpl$Fragment$PostCardFields$target;

  factory CopyWith$Fragment$PostCardFields$target.stub(TRes res) =
      _CopyWithStubImpl$Fragment$PostCardFields$target;

  TRes call({
    Enum$PostTargetType? type,
    String? id,
    String? title,
    String? thumbnailImageUrl,
  });
}

class _CopyWithImpl$Fragment$PostCardFields$target<TRes>
    implements CopyWith$Fragment$PostCardFields$target<TRes> {
  _CopyWithImpl$Fragment$PostCardFields$target(this._instance, this._then);

  final Fragment$PostCardFields$target _instance;

  final TRes Function(Fragment$PostCardFields$target) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? type = _undefined,
    Object? id = _undefined,
    Object? title = _undefined,
    Object? thumbnailImageUrl = _undefined,
  }) => _then(
    Fragment$PostCardFields$target(
      type: type == _undefined || type == null
          ? _instance.type
          : (type as Enum$PostTargetType),
      id: id == _undefined || id == null ? _instance.id : (id as String),
      title: title == _undefined || title == null
          ? _instance.title
          : (title as String),
      thumbnailImageUrl:
          thumbnailImageUrl == _undefined || thumbnailImageUrl == null
          ? _instance.thumbnailImageUrl
          : (thumbnailImageUrl as String),
    ),
  );
}

class _CopyWithStubImpl$Fragment$PostCardFields$target<TRes>
    implements CopyWith$Fragment$PostCardFields$target<TRes> {
  _CopyWithStubImpl$Fragment$PostCardFields$target(this._res);

  TRes _res;

  call({
    Enum$PostTargetType? type,
    String? id,
    String? title,
    String? thumbnailImageUrl,
  }) => _res;
}

class Fragment$PostCardFields$author {
  Fragment$PostCardFields$author({
    required this.id,
    required this.nickname,
    this.profileImageUrl,
  });

  factory Fragment$PostCardFields$author.fromJson(Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$nickname = json['nickname'];
    final l$profileImageUrl = json['profileImageUrl'];
    return Fragment$PostCardFields$author(
      id: (l$id as String),
      nickname: (l$nickname as String),
      profileImageUrl: (l$profileImageUrl as String?),
    );
  }

  final String id;

  final String nickname;

  final String? profileImageUrl;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$nickname = nickname;
    _resultData['nickname'] = l$nickname;
    final l$profileImageUrl = profileImageUrl;
    _resultData['profileImageUrl'] = l$profileImageUrl;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$nickname = nickname;
    final l$profileImageUrl = profileImageUrl;
    return Object.hashAll([l$id, l$nickname, l$profileImageUrl]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment$PostCardFields$author ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$nickname = nickname;
    final lOther$nickname = other.nickname;
    if (l$nickname != lOther$nickname) {
      return false;
    }
    final l$profileImageUrl = profileImageUrl;
    final lOther$profileImageUrl = other.profileImageUrl;
    if (l$profileImageUrl != lOther$profileImageUrl) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Fragment$PostCardFields$author
    on Fragment$PostCardFields$author {
  CopyWith$Fragment$PostCardFields$author<Fragment$PostCardFields$author>
  get copyWith => CopyWith$Fragment$PostCardFields$author(this, (i) => i);
}

abstract class CopyWith$Fragment$PostCardFields$author<TRes> {
  factory CopyWith$Fragment$PostCardFields$author(
    Fragment$PostCardFields$author instance,
    TRes Function(Fragment$PostCardFields$author) then,
  ) = _CopyWithImpl$Fragment$PostCardFields$author;

  factory CopyWith$Fragment$PostCardFields$author.stub(TRes res) =
      _CopyWithStubImpl$Fragment$PostCardFields$author;

  TRes call({String? id, String? nickname, String? profileImageUrl});
}

class _CopyWithImpl$Fragment$PostCardFields$author<TRes>
    implements CopyWith$Fragment$PostCardFields$author<TRes> {
  _CopyWithImpl$Fragment$PostCardFields$author(this._instance, this._then);

  final Fragment$PostCardFields$author _instance;

  final TRes Function(Fragment$PostCardFields$author) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? nickname = _undefined,
    Object? profileImageUrl = _undefined,
  }) => _then(
    Fragment$PostCardFields$author(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      nickname: nickname == _undefined || nickname == null
          ? _instance.nickname
          : (nickname as String),
      profileImageUrl: profileImageUrl == _undefined
          ? _instance.profileImageUrl
          : (profileImageUrl as String?),
    ),
  );
}

class _CopyWithStubImpl$Fragment$PostCardFields$author<TRes>
    implements CopyWith$Fragment$PostCardFields$author<TRes> {
  _CopyWithStubImpl$Fragment$PostCardFields$author(this._res);

  TRes _res;

  call({String? id, String? nickname, String? profileImageUrl}) => _res;
}

class Variables$Query$NearbyPosts {
  factory Variables$Query$NearbyPosts({
    required double latitude,
    required double longitude,
    int? radiusMeters,
    Enum$PostTopic? topic,
    int? first,
    String? after,
  }) => Variables$Query$NearbyPosts._({
    r'latitude': latitude,
    r'longitude': longitude,
    if (radiusMeters != null) r'radiusMeters': radiusMeters,
    if (topic != null) r'topic': topic,
    if (first != null) r'first': first,
    if (after != null) r'after': after,
  });

  Variables$Query$NearbyPosts._(this._$data);

  factory Variables$Query$NearbyPosts.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$latitude = data['latitude'];
    result$data['latitude'] = (l$latitude as num).toDouble();
    final l$longitude = data['longitude'];
    result$data['longitude'] = (l$longitude as num).toDouble();
    if (data.containsKey('radiusMeters')) {
      final l$radiusMeters = data['radiusMeters'];
      result$data['radiusMeters'] = (l$radiusMeters as int?);
    }
    if (data.containsKey('topic')) {
      final l$topic = data['topic'];
      result$data['topic'] = l$topic == null
          ? null
          : fromJson$Enum$PostTopic((l$topic as String));
    }
    if (data.containsKey('first')) {
      final l$first = data['first'];
      result$data['first'] = (l$first as int?);
    }
    if (data.containsKey('after')) {
      final l$after = data['after'];
      result$data['after'] = (l$after as String?);
    }
    return Variables$Query$NearbyPosts._(result$data);
  }

  Map<String, dynamic> _$data;

  double get latitude => (_$data['latitude'] as double);

  double get longitude => (_$data['longitude'] as double);

  int? get radiusMeters => (_$data['radiusMeters'] as int?);

  Enum$PostTopic? get topic => (_$data['topic'] as Enum$PostTopic?);

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
    if (_$data.containsKey('topic')) {
      final l$topic = topic;
      result$data['topic'] = l$topic == null
          ? null
          : toJson$Enum$PostTopic(l$topic);
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

  CopyWith$Variables$Query$NearbyPosts<Variables$Query$NearbyPosts>
  get copyWith => CopyWith$Variables$Query$NearbyPosts(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Query$NearbyPosts ||
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
    final l$topic = topic;
    final lOther$topic = other.topic;
    if (_$data.containsKey('topic') != other._$data.containsKey('topic')) {
      return false;
    }
    if (l$topic != lOther$topic) {
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
    final l$topic = topic;
    final l$first = first;
    final l$after = after;
    return Object.hashAll([
      l$latitude,
      l$longitude,
      _$data.containsKey('radiusMeters') ? l$radiusMeters : const {},
      _$data.containsKey('topic') ? l$topic : const {},
      _$data.containsKey('first') ? l$first : const {},
      _$data.containsKey('after') ? l$after : const {},
    ]);
  }
}

abstract class CopyWith$Variables$Query$NearbyPosts<TRes> {
  factory CopyWith$Variables$Query$NearbyPosts(
    Variables$Query$NearbyPosts instance,
    TRes Function(Variables$Query$NearbyPosts) then,
  ) = _CopyWithImpl$Variables$Query$NearbyPosts;

  factory CopyWith$Variables$Query$NearbyPosts.stub(TRes res) =
      _CopyWithStubImpl$Variables$Query$NearbyPosts;

  TRes call({
    double? latitude,
    double? longitude,
    int? radiusMeters,
    Enum$PostTopic? topic,
    int? first,
    String? after,
  });
}

class _CopyWithImpl$Variables$Query$NearbyPosts<TRes>
    implements CopyWith$Variables$Query$NearbyPosts<TRes> {
  _CopyWithImpl$Variables$Query$NearbyPosts(this._instance, this._then);

  final Variables$Query$NearbyPosts _instance;

  final TRes Function(Variables$Query$NearbyPosts) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? latitude = _undefined,
    Object? longitude = _undefined,
    Object? radiusMeters = _undefined,
    Object? topic = _undefined,
    Object? first = _undefined,
    Object? after = _undefined,
  }) => _then(
    Variables$Query$NearbyPosts._({
      ..._instance._$data,
      if (latitude != _undefined && latitude != null)
        'latitude': (latitude as double),
      if (longitude != _undefined && longitude != null)
        'longitude': (longitude as double),
      if (radiusMeters != _undefined) 'radiusMeters': (radiusMeters as int?),
      if (topic != _undefined) 'topic': (topic as Enum$PostTopic?),
      if (first != _undefined) 'first': (first as int?),
      if (after != _undefined) 'after': (after as String?),
    }),
  );
}

class _CopyWithStubImpl$Variables$Query$NearbyPosts<TRes>
    implements CopyWith$Variables$Query$NearbyPosts<TRes> {
  _CopyWithStubImpl$Variables$Query$NearbyPosts(this._res);

  TRes _res;

  call({
    double? latitude,
    double? longitude,
    int? radiusMeters,
    Enum$PostTopic? topic,
    int? first,
    String? after,
  }) => _res;
}

class Query$NearbyPosts {
  Query$NearbyPosts({required this.nearbyPosts});

  factory Query$NearbyPosts.fromJson(Map<String, dynamic> json) {
    final l$nearbyPosts = json['nearbyPosts'];
    return Query$NearbyPosts(
      nearbyPosts: Query$NearbyPosts$nearbyPosts.fromJson(
        (l$nearbyPosts as Map<String, dynamic>),
      ),
    );
  }

  final Query$NearbyPosts$nearbyPosts nearbyPosts;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$nearbyPosts = nearbyPosts;
    _resultData['nearbyPosts'] = l$nearbyPosts.toJson();
    return _resultData;
  }

  @override
  int get hashCode {
    final l$nearbyPosts = nearbyPosts;
    return Object.hashAll([l$nearbyPosts]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$NearbyPosts || runtimeType != other.runtimeType) {
      return false;
    }
    final l$nearbyPosts = nearbyPosts;
    final lOther$nearbyPosts = other.nearbyPosts;
    if (l$nearbyPosts != lOther$nearbyPosts) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Query$NearbyPosts on Query$NearbyPosts {
  CopyWith$Query$NearbyPosts<Query$NearbyPosts> get copyWith =>
      CopyWith$Query$NearbyPosts(this, (i) => i);
}

abstract class CopyWith$Query$NearbyPosts<TRes> {
  factory CopyWith$Query$NearbyPosts(
    Query$NearbyPosts instance,
    TRes Function(Query$NearbyPosts) then,
  ) = _CopyWithImpl$Query$NearbyPosts;

  factory CopyWith$Query$NearbyPosts.stub(TRes res) =
      _CopyWithStubImpl$Query$NearbyPosts;

  TRes call({Query$NearbyPosts$nearbyPosts? nearbyPosts});
  CopyWith$Query$NearbyPosts$nearbyPosts<TRes> get nearbyPosts;
}

class _CopyWithImpl$Query$NearbyPosts<TRes>
    implements CopyWith$Query$NearbyPosts<TRes> {
  _CopyWithImpl$Query$NearbyPosts(this._instance, this._then);

  final Query$NearbyPosts _instance;

  final TRes Function(Query$NearbyPosts) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? nearbyPosts = _undefined}) => _then(
    Query$NearbyPosts(
      nearbyPosts: nearbyPosts == _undefined || nearbyPosts == null
          ? _instance.nearbyPosts
          : (nearbyPosts as Query$NearbyPosts$nearbyPosts),
    ),
  );

  CopyWith$Query$NearbyPosts$nearbyPosts<TRes> get nearbyPosts {
    final local$nearbyPosts = _instance.nearbyPosts;
    return CopyWith$Query$NearbyPosts$nearbyPosts(
      local$nearbyPosts,
      (e) => call(nearbyPosts: e),
    );
  }
}

class _CopyWithStubImpl$Query$NearbyPosts<TRes>
    implements CopyWith$Query$NearbyPosts<TRes> {
  _CopyWithStubImpl$Query$NearbyPosts(this._res);

  TRes _res;

  call({Query$NearbyPosts$nearbyPosts? nearbyPosts}) => _res;

  CopyWith$Query$NearbyPosts$nearbyPosts<TRes> get nearbyPosts =>
      CopyWith$Query$NearbyPosts$nearbyPosts.stub(_res);
}

const documentNodeQueryNearbyPosts = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'NearbyPosts'),
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
          variable: VariableNode(name: NameNode(value: 'topic')),
          type: NamedTypeNode(
            name: NameNode(value: 'PostTopic'),
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
            name: NameNode(value: 'nearbyPosts'),
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
                name: NameNode(value: 'topic'),
                value: VariableNode(name: NameNode(value: 'topic')),
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
                            FragmentSpreadNode(
                              name: NameNode(value: 'PostCardFields'),
                              directives: [],
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
    fragmentDefinitionPostCardFields,
  ],
);

class Query$NearbyPosts$nearbyPosts {
  Query$NearbyPosts$nearbyPosts({required this.edges, required this.pageInfo});

  factory Query$NearbyPosts$nearbyPosts.fromJson(Map<String, dynamic> json) {
    final l$edges = json['edges'];
    final l$pageInfo = json['pageInfo'];
    return Query$NearbyPosts$nearbyPosts(
      edges: (l$edges as List<dynamic>)
          .map(
            (e) => Query$NearbyPosts$nearbyPosts$edges.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      pageInfo: Query$NearbyPosts$nearbyPosts$pageInfo.fromJson(
        (l$pageInfo as Map<String, dynamic>),
      ),
    );
  }

  final List<Query$NearbyPosts$nearbyPosts$edges> edges;

  final Query$NearbyPosts$nearbyPosts$pageInfo pageInfo;

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
    if (other is! Query$NearbyPosts$nearbyPosts ||
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

extension UtilityExtension$Query$NearbyPosts$nearbyPosts
    on Query$NearbyPosts$nearbyPosts {
  CopyWith$Query$NearbyPosts$nearbyPosts<Query$NearbyPosts$nearbyPosts>
  get copyWith => CopyWith$Query$NearbyPosts$nearbyPosts(this, (i) => i);
}

abstract class CopyWith$Query$NearbyPosts$nearbyPosts<TRes> {
  factory CopyWith$Query$NearbyPosts$nearbyPosts(
    Query$NearbyPosts$nearbyPosts instance,
    TRes Function(Query$NearbyPosts$nearbyPosts) then,
  ) = _CopyWithImpl$Query$NearbyPosts$nearbyPosts;

  factory CopyWith$Query$NearbyPosts$nearbyPosts.stub(TRes res) =
      _CopyWithStubImpl$Query$NearbyPosts$nearbyPosts;

  TRes call({
    List<Query$NearbyPosts$nearbyPosts$edges>? edges,
    Query$NearbyPosts$nearbyPosts$pageInfo? pageInfo,
  });
  TRes edges(
    Iterable<Query$NearbyPosts$nearbyPosts$edges> Function(
      Iterable<
        CopyWith$Query$NearbyPosts$nearbyPosts$edges<
          Query$NearbyPosts$nearbyPosts$edges
        >
      >,
    )
    _fn,
  );
  CopyWith$Query$NearbyPosts$nearbyPosts$pageInfo<TRes> get pageInfo;
}

class _CopyWithImpl$Query$NearbyPosts$nearbyPosts<TRes>
    implements CopyWith$Query$NearbyPosts$nearbyPosts<TRes> {
  _CopyWithImpl$Query$NearbyPosts$nearbyPosts(this._instance, this._then);

  final Query$NearbyPosts$nearbyPosts _instance;

  final TRes Function(Query$NearbyPosts$nearbyPosts) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? edges = _undefined, Object? pageInfo = _undefined}) =>
      _then(
        Query$NearbyPosts$nearbyPosts(
          edges: edges == _undefined || edges == null
              ? _instance.edges
              : (edges as List<Query$NearbyPosts$nearbyPosts$edges>),
          pageInfo: pageInfo == _undefined || pageInfo == null
              ? _instance.pageInfo
              : (pageInfo as Query$NearbyPosts$nearbyPosts$pageInfo),
        ),
      );

  TRes edges(
    Iterable<Query$NearbyPosts$nearbyPosts$edges> Function(
      Iterable<
        CopyWith$Query$NearbyPosts$nearbyPosts$edges<
          Query$NearbyPosts$nearbyPosts$edges
        >
      >,
    )
    _fn,
  ) => call(
    edges: _fn(
      _instance.edges.map(
        (e) => CopyWith$Query$NearbyPosts$nearbyPosts$edges(e, (i) => i),
      ),
    ).toList(),
  );

  CopyWith$Query$NearbyPosts$nearbyPosts$pageInfo<TRes> get pageInfo {
    final local$pageInfo = _instance.pageInfo;
    return CopyWith$Query$NearbyPosts$nearbyPosts$pageInfo(
      local$pageInfo,
      (e) => call(pageInfo: e),
    );
  }
}

class _CopyWithStubImpl$Query$NearbyPosts$nearbyPosts<TRes>
    implements CopyWith$Query$NearbyPosts$nearbyPosts<TRes> {
  _CopyWithStubImpl$Query$NearbyPosts$nearbyPosts(this._res);

  TRes _res;

  call({
    List<Query$NearbyPosts$nearbyPosts$edges>? edges,
    Query$NearbyPosts$nearbyPosts$pageInfo? pageInfo,
  }) => _res;

  edges(_fn) => _res;

  CopyWith$Query$NearbyPosts$nearbyPosts$pageInfo<TRes> get pageInfo =>
      CopyWith$Query$NearbyPosts$nearbyPosts$pageInfo.stub(_res);
}

class Query$NearbyPosts$nearbyPosts$edges {
  Query$NearbyPosts$nearbyPosts$edges({
    required this.cursor,
    required this.node,
  });

  factory Query$NearbyPosts$nearbyPosts$edges.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$cursor = json['cursor'];
    final l$node = json['node'];
    return Query$NearbyPosts$nearbyPosts$edges(
      cursor: (l$cursor as String),
      node: Fragment$PostCardFields.fromJson((l$node as Map<String, dynamic>)),
    );
  }

  final String cursor;

  final Fragment$PostCardFields node;

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
    if (other is! Query$NearbyPosts$nearbyPosts$edges ||
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

extension UtilityExtension$Query$NearbyPosts$nearbyPosts$edges
    on Query$NearbyPosts$nearbyPosts$edges {
  CopyWith$Query$NearbyPosts$nearbyPosts$edges<
    Query$NearbyPosts$nearbyPosts$edges
  >
  get copyWith => CopyWith$Query$NearbyPosts$nearbyPosts$edges(this, (i) => i);
}

abstract class CopyWith$Query$NearbyPosts$nearbyPosts$edges<TRes> {
  factory CopyWith$Query$NearbyPosts$nearbyPosts$edges(
    Query$NearbyPosts$nearbyPosts$edges instance,
    TRes Function(Query$NearbyPosts$nearbyPosts$edges) then,
  ) = _CopyWithImpl$Query$NearbyPosts$nearbyPosts$edges;

  factory CopyWith$Query$NearbyPosts$nearbyPosts$edges.stub(TRes res) =
      _CopyWithStubImpl$Query$NearbyPosts$nearbyPosts$edges;

  TRes call({String? cursor, Fragment$PostCardFields? node});
  CopyWith$Fragment$PostCardFields<TRes> get node;
}

class _CopyWithImpl$Query$NearbyPosts$nearbyPosts$edges<TRes>
    implements CopyWith$Query$NearbyPosts$nearbyPosts$edges<TRes> {
  _CopyWithImpl$Query$NearbyPosts$nearbyPosts$edges(this._instance, this._then);

  final Query$NearbyPosts$nearbyPosts$edges _instance;

  final TRes Function(Query$NearbyPosts$nearbyPosts$edges) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? cursor = _undefined, Object? node = _undefined}) => _then(
    Query$NearbyPosts$nearbyPosts$edges(
      cursor: cursor == _undefined || cursor == null
          ? _instance.cursor
          : (cursor as String),
      node: node == _undefined || node == null
          ? _instance.node
          : (node as Fragment$PostCardFields),
    ),
  );

  CopyWith$Fragment$PostCardFields<TRes> get node {
    final local$node = _instance.node;
    return CopyWith$Fragment$PostCardFields(local$node, (e) => call(node: e));
  }
}

class _CopyWithStubImpl$Query$NearbyPosts$nearbyPosts$edges<TRes>
    implements CopyWith$Query$NearbyPosts$nearbyPosts$edges<TRes> {
  _CopyWithStubImpl$Query$NearbyPosts$nearbyPosts$edges(this._res);

  TRes _res;

  call({String? cursor, Fragment$PostCardFields? node}) => _res;

  CopyWith$Fragment$PostCardFields<TRes> get node =>
      CopyWith$Fragment$PostCardFields.stub(_res);
}

class Query$NearbyPosts$nearbyPosts$pageInfo {
  Query$NearbyPosts$nearbyPosts$pageInfo({
    required this.hasNextPage,
    this.endCursor,
  });

  factory Query$NearbyPosts$nearbyPosts$pageInfo.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$hasNextPage = json['hasNextPage'];
    final l$endCursor = json['endCursor'];
    return Query$NearbyPosts$nearbyPosts$pageInfo(
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
    if (other is! Query$NearbyPosts$nearbyPosts$pageInfo ||
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

extension UtilityExtension$Query$NearbyPosts$nearbyPosts$pageInfo
    on Query$NearbyPosts$nearbyPosts$pageInfo {
  CopyWith$Query$NearbyPosts$nearbyPosts$pageInfo<
    Query$NearbyPosts$nearbyPosts$pageInfo
  >
  get copyWith =>
      CopyWith$Query$NearbyPosts$nearbyPosts$pageInfo(this, (i) => i);
}

abstract class CopyWith$Query$NearbyPosts$nearbyPosts$pageInfo<TRes> {
  factory CopyWith$Query$NearbyPosts$nearbyPosts$pageInfo(
    Query$NearbyPosts$nearbyPosts$pageInfo instance,
    TRes Function(Query$NearbyPosts$nearbyPosts$pageInfo) then,
  ) = _CopyWithImpl$Query$NearbyPosts$nearbyPosts$pageInfo;

  factory CopyWith$Query$NearbyPosts$nearbyPosts$pageInfo.stub(TRes res) =
      _CopyWithStubImpl$Query$NearbyPosts$nearbyPosts$pageInfo;

  TRes call({bool? hasNextPage, String? endCursor});
}

class _CopyWithImpl$Query$NearbyPosts$nearbyPosts$pageInfo<TRes>
    implements CopyWith$Query$NearbyPosts$nearbyPosts$pageInfo<TRes> {
  _CopyWithImpl$Query$NearbyPosts$nearbyPosts$pageInfo(
    this._instance,
    this._then,
  );

  final Query$NearbyPosts$nearbyPosts$pageInfo _instance;

  final TRes Function(Query$NearbyPosts$nearbyPosts$pageInfo) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? hasNextPage = _undefined,
    Object? endCursor = _undefined,
  }) => _then(
    Query$NearbyPosts$nearbyPosts$pageInfo(
      hasNextPage: hasNextPage == _undefined || hasNextPage == null
          ? _instance.hasNextPage
          : (hasNextPage as bool),
      endCursor: endCursor == _undefined
          ? _instance.endCursor
          : (endCursor as String?),
    ),
  );
}

class _CopyWithStubImpl$Query$NearbyPosts$nearbyPosts$pageInfo<TRes>
    implements CopyWith$Query$NearbyPosts$nearbyPosts$pageInfo<TRes> {
  _CopyWithStubImpl$Query$NearbyPosts$nearbyPosts$pageInfo(this._res);

  TRes _res;

  call({bool? hasNextPage, String? endCursor}) => _res;
}

class Variables$Query$TargetPosts {
  factory Variables$Query$TargetPosts({
    required Enum$PostTargetType targetType,
    required String targetId,
    Enum$PostTopic? topic,
    int? first,
    String? after,
  }) => Variables$Query$TargetPosts._({
    r'targetType': targetType,
    r'targetId': targetId,
    if (topic != null) r'topic': topic,
    if (first != null) r'first': first,
    if (after != null) r'after': after,
  });

  Variables$Query$TargetPosts._(this._$data);

  factory Variables$Query$TargetPosts.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$targetType = data['targetType'];
    result$data['targetType'] = fromJson$Enum$PostTargetType(
      (l$targetType as String),
    );
    final l$targetId = data['targetId'];
    result$data['targetId'] = (l$targetId as String);
    if (data.containsKey('topic')) {
      final l$topic = data['topic'];
      result$data['topic'] = l$topic == null
          ? null
          : fromJson$Enum$PostTopic((l$topic as String));
    }
    if (data.containsKey('first')) {
      final l$first = data['first'];
      result$data['first'] = (l$first as int?);
    }
    if (data.containsKey('after')) {
      final l$after = data['after'];
      result$data['after'] = (l$after as String?);
    }
    return Variables$Query$TargetPosts._(result$data);
  }

  Map<String, dynamic> _$data;

  Enum$PostTargetType get targetType =>
      (_$data['targetType'] as Enum$PostTargetType);

  String get targetId => (_$data['targetId'] as String);

  Enum$PostTopic? get topic => (_$data['topic'] as Enum$PostTopic?);

  int? get first => (_$data['first'] as int?);

  String? get after => (_$data['after'] as String?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$targetType = targetType;
    result$data['targetType'] = toJson$Enum$PostTargetType(l$targetType);
    final l$targetId = targetId;
    result$data['targetId'] = l$targetId;
    if (_$data.containsKey('topic')) {
      final l$topic = topic;
      result$data['topic'] = l$topic == null
          ? null
          : toJson$Enum$PostTopic(l$topic);
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

  CopyWith$Variables$Query$TargetPosts<Variables$Query$TargetPosts>
  get copyWith => CopyWith$Variables$Query$TargetPosts(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Query$TargetPosts ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$targetType = targetType;
    final lOther$targetType = other.targetType;
    if (l$targetType != lOther$targetType) {
      return false;
    }
    final l$targetId = targetId;
    final lOther$targetId = other.targetId;
    if (l$targetId != lOther$targetId) {
      return false;
    }
    final l$topic = topic;
    final lOther$topic = other.topic;
    if (_$data.containsKey('topic') != other._$data.containsKey('topic')) {
      return false;
    }
    if (l$topic != lOther$topic) {
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
    final l$targetType = targetType;
    final l$targetId = targetId;
    final l$topic = topic;
    final l$first = first;
    final l$after = after;
    return Object.hashAll([
      l$targetType,
      l$targetId,
      _$data.containsKey('topic') ? l$topic : const {},
      _$data.containsKey('first') ? l$first : const {},
      _$data.containsKey('after') ? l$after : const {},
    ]);
  }
}

abstract class CopyWith$Variables$Query$TargetPosts<TRes> {
  factory CopyWith$Variables$Query$TargetPosts(
    Variables$Query$TargetPosts instance,
    TRes Function(Variables$Query$TargetPosts) then,
  ) = _CopyWithImpl$Variables$Query$TargetPosts;

  factory CopyWith$Variables$Query$TargetPosts.stub(TRes res) =
      _CopyWithStubImpl$Variables$Query$TargetPosts;

  TRes call({
    Enum$PostTargetType? targetType,
    String? targetId,
    Enum$PostTopic? topic,
    int? first,
    String? after,
  });
}

class _CopyWithImpl$Variables$Query$TargetPosts<TRes>
    implements CopyWith$Variables$Query$TargetPosts<TRes> {
  _CopyWithImpl$Variables$Query$TargetPosts(this._instance, this._then);

  final Variables$Query$TargetPosts _instance;

  final TRes Function(Variables$Query$TargetPosts) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? targetType = _undefined,
    Object? targetId = _undefined,
    Object? topic = _undefined,
    Object? first = _undefined,
    Object? after = _undefined,
  }) => _then(
    Variables$Query$TargetPosts._({
      ..._instance._$data,
      if (targetType != _undefined && targetType != null)
        'targetType': (targetType as Enum$PostTargetType),
      if (targetId != _undefined && targetId != null)
        'targetId': (targetId as String),
      if (topic != _undefined) 'topic': (topic as Enum$PostTopic?),
      if (first != _undefined) 'first': (first as int?),
      if (after != _undefined) 'after': (after as String?),
    }),
  );
}

class _CopyWithStubImpl$Variables$Query$TargetPosts<TRes>
    implements CopyWith$Variables$Query$TargetPosts<TRes> {
  _CopyWithStubImpl$Variables$Query$TargetPosts(this._res);

  TRes _res;

  call({
    Enum$PostTargetType? targetType,
    String? targetId,
    Enum$PostTopic? topic,
    int? first,
    String? after,
  }) => _res;
}

class Query$TargetPosts {
  Query$TargetPosts({required this.targetPosts});

  factory Query$TargetPosts.fromJson(Map<String, dynamic> json) {
    final l$targetPosts = json['targetPosts'];
    return Query$TargetPosts(
      targetPosts: Query$TargetPosts$targetPosts.fromJson(
        (l$targetPosts as Map<String, dynamic>),
      ),
    );
  }

  final Query$TargetPosts$targetPosts targetPosts;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$targetPosts = targetPosts;
    _resultData['targetPosts'] = l$targetPosts.toJson();
    return _resultData;
  }

  @override
  int get hashCode {
    final l$targetPosts = targetPosts;
    return Object.hashAll([l$targetPosts]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$TargetPosts || runtimeType != other.runtimeType) {
      return false;
    }
    final l$targetPosts = targetPosts;
    final lOther$targetPosts = other.targetPosts;
    if (l$targetPosts != lOther$targetPosts) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Query$TargetPosts on Query$TargetPosts {
  CopyWith$Query$TargetPosts<Query$TargetPosts> get copyWith =>
      CopyWith$Query$TargetPosts(this, (i) => i);
}

abstract class CopyWith$Query$TargetPosts<TRes> {
  factory CopyWith$Query$TargetPosts(
    Query$TargetPosts instance,
    TRes Function(Query$TargetPosts) then,
  ) = _CopyWithImpl$Query$TargetPosts;

  factory CopyWith$Query$TargetPosts.stub(TRes res) =
      _CopyWithStubImpl$Query$TargetPosts;

  TRes call({Query$TargetPosts$targetPosts? targetPosts});
  CopyWith$Query$TargetPosts$targetPosts<TRes> get targetPosts;
}

class _CopyWithImpl$Query$TargetPosts<TRes>
    implements CopyWith$Query$TargetPosts<TRes> {
  _CopyWithImpl$Query$TargetPosts(this._instance, this._then);

  final Query$TargetPosts _instance;

  final TRes Function(Query$TargetPosts) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? targetPosts = _undefined}) => _then(
    Query$TargetPosts(
      targetPosts: targetPosts == _undefined || targetPosts == null
          ? _instance.targetPosts
          : (targetPosts as Query$TargetPosts$targetPosts),
    ),
  );

  CopyWith$Query$TargetPosts$targetPosts<TRes> get targetPosts {
    final local$targetPosts = _instance.targetPosts;
    return CopyWith$Query$TargetPosts$targetPosts(
      local$targetPosts,
      (e) => call(targetPosts: e),
    );
  }
}

class _CopyWithStubImpl$Query$TargetPosts<TRes>
    implements CopyWith$Query$TargetPosts<TRes> {
  _CopyWithStubImpl$Query$TargetPosts(this._res);

  TRes _res;

  call({Query$TargetPosts$targetPosts? targetPosts}) => _res;

  CopyWith$Query$TargetPosts$targetPosts<TRes> get targetPosts =>
      CopyWith$Query$TargetPosts$targetPosts.stub(_res);
}

const documentNodeQueryTargetPosts = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'TargetPosts'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'targetType')),
          type: NamedTypeNode(
            name: NameNode(value: 'PostTargetType'),
            isNonNull: true,
          ),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'targetId')),
          type: NamedTypeNode(name: NameNode(value: 'ID'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'topic')),
          type: NamedTypeNode(
            name: NameNode(value: 'PostTopic'),
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
            name: NameNode(value: 'targetPosts'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'targetType'),
                value: VariableNode(name: NameNode(value: 'targetType')),
              ),
              ArgumentNode(
                name: NameNode(value: 'targetId'),
                value: VariableNode(name: NameNode(value: 'targetId')),
              ),
              ArgumentNode(
                name: NameNode(value: 'topic'),
                value: VariableNode(name: NameNode(value: 'topic')),
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
                            FragmentSpreadNode(
                              name: NameNode(value: 'PostCardFields'),
                              directives: [],
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
    fragmentDefinitionPostCardFields,
  ],
);

class Query$TargetPosts$targetPosts {
  Query$TargetPosts$targetPosts({required this.edges, required this.pageInfo});

  factory Query$TargetPosts$targetPosts.fromJson(Map<String, dynamic> json) {
    final l$edges = json['edges'];
    final l$pageInfo = json['pageInfo'];
    return Query$TargetPosts$targetPosts(
      edges: (l$edges as List<dynamic>)
          .map(
            (e) => Query$TargetPosts$targetPosts$edges.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      pageInfo: Query$TargetPosts$targetPosts$pageInfo.fromJson(
        (l$pageInfo as Map<String, dynamic>),
      ),
    );
  }

  final List<Query$TargetPosts$targetPosts$edges> edges;

  final Query$TargetPosts$targetPosts$pageInfo pageInfo;

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
    if (other is! Query$TargetPosts$targetPosts ||
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

extension UtilityExtension$Query$TargetPosts$targetPosts
    on Query$TargetPosts$targetPosts {
  CopyWith$Query$TargetPosts$targetPosts<Query$TargetPosts$targetPosts>
  get copyWith => CopyWith$Query$TargetPosts$targetPosts(this, (i) => i);
}

abstract class CopyWith$Query$TargetPosts$targetPosts<TRes> {
  factory CopyWith$Query$TargetPosts$targetPosts(
    Query$TargetPosts$targetPosts instance,
    TRes Function(Query$TargetPosts$targetPosts) then,
  ) = _CopyWithImpl$Query$TargetPosts$targetPosts;

  factory CopyWith$Query$TargetPosts$targetPosts.stub(TRes res) =
      _CopyWithStubImpl$Query$TargetPosts$targetPosts;

  TRes call({
    List<Query$TargetPosts$targetPosts$edges>? edges,
    Query$TargetPosts$targetPosts$pageInfo? pageInfo,
  });
  TRes edges(
    Iterable<Query$TargetPosts$targetPosts$edges> Function(
      Iterable<
        CopyWith$Query$TargetPosts$targetPosts$edges<
          Query$TargetPosts$targetPosts$edges
        >
      >,
    )
    _fn,
  );
  CopyWith$Query$TargetPosts$targetPosts$pageInfo<TRes> get pageInfo;
}

class _CopyWithImpl$Query$TargetPosts$targetPosts<TRes>
    implements CopyWith$Query$TargetPosts$targetPosts<TRes> {
  _CopyWithImpl$Query$TargetPosts$targetPosts(this._instance, this._then);

  final Query$TargetPosts$targetPosts _instance;

  final TRes Function(Query$TargetPosts$targetPosts) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? edges = _undefined, Object? pageInfo = _undefined}) =>
      _then(
        Query$TargetPosts$targetPosts(
          edges: edges == _undefined || edges == null
              ? _instance.edges
              : (edges as List<Query$TargetPosts$targetPosts$edges>),
          pageInfo: pageInfo == _undefined || pageInfo == null
              ? _instance.pageInfo
              : (pageInfo as Query$TargetPosts$targetPosts$pageInfo),
        ),
      );

  TRes edges(
    Iterable<Query$TargetPosts$targetPosts$edges> Function(
      Iterable<
        CopyWith$Query$TargetPosts$targetPosts$edges<
          Query$TargetPosts$targetPosts$edges
        >
      >,
    )
    _fn,
  ) => call(
    edges: _fn(
      _instance.edges.map(
        (e) => CopyWith$Query$TargetPosts$targetPosts$edges(e, (i) => i),
      ),
    ).toList(),
  );

  CopyWith$Query$TargetPosts$targetPosts$pageInfo<TRes> get pageInfo {
    final local$pageInfo = _instance.pageInfo;
    return CopyWith$Query$TargetPosts$targetPosts$pageInfo(
      local$pageInfo,
      (e) => call(pageInfo: e),
    );
  }
}

class _CopyWithStubImpl$Query$TargetPosts$targetPosts<TRes>
    implements CopyWith$Query$TargetPosts$targetPosts<TRes> {
  _CopyWithStubImpl$Query$TargetPosts$targetPosts(this._res);

  TRes _res;

  call({
    List<Query$TargetPosts$targetPosts$edges>? edges,
    Query$TargetPosts$targetPosts$pageInfo? pageInfo,
  }) => _res;

  edges(_fn) => _res;

  CopyWith$Query$TargetPosts$targetPosts$pageInfo<TRes> get pageInfo =>
      CopyWith$Query$TargetPosts$targetPosts$pageInfo.stub(_res);
}

class Query$TargetPosts$targetPosts$edges {
  Query$TargetPosts$targetPosts$edges({
    required this.cursor,
    required this.node,
  });

  factory Query$TargetPosts$targetPosts$edges.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$cursor = json['cursor'];
    final l$node = json['node'];
    return Query$TargetPosts$targetPosts$edges(
      cursor: (l$cursor as String),
      node: Fragment$PostCardFields.fromJson((l$node as Map<String, dynamic>)),
    );
  }

  final String cursor;

  final Fragment$PostCardFields node;

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
    if (other is! Query$TargetPosts$targetPosts$edges ||
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

extension UtilityExtension$Query$TargetPosts$targetPosts$edges
    on Query$TargetPosts$targetPosts$edges {
  CopyWith$Query$TargetPosts$targetPosts$edges<
    Query$TargetPosts$targetPosts$edges
  >
  get copyWith => CopyWith$Query$TargetPosts$targetPosts$edges(this, (i) => i);
}

abstract class CopyWith$Query$TargetPosts$targetPosts$edges<TRes> {
  factory CopyWith$Query$TargetPosts$targetPosts$edges(
    Query$TargetPosts$targetPosts$edges instance,
    TRes Function(Query$TargetPosts$targetPosts$edges) then,
  ) = _CopyWithImpl$Query$TargetPosts$targetPosts$edges;

  factory CopyWith$Query$TargetPosts$targetPosts$edges.stub(TRes res) =
      _CopyWithStubImpl$Query$TargetPosts$targetPosts$edges;

  TRes call({String? cursor, Fragment$PostCardFields? node});
  CopyWith$Fragment$PostCardFields<TRes> get node;
}

class _CopyWithImpl$Query$TargetPosts$targetPosts$edges<TRes>
    implements CopyWith$Query$TargetPosts$targetPosts$edges<TRes> {
  _CopyWithImpl$Query$TargetPosts$targetPosts$edges(this._instance, this._then);

  final Query$TargetPosts$targetPosts$edges _instance;

  final TRes Function(Query$TargetPosts$targetPosts$edges) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? cursor = _undefined, Object? node = _undefined}) => _then(
    Query$TargetPosts$targetPosts$edges(
      cursor: cursor == _undefined || cursor == null
          ? _instance.cursor
          : (cursor as String),
      node: node == _undefined || node == null
          ? _instance.node
          : (node as Fragment$PostCardFields),
    ),
  );

  CopyWith$Fragment$PostCardFields<TRes> get node {
    final local$node = _instance.node;
    return CopyWith$Fragment$PostCardFields(local$node, (e) => call(node: e));
  }
}

class _CopyWithStubImpl$Query$TargetPosts$targetPosts$edges<TRes>
    implements CopyWith$Query$TargetPosts$targetPosts$edges<TRes> {
  _CopyWithStubImpl$Query$TargetPosts$targetPosts$edges(this._res);

  TRes _res;

  call({String? cursor, Fragment$PostCardFields? node}) => _res;

  CopyWith$Fragment$PostCardFields<TRes> get node =>
      CopyWith$Fragment$PostCardFields.stub(_res);
}

class Query$TargetPosts$targetPosts$pageInfo {
  Query$TargetPosts$targetPosts$pageInfo({
    required this.hasNextPage,
    this.endCursor,
  });

  factory Query$TargetPosts$targetPosts$pageInfo.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$hasNextPage = json['hasNextPage'];
    final l$endCursor = json['endCursor'];
    return Query$TargetPosts$targetPosts$pageInfo(
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
    if (other is! Query$TargetPosts$targetPosts$pageInfo ||
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

extension UtilityExtension$Query$TargetPosts$targetPosts$pageInfo
    on Query$TargetPosts$targetPosts$pageInfo {
  CopyWith$Query$TargetPosts$targetPosts$pageInfo<
    Query$TargetPosts$targetPosts$pageInfo
  >
  get copyWith =>
      CopyWith$Query$TargetPosts$targetPosts$pageInfo(this, (i) => i);
}

abstract class CopyWith$Query$TargetPosts$targetPosts$pageInfo<TRes> {
  factory CopyWith$Query$TargetPosts$targetPosts$pageInfo(
    Query$TargetPosts$targetPosts$pageInfo instance,
    TRes Function(Query$TargetPosts$targetPosts$pageInfo) then,
  ) = _CopyWithImpl$Query$TargetPosts$targetPosts$pageInfo;

  factory CopyWith$Query$TargetPosts$targetPosts$pageInfo.stub(TRes res) =
      _CopyWithStubImpl$Query$TargetPosts$targetPosts$pageInfo;

  TRes call({bool? hasNextPage, String? endCursor});
}

class _CopyWithImpl$Query$TargetPosts$targetPosts$pageInfo<TRes>
    implements CopyWith$Query$TargetPosts$targetPosts$pageInfo<TRes> {
  _CopyWithImpl$Query$TargetPosts$targetPosts$pageInfo(
    this._instance,
    this._then,
  );

  final Query$TargetPosts$targetPosts$pageInfo _instance;

  final TRes Function(Query$TargetPosts$targetPosts$pageInfo) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? hasNextPage = _undefined,
    Object? endCursor = _undefined,
  }) => _then(
    Query$TargetPosts$targetPosts$pageInfo(
      hasNextPage: hasNextPage == _undefined || hasNextPage == null
          ? _instance.hasNextPage
          : (hasNextPage as bool),
      endCursor: endCursor == _undefined
          ? _instance.endCursor
          : (endCursor as String?),
    ),
  );
}

class _CopyWithStubImpl$Query$TargetPosts$targetPosts$pageInfo<TRes>
    implements CopyWith$Query$TargetPosts$targetPosts$pageInfo<TRes> {
  _CopyWithStubImpl$Query$TargetPosts$targetPosts$pageInfo(this._res);

  TRes _res;

  call({bool? hasNextPage, String? endCursor}) => _res;
}

class Variables$Query$PostDetail {
  factory Variables$Query$PostDetail({
    required String id,
    int? commentCount,
    required bool withComments,
  }) => Variables$Query$PostDetail._({
    r'id': id,
    if (commentCount != null) r'commentCount': commentCount,
    r'withComments': withComments,
  });

  Variables$Query$PostDetail._(this._$data);

  factory Variables$Query$PostDetail.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$id = data['id'];
    result$data['id'] = (l$id as String);
    if (data.containsKey('commentCount')) {
      final l$commentCount = data['commentCount'];
      result$data['commentCount'] = (l$commentCount as int?);
    }
    final l$withComments = data['withComments'];
    result$data['withComments'] = (l$withComments as bool);
    return Variables$Query$PostDetail._(result$data);
  }

  Map<String, dynamic> _$data;

  String get id => (_$data['id'] as String);

  int? get commentCount => (_$data['commentCount'] as int?);

  bool get withComments => (_$data['withComments'] as bool);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$id = id;
    result$data['id'] = l$id;
    if (_$data.containsKey('commentCount')) {
      final l$commentCount = commentCount;
      result$data['commentCount'] = l$commentCount;
    }
    final l$withComments = withComments;
    result$data['withComments'] = l$withComments;
    return result$data;
  }

  CopyWith$Variables$Query$PostDetail<Variables$Query$PostDetail>
  get copyWith => CopyWith$Variables$Query$PostDetail(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Query$PostDetail ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$commentCount = commentCount;
    final lOther$commentCount = other.commentCount;
    if (_$data.containsKey('commentCount') !=
        other._$data.containsKey('commentCount')) {
      return false;
    }
    if (l$commentCount != lOther$commentCount) {
      return false;
    }
    final l$withComments = withComments;
    final lOther$withComments = other.withComments;
    if (l$withComments != lOther$withComments) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$commentCount = commentCount;
    final l$withComments = withComments;
    return Object.hashAll([
      l$id,
      _$data.containsKey('commentCount') ? l$commentCount : const {},
      l$withComments,
    ]);
  }
}

abstract class CopyWith$Variables$Query$PostDetail<TRes> {
  factory CopyWith$Variables$Query$PostDetail(
    Variables$Query$PostDetail instance,
    TRes Function(Variables$Query$PostDetail) then,
  ) = _CopyWithImpl$Variables$Query$PostDetail;

  factory CopyWith$Variables$Query$PostDetail.stub(TRes res) =
      _CopyWithStubImpl$Variables$Query$PostDetail;

  TRes call({String? id, int? commentCount, bool? withComments});
}

class _CopyWithImpl$Variables$Query$PostDetail<TRes>
    implements CopyWith$Variables$Query$PostDetail<TRes> {
  _CopyWithImpl$Variables$Query$PostDetail(this._instance, this._then);

  final Variables$Query$PostDetail _instance;

  final TRes Function(Variables$Query$PostDetail) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? commentCount = _undefined,
    Object? withComments = _undefined,
  }) => _then(
    Variables$Query$PostDetail._({
      ..._instance._$data,
      if (id != _undefined && id != null) 'id': (id as String),
      if (commentCount != _undefined) 'commentCount': (commentCount as int?),
      if (withComments != _undefined && withComments != null)
        'withComments': (withComments as bool),
    }),
  );
}

class _CopyWithStubImpl$Variables$Query$PostDetail<TRes>
    implements CopyWith$Variables$Query$PostDetail<TRes> {
  _CopyWithStubImpl$Variables$Query$PostDetail(this._res);

  TRes _res;

  call({String? id, int? commentCount, bool? withComments}) => _res;
}

class Query$PostDetail {
  Query$PostDetail({this.post});

  factory Query$PostDetail.fromJson(Map<String, dynamic> json) {
    final l$post = json['post'];
    return Query$PostDetail(
      post: l$post == null
          ? null
          : Query$PostDetail$post.fromJson((l$post as Map<String, dynamic>)),
    );
  }

  final Query$PostDetail$post? post;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$post = post;
    _resultData['post'] = l$post?.toJson();
    return _resultData;
  }

  @override
  int get hashCode {
    final l$post = post;
    return Object.hashAll([l$post]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$PostDetail || runtimeType != other.runtimeType) {
      return false;
    }
    final l$post = post;
    final lOther$post = other.post;
    if (l$post != lOther$post) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Query$PostDetail on Query$PostDetail {
  CopyWith$Query$PostDetail<Query$PostDetail> get copyWith =>
      CopyWith$Query$PostDetail(this, (i) => i);
}

abstract class CopyWith$Query$PostDetail<TRes> {
  factory CopyWith$Query$PostDetail(
    Query$PostDetail instance,
    TRes Function(Query$PostDetail) then,
  ) = _CopyWithImpl$Query$PostDetail;

  factory CopyWith$Query$PostDetail.stub(TRes res) =
      _CopyWithStubImpl$Query$PostDetail;

  TRes call({Query$PostDetail$post? post});
  CopyWith$Query$PostDetail$post<TRes> get post;
}

class _CopyWithImpl$Query$PostDetail<TRes>
    implements CopyWith$Query$PostDetail<TRes> {
  _CopyWithImpl$Query$PostDetail(this._instance, this._then);

  final Query$PostDetail _instance;

  final TRes Function(Query$PostDetail) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? post = _undefined}) => _then(
    Query$PostDetail(
      post: post == _undefined
          ? _instance.post
          : (post as Query$PostDetail$post?),
    ),
  );

  CopyWith$Query$PostDetail$post<TRes> get post {
    final local$post = _instance.post;
    return local$post == null
        ? CopyWith$Query$PostDetail$post.stub(_then(_instance))
        : CopyWith$Query$PostDetail$post(local$post, (e) => call(post: e));
  }
}

class _CopyWithStubImpl$Query$PostDetail<TRes>
    implements CopyWith$Query$PostDetail<TRes> {
  _CopyWithStubImpl$Query$PostDetail(this._res);

  TRes _res;

  call({Query$PostDetail$post? post}) => _res;

  CopyWith$Query$PostDetail$post<TRes> get post =>
      CopyWith$Query$PostDetail$post.stub(_res);
}

const documentNodeQueryPostDetail = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'PostDetail'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'id')),
          type: NamedTypeNode(name: NameNode(value: 'ID'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'commentCount')),
          type: NamedTypeNode(name: NameNode(value: 'Int'), isNonNull: false),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'withComments')),
          type: NamedTypeNode(
            name: NameNode(value: 'Boolean'),
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
            name: NameNode(value: 'post'),
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
                  name: NameNode(value: 'PostCardFields'),
                  directives: [],
                ),
                FieldNode(
                  name: NameNode(value: 'comments'),
                  alias: null,
                  arguments: [
                    ArgumentNode(
                      name: NameNode(value: 'first'),
                      value: VariableNode(
                        name: NameNode(value: 'commentCount'),
                      ),
                    ),
                  ],
                  directives: [
                    DirectiveNode(
                      name: NameNode(value: 'include'),
                      arguments: [
                        ArgumentNode(
                          name: NameNode(value: 'if'),
                          value: VariableNode(
                            name: NameNode(value: 'withComments'),
                          ),
                        ),
                      ],
                    ),
                  ],
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
                                    name: NameNode(value: 'body'),
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
                                  FieldNode(
                                    name: NameNode(value: 'ownedByViewer'),
                                    alias: null,
                                    arguments: [],
                                    directives: [],
                                    selectionSet: null,
                                  ),
                                  FieldNode(
                                    name: NameNode(value: 'hidden'),
                                    alias: null,
                                    arguments: [],
                                    directives: [],
                                    selectionSet: null,
                                  ),
                                  FieldNode(
                                    name: NameNode(value: 'author'),
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
                                          name: NameNode(value: 'nickname'),
                                          alias: null,
                                          arguments: [],
                                          directives: [],
                                          selectionSet: null,
                                        ),
                                        FieldNode(
                                          name: NameNode(
                                            value: 'profileImageUrl',
                                          ),
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
    fragmentDefinitionPostCardFields,
  ],
);

class Query$PostDetail$post implements Fragment$PostCardFields {
  Query$PostDetail$post({
    required this.id,
    required this.body,
    required this.topic,
    required this.createdAt,
    required this.photoKeys,
    required this.likeCount,
    required this.commentCount,
    required this.likedByViewer,
    required this.ownedByViewer,
    required this.hidden,
    required this.target,
    required this.author,
    this.comments,
  });

  factory Query$PostDetail$post.fromJson(Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$body = json['body'];
    final l$topic = json['topic'];
    final l$createdAt = json['createdAt'];
    final l$photoKeys = json['photoKeys'];
    final l$likeCount = json['likeCount'];
    final l$commentCount = json['commentCount'];
    final l$likedByViewer = json['likedByViewer'];
    final l$ownedByViewer = json['ownedByViewer'];
    final l$hidden = json['hidden'];
    final l$target = json['target'];
    final l$author = json['author'];
    final l$comments = json['comments'];
    return Query$PostDetail$post(
      id: (l$id as String),
      body: (l$body as String),
      topic: fromJson$Enum$PostTopic((l$topic as String)),
      createdAt: (l$createdAt as String),
      photoKeys: (l$photoKeys as List<dynamic>)
          .map((e) => (e as String))
          .toList(),
      likeCount: (l$likeCount as int),
      commentCount: (l$commentCount as int),
      likedByViewer: (l$likedByViewer as bool),
      ownedByViewer: (l$ownedByViewer as bool),
      hidden: (l$hidden as bool),
      target: Query$PostDetail$post$target.fromJson(
        (l$target as Map<String, dynamic>),
      ),
      author: Query$PostDetail$post$author.fromJson(
        (l$author as Map<String, dynamic>),
      ),
      comments: l$comments == null
          ? null
          : Query$PostDetail$post$comments.fromJson(
              (l$comments as Map<String, dynamic>),
            ),
    );
  }

  final String id;

  final String body;

  final Enum$PostTopic topic;

  final String createdAt;

  final List<String> photoKeys;

  final int likeCount;

  final int commentCount;

  final bool likedByViewer;

  final bool ownedByViewer;

  final bool hidden;

  final Query$PostDetail$post$target target;

  final Query$PostDetail$post$author author;

  final Query$PostDetail$post$comments? comments;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$body = body;
    _resultData['body'] = l$body;
    final l$topic = topic;
    _resultData['topic'] = toJson$Enum$PostTopic(l$topic);
    final l$createdAt = createdAt;
    _resultData['createdAt'] = l$createdAt;
    final l$photoKeys = photoKeys;
    _resultData['photoKeys'] = l$photoKeys.map((e) => e).toList();
    final l$likeCount = likeCount;
    _resultData['likeCount'] = l$likeCount;
    final l$commentCount = commentCount;
    _resultData['commentCount'] = l$commentCount;
    final l$likedByViewer = likedByViewer;
    _resultData['likedByViewer'] = l$likedByViewer;
    final l$ownedByViewer = ownedByViewer;
    _resultData['ownedByViewer'] = l$ownedByViewer;
    final l$hidden = hidden;
    _resultData['hidden'] = l$hidden;
    final l$target = target;
    _resultData['target'] = l$target.toJson();
    final l$author = author;
    _resultData['author'] = l$author.toJson();
    final l$comments = comments;
    _resultData['comments'] = l$comments?.toJson();
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$body = body;
    final l$topic = topic;
    final l$createdAt = createdAt;
    final l$photoKeys = photoKeys;
    final l$likeCount = likeCount;
    final l$commentCount = commentCount;
    final l$likedByViewer = likedByViewer;
    final l$ownedByViewer = ownedByViewer;
    final l$hidden = hidden;
    final l$target = target;
    final l$author = author;
    final l$comments = comments;
    return Object.hashAll([
      l$id,
      l$body,
      l$topic,
      l$createdAt,
      Object.hashAll(l$photoKeys.map((v) => v)),
      l$likeCount,
      l$commentCount,
      l$likedByViewer,
      l$ownedByViewer,
      l$hidden,
      l$target,
      l$author,
      l$comments,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$PostDetail$post || runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$body = body;
    final lOther$body = other.body;
    if (l$body != lOther$body) {
      return false;
    }
    final l$topic = topic;
    final lOther$topic = other.topic;
    if (l$topic != lOther$topic) {
      return false;
    }
    final l$createdAt = createdAt;
    final lOther$createdAt = other.createdAt;
    if (l$createdAt != lOther$createdAt) {
      return false;
    }
    final l$photoKeys = photoKeys;
    final lOther$photoKeys = other.photoKeys;
    if (l$photoKeys.length != lOther$photoKeys.length) {
      return false;
    }
    for (int i = 0; i < l$photoKeys.length; i++) {
      final l$photoKeys$entry = l$photoKeys[i];
      final lOther$photoKeys$entry = lOther$photoKeys[i];
      if (l$photoKeys$entry != lOther$photoKeys$entry) {
        return false;
      }
    }
    final l$likeCount = likeCount;
    final lOther$likeCount = other.likeCount;
    if (l$likeCount != lOther$likeCount) {
      return false;
    }
    final l$commentCount = commentCount;
    final lOther$commentCount = other.commentCount;
    if (l$commentCount != lOther$commentCount) {
      return false;
    }
    final l$likedByViewer = likedByViewer;
    final lOther$likedByViewer = other.likedByViewer;
    if (l$likedByViewer != lOther$likedByViewer) {
      return false;
    }
    final l$ownedByViewer = ownedByViewer;
    final lOther$ownedByViewer = other.ownedByViewer;
    if (l$ownedByViewer != lOther$ownedByViewer) {
      return false;
    }
    final l$hidden = hidden;
    final lOther$hidden = other.hidden;
    if (l$hidden != lOther$hidden) {
      return false;
    }
    final l$target = target;
    final lOther$target = other.target;
    if (l$target != lOther$target) {
      return false;
    }
    final l$author = author;
    final lOther$author = other.author;
    if (l$author != lOther$author) {
      return false;
    }
    final l$comments = comments;
    final lOther$comments = other.comments;
    if (l$comments != lOther$comments) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Query$PostDetail$post on Query$PostDetail$post {
  CopyWith$Query$PostDetail$post<Query$PostDetail$post> get copyWith =>
      CopyWith$Query$PostDetail$post(this, (i) => i);
}

abstract class CopyWith$Query$PostDetail$post<TRes> {
  factory CopyWith$Query$PostDetail$post(
    Query$PostDetail$post instance,
    TRes Function(Query$PostDetail$post) then,
  ) = _CopyWithImpl$Query$PostDetail$post;

  factory CopyWith$Query$PostDetail$post.stub(TRes res) =
      _CopyWithStubImpl$Query$PostDetail$post;

  TRes call({
    String? id,
    String? body,
    Enum$PostTopic? topic,
    String? createdAt,
    List<String>? photoKeys,
    int? likeCount,
    int? commentCount,
    bool? likedByViewer,
    bool? ownedByViewer,
    bool? hidden,
    Query$PostDetail$post$target? target,
    Query$PostDetail$post$author? author,
    Query$PostDetail$post$comments? comments,
  });
  CopyWith$Query$PostDetail$post$target<TRes> get target;
  CopyWith$Query$PostDetail$post$author<TRes> get author;
  CopyWith$Query$PostDetail$post$comments<TRes> get comments;
}

class _CopyWithImpl$Query$PostDetail$post<TRes>
    implements CopyWith$Query$PostDetail$post<TRes> {
  _CopyWithImpl$Query$PostDetail$post(this._instance, this._then);

  final Query$PostDetail$post _instance;

  final TRes Function(Query$PostDetail$post) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? body = _undefined,
    Object? topic = _undefined,
    Object? createdAt = _undefined,
    Object? photoKeys = _undefined,
    Object? likeCount = _undefined,
    Object? commentCount = _undefined,
    Object? likedByViewer = _undefined,
    Object? ownedByViewer = _undefined,
    Object? hidden = _undefined,
    Object? target = _undefined,
    Object? author = _undefined,
    Object? comments = _undefined,
  }) => _then(
    Query$PostDetail$post(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      body: body == _undefined || body == null
          ? _instance.body
          : (body as String),
      topic: topic == _undefined || topic == null
          ? _instance.topic
          : (topic as Enum$PostTopic),
      createdAt: createdAt == _undefined || createdAt == null
          ? _instance.createdAt
          : (createdAt as String),
      photoKeys: photoKeys == _undefined || photoKeys == null
          ? _instance.photoKeys
          : (photoKeys as List<String>),
      likeCount: likeCount == _undefined || likeCount == null
          ? _instance.likeCount
          : (likeCount as int),
      commentCount: commentCount == _undefined || commentCount == null
          ? _instance.commentCount
          : (commentCount as int),
      likedByViewer: likedByViewer == _undefined || likedByViewer == null
          ? _instance.likedByViewer
          : (likedByViewer as bool),
      ownedByViewer: ownedByViewer == _undefined || ownedByViewer == null
          ? _instance.ownedByViewer
          : (ownedByViewer as bool),
      hidden: hidden == _undefined || hidden == null
          ? _instance.hidden
          : (hidden as bool),
      target: target == _undefined || target == null
          ? _instance.target
          : (target as Query$PostDetail$post$target),
      author: author == _undefined || author == null
          ? _instance.author
          : (author as Query$PostDetail$post$author),
      comments: comments == _undefined
          ? _instance.comments
          : (comments as Query$PostDetail$post$comments?),
    ),
  );

  CopyWith$Query$PostDetail$post$target<TRes> get target {
    final local$target = _instance.target;
    return CopyWith$Query$PostDetail$post$target(
      local$target,
      (e) => call(target: e),
    );
  }

  CopyWith$Query$PostDetail$post$author<TRes> get author {
    final local$author = _instance.author;
    return CopyWith$Query$PostDetail$post$author(
      local$author,
      (e) => call(author: e),
    );
  }

  CopyWith$Query$PostDetail$post$comments<TRes> get comments {
    final local$comments = _instance.comments;
    return local$comments == null
        ? CopyWith$Query$PostDetail$post$comments.stub(_then(_instance))
        : CopyWith$Query$PostDetail$post$comments(
            local$comments,
            (e) => call(comments: e),
          );
  }
}

class _CopyWithStubImpl$Query$PostDetail$post<TRes>
    implements CopyWith$Query$PostDetail$post<TRes> {
  _CopyWithStubImpl$Query$PostDetail$post(this._res);

  TRes _res;

  call({
    String? id,
    String? body,
    Enum$PostTopic? topic,
    String? createdAt,
    List<String>? photoKeys,
    int? likeCount,
    int? commentCount,
    bool? likedByViewer,
    bool? ownedByViewer,
    bool? hidden,
    Query$PostDetail$post$target? target,
    Query$PostDetail$post$author? author,
    Query$PostDetail$post$comments? comments,
  }) => _res;

  CopyWith$Query$PostDetail$post$target<TRes> get target =>
      CopyWith$Query$PostDetail$post$target.stub(_res);

  CopyWith$Query$PostDetail$post$author<TRes> get author =>
      CopyWith$Query$PostDetail$post$author.stub(_res);

  CopyWith$Query$PostDetail$post$comments<TRes> get comments =>
      CopyWith$Query$PostDetail$post$comments.stub(_res);
}

class Query$PostDetail$post$target implements Fragment$PostCardFields$target {
  Query$PostDetail$post$target({
    required this.type,
    required this.id,
    required this.title,
    required this.thumbnailImageUrl,
  });

  factory Query$PostDetail$post$target.fromJson(Map<String, dynamic> json) {
    final l$type = json['type'];
    final l$id = json['id'];
    final l$title = json['title'];
    final l$thumbnailImageUrl = json['thumbnailImageUrl'];
    return Query$PostDetail$post$target(
      type: fromJson$Enum$PostTargetType((l$type as String)),
      id: (l$id as String),
      title: (l$title as String),
      thumbnailImageUrl: (l$thumbnailImageUrl as String),
    );
  }

  final Enum$PostTargetType type;

  final String id;

  final String title;

  final String thumbnailImageUrl;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$type = type;
    _resultData['type'] = toJson$Enum$PostTargetType(l$type);
    final l$id = id;
    _resultData['id'] = l$id;
    final l$title = title;
    _resultData['title'] = l$title;
    final l$thumbnailImageUrl = thumbnailImageUrl;
    _resultData['thumbnailImageUrl'] = l$thumbnailImageUrl;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$type = type;
    final l$id = id;
    final l$title = title;
    final l$thumbnailImageUrl = thumbnailImageUrl;
    return Object.hashAll([l$type, l$id, l$title, l$thumbnailImageUrl]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$PostDetail$post$target ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$type = type;
    final lOther$type = other.type;
    if (l$type != lOther$type) {
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
    return true;
  }
}

extension UtilityExtension$Query$PostDetail$post$target
    on Query$PostDetail$post$target {
  CopyWith$Query$PostDetail$post$target<Query$PostDetail$post$target>
  get copyWith => CopyWith$Query$PostDetail$post$target(this, (i) => i);
}

abstract class CopyWith$Query$PostDetail$post$target<TRes> {
  factory CopyWith$Query$PostDetail$post$target(
    Query$PostDetail$post$target instance,
    TRes Function(Query$PostDetail$post$target) then,
  ) = _CopyWithImpl$Query$PostDetail$post$target;

  factory CopyWith$Query$PostDetail$post$target.stub(TRes res) =
      _CopyWithStubImpl$Query$PostDetail$post$target;

  TRes call({
    Enum$PostTargetType? type,
    String? id,
    String? title,
    String? thumbnailImageUrl,
  });
}

class _CopyWithImpl$Query$PostDetail$post$target<TRes>
    implements CopyWith$Query$PostDetail$post$target<TRes> {
  _CopyWithImpl$Query$PostDetail$post$target(this._instance, this._then);

  final Query$PostDetail$post$target _instance;

  final TRes Function(Query$PostDetail$post$target) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? type = _undefined,
    Object? id = _undefined,
    Object? title = _undefined,
    Object? thumbnailImageUrl = _undefined,
  }) => _then(
    Query$PostDetail$post$target(
      type: type == _undefined || type == null
          ? _instance.type
          : (type as Enum$PostTargetType),
      id: id == _undefined || id == null ? _instance.id : (id as String),
      title: title == _undefined || title == null
          ? _instance.title
          : (title as String),
      thumbnailImageUrl:
          thumbnailImageUrl == _undefined || thumbnailImageUrl == null
          ? _instance.thumbnailImageUrl
          : (thumbnailImageUrl as String),
    ),
  );
}

class _CopyWithStubImpl$Query$PostDetail$post$target<TRes>
    implements CopyWith$Query$PostDetail$post$target<TRes> {
  _CopyWithStubImpl$Query$PostDetail$post$target(this._res);

  TRes _res;

  call({
    Enum$PostTargetType? type,
    String? id,
    String? title,
    String? thumbnailImageUrl,
  }) => _res;
}

class Query$PostDetail$post$author implements Fragment$PostCardFields$author {
  Query$PostDetail$post$author({
    required this.id,
    required this.nickname,
    this.profileImageUrl,
  });

  factory Query$PostDetail$post$author.fromJson(Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$nickname = json['nickname'];
    final l$profileImageUrl = json['profileImageUrl'];
    return Query$PostDetail$post$author(
      id: (l$id as String),
      nickname: (l$nickname as String),
      profileImageUrl: (l$profileImageUrl as String?),
    );
  }

  final String id;

  final String nickname;

  final String? profileImageUrl;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$nickname = nickname;
    _resultData['nickname'] = l$nickname;
    final l$profileImageUrl = profileImageUrl;
    _resultData['profileImageUrl'] = l$profileImageUrl;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$nickname = nickname;
    final l$profileImageUrl = profileImageUrl;
    return Object.hashAll([l$id, l$nickname, l$profileImageUrl]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$PostDetail$post$author ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$nickname = nickname;
    final lOther$nickname = other.nickname;
    if (l$nickname != lOther$nickname) {
      return false;
    }
    final l$profileImageUrl = profileImageUrl;
    final lOther$profileImageUrl = other.profileImageUrl;
    if (l$profileImageUrl != lOther$profileImageUrl) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Query$PostDetail$post$author
    on Query$PostDetail$post$author {
  CopyWith$Query$PostDetail$post$author<Query$PostDetail$post$author>
  get copyWith => CopyWith$Query$PostDetail$post$author(this, (i) => i);
}

abstract class CopyWith$Query$PostDetail$post$author<TRes> {
  factory CopyWith$Query$PostDetail$post$author(
    Query$PostDetail$post$author instance,
    TRes Function(Query$PostDetail$post$author) then,
  ) = _CopyWithImpl$Query$PostDetail$post$author;

  factory CopyWith$Query$PostDetail$post$author.stub(TRes res) =
      _CopyWithStubImpl$Query$PostDetail$post$author;

  TRes call({String? id, String? nickname, String? profileImageUrl});
}

class _CopyWithImpl$Query$PostDetail$post$author<TRes>
    implements CopyWith$Query$PostDetail$post$author<TRes> {
  _CopyWithImpl$Query$PostDetail$post$author(this._instance, this._then);

  final Query$PostDetail$post$author _instance;

  final TRes Function(Query$PostDetail$post$author) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? nickname = _undefined,
    Object? profileImageUrl = _undefined,
  }) => _then(
    Query$PostDetail$post$author(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      nickname: nickname == _undefined || nickname == null
          ? _instance.nickname
          : (nickname as String),
      profileImageUrl: profileImageUrl == _undefined
          ? _instance.profileImageUrl
          : (profileImageUrl as String?),
    ),
  );
}

class _CopyWithStubImpl$Query$PostDetail$post$author<TRes>
    implements CopyWith$Query$PostDetail$post$author<TRes> {
  _CopyWithStubImpl$Query$PostDetail$post$author(this._res);

  TRes _res;

  call({String? id, String? nickname, String? profileImageUrl}) => _res;
}

class Query$PostDetail$post$comments {
  Query$PostDetail$post$comments({required this.edges, required this.pageInfo});

  factory Query$PostDetail$post$comments.fromJson(Map<String, dynamic> json) {
    final l$edges = json['edges'];
    final l$pageInfo = json['pageInfo'];
    return Query$PostDetail$post$comments(
      edges: (l$edges as List<dynamic>)
          .map(
            (e) => Query$PostDetail$post$comments$edges.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      pageInfo: Query$PostDetail$post$comments$pageInfo.fromJson(
        (l$pageInfo as Map<String, dynamic>),
      ),
    );
  }

  final List<Query$PostDetail$post$comments$edges> edges;

  final Query$PostDetail$post$comments$pageInfo pageInfo;

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
    if (other is! Query$PostDetail$post$comments ||
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

extension UtilityExtension$Query$PostDetail$post$comments
    on Query$PostDetail$post$comments {
  CopyWith$Query$PostDetail$post$comments<Query$PostDetail$post$comments>
  get copyWith => CopyWith$Query$PostDetail$post$comments(this, (i) => i);
}

abstract class CopyWith$Query$PostDetail$post$comments<TRes> {
  factory CopyWith$Query$PostDetail$post$comments(
    Query$PostDetail$post$comments instance,
    TRes Function(Query$PostDetail$post$comments) then,
  ) = _CopyWithImpl$Query$PostDetail$post$comments;

  factory CopyWith$Query$PostDetail$post$comments.stub(TRes res) =
      _CopyWithStubImpl$Query$PostDetail$post$comments;

  TRes call({
    List<Query$PostDetail$post$comments$edges>? edges,
    Query$PostDetail$post$comments$pageInfo? pageInfo,
  });
  TRes edges(
    Iterable<Query$PostDetail$post$comments$edges> Function(
      Iterable<
        CopyWith$Query$PostDetail$post$comments$edges<
          Query$PostDetail$post$comments$edges
        >
      >,
    )
    _fn,
  );
  CopyWith$Query$PostDetail$post$comments$pageInfo<TRes> get pageInfo;
}

class _CopyWithImpl$Query$PostDetail$post$comments<TRes>
    implements CopyWith$Query$PostDetail$post$comments<TRes> {
  _CopyWithImpl$Query$PostDetail$post$comments(this._instance, this._then);

  final Query$PostDetail$post$comments _instance;

  final TRes Function(Query$PostDetail$post$comments) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? edges = _undefined, Object? pageInfo = _undefined}) =>
      _then(
        Query$PostDetail$post$comments(
          edges: edges == _undefined || edges == null
              ? _instance.edges
              : (edges as List<Query$PostDetail$post$comments$edges>),
          pageInfo: pageInfo == _undefined || pageInfo == null
              ? _instance.pageInfo
              : (pageInfo as Query$PostDetail$post$comments$pageInfo),
        ),
      );

  TRes edges(
    Iterable<Query$PostDetail$post$comments$edges> Function(
      Iterable<
        CopyWith$Query$PostDetail$post$comments$edges<
          Query$PostDetail$post$comments$edges
        >
      >,
    )
    _fn,
  ) => call(
    edges: _fn(
      _instance.edges.map(
        (e) => CopyWith$Query$PostDetail$post$comments$edges(e, (i) => i),
      ),
    ).toList(),
  );

  CopyWith$Query$PostDetail$post$comments$pageInfo<TRes> get pageInfo {
    final local$pageInfo = _instance.pageInfo;
    return CopyWith$Query$PostDetail$post$comments$pageInfo(
      local$pageInfo,
      (e) => call(pageInfo: e),
    );
  }
}

class _CopyWithStubImpl$Query$PostDetail$post$comments<TRes>
    implements CopyWith$Query$PostDetail$post$comments<TRes> {
  _CopyWithStubImpl$Query$PostDetail$post$comments(this._res);

  TRes _res;

  call({
    List<Query$PostDetail$post$comments$edges>? edges,
    Query$PostDetail$post$comments$pageInfo? pageInfo,
  }) => _res;

  edges(_fn) => _res;

  CopyWith$Query$PostDetail$post$comments$pageInfo<TRes> get pageInfo =>
      CopyWith$Query$PostDetail$post$comments$pageInfo.stub(_res);
}

class Query$PostDetail$post$comments$edges {
  Query$PostDetail$post$comments$edges({
    required this.cursor,
    required this.node,
  });

  factory Query$PostDetail$post$comments$edges.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$cursor = json['cursor'];
    final l$node = json['node'];
    return Query$PostDetail$post$comments$edges(
      cursor: (l$cursor as String),
      node: Query$PostDetail$post$comments$edges$node.fromJson(
        (l$node as Map<String, dynamic>),
      ),
    );
  }

  final String cursor;

  final Query$PostDetail$post$comments$edges$node node;

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
    if (other is! Query$PostDetail$post$comments$edges ||
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

extension UtilityExtension$Query$PostDetail$post$comments$edges
    on Query$PostDetail$post$comments$edges {
  CopyWith$Query$PostDetail$post$comments$edges<
    Query$PostDetail$post$comments$edges
  >
  get copyWith => CopyWith$Query$PostDetail$post$comments$edges(this, (i) => i);
}

abstract class CopyWith$Query$PostDetail$post$comments$edges<TRes> {
  factory CopyWith$Query$PostDetail$post$comments$edges(
    Query$PostDetail$post$comments$edges instance,
    TRes Function(Query$PostDetail$post$comments$edges) then,
  ) = _CopyWithImpl$Query$PostDetail$post$comments$edges;

  factory CopyWith$Query$PostDetail$post$comments$edges.stub(TRes res) =
      _CopyWithStubImpl$Query$PostDetail$post$comments$edges;

  TRes call({String? cursor, Query$PostDetail$post$comments$edges$node? node});
  CopyWith$Query$PostDetail$post$comments$edges$node<TRes> get node;
}

class _CopyWithImpl$Query$PostDetail$post$comments$edges<TRes>
    implements CopyWith$Query$PostDetail$post$comments$edges<TRes> {
  _CopyWithImpl$Query$PostDetail$post$comments$edges(
    this._instance,
    this._then,
  );

  final Query$PostDetail$post$comments$edges _instance;

  final TRes Function(Query$PostDetail$post$comments$edges) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? cursor = _undefined, Object? node = _undefined}) => _then(
    Query$PostDetail$post$comments$edges(
      cursor: cursor == _undefined || cursor == null
          ? _instance.cursor
          : (cursor as String),
      node: node == _undefined || node == null
          ? _instance.node
          : (node as Query$PostDetail$post$comments$edges$node),
    ),
  );

  CopyWith$Query$PostDetail$post$comments$edges$node<TRes> get node {
    final local$node = _instance.node;
    return CopyWith$Query$PostDetail$post$comments$edges$node(
      local$node,
      (e) => call(node: e),
    );
  }
}

class _CopyWithStubImpl$Query$PostDetail$post$comments$edges<TRes>
    implements CopyWith$Query$PostDetail$post$comments$edges<TRes> {
  _CopyWithStubImpl$Query$PostDetail$post$comments$edges(this._res);

  TRes _res;

  call({String? cursor, Query$PostDetail$post$comments$edges$node? node}) =>
      _res;

  CopyWith$Query$PostDetail$post$comments$edges$node<TRes> get node =>
      CopyWith$Query$PostDetail$post$comments$edges$node.stub(_res);
}

class Query$PostDetail$post$comments$edges$node {
  Query$PostDetail$post$comments$edges$node({
    required this.id,
    required this.body,
    required this.createdAt,
    required this.ownedByViewer,
    required this.hidden,
    required this.author,
  });

  factory Query$PostDetail$post$comments$edges$node.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$body = json['body'];
    final l$createdAt = json['createdAt'];
    final l$ownedByViewer = json['ownedByViewer'];
    final l$hidden = json['hidden'];
    final l$author = json['author'];
    return Query$PostDetail$post$comments$edges$node(
      id: (l$id as String),
      body: (l$body as String),
      createdAt: (l$createdAt as String),
      ownedByViewer: (l$ownedByViewer as bool),
      hidden: (l$hidden as bool),
      author: Query$PostDetail$post$comments$edges$node$author.fromJson(
        (l$author as Map<String, dynamic>),
      ),
    );
  }

  final String id;

  final String body;

  final String createdAt;

  final bool ownedByViewer;

  final bool hidden;

  final Query$PostDetail$post$comments$edges$node$author author;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$body = body;
    _resultData['body'] = l$body;
    final l$createdAt = createdAt;
    _resultData['createdAt'] = l$createdAt;
    final l$ownedByViewer = ownedByViewer;
    _resultData['ownedByViewer'] = l$ownedByViewer;
    final l$hidden = hidden;
    _resultData['hidden'] = l$hidden;
    final l$author = author;
    _resultData['author'] = l$author.toJson();
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$body = body;
    final l$createdAt = createdAt;
    final l$ownedByViewer = ownedByViewer;
    final l$hidden = hidden;
    final l$author = author;
    return Object.hashAll([
      l$id,
      l$body,
      l$createdAt,
      l$ownedByViewer,
      l$hidden,
      l$author,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$PostDetail$post$comments$edges$node ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$body = body;
    final lOther$body = other.body;
    if (l$body != lOther$body) {
      return false;
    }
    final l$createdAt = createdAt;
    final lOther$createdAt = other.createdAt;
    if (l$createdAt != lOther$createdAt) {
      return false;
    }
    final l$ownedByViewer = ownedByViewer;
    final lOther$ownedByViewer = other.ownedByViewer;
    if (l$ownedByViewer != lOther$ownedByViewer) {
      return false;
    }
    final l$hidden = hidden;
    final lOther$hidden = other.hidden;
    if (l$hidden != lOther$hidden) {
      return false;
    }
    final l$author = author;
    final lOther$author = other.author;
    if (l$author != lOther$author) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Query$PostDetail$post$comments$edges$node
    on Query$PostDetail$post$comments$edges$node {
  CopyWith$Query$PostDetail$post$comments$edges$node<
    Query$PostDetail$post$comments$edges$node
  >
  get copyWith =>
      CopyWith$Query$PostDetail$post$comments$edges$node(this, (i) => i);
}

abstract class CopyWith$Query$PostDetail$post$comments$edges$node<TRes> {
  factory CopyWith$Query$PostDetail$post$comments$edges$node(
    Query$PostDetail$post$comments$edges$node instance,
    TRes Function(Query$PostDetail$post$comments$edges$node) then,
  ) = _CopyWithImpl$Query$PostDetail$post$comments$edges$node;

  factory CopyWith$Query$PostDetail$post$comments$edges$node.stub(TRes res) =
      _CopyWithStubImpl$Query$PostDetail$post$comments$edges$node;

  TRes call({
    String? id,
    String? body,
    String? createdAt,
    bool? ownedByViewer,
    bool? hidden,
    Query$PostDetail$post$comments$edges$node$author? author,
  });
  CopyWith$Query$PostDetail$post$comments$edges$node$author<TRes> get author;
}

class _CopyWithImpl$Query$PostDetail$post$comments$edges$node<TRes>
    implements CopyWith$Query$PostDetail$post$comments$edges$node<TRes> {
  _CopyWithImpl$Query$PostDetail$post$comments$edges$node(
    this._instance,
    this._then,
  );

  final Query$PostDetail$post$comments$edges$node _instance;

  final TRes Function(Query$PostDetail$post$comments$edges$node) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? body = _undefined,
    Object? createdAt = _undefined,
    Object? ownedByViewer = _undefined,
    Object? hidden = _undefined,
    Object? author = _undefined,
  }) => _then(
    Query$PostDetail$post$comments$edges$node(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      body: body == _undefined || body == null
          ? _instance.body
          : (body as String),
      createdAt: createdAt == _undefined || createdAt == null
          ? _instance.createdAt
          : (createdAt as String),
      ownedByViewer: ownedByViewer == _undefined || ownedByViewer == null
          ? _instance.ownedByViewer
          : (ownedByViewer as bool),
      hidden: hidden == _undefined || hidden == null
          ? _instance.hidden
          : (hidden as bool),
      author: author == _undefined || author == null
          ? _instance.author
          : (author as Query$PostDetail$post$comments$edges$node$author),
    ),
  );

  CopyWith$Query$PostDetail$post$comments$edges$node$author<TRes> get author {
    final local$author = _instance.author;
    return CopyWith$Query$PostDetail$post$comments$edges$node$author(
      local$author,
      (e) => call(author: e),
    );
  }
}

class _CopyWithStubImpl$Query$PostDetail$post$comments$edges$node<TRes>
    implements CopyWith$Query$PostDetail$post$comments$edges$node<TRes> {
  _CopyWithStubImpl$Query$PostDetail$post$comments$edges$node(this._res);

  TRes _res;

  call({
    String? id,
    String? body,
    String? createdAt,
    bool? ownedByViewer,
    bool? hidden,
    Query$PostDetail$post$comments$edges$node$author? author,
  }) => _res;

  CopyWith$Query$PostDetail$post$comments$edges$node$author<TRes> get author =>
      CopyWith$Query$PostDetail$post$comments$edges$node$author.stub(_res);
}

class Query$PostDetail$post$comments$edges$node$author {
  Query$PostDetail$post$comments$edges$node$author({
    required this.id,
    required this.nickname,
    this.profileImageUrl,
  });

  factory Query$PostDetail$post$comments$edges$node$author.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$nickname = json['nickname'];
    final l$profileImageUrl = json['profileImageUrl'];
    return Query$PostDetail$post$comments$edges$node$author(
      id: (l$id as String),
      nickname: (l$nickname as String),
      profileImageUrl: (l$profileImageUrl as String?),
    );
  }

  final String id;

  final String nickname;

  final String? profileImageUrl;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$nickname = nickname;
    _resultData['nickname'] = l$nickname;
    final l$profileImageUrl = profileImageUrl;
    _resultData['profileImageUrl'] = l$profileImageUrl;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$nickname = nickname;
    final l$profileImageUrl = profileImageUrl;
    return Object.hashAll([l$id, l$nickname, l$profileImageUrl]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$PostDetail$post$comments$edges$node$author ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$nickname = nickname;
    final lOther$nickname = other.nickname;
    if (l$nickname != lOther$nickname) {
      return false;
    }
    final l$profileImageUrl = profileImageUrl;
    final lOther$profileImageUrl = other.profileImageUrl;
    if (l$profileImageUrl != lOther$profileImageUrl) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Query$PostDetail$post$comments$edges$node$author
    on Query$PostDetail$post$comments$edges$node$author {
  CopyWith$Query$PostDetail$post$comments$edges$node$author<
    Query$PostDetail$post$comments$edges$node$author
  >
  get copyWith =>
      CopyWith$Query$PostDetail$post$comments$edges$node$author(this, (i) => i);
}

abstract class CopyWith$Query$PostDetail$post$comments$edges$node$author<TRes> {
  factory CopyWith$Query$PostDetail$post$comments$edges$node$author(
    Query$PostDetail$post$comments$edges$node$author instance,
    TRes Function(Query$PostDetail$post$comments$edges$node$author) then,
  ) = _CopyWithImpl$Query$PostDetail$post$comments$edges$node$author;

  factory CopyWith$Query$PostDetail$post$comments$edges$node$author.stub(
    TRes res,
  ) = _CopyWithStubImpl$Query$PostDetail$post$comments$edges$node$author;

  TRes call({String? id, String? nickname, String? profileImageUrl});
}

class _CopyWithImpl$Query$PostDetail$post$comments$edges$node$author<TRes>
    implements CopyWith$Query$PostDetail$post$comments$edges$node$author<TRes> {
  _CopyWithImpl$Query$PostDetail$post$comments$edges$node$author(
    this._instance,
    this._then,
  );

  final Query$PostDetail$post$comments$edges$node$author _instance;

  final TRes Function(Query$PostDetail$post$comments$edges$node$author) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? nickname = _undefined,
    Object? profileImageUrl = _undefined,
  }) => _then(
    Query$PostDetail$post$comments$edges$node$author(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      nickname: nickname == _undefined || nickname == null
          ? _instance.nickname
          : (nickname as String),
      profileImageUrl: profileImageUrl == _undefined
          ? _instance.profileImageUrl
          : (profileImageUrl as String?),
    ),
  );
}

class _CopyWithStubImpl$Query$PostDetail$post$comments$edges$node$author<TRes>
    implements CopyWith$Query$PostDetail$post$comments$edges$node$author<TRes> {
  _CopyWithStubImpl$Query$PostDetail$post$comments$edges$node$author(this._res);

  TRes _res;

  call({String? id, String? nickname, String? profileImageUrl}) => _res;
}

class Query$PostDetail$post$comments$pageInfo {
  Query$PostDetail$post$comments$pageInfo({
    required this.hasNextPage,
    this.endCursor,
  });

  factory Query$PostDetail$post$comments$pageInfo.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$hasNextPage = json['hasNextPage'];
    final l$endCursor = json['endCursor'];
    return Query$PostDetail$post$comments$pageInfo(
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
    if (other is! Query$PostDetail$post$comments$pageInfo ||
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

extension UtilityExtension$Query$PostDetail$post$comments$pageInfo
    on Query$PostDetail$post$comments$pageInfo {
  CopyWith$Query$PostDetail$post$comments$pageInfo<
    Query$PostDetail$post$comments$pageInfo
  >
  get copyWith =>
      CopyWith$Query$PostDetail$post$comments$pageInfo(this, (i) => i);
}

abstract class CopyWith$Query$PostDetail$post$comments$pageInfo<TRes> {
  factory CopyWith$Query$PostDetail$post$comments$pageInfo(
    Query$PostDetail$post$comments$pageInfo instance,
    TRes Function(Query$PostDetail$post$comments$pageInfo) then,
  ) = _CopyWithImpl$Query$PostDetail$post$comments$pageInfo;

  factory CopyWith$Query$PostDetail$post$comments$pageInfo.stub(TRes res) =
      _CopyWithStubImpl$Query$PostDetail$post$comments$pageInfo;

  TRes call({bool? hasNextPage, String? endCursor});
}

class _CopyWithImpl$Query$PostDetail$post$comments$pageInfo<TRes>
    implements CopyWith$Query$PostDetail$post$comments$pageInfo<TRes> {
  _CopyWithImpl$Query$PostDetail$post$comments$pageInfo(
    this._instance,
    this._then,
  );

  final Query$PostDetail$post$comments$pageInfo _instance;

  final TRes Function(Query$PostDetail$post$comments$pageInfo) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? hasNextPage = _undefined,
    Object? endCursor = _undefined,
  }) => _then(
    Query$PostDetail$post$comments$pageInfo(
      hasNextPage: hasNextPage == _undefined || hasNextPage == null
          ? _instance.hasNextPage
          : (hasNextPage as bool),
      endCursor: endCursor == _undefined
          ? _instance.endCursor
          : (endCursor as String?),
    ),
  );
}

class _CopyWithStubImpl$Query$PostDetail$post$comments$pageInfo<TRes>
    implements CopyWith$Query$PostDetail$post$comments$pageInfo<TRes> {
  _CopyWithStubImpl$Query$PostDetail$post$comments$pageInfo(this._res);

  TRes _res;

  call({bool? hasNextPage, String? endCursor}) => _res;
}

class Query$DiscoveryTiles {
  Query$DiscoveryTiles({required this.discoveryTiles});

  factory Query$DiscoveryTiles.fromJson(Map<String, dynamic> json) {
    final l$discoveryTiles = json['discoveryTiles'];
    return Query$DiscoveryTiles(
      discoveryTiles: (l$discoveryTiles as List<dynamic>)
          .map(
            (e) => Query$DiscoveryTiles$discoveryTiles.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
    );
  }

  final List<Query$DiscoveryTiles$discoveryTiles> discoveryTiles;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$discoveryTiles = discoveryTiles;
    _resultData['discoveryTiles'] = l$discoveryTiles
        .map((e) => e.toJson())
        .toList();
    return _resultData;
  }

  @override
  int get hashCode {
    final l$discoveryTiles = discoveryTiles;
    return Object.hashAll([Object.hashAll(l$discoveryTiles.map((v) => v))]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$DiscoveryTiles || runtimeType != other.runtimeType) {
      return false;
    }
    final l$discoveryTiles = discoveryTiles;
    final lOther$discoveryTiles = other.discoveryTiles;
    if (l$discoveryTiles.length != lOther$discoveryTiles.length) {
      return false;
    }
    for (int i = 0; i < l$discoveryTiles.length; i++) {
      final l$discoveryTiles$entry = l$discoveryTiles[i];
      final lOther$discoveryTiles$entry = lOther$discoveryTiles[i];
      if (l$discoveryTiles$entry != lOther$discoveryTiles$entry) {
        return false;
      }
    }
    return true;
  }
}

extension UtilityExtension$Query$DiscoveryTiles on Query$DiscoveryTiles {
  CopyWith$Query$DiscoveryTiles<Query$DiscoveryTiles> get copyWith =>
      CopyWith$Query$DiscoveryTiles(this, (i) => i);
}

abstract class CopyWith$Query$DiscoveryTiles<TRes> {
  factory CopyWith$Query$DiscoveryTiles(
    Query$DiscoveryTiles instance,
    TRes Function(Query$DiscoveryTiles) then,
  ) = _CopyWithImpl$Query$DiscoveryTiles;

  factory CopyWith$Query$DiscoveryTiles.stub(TRes res) =
      _CopyWithStubImpl$Query$DiscoveryTiles;

  TRes call({List<Query$DiscoveryTiles$discoveryTiles>? discoveryTiles});
  TRes discoveryTiles(
    Iterable<Query$DiscoveryTiles$discoveryTiles> Function(
      Iterable<
        CopyWith$Query$DiscoveryTiles$discoveryTiles<
          Query$DiscoveryTiles$discoveryTiles
        >
      >,
    )
    _fn,
  );
}

class _CopyWithImpl$Query$DiscoveryTiles<TRes>
    implements CopyWith$Query$DiscoveryTiles<TRes> {
  _CopyWithImpl$Query$DiscoveryTiles(this._instance, this._then);

  final Query$DiscoveryTiles _instance;

  final TRes Function(Query$DiscoveryTiles) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? discoveryTiles = _undefined}) => _then(
    Query$DiscoveryTiles(
      discoveryTiles: discoveryTiles == _undefined || discoveryTiles == null
          ? _instance.discoveryTiles
          : (discoveryTiles as List<Query$DiscoveryTiles$discoveryTiles>),
    ),
  );

  TRes discoveryTiles(
    Iterable<Query$DiscoveryTiles$discoveryTiles> Function(
      Iterable<
        CopyWith$Query$DiscoveryTiles$discoveryTiles<
          Query$DiscoveryTiles$discoveryTiles
        >
      >,
    )
    _fn,
  ) => call(
    discoveryTiles: _fn(
      _instance.discoveryTiles.map(
        (e) => CopyWith$Query$DiscoveryTiles$discoveryTiles(e, (i) => i),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl$Query$DiscoveryTiles<TRes>
    implements CopyWith$Query$DiscoveryTiles<TRes> {
  _CopyWithStubImpl$Query$DiscoveryTiles(this._res);

  TRes _res;

  call({List<Query$DiscoveryTiles$discoveryTiles>? discoveryTiles}) => _res;

  discoveryTiles(_fn) => _res;
}

const documentNodeQueryDiscoveryTiles = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'DiscoveryTiles'),
      variableDefinitions: [],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'discoveryTiles'),
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
                  name: NameNode(value: 'imageUrl'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: 'filterTopic'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: 'filterTargetType'),
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

class Query$DiscoveryTiles$discoveryTiles {
  Query$DiscoveryTiles$discoveryTiles({
    required this.id,
    required this.title,
    this.imageUrl,
    this.filterTopic,
    this.filterTargetType,
  });

  factory Query$DiscoveryTiles$discoveryTiles.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$title = json['title'];
    final l$imageUrl = json['imageUrl'];
    final l$filterTopic = json['filterTopic'];
    final l$filterTargetType = json['filterTargetType'];
    return Query$DiscoveryTiles$discoveryTiles(
      id: (l$id as String),
      title: (l$title as String),
      imageUrl: (l$imageUrl as String?),
      filterTopic: l$filterTopic == null
          ? null
          : fromJson$Enum$PostTopic((l$filterTopic as String)),
      filterTargetType: l$filterTargetType == null
          ? null
          : fromJson$Enum$PostTargetType((l$filterTargetType as String)),
    );
  }

  final String id;

  final String title;

  final String? imageUrl;

  final Enum$PostTopic? filterTopic;

  final Enum$PostTargetType? filterTargetType;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$title = title;
    _resultData['title'] = l$title;
    final l$imageUrl = imageUrl;
    _resultData['imageUrl'] = l$imageUrl;
    final l$filterTopic = filterTopic;
    _resultData['filterTopic'] = l$filterTopic == null
        ? null
        : toJson$Enum$PostTopic(l$filterTopic);
    final l$filterTargetType = filterTargetType;
    _resultData['filterTargetType'] = l$filterTargetType == null
        ? null
        : toJson$Enum$PostTargetType(l$filterTargetType);
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$title = title;
    final l$imageUrl = imageUrl;
    final l$filterTopic = filterTopic;
    final l$filterTargetType = filterTargetType;
    return Object.hashAll([
      l$id,
      l$title,
      l$imageUrl,
      l$filterTopic,
      l$filterTargetType,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$DiscoveryTiles$discoveryTiles ||
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
    final l$imageUrl = imageUrl;
    final lOther$imageUrl = other.imageUrl;
    if (l$imageUrl != lOther$imageUrl) {
      return false;
    }
    final l$filterTopic = filterTopic;
    final lOther$filterTopic = other.filterTopic;
    if (l$filterTopic != lOther$filterTopic) {
      return false;
    }
    final l$filterTargetType = filterTargetType;
    final lOther$filterTargetType = other.filterTargetType;
    if (l$filterTargetType != lOther$filterTargetType) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Query$DiscoveryTiles$discoveryTiles
    on Query$DiscoveryTiles$discoveryTiles {
  CopyWith$Query$DiscoveryTiles$discoveryTiles<
    Query$DiscoveryTiles$discoveryTiles
  >
  get copyWith => CopyWith$Query$DiscoveryTiles$discoveryTiles(this, (i) => i);
}

abstract class CopyWith$Query$DiscoveryTiles$discoveryTiles<TRes> {
  factory CopyWith$Query$DiscoveryTiles$discoveryTiles(
    Query$DiscoveryTiles$discoveryTiles instance,
    TRes Function(Query$DiscoveryTiles$discoveryTiles) then,
  ) = _CopyWithImpl$Query$DiscoveryTiles$discoveryTiles;

  factory CopyWith$Query$DiscoveryTiles$discoveryTiles.stub(TRes res) =
      _CopyWithStubImpl$Query$DiscoveryTiles$discoveryTiles;

  TRes call({
    String? id,
    String? title,
    String? imageUrl,
    Enum$PostTopic? filterTopic,
    Enum$PostTargetType? filterTargetType,
  });
}

class _CopyWithImpl$Query$DiscoveryTiles$discoveryTiles<TRes>
    implements CopyWith$Query$DiscoveryTiles$discoveryTiles<TRes> {
  _CopyWithImpl$Query$DiscoveryTiles$discoveryTiles(this._instance, this._then);

  final Query$DiscoveryTiles$discoveryTiles _instance;

  final TRes Function(Query$DiscoveryTiles$discoveryTiles) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? title = _undefined,
    Object? imageUrl = _undefined,
    Object? filterTopic = _undefined,
    Object? filterTargetType = _undefined,
  }) => _then(
    Query$DiscoveryTiles$discoveryTiles(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      title: title == _undefined || title == null
          ? _instance.title
          : (title as String),
      imageUrl: imageUrl == _undefined
          ? _instance.imageUrl
          : (imageUrl as String?),
      filterTopic: filterTopic == _undefined
          ? _instance.filterTopic
          : (filterTopic as Enum$PostTopic?),
      filterTargetType: filterTargetType == _undefined
          ? _instance.filterTargetType
          : (filterTargetType as Enum$PostTargetType?),
    ),
  );
}

class _CopyWithStubImpl$Query$DiscoveryTiles$discoveryTiles<TRes>
    implements CopyWith$Query$DiscoveryTiles$discoveryTiles<TRes> {
  _CopyWithStubImpl$Query$DiscoveryTiles$discoveryTiles(this._res);

  TRes _res;

  call({
    String? id,
    String? title,
    String? imageUrl,
    Enum$PostTopic? filterTopic,
    Enum$PostTargetType? filterTargetType,
  }) => _res;
}

class Variables$Mutation$LikePost {
  factory Variables$Mutation$LikePost({required String postId}) =>
      Variables$Mutation$LikePost._({r'postId': postId});

  Variables$Mutation$LikePost._(this._$data);

  factory Variables$Mutation$LikePost.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$postId = data['postId'];
    result$data['postId'] = (l$postId as String);
    return Variables$Mutation$LikePost._(result$data);
  }

  Map<String, dynamic> _$data;

  String get postId => (_$data['postId'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$postId = postId;
    result$data['postId'] = l$postId;
    return result$data;
  }

  CopyWith$Variables$Mutation$LikePost<Variables$Mutation$LikePost>
  get copyWith => CopyWith$Variables$Mutation$LikePost(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Mutation$LikePost ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$postId = postId;
    final lOther$postId = other.postId;
    if (l$postId != lOther$postId) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$postId = postId;
    return Object.hashAll([l$postId]);
  }
}

abstract class CopyWith$Variables$Mutation$LikePost<TRes> {
  factory CopyWith$Variables$Mutation$LikePost(
    Variables$Mutation$LikePost instance,
    TRes Function(Variables$Mutation$LikePost) then,
  ) = _CopyWithImpl$Variables$Mutation$LikePost;

  factory CopyWith$Variables$Mutation$LikePost.stub(TRes res) =
      _CopyWithStubImpl$Variables$Mutation$LikePost;

  TRes call({String? postId});
}

class _CopyWithImpl$Variables$Mutation$LikePost<TRes>
    implements CopyWith$Variables$Mutation$LikePost<TRes> {
  _CopyWithImpl$Variables$Mutation$LikePost(this._instance, this._then);

  final Variables$Mutation$LikePost _instance;

  final TRes Function(Variables$Mutation$LikePost) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? postId = _undefined}) => _then(
    Variables$Mutation$LikePost._({
      ..._instance._$data,
      if (postId != _undefined && postId != null) 'postId': (postId as String),
    }),
  );
}

class _CopyWithStubImpl$Variables$Mutation$LikePost<TRes>
    implements CopyWith$Variables$Mutation$LikePost<TRes> {
  _CopyWithStubImpl$Variables$Mutation$LikePost(this._res);

  TRes _res;

  call({String? postId}) => _res;
}

class Mutation$LikePost {
  Mutation$LikePost({required this.likePost});

  factory Mutation$LikePost.fromJson(Map<String, dynamic> json) {
    final l$likePost = json['likePost'];
    return Mutation$LikePost(
      likePost: Mutation$LikePost$likePost.fromJson(
        (l$likePost as Map<String, dynamic>),
      ),
    );
  }

  final Mutation$LikePost$likePost likePost;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$likePost = likePost;
    _resultData['likePost'] = l$likePost.toJson();
    return _resultData;
  }

  @override
  int get hashCode {
    final l$likePost = likePost;
    return Object.hashAll([l$likePost]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$LikePost || runtimeType != other.runtimeType) {
      return false;
    }
    final l$likePost = likePost;
    final lOther$likePost = other.likePost;
    if (l$likePost != lOther$likePost) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Mutation$LikePost on Mutation$LikePost {
  CopyWith$Mutation$LikePost<Mutation$LikePost> get copyWith =>
      CopyWith$Mutation$LikePost(this, (i) => i);
}

abstract class CopyWith$Mutation$LikePost<TRes> {
  factory CopyWith$Mutation$LikePost(
    Mutation$LikePost instance,
    TRes Function(Mutation$LikePost) then,
  ) = _CopyWithImpl$Mutation$LikePost;

  factory CopyWith$Mutation$LikePost.stub(TRes res) =
      _CopyWithStubImpl$Mutation$LikePost;

  TRes call({Mutation$LikePost$likePost? likePost});
  CopyWith$Mutation$LikePost$likePost<TRes> get likePost;
}

class _CopyWithImpl$Mutation$LikePost<TRes>
    implements CopyWith$Mutation$LikePost<TRes> {
  _CopyWithImpl$Mutation$LikePost(this._instance, this._then);

  final Mutation$LikePost _instance;

  final TRes Function(Mutation$LikePost) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? likePost = _undefined}) => _then(
    Mutation$LikePost(
      likePost: likePost == _undefined || likePost == null
          ? _instance.likePost
          : (likePost as Mutation$LikePost$likePost),
    ),
  );

  CopyWith$Mutation$LikePost$likePost<TRes> get likePost {
    final local$likePost = _instance.likePost;
    return CopyWith$Mutation$LikePost$likePost(
      local$likePost,
      (e) => call(likePost: e),
    );
  }
}

class _CopyWithStubImpl$Mutation$LikePost<TRes>
    implements CopyWith$Mutation$LikePost<TRes> {
  _CopyWithStubImpl$Mutation$LikePost(this._res);

  TRes _res;

  call({Mutation$LikePost$likePost? likePost}) => _res;

  CopyWith$Mutation$LikePost$likePost<TRes> get likePost =>
      CopyWith$Mutation$LikePost$likePost.stub(_res);
}

const documentNodeMutationLikePost = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'LikePost'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'postId')),
          type: NamedTypeNode(name: NameNode(value: 'ID'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
      ],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'likePost'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'input'),
                value: ObjectValueNode(
                  fields: [
                    ObjectFieldNode(
                      name: NameNode(value: 'postId'),
                      value: VariableNode(name: NameNode(value: 'postId')),
                    ),
                  ],
                ),
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
                  name: NameNode(value: 'likeCount'),
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

class Mutation$LikePost$likePost {
  Mutation$LikePost$likePost({
    required this.success,
    required this.userErrors,
    this.likeCount,
  });

  factory Mutation$LikePost$likePost.fromJson(Map<String, dynamic> json) {
    final l$success = json['success'];
    final l$userErrors = json['userErrors'];
    final l$likeCount = json['likeCount'];
    return Mutation$LikePost$likePost(
      success: (l$success as bool),
      userErrors: (l$userErrors as List<dynamic>)
          .map(
            (e) => Mutation$LikePost$likePost$userErrors.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      likeCount: (l$likeCount as int?),
    );
  }

  final bool success;

  final List<Mutation$LikePost$likePost$userErrors> userErrors;

  final int? likeCount;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$success = success;
    _resultData['success'] = l$success;
    final l$userErrors = userErrors;
    _resultData['userErrors'] = l$userErrors.map((e) => e.toJson()).toList();
    final l$likeCount = likeCount;
    _resultData['likeCount'] = l$likeCount;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$success = success;
    final l$userErrors = userErrors;
    final l$likeCount = likeCount;
    return Object.hashAll([
      l$success,
      Object.hashAll(l$userErrors.map((v) => v)),
      l$likeCount,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$LikePost$likePost ||
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
    final l$likeCount = likeCount;
    final lOther$likeCount = other.likeCount;
    if (l$likeCount != lOther$likeCount) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Mutation$LikePost$likePost
    on Mutation$LikePost$likePost {
  CopyWith$Mutation$LikePost$likePost<Mutation$LikePost$likePost>
  get copyWith => CopyWith$Mutation$LikePost$likePost(this, (i) => i);
}

abstract class CopyWith$Mutation$LikePost$likePost<TRes> {
  factory CopyWith$Mutation$LikePost$likePost(
    Mutation$LikePost$likePost instance,
    TRes Function(Mutation$LikePost$likePost) then,
  ) = _CopyWithImpl$Mutation$LikePost$likePost;

  factory CopyWith$Mutation$LikePost$likePost.stub(TRes res) =
      _CopyWithStubImpl$Mutation$LikePost$likePost;

  TRes call({
    bool? success,
    List<Mutation$LikePost$likePost$userErrors>? userErrors,
    int? likeCount,
  });
  TRes userErrors(
    Iterable<Mutation$LikePost$likePost$userErrors> Function(
      Iterable<
        CopyWith$Mutation$LikePost$likePost$userErrors<
          Mutation$LikePost$likePost$userErrors
        >
      >,
    )
    _fn,
  );
}

class _CopyWithImpl$Mutation$LikePost$likePost<TRes>
    implements CopyWith$Mutation$LikePost$likePost<TRes> {
  _CopyWithImpl$Mutation$LikePost$likePost(this._instance, this._then);

  final Mutation$LikePost$likePost _instance;

  final TRes Function(Mutation$LikePost$likePost) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? success = _undefined,
    Object? userErrors = _undefined,
    Object? likeCount = _undefined,
  }) => _then(
    Mutation$LikePost$likePost(
      success: success == _undefined || success == null
          ? _instance.success
          : (success as bool),
      userErrors: userErrors == _undefined || userErrors == null
          ? _instance.userErrors
          : (userErrors as List<Mutation$LikePost$likePost$userErrors>),
      likeCount: likeCount == _undefined
          ? _instance.likeCount
          : (likeCount as int?),
    ),
  );

  TRes userErrors(
    Iterable<Mutation$LikePost$likePost$userErrors> Function(
      Iterable<
        CopyWith$Mutation$LikePost$likePost$userErrors<
          Mutation$LikePost$likePost$userErrors
        >
      >,
    )
    _fn,
  ) => call(
    userErrors: _fn(
      _instance.userErrors.map(
        (e) => CopyWith$Mutation$LikePost$likePost$userErrors(e, (i) => i),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl$Mutation$LikePost$likePost<TRes>
    implements CopyWith$Mutation$LikePost$likePost<TRes> {
  _CopyWithStubImpl$Mutation$LikePost$likePost(this._res);

  TRes _res;

  call({
    bool? success,
    List<Mutation$LikePost$likePost$userErrors>? userErrors,
    int? likeCount,
  }) => _res;

  userErrors(_fn) => _res;
}

class Mutation$LikePost$likePost$userErrors {
  Mutation$LikePost$likePost$userErrors({
    required this.code,
    required this.message,
    this.field,
  });

  factory Mutation$LikePost$likePost$userErrors.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$code = json['code'];
    final l$message = json['message'];
    final l$field = json['field'];
    return Mutation$LikePost$likePost$userErrors(
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
    if (other is! Mutation$LikePost$likePost$userErrors ||
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

extension UtilityExtension$Mutation$LikePost$likePost$userErrors
    on Mutation$LikePost$likePost$userErrors {
  CopyWith$Mutation$LikePost$likePost$userErrors<
    Mutation$LikePost$likePost$userErrors
  >
  get copyWith =>
      CopyWith$Mutation$LikePost$likePost$userErrors(this, (i) => i);
}

abstract class CopyWith$Mutation$LikePost$likePost$userErrors<TRes> {
  factory CopyWith$Mutation$LikePost$likePost$userErrors(
    Mutation$LikePost$likePost$userErrors instance,
    TRes Function(Mutation$LikePost$likePost$userErrors) then,
  ) = _CopyWithImpl$Mutation$LikePost$likePost$userErrors;

  factory CopyWith$Mutation$LikePost$likePost$userErrors.stub(TRes res) =
      _CopyWithStubImpl$Mutation$LikePost$likePost$userErrors;

  TRes call({String? code, String? message, String? field});
}

class _CopyWithImpl$Mutation$LikePost$likePost$userErrors<TRes>
    implements CopyWith$Mutation$LikePost$likePost$userErrors<TRes> {
  _CopyWithImpl$Mutation$LikePost$likePost$userErrors(
    this._instance,
    this._then,
  );

  final Mutation$LikePost$likePost$userErrors _instance;

  final TRes Function(Mutation$LikePost$likePost$userErrors) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? code = _undefined,
    Object? message = _undefined,
    Object? field = _undefined,
  }) => _then(
    Mutation$LikePost$likePost$userErrors(
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

class _CopyWithStubImpl$Mutation$LikePost$likePost$userErrors<TRes>
    implements CopyWith$Mutation$LikePost$likePost$userErrors<TRes> {
  _CopyWithStubImpl$Mutation$LikePost$likePost$userErrors(this._res);

  TRes _res;

  call({String? code, String? message, String? field}) => _res;
}

class Variables$Mutation$UnlikePost {
  factory Variables$Mutation$UnlikePost({required String postId}) =>
      Variables$Mutation$UnlikePost._({r'postId': postId});

  Variables$Mutation$UnlikePost._(this._$data);

  factory Variables$Mutation$UnlikePost.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$postId = data['postId'];
    result$data['postId'] = (l$postId as String);
    return Variables$Mutation$UnlikePost._(result$data);
  }

  Map<String, dynamic> _$data;

  String get postId => (_$data['postId'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$postId = postId;
    result$data['postId'] = l$postId;
    return result$data;
  }

  CopyWith$Variables$Mutation$UnlikePost<Variables$Mutation$UnlikePost>
  get copyWith => CopyWith$Variables$Mutation$UnlikePost(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Mutation$UnlikePost ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$postId = postId;
    final lOther$postId = other.postId;
    if (l$postId != lOther$postId) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$postId = postId;
    return Object.hashAll([l$postId]);
  }
}

abstract class CopyWith$Variables$Mutation$UnlikePost<TRes> {
  factory CopyWith$Variables$Mutation$UnlikePost(
    Variables$Mutation$UnlikePost instance,
    TRes Function(Variables$Mutation$UnlikePost) then,
  ) = _CopyWithImpl$Variables$Mutation$UnlikePost;

  factory CopyWith$Variables$Mutation$UnlikePost.stub(TRes res) =
      _CopyWithStubImpl$Variables$Mutation$UnlikePost;

  TRes call({String? postId});
}

class _CopyWithImpl$Variables$Mutation$UnlikePost<TRes>
    implements CopyWith$Variables$Mutation$UnlikePost<TRes> {
  _CopyWithImpl$Variables$Mutation$UnlikePost(this._instance, this._then);

  final Variables$Mutation$UnlikePost _instance;

  final TRes Function(Variables$Mutation$UnlikePost) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? postId = _undefined}) => _then(
    Variables$Mutation$UnlikePost._({
      ..._instance._$data,
      if (postId != _undefined && postId != null) 'postId': (postId as String),
    }),
  );
}

class _CopyWithStubImpl$Variables$Mutation$UnlikePost<TRes>
    implements CopyWith$Variables$Mutation$UnlikePost<TRes> {
  _CopyWithStubImpl$Variables$Mutation$UnlikePost(this._res);

  TRes _res;

  call({String? postId}) => _res;
}

class Mutation$UnlikePost {
  Mutation$UnlikePost({required this.unlikePost});

  factory Mutation$UnlikePost.fromJson(Map<String, dynamic> json) {
    final l$unlikePost = json['unlikePost'];
    return Mutation$UnlikePost(
      unlikePost: Mutation$UnlikePost$unlikePost.fromJson(
        (l$unlikePost as Map<String, dynamic>),
      ),
    );
  }

  final Mutation$UnlikePost$unlikePost unlikePost;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$unlikePost = unlikePost;
    _resultData['unlikePost'] = l$unlikePost.toJson();
    return _resultData;
  }

  @override
  int get hashCode {
    final l$unlikePost = unlikePost;
    return Object.hashAll([l$unlikePost]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$UnlikePost || runtimeType != other.runtimeType) {
      return false;
    }
    final l$unlikePost = unlikePost;
    final lOther$unlikePost = other.unlikePost;
    if (l$unlikePost != lOther$unlikePost) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Mutation$UnlikePost on Mutation$UnlikePost {
  CopyWith$Mutation$UnlikePost<Mutation$UnlikePost> get copyWith =>
      CopyWith$Mutation$UnlikePost(this, (i) => i);
}

abstract class CopyWith$Mutation$UnlikePost<TRes> {
  factory CopyWith$Mutation$UnlikePost(
    Mutation$UnlikePost instance,
    TRes Function(Mutation$UnlikePost) then,
  ) = _CopyWithImpl$Mutation$UnlikePost;

  factory CopyWith$Mutation$UnlikePost.stub(TRes res) =
      _CopyWithStubImpl$Mutation$UnlikePost;

  TRes call({Mutation$UnlikePost$unlikePost? unlikePost});
  CopyWith$Mutation$UnlikePost$unlikePost<TRes> get unlikePost;
}

class _CopyWithImpl$Mutation$UnlikePost<TRes>
    implements CopyWith$Mutation$UnlikePost<TRes> {
  _CopyWithImpl$Mutation$UnlikePost(this._instance, this._then);

  final Mutation$UnlikePost _instance;

  final TRes Function(Mutation$UnlikePost) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? unlikePost = _undefined}) => _then(
    Mutation$UnlikePost(
      unlikePost: unlikePost == _undefined || unlikePost == null
          ? _instance.unlikePost
          : (unlikePost as Mutation$UnlikePost$unlikePost),
    ),
  );

  CopyWith$Mutation$UnlikePost$unlikePost<TRes> get unlikePost {
    final local$unlikePost = _instance.unlikePost;
    return CopyWith$Mutation$UnlikePost$unlikePost(
      local$unlikePost,
      (e) => call(unlikePost: e),
    );
  }
}

class _CopyWithStubImpl$Mutation$UnlikePost<TRes>
    implements CopyWith$Mutation$UnlikePost<TRes> {
  _CopyWithStubImpl$Mutation$UnlikePost(this._res);

  TRes _res;

  call({Mutation$UnlikePost$unlikePost? unlikePost}) => _res;

  CopyWith$Mutation$UnlikePost$unlikePost<TRes> get unlikePost =>
      CopyWith$Mutation$UnlikePost$unlikePost.stub(_res);
}

const documentNodeMutationUnlikePost = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'UnlikePost'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'postId')),
          type: NamedTypeNode(name: NameNode(value: 'ID'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
      ],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'unlikePost'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'input'),
                value: ObjectValueNode(
                  fields: [
                    ObjectFieldNode(
                      name: NameNode(value: 'postId'),
                      value: VariableNode(name: NameNode(value: 'postId')),
                    ),
                  ],
                ),
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
                  name: NameNode(value: 'likeCount'),
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

class Mutation$UnlikePost$unlikePost {
  Mutation$UnlikePost$unlikePost({
    required this.success,
    required this.userErrors,
    this.likeCount,
  });

  factory Mutation$UnlikePost$unlikePost.fromJson(Map<String, dynamic> json) {
    final l$success = json['success'];
    final l$userErrors = json['userErrors'];
    final l$likeCount = json['likeCount'];
    return Mutation$UnlikePost$unlikePost(
      success: (l$success as bool),
      userErrors: (l$userErrors as List<dynamic>)
          .map(
            (e) => Mutation$UnlikePost$unlikePost$userErrors.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      likeCount: (l$likeCount as int?),
    );
  }

  final bool success;

  final List<Mutation$UnlikePost$unlikePost$userErrors> userErrors;

  final int? likeCount;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$success = success;
    _resultData['success'] = l$success;
    final l$userErrors = userErrors;
    _resultData['userErrors'] = l$userErrors.map((e) => e.toJson()).toList();
    final l$likeCount = likeCount;
    _resultData['likeCount'] = l$likeCount;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$success = success;
    final l$userErrors = userErrors;
    final l$likeCount = likeCount;
    return Object.hashAll([
      l$success,
      Object.hashAll(l$userErrors.map((v) => v)),
      l$likeCount,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$UnlikePost$unlikePost ||
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
    final l$likeCount = likeCount;
    final lOther$likeCount = other.likeCount;
    if (l$likeCount != lOther$likeCount) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Mutation$UnlikePost$unlikePost
    on Mutation$UnlikePost$unlikePost {
  CopyWith$Mutation$UnlikePost$unlikePost<Mutation$UnlikePost$unlikePost>
  get copyWith => CopyWith$Mutation$UnlikePost$unlikePost(this, (i) => i);
}

abstract class CopyWith$Mutation$UnlikePost$unlikePost<TRes> {
  factory CopyWith$Mutation$UnlikePost$unlikePost(
    Mutation$UnlikePost$unlikePost instance,
    TRes Function(Mutation$UnlikePost$unlikePost) then,
  ) = _CopyWithImpl$Mutation$UnlikePost$unlikePost;

  factory CopyWith$Mutation$UnlikePost$unlikePost.stub(TRes res) =
      _CopyWithStubImpl$Mutation$UnlikePost$unlikePost;

  TRes call({
    bool? success,
    List<Mutation$UnlikePost$unlikePost$userErrors>? userErrors,
    int? likeCount,
  });
  TRes userErrors(
    Iterable<Mutation$UnlikePost$unlikePost$userErrors> Function(
      Iterable<
        CopyWith$Mutation$UnlikePost$unlikePost$userErrors<
          Mutation$UnlikePost$unlikePost$userErrors
        >
      >,
    )
    _fn,
  );
}

class _CopyWithImpl$Mutation$UnlikePost$unlikePost<TRes>
    implements CopyWith$Mutation$UnlikePost$unlikePost<TRes> {
  _CopyWithImpl$Mutation$UnlikePost$unlikePost(this._instance, this._then);

  final Mutation$UnlikePost$unlikePost _instance;

  final TRes Function(Mutation$UnlikePost$unlikePost) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? success = _undefined,
    Object? userErrors = _undefined,
    Object? likeCount = _undefined,
  }) => _then(
    Mutation$UnlikePost$unlikePost(
      success: success == _undefined || success == null
          ? _instance.success
          : (success as bool),
      userErrors: userErrors == _undefined || userErrors == null
          ? _instance.userErrors
          : (userErrors as List<Mutation$UnlikePost$unlikePost$userErrors>),
      likeCount: likeCount == _undefined
          ? _instance.likeCount
          : (likeCount as int?),
    ),
  );

  TRes userErrors(
    Iterable<Mutation$UnlikePost$unlikePost$userErrors> Function(
      Iterable<
        CopyWith$Mutation$UnlikePost$unlikePost$userErrors<
          Mutation$UnlikePost$unlikePost$userErrors
        >
      >,
    )
    _fn,
  ) => call(
    userErrors: _fn(
      _instance.userErrors.map(
        (e) => CopyWith$Mutation$UnlikePost$unlikePost$userErrors(e, (i) => i),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl$Mutation$UnlikePost$unlikePost<TRes>
    implements CopyWith$Mutation$UnlikePost$unlikePost<TRes> {
  _CopyWithStubImpl$Mutation$UnlikePost$unlikePost(this._res);

  TRes _res;

  call({
    bool? success,
    List<Mutation$UnlikePost$unlikePost$userErrors>? userErrors,
    int? likeCount,
  }) => _res;

  userErrors(_fn) => _res;
}

class Mutation$UnlikePost$unlikePost$userErrors {
  Mutation$UnlikePost$unlikePost$userErrors({
    required this.code,
    required this.message,
    this.field,
  });

  factory Mutation$UnlikePost$unlikePost$userErrors.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$code = json['code'];
    final l$message = json['message'];
    final l$field = json['field'];
    return Mutation$UnlikePost$unlikePost$userErrors(
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
    if (other is! Mutation$UnlikePost$unlikePost$userErrors ||
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

extension UtilityExtension$Mutation$UnlikePost$unlikePost$userErrors
    on Mutation$UnlikePost$unlikePost$userErrors {
  CopyWith$Mutation$UnlikePost$unlikePost$userErrors<
    Mutation$UnlikePost$unlikePost$userErrors
  >
  get copyWith =>
      CopyWith$Mutation$UnlikePost$unlikePost$userErrors(this, (i) => i);
}

abstract class CopyWith$Mutation$UnlikePost$unlikePost$userErrors<TRes> {
  factory CopyWith$Mutation$UnlikePost$unlikePost$userErrors(
    Mutation$UnlikePost$unlikePost$userErrors instance,
    TRes Function(Mutation$UnlikePost$unlikePost$userErrors) then,
  ) = _CopyWithImpl$Mutation$UnlikePost$unlikePost$userErrors;

  factory CopyWith$Mutation$UnlikePost$unlikePost$userErrors.stub(TRes res) =
      _CopyWithStubImpl$Mutation$UnlikePost$unlikePost$userErrors;

  TRes call({String? code, String? message, String? field});
}

class _CopyWithImpl$Mutation$UnlikePost$unlikePost$userErrors<TRes>
    implements CopyWith$Mutation$UnlikePost$unlikePost$userErrors<TRes> {
  _CopyWithImpl$Mutation$UnlikePost$unlikePost$userErrors(
    this._instance,
    this._then,
  );

  final Mutation$UnlikePost$unlikePost$userErrors _instance;

  final TRes Function(Mutation$UnlikePost$unlikePost$userErrors) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? code = _undefined,
    Object? message = _undefined,
    Object? field = _undefined,
  }) => _then(
    Mutation$UnlikePost$unlikePost$userErrors(
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

class _CopyWithStubImpl$Mutation$UnlikePost$unlikePost$userErrors<TRes>
    implements CopyWith$Mutation$UnlikePost$unlikePost$userErrors<TRes> {
  _CopyWithStubImpl$Mutation$UnlikePost$unlikePost$userErrors(this._res);

  TRes _res;

  call({String? code, String? message, String? field}) => _res;
}

class Variables$Mutation$CreatePost {
  factory Variables$Mutation$CreatePost({
    required Enum$PostTargetType targetType,
    required String targetId,
    required Enum$PostTopic topic,
    required String body,
    required List<String> photoKeys,
  }) => Variables$Mutation$CreatePost._({
    r'targetType': targetType,
    r'targetId': targetId,
    r'topic': topic,
    r'body': body,
    r'photoKeys': photoKeys,
  });

  Variables$Mutation$CreatePost._(this._$data);

  factory Variables$Mutation$CreatePost.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$targetType = data['targetType'];
    result$data['targetType'] = fromJson$Enum$PostTargetType(
      (l$targetType as String),
    );
    final l$targetId = data['targetId'];
    result$data['targetId'] = (l$targetId as String);
    final l$topic = data['topic'];
    result$data['topic'] = fromJson$Enum$PostTopic((l$topic as String));
    final l$body = data['body'];
    result$data['body'] = (l$body as String);
    final l$photoKeys = data['photoKeys'];
    result$data['photoKeys'] = (l$photoKeys as List<dynamic>)
        .map((e) => (e as String))
        .toList();
    return Variables$Mutation$CreatePost._(result$data);
  }

  Map<String, dynamic> _$data;

  Enum$PostTargetType get targetType =>
      (_$data['targetType'] as Enum$PostTargetType);

  String get targetId => (_$data['targetId'] as String);

  Enum$PostTopic get topic => (_$data['topic'] as Enum$PostTopic);

  String get body => (_$data['body'] as String);

  List<String> get photoKeys => (_$data['photoKeys'] as List<String>);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$targetType = targetType;
    result$data['targetType'] = toJson$Enum$PostTargetType(l$targetType);
    final l$targetId = targetId;
    result$data['targetId'] = l$targetId;
    final l$topic = topic;
    result$data['topic'] = toJson$Enum$PostTopic(l$topic);
    final l$body = body;
    result$data['body'] = l$body;
    final l$photoKeys = photoKeys;
    result$data['photoKeys'] = l$photoKeys.map((e) => e).toList();
    return result$data;
  }

  CopyWith$Variables$Mutation$CreatePost<Variables$Mutation$CreatePost>
  get copyWith => CopyWith$Variables$Mutation$CreatePost(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Mutation$CreatePost ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$targetType = targetType;
    final lOther$targetType = other.targetType;
    if (l$targetType != lOther$targetType) {
      return false;
    }
    final l$targetId = targetId;
    final lOther$targetId = other.targetId;
    if (l$targetId != lOther$targetId) {
      return false;
    }
    final l$topic = topic;
    final lOther$topic = other.topic;
    if (l$topic != lOther$topic) {
      return false;
    }
    final l$body = body;
    final lOther$body = other.body;
    if (l$body != lOther$body) {
      return false;
    }
    final l$photoKeys = photoKeys;
    final lOther$photoKeys = other.photoKeys;
    if (l$photoKeys.length != lOther$photoKeys.length) {
      return false;
    }
    for (int i = 0; i < l$photoKeys.length; i++) {
      final l$photoKeys$entry = l$photoKeys[i];
      final lOther$photoKeys$entry = lOther$photoKeys[i];
      if (l$photoKeys$entry != lOther$photoKeys$entry) {
        return false;
      }
    }
    return true;
  }

  @override
  int get hashCode {
    final l$targetType = targetType;
    final l$targetId = targetId;
    final l$topic = topic;
    final l$body = body;
    final l$photoKeys = photoKeys;
    return Object.hashAll([
      l$targetType,
      l$targetId,
      l$topic,
      l$body,
      Object.hashAll(l$photoKeys.map((v) => v)),
    ]);
  }
}

abstract class CopyWith$Variables$Mutation$CreatePost<TRes> {
  factory CopyWith$Variables$Mutation$CreatePost(
    Variables$Mutation$CreatePost instance,
    TRes Function(Variables$Mutation$CreatePost) then,
  ) = _CopyWithImpl$Variables$Mutation$CreatePost;

  factory CopyWith$Variables$Mutation$CreatePost.stub(TRes res) =
      _CopyWithStubImpl$Variables$Mutation$CreatePost;

  TRes call({
    Enum$PostTargetType? targetType,
    String? targetId,
    Enum$PostTopic? topic,
    String? body,
    List<String>? photoKeys,
  });
}

class _CopyWithImpl$Variables$Mutation$CreatePost<TRes>
    implements CopyWith$Variables$Mutation$CreatePost<TRes> {
  _CopyWithImpl$Variables$Mutation$CreatePost(this._instance, this._then);

  final Variables$Mutation$CreatePost _instance;

  final TRes Function(Variables$Mutation$CreatePost) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? targetType = _undefined,
    Object? targetId = _undefined,
    Object? topic = _undefined,
    Object? body = _undefined,
    Object? photoKeys = _undefined,
  }) => _then(
    Variables$Mutation$CreatePost._({
      ..._instance._$data,
      if (targetType != _undefined && targetType != null)
        'targetType': (targetType as Enum$PostTargetType),
      if (targetId != _undefined && targetId != null)
        'targetId': (targetId as String),
      if (topic != _undefined && topic != null)
        'topic': (topic as Enum$PostTopic),
      if (body != _undefined && body != null) 'body': (body as String),
      if (photoKeys != _undefined && photoKeys != null)
        'photoKeys': (photoKeys as List<String>),
    }),
  );
}

class _CopyWithStubImpl$Variables$Mutation$CreatePost<TRes>
    implements CopyWith$Variables$Mutation$CreatePost<TRes> {
  _CopyWithStubImpl$Variables$Mutation$CreatePost(this._res);

  TRes _res;

  call({
    Enum$PostTargetType? targetType,
    String? targetId,
    Enum$PostTopic? topic,
    String? body,
    List<String>? photoKeys,
  }) => _res;
}

class Mutation$CreatePost {
  Mutation$CreatePost({required this.createPost});

  factory Mutation$CreatePost.fromJson(Map<String, dynamic> json) {
    final l$createPost = json['createPost'];
    return Mutation$CreatePost(
      createPost: Mutation$CreatePost$createPost.fromJson(
        (l$createPost as Map<String, dynamic>),
      ),
    );
  }

  final Mutation$CreatePost$createPost createPost;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$createPost = createPost;
    _resultData['createPost'] = l$createPost.toJson();
    return _resultData;
  }

  @override
  int get hashCode {
    final l$createPost = createPost;
    return Object.hashAll([l$createPost]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$CreatePost || runtimeType != other.runtimeType) {
      return false;
    }
    final l$createPost = createPost;
    final lOther$createPost = other.createPost;
    if (l$createPost != lOther$createPost) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Mutation$CreatePost on Mutation$CreatePost {
  CopyWith$Mutation$CreatePost<Mutation$CreatePost> get copyWith =>
      CopyWith$Mutation$CreatePost(this, (i) => i);
}

abstract class CopyWith$Mutation$CreatePost<TRes> {
  factory CopyWith$Mutation$CreatePost(
    Mutation$CreatePost instance,
    TRes Function(Mutation$CreatePost) then,
  ) = _CopyWithImpl$Mutation$CreatePost;

  factory CopyWith$Mutation$CreatePost.stub(TRes res) =
      _CopyWithStubImpl$Mutation$CreatePost;

  TRes call({Mutation$CreatePost$createPost? createPost});
  CopyWith$Mutation$CreatePost$createPost<TRes> get createPost;
}

class _CopyWithImpl$Mutation$CreatePost<TRes>
    implements CopyWith$Mutation$CreatePost<TRes> {
  _CopyWithImpl$Mutation$CreatePost(this._instance, this._then);

  final Mutation$CreatePost _instance;

  final TRes Function(Mutation$CreatePost) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? createPost = _undefined}) => _then(
    Mutation$CreatePost(
      createPost: createPost == _undefined || createPost == null
          ? _instance.createPost
          : (createPost as Mutation$CreatePost$createPost),
    ),
  );

  CopyWith$Mutation$CreatePost$createPost<TRes> get createPost {
    final local$createPost = _instance.createPost;
    return CopyWith$Mutation$CreatePost$createPost(
      local$createPost,
      (e) => call(createPost: e),
    );
  }
}

class _CopyWithStubImpl$Mutation$CreatePost<TRes>
    implements CopyWith$Mutation$CreatePost<TRes> {
  _CopyWithStubImpl$Mutation$CreatePost(this._res);

  TRes _res;

  call({Mutation$CreatePost$createPost? createPost}) => _res;

  CopyWith$Mutation$CreatePost$createPost<TRes> get createPost =>
      CopyWith$Mutation$CreatePost$createPost.stub(_res);
}

const documentNodeMutationCreatePost = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'CreatePost'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'targetType')),
          type: NamedTypeNode(
            name: NameNode(value: 'PostTargetType'),
            isNonNull: true,
          ),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'targetId')),
          type: NamedTypeNode(name: NameNode(value: 'ID'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'topic')),
          type: NamedTypeNode(
            name: NameNode(value: 'PostTopic'),
            isNonNull: true,
          ),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'body')),
          type: NamedTypeNode(name: NameNode(value: 'String'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'photoKeys')),
          type: ListTypeNode(
            type: NamedTypeNode(
              name: NameNode(value: 'String'),
              isNonNull: true,
            ),
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
            name: NameNode(value: 'createPost'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'input'),
                value: ObjectValueNode(
                  fields: [
                    ObjectFieldNode(
                      name: NameNode(value: 'targetType'),
                      value: VariableNode(name: NameNode(value: 'targetType')),
                    ),
                    ObjectFieldNode(
                      name: NameNode(value: 'targetId'),
                      value: VariableNode(name: NameNode(value: 'targetId')),
                    ),
                    ObjectFieldNode(
                      name: NameNode(value: 'topic'),
                      value: VariableNode(name: NameNode(value: 'topic')),
                    ),
                    ObjectFieldNode(
                      name: NameNode(value: 'body'),
                      value: VariableNode(name: NameNode(value: 'body')),
                    ),
                    ObjectFieldNode(
                      name: NameNode(value: 'photoKeys'),
                      value: VariableNode(name: NameNode(value: 'photoKeys')),
                    ),
                  ],
                ),
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
                  name: NameNode(value: 'postId'),
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

class Mutation$CreatePost$createPost {
  Mutation$CreatePost$createPost({
    required this.success,
    required this.userErrors,
    this.postId,
  });

  factory Mutation$CreatePost$createPost.fromJson(Map<String, dynamic> json) {
    final l$success = json['success'];
    final l$userErrors = json['userErrors'];
    final l$postId = json['postId'];
    return Mutation$CreatePost$createPost(
      success: (l$success as bool),
      userErrors: (l$userErrors as List<dynamic>)
          .map(
            (e) => Mutation$CreatePost$createPost$userErrors.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      postId: (l$postId as String?),
    );
  }

  final bool success;

  final List<Mutation$CreatePost$createPost$userErrors> userErrors;

  final String? postId;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$success = success;
    _resultData['success'] = l$success;
    final l$userErrors = userErrors;
    _resultData['userErrors'] = l$userErrors.map((e) => e.toJson()).toList();
    final l$postId = postId;
    _resultData['postId'] = l$postId;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$success = success;
    final l$userErrors = userErrors;
    final l$postId = postId;
    return Object.hashAll([
      l$success,
      Object.hashAll(l$userErrors.map((v) => v)),
      l$postId,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$CreatePost$createPost ||
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
    final l$postId = postId;
    final lOther$postId = other.postId;
    if (l$postId != lOther$postId) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Mutation$CreatePost$createPost
    on Mutation$CreatePost$createPost {
  CopyWith$Mutation$CreatePost$createPost<Mutation$CreatePost$createPost>
  get copyWith => CopyWith$Mutation$CreatePost$createPost(this, (i) => i);
}

abstract class CopyWith$Mutation$CreatePost$createPost<TRes> {
  factory CopyWith$Mutation$CreatePost$createPost(
    Mutation$CreatePost$createPost instance,
    TRes Function(Mutation$CreatePost$createPost) then,
  ) = _CopyWithImpl$Mutation$CreatePost$createPost;

  factory CopyWith$Mutation$CreatePost$createPost.stub(TRes res) =
      _CopyWithStubImpl$Mutation$CreatePost$createPost;

  TRes call({
    bool? success,
    List<Mutation$CreatePost$createPost$userErrors>? userErrors,
    String? postId,
  });
  TRes userErrors(
    Iterable<Mutation$CreatePost$createPost$userErrors> Function(
      Iterable<
        CopyWith$Mutation$CreatePost$createPost$userErrors<
          Mutation$CreatePost$createPost$userErrors
        >
      >,
    )
    _fn,
  );
}

class _CopyWithImpl$Mutation$CreatePost$createPost<TRes>
    implements CopyWith$Mutation$CreatePost$createPost<TRes> {
  _CopyWithImpl$Mutation$CreatePost$createPost(this._instance, this._then);

  final Mutation$CreatePost$createPost _instance;

  final TRes Function(Mutation$CreatePost$createPost) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? success = _undefined,
    Object? userErrors = _undefined,
    Object? postId = _undefined,
  }) => _then(
    Mutation$CreatePost$createPost(
      success: success == _undefined || success == null
          ? _instance.success
          : (success as bool),
      userErrors: userErrors == _undefined || userErrors == null
          ? _instance.userErrors
          : (userErrors as List<Mutation$CreatePost$createPost$userErrors>),
      postId: postId == _undefined ? _instance.postId : (postId as String?),
    ),
  );

  TRes userErrors(
    Iterable<Mutation$CreatePost$createPost$userErrors> Function(
      Iterable<
        CopyWith$Mutation$CreatePost$createPost$userErrors<
          Mutation$CreatePost$createPost$userErrors
        >
      >,
    )
    _fn,
  ) => call(
    userErrors: _fn(
      _instance.userErrors.map(
        (e) => CopyWith$Mutation$CreatePost$createPost$userErrors(e, (i) => i),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl$Mutation$CreatePost$createPost<TRes>
    implements CopyWith$Mutation$CreatePost$createPost<TRes> {
  _CopyWithStubImpl$Mutation$CreatePost$createPost(this._res);

  TRes _res;

  call({
    bool? success,
    List<Mutation$CreatePost$createPost$userErrors>? userErrors,
    String? postId,
  }) => _res;

  userErrors(_fn) => _res;
}

class Mutation$CreatePost$createPost$userErrors {
  Mutation$CreatePost$createPost$userErrors({
    required this.code,
    required this.message,
    this.field,
  });

  factory Mutation$CreatePost$createPost$userErrors.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$code = json['code'];
    final l$message = json['message'];
    final l$field = json['field'];
    return Mutation$CreatePost$createPost$userErrors(
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
    if (other is! Mutation$CreatePost$createPost$userErrors ||
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

extension UtilityExtension$Mutation$CreatePost$createPost$userErrors
    on Mutation$CreatePost$createPost$userErrors {
  CopyWith$Mutation$CreatePost$createPost$userErrors<
    Mutation$CreatePost$createPost$userErrors
  >
  get copyWith =>
      CopyWith$Mutation$CreatePost$createPost$userErrors(this, (i) => i);
}

abstract class CopyWith$Mutation$CreatePost$createPost$userErrors<TRes> {
  factory CopyWith$Mutation$CreatePost$createPost$userErrors(
    Mutation$CreatePost$createPost$userErrors instance,
    TRes Function(Mutation$CreatePost$createPost$userErrors) then,
  ) = _CopyWithImpl$Mutation$CreatePost$createPost$userErrors;

  factory CopyWith$Mutation$CreatePost$createPost$userErrors.stub(TRes res) =
      _CopyWithStubImpl$Mutation$CreatePost$createPost$userErrors;

  TRes call({String? code, String? message, String? field});
}

class _CopyWithImpl$Mutation$CreatePost$createPost$userErrors<TRes>
    implements CopyWith$Mutation$CreatePost$createPost$userErrors<TRes> {
  _CopyWithImpl$Mutation$CreatePost$createPost$userErrors(
    this._instance,
    this._then,
  );

  final Mutation$CreatePost$createPost$userErrors _instance;

  final TRes Function(Mutation$CreatePost$createPost$userErrors) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? code = _undefined,
    Object? message = _undefined,
    Object? field = _undefined,
  }) => _then(
    Mutation$CreatePost$createPost$userErrors(
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

class _CopyWithStubImpl$Mutation$CreatePost$createPost$userErrors<TRes>
    implements CopyWith$Mutation$CreatePost$createPost$userErrors<TRes> {
  _CopyWithStubImpl$Mutation$CreatePost$createPost$userErrors(this._res);

  TRes _res;

  call({String? code, String? message, String? field}) => _res;
}

class Variables$Mutation$CreateComment {
  factory Variables$Mutation$CreateComment({
    required String postId,
    required String body,
  }) => Variables$Mutation$CreateComment._({r'postId': postId, r'body': body});

  Variables$Mutation$CreateComment._(this._$data);

  factory Variables$Mutation$CreateComment.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$postId = data['postId'];
    result$data['postId'] = (l$postId as String);
    final l$body = data['body'];
    result$data['body'] = (l$body as String);
    return Variables$Mutation$CreateComment._(result$data);
  }

  Map<String, dynamic> _$data;

  String get postId => (_$data['postId'] as String);

  String get body => (_$data['body'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$postId = postId;
    result$data['postId'] = l$postId;
    final l$body = body;
    result$data['body'] = l$body;
    return result$data;
  }

  CopyWith$Variables$Mutation$CreateComment<Variables$Mutation$CreateComment>
  get copyWith => CopyWith$Variables$Mutation$CreateComment(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Mutation$CreateComment ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$postId = postId;
    final lOther$postId = other.postId;
    if (l$postId != lOther$postId) {
      return false;
    }
    final l$body = body;
    final lOther$body = other.body;
    if (l$body != lOther$body) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$postId = postId;
    final l$body = body;
    return Object.hashAll([l$postId, l$body]);
  }
}

abstract class CopyWith$Variables$Mutation$CreateComment<TRes> {
  factory CopyWith$Variables$Mutation$CreateComment(
    Variables$Mutation$CreateComment instance,
    TRes Function(Variables$Mutation$CreateComment) then,
  ) = _CopyWithImpl$Variables$Mutation$CreateComment;

  factory CopyWith$Variables$Mutation$CreateComment.stub(TRes res) =
      _CopyWithStubImpl$Variables$Mutation$CreateComment;

  TRes call({String? postId, String? body});
}

class _CopyWithImpl$Variables$Mutation$CreateComment<TRes>
    implements CopyWith$Variables$Mutation$CreateComment<TRes> {
  _CopyWithImpl$Variables$Mutation$CreateComment(this._instance, this._then);

  final Variables$Mutation$CreateComment _instance;

  final TRes Function(Variables$Mutation$CreateComment) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? postId = _undefined, Object? body = _undefined}) => _then(
    Variables$Mutation$CreateComment._({
      ..._instance._$data,
      if (postId != _undefined && postId != null) 'postId': (postId as String),
      if (body != _undefined && body != null) 'body': (body as String),
    }),
  );
}

class _CopyWithStubImpl$Variables$Mutation$CreateComment<TRes>
    implements CopyWith$Variables$Mutation$CreateComment<TRes> {
  _CopyWithStubImpl$Variables$Mutation$CreateComment(this._res);

  TRes _res;

  call({String? postId, String? body}) => _res;
}

class Mutation$CreateComment {
  Mutation$CreateComment({required this.createComment});

  factory Mutation$CreateComment.fromJson(Map<String, dynamic> json) {
    final l$createComment = json['createComment'];
    return Mutation$CreateComment(
      createComment: Mutation$CreateComment$createComment.fromJson(
        (l$createComment as Map<String, dynamic>),
      ),
    );
  }

  final Mutation$CreateComment$createComment createComment;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$createComment = createComment;
    _resultData['createComment'] = l$createComment.toJson();
    return _resultData;
  }

  @override
  int get hashCode {
    final l$createComment = createComment;
    return Object.hashAll([l$createComment]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$CreateComment || runtimeType != other.runtimeType) {
      return false;
    }
    final l$createComment = createComment;
    final lOther$createComment = other.createComment;
    if (l$createComment != lOther$createComment) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Mutation$CreateComment on Mutation$CreateComment {
  CopyWith$Mutation$CreateComment<Mutation$CreateComment> get copyWith =>
      CopyWith$Mutation$CreateComment(this, (i) => i);
}

abstract class CopyWith$Mutation$CreateComment<TRes> {
  factory CopyWith$Mutation$CreateComment(
    Mutation$CreateComment instance,
    TRes Function(Mutation$CreateComment) then,
  ) = _CopyWithImpl$Mutation$CreateComment;

  factory CopyWith$Mutation$CreateComment.stub(TRes res) =
      _CopyWithStubImpl$Mutation$CreateComment;

  TRes call({Mutation$CreateComment$createComment? createComment});
  CopyWith$Mutation$CreateComment$createComment<TRes> get createComment;
}

class _CopyWithImpl$Mutation$CreateComment<TRes>
    implements CopyWith$Mutation$CreateComment<TRes> {
  _CopyWithImpl$Mutation$CreateComment(this._instance, this._then);

  final Mutation$CreateComment _instance;

  final TRes Function(Mutation$CreateComment) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? createComment = _undefined}) => _then(
    Mutation$CreateComment(
      createComment: createComment == _undefined || createComment == null
          ? _instance.createComment
          : (createComment as Mutation$CreateComment$createComment),
    ),
  );

  CopyWith$Mutation$CreateComment$createComment<TRes> get createComment {
    final local$createComment = _instance.createComment;
    return CopyWith$Mutation$CreateComment$createComment(
      local$createComment,
      (e) => call(createComment: e),
    );
  }
}

class _CopyWithStubImpl$Mutation$CreateComment<TRes>
    implements CopyWith$Mutation$CreateComment<TRes> {
  _CopyWithStubImpl$Mutation$CreateComment(this._res);

  TRes _res;

  call({Mutation$CreateComment$createComment? createComment}) => _res;

  CopyWith$Mutation$CreateComment$createComment<TRes> get createComment =>
      CopyWith$Mutation$CreateComment$createComment.stub(_res);
}

const documentNodeMutationCreateComment = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'CreateComment'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'postId')),
          type: NamedTypeNode(name: NameNode(value: 'ID'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'body')),
          type: NamedTypeNode(name: NameNode(value: 'String'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
      ],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'createComment'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'input'),
                value: ObjectValueNode(
                  fields: [
                    ObjectFieldNode(
                      name: NameNode(value: 'postId'),
                      value: VariableNode(name: NameNode(value: 'postId')),
                    ),
                    ObjectFieldNode(
                      name: NameNode(value: 'body'),
                      value: VariableNode(name: NameNode(value: 'body')),
                    ),
                  ],
                ),
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
                  name: NameNode(value: 'commentId'),
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

class Mutation$CreateComment$createComment {
  Mutation$CreateComment$createComment({
    required this.success,
    required this.userErrors,
    this.commentId,
  });

  factory Mutation$CreateComment$createComment.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$success = json['success'];
    final l$userErrors = json['userErrors'];
    final l$commentId = json['commentId'];
    return Mutation$CreateComment$createComment(
      success: (l$success as bool),
      userErrors: (l$userErrors as List<dynamic>)
          .map(
            (e) => Mutation$CreateComment$createComment$userErrors.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      commentId: (l$commentId as String?),
    );
  }

  final bool success;

  final List<Mutation$CreateComment$createComment$userErrors> userErrors;

  final String? commentId;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$success = success;
    _resultData['success'] = l$success;
    final l$userErrors = userErrors;
    _resultData['userErrors'] = l$userErrors.map((e) => e.toJson()).toList();
    final l$commentId = commentId;
    _resultData['commentId'] = l$commentId;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$success = success;
    final l$userErrors = userErrors;
    final l$commentId = commentId;
    return Object.hashAll([
      l$success,
      Object.hashAll(l$userErrors.map((v) => v)),
      l$commentId,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$CreateComment$createComment ||
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
    final l$commentId = commentId;
    final lOther$commentId = other.commentId;
    if (l$commentId != lOther$commentId) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Mutation$CreateComment$createComment
    on Mutation$CreateComment$createComment {
  CopyWith$Mutation$CreateComment$createComment<
    Mutation$CreateComment$createComment
  >
  get copyWith => CopyWith$Mutation$CreateComment$createComment(this, (i) => i);
}

abstract class CopyWith$Mutation$CreateComment$createComment<TRes> {
  factory CopyWith$Mutation$CreateComment$createComment(
    Mutation$CreateComment$createComment instance,
    TRes Function(Mutation$CreateComment$createComment) then,
  ) = _CopyWithImpl$Mutation$CreateComment$createComment;

  factory CopyWith$Mutation$CreateComment$createComment.stub(TRes res) =
      _CopyWithStubImpl$Mutation$CreateComment$createComment;

  TRes call({
    bool? success,
    List<Mutation$CreateComment$createComment$userErrors>? userErrors,
    String? commentId,
  });
  TRes userErrors(
    Iterable<Mutation$CreateComment$createComment$userErrors> Function(
      Iterable<
        CopyWith$Mutation$CreateComment$createComment$userErrors<
          Mutation$CreateComment$createComment$userErrors
        >
      >,
    )
    _fn,
  );
}

class _CopyWithImpl$Mutation$CreateComment$createComment<TRes>
    implements CopyWith$Mutation$CreateComment$createComment<TRes> {
  _CopyWithImpl$Mutation$CreateComment$createComment(
    this._instance,
    this._then,
  );

  final Mutation$CreateComment$createComment _instance;

  final TRes Function(Mutation$CreateComment$createComment) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? success = _undefined,
    Object? userErrors = _undefined,
    Object? commentId = _undefined,
  }) => _then(
    Mutation$CreateComment$createComment(
      success: success == _undefined || success == null
          ? _instance.success
          : (success as bool),
      userErrors: userErrors == _undefined || userErrors == null
          ? _instance.userErrors
          : (userErrors
                as List<Mutation$CreateComment$createComment$userErrors>),
      commentId: commentId == _undefined
          ? _instance.commentId
          : (commentId as String?),
    ),
  );

  TRes userErrors(
    Iterable<Mutation$CreateComment$createComment$userErrors> Function(
      Iterable<
        CopyWith$Mutation$CreateComment$createComment$userErrors<
          Mutation$CreateComment$createComment$userErrors
        >
      >,
    )
    _fn,
  ) => call(
    userErrors: _fn(
      _instance.userErrors.map(
        (e) => CopyWith$Mutation$CreateComment$createComment$userErrors(
          e,
          (i) => i,
        ),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl$Mutation$CreateComment$createComment<TRes>
    implements CopyWith$Mutation$CreateComment$createComment<TRes> {
  _CopyWithStubImpl$Mutation$CreateComment$createComment(this._res);

  TRes _res;

  call({
    bool? success,
    List<Mutation$CreateComment$createComment$userErrors>? userErrors,
    String? commentId,
  }) => _res;

  userErrors(_fn) => _res;
}

class Mutation$CreateComment$createComment$userErrors {
  Mutation$CreateComment$createComment$userErrors({
    required this.code,
    required this.message,
    this.field,
  });

  factory Mutation$CreateComment$createComment$userErrors.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$code = json['code'];
    final l$message = json['message'];
    final l$field = json['field'];
    return Mutation$CreateComment$createComment$userErrors(
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
    if (other is! Mutation$CreateComment$createComment$userErrors ||
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

extension UtilityExtension$Mutation$CreateComment$createComment$userErrors
    on Mutation$CreateComment$createComment$userErrors {
  CopyWith$Mutation$CreateComment$createComment$userErrors<
    Mutation$CreateComment$createComment$userErrors
  >
  get copyWith =>
      CopyWith$Mutation$CreateComment$createComment$userErrors(this, (i) => i);
}

abstract class CopyWith$Mutation$CreateComment$createComment$userErrors<TRes> {
  factory CopyWith$Mutation$CreateComment$createComment$userErrors(
    Mutation$CreateComment$createComment$userErrors instance,
    TRes Function(Mutation$CreateComment$createComment$userErrors) then,
  ) = _CopyWithImpl$Mutation$CreateComment$createComment$userErrors;

  factory CopyWith$Mutation$CreateComment$createComment$userErrors.stub(
    TRes res,
  ) = _CopyWithStubImpl$Mutation$CreateComment$createComment$userErrors;

  TRes call({String? code, String? message, String? field});
}

class _CopyWithImpl$Mutation$CreateComment$createComment$userErrors<TRes>
    implements CopyWith$Mutation$CreateComment$createComment$userErrors<TRes> {
  _CopyWithImpl$Mutation$CreateComment$createComment$userErrors(
    this._instance,
    this._then,
  );

  final Mutation$CreateComment$createComment$userErrors _instance;

  final TRes Function(Mutation$CreateComment$createComment$userErrors) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? code = _undefined,
    Object? message = _undefined,
    Object? field = _undefined,
  }) => _then(
    Mutation$CreateComment$createComment$userErrors(
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

class _CopyWithStubImpl$Mutation$CreateComment$createComment$userErrors<TRes>
    implements CopyWith$Mutation$CreateComment$createComment$userErrors<TRes> {
  _CopyWithStubImpl$Mutation$CreateComment$createComment$userErrors(this._res);

  TRes _res;

  call({String? code, String? message, String? field}) => _res;
}
