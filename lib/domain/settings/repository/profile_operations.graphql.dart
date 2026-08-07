// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, unused_element
import '../../../common/network/shared_schema.graphql.dart';
import 'package:gql/ast.dart';
import 'profile_schema.graphql.dart';

class Variables$Query$MyPosts {
  factory Variables$Query$MyPosts({int? first, String? after}) =>
      Variables$Query$MyPosts._({
        if (first != null) r'first': first,
        if (after != null) r'after': after,
      });

  Variables$Query$MyPosts._(this._$data);

  factory Variables$Query$MyPosts.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    if (data.containsKey('first')) {
      final l$first = data['first'];
      result$data['first'] = (l$first as int?);
    }
    if (data.containsKey('after')) {
      final l$after = data['after'];
      result$data['after'] = (l$after as String?);
    }
    return Variables$Query$MyPosts._(result$data);
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

  CopyWith$Variables$Query$MyPosts<Variables$Query$MyPosts> get copyWith =>
      CopyWith$Variables$Query$MyPosts(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Query$MyPosts || runtimeType != other.runtimeType) {
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

abstract class CopyWith$Variables$Query$MyPosts<TRes> {
  factory CopyWith$Variables$Query$MyPosts(
    Variables$Query$MyPosts instance,
    TRes Function(Variables$Query$MyPosts) then,
  ) = _CopyWithImpl$Variables$Query$MyPosts;

  factory CopyWith$Variables$Query$MyPosts.stub(TRes res) =
      _CopyWithStubImpl$Variables$Query$MyPosts;

  TRes call({int? first, String? after});
}

class _CopyWithImpl$Variables$Query$MyPosts<TRes>
    implements CopyWith$Variables$Query$MyPosts<TRes> {
  _CopyWithImpl$Variables$Query$MyPosts(this._instance, this._then);

  final Variables$Query$MyPosts _instance;

  final TRes Function(Variables$Query$MyPosts) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? first = _undefined, Object? after = _undefined}) => _then(
    Variables$Query$MyPosts._({
      ..._instance._$data,
      if (first != _undefined) 'first': (first as int?),
      if (after != _undefined) 'after': (after as String?),
    }),
  );
}

class _CopyWithStubImpl$Variables$Query$MyPosts<TRes>
    implements CopyWith$Variables$Query$MyPosts<TRes> {
  _CopyWithStubImpl$Variables$Query$MyPosts(this._res);

  TRes _res;

  call({int? first, String? after}) => _res;
}

class Query$MyPosts {
  Query$MyPosts({required this.myPosts});

  factory Query$MyPosts.fromJson(Map<String, dynamic> json) {
    final l$myPosts = json['myPosts'];
    return Query$MyPosts(
      myPosts: Query$MyPosts$myPosts.fromJson(
        (l$myPosts as Map<String, dynamic>),
      ),
    );
  }

  final Query$MyPosts$myPosts myPosts;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$myPosts = myPosts;
    _resultData['myPosts'] = l$myPosts.toJson();
    return _resultData;
  }

  @override
  int get hashCode {
    final l$myPosts = myPosts;
    return Object.hashAll([l$myPosts]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$MyPosts || runtimeType != other.runtimeType) {
      return false;
    }
    final l$myPosts = myPosts;
    final lOther$myPosts = other.myPosts;
    if (l$myPosts != lOther$myPosts) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Query$MyPosts on Query$MyPosts {
  CopyWith$Query$MyPosts<Query$MyPosts> get copyWith =>
      CopyWith$Query$MyPosts(this, (i) => i);
}

abstract class CopyWith$Query$MyPosts<TRes> {
  factory CopyWith$Query$MyPosts(
    Query$MyPosts instance,
    TRes Function(Query$MyPosts) then,
  ) = _CopyWithImpl$Query$MyPosts;

  factory CopyWith$Query$MyPosts.stub(TRes res) =
      _CopyWithStubImpl$Query$MyPosts;

  TRes call({Query$MyPosts$myPosts? myPosts});
  CopyWith$Query$MyPosts$myPosts<TRes> get myPosts;
}

class _CopyWithImpl$Query$MyPosts<TRes>
    implements CopyWith$Query$MyPosts<TRes> {
  _CopyWithImpl$Query$MyPosts(this._instance, this._then);

  final Query$MyPosts _instance;

  final TRes Function(Query$MyPosts) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? myPosts = _undefined}) => _then(
    Query$MyPosts(
      myPosts: myPosts == _undefined || myPosts == null
          ? _instance.myPosts
          : (myPosts as Query$MyPosts$myPosts),
    ),
  );

  CopyWith$Query$MyPosts$myPosts<TRes> get myPosts {
    final local$myPosts = _instance.myPosts;
    return CopyWith$Query$MyPosts$myPosts(
      local$myPosts,
      (e) => call(myPosts: e),
    );
  }
}

class _CopyWithStubImpl$Query$MyPosts<TRes>
    implements CopyWith$Query$MyPosts<TRes> {
  _CopyWithStubImpl$Query$MyPosts(this._res);

  TRes _res;

  call({Query$MyPosts$myPosts? myPosts}) => _res;

  CopyWith$Query$MyPosts$myPosts<TRes> get myPosts =>
      CopyWith$Query$MyPosts$myPosts.stub(_res);
}

const documentNodeQueryMyPosts = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'MyPosts'),
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
            name: NameNode(value: 'myPosts'),
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

class Query$MyPosts$myPosts {
  Query$MyPosts$myPosts({required this.edges, required this.pageInfo});

  factory Query$MyPosts$myPosts.fromJson(Map<String, dynamic> json) {
    final l$edges = json['edges'];
    final l$pageInfo = json['pageInfo'];
    return Query$MyPosts$myPosts(
      edges: (l$edges as List<dynamic>)
          .map(
            (e) => Query$MyPosts$myPosts$edges.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      pageInfo: Query$MyPosts$myPosts$pageInfo.fromJson(
        (l$pageInfo as Map<String, dynamic>),
      ),
    );
  }

  final List<Query$MyPosts$myPosts$edges> edges;

  final Query$MyPosts$myPosts$pageInfo pageInfo;

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
    if (other is! Query$MyPosts$myPosts || runtimeType != other.runtimeType) {
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

extension UtilityExtension$Query$MyPosts$myPosts on Query$MyPosts$myPosts {
  CopyWith$Query$MyPosts$myPosts<Query$MyPosts$myPosts> get copyWith =>
      CopyWith$Query$MyPosts$myPosts(this, (i) => i);
}

abstract class CopyWith$Query$MyPosts$myPosts<TRes> {
  factory CopyWith$Query$MyPosts$myPosts(
    Query$MyPosts$myPosts instance,
    TRes Function(Query$MyPosts$myPosts) then,
  ) = _CopyWithImpl$Query$MyPosts$myPosts;

  factory CopyWith$Query$MyPosts$myPosts.stub(TRes res) =
      _CopyWithStubImpl$Query$MyPosts$myPosts;

  TRes call({
    List<Query$MyPosts$myPosts$edges>? edges,
    Query$MyPosts$myPosts$pageInfo? pageInfo,
  });
  TRes edges(
    Iterable<Query$MyPosts$myPosts$edges> Function(
      Iterable<
        CopyWith$Query$MyPosts$myPosts$edges<Query$MyPosts$myPosts$edges>
      >,
    )
    _fn,
  );
  CopyWith$Query$MyPosts$myPosts$pageInfo<TRes> get pageInfo;
}

class _CopyWithImpl$Query$MyPosts$myPosts<TRes>
    implements CopyWith$Query$MyPosts$myPosts<TRes> {
  _CopyWithImpl$Query$MyPosts$myPosts(this._instance, this._then);

  final Query$MyPosts$myPosts _instance;

  final TRes Function(Query$MyPosts$myPosts) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? edges = _undefined, Object? pageInfo = _undefined}) =>
      _then(
        Query$MyPosts$myPosts(
          edges: edges == _undefined || edges == null
              ? _instance.edges
              : (edges as List<Query$MyPosts$myPosts$edges>),
          pageInfo: pageInfo == _undefined || pageInfo == null
              ? _instance.pageInfo
              : (pageInfo as Query$MyPosts$myPosts$pageInfo),
        ),
      );

  TRes edges(
    Iterable<Query$MyPosts$myPosts$edges> Function(
      Iterable<
        CopyWith$Query$MyPosts$myPosts$edges<Query$MyPosts$myPosts$edges>
      >,
    )
    _fn,
  ) => call(
    edges: _fn(
      _instance.edges.map(
        (e) => CopyWith$Query$MyPosts$myPosts$edges(e, (i) => i),
      ),
    ).toList(),
  );

  CopyWith$Query$MyPosts$myPosts$pageInfo<TRes> get pageInfo {
    final local$pageInfo = _instance.pageInfo;
    return CopyWith$Query$MyPosts$myPosts$pageInfo(
      local$pageInfo,
      (e) => call(pageInfo: e),
    );
  }
}

class _CopyWithStubImpl$Query$MyPosts$myPosts<TRes>
    implements CopyWith$Query$MyPosts$myPosts<TRes> {
  _CopyWithStubImpl$Query$MyPosts$myPosts(this._res);

  TRes _res;

  call({
    List<Query$MyPosts$myPosts$edges>? edges,
    Query$MyPosts$myPosts$pageInfo? pageInfo,
  }) => _res;

  edges(_fn) => _res;

  CopyWith$Query$MyPosts$myPosts$pageInfo<TRes> get pageInfo =>
      CopyWith$Query$MyPosts$myPosts$pageInfo.stub(_res);
}

class Query$MyPosts$myPosts$edges {
  Query$MyPosts$myPosts$edges({required this.node});

  factory Query$MyPosts$myPosts$edges.fromJson(Map<String, dynamic> json) {
    final l$node = json['node'];
    return Query$MyPosts$myPosts$edges(
      node: Query$MyPosts$myPosts$edges$node.fromJson(
        (l$node as Map<String, dynamic>),
      ),
    );
  }

  final Query$MyPosts$myPosts$edges$node node;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$node = node;
    _resultData['node'] = l$node.toJson();
    return _resultData;
  }

