// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, unused_element
import '../../../common/network/shared_schema.graphql.dart';
import 'package:gql/ast.dart';

class Fragment$SpotQaAuthorParts {
  Fragment$SpotQaAuthorParts({
    required this.id,
    required this.nickname,
    this.profileImageUrl,
  });

  factory Fragment$SpotQaAuthorParts.fromJson(Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$nickname = json['nickname'];
    final l$profileImageUrl = json['profileImageUrl'];
    return Fragment$SpotQaAuthorParts(
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
    if (other is! Fragment$SpotQaAuthorParts ||
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

extension UtilityExtension$Fragment$SpotQaAuthorParts
    on Fragment$SpotQaAuthorParts {
  CopyWith$Fragment$SpotQaAuthorParts<Fragment$SpotQaAuthorParts>
  get copyWith => CopyWith$Fragment$SpotQaAuthorParts(this, (i) => i);
}

abstract class CopyWith$Fragment$SpotQaAuthorParts<TRes> {
  factory CopyWith$Fragment$SpotQaAuthorParts(
    Fragment$SpotQaAuthorParts instance,
    TRes Function(Fragment$SpotQaAuthorParts) then,
  ) = _CopyWithImpl$Fragment$SpotQaAuthorParts;

  factory CopyWith$Fragment$SpotQaAuthorParts.stub(TRes res) =
      _CopyWithStubImpl$Fragment$SpotQaAuthorParts;

  TRes call({String? id, String? nickname, String? profileImageUrl});
}

class _CopyWithImpl$Fragment$SpotQaAuthorParts<TRes>
    implements CopyWith$Fragment$SpotQaAuthorParts<TRes> {
  _CopyWithImpl$Fragment$SpotQaAuthorParts(this._instance, this._then);

  final Fragment$SpotQaAuthorParts _instance;

  final TRes Function(Fragment$SpotQaAuthorParts) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? nickname = _undefined,
    Object? profileImageUrl = _undefined,
  }) => _then(
    Fragment$SpotQaAuthorParts(
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

class _CopyWithStubImpl$Fragment$SpotQaAuthorParts<TRes>
    implements CopyWith$Fragment$SpotQaAuthorParts<TRes> {
  _CopyWithStubImpl$Fragment$SpotQaAuthorParts(this._res);

  TRes _res;

  call({String? id, String? nickname, String? profileImageUrl}) => _res;
}

const fragmentDefinitionSpotQaAuthorParts = FragmentDefinitionNode(
  name: NameNode(value: 'SpotQaAuthorParts'),
  typeCondition: TypeConditionNode(
    on: NamedTypeNode(name: NameNode(value: 'PostAuthor'), isNonNull: false),
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
);
const documentNodeFragmentSpotQaAuthorParts = DocumentNode(
  definitions: [fragmentDefinitionSpotQaAuthorParts],
);

class Fragment$SpotQaSpotParts {
  Fragment$SpotQaSpotParts({
    required this.id,
    required this.title,
    required this.thumbnailImageUrl,
    this.category,
  });

  factory Fragment$SpotQaSpotParts.fromJson(Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$title = json['title'];
    final l$thumbnailImageUrl = json['thumbnailImageUrl'];
    final l$category = json['category'];
    return Fragment$SpotQaSpotParts(
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
    if (other is! Fragment$SpotQaSpotParts ||
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

extension UtilityExtension$Fragment$SpotQaSpotParts
    on Fragment$SpotQaSpotParts {
  CopyWith$Fragment$SpotQaSpotParts<Fragment$SpotQaSpotParts> get copyWith =>
      CopyWith$Fragment$SpotQaSpotParts(this, (i) => i);
}

abstract class CopyWith$Fragment$SpotQaSpotParts<TRes> {
  factory CopyWith$Fragment$SpotQaSpotParts(
    Fragment$SpotQaSpotParts instance,
    TRes Function(Fragment$SpotQaSpotParts) then,
  ) = _CopyWithImpl$Fragment$SpotQaSpotParts;

  factory CopyWith$Fragment$SpotQaSpotParts.stub(TRes res) =
      _CopyWithStubImpl$Fragment$SpotQaSpotParts;

  TRes call({
    String? id,
    String? title,
    String? thumbnailImageUrl,
    Enum$TargetCategory? category,
  });
}

class _CopyWithImpl$Fragment$SpotQaSpotParts<TRes>
    implements CopyWith$Fragment$SpotQaSpotParts<TRes> {
  _CopyWithImpl$Fragment$SpotQaSpotParts(this._instance, this._then);

  final Fragment$SpotQaSpotParts _instance;

  final TRes Function(Fragment$SpotQaSpotParts) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? title = _undefined,
    Object? thumbnailImageUrl = _undefined,
    Object? category = _undefined,
  }) => _then(
    Fragment$SpotQaSpotParts(
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

class _CopyWithStubImpl$Fragment$SpotQaSpotParts<TRes>
    implements CopyWith$Fragment$SpotQaSpotParts<TRes> {
  _CopyWithStubImpl$Fragment$SpotQaSpotParts(this._res);

  TRes _res;

  call({
    String? id,
    String? title,
    String? thumbnailImageUrl,
    Enum$TargetCategory? category,
  }) => _res;
}

const fragmentDefinitionSpotQaSpotParts = FragmentDefinitionNode(
  name: NameNode(value: 'SpotQaSpotParts'),
  typeCondition: TypeConditionNode(
    on: NamedTypeNode(name: NameNode(value: 'PostSpot'), isNonNull: false),
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
);
const documentNodeFragmentSpotQaSpotParts = DocumentNode(
  definitions: [fragmentDefinitionSpotQaSpotParts],
);

class Fragment$SpotQuestionParts {
  Fragment$SpotQuestionParts({
    required this.id,
    required this.spot,
    required this.body,
    required this.author,
    required this.photoKeys,
    required this.resolved,
    required this.answerCount,
    required this.ownedByViewer,
    required this.hidden,
    required this.createdAt,
  });

  factory Fragment$SpotQuestionParts.fromJson(Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$spot = json['spot'];
    final l$body = json['body'];
    final l$author = json['author'];
    final l$photoKeys = json['photoKeys'];
    final l$resolved = json['resolved'];
    final l$answerCount = json['answerCount'];
    final l$ownedByViewer = json['ownedByViewer'];
    final l$hidden = json['hidden'];
    final l$createdAt = json['createdAt'];
    return Fragment$SpotQuestionParts(
      id: (l$id as String),
      spot: Fragment$SpotQaSpotParts.fromJson((l$spot as Map<String, dynamic>)),
      body: (l$body as String),
      author: Fragment$SpotQaAuthorParts.fromJson(
        (l$author as Map<String, dynamic>),
      ),
      photoKeys: (l$photoKeys as List<dynamic>)
          .map((e) => (e as String))
          .toList(),
      resolved: (l$resolved as bool),
      answerCount: (l$answerCount as int),
      ownedByViewer: (l$ownedByViewer as bool),
      hidden: (l$hidden as bool),
      createdAt: (l$createdAt as String),
    );
  }

  final String id;

  final Fragment$SpotQaSpotParts spot;

  final String body;

  final Fragment$SpotQaAuthorParts author;

  final List<String> photoKeys;

  final bool resolved;

  final int answerCount;

  final bool ownedByViewer;

  final bool hidden;

  final String createdAt;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$spot = spot;
    _resultData['spot'] = l$spot.toJson();
    final l$body = body;
    _resultData['body'] = l$body;
    final l$author = author;
    _resultData['author'] = l$author.toJson();
    final l$photoKeys = photoKeys;
    _resultData['photoKeys'] = l$photoKeys.map((e) => e).toList();
    final l$resolved = resolved;
    _resultData['resolved'] = l$resolved;
    final l$answerCount = answerCount;
    _resultData['answerCount'] = l$answerCount;
    final l$ownedByViewer = ownedByViewer;
    _resultData['ownedByViewer'] = l$ownedByViewer;
    final l$hidden = hidden;
    _resultData['hidden'] = l$hidden;
    final l$createdAt = createdAt;
    _resultData['createdAt'] = l$createdAt;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$spot = spot;
    final l$body = body;
    final l$author = author;
    final l$photoKeys = photoKeys;
    final l$resolved = resolved;
    final l$answerCount = answerCount;
    final l$ownedByViewer = ownedByViewer;
    final l$hidden = hidden;
    final l$createdAt = createdAt;
    return Object.hashAll([
      l$id,
      l$spot,
      l$body,
      l$author,
      Object.hashAll(l$photoKeys.map((v) => v)),
      l$resolved,
      l$answerCount,
      l$ownedByViewer,
      l$hidden,
      l$createdAt,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment$SpotQuestionParts ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$spot = spot;
    final lOther$spot = other.spot;
    if (l$spot != lOther$spot) {
      return false;
    }
    final l$body = body;
    final lOther$body = other.body;
    if (l$body != lOther$body) {
      return false;
    }
    final l$author = author;
    final lOther$author = other.author;
    if (l$author != lOther$author) {
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
    final l$resolved = resolved;
    final lOther$resolved = other.resolved;
    if (l$resolved != lOther$resolved) {
      return false;
    }
    final l$answerCount = answerCount;
    final lOther$answerCount = other.answerCount;
    if (l$answerCount != lOther$answerCount) {
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
    final l$createdAt = createdAt;
    final lOther$createdAt = other.createdAt;
    if (l$createdAt != lOther$createdAt) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Fragment$SpotQuestionParts
    on Fragment$SpotQuestionParts {
  CopyWith$Fragment$SpotQuestionParts<Fragment$SpotQuestionParts>
  get copyWith => CopyWith$Fragment$SpotQuestionParts(this, (i) => i);
}

abstract class CopyWith$Fragment$SpotQuestionParts<TRes> {
  factory CopyWith$Fragment$SpotQuestionParts(
    Fragment$SpotQuestionParts instance,
    TRes Function(Fragment$SpotQuestionParts) then,
  ) = _CopyWithImpl$Fragment$SpotQuestionParts;

  factory CopyWith$Fragment$SpotQuestionParts.stub(TRes res) =
      _CopyWithStubImpl$Fragment$SpotQuestionParts;

  TRes call({
    String? id,
    Fragment$SpotQaSpotParts? spot,
    String? body,
    Fragment$SpotQaAuthorParts? author,
    List<String>? photoKeys,
    bool? resolved,
    int? answerCount,
    bool? ownedByViewer,
    bool? hidden,
    String? createdAt,
  });
  CopyWith$Fragment$SpotQaSpotParts<TRes> get spot;
  CopyWith$Fragment$SpotQaAuthorParts<TRes> get author;
}

class _CopyWithImpl$Fragment$SpotQuestionParts<TRes>
    implements CopyWith$Fragment$SpotQuestionParts<TRes> {
  _CopyWithImpl$Fragment$SpotQuestionParts(this._instance, this._then);

  final Fragment$SpotQuestionParts _instance;

  final TRes Function(Fragment$SpotQuestionParts) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? spot = _undefined,
    Object? body = _undefined,
    Object? author = _undefined,
    Object? photoKeys = _undefined,
    Object? resolved = _undefined,
    Object? answerCount = _undefined,
    Object? ownedByViewer = _undefined,
    Object? hidden = _undefined,
    Object? createdAt = _undefined,
  }) => _then(
    Fragment$SpotQuestionParts(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      spot: spot == _undefined || spot == null
          ? _instance.spot
          : (spot as Fragment$SpotQaSpotParts),
      body: body == _undefined || body == null
          ? _instance.body
          : (body as String),
      author: author == _undefined || author == null
          ? _instance.author
          : (author as Fragment$SpotQaAuthorParts),
      photoKeys: photoKeys == _undefined || photoKeys == null
          ? _instance.photoKeys
          : (photoKeys as List<String>),
      resolved: resolved == _undefined || resolved == null
          ? _instance.resolved
          : (resolved as bool),
      answerCount: answerCount == _undefined || answerCount == null
          ? _instance.answerCount
          : (answerCount as int),
      ownedByViewer: ownedByViewer == _undefined || ownedByViewer == null
          ? _instance.ownedByViewer
          : (ownedByViewer as bool),
      hidden: hidden == _undefined || hidden == null
          ? _instance.hidden
          : (hidden as bool),
      createdAt: createdAt == _undefined || createdAt == null
          ? _instance.createdAt
          : (createdAt as String),
    ),
  );

  CopyWith$Fragment$SpotQaSpotParts<TRes> get spot {
    final local$spot = _instance.spot;
    return CopyWith$Fragment$SpotQaSpotParts(local$spot, (e) => call(spot: e));
  }

  CopyWith$Fragment$SpotQaAuthorParts<TRes> get author {
    final local$author = _instance.author;
    return CopyWith$Fragment$SpotQaAuthorParts(
      local$author,
      (e) => call(author: e),
    );
  }
}

class _CopyWithStubImpl$Fragment$SpotQuestionParts<TRes>
    implements CopyWith$Fragment$SpotQuestionParts<TRes> {
  _CopyWithStubImpl$Fragment$SpotQuestionParts(this._res);

  TRes _res;

  call({
    String? id,
    Fragment$SpotQaSpotParts? spot,
    String? body,
    Fragment$SpotQaAuthorParts? author,
    List<String>? photoKeys,
    bool? resolved,
    int? answerCount,
    bool? ownedByViewer,
    bool? hidden,
    String? createdAt,
  }) => _res;

  CopyWith$Fragment$SpotQaSpotParts<TRes> get spot =>
      CopyWith$Fragment$SpotQaSpotParts.stub(_res);

  CopyWith$Fragment$SpotQaAuthorParts<TRes> get author =>
      CopyWith$Fragment$SpotQaAuthorParts.stub(_res);
}

const fragmentDefinitionSpotQuestionParts = FragmentDefinitionNode(
  name: NameNode(value: 'SpotQuestionParts'),
  typeCondition: TypeConditionNode(
    on: NamedTypeNode(name: NameNode(value: 'SpotQuestion'), isNonNull: false),
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
        name: NameNode(value: 'spot'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: SelectionSetNode(
          selections: [
            FragmentSpreadNode(
              name: NameNode(value: 'SpotQaSpotParts'),
              directives: [],
            ),
          ],
        ),
      ),
      FieldNode(
        name: NameNode(value: 'body'),
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
            FragmentSpreadNode(
              name: NameNode(value: 'SpotQaAuthorParts'),
              directives: [],
            ),
          ],
        ),
      ),
      FieldNode(
        name: NameNode(value: 'photoKeys'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'resolved'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'answerCount'),
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
        name: NameNode(value: 'createdAt'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
    ],
  ),
);
const documentNodeFragmentSpotQuestionParts = DocumentNode(
  definitions: [
    fragmentDefinitionSpotQuestionParts,
    fragmentDefinitionSpotQaSpotParts,
    fragmentDefinitionSpotQaAuthorParts,
  ],
);

class Fragment$SpotAnswerReplyParts {
  Fragment$SpotAnswerReplyParts({
    required this.id,
    required this.answerId,
    required this.body,
    required this.author,
    required this.photoKeys,
    required this.ownedByViewer,
    required this.hidden,
    required this.createdAt,
  });

  factory Fragment$SpotAnswerReplyParts.fromJson(Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$answerId = json['answerId'];
    final l$body = json['body'];
    final l$author = json['author'];
    final l$photoKeys = json['photoKeys'];
    final l$ownedByViewer = json['ownedByViewer'];
    final l$hidden = json['hidden'];
    final l$createdAt = json['createdAt'];
    return Fragment$SpotAnswerReplyParts(
      id: (l$id as String),
      answerId: (l$answerId as String),
      body: (l$body as String),
      author: Fragment$SpotQaAuthorParts.fromJson(
        (l$author as Map<String, dynamic>),
      ),
      photoKeys: (l$photoKeys as List<dynamic>)
          .map((e) => (e as String))
          .toList(),
      ownedByViewer: (l$ownedByViewer as bool),
      hidden: (l$hidden as bool),
      createdAt: (l$createdAt as String),
    );
  }

  final String id;

  final String answerId;

  final String body;

  final Fragment$SpotQaAuthorParts author;

  final List<String> photoKeys;

  final bool ownedByViewer;

  final bool hidden;

  final String createdAt;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$answerId = answerId;
    _resultData['answerId'] = l$answerId;
    final l$body = body;
    _resultData['body'] = l$body;
    final l$author = author;
    _resultData['author'] = l$author.toJson();
    final l$photoKeys = photoKeys;
    _resultData['photoKeys'] = l$photoKeys.map((e) => e).toList();
    final l$ownedByViewer = ownedByViewer;
    _resultData['ownedByViewer'] = l$ownedByViewer;
    final l$hidden = hidden;
    _resultData['hidden'] = l$hidden;
    final l$createdAt = createdAt;
    _resultData['createdAt'] = l$createdAt;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$answerId = answerId;
    final l$body = body;
    final l$author = author;
    final l$photoKeys = photoKeys;
    final l$ownedByViewer = ownedByViewer;
    final l$hidden = hidden;
    final l$createdAt = createdAt;
    return Object.hashAll([
      l$id,
      l$answerId,
      l$body,
      l$author,
      Object.hashAll(l$photoKeys.map((v) => v)),
      l$ownedByViewer,
      l$hidden,
      l$createdAt,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment$SpotAnswerReplyParts ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$answerId = answerId;
    final lOther$answerId = other.answerId;
    if (l$answerId != lOther$answerId) {
      return false;
    }
    final l$body = body;
    final lOther$body = other.body;
    if (l$body != lOther$body) {
      return false;
    }
    final l$author = author;
    final lOther$author = other.author;
    if (l$author != lOther$author) {
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
    final l$createdAt = createdAt;
    final lOther$createdAt = other.createdAt;
    if (l$createdAt != lOther$createdAt) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Fragment$SpotAnswerReplyParts
    on Fragment$SpotAnswerReplyParts {
  CopyWith$Fragment$SpotAnswerReplyParts<Fragment$SpotAnswerReplyParts>
  get copyWith => CopyWith$Fragment$SpotAnswerReplyParts(this, (i) => i);
}

abstract class CopyWith$Fragment$SpotAnswerReplyParts<TRes> {
  factory CopyWith$Fragment$SpotAnswerReplyParts(
    Fragment$SpotAnswerReplyParts instance,
    TRes Function(Fragment$SpotAnswerReplyParts) then,
  ) = _CopyWithImpl$Fragment$SpotAnswerReplyParts;

  factory CopyWith$Fragment$SpotAnswerReplyParts.stub(TRes res) =
      _CopyWithStubImpl$Fragment$SpotAnswerReplyParts;

  TRes call({
    String? id,
    String? answerId,
    String? body,
    Fragment$SpotQaAuthorParts? author,
    List<String>? photoKeys,
    bool? ownedByViewer,
    bool? hidden,
    String? createdAt,
  });
  CopyWith$Fragment$SpotQaAuthorParts<TRes> get author;
}

class _CopyWithImpl$Fragment$SpotAnswerReplyParts<TRes>
    implements CopyWith$Fragment$SpotAnswerReplyParts<TRes> {
  _CopyWithImpl$Fragment$SpotAnswerReplyParts(this._instance, this._then);

  final Fragment$SpotAnswerReplyParts _instance;

  final TRes Function(Fragment$SpotAnswerReplyParts) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? answerId = _undefined,
    Object? body = _undefined,
    Object? author = _undefined,
    Object? photoKeys = _undefined,
    Object? ownedByViewer = _undefined,
    Object? hidden = _undefined,
    Object? createdAt = _undefined,
  }) => _then(
    Fragment$SpotAnswerReplyParts(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      answerId: answerId == _undefined || answerId == null
          ? _instance.answerId
          : (answerId as String),
      body: body == _undefined || body == null
          ? _instance.body
          : (body as String),
      author: author == _undefined || author == null
          ? _instance.author
          : (author as Fragment$SpotQaAuthorParts),
      photoKeys: photoKeys == _undefined || photoKeys == null
          ? _instance.photoKeys
          : (photoKeys as List<String>),
      ownedByViewer: ownedByViewer == _undefined || ownedByViewer == null
          ? _instance.ownedByViewer
          : (ownedByViewer as bool),
      hidden: hidden == _undefined || hidden == null
          ? _instance.hidden
          : (hidden as bool),
      createdAt: createdAt == _undefined || createdAt == null
          ? _instance.createdAt
          : (createdAt as String),
    ),
  );

  CopyWith$Fragment$SpotQaAuthorParts<TRes> get author {
    final local$author = _instance.author;
    return CopyWith$Fragment$SpotQaAuthorParts(
      local$author,
      (e) => call(author: e),
    );
  }
}

class _CopyWithStubImpl$Fragment$SpotAnswerReplyParts<TRes>
    implements CopyWith$Fragment$SpotAnswerReplyParts<TRes> {
  _CopyWithStubImpl$Fragment$SpotAnswerReplyParts(this._res);

  TRes _res;

  call({
    String? id,
    String? answerId,
    String? body,
    Fragment$SpotQaAuthorParts? author,
    List<String>? photoKeys,
    bool? ownedByViewer,
    bool? hidden,
    String? createdAt,
  }) => _res;

  CopyWith$Fragment$SpotQaAuthorParts<TRes> get author =>
      CopyWith$Fragment$SpotQaAuthorParts.stub(_res);
}

const fragmentDefinitionSpotAnswerReplyParts = FragmentDefinitionNode(
  name: NameNode(value: 'SpotAnswerReplyParts'),
  typeCondition: TypeConditionNode(
    on: NamedTypeNode(
      name: NameNode(value: 'SpotAnswerReply'),
      isNonNull: false,
    ),
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
        name: NameNode(value: 'answerId'),
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
        name: NameNode(value: 'author'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: SelectionSetNode(
          selections: [
            FragmentSpreadNode(
              name: NameNode(value: 'SpotQaAuthorParts'),
              directives: [],
            ),
          ],
        ),
      ),
      FieldNode(
        name: NameNode(value: 'photoKeys'),
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
        name: NameNode(value: 'createdAt'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
    ],
  ),
);
const documentNodeFragmentSpotAnswerReplyParts = DocumentNode(
  definitions: [
    fragmentDefinitionSpotAnswerReplyParts,
    fragmentDefinitionSpotQaAuthorParts,
  ],
);

class Fragment$SpotAnswerParts {
  Fragment$SpotAnswerParts({
    required this.id,
    required this.questionId,
    required this.body,
    required this.author,
    required this.photoKeys,
    required this.ownedByViewer,
    required this.hidden,
    required this.createdAt,
    required this.replies,
  });

  factory Fragment$SpotAnswerParts.fromJson(Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$questionId = json['questionId'];
    final l$body = json['body'];
    final l$author = json['author'];
    final l$photoKeys = json['photoKeys'];
    final l$ownedByViewer = json['ownedByViewer'];
    final l$hidden = json['hidden'];
    final l$createdAt = json['createdAt'];
    final l$replies = json['replies'];
    return Fragment$SpotAnswerParts(
      id: (l$id as String),
      questionId: (l$questionId as String),
      body: (l$body as String),
      author: Fragment$SpotQaAuthorParts.fromJson(
        (l$author as Map<String, dynamic>),
      ),
      photoKeys: (l$photoKeys as List<dynamic>)
          .map((e) => (e as String))
          .toList(),
      ownedByViewer: (l$ownedByViewer as bool),
      hidden: (l$hidden as bool),
      createdAt: (l$createdAt as String),
      replies: (l$replies as List<dynamic>)
          .map(
            (e) => Fragment$SpotAnswerReplyParts.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
    );
  }

  final String id;

  final String questionId;

  final String body;

  final Fragment$SpotQaAuthorParts author;

  final List<String> photoKeys;

  final bool ownedByViewer;

  final bool hidden;

  final String createdAt;

  final List<Fragment$SpotAnswerReplyParts> replies;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$questionId = questionId;
    _resultData['questionId'] = l$questionId;
    final l$body = body;
    _resultData['body'] = l$body;
    final l$author = author;
    _resultData['author'] = l$author.toJson();
    final l$photoKeys = photoKeys;
    _resultData['photoKeys'] = l$photoKeys.map((e) => e).toList();
    final l$ownedByViewer = ownedByViewer;
    _resultData['ownedByViewer'] = l$ownedByViewer;
    final l$hidden = hidden;
    _resultData['hidden'] = l$hidden;
    final l$createdAt = createdAt;
    _resultData['createdAt'] = l$createdAt;
    final l$replies = replies;
    _resultData['replies'] = l$replies.map((e) => e.toJson()).toList();
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$questionId = questionId;
    final l$body = body;
    final l$author = author;
    final l$photoKeys = photoKeys;
    final l$ownedByViewer = ownedByViewer;
    final l$hidden = hidden;
    final l$createdAt = createdAt;
    final l$replies = replies;
    return Object.hashAll([
      l$id,
      l$questionId,
      l$body,
      l$author,
      Object.hashAll(l$photoKeys.map((v) => v)),
      l$ownedByViewer,
      l$hidden,
      l$createdAt,
      Object.hashAll(l$replies.map((v) => v)),
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment$SpotAnswerParts ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$questionId = questionId;
    final lOther$questionId = other.questionId;
    if (l$questionId != lOther$questionId) {
      return false;
    }
    final l$body = body;
    final lOther$body = other.body;
    if (l$body != lOther$body) {
      return false;
    }
    final l$author = author;
    final lOther$author = other.author;
    if (l$author != lOther$author) {
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
    final l$createdAt = createdAt;
    final lOther$createdAt = other.createdAt;
    if (l$createdAt != lOther$createdAt) {
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

extension UtilityExtension$Fragment$SpotAnswerParts
    on Fragment$SpotAnswerParts {
  CopyWith$Fragment$SpotAnswerParts<Fragment$SpotAnswerParts> get copyWith =>
      CopyWith$Fragment$SpotAnswerParts(this, (i) => i);
}

abstract class CopyWith$Fragment$SpotAnswerParts<TRes> {
  factory CopyWith$Fragment$SpotAnswerParts(
    Fragment$SpotAnswerParts instance,
    TRes Function(Fragment$SpotAnswerParts) then,
  ) = _CopyWithImpl$Fragment$SpotAnswerParts;

  factory CopyWith$Fragment$SpotAnswerParts.stub(TRes res) =
      _CopyWithStubImpl$Fragment$SpotAnswerParts;

  TRes call({
    String? id,
    String? questionId,
    String? body,
    Fragment$SpotQaAuthorParts? author,
    List<String>? photoKeys,
    bool? ownedByViewer,
    bool? hidden,
    String? createdAt,
    List<Fragment$SpotAnswerReplyParts>? replies,
  });
  CopyWith$Fragment$SpotQaAuthorParts<TRes> get author;
  TRes replies(
    Iterable<Fragment$SpotAnswerReplyParts> Function(
      Iterable<
        CopyWith$Fragment$SpotAnswerReplyParts<Fragment$SpotAnswerReplyParts>
      >,
    )
    _fn,
  );
}

class _CopyWithImpl$Fragment$SpotAnswerParts<TRes>
    implements CopyWith$Fragment$SpotAnswerParts<TRes> {
  _CopyWithImpl$Fragment$SpotAnswerParts(this._instance, this._then);

  final Fragment$SpotAnswerParts _instance;

  final TRes Function(Fragment$SpotAnswerParts) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? questionId = _undefined,
    Object? body = _undefined,
    Object? author = _undefined,
    Object? photoKeys = _undefined,
    Object? ownedByViewer = _undefined,
    Object? hidden = _undefined,
    Object? createdAt = _undefined,
    Object? replies = _undefined,
  }) => _then(
    Fragment$SpotAnswerParts(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      questionId: questionId == _undefined || questionId == null
          ? _instance.questionId
          : (questionId as String),
      body: body == _undefined || body == null
          ? _instance.body
          : (body as String),
      author: author == _undefined || author == null
          ? _instance.author
          : (author as Fragment$SpotQaAuthorParts),
      photoKeys: photoKeys == _undefined || photoKeys == null
          ? _instance.photoKeys
          : (photoKeys as List<String>),
      ownedByViewer: ownedByViewer == _undefined || ownedByViewer == null
          ? _instance.ownedByViewer
          : (ownedByViewer as bool),
      hidden: hidden == _undefined || hidden == null
          ? _instance.hidden
          : (hidden as bool),
      createdAt: createdAt == _undefined || createdAt == null
          ? _instance.createdAt
          : (createdAt as String),
      replies: replies == _undefined || replies == null
          ? _instance.replies
          : (replies as List<Fragment$SpotAnswerReplyParts>),
    ),
  );

  CopyWith$Fragment$SpotQaAuthorParts<TRes> get author {
    final local$author = _instance.author;
    return CopyWith$Fragment$SpotQaAuthorParts(
      local$author,
      (e) => call(author: e),
    );
  }

  TRes replies(
    Iterable<Fragment$SpotAnswerReplyParts> Function(
      Iterable<
        CopyWith$Fragment$SpotAnswerReplyParts<Fragment$SpotAnswerReplyParts>
      >,
    )
    _fn,
  ) => call(
    replies: _fn(
      _instance.replies.map(
        (e) => CopyWith$Fragment$SpotAnswerReplyParts(e, (i) => i),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl$Fragment$SpotAnswerParts<TRes>
    implements CopyWith$Fragment$SpotAnswerParts<TRes> {
  _CopyWithStubImpl$Fragment$SpotAnswerParts(this._res);

  TRes _res;

  call({
    String? id,
    String? questionId,
    String? body,
    Fragment$SpotQaAuthorParts? author,
    List<String>? photoKeys,
    bool? ownedByViewer,
    bool? hidden,
    String? createdAt,
    List<Fragment$SpotAnswerReplyParts>? replies,
  }) => _res;

  CopyWith$Fragment$SpotQaAuthorParts<TRes> get author =>
      CopyWith$Fragment$SpotQaAuthorParts.stub(_res);

  replies(_fn) => _res;
}

const fragmentDefinitionSpotAnswerParts = FragmentDefinitionNode(
  name: NameNode(value: 'SpotAnswerParts'),
  typeCondition: TypeConditionNode(
    on: NamedTypeNode(name: NameNode(value: 'SpotAnswer'), isNonNull: false),
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
        name: NameNode(value: 'questionId'),
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
        name: NameNode(value: 'author'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: SelectionSetNode(
          selections: [
            FragmentSpreadNode(
              name: NameNode(value: 'SpotQaAuthorParts'),
              directives: [],
            ),
          ],
        ),
      ),
      FieldNode(
        name: NameNode(value: 'photoKeys'),
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
        name: NameNode(value: 'createdAt'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'replies'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: SelectionSetNode(
          selections: [
            FragmentSpreadNode(
              name: NameNode(value: 'SpotAnswerReplyParts'),
              directives: [],
            ),
          ],
        ),
      ),
    ],
  ),
);
const documentNodeFragmentSpotAnswerParts = DocumentNode(
  definitions: [
    fragmentDefinitionSpotAnswerParts,
    fragmentDefinitionSpotQaAuthorParts,
    fragmentDefinitionSpotAnswerReplyParts,
  ],
);

class Variables$Query$SpotQuestions {
  factory Variables$Query$SpotQuestions({
    required String catalogId,
    int? first,
    String? after,
  }) => Variables$Query$SpotQuestions._({
    r'catalogId': catalogId,
    if (first != null) r'first': first,
    if (after != null) r'after': after,
  });

  Variables$Query$SpotQuestions._(this._$data);

  factory Variables$Query$SpotQuestions.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$catalogId = data['catalogId'];
    result$data['catalogId'] = (l$catalogId as String);
    if (data.containsKey('first')) {
      final l$first = data['first'];
      result$data['first'] = (l$first as int?);
    }
    if (data.containsKey('after')) {
      final l$after = data['after'];
      result$data['after'] = (l$after as String?);
    }
    return Variables$Query$SpotQuestions._(result$data);
  }

  Map<String, dynamic> _$data;

  String get catalogId => (_$data['catalogId'] as String);

  int? get first => (_$data['first'] as int?);

  String? get after => (_$data['after'] as String?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$catalogId = catalogId;
    result$data['catalogId'] = l$catalogId;
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

  CopyWith$Variables$Query$SpotQuestions<Variables$Query$SpotQuestions>
  get copyWith => CopyWith$Variables$Query$SpotQuestions(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Query$SpotQuestions ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$catalogId = catalogId;
    final lOther$catalogId = other.catalogId;
    if (l$catalogId != lOther$catalogId) {
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
    final l$first = first;
    final l$after = after;
    return Object.hashAll([
      l$catalogId,
      _$data.containsKey('first') ? l$first : const {},
      _$data.containsKey('after') ? l$after : const {},
    ]);
  }
}

abstract class CopyWith$Variables$Query$SpotQuestions<TRes> {
  factory CopyWith$Variables$Query$SpotQuestions(
    Variables$Query$SpotQuestions instance,
    TRes Function(Variables$Query$SpotQuestions) then,
  ) = _CopyWithImpl$Variables$Query$SpotQuestions;

  factory CopyWith$Variables$Query$SpotQuestions.stub(TRes res) =
      _CopyWithStubImpl$Variables$Query$SpotQuestions;

  TRes call({String? catalogId, int? first, String? after});
}

class _CopyWithImpl$Variables$Query$SpotQuestions<TRes>
    implements CopyWith$Variables$Query$SpotQuestions<TRes> {
  _CopyWithImpl$Variables$Query$SpotQuestions(this._instance, this._then);

  final Variables$Query$SpotQuestions _instance;

  final TRes Function(Variables$Query$SpotQuestions) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? catalogId = _undefined,
    Object? first = _undefined,
    Object? after = _undefined,
  }) => _then(
    Variables$Query$SpotQuestions._({
      ..._instance._$data,
      if (catalogId != _undefined && catalogId != null)
        'catalogId': (catalogId as String),
      if (first != _undefined) 'first': (first as int?),
      if (after != _undefined) 'after': (after as String?),
    }),
  );
}

class _CopyWithStubImpl$Variables$Query$SpotQuestions<TRes>
    implements CopyWith$Variables$Query$SpotQuestions<TRes> {
  _CopyWithStubImpl$Variables$Query$SpotQuestions(this._res);

  TRes _res;

  call({String? catalogId, int? first, String? after}) => _res;
}

class Query$SpotQuestions {
  Query$SpotQuestions({required this.spotQuestions});

  factory Query$SpotQuestions.fromJson(Map<String, dynamic> json) {
    final l$spotQuestions = json['spotQuestions'];
    return Query$SpotQuestions(
      spotQuestions: Query$SpotQuestions$spotQuestions.fromJson(
        (l$spotQuestions as Map<String, dynamic>),
      ),
    );
  }

  final Query$SpotQuestions$spotQuestions spotQuestions;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$spotQuestions = spotQuestions;
    _resultData['spotQuestions'] = l$spotQuestions.toJson();
    return _resultData;
  }

  @override
  int get hashCode {
    final l$spotQuestions = spotQuestions;
    return Object.hashAll([l$spotQuestions]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$SpotQuestions || runtimeType != other.runtimeType) {
      return false;
    }
    final l$spotQuestions = spotQuestions;
    final lOther$spotQuestions = other.spotQuestions;
    if (l$spotQuestions != lOther$spotQuestions) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Query$SpotQuestions on Query$SpotQuestions {
  CopyWith$Query$SpotQuestions<Query$SpotQuestions> get copyWith =>
      CopyWith$Query$SpotQuestions(this, (i) => i);
}

abstract class CopyWith$Query$SpotQuestions<TRes> {
  factory CopyWith$Query$SpotQuestions(
    Query$SpotQuestions instance,
    TRes Function(Query$SpotQuestions) then,
  ) = _CopyWithImpl$Query$SpotQuestions;

  factory CopyWith$Query$SpotQuestions.stub(TRes res) =
      _CopyWithStubImpl$Query$SpotQuestions;

  TRes call({Query$SpotQuestions$spotQuestions? spotQuestions});
  CopyWith$Query$SpotQuestions$spotQuestions<TRes> get spotQuestions;
}

class _CopyWithImpl$Query$SpotQuestions<TRes>
    implements CopyWith$Query$SpotQuestions<TRes> {
  _CopyWithImpl$Query$SpotQuestions(this._instance, this._then);

  final Query$SpotQuestions _instance;

  final TRes Function(Query$SpotQuestions) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? spotQuestions = _undefined}) => _then(
    Query$SpotQuestions(
      spotQuestions: spotQuestions == _undefined || spotQuestions == null
          ? _instance.spotQuestions
          : (spotQuestions as Query$SpotQuestions$spotQuestions),
    ),
  );

  CopyWith$Query$SpotQuestions$spotQuestions<TRes> get spotQuestions {
    final local$spotQuestions = _instance.spotQuestions;
    return CopyWith$Query$SpotQuestions$spotQuestions(
      local$spotQuestions,
      (e) => call(spotQuestions: e),
    );
  }
}

class _CopyWithStubImpl$Query$SpotQuestions<TRes>
    implements CopyWith$Query$SpotQuestions<TRes> {
  _CopyWithStubImpl$Query$SpotQuestions(this._res);

  TRes _res;

  call({Query$SpotQuestions$spotQuestions? spotQuestions}) => _res;

  CopyWith$Query$SpotQuestions$spotQuestions<TRes> get spotQuestions =>
      CopyWith$Query$SpotQuestions$spotQuestions.stub(_res);
}

const documentNodeQuerySpotQuestions = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'SpotQuestions'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'catalogId')),
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
            name: NameNode(value: 'spotQuestions'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'catalogId'),
                value: VariableNode(name: NameNode(value: 'catalogId')),
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
                              name: NameNode(value: 'SpotQuestionParts'),
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
    fragmentDefinitionSpotQuestionParts,
    fragmentDefinitionSpotQaSpotParts,
    fragmentDefinitionSpotQaAuthorParts,
  ],
);

class Query$SpotQuestions$spotQuestions {
  Query$SpotQuestions$spotQuestions({
    required this.edges,
    required this.pageInfo,
  });

  factory Query$SpotQuestions$spotQuestions.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$edges = json['edges'];
    final l$pageInfo = json['pageInfo'];
    return Query$SpotQuestions$spotQuestions(
      edges: (l$edges as List<dynamic>)
          .map(
            (e) => Query$SpotQuestions$spotQuestions$edges.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      pageInfo: Query$SpotQuestions$spotQuestions$pageInfo.fromJson(
        (l$pageInfo as Map<String, dynamic>),
      ),
    );
  }

  final List<Query$SpotQuestions$spotQuestions$edges> edges;

  final Query$SpotQuestions$spotQuestions$pageInfo pageInfo;

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
    if (other is! Query$SpotQuestions$spotQuestions ||
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

extension UtilityExtension$Query$SpotQuestions$spotQuestions
    on Query$SpotQuestions$spotQuestions {
  CopyWith$Query$SpotQuestions$spotQuestions<Query$SpotQuestions$spotQuestions>
  get copyWith => CopyWith$Query$SpotQuestions$spotQuestions(this, (i) => i);
}

abstract class CopyWith$Query$SpotQuestions$spotQuestions<TRes> {
  factory CopyWith$Query$SpotQuestions$spotQuestions(
    Query$SpotQuestions$spotQuestions instance,
    TRes Function(Query$SpotQuestions$spotQuestions) then,
  ) = _CopyWithImpl$Query$SpotQuestions$spotQuestions;

  factory CopyWith$Query$SpotQuestions$spotQuestions.stub(TRes res) =
      _CopyWithStubImpl$Query$SpotQuestions$spotQuestions;

  TRes call({
    List<Query$SpotQuestions$spotQuestions$edges>? edges,
    Query$SpotQuestions$spotQuestions$pageInfo? pageInfo,
  });
  TRes edges(
    Iterable<Query$SpotQuestions$spotQuestions$edges> Function(
      Iterable<
        CopyWith$Query$SpotQuestions$spotQuestions$edges<
          Query$SpotQuestions$spotQuestions$edges
        >
      >,
    )
    _fn,
  );
  CopyWith$Query$SpotQuestions$spotQuestions$pageInfo<TRes> get pageInfo;
}

class _CopyWithImpl$Query$SpotQuestions$spotQuestions<TRes>
    implements CopyWith$Query$SpotQuestions$spotQuestions<TRes> {
  _CopyWithImpl$Query$SpotQuestions$spotQuestions(this._instance, this._then);

  final Query$SpotQuestions$spotQuestions _instance;

  final TRes Function(Query$SpotQuestions$spotQuestions) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? edges = _undefined, Object? pageInfo = _undefined}) =>
      _then(
        Query$SpotQuestions$spotQuestions(
          edges: edges == _undefined || edges == null
              ? _instance.edges
              : (edges as List<Query$SpotQuestions$spotQuestions$edges>),
          pageInfo: pageInfo == _undefined || pageInfo == null
              ? _instance.pageInfo
              : (pageInfo as Query$SpotQuestions$spotQuestions$pageInfo),
        ),
      );

  TRes edges(
    Iterable<Query$SpotQuestions$spotQuestions$edges> Function(
      Iterable<
        CopyWith$Query$SpotQuestions$spotQuestions$edges<
          Query$SpotQuestions$spotQuestions$edges
        >
      >,
    )
    _fn,
  ) => call(
    edges: _fn(
      _instance.edges.map(
        (e) => CopyWith$Query$SpotQuestions$spotQuestions$edges(e, (i) => i),
      ),
    ).toList(),
  );

  CopyWith$Query$SpotQuestions$spotQuestions$pageInfo<TRes> get pageInfo {
    final local$pageInfo = _instance.pageInfo;
    return CopyWith$Query$SpotQuestions$spotQuestions$pageInfo(
      local$pageInfo,
      (e) => call(pageInfo: e),
    );
  }
}

class _CopyWithStubImpl$Query$SpotQuestions$spotQuestions<TRes>
    implements CopyWith$Query$SpotQuestions$spotQuestions<TRes> {
  _CopyWithStubImpl$Query$SpotQuestions$spotQuestions(this._res);

  TRes _res;

  call({
    List<Query$SpotQuestions$spotQuestions$edges>? edges,
    Query$SpotQuestions$spotQuestions$pageInfo? pageInfo,
  }) => _res;

  edges(_fn) => _res;

  CopyWith$Query$SpotQuestions$spotQuestions$pageInfo<TRes> get pageInfo =>
      CopyWith$Query$SpotQuestions$spotQuestions$pageInfo.stub(_res);
}

class Query$SpotQuestions$spotQuestions$edges {
  Query$SpotQuestions$spotQuestions$edges({
    required this.cursor,
    required this.node,
  });

  factory Query$SpotQuestions$spotQuestions$edges.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$cursor = json['cursor'];
    final l$node = json['node'];
    return Query$SpotQuestions$spotQuestions$edges(
      cursor: (l$cursor as String),
      node: Fragment$SpotQuestionParts.fromJson(
        (l$node as Map<String, dynamic>),
      ),
    );
  }

  final String cursor;

  final Fragment$SpotQuestionParts node;

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
    if (other is! Query$SpotQuestions$spotQuestions$edges ||
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

extension UtilityExtension$Query$SpotQuestions$spotQuestions$edges
    on Query$SpotQuestions$spotQuestions$edges {
  CopyWith$Query$SpotQuestions$spotQuestions$edges<
    Query$SpotQuestions$spotQuestions$edges
  >
  get copyWith =>
      CopyWith$Query$SpotQuestions$spotQuestions$edges(this, (i) => i);
}

abstract class CopyWith$Query$SpotQuestions$spotQuestions$edges<TRes> {
  factory CopyWith$Query$SpotQuestions$spotQuestions$edges(
    Query$SpotQuestions$spotQuestions$edges instance,
    TRes Function(Query$SpotQuestions$spotQuestions$edges) then,
  ) = _CopyWithImpl$Query$SpotQuestions$spotQuestions$edges;

  factory CopyWith$Query$SpotQuestions$spotQuestions$edges.stub(TRes res) =
      _CopyWithStubImpl$Query$SpotQuestions$spotQuestions$edges;

  TRes call({String? cursor, Fragment$SpotQuestionParts? node});
  CopyWith$Fragment$SpotQuestionParts<TRes> get node;
}

class _CopyWithImpl$Query$SpotQuestions$spotQuestions$edges<TRes>
    implements CopyWith$Query$SpotQuestions$spotQuestions$edges<TRes> {
  _CopyWithImpl$Query$SpotQuestions$spotQuestions$edges(
    this._instance,
    this._then,
  );

  final Query$SpotQuestions$spotQuestions$edges _instance;

  final TRes Function(Query$SpotQuestions$spotQuestions$edges) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? cursor = _undefined, Object? node = _undefined}) => _then(
    Query$SpotQuestions$spotQuestions$edges(
      cursor: cursor == _undefined || cursor == null
          ? _instance.cursor
          : (cursor as String),
      node: node == _undefined || node == null
          ? _instance.node
          : (node as Fragment$SpotQuestionParts),
    ),
  );

  CopyWith$Fragment$SpotQuestionParts<TRes> get node {
    final local$node = _instance.node;
    return CopyWith$Fragment$SpotQuestionParts(
      local$node,
      (e) => call(node: e),
    );
  }
}

class _CopyWithStubImpl$Query$SpotQuestions$spotQuestions$edges<TRes>
    implements CopyWith$Query$SpotQuestions$spotQuestions$edges<TRes> {
  _CopyWithStubImpl$Query$SpotQuestions$spotQuestions$edges(this._res);

  TRes _res;

  call({String? cursor, Fragment$SpotQuestionParts? node}) => _res;

  CopyWith$Fragment$SpotQuestionParts<TRes> get node =>
      CopyWith$Fragment$SpotQuestionParts.stub(_res);
}

class Query$SpotQuestions$spotQuestions$pageInfo {
  Query$SpotQuestions$spotQuestions$pageInfo({
    required this.hasNextPage,
    this.endCursor,
  });

  factory Query$SpotQuestions$spotQuestions$pageInfo.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$hasNextPage = json['hasNextPage'];
    final l$endCursor = json['endCursor'];
    return Query$SpotQuestions$spotQuestions$pageInfo(
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
    if (other is! Query$SpotQuestions$spotQuestions$pageInfo ||
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

extension UtilityExtension$Query$SpotQuestions$spotQuestions$pageInfo
    on Query$SpotQuestions$spotQuestions$pageInfo {
  CopyWith$Query$SpotQuestions$spotQuestions$pageInfo<
    Query$SpotQuestions$spotQuestions$pageInfo
  >
  get copyWith =>
      CopyWith$Query$SpotQuestions$spotQuestions$pageInfo(this, (i) => i);
}

abstract class CopyWith$Query$SpotQuestions$spotQuestions$pageInfo<TRes> {
  factory CopyWith$Query$SpotQuestions$spotQuestions$pageInfo(
    Query$SpotQuestions$spotQuestions$pageInfo instance,
    TRes Function(Query$SpotQuestions$spotQuestions$pageInfo) then,
  ) = _CopyWithImpl$Query$SpotQuestions$spotQuestions$pageInfo;

  factory CopyWith$Query$SpotQuestions$spotQuestions$pageInfo.stub(TRes res) =
      _CopyWithStubImpl$Query$SpotQuestions$spotQuestions$pageInfo;

  TRes call({bool? hasNextPage, String? endCursor});
}

class _CopyWithImpl$Query$SpotQuestions$spotQuestions$pageInfo<TRes>
    implements CopyWith$Query$SpotQuestions$spotQuestions$pageInfo<TRes> {
  _CopyWithImpl$Query$SpotQuestions$spotQuestions$pageInfo(
    this._instance,
    this._then,
  );

  final Query$SpotQuestions$spotQuestions$pageInfo _instance;

  final TRes Function(Query$SpotQuestions$spotQuestions$pageInfo) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? hasNextPage = _undefined,
    Object? endCursor = _undefined,
  }) => _then(
    Query$SpotQuestions$spotQuestions$pageInfo(
      hasNextPage: hasNextPage == _undefined || hasNextPage == null
          ? _instance.hasNextPage
          : (hasNextPage as bool),
      endCursor: endCursor == _undefined
          ? _instance.endCursor
          : (endCursor as String?),
    ),
  );
}

class _CopyWithStubImpl$Query$SpotQuestions$spotQuestions$pageInfo<TRes>
    implements CopyWith$Query$SpotQuestions$spotQuestions$pageInfo<TRes> {
  _CopyWithStubImpl$Query$SpotQuestions$spotQuestions$pageInfo(this._res);

  TRes _res;

  call({bool? hasNextPage, String? endCursor}) => _res;
}

class Variables$Query$SpotAnswers {
  factory Variables$Query$SpotAnswers({
    required String questionId,
    int? first,
    String? after,
  }) => Variables$Query$SpotAnswers._({
    r'questionId': questionId,
    if (first != null) r'first': first,
    if (after != null) r'after': after,
  });

  Variables$Query$SpotAnswers._(this._$data);

  factory Variables$Query$SpotAnswers.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$questionId = data['questionId'];
    result$data['questionId'] = (l$questionId as String);
    if (data.containsKey('first')) {
      final l$first = data['first'];
      result$data['first'] = (l$first as int?);
    }
    if (data.containsKey('after')) {
      final l$after = data['after'];
      result$data['after'] = (l$after as String?);
    }
    return Variables$Query$SpotAnswers._(result$data);
  }

  Map<String, dynamic> _$data;

  String get questionId => (_$data['questionId'] as String);

  int? get first => (_$data['first'] as int?);

  String? get after => (_$data['after'] as String?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$questionId = questionId;
    result$data['questionId'] = l$questionId;
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

  CopyWith$Variables$Query$SpotAnswers<Variables$Query$SpotAnswers>
  get copyWith => CopyWith$Variables$Query$SpotAnswers(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Query$SpotAnswers ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$questionId = questionId;
    final lOther$questionId = other.questionId;
    if (l$questionId != lOther$questionId) {
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
    final l$questionId = questionId;
    final l$first = first;
    final l$after = after;
    return Object.hashAll([
      l$questionId,
      _$data.containsKey('first') ? l$first : const {},
      _$data.containsKey('after') ? l$after : const {},
    ]);
  }
}

abstract class CopyWith$Variables$Query$SpotAnswers<TRes> {
  factory CopyWith$Variables$Query$SpotAnswers(
    Variables$Query$SpotAnswers instance,
    TRes Function(Variables$Query$SpotAnswers) then,
  ) = _CopyWithImpl$Variables$Query$SpotAnswers;

  factory CopyWith$Variables$Query$SpotAnswers.stub(TRes res) =
      _CopyWithStubImpl$Variables$Query$SpotAnswers;

  TRes call({String? questionId, int? first, String? after});
}

class _CopyWithImpl$Variables$Query$SpotAnswers<TRes>
    implements CopyWith$Variables$Query$SpotAnswers<TRes> {
  _CopyWithImpl$Variables$Query$SpotAnswers(this._instance, this._then);

  final Variables$Query$SpotAnswers _instance;

  final TRes Function(Variables$Query$SpotAnswers) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? questionId = _undefined,
    Object? first = _undefined,
    Object? after = _undefined,
  }) => _then(
    Variables$Query$SpotAnswers._({
      ..._instance._$data,
      if (questionId != _undefined && questionId != null)
        'questionId': (questionId as String),
      if (first != _undefined) 'first': (first as int?),
      if (after != _undefined) 'after': (after as String?),
    }),
  );
}

class _CopyWithStubImpl$Variables$Query$SpotAnswers<TRes>
    implements CopyWith$Variables$Query$SpotAnswers<TRes> {
  _CopyWithStubImpl$Variables$Query$SpotAnswers(this._res);

  TRes _res;

  call({String? questionId, int? first, String? after}) => _res;
}

class Query$SpotAnswers {
  Query$SpotAnswers({required this.spotAnswers});

  factory Query$SpotAnswers.fromJson(Map<String, dynamic> json) {
    final l$spotAnswers = json['spotAnswers'];
    return Query$SpotAnswers(
      spotAnswers: Query$SpotAnswers$spotAnswers.fromJson(
        (l$spotAnswers as Map<String, dynamic>),
      ),
    );
  }

  final Query$SpotAnswers$spotAnswers spotAnswers;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$spotAnswers = spotAnswers;
    _resultData['spotAnswers'] = l$spotAnswers.toJson();
    return _resultData;
  }

  @override
  int get hashCode {
    final l$spotAnswers = spotAnswers;
    return Object.hashAll([l$spotAnswers]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$SpotAnswers || runtimeType != other.runtimeType) {
      return false;
    }
    final l$spotAnswers = spotAnswers;
    final lOther$spotAnswers = other.spotAnswers;
    if (l$spotAnswers != lOther$spotAnswers) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Query$SpotAnswers on Query$SpotAnswers {
  CopyWith$Query$SpotAnswers<Query$SpotAnswers> get copyWith =>
      CopyWith$Query$SpotAnswers(this, (i) => i);
}

abstract class CopyWith$Query$SpotAnswers<TRes> {
  factory CopyWith$Query$SpotAnswers(
    Query$SpotAnswers instance,
    TRes Function(Query$SpotAnswers) then,
  ) = _CopyWithImpl$Query$SpotAnswers;

  factory CopyWith$Query$SpotAnswers.stub(TRes res) =
      _CopyWithStubImpl$Query$SpotAnswers;

  TRes call({Query$SpotAnswers$spotAnswers? spotAnswers});
  CopyWith$Query$SpotAnswers$spotAnswers<TRes> get spotAnswers;
}

class _CopyWithImpl$Query$SpotAnswers<TRes>
    implements CopyWith$Query$SpotAnswers<TRes> {
  _CopyWithImpl$Query$SpotAnswers(this._instance, this._then);

  final Query$SpotAnswers _instance;

  final TRes Function(Query$SpotAnswers) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? spotAnswers = _undefined}) => _then(
    Query$SpotAnswers(
      spotAnswers: spotAnswers == _undefined || spotAnswers == null
          ? _instance.spotAnswers
          : (spotAnswers as Query$SpotAnswers$spotAnswers),
    ),
  );

  CopyWith$Query$SpotAnswers$spotAnswers<TRes> get spotAnswers {
    final local$spotAnswers = _instance.spotAnswers;
    return CopyWith$Query$SpotAnswers$spotAnswers(
      local$spotAnswers,
      (e) => call(spotAnswers: e),
    );
  }
}

class _CopyWithStubImpl$Query$SpotAnswers<TRes>
    implements CopyWith$Query$SpotAnswers<TRes> {
  _CopyWithStubImpl$Query$SpotAnswers(this._res);

  TRes _res;

  call({Query$SpotAnswers$spotAnswers? spotAnswers}) => _res;

  CopyWith$Query$SpotAnswers$spotAnswers<TRes> get spotAnswers =>
      CopyWith$Query$SpotAnswers$spotAnswers.stub(_res);
}

const documentNodeQuerySpotAnswers = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'SpotAnswers'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'questionId')),
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
            name: NameNode(value: 'spotAnswers'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'questionId'),
                value: VariableNode(name: NameNode(value: 'questionId')),
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
                              name: NameNode(value: 'SpotAnswerParts'),
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
    fragmentDefinitionSpotAnswerParts,
    fragmentDefinitionSpotQaAuthorParts,
    fragmentDefinitionSpotAnswerReplyParts,
  ],
);

class Query$SpotAnswers$spotAnswers {
  Query$SpotAnswers$spotAnswers({required this.edges, required this.pageInfo});

  factory Query$SpotAnswers$spotAnswers.fromJson(Map<String, dynamic> json) {
    final l$edges = json['edges'];
    final l$pageInfo = json['pageInfo'];
    return Query$SpotAnswers$spotAnswers(
      edges: (l$edges as List<dynamic>)
          .map(
            (e) => Query$SpotAnswers$spotAnswers$edges.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      pageInfo: Query$SpotAnswers$spotAnswers$pageInfo.fromJson(
        (l$pageInfo as Map<String, dynamic>),
      ),
    );
  }

  final List<Query$SpotAnswers$spotAnswers$edges> edges;

  final Query$SpotAnswers$spotAnswers$pageInfo pageInfo;

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
    if (other is! Query$SpotAnswers$spotAnswers ||
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

extension UtilityExtension$Query$SpotAnswers$spotAnswers
    on Query$SpotAnswers$spotAnswers {
  CopyWith$Query$SpotAnswers$spotAnswers<Query$SpotAnswers$spotAnswers>
  get copyWith => CopyWith$Query$SpotAnswers$spotAnswers(this, (i) => i);
}

abstract class CopyWith$Query$SpotAnswers$spotAnswers<TRes> {
  factory CopyWith$Query$SpotAnswers$spotAnswers(
    Query$SpotAnswers$spotAnswers instance,
    TRes Function(Query$SpotAnswers$spotAnswers) then,
  ) = _CopyWithImpl$Query$SpotAnswers$spotAnswers;

  factory CopyWith$Query$SpotAnswers$spotAnswers.stub(TRes res) =
      _CopyWithStubImpl$Query$SpotAnswers$spotAnswers;

  TRes call({
    List<Query$SpotAnswers$spotAnswers$edges>? edges,
    Query$SpotAnswers$spotAnswers$pageInfo? pageInfo,
  });
  TRes edges(
    Iterable<Query$SpotAnswers$spotAnswers$edges> Function(
      Iterable<
        CopyWith$Query$SpotAnswers$spotAnswers$edges<
          Query$SpotAnswers$spotAnswers$edges
        >
      >,
    )
    _fn,
  );
  CopyWith$Query$SpotAnswers$spotAnswers$pageInfo<TRes> get pageInfo;
}

class _CopyWithImpl$Query$SpotAnswers$spotAnswers<TRes>
    implements CopyWith$Query$SpotAnswers$spotAnswers<TRes> {
  _CopyWithImpl$Query$SpotAnswers$spotAnswers(this._instance, this._then);

  final Query$SpotAnswers$spotAnswers _instance;

  final TRes Function(Query$SpotAnswers$spotAnswers) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? edges = _undefined, Object? pageInfo = _undefined}) =>
      _then(
        Query$SpotAnswers$spotAnswers(
          edges: edges == _undefined || edges == null
              ? _instance.edges
              : (edges as List<Query$SpotAnswers$spotAnswers$edges>),
          pageInfo: pageInfo == _undefined || pageInfo == null
              ? _instance.pageInfo
              : (pageInfo as Query$SpotAnswers$spotAnswers$pageInfo),
        ),
      );

  TRes edges(
    Iterable<Query$SpotAnswers$spotAnswers$edges> Function(
      Iterable<
        CopyWith$Query$SpotAnswers$spotAnswers$edges<
          Query$SpotAnswers$spotAnswers$edges
        >
      >,
    )
    _fn,
  ) => call(
    edges: _fn(
      _instance.edges.map(
        (e) => CopyWith$Query$SpotAnswers$spotAnswers$edges(e, (i) => i),
      ),
    ).toList(),
  );

  CopyWith$Query$SpotAnswers$spotAnswers$pageInfo<TRes> get pageInfo {
    final local$pageInfo = _instance.pageInfo;
    return CopyWith$Query$SpotAnswers$spotAnswers$pageInfo(
      local$pageInfo,
      (e) => call(pageInfo: e),
    );
  }
}

class _CopyWithStubImpl$Query$SpotAnswers$spotAnswers<TRes>
    implements CopyWith$Query$SpotAnswers$spotAnswers<TRes> {
  _CopyWithStubImpl$Query$SpotAnswers$spotAnswers(this._res);

  TRes _res;

  call({
    List<Query$SpotAnswers$spotAnswers$edges>? edges,
    Query$SpotAnswers$spotAnswers$pageInfo? pageInfo,
  }) => _res;

  edges(_fn) => _res;

  CopyWith$Query$SpotAnswers$spotAnswers$pageInfo<TRes> get pageInfo =>
      CopyWith$Query$SpotAnswers$spotAnswers$pageInfo.stub(_res);
}

class Query$SpotAnswers$spotAnswers$edges {
  Query$SpotAnswers$spotAnswers$edges({
    required this.cursor,
    required this.node,
  });

  factory Query$SpotAnswers$spotAnswers$edges.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$cursor = json['cursor'];
    final l$node = json['node'];
    return Query$SpotAnswers$spotAnswers$edges(
      cursor: (l$cursor as String),
      node: Fragment$SpotAnswerParts.fromJson((l$node as Map<String, dynamic>)),
    );
  }

  final String cursor;

  final Fragment$SpotAnswerParts node;

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
    if (other is! Query$SpotAnswers$spotAnswers$edges ||
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

extension UtilityExtension$Query$SpotAnswers$spotAnswers$edges
    on Query$SpotAnswers$spotAnswers$edges {
  CopyWith$Query$SpotAnswers$spotAnswers$edges<
    Query$SpotAnswers$spotAnswers$edges
  >
  get copyWith => CopyWith$Query$SpotAnswers$spotAnswers$edges(this, (i) => i);
}

abstract class CopyWith$Query$SpotAnswers$spotAnswers$edges<TRes> {
  factory CopyWith$Query$SpotAnswers$spotAnswers$edges(
    Query$SpotAnswers$spotAnswers$edges instance,
    TRes Function(Query$SpotAnswers$spotAnswers$edges) then,
  ) = _CopyWithImpl$Query$SpotAnswers$spotAnswers$edges;

  factory CopyWith$Query$SpotAnswers$spotAnswers$edges.stub(TRes res) =
      _CopyWithStubImpl$Query$SpotAnswers$spotAnswers$edges;

  TRes call({String? cursor, Fragment$SpotAnswerParts? node});
  CopyWith$Fragment$SpotAnswerParts<TRes> get node;
}

class _CopyWithImpl$Query$SpotAnswers$spotAnswers$edges<TRes>
    implements CopyWith$Query$SpotAnswers$spotAnswers$edges<TRes> {
  _CopyWithImpl$Query$SpotAnswers$spotAnswers$edges(this._instance, this._then);

  final Query$SpotAnswers$spotAnswers$edges _instance;

  final TRes Function(Query$SpotAnswers$spotAnswers$edges) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? cursor = _undefined, Object? node = _undefined}) => _then(
    Query$SpotAnswers$spotAnswers$edges(
      cursor: cursor == _undefined || cursor == null
          ? _instance.cursor
          : (cursor as String),
      node: node == _undefined || node == null
          ? _instance.node
          : (node as Fragment$SpotAnswerParts),
    ),
  );

  CopyWith$Fragment$SpotAnswerParts<TRes> get node {
    final local$node = _instance.node;
    return CopyWith$Fragment$SpotAnswerParts(local$node, (e) => call(node: e));
  }
}

class _CopyWithStubImpl$Query$SpotAnswers$spotAnswers$edges<TRes>
    implements CopyWith$Query$SpotAnswers$spotAnswers$edges<TRes> {
  _CopyWithStubImpl$Query$SpotAnswers$spotAnswers$edges(this._res);

  TRes _res;

  call({String? cursor, Fragment$SpotAnswerParts? node}) => _res;

  CopyWith$Fragment$SpotAnswerParts<TRes> get node =>
      CopyWith$Fragment$SpotAnswerParts.stub(_res);
}

class Query$SpotAnswers$spotAnswers$pageInfo {
  Query$SpotAnswers$spotAnswers$pageInfo({
    required this.hasNextPage,
    this.endCursor,
  });

  factory Query$SpotAnswers$spotAnswers$pageInfo.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$hasNextPage = json['hasNextPage'];
    final l$endCursor = json['endCursor'];
    return Query$SpotAnswers$spotAnswers$pageInfo(
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
    if (other is! Query$SpotAnswers$spotAnswers$pageInfo ||
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

extension UtilityExtension$Query$SpotAnswers$spotAnswers$pageInfo
    on Query$SpotAnswers$spotAnswers$pageInfo {
  CopyWith$Query$SpotAnswers$spotAnswers$pageInfo<
    Query$SpotAnswers$spotAnswers$pageInfo
  >
  get copyWith =>
      CopyWith$Query$SpotAnswers$spotAnswers$pageInfo(this, (i) => i);
}

abstract class CopyWith$Query$SpotAnswers$spotAnswers$pageInfo<TRes> {
  factory CopyWith$Query$SpotAnswers$spotAnswers$pageInfo(
    Query$SpotAnswers$spotAnswers$pageInfo instance,
    TRes Function(Query$SpotAnswers$spotAnswers$pageInfo) then,
  ) = _CopyWithImpl$Query$SpotAnswers$spotAnswers$pageInfo;

  factory CopyWith$Query$SpotAnswers$spotAnswers$pageInfo.stub(TRes res) =
      _CopyWithStubImpl$Query$SpotAnswers$spotAnswers$pageInfo;

  TRes call({bool? hasNextPage, String? endCursor});
}

class _CopyWithImpl$Query$SpotAnswers$spotAnswers$pageInfo<TRes>
    implements CopyWith$Query$SpotAnswers$spotAnswers$pageInfo<TRes> {
  _CopyWithImpl$Query$SpotAnswers$spotAnswers$pageInfo(
    this._instance,
    this._then,
  );

  final Query$SpotAnswers$spotAnswers$pageInfo _instance;

  final TRes Function(Query$SpotAnswers$spotAnswers$pageInfo) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? hasNextPage = _undefined,
    Object? endCursor = _undefined,
  }) => _then(
    Query$SpotAnswers$spotAnswers$pageInfo(
      hasNextPage: hasNextPage == _undefined || hasNextPage == null
          ? _instance.hasNextPage
          : (hasNextPage as bool),
      endCursor: endCursor == _undefined
          ? _instance.endCursor
          : (endCursor as String?),
    ),
  );
}

class _CopyWithStubImpl$Query$SpotAnswers$spotAnswers$pageInfo<TRes>
    implements CopyWith$Query$SpotAnswers$spotAnswers$pageInfo<TRes> {
  _CopyWithStubImpl$Query$SpotAnswers$spotAnswers$pageInfo(this._res);

  TRes _res;

  call({bool? hasNextPage, String? endCursor}) => _res;
}

class Variables$Mutation$CreateSpotQuestion {
  factory Variables$Mutation$CreateSpotQuestion({
    required String catalogId,
    required String body,
    required List<String> photoKeys,
  }) => Variables$Mutation$CreateSpotQuestion._({
    r'catalogId': catalogId,
    r'body': body,
    r'photoKeys': photoKeys,
  });

  Variables$Mutation$CreateSpotQuestion._(this._$data);

  factory Variables$Mutation$CreateSpotQuestion.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    final l$catalogId = data['catalogId'];
    result$data['catalogId'] = (l$catalogId as String);
    final l$body = data['body'];
    result$data['body'] = (l$body as String);
    final l$photoKeys = data['photoKeys'];
    result$data['photoKeys'] = (l$photoKeys as List<dynamic>)
        .map((e) => (e as String))
        .toList();
    return Variables$Mutation$CreateSpotQuestion._(result$data);
  }

  Map<String, dynamic> _$data;

  String get catalogId => (_$data['catalogId'] as String);

  String get body => (_$data['body'] as String);

  List<String> get photoKeys => (_$data['photoKeys'] as List<String>);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$catalogId = catalogId;
    result$data['catalogId'] = l$catalogId;
    final l$body = body;
    result$data['body'] = l$body;
    final l$photoKeys = photoKeys;
    result$data['photoKeys'] = l$photoKeys.map((e) => e).toList();
    return result$data;
  }

  CopyWith$Variables$Mutation$CreateSpotQuestion<
    Variables$Mutation$CreateSpotQuestion
  >
  get copyWith =>
      CopyWith$Variables$Mutation$CreateSpotQuestion(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Mutation$CreateSpotQuestion ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$catalogId = catalogId;
    final lOther$catalogId = other.catalogId;
    if (l$catalogId != lOther$catalogId) {
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
    final l$catalogId = catalogId;
    final l$body = body;
    final l$photoKeys = photoKeys;
    return Object.hashAll([
      l$catalogId,
      l$body,
      Object.hashAll(l$photoKeys.map((v) => v)),
    ]);
  }
}

abstract class CopyWith$Variables$Mutation$CreateSpotQuestion<TRes> {
  factory CopyWith$Variables$Mutation$CreateSpotQuestion(
    Variables$Mutation$CreateSpotQuestion instance,
    TRes Function(Variables$Mutation$CreateSpotQuestion) then,
  ) = _CopyWithImpl$Variables$Mutation$CreateSpotQuestion;

  factory CopyWith$Variables$Mutation$CreateSpotQuestion.stub(TRes res) =
      _CopyWithStubImpl$Variables$Mutation$CreateSpotQuestion;

  TRes call({String? catalogId, String? body, List<String>? photoKeys});
}

class _CopyWithImpl$Variables$Mutation$CreateSpotQuestion<TRes>
    implements CopyWith$Variables$Mutation$CreateSpotQuestion<TRes> {
  _CopyWithImpl$Variables$Mutation$CreateSpotQuestion(
    this._instance,
    this._then,
  );

  final Variables$Mutation$CreateSpotQuestion _instance;

  final TRes Function(Variables$Mutation$CreateSpotQuestion) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? catalogId = _undefined,
    Object? body = _undefined,
    Object? photoKeys = _undefined,
  }) => _then(
    Variables$Mutation$CreateSpotQuestion._({
      ..._instance._$data,
      if (catalogId != _undefined && catalogId != null)
        'catalogId': (catalogId as String),
      if (body != _undefined && body != null) 'body': (body as String),
      if (photoKeys != _undefined && photoKeys != null)
        'photoKeys': (photoKeys as List<String>),
    }),
  );
}

class _CopyWithStubImpl$Variables$Mutation$CreateSpotQuestion<TRes>
    implements CopyWith$Variables$Mutation$CreateSpotQuestion<TRes> {
  _CopyWithStubImpl$Variables$Mutation$CreateSpotQuestion(this._res);

  TRes _res;

  call({String? catalogId, String? body, List<String>? photoKeys}) => _res;
}

class Mutation$CreateSpotQuestion {
  Mutation$CreateSpotQuestion({required this.createSpotQuestion});

  factory Mutation$CreateSpotQuestion.fromJson(Map<String, dynamic> json) {
    final l$createSpotQuestion = json['createSpotQuestion'];
    return Mutation$CreateSpotQuestion(
      createSpotQuestion:
          Mutation$CreateSpotQuestion$createSpotQuestion.fromJson(
            (l$createSpotQuestion as Map<String, dynamic>),
          ),
    );
  }

  final Mutation$CreateSpotQuestion$createSpotQuestion createSpotQuestion;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$createSpotQuestion = createSpotQuestion;
    _resultData['createSpotQuestion'] = l$createSpotQuestion.toJson();
    return _resultData;
  }

  @override
  int get hashCode {
    final l$createSpotQuestion = createSpotQuestion;
    return Object.hashAll([l$createSpotQuestion]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$CreateSpotQuestion ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$createSpotQuestion = createSpotQuestion;
    final lOther$createSpotQuestion = other.createSpotQuestion;
    if (l$createSpotQuestion != lOther$createSpotQuestion) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Mutation$CreateSpotQuestion
    on Mutation$CreateSpotQuestion {
  CopyWith$Mutation$CreateSpotQuestion<Mutation$CreateSpotQuestion>
  get copyWith => CopyWith$Mutation$CreateSpotQuestion(this, (i) => i);
}

abstract class CopyWith$Mutation$CreateSpotQuestion<TRes> {
  factory CopyWith$Mutation$CreateSpotQuestion(
    Mutation$CreateSpotQuestion instance,
    TRes Function(Mutation$CreateSpotQuestion) then,
  ) = _CopyWithImpl$Mutation$CreateSpotQuestion;

  factory CopyWith$Mutation$CreateSpotQuestion.stub(TRes res) =
      _CopyWithStubImpl$Mutation$CreateSpotQuestion;

  TRes call({
    Mutation$CreateSpotQuestion$createSpotQuestion? createSpotQuestion,
  });
  CopyWith$Mutation$CreateSpotQuestion$createSpotQuestion<TRes>
  get createSpotQuestion;
}

class _CopyWithImpl$Mutation$CreateSpotQuestion<TRes>
    implements CopyWith$Mutation$CreateSpotQuestion<TRes> {
  _CopyWithImpl$Mutation$CreateSpotQuestion(this._instance, this._then);

  final Mutation$CreateSpotQuestion _instance;

  final TRes Function(Mutation$CreateSpotQuestion) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? createSpotQuestion = _undefined}) => _then(
    Mutation$CreateSpotQuestion(
      createSpotQuestion:
          createSpotQuestion == _undefined || createSpotQuestion == null
          ? _instance.createSpotQuestion
          : (createSpotQuestion
                as Mutation$CreateSpotQuestion$createSpotQuestion),
    ),
  );

  CopyWith$Mutation$CreateSpotQuestion$createSpotQuestion<TRes>
  get createSpotQuestion {
    final local$createSpotQuestion = _instance.createSpotQuestion;
    return CopyWith$Mutation$CreateSpotQuestion$createSpotQuestion(
      local$createSpotQuestion,
      (e) => call(createSpotQuestion: e),
    );
  }
}

class _CopyWithStubImpl$Mutation$CreateSpotQuestion<TRes>
    implements CopyWith$Mutation$CreateSpotQuestion<TRes> {
  _CopyWithStubImpl$Mutation$CreateSpotQuestion(this._res);

  TRes _res;

  call({Mutation$CreateSpotQuestion$createSpotQuestion? createSpotQuestion}) =>
      _res;

  CopyWith$Mutation$CreateSpotQuestion$createSpotQuestion<TRes>
  get createSpotQuestion =>
      CopyWith$Mutation$CreateSpotQuestion$createSpotQuestion.stub(_res);
}

const documentNodeMutationCreateSpotQuestion = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'CreateSpotQuestion'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'catalogId')),
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
            name: NameNode(value: 'createSpotQuestion'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'input'),
                value: ObjectValueNode(
                  fields: [
                    ObjectFieldNode(
                      name: NameNode(value: 'catalogId'),
                      value: VariableNode(name: NameNode(value: 'catalogId')),
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
                        name: NameNode(value: 'field'),
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
                    ],
                  ),
                ),
                FieldNode(
                  name: NameNode(value: 'questionId'),
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

class Mutation$CreateSpotQuestion$createSpotQuestion {
  Mutation$CreateSpotQuestion$createSpotQuestion({
    required this.success,
    required this.userErrors,
    this.questionId,
  });

  factory Mutation$CreateSpotQuestion$createSpotQuestion.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$success = json['success'];
    final l$userErrors = json['userErrors'];
    final l$questionId = json['questionId'];
    return Mutation$CreateSpotQuestion$createSpotQuestion(
      success: (l$success as bool),
      userErrors: (l$userErrors as List<dynamic>)
          .map(
            (e) =>
                Mutation$CreateSpotQuestion$createSpotQuestion$userErrors.fromJson(
                  (e as Map<String, dynamic>),
                ),
          )
          .toList(),
      questionId: (l$questionId as String?),
    );
  }

  final bool success;

  final List<Mutation$CreateSpotQuestion$createSpotQuestion$userErrors>
  userErrors;

  final String? questionId;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$success = success;
    _resultData['success'] = l$success;
    final l$userErrors = userErrors;
    _resultData['userErrors'] = l$userErrors.map((e) => e.toJson()).toList();
    final l$questionId = questionId;
    _resultData['questionId'] = l$questionId;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$success = success;
    final l$userErrors = userErrors;
    final l$questionId = questionId;
    return Object.hashAll([
      l$success,
      Object.hashAll(l$userErrors.map((v) => v)),
      l$questionId,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$CreateSpotQuestion$createSpotQuestion ||
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
    final l$questionId = questionId;
    final lOther$questionId = other.questionId;
    if (l$questionId != lOther$questionId) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Mutation$CreateSpotQuestion$createSpotQuestion
    on Mutation$CreateSpotQuestion$createSpotQuestion {
  CopyWith$Mutation$CreateSpotQuestion$createSpotQuestion<
    Mutation$CreateSpotQuestion$createSpotQuestion
  >
  get copyWith =>
      CopyWith$Mutation$CreateSpotQuestion$createSpotQuestion(this, (i) => i);
}

abstract class CopyWith$Mutation$CreateSpotQuestion$createSpotQuestion<TRes> {
  factory CopyWith$Mutation$CreateSpotQuestion$createSpotQuestion(
    Mutation$CreateSpotQuestion$createSpotQuestion instance,
    TRes Function(Mutation$CreateSpotQuestion$createSpotQuestion) then,
  ) = _CopyWithImpl$Mutation$CreateSpotQuestion$createSpotQuestion;

  factory CopyWith$Mutation$CreateSpotQuestion$createSpotQuestion.stub(
    TRes res,
  ) = _CopyWithStubImpl$Mutation$CreateSpotQuestion$createSpotQuestion;

  TRes call({
    bool? success,
    List<Mutation$CreateSpotQuestion$createSpotQuestion$userErrors>? userErrors,
    String? questionId,
  });
  TRes userErrors(
    Iterable<Mutation$CreateSpotQuestion$createSpotQuestion$userErrors>
    Function(
      Iterable<
        CopyWith$Mutation$CreateSpotQuestion$createSpotQuestion$userErrors<
          Mutation$CreateSpotQuestion$createSpotQuestion$userErrors
        >
      >,
    )
    _fn,
  );
}

class _CopyWithImpl$Mutation$CreateSpotQuestion$createSpotQuestion<TRes>
    implements CopyWith$Mutation$CreateSpotQuestion$createSpotQuestion<TRes> {
  _CopyWithImpl$Mutation$CreateSpotQuestion$createSpotQuestion(
    this._instance,
    this._then,
  );

  final Mutation$CreateSpotQuestion$createSpotQuestion _instance;

  final TRes Function(Mutation$CreateSpotQuestion$createSpotQuestion) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? success = _undefined,
    Object? userErrors = _undefined,
    Object? questionId = _undefined,
  }) => _then(
    Mutation$CreateSpotQuestion$createSpotQuestion(
      success: success == _undefined || success == null
          ? _instance.success
          : (success as bool),
      userErrors: userErrors == _undefined || userErrors == null
          ? _instance.userErrors
          : (userErrors
                as List<
                  Mutation$CreateSpotQuestion$createSpotQuestion$userErrors
                >),
      questionId: questionId == _undefined
          ? _instance.questionId
          : (questionId as String?),
    ),
  );

  TRes userErrors(
    Iterable<Mutation$CreateSpotQuestion$createSpotQuestion$userErrors>
    Function(
      Iterable<
        CopyWith$Mutation$CreateSpotQuestion$createSpotQuestion$userErrors<
          Mutation$CreateSpotQuestion$createSpotQuestion$userErrors
        >
      >,
    )
    _fn,
  ) => call(
    userErrors: _fn(
      _instance.userErrors.map(
        (e) =>
            CopyWith$Mutation$CreateSpotQuestion$createSpotQuestion$userErrors(
              e,
              (i) => i,
            ),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl$Mutation$CreateSpotQuestion$createSpotQuestion<TRes>
    implements CopyWith$Mutation$CreateSpotQuestion$createSpotQuestion<TRes> {
  _CopyWithStubImpl$Mutation$CreateSpotQuestion$createSpotQuestion(this._res);

  TRes _res;

  call({
    bool? success,
    List<Mutation$CreateSpotQuestion$createSpotQuestion$userErrors>? userErrors,
    String? questionId,
  }) => _res;

  userErrors(_fn) => _res;
}

class Mutation$CreateSpotQuestion$createSpotQuestion$userErrors {
  Mutation$CreateSpotQuestion$createSpotQuestion$userErrors({
    required this.code,
    this.field,
    required this.message,
  });

  factory Mutation$CreateSpotQuestion$createSpotQuestion$userErrors.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$code = json['code'];
    final l$field = json['field'];
    final l$message = json['message'];
    return Mutation$CreateSpotQuestion$createSpotQuestion$userErrors(
      code: (l$code as String),
      field: (l$field as String?),
      message: (l$message as String),
    );
  }

  final String code;

  final String? field;

  final String message;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$code = code;
    _resultData['code'] = l$code;
    final l$field = field;
    _resultData['field'] = l$field;
    final l$message = message;
    _resultData['message'] = l$message;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$code = code;
    final l$field = field;
    final l$message = message;
    return Object.hashAll([l$code, l$field, l$message]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$CreateSpotQuestion$createSpotQuestion$userErrors ||
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
    final l$message = message;
    final lOther$message = other.message;
    if (l$message != lOther$message) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Mutation$CreateSpotQuestion$createSpotQuestion$userErrors
    on Mutation$CreateSpotQuestion$createSpotQuestion$userErrors {
  CopyWith$Mutation$CreateSpotQuestion$createSpotQuestion$userErrors<
    Mutation$CreateSpotQuestion$createSpotQuestion$userErrors
  >
  get copyWith =>
      CopyWith$Mutation$CreateSpotQuestion$createSpotQuestion$userErrors(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Mutation$CreateSpotQuestion$createSpotQuestion$userErrors<
  TRes
> {
  factory CopyWith$Mutation$CreateSpotQuestion$createSpotQuestion$userErrors(
    Mutation$CreateSpotQuestion$createSpotQuestion$userErrors instance,
    TRes Function(Mutation$CreateSpotQuestion$createSpotQuestion$userErrors)
    then,
  ) = _CopyWithImpl$Mutation$CreateSpotQuestion$createSpotQuestion$userErrors;

  factory CopyWith$Mutation$CreateSpotQuestion$createSpotQuestion$userErrors.stub(
    TRes res,
  ) = _CopyWithStubImpl$Mutation$CreateSpotQuestion$createSpotQuestion$userErrors;

  TRes call({String? code, String? field, String? message});
}

class _CopyWithImpl$Mutation$CreateSpotQuestion$createSpotQuestion$userErrors<
  TRes
>
    implements
        CopyWith$Mutation$CreateSpotQuestion$createSpotQuestion$userErrors<
          TRes
        > {
  _CopyWithImpl$Mutation$CreateSpotQuestion$createSpotQuestion$userErrors(
    this._instance,
    this._then,
  );

  final Mutation$CreateSpotQuestion$createSpotQuestion$userErrors _instance;

  final TRes Function(Mutation$CreateSpotQuestion$createSpotQuestion$userErrors)
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? code = _undefined,
    Object? field = _undefined,
    Object? message = _undefined,
  }) => _then(
    Mutation$CreateSpotQuestion$createSpotQuestion$userErrors(
      code: code == _undefined || code == null
          ? _instance.code
          : (code as String),
      field: field == _undefined ? _instance.field : (field as String?),
      message: message == _undefined || message == null
          ? _instance.message
          : (message as String),
    ),
  );
}

class _CopyWithStubImpl$Mutation$CreateSpotQuestion$createSpotQuestion$userErrors<
  TRes
>
    implements
        CopyWith$Mutation$CreateSpotQuestion$createSpotQuestion$userErrors<
          TRes
        > {
  _CopyWithStubImpl$Mutation$CreateSpotQuestion$createSpotQuestion$userErrors(
    this._res,
  );

  TRes _res;

  call({String? code, String? field, String? message}) => _res;
}

class Variables$Mutation$DeleteSpotQuestion {
  factory Variables$Mutation$DeleteSpotQuestion({required String questionId}) =>
      Variables$Mutation$DeleteSpotQuestion._({r'questionId': questionId});

  Variables$Mutation$DeleteSpotQuestion._(this._$data);

  factory Variables$Mutation$DeleteSpotQuestion.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    final l$questionId = data['questionId'];
    result$data['questionId'] = (l$questionId as String);
    return Variables$Mutation$DeleteSpotQuestion._(result$data);
  }

  Map<String, dynamic> _$data;

  String get questionId => (_$data['questionId'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$questionId = questionId;
    result$data['questionId'] = l$questionId;
    return result$data;
  }

  CopyWith$Variables$Mutation$DeleteSpotQuestion<
    Variables$Mutation$DeleteSpotQuestion
  >
  get copyWith =>
      CopyWith$Variables$Mutation$DeleteSpotQuestion(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Mutation$DeleteSpotQuestion ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$questionId = questionId;
    final lOther$questionId = other.questionId;
    if (l$questionId != lOther$questionId) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$questionId = questionId;
    return Object.hashAll([l$questionId]);
  }
}

abstract class CopyWith$Variables$Mutation$DeleteSpotQuestion<TRes> {
  factory CopyWith$Variables$Mutation$DeleteSpotQuestion(
    Variables$Mutation$DeleteSpotQuestion instance,
    TRes Function(Variables$Mutation$DeleteSpotQuestion) then,
  ) = _CopyWithImpl$Variables$Mutation$DeleteSpotQuestion;

  factory CopyWith$Variables$Mutation$DeleteSpotQuestion.stub(TRes res) =
      _CopyWithStubImpl$Variables$Mutation$DeleteSpotQuestion;

  TRes call({String? questionId});
}

class _CopyWithImpl$Variables$Mutation$DeleteSpotQuestion<TRes>
    implements CopyWith$Variables$Mutation$DeleteSpotQuestion<TRes> {
  _CopyWithImpl$Variables$Mutation$DeleteSpotQuestion(
    this._instance,
    this._then,
  );

  final Variables$Mutation$DeleteSpotQuestion _instance;

  final TRes Function(Variables$Mutation$DeleteSpotQuestion) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? questionId = _undefined}) => _then(
    Variables$Mutation$DeleteSpotQuestion._({
      ..._instance._$data,
      if (questionId != _undefined && questionId != null)
        'questionId': (questionId as String),
    }),
  );
}

class _CopyWithStubImpl$Variables$Mutation$DeleteSpotQuestion<TRes>
    implements CopyWith$Variables$Mutation$DeleteSpotQuestion<TRes> {
  _CopyWithStubImpl$Variables$Mutation$DeleteSpotQuestion(this._res);

  TRes _res;

  call({String? questionId}) => _res;
}

class Mutation$DeleteSpotQuestion {
  Mutation$DeleteSpotQuestion({required this.deleteSpotQuestion});

  factory Mutation$DeleteSpotQuestion.fromJson(Map<String, dynamic> json) {
    final l$deleteSpotQuestion = json['deleteSpotQuestion'];
    return Mutation$DeleteSpotQuestion(
      deleteSpotQuestion:
          Mutation$DeleteSpotQuestion$deleteSpotQuestion.fromJson(
            (l$deleteSpotQuestion as Map<String, dynamic>),
          ),
    );
  }

  final Mutation$DeleteSpotQuestion$deleteSpotQuestion deleteSpotQuestion;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$deleteSpotQuestion = deleteSpotQuestion;
    _resultData['deleteSpotQuestion'] = l$deleteSpotQuestion.toJson();
    return _resultData;
  }

  @override
  int get hashCode {
    final l$deleteSpotQuestion = deleteSpotQuestion;
    return Object.hashAll([l$deleteSpotQuestion]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$DeleteSpotQuestion ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$deleteSpotQuestion = deleteSpotQuestion;
    final lOther$deleteSpotQuestion = other.deleteSpotQuestion;
    if (l$deleteSpotQuestion != lOther$deleteSpotQuestion) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Mutation$DeleteSpotQuestion
    on Mutation$DeleteSpotQuestion {
  CopyWith$Mutation$DeleteSpotQuestion<Mutation$DeleteSpotQuestion>
  get copyWith => CopyWith$Mutation$DeleteSpotQuestion(this, (i) => i);
}

abstract class CopyWith$Mutation$DeleteSpotQuestion<TRes> {
  factory CopyWith$Mutation$DeleteSpotQuestion(
    Mutation$DeleteSpotQuestion instance,
    TRes Function(Mutation$DeleteSpotQuestion) then,
  ) = _CopyWithImpl$Mutation$DeleteSpotQuestion;

  factory CopyWith$Mutation$DeleteSpotQuestion.stub(TRes res) =
      _CopyWithStubImpl$Mutation$DeleteSpotQuestion;

  TRes call({
    Mutation$DeleteSpotQuestion$deleteSpotQuestion? deleteSpotQuestion,
  });
  CopyWith$Mutation$DeleteSpotQuestion$deleteSpotQuestion<TRes>
  get deleteSpotQuestion;
}

class _CopyWithImpl$Mutation$DeleteSpotQuestion<TRes>
    implements CopyWith$Mutation$DeleteSpotQuestion<TRes> {
  _CopyWithImpl$Mutation$DeleteSpotQuestion(this._instance, this._then);

  final Mutation$DeleteSpotQuestion _instance;

  final TRes Function(Mutation$DeleteSpotQuestion) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? deleteSpotQuestion = _undefined}) => _then(
    Mutation$DeleteSpotQuestion(
      deleteSpotQuestion:
          deleteSpotQuestion == _undefined || deleteSpotQuestion == null
          ? _instance.deleteSpotQuestion
          : (deleteSpotQuestion
                as Mutation$DeleteSpotQuestion$deleteSpotQuestion),
    ),
  );

  CopyWith$Mutation$DeleteSpotQuestion$deleteSpotQuestion<TRes>
  get deleteSpotQuestion {
    final local$deleteSpotQuestion = _instance.deleteSpotQuestion;
    return CopyWith$Mutation$DeleteSpotQuestion$deleteSpotQuestion(
      local$deleteSpotQuestion,
      (e) => call(deleteSpotQuestion: e),
    );
  }
}

class _CopyWithStubImpl$Mutation$DeleteSpotQuestion<TRes>
    implements CopyWith$Mutation$DeleteSpotQuestion<TRes> {
  _CopyWithStubImpl$Mutation$DeleteSpotQuestion(this._res);

  TRes _res;

  call({Mutation$DeleteSpotQuestion$deleteSpotQuestion? deleteSpotQuestion}) =>
      _res;

  CopyWith$Mutation$DeleteSpotQuestion$deleteSpotQuestion<TRes>
  get deleteSpotQuestion =>
      CopyWith$Mutation$DeleteSpotQuestion$deleteSpotQuestion.stub(_res);
}

const documentNodeMutationDeleteSpotQuestion = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'DeleteSpotQuestion'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'questionId')),
          type: NamedTypeNode(name: NameNode(value: 'ID'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
      ],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'deleteSpotQuestion'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'input'),
                value: ObjectValueNode(
                  fields: [
                    ObjectFieldNode(
                      name: NameNode(value: 'questionId'),
                      value: VariableNode(name: NameNode(value: 'questionId')),
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
                        name: NameNode(value: 'field'),
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

class Mutation$DeleteSpotQuestion$deleteSpotQuestion {
  Mutation$DeleteSpotQuestion$deleteSpotQuestion({
    required this.success,
    required this.userErrors,
  });

  factory Mutation$DeleteSpotQuestion$deleteSpotQuestion.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$success = json['success'];
    final l$userErrors = json['userErrors'];
    return Mutation$DeleteSpotQuestion$deleteSpotQuestion(
      success: (l$success as bool),
      userErrors: (l$userErrors as List<dynamic>)
          .map(
            (e) =>
                Mutation$DeleteSpotQuestion$deleteSpotQuestion$userErrors.fromJson(
                  (e as Map<String, dynamic>),
                ),
          )
          .toList(),
    );
  }

  final bool success;

  final List<Mutation$DeleteSpotQuestion$deleteSpotQuestion$userErrors>
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
    if (other is! Mutation$DeleteSpotQuestion$deleteSpotQuestion ||
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

extension UtilityExtension$Mutation$DeleteSpotQuestion$deleteSpotQuestion
    on Mutation$DeleteSpotQuestion$deleteSpotQuestion {
  CopyWith$Mutation$DeleteSpotQuestion$deleteSpotQuestion<
    Mutation$DeleteSpotQuestion$deleteSpotQuestion
  >
  get copyWith =>
      CopyWith$Mutation$DeleteSpotQuestion$deleteSpotQuestion(this, (i) => i);
}

abstract class CopyWith$Mutation$DeleteSpotQuestion$deleteSpotQuestion<TRes> {
  factory CopyWith$Mutation$DeleteSpotQuestion$deleteSpotQuestion(
    Mutation$DeleteSpotQuestion$deleteSpotQuestion instance,
    TRes Function(Mutation$DeleteSpotQuestion$deleteSpotQuestion) then,
  ) = _CopyWithImpl$Mutation$DeleteSpotQuestion$deleteSpotQuestion;

  factory CopyWith$Mutation$DeleteSpotQuestion$deleteSpotQuestion.stub(
    TRes res,
  ) = _CopyWithStubImpl$Mutation$DeleteSpotQuestion$deleteSpotQuestion;

  TRes call({
    bool? success,
    List<Mutation$DeleteSpotQuestion$deleteSpotQuestion$userErrors>? userErrors,
  });
  TRes userErrors(
    Iterable<Mutation$DeleteSpotQuestion$deleteSpotQuestion$userErrors>
    Function(
      Iterable<
        CopyWith$Mutation$DeleteSpotQuestion$deleteSpotQuestion$userErrors<
          Mutation$DeleteSpotQuestion$deleteSpotQuestion$userErrors
        >
      >,
    )
    _fn,
  );
}

class _CopyWithImpl$Mutation$DeleteSpotQuestion$deleteSpotQuestion<TRes>
    implements CopyWith$Mutation$DeleteSpotQuestion$deleteSpotQuestion<TRes> {
  _CopyWithImpl$Mutation$DeleteSpotQuestion$deleteSpotQuestion(
    this._instance,
    this._then,
  );

  final Mutation$DeleteSpotQuestion$deleteSpotQuestion _instance;

  final TRes Function(Mutation$DeleteSpotQuestion$deleteSpotQuestion) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? success = _undefined, Object? userErrors = _undefined}) =>
      _then(
        Mutation$DeleteSpotQuestion$deleteSpotQuestion(
          success: success == _undefined || success == null
              ? _instance.success
              : (success as bool),
          userErrors: userErrors == _undefined || userErrors == null
              ? _instance.userErrors
              : (userErrors
                    as List<
                      Mutation$DeleteSpotQuestion$deleteSpotQuestion$userErrors
                    >),
        ),
      );

  TRes userErrors(
    Iterable<Mutation$DeleteSpotQuestion$deleteSpotQuestion$userErrors>
    Function(
      Iterable<
        CopyWith$Mutation$DeleteSpotQuestion$deleteSpotQuestion$userErrors<
          Mutation$DeleteSpotQuestion$deleteSpotQuestion$userErrors
        >
      >,
    )
    _fn,
  ) => call(
    userErrors: _fn(
      _instance.userErrors.map(
        (e) =>
            CopyWith$Mutation$DeleteSpotQuestion$deleteSpotQuestion$userErrors(
              e,
              (i) => i,
            ),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl$Mutation$DeleteSpotQuestion$deleteSpotQuestion<TRes>
    implements CopyWith$Mutation$DeleteSpotQuestion$deleteSpotQuestion<TRes> {
  _CopyWithStubImpl$Mutation$DeleteSpotQuestion$deleteSpotQuestion(this._res);

  TRes _res;

  call({
    bool? success,
    List<Mutation$DeleteSpotQuestion$deleteSpotQuestion$userErrors>? userErrors,
  }) => _res;

  userErrors(_fn) => _res;
}

class Mutation$DeleteSpotQuestion$deleteSpotQuestion$userErrors {
  Mutation$DeleteSpotQuestion$deleteSpotQuestion$userErrors({
    required this.code,
    this.field,
    required this.message,
  });

  factory Mutation$DeleteSpotQuestion$deleteSpotQuestion$userErrors.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$code = json['code'];
    final l$field = json['field'];
    final l$message = json['message'];
    return Mutation$DeleteSpotQuestion$deleteSpotQuestion$userErrors(
      code: (l$code as String),
      field: (l$field as String?),
      message: (l$message as String),
    );
  }

  final String code;

  final String? field;

  final String message;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$code = code;
    _resultData['code'] = l$code;
    final l$field = field;
    _resultData['field'] = l$field;
    final l$message = message;
    _resultData['message'] = l$message;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$code = code;
    final l$field = field;
    final l$message = message;
    return Object.hashAll([l$code, l$field, l$message]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$DeleteSpotQuestion$deleteSpotQuestion$userErrors ||
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
    final l$message = message;
    final lOther$message = other.message;
    if (l$message != lOther$message) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Mutation$DeleteSpotQuestion$deleteSpotQuestion$userErrors
    on Mutation$DeleteSpotQuestion$deleteSpotQuestion$userErrors {
  CopyWith$Mutation$DeleteSpotQuestion$deleteSpotQuestion$userErrors<
    Mutation$DeleteSpotQuestion$deleteSpotQuestion$userErrors
  >
  get copyWith =>
      CopyWith$Mutation$DeleteSpotQuestion$deleteSpotQuestion$userErrors(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Mutation$DeleteSpotQuestion$deleteSpotQuestion$userErrors<
  TRes
> {
  factory CopyWith$Mutation$DeleteSpotQuestion$deleteSpotQuestion$userErrors(
    Mutation$DeleteSpotQuestion$deleteSpotQuestion$userErrors instance,
    TRes Function(Mutation$DeleteSpotQuestion$deleteSpotQuestion$userErrors)
    then,
  ) = _CopyWithImpl$Mutation$DeleteSpotQuestion$deleteSpotQuestion$userErrors;

  factory CopyWith$Mutation$DeleteSpotQuestion$deleteSpotQuestion$userErrors.stub(
    TRes res,
  ) = _CopyWithStubImpl$Mutation$DeleteSpotQuestion$deleteSpotQuestion$userErrors;

  TRes call({String? code, String? field, String? message});
}

class _CopyWithImpl$Mutation$DeleteSpotQuestion$deleteSpotQuestion$userErrors<
  TRes
>
    implements
        CopyWith$Mutation$DeleteSpotQuestion$deleteSpotQuestion$userErrors<
          TRes
        > {
  _CopyWithImpl$Mutation$DeleteSpotQuestion$deleteSpotQuestion$userErrors(
    this._instance,
    this._then,
  );

  final Mutation$DeleteSpotQuestion$deleteSpotQuestion$userErrors _instance;

  final TRes Function(Mutation$DeleteSpotQuestion$deleteSpotQuestion$userErrors)
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? code = _undefined,
    Object? field = _undefined,
    Object? message = _undefined,
  }) => _then(
    Mutation$DeleteSpotQuestion$deleteSpotQuestion$userErrors(
      code: code == _undefined || code == null
          ? _instance.code
          : (code as String),
      field: field == _undefined ? _instance.field : (field as String?),
      message: message == _undefined || message == null
          ? _instance.message
          : (message as String),
    ),
  );
}

class _CopyWithStubImpl$Mutation$DeleteSpotQuestion$deleteSpotQuestion$userErrors<
  TRes
>
    implements
        CopyWith$Mutation$DeleteSpotQuestion$deleteSpotQuestion$userErrors<
          TRes
        > {
  _CopyWithStubImpl$Mutation$DeleteSpotQuestion$deleteSpotQuestion$userErrors(
    this._res,
  );

  TRes _res;

  call({String? code, String? field, String? message}) => _res;
}

class Variables$Mutation$ResolveSpotQuestion {
  factory Variables$Mutation$ResolveSpotQuestion({
    required String questionId,
  }) => Variables$Mutation$ResolveSpotQuestion._({r'questionId': questionId});

  Variables$Mutation$ResolveSpotQuestion._(this._$data);

  factory Variables$Mutation$ResolveSpotQuestion.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    final l$questionId = data['questionId'];
    result$data['questionId'] = (l$questionId as String);
    return Variables$Mutation$ResolveSpotQuestion._(result$data);
  }

  Map<String, dynamic> _$data;

  String get questionId => (_$data['questionId'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$questionId = questionId;
    result$data['questionId'] = l$questionId;
    return result$data;
  }

  CopyWith$Variables$Mutation$ResolveSpotQuestion<
    Variables$Mutation$ResolveSpotQuestion
  >
  get copyWith =>
      CopyWith$Variables$Mutation$ResolveSpotQuestion(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Mutation$ResolveSpotQuestion ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$questionId = questionId;
    final lOther$questionId = other.questionId;
    if (l$questionId != lOther$questionId) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$questionId = questionId;
    return Object.hashAll([l$questionId]);
  }
}

abstract class CopyWith$Variables$Mutation$ResolveSpotQuestion<TRes> {
  factory CopyWith$Variables$Mutation$ResolveSpotQuestion(
    Variables$Mutation$ResolveSpotQuestion instance,
    TRes Function(Variables$Mutation$ResolveSpotQuestion) then,
  ) = _CopyWithImpl$Variables$Mutation$ResolveSpotQuestion;

  factory CopyWith$Variables$Mutation$ResolveSpotQuestion.stub(TRes res) =
      _CopyWithStubImpl$Variables$Mutation$ResolveSpotQuestion;

  TRes call({String? questionId});
}

class _CopyWithImpl$Variables$Mutation$ResolveSpotQuestion<TRes>
    implements CopyWith$Variables$Mutation$ResolveSpotQuestion<TRes> {
  _CopyWithImpl$Variables$Mutation$ResolveSpotQuestion(
    this._instance,
    this._then,
  );

  final Variables$Mutation$ResolveSpotQuestion _instance;

  final TRes Function(Variables$Mutation$ResolveSpotQuestion) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? questionId = _undefined}) => _then(
    Variables$Mutation$ResolveSpotQuestion._({
      ..._instance._$data,
      if (questionId != _undefined && questionId != null)
        'questionId': (questionId as String),
    }),
  );
}

class _CopyWithStubImpl$Variables$Mutation$ResolveSpotQuestion<TRes>
    implements CopyWith$Variables$Mutation$ResolveSpotQuestion<TRes> {
  _CopyWithStubImpl$Variables$Mutation$ResolveSpotQuestion(this._res);

  TRes _res;

  call({String? questionId}) => _res;
}

class Mutation$ResolveSpotQuestion {
  Mutation$ResolveSpotQuestion({required this.resolveSpotQuestion});

  factory Mutation$ResolveSpotQuestion.fromJson(Map<String, dynamic> json) {
    final l$resolveSpotQuestion = json['resolveSpotQuestion'];
    return Mutation$ResolveSpotQuestion(
      resolveSpotQuestion:
          Mutation$ResolveSpotQuestion$resolveSpotQuestion.fromJson(
            (l$resolveSpotQuestion as Map<String, dynamic>),
          ),
    );
  }

  final Mutation$ResolveSpotQuestion$resolveSpotQuestion resolveSpotQuestion;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$resolveSpotQuestion = resolveSpotQuestion;
    _resultData['resolveSpotQuestion'] = l$resolveSpotQuestion.toJson();
    return _resultData;
  }

  @override
  int get hashCode {
    final l$resolveSpotQuestion = resolveSpotQuestion;
    return Object.hashAll([l$resolveSpotQuestion]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$ResolveSpotQuestion ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$resolveSpotQuestion = resolveSpotQuestion;
    final lOther$resolveSpotQuestion = other.resolveSpotQuestion;
    if (l$resolveSpotQuestion != lOther$resolveSpotQuestion) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Mutation$ResolveSpotQuestion
    on Mutation$ResolveSpotQuestion {
  CopyWith$Mutation$ResolveSpotQuestion<Mutation$ResolveSpotQuestion>
  get copyWith => CopyWith$Mutation$ResolveSpotQuestion(this, (i) => i);
}

abstract class CopyWith$Mutation$ResolveSpotQuestion<TRes> {
  factory CopyWith$Mutation$ResolveSpotQuestion(
    Mutation$ResolveSpotQuestion instance,
    TRes Function(Mutation$ResolveSpotQuestion) then,
  ) = _CopyWithImpl$Mutation$ResolveSpotQuestion;

  factory CopyWith$Mutation$ResolveSpotQuestion.stub(TRes res) =
      _CopyWithStubImpl$Mutation$ResolveSpotQuestion;

  TRes call({
    Mutation$ResolveSpotQuestion$resolveSpotQuestion? resolveSpotQuestion,
  });
  CopyWith$Mutation$ResolveSpotQuestion$resolveSpotQuestion<TRes>
  get resolveSpotQuestion;
}

class _CopyWithImpl$Mutation$ResolveSpotQuestion<TRes>
    implements CopyWith$Mutation$ResolveSpotQuestion<TRes> {
  _CopyWithImpl$Mutation$ResolveSpotQuestion(this._instance, this._then);

  final Mutation$ResolveSpotQuestion _instance;

  final TRes Function(Mutation$ResolveSpotQuestion) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? resolveSpotQuestion = _undefined}) => _then(
    Mutation$ResolveSpotQuestion(
      resolveSpotQuestion:
          resolveSpotQuestion == _undefined || resolveSpotQuestion == null
          ? _instance.resolveSpotQuestion
          : (resolveSpotQuestion
                as Mutation$ResolveSpotQuestion$resolveSpotQuestion),
    ),
  );

  CopyWith$Mutation$ResolveSpotQuestion$resolveSpotQuestion<TRes>
  get resolveSpotQuestion {
    final local$resolveSpotQuestion = _instance.resolveSpotQuestion;
    return CopyWith$Mutation$ResolveSpotQuestion$resolveSpotQuestion(
      local$resolveSpotQuestion,
      (e) => call(resolveSpotQuestion: e),
    );
  }
}

class _CopyWithStubImpl$Mutation$ResolveSpotQuestion<TRes>
    implements CopyWith$Mutation$ResolveSpotQuestion<TRes> {
  _CopyWithStubImpl$Mutation$ResolveSpotQuestion(this._res);

  TRes _res;

  call({
    Mutation$ResolveSpotQuestion$resolveSpotQuestion? resolveSpotQuestion,
  }) => _res;

  CopyWith$Mutation$ResolveSpotQuestion$resolveSpotQuestion<TRes>
  get resolveSpotQuestion =>
      CopyWith$Mutation$ResolveSpotQuestion$resolveSpotQuestion.stub(_res);
}

const documentNodeMutationResolveSpotQuestion = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'ResolveSpotQuestion'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'questionId')),
          type: NamedTypeNode(name: NameNode(value: 'ID'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
      ],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'resolveSpotQuestion'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'input'),
                value: ObjectValueNode(
                  fields: [
                    ObjectFieldNode(
                      name: NameNode(value: 'questionId'),
                      value: VariableNode(name: NameNode(value: 'questionId')),
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
                        name: NameNode(value: 'field'),
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

class Mutation$ResolveSpotQuestion$resolveSpotQuestion {
  Mutation$ResolveSpotQuestion$resolveSpotQuestion({
    required this.success,
    required this.userErrors,
  });

  factory Mutation$ResolveSpotQuestion$resolveSpotQuestion.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$success = json['success'];
    final l$userErrors = json['userErrors'];
    return Mutation$ResolveSpotQuestion$resolveSpotQuestion(
      success: (l$success as bool),
      userErrors: (l$userErrors as List<dynamic>)
          .map(
            (e) =>
                Mutation$ResolveSpotQuestion$resolveSpotQuestion$userErrors.fromJson(
                  (e as Map<String, dynamic>),
                ),
          )
          .toList(),
    );
  }

  final bool success;

  final List<Mutation$ResolveSpotQuestion$resolveSpotQuestion$userErrors>
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
    if (other is! Mutation$ResolveSpotQuestion$resolveSpotQuestion ||
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

extension UtilityExtension$Mutation$ResolveSpotQuestion$resolveSpotQuestion
    on Mutation$ResolveSpotQuestion$resolveSpotQuestion {
  CopyWith$Mutation$ResolveSpotQuestion$resolveSpotQuestion<
    Mutation$ResolveSpotQuestion$resolveSpotQuestion
  >
  get copyWith =>
      CopyWith$Mutation$ResolveSpotQuestion$resolveSpotQuestion(this, (i) => i);
}

abstract class CopyWith$Mutation$ResolveSpotQuestion$resolveSpotQuestion<TRes> {
  factory CopyWith$Mutation$ResolveSpotQuestion$resolveSpotQuestion(
    Mutation$ResolveSpotQuestion$resolveSpotQuestion instance,
    TRes Function(Mutation$ResolveSpotQuestion$resolveSpotQuestion) then,
  ) = _CopyWithImpl$Mutation$ResolveSpotQuestion$resolveSpotQuestion;

  factory CopyWith$Mutation$ResolveSpotQuestion$resolveSpotQuestion.stub(
    TRes res,
  ) = _CopyWithStubImpl$Mutation$ResolveSpotQuestion$resolveSpotQuestion;

  TRes call({
    bool? success,
    List<Mutation$ResolveSpotQuestion$resolveSpotQuestion$userErrors>?
    userErrors,
  });
  TRes userErrors(
    Iterable<Mutation$ResolveSpotQuestion$resolveSpotQuestion$userErrors>
    Function(
      Iterable<
        CopyWith$Mutation$ResolveSpotQuestion$resolveSpotQuestion$userErrors<
          Mutation$ResolveSpotQuestion$resolveSpotQuestion$userErrors
        >
      >,
    )
    _fn,
  );
}

class _CopyWithImpl$Mutation$ResolveSpotQuestion$resolveSpotQuestion<TRes>
    implements CopyWith$Mutation$ResolveSpotQuestion$resolveSpotQuestion<TRes> {
  _CopyWithImpl$Mutation$ResolveSpotQuestion$resolveSpotQuestion(
    this._instance,
    this._then,
  );

  final Mutation$ResolveSpotQuestion$resolveSpotQuestion _instance;

  final TRes Function(Mutation$ResolveSpotQuestion$resolveSpotQuestion) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? success = _undefined,
    Object? userErrors = _undefined,
  }) => _then(
    Mutation$ResolveSpotQuestion$resolveSpotQuestion(
      success: success == _undefined || success == null
          ? _instance.success
          : (success as bool),
      userErrors: userErrors == _undefined || userErrors == null
          ? _instance.userErrors
          : (userErrors
                as List<
                  Mutation$ResolveSpotQuestion$resolveSpotQuestion$userErrors
                >),
    ),
  );

  TRes userErrors(
    Iterable<Mutation$ResolveSpotQuestion$resolveSpotQuestion$userErrors>
    Function(
      Iterable<
        CopyWith$Mutation$ResolveSpotQuestion$resolveSpotQuestion$userErrors<
          Mutation$ResolveSpotQuestion$resolveSpotQuestion$userErrors
        >
      >,
    )
    _fn,
  ) => call(
    userErrors: _fn(
      _instance.userErrors.map(
        (e) =>
            CopyWith$Mutation$ResolveSpotQuestion$resolveSpotQuestion$userErrors(
              e,
              (i) => i,
            ),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl$Mutation$ResolveSpotQuestion$resolveSpotQuestion<TRes>
    implements CopyWith$Mutation$ResolveSpotQuestion$resolveSpotQuestion<TRes> {
  _CopyWithStubImpl$Mutation$ResolveSpotQuestion$resolveSpotQuestion(this._res);

  TRes _res;

  call({
    bool? success,
    List<Mutation$ResolveSpotQuestion$resolveSpotQuestion$userErrors>?
    userErrors,
  }) => _res;

  userErrors(_fn) => _res;
}

class Mutation$ResolveSpotQuestion$resolveSpotQuestion$userErrors {
  Mutation$ResolveSpotQuestion$resolveSpotQuestion$userErrors({
    required this.code,
    this.field,
    required this.message,
  });

  factory Mutation$ResolveSpotQuestion$resolveSpotQuestion$userErrors.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$code = json['code'];
    final l$field = json['field'];
    final l$message = json['message'];
    return Mutation$ResolveSpotQuestion$resolveSpotQuestion$userErrors(
      code: (l$code as String),
      field: (l$field as String?),
      message: (l$message as String),
    );
  }

  final String code;

  final String? field;

  final String message;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$code = code;
    _resultData['code'] = l$code;
    final l$field = field;
    _resultData['field'] = l$field;
    final l$message = message;
    _resultData['message'] = l$message;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$code = code;
    final l$field = field;
    final l$message = message;
    return Object.hashAll([l$code, l$field, l$message]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$ResolveSpotQuestion$resolveSpotQuestion$userErrors ||
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
    final l$message = message;
    final lOther$message = other.message;
    if (l$message != lOther$message) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Mutation$ResolveSpotQuestion$resolveSpotQuestion$userErrors
    on Mutation$ResolveSpotQuestion$resolveSpotQuestion$userErrors {
  CopyWith$Mutation$ResolveSpotQuestion$resolveSpotQuestion$userErrors<
    Mutation$ResolveSpotQuestion$resolveSpotQuestion$userErrors
  >
  get copyWith =>
      CopyWith$Mutation$ResolveSpotQuestion$resolveSpotQuestion$userErrors(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Mutation$ResolveSpotQuestion$resolveSpotQuestion$userErrors<
  TRes
> {
  factory CopyWith$Mutation$ResolveSpotQuestion$resolveSpotQuestion$userErrors(
    Mutation$ResolveSpotQuestion$resolveSpotQuestion$userErrors instance,
    TRes Function(Mutation$ResolveSpotQuestion$resolveSpotQuestion$userErrors)
    then,
  ) = _CopyWithImpl$Mutation$ResolveSpotQuestion$resolveSpotQuestion$userErrors;

  factory CopyWith$Mutation$ResolveSpotQuestion$resolveSpotQuestion$userErrors.stub(
    TRes res,
  ) = _CopyWithStubImpl$Mutation$ResolveSpotQuestion$resolveSpotQuestion$userErrors;

  TRes call({String? code, String? field, String? message});
}

class _CopyWithImpl$Mutation$ResolveSpotQuestion$resolveSpotQuestion$userErrors<
  TRes
>
    implements
        CopyWith$Mutation$ResolveSpotQuestion$resolveSpotQuestion$userErrors<
          TRes
        > {
  _CopyWithImpl$Mutation$ResolveSpotQuestion$resolveSpotQuestion$userErrors(
    this._instance,
    this._then,
  );

  final Mutation$ResolveSpotQuestion$resolveSpotQuestion$userErrors _instance;

  final TRes Function(
    Mutation$ResolveSpotQuestion$resolveSpotQuestion$userErrors,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? code = _undefined,
    Object? field = _undefined,
    Object? message = _undefined,
  }) => _then(
    Mutation$ResolveSpotQuestion$resolveSpotQuestion$userErrors(
      code: code == _undefined || code == null
          ? _instance.code
          : (code as String),
      field: field == _undefined ? _instance.field : (field as String?),
      message: message == _undefined || message == null
          ? _instance.message
          : (message as String),
    ),
  );
}

class _CopyWithStubImpl$Mutation$ResolveSpotQuestion$resolveSpotQuestion$userErrors<
  TRes
>
    implements
        CopyWith$Mutation$ResolveSpotQuestion$resolveSpotQuestion$userErrors<
          TRes
        > {
  _CopyWithStubImpl$Mutation$ResolveSpotQuestion$resolveSpotQuestion$userErrors(
    this._res,
  );

  TRes _res;

  call({String? code, String? field, String? message}) => _res;
}

class Variables$Mutation$CreateSpotAnswer {
  factory Variables$Mutation$CreateSpotAnswer({
    required String questionId,
    required String body,
    required List<String> photoKeys,
  }) => Variables$Mutation$CreateSpotAnswer._({
    r'questionId': questionId,
    r'body': body,
    r'photoKeys': photoKeys,
  });

  Variables$Mutation$CreateSpotAnswer._(this._$data);

  factory Variables$Mutation$CreateSpotAnswer.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    final l$questionId = data['questionId'];
    result$data['questionId'] = (l$questionId as String);
    final l$body = data['body'];
    result$data['body'] = (l$body as String);
    final l$photoKeys = data['photoKeys'];
    result$data['photoKeys'] = (l$photoKeys as List<dynamic>)
        .map((e) => (e as String))
        .toList();
    return Variables$Mutation$CreateSpotAnswer._(result$data);
  }

  Map<String, dynamic> _$data;

  String get questionId => (_$data['questionId'] as String);

  String get body => (_$data['body'] as String);

  List<String> get photoKeys => (_$data['photoKeys'] as List<String>);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$questionId = questionId;
    result$data['questionId'] = l$questionId;
    final l$body = body;
    result$data['body'] = l$body;
    final l$photoKeys = photoKeys;
    result$data['photoKeys'] = l$photoKeys.map((e) => e).toList();
    return result$data;
  }

  CopyWith$Variables$Mutation$CreateSpotAnswer<
    Variables$Mutation$CreateSpotAnswer
  >
  get copyWith => CopyWith$Variables$Mutation$CreateSpotAnswer(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Mutation$CreateSpotAnswer ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$questionId = questionId;
    final lOther$questionId = other.questionId;
    if (l$questionId != lOther$questionId) {
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
    final l$questionId = questionId;
    final l$body = body;
    final l$photoKeys = photoKeys;
    return Object.hashAll([
      l$questionId,
      l$body,
      Object.hashAll(l$photoKeys.map((v) => v)),
    ]);
  }
}

abstract class CopyWith$Variables$Mutation$CreateSpotAnswer<TRes> {
  factory CopyWith$Variables$Mutation$CreateSpotAnswer(
    Variables$Mutation$CreateSpotAnswer instance,
    TRes Function(Variables$Mutation$CreateSpotAnswer) then,
  ) = _CopyWithImpl$Variables$Mutation$CreateSpotAnswer;

  factory CopyWith$Variables$Mutation$CreateSpotAnswer.stub(TRes res) =
      _CopyWithStubImpl$Variables$Mutation$CreateSpotAnswer;

  TRes call({String? questionId, String? body, List<String>? photoKeys});
}

class _CopyWithImpl$Variables$Mutation$CreateSpotAnswer<TRes>
    implements CopyWith$Variables$Mutation$CreateSpotAnswer<TRes> {
  _CopyWithImpl$Variables$Mutation$CreateSpotAnswer(this._instance, this._then);

  final Variables$Mutation$CreateSpotAnswer _instance;

  final TRes Function(Variables$Mutation$CreateSpotAnswer) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? questionId = _undefined,
    Object? body = _undefined,
    Object? photoKeys = _undefined,
  }) => _then(
    Variables$Mutation$CreateSpotAnswer._({
      ..._instance._$data,
      if (questionId != _undefined && questionId != null)
        'questionId': (questionId as String),
      if (body != _undefined && body != null) 'body': (body as String),
      if (photoKeys != _undefined && photoKeys != null)
        'photoKeys': (photoKeys as List<String>),
    }),
  );
}

class _CopyWithStubImpl$Variables$Mutation$CreateSpotAnswer<TRes>
    implements CopyWith$Variables$Mutation$CreateSpotAnswer<TRes> {
  _CopyWithStubImpl$Variables$Mutation$CreateSpotAnswer(this._res);

  TRes _res;

  call({String? questionId, String? body, List<String>? photoKeys}) => _res;
}

class Mutation$CreateSpotAnswer {
  Mutation$CreateSpotAnswer({required this.createSpotAnswer});

  factory Mutation$CreateSpotAnswer.fromJson(Map<String, dynamic> json) {
    final l$createSpotAnswer = json['createSpotAnswer'];
    return Mutation$CreateSpotAnswer(
      createSpotAnswer: Mutation$CreateSpotAnswer$createSpotAnswer.fromJson(
        (l$createSpotAnswer as Map<String, dynamic>),
      ),
    );
  }

  final Mutation$CreateSpotAnswer$createSpotAnswer createSpotAnswer;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$createSpotAnswer = createSpotAnswer;
    _resultData['createSpotAnswer'] = l$createSpotAnswer.toJson();
    return _resultData;
  }

  @override
  int get hashCode {
    final l$createSpotAnswer = createSpotAnswer;
    return Object.hashAll([l$createSpotAnswer]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$CreateSpotAnswer ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$createSpotAnswer = createSpotAnswer;
    final lOther$createSpotAnswer = other.createSpotAnswer;
    if (l$createSpotAnswer != lOther$createSpotAnswer) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Mutation$CreateSpotAnswer
    on Mutation$CreateSpotAnswer {
  CopyWith$Mutation$CreateSpotAnswer<Mutation$CreateSpotAnswer> get copyWith =>
      CopyWith$Mutation$CreateSpotAnswer(this, (i) => i);
}

abstract class CopyWith$Mutation$CreateSpotAnswer<TRes> {
  factory CopyWith$Mutation$CreateSpotAnswer(
    Mutation$CreateSpotAnswer instance,
    TRes Function(Mutation$CreateSpotAnswer) then,
  ) = _CopyWithImpl$Mutation$CreateSpotAnswer;

  factory CopyWith$Mutation$CreateSpotAnswer.stub(TRes res) =
      _CopyWithStubImpl$Mutation$CreateSpotAnswer;

  TRes call({Mutation$CreateSpotAnswer$createSpotAnswer? createSpotAnswer});
  CopyWith$Mutation$CreateSpotAnswer$createSpotAnswer<TRes>
  get createSpotAnswer;
}

class _CopyWithImpl$Mutation$CreateSpotAnswer<TRes>
    implements CopyWith$Mutation$CreateSpotAnswer<TRes> {
  _CopyWithImpl$Mutation$CreateSpotAnswer(this._instance, this._then);

  final Mutation$CreateSpotAnswer _instance;

  final TRes Function(Mutation$CreateSpotAnswer) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? createSpotAnswer = _undefined}) => _then(
    Mutation$CreateSpotAnswer(
      createSpotAnswer:
          createSpotAnswer == _undefined || createSpotAnswer == null
          ? _instance.createSpotAnswer
          : (createSpotAnswer as Mutation$CreateSpotAnswer$createSpotAnswer),
    ),
  );

  CopyWith$Mutation$CreateSpotAnswer$createSpotAnswer<TRes>
  get createSpotAnswer {
    final local$createSpotAnswer = _instance.createSpotAnswer;
    return CopyWith$Mutation$CreateSpotAnswer$createSpotAnswer(
      local$createSpotAnswer,
      (e) => call(createSpotAnswer: e),
    );
  }
}

class _CopyWithStubImpl$Mutation$CreateSpotAnswer<TRes>
    implements CopyWith$Mutation$CreateSpotAnswer<TRes> {
  _CopyWithStubImpl$Mutation$CreateSpotAnswer(this._res);

  TRes _res;

  call({Mutation$CreateSpotAnswer$createSpotAnswer? createSpotAnswer}) => _res;

  CopyWith$Mutation$CreateSpotAnswer$createSpotAnswer<TRes>
  get createSpotAnswer =>
      CopyWith$Mutation$CreateSpotAnswer$createSpotAnswer.stub(_res);
}

const documentNodeMutationCreateSpotAnswer = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'CreateSpotAnswer'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'questionId')),
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
            name: NameNode(value: 'createSpotAnswer'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'input'),
                value: ObjectValueNode(
                  fields: [
                    ObjectFieldNode(
                      name: NameNode(value: 'questionId'),
                      value: VariableNode(name: NameNode(value: 'questionId')),
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
                        name: NameNode(value: 'field'),
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
                    ],
                  ),
                ),
                FieldNode(
                  name: NameNode(value: 'answerId'),
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

class Mutation$CreateSpotAnswer$createSpotAnswer {
  Mutation$CreateSpotAnswer$createSpotAnswer({
    required this.success,
    required this.userErrors,
    this.answerId,
  });

  factory Mutation$CreateSpotAnswer$createSpotAnswer.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$success = json['success'];
    final l$userErrors = json['userErrors'];
    final l$answerId = json['answerId'];
    return Mutation$CreateSpotAnswer$createSpotAnswer(
      success: (l$success as bool),
      userErrors: (l$userErrors as List<dynamic>)
          .map(
            (e) =>
                Mutation$CreateSpotAnswer$createSpotAnswer$userErrors.fromJson(
                  (e as Map<String, dynamic>),
                ),
          )
          .toList(),
      answerId: (l$answerId as String?),
    );
  }

  final bool success;

  final List<Mutation$CreateSpotAnswer$createSpotAnswer$userErrors> userErrors;

  final String? answerId;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$success = success;
    _resultData['success'] = l$success;
    final l$userErrors = userErrors;
    _resultData['userErrors'] = l$userErrors.map((e) => e.toJson()).toList();
    final l$answerId = answerId;
    _resultData['answerId'] = l$answerId;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$success = success;
    final l$userErrors = userErrors;
    final l$answerId = answerId;
    return Object.hashAll([
      l$success,
      Object.hashAll(l$userErrors.map((v) => v)),
      l$answerId,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$CreateSpotAnswer$createSpotAnswer ||
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
    final l$answerId = answerId;
    final lOther$answerId = other.answerId;
    if (l$answerId != lOther$answerId) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Mutation$CreateSpotAnswer$createSpotAnswer
    on Mutation$CreateSpotAnswer$createSpotAnswer {
  CopyWith$Mutation$CreateSpotAnswer$createSpotAnswer<
    Mutation$CreateSpotAnswer$createSpotAnswer
  >
  get copyWith =>
      CopyWith$Mutation$CreateSpotAnswer$createSpotAnswer(this, (i) => i);
}

abstract class CopyWith$Mutation$CreateSpotAnswer$createSpotAnswer<TRes> {
  factory CopyWith$Mutation$CreateSpotAnswer$createSpotAnswer(
    Mutation$CreateSpotAnswer$createSpotAnswer instance,
    TRes Function(Mutation$CreateSpotAnswer$createSpotAnswer) then,
  ) = _CopyWithImpl$Mutation$CreateSpotAnswer$createSpotAnswer;

  factory CopyWith$Mutation$CreateSpotAnswer$createSpotAnswer.stub(TRes res) =
      _CopyWithStubImpl$Mutation$CreateSpotAnswer$createSpotAnswer;

  TRes call({
    bool? success,
    List<Mutation$CreateSpotAnswer$createSpotAnswer$userErrors>? userErrors,
    String? answerId,
  });
  TRes userErrors(
    Iterable<Mutation$CreateSpotAnswer$createSpotAnswer$userErrors> Function(
      Iterable<
        CopyWith$Mutation$CreateSpotAnswer$createSpotAnswer$userErrors<
          Mutation$CreateSpotAnswer$createSpotAnswer$userErrors
        >
      >,
    )
    _fn,
  );
}

class _CopyWithImpl$Mutation$CreateSpotAnswer$createSpotAnswer<TRes>
    implements CopyWith$Mutation$CreateSpotAnswer$createSpotAnswer<TRes> {
  _CopyWithImpl$Mutation$CreateSpotAnswer$createSpotAnswer(
    this._instance,
    this._then,
  );

  final Mutation$CreateSpotAnswer$createSpotAnswer _instance;

  final TRes Function(Mutation$CreateSpotAnswer$createSpotAnswer) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? success = _undefined,
    Object? userErrors = _undefined,
    Object? answerId = _undefined,
  }) => _then(
    Mutation$CreateSpotAnswer$createSpotAnswer(
      success: success == _undefined || success == null
          ? _instance.success
          : (success as bool),
      userErrors: userErrors == _undefined || userErrors == null
          ? _instance.userErrors
          : (userErrors
                as List<Mutation$CreateSpotAnswer$createSpotAnswer$userErrors>),
      answerId: answerId == _undefined
          ? _instance.answerId
          : (answerId as String?),
    ),
  );

  TRes userErrors(
    Iterable<Mutation$CreateSpotAnswer$createSpotAnswer$userErrors> Function(
      Iterable<
        CopyWith$Mutation$CreateSpotAnswer$createSpotAnswer$userErrors<
          Mutation$CreateSpotAnswer$createSpotAnswer$userErrors
        >
      >,
    )
    _fn,
  ) => call(
    userErrors: _fn(
      _instance.userErrors.map(
        (e) => CopyWith$Mutation$CreateSpotAnswer$createSpotAnswer$userErrors(
          e,
          (i) => i,
        ),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl$Mutation$CreateSpotAnswer$createSpotAnswer<TRes>
    implements CopyWith$Mutation$CreateSpotAnswer$createSpotAnswer<TRes> {
  _CopyWithStubImpl$Mutation$CreateSpotAnswer$createSpotAnswer(this._res);

  TRes _res;

  call({
    bool? success,
    List<Mutation$CreateSpotAnswer$createSpotAnswer$userErrors>? userErrors,
    String? answerId,
  }) => _res;

  userErrors(_fn) => _res;
}

class Mutation$CreateSpotAnswer$createSpotAnswer$userErrors {
  Mutation$CreateSpotAnswer$createSpotAnswer$userErrors({
    required this.code,
    this.field,
    required this.message,
  });

  factory Mutation$CreateSpotAnswer$createSpotAnswer$userErrors.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$code = json['code'];
    final l$field = json['field'];
    final l$message = json['message'];
    return Mutation$CreateSpotAnswer$createSpotAnswer$userErrors(
      code: (l$code as String),
      field: (l$field as String?),
      message: (l$message as String),
    );
  }

  final String code;

  final String? field;

  final String message;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$code = code;
    _resultData['code'] = l$code;
    final l$field = field;
    _resultData['field'] = l$field;
    final l$message = message;
    _resultData['message'] = l$message;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$code = code;
    final l$field = field;
    final l$message = message;
    return Object.hashAll([l$code, l$field, l$message]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$CreateSpotAnswer$createSpotAnswer$userErrors ||
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
    final l$message = message;
    final lOther$message = other.message;
    if (l$message != lOther$message) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Mutation$CreateSpotAnswer$createSpotAnswer$userErrors
    on Mutation$CreateSpotAnswer$createSpotAnswer$userErrors {
  CopyWith$Mutation$CreateSpotAnswer$createSpotAnswer$userErrors<
    Mutation$CreateSpotAnswer$createSpotAnswer$userErrors
  >
  get copyWith =>
      CopyWith$Mutation$CreateSpotAnswer$createSpotAnswer$userErrors(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Mutation$CreateSpotAnswer$createSpotAnswer$userErrors<
  TRes
> {
  factory CopyWith$Mutation$CreateSpotAnswer$createSpotAnswer$userErrors(
    Mutation$CreateSpotAnswer$createSpotAnswer$userErrors instance,
    TRes Function(Mutation$CreateSpotAnswer$createSpotAnswer$userErrors) then,
  ) = _CopyWithImpl$Mutation$CreateSpotAnswer$createSpotAnswer$userErrors;

  factory CopyWith$Mutation$CreateSpotAnswer$createSpotAnswer$userErrors.stub(
    TRes res,
  ) = _CopyWithStubImpl$Mutation$CreateSpotAnswer$createSpotAnswer$userErrors;

  TRes call({String? code, String? field, String? message});
}

class _CopyWithImpl$Mutation$CreateSpotAnswer$createSpotAnswer$userErrors<TRes>
    implements
        CopyWith$Mutation$CreateSpotAnswer$createSpotAnswer$userErrors<TRes> {
  _CopyWithImpl$Mutation$CreateSpotAnswer$createSpotAnswer$userErrors(
    this._instance,
    this._then,
  );

  final Mutation$CreateSpotAnswer$createSpotAnswer$userErrors _instance;

  final TRes Function(Mutation$CreateSpotAnswer$createSpotAnswer$userErrors)
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? code = _undefined,
    Object? field = _undefined,
    Object? message = _undefined,
  }) => _then(
    Mutation$CreateSpotAnswer$createSpotAnswer$userErrors(
      code: code == _undefined || code == null
          ? _instance.code
          : (code as String),
      field: field == _undefined ? _instance.field : (field as String?),
      message: message == _undefined || message == null
          ? _instance.message
          : (message as String),
    ),
  );
}

class _CopyWithStubImpl$Mutation$CreateSpotAnswer$createSpotAnswer$userErrors<
  TRes
>
    implements
        CopyWith$Mutation$CreateSpotAnswer$createSpotAnswer$userErrors<TRes> {
  _CopyWithStubImpl$Mutation$CreateSpotAnswer$createSpotAnswer$userErrors(
    this._res,
  );

  TRes _res;

  call({String? code, String? field, String? message}) => _res;
}

class Variables$Mutation$DeleteSpotAnswer {
  factory Variables$Mutation$DeleteSpotAnswer({required String answerId}) =>
      Variables$Mutation$DeleteSpotAnswer._({r'answerId': answerId});

  Variables$Mutation$DeleteSpotAnswer._(this._$data);

  factory Variables$Mutation$DeleteSpotAnswer.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    final l$answerId = data['answerId'];
    result$data['answerId'] = (l$answerId as String);
    return Variables$Mutation$DeleteSpotAnswer._(result$data);
  }

  Map<String, dynamic> _$data;

  String get answerId => (_$data['answerId'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$answerId = answerId;
    result$data['answerId'] = l$answerId;
    return result$data;
  }

  CopyWith$Variables$Mutation$DeleteSpotAnswer<
    Variables$Mutation$DeleteSpotAnswer
  >
  get copyWith => CopyWith$Variables$Mutation$DeleteSpotAnswer(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Mutation$DeleteSpotAnswer ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$answerId = answerId;
    final lOther$answerId = other.answerId;
    if (l$answerId != lOther$answerId) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$answerId = answerId;
    return Object.hashAll([l$answerId]);
  }
}

abstract class CopyWith$Variables$Mutation$DeleteSpotAnswer<TRes> {
  factory CopyWith$Variables$Mutation$DeleteSpotAnswer(
    Variables$Mutation$DeleteSpotAnswer instance,
    TRes Function(Variables$Mutation$DeleteSpotAnswer) then,
  ) = _CopyWithImpl$Variables$Mutation$DeleteSpotAnswer;

  factory CopyWith$Variables$Mutation$DeleteSpotAnswer.stub(TRes res) =
      _CopyWithStubImpl$Variables$Mutation$DeleteSpotAnswer;

  TRes call({String? answerId});
}

class _CopyWithImpl$Variables$Mutation$DeleteSpotAnswer<TRes>
    implements CopyWith$Variables$Mutation$DeleteSpotAnswer<TRes> {
  _CopyWithImpl$Variables$Mutation$DeleteSpotAnswer(this._instance, this._then);

  final Variables$Mutation$DeleteSpotAnswer _instance;

  final TRes Function(Variables$Mutation$DeleteSpotAnswer) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? answerId = _undefined}) => _then(
    Variables$Mutation$DeleteSpotAnswer._({
      ..._instance._$data,
      if (answerId != _undefined && answerId != null)
        'answerId': (answerId as String),
    }),
  );
}

class _CopyWithStubImpl$Variables$Mutation$DeleteSpotAnswer<TRes>
    implements CopyWith$Variables$Mutation$DeleteSpotAnswer<TRes> {
  _CopyWithStubImpl$Variables$Mutation$DeleteSpotAnswer(this._res);

  TRes _res;

  call({String? answerId}) => _res;
}

class Mutation$DeleteSpotAnswer {
  Mutation$DeleteSpotAnswer({required this.deleteSpotAnswer});

  factory Mutation$DeleteSpotAnswer.fromJson(Map<String, dynamic> json) {
    final l$deleteSpotAnswer = json['deleteSpotAnswer'];
    return Mutation$DeleteSpotAnswer(
      deleteSpotAnswer: Mutation$DeleteSpotAnswer$deleteSpotAnswer.fromJson(
        (l$deleteSpotAnswer as Map<String, dynamic>),
      ),
    );
  }

  final Mutation$DeleteSpotAnswer$deleteSpotAnswer deleteSpotAnswer;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$deleteSpotAnswer = deleteSpotAnswer;
    _resultData['deleteSpotAnswer'] = l$deleteSpotAnswer.toJson();
    return _resultData;
  }

  @override
  int get hashCode {
    final l$deleteSpotAnswer = deleteSpotAnswer;
    return Object.hashAll([l$deleteSpotAnswer]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$DeleteSpotAnswer ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$deleteSpotAnswer = deleteSpotAnswer;
    final lOther$deleteSpotAnswer = other.deleteSpotAnswer;
    if (l$deleteSpotAnswer != lOther$deleteSpotAnswer) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Mutation$DeleteSpotAnswer
    on Mutation$DeleteSpotAnswer {
  CopyWith$Mutation$DeleteSpotAnswer<Mutation$DeleteSpotAnswer> get copyWith =>
      CopyWith$Mutation$DeleteSpotAnswer(this, (i) => i);
}

abstract class CopyWith$Mutation$DeleteSpotAnswer<TRes> {
  factory CopyWith$Mutation$DeleteSpotAnswer(
    Mutation$DeleteSpotAnswer instance,
    TRes Function(Mutation$DeleteSpotAnswer) then,
  ) = _CopyWithImpl$Mutation$DeleteSpotAnswer;

  factory CopyWith$Mutation$DeleteSpotAnswer.stub(TRes res) =
      _CopyWithStubImpl$Mutation$DeleteSpotAnswer;

  TRes call({Mutation$DeleteSpotAnswer$deleteSpotAnswer? deleteSpotAnswer});
  CopyWith$Mutation$DeleteSpotAnswer$deleteSpotAnswer<TRes>
  get deleteSpotAnswer;
}

class _CopyWithImpl$Mutation$DeleteSpotAnswer<TRes>
    implements CopyWith$Mutation$DeleteSpotAnswer<TRes> {
  _CopyWithImpl$Mutation$DeleteSpotAnswer(this._instance, this._then);

  final Mutation$DeleteSpotAnswer _instance;

  final TRes Function(Mutation$DeleteSpotAnswer) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? deleteSpotAnswer = _undefined}) => _then(
    Mutation$DeleteSpotAnswer(
      deleteSpotAnswer:
          deleteSpotAnswer == _undefined || deleteSpotAnswer == null
          ? _instance.deleteSpotAnswer
          : (deleteSpotAnswer as Mutation$DeleteSpotAnswer$deleteSpotAnswer),
    ),
  );

  CopyWith$Mutation$DeleteSpotAnswer$deleteSpotAnswer<TRes>
  get deleteSpotAnswer {
    final local$deleteSpotAnswer = _instance.deleteSpotAnswer;
    return CopyWith$Mutation$DeleteSpotAnswer$deleteSpotAnswer(
      local$deleteSpotAnswer,
      (e) => call(deleteSpotAnswer: e),
    );
  }
}

class _CopyWithStubImpl$Mutation$DeleteSpotAnswer<TRes>
    implements CopyWith$Mutation$DeleteSpotAnswer<TRes> {
  _CopyWithStubImpl$Mutation$DeleteSpotAnswer(this._res);

  TRes _res;

  call({Mutation$DeleteSpotAnswer$deleteSpotAnswer? deleteSpotAnswer}) => _res;

  CopyWith$Mutation$DeleteSpotAnswer$deleteSpotAnswer<TRes>
  get deleteSpotAnswer =>
      CopyWith$Mutation$DeleteSpotAnswer$deleteSpotAnswer.stub(_res);
}

const documentNodeMutationDeleteSpotAnswer = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'DeleteSpotAnswer'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'answerId')),
          type: NamedTypeNode(name: NameNode(value: 'ID'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
      ],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'deleteSpotAnswer'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'input'),
                value: ObjectValueNode(
                  fields: [
                    ObjectFieldNode(
                      name: NameNode(value: 'answerId'),
                      value: VariableNode(name: NameNode(value: 'answerId')),
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
                        name: NameNode(value: 'field'),
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

class Mutation$DeleteSpotAnswer$deleteSpotAnswer {
  Mutation$DeleteSpotAnswer$deleteSpotAnswer({
    required this.success,
    required this.userErrors,
  });

  factory Mutation$DeleteSpotAnswer$deleteSpotAnswer.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$success = json['success'];
    final l$userErrors = json['userErrors'];
    return Mutation$DeleteSpotAnswer$deleteSpotAnswer(
      success: (l$success as bool),
      userErrors: (l$userErrors as List<dynamic>)
          .map(
            (e) =>
                Mutation$DeleteSpotAnswer$deleteSpotAnswer$userErrors.fromJson(
                  (e as Map<String, dynamic>),
                ),
          )
          .toList(),
    );
  }

  final bool success;

  final List<Mutation$DeleteSpotAnswer$deleteSpotAnswer$userErrors> userErrors;

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
    if (other is! Mutation$DeleteSpotAnswer$deleteSpotAnswer ||
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

extension UtilityExtension$Mutation$DeleteSpotAnswer$deleteSpotAnswer
    on Mutation$DeleteSpotAnswer$deleteSpotAnswer {
  CopyWith$Mutation$DeleteSpotAnswer$deleteSpotAnswer<
    Mutation$DeleteSpotAnswer$deleteSpotAnswer
  >
  get copyWith =>
      CopyWith$Mutation$DeleteSpotAnswer$deleteSpotAnswer(this, (i) => i);
}

abstract class CopyWith$Mutation$DeleteSpotAnswer$deleteSpotAnswer<TRes> {
  factory CopyWith$Mutation$DeleteSpotAnswer$deleteSpotAnswer(
    Mutation$DeleteSpotAnswer$deleteSpotAnswer instance,
    TRes Function(Mutation$DeleteSpotAnswer$deleteSpotAnswer) then,
  ) = _CopyWithImpl$Mutation$DeleteSpotAnswer$deleteSpotAnswer;

  factory CopyWith$Mutation$DeleteSpotAnswer$deleteSpotAnswer.stub(TRes res) =
      _CopyWithStubImpl$Mutation$DeleteSpotAnswer$deleteSpotAnswer;

  TRes call({
    bool? success,
    List<Mutation$DeleteSpotAnswer$deleteSpotAnswer$userErrors>? userErrors,
  });
  TRes userErrors(
    Iterable<Mutation$DeleteSpotAnswer$deleteSpotAnswer$userErrors> Function(
      Iterable<
        CopyWith$Mutation$DeleteSpotAnswer$deleteSpotAnswer$userErrors<
          Mutation$DeleteSpotAnswer$deleteSpotAnswer$userErrors
        >
      >,
    )
    _fn,
  );
}

class _CopyWithImpl$Mutation$DeleteSpotAnswer$deleteSpotAnswer<TRes>
    implements CopyWith$Mutation$DeleteSpotAnswer$deleteSpotAnswer<TRes> {
  _CopyWithImpl$Mutation$DeleteSpotAnswer$deleteSpotAnswer(
    this._instance,
    this._then,
  );

  final Mutation$DeleteSpotAnswer$deleteSpotAnswer _instance;

  final TRes Function(Mutation$DeleteSpotAnswer$deleteSpotAnswer) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? success = _undefined,
    Object? userErrors = _undefined,
  }) => _then(
    Mutation$DeleteSpotAnswer$deleteSpotAnswer(
      success: success == _undefined || success == null
          ? _instance.success
          : (success as bool),
      userErrors: userErrors == _undefined || userErrors == null
          ? _instance.userErrors
          : (userErrors
                as List<Mutation$DeleteSpotAnswer$deleteSpotAnswer$userErrors>),
    ),
  );

  TRes userErrors(
    Iterable<Mutation$DeleteSpotAnswer$deleteSpotAnswer$userErrors> Function(
      Iterable<
        CopyWith$Mutation$DeleteSpotAnswer$deleteSpotAnswer$userErrors<
          Mutation$DeleteSpotAnswer$deleteSpotAnswer$userErrors
        >
      >,
    )
    _fn,
  ) => call(
    userErrors: _fn(
      _instance.userErrors.map(
        (e) => CopyWith$Mutation$DeleteSpotAnswer$deleteSpotAnswer$userErrors(
          e,
          (i) => i,
        ),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl$Mutation$DeleteSpotAnswer$deleteSpotAnswer<TRes>
    implements CopyWith$Mutation$DeleteSpotAnswer$deleteSpotAnswer<TRes> {
  _CopyWithStubImpl$Mutation$DeleteSpotAnswer$deleteSpotAnswer(this._res);

  TRes _res;

  call({
    bool? success,
    List<Mutation$DeleteSpotAnswer$deleteSpotAnswer$userErrors>? userErrors,
  }) => _res;

  userErrors(_fn) => _res;
}

class Mutation$DeleteSpotAnswer$deleteSpotAnswer$userErrors {
  Mutation$DeleteSpotAnswer$deleteSpotAnswer$userErrors({
    required this.code,
    this.field,
    required this.message,
  });

  factory Mutation$DeleteSpotAnswer$deleteSpotAnswer$userErrors.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$code = json['code'];
    final l$field = json['field'];
    final l$message = json['message'];
    return Mutation$DeleteSpotAnswer$deleteSpotAnswer$userErrors(
      code: (l$code as String),
      field: (l$field as String?),
      message: (l$message as String),
    );
  }

  final String code;

  final String? field;

  final String message;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$code = code;
    _resultData['code'] = l$code;
    final l$field = field;
    _resultData['field'] = l$field;
    final l$message = message;
    _resultData['message'] = l$message;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$code = code;
    final l$field = field;
    final l$message = message;
    return Object.hashAll([l$code, l$field, l$message]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$DeleteSpotAnswer$deleteSpotAnswer$userErrors ||
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
    final l$message = message;
    final lOther$message = other.message;
    if (l$message != lOther$message) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Mutation$DeleteSpotAnswer$deleteSpotAnswer$userErrors
    on Mutation$DeleteSpotAnswer$deleteSpotAnswer$userErrors {
  CopyWith$Mutation$DeleteSpotAnswer$deleteSpotAnswer$userErrors<
    Mutation$DeleteSpotAnswer$deleteSpotAnswer$userErrors
  >
  get copyWith =>
      CopyWith$Mutation$DeleteSpotAnswer$deleteSpotAnswer$userErrors(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Mutation$DeleteSpotAnswer$deleteSpotAnswer$userErrors<
  TRes
> {
  factory CopyWith$Mutation$DeleteSpotAnswer$deleteSpotAnswer$userErrors(
    Mutation$DeleteSpotAnswer$deleteSpotAnswer$userErrors instance,
    TRes Function(Mutation$DeleteSpotAnswer$deleteSpotAnswer$userErrors) then,
  ) = _CopyWithImpl$Mutation$DeleteSpotAnswer$deleteSpotAnswer$userErrors;

  factory CopyWith$Mutation$DeleteSpotAnswer$deleteSpotAnswer$userErrors.stub(
    TRes res,
  ) = _CopyWithStubImpl$Mutation$DeleteSpotAnswer$deleteSpotAnswer$userErrors;

  TRes call({String? code, String? field, String? message});
}

class _CopyWithImpl$Mutation$DeleteSpotAnswer$deleteSpotAnswer$userErrors<TRes>
    implements
        CopyWith$Mutation$DeleteSpotAnswer$deleteSpotAnswer$userErrors<TRes> {
  _CopyWithImpl$Mutation$DeleteSpotAnswer$deleteSpotAnswer$userErrors(
    this._instance,
    this._then,
  );

  final Mutation$DeleteSpotAnswer$deleteSpotAnswer$userErrors _instance;

  final TRes Function(Mutation$DeleteSpotAnswer$deleteSpotAnswer$userErrors)
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? code = _undefined,
    Object? field = _undefined,
    Object? message = _undefined,
  }) => _then(
    Mutation$DeleteSpotAnswer$deleteSpotAnswer$userErrors(
      code: code == _undefined || code == null
          ? _instance.code
          : (code as String),
      field: field == _undefined ? _instance.field : (field as String?),
      message: message == _undefined || message == null
          ? _instance.message
          : (message as String),
    ),
  );
}

class _CopyWithStubImpl$Mutation$DeleteSpotAnswer$deleteSpotAnswer$userErrors<
  TRes
>
    implements
        CopyWith$Mutation$DeleteSpotAnswer$deleteSpotAnswer$userErrors<TRes> {
  _CopyWithStubImpl$Mutation$DeleteSpotAnswer$deleteSpotAnswer$userErrors(
    this._res,
  );

  TRes _res;

  call({String? code, String? field, String? message}) => _res;
}

class Variables$Mutation$CreateSpotAnswerReply {
  factory Variables$Mutation$CreateSpotAnswerReply({
    required String parentAnswerId,
    required String body,
    required List<String> photoKeys,
  }) => Variables$Mutation$CreateSpotAnswerReply._({
    r'parentAnswerId': parentAnswerId,
    r'body': body,
    r'photoKeys': photoKeys,
  });

  Variables$Mutation$CreateSpotAnswerReply._(this._$data);

  factory Variables$Mutation$CreateSpotAnswerReply.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    final l$parentAnswerId = data['parentAnswerId'];
    result$data['parentAnswerId'] = (l$parentAnswerId as String);
    final l$body = data['body'];
    result$data['body'] = (l$body as String);
    final l$photoKeys = data['photoKeys'];
    result$data['photoKeys'] = (l$photoKeys as List<dynamic>)
        .map((e) => (e as String))
        .toList();
    return Variables$Mutation$CreateSpotAnswerReply._(result$data);
  }

  Map<String, dynamic> _$data;

  String get parentAnswerId => (_$data['parentAnswerId'] as String);

  String get body => (_$data['body'] as String);

  List<String> get photoKeys => (_$data['photoKeys'] as List<String>);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$parentAnswerId = parentAnswerId;
    result$data['parentAnswerId'] = l$parentAnswerId;
    final l$body = body;
    result$data['body'] = l$body;
    final l$photoKeys = photoKeys;
    result$data['photoKeys'] = l$photoKeys.map((e) => e).toList();
    return result$data;
  }

  CopyWith$Variables$Mutation$CreateSpotAnswerReply<
    Variables$Mutation$CreateSpotAnswerReply
  >
  get copyWith =>
      CopyWith$Variables$Mutation$CreateSpotAnswerReply(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Mutation$CreateSpotAnswerReply ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$parentAnswerId = parentAnswerId;
    final lOther$parentAnswerId = other.parentAnswerId;
    if (l$parentAnswerId != lOther$parentAnswerId) {
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
    final l$parentAnswerId = parentAnswerId;
    final l$body = body;
    final l$photoKeys = photoKeys;
    return Object.hashAll([
      l$parentAnswerId,
      l$body,
      Object.hashAll(l$photoKeys.map((v) => v)),
    ]);
  }
}

abstract class CopyWith$Variables$Mutation$CreateSpotAnswerReply<TRes> {
  factory CopyWith$Variables$Mutation$CreateSpotAnswerReply(
    Variables$Mutation$CreateSpotAnswerReply instance,
    TRes Function(Variables$Mutation$CreateSpotAnswerReply) then,
  ) = _CopyWithImpl$Variables$Mutation$CreateSpotAnswerReply;

  factory CopyWith$Variables$Mutation$CreateSpotAnswerReply.stub(TRes res) =
      _CopyWithStubImpl$Variables$Mutation$CreateSpotAnswerReply;

  TRes call({String? parentAnswerId, String? body, List<String>? photoKeys});
}

class _CopyWithImpl$Variables$Mutation$CreateSpotAnswerReply<TRes>
    implements CopyWith$Variables$Mutation$CreateSpotAnswerReply<TRes> {
  _CopyWithImpl$Variables$Mutation$CreateSpotAnswerReply(
    this._instance,
    this._then,
  );

  final Variables$Mutation$CreateSpotAnswerReply _instance;

  final TRes Function(Variables$Mutation$CreateSpotAnswerReply) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? parentAnswerId = _undefined,
    Object? body = _undefined,
    Object? photoKeys = _undefined,
  }) => _then(
    Variables$Mutation$CreateSpotAnswerReply._({
      ..._instance._$data,
      if (parentAnswerId != _undefined && parentAnswerId != null)
        'parentAnswerId': (parentAnswerId as String),
      if (body != _undefined && body != null) 'body': (body as String),
      if (photoKeys != _undefined && photoKeys != null)
        'photoKeys': (photoKeys as List<String>),
    }),
  );
}

class _CopyWithStubImpl$Variables$Mutation$CreateSpotAnswerReply<TRes>
    implements CopyWith$Variables$Mutation$CreateSpotAnswerReply<TRes> {
  _CopyWithStubImpl$Variables$Mutation$CreateSpotAnswerReply(this._res);

  TRes _res;

  call({String? parentAnswerId, String? body, List<String>? photoKeys}) => _res;
}

class Mutation$CreateSpotAnswerReply {
  Mutation$CreateSpotAnswerReply({required this.createSpotAnswerReply});

  factory Mutation$CreateSpotAnswerReply.fromJson(Map<String, dynamic> json) {
    final l$createSpotAnswerReply = json['createSpotAnswerReply'];
    return Mutation$CreateSpotAnswerReply(
      createSpotAnswerReply:
          Mutation$CreateSpotAnswerReply$createSpotAnswerReply.fromJson(
            (l$createSpotAnswerReply as Map<String, dynamic>),
          ),
    );
  }

  final Mutation$CreateSpotAnswerReply$createSpotAnswerReply
  createSpotAnswerReply;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$createSpotAnswerReply = createSpotAnswerReply;
    _resultData['createSpotAnswerReply'] = l$createSpotAnswerReply.toJson();
    return _resultData;
  }

  @override
  int get hashCode {
    final l$createSpotAnswerReply = createSpotAnswerReply;
    return Object.hashAll([l$createSpotAnswerReply]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$CreateSpotAnswerReply ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$createSpotAnswerReply = createSpotAnswerReply;
    final lOther$createSpotAnswerReply = other.createSpotAnswerReply;
    if (l$createSpotAnswerReply != lOther$createSpotAnswerReply) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Mutation$CreateSpotAnswerReply
    on Mutation$CreateSpotAnswerReply {
  CopyWith$Mutation$CreateSpotAnswerReply<Mutation$CreateSpotAnswerReply>
  get copyWith => CopyWith$Mutation$CreateSpotAnswerReply(this, (i) => i);
}

abstract class CopyWith$Mutation$CreateSpotAnswerReply<TRes> {
  factory CopyWith$Mutation$CreateSpotAnswerReply(
    Mutation$CreateSpotAnswerReply instance,
    TRes Function(Mutation$CreateSpotAnswerReply) then,
  ) = _CopyWithImpl$Mutation$CreateSpotAnswerReply;

  factory CopyWith$Mutation$CreateSpotAnswerReply.stub(TRes res) =
      _CopyWithStubImpl$Mutation$CreateSpotAnswerReply;

  TRes call({
    Mutation$CreateSpotAnswerReply$createSpotAnswerReply? createSpotAnswerReply,
  });
  CopyWith$Mutation$CreateSpotAnswerReply$createSpotAnswerReply<TRes>
  get createSpotAnswerReply;
}

class _CopyWithImpl$Mutation$CreateSpotAnswerReply<TRes>
    implements CopyWith$Mutation$CreateSpotAnswerReply<TRes> {
  _CopyWithImpl$Mutation$CreateSpotAnswerReply(this._instance, this._then);

  final Mutation$CreateSpotAnswerReply _instance;

  final TRes Function(Mutation$CreateSpotAnswerReply) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? createSpotAnswerReply = _undefined}) => _then(
    Mutation$CreateSpotAnswerReply(
      createSpotAnswerReply:
          createSpotAnswerReply == _undefined || createSpotAnswerReply == null
          ? _instance.createSpotAnswerReply
          : (createSpotAnswerReply
                as Mutation$CreateSpotAnswerReply$createSpotAnswerReply),
    ),
  );

  CopyWith$Mutation$CreateSpotAnswerReply$createSpotAnswerReply<TRes>
  get createSpotAnswerReply {
    final local$createSpotAnswerReply = _instance.createSpotAnswerReply;
    return CopyWith$Mutation$CreateSpotAnswerReply$createSpotAnswerReply(
      local$createSpotAnswerReply,
      (e) => call(createSpotAnswerReply: e),
    );
  }
}

class _CopyWithStubImpl$Mutation$CreateSpotAnswerReply<TRes>
    implements CopyWith$Mutation$CreateSpotAnswerReply<TRes> {
  _CopyWithStubImpl$Mutation$CreateSpotAnswerReply(this._res);

  TRes _res;

  call({
    Mutation$CreateSpotAnswerReply$createSpotAnswerReply? createSpotAnswerReply,
  }) => _res;

  CopyWith$Mutation$CreateSpotAnswerReply$createSpotAnswerReply<TRes>
  get createSpotAnswerReply =>
      CopyWith$Mutation$CreateSpotAnswerReply$createSpotAnswerReply.stub(_res);
}

const documentNodeMutationCreateSpotAnswerReply = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'CreateSpotAnswerReply'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'parentAnswerId')),
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
            name: NameNode(value: 'createSpotAnswerReply'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'input'),
                value: ObjectValueNode(
                  fields: [
                    ObjectFieldNode(
                      name: NameNode(value: 'parentAnswerId'),
                      value: VariableNode(
                        name: NameNode(value: 'parentAnswerId'),
                      ),
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
                        name: NameNode(value: 'field'),
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
                    ],
                  ),
                ),
                FieldNode(
                  name: NameNode(value: 'replyId'),
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

class Mutation$CreateSpotAnswerReply$createSpotAnswerReply {
  Mutation$CreateSpotAnswerReply$createSpotAnswerReply({
    required this.success,
    required this.userErrors,
    this.replyId,
  });

  factory Mutation$CreateSpotAnswerReply$createSpotAnswerReply.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$success = json['success'];
    final l$userErrors = json['userErrors'];
    final l$replyId = json['replyId'];
    return Mutation$CreateSpotAnswerReply$createSpotAnswerReply(
      success: (l$success as bool),
      userErrors: (l$userErrors as List<dynamic>)
          .map(
            (e) =>
                Mutation$CreateSpotAnswerReply$createSpotAnswerReply$userErrors.fromJson(
                  (e as Map<String, dynamic>),
                ),
          )
          .toList(),
      replyId: (l$replyId as String?),
    );
  }

  final bool success;

  final List<Mutation$CreateSpotAnswerReply$createSpotAnswerReply$userErrors>
  userErrors;

  final String? replyId;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$success = success;
    _resultData['success'] = l$success;
    final l$userErrors = userErrors;
    _resultData['userErrors'] = l$userErrors.map((e) => e.toJson()).toList();
    final l$replyId = replyId;
    _resultData['replyId'] = l$replyId;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$success = success;
    final l$userErrors = userErrors;
    final l$replyId = replyId;
    return Object.hashAll([
      l$success,
      Object.hashAll(l$userErrors.map((v) => v)),
      l$replyId,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$CreateSpotAnswerReply$createSpotAnswerReply ||
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
    final l$replyId = replyId;
    final lOther$replyId = other.replyId;
    if (l$replyId != lOther$replyId) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Mutation$CreateSpotAnswerReply$createSpotAnswerReply
    on Mutation$CreateSpotAnswerReply$createSpotAnswerReply {
  CopyWith$Mutation$CreateSpotAnswerReply$createSpotAnswerReply<
    Mutation$CreateSpotAnswerReply$createSpotAnswerReply
  >
  get copyWith => CopyWith$Mutation$CreateSpotAnswerReply$createSpotAnswerReply(
    this,
    (i) => i,
  );
}

abstract class CopyWith$Mutation$CreateSpotAnswerReply$createSpotAnswerReply<
  TRes
> {
  factory CopyWith$Mutation$CreateSpotAnswerReply$createSpotAnswerReply(
    Mutation$CreateSpotAnswerReply$createSpotAnswerReply instance,
    TRes Function(Mutation$CreateSpotAnswerReply$createSpotAnswerReply) then,
  ) = _CopyWithImpl$Mutation$CreateSpotAnswerReply$createSpotAnswerReply;

  factory CopyWith$Mutation$CreateSpotAnswerReply$createSpotAnswerReply.stub(
    TRes res,
  ) = _CopyWithStubImpl$Mutation$CreateSpotAnswerReply$createSpotAnswerReply;

  TRes call({
    bool? success,
    List<Mutation$CreateSpotAnswerReply$createSpotAnswerReply$userErrors>?
    userErrors,
    String? replyId,
  });
  TRes userErrors(
    Iterable<Mutation$CreateSpotAnswerReply$createSpotAnswerReply$userErrors>
    Function(
      Iterable<
        CopyWith$Mutation$CreateSpotAnswerReply$createSpotAnswerReply$userErrors<
          Mutation$CreateSpotAnswerReply$createSpotAnswerReply$userErrors
        >
      >,
    )
    _fn,
  );
}

class _CopyWithImpl$Mutation$CreateSpotAnswerReply$createSpotAnswerReply<TRes>
    implements
        CopyWith$Mutation$CreateSpotAnswerReply$createSpotAnswerReply<TRes> {
  _CopyWithImpl$Mutation$CreateSpotAnswerReply$createSpotAnswerReply(
    this._instance,
    this._then,
  );

  final Mutation$CreateSpotAnswerReply$createSpotAnswerReply _instance;

  final TRes Function(Mutation$CreateSpotAnswerReply$createSpotAnswerReply)
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? success = _undefined,
    Object? userErrors = _undefined,
    Object? replyId = _undefined,
  }) => _then(
    Mutation$CreateSpotAnswerReply$createSpotAnswerReply(
      success: success == _undefined || success == null
          ? _instance.success
          : (success as bool),
      userErrors: userErrors == _undefined || userErrors == null
          ? _instance.userErrors
          : (userErrors
                as List<
                  Mutation$CreateSpotAnswerReply$createSpotAnswerReply$userErrors
                >),
      replyId: replyId == _undefined ? _instance.replyId : (replyId as String?),
    ),
  );

  TRes userErrors(
    Iterable<Mutation$CreateSpotAnswerReply$createSpotAnswerReply$userErrors>
    Function(
      Iterable<
        CopyWith$Mutation$CreateSpotAnswerReply$createSpotAnswerReply$userErrors<
          Mutation$CreateSpotAnswerReply$createSpotAnswerReply$userErrors
        >
      >,
    )
    _fn,
  ) => call(
    userErrors: _fn(
      _instance.userErrors.map(
        (e) =>
            CopyWith$Mutation$CreateSpotAnswerReply$createSpotAnswerReply$userErrors(
              e,
              (i) => i,
            ),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl$Mutation$CreateSpotAnswerReply$createSpotAnswerReply<
  TRes
>
    implements
        CopyWith$Mutation$CreateSpotAnswerReply$createSpotAnswerReply<TRes> {
  _CopyWithStubImpl$Mutation$CreateSpotAnswerReply$createSpotAnswerReply(
    this._res,
  );

  TRes _res;

  call({
    bool? success,
    List<Mutation$CreateSpotAnswerReply$createSpotAnswerReply$userErrors>?
    userErrors,
    String? replyId,
  }) => _res;

  userErrors(_fn) => _res;
}

class Mutation$CreateSpotAnswerReply$createSpotAnswerReply$userErrors {
  Mutation$CreateSpotAnswerReply$createSpotAnswerReply$userErrors({
    required this.code,
    this.field,
    required this.message,
  });

  factory Mutation$CreateSpotAnswerReply$createSpotAnswerReply$userErrors.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$code = json['code'];
    final l$field = json['field'];
    final l$message = json['message'];
    return Mutation$CreateSpotAnswerReply$createSpotAnswerReply$userErrors(
      code: (l$code as String),
      field: (l$field as String?),
      message: (l$message as String),
    );
  }

  final String code;

  final String? field;

  final String message;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$code = code;
    _resultData['code'] = l$code;
    final l$field = field;
    _resultData['field'] = l$field;
    final l$message = message;
    _resultData['message'] = l$message;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$code = code;
    final l$field = field;
    final l$message = message;
    return Object.hashAll([l$code, l$field, l$message]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Mutation$CreateSpotAnswerReply$createSpotAnswerReply$userErrors ||
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
    final l$message = message;
    final lOther$message = other.message;
    if (l$message != lOther$message) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Mutation$CreateSpotAnswerReply$createSpotAnswerReply$userErrors
    on Mutation$CreateSpotAnswerReply$createSpotAnswerReply$userErrors {
  CopyWith$Mutation$CreateSpotAnswerReply$createSpotAnswerReply$userErrors<
    Mutation$CreateSpotAnswerReply$createSpotAnswerReply$userErrors
  >
  get copyWith =>
      CopyWith$Mutation$CreateSpotAnswerReply$createSpotAnswerReply$userErrors(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Mutation$CreateSpotAnswerReply$createSpotAnswerReply$userErrors<
  TRes
> {
  factory CopyWith$Mutation$CreateSpotAnswerReply$createSpotAnswerReply$userErrors(
    Mutation$CreateSpotAnswerReply$createSpotAnswerReply$userErrors instance,
    TRes Function(
      Mutation$CreateSpotAnswerReply$createSpotAnswerReply$userErrors,
    )
    then,
  ) = _CopyWithImpl$Mutation$CreateSpotAnswerReply$createSpotAnswerReply$userErrors;

  factory CopyWith$Mutation$CreateSpotAnswerReply$createSpotAnswerReply$userErrors.stub(
    TRes res,
  ) = _CopyWithStubImpl$Mutation$CreateSpotAnswerReply$createSpotAnswerReply$userErrors;

  TRes call({String? code, String? field, String? message});
}

class _CopyWithImpl$Mutation$CreateSpotAnswerReply$createSpotAnswerReply$userErrors<
  TRes
>
    implements
        CopyWith$Mutation$CreateSpotAnswerReply$createSpotAnswerReply$userErrors<
          TRes
        > {
  _CopyWithImpl$Mutation$CreateSpotAnswerReply$createSpotAnswerReply$userErrors(
    this._instance,
    this._then,
  );

  final Mutation$CreateSpotAnswerReply$createSpotAnswerReply$userErrors
  _instance;

  final TRes Function(
    Mutation$CreateSpotAnswerReply$createSpotAnswerReply$userErrors,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? code = _undefined,
    Object? field = _undefined,
    Object? message = _undefined,
  }) => _then(
    Mutation$CreateSpotAnswerReply$createSpotAnswerReply$userErrors(
      code: code == _undefined || code == null
          ? _instance.code
          : (code as String),
      field: field == _undefined ? _instance.field : (field as String?),
      message: message == _undefined || message == null
          ? _instance.message
          : (message as String),
    ),
  );
}

class _CopyWithStubImpl$Mutation$CreateSpotAnswerReply$createSpotAnswerReply$userErrors<
  TRes
>
    implements
        CopyWith$Mutation$CreateSpotAnswerReply$createSpotAnswerReply$userErrors<
          TRes
        > {
  _CopyWithStubImpl$Mutation$CreateSpotAnswerReply$createSpotAnswerReply$userErrors(
    this._res,
  );

  TRes _res;

  call({String? code, String? field, String? message}) => _res;
}

class Variables$Mutation$DeleteSpotAnswerReply {
  factory Variables$Mutation$DeleteSpotAnswerReply({required String replyId}) =>
      Variables$Mutation$DeleteSpotAnswerReply._({r'replyId': replyId});

  Variables$Mutation$DeleteSpotAnswerReply._(this._$data);

  factory Variables$Mutation$DeleteSpotAnswerReply.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    final l$replyId = data['replyId'];
    result$data['replyId'] = (l$replyId as String);
    return Variables$Mutation$DeleteSpotAnswerReply._(result$data);
  }

  Map<String, dynamic> _$data;

  String get replyId => (_$data['replyId'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$replyId = replyId;
    result$data['replyId'] = l$replyId;
    return result$data;
  }

  CopyWith$Variables$Mutation$DeleteSpotAnswerReply<
    Variables$Mutation$DeleteSpotAnswerReply
  >
  get copyWith =>
      CopyWith$Variables$Mutation$DeleteSpotAnswerReply(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Mutation$DeleteSpotAnswerReply ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$replyId = replyId;
    final lOther$replyId = other.replyId;
    if (l$replyId != lOther$replyId) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$replyId = replyId;
    return Object.hashAll([l$replyId]);
  }
}

abstract class CopyWith$Variables$Mutation$DeleteSpotAnswerReply<TRes> {
  factory CopyWith$Variables$Mutation$DeleteSpotAnswerReply(
    Variables$Mutation$DeleteSpotAnswerReply instance,
    TRes Function(Variables$Mutation$DeleteSpotAnswerReply) then,
  ) = _CopyWithImpl$Variables$Mutation$DeleteSpotAnswerReply;

  factory CopyWith$Variables$Mutation$DeleteSpotAnswerReply.stub(TRes res) =
      _CopyWithStubImpl$Variables$Mutation$DeleteSpotAnswerReply;

  TRes call({String? replyId});
}

class _CopyWithImpl$Variables$Mutation$DeleteSpotAnswerReply<TRes>
    implements CopyWith$Variables$Mutation$DeleteSpotAnswerReply<TRes> {
  _CopyWithImpl$Variables$Mutation$DeleteSpotAnswerReply(
    this._instance,
    this._then,
  );

  final Variables$Mutation$DeleteSpotAnswerReply _instance;

  final TRes Function(Variables$Mutation$DeleteSpotAnswerReply) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? replyId = _undefined}) => _then(
    Variables$Mutation$DeleteSpotAnswerReply._({
      ..._instance._$data,
      if (replyId != _undefined && replyId != null)
        'replyId': (replyId as String),
    }),
  );
}

class _CopyWithStubImpl$Variables$Mutation$DeleteSpotAnswerReply<TRes>
    implements CopyWith$Variables$Mutation$DeleteSpotAnswerReply<TRes> {
  _CopyWithStubImpl$Variables$Mutation$DeleteSpotAnswerReply(this._res);

  TRes _res;

  call({String? replyId}) => _res;
}

class Mutation$DeleteSpotAnswerReply {
  Mutation$DeleteSpotAnswerReply({required this.deleteSpotAnswerReply});

  factory Mutation$DeleteSpotAnswerReply.fromJson(Map<String, dynamic> json) {
    final l$deleteSpotAnswerReply = json['deleteSpotAnswerReply'];
    return Mutation$DeleteSpotAnswerReply(
      deleteSpotAnswerReply:
          Mutation$DeleteSpotAnswerReply$deleteSpotAnswerReply.fromJson(
            (l$deleteSpotAnswerReply as Map<String, dynamic>),
          ),
    );
  }

  final Mutation$DeleteSpotAnswerReply$deleteSpotAnswerReply
  deleteSpotAnswerReply;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$deleteSpotAnswerReply = deleteSpotAnswerReply;
    _resultData['deleteSpotAnswerReply'] = l$deleteSpotAnswerReply.toJson();
    return _resultData;
  }

  @override
  int get hashCode {
    final l$deleteSpotAnswerReply = deleteSpotAnswerReply;
    return Object.hashAll([l$deleteSpotAnswerReply]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$DeleteSpotAnswerReply ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$deleteSpotAnswerReply = deleteSpotAnswerReply;
    final lOther$deleteSpotAnswerReply = other.deleteSpotAnswerReply;
    if (l$deleteSpotAnswerReply != lOther$deleteSpotAnswerReply) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Mutation$DeleteSpotAnswerReply
    on Mutation$DeleteSpotAnswerReply {
  CopyWith$Mutation$DeleteSpotAnswerReply<Mutation$DeleteSpotAnswerReply>
  get copyWith => CopyWith$Mutation$DeleteSpotAnswerReply(this, (i) => i);
}

abstract class CopyWith$Mutation$DeleteSpotAnswerReply<TRes> {
  factory CopyWith$Mutation$DeleteSpotAnswerReply(
    Mutation$DeleteSpotAnswerReply instance,
    TRes Function(Mutation$DeleteSpotAnswerReply) then,
  ) = _CopyWithImpl$Mutation$DeleteSpotAnswerReply;

  factory CopyWith$Mutation$DeleteSpotAnswerReply.stub(TRes res) =
      _CopyWithStubImpl$Mutation$DeleteSpotAnswerReply;

  TRes call({
    Mutation$DeleteSpotAnswerReply$deleteSpotAnswerReply? deleteSpotAnswerReply,
  });
  CopyWith$Mutation$DeleteSpotAnswerReply$deleteSpotAnswerReply<TRes>
  get deleteSpotAnswerReply;
}

class _CopyWithImpl$Mutation$DeleteSpotAnswerReply<TRes>
    implements CopyWith$Mutation$DeleteSpotAnswerReply<TRes> {
  _CopyWithImpl$Mutation$DeleteSpotAnswerReply(this._instance, this._then);

  final Mutation$DeleteSpotAnswerReply _instance;

  final TRes Function(Mutation$DeleteSpotAnswerReply) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? deleteSpotAnswerReply = _undefined}) => _then(
    Mutation$DeleteSpotAnswerReply(
      deleteSpotAnswerReply:
          deleteSpotAnswerReply == _undefined || deleteSpotAnswerReply == null
          ? _instance.deleteSpotAnswerReply
          : (deleteSpotAnswerReply
                as Mutation$DeleteSpotAnswerReply$deleteSpotAnswerReply),
    ),
  );

  CopyWith$Mutation$DeleteSpotAnswerReply$deleteSpotAnswerReply<TRes>
  get deleteSpotAnswerReply {
    final local$deleteSpotAnswerReply = _instance.deleteSpotAnswerReply;
    return CopyWith$Mutation$DeleteSpotAnswerReply$deleteSpotAnswerReply(
      local$deleteSpotAnswerReply,
      (e) => call(deleteSpotAnswerReply: e),
    );
  }
}

class _CopyWithStubImpl$Mutation$DeleteSpotAnswerReply<TRes>
    implements CopyWith$Mutation$DeleteSpotAnswerReply<TRes> {
  _CopyWithStubImpl$Mutation$DeleteSpotAnswerReply(this._res);

  TRes _res;

  call({
    Mutation$DeleteSpotAnswerReply$deleteSpotAnswerReply? deleteSpotAnswerReply,
  }) => _res;

  CopyWith$Mutation$DeleteSpotAnswerReply$deleteSpotAnswerReply<TRes>
  get deleteSpotAnswerReply =>
      CopyWith$Mutation$DeleteSpotAnswerReply$deleteSpotAnswerReply.stub(_res);
}

const documentNodeMutationDeleteSpotAnswerReply = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'DeleteSpotAnswerReply'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'replyId')),
          type: NamedTypeNode(name: NameNode(value: 'ID'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
      ],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'deleteSpotAnswerReply'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'input'),
                value: ObjectValueNode(
                  fields: [
                    ObjectFieldNode(
                      name: NameNode(value: 'replyId'),
                      value: VariableNode(name: NameNode(value: 'replyId')),
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
                        name: NameNode(value: 'field'),
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

class Mutation$DeleteSpotAnswerReply$deleteSpotAnswerReply {
  Mutation$DeleteSpotAnswerReply$deleteSpotAnswerReply({
    required this.success,
    required this.userErrors,
  });

  factory Mutation$DeleteSpotAnswerReply$deleteSpotAnswerReply.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$success = json['success'];
    final l$userErrors = json['userErrors'];
    return Mutation$DeleteSpotAnswerReply$deleteSpotAnswerReply(
      success: (l$success as bool),
      userErrors: (l$userErrors as List<dynamic>)
          .map(
            (e) =>
                Mutation$DeleteSpotAnswerReply$deleteSpotAnswerReply$userErrors.fromJson(
                  (e as Map<String, dynamic>),
                ),
          )
          .toList(),
    );
  }

  final bool success;

  final List<Mutation$DeleteSpotAnswerReply$deleteSpotAnswerReply$userErrors>
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
    if (other is! Mutation$DeleteSpotAnswerReply$deleteSpotAnswerReply ||
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

extension UtilityExtension$Mutation$DeleteSpotAnswerReply$deleteSpotAnswerReply
    on Mutation$DeleteSpotAnswerReply$deleteSpotAnswerReply {
  CopyWith$Mutation$DeleteSpotAnswerReply$deleteSpotAnswerReply<
    Mutation$DeleteSpotAnswerReply$deleteSpotAnswerReply
  >
  get copyWith => CopyWith$Mutation$DeleteSpotAnswerReply$deleteSpotAnswerReply(
    this,
    (i) => i,
  );
}

abstract class CopyWith$Mutation$DeleteSpotAnswerReply$deleteSpotAnswerReply<
  TRes
> {
  factory CopyWith$Mutation$DeleteSpotAnswerReply$deleteSpotAnswerReply(
    Mutation$DeleteSpotAnswerReply$deleteSpotAnswerReply instance,
    TRes Function(Mutation$DeleteSpotAnswerReply$deleteSpotAnswerReply) then,
  ) = _CopyWithImpl$Mutation$DeleteSpotAnswerReply$deleteSpotAnswerReply;

  factory CopyWith$Mutation$DeleteSpotAnswerReply$deleteSpotAnswerReply.stub(
    TRes res,
  ) = _CopyWithStubImpl$Mutation$DeleteSpotAnswerReply$deleteSpotAnswerReply;

  TRes call({
    bool? success,
    List<Mutation$DeleteSpotAnswerReply$deleteSpotAnswerReply$userErrors>?
    userErrors,
  });
  TRes userErrors(
    Iterable<Mutation$DeleteSpotAnswerReply$deleteSpotAnswerReply$userErrors>
    Function(
      Iterable<
        CopyWith$Mutation$DeleteSpotAnswerReply$deleteSpotAnswerReply$userErrors<
          Mutation$DeleteSpotAnswerReply$deleteSpotAnswerReply$userErrors
        >
      >,
    )
    _fn,
  );
}

class _CopyWithImpl$Mutation$DeleteSpotAnswerReply$deleteSpotAnswerReply<TRes>
    implements
        CopyWith$Mutation$DeleteSpotAnswerReply$deleteSpotAnswerReply<TRes> {
  _CopyWithImpl$Mutation$DeleteSpotAnswerReply$deleteSpotAnswerReply(
    this._instance,
    this._then,
  );

  final Mutation$DeleteSpotAnswerReply$deleteSpotAnswerReply _instance;

  final TRes Function(Mutation$DeleteSpotAnswerReply$deleteSpotAnswerReply)
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? success = _undefined,
    Object? userErrors = _undefined,
  }) => _then(
    Mutation$DeleteSpotAnswerReply$deleteSpotAnswerReply(
      success: success == _undefined || success == null
          ? _instance.success
          : (success as bool),
      userErrors: userErrors == _undefined || userErrors == null
          ? _instance.userErrors
          : (userErrors
                as List<
                  Mutation$DeleteSpotAnswerReply$deleteSpotAnswerReply$userErrors
                >),
    ),
  );

  TRes userErrors(
    Iterable<Mutation$DeleteSpotAnswerReply$deleteSpotAnswerReply$userErrors>
    Function(
      Iterable<
        CopyWith$Mutation$DeleteSpotAnswerReply$deleteSpotAnswerReply$userErrors<
          Mutation$DeleteSpotAnswerReply$deleteSpotAnswerReply$userErrors
        >
      >,
    )
    _fn,
  ) => call(
    userErrors: _fn(
      _instance.userErrors.map(
        (e) =>
            CopyWith$Mutation$DeleteSpotAnswerReply$deleteSpotAnswerReply$userErrors(
              e,
              (i) => i,
            ),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl$Mutation$DeleteSpotAnswerReply$deleteSpotAnswerReply<
  TRes
>
    implements
        CopyWith$Mutation$DeleteSpotAnswerReply$deleteSpotAnswerReply<TRes> {
  _CopyWithStubImpl$Mutation$DeleteSpotAnswerReply$deleteSpotAnswerReply(
    this._res,
  );

  TRes _res;

  call({
    bool? success,
    List<Mutation$DeleteSpotAnswerReply$deleteSpotAnswerReply$userErrors>?
    userErrors,
  }) => _res;

  userErrors(_fn) => _res;
}

class Mutation$DeleteSpotAnswerReply$deleteSpotAnswerReply$userErrors {
  Mutation$DeleteSpotAnswerReply$deleteSpotAnswerReply$userErrors({
    required this.code,
    this.field,
    required this.message,
  });

  factory Mutation$DeleteSpotAnswerReply$deleteSpotAnswerReply$userErrors.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$code = json['code'];
    final l$field = json['field'];
    final l$message = json['message'];
    return Mutation$DeleteSpotAnswerReply$deleteSpotAnswerReply$userErrors(
      code: (l$code as String),
      field: (l$field as String?),
      message: (l$message as String),
    );
  }

  final String code;

  final String? field;

  final String message;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$code = code;
    _resultData['code'] = l$code;
    final l$field = field;
    _resultData['field'] = l$field;
    final l$message = message;
    _resultData['message'] = l$message;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$code = code;
    final l$field = field;
    final l$message = message;
    return Object.hashAll([l$code, l$field, l$message]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Mutation$DeleteSpotAnswerReply$deleteSpotAnswerReply$userErrors ||
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
    final l$message = message;
    final lOther$message = other.message;
    if (l$message != lOther$message) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Mutation$DeleteSpotAnswerReply$deleteSpotAnswerReply$userErrors
    on Mutation$DeleteSpotAnswerReply$deleteSpotAnswerReply$userErrors {
  CopyWith$Mutation$DeleteSpotAnswerReply$deleteSpotAnswerReply$userErrors<
    Mutation$DeleteSpotAnswerReply$deleteSpotAnswerReply$userErrors
  >
  get copyWith =>
      CopyWith$Mutation$DeleteSpotAnswerReply$deleteSpotAnswerReply$userErrors(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Mutation$DeleteSpotAnswerReply$deleteSpotAnswerReply$userErrors<
  TRes
> {
  factory CopyWith$Mutation$DeleteSpotAnswerReply$deleteSpotAnswerReply$userErrors(
    Mutation$DeleteSpotAnswerReply$deleteSpotAnswerReply$userErrors instance,
    TRes Function(
      Mutation$DeleteSpotAnswerReply$deleteSpotAnswerReply$userErrors,
    )
    then,
  ) = _CopyWithImpl$Mutation$DeleteSpotAnswerReply$deleteSpotAnswerReply$userErrors;

  factory CopyWith$Mutation$DeleteSpotAnswerReply$deleteSpotAnswerReply$userErrors.stub(
    TRes res,
  ) = _CopyWithStubImpl$Mutation$DeleteSpotAnswerReply$deleteSpotAnswerReply$userErrors;

  TRes call({String? code, String? field, String? message});
}

class _CopyWithImpl$Mutation$DeleteSpotAnswerReply$deleteSpotAnswerReply$userErrors<
  TRes
>
    implements
        CopyWith$Mutation$DeleteSpotAnswerReply$deleteSpotAnswerReply$userErrors<
          TRes
        > {
  _CopyWithImpl$Mutation$DeleteSpotAnswerReply$deleteSpotAnswerReply$userErrors(
    this._instance,
    this._then,
  );

  final Mutation$DeleteSpotAnswerReply$deleteSpotAnswerReply$userErrors
  _instance;

  final TRes Function(
    Mutation$DeleteSpotAnswerReply$deleteSpotAnswerReply$userErrors,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? code = _undefined,
    Object? field = _undefined,
    Object? message = _undefined,
  }) => _then(
    Mutation$DeleteSpotAnswerReply$deleteSpotAnswerReply$userErrors(
      code: code == _undefined || code == null
          ? _instance.code
          : (code as String),
      field: field == _undefined ? _instance.field : (field as String?),
      message: message == _undefined || message == null
          ? _instance.message
          : (message as String),
    ),
  );
}

class _CopyWithStubImpl$Mutation$DeleteSpotAnswerReply$deleteSpotAnswerReply$userErrors<
  TRes
>
    implements
        CopyWith$Mutation$DeleteSpotAnswerReply$deleteSpotAnswerReply$userErrors<
          TRes
        > {
  _CopyWithStubImpl$Mutation$DeleteSpotAnswerReply$deleteSpotAnswerReply$userErrors(
    this._res,
  );

  TRes _res;

  call({String? code, String? field, String? message}) => _res;
}
