// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, unused_element
import '../../../common/network/shared_schema.graphql.dart';
import 'community_schema.graphql.dart';
import 'package:gql/ast.dart';

class Fragment$PostCardFields {
  Fragment$PostCardFields({
    required this.id,
    required this.title,
    required this.body,
    required this.tags,
    required this.category,
    required this.createdAt,
    required this.photoKeys,
    required this.likeCount,
    required this.commentCount,
    required this.viewCount,
    required this.likedByViewer,
    required this.ownedByViewer,
    required this.hidden,
    required this.edited,
    this.spot,
    required this.author,
  });

  factory Fragment$PostCardFields.fromJson(Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$title = json['title'];
    final l$body = json['body'];
    final l$tags = json['tags'];
    final l$category = json['category'];
    final l$createdAt = json['createdAt'];
    final l$photoKeys = json['photoKeys'];
    final l$likeCount = json['likeCount'];
    final l$commentCount = json['commentCount'];
    final l$viewCount = json['viewCount'];
    final l$likedByViewer = json['likedByViewer'];
    final l$ownedByViewer = json['ownedByViewer'];
    final l$hidden = json['hidden'];
    final l$edited = json['edited'];
    final l$spot = json['spot'];
    final l$author = json['author'];
    return Fragment$PostCardFields(
      id: (l$id as String),
      title: (l$title as String),
      body: (l$body as String),
      tags: (l$tags as List<dynamic>).map((e) => (e as String)).toList(),
      category: fromJson$Enum$TargetCategory((l$category as String)),
      createdAt: (l$createdAt as String),
      photoKeys: (l$photoKeys as List<dynamic>)
          .map((e) => (e as String))
          .toList(),
      likeCount: (l$likeCount as int),
      commentCount: (l$commentCount as int),
      viewCount: (l$viewCount as int),
      likedByViewer: (l$likedByViewer as bool),
      ownedByViewer: (l$ownedByViewer as bool),
      hidden: (l$hidden as bool),
      edited: (l$edited as bool),
      spot: l$spot == null
          ? null
          : Fragment$PostCardFields$spot.fromJson(
              (l$spot as Map<String, dynamic>),
            ),
      author: Fragment$PostCardFields$author.fromJson(
        (l$author as Map<String, dynamic>),
      ),
    );
  }

  final String id;

  final String title;

  final String body;

  final List<String> tags;

  final Enum$TargetCategory category;

  final String createdAt;

  final List<String> photoKeys;

  final int likeCount;

  final int commentCount;

  final int viewCount;

  final bool likedByViewer;

  final bool ownedByViewer;

  final bool hidden;

  final bool edited;

  final Fragment$PostCardFields$spot? spot;

  final Fragment$PostCardFields$author author;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$title = title;
    _resultData['title'] = l$title;
    final l$body = body;
    _resultData['body'] = l$body;
    final l$tags = tags;
    _resultData['tags'] = l$tags.map((e) => e).toList();
    final l$category = category;
    _resultData['category'] = toJson$Enum$TargetCategory(l$category);
    final l$createdAt = createdAt;
    _resultData['createdAt'] = l$createdAt;
    final l$photoKeys = photoKeys;
    _resultData['photoKeys'] = l$photoKeys.map((e) => e).toList();
    final l$likeCount = likeCount;
    _resultData['likeCount'] = l$likeCount;
    final l$commentCount = commentCount;
    _resultData['commentCount'] = l$commentCount;
    final l$viewCount = viewCount;
    _resultData['viewCount'] = l$viewCount;
    final l$likedByViewer = likedByViewer;
    _resultData['likedByViewer'] = l$likedByViewer;
    final l$ownedByViewer = ownedByViewer;
    _resultData['ownedByViewer'] = l$ownedByViewer;
    final l$hidden = hidden;
    _resultData['hidden'] = l$hidden;
    final l$edited = edited;
    _resultData['edited'] = l$edited;
    final l$spot = spot;
    _resultData['spot'] = l$spot?.toJson();
    final l$author = author;
    _resultData['author'] = l$author.toJson();
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$title = title;
    final l$body = body;
    final l$tags = tags;
    final l$category = category;
    final l$createdAt = createdAt;
    final l$photoKeys = photoKeys;
    final l$likeCount = likeCount;
    final l$commentCount = commentCount;
    final l$viewCount = viewCount;
    final l$likedByViewer = likedByViewer;
    final l$ownedByViewer = ownedByViewer;
    final l$hidden = hidden;
    final l$edited = edited;
    final l$spot = spot;
    final l$author = author;
    return Object.hashAll([
      l$id,
      l$title,
      l$body,
      Object.hashAll(l$tags.map((v) => v)),
      l$category,
      l$createdAt,
      Object.hashAll(l$photoKeys.map((v) => v)),
      l$likeCount,
      l$commentCount,
      l$viewCount,
      l$likedByViewer,
      l$ownedByViewer,
      l$hidden,
      l$edited,
      l$spot,
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
    final l$title = title;
    final lOther$title = other.title;
    if (l$title != lOther$title) {
      return false;
    }
    final l$body = body;
    final lOther$body = other.body;
    if (l$body != lOther$body) {
      return false;
    }
    final l$tags = tags;
    final lOther$tags = other.tags;
    if (l$tags.length != lOther$tags.length) {
      return false;
    }
    for (int i = 0; i < l$tags.length; i++) {
      final l$tags$entry = l$tags[i];
      final lOther$tags$entry = lOther$tags[i];
      if (l$tags$entry != lOther$tags$entry) {
        return false;
      }
    }
    final l$category = category;
    final lOther$category = other.category;
    if (l$category != lOther$category) {
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
    final l$viewCount = viewCount;
    final lOther$viewCount = other.viewCount;
    if (l$viewCount != lOther$viewCount) {
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
    final l$edited = edited;
    final lOther$edited = other.edited;
    if (l$edited != lOther$edited) {
      return false;
    }
    final l$spot = spot;
    final lOther$spot = other.spot;
    if (l$spot != lOther$spot) {
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
    String? title,
    String? body,
    List<String>? tags,
    Enum$TargetCategory? category,
    String? createdAt,
    List<String>? photoKeys,
    int? likeCount,
    int? commentCount,
    int? viewCount,
    bool? likedByViewer,
    bool? ownedByViewer,
    bool? hidden,
    bool? edited,
    Fragment$PostCardFields$spot? spot,
    Fragment$PostCardFields$author? author,
  });
  CopyWith$Fragment$PostCardFields$spot<TRes> get spot;
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
    Object? title = _undefined,
    Object? body = _undefined,
    Object? tags = _undefined,
    Object? category = _undefined,
    Object? createdAt = _undefined,
    Object? photoKeys = _undefined,
    Object? likeCount = _undefined,
    Object? commentCount = _undefined,
    Object? viewCount = _undefined,
    Object? likedByViewer = _undefined,
    Object? ownedByViewer = _undefined,
    Object? hidden = _undefined,
    Object? edited = _undefined,
    Object? spot = _undefined,
    Object? author = _undefined,
  }) => _then(
    Fragment$PostCardFields(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      title: title == _undefined || title == null
          ? _instance.title
          : (title as String),
      body: body == _undefined || body == null
          ? _instance.body
          : (body as String),
      tags: tags == _undefined || tags == null
          ? _instance.tags
          : (tags as List<String>),
      category: category == _undefined || category == null
          ? _instance.category
          : (category as Enum$TargetCategory),
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
      viewCount: viewCount == _undefined || viewCount == null
          ? _instance.viewCount
          : (viewCount as int),
      likedByViewer: likedByViewer == _undefined || likedByViewer == null
          ? _instance.likedByViewer
          : (likedByViewer as bool),
      ownedByViewer: ownedByViewer == _undefined || ownedByViewer == null
          ? _instance.ownedByViewer
          : (ownedByViewer as bool),
      hidden: hidden == _undefined || hidden == null
          ? _instance.hidden
          : (hidden as bool),
      edited: edited == _undefined || edited == null
          ? _instance.edited
          : (edited as bool),
      spot: spot == _undefined
          ? _instance.spot
          : (spot as Fragment$PostCardFields$spot?),
      author: author == _undefined || author == null
          ? _instance.author
          : (author as Fragment$PostCardFields$author),
    ),
  );

  CopyWith$Fragment$PostCardFields$spot<TRes> get spot {
    final local$spot = _instance.spot;
    return local$spot == null
        ? CopyWith$Fragment$PostCardFields$spot.stub(_then(_instance))
        : CopyWith$Fragment$PostCardFields$spot(
            local$spot,
            (e) => call(spot: e),
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
    String? title,
    String? body,
    List<String>? tags,
    Enum$TargetCategory? category,
    String? createdAt,
    List<String>? photoKeys,
    int? likeCount,
    int? commentCount,
    int? viewCount,
    bool? likedByViewer,
    bool? ownedByViewer,
    bool? hidden,
    bool? edited,
    Fragment$PostCardFields$spot? spot,
    Fragment$PostCardFields$author? author,
  }) => _res;

  CopyWith$Fragment$PostCardFields$spot<TRes> get spot =>
      CopyWith$Fragment$PostCardFields$spot.stub(_res);

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
        name: NameNode(value: 'title'),
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
        name: NameNode(value: 'tags'),
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
        name: NameNode(value: 'viewCount'),
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
        name: NameNode(value: 'edited'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'spot'),
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

class Fragment$PostCardFields$spot {
  Fragment$PostCardFields$spot({
    required this.id,
    required this.title,
    required this.thumbnailImageUrl,
    this.category,
  });

  factory Fragment$PostCardFields$spot.fromJson(Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$title = json['title'];
    final l$thumbnailImageUrl = json['thumbnailImageUrl'];
    final l$category = json['category'];
    return Fragment$PostCardFields$spot(
      id: (l$id as String),
      title: (l$title as String),
      thumbnailImageUrl: (l$thumbnailImageUrl as String),
      category: l$category == null
          ? null
          : fromJson$Enum$TargetCategory((l$category as String)),
    );
  }

  final String id;

  final String title;

  final String thumbnailImageUrl;

  final Enum$TargetCategory? category;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$title = title;
    _resultData['title'] = l$title;
    final l$thumbnailImageUrl = thumbnailImageUrl;
    _resultData['thumbnailImageUrl'] = l$thumbnailImageUrl;
    final l$category = category;
    _resultData['category'] = l$category == null
        ? null
        : toJson$Enum$TargetCategory(l$category);
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$title = title;
    final l$thumbnailImageUrl = thumbnailImageUrl;
    final l$category = category;
    return Object.hashAll([l$id, l$title, l$thumbnailImageUrl, l$category]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment$PostCardFields$spot ||
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
    return true;
  }
}

extension UtilityExtension$Fragment$PostCardFields$spot
    on Fragment$PostCardFields$spot {
  CopyWith$Fragment$PostCardFields$spot<Fragment$PostCardFields$spot>
  get copyWith => CopyWith$Fragment$PostCardFields$spot(this, (i) => i);
}

abstract class CopyWith$Fragment$PostCardFields$spot<TRes> {
  factory CopyWith$Fragment$PostCardFields$spot(
    Fragment$PostCardFields$spot instance,
    TRes Function(Fragment$PostCardFields$spot) then,
  ) = _CopyWithImpl$Fragment$PostCardFields$spot;

  factory CopyWith$Fragment$PostCardFields$spot.stub(TRes res) =
      _CopyWithStubImpl$Fragment$PostCardFields$spot;

  TRes call({
    String? id,
    String? title,
    String? thumbnailImageUrl,
    Enum$TargetCategory? category,
  });
}

class _CopyWithImpl$Fragment$PostCardFields$spot<TRes>
    implements CopyWith$Fragment$PostCardFields$spot<TRes> {
  _CopyWithImpl$Fragment$PostCardFields$spot(this._instance, this._then);

  final Fragment$PostCardFields$spot _instance;

  final TRes Function(Fragment$PostCardFields$spot) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? title = _undefined,
    Object? thumbnailImageUrl = _undefined,
    Object? category = _undefined,
  }) => _then(
    Fragment$PostCardFields$spot(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      title: title == _undefined || title == null
          ? _instance.title
          : (title as String),
      thumbnailImageUrl:
          thumbnailImageUrl == _undefined || thumbnailImageUrl == null
          ? _instance.thumbnailImageUrl
          : (thumbnailImageUrl as String),
      category: category == _undefined
          ? _instance.category
          : (category as Enum$TargetCategory?),
    ),
  );
}

class _CopyWithStubImpl$Fragment$PostCardFields$spot<TRes>
    implements CopyWith$Fragment$PostCardFields$spot<TRes> {
  _CopyWithStubImpl$Fragment$PostCardFields$spot(this._res);

  TRes _res;

  call({
    String? id,
    String? title,
    String? thumbnailImageUrl,
    Enum$TargetCategory? category,
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

class Variables$Query$Posts {
  factory Variables$Query$Posts({
    String? catalogId,
    double? latitude,
    double? longitude,
    int? radiusMeters,
    Enum$TargetCategory? category,
    String? tag,
    Enum$PostSortOrder? sort,
    bool? hiddenByViewer,
    int? first,
    String? after,
  }) => Variables$Query$Posts._({
    if (catalogId != null) r'catalogId': catalogId,
    if (latitude != null) r'latitude': latitude,
    if (longitude != null) r'longitude': longitude,
    if (radiusMeters != null) r'radiusMeters': radiusMeters,
    if (category != null) r'category': category,
    if (tag != null) r'tag': tag,
    if (sort != null) r'sort': sort,
    if (hiddenByViewer != null) r'hiddenByViewer': hiddenByViewer,
    if (first != null) r'first': first,
    if (after != null) r'after': after,
  });

  Variables$Query$Posts._(this._$data);

  factory Variables$Query$Posts.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    if (data.containsKey('catalogId')) {
      final l$catalogId = data['catalogId'];
      result$data['catalogId'] = (l$catalogId as String?);
    }
    if (data.containsKey('latitude')) {
      final l$latitude = data['latitude'];
      result$data['latitude'] = (l$latitude as num?)?.toDouble();
    }
    if (data.containsKey('longitude')) {
      final l$longitude = data['longitude'];
      result$data['longitude'] = (l$longitude as num?)?.toDouble();
    }
    if (data.containsKey('radiusMeters')) {
      final l$radiusMeters = data['radiusMeters'];
      result$data['radiusMeters'] = (l$radiusMeters as int?);
    }
    if (data.containsKey('category')) {
      final l$category = data['category'];
      result$data['category'] = l$category == null
          ? null
          : fromJson$Enum$TargetCategory((l$category as String));
    }
    if (data.containsKey('tag')) {
      final l$tag = data['tag'];
      result$data['tag'] = (l$tag as String?);
    }
    if (data.containsKey('sort')) {
      final l$sort = data['sort'];
      result$data['sort'] = l$sort == null
          ? null
          : fromJson$Enum$PostSortOrder((l$sort as String));
    }
    if (data.containsKey('hiddenByViewer')) {
      final l$hiddenByViewer = data['hiddenByViewer'];
      result$data['hiddenByViewer'] = (l$hiddenByViewer as bool?);
    }
    if (data.containsKey('first')) {
      final l$first = data['first'];
      result$data['first'] = (l$first as int?);
    }
    if (data.containsKey('after')) {
      final l$after = data['after'];
      result$data['after'] = (l$after as String?);
    }
    return Variables$Query$Posts._(result$data);
  }

  Map<String, dynamic> _$data;

  String? get catalogId => (_$data['catalogId'] as String?);

  double? get latitude => (_$data['latitude'] as double?);

  double? get longitude => (_$data['longitude'] as double?);

  int? get radiusMeters => (_$data['radiusMeters'] as int?);

  Enum$TargetCategory? get category =>
      (_$data['category'] as Enum$TargetCategory?);

  String? get tag => (_$data['tag'] as String?);

  Enum$PostSortOrder? get sort => (_$data['sort'] as Enum$PostSortOrder?);

  bool? get hiddenByViewer => (_$data['hiddenByViewer'] as bool?);

  int? get first => (_$data['first'] as int?);

  String? get after => (_$data['after'] as String?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    if (_$data.containsKey('catalogId')) {
      final l$catalogId = catalogId;
      result$data['catalogId'] = l$catalogId;
    }
    if (_$data.containsKey('latitude')) {
      final l$latitude = latitude;
      result$data['latitude'] = l$latitude;
    }
    if (_$data.containsKey('longitude')) {
      final l$longitude = longitude;
      result$data['longitude'] = l$longitude;
    }
    if (_$data.containsKey('radiusMeters')) {
      final l$radiusMeters = radiusMeters;
      result$data['radiusMeters'] = l$radiusMeters;
    }
    if (_$data.containsKey('category')) {
      final l$category = category;
      result$data['category'] = l$category == null
          ? null
          : toJson$Enum$TargetCategory(l$category);
    }
    if (_$data.containsKey('tag')) {
      final l$tag = tag;
      result$data['tag'] = l$tag;
    }
    if (_$data.containsKey('sort')) {
      final l$sort = sort;
      result$data['sort'] = l$sort == null
          ? null
          : toJson$Enum$PostSortOrder(l$sort);
    }
    if (_$data.containsKey('hiddenByViewer')) {
      final l$hiddenByViewer = hiddenByViewer;
      result$data['hiddenByViewer'] = l$hiddenByViewer;
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

  CopyWith$Variables$Query$Posts<Variables$Query$Posts> get copyWith =>
      CopyWith$Variables$Query$Posts(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Query$Posts || runtimeType != other.runtimeType) {
      return false;
    }
    final l$catalogId = catalogId;
    final lOther$catalogId = other.catalogId;
    if (_$data.containsKey('catalogId') !=
        other._$data.containsKey('catalogId')) {
      return false;
    }
    if (l$catalogId != lOther$catalogId) {
      return false;
    }
    final l$latitude = latitude;
    final lOther$latitude = other.latitude;
    if (_$data.containsKey('latitude') !=
        other._$data.containsKey('latitude')) {
      return false;
    }
    if (l$latitude != lOther$latitude) {
      return false;
    }
    final l$longitude = longitude;
    final lOther$longitude = other.longitude;
    if (_$data.containsKey('longitude') !=
        other._$data.containsKey('longitude')) {
      return false;
    }
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
    final l$tag = tag;
    final lOther$tag = other.tag;
    if (_$data.containsKey('tag') != other._$data.containsKey('tag')) {
      return false;
    }
    if (l$tag != lOther$tag) {
      return false;
    }
    final l$sort = sort;
    final lOther$sort = other.sort;
    if (_$data.containsKey('sort') != other._$data.containsKey('sort')) {
      return false;
    }
    if (l$sort != lOther$sort) {
      return false;
    }
    final l$hiddenByViewer = hiddenByViewer;
    final lOther$hiddenByViewer = other.hiddenByViewer;
    if (_$data.containsKey('hiddenByViewer') !=
        other._$data.containsKey('hiddenByViewer')) {
      return false;
    }
    if (l$hiddenByViewer != lOther$hiddenByViewer) {
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
    final l$catalogId = catalogId;
    final l$latitude = latitude;
    final l$longitude = longitude;
    final l$radiusMeters = radiusMeters;
    final l$category = category;
    final l$tag = tag;
    final l$sort = sort;
    final l$hiddenByViewer = hiddenByViewer;
    final l$first = first;
    final l$after = after;
    return Object.hashAll([
      _$data.containsKey('catalogId') ? l$catalogId : const {},
      _$data.containsKey('latitude') ? l$latitude : const {},
      _$data.containsKey('longitude') ? l$longitude : const {},
      _$data.containsKey('radiusMeters') ? l$radiusMeters : const {},
      _$data.containsKey('category') ? l$category : const {},
      _$data.containsKey('tag') ? l$tag : const {},
      _$data.containsKey('sort') ? l$sort : const {},
      _$data.containsKey('hiddenByViewer') ? l$hiddenByViewer : const {},
      _$data.containsKey('first') ? l$first : const {},
      _$data.containsKey('after') ? l$after : const {},
    ]);
  }
}

abstract class CopyWith$Variables$Query$Posts<TRes> {
  factory CopyWith$Variables$Query$Posts(
    Variables$Query$Posts instance,
    TRes Function(Variables$Query$Posts) then,
  ) = _CopyWithImpl$Variables$Query$Posts;

  factory CopyWith$Variables$Query$Posts.stub(TRes res) =
      _CopyWithStubImpl$Variables$Query$Posts;

  TRes call({
    String? catalogId,
    double? latitude,
    double? longitude,
    int? radiusMeters,
    Enum$TargetCategory? category,
    String? tag,
    Enum$PostSortOrder? sort,
    bool? hiddenByViewer,
    int? first,
    String? after,
  });
}

class _CopyWithImpl$Variables$Query$Posts<TRes>
    implements CopyWith$Variables$Query$Posts<TRes> {
  _CopyWithImpl$Variables$Query$Posts(this._instance, this._then);

  final Variables$Query$Posts _instance;

  final TRes Function(Variables$Query$Posts) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? catalogId = _undefined,
    Object? latitude = _undefined,
    Object? longitude = _undefined,
    Object? radiusMeters = _undefined,
    Object? category = _undefined,
    Object? tag = _undefined,
    Object? sort = _undefined,
    Object? hiddenByViewer = _undefined,
    Object? first = _undefined,
    Object? after = _undefined,
  }) => _then(
    Variables$Query$Posts._({
      ..._instance._$data,
      if (catalogId != _undefined) 'catalogId': (catalogId as String?),
      if (latitude != _undefined) 'latitude': (latitude as double?),
      if (longitude != _undefined) 'longitude': (longitude as double?),
      if (radiusMeters != _undefined) 'radiusMeters': (radiusMeters as int?),
      if (category != _undefined)
        'category': (category as Enum$TargetCategory?),
      if (tag != _undefined) 'tag': (tag as String?),
      if (sort != _undefined) 'sort': (sort as Enum$PostSortOrder?),
      if (hiddenByViewer != _undefined)
        'hiddenByViewer': (hiddenByViewer as bool?),
      if (first != _undefined) 'first': (first as int?),
      if (after != _undefined) 'after': (after as String?),
    }),
  );
}

class _CopyWithStubImpl$Variables$Query$Posts<TRes>
    implements CopyWith$Variables$Query$Posts<TRes> {
  _CopyWithStubImpl$Variables$Query$Posts(this._res);

  TRes _res;

  call({
    String? catalogId,
    double? latitude,
    double? longitude,
    int? radiusMeters,
    Enum$TargetCategory? category,
    String? tag,
    Enum$PostSortOrder? sort,
    bool? hiddenByViewer,
    int? first,
    String? after,
  }) => _res;
}

class Query$Posts {
  Query$Posts({required this.posts});

  factory Query$Posts.fromJson(Map<String, dynamic> json) {
    final l$posts = json['posts'];
    return Query$Posts(
      posts: Query$Posts$posts.fromJson((l$posts as Map<String, dynamic>)),
    );
  }

  final Query$Posts$posts posts;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$posts = posts;
    _resultData['posts'] = l$posts.toJson();
    return _resultData;
  }

  @override
  int get hashCode {
    final l$posts = posts;
    return Object.hashAll([l$posts]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$Posts || runtimeType != other.runtimeType) {
      return false;
    }
    final l$posts = posts;
    final lOther$posts = other.posts;
    if (l$posts != lOther$posts) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Query$Posts on Query$Posts {
  CopyWith$Query$Posts<Query$Posts> get copyWith =>
      CopyWith$Query$Posts(this, (i) => i);
}

abstract class CopyWith$Query$Posts<TRes> {
  factory CopyWith$Query$Posts(
    Query$Posts instance,
    TRes Function(Query$Posts) then,
  ) = _CopyWithImpl$Query$Posts;

  factory CopyWith$Query$Posts.stub(TRes res) = _CopyWithStubImpl$Query$Posts;

  TRes call({Query$Posts$posts? posts});
  CopyWith$Query$Posts$posts<TRes> get posts;
}

class _CopyWithImpl$Query$Posts<TRes> implements CopyWith$Query$Posts<TRes> {
  _CopyWithImpl$Query$Posts(this._instance, this._then);

  final Query$Posts _instance;

  final TRes Function(Query$Posts) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? posts = _undefined}) => _then(
    Query$Posts(
      posts: posts == _undefined || posts == null
          ? _instance.posts
          : (posts as Query$Posts$posts),
    ),
  );

  CopyWith$Query$Posts$posts<TRes> get posts {
    final local$posts = _instance.posts;
    return CopyWith$Query$Posts$posts(local$posts, (e) => call(posts: e));
  }
}

class _CopyWithStubImpl$Query$Posts<TRes>
    implements CopyWith$Query$Posts<TRes> {
  _CopyWithStubImpl$Query$Posts(this._res);

  TRes _res;

  call({Query$Posts$posts? posts}) => _res;

  CopyWith$Query$Posts$posts<TRes> get posts =>
      CopyWith$Query$Posts$posts.stub(_res);
}

const documentNodeQueryPosts = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'Posts'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'catalogId')),
          type: NamedTypeNode(name: NameNode(value: 'ID'), isNonNull: false),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'latitude')),
          type: NamedTypeNode(name: NameNode(value: 'Float'), isNonNull: false),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'longitude')),
          type: NamedTypeNode(name: NameNode(value: 'Float'), isNonNull: false),
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
            name: NameNode(value: 'TargetCategory'),
            isNonNull: false,
          ),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'tag')),
          type: NamedTypeNode(
            name: NameNode(value: 'String'),
            isNonNull: false,
          ),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'sort')),
          type: NamedTypeNode(
            name: NameNode(value: 'PostSortOrder'),
            isNonNull: false,
          ),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'hiddenByViewer')),
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
            name: NameNode(value: 'posts'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'catalogId'),
                value: VariableNode(name: NameNode(value: 'catalogId')),
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
                name: NameNode(value: 'category'),
                value: VariableNode(name: NameNode(value: 'category')),
              ),
              ArgumentNode(
                name: NameNode(value: 'tag'),
                value: VariableNode(name: NameNode(value: 'tag')),
              ),
              ArgumentNode(
                name: NameNode(value: 'sort'),
                value: VariableNode(name: NameNode(value: 'sort')),
              ),
              ArgumentNode(
                name: NameNode(value: 'hiddenByViewer'),
                value: VariableNode(name: NameNode(value: 'hiddenByViewer')),
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

class Query$Posts$posts {
  Query$Posts$posts({required this.edges, required this.pageInfo});

  factory Query$Posts$posts.fromJson(Map<String, dynamic> json) {
    final l$edges = json['edges'];
    final l$pageInfo = json['pageInfo'];
    return Query$Posts$posts(
      edges: (l$edges as List<dynamic>)
          .map(
            (e) =>
                Query$Posts$posts$edges.fromJson((e as Map<String, dynamic>)),
          )
          .toList(),
      pageInfo: Query$Posts$posts$pageInfo.fromJson(
        (l$pageInfo as Map<String, dynamic>),
      ),
    );
  }

  final List<Query$Posts$posts$edges> edges;

  final Query$Posts$posts$pageInfo pageInfo;

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
    if (other is! Query$Posts$posts || runtimeType != other.runtimeType) {
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

extension UtilityExtension$Query$Posts$posts on Query$Posts$posts {
  CopyWith$Query$Posts$posts<Query$Posts$posts> get copyWith =>
      CopyWith$Query$Posts$posts(this, (i) => i);
}

abstract class CopyWith$Query$Posts$posts<TRes> {
  factory CopyWith$Query$Posts$posts(
    Query$Posts$posts instance,
    TRes Function(Query$Posts$posts) then,
  ) = _CopyWithImpl$Query$Posts$posts;

  factory CopyWith$Query$Posts$posts.stub(TRes res) =
      _CopyWithStubImpl$Query$Posts$posts;

  TRes call({
    List<Query$Posts$posts$edges>? edges,
    Query$Posts$posts$pageInfo? pageInfo,
  });
  TRes edges(
    Iterable<Query$Posts$posts$edges> Function(
      Iterable<CopyWith$Query$Posts$posts$edges<Query$Posts$posts$edges>>,
    )
    _fn,
  );
  CopyWith$Query$Posts$posts$pageInfo<TRes> get pageInfo;
}

class _CopyWithImpl$Query$Posts$posts<TRes>
    implements CopyWith$Query$Posts$posts<TRes> {
  _CopyWithImpl$Query$Posts$posts(this._instance, this._then);

  final Query$Posts$posts _instance;

  final TRes Function(Query$Posts$posts) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? edges = _undefined, Object? pageInfo = _undefined}) =>
      _then(
        Query$Posts$posts(
          edges: edges == _undefined || edges == null
              ? _instance.edges
              : (edges as List<Query$Posts$posts$edges>),
          pageInfo: pageInfo == _undefined || pageInfo == null
              ? _instance.pageInfo
              : (pageInfo as Query$Posts$posts$pageInfo),
        ),
      );

  TRes edges(
    Iterable<Query$Posts$posts$edges> Function(
      Iterable<CopyWith$Query$Posts$posts$edges<Query$Posts$posts$edges>>,
    )
    _fn,
  ) => call(
    edges: _fn(
      _instance.edges.map((e) => CopyWith$Query$Posts$posts$edges(e, (i) => i)),
    ).toList(),
  );

  CopyWith$Query$Posts$posts$pageInfo<TRes> get pageInfo {
    final local$pageInfo = _instance.pageInfo;
    return CopyWith$Query$Posts$posts$pageInfo(
      local$pageInfo,
      (e) => call(pageInfo: e),
    );
  }
}

class _CopyWithStubImpl$Query$Posts$posts<TRes>
    implements CopyWith$Query$Posts$posts<TRes> {
  _CopyWithStubImpl$Query$Posts$posts(this._res);

  TRes _res;

  call({
    List<Query$Posts$posts$edges>? edges,
    Query$Posts$posts$pageInfo? pageInfo,
  }) => _res;

  edges(_fn) => _res;

  CopyWith$Query$Posts$posts$pageInfo<TRes> get pageInfo =>
      CopyWith$Query$Posts$posts$pageInfo.stub(_res);
}

class Query$Posts$posts$edges {
  Query$Posts$posts$edges({required this.cursor, required this.node});

  factory Query$Posts$posts$edges.fromJson(Map<String, dynamic> json) {
    final l$cursor = json['cursor'];
    final l$node = json['node'];
    return Query$Posts$posts$edges(
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
    if (other is! Query$Posts$posts$edges || runtimeType != other.runtimeType) {
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

extension UtilityExtension$Query$Posts$posts$edges on Query$Posts$posts$edges {
  CopyWith$Query$Posts$posts$edges<Query$Posts$posts$edges> get copyWith =>
      CopyWith$Query$Posts$posts$edges(this, (i) => i);
}

abstract class CopyWith$Query$Posts$posts$edges<TRes> {
  factory CopyWith$Query$Posts$posts$edges(
    Query$Posts$posts$edges instance,
    TRes Function(Query$Posts$posts$edges) then,
  ) = _CopyWithImpl$Query$Posts$posts$edges;

  factory CopyWith$Query$Posts$posts$edges.stub(TRes res) =
      _CopyWithStubImpl$Query$Posts$posts$edges;

  TRes call({String? cursor, Fragment$PostCardFields? node});
  CopyWith$Fragment$PostCardFields<TRes> get node;
}

class _CopyWithImpl$Query$Posts$posts$edges<TRes>
    implements CopyWith$Query$Posts$posts$edges<TRes> {
  _CopyWithImpl$Query$Posts$posts$edges(this._instance, this._then);

  final Query$Posts$posts$edges _instance;

  final TRes Function(Query$Posts$posts$edges) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? cursor = _undefined, Object? node = _undefined}) => _then(
    Query$Posts$posts$edges(
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

class _CopyWithStubImpl$Query$Posts$posts$edges<TRes>
    implements CopyWith$Query$Posts$posts$edges<TRes> {
  _CopyWithStubImpl$Query$Posts$posts$edges(this._res);

  TRes _res;

  call({String? cursor, Fragment$PostCardFields? node}) => _res;

  CopyWith$Fragment$PostCardFields<TRes> get node =>
      CopyWith$Fragment$PostCardFields.stub(_res);
}

class Query$Posts$posts$pageInfo {
  Query$Posts$posts$pageInfo({required this.hasNextPage, this.endCursor});

  factory Query$Posts$posts$pageInfo.fromJson(Map<String, dynamic> json) {
    final l$hasNextPage = json['hasNextPage'];
    final l$endCursor = json['endCursor'];
    return Query$Posts$posts$pageInfo(
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
    if (other is! Query$Posts$posts$pageInfo ||
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

extension UtilityExtension$Query$Posts$posts$pageInfo
    on Query$Posts$posts$pageInfo {
  CopyWith$Query$Posts$posts$pageInfo<Query$Posts$posts$pageInfo>
  get copyWith => CopyWith$Query$Posts$posts$pageInfo(this, (i) => i);
}

abstract class CopyWith$Query$Posts$posts$pageInfo<TRes> {
  factory CopyWith$Query$Posts$posts$pageInfo(
    Query$Posts$posts$pageInfo instance,
    TRes Function(Query$Posts$posts$pageInfo) then,
  ) = _CopyWithImpl$Query$Posts$posts$pageInfo;

  factory CopyWith$Query$Posts$posts$pageInfo.stub(TRes res) =
      _CopyWithStubImpl$Query$Posts$posts$pageInfo;

  TRes call({bool? hasNextPage, String? endCursor});
}

class _CopyWithImpl$Query$Posts$posts$pageInfo<TRes>
    implements CopyWith$Query$Posts$posts$pageInfo<TRes> {
  _CopyWithImpl$Query$Posts$posts$pageInfo(this._instance, this._then);

  final Query$Posts$posts$pageInfo _instance;

  final TRes Function(Query$Posts$posts$pageInfo) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? hasNextPage = _undefined,
    Object? endCursor = _undefined,
  }) => _then(
    Query$Posts$posts$pageInfo(
      hasNextPage: hasNextPage == _undefined || hasNextPage == null
          ? _instance.hasNextPage
          : (hasNextPage as bool),
      endCursor: endCursor == _undefined
          ? _instance.endCursor
          : (endCursor as String?),
    ),
  );
}

class _CopyWithStubImpl$Query$Posts$posts$pageInfo<TRes>
    implements CopyWith$Query$Posts$posts$pageInfo<TRes> {
  _CopyWithStubImpl$Query$Posts$posts$pageInfo(this._res);

  TRes _res;

  call({bool? hasNextPage, String? endCursor}) => _res;
}

class Variables$Query$PostDetail {
  factory Variables$Query$PostDetail({required String id}) =>
      Variables$Query$PostDetail._({r'id': id});

  Variables$Query$PostDetail._(this._$data);

  factory Variables$Query$PostDetail.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$id = data['id'];
    result$data['id'] = (l$id as String);
    return Variables$Query$PostDetail._(result$data);
  }

  Map<String, dynamic> _$data;

  String get id => (_$data['id'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$id = id;
    result$data['id'] = l$id;
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
    return true;
  }

  @override
  int get hashCode {
    final l$id = id;
    return Object.hashAll([l$id]);
  }
}

abstract class CopyWith$Variables$Query$PostDetail<TRes> {
  factory CopyWith$Variables$Query$PostDetail(
    Variables$Query$PostDetail instance,
    TRes Function(Variables$Query$PostDetail) then,
  ) = _CopyWithImpl$Variables$Query$PostDetail;

  factory CopyWith$Variables$Query$PostDetail.stub(TRes res) =
      _CopyWithStubImpl$Variables$Query$PostDetail;

  TRes call({String? id});
}

class _CopyWithImpl$Variables$Query$PostDetail<TRes>
    implements CopyWith$Variables$Query$PostDetail<TRes> {
  _CopyWithImpl$Variables$Query$PostDetail(this._instance, this._then);

  final Variables$Query$PostDetail _instance;

  final TRes Function(Variables$Query$PostDetail) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? id = _undefined}) => _then(
    Variables$Query$PostDetail._({
      ..._instance._$data,
      if (id != _undefined && id != null) 'id': (id as String),
    }),
  );
}

class _CopyWithStubImpl$Variables$Query$PostDetail<TRes>
    implements CopyWith$Variables$Query$PostDetail<TRes> {
  _CopyWithStubImpl$Variables$Query$PostDetail(this._res);

  TRes _res;

  call({String? id}) => _res;
}

class Query$PostDetail {
  Query$PostDetail({this.post});

  factory Query$PostDetail.fromJson(Map<String, dynamic> json) {
    final l$post = json['post'];
    return Query$PostDetail(
      post: l$post == null
          ? null
          : Fragment$PostCardFields.fromJson((l$post as Map<String, dynamic>)),
    );
  }

  final Fragment$PostCardFields? post;

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

  TRes call({Fragment$PostCardFields? post});
  CopyWith$Fragment$PostCardFields<TRes> get post;
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
          : (post as Fragment$PostCardFields?),
    ),
  );

  CopyWith$Fragment$PostCardFields<TRes> get post {
    final local$post = _instance.post;
    return local$post == null
        ? CopyWith$Fragment$PostCardFields.stub(_then(_instance))
        : CopyWith$Fragment$PostCardFields(local$post, (e) => call(post: e));
  }
}

class _CopyWithStubImpl$Query$PostDetail<TRes>
    implements CopyWith$Query$PostDetail<TRes> {
  _CopyWithStubImpl$Query$PostDetail(this._res);

  TRes _res;

  call({Fragment$PostCardFields? post}) => _res;

  CopyWith$Fragment$PostCardFields<TRes> get post =>
      CopyWith$Fragment$PostCardFields.stub(_res);
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
              ],
            ),
          ),
        ],
      ),
    ),
    fragmentDefinitionPostCardFields,
  ],
);

class Variables$Query$Comments {
  factory Variables$Query$Comments({
    required String postId,
    int? first,
    String? after,
  }) => Variables$Query$Comments._({
    r'postId': postId,
    if (first != null) r'first': first,
    if (after != null) r'after': after,
  });

  Variables$Query$Comments._(this._$data);

  factory Variables$Query$Comments.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$postId = data['postId'];
    result$data['postId'] = (l$postId as String);
    if (data.containsKey('first')) {
      final l$first = data['first'];
      result$data['first'] = (l$first as int?);
    }
    if (data.containsKey('after')) {
      final l$after = data['after'];
      result$data['after'] = (l$after as String?);
    }
    return Variables$Query$Comments._(result$data);
  }

  Map<String, dynamic> _$data;

  String get postId => (_$data['postId'] as String);

  int? get first => (_$data['first'] as int?);

  String? get after => (_$data['after'] as String?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$postId = postId;
    result$data['postId'] = l$postId;
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

  CopyWith$Variables$Query$Comments<Variables$Query$Comments> get copyWith =>
      CopyWith$Variables$Query$Comments(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Query$Comments ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$postId = postId;
    final lOther$postId = other.postId;
    if (l$postId != lOther$postId) {
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
    final l$postId = postId;
    final l$first = first;
    final l$after = after;
    return Object.hashAll([
      l$postId,
      _$data.containsKey('first') ? l$first : const {},
      _$data.containsKey('after') ? l$after : const {},
    ]);
  }
}

abstract class CopyWith$Variables$Query$Comments<TRes> {
  factory CopyWith$Variables$Query$Comments(
    Variables$Query$Comments instance,
    TRes Function(Variables$Query$Comments) then,
  ) = _CopyWithImpl$Variables$Query$Comments;

  factory CopyWith$Variables$Query$Comments.stub(TRes res) =
      _CopyWithStubImpl$Variables$Query$Comments;

  TRes call({String? postId, int? first, String? after});
}

class _CopyWithImpl$Variables$Query$Comments<TRes>
    implements CopyWith$Variables$Query$Comments<TRes> {
  _CopyWithImpl$Variables$Query$Comments(this._instance, this._then);

  final Variables$Query$Comments _instance;

  final TRes Function(Variables$Query$Comments) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? postId = _undefined,
    Object? first = _undefined,
    Object? after = _undefined,
  }) => _then(
    Variables$Query$Comments._({
      ..._instance._$data,
      if (postId != _undefined && postId != null) 'postId': (postId as String),
      if (first != _undefined) 'first': (first as int?),
      if (after != _undefined) 'after': (after as String?),
    }),
  );
}

class _CopyWithStubImpl$Variables$Query$Comments<TRes>
    implements CopyWith$Variables$Query$Comments<TRes> {
  _CopyWithStubImpl$Variables$Query$Comments(this._res);

  TRes _res;

  call({String? postId, int? first, String? after}) => _res;
}

class Query$Comments {
  Query$Comments({required this.comments});

  factory Query$Comments.fromJson(Map<String, dynamic> json) {
    final l$comments = json['comments'];
    return Query$Comments(
      comments: Query$Comments$comments.fromJson(
        (l$comments as Map<String, dynamic>),
      ),
    );
  }

  final Query$Comments$comments comments;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$comments = comments;
    _resultData['comments'] = l$comments.toJson();
    return _resultData;
  }

  @override
  int get hashCode {
    final l$comments = comments;
    return Object.hashAll([l$comments]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$Comments || runtimeType != other.runtimeType) {
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

extension UtilityExtension$Query$Comments on Query$Comments {
  CopyWith$Query$Comments<Query$Comments> get copyWith =>
      CopyWith$Query$Comments(this, (i) => i);
}

abstract class CopyWith$Query$Comments<TRes> {
  factory CopyWith$Query$Comments(
    Query$Comments instance,
    TRes Function(Query$Comments) then,
  ) = _CopyWithImpl$Query$Comments;

  factory CopyWith$Query$Comments.stub(TRes res) =
      _CopyWithStubImpl$Query$Comments;

  TRes call({Query$Comments$comments? comments});
  CopyWith$Query$Comments$comments<TRes> get comments;
}

class _CopyWithImpl$Query$Comments<TRes>
    implements CopyWith$Query$Comments<TRes> {
  _CopyWithImpl$Query$Comments(this._instance, this._then);

  final Query$Comments _instance;

  final TRes Function(Query$Comments) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? comments = _undefined}) => _then(
    Query$Comments(
      comments: comments == _undefined || comments == null
          ? _instance.comments
          : (comments as Query$Comments$comments),
    ),
  );

  CopyWith$Query$Comments$comments<TRes> get comments {
    final local$comments = _instance.comments;
    return CopyWith$Query$Comments$comments(
      local$comments,
      (e) => call(comments: e),
    );
  }
}

class _CopyWithStubImpl$Query$Comments<TRes>
    implements CopyWith$Query$Comments<TRes> {
  _CopyWithStubImpl$Query$Comments(this._res);

  TRes _res;

  call({Query$Comments$comments? comments}) => _res;

  CopyWith$Query$Comments$comments<TRes> get comments =>
      CopyWith$Query$Comments$comments.stub(_res);
}

const documentNodeQueryComments = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'Comments'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'postId')),
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
            name: NameNode(value: 'comments'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'postId'),
                value: VariableNode(name: NameNode(value: 'postId')),
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
                              name: NameNode(value: 'parentCommentId'),
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
                                    name: NameNode(value: 'profileImageUrl'),
                                    alias: null,
                                    arguments: [],
                                    directives: [],
                                    selectionSet: null,
                                  ),
                                ],
                              ),
                            ),
                            FieldNode(
                              name: NameNode(value: 'replies'),
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
                                    name: NameNode(value: 'parentCommentId'),
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

class Query$Comments$comments {
  Query$Comments$comments({required this.edges, required this.pageInfo});

  factory Query$Comments$comments.fromJson(Map<String, dynamic> json) {
    final l$edges = json['edges'];
    final l$pageInfo = json['pageInfo'];
    return Query$Comments$comments(
      edges: (l$edges as List<dynamic>)
          .map(
            (e) => Query$Comments$comments$edges.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      pageInfo: Query$Comments$comments$pageInfo.fromJson(
        (l$pageInfo as Map<String, dynamic>),
      ),
    );
  }

  final List<Query$Comments$comments$edges> edges;

  final Query$Comments$comments$pageInfo pageInfo;

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
    if (other is! Query$Comments$comments || runtimeType != other.runtimeType) {
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

extension UtilityExtension$Query$Comments$comments on Query$Comments$comments {
  CopyWith$Query$Comments$comments<Query$Comments$comments> get copyWith =>
      CopyWith$Query$Comments$comments(this, (i) => i);
}

abstract class CopyWith$Query$Comments$comments<TRes> {
  factory CopyWith$Query$Comments$comments(
    Query$Comments$comments instance,
    TRes Function(Query$Comments$comments) then,
  ) = _CopyWithImpl$Query$Comments$comments;

  factory CopyWith$Query$Comments$comments.stub(TRes res) =
      _CopyWithStubImpl$Query$Comments$comments;

  TRes call({
    List<Query$Comments$comments$edges>? edges,
    Query$Comments$comments$pageInfo? pageInfo,
  });
  TRes edges(
    Iterable<Query$Comments$comments$edges> Function(
      Iterable<
        CopyWith$Query$Comments$comments$edges<Query$Comments$comments$edges>
      >,
    )
    _fn,
  );
  CopyWith$Query$Comments$comments$pageInfo<TRes> get pageInfo;
}

class _CopyWithImpl$Query$Comments$comments<TRes>
    implements CopyWith$Query$Comments$comments<TRes> {
  _CopyWithImpl$Query$Comments$comments(this._instance, this._then);

  final Query$Comments$comments _instance;

  final TRes Function(Query$Comments$comments) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? edges = _undefined, Object? pageInfo = _undefined}) =>
      _then(
        Query$Comments$comments(
          edges: edges == _undefined || edges == null
              ? _instance.edges
              : (edges as List<Query$Comments$comments$edges>),
          pageInfo: pageInfo == _undefined || pageInfo == null
              ? _instance.pageInfo
              : (pageInfo as Query$Comments$comments$pageInfo),
        ),
      );

  TRes edges(
    Iterable<Query$Comments$comments$edges> Function(
      Iterable<
        CopyWith$Query$Comments$comments$edges<Query$Comments$comments$edges>
      >,
    )
    _fn,
  ) => call(
    edges: _fn(
      _instance.edges.map(
        (e) => CopyWith$Query$Comments$comments$edges(e, (i) => i),
      ),
    ).toList(),
  );

  CopyWith$Query$Comments$comments$pageInfo<TRes> get pageInfo {
    final local$pageInfo = _instance.pageInfo;
    return CopyWith$Query$Comments$comments$pageInfo(
      local$pageInfo,
      (e) => call(pageInfo: e),
    );
  }
}

class _CopyWithStubImpl$Query$Comments$comments<TRes>
    implements CopyWith$Query$Comments$comments<TRes> {
  _CopyWithStubImpl$Query$Comments$comments(this._res);

  TRes _res;

  call({
    List<Query$Comments$comments$edges>? edges,
    Query$Comments$comments$pageInfo? pageInfo,
  }) => _res;

  edges(_fn) => _res;

  CopyWith$Query$Comments$comments$pageInfo<TRes> get pageInfo =>
      CopyWith$Query$Comments$comments$pageInfo.stub(_res);
}

class Query$Comments$comments$edges {
  Query$Comments$comments$edges({required this.cursor, required this.node});

  factory Query$Comments$comments$edges.fromJson(Map<String, dynamic> json) {
    final l$cursor = json['cursor'];
    final l$node = json['node'];
    return Query$Comments$comments$edges(
      cursor: (l$cursor as String),
      node: Query$Comments$comments$edges$node.fromJson(
        (l$node as Map<String, dynamic>),
      ),
    );
  }

  final String cursor;

  final Query$Comments$comments$edges$node node;

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
    if (other is! Query$Comments$comments$edges ||
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

extension UtilityExtension$Query$Comments$comments$edges
    on Query$Comments$comments$edges {
  CopyWith$Query$Comments$comments$edges<Query$Comments$comments$edges>
  get copyWith => CopyWith$Query$Comments$comments$edges(this, (i) => i);
}

abstract class CopyWith$Query$Comments$comments$edges<TRes> {
  factory CopyWith$Query$Comments$comments$edges(
    Query$Comments$comments$edges instance,
    TRes Function(Query$Comments$comments$edges) then,
  ) = _CopyWithImpl$Query$Comments$comments$edges;

  factory CopyWith$Query$Comments$comments$edges.stub(TRes res) =
      _CopyWithStubImpl$Query$Comments$comments$edges;

  TRes call({String? cursor, Query$Comments$comments$edges$node? node});
  CopyWith$Query$Comments$comments$edges$node<TRes> get node;
}

class _CopyWithImpl$Query$Comments$comments$edges<TRes>
    implements CopyWith$Query$Comments$comments$edges<TRes> {
  _CopyWithImpl$Query$Comments$comments$edges(this._instance, this._then);

  final Query$Comments$comments$edges _instance;

  final TRes Function(Query$Comments$comments$edges) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? cursor = _undefined, Object? node = _undefined}) => _then(
    Query$Comments$comments$edges(
      cursor: cursor == _undefined || cursor == null
          ? _instance.cursor
          : (cursor as String),
      node: node == _undefined || node == null
          ? _instance.node
          : (node as Query$Comments$comments$edges$node),
    ),
  );

  CopyWith$Query$Comments$comments$edges$node<TRes> get node {
    final local$node = _instance.node;
    return CopyWith$Query$Comments$comments$edges$node(
      local$node,
      (e) => call(node: e),
    );
  }
}

class _CopyWithStubImpl$Query$Comments$comments$edges<TRes>
    implements CopyWith$Query$Comments$comments$edges<TRes> {
  _CopyWithStubImpl$Query$Comments$comments$edges(this._res);

  TRes _res;

  call({String? cursor, Query$Comments$comments$edges$node? node}) => _res;

  CopyWith$Query$Comments$comments$edges$node<TRes> get node =>
      CopyWith$Query$Comments$comments$edges$node.stub(_res);
}

class Query$Comments$comments$edges$node {
  Query$Comments$comments$edges$node({
    required this.id,
    required this.body,
    required this.createdAt,
    required this.ownedByViewer,
    required this.hidden,
    this.parentCommentId,
    required this.author,
    required this.replies,
  });

  factory Query$Comments$comments$edges$node.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$body = json['body'];
    final l$createdAt = json['createdAt'];
    final l$ownedByViewer = json['ownedByViewer'];
    final l$hidden = json['hidden'];
    final l$parentCommentId = json['parentCommentId'];
    final l$author = json['author'];
    final l$replies = json['replies'];
    return Query$Comments$comments$edges$node(
      id: (l$id as String),
      body: (l$body as String),
      createdAt: (l$createdAt as String),
      ownedByViewer: (l$ownedByViewer as bool),
      hidden: (l$hidden as bool),
      parentCommentId: (l$parentCommentId as String?),
      author: Query$Comments$comments$edges$node$author.fromJson(
        (l$author as Map<String, dynamic>),
      ),
      replies: (l$replies as List<dynamic>)
          .map(
            (e) => Query$Comments$comments$edges$node$replies.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
    );
  }

  final String id;

  final String body;

  final String createdAt;

  final bool ownedByViewer;

  final bool hidden;

  final String? parentCommentId;

  final Query$Comments$comments$edges$node$author author;

  final List<Query$Comments$comments$edges$node$replies> replies;

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
    final l$parentCommentId = parentCommentId;
    _resultData['parentCommentId'] = l$parentCommentId;
    final l$author = author;
    _resultData['author'] = l$author.toJson();
    final l$replies = replies;
    _resultData['replies'] = l$replies.map((e) => e.toJson()).toList();
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$body = body;
    final l$createdAt = createdAt;
    final l$ownedByViewer = ownedByViewer;
    final l$hidden = hidden;
    final l$parentCommentId = parentCommentId;
    final l$author = author;
    final l$replies = replies;
    return Object.hashAll([
      l$id,
      l$body,
      l$createdAt,
      l$ownedByViewer,
      l$hidden,
      l$parentCommentId,
      l$author,
      Object.hashAll(l$replies.map((v) => v)),
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$Comments$comments$edges$node ||
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
    final l$parentCommentId = parentCommentId;
    final lOther$parentCommentId = other.parentCommentId;
    if (l$parentCommentId != lOther$parentCommentId) {
      return false;
    }
    final l$author = author;
    final lOther$author = other.author;
    if (l$author != lOther$author) {
      return false;
    }
    final l$replies = replies;
    final lOther$replies = other.replies;
    if (l$replies.length != lOther$replies.length) {
      return false;
    }
    for (int i = 0; i < l$replies.length; i++) {
      final l$replies$entry = l$replies[i];
      final lOther$replies$entry = lOther$replies[i];
      if (l$replies$entry != lOther$replies$entry) {
        return false;
      }
    }
    return true;
  }
}

extension UtilityExtension$Query$Comments$comments$edges$node
    on Query$Comments$comments$edges$node {
  CopyWith$Query$Comments$comments$edges$node<
    Query$Comments$comments$edges$node
  >
  get copyWith => CopyWith$Query$Comments$comments$edges$node(this, (i) => i);
}

abstract class CopyWith$Query$Comments$comments$edges$node<TRes> {
  factory CopyWith$Query$Comments$comments$edges$node(
    Query$Comments$comments$edges$node instance,
    TRes Function(Query$Comments$comments$edges$node) then,
  ) = _CopyWithImpl$Query$Comments$comments$edges$node;

  factory CopyWith$Query$Comments$comments$edges$node.stub(TRes res) =
      _CopyWithStubImpl$Query$Comments$comments$edges$node;

  TRes call({
    String? id,
    String? body,
    String? createdAt,
    bool? ownedByViewer,
    bool? hidden,
    String? parentCommentId,
    Query$Comments$comments$edges$node$author? author,
    List<Query$Comments$comments$edges$node$replies>? replies,
  });
  CopyWith$Query$Comments$comments$edges$node$author<TRes> get author;
  TRes replies(
    Iterable<Query$Comments$comments$edges$node$replies> Function(
      Iterable<
        CopyWith$Query$Comments$comments$edges$node$replies<
          Query$Comments$comments$edges$node$replies
        >
      >,
    )
    _fn,
  );
}

class _CopyWithImpl$Query$Comments$comments$edges$node<TRes>
    implements CopyWith$Query$Comments$comments$edges$node<TRes> {
  _CopyWithImpl$Query$Comments$comments$edges$node(this._instance, this._then);

  final Query$Comments$comments$edges$node _instance;

  final TRes Function(Query$Comments$comments$edges$node) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? body = _undefined,
    Object? createdAt = _undefined,
    Object? ownedByViewer = _undefined,
    Object? hidden = _undefined,
    Object? parentCommentId = _undefined,
    Object? author = _undefined,
    Object? replies = _undefined,
  }) => _then(
    Query$Comments$comments$edges$node(
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
      parentCommentId: parentCommentId == _undefined
          ? _instance.parentCommentId
          : (parentCommentId as String?),
      author: author == _undefined || author == null
          ? _instance.author
          : (author as Query$Comments$comments$edges$node$author),
      replies: replies == _undefined || replies == null
          ? _instance.replies
          : (replies as List<Query$Comments$comments$edges$node$replies>),
    ),
  );

  CopyWith$Query$Comments$comments$edges$node$author<TRes> get author {
    final local$author = _instance.author;
    return CopyWith$Query$Comments$comments$edges$node$author(
      local$author,
      (e) => call(author: e),
    );
  }

  TRes replies(
    Iterable<Query$Comments$comments$edges$node$replies> Function(
      Iterable<
        CopyWith$Query$Comments$comments$edges$node$replies<
          Query$Comments$comments$edges$node$replies
        >
      >,
    )
    _fn,
  ) => call(
    replies: _fn(
      _instance.replies.map(
        (e) => CopyWith$Query$Comments$comments$edges$node$replies(e, (i) => i),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl$Query$Comments$comments$edges$node<TRes>
    implements CopyWith$Query$Comments$comments$edges$node<TRes> {
  _CopyWithStubImpl$Query$Comments$comments$edges$node(this._res);

  TRes _res;

  call({
    String? id,
    String? body,
    String? createdAt,
    bool? ownedByViewer,
    bool? hidden,
    String? parentCommentId,
    Query$Comments$comments$edges$node$author? author,
    List<Query$Comments$comments$edges$node$replies>? replies,
  }) => _res;

  CopyWith$Query$Comments$comments$edges$node$author<TRes> get author =>
      CopyWith$Query$Comments$comments$edges$node$author.stub(_res);

  replies(_fn) => _res;
}

class Query$Comments$comments$edges$node$author {
  Query$Comments$comments$edges$node$author({
    required this.id,
    required this.nickname,
    this.profileImageUrl,
  });

  factory Query$Comments$comments$edges$node$author.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$nickname = json['nickname'];
    final l$profileImageUrl = json['profileImageUrl'];
    return Query$Comments$comments$edges$node$author(
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
    if (other is! Query$Comments$comments$edges$node$author ||
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

extension UtilityExtension$Query$Comments$comments$edges$node$author
    on Query$Comments$comments$edges$node$author {
  CopyWith$Query$Comments$comments$edges$node$author<
    Query$Comments$comments$edges$node$author
  >
  get copyWith =>
      CopyWith$Query$Comments$comments$edges$node$author(this, (i) => i);
}

abstract class CopyWith$Query$Comments$comments$edges$node$author<TRes> {
  factory CopyWith$Query$Comments$comments$edges$node$author(
    Query$Comments$comments$edges$node$author instance,
    TRes Function(Query$Comments$comments$edges$node$author) then,
  ) = _CopyWithImpl$Query$Comments$comments$edges$node$author;

  factory CopyWith$Query$Comments$comments$edges$node$author.stub(TRes res) =
      _CopyWithStubImpl$Query$Comments$comments$edges$node$author;

  TRes call({String? id, String? nickname, String? profileImageUrl});
}

class _CopyWithImpl$Query$Comments$comments$edges$node$author<TRes>
    implements CopyWith$Query$Comments$comments$edges$node$author<TRes> {
  _CopyWithImpl$Query$Comments$comments$edges$node$author(
    this._instance,
    this._then,
  );

  final Query$Comments$comments$edges$node$author _instance;

  final TRes Function(Query$Comments$comments$edges$node$author) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? nickname = _undefined,
    Object? profileImageUrl = _undefined,
  }) => _then(
    Query$Comments$comments$edges$node$author(
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

class _CopyWithStubImpl$Query$Comments$comments$edges$node$author<TRes>
    implements CopyWith$Query$Comments$comments$edges$node$author<TRes> {
  _CopyWithStubImpl$Query$Comments$comments$edges$node$author(this._res);

  TRes _res;

  call({String? id, String? nickname, String? profileImageUrl}) => _res;
}

class Query$Comments$comments$edges$node$replies {
  Query$Comments$comments$edges$node$replies({
    required this.id,
    required this.body,
    required this.createdAt,
    required this.ownedByViewer,
    required this.hidden,
    this.parentCommentId,
    required this.author,
  });

  factory Query$Comments$comments$edges$node$replies.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$body = json['body'];
    final l$createdAt = json['createdAt'];
    final l$ownedByViewer = json['ownedByViewer'];
    final l$hidden = json['hidden'];
    final l$parentCommentId = json['parentCommentId'];
    final l$author = json['author'];
    return Query$Comments$comments$edges$node$replies(
      id: (l$id as String),
      body: (l$body as String),
      createdAt: (l$createdAt as String),
      ownedByViewer: (l$ownedByViewer as bool),
      hidden: (l$hidden as bool),
      parentCommentId: (l$parentCommentId as String?),
      author: Query$Comments$comments$edges$node$replies$author.fromJson(
        (l$author as Map<String, dynamic>),
      ),
    );
  }

  final String id;

  final String body;

  final String createdAt;

  final bool ownedByViewer;

  final bool hidden;

  final String? parentCommentId;

  final Query$Comments$comments$edges$node$replies$author author;

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
    final l$parentCommentId = parentCommentId;
    _resultData['parentCommentId'] = l$parentCommentId;
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
    final l$parentCommentId = parentCommentId;
    final l$author = author;
    return Object.hashAll([
      l$id,
      l$body,
      l$createdAt,
      l$ownedByViewer,
      l$hidden,
      l$parentCommentId,
      l$author,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$Comments$comments$edges$node$replies ||
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
    final l$parentCommentId = parentCommentId;
    final lOther$parentCommentId = other.parentCommentId;
    if (l$parentCommentId != lOther$parentCommentId) {
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

extension UtilityExtension$Query$Comments$comments$edges$node$replies
    on Query$Comments$comments$edges$node$replies {
  CopyWith$Query$Comments$comments$edges$node$replies<
    Query$Comments$comments$edges$node$replies
  >
  get copyWith =>
      CopyWith$Query$Comments$comments$edges$node$replies(this, (i) => i);
}

abstract class CopyWith$Query$Comments$comments$edges$node$replies<TRes> {
  factory CopyWith$Query$Comments$comments$edges$node$replies(
    Query$Comments$comments$edges$node$replies instance,
    TRes Function(Query$Comments$comments$edges$node$replies) then,
  ) = _CopyWithImpl$Query$Comments$comments$edges$node$replies;

  factory CopyWith$Query$Comments$comments$edges$node$replies.stub(TRes res) =
      _CopyWithStubImpl$Query$Comments$comments$edges$node$replies;

  TRes call({
    String? id,
    String? body,
    String? createdAt,
    bool? ownedByViewer,
    bool? hidden,
    String? parentCommentId,
    Query$Comments$comments$edges$node$replies$author? author,
  });
  CopyWith$Query$Comments$comments$edges$node$replies$author<TRes> get author;
}

class _CopyWithImpl$Query$Comments$comments$edges$node$replies<TRes>
    implements CopyWith$Query$Comments$comments$edges$node$replies<TRes> {
  _CopyWithImpl$Query$Comments$comments$edges$node$replies(
    this._instance,
    this._then,
  );

  final Query$Comments$comments$edges$node$replies _instance;

  final TRes Function(Query$Comments$comments$edges$node$replies) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? body = _undefined,
    Object? createdAt = _undefined,
    Object? ownedByViewer = _undefined,
    Object? hidden = _undefined,
    Object? parentCommentId = _undefined,
    Object? author = _undefined,
  }) => _then(
    Query$Comments$comments$edges$node$replies(
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
      parentCommentId: parentCommentId == _undefined
          ? _instance.parentCommentId
          : (parentCommentId as String?),
      author: author == _undefined || author == null
          ? _instance.author
          : (author as Query$Comments$comments$edges$node$replies$author),
    ),
  );

  CopyWith$Query$Comments$comments$edges$node$replies$author<TRes> get author {
    final local$author = _instance.author;
    return CopyWith$Query$Comments$comments$edges$node$replies$author(
      local$author,
      (e) => call(author: e),
    );
  }
}

class _CopyWithStubImpl$Query$Comments$comments$edges$node$replies<TRes>
    implements CopyWith$Query$Comments$comments$edges$node$replies<TRes> {
  _CopyWithStubImpl$Query$Comments$comments$edges$node$replies(this._res);

  TRes _res;

  call({
    String? id,
    String? body,
    String? createdAt,
    bool? ownedByViewer,
    bool? hidden,
    String? parentCommentId,
    Query$Comments$comments$edges$node$replies$author? author,
  }) => _res;

  CopyWith$Query$Comments$comments$edges$node$replies$author<TRes> get author =>
      CopyWith$Query$Comments$comments$edges$node$replies$author.stub(_res);
}

class Query$Comments$comments$edges$node$replies$author {
  Query$Comments$comments$edges$node$replies$author({
    required this.id,
    required this.nickname,
    this.profileImageUrl,
  });

  factory Query$Comments$comments$edges$node$replies$author.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$nickname = json['nickname'];
    final l$profileImageUrl = json['profileImageUrl'];
    return Query$Comments$comments$edges$node$replies$author(
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
    if (other is! Query$Comments$comments$edges$node$replies$author ||
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

extension UtilityExtension$Query$Comments$comments$edges$node$replies$author
    on Query$Comments$comments$edges$node$replies$author {
  CopyWith$Query$Comments$comments$edges$node$replies$author<
    Query$Comments$comments$edges$node$replies$author
  >
  get copyWith => CopyWith$Query$Comments$comments$edges$node$replies$author(
    this,
    (i) => i,
  );
}

abstract class CopyWith$Query$Comments$comments$edges$node$replies$author<
  TRes
> {
  factory CopyWith$Query$Comments$comments$edges$node$replies$author(
    Query$Comments$comments$edges$node$replies$author instance,
    TRes Function(Query$Comments$comments$edges$node$replies$author) then,
  ) = _CopyWithImpl$Query$Comments$comments$edges$node$replies$author;

  factory CopyWith$Query$Comments$comments$edges$node$replies$author.stub(
    TRes res,
  ) = _CopyWithStubImpl$Query$Comments$comments$edges$node$replies$author;

  TRes call({String? id, String? nickname, String? profileImageUrl});
}

class _CopyWithImpl$Query$Comments$comments$edges$node$replies$author<TRes>
    implements
        CopyWith$Query$Comments$comments$edges$node$replies$author<TRes> {
  _CopyWithImpl$Query$Comments$comments$edges$node$replies$author(
    this._instance,
    this._then,
  );

  final Query$Comments$comments$edges$node$replies$author _instance;

  final TRes Function(Query$Comments$comments$edges$node$replies$author) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? nickname = _undefined,
    Object? profileImageUrl = _undefined,
  }) => _then(
    Query$Comments$comments$edges$node$replies$author(
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

class _CopyWithStubImpl$Query$Comments$comments$edges$node$replies$author<TRes>
    implements
        CopyWith$Query$Comments$comments$edges$node$replies$author<TRes> {
  _CopyWithStubImpl$Query$Comments$comments$edges$node$replies$author(
    this._res,
  );

  TRes _res;

  call({String? id, String? nickname, String? profileImageUrl}) => _res;
}

class Query$Comments$comments$pageInfo {
  Query$Comments$comments$pageInfo({required this.hasNextPage, this.endCursor});

  factory Query$Comments$comments$pageInfo.fromJson(Map<String, dynamic> json) {
    final l$hasNextPage = json['hasNextPage'];
    final l$endCursor = json['endCursor'];
    return Query$Comments$comments$pageInfo(
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
    if (other is! Query$Comments$comments$pageInfo ||
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

extension UtilityExtension$Query$Comments$comments$pageInfo
    on Query$Comments$comments$pageInfo {
  CopyWith$Query$Comments$comments$pageInfo<Query$Comments$comments$pageInfo>
  get copyWith => CopyWith$Query$Comments$comments$pageInfo(this, (i) => i);
}

abstract class CopyWith$Query$Comments$comments$pageInfo<TRes> {
  factory CopyWith$Query$Comments$comments$pageInfo(
    Query$Comments$comments$pageInfo instance,
    TRes Function(Query$Comments$comments$pageInfo) then,
  ) = _CopyWithImpl$Query$Comments$comments$pageInfo;

  factory CopyWith$Query$Comments$comments$pageInfo.stub(TRes res) =
      _CopyWithStubImpl$Query$Comments$comments$pageInfo;

  TRes call({bool? hasNextPage, String? endCursor});
}

class _CopyWithImpl$Query$Comments$comments$pageInfo<TRes>
    implements CopyWith$Query$Comments$comments$pageInfo<TRes> {
  _CopyWithImpl$Query$Comments$comments$pageInfo(this._instance, this._then);

  final Query$Comments$comments$pageInfo _instance;

  final TRes Function(Query$Comments$comments$pageInfo) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? hasNextPage = _undefined,
    Object? endCursor = _undefined,
  }) => _then(
    Query$Comments$comments$pageInfo(
      hasNextPage: hasNextPage == _undefined || hasNextPage == null
          ? _instance.hasNextPage
          : (hasNextPage as bool),
      endCursor: endCursor == _undefined
          ? _instance.endCursor
          : (endCursor as String?),
    ),
  );
}

class _CopyWithStubImpl$Query$Comments$comments$pageInfo<TRes>
    implements CopyWith$Query$Comments$comments$pageInfo<TRes> {
  _CopyWithStubImpl$Query$Comments$comments$pageInfo(this._res);

  TRes _res;

  call({bool? hasNextPage, String? endCursor}) => _res;
}

class Query$CommunityChips {
  Query$CommunityChips({required this.communityChips});

  factory Query$CommunityChips.fromJson(Map<String, dynamic> json) {
    final l$communityChips = json['communityChips'];
    return Query$CommunityChips(
      communityChips: (l$communityChips as List<dynamic>)
          .map((e) => fromJson$Enum$TargetCategory((e as String)))
          .toList(),
    );
  }

  final List<Enum$TargetCategory> communityChips;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$communityChips = communityChips;
    _resultData['communityChips'] = l$communityChips
        .map((e) => toJson$Enum$TargetCategory(e))
        .toList();
    return _resultData;
  }

  @override
  int get hashCode {
    final l$communityChips = communityChips;
    return Object.hashAll([Object.hashAll(l$communityChips.map((v) => v))]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$CommunityChips || runtimeType != other.runtimeType) {
      return false;
    }
    final l$communityChips = communityChips;
    final lOther$communityChips = other.communityChips;
    if (l$communityChips.length != lOther$communityChips.length) {
      return false;
    }
    for (int i = 0; i < l$communityChips.length; i++) {
      final l$communityChips$entry = l$communityChips[i];
      final lOther$communityChips$entry = lOther$communityChips[i];
      if (l$communityChips$entry != lOther$communityChips$entry) {
        return false;
      }
    }
    return true;
  }
}

extension UtilityExtension$Query$CommunityChips on Query$CommunityChips {
  CopyWith$Query$CommunityChips<Query$CommunityChips> get copyWith =>
      CopyWith$Query$CommunityChips(this, (i) => i);
}

abstract class CopyWith$Query$CommunityChips<TRes> {
  factory CopyWith$Query$CommunityChips(
    Query$CommunityChips instance,
    TRes Function(Query$CommunityChips) then,
  ) = _CopyWithImpl$Query$CommunityChips;

  factory CopyWith$Query$CommunityChips.stub(TRes res) =
      _CopyWithStubImpl$Query$CommunityChips;

  TRes call({List<Enum$TargetCategory>? communityChips});
}

class _CopyWithImpl$Query$CommunityChips<TRes>
    implements CopyWith$Query$CommunityChips<TRes> {
  _CopyWithImpl$Query$CommunityChips(this._instance, this._then);

  final Query$CommunityChips _instance;

  final TRes Function(Query$CommunityChips) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? communityChips = _undefined}) => _then(
    Query$CommunityChips(
      communityChips: communityChips == _undefined || communityChips == null
          ? _instance.communityChips
          : (communityChips as List<Enum$TargetCategory>),
    ),
  );
}

class _CopyWithStubImpl$Query$CommunityChips<TRes>
    implements CopyWith$Query$CommunityChips<TRes> {
  _CopyWithStubImpl$Query$CommunityChips(this._res);

  TRes _res;

  call({List<Enum$TargetCategory>? communityChips}) => _res;
}

const documentNodeQueryCommunityChips = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'CommunityChips'),
      variableDefinitions: [],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'communityChips'),
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

class Variables$Query$BlockedUsers {
  factory Variables$Query$BlockedUsers({int? first, String? after}) =>
      Variables$Query$BlockedUsers._({
        if (first != null) r'first': first,
        if (after != null) r'after': after,
      });

  Variables$Query$BlockedUsers._(this._$data);

  factory Variables$Query$BlockedUsers.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    if (data.containsKey('first')) {
      final l$first = data['first'];
      result$data['first'] = (l$first as int?);
    }
    if (data.containsKey('after')) {
      final l$after = data['after'];
      result$data['after'] = (l$after as String?);
    }
    return Variables$Query$BlockedUsers._(result$data);
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

  CopyWith$Variables$Query$BlockedUsers<Variables$Query$BlockedUsers>
  get copyWith => CopyWith$Variables$Query$BlockedUsers(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Query$BlockedUsers ||
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

abstract class CopyWith$Variables$Query$BlockedUsers<TRes> {
  factory CopyWith$Variables$Query$BlockedUsers(
    Variables$Query$BlockedUsers instance,
    TRes Function(Variables$Query$BlockedUsers) then,
  ) = _CopyWithImpl$Variables$Query$BlockedUsers;

  factory CopyWith$Variables$Query$BlockedUsers.stub(TRes res) =
      _CopyWithStubImpl$Variables$Query$BlockedUsers;

  TRes call({int? first, String? after});
}

class _CopyWithImpl$Variables$Query$BlockedUsers<TRes>
    implements CopyWith$Variables$Query$BlockedUsers<TRes> {
  _CopyWithImpl$Variables$Query$BlockedUsers(this._instance, this._then);

  final Variables$Query$BlockedUsers _instance;

  final TRes Function(Variables$Query$BlockedUsers) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? first = _undefined, Object? after = _undefined}) => _then(
    Variables$Query$BlockedUsers._({
      ..._instance._$data,
      if (first != _undefined) 'first': (first as int?),
      if (after != _undefined) 'after': (after as String?),
    }),
  );
}

class _CopyWithStubImpl$Variables$Query$BlockedUsers<TRes>
    implements CopyWith$Variables$Query$BlockedUsers<TRes> {
  _CopyWithStubImpl$Variables$Query$BlockedUsers(this._res);

  TRes _res;

  call({int? first, String? after}) => _res;
}

class Query$BlockedUsers {
  Query$BlockedUsers({required this.blockedUsers});

  factory Query$BlockedUsers.fromJson(Map<String, dynamic> json) {
    final l$blockedUsers = json['blockedUsers'];
    return Query$BlockedUsers(
      blockedUsers: Query$BlockedUsers$blockedUsers.fromJson(
        (l$blockedUsers as Map<String, dynamic>),
      ),
    );
  }

  final Query$BlockedUsers$blockedUsers blockedUsers;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$blockedUsers = blockedUsers;
    _resultData['blockedUsers'] = l$blockedUsers.toJson();
    return _resultData;
  }

  @override
  int get hashCode {
    final l$blockedUsers = blockedUsers;
    return Object.hashAll([l$blockedUsers]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$BlockedUsers || runtimeType != other.runtimeType) {
      return false;
    }
    final l$blockedUsers = blockedUsers;
    final lOther$blockedUsers = other.blockedUsers;
    if (l$blockedUsers != lOther$blockedUsers) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Query$BlockedUsers on Query$BlockedUsers {
  CopyWith$Query$BlockedUsers<Query$BlockedUsers> get copyWith =>
      CopyWith$Query$BlockedUsers(this, (i) => i);
}

abstract class CopyWith$Query$BlockedUsers<TRes> {
  factory CopyWith$Query$BlockedUsers(
    Query$BlockedUsers instance,
    TRes Function(Query$BlockedUsers) then,
  ) = _CopyWithImpl$Query$BlockedUsers;

  factory CopyWith$Query$BlockedUsers.stub(TRes res) =
      _CopyWithStubImpl$Query$BlockedUsers;

  TRes call({Query$BlockedUsers$blockedUsers? blockedUsers});
  CopyWith$Query$BlockedUsers$blockedUsers<TRes> get blockedUsers;
}

class _CopyWithImpl$Query$BlockedUsers<TRes>
    implements CopyWith$Query$BlockedUsers<TRes> {
  _CopyWithImpl$Query$BlockedUsers(this._instance, this._then);

  final Query$BlockedUsers _instance;

  final TRes Function(Query$BlockedUsers) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? blockedUsers = _undefined}) => _then(
    Query$BlockedUsers(
      blockedUsers: blockedUsers == _undefined || blockedUsers == null
          ? _instance.blockedUsers
          : (blockedUsers as Query$BlockedUsers$blockedUsers),
    ),
  );

  CopyWith$Query$BlockedUsers$blockedUsers<TRes> get blockedUsers {
    final local$blockedUsers = _instance.blockedUsers;
    return CopyWith$Query$BlockedUsers$blockedUsers(
      local$blockedUsers,
      (e) => call(blockedUsers: e),
    );
  }
}

class _CopyWithStubImpl$Query$BlockedUsers<TRes>
    implements CopyWith$Query$BlockedUsers<TRes> {
  _CopyWithStubImpl$Query$BlockedUsers(this._res);

  TRes _res;

  call({Query$BlockedUsers$blockedUsers? blockedUsers}) => _res;

  CopyWith$Query$BlockedUsers$blockedUsers<TRes> get blockedUsers =>
      CopyWith$Query$BlockedUsers$blockedUsers.stub(_res);
}

const documentNodeQueryBlockedUsers = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'BlockedUsers'),
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
            name: NameNode(value: 'blockedUsers'),
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
                        name: NameNode(value: 'blockedAt'),
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

class Query$BlockedUsers$blockedUsers {
  Query$BlockedUsers$blockedUsers({
    required this.edges,
    required this.pageInfo,
  });

  factory Query$BlockedUsers$blockedUsers.fromJson(Map<String, dynamic> json) {
    final l$edges = json['edges'];
    final l$pageInfo = json['pageInfo'];
    return Query$BlockedUsers$blockedUsers(
      edges: (l$edges as List<dynamic>)
          .map(
            (e) => Query$BlockedUsers$blockedUsers$edges.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      pageInfo: Query$BlockedUsers$blockedUsers$pageInfo.fromJson(
        (l$pageInfo as Map<String, dynamic>),
      ),
    );
  }

  final List<Query$BlockedUsers$blockedUsers$edges> edges;

  final Query$BlockedUsers$blockedUsers$pageInfo pageInfo;

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
    if (other is! Query$BlockedUsers$blockedUsers ||
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

extension UtilityExtension$Query$BlockedUsers$blockedUsers
    on Query$BlockedUsers$blockedUsers {
  CopyWith$Query$BlockedUsers$blockedUsers<Query$BlockedUsers$blockedUsers>
  get copyWith => CopyWith$Query$BlockedUsers$blockedUsers(this, (i) => i);
}

abstract class CopyWith$Query$BlockedUsers$blockedUsers<TRes> {
  factory CopyWith$Query$BlockedUsers$blockedUsers(
    Query$BlockedUsers$blockedUsers instance,
    TRes Function(Query$BlockedUsers$blockedUsers) then,
  ) = _CopyWithImpl$Query$BlockedUsers$blockedUsers;

  factory CopyWith$Query$BlockedUsers$blockedUsers.stub(TRes res) =
      _CopyWithStubImpl$Query$BlockedUsers$blockedUsers;

  TRes call({
    List<Query$BlockedUsers$blockedUsers$edges>? edges,
    Query$BlockedUsers$blockedUsers$pageInfo? pageInfo,
  });
  TRes edges(
    Iterable<Query$BlockedUsers$blockedUsers$edges> Function(
      Iterable<
        CopyWith$Query$BlockedUsers$blockedUsers$edges<
          Query$BlockedUsers$blockedUsers$edges
        >
      >,
    )
    _fn,
  );
  CopyWith$Query$BlockedUsers$blockedUsers$pageInfo<TRes> get pageInfo;
}

class _CopyWithImpl$Query$BlockedUsers$blockedUsers<TRes>
    implements CopyWith$Query$BlockedUsers$blockedUsers<TRes> {
  _CopyWithImpl$Query$BlockedUsers$blockedUsers(this._instance, this._then);

  final Query$BlockedUsers$blockedUsers _instance;

  final TRes Function(Query$BlockedUsers$blockedUsers) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? edges = _undefined, Object? pageInfo = _undefined}) =>
      _then(
        Query$BlockedUsers$blockedUsers(
          edges: edges == _undefined || edges == null
              ? _instance.edges
              : (edges as List<Query$BlockedUsers$blockedUsers$edges>),
          pageInfo: pageInfo == _undefined || pageInfo == null
              ? _instance.pageInfo
              : (pageInfo as Query$BlockedUsers$blockedUsers$pageInfo),
        ),
      );

  TRes edges(
    Iterable<Query$BlockedUsers$blockedUsers$edges> Function(
      Iterable<
        CopyWith$Query$BlockedUsers$blockedUsers$edges<
          Query$BlockedUsers$blockedUsers$edges
        >
      >,
    )
    _fn,
  ) => call(
    edges: _fn(
      _instance.edges.map(
        (e) => CopyWith$Query$BlockedUsers$blockedUsers$edges(e, (i) => i),
      ),
    ).toList(),
  );

  CopyWith$Query$BlockedUsers$blockedUsers$pageInfo<TRes> get pageInfo {
    final local$pageInfo = _instance.pageInfo;
    return CopyWith$Query$BlockedUsers$blockedUsers$pageInfo(
      local$pageInfo,
      (e) => call(pageInfo: e),
    );
  }
}

class _CopyWithStubImpl$Query$BlockedUsers$blockedUsers<TRes>
    implements CopyWith$Query$BlockedUsers$blockedUsers<TRes> {
  _CopyWithStubImpl$Query$BlockedUsers$blockedUsers(this._res);

  TRes _res;

  call({
    List<Query$BlockedUsers$blockedUsers$edges>? edges,
    Query$BlockedUsers$blockedUsers$pageInfo? pageInfo,
  }) => _res;

  edges(_fn) => _res;

  CopyWith$Query$BlockedUsers$blockedUsers$pageInfo<TRes> get pageInfo =>
      CopyWith$Query$BlockedUsers$blockedUsers$pageInfo.stub(_res);
}

class Query$BlockedUsers$blockedUsers$edges {
  Query$BlockedUsers$blockedUsers$edges({
    required this.cursor,
    required this.blockedAt,
    required this.node,
  });

  factory Query$BlockedUsers$blockedUsers$edges.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$cursor = json['cursor'];
    final l$blockedAt = json['blockedAt'];
    final l$node = json['node'];
    return Query$BlockedUsers$blockedUsers$edges(
      cursor: (l$cursor as String),
      blockedAt: (l$blockedAt as String),
      node: Query$BlockedUsers$blockedUsers$edges$node.fromJson(
        (l$node as Map<String, dynamic>),
      ),
    );
  }

  final String cursor;

  final String blockedAt;

  final Query$BlockedUsers$blockedUsers$edges$node node;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$cursor = cursor;
    _resultData['cursor'] = l$cursor;
    final l$blockedAt = blockedAt;
    _resultData['blockedAt'] = l$blockedAt;
    final l$node = node;
    _resultData['node'] = l$node.toJson();
    return _resultData;
  }

  @override
  int get hashCode {
    final l$cursor = cursor;
    final l$blockedAt = blockedAt;
    final l$node = node;
    return Object.hashAll([l$cursor, l$blockedAt, l$node]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$BlockedUsers$blockedUsers$edges ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$cursor = cursor;
    final lOther$cursor = other.cursor;
    if (l$cursor != lOther$cursor) {
      return false;
    }
    final l$blockedAt = blockedAt;
    final lOther$blockedAt = other.blockedAt;
    if (l$blockedAt != lOther$blockedAt) {
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

extension UtilityExtension$Query$BlockedUsers$blockedUsers$edges
    on Query$BlockedUsers$blockedUsers$edges {
  CopyWith$Query$BlockedUsers$blockedUsers$edges<
    Query$BlockedUsers$blockedUsers$edges
  >
  get copyWith =>
      CopyWith$Query$BlockedUsers$blockedUsers$edges(this, (i) => i);
}

abstract class CopyWith$Query$BlockedUsers$blockedUsers$edges<TRes> {
  factory CopyWith$Query$BlockedUsers$blockedUsers$edges(
    Query$BlockedUsers$blockedUsers$edges instance,
    TRes Function(Query$BlockedUsers$blockedUsers$edges) then,
  ) = _CopyWithImpl$Query$BlockedUsers$blockedUsers$edges;

  factory CopyWith$Query$BlockedUsers$blockedUsers$edges.stub(TRes res) =
      _CopyWithStubImpl$Query$BlockedUsers$blockedUsers$edges;

  TRes call({
    String? cursor,
    String? blockedAt,
    Query$BlockedUsers$blockedUsers$edges$node? node,
  });
  CopyWith$Query$BlockedUsers$blockedUsers$edges$node<TRes> get node;
}

class _CopyWithImpl$Query$BlockedUsers$blockedUsers$edges<TRes>
    implements CopyWith$Query$BlockedUsers$blockedUsers$edges<TRes> {
  _CopyWithImpl$Query$BlockedUsers$blockedUsers$edges(
    this._instance,
    this._then,
  );

  final Query$BlockedUsers$blockedUsers$edges _instance;

  final TRes Function(Query$BlockedUsers$blockedUsers$edges) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? cursor = _undefined,
    Object? blockedAt = _undefined,
    Object? node = _undefined,
  }) => _then(
    Query$BlockedUsers$blockedUsers$edges(
      cursor: cursor == _undefined || cursor == null
          ? _instance.cursor
          : (cursor as String),
      blockedAt: blockedAt == _undefined || blockedAt == null
          ? _instance.blockedAt
          : (blockedAt as String),
      node: node == _undefined || node == null
          ? _instance.node
          : (node as Query$BlockedUsers$blockedUsers$edges$node),
    ),
  );

  CopyWith$Query$BlockedUsers$blockedUsers$edges$node<TRes> get node {
    final local$node = _instance.node;
    return CopyWith$Query$BlockedUsers$blockedUsers$edges$node(
      local$node,
      (e) => call(node: e),
    );
  }
}

class _CopyWithStubImpl$Query$BlockedUsers$blockedUsers$edges<TRes>
    implements CopyWith$Query$BlockedUsers$blockedUsers$edges<TRes> {
  _CopyWithStubImpl$Query$BlockedUsers$blockedUsers$edges(this._res);

  TRes _res;

  call({
    String? cursor,
    String? blockedAt,
    Query$BlockedUsers$blockedUsers$edges$node? node,
  }) => _res;

  CopyWith$Query$BlockedUsers$blockedUsers$edges$node<TRes> get node =>
      CopyWith$Query$BlockedUsers$blockedUsers$edges$node.stub(_res);
}

class Query$BlockedUsers$blockedUsers$edges$node {
  Query$BlockedUsers$blockedUsers$edges$node({
    required this.id,
    required this.nickname,
    this.profileImageUrl,
  });

  factory Query$BlockedUsers$blockedUsers$edges$node.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$nickname = json['nickname'];
    final l$profileImageUrl = json['profileImageUrl'];
    return Query$BlockedUsers$blockedUsers$edges$node(
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
    if (other is! Query$BlockedUsers$blockedUsers$edges$node ||
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

extension UtilityExtension$Query$BlockedUsers$blockedUsers$edges$node
    on Query$BlockedUsers$blockedUsers$edges$node {
  CopyWith$Query$BlockedUsers$blockedUsers$edges$node<
    Query$BlockedUsers$blockedUsers$edges$node
  >
  get copyWith =>
      CopyWith$Query$BlockedUsers$blockedUsers$edges$node(this, (i) => i);
}

abstract class CopyWith$Query$BlockedUsers$blockedUsers$edges$node<TRes> {
  factory CopyWith$Query$BlockedUsers$blockedUsers$edges$node(
    Query$BlockedUsers$blockedUsers$edges$node instance,
    TRes Function(Query$BlockedUsers$blockedUsers$edges$node) then,
  ) = _CopyWithImpl$Query$BlockedUsers$blockedUsers$edges$node;

  factory CopyWith$Query$BlockedUsers$blockedUsers$edges$node.stub(TRes res) =
      _CopyWithStubImpl$Query$BlockedUsers$blockedUsers$edges$node;

  TRes call({String? id, String? nickname, String? profileImageUrl});
}

class _CopyWithImpl$Query$BlockedUsers$blockedUsers$edges$node<TRes>
    implements CopyWith$Query$BlockedUsers$blockedUsers$edges$node<TRes> {
  _CopyWithImpl$Query$BlockedUsers$blockedUsers$edges$node(
    this._instance,
    this._then,
  );

  final Query$BlockedUsers$blockedUsers$edges$node _instance;

  final TRes Function(Query$BlockedUsers$blockedUsers$edges$node) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? nickname = _undefined,
    Object? profileImageUrl = _undefined,
  }) => _then(
    Query$BlockedUsers$blockedUsers$edges$node(
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

class _CopyWithStubImpl$Query$BlockedUsers$blockedUsers$edges$node<TRes>
    implements CopyWith$Query$BlockedUsers$blockedUsers$edges$node<TRes> {
  _CopyWithStubImpl$Query$BlockedUsers$blockedUsers$edges$node(this._res);

  TRes _res;

  call({String? id, String? nickname, String? profileImageUrl}) => _res;
}

class Query$BlockedUsers$blockedUsers$pageInfo {
  Query$BlockedUsers$blockedUsers$pageInfo({
    required this.hasNextPage,
    this.endCursor,
  });

  factory Query$BlockedUsers$blockedUsers$pageInfo.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$hasNextPage = json['hasNextPage'];
    final l$endCursor = json['endCursor'];
    return Query$BlockedUsers$blockedUsers$pageInfo(
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
    if (other is! Query$BlockedUsers$blockedUsers$pageInfo ||
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

extension UtilityExtension$Query$BlockedUsers$blockedUsers$pageInfo
    on Query$BlockedUsers$blockedUsers$pageInfo {
  CopyWith$Query$BlockedUsers$blockedUsers$pageInfo<
    Query$BlockedUsers$blockedUsers$pageInfo
  >
  get copyWith =>
      CopyWith$Query$BlockedUsers$blockedUsers$pageInfo(this, (i) => i);
}

abstract class CopyWith$Query$BlockedUsers$blockedUsers$pageInfo<TRes> {
  factory CopyWith$Query$BlockedUsers$blockedUsers$pageInfo(
    Query$BlockedUsers$blockedUsers$pageInfo instance,
    TRes Function(Query$BlockedUsers$blockedUsers$pageInfo) then,
  ) = _CopyWithImpl$Query$BlockedUsers$blockedUsers$pageInfo;

  factory CopyWith$Query$BlockedUsers$blockedUsers$pageInfo.stub(TRes res) =
      _CopyWithStubImpl$Query$BlockedUsers$blockedUsers$pageInfo;

  TRes call({bool? hasNextPage, String? endCursor});
}

class _CopyWithImpl$Query$BlockedUsers$blockedUsers$pageInfo<TRes>
    implements CopyWith$Query$BlockedUsers$blockedUsers$pageInfo<TRes> {
  _CopyWithImpl$Query$BlockedUsers$blockedUsers$pageInfo(
    this._instance,
    this._then,
  );

  final Query$BlockedUsers$blockedUsers$pageInfo _instance;

  final TRes Function(Query$BlockedUsers$blockedUsers$pageInfo) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? hasNextPage = _undefined,
    Object? endCursor = _undefined,
  }) => _then(
    Query$BlockedUsers$blockedUsers$pageInfo(
      hasNextPage: hasNextPage == _undefined || hasNextPage == null
          ? _instance.hasNextPage
          : (hasNextPage as bool),
      endCursor: endCursor == _undefined
          ? _instance.endCursor
          : (endCursor as String?),
    ),
  );
}

class _CopyWithStubImpl$Query$BlockedUsers$blockedUsers$pageInfo<TRes>
    implements CopyWith$Query$BlockedUsers$blockedUsers$pageInfo<TRes> {
  _CopyWithStubImpl$Query$BlockedUsers$blockedUsers$pageInfo(this._res);

  TRes _res;

  call({bool? hasNextPage, String? endCursor}) => _res;
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
    required Enum$TargetCategory category,
    String? catalogId,
    required List<String> tags,
    required String title,
    required String body,
    required List<String> photoKeys,
  }) => Variables$Mutation$CreatePost._({
    r'category': category,
    if (catalogId != null) r'catalogId': catalogId,
    r'tags': tags,
    r'title': title,
    r'body': body,
    r'photoKeys': photoKeys,
  });

  Variables$Mutation$CreatePost._(this._$data);

  factory Variables$Mutation$CreatePost.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$category = data['category'];
    result$data['category'] = fromJson$Enum$TargetCategory(
      (l$category as String),
    );
    if (data.containsKey('catalogId')) {
      final l$catalogId = data['catalogId'];
      result$data['catalogId'] = (l$catalogId as String?);
    }
    final l$tags = data['tags'];
    result$data['tags'] = (l$tags as List<dynamic>)
        .map((e) => (e as String))
        .toList();
    final l$title = data['title'];
    result$data['title'] = (l$title as String);
    final l$body = data['body'];
    result$data['body'] = (l$body as String);
    final l$photoKeys = data['photoKeys'];
    result$data['photoKeys'] = (l$photoKeys as List<dynamic>)
        .map((e) => (e as String))
        .toList();
    return Variables$Mutation$CreatePost._(result$data);
  }

  Map<String, dynamic> _$data;

  Enum$TargetCategory get category =>
      (_$data['category'] as Enum$TargetCategory);

  String? get catalogId => (_$data['catalogId'] as String?);

  List<String> get tags => (_$data['tags'] as List<String>);

  String get title => (_$data['title'] as String);

  String get body => (_$data['body'] as String);

  List<String> get photoKeys => (_$data['photoKeys'] as List<String>);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$category = category;
    result$data['category'] = toJson$Enum$TargetCategory(l$category);
    if (_$data.containsKey('catalogId')) {
      final l$catalogId = catalogId;
      result$data['catalogId'] = l$catalogId;
    }
    final l$tags = tags;
    result$data['tags'] = l$tags.map((e) => e).toList();
    final l$title = title;
    result$data['title'] = l$title;
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
    final l$category = category;
    final lOther$category = other.category;
    if (l$category != lOther$category) {
      return false;
    }
    final l$catalogId = catalogId;
    final lOther$catalogId = other.catalogId;
    if (_$data.containsKey('catalogId') !=
        other._$data.containsKey('catalogId')) {
      return false;
    }
    if (l$catalogId != lOther$catalogId) {
      return false;
    }
    final l$tags = tags;
    final lOther$tags = other.tags;
    if (l$tags.length != lOther$tags.length) {
      return false;
    }
    for (int i = 0; i < l$tags.length; i++) {
      final l$tags$entry = l$tags[i];
      final lOther$tags$entry = lOther$tags[i];
      if (l$tags$entry != lOther$tags$entry) {
        return false;
      }
    }
    final l$title = title;
    final lOther$title = other.title;
    if (l$title != lOther$title) {
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
    final l$category = category;
    final l$catalogId = catalogId;
    final l$tags = tags;
    final l$title = title;
    final l$body = body;
    final l$photoKeys = photoKeys;
    return Object.hashAll([
      l$category,
      _$data.containsKey('catalogId') ? l$catalogId : const {},
      Object.hashAll(l$tags.map((v) => v)),
      l$title,
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
    Enum$TargetCategory? category,
    String? catalogId,
    List<String>? tags,
    String? title,
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
    Object? category = _undefined,
    Object? catalogId = _undefined,
    Object? tags = _undefined,
    Object? title = _undefined,
    Object? body = _undefined,
    Object? photoKeys = _undefined,
  }) => _then(
    Variables$Mutation$CreatePost._({
      ..._instance._$data,
      if (category != _undefined && category != null)
        'category': (category as Enum$TargetCategory),
      if (catalogId != _undefined) 'catalogId': (catalogId as String?),
      if (tags != _undefined && tags != null) 'tags': (tags as List<String>),
      if (title != _undefined && title != null) 'title': (title as String),
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
    Enum$TargetCategory? category,
    String? catalogId,
    List<String>? tags,
    String? title,
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
          variable: VariableNode(name: NameNode(value: 'category')),
          type: NamedTypeNode(
            name: NameNode(value: 'TargetCategory'),
            isNonNull: true,
          ),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'catalogId')),
          type: NamedTypeNode(name: NameNode(value: 'ID'), isNonNull: false),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'tags')),
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
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'title')),
          type: NamedTypeNode(name: NameNode(value: 'String'), isNonNull: true),
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
                      name: NameNode(value: 'category'),
                      value: VariableNode(name: NameNode(value: 'category')),
                    ),
                    ObjectFieldNode(
                      name: NameNode(value: 'catalogId'),
                      value: VariableNode(name: NameNode(value: 'catalogId')),
                    ),
                    ObjectFieldNode(
                      name: NameNode(value: 'tags'),
                      value: VariableNode(name: NameNode(value: 'tags')),
                    ),
                    ObjectFieldNode(
                      name: NameNode(value: 'title'),
                      value: VariableNode(name: NameNode(value: 'title')),
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

class Variables$Mutation$EditPost {
  factory Variables$Mutation$EditPost({
    required String postId,
    required String title,
    required String body,
    List<String>? photoKeys,
    Enum$TargetCategory? category,
    bool? changeSpot,
    String? catalogId,
    List<String>? tags,
  }) => Variables$Mutation$EditPost._({
    r'postId': postId,
    r'title': title,
    r'body': body,
    if (photoKeys != null) r'photoKeys': photoKeys,
    if (category != null) r'category': category,
    if (changeSpot != null) r'changeSpot': changeSpot,
    if (catalogId != null) r'catalogId': catalogId,
    if (tags != null) r'tags': tags,
  });

  Variables$Mutation$EditPost._(this._$data);

  factory Variables$Mutation$EditPost.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$postId = data['postId'];
    result$data['postId'] = (l$postId as String);
    final l$title = data['title'];
    result$data['title'] = (l$title as String);
    final l$body = data['body'];
    result$data['body'] = (l$body as String);
    if (data.containsKey('photoKeys')) {
      final l$photoKeys = data['photoKeys'];
      result$data['photoKeys'] = (l$photoKeys as List<dynamic>?)
          ?.map((e) => (e as String))
          .toList();
    }
    if (data.containsKey('category')) {
      final l$category = data['category'];
      result$data['category'] = l$category == null
          ? null
          : fromJson$Enum$TargetCategory((l$category as String));
    }
    if (data.containsKey('changeSpot')) {
      final l$changeSpot = data['changeSpot'];
      result$data['changeSpot'] = (l$changeSpot as bool?);
    }
    if (data.containsKey('catalogId')) {
      final l$catalogId = data['catalogId'];
      result$data['catalogId'] = (l$catalogId as String?);
    }
    if (data.containsKey('tags')) {
      final l$tags = data['tags'];
      result$data['tags'] = (l$tags as List<dynamic>?)
          ?.map((e) => (e as String))
          .toList();
    }
    return Variables$Mutation$EditPost._(result$data);
  }

  Map<String, dynamic> _$data;

  String get postId => (_$data['postId'] as String);

  String get title => (_$data['title'] as String);

  String get body => (_$data['body'] as String);

  List<String>? get photoKeys => (_$data['photoKeys'] as List<String>?);

  Enum$TargetCategory? get category =>
      (_$data['category'] as Enum$TargetCategory?);

  bool? get changeSpot => (_$data['changeSpot'] as bool?);

  String? get catalogId => (_$data['catalogId'] as String?);

  List<String>? get tags => (_$data['tags'] as List<String>?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$postId = postId;
    result$data['postId'] = l$postId;
    final l$title = title;
    result$data['title'] = l$title;
    final l$body = body;
    result$data['body'] = l$body;
    if (_$data.containsKey('photoKeys')) {
      final l$photoKeys = photoKeys;
      result$data['photoKeys'] = l$photoKeys?.map((e) => e).toList();
    }
    if (_$data.containsKey('category')) {
      final l$category = category;
      result$data['category'] = l$category == null
          ? null
          : toJson$Enum$TargetCategory(l$category);
    }
    if (_$data.containsKey('changeSpot')) {
      final l$changeSpot = changeSpot;
      result$data['changeSpot'] = l$changeSpot;
    }
    if (_$data.containsKey('catalogId')) {
      final l$catalogId = catalogId;
      result$data['catalogId'] = l$catalogId;
    }
    if (_$data.containsKey('tags')) {
      final l$tags = tags;
      result$data['tags'] = l$tags?.map((e) => e).toList();
    }
    return result$data;
  }

  CopyWith$Variables$Mutation$EditPost<Variables$Mutation$EditPost>
  get copyWith => CopyWith$Variables$Mutation$EditPost(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Mutation$EditPost ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$postId = postId;
    final lOther$postId = other.postId;
    if (l$postId != lOther$postId) {
      return false;
    }
    final l$title = title;
    final lOther$title = other.title;
    if (l$title != lOther$title) {
      return false;
    }
    final l$body = body;
    final lOther$body = other.body;
    if (l$body != lOther$body) {
      return false;
    }
    final l$photoKeys = photoKeys;
    final lOther$photoKeys = other.photoKeys;
    if (_$data.containsKey('photoKeys') !=
        other._$data.containsKey('photoKeys')) {
      return false;
    }
    if (l$photoKeys != null && lOther$photoKeys != null) {
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
    } else if (l$photoKeys != lOther$photoKeys) {
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
    final l$changeSpot = changeSpot;
    final lOther$changeSpot = other.changeSpot;
    if (_$data.containsKey('changeSpot') !=
        other._$data.containsKey('changeSpot')) {
      return false;
    }
    if (l$changeSpot != lOther$changeSpot) {
      return false;
    }
    final l$catalogId = catalogId;
    final lOther$catalogId = other.catalogId;
    if (_$data.containsKey('catalogId') !=
        other._$data.containsKey('catalogId')) {
      return false;
    }
    if (l$catalogId != lOther$catalogId) {
      return false;
    }
    final l$tags = tags;
    final lOther$tags = other.tags;
    if (_$data.containsKey('tags') != other._$data.containsKey('tags')) {
      return false;
    }
    if (l$tags != null && lOther$tags != null) {
      if (l$tags.length != lOther$tags.length) {
        return false;
      }
      for (int i = 0; i < l$tags.length; i++) {
        final l$tags$entry = l$tags[i];
        final lOther$tags$entry = lOther$tags[i];
        if (l$tags$entry != lOther$tags$entry) {
          return false;
        }
      }
    } else if (l$tags != lOther$tags) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$postId = postId;
    final l$title = title;
    final l$body = body;
    final l$photoKeys = photoKeys;
    final l$category = category;
    final l$changeSpot = changeSpot;
    final l$catalogId = catalogId;
    final l$tags = tags;
    return Object.hashAll([
      l$postId,
      l$title,
      l$body,
      _$data.containsKey('photoKeys')
          ? l$photoKeys == null
                ? null
                : Object.hashAll(l$photoKeys.map((v) => v))
          : const {},
      _$data.containsKey('category') ? l$category : const {},
      _$data.containsKey('changeSpot') ? l$changeSpot : const {},
      _$data.containsKey('catalogId') ? l$catalogId : const {},
      _$data.containsKey('tags')
          ? l$tags == null
                ? null
                : Object.hashAll(l$tags.map((v) => v))
          : const {},
    ]);
  }
}

abstract class CopyWith$Variables$Mutation$EditPost<TRes> {
  factory CopyWith$Variables$Mutation$EditPost(
    Variables$Mutation$EditPost instance,
    TRes Function(Variables$Mutation$EditPost) then,
  ) = _CopyWithImpl$Variables$Mutation$EditPost;

  factory CopyWith$Variables$Mutation$EditPost.stub(TRes res) =
      _CopyWithStubImpl$Variables$Mutation$EditPost;

  TRes call({
    String? postId,
    String? title,
    String? body,
    List<String>? photoKeys,
    Enum$TargetCategory? category,
    bool? changeSpot,
    String? catalogId,
    List<String>? tags,
  });
}

class _CopyWithImpl$Variables$Mutation$EditPost<TRes>
    implements CopyWith$Variables$Mutation$EditPost<TRes> {
  _CopyWithImpl$Variables$Mutation$EditPost(this._instance, this._then);

  final Variables$Mutation$EditPost _instance;

  final TRes Function(Variables$Mutation$EditPost) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? postId = _undefined,
    Object? title = _undefined,
    Object? body = _undefined,
    Object? photoKeys = _undefined,
    Object? category = _undefined,
    Object? changeSpot = _undefined,
    Object? catalogId = _undefined,
    Object? tags = _undefined,
  }) => _then(
    Variables$Mutation$EditPost._({
      ..._instance._$data,
      if (postId != _undefined && postId != null) 'postId': (postId as String),
      if (title != _undefined && title != null) 'title': (title as String),
      if (body != _undefined && body != null) 'body': (body as String),
      if (photoKeys != _undefined) 'photoKeys': (photoKeys as List<String>?),
      if (category != _undefined)
        'category': (category as Enum$TargetCategory?),
      if (changeSpot != _undefined) 'changeSpot': (changeSpot as bool?),
      if (catalogId != _undefined) 'catalogId': (catalogId as String?),
      if (tags != _undefined) 'tags': (tags as List<String>?),
    }),
  );
}

class _CopyWithStubImpl$Variables$Mutation$EditPost<TRes>
    implements CopyWith$Variables$Mutation$EditPost<TRes> {
  _CopyWithStubImpl$Variables$Mutation$EditPost(this._res);

  TRes _res;

  call({
    String? postId,
    String? title,
    String? body,
    List<String>? photoKeys,
    Enum$TargetCategory? category,
    bool? changeSpot,
    String? catalogId,
    List<String>? tags,
  }) => _res;
}

class Mutation$EditPost {
  Mutation$EditPost({required this.editPost});

  factory Mutation$EditPost.fromJson(Map<String, dynamic> json) {
    final l$editPost = json['editPost'];
    return Mutation$EditPost(
      editPost: Mutation$EditPost$editPost.fromJson(
        (l$editPost as Map<String, dynamic>),
      ),
    );
  }

  final Mutation$EditPost$editPost editPost;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$editPost = editPost;
    _resultData['editPost'] = l$editPost.toJson();
    return _resultData;
  }

  @override
  int get hashCode {
    final l$editPost = editPost;
    return Object.hashAll([l$editPost]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$EditPost || runtimeType != other.runtimeType) {
      return false;
    }
    final l$editPost = editPost;
    final lOther$editPost = other.editPost;
    if (l$editPost != lOther$editPost) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Mutation$EditPost on Mutation$EditPost {
  CopyWith$Mutation$EditPost<Mutation$EditPost> get copyWith =>
      CopyWith$Mutation$EditPost(this, (i) => i);
}

abstract class CopyWith$Mutation$EditPost<TRes> {
  factory CopyWith$Mutation$EditPost(
    Mutation$EditPost instance,
    TRes Function(Mutation$EditPost) then,
  ) = _CopyWithImpl$Mutation$EditPost;

  factory CopyWith$Mutation$EditPost.stub(TRes res) =
      _CopyWithStubImpl$Mutation$EditPost;

  TRes call({Mutation$EditPost$editPost? editPost});
  CopyWith$Mutation$EditPost$editPost<TRes> get editPost;
}

class _CopyWithImpl$Mutation$EditPost<TRes>
    implements CopyWith$Mutation$EditPost<TRes> {
  _CopyWithImpl$Mutation$EditPost(this._instance, this._then);

  final Mutation$EditPost _instance;

  final TRes Function(Mutation$EditPost) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? editPost = _undefined}) => _then(
    Mutation$EditPost(
      editPost: editPost == _undefined || editPost == null
          ? _instance.editPost
          : (editPost as Mutation$EditPost$editPost),
    ),
  );

  CopyWith$Mutation$EditPost$editPost<TRes> get editPost {
    final local$editPost = _instance.editPost;
    return CopyWith$Mutation$EditPost$editPost(
      local$editPost,
      (e) => call(editPost: e),
    );
  }
}

class _CopyWithStubImpl$Mutation$EditPost<TRes>
    implements CopyWith$Mutation$EditPost<TRes> {
  _CopyWithStubImpl$Mutation$EditPost(this._res);

  TRes _res;

  call({Mutation$EditPost$editPost? editPost}) => _res;

  CopyWith$Mutation$EditPost$editPost<TRes> get editPost =>
      CopyWith$Mutation$EditPost$editPost.stub(_res);
}

const documentNodeMutationEditPost = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'EditPost'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'postId')),
          type: NamedTypeNode(name: NameNode(value: 'ID'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'title')),
          type: NamedTypeNode(name: NameNode(value: 'String'), isNonNull: true),
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
            isNonNull: false,
          ),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'category')),
          type: NamedTypeNode(
            name: NameNode(value: 'TargetCategory'),
            isNonNull: false,
          ),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'changeSpot')),
          type: NamedTypeNode(
            name: NameNode(value: 'Boolean'),
            isNonNull: false,
          ),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'catalogId')),
          type: NamedTypeNode(name: NameNode(value: 'ID'), isNonNull: false),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'tags')),
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
            name: NameNode(value: 'editPost'),
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
                      name: NameNode(value: 'title'),
                      value: VariableNode(name: NameNode(value: 'title')),
                    ),
                    ObjectFieldNode(
                      name: NameNode(value: 'body'),
                      value: VariableNode(name: NameNode(value: 'body')),
                    ),
                    ObjectFieldNode(
                      name: NameNode(value: 'photoKeys'),
                      value: VariableNode(name: NameNode(value: 'photoKeys')),
                    ),
                    ObjectFieldNode(
                      name: NameNode(value: 'category'),
                      value: VariableNode(name: NameNode(value: 'category')),
                    ),
                    ObjectFieldNode(
                      name: NameNode(value: 'changeSpot'),
                      value: VariableNode(name: NameNode(value: 'changeSpot')),
                    ),
                    ObjectFieldNode(
                      name: NameNode(value: 'catalogId'),
                      value: VariableNode(name: NameNode(value: 'catalogId')),
                    ),
                    ObjectFieldNode(
                      name: NameNode(value: 'tags'),
                      value: VariableNode(name: NameNode(value: 'tags')),
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
              ],
            ),
          ),
        ],
      ),
    ),
  ],
);

class Mutation$EditPost$editPost {
  Mutation$EditPost$editPost({required this.success, required this.userErrors});

  factory Mutation$EditPost$editPost.fromJson(Map<String, dynamic> json) {
    final l$success = json['success'];
    final l$userErrors = json['userErrors'];
    return Mutation$EditPost$editPost(
      success: (l$success as bool),
      userErrors: (l$userErrors as List<dynamic>)
          .map(
            (e) => Mutation$EditPost$editPost$userErrors.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
    );
  }

  final bool success;

  final List<Mutation$EditPost$editPost$userErrors> userErrors;

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
    if (other is! Mutation$EditPost$editPost ||
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

extension UtilityExtension$Mutation$EditPost$editPost
    on Mutation$EditPost$editPost {
  CopyWith$Mutation$EditPost$editPost<Mutation$EditPost$editPost>
  get copyWith => CopyWith$Mutation$EditPost$editPost(this, (i) => i);
}

abstract class CopyWith$Mutation$EditPost$editPost<TRes> {
  factory CopyWith$Mutation$EditPost$editPost(
    Mutation$EditPost$editPost instance,
    TRes Function(Mutation$EditPost$editPost) then,
  ) = _CopyWithImpl$Mutation$EditPost$editPost;

  factory CopyWith$Mutation$EditPost$editPost.stub(TRes res) =
      _CopyWithStubImpl$Mutation$EditPost$editPost;

  TRes call({
    bool? success,
    List<Mutation$EditPost$editPost$userErrors>? userErrors,
  });
  TRes userErrors(
    Iterable<Mutation$EditPost$editPost$userErrors> Function(
      Iterable<
        CopyWith$Mutation$EditPost$editPost$userErrors<
          Mutation$EditPost$editPost$userErrors
        >
      >,
    )
    _fn,
  );
}

class _CopyWithImpl$Mutation$EditPost$editPost<TRes>
    implements CopyWith$Mutation$EditPost$editPost<TRes> {
  _CopyWithImpl$Mutation$EditPost$editPost(this._instance, this._then);

  final Mutation$EditPost$editPost _instance;

  final TRes Function(Mutation$EditPost$editPost) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? success = _undefined, Object? userErrors = _undefined}) =>
      _then(
        Mutation$EditPost$editPost(
          success: success == _undefined || success == null
              ? _instance.success
              : (success as bool),
          userErrors: userErrors == _undefined || userErrors == null
              ? _instance.userErrors
              : (userErrors as List<Mutation$EditPost$editPost$userErrors>),
        ),
      );

  TRes userErrors(
    Iterable<Mutation$EditPost$editPost$userErrors> Function(
      Iterable<
        CopyWith$Mutation$EditPost$editPost$userErrors<
          Mutation$EditPost$editPost$userErrors
        >
      >,
    )
    _fn,
  ) => call(
    userErrors: _fn(
      _instance.userErrors.map(
        (e) => CopyWith$Mutation$EditPost$editPost$userErrors(e, (i) => i),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl$Mutation$EditPost$editPost<TRes>
    implements CopyWith$Mutation$EditPost$editPost<TRes> {
  _CopyWithStubImpl$Mutation$EditPost$editPost(this._res);

  TRes _res;

  call({
    bool? success,
    List<Mutation$EditPost$editPost$userErrors>? userErrors,
  }) => _res;

  userErrors(_fn) => _res;
}

class Mutation$EditPost$editPost$userErrors {
  Mutation$EditPost$editPost$userErrors({
    required this.code,
    required this.message,
    this.field,
  });

  factory Mutation$EditPost$editPost$userErrors.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$code = json['code'];
    final l$message = json['message'];
    final l$field = json['field'];
    return Mutation$EditPost$editPost$userErrors(
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
    if (other is! Mutation$EditPost$editPost$userErrors ||
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

extension UtilityExtension$Mutation$EditPost$editPost$userErrors
    on Mutation$EditPost$editPost$userErrors {
  CopyWith$Mutation$EditPost$editPost$userErrors<
    Mutation$EditPost$editPost$userErrors
  >
  get copyWith =>
      CopyWith$Mutation$EditPost$editPost$userErrors(this, (i) => i);
}

abstract class CopyWith$Mutation$EditPost$editPost$userErrors<TRes> {
  factory CopyWith$Mutation$EditPost$editPost$userErrors(
    Mutation$EditPost$editPost$userErrors instance,
    TRes Function(Mutation$EditPost$editPost$userErrors) then,
  ) = _CopyWithImpl$Mutation$EditPost$editPost$userErrors;

  factory CopyWith$Mutation$EditPost$editPost$userErrors.stub(TRes res) =
      _CopyWithStubImpl$Mutation$EditPost$editPost$userErrors;

  TRes call({String? code, String? message, String? field});
}

class _CopyWithImpl$Mutation$EditPost$editPost$userErrors<TRes>
    implements CopyWith$Mutation$EditPost$editPost$userErrors<TRes> {
  _CopyWithImpl$Mutation$EditPost$editPost$userErrors(
    this._instance,
    this._then,
  );

  final Mutation$EditPost$editPost$userErrors _instance;

  final TRes Function(Mutation$EditPost$editPost$userErrors) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? code = _undefined,
    Object? message = _undefined,
    Object? field = _undefined,
  }) => _then(
    Mutation$EditPost$editPost$userErrors(
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

class _CopyWithStubImpl$Mutation$EditPost$editPost$userErrors<TRes>
    implements CopyWith$Mutation$EditPost$editPost$userErrors<TRes> {
  _CopyWithStubImpl$Mutation$EditPost$editPost$userErrors(this._res);

  TRes _res;

  call({String? code, String? message, String? field}) => _res;
}

class Variables$Mutation$CreateComment {
  factory Variables$Mutation$CreateComment({
    required String postId,
    required String body,
    String? parentCommentId,
  }) => Variables$Mutation$CreateComment._({
    r'postId': postId,
    r'body': body,
    if (parentCommentId != null) r'parentCommentId': parentCommentId,
  });

  Variables$Mutation$CreateComment._(this._$data);

  factory Variables$Mutation$CreateComment.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$postId = data['postId'];
    result$data['postId'] = (l$postId as String);
    final l$body = data['body'];
    result$data['body'] = (l$body as String);
    if (data.containsKey('parentCommentId')) {
      final l$parentCommentId = data['parentCommentId'];
      result$data['parentCommentId'] = (l$parentCommentId as String?);
    }
    return Variables$Mutation$CreateComment._(result$data);
  }

  Map<String, dynamic> _$data;

  String get postId => (_$data['postId'] as String);

  String get body => (_$data['body'] as String);

  String? get parentCommentId => (_$data['parentCommentId'] as String?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$postId = postId;
    result$data['postId'] = l$postId;
    final l$body = body;
    result$data['body'] = l$body;
    if (_$data.containsKey('parentCommentId')) {
      final l$parentCommentId = parentCommentId;
      result$data['parentCommentId'] = l$parentCommentId;
    }
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
    final l$parentCommentId = parentCommentId;
    final lOther$parentCommentId = other.parentCommentId;
    if (_$data.containsKey('parentCommentId') !=
        other._$data.containsKey('parentCommentId')) {
      return false;
    }
    if (l$parentCommentId != lOther$parentCommentId) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$postId = postId;
    final l$body = body;
    final l$parentCommentId = parentCommentId;
    return Object.hashAll([
      l$postId,
      l$body,
      _$data.containsKey('parentCommentId') ? l$parentCommentId : const {},
    ]);
  }
}

abstract class CopyWith$Variables$Mutation$CreateComment<TRes> {
  factory CopyWith$Variables$Mutation$CreateComment(
    Variables$Mutation$CreateComment instance,
    TRes Function(Variables$Mutation$CreateComment) then,
  ) = _CopyWithImpl$Variables$Mutation$CreateComment;

  factory CopyWith$Variables$Mutation$CreateComment.stub(TRes res) =
      _CopyWithStubImpl$Variables$Mutation$CreateComment;

  TRes call({String? postId, String? body, String? parentCommentId});
}

class _CopyWithImpl$Variables$Mutation$CreateComment<TRes>
    implements CopyWith$Variables$Mutation$CreateComment<TRes> {
  _CopyWithImpl$Variables$Mutation$CreateComment(this._instance, this._then);

  final Variables$Mutation$CreateComment _instance;

  final TRes Function(Variables$Mutation$CreateComment) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? postId = _undefined,
    Object? body = _undefined,
    Object? parentCommentId = _undefined,
  }) => _then(
    Variables$Mutation$CreateComment._({
      ..._instance._$data,
      if (postId != _undefined && postId != null) 'postId': (postId as String),
      if (body != _undefined && body != null) 'body': (body as String),
      if (parentCommentId != _undefined)
        'parentCommentId': (parentCommentId as String?),
    }),
  );
}

class _CopyWithStubImpl$Variables$Mutation$CreateComment<TRes>
    implements CopyWith$Variables$Mutation$CreateComment<TRes> {
  _CopyWithStubImpl$Variables$Mutation$CreateComment(this._res);

  TRes _res;

  call({String? postId, String? body, String? parentCommentId}) => _res;
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
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'parentCommentId')),
          type: NamedTypeNode(name: NameNode(value: 'ID'), isNonNull: false),
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
                    ObjectFieldNode(
                      name: NameNode(value: 'parentCommentId'),
                      value: VariableNode(
                        name: NameNode(value: 'parentCommentId'),
                      ),
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

class Variables$Mutation$DeleteComment {
  factory Variables$Mutation$DeleteComment({required String commentId}) =>
      Variables$Mutation$DeleteComment._({r'commentId': commentId});

  Variables$Mutation$DeleteComment._(this._$data);

  factory Variables$Mutation$DeleteComment.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$commentId = data['commentId'];
    result$data['commentId'] = (l$commentId as String);
    return Variables$Mutation$DeleteComment._(result$data);
  }

  Map<String, dynamic> _$data;

  String get commentId => (_$data['commentId'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$commentId = commentId;
    result$data['commentId'] = l$commentId;
    return result$data;
  }

  CopyWith$Variables$Mutation$DeleteComment<Variables$Mutation$DeleteComment>
  get copyWith => CopyWith$Variables$Mutation$DeleteComment(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Mutation$DeleteComment ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$commentId = commentId;
    final lOther$commentId = other.commentId;
    if (l$commentId != lOther$commentId) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$commentId = commentId;
    return Object.hashAll([l$commentId]);
  }
}

abstract class CopyWith$Variables$Mutation$DeleteComment<TRes> {
  factory CopyWith$Variables$Mutation$DeleteComment(
    Variables$Mutation$DeleteComment instance,
    TRes Function(Variables$Mutation$DeleteComment) then,
  ) = _CopyWithImpl$Variables$Mutation$DeleteComment;

  factory CopyWith$Variables$Mutation$DeleteComment.stub(TRes res) =
      _CopyWithStubImpl$Variables$Mutation$DeleteComment;

  TRes call({String? commentId});
}

class _CopyWithImpl$Variables$Mutation$DeleteComment<TRes>
    implements CopyWith$Variables$Mutation$DeleteComment<TRes> {
  _CopyWithImpl$Variables$Mutation$DeleteComment(this._instance, this._then);

  final Variables$Mutation$DeleteComment _instance;

  final TRes Function(Variables$Mutation$DeleteComment) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? commentId = _undefined}) => _then(
    Variables$Mutation$DeleteComment._({
      ..._instance._$data,
      if (commentId != _undefined && commentId != null)
        'commentId': (commentId as String),
    }),
  );
}

class _CopyWithStubImpl$Variables$Mutation$DeleteComment<TRes>
    implements CopyWith$Variables$Mutation$DeleteComment<TRes> {
  _CopyWithStubImpl$Variables$Mutation$DeleteComment(this._res);

  TRes _res;

  call({String? commentId}) => _res;
}

class Mutation$DeleteComment {
  Mutation$DeleteComment({required this.deleteComment});

  factory Mutation$DeleteComment.fromJson(Map<String, dynamic> json) {
    final l$deleteComment = json['deleteComment'];
    return Mutation$DeleteComment(
      deleteComment: Mutation$DeleteComment$deleteComment.fromJson(
        (l$deleteComment as Map<String, dynamic>),
      ),
    );
  }

  final Mutation$DeleteComment$deleteComment deleteComment;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$deleteComment = deleteComment;
    _resultData['deleteComment'] = l$deleteComment.toJson();
    return _resultData;
  }

  @override
  int get hashCode {
    final l$deleteComment = deleteComment;
    return Object.hashAll([l$deleteComment]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$DeleteComment || runtimeType != other.runtimeType) {
      return false;
    }
    final l$deleteComment = deleteComment;
    final lOther$deleteComment = other.deleteComment;
    if (l$deleteComment != lOther$deleteComment) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Mutation$DeleteComment on Mutation$DeleteComment {
  CopyWith$Mutation$DeleteComment<Mutation$DeleteComment> get copyWith =>
      CopyWith$Mutation$DeleteComment(this, (i) => i);
}

abstract class CopyWith$Mutation$DeleteComment<TRes> {
  factory CopyWith$Mutation$DeleteComment(
    Mutation$DeleteComment instance,
    TRes Function(Mutation$DeleteComment) then,
  ) = _CopyWithImpl$Mutation$DeleteComment;

  factory CopyWith$Mutation$DeleteComment.stub(TRes res) =
      _CopyWithStubImpl$Mutation$DeleteComment;

  TRes call({Mutation$DeleteComment$deleteComment? deleteComment});
  CopyWith$Mutation$DeleteComment$deleteComment<TRes> get deleteComment;
}

class _CopyWithImpl$Mutation$DeleteComment<TRes>
    implements CopyWith$Mutation$DeleteComment<TRes> {
  _CopyWithImpl$Mutation$DeleteComment(this._instance, this._then);

  final Mutation$DeleteComment _instance;

  final TRes Function(Mutation$DeleteComment) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? deleteComment = _undefined}) => _then(
    Mutation$DeleteComment(
      deleteComment: deleteComment == _undefined || deleteComment == null
          ? _instance.deleteComment
          : (deleteComment as Mutation$DeleteComment$deleteComment),
    ),
  );

  CopyWith$Mutation$DeleteComment$deleteComment<TRes> get deleteComment {
    final local$deleteComment = _instance.deleteComment;
    return CopyWith$Mutation$DeleteComment$deleteComment(
      local$deleteComment,
      (e) => call(deleteComment: e),
    );
  }
}

class _CopyWithStubImpl$Mutation$DeleteComment<TRes>
    implements CopyWith$Mutation$DeleteComment<TRes> {
  _CopyWithStubImpl$Mutation$DeleteComment(this._res);

  TRes _res;

  call({Mutation$DeleteComment$deleteComment? deleteComment}) => _res;

  CopyWith$Mutation$DeleteComment$deleteComment<TRes> get deleteComment =>
      CopyWith$Mutation$DeleteComment$deleteComment.stub(_res);
}

const documentNodeMutationDeleteComment = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'DeleteComment'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'commentId')),
          type: NamedTypeNode(name: NameNode(value: 'ID'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
      ],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'deleteComment'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'input'),
                value: ObjectValueNode(
                  fields: [
                    ObjectFieldNode(
                      name: NameNode(value: 'commentId'),
                      value: VariableNode(name: NameNode(value: 'commentId')),
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
              ],
            ),
          ),
        ],
      ),
    ),
  ],
);

class Mutation$DeleteComment$deleteComment {
  Mutation$DeleteComment$deleteComment({
    required this.success,
    required this.userErrors,
  });

  factory Mutation$DeleteComment$deleteComment.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$success = json['success'];
    final l$userErrors = json['userErrors'];
    return Mutation$DeleteComment$deleteComment(
      success: (l$success as bool),
      userErrors: (l$userErrors as List<dynamic>)
          .map(
            (e) => Mutation$DeleteComment$deleteComment$userErrors.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
    );
  }

  final bool success;

  final List<Mutation$DeleteComment$deleteComment$userErrors> userErrors;

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
    if (other is! Mutation$DeleteComment$deleteComment ||
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

extension UtilityExtension$Mutation$DeleteComment$deleteComment
    on Mutation$DeleteComment$deleteComment {
  CopyWith$Mutation$DeleteComment$deleteComment<
    Mutation$DeleteComment$deleteComment
  >
  get copyWith => CopyWith$Mutation$DeleteComment$deleteComment(this, (i) => i);
}

abstract class CopyWith$Mutation$DeleteComment$deleteComment<TRes> {
  factory CopyWith$Mutation$DeleteComment$deleteComment(
    Mutation$DeleteComment$deleteComment instance,
    TRes Function(Mutation$DeleteComment$deleteComment) then,
  ) = _CopyWithImpl$Mutation$DeleteComment$deleteComment;

  factory CopyWith$Mutation$DeleteComment$deleteComment.stub(TRes res) =
      _CopyWithStubImpl$Mutation$DeleteComment$deleteComment;

  TRes call({
    bool? success,
    List<Mutation$DeleteComment$deleteComment$userErrors>? userErrors,
  });
  TRes userErrors(
    Iterable<Mutation$DeleteComment$deleteComment$userErrors> Function(
      Iterable<
        CopyWith$Mutation$DeleteComment$deleteComment$userErrors<
          Mutation$DeleteComment$deleteComment$userErrors
        >
      >,
    )
    _fn,
  );
}

class _CopyWithImpl$Mutation$DeleteComment$deleteComment<TRes>
    implements CopyWith$Mutation$DeleteComment$deleteComment<TRes> {
  _CopyWithImpl$Mutation$DeleteComment$deleteComment(
    this._instance,
    this._then,
  );

  final Mutation$DeleteComment$deleteComment _instance;

  final TRes Function(Mutation$DeleteComment$deleteComment) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? success = _undefined, Object? userErrors = _undefined}) =>
      _then(
        Mutation$DeleteComment$deleteComment(
          success: success == _undefined || success == null
              ? _instance.success
              : (success as bool),
          userErrors: userErrors == _undefined || userErrors == null
              ? _instance.userErrors
              : (userErrors
                    as List<Mutation$DeleteComment$deleteComment$userErrors>),
        ),
      );

  TRes userErrors(
    Iterable<Mutation$DeleteComment$deleteComment$userErrors> Function(
      Iterable<
        CopyWith$Mutation$DeleteComment$deleteComment$userErrors<
          Mutation$DeleteComment$deleteComment$userErrors
        >
      >,
    )
    _fn,
  ) => call(
    userErrors: _fn(
      _instance.userErrors.map(
        (e) => CopyWith$Mutation$DeleteComment$deleteComment$userErrors(
          e,
          (i) => i,
        ),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl$Mutation$DeleteComment$deleteComment<TRes>
    implements CopyWith$Mutation$DeleteComment$deleteComment<TRes> {
  _CopyWithStubImpl$Mutation$DeleteComment$deleteComment(this._res);

  TRes _res;

  call({
    bool? success,
    List<Mutation$DeleteComment$deleteComment$userErrors>? userErrors,
  }) => _res;

  userErrors(_fn) => _res;
}

class Mutation$DeleteComment$deleteComment$userErrors {
  Mutation$DeleteComment$deleteComment$userErrors({
    required this.code,
    required this.message,
    this.field,
  });

  factory Mutation$DeleteComment$deleteComment$userErrors.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$code = json['code'];
    final l$message = json['message'];
    final l$field = json['field'];
    return Mutation$DeleteComment$deleteComment$userErrors(
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
    if (other is! Mutation$DeleteComment$deleteComment$userErrors ||
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

extension UtilityExtension$Mutation$DeleteComment$deleteComment$userErrors
    on Mutation$DeleteComment$deleteComment$userErrors {
  CopyWith$Mutation$DeleteComment$deleteComment$userErrors<
    Mutation$DeleteComment$deleteComment$userErrors
  >
  get copyWith =>
      CopyWith$Mutation$DeleteComment$deleteComment$userErrors(this, (i) => i);
}

abstract class CopyWith$Mutation$DeleteComment$deleteComment$userErrors<TRes> {
  factory CopyWith$Mutation$DeleteComment$deleteComment$userErrors(
    Mutation$DeleteComment$deleteComment$userErrors instance,
    TRes Function(Mutation$DeleteComment$deleteComment$userErrors) then,
  ) = _CopyWithImpl$Mutation$DeleteComment$deleteComment$userErrors;

  factory CopyWith$Mutation$DeleteComment$deleteComment$userErrors.stub(
    TRes res,
  ) = _CopyWithStubImpl$Mutation$DeleteComment$deleteComment$userErrors;

  TRes call({String? code, String? message, String? field});
}

class _CopyWithImpl$Mutation$DeleteComment$deleteComment$userErrors<TRes>
    implements CopyWith$Mutation$DeleteComment$deleteComment$userErrors<TRes> {
  _CopyWithImpl$Mutation$DeleteComment$deleteComment$userErrors(
    this._instance,
    this._then,
  );

  final Mutation$DeleteComment$deleteComment$userErrors _instance;

  final TRes Function(Mutation$DeleteComment$deleteComment$userErrors) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? code = _undefined,
    Object? message = _undefined,
    Object? field = _undefined,
  }) => _then(
    Mutation$DeleteComment$deleteComment$userErrors(
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

class _CopyWithStubImpl$Mutation$DeleteComment$deleteComment$userErrors<TRes>
    implements CopyWith$Mutation$DeleteComment$deleteComment$userErrors<TRes> {
  _CopyWithStubImpl$Mutation$DeleteComment$deleteComment$userErrors(this._res);

  TRes _res;

  call({String? code, String? message, String? field}) => _res;
}

class Variables$Mutation$DeletePost {
  factory Variables$Mutation$DeletePost({required String postId}) =>
      Variables$Mutation$DeletePost._({r'postId': postId});

  Variables$Mutation$DeletePost._(this._$data);

  factory Variables$Mutation$DeletePost.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$postId = data['postId'];
    result$data['postId'] = (l$postId as String);
    return Variables$Mutation$DeletePost._(result$data);
  }

  Map<String, dynamic> _$data;

  String get postId => (_$data['postId'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$postId = postId;
    result$data['postId'] = l$postId;
    return result$data;
  }

  CopyWith$Variables$Mutation$DeletePost<Variables$Mutation$DeletePost>
  get copyWith => CopyWith$Variables$Mutation$DeletePost(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Mutation$DeletePost ||
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

abstract class CopyWith$Variables$Mutation$DeletePost<TRes> {
  factory CopyWith$Variables$Mutation$DeletePost(
    Variables$Mutation$DeletePost instance,
    TRes Function(Variables$Mutation$DeletePost) then,
  ) = _CopyWithImpl$Variables$Mutation$DeletePost;

  factory CopyWith$Variables$Mutation$DeletePost.stub(TRes res) =
      _CopyWithStubImpl$Variables$Mutation$DeletePost;

  TRes call({String? postId});
}

class _CopyWithImpl$Variables$Mutation$DeletePost<TRes>
    implements CopyWith$Variables$Mutation$DeletePost<TRes> {
  _CopyWithImpl$Variables$Mutation$DeletePost(this._instance, this._then);

  final Variables$Mutation$DeletePost _instance;

  final TRes Function(Variables$Mutation$DeletePost) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? postId = _undefined}) => _then(
    Variables$Mutation$DeletePost._({
      ..._instance._$data,
      if (postId != _undefined && postId != null) 'postId': (postId as String),
    }),
  );
}

class _CopyWithStubImpl$Variables$Mutation$DeletePost<TRes>
    implements CopyWith$Variables$Mutation$DeletePost<TRes> {
  _CopyWithStubImpl$Variables$Mutation$DeletePost(this._res);

  TRes _res;

  call({String? postId}) => _res;
}

class Mutation$DeletePost {
  Mutation$DeletePost({required this.deletePost});

  factory Mutation$DeletePost.fromJson(Map<String, dynamic> json) {
    final l$deletePost = json['deletePost'];
    return Mutation$DeletePost(
      deletePost: Mutation$DeletePost$deletePost.fromJson(
        (l$deletePost as Map<String, dynamic>),
      ),
    );
  }

  final Mutation$DeletePost$deletePost deletePost;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$deletePost = deletePost;
    _resultData['deletePost'] = l$deletePost.toJson();
    return _resultData;
  }

  @override
  int get hashCode {
    final l$deletePost = deletePost;
    return Object.hashAll([l$deletePost]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$DeletePost || runtimeType != other.runtimeType) {
      return false;
    }
    final l$deletePost = deletePost;
    final lOther$deletePost = other.deletePost;
    if (l$deletePost != lOther$deletePost) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Mutation$DeletePost on Mutation$DeletePost {
  CopyWith$Mutation$DeletePost<Mutation$DeletePost> get copyWith =>
      CopyWith$Mutation$DeletePost(this, (i) => i);
}

abstract class CopyWith$Mutation$DeletePost<TRes> {
  factory CopyWith$Mutation$DeletePost(
    Mutation$DeletePost instance,
    TRes Function(Mutation$DeletePost) then,
  ) = _CopyWithImpl$Mutation$DeletePost;

  factory CopyWith$Mutation$DeletePost.stub(TRes res) =
      _CopyWithStubImpl$Mutation$DeletePost;

  TRes call({Mutation$DeletePost$deletePost? deletePost});
  CopyWith$Mutation$DeletePost$deletePost<TRes> get deletePost;
}

class _CopyWithImpl$Mutation$DeletePost<TRes>
    implements CopyWith$Mutation$DeletePost<TRes> {
  _CopyWithImpl$Mutation$DeletePost(this._instance, this._then);

  final Mutation$DeletePost _instance;

  final TRes Function(Mutation$DeletePost) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? deletePost = _undefined}) => _then(
    Mutation$DeletePost(
      deletePost: deletePost == _undefined || deletePost == null
          ? _instance.deletePost
          : (deletePost as Mutation$DeletePost$deletePost),
    ),
  );

  CopyWith$Mutation$DeletePost$deletePost<TRes> get deletePost {
    final local$deletePost = _instance.deletePost;
    return CopyWith$Mutation$DeletePost$deletePost(
      local$deletePost,
      (e) => call(deletePost: e),
    );
  }
}

class _CopyWithStubImpl$Mutation$DeletePost<TRes>
    implements CopyWith$Mutation$DeletePost<TRes> {
  _CopyWithStubImpl$Mutation$DeletePost(this._res);

  TRes _res;

  call({Mutation$DeletePost$deletePost? deletePost}) => _res;

  CopyWith$Mutation$DeletePost$deletePost<TRes> get deletePost =>
      CopyWith$Mutation$DeletePost$deletePost.stub(_res);
}

const documentNodeMutationDeletePost = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'DeletePost'),
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
            name: NameNode(value: 'deletePost'),
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
              ],
            ),
          ),
        ],
      ),
    ),
  ],
);

class Mutation$DeletePost$deletePost {
  Mutation$DeletePost$deletePost({
    required this.success,
    required this.userErrors,
  });

  factory Mutation$DeletePost$deletePost.fromJson(Map<String, dynamic> json) {
    final l$success = json['success'];
    final l$userErrors = json['userErrors'];
    return Mutation$DeletePost$deletePost(
      success: (l$success as bool),
      userErrors: (l$userErrors as List<dynamic>)
          .map(
            (e) => Mutation$DeletePost$deletePost$userErrors.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
    );
  }

  final bool success;

  final List<Mutation$DeletePost$deletePost$userErrors> userErrors;

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
    if (other is! Mutation$DeletePost$deletePost ||
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

extension UtilityExtension$Mutation$DeletePost$deletePost
    on Mutation$DeletePost$deletePost {
  CopyWith$Mutation$DeletePost$deletePost<Mutation$DeletePost$deletePost>
  get copyWith => CopyWith$Mutation$DeletePost$deletePost(this, (i) => i);
}

abstract class CopyWith$Mutation$DeletePost$deletePost<TRes> {
  factory CopyWith$Mutation$DeletePost$deletePost(
    Mutation$DeletePost$deletePost instance,
    TRes Function(Mutation$DeletePost$deletePost) then,
  ) = _CopyWithImpl$Mutation$DeletePost$deletePost;

  factory CopyWith$Mutation$DeletePost$deletePost.stub(TRes res) =
      _CopyWithStubImpl$Mutation$DeletePost$deletePost;

  TRes call({
    bool? success,
    List<Mutation$DeletePost$deletePost$userErrors>? userErrors,
  });
  TRes userErrors(
    Iterable<Mutation$DeletePost$deletePost$userErrors> Function(
      Iterable<
        CopyWith$Mutation$DeletePost$deletePost$userErrors<
          Mutation$DeletePost$deletePost$userErrors
        >
      >,
    )
    _fn,
  );
}

class _CopyWithImpl$Mutation$DeletePost$deletePost<TRes>
    implements CopyWith$Mutation$DeletePost$deletePost<TRes> {
  _CopyWithImpl$Mutation$DeletePost$deletePost(this._instance, this._then);

  final Mutation$DeletePost$deletePost _instance;

  final TRes Function(Mutation$DeletePost$deletePost) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? success = _undefined, Object? userErrors = _undefined}) =>
      _then(
        Mutation$DeletePost$deletePost(
          success: success == _undefined || success == null
              ? _instance.success
              : (success as bool),
          userErrors: userErrors == _undefined || userErrors == null
              ? _instance.userErrors
              : (userErrors as List<Mutation$DeletePost$deletePost$userErrors>),
        ),
      );

  TRes userErrors(
    Iterable<Mutation$DeletePost$deletePost$userErrors> Function(
      Iterable<
        CopyWith$Mutation$DeletePost$deletePost$userErrors<
          Mutation$DeletePost$deletePost$userErrors
        >
      >,
    )
    _fn,
  ) => call(
    userErrors: _fn(
      _instance.userErrors.map(
        (e) => CopyWith$Mutation$DeletePost$deletePost$userErrors(e, (i) => i),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl$Mutation$DeletePost$deletePost<TRes>
    implements CopyWith$Mutation$DeletePost$deletePost<TRes> {
  _CopyWithStubImpl$Mutation$DeletePost$deletePost(this._res);

  TRes _res;

  call({
    bool? success,
    List<Mutation$DeletePost$deletePost$userErrors>? userErrors,
  }) => _res;

  userErrors(_fn) => _res;
}

class Mutation$DeletePost$deletePost$userErrors {
  Mutation$DeletePost$deletePost$userErrors({
    required this.code,
    required this.message,
    this.field,
  });

  factory Mutation$DeletePost$deletePost$userErrors.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$code = json['code'];
    final l$message = json['message'];
    final l$field = json['field'];
    return Mutation$DeletePost$deletePost$userErrors(
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
    if (other is! Mutation$DeletePost$deletePost$userErrors ||
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

extension UtilityExtension$Mutation$DeletePost$deletePost$userErrors
    on Mutation$DeletePost$deletePost$userErrors {
  CopyWith$Mutation$DeletePost$deletePost$userErrors<
    Mutation$DeletePost$deletePost$userErrors
  >
  get copyWith =>
      CopyWith$Mutation$DeletePost$deletePost$userErrors(this, (i) => i);
}

abstract class CopyWith$Mutation$DeletePost$deletePost$userErrors<TRes> {
  factory CopyWith$Mutation$DeletePost$deletePost$userErrors(
    Mutation$DeletePost$deletePost$userErrors instance,
    TRes Function(Mutation$DeletePost$deletePost$userErrors) then,
  ) = _CopyWithImpl$Mutation$DeletePost$deletePost$userErrors;

  factory CopyWith$Mutation$DeletePost$deletePost$userErrors.stub(TRes res) =
      _CopyWithStubImpl$Mutation$DeletePost$deletePost$userErrors;

  TRes call({String? code, String? message, String? field});
}

class _CopyWithImpl$Mutation$DeletePost$deletePost$userErrors<TRes>
    implements CopyWith$Mutation$DeletePost$deletePost$userErrors<TRes> {
  _CopyWithImpl$Mutation$DeletePost$deletePost$userErrors(
    this._instance,
    this._then,
  );

  final Mutation$DeletePost$deletePost$userErrors _instance;

  final TRes Function(Mutation$DeletePost$deletePost$userErrors) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? code = _undefined,
    Object? message = _undefined,
    Object? field = _undefined,
  }) => _then(
    Mutation$DeletePost$deletePost$userErrors(
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

class _CopyWithStubImpl$Mutation$DeletePost$deletePost$userErrors<TRes>
    implements CopyWith$Mutation$DeletePost$deletePost$userErrors<TRes> {
  _CopyWithStubImpl$Mutation$DeletePost$deletePost$userErrors(this._res);

  TRes _res;

  call({String? code, String? message, String? field}) => _res;
}

class Variables$Mutation$CreatePostImageUploadUrls {
  factory Variables$Mutation$CreatePostImageUploadUrls({
    required List<Input$PostImageUploadRequest> images,
  }) => Variables$Mutation$CreatePostImageUploadUrls._({r'images': images});

  Variables$Mutation$CreatePostImageUploadUrls._(this._$data);

  factory Variables$Mutation$CreatePostImageUploadUrls.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    final l$images = data['images'];
    result$data['images'] = (l$images as List<dynamic>)
        .map(
          (e) => Input$PostImageUploadRequest.fromJson(
            (e as Map<String, dynamic>),
          ),
        )
        .toList();
    return Variables$Mutation$CreatePostImageUploadUrls._(result$data);
  }

  Map<String, dynamic> _$data;

  List<Input$PostImageUploadRequest> get images =>
      (_$data['images'] as List<Input$PostImageUploadRequest>);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$images = images;
    result$data['images'] = l$images.map((e) => e.toJson()).toList();
    return result$data;
  }

  CopyWith$Variables$Mutation$CreatePostImageUploadUrls<
    Variables$Mutation$CreatePostImageUploadUrls
  >
  get copyWith =>
      CopyWith$Variables$Mutation$CreatePostImageUploadUrls(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Mutation$CreatePostImageUploadUrls ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$images = images;
    final lOther$images = other.images;
    if (l$images.length != lOther$images.length) {
      return false;
    }
    for (int i = 0; i < l$images.length; i++) {
      final l$images$entry = l$images[i];
      final lOther$images$entry = lOther$images[i];
      if (l$images$entry != lOther$images$entry) {
        return false;
      }
    }
    return true;
  }

  @override
  int get hashCode {
    final l$images = images;
    return Object.hashAll([Object.hashAll(l$images.map((v) => v))]);
  }
}

abstract class CopyWith$Variables$Mutation$CreatePostImageUploadUrls<TRes> {
  factory CopyWith$Variables$Mutation$CreatePostImageUploadUrls(
    Variables$Mutation$CreatePostImageUploadUrls instance,
    TRes Function(Variables$Mutation$CreatePostImageUploadUrls) then,
  ) = _CopyWithImpl$Variables$Mutation$CreatePostImageUploadUrls;

  factory CopyWith$Variables$Mutation$CreatePostImageUploadUrls.stub(TRes res) =
      _CopyWithStubImpl$Variables$Mutation$CreatePostImageUploadUrls;

  TRes call({List<Input$PostImageUploadRequest>? images});
}

class _CopyWithImpl$Variables$Mutation$CreatePostImageUploadUrls<TRes>
    implements CopyWith$Variables$Mutation$CreatePostImageUploadUrls<TRes> {
  _CopyWithImpl$Variables$Mutation$CreatePostImageUploadUrls(
    this._instance,
    this._then,
  );

  final Variables$Mutation$CreatePostImageUploadUrls _instance;

  final TRes Function(Variables$Mutation$CreatePostImageUploadUrls) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? images = _undefined}) => _then(
    Variables$Mutation$CreatePostImageUploadUrls._({
      ..._instance._$data,
      if (images != _undefined && images != null)
        'images': (images as List<Input$PostImageUploadRequest>),
    }),
  );
}

class _CopyWithStubImpl$Variables$Mutation$CreatePostImageUploadUrls<TRes>
    implements CopyWith$Variables$Mutation$CreatePostImageUploadUrls<TRes> {
  _CopyWithStubImpl$Variables$Mutation$CreatePostImageUploadUrls(this._res);

  TRes _res;

  call({List<Input$PostImageUploadRequest>? images}) => _res;
}

class Mutation$CreatePostImageUploadUrls {
  Mutation$CreatePostImageUploadUrls({required this.createPostImageUploadUrls});

  factory Mutation$CreatePostImageUploadUrls.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$createPostImageUploadUrls = json['createPostImageUploadUrls'];
    return Mutation$CreatePostImageUploadUrls(
      createPostImageUploadUrls:
          Mutation$CreatePostImageUploadUrls$createPostImageUploadUrls.fromJson(
            (l$createPostImageUploadUrls as Map<String, dynamic>),
          ),
    );
  }

  final Mutation$CreatePostImageUploadUrls$createPostImageUploadUrls
  createPostImageUploadUrls;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$createPostImageUploadUrls = createPostImageUploadUrls;
    _resultData['createPostImageUploadUrls'] = l$createPostImageUploadUrls
        .toJson();
    return _resultData;
  }

  @override
  int get hashCode {
    final l$createPostImageUploadUrls = createPostImageUploadUrls;
    return Object.hashAll([l$createPostImageUploadUrls]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$CreatePostImageUploadUrls ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$createPostImageUploadUrls = createPostImageUploadUrls;
    final lOther$createPostImageUploadUrls = other.createPostImageUploadUrls;
    if (l$createPostImageUploadUrls != lOther$createPostImageUploadUrls) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Mutation$CreatePostImageUploadUrls
    on Mutation$CreatePostImageUploadUrls {
  CopyWith$Mutation$CreatePostImageUploadUrls<
    Mutation$CreatePostImageUploadUrls
  >
  get copyWith => CopyWith$Mutation$CreatePostImageUploadUrls(this, (i) => i);
}

abstract class CopyWith$Mutation$CreatePostImageUploadUrls<TRes> {
  factory CopyWith$Mutation$CreatePostImageUploadUrls(
    Mutation$CreatePostImageUploadUrls instance,
    TRes Function(Mutation$CreatePostImageUploadUrls) then,
  ) = _CopyWithImpl$Mutation$CreatePostImageUploadUrls;

  factory CopyWith$Mutation$CreatePostImageUploadUrls.stub(TRes res) =
      _CopyWithStubImpl$Mutation$CreatePostImageUploadUrls;

  TRes call({
    Mutation$CreatePostImageUploadUrls$createPostImageUploadUrls?
    createPostImageUploadUrls,
  });
  CopyWith$Mutation$CreatePostImageUploadUrls$createPostImageUploadUrls<TRes>
  get createPostImageUploadUrls;
}

class _CopyWithImpl$Mutation$CreatePostImageUploadUrls<TRes>
    implements CopyWith$Mutation$CreatePostImageUploadUrls<TRes> {
  _CopyWithImpl$Mutation$CreatePostImageUploadUrls(this._instance, this._then);

  final Mutation$CreatePostImageUploadUrls _instance;

  final TRes Function(Mutation$CreatePostImageUploadUrls) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? createPostImageUploadUrls = _undefined}) => _then(
    Mutation$CreatePostImageUploadUrls(
      createPostImageUploadUrls:
          createPostImageUploadUrls == _undefined ||
              createPostImageUploadUrls == null
          ? _instance.createPostImageUploadUrls
          : (createPostImageUploadUrls
                as Mutation$CreatePostImageUploadUrls$createPostImageUploadUrls),
    ),
  );

  CopyWith$Mutation$CreatePostImageUploadUrls$createPostImageUploadUrls<TRes>
  get createPostImageUploadUrls {
    final local$createPostImageUploadUrls = _instance.createPostImageUploadUrls;
    return CopyWith$Mutation$CreatePostImageUploadUrls$createPostImageUploadUrls(
      local$createPostImageUploadUrls,
      (e) => call(createPostImageUploadUrls: e),
    );
  }
}

class _CopyWithStubImpl$Mutation$CreatePostImageUploadUrls<TRes>
    implements CopyWith$Mutation$CreatePostImageUploadUrls<TRes> {
  _CopyWithStubImpl$Mutation$CreatePostImageUploadUrls(this._res);

  TRes _res;

  call({
    Mutation$CreatePostImageUploadUrls$createPostImageUploadUrls?
    createPostImageUploadUrls,
  }) => _res;

  CopyWith$Mutation$CreatePostImageUploadUrls$createPostImageUploadUrls<TRes>
  get createPostImageUploadUrls =>
      CopyWith$Mutation$CreatePostImageUploadUrls$createPostImageUploadUrls.stub(
        _res,
      );
}

const documentNodeMutationCreatePostImageUploadUrls = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'CreatePostImageUploadUrls'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'images')),
          type: ListTypeNode(
            type: NamedTypeNode(
              name: NameNode(value: 'PostImageUploadRequest'),
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
            name: NameNode(value: 'createPostImageUploadUrls'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'input'),
                value: ObjectValueNode(
                  fields: [
                    ObjectFieldNode(
                      name: NameNode(value: 'images'),
                      value: VariableNode(name: NameNode(value: 'images')),
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
                  name: NameNode(value: 'uploadUrls'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: SelectionSetNode(
                    selections: [
                      FieldNode(
                        name: NameNode(value: 'uploadUrl'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'objectKey'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'expiresAt'),
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

class Mutation$CreatePostImageUploadUrls$createPostImageUploadUrls {
  Mutation$CreatePostImageUploadUrls$createPostImageUploadUrls({
    required this.success,
    required this.userErrors,
    required this.uploadUrls,
  });

  factory Mutation$CreatePostImageUploadUrls$createPostImageUploadUrls.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$success = json['success'];
    final l$userErrors = json['userErrors'];
    final l$uploadUrls = json['uploadUrls'];
    return Mutation$CreatePostImageUploadUrls$createPostImageUploadUrls(
      success: (l$success as bool),
      userErrors: (l$userErrors as List<dynamic>)
          .map(
            (e) =>
                Mutation$CreatePostImageUploadUrls$createPostImageUploadUrls$userErrors.fromJson(
                  (e as Map<String, dynamic>),
                ),
          )
          .toList(),
      uploadUrls: (l$uploadUrls as List<dynamic>)
          .map(
            (e) =>
                Mutation$CreatePostImageUploadUrls$createPostImageUploadUrls$uploadUrls.fromJson(
                  (e as Map<String, dynamic>),
                ),
          )
          .toList(),
    );
  }

  final bool success;

  final List<
    Mutation$CreatePostImageUploadUrls$createPostImageUploadUrls$userErrors
  >
  userErrors;

  final List<
    Mutation$CreatePostImageUploadUrls$createPostImageUploadUrls$uploadUrls
  >
  uploadUrls;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$success = success;
    _resultData['success'] = l$success;
    final l$userErrors = userErrors;
    _resultData['userErrors'] = l$userErrors.map((e) => e.toJson()).toList();
    final l$uploadUrls = uploadUrls;
    _resultData['uploadUrls'] = l$uploadUrls.map((e) => e.toJson()).toList();
    return _resultData;
  }

  @override
  int get hashCode {
    final l$success = success;
    final l$userErrors = userErrors;
    final l$uploadUrls = uploadUrls;
    return Object.hashAll([
      l$success,
      Object.hashAll(l$userErrors.map((v) => v)),
      Object.hashAll(l$uploadUrls.map((v) => v)),
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Mutation$CreatePostImageUploadUrls$createPostImageUploadUrls ||
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
    final l$uploadUrls = uploadUrls;
    final lOther$uploadUrls = other.uploadUrls;
    if (l$uploadUrls.length != lOther$uploadUrls.length) {
      return false;
    }
    for (int i = 0; i < l$uploadUrls.length; i++) {
      final l$uploadUrls$entry = l$uploadUrls[i];
      final lOther$uploadUrls$entry = lOther$uploadUrls[i];
      if (l$uploadUrls$entry != lOther$uploadUrls$entry) {
        return false;
      }
    }
    return true;
  }
}

extension UtilityExtension$Mutation$CreatePostImageUploadUrls$createPostImageUploadUrls
    on Mutation$CreatePostImageUploadUrls$createPostImageUploadUrls {
  CopyWith$Mutation$CreatePostImageUploadUrls$createPostImageUploadUrls<
    Mutation$CreatePostImageUploadUrls$createPostImageUploadUrls
  >
  get copyWith =>
      CopyWith$Mutation$CreatePostImageUploadUrls$createPostImageUploadUrls(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Mutation$CreatePostImageUploadUrls$createPostImageUploadUrls<
  TRes
> {
  factory CopyWith$Mutation$CreatePostImageUploadUrls$createPostImageUploadUrls(
    Mutation$CreatePostImageUploadUrls$createPostImageUploadUrls instance,
    TRes Function(Mutation$CreatePostImageUploadUrls$createPostImageUploadUrls)
    then,
  ) = _CopyWithImpl$Mutation$CreatePostImageUploadUrls$createPostImageUploadUrls;

  factory CopyWith$Mutation$CreatePostImageUploadUrls$createPostImageUploadUrls.stub(
    TRes res,
  ) = _CopyWithStubImpl$Mutation$CreatePostImageUploadUrls$createPostImageUploadUrls;

  TRes call({
    bool? success,
    List<
      Mutation$CreatePostImageUploadUrls$createPostImageUploadUrls$userErrors
    >?
    userErrors,
    List<
      Mutation$CreatePostImageUploadUrls$createPostImageUploadUrls$uploadUrls
    >?
    uploadUrls,
  });
  TRes userErrors(
    Iterable<
      Mutation$CreatePostImageUploadUrls$createPostImageUploadUrls$userErrors
    >
    Function(
      Iterable<
        CopyWith$Mutation$CreatePostImageUploadUrls$createPostImageUploadUrls$userErrors<
          Mutation$CreatePostImageUploadUrls$createPostImageUploadUrls$userErrors
        >
      >,
    )
    _fn,
  );
  TRes uploadUrls(
    Iterable<
      Mutation$CreatePostImageUploadUrls$createPostImageUploadUrls$uploadUrls
    >
    Function(
      Iterable<
        CopyWith$Mutation$CreatePostImageUploadUrls$createPostImageUploadUrls$uploadUrls<
          Mutation$CreatePostImageUploadUrls$createPostImageUploadUrls$uploadUrls
        >
      >,
    )
    _fn,
  );
}

class _CopyWithImpl$Mutation$CreatePostImageUploadUrls$createPostImageUploadUrls<
  TRes
>
    implements
        CopyWith$Mutation$CreatePostImageUploadUrls$createPostImageUploadUrls<
          TRes
        > {
  _CopyWithImpl$Mutation$CreatePostImageUploadUrls$createPostImageUploadUrls(
    this._instance,
    this._then,
  );

  final Mutation$CreatePostImageUploadUrls$createPostImageUploadUrls _instance;

  final TRes Function(
    Mutation$CreatePostImageUploadUrls$createPostImageUploadUrls,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? success = _undefined,
    Object? userErrors = _undefined,
    Object? uploadUrls = _undefined,
  }) => _then(
    Mutation$CreatePostImageUploadUrls$createPostImageUploadUrls(
      success: success == _undefined || success == null
          ? _instance.success
          : (success as bool),
      userErrors: userErrors == _undefined || userErrors == null
          ? _instance.userErrors
          : (userErrors
                as List<
                  Mutation$CreatePostImageUploadUrls$createPostImageUploadUrls$userErrors
                >),
      uploadUrls: uploadUrls == _undefined || uploadUrls == null
          ? _instance.uploadUrls
          : (uploadUrls
                as List<
                  Mutation$CreatePostImageUploadUrls$createPostImageUploadUrls$uploadUrls
                >),
    ),
  );

  TRes userErrors(
    Iterable<
      Mutation$CreatePostImageUploadUrls$createPostImageUploadUrls$userErrors
    >
    Function(
      Iterable<
        CopyWith$Mutation$CreatePostImageUploadUrls$createPostImageUploadUrls$userErrors<
          Mutation$CreatePostImageUploadUrls$createPostImageUploadUrls$userErrors
        >
      >,
    )
    _fn,
  ) => call(
    userErrors: _fn(
      _instance.userErrors.map(
        (e) =>
            CopyWith$Mutation$CreatePostImageUploadUrls$createPostImageUploadUrls$userErrors(
              e,
              (i) => i,
            ),
      ),
    ).toList(),
  );

  TRes uploadUrls(
    Iterable<
      Mutation$CreatePostImageUploadUrls$createPostImageUploadUrls$uploadUrls
    >
    Function(
      Iterable<
        CopyWith$Mutation$CreatePostImageUploadUrls$createPostImageUploadUrls$uploadUrls<
          Mutation$CreatePostImageUploadUrls$createPostImageUploadUrls$uploadUrls
        >
      >,
    )
    _fn,
  ) => call(
    uploadUrls: _fn(
      _instance.uploadUrls.map(
        (e) =>
            CopyWith$Mutation$CreatePostImageUploadUrls$createPostImageUploadUrls$uploadUrls(
              e,
              (i) => i,
            ),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl$Mutation$CreatePostImageUploadUrls$createPostImageUploadUrls<
  TRes
>
    implements
        CopyWith$Mutation$CreatePostImageUploadUrls$createPostImageUploadUrls<
          TRes
        > {
  _CopyWithStubImpl$Mutation$CreatePostImageUploadUrls$createPostImageUploadUrls(
    this._res,
  );

  TRes _res;

  call({
    bool? success,
    List<
      Mutation$CreatePostImageUploadUrls$createPostImageUploadUrls$userErrors
    >?
    userErrors,
    List<
      Mutation$CreatePostImageUploadUrls$createPostImageUploadUrls$uploadUrls
    >?
    uploadUrls,
  }) => _res;

  userErrors(_fn) => _res;

  uploadUrls(_fn) => _res;
}

class Mutation$CreatePostImageUploadUrls$createPostImageUploadUrls$userErrors {
  Mutation$CreatePostImageUploadUrls$createPostImageUploadUrls$userErrors({
    required this.code,
    required this.message,
    this.field,
  });

  factory Mutation$CreatePostImageUploadUrls$createPostImageUploadUrls$userErrors.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$code = json['code'];
    final l$message = json['message'];
    final l$field = json['field'];
    return Mutation$CreatePostImageUploadUrls$createPostImageUploadUrls$userErrors(
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
    if (other
            is! Mutation$CreatePostImageUploadUrls$createPostImageUploadUrls$userErrors ||
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

extension UtilityExtension$Mutation$CreatePostImageUploadUrls$createPostImageUploadUrls$userErrors
    on Mutation$CreatePostImageUploadUrls$createPostImageUploadUrls$userErrors {
  CopyWith$Mutation$CreatePostImageUploadUrls$createPostImageUploadUrls$userErrors<
    Mutation$CreatePostImageUploadUrls$createPostImageUploadUrls$userErrors
  >
  get copyWith =>
      CopyWith$Mutation$CreatePostImageUploadUrls$createPostImageUploadUrls$userErrors(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Mutation$CreatePostImageUploadUrls$createPostImageUploadUrls$userErrors<
  TRes
> {
  factory CopyWith$Mutation$CreatePostImageUploadUrls$createPostImageUploadUrls$userErrors(
    Mutation$CreatePostImageUploadUrls$createPostImageUploadUrls$userErrors
    instance,
    TRes Function(
      Mutation$CreatePostImageUploadUrls$createPostImageUploadUrls$userErrors,
    )
    then,
  ) = _CopyWithImpl$Mutation$CreatePostImageUploadUrls$createPostImageUploadUrls$userErrors;

  factory CopyWith$Mutation$CreatePostImageUploadUrls$createPostImageUploadUrls$userErrors.stub(
    TRes res,
  ) = _CopyWithStubImpl$Mutation$CreatePostImageUploadUrls$createPostImageUploadUrls$userErrors;

  TRes call({String? code, String? message, String? field});
}

class _CopyWithImpl$Mutation$CreatePostImageUploadUrls$createPostImageUploadUrls$userErrors<
  TRes
>
    implements
        CopyWith$Mutation$CreatePostImageUploadUrls$createPostImageUploadUrls$userErrors<
          TRes
        > {
  _CopyWithImpl$Mutation$CreatePostImageUploadUrls$createPostImageUploadUrls$userErrors(
    this._instance,
    this._then,
  );

  final Mutation$CreatePostImageUploadUrls$createPostImageUploadUrls$userErrors
  _instance;

  final TRes Function(
    Mutation$CreatePostImageUploadUrls$createPostImageUploadUrls$userErrors,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? code = _undefined,
    Object? message = _undefined,
    Object? field = _undefined,
  }) => _then(
    Mutation$CreatePostImageUploadUrls$createPostImageUploadUrls$userErrors(
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

class _CopyWithStubImpl$Mutation$CreatePostImageUploadUrls$createPostImageUploadUrls$userErrors<
  TRes
>
    implements
        CopyWith$Mutation$CreatePostImageUploadUrls$createPostImageUploadUrls$userErrors<
          TRes
        > {
  _CopyWithStubImpl$Mutation$CreatePostImageUploadUrls$createPostImageUploadUrls$userErrors(
    this._res,
  );

  TRes _res;

  call({String? code, String? message, String? field}) => _res;
}

class Mutation$CreatePostImageUploadUrls$createPostImageUploadUrls$uploadUrls {
  Mutation$CreatePostImageUploadUrls$createPostImageUploadUrls$uploadUrls({
    required this.uploadUrl,
    required this.objectKey,
    required this.expiresAt,
  });

  factory Mutation$CreatePostImageUploadUrls$createPostImageUploadUrls$uploadUrls.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$uploadUrl = json['uploadUrl'];
    final l$objectKey = json['objectKey'];
    final l$expiresAt = json['expiresAt'];
    return Mutation$CreatePostImageUploadUrls$createPostImageUploadUrls$uploadUrls(
      uploadUrl: (l$uploadUrl as String),
      objectKey: (l$objectKey as String),
      expiresAt: (l$expiresAt as String),
    );
  }

  final String uploadUrl;

  final String objectKey;

  final String expiresAt;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$uploadUrl = uploadUrl;
    _resultData['uploadUrl'] = l$uploadUrl;
    final l$objectKey = objectKey;
    _resultData['objectKey'] = l$objectKey;
    final l$expiresAt = expiresAt;
    _resultData['expiresAt'] = l$expiresAt;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$uploadUrl = uploadUrl;
    final l$objectKey = objectKey;
    final l$expiresAt = expiresAt;
    return Object.hashAll([l$uploadUrl, l$objectKey, l$expiresAt]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Mutation$CreatePostImageUploadUrls$createPostImageUploadUrls$uploadUrls ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$uploadUrl = uploadUrl;
    final lOther$uploadUrl = other.uploadUrl;
    if (l$uploadUrl != lOther$uploadUrl) {
      return false;
    }
    final l$objectKey = objectKey;
    final lOther$objectKey = other.objectKey;
    if (l$objectKey != lOther$objectKey) {
      return false;
    }
    final l$expiresAt = expiresAt;
    final lOther$expiresAt = other.expiresAt;
    if (l$expiresAt != lOther$expiresAt) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Mutation$CreatePostImageUploadUrls$createPostImageUploadUrls$uploadUrls
    on Mutation$CreatePostImageUploadUrls$createPostImageUploadUrls$uploadUrls {
  CopyWith$Mutation$CreatePostImageUploadUrls$createPostImageUploadUrls$uploadUrls<
    Mutation$CreatePostImageUploadUrls$createPostImageUploadUrls$uploadUrls
  >
  get copyWith =>
      CopyWith$Mutation$CreatePostImageUploadUrls$createPostImageUploadUrls$uploadUrls(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Mutation$CreatePostImageUploadUrls$createPostImageUploadUrls$uploadUrls<
  TRes
> {
  factory CopyWith$Mutation$CreatePostImageUploadUrls$createPostImageUploadUrls$uploadUrls(
    Mutation$CreatePostImageUploadUrls$createPostImageUploadUrls$uploadUrls
    instance,
    TRes Function(
      Mutation$CreatePostImageUploadUrls$createPostImageUploadUrls$uploadUrls,
    )
    then,
  ) = _CopyWithImpl$Mutation$CreatePostImageUploadUrls$createPostImageUploadUrls$uploadUrls;

  factory CopyWith$Mutation$CreatePostImageUploadUrls$createPostImageUploadUrls$uploadUrls.stub(
    TRes res,
  ) = _CopyWithStubImpl$Mutation$CreatePostImageUploadUrls$createPostImageUploadUrls$uploadUrls;

  TRes call({String? uploadUrl, String? objectKey, String? expiresAt});
}

class _CopyWithImpl$Mutation$CreatePostImageUploadUrls$createPostImageUploadUrls$uploadUrls<
  TRes
>
    implements
        CopyWith$Mutation$CreatePostImageUploadUrls$createPostImageUploadUrls$uploadUrls<
          TRes
        > {
  _CopyWithImpl$Mutation$CreatePostImageUploadUrls$createPostImageUploadUrls$uploadUrls(
    this._instance,
    this._then,
  );

  final Mutation$CreatePostImageUploadUrls$createPostImageUploadUrls$uploadUrls
  _instance;

  final TRes Function(
    Mutation$CreatePostImageUploadUrls$createPostImageUploadUrls$uploadUrls,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? uploadUrl = _undefined,
    Object? objectKey = _undefined,
    Object? expiresAt = _undefined,
  }) => _then(
    Mutation$CreatePostImageUploadUrls$createPostImageUploadUrls$uploadUrls(
      uploadUrl: uploadUrl == _undefined || uploadUrl == null
          ? _instance.uploadUrl
          : (uploadUrl as String),
      objectKey: objectKey == _undefined || objectKey == null
          ? _instance.objectKey
          : (objectKey as String),
      expiresAt: expiresAt == _undefined || expiresAt == null
          ? _instance.expiresAt
          : (expiresAt as String),
    ),
  );
}

class _CopyWithStubImpl$Mutation$CreatePostImageUploadUrls$createPostImageUploadUrls$uploadUrls<
  TRes
>
    implements
        CopyWith$Mutation$CreatePostImageUploadUrls$createPostImageUploadUrls$uploadUrls<
          TRes
        > {
  _CopyWithStubImpl$Mutation$CreatePostImageUploadUrls$createPostImageUploadUrls$uploadUrls(
    this._res,
  );

  TRes _res;

  call({String? uploadUrl, String? objectKey, String? expiresAt}) => _res;
}

class Variables$Mutation$ConfirmPostImageUploads {
  factory Variables$Mutation$ConfirmPostImageUploads({
    required List<String> objectKeys,
  }) =>
      Variables$Mutation$ConfirmPostImageUploads._({r'objectKeys': objectKeys});

  Variables$Mutation$ConfirmPostImageUploads._(this._$data);

  factory Variables$Mutation$ConfirmPostImageUploads.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    final l$objectKeys = data['objectKeys'];
    result$data['objectKeys'] = (l$objectKeys as List<dynamic>)
        .map((e) => (e as String))
        .toList();
    return Variables$Mutation$ConfirmPostImageUploads._(result$data);
  }

  Map<String, dynamic> _$data;

  List<String> get objectKeys => (_$data['objectKeys'] as List<String>);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$objectKeys = objectKeys;
    result$data['objectKeys'] = l$objectKeys.map((e) => e).toList();
    return result$data;
  }

  CopyWith$Variables$Mutation$ConfirmPostImageUploads<
    Variables$Mutation$ConfirmPostImageUploads
  >
  get copyWith =>
      CopyWith$Variables$Mutation$ConfirmPostImageUploads(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Mutation$ConfirmPostImageUploads ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$objectKeys = objectKeys;
    final lOther$objectKeys = other.objectKeys;
    if (l$objectKeys.length != lOther$objectKeys.length) {
      return false;
    }
    for (int i = 0; i < l$objectKeys.length; i++) {
      final l$objectKeys$entry = l$objectKeys[i];
      final lOther$objectKeys$entry = lOther$objectKeys[i];
      if (l$objectKeys$entry != lOther$objectKeys$entry) {
        return false;
      }
    }
    return true;
  }

  @override
  int get hashCode {
    final l$objectKeys = objectKeys;
    return Object.hashAll([Object.hashAll(l$objectKeys.map((v) => v))]);
  }
}

abstract class CopyWith$Variables$Mutation$ConfirmPostImageUploads<TRes> {
  factory CopyWith$Variables$Mutation$ConfirmPostImageUploads(
    Variables$Mutation$ConfirmPostImageUploads instance,
    TRes Function(Variables$Mutation$ConfirmPostImageUploads) then,
  ) = _CopyWithImpl$Variables$Mutation$ConfirmPostImageUploads;

  factory CopyWith$Variables$Mutation$ConfirmPostImageUploads.stub(TRes res) =
      _CopyWithStubImpl$Variables$Mutation$ConfirmPostImageUploads;

  TRes call({List<String>? objectKeys});
}

class _CopyWithImpl$Variables$Mutation$ConfirmPostImageUploads<TRes>
    implements CopyWith$Variables$Mutation$ConfirmPostImageUploads<TRes> {
  _CopyWithImpl$Variables$Mutation$ConfirmPostImageUploads(
    this._instance,
    this._then,
  );

  final Variables$Mutation$ConfirmPostImageUploads _instance;

  final TRes Function(Variables$Mutation$ConfirmPostImageUploads) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? objectKeys = _undefined}) => _then(
    Variables$Mutation$ConfirmPostImageUploads._({
      ..._instance._$data,
      if (objectKeys != _undefined && objectKeys != null)
        'objectKeys': (objectKeys as List<String>),
    }),
  );
}

class _CopyWithStubImpl$Variables$Mutation$ConfirmPostImageUploads<TRes>
    implements CopyWith$Variables$Mutation$ConfirmPostImageUploads<TRes> {
  _CopyWithStubImpl$Variables$Mutation$ConfirmPostImageUploads(this._res);

  TRes _res;

  call({List<String>? objectKeys}) => _res;
}

class Mutation$ConfirmPostImageUploads {
  Mutation$ConfirmPostImageUploads({required this.confirmPostImageUploads});

  factory Mutation$ConfirmPostImageUploads.fromJson(Map<String, dynamic> json) {
    final l$confirmPostImageUploads = json['confirmPostImageUploads'];
    return Mutation$ConfirmPostImageUploads(
      confirmPostImageUploads:
          Mutation$ConfirmPostImageUploads$confirmPostImageUploads.fromJson(
            (l$confirmPostImageUploads as Map<String, dynamic>),
          ),
    );
  }

  final Mutation$ConfirmPostImageUploads$confirmPostImageUploads
  confirmPostImageUploads;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$confirmPostImageUploads = confirmPostImageUploads;
    _resultData['confirmPostImageUploads'] = l$confirmPostImageUploads.toJson();
    return _resultData;
  }

  @override
  int get hashCode {
    final l$confirmPostImageUploads = confirmPostImageUploads;
    return Object.hashAll([l$confirmPostImageUploads]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$ConfirmPostImageUploads ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$confirmPostImageUploads = confirmPostImageUploads;
    final lOther$confirmPostImageUploads = other.confirmPostImageUploads;
    if (l$confirmPostImageUploads != lOther$confirmPostImageUploads) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Mutation$ConfirmPostImageUploads
    on Mutation$ConfirmPostImageUploads {
  CopyWith$Mutation$ConfirmPostImageUploads<Mutation$ConfirmPostImageUploads>
  get copyWith => CopyWith$Mutation$ConfirmPostImageUploads(this, (i) => i);
}

abstract class CopyWith$Mutation$ConfirmPostImageUploads<TRes> {
  factory CopyWith$Mutation$ConfirmPostImageUploads(
    Mutation$ConfirmPostImageUploads instance,
    TRes Function(Mutation$ConfirmPostImageUploads) then,
  ) = _CopyWithImpl$Mutation$ConfirmPostImageUploads;

  factory CopyWith$Mutation$ConfirmPostImageUploads.stub(TRes res) =
      _CopyWithStubImpl$Mutation$ConfirmPostImageUploads;

  TRes call({
    Mutation$ConfirmPostImageUploads$confirmPostImageUploads?
    confirmPostImageUploads,
  });
  CopyWith$Mutation$ConfirmPostImageUploads$confirmPostImageUploads<TRes>
  get confirmPostImageUploads;
}

class _CopyWithImpl$Mutation$ConfirmPostImageUploads<TRes>
    implements CopyWith$Mutation$ConfirmPostImageUploads<TRes> {
  _CopyWithImpl$Mutation$ConfirmPostImageUploads(this._instance, this._then);

  final Mutation$ConfirmPostImageUploads _instance;

  final TRes Function(Mutation$ConfirmPostImageUploads) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? confirmPostImageUploads = _undefined}) => _then(
    Mutation$ConfirmPostImageUploads(
      confirmPostImageUploads:
          confirmPostImageUploads == _undefined ||
              confirmPostImageUploads == null
          ? _instance.confirmPostImageUploads
          : (confirmPostImageUploads
                as Mutation$ConfirmPostImageUploads$confirmPostImageUploads),
    ),
  );

  CopyWith$Mutation$ConfirmPostImageUploads$confirmPostImageUploads<TRes>
  get confirmPostImageUploads {
    final local$confirmPostImageUploads = _instance.confirmPostImageUploads;
    return CopyWith$Mutation$ConfirmPostImageUploads$confirmPostImageUploads(
      local$confirmPostImageUploads,
      (e) => call(confirmPostImageUploads: e),
    );
  }
}

class _CopyWithStubImpl$Mutation$ConfirmPostImageUploads<TRes>
    implements CopyWith$Mutation$ConfirmPostImageUploads<TRes> {
  _CopyWithStubImpl$Mutation$ConfirmPostImageUploads(this._res);

  TRes _res;

  call({
    Mutation$ConfirmPostImageUploads$confirmPostImageUploads?
    confirmPostImageUploads,
  }) => _res;

  CopyWith$Mutation$ConfirmPostImageUploads$confirmPostImageUploads<TRes>
  get confirmPostImageUploads =>
      CopyWith$Mutation$ConfirmPostImageUploads$confirmPostImageUploads.stub(
        _res,
      );
}

const documentNodeMutationConfirmPostImageUploads = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'ConfirmPostImageUploads'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'objectKeys')),
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
            name: NameNode(value: 'confirmPostImageUploads'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'input'),
                value: ObjectValueNode(
                  fields: [
                    ObjectFieldNode(
                      name: NameNode(value: 'objectKeys'),
                      value: VariableNode(name: NameNode(value: 'objectKeys')),
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
                  name: NameNode(value: 'confirmed'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: 'failed'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: SelectionSetNode(
                    selections: [
                      FieldNode(
                        name: NameNode(value: 'objectKey'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'code'),
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

class Mutation$ConfirmPostImageUploads$confirmPostImageUploads {
  Mutation$ConfirmPostImageUploads$confirmPostImageUploads({
    required this.success,
    required this.userErrors,
    required this.confirmed,
    required this.failed,
  });

  factory Mutation$ConfirmPostImageUploads$confirmPostImageUploads.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$success = json['success'];
    final l$userErrors = json['userErrors'];
    final l$confirmed = json['confirmed'];
    final l$failed = json['failed'];
    return Mutation$ConfirmPostImageUploads$confirmPostImageUploads(
      success: (l$success as bool),
      userErrors: (l$userErrors as List<dynamic>)
          .map(
            (e) =>
                Mutation$ConfirmPostImageUploads$confirmPostImageUploads$userErrors.fromJson(
                  (e as Map<String, dynamic>),
                ),
          )
          .toList(),
      confirmed: (l$confirmed as List<dynamic>)
          .map((e) => (e as String))
          .toList(),
      failed: (l$failed as List<dynamic>)
          .map(
            (e) =>
                Mutation$ConfirmPostImageUploads$confirmPostImageUploads$failed.fromJson(
                  (e as Map<String, dynamic>),
                ),
          )
          .toList(),
    );
  }

  final bool success;

  final List<
    Mutation$ConfirmPostImageUploads$confirmPostImageUploads$userErrors
  >
  userErrors;

  final List<String> confirmed;

  final List<Mutation$ConfirmPostImageUploads$confirmPostImageUploads$failed>
  failed;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$success = success;
    _resultData['success'] = l$success;
    final l$userErrors = userErrors;
    _resultData['userErrors'] = l$userErrors.map((e) => e.toJson()).toList();
    final l$confirmed = confirmed;
    _resultData['confirmed'] = l$confirmed.map((e) => e).toList();
    final l$failed = failed;
    _resultData['failed'] = l$failed.map((e) => e.toJson()).toList();
    return _resultData;
  }

  @override
  int get hashCode {
    final l$success = success;
    final l$userErrors = userErrors;
    final l$confirmed = confirmed;
    final l$failed = failed;
    return Object.hashAll([
      l$success,
      Object.hashAll(l$userErrors.map((v) => v)),
      Object.hashAll(l$confirmed.map((v) => v)),
      Object.hashAll(l$failed.map((v) => v)),
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$ConfirmPostImageUploads$confirmPostImageUploads ||
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
    final l$confirmed = confirmed;
    final lOther$confirmed = other.confirmed;
    if (l$confirmed.length != lOther$confirmed.length) {
      return false;
    }
    for (int i = 0; i < l$confirmed.length; i++) {
      final l$confirmed$entry = l$confirmed[i];
      final lOther$confirmed$entry = lOther$confirmed[i];
      if (l$confirmed$entry != lOther$confirmed$entry) {
        return false;
      }
    }
    final l$failed = failed;
    final lOther$failed = other.failed;
    if (l$failed.length != lOther$failed.length) {
      return false;
    }
    for (int i = 0; i < l$failed.length; i++) {
      final l$failed$entry = l$failed[i];
      final lOther$failed$entry = lOther$failed[i];
      if (l$failed$entry != lOther$failed$entry) {
        return false;
      }
    }
    return true;
  }
}

extension UtilityExtension$Mutation$ConfirmPostImageUploads$confirmPostImageUploads
    on Mutation$ConfirmPostImageUploads$confirmPostImageUploads {
  CopyWith$Mutation$ConfirmPostImageUploads$confirmPostImageUploads<
    Mutation$ConfirmPostImageUploads$confirmPostImageUploads
  >
  get copyWith =>
      CopyWith$Mutation$ConfirmPostImageUploads$confirmPostImageUploads(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Mutation$ConfirmPostImageUploads$confirmPostImageUploads<
  TRes
> {
  factory CopyWith$Mutation$ConfirmPostImageUploads$confirmPostImageUploads(
    Mutation$ConfirmPostImageUploads$confirmPostImageUploads instance,
    TRes Function(Mutation$ConfirmPostImageUploads$confirmPostImageUploads)
    then,
  ) = _CopyWithImpl$Mutation$ConfirmPostImageUploads$confirmPostImageUploads;

  factory CopyWith$Mutation$ConfirmPostImageUploads$confirmPostImageUploads.stub(
    TRes res,
  ) = _CopyWithStubImpl$Mutation$ConfirmPostImageUploads$confirmPostImageUploads;

  TRes call({
    bool? success,
    List<Mutation$ConfirmPostImageUploads$confirmPostImageUploads$userErrors>?
    userErrors,
    List<String>? confirmed,
    List<Mutation$ConfirmPostImageUploads$confirmPostImageUploads$failed>?
    failed,
  });
  TRes userErrors(
    Iterable<
      Mutation$ConfirmPostImageUploads$confirmPostImageUploads$userErrors
    >
    Function(
      Iterable<
        CopyWith$Mutation$ConfirmPostImageUploads$confirmPostImageUploads$userErrors<
          Mutation$ConfirmPostImageUploads$confirmPostImageUploads$userErrors
        >
      >,
    )
    _fn,
  );
  TRes failed(
    Iterable<Mutation$ConfirmPostImageUploads$confirmPostImageUploads$failed>
    Function(
      Iterable<
        CopyWith$Mutation$ConfirmPostImageUploads$confirmPostImageUploads$failed<
          Mutation$ConfirmPostImageUploads$confirmPostImageUploads$failed
        >
      >,
    )
    _fn,
  );
}

class _CopyWithImpl$Mutation$ConfirmPostImageUploads$confirmPostImageUploads<
  TRes
>
    implements
        CopyWith$Mutation$ConfirmPostImageUploads$confirmPostImageUploads<
          TRes
        > {
  _CopyWithImpl$Mutation$ConfirmPostImageUploads$confirmPostImageUploads(
    this._instance,
    this._then,
  );

  final Mutation$ConfirmPostImageUploads$confirmPostImageUploads _instance;

  final TRes Function(Mutation$ConfirmPostImageUploads$confirmPostImageUploads)
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? success = _undefined,
    Object? userErrors = _undefined,
    Object? confirmed = _undefined,
    Object? failed = _undefined,
  }) => _then(
    Mutation$ConfirmPostImageUploads$confirmPostImageUploads(
      success: success == _undefined || success == null
          ? _instance.success
          : (success as bool),
      userErrors: userErrors == _undefined || userErrors == null
          ? _instance.userErrors
          : (userErrors
                as List<
                  Mutation$ConfirmPostImageUploads$confirmPostImageUploads$userErrors
                >),
      confirmed: confirmed == _undefined || confirmed == null
          ? _instance.confirmed
          : (confirmed as List<String>),
      failed: failed == _undefined || failed == null
          ? _instance.failed
          : (failed
                as List<
                  Mutation$ConfirmPostImageUploads$confirmPostImageUploads$failed
                >),
    ),
  );

  TRes userErrors(
    Iterable<
      Mutation$ConfirmPostImageUploads$confirmPostImageUploads$userErrors
    >
    Function(
      Iterable<
        CopyWith$Mutation$ConfirmPostImageUploads$confirmPostImageUploads$userErrors<
          Mutation$ConfirmPostImageUploads$confirmPostImageUploads$userErrors
        >
      >,
    )
    _fn,
  ) => call(
    userErrors: _fn(
      _instance.userErrors.map(
        (e) =>
            CopyWith$Mutation$ConfirmPostImageUploads$confirmPostImageUploads$userErrors(
              e,
              (i) => i,
            ),
      ),
    ).toList(),
  );

  TRes failed(
    Iterable<Mutation$ConfirmPostImageUploads$confirmPostImageUploads$failed>
    Function(
      Iterable<
        CopyWith$Mutation$ConfirmPostImageUploads$confirmPostImageUploads$failed<
          Mutation$ConfirmPostImageUploads$confirmPostImageUploads$failed
        >
      >,
    )
    _fn,
  ) => call(
    failed: _fn(
      _instance.failed.map(
        (e) =>
            CopyWith$Mutation$ConfirmPostImageUploads$confirmPostImageUploads$failed(
              e,
              (i) => i,
            ),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl$Mutation$ConfirmPostImageUploads$confirmPostImageUploads<
  TRes
>
    implements
        CopyWith$Mutation$ConfirmPostImageUploads$confirmPostImageUploads<
          TRes
        > {
  _CopyWithStubImpl$Mutation$ConfirmPostImageUploads$confirmPostImageUploads(
    this._res,
  );

  TRes _res;

  call({
    bool? success,
    List<Mutation$ConfirmPostImageUploads$confirmPostImageUploads$userErrors>?
    userErrors,
    List<String>? confirmed,
    List<Mutation$ConfirmPostImageUploads$confirmPostImageUploads$failed>?
    failed,
  }) => _res;

  userErrors(_fn) => _res;

  failed(_fn) => _res;
}

class Mutation$ConfirmPostImageUploads$confirmPostImageUploads$userErrors {
  Mutation$ConfirmPostImageUploads$confirmPostImageUploads$userErrors({
    required this.code,
    required this.message,
    this.field,
  });

  factory Mutation$ConfirmPostImageUploads$confirmPostImageUploads$userErrors.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$code = json['code'];
    final l$message = json['message'];
    final l$field = json['field'];
    return Mutation$ConfirmPostImageUploads$confirmPostImageUploads$userErrors(
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
    if (other
            is! Mutation$ConfirmPostImageUploads$confirmPostImageUploads$userErrors ||
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

extension UtilityExtension$Mutation$ConfirmPostImageUploads$confirmPostImageUploads$userErrors
    on Mutation$ConfirmPostImageUploads$confirmPostImageUploads$userErrors {
  CopyWith$Mutation$ConfirmPostImageUploads$confirmPostImageUploads$userErrors<
    Mutation$ConfirmPostImageUploads$confirmPostImageUploads$userErrors
  >
  get copyWith =>
      CopyWith$Mutation$ConfirmPostImageUploads$confirmPostImageUploads$userErrors(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Mutation$ConfirmPostImageUploads$confirmPostImageUploads$userErrors<
  TRes
> {
  factory CopyWith$Mutation$ConfirmPostImageUploads$confirmPostImageUploads$userErrors(
    Mutation$ConfirmPostImageUploads$confirmPostImageUploads$userErrors
    instance,
    TRes Function(
      Mutation$ConfirmPostImageUploads$confirmPostImageUploads$userErrors,
    )
    then,
  ) = _CopyWithImpl$Mutation$ConfirmPostImageUploads$confirmPostImageUploads$userErrors;

  factory CopyWith$Mutation$ConfirmPostImageUploads$confirmPostImageUploads$userErrors.stub(
    TRes res,
  ) = _CopyWithStubImpl$Mutation$ConfirmPostImageUploads$confirmPostImageUploads$userErrors;

  TRes call({String? code, String? message, String? field});
}

class _CopyWithImpl$Mutation$ConfirmPostImageUploads$confirmPostImageUploads$userErrors<
  TRes
>
    implements
        CopyWith$Mutation$ConfirmPostImageUploads$confirmPostImageUploads$userErrors<
          TRes
        > {
  _CopyWithImpl$Mutation$ConfirmPostImageUploads$confirmPostImageUploads$userErrors(
    this._instance,
    this._then,
  );

  final Mutation$ConfirmPostImageUploads$confirmPostImageUploads$userErrors
  _instance;

  final TRes Function(
    Mutation$ConfirmPostImageUploads$confirmPostImageUploads$userErrors,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? code = _undefined,
    Object? message = _undefined,
    Object? field = _undefined,
  }) => _then(
    Mutation$ConfirmPostImageUploads$confirmPostImageUploads$userErrors(
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

class _CopyWithStubImpl$Mutation$ConfirmPostImageUploads$confirmPostImageUploads$userErrors<
  TRes
>
    implements
        CopyWith$Mutation$ConfirmPostImageUploads$confirmPostImageUploads$userErrors<
          TRes
        > {
  _CopyWithStubImpl$Mutation$ConfirmPostImageUploads$confirmPostImageUploads$userErrors(
    this._res,
  );

  TRes _res;

  call({String? code, String? message, String? field}) => _res;
}

class Mutation$ConfirmPostImageUploads$confirmPostImageUploads$failed {
  Mutation$ConfirmPostImageUploads$confirmPostImageUploads$failed({
    required this.objectKey,
    required this.code,
  });

  factory Mutation$ConfirmPostImageUploads$confirmPostImageUploads$failed.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$objectKey = json['objectKey'];
    final l$code = json['code'];
    return Mutation$ConfirmPostImageUploads$confirmPostImageUploads$failed(
      objectKey: (l$objectKey as String),
      code: (l$code as String),
    );
  }

  final String objectKey;

  final String code;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$objectKey = objectKey;
    _resultData['objectKey'] = l$objectKey;
    final l$code = code;
    _resultData['code'] = l$code;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$objectKey = objectKey;
    final l$code = code;
    return Object.hashAll([l$objectKey, l$code]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Mutation$ConfirmPostImageUploads$confirmPostImageUploads$failed ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$objectKey = objectKey;
    final lOther$objectKey = other.objectKey;
    if (l$objectKey != lOther$objectKey) {
      return false;
    }
    final l$code = code;
    final lOther$code = other.code;
    if (l$code != lOther$code) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Mutation$ConfirmPostImageUploads$confirmPostImageUploads$failed
    on Mutation$ConfirmPostImageUploads$confirmPostImageUploads$failed {
  CopyWith$Mutation$ConfirmPostImageUploads$confirmPostImageUploads$failed<
    Mutation$ConfirmPostImageUploads$confirmPostImageUploads$failed
  >
  get copyWith =>
      CopyWith$Mutation$ConfirmPostImageUploads$confirmPostImageUploads$failed(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Mutation$ConfirmPostImageUploads$confirmPostImageUploads$failed<
  TRes
> {
  factory CopyWith$Mutation$ConfirmPostImageUploads$confirmPostImageUploads$failed(
    Mutation$ConfirmPostImageUploads$confirmPostImageUploads$failed instance,
    TRes Function(
      Mutation$ConfirmPostImageUploads$confirmPostImageUploads$failed,
    )
    then,
  ) = _CopyWithImpl$Mutation$ConfirmPostImageUploads$confirmPostImageUploads$failed;

  factory CopyWith$Mutation$ConfirmPostImageUploads$confirmPostImageUploads$failed.stub(
    TRes res,
  ) = _CopyWithStubImpl$Mutation$ConfirmPostImageUploads$confirmPostImageUploads$failed;

  TRes call({String? objectKey, String? code});
}

class _CopyWithImpl$Mutation$ConfirmPostImageUploads$confirmPostImageUploads$failed<
  TRes
>
    implements
        CopyWith$Mutation$ConfirmPostImageUploads$confirmPostImageUploads$failed<
          TRes
        > {
  _CopyWithImpl$Mutation$ConfirmPostImageUploads$confirmPostImageUploads$failed(
    this._instance,
    this._then,
  );

  final Mutation$ConfirmPostImageUploads$confirmPostImageUploads$failed
  _instance;

  final TRes Function(
    Mutation$ConfirmPostImageUploads$confirmPostImageUploads$failed,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? objectKey = _undefined, Object? code = _undefined}) =>
      _then(
        Mutation$ConfirmPostImageUploads$confirmPostImageUploads$failed(
          objectKey: objectKey == _undefined || objectKey == null
              ? _instance.objectKey
              : (objectKey as String),
          code: code == _undefined || code == null
              ? _instance.code
              : (code as String),
        ),
      );
}

class _CopyWithStubImpl$Mutation$ConfirmPostImageUploads$confirmPostImageUploads$failed<
  TRes
>
    implements
        CopyWith$Mutation$ConfirmPostImageUploads$confirmPostImageUploads$failed<
          TRes
        > {
  _CopyWithStubImpl$Mutation$ConfirmPostImageUploads$confirmPostImageUploads$failed(
    this._res,
  );

  TRes _res;

  call({String? objectKey, String? code}) => _res;
}

class Variables$Mutation$DeletePostImage {
  factory Variables$Mutation$DeletePostImage({required String objectKey}) =>
      Variables$Mutation$DeletePostImage._({r'objectKey': objectKey});

  Variables$Mutation$DeletePostImage._(this._$data);

  factory Variables$Mutation$DeletePostImage.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    final l$objectKey = data['objectKey'];
    result$data['objectKey'] = (l$objectKey as String);
    return Variables$Mutation$DeletePostImage._(result$data);
  }

  Map<String, dynamic> _$data;

  String get objectKey => (_$data['objectKey'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$objectKey = objectKey;
    result$data['objectKey'] = l$objectKey;
    return result$data;
  }

  CopyWith$Variables$Mutation$DeletePostImage<
    Variables$Mutation$DeletePostImage
  >
  get copyWith => CopyWith$Variables$Mutation$DeletePostImage(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Mutation$DeletePostImage ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$objectKey = objectKey;
    final lOther$objectKey = other.objectKey;
    if (l$objectKey != lOther$objectKey) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$objectKey = objectKey;
    return Object.hashAll([l$objectKey]);
  }
}

abstract class CopyWith$Variables$Mutation$DeletePostImage<TRes> {
  factory CopyWith$Variables$Mutation$DeletePostImage(
    Variables$Mutation$DeletePostImage instance,
    TRes Function(Variables$Mutation$DeletePostImage) then,
  ) = _CopyWithImpl$Variables$Mutation$DeletePostImage;

  factory CopyWith$Variables$Mutation$DeletePostImage.stub(TRes res) =
      _CopyWithStubImpl$Variables$Mutation$DeletePostImage;

  TRes call({String? objectKey});
}

class _CopyWithImpl$Variables$Mutation$DeletePostImage<TRes>
    implements CopyWith$Variables$Mutation$DeletePostImage<TRes> {
  _CopyWithImpl$Variables$Mutation$DeletePostImage(this._instance, this._then);

  final Variables$Mutation$DeletePostImage _instance;

  final TRes Function(Variables$Mutation$DeletePostImage) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? objectKey = _undefined}) => _then(
    Variables$Mutation$DeletePostImage._({
      ..._instance._$data,
      if (objectKey != _undefined && objectKey != null)
        'objectKey': (objectKey as String),
    }),
  );
}

class _CopyWithStubImpl$Variables$Mutation$DeletePostImage<TRes>
    implements CopyWith$Variables$Mutation$DeletePostImage<TRes> {
  _CopyWithStubImpl$Variables$Mutation$DeletePostImage(this._res);

  TRes _res;

  call({String? objectKey}) => _res;
}

class Mutation$DeletePostImage {
  Mutation$DeletePostImage({required this.deletePostImage});

  factory Mutation$DeletePostImage.fromJson(Map<String, dynamic> json) {
    final l$deletePostImage = json['deletePostImage'];
    return Mutation$DeletePostImage(
      deletePostImage: Mutation$DeletePostImage$deletePostImage.fromJson(
        (l$deletePostImage as Map<String, dynamic>),
      ),
    );
  }

  final Mutation$DeletePostImage$deletePostImage deletePostImage;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$deletePostImage = deletePostImage;
    _resultData['deletePostImage'] = l$deletePostImage.toJson();
    return _resultData;
  }

  @override
  int get hashCode {
    final l$deletePostImage = deletePostImage;
    return Object.hashAll([l$deletePostImage]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$DeletePostImage ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$deletePostImage = deletePostImage;
    final lOther$deletePostImage = other.deletePostImage;
    if (l$deletePostImage != lOther$deletePostImage) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Mutation$DeletePostImage
    on Mutation$DeletePostImage {
  CopyWith$Mutation$DeletePostImage<Mutation$DeletePostImage> get copyWith =>
      CopyWith$Mutation$DeletePostImage(this, (i) => i);
}

abstract class CopyWith$Mutation$DeletePostImage<TRes> {
  factory CopyWith$Mutation$DeletePostImage(
    Mutation$DeletePostImage instance,
    TRes Function(Mutation$DeletePostImage) then,
  ) = _CopyWithImpl$Mutation$DeletePostImage;

  factory CopyWith$Mutation$DeletePostImage.stub(TRes res) =
      _CopyWithStubImpl$Mutation$DeletePostImage;

  TRes call({Mutation$DeletePostImage$deletePostImage? deletePostImage});
  CopyWith$Mutation$DeletePostImage$deletePostImage<TRes> get deletePostImage;
}

class _CopyWithImpl$Mutation$DeletePostImage<TRes>
    implements CopyWith$Mutation$DeletePostImage<TRes> {
  _CopyWithImpl$Mutation$DeletePostImage(this._instance, this._then);

  final Mutation$DeletePostImage _instance;

  final TRes Function(Mutation$DeletePostImage) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? deletePostImage = _undefined}) => _then(
    Mutation$DeletePostImage(
      deletePostImage: deletePostImage == _undefined || deletePostImage == null
          ? _instance.deletePostImage
          : (deletePostImage as Mutation$DeletePostImage$deletePostImage),
    ),
  );

  CopyWith$Mutation$DeletePostImage$deletePostImage<TRes> get deletePostImage {
    final local$deletePostImage = _instance.deletePostImage;
    return CopyWith$Mutation$DeletePostImage$deletePostImage(
      local$deletePostImage,
      (e) => call(deletePostImage: e),
    );
  }
}

class _CopyWithStubImpl$Mutation$DeletePostImage<TRes>
    implements CopyWith$Mutation$DeletePostImage<TRes> {
  _CopyWithStubImpl$Mutation$DeletePostImage(this._res);

  TRes _res;

  call({Mutation$DeletePostImage$deletePostImage? deletePostImage}) => _res;

  CopyWith$Mutation$DeletePostImage$deletePostImage<TRes> get deletePostImage =>
      CopyWith$Mutation$DeletePostImage$deletePostImage.stub(_res);
}

const documentNodeMutationDeletePostImage = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'DeletePostImage'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'objectKey')),
          type: NamedTypeNode(name: NameNode(value: 'String'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
      ],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'deletePostImage'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'input'),
                value: ObjectValueNode(
                  fields: [
                    ObjectFieldNode(
                      name: NameNode(value: 'objectKey'),
                      value: VariableNode(name: NameNode(value: 'objectKey')),
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
              ],
            ),
          ),
        ],
      ),
    ),
  ],
);

class Mutation$DeletePostImage$deletePostImage {
  Mutation$DeletePostImage$deletePostImage({
    required this.success,
    required this.userErrors,
  });

  factory Mutation$DeletePostImage$deletePostImage.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$success = json['success'];
    final l$userErrors = json['userErrors'];
    return Mutation$DeletePostImage$deletePostImage(
      success: (l$success as bool),
      userErrors: (l$userErrors as List<dynamic>)
          .map(
            (e) => Mutation$DeletePostImage$deletePostImage$userErrors.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
    );
  }

  final bool success;

  final List<Mutation$DeletePostImage$deletePostImage$userErrors> userErrors;

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
    if (other is! Mutation$DeletePostImage$deletePostImage ||
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

extension UtilityExtension$Mutation$DeletePostImage$deletePostImage
    on Mutation$DeletePostImage$deletePostImage {
  CopyWith$Mutation$DeletePostImage$deletePostImage<
    Mutation$DeletePostImage$deletePostImage
  >
  get copyWith =>
      CopyWith$Mutation$DeletePostImage$deletePostImage(this, (i) => i);
}

abstract class CopyWith$Mutation$DeletePostImage$deletePostImage<TRes> {
  factory CopyWith$Mutation$DeletePostImage$deletePostImage(
    Mutation$DeletePostImage$deletePostImage instance,
    TRes Function(Mutation$DeletePostImage$deletePostImage) then,
  ) = _CopyWithImpl$Mutation$DeletePostImage$deletePostImage;

  factory CopyWith$Mutation$DeletePostImage$deletePostImage.stub(TRes res) =
      _CopyWithStubImpl$Mutation$DeletePostImage$deletePostImage;

  TRes call({
    bool? success,
    List<Mutation$DeletePostImage$deletePostImage$userErrors>? userErrors,
  });
  TRes userErrors(
    Iterable<Mutation$DeletePostImage$deletePostImage$userErrors> Function(
      Iterable<
        CopyWith$Mutation$DeletePostImage$deletePostImage$userErrors<
          Mutation$DeletePostImage$deletePostImage$userErrors
        >
      >,
    )
    _fn,
  );
}

class _CopyWithImpl$Mutation$DeletePostImage$deletePostImage<TRes>
    implements CopyWith$Mutation$DeletePostImage$deletePostImage<TRes> {
  _CopyWithImpl$Mutation$DeletePostImage$deletePostImage(
    this._instance,
    this._then,
  );

  final Mutation$DeletePostImage$deletePostImage _instance;

  final TRes Function(Mutation$DeletePostImage$deletePostImage) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? success = _undefined,
    Object? userErrors = _undefined,
  }) => _then(
    Mutation$DeletePostImage$deletePostImage(
      success: success == _undefined || success == null
          ? _instance.success
          : (success as bool),
      userErrors: userErrors == _undefined || userErrors == null
          ? _instance.userErrors
          : (userErrors
                as List<Mutation$DeletePostImage$deletePostImage$userErrors>),
    ),
  );

  TRes userErrors(
    Iterable<Mutation$DeletePostImage$deletePostImage$userErrors> Function(
      Iterable<
        CopyWith$Mutation$DeletePostImage$deletePostImage$userErrors<
          Mutation$DeletePostImage$deletePostImage$userErrors
        >
      >,
    )
    _fn,
  ) => call(
    userErrors: _fn(
      _instance.userErrors.map(
        (e) => CopyWith$Mutation$DeletePostImage$deletePostImage$userErrors(
          e,
          (i) => i,
        ),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl$Mutation$DeletePostImage$deletePostImage<TRes>
    implements CopyWith$Mutation$DeletePostImage$deletePostImage<TRes> {
  _CopyWithStubImpl$Mutation$DeletePostImage$deletePostImage(this._res);

  TRes _res;

  call({
    bool? success,
    List<Mutation$DeletePostImage$deletePostImage$userErrors>? userErrors,
  }) => _res;

  userErrors(_fn) => _res;
}

class Mutation$DeletePostImage$deletePostImage$userErrors {
  Mutation$DeletePostImage$deletePostImage$userErrors({
    required this.code,
    required this.message,
    this.field,
  });

  factory Mutation$DeletePostImage$deletePostImage$userErrors.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$code = json['code'];
    final l$message = json['message'];
    final l$field = json['field'];
    return Mutation$DeletePostImage$deletePostImage$userErrors(
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
    if (other is! Mutation$DeletePostImage$deletePostImage$userErrors ||
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

extension UtilityExtension$Mutation$DeletePostImage$deletePostImage$userErrors
    on Mutation$DeletePostImage$deletePostImage$userErrors {
  CopyWith$Mutation$DeletePostImage$deletePostImage$userErrors<
    Mutation$DeletePostImage$deletePostImage$userErrors
  >
  get copyWith => CopyWith$Mutation$DeletePostImage$deletePostImage$userErrors(
    this,
    (i) => i,
  );
}

abstract class CopyWith$Mutation$DeletePostImage$deletePostImage$userErrors<
  TRes
> {
  factory CopyWith$Mutation$DeletePostImage$deletePostImage$userErrors(
    Mutation$DeletePostImage$deletePostImage$userErrors instance,
    TRes Function(Mutation$DeletePostImage$deletePostImage$userErrors) then,
  ) = _CopyWithImpl$Mutation$DeletePostImage$deletePostImage$userErrors;

  factory CopyWith$Mutation$DeletePostImage$deletePostImage$userErrors.stub(
    TRes res,
  ) = _CopyWithStubImpl$Mutation$DeletePostImage$deletePostImage$userErrors;

  TRes call({String? code, String? message, String? field});
}

class _CopyWithImpl$Mutation$DeletePostImage$deletePostImage$userErrors<TRes>
    implements
        CopyWith$Mutation$DeletePostImage$deletePostImage$userErrors<TRes> {
  _CopyWithImpl$Mutation$DeletePostImage$deletePostImage$userErrors(
    this._instance,
    this._then,
  );

  final Mutation$DeletePostImage$deletePostImage$userErrors _instance;

  final TRes Function(Mutation$DeletePostImage$deletePostImage$userErrors)
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? code = _undefined,
    Object? message = _undefined,
    Object? field = _undefined,
  }) => _then(
    Mutation$DeletePostImage$deletePostImage$userErrors(
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

class _CopyWithStubImpl$Mutation$DeletePostImage$deletePostImage$userErrors<
  TRes
>
    implements
        CopyWith$Mutation$DeletePostImage$deletePostImage$userErrors<TRes> {
  _CopyWithStubImpl$Mutation$DeletePostImage$deletePostImage$userErrors(
    this._res,
  );

  TRes _res;

  call({String? code, String? message, String? field}) => _res;
}

class Variables$Mutation$HidePost {
  factory Variables$Mutation$HidePost({required String postId}) =>
      Variables$Mutation$HidePost._({r'postId': postId});

  Variables$Mutation$HidePost._(this._$data);

  factory Variables$Mutation$HidePost.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$postId = data['postId'];
    result$data['postId'] = (l$postId as String);
    return Variables$Mutation$HidePost._(result$data);
  }

  Map<String, dynamic> _$data;

  String get postId => (_$data['postId'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$postId = postId;
    result$data['postId'] = l$postId;
    return result$data;
  }

  CopyWith$Variables$Mutation$HidePost<Variables$Mutation$HidePost>
  get copyWith => CopyWith$Variables$Mutation$HidePost(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Mutation$HidePost ||
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

abstract class CopyWith$Variables$Mutation$HidePost<TRes> {
  factory CopyWith$Variables$Mutation$HidePost(
    Variables$Mutation$HidePost instance,
    TRes Function(Variables$Mutation$HidePost) then,
  ) = _CopyWithImpl$Variables$Mutation$HidePost;

  factory CopyWith$Variables$Mutation$HidePost.stub(TRes res) =
      _CopyWithStubImpl$Variables$Mutation$HidePost;

  TRes call({String? postId});
}

class _CopyWithImpl$Variables$Mutation$HidePost<TRes>
    implements CopyWith$Variables$Mutation$HidePost<TRes> {
  _CopyWithImpl$Variables$Mutation$HidePost(this._instance, this._then);

  final Variables$Mutation$HidePost _instance;

  final TRes Function(Variables$Mutation$HidePost) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? postId = _undefined}) => _then(
    Variables$Mutation$HidePost._({
      ..._instance._$data,
      if (postId != _undefined && postId != null) 'postId': (postId as String),
    }),
  );
}

class _CopyWithStubImpl$Variables$Mutation$HidePost<TRes>
    implements CopyWith$Variables$Mutation$HidePost<TRes> {
  _CopyWithStubImpl$Variables$Mutation$HidePost(this._res);

  TRes _res;

  call({String? postId}) => _res;
}

class Mutation$HidePost {
  Mutation$HidePost({required this.hidePost});

  factory Mutation$HidePost.fromJson(Map<String, dynamic> json) {
    final l$hidePost = json['hidePost'];
    return Mutation$HidePost(
      hidePost: Mutation$HidePost$hidePost.fromJson(
        (l$hidePost as Map<String, dynamic>),
      ),
    );
  }

  final Mutation$HidePost$hidePost hidePost;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$hidePost = hidePost;
    _resultData['hidePost'] = l$hidePost.toJson();
    return _resultData;
  }

  @override
  int get hashCode {
    final l$hidePost = hidePost;
    return Object.hashAll([l$hidePost]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$HidePost || runtimeType != other.runtimeType) {
      return false;
    }
    final l$hidePost = hidePost;
    final lOther$hidePost = other.hidePost;
    if (l$hidePost != lOther$hidePost) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Mutation$HidePost on Mutation$HidePost {
  CopyWith$Mutation$HidePost<Mutation$HidePost> get copyWith =>
      CopyWith$Mutation$HidePost(this, (i) => i);
}

abstract class CopyWith$Mutation$HidePost<TRes> {
  factory CopyWith$Mutation$HidePost(
    Mutation$HidePost instance,
    TRes Function(Mutation$HidePost) then,
  ) = _CopyWithImpl$Mutation$HidePost;

  factory CopyWith$Mutation$HidePost.stub(TRes res) =
      _CopyWithStubImpl$Mutation$HidePost;

  TRes call({Mutation$HidePost$hidePost? hidePost});
  CopyWith$Mutation$HidePost$hidePost<TRes> get hidePost;
}

class _CopyWithImpl$Mutation$HidePost<TRes>
    implements CopyWith$Mutation$HidePost<TRes> {
  _CopyWithImpl$Mutation$HidePost(this._instance, this._then);

  final Mutation$HidePost _instance;

  final TRes Function(Mutation$HidePost) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? hidePost = _undefined}) => _then(
    Mutation$HidePost(
      hidePost: hidePost == _undefined || hidePost == null
          ? _instance.hidePost
          : (hidePost as Mutation$HidePost$hidePost),
    ),
  );

  CopyWith$Mutation$HidePost$hidePost<TRes> get hidePost {
    final local$hidePost = _instance.hidePost;
    return CopyWith$Mutation$HidePost$hidePost(
      local$hidePost,
      (e) => call(hidePost: e),
    );
  }
}

class _CopyWithStubImpl$Mutation$HidePost<TRes>
    implements CopyWith$Mutation$HidePost<TRes> {
  _CopyWithStubImpl$Mutation$HidePost(this._res);

  TRes _res;

  call({Mutation$HidePost$hidePost? hidePost}) => _res;

  CopyWith$Mutation$HidePost$hidePost<TRes> get hidePost =>
      CopyWith$Mutation$HidePost$hidePost.stub(_res);
}

const documentNodeMutationHidePost = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'HidePost'),
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
            name: NameNode(value: 'hidePost'),
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
              ],
            ),
          ),
        ],
      ),
    ),
  ],
);

class Mutation$HidePost$hidePost {
  Mutation$HidePost$hidePost({required this.success, required this.userErrors});

  factory Mutation$HidePost$hidePost.fromJson(Map<String, dynamic> json) {
    final l$success = json['success'];
    final l$userErrors = json['userErrors'];
    return Mutation$HidePost$hidePost(
      success: (l$success as bool),
      userErrors: (l$userErrors as List<dynamic>)
          .map(
            (e) => Mutation$HidePost$hidePost$userErrors.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
    );
  }

  final bool success;

  final List<Mutation$HidePost$hidePost$userErrors> userErrors;

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
    if (other is! Mutation$HidePost$hidePost ||
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

extension UtilityExtension$Mutation$HidePost$hidePost
    on Mutation$HidePost$hidePost {
  CopyWith$Mutation$HidePost$hidePost<Mutation$HidePost$hidePost>
  get copyWith => CopyWith$Mutation$HidePost$hidePost(this, (i) => i);
}

abstract class CopyWith$Mutation$HidePost$hidePost<TRes> {
  factory CopyWith$Mutation$HidePost$hidePost(
    Mutation$HidePost$hidePost instance,
    TRes Function(Mutation$HidePost$hidePost) then,
  ) = _CopyWithImpl$Mutation$HidePost$hidePost;

  factory CopyWith$Mutation$HidePost$hidePost.stub(TRes res) =
      _CopyWithStubImpl$Mutation$HidePost$hidePost;

  TRes call({
    bool? success,
    List<Mutation$HidePost$hidePost$userErrors>? userErrors,
  });
  TRes userErrors(
    Iterable<Mutation$HidePost$hidePost$userErrors> Function(
      Iterable<
        CopyWith$Mutation$HidePost$hidePost$userErrors<
          Mutation$HidePost$hidePost$userErrors
        >
      >,
    )
    _fn,
  );
}

class _CopyWithImpl$Mutation$HidePost$hidePost<TRes>
    implements CopyWith$Mutation$HidePost$hidePost<TRes> {
  _CopyWithImpl$Mutation$HidePost$hidePost(this._instance, this._then);

  final Mutation$HidePost$hidePost _instance;

  final TRes Function(Mutation$HidePost$hidePost) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? success = _undefined, Object? userErrors = _undefined}) =>
      _then(
        Mutation$HidePost$hidePost(
          success: success == _undefined || success == null
              ? _instance.success
              : (success as bool),
          userErrors: userErrors == _undefined || userErrors == null
              ? _instance.userErrors
              : (userErrors as List<Mutation$HidePost$hidePost$userErrors>),
        ),
      );

  TRes userErrors(
    Iterable<Mutation$HidePost$hidePost$userErrors> Function(
      Iterable<
        CopyWith$Mutation$HidePost$hidePost$userErrors<
          Mutation$HidePost$hidePost$userErrors
        >
      >,
    )
    _fn,
  ) => call(
    userErrors: _fn(
      _instance.userErrors.map(
        (e) => CopyWith$Mutation$HidePost$hidePost$userErrors(e, (i) => i),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl$Mutation$HidePost$hidePost<TRes>
    implements CopyWith$Mutation$HidePost$hidePost<TRes> {
  _CopyWithStubImpl$Mutation$HidePost$hidePost(this._res);

  TRes _res;

  call({
    bool? success,
    List<Mutation$HidePost$hidePost$userErrors>? userErrors,
  }) => _res;

  userErrors(_fn) => _res;
}

class Mutation$HidePost$hidePost$userErrors {
  Mutation$HidePost$hidePost$userErrors({
    required this.code,
    required this.message,
    this.field,
  });

  factory Mutation$HidePost$hidePost$userErrors.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$code = json['code'];
    final l$message = json['message'];
    final l$field = json['field'];
    return Mutation$HidePost$hidePost$userErrors(
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
    if (other is! Mutation$HidePost$hidePost$userErrors ||
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

extension UtilityExtension$Mutation$HidePost$hidePost$userErrors
    on Mutation$HidePost$hidePost$userErrors {
  CopyWith$Mutation$HidePost$hidePost$userErrors<
    Mutation$HidePost$hidePost$userErrors
  >
  get copyWith =>
      CopyWith$Mutation$HidePost$hidePost$userErrors(this, (i) => i);
}

abstract class CopyWith$Mutation$HidePost$hidePost$userErrors<TRes> {
  factory CopyWith$Mutation$HidePost$hidePost$userErrors(
    Mutation$HidePost$hidePost$userErrors instance,
    TRes Function(Mutation$HidePost$hidePost$userErrors) then,
  ) = _CopyWithImpl$Mutation$HidePost$hidePost$userErrors;

  factory CopyWith$Mutation$HidePost$hidePost$userErrors.stub(TRes res) =
      _CopyWithStubImpl$Mutation$HidePost$hidePost$userErrors;

  TRes call({String? code, String? message, String? field});
}

class _CopyWithImpl$Mutation$HidePost$hidePost$userErrors<TRes>
    implements CopyWith$Mutation$HidePost$hidePost$userErrors<TRes> {
  _CopyWithImpl$Mutation$HidePost$hidePost$userErrors(
    this._instance,
    this._then,
  );

  final Mutation$HidePost$hidePost$userErrors _instance;

  final TRes Function(Mutation$HidePost$hidePost$userErrors) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? code = _undefined,
    Object? message = _undefined,
    Object? field = _undefined,
  }) => _then(
    Mutation$HidePost$hidePost$userErrors(
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

class _CopyWithStubImpl$Mutation$HidePost$hidePost$userErrors<TRes>
    implements CopyWith$Mutation$HidePost$hidePost$userErrors<TRes> {
  _CopyWithStubImpl$Mutation$HidePost$hidePost$userErrors(this._res);

  TRes _res;

  call({String? code, String? message, String? field}) => _res;
}

class Variables$Mutation$UnhidePost {
  factory Variables$Mutation$UnhidePost({required String postId}) =>
      Variables$Mutation$UnhidePost._({r'postId': postId});

  Variables$Mutation$UnhidePost._(this._$data);

  factory Variables$Mutation$UnhidePost.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$postId = data['postId'];
    result$data['postId'] = (l$postId as String);
    return Variables$Mutation$UnhidePost._(result$data);
  }

  Map<String, dynamic> _$data;

  String get postId => (_$data['postId'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$postId = postId;
    result$data['postId'] = l$postId;
    return result$data;
  }

  CopyWith$Variables$Mutation$UnhidePost<Variables$Mutation$UnhidePost>
  get copyWith => CopyWith$Variables$Mutation$UnhidePost(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Mutation$UnhidePost ||
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

abstract class CopyWith$Variables$Mutation$UnhidePost<TRes> {
  factory CopyWith$Variables$Mutation$UnhidePost(
    Variables$Mutation$UnhidePost instance,
    TRes Function(Variables$Mutation$UnhidePost) then,
  ) = _CopyWithImpl$Variables$Mutation$UnhidePost;

  factory CopyWith$Variables$Mutation$UnhidePost.stub(TRes res) =
      _CopyWithStubImpl$Variables$Mutation$UnhidePost;

  TRes call({String? postId});
}

class _CopyWithImpl$Variables$Mutation$UnhidePost<TRes>
    implements CopyWith$Variables$Mutation$UnhidePost<TRes> {
  _CopyWithImpl$Variables$Mutation$UnhidePost(this._instance, this._then);

  final Variables$Mutation$UnhidePost _instance;

  final TRes Function(Variables$Mutation$UnhidePost) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? postId = _undefined}) => _then(
    Variables$Mutation$UnhidePost._({
      ..._instance._$data,
      if (postId != _undefined && postId != null) 'postId': (postId as String),
    }),
  );
}

class _CopyWithStubImpl$Variables$Mutation$UnhidePost<TRes>
    implements CopyWith$Variables$Mutation$UnhidePost<TRes> {
  _CopyWithStubImpl$Variables$Mutation$UnhidePost(this._res);

  TRes _res;

  call({String? postId}) => _res;
}

class Mutation$UnhidePost {
  Mutation$UnhidePost({required this.unhidePost});

  factory Mutation$UnhidePost.fromJson(Map<String, dynamic> json) {
    final l$unhidePost = json['unhidePost'];
    return Mutation$UnhidePost(
      unhidePost: Mutation$UnhidePost$unhidePost.fromJson(
        (l$unhidePost as Map<String, dynamic>),
      ),
    );
  }

  final Mutation$UnhidePost$unhidePost unhidePost;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$unhidePost = unhidePost;
    _resultData['unhidePost'] = l$unhidePost.toJson();
    return _resultData;
  }

  @override
  int get hashCode {
    final l$unhidePost = unhidePost;
    return Object.hashAll([l$unhidePost]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$UnhidePost || runtimeType != other.runtimeType) {
      return false;
    }
    final l$unhidePost = unhidePost;
    final lOther$unhidePost = other.unhidePost;
    if (l$unhidePost != lOther$unhidePost) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Mutation$UnhidePost on Mutation$UnhidePost {
  CopyWith$Mutation$UnhidePost<Mutation$UnhidePost> get copyWith =>
      CopyWith$Mutation$UnhidePost(this, (i) => i);
}

abstract class CopyWith$Mutation$UnhidePost<TRes> {
  factory CopyWith$Mutation$UnhidePost(
    Mutation$UnhidePost instance,
    TRes Function(Mutation$UnhidePost) then,
  ) = _CopyWithImpl$Mutation$UnhidePost;

  factory CopyWith$Mutation$UnhidePost.stub(TRes res) =
      _CopyWithStubImpl$Mutation$UnhidePost;

  TRes call({Mutation$UnhidePost$unhidePost? unhidePost});
  CopyWith$Mutation$UnhidePost$unhidePost<TRes> get unhidePost;
}

class _CopyWithImpl$Mutation$UnhidePost<TRes>
    implements CopyWith$Mutation$UnhidePost<TRes> {
  _CopyWithImpl$Mutation$UnhidePost(this._instance, this._then);

  final Mutation$UnhidePost _instance;

  final TRes Function(Mutation$UnhidePost) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? unhidePost = _undefined}) => _then(
    Mutation$UnhidePost(
      unhidePost: unhidePost == _undefined || unhidePost == null
          ? _instance.unhidePost
          : (unhidePost as Mutation$UnhidePost$unhidePost),
    ),
  );

  CopyWith$Mutation$UnhidePost$unhidePost<TRes> get unhidePost {
    final local$unhidePost = _instance.unhidePost;
    return CopyWith$Mutation$UnhidePost$unhidePost(
      local$unhidePost,
      (e) => call(unhidePost: e),
    );
  }
}

class _CopyWithStubImpl$Mutation$UnhidePost<TRes>
    implements CopyWith$Mutation$UnhidePost<TRes> {
  _CopyWithStubImpl$Mutation$UnhidePost(this._res);

  TRes _res;

  call({Mutation$UnhidePost$unhidePost? unhidePost}) => _res;

  CopyWith$Mutation$UnhidePost$unhidePost<TRes> get unhidePost =>
      CopyWith$Mutation$UnhidePost$unhidePost.stub(_res);
}

const documentNodeMutationUnhidePost = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'UnhidePost'),
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
            name: NameNode(value: 'unhidePost'),
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
              ],
            ),
          ),
        ],
      ),
    ),
  ],
);

class Mutation$UnhidePost$unhidePost {
  Mutation$UnhidePost$unhidePost({
    required this.success,
    required this.userErrors,
  });

  factory Mutation$UnhidePost$unhidePost.fromJson(Map<String, dynamic> json) {
    final l$success = json['success'];
    final l$userErrors = json['userErrors'];
    return Mutation$UnhidePost$unhidePost(
      success: (l$success as bool),
      userErrors: (l$userErrors as List<dynamic>)
          .map(
            (e) => Mutation$UnhidePost$unhidePost$userErrors.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
    );
  }

  final bool success;

  final List<Mutation$UnhidePost$unhidePost$userErrors> userErrors;

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
    if (other is! Mutation$UnhidePost$unhidePost ||
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

extension UtilityExtension$Mutation$UnhidePost$unhidePost
    on Mutation$UnhidePost$unhidePost {
  CopyWith$Mutation$UnhidePost$unhidePost<Mutation$UnhidePost$unhidePost>
  get copyWith => CopyWith$Mutation$UnhidePost$unhidePost(this, (i) => i);
}

abstract class CopyWith$Mutation$UnhidePost$unhidePost<TRes> {
  factory CopyWith$Mutation$UnhidePost$unhidePost(
    Mutation$UnhidePost$unhidePost instance,
    TRes Function(Mutation$UnhidePost$unhidePost) then,
  ) = _CopyWithImpl$Mutation$UnhidePost$unhidePost;

  factory CopyWith$Mutation$UnhidePost$unhidePost.stub(TRes res) =
      _CopyWithStubImpl$Mutation$UnhidePost$unhidePost;

  TRes call({
    bool? success,
    List<Mutation$UnhidePost$unhidePost$userErrors>? userErrors,
  });
  TRes userErrors(
    Iterable<Mutation$UnhidePost$unhidePost$userErrors> Function(
      Iterable<
        CopyWith$Mutation$UnhidePost$unhidePost$userErrors<
          Mutation$UnhidePost$unhidePost$userErrors
        >
      >,
    )
    _fn,
  );
}

class _CopyWithImpl$Mutation$UnhidePost$unhidePost<TRes>
    implements CopyWith$Mutation$UnhidePost$unhidePost<TRes> {
  _CopyWithImpl$Mutation$UnhidePost$unhidePost(this._instance, this._then);

  final Mutation$UnhidePost$unhidePost _instance;

  final TRes Function(Mutation$UnhidePost$unhidePost) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? success = _undefined, Object? userErrors = _undefined}) =>
      _then(
        Mutation$UnhidePost$unhidePost(
          success: success == _undefined || success == null
              ? _instance.success
              : (success as bool),
          userErrors: userErrors == _undefined || userErrors == null
              ? _instance.userErrors
              : (userErrors as List<Mutation$UnhidePost$unhidePost$userErrors>),
        ),
      );

  TRes userErrors(
    Iterable<Mutation$UnhidePost$unhidePost$userErrors> Function(
      Iterable<
        CopyWith$Mutation$UnhidePost$unhidePost$userErrors<
          Mutation$UnhidePost$unhidePost$userErrors
        >
      >,
    )
    _fn,
  ) => call(
    userErrors: _fn(
      _instance.userErrors.map(
        (e) => CopyWith$Mutation$UnhidePost$unhidePost$userErrors(e, (i) => i),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl$Mutation$UnhidePost$unhidePost<TRes>
    implements CopyWith$Mutation$UnhidePost$unhidePost<TRes> {
  _CopyWithStubImpl$Mutation$UnhidePost$unhidePost(this._res);

  TRes _res;

  call({
    bool? success,
    List<Mutation$UnhidePost$unhidePost$userErrors>? userErrors,
  }) => _res;

  userErrors(_fn) => _res;
}

class Mutation$UnhidePost$unhidePost$userErrors {
  Mutation$UnhidePost$unhidePost$userErrors({
    required this.code,
    required this.message,
    this.field,
  });

  factory Mutation$UnhidePost$unhidePost$userErrors.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$code = json['code'];
    final l$message = json['message'];
    final l$field = json['field'];
    return Mutation$UnhidePost$unhidePost$userErrors(
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
    if (other is! Mutation$UnhidePost$unhidePost$userErrors ||
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

extension UtilityExtension$Mutation$UnhidePost$unhidePost$userErrors
    on Mutation$UnhidePost$unhidePost$userErrors {
  CopyWith$Mutation$UnhidePost$unhidePost$userErrors<
    Mutation$UnhidePost$unhidePost$userErrors
  >
  get copyWith =>
      CopyWith$Mutation$UnhidePost$unhidePost$userErrors(this, (i) => i);
}

abstract class CopyWith$Mutation$UnhidePost$unhidePost$userErrors<TRes> {
  factory CopyWith$Mutation$UnhidePost$unhidePost$userErrors(
    Mutation$UnhidePost$unhidePost$userErrors instance,
    TRes Function(Mutation$UnhidePost$unhidePost$userErrors) then,
  ) = _CopyWithImpl$Mutation$UnhidePost$unhidePost$userErrors;

  factory CopyWith$Mutation$UnhidePost$unhidePost$userErrors.stub(TRes res) =
      _CopyWithStubImpl$Mutation$UnhidePost$unhidePost$userErrors;

  TRes call({String? code, String? message, String? field});
}

class _CopyWithImpl$Mutation$UnhidePost$unhidePost$userErrors<TRes>
    implements CopyWith$Mutation$UnhidePost$unhidePost$userErrors<TRes> {
  _CopyWithImpl$Mutation$UnhidePost$unhidePost$userErrors(
    this._instance,
    this._then,
  );

  final Mutation$UnhidePost$unhidePost$userErrors _instance;

  final TRes Function(Mutation$UnhidePost$unhidePost$userErrors) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? code = _undefined,
    Object? message = _undefined,
    Object? field = _undefined,
  }) => _then(
    Mutation$UnhidePost$unhidePost$userErrors(
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

class _CopyWithStubImpl$Mutation$UnhidePost$unhidePost$userErrors<TRes>
    implements CopyWith$Mutation$UnhidePost$unhidePost$userErrors<TRes> {
  _CopyWithStubImpl$Mutation$UnhidePost$unhidePost$userErrors(this._res);

  TRes _res;

  call({String? code, String? message, String? field}) => _res;
}

class Variables$Mutation$BlockUser {
  factory Variables$Mutation$BlockUser({required String targetMemberId}) =>
      Variables$Mutation$BlockUser._({r'targetMemberId': targetMemberId});

  Variables$Mutation$BlockUser._(this._$data);

  factory Variables$Mutation$BlockUser.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$targetMemberId = data['targetMemberId'];
    result$data['targetMemberId'] = (l$targetMemberId as String);
    return Variables$Mutation$BlockUser._(result$data);
  }

  Map<String, dynamic> _$data;

  String get targetMemberId => (_$data['targetMemberId'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$targetMemberId = targetMemberId;
    result$data['targetMemberId'] = l$targetMemberId;
    return result$data;
  }

  CopyWith$Variables$Mutation$BlockUser<Variables$Mutation$BlockUser>
  get copyWith => CopyWith$Variables$Mutation$BlockUser(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Mutation$BlockUser ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$targetMemberId = targetMemberId;
    final lOther$targetMemberId = other.targetMemberId;
    if (l$targetMemberId != lOther$targetMemberId) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$targetMemberId = targetMemberId;
    return Object.hashAll([l$targetMemberId]);
  }
}

abstract class CopyWith$Variables$Mutation$BlockUser<TRes> {
  factory CopyWith$Variables$Mutation$BlockUser(
    Variables$Mutation$BlockUser instance,
    TRes Function(Variables$Mutation$BlockUser) then,
  ) = _CopyWithImpl$Variables$Mutation$BlockUser;

  factory CopyWith$Variables$Mutation$BlockUser.stub(TRes res) =
      _CopyWithStubImpl$Variables$Mutation$BlockUser;

  TRes call({String? targetMemberId});
}

class _CopyWithImpl$Variables$Mutation$BlockUser<TRes>
    implements CopyWith$Variables$Mutation$BlockUser<TRes> {
  _CopyWithImpl$Variables$Mutation$BlockUser(this._instance, this._then);

  final Variables$Mutation$BlockUser _instance;

  final TRes Function(Variables$Mutation$BlockUser) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? targetMemberId = _undefined}) => _then(
    Variables$Mutation$BlockUser._({
      ..._instance._$data,
      if (targetMemberId != _undefined && targetMemberId != null)
        'targetMemberId': (targetMemberId as String),
    }),
  );
}

class _CopyWithStubImpl$Variables$Mutation$BlockUser<TRes>
    implements CopyWith$Variables$Mutation$BlockUser<TRes> {
  _CopyWithStubImpl$Variables$Mutation$BlockUser(this._res);

  TRes _res;

  call({String? targetMemberId}) => _res;
}

class Mutation$BlockUser {
  Mutation$BlockUser({required this.blockUser});

  factory Mutation$BlockUser.fromJson(Map<String, dynamic> json) {
    final l$blockUser = json['blockUser'];
    return Mutation$BlockUser(
      blockUser: Mutation$BlockUser$blockUser.fromJson(
        (l$blockUser as Map<String, dynamic>),
      ),
    );
  }

  final Mutation$BlockUser$blockUser blockUser;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$blockUser = blockUser;
    _resultData['blockUser'] = l$blockUser.toJson();
    return _resultData;
  }

  @override
  int get hashCode {
    final l$blockUser = blockUser;
    return Object.hashAll([l$blockUser]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$BlockUser || runtimeType != other.runtimeType) {
      return false;
    }
    final l$blockUser = blockUser;
    final lOther$blockUser = other.blockUser;
    if (l$blockUser != lOther$blockUser) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Mutation$BlockUser on Mutation$BlockUser {
  CopyWith$Mutation$BlockUser<Mutation$BlockUser> get copyWith =>
      CopyWith$Mutation$BlockUser(this, (i) => i);
}

abstract class CopyWith$Mutation$BlockUser<TRes> {
  factory CopyWith$Mutation$BlockUser(
    Mutation$BlockUser instance,
    TRes Function(Mutation$BlockUser) then,
  ) = _CopyWithImpl$Mutation$BlockUser;

  factory CopyWith$Mutation$BlockUser.stub(TRes res) =
      _CopyWithStubImpl$Mutation$BlockUser;

  TRes call({Mutation$BlockUser$blockUser? blockUser});
  CopyWith$Mutation$BlockUser$blockUser<TRes> get blockUser;
}

class _CopyWithImpl$Mutation$BlockUser<TRes>
    implements CopyWith$Mutation$BlockUser<TRes> {
  _CopyWithImpl$Mutation$BlockUser(this._instance, this._then);

  final Mutation$BlockUser _instance;

  final TRes Function(Mutation$BlockUser) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? blockUser = _undefined}) => _then(
    Mutation$BlockUser(
      blockUser: blockUser == _undefined || blockUser == null
          ? _instance.blockUser
          : (blockUser as Mutation$BlockUser$blockUser),
    ),
  );

  CopyWith$Mutation$BlockUser$blockUser<TRes> get blockUser {
    final local$blockUser = _instance.blockUser;
    return CopyWith$Mutation$BlockUser$blockUser(
      local$blockUser,
      (e) => call(blockUser: e),
    );
  }
}

class _CopyWithStubImpl$Mutation$BlockUser<TRes>
    implements CopyWith$Mutation$BlockUser<TRes> {
  _CopyWithStubImpl$Mutation$BlockUser(this._res);

  TRes _res;

  call({Mutation$BlockUser$blockUser? blockUser}) => _res;

  CopyWith$Mutation$BlockUser$blockUser<TRes> get blockUser =>
      CopyWith$Mutation$BlockUser$blockUser.stub(_res);
}

const documentNodeMutationBlockUser = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'BlockUser'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'targetMemberId')),
          type: NamedTypeNode(name: NameNode(value: 'ID'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
      ],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'blockUser'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'input'),
                value: ObjectValueNode(
                  fields: [
                    ObjectFieldNode(
                      name: NameNode(value: 'targetMemberId'),
                      value: VariableNode(
                        name: NameNode(value: 'targetMemberId'),
                      ),
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
              ],
            ),
          ),
        ],
      ),
    ),
  ],
);

class Mutation$BlockUser$blockUser {
  Mutation$BlockUser$blockUser({
    required this.success,
    required this.userErrors,
  });

  factory Mutation$BlockUser$blockUser.fromJson(Map<String, dynamic> json) {
    final l$success = json['success'];
    final l$userErrors = json['userErrors'];
    return Mutation$BlockUser$blockUser(
      success: (l$success as bool),
      userErrors: (l$userErrors as List<dynamic>)
          .map(
            (e) => Mutation$BlockUser$blockUser$userErrors.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
    );
  }

  final bool success;

  final List<Mutation$BlockUser$blockUser$userErrors> userErrors;

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
    if (other is! Mutation$BlockUser$blockUser ||
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

extension UtilityExtension$Mutation$BlockUser$blockUser
    on Mutation$BlockUser$blockUser {
  CopyWith$Mutation$BlockUser$blockUser<Mutation$BlockUser$blockUser>
  get copyWith => CopyWith$Mutation$BlockUser$blockUser(this, (i) => i);
}

abstract class CopyWith$Mutation$BlockUser$blockUser<TRes> {
  factory CopyWith$Mutation$BlockUser$blockUser(
    Mutation$BlockUser$blockUser instance,
    TRes Function(Mutation$BlockUser$blockUser) then,
  ) = _CopyWithImpl$Mutation$BlockUser$blockUser;

  factory CopyWith$Mutation$BlockUser$blockUser.stub(TRes res) =
      _CopyWithStubImpl$Mutation$BlockUser$blockUser;

  TRes call({
    bool? success,
    List<Mutation$BlockUser$blockUser$userErrors>? userErrors,
  });
  TRes userErrors(
    Iterable<Mutation$BlockUser$blockUser$userErrors> Function(
      Iterable<
        CopyWith$Mutation$BlockUser$blockUser$userErrors<
          Mutation$BlockUser$blockUser$userErrors
        >
      >,
    )
    _fn,
  );
}

class _CopyWithImpl$Mutation$BlockUser$blockUser<TRes>
    implements CopyWith$Mutation$BlockUser$blockUser<TRes> {
  _CopyWithImpl$Mutation$BlockUser$blockUser(this._instance, this._then);

  final Mutation$BlockUser$blockUser _instance;

  final TRes Function(Mutation$BlockUser$blockUser) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? success = _undefined, Object? userErrors = _undefined}) =>
      _then(
        Mutation$BlockUser$blockUser(
          success: success == _undefined || success == null
              ? _instance.success
              : (success as bool),
          userErrors: userErrors == _undefined || userErrors == null
              ? _instance.userErrors
              : (userErrors as List<Mutation$BlockUser$blockUser$userErrors>),
        ),
      );

  TRes userErrors(
    Iterable<Mutation$BlockUser$blockUser$userErrors> Function(
      Iterable<
        CopyWith$Mutation$BlockUser$blockUser$userErrors<
          Mutation$BlockUser$blockUser$userErrors
        >
      >,
    )
    _fn,
  ) => call(
    userErrors: _fn(
      _instance.userErrors.map(
        (e) => CopyWith$Mutation$BlockUser$blockUser$userErrors(e, (i) => i),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl$Mutation$BlockUser$blockUser<TRes>
    implements CopyWith$Mutation$BlockUser$blockUser<TRes> {
  _CopyWithStubImpl$Mutation$BlockUser$blockUser(this._res);

  TRes _res;

  call({
    bool? success,
    List<Mutation$BlockUser$blockUser$userErrors>? userErrors,
  }) => _res;

  userErrors(_fn) => _res;
}

class Mutation$BlockUser$blockUser$userErrors {
  Mutation$BlockUser$blockUser$userErrors({
    required this.code,
    required this.message,
    this.field,
  });

  factory Mutation$BlockUser$blockUser$userErrors.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$code = json['code'];
    final l$message = json['message'];
    final l$field = json['field'];
    return Mutation$BlockUser$blockUser$userErrors(
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
    if (other is! Mutation$BlockUser$blockUser$userErrors ||
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

extension UtilityExtension$Mutation$BlockUser$blockUser$userErrors
    on Mutation$BlockUser$blockUser$userErrors {
  CopyWith$Mutation$BlockUser$blockUser$userErrors<
    Mutation$BlockUser$blockUser$userErrors
  >
  get copyWith =>
      CopyWith$Mutation$BlockUser$blockUser$userErrors(this, (i) => i);
}

abstract class CopyWith$Mutation$BlockUser$blockUser$userErrors<TRes> {
  factory CopyWith$Mutation$BlockUser$blockUser$userErrors(
    Mutation$BlockUser$blockUser$userErrors instance,
    TRes Function(Mutation$BlockUser$blockUser$userErrors) then,
  ) = _CopyWithImpl$Mutation$BlockUser$blockUser$userErrors;

  factory CopyWith$Mutation$BlockUser$blockUser$userErrors.stub(TRes res) =
      _CopyWithStubImpl$Mutation$BlockUser$blockUser$userErrors;

  TRes call({String? code, String? message, String? field});
}

class _CopyWithImpl$Mutation$BlockUser$blockUser$userErrors<TRes>
    implements CopyWith$Mutation$BlockUser$blockUser$userErrors<TRes> {
  _CopyWithImpl$Mutation$BlockUser$blockUser$userErrors(
    this._instance,
    this._then,
  );

  final Mutation$BlockUser$blockUser$userErrors _instance;

  final TRes Function(Mutation$BlockUser$blockUser$userErrors) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? code = _undefined,
    Object? message = _undefined,
    Object? field = _undefined,
  }) => _then(
    Mutation$BlockUser$blockUser$userErrors(
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

class _CopyWithStubImpl$Mutation$BlockUser$blockUser$userErrors<TRes>
    implements CopyWith$Mutation$BlockUser$blockUser$userErrors<TRes> {
  _CopyWithStubImpl$Mutation$BlockUser$blockUser$userErrors(this._res);

  TRes _res;

  call({String? code, String? message, String? field}) => _res;
}

class Variables$Mutation$UnblockUser {
  factory Variables$Mutation$UnblockUser({required String targetMemberId}) =>
      Variables$Mutation$UnblockUser._({r'targetMemberId': targetMemberId});

  Variables$Mutation$UnblockUser._(this._$data);

  factory Variables$Mutation$UnblockUser.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$targetMemberId = data['targetMemberId'];
    result$data['targetMemberId'] = (l$targetMemberId as String);
    return Variables$Mutation$UnblockUser._(result$data);
  }

  Map<String, dynamic> _$data;

  String get targetMemberId => (_$data['targetMemberId'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$targetMemberId = targetMemberId;
    result$data['targetMemberId'] = l$targetMemberId;
    return result$data;
  }

  CopyWith$Variables$Mutation$UnblockUser<Variables$Mutation$UnblockUser>
  get copyWith => CopyWith$Variables$Mutation$UnblockUser(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Mutation$UnblockUser ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$targetMemberId = targetMemberId;
    final lOther$targetMemberId = other.targetMemberId;
    if (l$targetMemberId != lOther$targetMemberId) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$targetMemberId = targetMemberId;
    return Object.hashAll([l$targetMemberId]);
  }
}

abstract class CopyWith$Variables$Mutation$UnblockUser<TRes> {
  factory CopyWith$Variables$Mutation$UnblockUser(
    Variables$Mutation$UnblockUser instance,
    TRes Function(Variables$Mutation$UnblockUser) then,
  ) = _CopyWithImpl$Variables$Mutation$UnblockUser;

  factory CopyWith$Variables$Mutation$UnblockUser.stub(TRes res) =
      _CopyWithStubImpl$Variables$Mutation$UnblockUser;

  TRes call({String? targetMemberId});
}

class _CopyWithImpl$Variables$Mutation$UnblockUser<TRes>
    implements CopyWith$Variables$Mutation$UnblockUser<TRes> {
  _CopyWithImpl$Variables$Mutation$UnblockUser(this._instance, this._then);

  final Variables$Mutation$UnblockUser _instance;

  final TRes Function(Variables$Mutation$UnblockUser) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? targetMemberId = _undefined}) => _then(
    Variables$Mutation$UnblockUser._({
      ..._instance._$data,
      if (targetMemberId != _undefined && targetMemberId != null)
        'targetMemberId': (targetMemberId as String),
    }),
  );
}

class _CopyWithStubImpl$Variables$Mutation$UnblockUser<TRes>
    implements CopyWith$Variables$Mutation$UnblockUser<TRes> {
  _CopyWithStubImpl$Variables$Mutation$UnblockUser(this._res);

  TRes _res;

  call({String? targetMemberId}) => _res;
}

class Mutation$UnblockUser {
  Mutation$UnblockUser({required this.unblockUser});

  factory Mutation$UnblockUser.fromJson(Map<String, dynamic> json) {
    final l$unblockUser = json['unblockUser'];
    return Mutation$UnblockUser(
      unblockUser: Mutation$UnblockUser$unblockUser.fromJson(
        (l$unblockUser as Map<String, dynamic>),
      ),
    );
  }

  final Mutation$UnblockUser$unblockUser unblockUser;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$unblockUser = unblockUser;
    _resultData['unblockUser'] = l$unblockUser.toJson();
    return _resultData;
  }

  @override
  int get hashCode {
    final l$unblockUser = unblockUser;
    return Object.hashAll([l$unblockUser]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$UnblockUser || runtimeType != other.runtimeType) {
      return false;
    }
    final l$unblockUser = unblockUser;
    final lOther$unblockUser = other.unblockUser;
    if (l$unblockUser != lOther$unblockUser) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Mutation$UnblockUser on Mutation$UnblockUser {
  CopyWith$Mutation$UnblockUser<Mutation$UnblockUser> get copyWith =>
      CopyWith$Mutation$UnblockUser(this, (i) => i);
}

abstract class CopyWith$Mutation$UnblockUser<TRes> {
  factory CopyWith$Mutation$UnblockUser(
    Mutation$UnblockUser instance,
    TRes Function(Mutation$UnblockUser) then,
  ) = _CopyWithImpl$Mutation$UnblockUser;

  factory CopyWith$Mutation$UnblockUser.stub(TRes res) =
      _CopyWithStubImpl$Mutation$UnblockUser;

  TRes call({Mutation$UnblockUser$unblockUser? unblockUser});
  CopyWith$Mutation$UnblockUser$unblockUser<TRes> get unblockUser;
}

class _CopyWithImpl$Mutation$UnblockUser<TRes>
    implements CopyWith$Mutation$UnblockUser<TRes> {
  _CopyWithImpl$Mutation$UnblockUser(this._instance, this._then);

  final Mutation$UnblockUser _instance;

  final TRes Function(Mutation$UnblockUser) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? unblockUser = _undefined}) => _then(
    Mutation$UnblockUser(
      unblockUser: unblockUser == _undefined || unblockUser == null
          ? _instance.unblockUser
          : (unblockUser as Mutation$UnblockUser$unblockUser),
    ),
  );

  CopyWith$Mutation$UnblockUser$unblockUser<TRes> get unblockUser {
    final local$unblockUser = _instance.unblockUser;
    return CopyWith$Mutation$UnblockUser$unblockUser(
      local$unblockUser,
      (e) => call(unblockUser: e),
    );
  }
}

class _CopyWithStubImpl$Mutation$UnblockUser<TRes>
    implements CopyWith$Mutation$UnblockUser<TRes> {
  _CopyWithStubImpl$Mutation$UnblockUser(this._res);

  TRes _res;

  call({Mutation$UnblockUser$unblockUser? unblockUser}) => _res;

  CopyWith$Mutation$UnblockUser$unblockUser<TRes> get unblockUser =>
      CopyWith$Mutation$UnblockUser$unblockUser.stub(_res);
}

const documentNodeMutationUnblockUser = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'UnblockUser'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'targetMemberId')),
          type: NamedTypeNode(name: NameNode(value: 'ID'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
      ],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'unblockUser'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'input'),
                value: ObjectValueNode(
                  fields: [
                    ObjectFieldNode(
                      name: NameNode(value: 'targetMemberId'),
                      value: VariableNode(
                        name: NameNode(value: 'targetMemberId'),
                      ),
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
              ],
            ),
          ),
        ],
      ),
    ),
  ],
);

class Mutation$UnblockUser$unblockUser {
  Mutation$UnblockUser$unblockUser({
    required this.success,
    required this.userErrors,
  });

  factory Mutation$UnblockUser$unblockUser.fromJson(Map<String, dynamic> json) {
    final l$success = json['success'];
    final l$userErrors = json['userErrors'];
    return Mutation$UnblockUser$unblockUser(
      success: (l$success as bool),
      userErrors: (l$userErrors as List<dynamic>)
          .map(
            (e) => Mutation$UnblockUser$unblockUser$userErrors.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
    );
  }

  final bool success;

  final List<Mutation$UnblockUser$unblockUser$userErrors> userErrors;

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
    if (other is! Mutation$UnblockUser$unblockUser ||
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

extension UtilityExtension$Mutation$UnblockUser$unblockUser
    on Mutation$UnblockUser$unblockUser {
  CopyWith$Mutation$UnblockUser$unblockUser<Mutation$UnblockUser$unblockUser>
  get copyWith => CopyWith$Mutation$UnblockUser$unblockUser(this, (i) => i);
}

abstract class CopyWith$Mutation$UnblockUser$unblockUser<TRes> {
  factory CopyWith$Mutation$UnblockUser$unblockUser(
    Mutation$UnblockUser$unblockUser instance,
    TRes Function(Mutation$UnblockUser$unblockUser) then,
  ) = _CopyWithImpl$Mutation$UnblockUser$unblockUser;

  factory CopyWith$Mutation$UnblockUser$unblockUser.stub(TRes res) =
      _CopyWithStubImpl$Mutation$UnblockUser$unblockUser;

  TRes call({
    bool? success,
    List<Mutation$UnblockUser$unblockUser$userErrors>? userErrors,
  });
  TRes userErrors(
    Iterable<Mutation$UnblockUser$unblockUser$userErrors> Function(
      Iterable<
        CopyWith$Mutation$UnblockUser$unblockUser$userErrors<
          Mutation$UnblockUser$unblockUser$userErrors
        >
      >,
    )
    _fn,
  );
}

class _CopyWithImpl$Mutation$UnblockUser$unblockUser<TRes>
    implements CopyWith$Mutation$UnblockUser$unblockUser<TRes> {
  _CopyWithImpl$Mutation$UnblockUser$unblockUser(this._instance, this._then);

  final Mutation$UnblockUser$unblockUser _instance;

  final TRes Function(Mutation$UnblockUser$unblockUser) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? success = _undefined, Object? userErrors = _undefined}) =>
      _then(
        Mutation$UnblockUser$unblockUser(
          success: success == _undefined || success == null
              ? _instance.success
              : (success as bool),
          userErrors: userErrors == _undefined || userErrors == null
              ? _instance.userErrors
              : (userErrors
                    as List<Mutation$UnblockUser$unblockUser$userErrors>),
        ),
      );

  TRes userErrors(
    Iterable<Mutation$UnblockUser$unblockUser$userErrors> Function(
      Iterable<
        CopyWith$Mutation$UnblockUser$unblockUser$userErrors<
          Mutation$UnblockUser$unblockUser$userErrors
        >
      >,
    )
    _fn,
  ) => call(
    userErrors: _fn(
      _instance.userErrors.map(
        (e) =>
            CopyWith$Mutation$UnblockUser$unblockUser$userErrors(e, (i) => i),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl$Mutation$UnblockUser$unblockUser<TRes>
    implements CopyWith$Mutation$UnblockUser$unblockUser<TRes> {
  _CopyWithStubImpl$Mutation$UnblockUser$unblockUser(this._res);

  TRes _res;

  call({
    bool? success,
    List<Mutation$UnblockUser$unblockUser$userErrors>? userErrors,
  }) => _res;

  userErrors(_fn) => _res;
}

class Mutation$UnblockUser$unblockUser$userErrors {
  Mutation$UnblockUser$unblockUser$userErrors({
    required this.code,
    required this.message,
    this.field,
  });

  factory Mutation$UnblockUser$unblockUser$userErrors.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$code = json['code'];
    final l$message = json['message'];
    final l$field = json['field'];
    return Mutation$UnblockUser$unblockUser$userErrors(
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
    if (other is! Mutation$UnblockUser$unblockUser$userErrors ||
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

extension UtilityExtension$Mutation$UnblockUser$unblockUser$userErrors
    on Mutation$UnblockUser$unblockUser$userErrors {
  CopyWith$Mutation$UnblockUser$unblockUser$userErrors<
    Mutation$UnblockUser$unblockUser$userErrors
  >
  get copyWith =>
      CopyWith$Mutation$UnblockUser$unblockUser$userErrors(this, (i) => i);
}

abstract class CopyWith$Mutation$UnblockUser$unblockUser$userErrors<TRes> {
  factory CopyWith$Mutation$UnblockUser$unblockUser$userErrors(
    Mutation$UnblockUser$unblockUser$userErrors instance,
    TRes Function(Mutation$UnblockUser$unblockUser$userErrors) then,
  ) = _CopyWithImpl$Mutation$UnblockUser$unblockUser$userErrors;

  factory CopyWith$Mutation$UnblockUser$unblockUser$userErrors.stub(TRes res) =
      _CopyWithStubImpl$Mutation$UnblockUser$unblockUser$userErrors;

  TRes call({String? code, String? message, String? field});
}

class _CopyWithImpl$Mutation$UnblockUser$unblockUser$userErrors<TRes>
    implements CopyWith$Mutation$UnblockUser$unblockUser$userErrors<TRes> {
  _CopyWithImpl$Mutation$UnblockUser$unblockUser$userErrors(
    this._instance,
    this._then,
  );

  final Mutation$UnblockUser$unblockUser$userErrors _instance;

  final TRes Function(Mutation$UnblockUser$unblockUser$userErrors) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? code = _undefined,
    Object? message = _undefined,
    Object? field = _undefined,
  }) => _then(
    Mutation$UnblockUser$unblockUser$userErrors(
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

class _CopyWithStubImpl$Mutation$UnblockUser$unblockUser$userErrors<TRes>
    implements CopyWith$Mutation$UnblockUser$unblockUser$userErrors<TRes> {
  _CopyWithStubImpl$Mutation$UnblockUser$unblockUser$userErrors(this._res);

  TRes _res;

  call({String? code, String? message, String? field}) => _res;
}

class Variables$Mutation$ReportContent {
  factory Variables$Mutation$ReportContent({
    required Enum$ReportTargetType targetType,
    required String targetId,
    required Enum$ReportReason reason,
    String? detail,
  }) => Variables$Mutation$ReportContent._({
    r'targetType': targetType,
    r'targetId': targetId,
    r'reason': reason,
    if (detail != null) r'detail': detail,
  });

  Variables$Mutation$ReportContent._(this._$data);

  factory Variables$Mutation$ReportContent.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$targetType = data['targetType'];
    result$data['targetType'] = fromJson$Enum$ReportTargetType(
      (l$targetType as String),
    );
    final l$targetId = data['targetId'];
    result$data['targetId'] = (l$targetId as String);
    final l$reason = data['reason'];
    result$data['reason'] = fromJson$Enum$ReportReason((l$reason as String));
    if (data.containsKey('detail')) {
      final l$detail = data['detail'];
      result$data['detail'] = (l$detail as String?);
    }
    return Variables$Mutation$ReportContent._(result$data);
  }

  Map<String, dynamic> _$data;

  Enum$ReportTargetType get targetType =>
      (_$data['targetType'] as Enum$ReportTargetType);

  String get targetId => (_$data['targetId'] as String);

  Enum$ReportReason get reason => (_$data['reason'] as Enum$ReportReason);

  String? get detail => (_$data['detail'] as String?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$targetType = targetType;
    result$data['targetType'] = toJson$Enum$ReportTargetType(l$targetType);
    final l$targetId = targetId;
    result$data['targetId'] = l$targetId;
    final l$reason = reason;
    result$data['reason'] = toJson$Enum$ReportReason(l$reason);
    if (_$data.containsKey('detail')) {
      final l$detail = detail;
      result$data['detail'] = l$detail;
    }
    return result$data;
  }

  CopyWith$Variables$Mutation$ReportContent<Variables$Mutation$ReportContent>
  get copyWith => CopyWith$Variables$Mutation$ReportContent(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Mutation$ReportContent ||
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
    final l$reason = reason;
    final lOther$reason = other.reason;
    if (l$reason != lOther$reason) {
      return false;
    }
    final l$detail = detail;
    final lOther$detail = other.detail;
    if (_$data.containsKey('detail') != other._$data.containsKey('detail')) {
      return false;
    }
    if (l$detail != lOther$detail) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$targetType = targetType;
    final l$targetId = targetId;
    final l$reason = reason;
    final l$detail = detail;
    return Object.hashAll([
      l$targetType,
      l$targetId,
      l$reason,
      _$data.containsKey('detail') ? l$detail : const {},
    ]);
  }
}

abstract class CopyWith$Variables$Mutation$ReportContent<TRes> {
  factory CopyWith$Variables$Mutation$ReportContent(
    Variables$Mutation$ReportContent instance,
    TRes Function(Variables$Mutation$ReportContent) then,
  ) = _CopyWithImpl$Variables$Mutation$ReportContent;

  factory CopyWith$Variables$Mutation$ReportContent.stub(TRes res) =
      _CopyWithStubImpl$Variables$Mutation$ReportContent;

  TRes call({
    Enum$ReportTargetType? targetType,
    String? targetId,
    Enum$ReportReason? reason,
    String? detail,
  });
}

class _CopyWithImpl$Variables$Mutation$ReportContent<TRes>
    implements CopyWith$Variables$Mutation$ReportContent<TRes> {
  _CopyWithImpl$Variables$Mutation$ReportContent(this._instance, this._then);

  final Variables$Mutation$ReportContent _instance;

  final TRes Function(Variables$Mutation$ReportContent) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? targetType = _undefined,
    Object? targetId = _undefined,
    Object? reason = _undefined,
    Object? detail = _undefined,
  }) => _then(
    Variables$Mutation$ReportContent._({
      ..._instance._$data,
      if (targetType != _undefined && targetType != null)
        'targetType': (targetType as Enum$ReportTargetType),
      if (targetId != _undefined && targetId != null)
        'targetId': (targetId as String),
      if (reason != _undefined && reason != null)
        'reason': (reason as Enum$ReportReason),
      if (detail != _undefined) 'detail': (detail as String?),
    }),
  );
}

class _CopyWithStubImpl$Variables$Mutation$ReportContent<TRes>
    implements CopyWith$Variables$Mutation$ReportContent<TRes> {
  _CopyWithStubImpl$Variables$Mutation$ReportContent(this._res);

  TRes _res;

  call({
    Enum$ReportTargetType? targetType,
    String? targetId,
    Enum$ReportReason? reason,
    String? detail,
  }) => _res;
}

class Mutation$ReportContent {
  Mutation$ReportContent({required this.reportContent});

  factory Mutation$ReportContent.fromJson(Map<String, dynamic> json) {
    final l$reportContent = json['reportContent'];
    return Mutation$ReportContent(
      reportContent: Mutation$ReportContent$reportContent.fromJson(
        (l$reportContent as Map<String, dynamic>),
      ),
    );
  }

  final Mutation$ReportContent$reportContent reportContent;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$reportContent = reportContent;
    _resultData['reportContent'] = l$reportContent.toJson();
    return _resultData;
  }

  @override
  int get hashCode {
    final l$reportContent = reportContent;
    return Object.hashAll([l$reportContent]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$ReportContent || runtimeType != other.runtimeType) {
      return false;
    }
    final l$reportContent = reportContent;
    final lOther$reportContent = other.reportContent;
    if (l$reportContent != lOther$reportContent) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Mutation$ReportContent on Mutation$ReportContent {
  CopyWith$Mutation$ReportContent<Mutation$ReportContent> get copyWith =>
      CopyWith$Mutation$ReportContent(this, (i) => i);
}

abstract class CopyWith$Mutation$ReportContent<TRes> {
  factory CopyWith$Mutation$ReportContent(
    Mutation$ReportContent instance,
    TRes Function(Mutation$ReportContent) then,
  ) = _CopyWithImpl$Mutation$ReportContent;

  factory CopyWith$Mutation$ReportContent.stub(TRes res) =
      _CopyWithStubImpl$Mutation$ReportContent;

  TRes call({Mutation$ReportContent$reportContent? reportContent});
  CopyWith$Mutation$ReportContent$reportContent<TRes> get reportContent;
}

class _CopyWithImpl$Mutation$ReportContent<TRes>
    implements CopyWith$Mutation$ReportContent<TRes> {
  _CopyWithImpl$Mutation$ReportContent(this._instance, this._then);

  final Mutation$ReportContent _instance;

  final TRes Function(Mutation$ReportContent) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? reportContent = _undefined}) => _then(
    Mutation$ReportContent(
      reportContent: reportContent == _undefined || reportContent == null
          ? _instance.reportContent
          : (reportContent as Mutation$ReportContent$reportContent),
    ),
  );

  CopyWith$Mutation$ReportContent$reportContent<TRes> get reportContent {
    final local$reportContent = _instance.reportContent;
    return CopyWith$Mutation$ReportContent$reportContent(
      local$reportContent,
      (e) => call(reportContent: e),
    );
  }
}

class _CopyWithStubImpl$Mutation$ReportContent<TRes>
    implements CopyWith$Mutation$ReportContent<TRes> {
  _CopyWithStubImpl$Mutation$ReportContent(this._res);

  TRes _res;

  call({Mutation$ReportContent$reportContent? reportContent}) => _res;

  CopyWith$Mutation$ReportContent$reportContent<TRes> get reportContent =>
      CopyWith$Mutation$ReportContent$reportContent.stub(_res);
}

const documentNodeMutationReportContent = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'ReportContent'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'targetType')),
          type: NamedTypeNode(
            name: NameNode(value: 'ReportTargetType'),
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
          variable: VariableNode(name: NameNode(value: 'reason')),
          type: NamedTypeNode(
            name: NameNode(value: 'ReportReason'),
            isNonNull: true,
          ),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'detail')),
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
            name: NameNode(value: 'reportContent'),
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
                      name: NameNode(value: 'reason'),
                      value: VariableNode(name: NameNode(value: 'reason')),
                    ),
                    ObjectFieldNode(
                      name: NameNode(value: 'detail'),
                      value: VariableNode(name: NameNode(value: 'detail')),
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
              ],
            ),
          ),
        ],
      ),
    ),
  ],
);

class Mutation$ReportContent$reportContent {
  Mutation$ReportContent$reportContent({
    required this.success,
    required this.userErrors,
  });

  factory Mutation$ReportContent$reportContent.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$success = json['success'];
    final l$userErrors = json['userErrors'];
    return Mutation$ReportContent$reportContent(
      success: (l$success as bool),
      userErrors: (l$userErrors as List<dynamic>)
          .map(
            (e) => Mutation$ReportContent$reportContent$userErrors.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
    );
  }

  final bool success;

  final List<Mutation$ReportContent$reportContent$userErrors> userErrors;

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
    if (other is! Mutation$ReportContent$reportContent ||
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

extension UtilityExtension$Mutation$ReportContent$reportContent
    on Mutation$ReportContent$reportContent {
  CopyWith$Mutation$ReportContent$reportContent<
    Mutation$ReportContent$reportContent
  >
  get copyWith => CopyWith$Mutation$ReportContent$reportContent(this, (i) => i);
}

abstract class CopyWith$Mutation$ReportContent$reportContent<TRes> {
  factory CopyWith$Mutation$ReportContent$reportContent(
    Mutation$ReportContent$reportContent instance,
    TRes Function(Mutation$ReportContent$reportContent) then,
  ) = _CopyWithImpl$Mutation$ReportContent$reportContent;

  factory CopyWith$Mutation$ReportContent$reportContent.stub(TRes res) =
      _CopyWithStubImpl$Mutation$ReportContent$reportContent;

  TRes call({
    bool? success,
    List<Mutation$ReportContent$reportContent$userErrors>? userErrors,
  });
  TRes userErrors(
    Iterable<Mutation$ReportContent$reportContent$userErrors> Function(
      Iterable<
        CopyWith$Mutation$ReportContent$reportContent$userErrors<
          Mutation$ReportContent$reportContent$userErrors
        >
      >,
    )
    _fn,
  );
}

class _CopyWithImpl$Mutation$ReportContent$reportContent<TRes>
    implements CopyWith$Mutation$ReportContent$reportContent<TRes> {
  _CopyWithImpl$Mutation$ReportContent$reportContent(
    this._instance,
    this._then,
  );

  final Mutation$ReportContent$reportContent _instance;

  final TRes Function(Mutation$ReportContent$reportContent) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? success = _undefined, Object? userErrors = _undefined}) =>
      _then(
        Mutation$ReportContent$reportContent(
          success: success == _undefined || success == null
              ? _instance.success
              : (success as bool),
          userErrors: userErrors == _undefined || userErrors == null
              ? _instance.userErrors
              : (userErrors
                    as List<Mutation$ReportContent$reportContent$userErrors>),
        ),
      );

  TRes userErrors(
    Iterable<Mutation$ReportContent$reportContent$userErrors> Function(
      Iterable<
        CopyWith$Mutation$ReportContent$reportContent$userErrors<
          Mutation$ReportContent$reportContent$userErrors
        >
      >,
    )
    _fn,
  ) => call(
    userErrors: _fn(
      _instance.userErrors.map(
        (e) => CopyWith$Mutation$ReportContent$reportContent$userErrors(
          e,
          (i) => i,
        ),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl$Mutation$ReportContent$reportContent<TRes>
    implements CopyWith$Mutation$ReportContent$reportContent<TRes> {
  _CopyWithStubImpl$Mutation$ReportContent$reportContent(this._res);

  TRes _res;

  call({
    bool? success,
    List<Mutation$ReportContent$reportContent$userErrors>? userErrors,
  }) => _res;

  userErrors(_fn) => _res;
}

class Mutation$ReportContent$reportContent$userErrors {
  Mutation$ReportContent$reportContent$userErrors({
    required this.code,
    required this.message,
    this.field,
  });

  factory Mutation$ReportContent$reportContent$userErrors.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$code = json['code'];
    final l$message = json['message'];
    final l$field = json['field'];
    return Mutation$ReportContent$reportContent$userErrors(
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
    if (other is! Mutation$ReportContent$reportContent$userErrors ||
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

extension UtilityExtension$Mutation$ReportContent$reportContent$userErrors
    on Mutation$ReportContent$reportContent$userErrors {
  CopyWith$Mutation$ReportContent$reportContent$userErrors<
    Mutation$ReportContent$reportContent$userErrors
  >
  get copyWith =>
      CopyWith$Mutation$ReportContent$reportContent$userErrors(this, (i) => i);
}

abstract class CopyWith$Mutation$ReportContent$reportContent$userErrors<TRes> {
  factory CopyWith$Mutation$ReportContent$reportContent$userErrors(
    Mutation$ReportContent$reportContent$userErrors instance,
    TRes Function(Mutation$ReportContent$reportContent$userErrors) then,
  ) = _CopyWithImpl$Mutation$ReportContent$reportContent$userErrors;

  factory CopyWith$Mutation$ReportContent$reportContent$userErrors.stub(
    TRes res,
  ) = _CopyWithStubImpl$Mutation$ReportContent$reportContent$userErrors;

  TRes call({String? code, String? message, String? field});
}

class _CopyWithImpl$Mutation$ReportContent$reportContent$userErrors<TRes>
    implements CopyWith$Mutation$ReportContent$reportContent$userErrors<TRes> {
  _CopyWithImpl$Mutation$ReportContent$reportContent$userErrors(
    this._instance,
    this._then,
  );

  final Mutation$ReportContent$reportContent$userErrors _instance;

  final TRes Function(Mutation$ReportContent$reportContent$userErrors) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? code = _undefined,
    Object? message = _undefined,
    Object? field = _undefined,
  }) => _then(
    Mutation$ReportContent$reportContent$userErrors(
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

class _CopyWithStubImpl$Mutation$ReportContent$reportContent$userErrors<TRes>
    implements CopyWith$Mutation$ReportContent$reportContent$userErrors<TRes> {
  _CopyWithStubImpl$Mutation$ReportContent$reportContent$userErrors(this._res);

  TRes _res;

  call({String? code, String? message, String? field}) => _res;
}

class Variables$Query$NearbySpots {
  factory Variables$Query$NearbySpots({
    required double latitude,
    required double longitude,
    int? radiusMeters,
    List<String>? categories,
    int? page,
    int? size,
  }) => Variables$Query$NearbySpots._({
    r'latitude': latitude,
    r'longitude': longitude,
    if (radiusMeters != null) r'radiusMeters': radiusMeters,
    if (categories != null) r'categories': categories,
    if (page != null) r'page': page,
    if (size != null) r'size': size,
  });

  Variables$Query$NearbySpots._(this._$data);

  factory Variables$Query$NearbySpots.fromJson(Map<String, dynamic> data) {
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
    if (data.containsKey('page')) {
      final l$page = data['page'];
      result$data['page'] = (l$page as int?);
    }
    if (data.containsKey('size')) {
      final l$size = data['size'];
      result$data['size'] = (l$size as int?);
    }
    return Variables$Query$NearbySpots._(result$data);
  }

  Map<String, dynamic> _$data;

  double get latitude => (_$data['latitude'] as double);

  double get longitude => (_$data['longitude'] as double);

  int? get radiusMeters => (_$data['radiusMeters'] as int?);

  List<String>? get categories => (_$data['categories'] as List<String>?);

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

  CopyWith$Variables$Query$NearbySpots<Variables$Query$NearbySpots>
  get copyWith => CopyWith$Variables$Query$NearbySpots(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Query$NearbySpots ||
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
      _$data.containsKey('page') ? l$page : const {},
      _$data.containsKey('size') ? l$size : const {},
    ]);
  }
}

abstract class CopyWith$Variables$Query$NearbySpots<TRes> {
  factory CopyWith$Variables$Query$NearbySpots(
    Variables$Query$NearbySpots instance,
    TRes Function(Variables$Query$NearbySpots) then,
  ) = _CopyWithImpl$Variables$Query$NearbySpots;

  factory CopyWith$Variables$Query$NearbySpots.stub(TRes res) =
      _CopyWithStubImpl$Variables$Query$NearbySpots;

  TRes call({
    double? latitude,
    double? longitude,
    int? radiusMeters,
    List<String>? categories,
    int? page,
    int? size,
  });
}

class _CopyWithImpl$Variables$Query$NearbySpots<TRes>
    implements CopyWith$Variables$Query$NearbySpots<TRes> {
  _CopyWithImpl$Variables$Query$NearbySpots(this._instance, this._then);

  final Variables$Query$NearbySpots _instance;

  final TRes Function(Variables$Query$NearbySpots) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? latitude = _undefined,
    Object? longitude = _undefined,
    Object? radiusMeters = _undefined,
    Object? categories = _undefined,
    Object? page = _undefined,
    Object? size = _undefined,
  }) => _then(
    Variables$Query$NearbySpots._({
      ..._instance._$data,
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

class _CopyWithStubImpl$Variables$Query$NearbySpots<TRes>
    implements CopyWith$Variables$Query$NearbySpots<TRes> {
  _CopyWithStubImpl$Variables$Query$NearbySpots(this._res);

  TRes _res;

  call({
    double? latitude,
    double? longitude,
    int? radiusMeters,
    List<String>? categories,
    int? page,
    int? size,
  }) => _res;
}

class Query$NearbySpots {
  Query$NearbySpots({required this.spots});

  factory Query$NearbySpots.fromJson(Map<String, dynamic> json) {
    final l$spots = json['spots'];
    return Query$NearbySpots(
      spots: Query$NearbySpots$spots.fromJson(
        (l$spots as Map<String, dynamic>),
      ),
    );
  }

  final Query$NearbySpots$spots spots;

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
    if (other is! Query$NearbySpots || runtimeType != other.runtimeType) {
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

extension UtilityExtension$Query$NearbySpots on Query$NearbySpots {
  CopyWith$Query$NearbySpots<Query$NearbySpots> get copyWith =>
      CopyWith$Query$NearbySpots(this, (i) => i);
}

abstract class CopyWith$Query$NearbySpots<TRes> {
  factory CopyWith$Query$NearbySpots(
    Query$NearbySpots instance,
    TRes Function(Query$NearbySpots) then,
  ) = _CopyWithImpl$Query$NearbySpots;

  factory CopyWith$Query$NearbySpots.stub(TRes res) =
      _CopyWithStubImpl$Query$NearbySpots;

  TRes call({Query$NearbySpots$spots? spots});
  CopyWith$Query$NearbySpots$spots<TRes> get spots;
}

class _CopyWithImpl$Query$NearbySpots<TRes>
    implements CopyWith$Query$NearbySpots<TRes> {
  _CopyWithImpl$Query$NearbySpots(this._instance, this._then);

  final Query$NearbySpots _instance;

  final TRes Function(Query$NearbySpots) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? spots = _undefined}) => _then(
    Query$NearbySpots(
      spots: spots == _undefined || spots == null
          ? _instance.spots
          : (spots as Query$NearbySpots$spots),
    ),
  );

  CopyWith$Query$NearbySpots$spots<TRes> get spots {
    final local$spots = _instance.spots;
    return CopyWith$Query$NearbySpots$spots(local$spots, (e) => call(spots: e));
  }
}

class _CopyWithStubImpl$Query$NearbySpots<TRes>
    implements CopyWith$Query$NearbySpots<TRes> {
  _CopyWithStubImpl$Query$NearbySpots(this._res);

  TRes _res;

  call({Query$NearbySpots$spots? spots}) => _res;

  CopyWith$Query$NearbySpots$spots<TRes> get spots =>
      CopyWith$Query$NearbySpots$spots.stub(_res);
}

const documentNodeQueryNearbySpots = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'NearbySpots'),
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

class Query$NearbySpots$spots {
  Query$NearbySpots$spots({
    required this.items,
    required this.page,
    required this.hasNext,
    this.totalCount,
  });

  factory Query$NearbySpots$spots.fromJson(Map<String, dynamic> json) {
    final l$items = json['items'];
    final l$page = json['page'];
    final l$hasNext = json['hasNext'];
    final l$totalCount = json['totalCount'];
    return Query$NearbySpots$spots(
      items: (l$items as List<dynamic>)
          .map(
            (e) => Query$NearbySpots$spots$items.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      page: (l$page as int),
      hasNext: (l$hasNext as bool),
      totalCount: (l$totalCount as int?),
    );
  }

  final List<Query$NearbySpots$spots$items> items;

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
    if (other is! Query$NearbySpots$spots || runtimeType != other.runtimeType) {
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

extension UtilityExtension$Query$NearbySpots$spots on Query$NearbySpots$spots {
  CopyWith$Query$NearbySpots$spots<Query$NearbySpots$spots> get copyWith =>
      CopyWith$Query$NearbySpots$spots(this, (i) => i);
}

abstract class CopyWith$Query$NearbySpots$spots<TRes> {
  factory CopyWith$Query$NearbySpots$spots(
    Query$NearbySpots$spots instance,
    TRes Function(Query$NearbySpots$spots) then,
  ) = _CopyWithImpl$Query$NearbySpots$spots;

  factory CopyWith$Query$NearbySpots$spots.stub(TRes res) =
      _CopyWithStubImpl$Query$NearbySpots$spots;

  TRes call({
    List<Query$NearbySpots$spots$items>? items,
    int? page,
    bool? hasNext,
    int? totalCount,
  });
  TRes items(
    Iterable<Query$NearbySpots$spots$items> Function(
      Iterable<
        CopyWith$Query$NearbySpots$spots$items<Query$NearbySpots$spots$items>
      >,
    )
    _fn,
  );
}

class _CopyWithImpl$Query$NearbySpots$spots<TRes>
    implements CopyWith$Query$NearbySpots$spots<TRes> {
  _CopyWithImpl$Query$NearbySpots$spots(this._instance, this._then);

  final Query$NearbySpots$spots _instance;

  final TRes Function(Query$NearbySpots$spots) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? items = _undefined,
    Object? page = _undefined,
    Object? hasNext = _undefined,
    Object? totalCount = _undefined,
  }) => _then(
    Query$NearbySpots$spots(
      items: items == _undefined || items == null
          ? _instance.items
          : (items as List<Query$NearbySpots$spots$items>),
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
    Iterable<Query$NearbySpots$spots$items> Function(
      Iterable<
        CopyWith$Query$NearbySpots$spots$items<Query$NearbySpots$spots$items>
      >,
    )
    _fn,
  ) => call(
    items: _fn(
      _instance.items.map(
        (e) => CopyWith$Query$NearbySpots$spots$items(e, (i) => i),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl$Query$NearbySpots$spots<TRes>
    implements CopyWith$Query$NearbySpots$spots<TRes> {
  _CopyWithStubImpl$Query$NearbySpots$spots(this._res);

  TRes _res;

  call({
    List<Query$NearbySpots$spots$items>? items,
    int? page,
    bool? hasNext,
    int? totalCount,
  }) => _res;

  items(_fn) => _res;
}

class Query$NearbySpots$spots$items {
  Query$NearbySpots$spots$items({
    required this.id,
    required this.title,
    this.address,
    required this.thumbnailImageUrl,
    required this.distanceMeters,
  });

  factory Query$NearbySpots$spots$items.fromJson(Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$title = json['title'];
    final l$address = json['address'];
    final l$thumbnailImageUrl = json['thumbnailImageUrl'];
    final l$distanceMeters = json['distanceMeters'];
    return Query$NearbySpots$spots$items(
      id: (l$id as String),
      title: (l$title as String),
      address: (l$address as String?),
      thumbnailImageUrl: (l$thumbnailImageUrl as String),
      distanceMeters: (l$distanceMeters as num).toDouble(),
    );
  }

  final String id;

  final String title;

  final String? address;

  final String thumbnailImageUrl;

  final double distanceMeters;

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
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$title = title;
    final l$address = address;
    final l$thumbnailImageUrl = thumbnailImageUrl;
    final l$distanceMeters = distanceMeters;
    return Object.hashAll([
      l$id,
      l$title,
      l$address,
      l$thumbnailImageUrl,
      l$distanceMeters,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$NearbySpots$spots$items ||
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
    return true;
  }
}

extension UtilityExtension$Query$NearbySpots$spots$items
    on Query$NearbySpots$spots$items {
  CopyWith$Query$NearbySpots$spots$items<Query$NearbySpots$spots$items>
  get copyWith => CopyWith$Query$NearbySpots$spots$items(this, (i) => i);
}

abstract class CopyWith$Query$NearbySpots$spots$items<TRes> {
  factory CopyWith$Query$NearbySpots$spots$items(
    Query$NearbySpots$spots$items instance,
    TRes Function(Query$NearbySpots$spots$items) then,
  ) = _CopyWithImpl$Query$NearbySpots$spots$items;

  factory CopyWith$Query$NearbySpots$spots$items.stub(TRes res) =
      _CopyWithStubImpl$Query$NearbySpots$spots$items;

  TRes call({
    String? id,
    String? title,
    String? address,
    String? thumbnailImageUrl,
    double? distanceMeters,
  });
}

class _CopyWithImpl$Query$NearbySpots$spots$items<TRes>
    implements CopyWith$Query$NearbySpots$spots$items<TRes> {
  _CopyWithImpl$Query$NearbySpots$spots$items(this._instance, this._then);

  final Query$NearbySpots$spots$items _instance;

  final TRes Function(Query$NearbySpots$spots$items) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? title = _undefined,
    Object? address = _undefined,
    Object? thumbnailImageUrl = _undefined,
    Object? distanceMeters = _undefined,
  }) => _then(
    Query$NearbySpots$spots$items(
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
    ),
  );
}

class _CopyWithStubImpl$Query$NearbySpots$spots$items<TRes>
    implements CopyWith$Query$NearbySpots$spots$items<TRes> {
  _CopyWithStubImpl$Query$NearbySpots$spots$items(this._res);

  TRes _res;

  call({
    String? id,
    String? title,
    String? address,
    String? thumbnailImageUrl,
    double? distanceMeters,
  }) => _res;
}

class Query$NearbySpotCategories {
  Query$NearbySpotCategories({required this.availableSpotCategories});

  factory Query$NearbySpotCategories.fromJson(Map<String, dynamic> json) {
    final l$availableSpotCategories = json['availableSpotCategories'];
    return Query$NearbySpotCategories(
      availableSpotCategories: (l$availableSpotCategories as List<dynamic>)
          .map(
            (e) => Query$NearbySpotCategories$availableSpotCategories.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
    );
  }

  final List<Query$NearbySpotCategories$availableSpotCategories>
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
    if (other is! Query$NearbySpotCategories ||
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

extension UtilityExtension$Query$NearbySpotCategories
    on Query$NearbySpotCategories {
  CopyWith$Query$NearbySpotCategories<Query$NearbySpotCategories>
  get copyWith => CopyWith$Query$NearbySpotCategories(this, (i) => i);
}

abstract class CopyWith$Query$NearbySpotCategories<TRes> {
  factory CopyWith$Query$NearbySpotCategories(
    Query$NearbySpotCategories instance,
    TRes Function(Query$NearbySpotCategories) then,
  ) = _CopyWithImpl$Query$NearbySpotCategories;

  factory CopyWith$Query$NearbySpotCategories.stub(TRes res) =
      _CopyWithStubImpl$Query$NearbySpotCategories;

  TRes call({
    List<Query$NearbySpotCategories$availableSpotCategories>?
    availableSpotCategories,
  });
  TRes availableSpotCategories(
    Iterable<Query$NearbySpotCategories$availableSpotCategories> Function(
      Iterable<
        CopyWith$Query$NearbySpotCategories$availableSpotCategories<
          Query$NearbySpotCategories$availableSpotCategories
        >
      >,
    )
    _fn,
  );
}

class _CopyWithImpl$Query$NearbySpotCategories<TRes>
    implements CopyWith$Query$NearbySpotCategories<TRes> {
  _CopyWithImpl$Query$NearbySpotCategories(this._instance, this._then);

  final Query$NearbySpotCategories _instance;

  final TRes Function(Query$NearbySpotCategories) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? availableSpotCategories = _undefined}) => _then(
    Query$NearbySpotCategories(
      availableSpotCategories:
          availableSpotCategories == _undefined ||
              availableSpotCategories == null
          ? _instance.availableSpotCategories
          : (availableSpotCategories
                as List<Query$NearbySpotCategories$availableSpotCategories>),
    ),
  );

  TRes availableSpotCategories(
    Iterable<Query$NearbySpotCategories$availableSpotCategories> Function(
      Iterable<
        CopyWith$Query$NearbySpotCategories$availableSpotCategories<
          Query$NearbySpotCategories$availableSpotCategories
        >
      >,
    )
    _fn,
  ) => call(
    availableSpotCategories: _fn(
      _instance.availableSpotCategories.map(
        (e) => CopyWith$Query$NearbySpotCategories$availableSpotCategories(
          e,
          (i) => i,
        ),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl$Query$NearbySpotCategories<TRes>
    implements CopyWith$Query$NearbySpotCategories<TRes> {
  _CopyWithStubImpl$Query$NearbySpotCategories(this._res);

  TRes _res;

  call({
    List<Query$NearbySpotCategories$availableSpotCategories>?
    availableSpotCategories,
  }) => _res;

  availableSpotCategories(_fn) => _res;
}

const documentNodeQueryNearbySpotCategories = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'NearbySpotCategories'),
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

class Query$NearbySpotCategories$availableSpotCategories {
  Query$NearbySpotCategories$availableSpotCategories({
    required this.code,
    required this.label,
    this.iconUrl,
  });

  factory Query$NearbySpotCategories$availableSpotCategories.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$code = json['code'];
    final l$label = json['label'];
    final l$iconUrl = json['iconUrl'];
    return Query$NearbySpotCategories$availableSpotCategories(
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
    if (other is! Query$NearbySpotCategories$availableSpotCategories ||
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

extension UtilityExtension$Query$NearbySpotCategories$availableSpotCategories
    on Query$NearbySpotCategories$availableSpotCategories {
  CopyWith$Query$NearbySpotCategories$availableSpotCategories<
    Query$NearbySpotCategories$availableSpotCategories
  >
  get copyWith => CopyWith$Query$NearbySpotCategories$availableSpotCategories(
    this,
    (i) => i,
  );
}

abstract class CopyWith$Query$NearbySpotCategories$availableSpotCategories<
  TRes
> {
  factory CopyWith$Query$NearbySpotCategories$availableSpotCategories(
    Query$NearbySpotCategories$availableSpotCategories instance,
    TRes Function(Query$NearbySpotCategories$availableSpotCategories) then,
  ) = _CopyWithImpl$Query$NearbySpotCategories$availableSpotCategories;

  factory CopyWith$Query$NearbySpotCategories$availableSpotCategories.stub(
    TRes res,
  ) = _CopyWithStubImpl$Query$NearbySpotCategories$availableSpotCategories;

  TRes call({String? code, String? label, String? iconUrl});
}

class _CopyWithImpl$Query$NearbySpotCategories$availableSpotCategories<TRes>
    implements
        CopyWith$Query$NearbySpotCategories$availableSpotCategories<TRes> {
  _CopyWithImpl$Query$NearbySpotCategories$availableSpotCategories(
    this._instance,
    this._then,
  );

  final Query$NearbySpotCategories$availableSpotCategories _instance;

  final TRes Function(Query$NearbySpotCategories$availableSpotCategories) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? code = _undefined,
    Object? label = _undefined,
    Object? iconUrl = _undefined,
  }) => _then(
    Query$NearbySpotCategories$availableSpotCategories(
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

class _CopyWithStubImpl$Query$NearbySpotCategories$availableSpotCategories<TRes>
    implements
        CopyWith$Query$NearbySpotCategories$availableSpotCategories<TRes> {
  _CopyWithStubImpl$Query$NearbySpotCategories$availableSpotCategories(
    this._res,
  );

  TRes _res;

  call({String? code, String? label, String? iconUrl}) => _res;
}

class Variables$Query$CommunityLikedSpots {
  factory Variables$Query$CommunityLikedSpots({
    List<String>? categories,
    int? first,
    String? after,
  }) => Variables$Query$CommunityLikedSpots._({
    if (categories != null) r'categories': categories,
    if (first != null) r'first': first,
    if (after != null) r'after': after,
  });

  Variables$Query$CommunityLikedSpots._(this._$data);

  factory Variables$Query$CommunityLikedSpots.fromJson(
    Map<String, dynamic> data,
  ) {
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
    return Variables$Query$CommunityLikedSpots._(result$data);
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

  CopyWith$Variables$Query$CommunityLikedSpots<
    Variables$Query$CommunityLikedSpots
  >
  get copyWith => CopyWith$Variables$Query$CommunityLikedSpots(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Query$CommunityLikedSpots ||
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

abstract class CopyWith$Variables$Query$CommunityLikedSpots<TRes> {
  factory CopyWith$Variables$Query$CommunityLikedSpots(
    Variables$Query$CommunityLikedSpots instance,
    TRes Function(Variables$Query$CommunityLikedSpots) then,
  ) = _CopyWithImpl$Variables$Query$CommunityLikedSpots;

  factory CopyWith$Variables$Query$CommunityLikedSpots.stub(TRes res) =
      _CopyWithStubImpl$Variables$Query$CommunityLikedSpots;

  TRes call({List<String>? categories, int? first, String? after});
}

class _CopyWithImpl$Variables$Query$CommunityLikedSpots<TRes>
    implements CopyWith$Variables$Query$CommunityLikedSpots<TRes> {
  _CopyWithImpl$Variables$Query$CommunityLikedSpots(this._instance, this._then);

  final Variables$Query$CommunityLikedSpots _instance;

  final TRes Function(Variables$Query$CommunityLikedSpots) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? categories = _undefined,
    Object? first = _undefined,
    Object? after = _undefined,
  }) => _then(
    Variables$Query$CommunityLikedSpots._({
      ..._instance._$data,
      if (categories != _undefined) 'categories': (categories as List<String>?),
      if (first != _undefined) 'first': (first as int?),
      if (after != _undefined) 'after': (after as String?),
    }),
  );
}

class _CopyWithStubImpl$Variables$Query$CommunityLikedSpots<TRes>
    implements CopyWith$Variables$Query$CommunityLikedSpots<TRes> {
  _CopyWithStubImpl$Variables$Query$CommunityLikedSpots(this._res);

  TRes _res;

  call({List<String>? categories, int? first, String? after}) => _res;
}

class Query$CommunityLikedSpots {
  Query$CommunityLikedSpots({required this.likedSpots});

  factory Query$CommunityLikedSpots.fromJson(Map<String, dynamic> json) {
    final l$likedSpots = json['likedSpots'];
    return Query$CommunityLikedSpots(
      likedSpots: Query$CommunityLikedSpots$likedSpots.fromJson(
        (l$likedSpots as Map<String, dynamic>),
      ),
    );
  }

  final Query$CommunityLikedSpots$likedSpots likedSpots;

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
    if (other is! Query$CommunityLikedSpots ||
        runtimeType != other.runtimeType) {
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

extension UtilityExtension$Query$CommunityLikedSpots
    on Query$CommunityLikedSpots {
  CopyWith$Query$CommunityLikedSpots<Query$CommunityLikedSpots> get copyWith =>
      CopyWith$Query$CommunityLikedSpots(this, (i) => i);
}

abstract class CopyWith$Query$CommunityLikedSpots<TRes> {
  factory CopyWith$Query$CommunityLikedSpots(
    Query$CommunityLikedSpots instance,
    TRes Function(Query$CommunityLikedSpots) then,
  ) = _CopyWithImpl$Query$CommunityLikedSpots;

  factory CopyWith$Query$CommunityLikedSpots.stub(TRes res) =
      _CopyWithStubImpl$Query$CommunityLikedSpots;

  TRes call({Query$CommunityLikedSpots$likedSpots? likedSpots});
  CopyWith$Query$CommunityLikedSpots$likedSpots<TRes> get likedSpots;
}

class _CopyWithImpl$Query$CommunityLikedSpots<TRes>
    implements CopyWith$Query$CommunityLikedSpots<TRes> {
  _CopyWithImpl$Query$CommunityLikedSpots(this._instance, this._then);

  final Query$CommunityLikedSpots _instance;

  final TRes Function(Query$CommunityLikedSpots) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? likedSpots = _undefined}) => _then(
    Query$CommunityLikedSpots(
      likedSpots: likedSpots == _undefined || likedSpots == null
          ? _instance.likedSpots
          : (likedSpots as Query$CommunityLikedSpots$likedSpots),
    ),
  );

  CopyWith$Query$CommunityLikedSpots$likedSpots<TRes> get likedSpots {
    final local$likedSpots = _instance.likedSpots;
    return CopyWith$Query$CommunityLikedSpots$likedSpots(
      local$likedSpots,
      (e) => call(likedSpots: e),
    );
  }
}

class _CopyWithStubImpl$Query$CommunityLikedSpots<TRes>
    implements CopyWith$Query$CommunityLikedSpots<TRes> {
  _CopyWithStubImpl$Query$CommunityLikedSpots(this._res);

  TRes _res;

  call({Query$CommunityLikedSpots$likedSpots? likedSpots}) => _res;

  CopyWith$Query$CommunityLikedSpots$likedSpots<TRes> get likedSpots =>
      CopyWith$Query$CommunityLikedSpots$likedSpots.stub(_res);
}

const documentNodeQueryCommunityLikedSpots = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'CommunityLikedSpots'),
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

class Query$CommunityLikedSpots$likedSpots {
  Query$CommunityLikedSpots$likedSpots({
    required this.edges,
    required this.pageInfo,
  });

  factory Query$CommunityLikedSpots$likedSpots.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$edges = json['edges'];
    final l$pageInfo = json['pageInfo'];
    return Query$CommunityLikedSpots$likedSpots(
      edges: (l$edges as List<dynamic>)
          .map(
            (e) => Query$CommunityLikedSpots$likedSpots$edges.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      pageInfo: Query$CommunityLikedSpots$likedSpots$pageInfo.fromJson(
        (l$pageInfo as Map<String, dynamic>),
      ),
    );
  }

  final List<Query$CommunityLikedSpots$likedSpots$edges> edges;

  final Query$CommunityLikedSpots$likedSpots$pageInfo pageInfo;

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
    if (other is! Query$CommunityLikedSpots$likedSpots ||
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

extension UtilityExtension$Query$CommunityLikedSpots$likedSpots
    on Query$CommunityLikedSpots$likedSpots {
  CopyWith$Query$CommunityLikedSpots$likedSpots<
    Query$CommunityLikedSpots$likedSpots
  >
  get copyWith => CopyWith$Query$CommunityLikedSpots$likedSpots(this, (i) => i);
}

abstract class CopyWith$Query$CommunityLikedSpots$likedSpots<TRes> {
  factory CopyWith$Query$CommunityLikedSpots$likedSpots(
    Query$CommunityLikedSpots$likedSpots instance,
    TRes Function(Query$CommunityLikedSpots$likedSpots) then,
  ) = _CopyWithImpl$Query$CommunityLikedSpots$likedSpots;

  factory CopyWith$Query$CommunityLikedSpots$likedSpots.stub(TRes res) =
      _CopyWithStubImpl$Query$CommunityLikedSpots$likedSpots;

  TRes call({
    List<Query$CommunityLikedSpots$likedSpots$edges>? edges,
    Query$CommunityLikedSpots$likedSpots$pageInfo? pageInfo,
  });
  TRes edges(
    Iterable<Query$CommunityLikedSpots$likedSpots$edges> Function(
      Iterable<
        CopyWith$Query$CommunityLikedSpots$likedSpots$edges<
          Query$CommunityLikedSpots$likedSpots$edges
        >
      >,
    )
    _fn,
  );
  CopyWith$Query$CommunityLikedSpots$likedSpots$pageInfo<TRes> get pageInfo;
}

class _CopyWithImpl$Query$CommunityLikedSpots$likedSpots<TRes>
    implements CopyWith$Query$CommunityLikedSpots$likedSpots<TRes> {
  _CopyWithImpl$Query$CommunityLikedSpots$likedSpots(
    this._instance,
    this._then,
  );

  final Query$CommunityLikedSpots$likedSpots _instance;

  final TRes Function(Query$CommunityLikedSpots$likedSpots) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? edges = _undefined, Object? pageInfo = _undefined}) =>
      _then(
        Query$CommunityLikedSpots$likedSpots(
          edges: edges == _undefined || edges == null
              ? _instance.edges
              : (edges as List<Query$CommunityLikedSpots$likedSpots$edges>),
          pageInfo: pageInfo == _undefined || pageInfo == null
              ? _instance.pageInfo
              : (pageInfo as Query$CommunityLikedSpots$likedSpots$pageInfo),
        ),
      );

  TRes edges(
    Iterable<Query$CommunityLikedSpots$likedSpots$edges> Function(
      Iterable<
        CopyWith$Query$CommunityLikedSpots$likedSpots$edges<
          Query$CommunityLikedSpots$likedSpots$edges
        >
      >,
    )
    _fn,
  ) => call(
    edges: _fn(
      _instance.edges.map(
        (e) => CopyWith$Query$CommunityLikedSpots$likedSpots$edges(e, (i) => i),
      ),
    ).toList(),
  );

  CopyWith$Query$CommunityLikedSpots$likedSpots$pageInfo<TRes> get pageInfo {
    final local$pageInfo = _instance.pageInfo;
    return CopyWith$Query$CommunityLikedSpots$likedSpots$pageInfo(
      local$pageInfo,
      (e) => call(pageInfo: e),
    );
  }
}

class _CopyWithStubImpl$Query$CommunityLikedSpots$likedSpots<TRes>
    implements CopyWith$Query$CommunityLikedSpots$likedSpots<TRes> {
  _CopyWithStubImpl$Query$CommunityLikedSpots$likedSpots(this._res);

  TRes _res;

  call({
    List<Query$CommunityLikedSpots$likedSpots$edges>? edges,
    Query$CommunityLikedSpots$likedSpots$pageInfo? pageInfo,
  }) => _res;

  edges(_fn) => _res;

  CopyWith$Query$CommunityLikedSpots$likedSpots$pageInfo<TRes> get pageInfo =>
      CopyWith$Query$CommunityLikedSpots$likedSpots$pageInfo.stub(_res);
}

class Query$CommunityLikedSpots$likedSpots$edges {
  Query$CommunityLikedSpots$likedSpots$edges({
    required this.cursor,
    required this.node,
  });

  factory Query$CommunityLikedSpots$likedSpots$edges.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$cursor = json['cursor'];
    final l$node = json['node'];
    return Query$CommunityLikedSpots$likedSpots$edges(
      cursor: (l$cursor as String),
      node: Query$CommunityLikedSpots$likedSpots$edges$node.fromJson(
        (l$node as Map<String, dynamic>),
      ),
    );
  }

  final String cursor;

  final Query$CommunityLikedSpots$likedSpots$edges$node node;

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
    if (other is! Query$CommunityLikedSpots$likedSpots$edges ||
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

extension UtilityExtension$Query$CommunityLikedSpots$likedSpots$edges
    on Query$CommunityLikedSpots$likedSpots$edges {
  CopyWith$Query$CommunityLikedSpots$likedSpots$edges<
    Query$CommunityLikedSpots$likedSpots$edges
  >
  get copyWith =>
      CopyWith$Query$CommunityLikedSpots$likedSpots$edges(this, (i) => i);
}

abstract class CopyWith$Query$CommunityLikedSpots$likedSpots$edges<TRes> {
  factory CopyWith$Query$CommunityLikedSpots$likedSpots$edges(
    Query$CommunityLikedSpots$likedSpots$edges instance,
    TRes Function(Query$CommunityLikedSpots$likedSpots$edges) then,
  ) = _CopyWithImpl$Query$CommunityLikedSpots$likedSpots$edges;

  factory CopyWith$Query$CommunityLikedSpots$likedSpots$edges.stub(TRes res) =
      _CopyWithStubImpl$Query$CommunityLikedSpots$likedSpots$edges;

  TRes call({
    String? cursor,
    Query$CommunityLikedSpots$likedSpots$edges$node? node,
  });
  CopyWith$Query$CommunityLikedSpots$likedSpots$edges$node<TRes> get node;
}

class _CopyWithImpl$Query$CommunityLikedSpots$likedSpots$edges<TRes>
    implements CopyWith$Query$CommunityLikedSpots$likedSpots$edges<TRes> {
  _CopyWithImpl$Query$CommunityLikedSpots$likedSpots$edges(
    this._instance,
    this._then,
  );

  final Query$CommunityLikedSpots$likedSpots$edges _instance;

  final TRes Function(Query$CommunityLikedSpots$likedSpots$edges) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? cursor = _undefined, Object? node = _undefined}) => _then(
    Query$CommunityLikedSpots$likedSpots$edges(
      cursor: cursor == _undefined || cursor == null
          ? _instance.cursor
          : (cursor as String),
      node: node == _undefined || node == null
          ? _instance.node
          : (node as Query$CommunityLikedSpots$likedSpots$edges$node),
    ),
  );

  CopyWith$Query$CommunityLikedSpots$likedSpots$edges$node<TRes> get node {
    final local$node = _instance.node;
    return CopyWith$Query$CommunityLikedSpots$likedSpots$edges$node(
      local$node,
      (e) => call(node: e),
    );
  }
}

class _CopyWithStubImpl$Query$CommunityLikedSpots$likedSpots$edges<TRes>
    implements CopyWith$Query$CommunityLikedSpots$likedSpots$edges<TRes> {
  _CopyWithStubImpl$Query$CommunityLikedSpots$likedSpots$edges(this._res);

  TRes _res;

  call({
    String? cursor,
    Query$CommunityLikedSpots$likedSpots$edges$node? node,
  }) => _res;

  CopyWith$Query$CommunityLikedSpots$likedSpots$edges$node<TRes> get node =>
      CopyWith$Query$CommunityLikedSpots$likedSpots$edges$node.stub(_res);
}

class Query$CommunityLikedSpots$likedSpots$edges$node {
  Query$CommunityLikedSpots$likedSpots$edges$node({
    required this.id,
    required this.title,
    required this.thumbnailImageUrl,
    this.address,
  });

  factory Query$CommunityLikedSpots$likedSpots$edges$node.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$title = json['title'];
    final l$thumbnailImageUrl = json['thumbnailImageUrl'];
    final l$address = json['address'];
    return Query$CommunityLikedSpots$likedSpots$edges$node(
      id: (l$id as String),
      title: (l$title as String),
      thumbnailImageUrl: (l$thumbnailImageUrl as String),
      address: (l$address as String?),
    );
  }

  final String id;

  final String title;

  final String thumbnailImageUrl;

  final String? address;

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
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$title = title;
    final l$thumbnailImageUrl = thumbnailImageUrl;
    final l$address = address;
    return Object.hashAll([l$id, l$title, l$thumbnailImageUrl, l$address]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$CommunityLikedSpots$likedSpots$edges$node ||
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
    return true;
  }
}

extension UtilityExtension$Query$CommunityLikedSpots$likedSpots$edges$node
    on Query$CommunityLikedSpots$likedSpots$edges$node {
  CopyWith$Query$CommunityLikedSpots$likedSpots$edges$node<
    Query$CommunityLikedSpots$likedSpots$edges$node
  >
  get copyWith =>
      CopyWith$Query$CommunityLikedSpots$likedSpots$edges$node(this, (i) => i);
}

abstract class CopyWith$Query$CommunityLikedSpots$likedSpots$edges$node<TRes> {
  factory CopyWith$Query$CommunityLikedSpots$likedSpots$edges$node(
    Query$CommunityLikedSpots$likedSpots$edges$node instance,
    TRes Function(Query$CommunityLikedSpots$likedSpots$edges$node) then,
  ) = _CopyWithImpl$Query$CommunityLikedSpots$likedSpots$edges$node;

  factory CopyWith$Query$CommunityLikedSpots$likedSpots$edges$node.stub(
    TRes res,
  ) = _CopyWithStubImpl$Query$CommunityLikedSpots$likedSpots$edges$node;

  TRes call({
    String? id,
    String? title,
    String? thumbnailImageUrl,
    String? address,
  });
}

class _CopyWithImpl$Query$CommunityLikedSpots$likedSpots$edges$node<TRes>
    implements CopyWith$Query$CommunityLikedSpots$likedSpots$edges$node<TRes> {
  _CopyWithImpl$Query$CommunityLikedSpots$likedSpots$edges$node(
    this._instance,
    this._then,
  );

  final Query$CommunityLikedSpots$likedSpots$edges$node _instance;

  final TRes Function(Query$CommunityLikedSpots$likedSpots$edges$node) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? title = _undefined,
    Object? thumbnailImageUrl = _undefined,
    Object? address = _undefined,
  }) => _then(
    Query$CommunityLikedSpots$likedSpots$edges$node(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      title: title == _undefined || title == null
          ? _instance.title
          : (title as String),
      thumbnailImageUrl:
          thumbnailImageUrl == _undefined || thumbnailImageUrl == null
          ? _instance.thumbnailImageUrl
          : (thumbnailImageUrl as String),
      address: address == _undefined ? _instance.address : (address as String?),
    ),
  );
}

class _CopyWithStubImpl$Query$CommunityLikedSpots$likedSpots$edges$node<TRes>
    implements CopyWith$Query$CommunityLikedSpots$likedSpots$edges$node<TRes> {
  _CopyWithStubImpl$Query$CommunityLikedSpots$likedSpots$edges$node(this._res);

  TRes _res;

  call({
    String? id,
    String? title,
    String? thumbnailImageUrl,
    String? address,
  }) => _res;
}

class Query$CommunityLikedSpots$likedSpots$pageInfo {
  Query$CommunityLikedSpots$likedSpots$pageInfo({
    required this.hasNextPage,
    this.endCursor,
  });

  factory Query$CommunityLikedSpots$likedSpots$pageInfo.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$hasNextPage = json['hasNextPage'];
    final l$endCursor = json['endCursor'];
    return Query$CommunityLikedSpots$likedSpots$pageInfo(
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
    if (other is! Query$CommunityLikedSpots$likedSpots$pageInfo ||
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

extension UtilityExtension$Query$CommunityLikedSpots$likedSpots$pageInfo
    on Query$CommunityLikedSpots$likedSpots$pageInfo {
  CopyWith$Query$CommunityLikedSpots$likedSpots$pageInfo<
    Query$CommunityLikedSpots$likedSpots$pageInfo
  >
  get copyWith =>
      CopyWith$Query$CommunityLikedSpots$likedSpots$pageInfo(this, (i) => i);
}

abstract class CopyWith$Query$CommunityLikedSpots$likedSpots$pageInfo<TRes> {
  factory CopyWith$Query$CommunityLikedSpots$likedSpots$pageInfo(
    Query$CommunityLikedSpots$likedSpots$pageInfo instance,
    TRes Function(Query$CommunityLikedSpots$likedSpots$pageInfo) then,
  ) = _CopyWithImpl$Query$CommunityLikedSpots$likedSpots$pageInfo;

  factory CopyWith$Query$CommunityLikedSpots$likedSpots$pageInfo.stub(
    TRes res,
  ) = _CopyWithStubImpl$Query$CommunityLikedSpots$likedSpots$pageInfo;

  TRes call({bool? hasNextPage, String? endCursor});
}

class _CopyWithImpl$Query$CommunityLikedSpots$likedSpots$pageInfo<TRes>
    implements CopyWith$Query$CommunityLikedSpots$likedSpots$pageInfo<TRes> {
  _CopyWithImpl$Query$CommunityLikedSpots$likedSpots$pageInfo(
    this._instance,
    this._then,
  );

  final Query$CommunityLikedSpots$likedSpots$pageInfo _instance;

  final TRes Function(Query$CommunityLikedSpots$likedSpots$pageInfo) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? hasNextPage = _undefined,
    Object? endCursor = _undefined,
  }) => _then(
    Query$CommunityLikedSpots$likedSpots$pageInfo(
      hasNextPage: hasNextPage == _undefined || hasNextPage == null
          ? _instance.hasNextPage
          : (hasNextPage as bool),
      endCursor: endCursor == _undefined
          ? _instance.endCursor
          : (endCursor as String?),
    ),
  );
}

class _CopyWithStubImpl$Query$CommunityLikedSpots$likedSpots$pageInfo<TRes>
    implements CopyWith$Query$CommunityLikedSpots$likedSpots$pageInfo<TRes> {
  _CopyWithStubImpl$Query$CommunityLikedSpots$likedSpots$pageInfo(this._res);

  TRes _res;

  call({bool? hasNextPage, String? endCursor}) => _res;
}

class Variables$Query$CommunitySearchSpots {
  factory Variables$Query$CommunitySearchSpots({
    required String query,
    required double latitude,
    required double longitude,
    int? radiusMeters,
    List<String>? categories,
    int? page,
    int? size,
  }) => Variables$Query$CommunitySearchSpots._({
    r'query': query,
    r'latitude': latitude,
    r'longitude': longitude,
    if (radiusMeters != null) r'radiusMeters': radiusMeters,
    if (categories != null) r'categories': categories,
    if (page != null) r'page': page,
    if (size != null) r'size': size,
  });

  Variables$Query$CommunitySearchSpots._(this._$data);

  factory Variables$Query$CommunitySearchSpots.fromJson(
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
    return Variables$Query$CommunitySearchSpots._(result$data);
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

  CopyWith$Variables$Query$CommunitySearchSpots<
    Variables$Query$CommunitySearchSpots
  >
  get copyWith => CopyWith$Variables$Query$CommunitySearchSpots(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Query$CommunitySearchSpots ||
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

abstract class CopyWith$Variables$Query$CommunitySearchSpots<TRes> {
  factory CopyWith$Variables$Query$CommunitySearchSpots(
    Variables$Query$CommunitySearchSpots instance,
    TRes Function(Variables$Query$CommunitySearchSpots) then,
  ) = _CopyWithImpl$Variables$Query$CommunitySearchSpots;

  factory CopyWith$Variables$Query$CommunitySearchSpots.stub(TRes res) =
      _CopyWithStubImpl$Variables$Query$CommunitySearchSpots;

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

class _CopyWithImpl$Variables$Query$CommunitySearchSpots<TRes>
    implements CopyWith$Variables$Query$CommunitySearchSpots<TRes> {
  _CopyWithImpl$Variables$Query$CommunitySearchSpots(
    this._instance,
    this._then,
  );

  final Variables$Query$CommunitySearchSpots _instance;

  final TRes Function(Variables$Query$CommunitySearchSpots) _then;

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
    Variables$Query$CommunitySearchSpots._({
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

class _CopyWithStubImpl$Variables$Query$CommunitySearchSpots<TRes>
    implements CopyWith$Variables$Query$CommunitySearchSpots<TRes> {
  _CopyWithStubImpl$Variables$Query$CommunitySearchSpots(this._res);

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

class Query$CommunitySearchSpots {
  Query$CommunitySearchSpots({required this.searchSpots});

  factory Query$CommunitySearchSpots.fromJson(Map<String, dynamic> json) {
    final l$searchSpots = json['searchSpots'];
    return Query$CommunitySearchSpots(
      searchSpots: Query$CommunitySearchSpots$searchSpots.fromJson(
        (l$searchSpots as Map<String, dynamic>),
      ),
    );
  }

  final Query$CommunitySearchSpots$searchSpots searchSpots;

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
    if (other is! Query$CommunitySearchSpots ||
        runtimeType != other.runtimeType) {
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

extension UtilityExtension$Query$CommunitySearchSpots
    on Query$CommunitySearchSpots {
  CopyWith$Query$CommunitySearchSpots<Query$CommunitySearchSpots>
  get copyWith => CopyWith$Query$CommunitySearchSpots(this, (i) => i);
}

abstract class CopyWith$Query$CommunitySearchSpots<TRes> {
  factory CopyWith$Query$CommunitySearchSpots(
    Query$CommunitySearchSpots instance,
    TRes Function(Query$CommunitySearchSpots) then,
  ) = _CopyWithImpl$Query$CommunitySearchSpots;

  factory CopyWith$Query$CommunitySearchSpots.stub(TRes res) =
      _CopyWithStubImpl$Query$CommunitySearchSpots;

  TRes call({Query$CommunitySearchSpots$searchSpots? searchSpots});
  CopyWith$Query$CommunitySearchSpots$searchSpots<TRes> get searchSpots;
}

class _CopyWithImpl$Query$CommunitySearchSpots<TRes>
    implements CopyWith$Query$CommunitySearchSpots<TRes> {
  _CopyWithImpl$Query$CommunitySearchSpots(this._instance, this._then);

  final Query$CommunitySearchSpots _instance;

  final TRes Function(Query$CommunitySearchSpots) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? searchSpots = _undefined}) => _then(
    Query$CommunitySearchSpots(
      searchSpots: searchSpots == _undefined || searchSpots == null
          ? _instance.searchSpots
          : (searchSpots as Query$CommunitySearchSpots$searchSpots),
    ),
  );

  CopyWith$Query$CommunitySearchSpots$searchSpots<TRes> get searchSpots {
    final local$searchSpots = _instance.searchSpots;
    return CopyWith$Query$CommunitySearchSpots$searchSpots(
      local$searchSpots,
      (e) => call(searchSpots: e),
    );
  }
}

class _CopyWithStubImpl$Query$CommunitySearchSpots<TRes>
    implements CopyWith$Query$CommunitySearchSpots<TRes> {
  _CopyWithStubImpl$Query$CommunitySearchSpots(this._res);

  TRes _res;

  call({Query$CommunitySearchSpots$searchSpots? searchSpots}) => _res;

  CopyWith$Query$CommunitySearchSpots$searchSpots<TRes> get searchSpots =>
      CopyWith$Query$CommunitySearchSpots$searchSpots.stub(_res);
}

const documentNodeQueryCommunitySearchSpots = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'CommunitySearchSpots'),
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

class Query$CommunitySearchSpots$searchSpots {
  Query$CommunitySearchSpots$searchSpots({
    required this.success,
    required this.userErrors,
    required this.connection,
  });

  factory Query$CommunitySearchSpots$searchSpots.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$success = json['success'];
    final l$userErrors = json['userErrors'];
    final l$connection = json['connection'];
    return Query$CommunitySearchSpots$searchSpots(
      success: (l$success as bool),
      userErrors: (l$userErrors as List<dynamic>)
          .map(
            (e) => Query$CommunitySearchSpots$searchSpots$userErrors.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      connection: Query$CommunitySearchSpots$searchSpots$connection.fromJson(
        (l$connection as Map<String, dynamic>),
      ),
    );
  }

  final bool success;

  final List<Query$CommunitySearchSpots$searchSpots$userErrors> userErrors;

  final Query$CommunitySearchSpots$searchSpots$connection connection;

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
    if (other is! Query$CommunitySearchSpots$searchSpots ||
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

extension UtilityExtension$Query$CommunitySearchSpots$searchSpots
    on Query$CommunitySearchSpots$searchSpots {
  CopyWith$Query$CommunitySearchSpots$searchSpots<
    Query$CommunitySearchSpots$searchSpots
  >
  get copyWith =>
      CopyWith$Query$CommunitySearchSpots$searchSpots(this, (i) => i);
}

abstract class CopyWith$Query$CommunitySearchSpots$searchSpots<TRes> {
  factory CopyWith$Query$CommunitySearchSpots$searchSpots(
    Query$CommunitySearchSpots$searchSpots instance,
    TRes Function(Query$CommunitySearchSpots$searchSpots) then,
  ) = _CopyWithImpl$Query$CommunitySearchSpots$searchSpots;

  factory CopyWith$Query$CommunitySearchSpots$searchSpots.stub(TRes res) =
      _CopyWithStubImpl$Query$CommunitySearchSpots$searchSpots;

  TRes call({
    bool? success,
    List<Query$CommunitySearchSpots$searchSpots$userErrors>? userErrors,
    Query$CommunitySearchSpots$searchSpots$connection? connection,
  });
  TRes userErrors(
    Iterable<Query$CommunitySearchSpots$searchSpots$userErrors> Function(
      Iterable<
        CopyWith$Query$CommunitySearchSpots$searchSpots$userErrors<
          Query$CommunitySearchSpots$searchSpots$userErrors
        >
      >,
    )
    _fn,
  );
  CopyWith$Query$CommunitySearchSpots$searchSpots$connection<TRes>
  get connection;
}

class _CopyWithImpl$Query$CommunitySearchSpots$searchSpots<TRes>
    implements CopyWith$Query$CommunitySearchSpots$searchSpots<TRes> {
  _CopyWithImpl$Query$CommunitySearchSpots$searchSpots(
    this._instance,
    this._then,
  );

  final Query$CommunitySearchSpots$searchSpots _instance;

  final TRes Function(Query$CommunitySearchSpots$searchSpots) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? success = _undefined,
    Object? userErrors = _undefined,
    Object? connection = _undefined,
  }) => _then(
    Query$CommunitySearchSpots$searchSpots(
      success: success == _undefined || success == null
          ? _instance.success
          : (success as bool),
      userErrors: userErrors == _undefined || userErrors == null
          ? _instance.userErrors
          : (userErrors
                as List<Query$CommunitySearchSpots$searchSpots$userErrors>),
      connection: connection == _undefined || connection == null
          ? _instance.connection
          : (connection as Query$CommunitySearchSpots$searchSpots$connection),
    ),
  );

  TRes userErrors(
    Iterable<Query$CommunitySearchSpots$searchSpots$userErrors> Function(
      Iterable<
        CopyWith$Query$CommunitySearchSpots$searchSpots$userErrors<
          Query$CommunitySearchSpots$searchSpots$userErrors
        >
      >,
    )
    _fn,
  ) => call(
    userErrors: _fn(
      _instance.userErrors.map(
        (e) => CopyWith$Query$CommunitySearchSpots$searchSpots$userErrors(
          e,
          (i) => i,
        ),
      ),
    ).toList(),
  );

  CopyWith$Query$CommunitySearchSpots$searchSpots$connection<TRes>
  get connection {
    final local$connection = _instance.connection;
    return CopyWith$Query$CommunitySearchSpots$searchSpots$connection(
      local$connection,
      (e) => call(connection: e),
    );
  }
}

class _CopyWithStubImpl$Query$CommunitySearchSpots$searchSpots<TRes>
    implements CopyWith$Query$CommunitySearchSpots$searchSpots<TRes> {
  _CopyWithStubImpl$Query$CommunitySearchSpots$searchSpots(this._res);

  TRes _res;

  call({
    bool? success,
    List<Query$CommunitySearchSpots$searchSpots$userErrors>? userErrors,
    Query$CommunitySearchSpots$searchSpots$connection? connection,
  }) => _res;

  userErrors(_fn) => _res;

  CopyWith$Query$CommunitySearchSpots$searchSpots$connection<TRes>
  get connection =>
      CopyWith$Query$CommunitySearchSpots$searchSpots$connection.stub(_res);
}

class Query$CommunitySearchSpots$searchSpots$userErrors {
  Query$CommunitySearchSpots$searchSpots$userErrors({
    required this.code,
    this.field,
  });

  factory Query$CommunitySearchSpots$searchSpots$userErrors.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$code = json['code'];
    final l$field = json['field'];
    return Query$CommunitySearchSpots$searchSpots$userErrors(
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
    if (other is! Query$CommunitySearchSpots$searchSpots$userErrors ||
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

extension UtilityExtension$Query$CommunitySearchSpots$searchSpots$userErrors
    on Query$CommunitySearchSpots$searchSpots$userErrors {
  CopyWith$Query$CommunitySearchSpots$searchSpots$userErrors<
    Query$CommunitySearchSpots$searchSpots$userErrors
  >
  get copyWith => CopyWith$Query$CommunitySearchSpots$searchSpots$userErrors(
    this,
    (i) => i,
  );
}

abstract class CopyWith$Query$CommunitySearchSpots$searchSpots$userErrors<
  TRes
> {
  factory CopyWith$Query$CommunitySearchSpots$searchSpots$userErrors(
    Query$CommunitySearchSpots$searchSpots$userErrors instance,
    TRes Function(Query$CommunitySearchSpots$searchSpots$userErrors) then,
  ) = _CopyWithImpl$Query$CommunitySearchSpots$searchSpots$userErrors;

  factory CopyWith$Query$CommunitySearchSpots$searchSpots$userErrors.stub(
    TRes res,
  ) = _CopyWithStubImpl$Query$CommunitySearchSpots$searchSpots$userErrors;

  TRes call({String? code, String? field});
}

class _CopyWithImpl$Query$CommunitySearchSpots$searchSpots$userErrors<TRes>
    implements
        CopyWith$Query$CommunitySearchSpots$searchSpots$userErrors<TRes> {
  _CopyWithImpl$Query$CommunitySearchSpots$searchSpots$userErrors(
    this._instance,
    this._then,
  );

  final Query$CommunitySearchSpots$searchSpots$userErrors _instance;

  final TRes Function(Query$CommunitySearchSpots$searchSpots$userErrors) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? code = _undefined, Object? field = _undefined}) => _then(
    Query$CommunitySearchSpots$searchSpots$userErrors(
      code: code == _undefined || code == null
          ? _instance.code
          : (code as String),
      field: field == _undefined ? _instance.field : (field as String?),
    ),
  );
}

class _CopyWithStubImpl$Query$CommunitySearchSpots$searchSpots$userErrors<TRes>
    implements
        CopyWith$Query$CommunitySearchSpots$searchSpots$userErrors<TRes> {
  _CopyWithStubImpl$Query$CommunitySearchSpots$searchSpots$userErrors(
    this._res,
  );

  TRes _res;

  call({String? code, String? field}) => _res;
}

class Query$CommunitySearchSpots$searchSpots$connection {
  Query$CommunitySearchSpots$searchSpots$connection({
    required this.items,
    required this.page,
    required this.hasNext,
    required this.totalCount,
  });

  factory Query$CommunitySearchSpots$searchSpots$connection.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$items = json['items'];
    final l$page = json['page'];
    final l$hasNext = json['hasNext'];
    final l$totalCount = json['totalCount'];
    return Query$CommunitySearchSpots$searchSpots$connection(
      items: (l$items as List<dynamic>)
          .map(
            (e) =>
                Query$CommunitySearchSpots$searchSpots$connection$items.fromJson(
                  (e as Map<String, dynamic>),
                ),
          )
          .toList(),
      page: (l$page as int),
      hasNext: (l$hasNext as bool),
      totalCount: (l$totalCount as int),
    );
  }

  final List<Query$CommunitySearchSpots$searchSpots$connection$items> items;

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
    if (other is! Query$CommunitySearchSpots$searchSpots$connection ||
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

extension UtilityExtension$Query$CommunitySearchSpots$searchSpots$connection
    on Query$CommunitySearchSpots$searchSpots$connection {
  CopyWith$Query$CommunitySearchSpots$searchSpots$connection<
    Query$CommunitySearchSpots$searchSpots$connection
  >
  get copyWith => CopyWith$Query$CommunitySearchSpots$searchSpots$connection(
    this,
    (i) => i,
  );
}

abstract class CopyWith$Query$CommunitySearchSpots$searchSpots$connection<
  TRes
> {
  factory CopyWith$Query$CommunitySearchSpots$searchSpots$connection(
    Query$CommunitySearchSpots$searchSpots$connection instance,
    TRes Function(Query$CommunitySearchSpots$searchSpots$connection) then,
  ) = _CopyWithImpl$Query$CommunitySearchSpots$searchSpots$connection;

  factory CopyWith$Query$CommunitySearchSpots$searchSpots$connection.stub(
    TRes res,
  ) = _CopyWithStubImpl$Query$CommunitySearchSpots$searchSpots$connection;

  TRes call({
    List<Query$CommunitySearchSpots$searchSpots$connection$items>? items,
    int? page,
    bool? hasNext,
    int? totalCount,
  });
  TRes items(
    Iterable<Query$CommunitySearchSpots$searchSpots$connection$items> Function(
      Iterable<
        CopyWith$Query$CommunitySearchSpots$searchSpots$connection$items<
          Query$CommunitySearchSpots$searchSpots$connection$items
        >
      >,
    )
    _fn,
  );
}

class _CopyWithImpl$Query$CommunitySearchSpots$searchSpots$connection<TRes>
    implements
        CopyWith$Query$CommunitySearchSpots$searchSpots$connection<TRes> {
  _CopyWithImpl$Query$CommunitySearchSpots$searchSpots$connection(
    this._instance,
    this._then,
  );

  final Query$CommunitySearchSpots$searchSpots$connection _instance;

  final TRes Function(Query$CommunitySearchSpots$searchSpots$connection) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? items = _undefined,
    Object? page = _undefined,
    Object? hasNext = _undefined,
    Object? totalCount = _undefined,
  }) => _then(
    Query$CommunitySearchSpots$searchSpots$connection(
      items: items == _undefined || items == null
          ? _instance.items
          : (items
                as List<
                  Query$CommunitySearchSpots$searchSpots$connection$items
                >),
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
    Iterable<Query$CommunitySearchSpots$searchSpots$connection$items> Function(
      Iterable<
        CopyWith$Query$CommunitySearchSpots$searchSpots$connection$items<
          Query$CommunitySearchSpots$searchSpots$connection$items
        >
      >,
    )
    _fn,
  ) => call(
    items: _fn(
      _instance.items.map(
        (e) => CopyWith$Query$CommunitySearchSpots$searchSpots$connection$items(
          e,
          (i) => i,
        ),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl$Query$CommunitySearchSpots$searchSpots$connection<TRes>
    implements
        CopyWith$Query$CommunitySearchSpots$searchSpots$connection<TRes> {
  _CopyWithStubImpl$Query$CommunitySearchSpots$searchSpots$connection(
    this._res,
  );

  TRes _res;

  call({
    List<Query$CommunitySearchSpots$searchSpots$connection$items>? items,
    int? page,
    bool? hasNext,
    int? totalCount,
  }) => _res;

  items(_fn) => _res;
}

class Query$CommunitySearchSpots$searchSpots$connection$items {
  Query$CommunitySearchSpots$searchSpots$connection$items({
    required this.id,
    required this.title,
    this.address,
    required this.thumbnailImageUrl,
    required this.distanceMeters,
  });

  factory Query$CommunitySearchSpots$searchSpots$connection$items.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$title = json['title'];
    final l$address = json['address'];
    final l$thumbnailImageUrl = json['thumbnailImageUrl'];
    final l$distanceMeters = json['distanceMeters'];
    return Query$CommunitySearchSpots$searchSpots$connection$items(
      id: (l$id as String),
      title: (l$title as String),
      address: (l$address as String?),
      thumbnailImageUrl: (l$thumbnailImageUrl as String),
      distanceMeters: (l$distanceMeters as num).toDouble(),
    );
  }

  final String id;

  final String title;

  final String? address;

  final String thumbnailImageUrl;

  final double distanceMeters;

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
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$title = title;
    final l$address = address;
    final l$thumbnailImageUrl = thumbnailImageUrl;
    final l$distanceMeters = distanceMeters;
    return Object.hashAll([
      l$id,
      l$title,
      l$address,
      l$thumbnailImageUrl,
      l$distanceMeters,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$CommunitySearchSpots$searchSpots$connection$items ||
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
    return true;
  }
}

extension UtilityExtension$Query$CommunitySearchSpots$searchSpots$connection$items
    on Query$CommunitySearchSpots$searchSpots$connection$items {
  CopyWith$Query$CommunitySearchSpots$searchSpots$connection$items<
    Query$CommunitySearchSpots$searchSpots$connection$items
  >
  get copyWith =>
      CopyWith$Query$CommunitySearchSpots$searchSpots$connection$items(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Query$CommunitySearchSpots$searchSpots$connection$items<
  TRes
> {
  factory CopyWith$Query$CommunitySearchSpots$searchSpots$connection$items(
    Query$CommunitySearchSpots$searchSpots$connection$items instance,
    TRes Function(Query$CommunitySearchSpots$searchSpots$connection$items) then,
  ) = _CopyWithImpl$Query$CommunitySearchSpots$searchSpots$connection$items;

  factory CopyWith$Query$CommunitySearchSpots$searchSpots$connection$items.stub(
    TRes res,
  ) = _CopyWithStubImpl$Query$CommunitySearchSpots$searchSpots$connection$items;

  TRes call({
    String? id,
    String? title,
    String? address,
    String? thumbnailImageUrl,
    double? distanceMeters,
  });
}

class _CopyWithImpl$Query$CommunitySearchSpots$searchSpots$connection$items<
  TRes
>
    implements
        CopyWith$Query$CommunitySearchSpots$searchSpots$connection$items<TRes> {
  _CopyWithImpl$Query$CommunitySearchSpots$searchSpots$connection$items(
    this._instance,
    this._then,
  );

  final Query$CommunitySearchSpots$searchSpots$connection$items _instance;

  final TRes Function(Query$CommunitySearchSpots$searchSpots$connection$items)
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? title = _undefined,
    Object? address = _undefined,
    Object? thumbnailImageUrl = _undefined,
    Object? distanceMeters = _undefined,
  }) => _then(
    Query$CommunitySearchSpots$searchSpots$connection$items(
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
    ),
  );
}

class _CopyWithStubImpl$Query$CommunitySearchSpots$searchSpots$connection$items<
  TRes
>
    implements
        CopyWith$Query$CommunitySearchSpots$searchSpots$connection$items<TRes> {
  _CopyWithStubImpl$Query$CommunitySearchSpots$searchSpots$connection$items(
    this._res,
  );

  TRes _res;

  call({
    String? id,
    String? title,
    String? address,
    String? thumbnailImageUrl,
    double? distanceMeters,
  }) => _res;
}