  @override
  int get hashCode {
    final l$node = node;
    return Object.hashAll([l$node]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$MyPosts$myPosts$edges ||
        runtimeType != other.runtimeType) {
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

extension UtilityExtension$Query$MyPosts$myPosts$edges
    on Query$MyPosts$myPosts$edges {
  CopyWith$Query$MyPosts$myPosts$edges<Query$MyPosts$myPosts$edges>
  get copyWith => CopyWith$Query$MyPosts$myPosts$edges(this, (i) => i);
}

abstract class CopyWith$Query$MyPosts$myPosts$edges<TRes> {
  factory CopyWith$Query$MyPosts$myPosts$edges(
    Query$MyPosts$myPosts$edges instance,
    TRes Function(Query$MyPosts$myPosts$edges) then,
  ) = _CopyWithImpl$Query$MyPosts$myPosts$edges;

  factory CopyWith$Query$MyPosts$myPosts$edges.stub(TRes res) =
      _CopyWithStubImpl$Query$MyPosts$myPosts$edges;

  TRes call({Query$MyPosts$myPosts$edges$node? node});
  CopyWith$Query$MyPosts$myPosts$edges$node<TRes> get node;
}

class _CopyWithImpl$Query$MyPosts$myPosts$edges<TRes>
    implements CopyWith$Query$MyPosts$myPosts$edges<TRes> {
  _CopyWithImpl$Query$MyPosts$myPosts$edges(this._instance, this._then);

  final Query$MyPosts$myPosts$edges _instance;

  final TRes Function(Query$MyPosts$myPosts$edges) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? node = _undefined}) => _then(
    Query$MyPosts$myPosts$edges(
      node: node == _undefined || node == null
          ? _instance.node
          : (node as Query$MyPosts$myPosts$edges$node),
    ),
  );

  CopyWith$Query$MyPosts$myPosts$edges$node<TRes> get node {
    final local$node = _instance.node;
    return CopyWith$Query$MyPosts$myPosts$edges$node(
      local$node,
      (e) => call(node: e),
    );
  }
}

class _CopyWithStubImpl$Query$MyPosts$myPosts$edges<TRes>
    implements CopyWith$Query$MyPosts$myPosts$edges<TRes> {
  _CopyWithStubImpl$Query$MyPosts$myPosts$edges(this._res);

  TRes _res;

  call({Query$MyPosts$myPosts$edges$node? node}) => _res;

  CopyWith$Query$MyPosts$myPosts$edges$node<TRes> get node =>
      CopyWith$Query$MyPosts$myPosts$edges$node.stub(_res);
}

class Query$MyPosts$myPosts$edges$node {
  Query$MyPosts$myPosts$edges$node({
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

  factory Query$MyPosts$myPosts$edges$node.fromJson(Map<String, dynamic> json) {
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
    return Query$MyPosts$myPosts$edges$node(
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
          : Query$MyPosts$myPosts$edges$node$spot.fromJson(
              (l$spot as Map<String, dynamic>),
            ),
      author: Query$MyPosts$myPosts$edges$node$author.fromJson(
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

  final Query$MyPosts$myPosts$edges$node$spot? spot;

  final Query$MyPosts$myPosts$edges$node$author author;

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
    if (other is! Query$MyPosts$myPosts$edges$node ||
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

extension UtilityExtension$Query$MyPosts$myPosts$edges$node
    on Query$MyPosts$myPosts$edges$node {
  CopyWith$Query$MyPosts$myPosts$edges$node<Query$MyPosts$myPosts$edges$node>
  get copyWith => CopyWith$Query$MyPosts$myPosts$edges$node(this, (i) => i);
}

abstract class CopyWith$Query$MyPosts$myPosts$edges$node<TRes> {
  factory CopyWith$Query$MyPosts$myPosts$edges$node(
    Query$MyPosts$myPosts$edges$node instance,
    TRes Function(Query$MyPosts$myPosts$edges$node) then,
  ) = _CopyWithImpl$Query$MyPosts$myPosts$edges$node;

  factory CopyWith$Query$MyPosts$myPosts$edges$node.stub(TRes res) =
      _CopyWithStubImpl$Query$MyPosts$myPosts$edges$node;

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
    Query$MyPosts$myPosts$edges$node$spot? spot,
    Query$MyPosts$myPosts$edges$node$author? author,
  });
  CopyWith$Query$MyPosts$myPosts$edges$node$spot<TRes> get spot;
  CopyWith$Query$MyPosts$myPosts$edges$node$author<TRes> get author;
}

class _CopyWithImpl$Query$MyPosts$myPosts$edges$node<TRes>
    implements CopyWith$Query$MyPosts$myPosts$edges$node<TRes> {
  _CopyWithImpl$Query$MyPosts$myPosts$edges$node(this._instance, this._then);

  final Query$MyPosts$myPosts$edges$node _instance;

  final TRes Function(Query$MyPosts$myPosts$edges$node) _then;

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
    Query$MyPosts$myPosts$edges$node(
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
          : (spot as Query$MyPosts$myPosts$edges$node$spot?),
      author: author == _undefined || author == null
          ? _instance.author
          : (author as Query$MyPosts$myPosts$edges$node$author),
    ),
  );

  CopyWith$Query$MyPosts$myPosts$edges$node$spot<TRes> get spot {
    final local$spot = _instance.spot;
    return local$spot == null
        ? CopyWith$Query$MyPosts$myPosts$edges$node$spot.stub(_then(_instance))
        : CopyWith$Query$MyPosts$myPosts$edges$node$spot(
            local$spot,
            (e) => call(spot: e),
          );
  }

  CopyWith$Query$MyPosts$myPosts$edges$node$author<TRes> get author {
    final local$author = _instance.author;
    return CopyWith$Query$MyPosts$myPosts$edges$node$author(
      local$author,
      (e) => call(author: e),
    );
  }
}

class _CopyWithStubImpl$Query$MyPosts$myPosts$edges$node<TRes>
    implements CopyWith$Query$MyPosts$myPosts$edges$node<TRes> {
  _CopyWithStubImpl$Query$MyPosts$myPosts$edges$node(this._res);

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
    Query$MyPosts$myPosts$edges$node$spot? spot,
    Query$MyPosts$myPosts$edges$node$author? author,
  }) => _res;

  CopyWith$Query$MyPosts$myPosts$edges$node$spot<TRes> get spot =>
      CopyWith$Query$MyPosts$myPosts$edges$node$spot.stub(_res);

  CopyWith$Query$MyPosts$myPosts$edges$node$author<TRes> get author =>
      CopyWith$Query$MyPosts$myPosts$edges$node$author.stub(_res);
}

class Query$MyPosts$myPosts$edges$node$spot {
  Query$MyPosts$myPosts$edges$node$spot({
    required this.id,
    required this.title,
    required this.thumbnailImageUrl,
    this.category,
  });

  factory Query$MyPosts$myPosts$edges$node$spot.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$title = json['title'];
    final l$thumbnailImageUrl = json['thumbnailImageUrl'];
    final l$category = json['category'];
    return Query$MyPosts$myPosts$edges$node$spot(
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
    if (other is! Query$MyPosts$myPosts$edges$node$spot ||
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

extension UtilityExtension$Query$MyPosts$myPosts$edges$node$spot
    on Query$MyPosts$myPosts$edges$node$spot {
  CopyWith$Query$MyPosts$myPosts$edges$node$spot<
    Query$MyPosts$myPosts$edges$node$spot
  >
  get copyWith =>
      CopyWith$Query$MyPosts$myPosts$edges$node$spot(this, (i) => i);
}

abstract class CopyWith$Query$MyPosts$myPosts$edges$node$spot<TRes> {
  factory CopyWith$Query$MyPosts$myPosts$edges$node$spot(
    Query$MyPosts$myPosts$edges$node$spot instance,
    TRes Function(Query$MyPosts$myPosts$edges$node$spot) then,
  ) = _CopyWithImpl$Query$MyPosts$myPosts$edges$node$spot;

  factory CopyWith$Query$MyPosts$myPosts$edges$node$spot.stub(TRes res) =
      _CopyWithStubImpl$Query$MyPosts$myPosts$edges$node$spot;

  TRes call({
    String? id,
    String? title,
    String? thumbnailImageUrl,
    Enum$TargetCategory? category,
  });
}

class _CopyWithImpl$Query$MyPosts$myPosts$edges$node$spot<TRes>
    implements CopyWith$Query$MyPosts$myPosts$edges$node$spot<TRes> {
  _CopyWithImpl$Query$MyPosts$myPosts$edges$node$spot(
    this._instance,
    this._then,
  );

  final Query$MyPosts$myPosts$edges$node$spot _instance;

  final TRes Function(Query$MyPosts$myPosts$edges$node$spot) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? title = _undefined,
    Object? thumbnailImageUrl = _undefined,
    Object? category = _undefined,
  }) => _then(
    Query$MyPosts$myPosts$edges$node$spot(
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

class _CopyWithStubImpl$Query$MyPosts$myPosts$edges$node$spot<TRes>
    implements CopyWith$Query$MyPosts$myPosts$edges$node$spot<TRes> {
  _CopyWithStubImpl$Query$MyPosts$myPosts$edges$node$spot(this._res);

  TRes _res;

  call({
    String? id,
    String? title,
    String? thumbnailImageUrl,
    Enum$TargetCategory? category,
  }) => _res;
}

class Query$MyPosts$myPosts$edges$node$author {
  Query$MyPosts$myPosts$edges$node$author({
    required this.id,
    required this.nickname,
    this.profileImageUrl,
  });

  factory Query$MyPosts$myPosts$edges$node$author.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$nickname = json['nickname'];
    final l$profileImageUrl = json['profileImageUrl'];
    return Query$MyPosts$myPosts$edges$node$author(
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
    if (other is! Query$MyPosts$myPosts$edges$node$author ||
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

extension UtilityExtension$Query$MyPosts$myPosts$edges$node$author
    on Query$MyPosts$myPosts$edges$node$author {
  CopyWith$Query$MyPosts$myPosts$edges$node$author<
    Query$MyPosts$myPosts$edges$node$author
  >
  get copyWith =>
      CopyWith$Query$MyPosts$myPosts$edges$node$author(this, (i) => i);
}

abstract class CopyWith$Query$MyPosts$myPosts$edges$node$author<TRes> {
  factory CopyWith$Query$MyPosts$myPosts$edges$node$author(
    Query$MyPosts$myPosts$edges$node$author instance,
    TRes Function(Query$MyPosts$myPosts$edges$node$author) then,
  ) = _CopyWithImpl$Query$MyPosts$myPosts$edges$node$author;

  factory CopyWith$Query$MyPosts$myPosts$edges$node$author.stub(TRes res) =
      _CopyWithStubImpl$Query$MyPosts$myPosts$edges$node$author;

  TRes call({String? id, String? nickname, String? profileImageUrl});
}

class _CopyWithImpl$Query$MyPosts$myPosts$edges$node$author<TRes>
    implements CopyWith$Query$MyPosts$myPosts$edges$node$author<TRes> {
  _CopyWithImpl$Query$MyPosts$myPosts$edges$node$author(
    this._instance,
    this._then,
  );

  final Query$MyPosts$myPosts$edges$node$author _instance;

  final TRes Function(Query$MyPosts$myPosts$edges$node$author) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? nickname = _undefined,
    Object? profileImageUrl = _undefined,
  }) => _then(
    Query$MyPosts$myPosts$edges$node$author(
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

class _CopyWithStubImpl$Query$MyPosts$myPosts$edges$node$author<TRes>
    implements CopyWith$Query$MyPosts$myPosts$edges$node$author<TRes> {
  _CopyWithStubImpl$Query$MyPosts$myPosts$edges$node$author(this._res);

  TRes _res;

  call({String? id, String? nickname, String? profileImageUrl}) => _res;
}

class Query$MyPosts$myPosts$pageInfo {
  Query$MyPosts$myPosts$pageInfo({required this.hasNextPage, this.endCursor});

  factory Query$MyPosts$myPosts$pageInfo.fromJson(Map<String, dynamic> json) {
    final l$hasNextPage = json['hasNextPage'];
    final l$endCursor = json['endCursor'];
    return Query$MyPosts$myPosts$pageInfo(
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
    if (other is! Query$MyPosts$myPosts$pageInfo ||
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

extension UtilityExtension$Query$MyPosts$myPosts$pageInfo
    on Query$MyPosts$myPosts$pageInfo {
  CopyWith$Query$MyPosts$myPosts$pageInfo<Query$MyPosts$myPosts$pageInfo>
  get copyWith => CopyWith$Query$MyPosts$myPosts$pageInfo(this, (i) => i);
}

abstract class CopyWith$Query$MyPosts$myPosts$pageInfo<TRes> {
  factory CopyWith$Query$MyPosts$myPosts$pageInfo(
    Query$MyPosts$myPosts$pageInfo instance,
    TRes Function(Query$MyPosts$myPosts$pageInfo) then,
  ) = _CopyWithImpl$Query$MyPosts$myPosts$pageInfo;

  factory CopyWith$Query$MyPosts$myPosts$pageInfo.stub(TRes res) =
      _CopyWithStubImpl$Query$MyPosts$myPosts$pageInfo;

  TRes call({bool? hasNextPage, String? endCursor});
}

class _CopyWithImpl$Query$MyPosts$myPosts$pageInfo<TRes>
    implements CopyWith$Query$MyPosts$myPosts$pageInfo<TRes> {
  _CopyWithImpl$Query$MyPosts$myPosts$pageInfo(this._instance, this._then);

  final Query$MyPosts$myPosts$pageInfo _instance;

  final TRes Function(Query$MyPosts$myPosts$pageInfo) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? hasNextPage = _undefined,
    Object? endCursor = _undefined,
  }) => _then(
    Query$MyPosts$myPosts$pageInfo(
      hasNextPage: hasNextPage == _undefined || hasNextPage == null
          ? _instance.hasNextPage
          : (hasNextPage as bool),
      endCursor: endCursor == _undefined
          ? _instance.endCursor
          : (endCursor as String?),
    ),
  );
}

class _CopyWithStubImpl$Query$MyPosts$myPosts$pageInfo<TRes>
    implements CopyWith$Query$MyPosts$myPosts$pageInfo<TRes> {
  _CopyWithStubImpl$Query$MyPosts$myPosts$pageInfo(this._res);

  TRes _res;

  call({bool? hasNextPage, String? endCursor}) => _res;
}

class Variables$Mutation$ChangeNickname {
  factory Variables$Mutation$ChangeNickname({
    required Input$ChangeNicknameInput input,
  }) => Variables$Mutation$ChangeNickname._({r'input': input});

  Variables$Mutation$ChangeNickname._(this._$data);

  factory Variables$Mutation$ChangeNickname.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    final l$input = data['input'];
    result$data['input'] = Input$ChangeNicknameInput.fromJson(
      (l$input as Map<String, dynamic>),
    );
    return Variables$Mutation$ChangeNickname._(result$data);
  }

  Map<String, dynamic> _$data;

  Input$ChangeNicknameInput get input =>
      (_$data['input'] as Input$ChangeNicknameInput);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$input = input;
    result$data['input'] = l$input.toJson();
    return result$data;
  }

  CopyWith$Variables$Mutation$ChangeNickname<Variables$Mutation$ChangeNickname>
  get copyWith => CopyWith$Variables$Mutation$ChangeNickname(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Mutation$ChangeNickname ||
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

abstract class CopyWith$Variables$Mutation$ChangeNickname<TRes> {
  factory CopyWith$Variables$Mutation$ChangeNickname(
    Variables$Mutation$ChangeNickname instance,
    TRes Function(Variables$Mutation$ChangeNickname) then,
  ) = _CopyWithImpl$Variables$Mutation$ChangeNickname;

  factory CopyWith$Variables$Mutation$ChangeNickname.stub(TRes res) =
      _CopyWithStubImpl$Variables$Mutation$ChangeNickname;

  TRes call({Input$ChangeNicknameInput? input});
}

class _CopyWithImpl$Variables$Mutation$ChangeNickname<TRes>
    implements CopyWith$Variables$Mutation$ChangeNickname<TRes> {
  _CopyWithImpl$Variables$Mutation$ChangeNickname(this._instance, this._then);

  final Variables$Mutation$ChangeNickname _instance;

  final TRes Function(Variables$Mutation$ChangeNickname) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? input = _undefined}) => _then(
    Variables$Mutation$ChangeNickname._({
      ..._instance._$data,
      if (input != _undefined && input != null)
        'input': (input as Input$ChangeNicknameInput),
    }),
  );
}

class _CopyWithStubImpl$Variables$Mutation$ChangeNickname<TRes>
    implements CopyWith$Variables$Mutation$ChangeNickname<TRes> {
  _CopyWithStubImpl$Variables$Mutation$ChangeNickname(this._res);

  TRes _res;

  call({Input$ChangeNicknameInput? input}) => _res;
}

class Mutation$ChangeNickname {
  Mutation$ChangeNickname({required this.changeNickname});

  factory Mutation$ChangeNickname.fromJson(Map<String, dynamic> json) {
    final l$changeNickname = json['changeNickname'];
    return Mutation$ChangeNickname(
      changeNickname: Mutation$ChangeNickname$changeNickname.fromJson(
        (l$changeNickname as Map<String, dynamic>),
      ),
    );
  }

  final Mutation$ChangeNickname$changeNickname changeNickname;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$changeNickname = changeNickname;
    _resultData['changeNickname'] = l$changeNickname.toJson();
    return _resultData;
  }

  @override
  int get hashCode {
    final l$changeNickname = changeNickname;
    return Object.hashAll([l$changeNickname]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$ChangeNickname || runtimeType != other.runtimeType) {
      return false;
    }
    final l$changeNickname = changeNickname;
    final lOther$changeNickname = other.changeNickname;
    if (l$changeNickname != lOther$changeNickname) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Mutation$ChangeNickname on Mutation$ChangeNickname {
  CopyWith$Mutation$ChangeNickname<Mutation$ChangeNickname> get copyWith =>
      CopyWith$Mutation$ChangeNickname(this, (i) => i);
}

abstract class CopyWith$Mutation$ChangeNickname<TRes> {
  factory CopyWith$Mutation$ChangeNickname(
    Mutation$ChangeNickname instance,
    TRes Function(Mutation$ChangeNickname) then,
  ) = _CopyWithImpl$Mutation$ChangeNickname;

  factory CopyWith$Mutation$ChangeNickname.stub(TRes res) =
      _CopyWithStubImpl$Mutation$ChangeNickname;

  TRes call({Mutation$ChangeNickname$changeNickname? changeNickname});
  CopyWith$Mutation$ChangeNickname$changeNickname<TRes> get changeNickname;
}

class _CopyWithImpl$Mutation$ChangeNickname<TRes>
    implements CopyWith$Mutation$ChangeNickname<TRes> {
  _CopyWithImpl$Mutation$ChangeNickname(this._instance, this._then);

  final Mutation$ChangeNickname _instance;

  final TRes Function(Mutation$ChangeNickname) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? changeNickname = _undefined}) => _then(
    Mutation$ChangeNickname(
      changeNickname: changeNickname == _undefined || changeNickname == null
          ? _instance.changeNickname
          : (changeNickname as Mutation$ChangeNickname$changeNickname),
    ),
  );

  CopyWith$Mutation$ChangeNickname$changeNickname<TRes> get changeNickname {
    final local$changeNickname = _instance.changeNickname;
    return CopyWith$Mutation$ChangeNickname$changeNickname(
      local$changeNickname,
      (e) => call(changeNickname: e),
    );
  }
}

class _CopyWithStubImpl$Mutation$ChangeNickname<TRes>
    implements CopyWith$Mutation$ChangeNickname<TRes> {
  _CopyWithStubImpl$Mutation$ChangeNickname(this._res);

  TRes _res;

  call({Mutation$ChangeNickname$changeNickname? changeNickname}) => _res;

  CopyWith$Mutation$ChangeNickname$changeNickname<TRes> get changeNickname =>
      CopyWith$Mutation$ChangeNickname$changeNickname.stub(_res);
}

const documentNodeMutationChangeNickname = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'ChangeNickname'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'input')),
          type: NamedTypeNode(
            name: NameNode(value: 'ChangeNicknameInput'),
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
            name: NameNode(value: 'changeNickname'),
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
                  name: NameNode(value: 'nickname'),
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

class Mutation$ChangeNickname$changeNickname {
  Mutation$ChangeNickname$changeNickname({
    required this.success,
    required this.userErrors,
    this.nickname,
  });

  factory Mutation$ChangeNickname$changeNickname.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$success = json['success'];
    final l$userErrors = json['userErrors'];
    final l$nickname = json['nickname'];
    return Mutation$ChangeNickname$changeNickname(
      success: (l$success as bool),
      userErrors: (l$userErrors as List<dynamic>)
          .map(
            (e) => Mutation$ChangeNickname$changeNickname$userErrors.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      nickname: (l$nickname as String?),
    );
  }

  final bool success;

  final List<Mutation$ChangeNickname$changeNickname$userErrors> userErrors;

  final String? nickname;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$success = success;
    _resultData['success'] = l$success;
    final l$userErrors = userErrors;
    _resultData['userErrors'] = l$userErrors.map((e) => e.toJson()).toList();
    final l$nickname = nickname;
    _resultData['nickname'] = l$nickname;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$success = success;
    final l$userErrors = userErrors;
    final l$nickname = nickname;
    return Object.hashAll([
      l$success,
      Object.hashAll(l$userErrors.map((v) => v)),
      l$nickname,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$ChangeNickname$changeNickname ||
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
    final l$nickname = nickname;
    final lOther$nickname = other.nickname;
    if (l$nickname != lOther$nickname) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Mutation$ChangeNickname$changeNickname
    on Mutation$ChangeNickname$changeNickname {
  CopyWith$Mutation$ChangeNickname$changeNickname<
    Mutation$ChangeNickname$changeNickname
  >
  get copyWith =>
      CopyWith$Mutation$ChangeNickname$changeNickname(this, (i) => i);
}

abstract class CopyWith$Mutation$ChangeNickname$changeNickname<TRes> {
  factory CopyWith$Mutation$ChangeNickname$changeNickname(
    Mutation$ChangeNickname$changeNickname instance,
    TRes Function(Mutation$ChangeNickname$changeNickname) then,
  ) = _CopyWithImpl$Mutation$ChangeNickname$changeNickname;

  factory CopyWith$Mutation$ChangeNickname$changeNickname.stub(TRes res) =
      _CopyWithStubImpl$Mutation$ChangeNickname$changeNickname;

  TRes call({
    bool? success,
    List<Mutation$ChangeNickname$changeNickname$userErrors>? userErrors,
    String? nickname,
  });
  TRes userErrors(
    Iterable<Mutation$ChangeNickname$changeNickname$userErrors> Function(
      Iterable<
        CopyWith$Mutation$ChangeNickname$changeNickname$userErrors<
          Mutation$ChangeNickname$changeNickname$userErrors
        >
      >,
    )
    _fn,
  );
}

class _CopyWithImpl$Mutation$ChangeNickname$changeNickname<TRes>
    implements CopyWith$Mutation$ChangeNickname$changeNickname<TRes> {
  _CopyWithImpl$Mutation$ChangeNickname$changeNickname(
    this._instance,
    this._then,
  );

  final Mutation$ChangeNickname$changeNickname _instance;

  final TRes Function(Mutation$ChangeNickname$changeNickname) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? success = _undefined,
    Object? userErrors = _undefined,
    Object? nickname = _undefined,
  }) => _then(
    Mutation$ChangeNickname$changeNickname(
      success: success == _undefined || success == null
          ? _instance.success
          : (success as bool),
      userErrors: userErrors == _undefined || userErrors == null
          ? _instance.userErrors
          : (userErrors
                as List<Mutation$ChangeNickname$changeNickname$userErrors>),
      nickname: nickname == _undefined
          ? _instance.nickname
          : (nickname as String?),
    ),
  );

  TRes userErrors(
    Iterable<Mutation$ChangeNickname$changeNickname$userErrors> Function(
      Iterable<
        CopyWith$Mutation$ChangeNickname$changeNickname$userErrors<
          Mutation$ChangeNickname$changeNickname$userErrors
        >
      >,
    )
    _fn,
  ) => call(
    userErrors: _fn(
      _instance.userErrors.map(
        (e) => CopyWith$Mutation$ChangeNickname$changeNickname$userErrors(
          e,
          (i) => i,
        ),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl$Mutation$ChangeNickname$changeNickname<TRes>
    implements CopyWith$Mutation$ChangeNickname$changeNickname<TRes> {
  _CopyWithStubImpl$Mutation$ChangeNickname$changeNickname(this._res);

  TRes _res;

  call({
    bool? success,
    List<Mutation$ChangeNickname$changeNickname$userErrors>? userErrors,
    String? nickname,
  }) => _res;

  userErrors(_fn) => _res;
}

class Mutation$ChangeNickname$changeNickname$userErrors {
  Mutation$ChangeNickname$changeNickname$userErrors({
    required this.code,
    required this.message,
    this.field,
  });

  factory Mutation$ChangeNickname$changeNickname$userErrors.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$code = json['code'];
    final l$message = json['message'];
    final l$field = json['field'];
    return Mutation$ChangeNickname$changeNickname$userErrors(
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
    if (other is! Mutation$ChangeNickname$changeNickname$userErrors ||
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

extension UtilityExtension$Mutation$ChangeNickname$changeNickname$userErrors
    on Mutation$ChangeNickname$changeNickname$userErrors {
  CopyWith$Mutation$ChangeNickname$changeNickname$userErrors<
    Mutation$ChangeNickname$changeNickname$userErrors
  >
  get copyWith => CopyWith$Mutation$ChangeNickname$changeNickname$userErrors(
    this,
    (i) => i,
  );
}

abstract class CopyWith$Mutation$ChangeNickname$changeNickname$userErrors<
  TRes
> {
  factory CopyWith$Mutation$ChangeNickname$changeNickname$userErrors(
    Mutation$ChangeNickname$changeNickname$userErrors instance,
    TRes Function(Mutation$ChangeNickname$changeNickname$userErrors) then,
  ) = _CopyWithImpl$Mutation$ChangeNickname$changeNickname$userErrors;

  factory CopyWith$Mutation$ChangeNickname$changeNickname$userErrors.stub(
    TRes res,
  ) = _CopyWithStubImpl$Mutation$ChangeNickname$changeNickname$userErrors;

  TRes call({String? code, String? message, String? field});
}

class _CopyWithImpl$Mutation$ChangeNickname$changeNickname$userErrors<TRes>
    implements
        CopyWith$Mutation$ChangeNickname$changeNickname$userErrors<TRes> {
  _CopyWithImpl$Mutation$ChangeNickname$changeNickname$userErrors(
    this._instance,
    this._then,
  );

  final Mutation$ChangeNickname$changeNickname$userErrors _instance;

  final TRes Function(Mutation$ChangeNickname$changeNickname$userErrors) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? code = _undefined,
    Object? message = _undefined,
    Object? field = _undefined,
  }) => _then(
    Mutation$ChangeNickname$changeNickname$userErrors(
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

class _CopyWithStubImpl$Mutation$ChangeNickname$changeNickname$userErrors<TRes>
    implements
        CopyWith$Mutation$ChangeNickname$changeNickname$userErrors<TRes> {
  _CopyWithStubImpl$Mutation$ChangeNickname$changeNickname$userErrors(
    this._res,
  );

  TRes _res;

  call({String? code, String? message, String? field}) => _res;
}

class Variables$Mutation$CreateProfileImageUploadUrl {
  factory Variables$Mutation$CreateProfileImageUploadUrl({
    required Input$CreateProfileImageUploadUrlInput input,
  }) => Variables$Mutation$CreateProfileImageUploadUrl._({r'input': input});

  Variables$Mutation$CreateProfileImageUploadUrl._(this._$data);

  factory Variables$Mutation$CreateProfileImageUploadUrl.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    final l$input = data['input'];
    result$data['input'] = Input$CreateProfileImageUploadUrlInput.fromJson(
      (l$input as Map<String, dynamic>),
    );
    return Variables$Mutation$CreateProfileImageUploadUrl._(result$data);
  }

  Map<String, dynamic> _$data;

  Input$CreateProfileImageUploadUrlInput get input =>
      (_$data['input'] as Input$CreateProfileImageUploadUrlInput);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$input = input;
    result$data['input'] = l$input.toJson();
    return result$data;
  }

  CopyWith$Variables$Mutation$CreateProfileImageUploadUrl<
    Variables$Mutation$CreateProfileImageUploadUrl
  >
  get copyWith =>
      CopyWith$Variables$Mutation$CreateProfileImageUploadUrl(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Mutation$CreateProfileImageUploadUrl ||
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

abstract class CopyWith$Variables$Mutation$CreateProfileImageUploadUrl<TRes> {
  factory CopyWith$Variables$Mutation$CreateProfileImageUploadUrl(
    Variables$Mutation$CreateProfileImageUploadUrl instance,
    TRes Function(Variables$Mutation$CreateProfileImageUploadUrl) then,
  ) = _CopyWithImpl$Variables$Mutation$CreateProfileImageUploadUrl;

  factory CopyWith$Variables$Mutation$CreateProfileImageUploadUrl.stub(
    TRes res,
  ) = _CopyWithStubImpl$Variables$Mutation$CreateProfileImageUploadUrl;

  TRes call({Input$CreateProfileImageUploadUrlInput? input});
}

class _CopyWithImpl$Variables$Mutation$CreateProfileImageUploadUrl<TRes>
    implements CopyWith$Variables$Mutation$CreateProfileImageUploadUrl<TRes> {
  _CopyWithImpl$Variables$Mutation$CreateProfileImageUploadUrl(
    this._instance,
    this._then,
  );

  final Variables$Mutation$CreateProfileImageUploadUrl _instance;

  final TRes Function(Variables$Mutation$CreateProfileImageUploadUrl) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? input = _undefined}) => _then(
    Variables$Mutation$CreateProfileImageUploadUrl._({
      ..._instance._$data,
      if (input != _undefined && input != null)
        'input': (input as Input$CreateProfileImageUploadUrlInput),
    }),
  );
}

class _CopyWithStubImpl$Variables$Mutation$CreateProfileImageUploadUrl<TRes>
    implements CopyWith$Variables$Mutation$CreateProfileImageUploadUrl<TRes> {
  _CopyWithStubImpl$Variables$Mutation$CreateProfileImageUploadUrl(this._res);

  TRes _res;

  call({Input$CreateProfileImageUploadUrlInput? input}) => _res;
}

class Mutation$CreateProfileImageUploadUrl {
  Mutation$CreateProfileImageUploadUrl({
    required this.createProfileImageUploadUrl,
  });

  factory Mutation$CreateProfileImageUploadUrl.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$createProfileImageUploadUrl = json['createProfileImageUploadUrl'];
    return Mutation$CreateProfileImageUploadUrl(
      createProfileImageUploadUrl:
          Mutation$CreateProfileImageUploadUrl$createProfileImageUploadUrl.fromJson(
            (l$createProfileImageUploadUrl as Map<String, dynamic>),
          ),
    );
  }

  final Mutation$CreateProfileImageUploadUrl$createProfileImageUploadUrl
  createProfileImageUploadUrl;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$createProfileImageUploadUrl = createProfileImageUploadUrl;
    _resultData['createProfileImageUploadUrl'] = l$createProfileImageUploadUrl
        .toJson();
    return _resultData;
  }

  @override
  int get hashCode {
    final l$createProfileImageUploadUrl = createProfileImageUploadUrl;
    return Object.hashAll([l$createProfileImageUploadUrl]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$CreateProfileImageUploadUrl ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$createProfileImageUploadUrl = createProfileImageUploadUrl;
    final lOther$createProfileImageUploadUrl =
        other.createProfileImageUploadUrl;
    if (l$createProfileImageUploadUrl != lOther$createProfileImageUploadUrl) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Mutation$CreateProfileImageUploadUrl
    on Mutation$CreateProfileImageUploadUrl {
  CopyWith$Mutation$CreateProfileImageUploadUrl<
    Mutation$CreateProfileImageUploadUrl
  >
  get copyWith => CopyWith$Mutation$CreateProfileImageUploadUrl(this, (i) => i);
}

abstract class CopyWith$Mutation$CreateProfileImageUploadUrl<TRes> {
  factory CopyWith$Mutation$CreateProfileImageUploadUrl(
    Mutation$CreateProfileImageUploadUrl instance,
    TRes Function(Mutation$CreateProfileImageUploadUrl) then,
  ) = _CopyWithImpl$Mutation$CreateProfileImageUploadUrl;

  factory CopyWith$Mutation$CreateProfileImageUploadUrl.stub(TRes res) =
      _CopyWithStubImpl$Mutation$CreateProfileImageUploadUrl;

  TRes call({
    Mutation$CreateProfileImageUploadUrl$createProfileImageUploadUrl?
    createProfileImageUploadUrl,
  });
  CopyWith$Mutation$CreateProfileImageUploadUrl$createProfileImageUploadUrl<
    TRes
  >
  get createProfileImageUploadUrl;
}

class _CopyWithImpl$Mutation$CreateProfileImageUploadUrl<TRes>
    implements CopyWith$Mutation$CreateProfileImageUploadUrl<TRes> {
  _CopyWithImpl$Mutation$CreateProfileImageUploadUrl(
    this._instance,
    this._then,
  );

  final Mutation$CreateProfileImageUploadUrl _instance;

  final TRes Function(Mutation$CreateProfileImageUploadUrl) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? createProfileImageUploadUrl = _undefined}) => _then(
    Mutation$CreateProfileImageUploadUrl(
      createProfileImageUploadUrl:
          createProfileImageUploadUrl == _undefined ||
              createProfileImageUploadUrl == null
          ? _instance.createProfileImageUploadUrl
          : (createProfileImageUploadUrl
                as Mutation$CreateProfileImageUploadUrl$createProfileImageUploadUrl),
    ),
  );

  CopyWith$Mutation$CreateProfileImageUploadUrl$createProfileImageUploadUrl<
    TRes
  >
  get createProfileImageUploadUrl {
    final local$createProfileImageUploadUrl =
        _instance.createProfileImageUploadUrl;
    return CopyWith$Mutation$CreateProfileImageUploadUrl$createProfileImageUploadUrl(
      local$createProfileImageUploadUrl,
      (e) => call(createProfileImageUploadUrl: e),
    );
  }
}

class _CopyWithStubImpl$Mutation$CreateProfileImageUploadUrl<TRes>
    implements CopyWith$Mutation$CreateProfileImageUploadUrl<TRes> {
  _CopyWithStubImpl$Mutation$CreateProfileImageUploadUrl(this._res);

  TRes _res;

  call({
    Mutation$CreateProfileImageUploadUrl$createProfileImageUploadUrl?
    createProfileImageUploadUrl,
  }) => _res;

  CopyWith$Mutation$CreateProfileImageUploadUrl$createProfileImageUploadUrl<
    TRes
  >
  get createProfileImageUploadUrl =>
      CopyWith$Mutation$CreateProfileImageUploadUrl$createProfileImageUploadUrl.stub(
        _res,
      );
}

const documentNodeMutationCreateProfileImageUploadUrl = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'CreateProfileImageUploadUrl'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'input')),
          type: NamedTypeNode(
            name: NameNode(value: 'CreateProfileImageUploadUrlInput'),
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
            name: NameNode(value: 'createProfileImageUploadUrl'),
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
);

class Mutation$CreateProfileImageUploadUrl$createProfileImageUploadUrl {
  Mutation$CreateProfileImageUploadUrl$createProfileImageUploadUrl({
    required this.success,
    required this.userErrors,
    this.uploadUrl,
    this.objectKey,
    this.expiresAt,
  });

  factory Mutation$CreateProfileImageUploadUrl$createProfileImageUploadUrl.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$success = json['success'];
    final l$userErrors = json['userErrors'];
    final l$uploadUrl = json['uploadUrl'];
    final l$objectKey = json['objectKey'];
    final l$expiresAt = json['expiresAt'];
    return Mutation$CreateProfileImageUploadUrl$createProfileImageUploadUrl(
      success: (l$success as bool),
      userErrors: (l$userErrors as List<dynamic>)
          .map(
            (e) =>
                Mutation$CreateProfileImageUploadUrl$createProfileImageUploadUrl$userErrors.fromJson(
                  (e as Map<String, dynamic>),
                ),
          )
          .toList(),
      uploadUrl: (l$uploadUrl as String?),
      objectKey: (l$objectKey as String?),
      expiresAt: (l$expiresAt as String?),
    );
  }

  final bool success;

  final List<
    Mutation$CreateProfileImageUploadUrl$createProfileImageUploadUrl$userErrors
  >
  userErrors;

  final String? uploadUrl;

  final String? objectKey;

  final String? expiresAt;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$success = success;
    _resultData['success'] = l$success;
    final l$userErrors = userErrors;
    _resultData['userErrors'] = l$userErrors.map((e) => e.toJson()).toList();
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
    final l$success = success;
    final l$userErrors = userErrors;
    final l$uploadUrl = uploadUrl;
    final l$objectKey = objectKey;
    final l$expiresAt = expiresAt;
    return Object.hashAll([
      l$success,
      Object.hashAll(l$userErrors.map((v) => v)),
      l$uploadUrl,
      l$objectKey,
      l$expiresAt,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Mutation$CreateProfileImageUploadUrl$createProfileImageUploadUrl ||
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

extension UtilityExtension$Mutation$CreateProfileImageUploadUrl$createProfileImageUploadUrl
    on Mutation$CreateProfileImageUploadUrl$createProfileImageUploadUrl {
  CopyWith$Mutation$CreateProfileImageUploadUrl$createProfileImageUploadUrl<
    Mutation$CreateProfileImageUploadUrl$createProfileImageUploadUrl
  >
  get copyWith =>
      CopyWith$Mutation$CreateProfileImageUploadUrl$createProfileImageUploadUrl(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Mutation$CreateProfileImageUploadUrl$createProfileImageUploadUrl<
  TRes
> {
  factory CopyWith$Mutation$CreateProfileImageUploadUrl$createProfileImageUploadUrl(
    Mutation$CreateProfileImageUploadUrl$createProfileImageUploadUrl instance,
    TRes Function(
      Mutation$CreateProfileImageUploadUrl$createProfileImageUploadUrl,
    )
    then,
  ) = _CopyWithImpl$Mutation$CreateProfileImageUploadUrl$createProfileImageUploadUrl;

  factory CopyWith$Mutation$CreateProfileImageUploadUrl$createProfileImageUploadUrl.stub(
    TRes res,
  ) = _CopyWithStubImpl$Mutation$CreateProfileImageUploadUrl$createProfileImageUploadUrl;

  TRes call({
    bool? success,
    List<
      Mutation$CreateProfileImageUploadUrl$createProfileImageUploadUrl$userErrors
    >?
    userErrors,
    String? uploadUrl,
    String? objectKey,
    String? expiresAt,
  });
  TRes userErrors(
    Iterable<
      Mutation$CreateProfileImageUploadUrl$createProfileImageUploadUrl$userErrors
    >
    Function(
      Iterable<
        CopyWith$Mutation$CreateProfileImageUploadUrl$createProfileImageUploadUrl$userErrors<
          Mutation$CreateProfileImageUploadUrl$createProfileImageUploadUrl$userErrors
        >
      >,
    )
    _fn,
  );
}

class _CopyWithImpl$Mutation$CreateProfileImageUploadUrl$createProfileImageUploadUrl<
  TRes
>
    implements
        CopyWith$Mutation$CreateProfileImageUploadUrl$createProfileImageUploadUrl<
          TRes
        > {
  _CopyWithImpl$Mutation$CreateProfileImageUploadUrl$createProfileImageUploadUrl(
    this._instance,
    this._then,
  );

  final Mutation$CreateProfileImageUploadUrl$createProfileImageUploadUrl
  _instance;

  final TRes Function(
    Mutation$CreateProfileImageUploadUrl$createProfileImageUploadUrl,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? success = _undefined,
    Object? userErrors = _undefined,
    Object? uploadUrl = _undefined,
    Object? objectKey = _undefined,
    Object? expiresAt = _undefined,
  }) => _then(
    Mutation$CreateProfileImageUploadUrl$createProfileImageUploadUrl(
      success: success == _undefined || success == null
          ? _instance.success
          : (success as bool),
      userErrors: userErrors == _undefined || userErrors == null
          ? _instance.userErrors
          : (userErrors
                as List<
                  Mutation$CreateProfileImageUploadUrl$createProfileImageUploadUrl$userErrors
                >),
      uploadUrl: uploadUrl == _undefined
          ? _instance.uploadUrl
          : (uploadUrl as String?),
      objectKey: objectKey == _undefined
          ? _instance.objectKey
          : (objectKey as String?),
      expiresAt: expiresAt == _undefined
          ? _instance.expiresAt
          : (expiresAt as String?),
    ),
  );

  TRes userErrors(
    Iterable<
      Mutation$CreateProfileImageUploadUrl$createProfileImageUploadUrl$userErrors
    >
    Function(
      Iterable<
        CopyWith$Mutation$CreateProfileImageUploadUrl$createProfileImageUploadUrl$userErrors<
          Mutation$CreateProfileImageUploadUrl$createProfileImageUploadUrl$userErrors
        >
      >,
    )
    _fn,
  ) => call(
    userErrors: _fn(
      _instance.userErrors.map(
        (e) =>
            CopyWith$Mutation$CreateProfileImageUploadUrl$createProfileImageUploadUrl$userErrors(
              e,
              (i) => i,
            ),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl$Mutation$CreateProfileImageUploadUrl$createProfileImageUploadUrl<
  TRes
>
    implements
        CopyWith$Mutation$CreateProfileImageUploadUrl$createProfileImageUploadUrl<
          TRes
        > {
  _CopyWithStubImpl$Mutation$CreateProfileImageUploadUrl$createProfileImageUploadUrl(
    this._res,
  );

  TRes _res;

  call({
    bool? success,
    List<
      Mutation$CreateProfileImageUploadUrl$createProfileImageUploadUrl$userErrors
    >?
    userErrors,
    String? uploadUrl,
    String? objectKey,
    String? expiresAt,
  }) => _res;

  userErrors(_fn) => _res;
}

class Mutation$CreateProfileImageUploadUrl$createProfileImageUploadUrl$userErrors {
  Mutation$CreateProfileImageUploadUrl$createProfileImageUploadUrl$userErrors({
    required this.code,
    required this.message,
    this.field,
  });

  factory Mutation$CreateProfileImageUploadUrl$createProfileImageUploadUrl$userErrors.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$code = json['code'];
    final l$message = json['message'];
    final l$field = json['field'];
    return Mutation$CreateProfileImageUploadUrl$createProfileImageUploadUrl$userErrors(
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
            is! Mutation$CreateProfileImageUploadUrl$createProfileImageUploadUrl$userErrors ||
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

extension UtilityExtension$Mutation$CreateProfileImageUploadUrl$createProfileImageUploadUrl$userErrors
    on Mutation$CreateProfileImageUploadUrl$createProfileImageUploadUrl$userErrors {
  CopyWith$Mutation$CreateProfileImageUploadUrl$createProfileImageUploadUrl$userErrors<
    Mutation$CreateProfileImageUploadUrl$createProfileImageUploadUrl$userErrors
  >
  get copyWith =>
      CopyWith$Mutation$CreateProfileImageUploadUrl$createProfileImageUploadUrl$userErrors(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Mutation$CreateProfileImageUploadUrl$createProfileImageUploadUrl$userErrors<
  TRes
> {
  factory CopyWith$Mutation$CreateProfileImageUploadUrl$createProfileImageUploadUrl$userErrors(
    Mutation$CreateProfileImageUploadUrl$createProfileImageUploadUrl$userErrors
    instance,
    TRes Function(
      Mutation$CreateProfileImageUploadUrl$createProfileImageUploadUrl$userErrors,
    )
    then,
  ) = _CopyWithImpl$Mutation$CreateProfileImageUploadUrl$createProfileImageUploadUrl$userErrors;

  factory CopyWith$Mutation$CreateProfileImageUploadUrl$createProfileImageUploadUrl$userErrors.stub(
    TRes res,
  ) = _CopyWithStubImpl$Mutation$CreateProfileImageUploadUrl$createProfileImageUploadUrl$userErrors;

  TRes call({String? code, String? message, String? field});
}

class _CopyWithImpl$Mutation$CreateProfileImageUploadUrl$createProfileImageUploadUrl$userErrors<
  TRes
>
    implements
        CopyWith$Mutation$CreateProfileImageUploadUrl$createProfileImageUploadUrl$userErrors<
          TRes
        > {
  _CopyWithImpl$Mutation$CreateProfileImageUploadUrl$createProfileImageUploadUrl$userErrors(
    this._instance,
    this._then,
  );

  final Mutation$CreateProfileImageUploadUrl$createProfileImageUploadUrl$userErrors
  _instance;

  final TRes Function(
    Mutation$CreateProfileImageUploadUrl$createProfileImageUploadUrl$userErrors,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? code = _undefined,
    Object? message = _undefined,
    Object? field = _undefined,
  }) => _then(
    Mutation$CreateProfileImageUploadUrl$createProfileImageUploadUrl$userErrors(
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

class _CopyWithStubImpl$Mutation$CreateProfileImageUploadUrl$createProfileImageUploadUrl$userErrors<
  TRes
>
    implements
        CopyWith$Mutation$CreateProfileImageUploadUrl$createProfileImageUploadUrl$userErrors<
          TRes
        > {
  _CopyWithStubImpl$Mutation$CreateProfileImageUploadUrl$createProfileImageUploadUrl$userErrors(
    this._res,
  );

  TRes _res;

  call({String? code, String? message, String? field}) => _res;
}

class Variables$Mutation$ConfirmProfileImageUpload {
  factory Variables$Mutation$ConfirmProfileImageUpload({
    required Input$ConfirmProfileImageUploadInput input,
  }) => Variables$Mutation$ConfirmProfileImageUpload._({r'input': input});

  Variables$Mutation$ConfirmProfileImageUpload._(this._$data);

  factory Variables$Mutation$ConfirmProfileImageUpload.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    final l$input = data['input'];
    result$data['input'] = Input$ConfirmProfileImageUploadInput.fromJson(
      (l$input as Map<String, dynamic>),
    );
    return Variables$Mutation$ConfirmProfileImageUpload._(result$data);
  }

  Map<String, dynamic> _$data;

  Input$ConfirmProfileImageUploadInput get input =>
      (_$data['input'] as Input$ConfirmProfileImageUploadInput);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$input = input;
    result$data['input'] = l$input.toJson();
    return result$data;
  }

  CopyWith$Variables$Mutation$ConfirmProfileImageUpload<
    Variables$Mutation$ConfirmProfileImageUpload
  >
  get copyWith =>
      CopyWith$Variables$Mutation$ConfirmProfileImageUpload(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Mutation$ConfirmProfileImageUpload ||
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

abstract class CopyWith$Variables$Mutation$ConfirmProfileImageUpload<TRes> {
  factory CopyWith$Variables$Mutation$ConfirmProfileImageUpload(
    Variables$Mutation$ConfirmProfileImageUpload instance,
    TRes Function(Variables$Mutation$ConfirmProfileImageUpload) then,
  ) = _CopyWithImpl$Variables$Mutation$ConfirmProfileImageUpload;

  factory CopyWith$Variables$Mutation$ConfirmProfileImageUpload.stub(TRes res) =
      _CopyWithStubImpl$Variables$Mutation$ConfirmProfileImageUpload;

  TRes call({Input$ConfirmProfileImageUploadInput? input});
}

class _CopyWithImpl$Variables$Mutation$ConfirmProfileImageUpload<TRes>
    implements CopyWith$Variables$Mutation$ConfirmProfileImageUpload<TRes> {
  _CopyWithImpl$Variables$Mutation$ConfirmProfileImageUpload(
    this._instance,
    this._then,
  );

  final Variables$Mutation$ConfirmProfileImageUpload _instance;

  final TRes Function(Variables$Mutation$ConfirmProfileImageUpload) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? input = _undefined}) => _then(
    Variables$Mutation$ConfirmProfileImageUpload._({
      ..._instance._$data,
      if (input != _undefined && input != null)
        'input': (input as Input$ConfirmProfileImageUploadInput),
    }),
  );
}

class _CopyWithStubImpl$Variables$Mutation$ConfirmProfileImageUpload<TRes>
    implements CopyWith$Variables$Mutation$ConfirmProfileImageUpload<TRes> {
  _CopyWithStubImpl$Variables$Mutation$ConfirmProfileImageUpload(this._res);

  TRes _res;

  call({Input$ConfirmProfileImageUploadInput? input}) => _res;
}

class Mutation$ConfirmProfileImageUpload {
  Mutation$ConfirmProfileImageUpload({required this.confirmProfileImageUpload});

  factory Mutation$ConfirmProfileImageUpload.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$confirmProfileImageUpload = json['confirmProfileImageUpload'];
    return Mutation$ConfirmProfileImageUpload(
      confirmProfileImageUpload:
          Mutation$ConfirmProfileImageUpload$confirmProfileImageUpload.fromJson(
            (l$confirmProfileImageUpload as Map<String, dynamic>),
          ),
    );
  }

  final Mutation$ConfirmProfileImageUpload$confirmProfileImageUpload
  confirmProfileImageUpload;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$confirmProfileImageUpload = confirmProfileImageUpload;
    _resultData['confirmProfileImageUpload'] = l$confirmProfileImageUpload
        .toJson();
    return _resultData;
  }

  @override
  int get hashCode {
    final l$confirmProfileImageUpload = confirmProfileImageUpload;
    return Object.hashAll([l$confirmProfileImageUpload]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$ConfirmProfileImageUpload ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$confirmProfileImageUpload = confirmProfileImageUpload;
    final lOther$confirmProfileImageUpload = other.confirmProfileImageUpload;
    if (l$confirmProfileImageUpload != lOther$confirmProfileImageUpload) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Mutation$ConfirmProfileImageUpload
    on Mutation$ConfirmProfileImageUpload {
  CopyWith$Mutation$ConfirmProfileImageUpload<
    Mutation$ConfirmProfileImageUpload
  >
  get copyWith => CopyWith$Mutation$ConfirmProfileImageUpload(this, (i) => i);
}

abstract class CopyWith$Mutation$ConfirmProfileImageUpload<TRes> {
  factory CopyWith$Mutation$ConfirmProfileImageUpload(
    Mutation$ConfirmProfileImageUpload instance,
    TRes Function(Mutation$ConfirmProfileImageUpload) then,
  ) = _CopyWithImpl$Mutation$ConfirmProfileImageUpload;

  factory CopyWith$Mutation$ConfirmProfileImageUpload.stub(TRes res) =
      _CopyWithStubImpl$Mutation$ConfirmProfileImageUpload;

  TRes call({
    Mutation$ConfirmProfileImageUpload$confirmProfileImageUpload?
    confirmProfileImageUpload,
  });
  CopyWith$Mutation$ConfirmProfileImageUpload$confirmProfileImageUpload<TRes>
  get confirmProfileImageUpload;
}

class _CopyWithImpl$Mutation$ConfirmProfileImageUpload<TRes>
    implements CopyWith$Mutation$ConfirmProfileImageUpload<TRes> {
  _CopyWithImpl$Mutation$ConfirmProfileImageUpload(this._instance, this._then);

  final Mutation$ConfirmProfileImageUpload _instance;

  final TRes Function(Mutation$ConfirmProfileImageUpload) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? confirmProfileImageUpload = _undefined}) => _then(
    Mutation$ConfirmProfileImageUpload(
      confirmProfileImageUpload:
          confirmProfileImageUpload == _undefined ||
              confirmProfileImageUpload == null
          ? _instance.confirmProfileImageUpload
          : (confirmProfileImageUpload
                as Mutation$ConfirmProfileImageUpload$confirmProfileImageUpload),
    ),
  );

  CopyWith$Mutation$ConfirmProfileImageUpload$confirmProfileImageUpload<TRes>
  get confirmProfileImageUpload {
    final local$confirmProfileImageUpload = _instance.confirmProfileImageUpload;
    return CopyWith$Mutation$ConfirmProfileImageUpload$confirmProfileImageUpload(
      local$confirmProfileImageUpload,
      (e) => call(confirmProfileImageUpload: e),
    );
  }
}

class _CopyWithStubImpl$Mutation$ConfirmProfileImageUpload<TRes>
    implements CopyWith$Mutation$ConfirmProfileImageUpload<TRes> {
  _CopyWithStubImpl$Mutation$ConfirmProfileImageUpload(this._res);

  TRes _res;

  call({
    Mutation$ConfirmProfileImageUpload$confirmProfileImageUpload?
    confirmProfileImageUpload,
  }) => _res;

  CopyWith$Mutation$ConfirmProfileImageUpload$confirmProfileImageUpload<TRes>
  get confirmProfileImageUpload =>
      CopyWith$Mutation$ConfirmProfileImageUpload$confirmProfileImageUpload.stub(
        _res,
      );
}

const documentNodeMutationConfirmProfileImageUpload = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'ConfirmProfileImageUpload'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'input')),
          type: NamedTypeNode(
            name: NameNode(value: 'ConfirmProfileImageUploadInput'),
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
            name: NameNode(value: 'confirmProfileImageUpload'),
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
                  name: NameNode(value: 'profileImageKey'),
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

class Mutation$ConfirmProfileImageUpload$confirmProfileImageUpload {
  Mutation$ConfirmProfileImageUpload$confirmProfileImageUpload({
    required this.success,
    required this.userErrors,
    this.profileImageKey,
  });

  factory Mutation$ConfirmProfileImageUpload$confirmProfileImageUpload.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$success = json['success'];
    final l$userErrors = json['userErrors'];
    final l$profileImageKey = json['profileImageKey'];
    return Mutation$ConfirmProfileImageUpload$confirmProfileImageUpload(
      success: (l$success as bool),
      userErrors: (l$userErrors as List<dynamic>)
          .map(
            (e) =>
                Mutation$ConfirmProfileImageUpload$confirmProfileImageUpload$userErrors.fromJson(
                  (e as Map<String, dynamic>),
                ),
          )
          .toList(),
      profileImageKey: (l$profileImageKey as String?),
    );
  }

  final bool success;

  final List<
    Mutation$ConfirmProfileImageUpload$confirmProfileImageUpload$userErrors
  >
  userErrors;

  final String? profileImageKey;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$success = success;
    _resultData['success'] = l$success;
    final l$userErrors = userErrors;
    _resultData['userErrors'] = l$userErrors.map((e) => e.toJson()).toList();
    final l$profileImageKey = profileImageKey;
    _resultData['profileImageKey'] = l$profileImageKey;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$success = success;
    final l$userErrors = userErrors;
    final l$profileImageKey = profileImageKey;
    return Object.hashAll([
      l$success,
      Object.hashAll(l$userErrors.map((v) => v)),
      l$profileImageKey,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Mutation$ConfirmProfileImageUpload$confirmProfileImageUpload ||
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
    final l$profileImageKey = profileImageKey;
    final lOther$profileImageKey = other.profileImageKey;
    if (l$profileImageKey != lOther$profileImageKey) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Mutation$ConfirmProfileImageUpload$confirmProfileImageUpload
    on Mutation$ConfirmProfileImageUpload$confirmProfileImageUpload {
  CopyWith$Mutation$ConfirmProfileImageUpload$confirmProfileImageUpload<
    Mutation$ConfirmProfileImageUpload$confirmProfileImageUpload
  >
  get copyWith =>
      CopyWith$Mutation$ConfirmProfileImageUpload$confirmProfileImageUpload(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Mutation$ConfirmProfileImageUpload$confirmProfileImageUpload<
  TRes
> {
  factory CopyWith$Mutation$ConfirmProfileImageUpload$confirmProfileImageUpload(
    Mutation$ConfirmProfileImageUpload$confirmProfileImageUpload instance,
    TRes Function(Mutation$ConfirmProfileImageUpload$confirmProfileImageUpload)
    then,
  ) = _CopyWithImpl$Mutation$ConfirmProfileImageUpload$confirmProfileImageUpload;

  factory CopyWith$Mutation$ConfirmProfileImageUpload$confirmProfileImageUpload.stub(
    TRes res,
  ) = _CopyWithStubImpl$Mutation$ConfirmProfileImageUpload$confirmProfileImageUpload;

  TRes call({
    bool? success,
    List<
      Mutation$ConfirmProfileImageUpload$confirmProfileImageUpload$userErrors
    >?
    userErrors,
    String? profileImageKey,
  });
  TRes userErrors(
    Iterable<
      Mutation$ConfirmProfileImageUpload$confirmProfileImageUpload$userErrors
    >
    Function(
      Iterable<
        CopyWith$Mutation$ConfirmProfileImageUpload$confirmProfileImageUpload$userErrors<
          Mutation$ConfirmProfileImageUpload$confirmProfileImageUpload$userErrors
        >
      >,
    )
    _fn,
  );
}

class _CopyWithImpl$Mutation$ConfirmProfileImageUpload$confirmProfileImageUpload<
  TRes
>
    implements
        CopyWith$Mutation$ConfirmProfileImageUpload$confirmProfileImageUpload<
          TRes
        > {
  _CopyWithImpl$Mutation$ConfirmProfileImageUpload$confirmProfileImageUpload(
    this._instance,
    this._then,
  );

  final Mutation$ConfirmProfileImageUpload$confirmProfileImageUpload _instance;

  final TRes Function(
    Mutation$ConfirmProfileImageUpload$confirmProfileImageUpload,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? success = _undefined,
    Object? userErrors = _undefined,
    Object? profileImageKey = _undefined,
  }) => _then(
    Mutation$ConfirmProfileImageUpload$confirmProfileImageUpload(
      success: success == _undefined || success == null
          ? _instance.success
          : (success as bool),
      userErrors: userErrors == _undefined || userErrors == null
          ? _instance.userErrors
          : (userErrors
                as List<
                  Mutation$ConfirmProfileImageUpload$confirmProfileImageUpload$userErrors
                >),
      profileImageKey: profileImageKey == _undefined
          ? _instance.profileImageKey
          : (profileImageKey as String?),
    ),
  );

  TRes userErrors(
    Iterable<
      Mutation$ConfirmProfileImageUpload$confirmProfileImageUpload$userErrors
    >
    Function(
      Iterable<
        CopyWith$Mutation$ConfirmProfileImageUpload$confirmProfileImageUpload$userErrors<
          Mutation$ConfirmProfileImageUpload$confirmProfileImageUpload$userErrors
        >
      >,
    )
    _fn,
  ) => call(
    userErrors: _fn(
      _instance.userErrors.map(
        (e) =>
            CopyWith$Mutation$ConfirmProfileImageUpload$confirmProfileImageUpload$userErrors(
              e,
              (i) => i,
            ),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl$Mutation$ConfirmProfileImageUpload$confirmProfileImageUpload<
  TRes
>
    implements
        CopyWith$Mutation$ConfirmProfileImageUpload$confirmProfileImageUpload<
          TRes
        > {
  _CopyWithStubImpl$Mutation$ConfirmProfileImageUpload$confirmProfileImageUpload(
    this._res,
  );

  TRes _res;

  call({
    bool? success,
    List<
      Mutation$ConfirmProfileImageUpload$confirmProfileImageUpload$userErrors
    >?
    userErrors,
    String? profileImageKey,
  }) => _res;

  userErrors(_fn) => _res;
}

class Mutation$ConfirmProfileImageUpload$confirmProfileImageUpload$userErrors {
  Mutation$ConfirmProfileImageUpload$confirmProfileImageUpload$userErrors({
    required this.code,
    required this.message,
    this.field,
  });

  factory Mutation$ConfirmProfileImageUpload$confirmProfileImageUpload$userErrors.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$code = json['code'];
    final l$message = json['message'];
    final l$field = json['field'];
    return Mutation$ConfirmProfileImageUpload$confirmProfileImageUpload$userErrors(
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
            is! Mutation$ConfirmProfileImageUpload$confirmProfileImageUpload$userErrors ||
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

extension UtilityExtension$Mutation$ConfirmProfileImageUpload$confirmProfileImageUpload$userErrors
    on Mutation$ConfirmProfileImageUpload$confirmProfileImageUpload$userErrors {
  CopyWith$Mutation$ConfirmProfileImageUpload$confirmProfileImageUpload$userErrors<
    Mutation$ConfirmProfileImageUpload$confirmProfileImageUpload$userErrors
  >
  get copyWith =>
      CopyWith$Mutation$ConfirmProfileImageUpload$confirmProfileImageUpload$userErrors(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Mutation$ConfirmProfileImageUpload$confirmProfileImageUpload$userErrors<
  TRes
> {
  factory CopyWith$Mutation$ConfirmProfileImageUpload$confirmProfileImageUpload$userErrors(
    Mutation$ConfirmProfileImageUpload$confirmProfileImageUpload$userErrors
    instance,
    TRes Function(
      Mutation$ConfirmProfileImageUpload$confirmProfileImageUpload$userErrors,
    )
    then,
  ) = _CopyWithImpl$Mutation$ConfirmProfileImageUpload$confirmProfileImageUpload$userErrors;

  factory CopyWith$Mutation$ConfirmProfileImageUpload$confirmProfileImageUpload$userErrors.stub(
    TRes res,
  ) = _CopyWithStubImpl$Mutation$ConfirmProfileImageUpload$confirmProfileImageUpload$userErrors;

  TRes call({String? code, String? message, String? field});
}

class _CopyWithImpl$Mutation$ConfirmProfileImageUpload$confirmProfileImageUpload$userErrors<
  TRes
>
    implements
        CopyWith$Mutation$ConfirmProfileImageUpload$confirmProfileImageUpload$userErrors<
          TRes
        > {
  _CopyWithImpl$Mutation$ConfirmProfileImageUpload$confirmProfileImageUpload$userErrors(
    this._instance,
    this._then,
  );

  final Mutation$ConfirmProfileImageUpload$confirmProfileImageUpload$userErrors
  _instance;

  final TRes Function(
    Mutation$ConfirmProfileImageUpload$confirmProfileImageUpload$userErrors,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? code = _undefined,
    Object? message = _undefined,
    Object? field = _undefined,
  }) => _then(
    Mutation$ConfirmProfileImageUpload$confirmProfileImageUpload$userErrors(
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

class _CopyWithStubImpl$Mutation$ConfirmProfileImageUpload$confirmProfileImageUpload$userErrors<
  TRes
>
    implements
        CopyWith$Mutation$ConfirmProfileImageUpload$confirmProfileImageUpload$userErrors<
          TRes
        > {
  _CopyWithStubImpl$Mutation$ConfirmProfileImageUpload$confirmProfileImageUpload$userErrors(
    this._res,
  );

  TRes _res;

  call({String? code, String? message, String? field}) => _res;
}

class Mutation$RemoveProfileImage {
  Mutation$RemoveProfileImage({required this.removeProfileImage});

  factory Mutation$RemoveProfileImage.fromJson(Map<String, dynamic> json) {
    final l$removeProfileImage = json['removeProfileImage'];
    return Mutation$RemoveProfileImage(
      removeProfileImage:
          Mutation$RemoveProfileImage$removeProfileImage.fromJson(
            (l$removeProfileImage as Map<String, dynamic>),
          ),
    );
  }

  final Mutation$RemoveProfileImage$removeProfileImage removeProfileImage;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$removeProfileImage = removeProfileImage;
    _resultData['removeProfileImage'] = l$removeProfileImage.toJson();
    return _resultData;
  }

  @override
  int get hashCode {
    final l$removeProfileImage = removeProfileImage;
    return Object.hashAll([l$removeProfileImage]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$RemoveProfileImage ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$removeProfileImage = removeProfileImage;
    final lOther$removeProfileImage = other.removeProfileImage;
    if (l$removeProfileImage != lOther$removeProfileImage) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Mutation$RemoveProfileImage
    on Mutation$RemoveProfileImage {
  CopyWith$Mutation$RemoveProfileImage<Mutation$RemoveProfileImage>
  get copyWith => CopyWith$Mutation$RemoveProfileImage(this, (i) => i);
}

abstract class CopyWith$Mutation$RemoveProfileImage<TRes> {
  factory CopyWith$Mutation$RemoveProfileImage(
    Mutation$RemoveProfileImage instance,
    TRes Function(Mutation$RemoveProfileImage) then,
  ) = _CopyWithImpl$Mutation$RemoveProfileImage;

  factory CopyWith$Mutation$RemoveProfileImage.stub(TRes res) =
      _CopyWithStubImpl$Mutation$RemoveProfileImage;

  TRes call({
    Mutation$RemoveProfileImage$removeProfileImage? removeProfileImage,
  });
  CopyWith$Mutation$RemoveProfileImage$removeProfileImage<TRes>
  get removeProfileImage;
}

class _CopyWithImpl$Mutation$RemoveProfileImage<TRes>
    implements CopyWith$Mutation$RemoveProfileImage<TRes> {
  _CopyWithImpl$Mutation$RemoveProfileImage(this._instance, this._then);

  final Mutation$RemoveProfileImage _instance;

  final TRes Function(Mutation$RemoveProfileImage) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? removeProfileImage = _undefined}) => _then(
    Mutation$RemoveProfileImage(
      removeProfileImage:
          removeProfileImage == _undefined || removeProfileImage == null
          ? _instance.removeProfileImage
          : (removeProfileImage
                as Mutation$RemoveProfileImage$removeProfileImage),
    ),
  );

  CopyWith$Mutation$RemoveProfileImage$removeProfileImage<TRes>
  get removeProfileImage {
    final local$removeProfileImage = _instance.removeProfileImage;
    return CopyWith$Mutation$RemoveProfileImage$removeProfileImage(
      local$removeProfileImage,
      (e) => call(removeProfileImage: e),
    );
  }
}

class _CopyWithStubImpl$Mutation$RemoveProfileImage<TRes>
    implements CopyWith$Mutation$RemoveProfileImage<TRes> {
  _CopyWithStubImpl$Mutation$RemoveProfileImage(this._res);

  TRes _res;

  call({Mutation$RemoveProfileImage$removeProfileImage? removeProfileImage}) =>
      _res;

  CopyWith$Mutation$RemoveProfileImage$removeProfileImage<TRes>
  get removeProfileImage =>
      CopyWith$Mutation$RemoveProfileImage$removeProfileImage.stub(_res);
}

const documentNodeMutationRemoveProfileImage = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'RemoveProfileImage'),
      variableDefinitions: [],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'removeProfileImage'),
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
              ],
            ),
          ),
        ],
      ),
    ),
  ],
);

class Mutation$RemoveProfileImage$removeProfileImage {
  Mutation$RemoveProfileImage$removeProfileImage({
    required this.success,
    required this.userErrors,
  });

  factory Mutation$RemoveProfileImage$removeProfileImage.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$success = json['success'];
    final l$userErrors = json['userErrors'];
    return Mutation$RemoveProfileImage$removeProfileImage(
      success: (l$success as bool),
      userErrors: (l$userErrors as List<dynamic>)
          .map(
            (e) =>
                Mutation$RemoveProfileImage$removeProfileImage$userErrors.fromJson(
                  (e as Map<String, dynamic>),
                ),
          )
          .toList(),
    );
  }

  final bool success;

  final List<Mutation$RemoveProfileImage$removeProfileImage$userErrors>
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
    if (other is! Mutation$RemoveProfileImage$removeProfileImage ||
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

extension UtilityExtension$Mutation$RemoveProfileImage$removeProfileImage
    on Mutation$RemoveProfileImage$removeProfileImage {
  CopyWith$Mutation$RemoveProfileImage$removeProfileImage<
    Mutation$RemoveProfileImage$removeProfileImage
  >
  get copyWith =>
      CopyWith$Mutation$RemoveProfileImage$removeProfileImage(this, (i) => i);
}

abstract class CopyWith$Mutation$RemoveProfileImage$removeProfileImage<TRes> {
  factory CopyWith$Mutation$RemoveProfileImage$removeProfileImage(
    Mutation$RemoveProfileImage$removeProfileImage instance,
    TRes Function(Mutation$RemoveProfileImage$removeProfileImage) then,
  ) = _CopyWithImpl$Mutation$RemoveProfileImage$removeProfileImage;

  factory CopyWith$Mutation$RemoveProfileImage$removeProfileImage.stub(
    TRes res,
  ) = _CopyWithStubImpl$Mutation$RemoveProfileImage$removeProfileImage;

  TRes call({
    bool? success,
    List<Mutation$RemoveProfileImage$removeProfileImage$userErrors>? userErrors,
  });
  TRes userErrors(
    Iterable<Mutation$RemoveProfileImage$removeProfileImage$userErrors>
    Function(
      Iterable<
        CopyWith$Mutation$RemoveProfileImage$removeProfileImage$userErrors<
          Mutation$RemoveProfileImage$removeProfileImage$userErrors
        >
      >,
    )
    _fn,
  );
}

class _CopyWithImpl$Mutation$RemoveProfileImage$removeProfileImage<TRes>
    implements CopyWith$Mutation$RemoveProfileImage$removeProfileImage<TRes> {
  _CopyWithImpl$Mutation$RemoveProfileImage$removeProfileImage(
    this._instance,
    this._then,
  );

  final Mutation$RemoveProfileImage$removeProfileImage _instance;

  final TRes Function(Mutation$RemoveProfileImage$removeProfileImage) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? success = _undefined, Object? userErrors = _undefined}) =>
      _then(
        Mutation$RemoveProfileImage$removeProfileImage(
          success: success == _undefined || success == null
              ? _instance.success
              : (success as bool),
          userErrors: userErrors == _undefined || userErrors == null
              ? _instance.userErrors
              : (userErrors
                    as List<
                      Mutation$RemoveProfileImage$removeProfileImage$userErrors
                    >),
        ),
      );

  TRes userErrors(
    Iterable<Mutation$RemoveProfileImage$removeProfileImage$userErrors>
    Function(
      Iterable<
        CopyWith$Mutation$RemoveProfileImage$removeProfileImage$userErrors<
          Mutation$RemoveProfileImage$removeProfileImage$userErrors
        >
      >,
    )
    _fn,
  ) => call(
    userErrors: _fn(
      _instance.userErrors.map(
        (e) =>
            CopyWith$Mutation$RemoveProfileImage$removeProfileImage$userErrors(
              e,
              (i) => i,
            ),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl$Mutation$RemoveProfileImage$removeProfileImage<TRes>
    implements CopyWith$Mutation$RemoveProfileImage$removeProfileImage<TRes> {
  _CopyWithStubImpl$Mutation$RemoveProfileImage$removeProfileImage(this._res);

  TRes _res;

  call({
    bool? success,
    List<Mutation$RemoveProfileImage$removeProfileImage$userErrors>? userErrors,
  }) => _res;

  userErrors(_fn) => _res;
}

class Mutation$RemoveProfileImage$removeProfileImage$userErrors {
  Mutation$RemoveProfileImage$removeProfileImage$userErrors({
    required this.code,
    required this.message,
    this.field,
  });

  factory Mutation$RemoveProfileImage$removeProfileImage$userErrors.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$code = json['code'];
    final l$message = json['message'];
    final l$field = json['field'];
    return Mutation$RemoveProfileImage$removeProfileImage$userErrors(
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
    if (other is! Mutation$RemoveProfileImage$removeProfileImage$userErrors ||
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

extension UtilityExtension$Mutation$RemoveProfileImage$removeProfileImage$userErrors
    on Mutation$RemoveProfileImage$removeProfileImage$userErrors {
  CopyWith$Mutation$RemoveProfileImage$removeProfileImage$userErrors<
    Mutation$RemoveProfileImage$removeProfileImage$userErrors
  >
  get copyWith =>
      CopyWith$Mutation$RemoveProfileImage$removeProfileImage$userErrors(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Mutation$RemoveProfileImage$removeProfileImage$userErrors<
  TRes
> {
  factory CopyWith$Mutation$RemoveProfileImage$removeProfileImage$userErrors(
    Mutation$RemoveProfileImage$removeProfileImage$userErrors instance,
    TRes Function(Mutation$RemoveProfileImage$removeProfileImage$userErrors)
    then,
  ) = _CopyWithImpl$Mutation$RemoveProfileImage$removeProfileImage$userErrors;

  factory CopyWith$Mutation$RemoveProfileImage$removeProfileImage$userErrors.stub(
    TRes res,
  ) = _CopyWithStubImpl$Mutation$RemoveProfileImage$removeProfileImage$userErrors;

  TRes call({String? code, String? message, String? field});
}

class _CopyWithImpl$Mutation$RemoveProfileImage$removeProfileImage$userErrors<
  TRes
>
    implements
        CopyWith$Mutation$RemoveProfileImage$removeProfileImage$userErrors<
          TRes
        > {
  _CopyWithImpl$Mutation$RemoveProfileImage$removeProfileImage$userErrors(
    this._instance,
    this._then,
  );

  final Mutation$RemoveProfileImage$removeProfileImage$userErrors _instance;

  final TRes Function(Mutation$RemoveProfileImage$removeProfileImage$userErrors)
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? code = _undefined,
    Object? message = _undefined,
    Object? field = _undefined,
  }) => _then(
    Mutation$RemoveProfileImage$removeProfileImage$userErrors(
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

class _CopyWithStubImpl$Mutation$RemoveProfileImage$removeProfileImage$userErrors<
  TRes
>
    implements
        CopyWith$Mutation$RemoveProfileImage$removeProfileImage$userErrors<
          TRes
        > {
  _CopyWithStubImpl$Mutation$RemoveProfileImage$removeProfileImage$userErrors(
    this._res,
  );

  TRes _res;

  call({String? code, String? message, String? field}) => _res;
}
