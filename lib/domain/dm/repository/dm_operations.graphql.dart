// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, unused_element
import '../../community/repository/community_schema.graphql.dart';
import 'package:gql/ast.dart';

class Fragment$DmAuthorParts {
  Fragment$DmAuthorParts({
    required this.id,
    required this.nickname,
    this.profileImageUrl,
  });

  factory Fragment$DmAuthorParts.fromJson(Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$nickname = json['nickname'];
    final l$profileImageUrl = json['profileImageUrl'];
    return Fragment$DmAuthorParts(
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
    if (other is! Fragment$DmAuthorParts || runtimeType != other.runtimeType) {
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

extension UtilityExtension$Fragment$DmAuthorParts on Fragment$DmAuthorParts {
  CopyWith$Fragment$DmAuthorParts<Fragment$DmAuthorParts> get copyWith =>
      CopyWith$Fragment$DmAuthorParts(this, (i) => i);
}

abstract class CopyWith$Fragment$DmAuthorParts<TRes> {
  factory CopyWith$Fragment$DmAuthorParts(
    Fragment$DmAuthorParts instance,
    TRes Function(Fragment$DmAuthorParts) then,
  ) = _CopyWithImpl$Fragment$DmAuthorParts;

  factory CopyWith$Fragment$DmAuthorParts.stub(TRes res) =
      _CopyWithStubImpl$Fragment$DmAuthorParts;

  TRes call({String? id, String? nickname, String? profileImageUrl});
}

class _CopyWithImpl$Fragment$DmAuthorParts<TRes>
    implements CopyWith$Fragment$DmAuthorParts<TRes> {
  _CopyWithImpl$Fragment$DmAuthorParts(this._instance, this._then);

  final Fragment$DmAuthorParts _instance;

  final TRes Function(Fragment$DmAuthorParts) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? nickname = _undefined,
    Object? profileImageUrl = _undefined,
  }) => _then(
    Fragment$DmAuthorParts(
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

class _CopyWithStubImpl$Fragment$DmAuthorParts<TRes>
    implements CopyWith$Fragment$DmAuthorParts<TRes> {
  _CopyWithStubImpl$Fragment$DmAuthorParts(this._res);

  TRes _res;

  call({String? id, String? nickname, String? profileImageUrl}) => _res;
}

const fragmentDefinitionDmAuthorParts = FragmentDefinitionNode(
  name: NameNode(value: 'DmAuthorParts'),
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
const documentNodeFragmentDmAuthorParts = DocumentNode(
  definitions: [fragmentDefinitionDmAuthorParts],
);

class Fragment$MessageParts {
  Fragment$MessageParts({
    required this.id,
    required this.body,
    this.photoKey,
    required this.sender,
    required this.ownedByViewer,
    required this.createdAt,
  });

  factory Fragment$MessageParts.fromJson(Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$body = json['body'];
    final l$photoKey = json['photoKey'];
    final l$sender = json['sender'];
    final l$ownedByViewer = json['ownedByViewer'];
    final l$createdAt = json['createdAt'];
    return Fragment$MessageParts(
      id: (l$id as String),
      body: (l$body as String),
      photoKey: (l$photoKey as String?),
      sender: Fragment$DmAuthorParts.fromJson(
        (l$sender as Map<String, dynamic>),
      ),
      ownedByViewer: (l$ownedByViewer as bool),
      createdAt: (l$createdAt as String),
    );
  }

  final String id;

  final String body;

  final String? photoKey;

  final Fragment$DmAuthorParts sender;

  final bool ownedByViewer;

  final String createdAt;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$body = body;
    _resultData['body'] = l$body;
    final l$photoKey = photoKey;
    _resultData['photoKey'] = l$photoKey;
    final l$sender = sender;
    _resultData['sender'] = l$sender.toJson();
    final l$ownedByViewer = ownedByViewer;
    _resultData['ownedByViewer'] = l$ownedByViewer;
    final l$createdAt = createdAt;
    _resultData['createdAt'] = l$createdAt;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$body = body;
    final l$photoKey = photoKey;
    final l$sender = sender;
    final l$ownedByViewer = ownedByViewer;
    final l$createdAt = createdAt;
    return Object.hashAll([
      l$id,
      l$body,
      l$photoKey,
      l$sender,
      l$ownedByViewer,
      l$createdAt,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment$MessageParts || runtimeType != other.runtimeType) {
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
    final l$photoKey = photoKey;
    final lOther$photoKey = other.photoKey;
    if (l$photoKey != lOther$photoKey) {
      return false;
    }
    final l$sender = sender;
    final lOther$sender = other.sender;
    if (l$sender != lOther$sender) {
      return false;
    }
    final l$ownedByViewer = ownedByViewer;
    final lOther$ownedByViewer = other.ownedByViewer;
    if (l$ownedByViewer != lOther$ownedByViewer) {
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

extension UtilityExtension$Fragment$MessageParts on Fragment$MessageParts {
  CopyWith$Fragment$MessageParts<Fragment$MessageParts> get copyWith =>
      CopyWith$Fragment$MessageParts(this, (i) => i);
}

abstract class CopyWith$Fragment$MessageParts<TRes> {
  factory CopyWith$Fragment$MessageParts(
    Fragment$MessageParts instance,
    TRes Function(Fragment$MessageParts) then,
  ) = _CopyWithImpl$Fragment$MessageParts;

  factory CopyWith$Fragment$MessageParts.stub(TRes res) =
      _CopyWithStubImpl$Fragment$MessageParts;

  TRes call({
    String? id,
    String? body,
    String? photoKey,
    Fragment$DmAuthorParts? sender,
    bool? ownedByViewer,
    String? createdAt,
  });
  CopyWith$Fragment$DmAuthorParts<TRes> get sender;
}

class _CopyWithImpl$Fragment$MessageParts<TRes>
    implements CopyWith$Fragment$MessageParts<TRes> {
  _CopyWithImpl$Fragment$MessageParts(this._instance, this._then);

  final Fragment$MessageParts _instance;

  final TRes Function(Fragment$MessageParts) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? body = _undefined,
    Object? photoKey = _undefined,
    Object? sender = _undefined,
    Object? ownedByViewer = _undefined,
    Object? createdAt = _undefined,
  }) => _then(
    Fragment$MessageParts(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      body: body == _undefined || body == null
          ? _instance.body
          : (body as String),
      photoKey: photoKey == _undefined
          ? _instance.photoKey
          : (photoKey as String?),
      sender: sender == _undefined || sender == null
          ? _instance.sender
          : (sender as Fragment$DmAuthorParts),
      ownedByViewer: ownedByViewer == _undefined || ownedByViewer == null
          ? _instance.ownedByViewer
          : (ownedByViewer as bool),
      createdAt: createdAt == _undefined || createdAt == null
          ? _instance.createdAt
          : (createdAt as String),
    ),
  );

  CopyWith$Fragment$DmAuthorParts<TRes> get sender {
    final local$sender = _instance.sender;
    return CopyWith$Fragment$DmAuthorParts(
      local$sender,
      (e) => call(sender: e),
    );
  }
}

class _CopyWithStubImpl$Fragment$MessageParts<TRes>
    implements CopyWith$Fragment$MessageParts<TRes> {
  _CopyWithStubImpl$Fragment$MessageParts(this._res);

  TRes _res;

  call({
    String? id,
    String? body,
    String? photoKey,
    Fragment$DmAuthorParts? sender,
    bool? ownedByViewer,
    String? createdAt,
  }) => _res;

  CopyWith$Fragment$DmAuthorParts<TRes> get sender =>
      CopyWith$Fragment$DmAuthorParts.stub(_res);
}

const fragmentDefinitionMessageParts = FragmentDefinitionNode(
  name: NameNode(value: 'MessageParts'),
  typeCondition: TypeConditionNode(
    on: NamedTypeNode(name: NameNode(value: 'Message'), isNonNull: false),
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
        name: NameNode(value: 'photoKey'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'sender'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: SelectionSetNode(
          selections: [
            FragmentSpreadNode(
              name: NameNode(value: 'DmAuthorParts'),
              directives: [],
            ),
          ],
        ),
      ),
      FieldNode(
        name: NameNode(value: 'ownedByViewer'),
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
const documentNodeFragmentMessageParts = DocumentNode(
  definitions: [
    fragmentDefinitionMessageParts,
    fragmentDefinitionDmAuthorParts,
  ],
);

class Fragment$ConversationParts {
  Fragment$ConversationParts({
    required this.id,
    required this.counterpart,
    this.lastMessage,
    required this.unreadCount,
    required this.updatedAt,
  });

  factory Fragment$ConversationParts.fromJson(Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$counterpart = json['counterpart'];
    final l$lastMessage = json['lastMessage'];
    final l$unreadCount = json['unreadCount'];
    final l$updatedAt = json['updatedAt'];
    return Fragment$ConversationParts(
      id: (l$id as String),
      counterpart: Fragment$DmAuthorParts.fromJson(
        (l$counterpart as Map<String, dynamic>),
      ),
      lastMessage: l$lastMessage == null
          ? null
          : Fragment$MessageParts.fromJson(
              (l$lastMessage as Map<String, dynamic>),
            ),
      unreadCount: (l$unreadCount as int),
      updatedAt: (l$updatedAt as String),
    );
  }

  final String id;

  final Fragment$DmAuthorParts counterpart;

  final Fragment$MessageParts? lastMessage;

  final int unreadCount;

  final String updatedAt;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$counterpart = counterpart;
    _resultData['counterpart'] = l$counterpart.toJson();
    final l$lastMessage = lastMessage;
    _resultData['lastMessage'] = l$lastMessage?.toJson();
    final l$unreadCount = unreadCount;
    _resultData['unreadCount'] = l$unreadCount;
    final l$updatedAt = updatedAt;
    _resultData['updatedAt'] = l$updatedAt;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$counterpart = counterpart;
    final l$lastMessage = lastMessage;
    final l$unreadCount = unreadCount;
    final l$updatedAt = updatedAt;
    return Object.hashAll([
      l$id,
      l$counterpart,
      l$lastMessage,
      l$unreadCount,
      l$updatedAt,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment$ConversationParts ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$counterpart = counterpart;
    final lOther$counterpart = other.counterpart;
    if (l$counterpart != lOther$counterpart) {
      return false;
    }
    final l$lastMessage = lastMessage;
    final lOther$lastMessage = other.lastMessage;
    if (l$lastMessage != lOther$lastMessage) {
      return false;
    }
    final l$unreadCount = unreadCount;
    final lOther$unreadCount = other.unreadCount;
    if (l$unreadCount != lOther$unreadCount) {
      return false;
    }
    final l$updatedAt = updatedAt;
    final lOther$updatedAt = other.updatedAt;
    if (l$updatedAt != lOther$updatedAt) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Fragment$ConversationParts
    on Fragment$ConversationParts {
  CopyWith$Fragment$ConversationParts<Fragment$ConversationParts>
  get copyWith => CopyWith$Fragment$ConversationParts(this, (i) => i);
}

abstract class CopyWith$Fragment$ConversationParts<TRes> {
  factory CopyWith$Fragment$ConversationParts(
    Fragment$ConversationParts instance,
    TRes Function(Fragment$ConversationParts) then,
  ) = _CopyWithImpl$Fragment$ConversationParts;

  factory CopyWith$Fragment$ConversationParts.stub(TRes res) =
      _CopyWithStubImpl$Fragment$ConversationParts;

  TRes call({
    String? id,
    Fragment$DmAuthorParts? counterpart,
    Fragment$MessageParts? lastMessage,
    int? unreadCount,
    String? updatedAt,
  });
  CopyWith$Fragment$DmAuthorParts<TRes> get counterpart;
  CopyWith$Fragment$MessageParts<TRes> get lastMessage;
}

class _CopyWithImpl$Fragment$ConversationParts<TRes>
    implements CopyWith$Fragment$ConversationParts<TRes> {
  _CopyWithImpl$Fragment$ConversationParts(this._instance, this._then);

  final Fragment$ConversationParts _instance;

  final TRes Function(Fragment$ConversationParts) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? counterpart = _undefined,
    Object? lastMessage = _undefined,
    Object? unreadCount = _undefined,
    Object? updatedAt = _undefined,
  }) => _then(
    Fragment$ConversationParts(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      counterpart: counterpart == _undefined || counterpart == null
          ? _instance.counterpart
          : (counterpart as Fragment$DmAuthorParts),
      lastMessage: lastMessage == _undefined
          ? _instance.lastMessage
          : (lastMessage as Fragment$MessageParts?),
      unreadCount: unreadCount == _undefined || unreadCount == null
          ? _instance.unreadCount
          : (unreadCount as int),
      updatedAt: updatedAt == _undefined || updatedAt == null
          ? _instance.updatedAt
          : (updatedAt as String),
    ),
  );

  CopyWith$Fragment$DmAuthorParts<TRes> get counterpart {
    final local$counterpart = _instance.counterpart;
    return CopyWith$Fragment$DmAuthorParts(
      local$counterpart,
      (e) => call(counterpart: e),
    );
  }

  CopyWith$Fragment$MessageParts<TRes> get lastMessage {
    final local$lastMessage = _instance.lastMessage;
    return local$lastMessage == null
        ? CopyWith$Fragment$MessageParts.stub(_then(_instance))
        : CopyWith$Fragment$MessageParts(
            local$lastMessage,
            (e) => call(lastMessage: e),
          );
  }
}

class _CopyWithStubImpl$Fragment$ConversationParts<TRes>
    implements CopyWith$Fragment$ConversationParts<TRes> {
  _CopyWithStubImpl$Fragment$ConversationParts(this._res);

  TRes _res;

  call({
    String? id,
    Fragment$DmAuthorParts? counterpart,
    Fragment$MessageParts? lastMessage,
    int? unreadCount,
    String? updatedAt,
  }) => _res;

  CopyWith$Fragment$DmAuthorParts<TRes> get counterpart =>
      CopyWith$Fragment$DmAuthorParts.stub(_res);

  CopyWith$Fragment$MessageParts<TRes> get lastMessage =>
      CopyWith$Fragment$MessageParts.stub(_res);
}

const fragmentDefinitionConversationParts = FragmentDefinitionNode(
  name: NameNode(value: 'ConversationParts'),
  typeCondition: TypeConditionNode(
    on: NamedTypeNode(name: NameNode(value: 'Conversation'), isNonNull: false),
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
        name: NameNode(value: 'counterpart'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: SelectionSetNode(
          selections: [
            FragmentSpreadNode(
              name: NameNode(value: 'DmAuthorParts'),
              directives: [],
            ),
          ],
        ),
      ),
      FieldNode(
        name: NameNode(value: 'lastMessage'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: SelectionSetNode(
          selections: [
            FragmentSpreadNode(
              name: NameNode(value: 'MessageParts'),
              directives: [],
            ),
          ],
        ),
      ),
      FieldNode(
        name: NameNode(value: 'unreadCount'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'updatedAt'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
    ],
  ),
);
const documentNodeFragmentConversationParts = DocumentNode(
  definitions: [
    fragmentDefinitionConversationParts,
    fragmentDefinitionDmAuthorParts,
    fragmentDefinitionMessageParts,
  ],
);

class Variables$Query$Conversations {
  factory Variables$Query$Conversations({int? first, String? after}) =>
      Variables$Query$Conversations._({
        if (first != null) r'first': first,
        if (after != null) r'after': after,
      });

  Variables$Query$Conversations._(this._$data);

  factory Variables$Query$Conversations.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    if (data.containsKey('first')) {
      final l$first = data['first'];
      result$data['first'] = (l$first as int?);
    }
    if (data.containsKey('after')) {
      final l$after = data['after'];
      result$data['after'] = (l$after as String?);
    }
    return Variables$Query$Conversations._(result$data);
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

  CopyWith$Variables$Query$Conversations<Variables$Query$Conversations>
  get copyWith => CopyWith$Variables$Query$Conversations(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Query$Conversations ||
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

abstract class CopyWith$Variables$Query$Conversations<TRes> {
  factory CopyWith$Variables$Query$Conversations(
    Variables$Query$Conversations instance,
    TRes Function(Variables$Query$Conversations) then,
  ) = _CopyWithImpl$Variables$Query$Conversations;

  factory CopyWith$Variables$Query$Conversations.stub(TRes res) =
      _CopyWithStubImpl$Variables$Query$Conversations;

  TRes call({int? first, String? after});
}

class _CopyWithImpl$Variables$Query$Conversations<TRes>
    implements CopyWith$Variables$Query$Conversations<TRes> {
  _CopyWithImpl$Variables$Query$Conversations(this._instance, this._then);

  final Variables$Query$Conversations _instance;

  final TRes Function(Variables$Query$Conversations) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? first = _undefined, Object? after = _undefined}) => _then(
    Variables$Query$Conversations._({
      ..._instance._$data,
      if (first != _undefined) 'first': (first as int?),
      if (after != _undefined) 'after': (after as String?),
    }),
  );
}

class _CopyWithStubImpl$Variables$Query$Conversations<TRes>
    implements CopyWith$Variables$Query$Conversations<TRes> {
  _CopyWithStubImpl$Variables$Query$Conversations(this._res);

  TRes _res;

  call({int? first, String? after}) => _res;
}

class Query$Conversations {
  Query$Conversations({required this.conversations});

  factory Query$Conversations.fromJson(Map<String, dynamic> json) {
    final l$conversations = json['conversations'];
    return Query$Conversations(
      conversations: Query$Conversations$conversations.fromJson(
        (l$conversations as Map<String, dynamic>),
      ),
    );
  }

  final Query$Conversations$conversations conversations;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$conversations = conversations;
    _resultData['conversations'] = l$conversations.toJson();
    return _resultData;
  }

  @override
  int get hashCode {
    final l$conversations = conversations;
    return Object.hashAll([l$conversations]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$Conversations || runtimeType != other.runtimeType) {
      return false;
    }
    final l$conversations = conversations;
    final lOther$conversations = other.conversations;
    if (l$conversations != lOther$conversations) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Query$Conversations on Query$Conversations {
  CopyWith$Query$Conversations<Query$Conversations> get copyWith =>
      CopyWith$Query$Conversations(this, (i) => i);
}

abstract class CopyWith$Query$Conversations<TRes> {
  factory CopyWith$Query$Conversations(
    Query$Conversations instance,
    TRes Function(Query$Conversations) then,
  ) = _CopyWithImpl$Query$Conversations;

  factory CopyWith$Query$Conversations.stub(TRes res) =
      _CopyWithStubImpl$Query$Conversations;

  TRes call({Query$Conversations$conversations? conversations});
  CopyWith$Query$Conversations$conversations<TRes> get conversations;
}

class _CopyWithImpl$Query$Conversations<TRes>
    implements CopyWith$Query$Conversations<TRes> {
  _CopyWithImpl$Query$Conversations(this._instance, this._then);

  final Query$Conversations _instance;

  final TRes Function(Query$Conversations) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? conversations = _undefined}) => _then(
    Query$Conversations(
      conversations: conversations == _undefined || conversations == null
          ? _instance.conversations
          : (conversations as Query$Conversations$conversations),
    ),
  );

  CopyWith$Query$Conversations$conversations<TRes> get conversations {
    final local$conversations = _instance.conversations;
    return CopyWith$Query$Conversations$conversations(
      local$conversations,
      (e) => call(conversations: e),
    );
  }
}

class _CopyWithStubImpl$Query$Conversations<TRes>
    implements CopyWith$Query$Conversations<TRes> {
  _CopyWithStubImpl$Query$Conversations(this._res);

  TRes _res;

  call({Query$Conversations$conversations? conversations}) => _res;

  CopyWith$Query$Conversations$conversations<TRes> get conversations =>
      CopyWith$Query$Conversations$conversations.stub(_res);
}

const documentNodeQueryConversations = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'Conversations'),
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
            name: NameNode(value: 'conversations'),
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
                            FragmentSpreadNode(
                              name: NameNode(value: 'ConversationParts'),
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
    fragmentDefinitionConversationParts,
    fragmentDefinitionDmAuthorParts,
    fragmentDefinitionMessageParts,
  ],
);

class Query$Conversations$conversations {
  Query$Conversations$conversations({
    required this.edges,
    required this.pageInfo,
  });

  factory Query$Conversations$conversations.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$edges = json['edges'];
    final l$pageInfo = json['pageInfo'];
    return Query$Conversations$conversations(
      edges: (l$edges as List<dynamic>)
          .map(
            (e) => Query$Conversations$conversations$edges.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      pageInfo: Query$Conversations$conversations$pageInfo.fromJson(
        (l$pageInfo as Map<String, dynamic>),
      ),
    );
  }

  final List<Query$Conversations$conversations$edges> edges;

  final Query$Conversations$conversations$pageInfo pageInfo;

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
    if (other is! Query$Conversations$conversations ||
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

extension UtilityExtension$Query$Conversations$conversations
    on Query$Conversations$conversations {
  CopyWith$Query$Conversations$conversations<Query$Conversations$conversations>
  get copyWith => CopyWith$Query$Conversations$conversations(this, (i) => i);
}

abstract class CopyWith$Query$Conversations$conversations<TRes> {
  factory CopyWith$Query$Conversations$conversations(
    Query$Conversations$conversations instance,
    TRes Function(Query$Conversations$conversations) then,
  ) = _CopyWithImpl$Query$Conversations$conversations;

  factory CopyWith$Query$Conversations$conversations.stub(TRes res) =
      _CopyWithStubImpl$Query$Conversations$conversations;

  TRes call({
    List<Query$Conversations$conversations$edges>? edges,
    Query$Conversations$conversations$pageInfo? pageInfo,
  });
  TRes edges(
    Iterable<Query$Conversations$conversations$edges> Function(
      Iterable<
        CopyWith$Query$Conversations$conversations$edges<
          Query$Conversations$conversations$edges
        >
      >,
    )
    _fn,
  );
  CopyWith$Query$Conversations$conversations$pageInfo<TRes> get pageInfo;
}

class _CopyWithImpl$Query$Conversations$conversations<TRes>
    implements CopyWith$Query$Conversations$conversations<TRes> {
  _CopyWithImpl$Query$Conversations$conversations(this._instance, this._then);

  final Query$Conversations$conversations _instance;

  final TRes Function(Query$Conversations$conversations) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? edges = _undefined, Object? pageInfo = _undefined}) =>
      _then(
        Query$Conversations$conversations(
          edges: edges == _undefined || edges == null
              ? _instance.edges
              : (edges as List<Query$Conversations$conversations$edges>),
          pageInfo: pageInfo == _undefined || pageInfo == null
              ? _instance.pageInfo
              : (pageInfo as Query$Conversations$conversations$pageInfo),
        ),
      );

  TRes edges(
    Iterable<Query$Conversations$conversations$edges> Function(
      Iterable<
        CopyWith$Query$Conversations$conversations$edges<
          Query$Conversations$conversations$edges
        >
      >,
    )
    _fn,
  ) => call(
    edges: _fn(
      _instance.edges.map(
        (e) => CopyWith$Query$Conversations$conversations$edges(e, (i) => i),
      ),
    ).toList(),
  );

  CopyWith$Query$Conversations$conversations$pageInfo<TRes> get pageInfo {
    final local$pageInfo = _instance.pageInfo;
    return CopyWith$Query$Conversations$conversations$pageInfo(
      local$pageInfo,
      (e) => call(pageInfo: e),
    );
  }
}

class _CopyWithStubImpl$Query$Conversations$conversations<TRes>
    implements CopyWith$Query$Conversations$conversations<TRes> {
  _CopyWithStubImpl$Query$Conversations$conversations(this._res);

  TRes _res;

  call({
    List<Query$Conversations$conversations$edges>? edges,
    Query$Conversations$conversations$pageInfo? pageInfo,
  }) => _res;

  edges(_fn) => _res;

  CopyWith$Query$Conversations$conversations$pageInfo<TRes> get pageInfo =>
      CopyWith$Query$Conversations$conversations$pageInfo.stub(_res);
}

class Query$Conversations$conversations$edges {
  Query$Conversations$conversations$edges({
    required this.cursor,
    required this.node,
  });

  factory Query$Conversations$conversations$edges.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$cursor = json['cursor'];
    final l$node = json['node'];
    return Query$Conversations$conversations$edges(
      cursor: (l$cursor as String),
      node: Fragment$ConversationParts.fromJson(
        (l$node as Map<String, dynamic>),
      ),
    );
  }

  final String cursor;

  final Fragment$ConversationParts node;

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
    if (other is! Query$Conversations$conversations$edges ||
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

extension UtilityExtension$Query$Conversations$conversations$edges
    on Query$Conversations$conversations$edges {
  CopyWith$Query$Conversations$conversations$edges<
    Query$Conversations$conversations$edges
  >
  get copyWith =>
      CopyWith$Query$Conversations$conversations$edges(this, (i) => i);
}

abstract class CopyWith$Query$Conversations$conversations$edges<TRes> {
  factory CopyWith$Query$Conversations$conversations$edges(
    Query$Conversations$conversations$edges instance,
    TRes Function(Query$Conversations$conversations$edges) then,
  ) = _CopyWithImpl$Query$Conversations$conversations$edges;

  factory CopyWith$Query$Conversations$conversations$edges.stub(TRes res) =
      _CopyWithStubImpl$Query$Conversations$conversations$edges;

  TRes call({String? cursor, Fragment$ConversationParts? node});
  CopyWith$Fragment$ConversationParts<TRes> get node;
}

class _CopyWithImpl$Query$Conversations$conversations$edges<TRes>
    implements CopyWith$Query$Conversations$conversations$edges<TRes> {
  _CopyWithImpl$Query$Conversations$conversations$edges(
    this._instance,
    this._then,
  );

  final Query$Conversations$conversations$edges _instance;

  final TRes Function(Query$Conversations$conversations$edges) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? cursor = _undefined, Object? node = _undefined}) => _then(
    Query$Conversations$conversations$edges(
      cursor: cursor == _undefined || cursor == null
          ? _instance.cursor
          : (cursor as String),
      node: node == _undefined || node == null
          ? _instance.node
          : (node as Fragment$ConversationParts),
    ),
  );

  CopyWith$Fragment$ConversationParts<TRes> get node {
    final local$node = _instance.node;
    return CopyWith$Fragment$ConversationParts(
      local$node,
      (e) => call(node: e),
    );
  }
}

class _CopyWithStubImpl$Query$Conversations$conversations$edges<TRes>
    implements CopyWith$Query$Conversations$conversations$edges<TRes> {
  _CopyWithStubImpl$Query$Conversations$conversations$edges(this._res);

  TRes _res;

  call({String? cursor, Fragment$ConversationParts? node}) => _res;

  CopyWith$Fragment$ConversationParts<TRes> get node =>
      CopyWith$Fragment$ConversationParts.stub(_res);
}

class Query$Conversations$conversations$pageInfo {
  Query$Conversations$conversations$pageInfo({
    required this.hasNextPage,
    this.endCursor,
  });

  factory Query$Conversations$conversations$pageInfo.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$hasNextPage = json['hasNextPage'];
    final l$endCursor = json['endCursor'];
    return Query$Conversations$conversations$pageInfo(
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
    if (other is! Query$Conversations$conversations$pageInfo ||
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

extension UtilityExtension$Query$Conversations$conversations$pageInfo
    on Query$Conversations$conversations$pageInfo {
  CopyWith$Query$Conversations$conversations$pageInfo<
    Query$Conversations$conversations$pageInfo
  >
  get copyWith =>
      CopyWith$Query$Conversations$conversations$pageInfo(this, (i) => i);
}

abstract class CopyWith$Query$Conversations$conversations$pageInfo<TRes> {
  factory CopyWith$Query$Conversations$conversations$pageInfo(
    Query$Conversations$conversations$pageInfo instance,
    TRes Function(Query$Conversations$conversations$pageInfo) then,
  ) = _CopyWithImpl$Query$Conversations$conversations$pageInfo;

  factory CopyWith$Query$Conversations$conversations$pageInfo.stub(TRes res) =
      _CopyWithStubImpl$Query$Conversations$conversations$pageInfo;

  TRes call({bool? hasNextPage, String? endCursor});
}

class _CopyWithImpl$Query$Conversations$conversations$pageInfo<TRes>
    implements CopyWith$Query$Conversations$conversations$pageInfo<TRes> {
  _CopyWithImpl$Query$Conversations$conversations$pageInfo(
    this._instance,
    this._then,
  );

  final Query$Conversations$conversations$pageInfo _instance;

  final TRes Function(Query$Conversations$conversations$pageInfo) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? hasNextPage = _undefined,
    Object? endCursor = _undefined,
  }) => _then(
    Query$Conversations$conversations$pageInfo(
      hasNextPage: hasNextPage == _undefined || hasNextPage == null
          ? _instance.hasNextPage
          : (hasNextPage as bool),
      endCursor: endCursor == _undefined
          ? _instance.endCursor
          : (endCursor as String?),
    ),
  );
}

class _CopyWithStubImpl$Query$Conversations$conversations$pageInfo<TRes>
    implements CopyWith$Query$Conversations$conversations$pageInfo<TRes> {
  _CopyWithStubImpl$Query$Conversations$conversations$pageInfo(this._res);

  TRes _res;

  call({bool? hasNextPage, String? endCursor}) => _res;
}

class Variables$Query$ConversationMessages {
  factory Variables$Query$ConversationMessages({
    required String conversationId,
    int? first,
    String? after,
  }) => Variables$Query$ConversationMessages._({
    r'conversationId': conversationId,
    if (first != null) r'first': first,
    if (after != null) r'after': after,
  });

  Variables$Query$ConversationMessages._(this._$data);

  factory Variables$Query$ConversationMessages.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    final l$conversationId = data['conversationId'];
    result$data['conversationId'] = (l$conversationId as String);
    if (data.containsKey('first')) {
      final l$first = data['first'];
      result$data['first'] = (l$first as int?);
    }
    if (data.containsKey('after')) {
      final l$after = data['after'];
      result$data['after'] = (l$after as String?);
    }
    return Variables$Query$ConversationMessages._(result$data);
  }

  Map<String, dynamic> _$data;

  String get conversationId => (_$data['conversationId'] as String);

  int? get first => (_$data['first'] as int?);

  String? get after => (_$data['after'] as String?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$conversationId = conversationId;
    result$data['conversationId'] = l$conversationId;
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

  CopyWith$Variables$Query$ConversationMessages<
    Variables$Query$ConversationMessages
  >
  get copyWith => CopyWith$Variables$Query$ConversationMessages(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Query$ConversationMessages ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$conversationId = conversationId;
    final lOther$conversationId = other.conversationId;
    if (l$conversationId != lOther$conversationId) {
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
    final l$conversationId = conversationId;
    final l$first = first;
    final l$after = after;
    return Object.hashAll([
      l$conversationId,
      _$data.containsKey('first') ? l$first : const {},
      _$data.containsKey('after') ? l$after : const {},
    ]);
  }
}

abstract class CopyWith$Variables$Query$ConversationMessages<TRes> {
  factory CopyWith$Variables$Query$ConversationMessages(
    Variables$Query$ConversationMessages instance,
    TRes Function(Variables$Query$ConversationMessages) then,
  ) = _CopyWithImpl$Variables$Query$ConversationMessages;

  factory CopyWith$Variables$Query$ConversationMessages.stub(TRes res) =
      _CopyWithStubImpl$Variables$Query$ConversationMessages;

  TRes call({String? conversationId, int? first, String? after});
}

class _CopyWithImpl$Variables$Query$ConversationMessages<TRes>
    implements CopyWith$Variables$Query$ConversationMessages<TRes> {
  _CopyWithImpl$Variables$Query$ConversationMessages(
    this._instance,
    this._then,
  );

  final Variables$Query$ConversationMessages _instance;

  final TRes Function(Variables$Query$ConversationMessages) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? conversationId = _undefined,
    Object? first = _undefined,
    Object? after = _undefined,
  }) => _then(
    Variables$Query$ConversationMessages._({
      ..._instance._$data,
      if (conversationId != _undefined && conversationId != null)
        'conversationId': (conversationId as String),
      if (first != _undefined) 'first': (first as int?),
      if (after != _undefined) 'after': (after as String?),
    }),
  );
}

class _CopyWithStubImpl$Variables$Query$ConversationMessages<TRes>
    implements CopyWith$Variables$Query$ConversationMessages<TRes> {
  _CopyWithStubImpl$Variables$Query$ConversationMessages(this._res);

  TRes _res;

  call({String? conversationId, int? first, String? after}) => _res;
}

class Query$ConversationMessages {
  Query$ConversationMessages({required this.conversationMessages});

  factory Query$ConversationMessages.fromJson(Map<String, dynamic> json) {
    final l$conversationMessages = json['conversationMessages'];
    return Query$ConversationMessages(
      conversationMessages:
          Query$ConversationMessages$conversationMessages.fromJson(
            (l$conversationMessages as Map<String, dynamic>),
          ),
    );
  }

  final Query$ConversationMessages$conversationMessages conversationMessages;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$conversationMessages = conversationMessages;
    _resultData['conversationMessages'] = l$conversationMessages.toJson();
    return _resultData;
  }

  @override
  int get hashCode {
    final l$conversationMessages = conversationMessages;
    return Object.hashAll([l$conversationMessages]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$ConversationMessages ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$conversationMessages = conversationMessages;
    final lOther$conversationMessages = other.conversationMessages;
    if (l$conversationMessages != lOther$conversationMessages) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Query$ConversationMessages
    on Query$ConversationMessages {
  CopyWith$Query$ConversationMessages<Query$ConversationMessages>
  get copyWith => CopyWith$Query$ConversationMessages(this, (i) => i);
}

abstract class CopyWith$Query$ConversationMessages<TRes> {
  factory CopyWith$Query$ConversationMessages(
    Query$ConversationMessages instance,
    TRes Function(Query$ConversationMessages) then,
  ) = _CopyWithImpl$Query$ConversationMessages;

  factory CopyWith$Query$ConversationMessages.stub(TRes res) =
      _CopyWithStubImpl$Query$ConversationMessages;

  TRes call({
    Query$ConversationMessages$conversationMessages? conversationMessages,
  });
  CopyWith$Query$ConversationMessages$conversationMessages<TRes>
  get conversationMessages;
}

class _CopyWithImpl$Query$ConversationMessages<TRes>
    implements CopyWith$Query$ConversationMessages<TRes> {
  _CopyWithImpl$Query$ConversationMessages(this._instance, this._then);

  final Query$ConversationMessages _instance;

  final TRes Function(Query$ConversationMessages) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? conversationMessages = _undefined}) => _then(
    Query$ConversationMessages(
      conversationMessages:
          conversationMessages == _undefined || conversationMessages == null
          ? _instance.conversationMessages
          : (conversationMessages
                as Query$ConversationMessages$conversationMessages),
    ),
  );

  CopyWith$Query$ConversationMessages$conversationMessages<TRes>
  get conversationMessages {
    final local$conversationMessages = _instance.conversationMessages;
    return CopyWith$Query$ConversationMessages$conversationMessages(
      local$conversationMessages,
      (e) => call(conversationMessages: e),
    );
  }
}

class _CopyWithStubImpl$Query$ConversationMessages<TRes>
    implements CopyWith$Query$ConversationMessages<TRes> {
  _CopyWithStubImpl$Query$ConversationMessages(this._res);

  TRes _res;

  call({
    Query$ConversationMessages$conversationMessages? conversationMessages,
  }) => _res;

  CopyWith$Query$ConversationMessages$conversationMessages<TRes>
  get conversationMessages =>
      CopyWith$Query$ConversationMessages$conversationMessages.stub(_res);
}

const documentNodeQueryConversationMessages = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'ConversationMessages'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'conversationId')),
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
            name: NameNode(value: 'conversationMessages'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'conversationId'),
                value: VariableNode(name: NameNode(value: 'conversationId')),
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
                              name: NameNode(value: 'MessageParts'),
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
    fragmentDefinitionMessageParts,
    fragmentDefinitionDmAuthorParts,
  ],
);

class Query$ConversationMessages$conversationMessages {
  Query$ConversationMessages$conversationMessages({
    required this.edges,
    required this.pageInfo,
  });

  factory Query$ConversationMessages$conversationMessages.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$edges = json['edges'];
    final l$pageInfo = json['pageInfo'];
    return Query$ConversationMessages$conversationMessages(
      edges: (l$edges as List<dynamic>)
          .map(
            (e) =>
                Query$ConversationMessages$conversationMessages$edges.fromJson(
                  (e as Map<String, dynamic>),
                ),
          )
          .toList(),
      pageInfo:
          Query$ConversationMessages$conversationMessages$pageInfo.fromJson(
            (l$pageInfo as Map<String, dynamic>),
          ),
    );
  }

  final List<Query$ConversationMessages$conversationMessages$edges> edges;

  final Query$ConversationMessages$conversationMessages$pageInfo pageInfo;

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
    if (other is! Query$ConversationMessages$conversationMessages ||
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

extension UtilityExtension$Query$ConversationMessages$conversationMessages
    on Query$ConversationMessages$conversationMessages {
  CopyWith$Query$ConversationMessages$conversationMessages<
    Query$ConversationMessages$conversationMessages
  >
  get copyWith =>
      CopyWith$Query$ConversationMessages$conversationMessages(this, (i) => i);
}

abstract class CopyWith$Query$ConversationMessages$conversationMessages<TRes> {
  factory CopyWith$Query$ConversationMessages$conversationMessages(
    Query$ConversationMessages$conversationMessages instance,
    TRes Function(Query$ConversationMessages$conversationMessages) then,
  ) = _CopyWithImpl$Query$ConversationMessages$conversationMessages;

  factory CopyWith$Query$ConversationMessages$conversationMessages.stub(
    TRes res,
  ) = _CopyWithStubImpl$Query$ConversationMessages$conversationMessages;

  TRes call({
    List<Query$ConversationMessages$conversationMessages$edges>? edges,
    Query$ConversationMessages$conversationMessages$pageInfo? pageInfo,
  });
  TRes edges(
    Iterable<Query$ConversationMessages$conversationMessages$edges> Function(
      Iterable<
        CopyWith$Query$ConversationMessages$conversationMessages$edges<
          Query$ConversationMessages$conversationMessages$edges
        >
      >,
    )
    _fn,
  );
  CopyWith$Query$ConversationMessages$conversationMessages$pageInfo<TRes>
  get pageInfo;
}

class _CopyWithImpl$Query$ConversationMessages$conversationMessages<TRes>
    implements CopyWith$Query$ConversationMessages$conversationMessages<TRes> {
  _CopyWithImpl$Query$ConversationMessages$conversationMessages(
    this._instance,
    this._then,
  );

  final Query$ConversationMessages$conversationMessages _instance;

  final TRes Function(Query$ConversationMessages$conversationMessages) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? edges = _undefined,
    Object? pageInfo = _undefined,
  }) => _then(
    Query$ConversationMessages$conversationMessages(
      edges: edges == _undefined || edges == null
          ? _instance.edges
          : (edges
                as List<Query$ConversationMessages$conversationMessages$edges>),
      pageInfo: pageInfo == _undefined || pageInfo == null
          ? _instance.pageInfo
          : (pageInfo
                as Query$ConversationMessages$conversationMessages$pageInfo),
    ),
  );

  TRes edges(
    Iterable<Query$ConversationMessages$conversationMessages$edges> Function(
      Iterable<
        CopyWith$Query$ConversationMessages$conversationMessages$edges<
          Query$ConversationMessages$conversationMessages$edges
        >
      >,
    )
    _fn,
  ) => call(
    edges: _fn(
      _instance.edges.map(
        (e) => CopyWith$Query$ConversationMessages$conversationMessages$edges(
          e,
          (i) => i,
        ),
      ),
    ).toList(),
  );

  CopyWith$Query$ConversationMessages$conversationMessages$pageInfo<TRes>
  get pageInfo {
    final local$pageInfo = _instance.pageInfo;
    return CopyWith$Query$ConversationMessages$conversationMessages$pageInfo(
      local$pageInfo,
      (e) => call(pageInfo: e),
    );
  }
}

class _CopyWithStubImpl$Query$ConversationMessages$conversationMessages<TRes>
    implements CopyWith$Query$ConversationMessages$conversationMessages<TRes> {
  _CopyWithStubImpl$Query$ConversationMessages$conversationMessages(this._res);

  TRes _res;

  call({
    List<Query$ConversationMessages$conversationMessages$edges>? edges,
    Query$ConversationMessages$conversationMessages$pageInfo? pageInfo,
  }) => _res;

  edges(_fn) => _res;

  CopyWith$Query$ConversationMessages$conversationMessages$pageInfo<TRes>
  get pageInfo =>
      CopyWith$Query$ConversationMessages$conversationMessages$pageInfo.stub(
        _res,
      );
}

class Query$ConversationMessages$conversationMessages$edges {
  Query$ConversationMessages$conversationMessages$edges({
    required this.cursor,
    required this.node,
  });

  factory Query$ConversationMessages$conversationMessages$edges.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$cursor = json['cursor'];
    final l$node = json['node'];
    return Query$ConversationMessages$conversationMessages$edges(
      cursor: (l$cursor as String),
      node: Fragment$MessageParts.fromJson((l$node as Map<String, dynamic>)),
    );
  }

  final String cursor;

  final Fragment$MessageParts node;

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
    if (other is! Query$ConversationMessages$conversationMessages$edges ||
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

extension UtilityExtension$Query$ConversationMessages$conversationMessages$edges
    on Query$ConversationMessages$conversationMessages$edges {
  CopyWith$Query$ConversationMessages$conversationMessages$edges<
    Query$ConversationMessages$conversationMessages$edges
  >
  get copyWith =>
      CopyWith$Query$ConversationMessages$conversationMessages$edges(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Query$ConversationMessages$conversationMessages$edges<
  TRes
> {
  factory CopyWith$Query$ConversationMessages$conversationMessages$edges(
    Query$ConversationMessages$conversationMessages$edges instance,
    TRes Function(Query$ConversationMessages$conversationMessages$edges) then,
  ) = _CopyWithImpl$Query$ConversationMessages$conversationMessages$edges;

  factory CopyWith$Query$ConversationMessages$conversationMessages$edges.stub(
    TRes res,
  ) = _CopyWithStubImpl$Query$ConversationMessages$conversationMessages$edges;

  TRes call({String? cursor, Fragment$MessageParts? node});
  CopyWith$Fragment$MessageParts<TRes> get node;
}

class _CopyWithImpl$Query$ConversationMessages$conversationMessages$edges<TRes>
    implements
        CopyWith$Query$ConversationMessages$conversationMessages$edges<TRes> {
  _CopyWithImpl$Query$ConversationMessages$conversationMessages$edges(
    this._instance,
    this._then,
  );

  final Query$ConversationMessages$conversationMessages$edges _instance;

  final TRes Function(Query$ConversationMessages$conversationMessages$edges)
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? cursor = _undefined, Object? node = _undefined}) => _then(
    Query$ConversationMessages$conversationMessages$edges(
      cursor: cursor == _undefined || cursor == null
          ? _instance.cursor
          : (cursor as String),
      node: node == _undefined || node == null
          ? _instance.node
          : (node as Fragment$MessageParts),
    ),
  );

  CopyWith$Fragment$MessageParts<TRes> get node {
    final local$node = _instance.node;
    return CopyWith$Fragment$MessageParts(local$node, (e) => call(node: e));
  }
}

class _CopyWithStubImpl$Query$ConversationMessages$conversationMessages$edges<
  TRes
>
    implements
        CopyWith$Query$ConversationMessages$conversationMessages$edges<TRes> {
  _CopyWithStubImpl$Query$ConversationMessages$conversationMessages$edges(
    this._res,
  );

  TRes _res;

  call({String? cursor, Fragment$MessageParts? node}) => _res;

  CopyWith$Fragment$MessageParts<TRes> get node =>
      CopyWith$Fragment$MessageParts.stub(_res);
}

class Query$ConversationMessages$conversationMessages$pageInfo {
  Query$ConversationMessages$conversationMessages$pageInfo({
    required this.hasNextPage,
    this.endCursor,
  });

  factory Query$ConversationMessages$conversationMessages$pageInfo.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$hasNextPage = json['hasNextPage'];
    final l$endCursor = json['endCursor'];
    return Query$ConversationMessages$conversationMessages$pageInfo(
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
    if (other is! Query$ConversationMessages$conversationMessages$pageInfo ||
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

extension UtilityExtension$Query$ConversationMessages$conversationMessages$pageInfo
    on Query$ConversationMessages$conversationMessages$pageInfo {
  CopyWith$Query$ConversationMessages$conversationMessages$pageInfo<
    Query$ConversationMessages$conversationMessages$pageInfo
  >
  get copyWith =>
      CopyWith$Query$ConversationMessages$conversationMessages$pageInfo(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Query$ConversationMessages$conversationMessages$pageInfo<
  TRes
> {
  factory CopyWith$Query$ConversationMessages$conversationMessages$pageInfo(
    Query$ConversationMessages$conversationMessages$pageInfo instance,
    TRes Function(Query$ConversationMessages$conversationMessages$pageInfo)
    then,
  ) = _CopyWithImpl$Query$ConversationMessages$conversationMessages$pageInfo;

  factory CopyWith$Query$ConversationMessages$conversationMessages$pageInfo.stub(
    TRes res,
  ) = _CopyWithStubImpl$Query$ConversationMessages$conversationMessages$pageInfo;

  TRes call({bool? hasNextPage, String? endCursor});
}

class _CopyWithImpl$Query$ConversationMessages$conversationMessages$pageInfo<
  TRes
>
    implements
        CopyWith$Query$ConversationMessages$conversationMessages$pageInfo<
          TRes
        > {
  _CopyWithImpl$Query$ConversationMessages$conversationMessages$pageInfo(
    this._instance,
    this._then,
  );

  final Query$ConversationMessages$conversationMessages$pageInfo _instance;

  final TRes Function(Query$ConversationMessages$conversationMessages$pageInfo)
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? hasNextPage = _undefined,
    Object? endCursor = _undefined,
  }) => _then(
    Query$ConversationMessages$conversationMessages$pageInfo(
      hasNextPage: hasNextPage == _undefined || hasNextPage == null
          ? _instance.hasNextPage
          : (hasNextPage as bool),
      endCursor: endCursor == _undefined
          ? _instance.endCursor
          : (endCursor as String?),
    ),
  );
}

class _CopyWithStubImpl$Query$ConversationMessages$conversationMessages$pageInfo<
  TRes
>
    implements
        CopyWith$Query$ConversationMessages$conversationMessages$pageInfo<
          TRes
        > {
  _CopyWithStubImpl$Query$ConversationMessages$conversationMessages$pageInfo(
    this._res,
  );

  TRes _res;

  call({bool? hasNextPage, String? endCursor}) => _res;
}

class Variables$Mutation$StartConversation {
  factory Variables$Mutation$StartConversation({
    required String counterpartMemberId,
  }) => Variables$Mutation$StartConversation._({
    r'counterpartMemberId': counterpartMemberId,
  });

  Variables$Mutation$StartConversation._(this._$data);

  factory Variables$Mutation$StartConversation.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    final l$counterpartMemberId = data['counterpartMemberId'];
    result$data['counterpartMemberId'] = (l$counterpartMemberId as String);
    return Variables$Mutation$StartConversation._(result$data);
  }

  Map<String, dynamic> _$data;

  String get counterpartMemberId => (_$data['counterpartMemberId'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$counterpartMemberId = counterpartMemberId;
    result$data['counterpartMemberId'] = l$counterpartMemberId;
    return result$data;
  }

  CopyWith$Variables$Mutation$StartConversation<
    Variables$Mutation$StartConversation
  >
  get copyWith => CopyWith$Variables$Mutation$StartConversation(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Mutation$StartConversation ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$counterpartMemberId = counterpartMemberId;
    final lOther$counterpartMemberId = other.counterpartMemberId;
    if (l$counterpartMemberId != lOther$counterpartMemberId) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$counterpartMemberId = counterpartMemberId;
    return Object.hashAll([l$counterpartMemberId]);
  }
}

abstract class CopyWith$Variables$Mutation$StartConversation<TRes> {
  factory CopyWith$Variables$Mutation$StartConversation(
    Variables$Mutation$StartConversation instance,
    TRes Function(Variables$Mutation$StartConversation) then,
  ) = _CopyWithImpl$Variables$Mutation$StartConversation;

  factory CopyWith$Variables$Mutation$StartConversation.stub(TRes res) =
      _CopyWithStubImpl$Variables$Mutation$StartConversation;

  TRes call({String? counterpartMemberId});
}

class _CopyWithImpl$Variables$Mutation$StartConversation<TRes>
    implements CopyWith$Variables$Mutation$StartConversation<TRes> {
  _CopyWithImpl$Variables$Mutation$StartConversation(
    this._instance,
    this._then,
  );

  final Variables$Mutation$StartConversation _instance;

  final TRes Function(Variables$Mutation$StartConversation) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? counterpartMemberId = _undefined}) => _then(
    Variables$Mutation$StartConversation._({
      ..._instance._$data,
      if (counterpartMemberId != _undefined && counterpartMemberId != null)
        'counterpartMemberId': (counterpartMemberId as String),
    }),
  );
}

class _CopyWithStubImpl$Variables$Mutation$StartConversation<TRes>
    implements CopyWith$Variables$Mutation$StartConversation<TRes> {
  _CopyWithStubImpl$Variables$Mutation$StartConversation(this._res);

  TRes _res;

  call({String? counterpartMemberId}) => _res;
}

class Mutation$StartConversation {
  Mutation$StartConversation({required this.startConversation});

  factory Mutation$StartConversation.fromJson(Map<String, dynamic> json) {
    final l$startConversation = json['startConversation'];
    return Mutation$StartConversation(
      startConversation: Mutation$StartConversation$startConversation.fromJson(
        (l$startConversation as Map<String, dynamic>),
      ),
    );
  }

  final Mutation$StartConversation$startConversation startConversation;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$startConversation = startConversation;
    _resultData['startConversation'] = l$startConversation.toJson();
    return _resultData;
  }

  @override
  int get hashCode {
    final l$startConversation = startConversation;
    return Object.hashAll([l$startConversation]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$StartConversation ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$startConversation = startConversation;
    final lOther$startConversation = other.startConversation;
    if (l$startConversation != lOther$startConversation) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Mutation$StartConversation
    on Mutation$StartConversation {
  CopyWith$Mutation$StartConversation<Mutation$StartConversation>
  get copyWith => CopyWith$Mutation$StartConversation(this, (i) => i);
}

abstract class CopyWith$Mutation$StartConversation<TRes> {
  factory CopyWith$Mutation$StartConversation(
    Mutation$StartConversation instance,
    TRes Function(Mutation$StartConversation) then,
  ) = _CopyWithImpl$Mutation$StartConversation;

  factory CopyWith$Mutation$StartConversation.stub(TRes res) =
      _CopyWithStubImpl$Mutation$StartConversation;

  TRes call({Mutation$StartConversation$startConversation? startConversation});
  CopyWith$Mutation$StartConversation$startConversation<TRes>
  get startConversation;
}

class _CopyWithImpl$Mutation$StartConversation<TRes>
    implements CopyWith$Mutation$StartConversation<TRes> {
  _CopyWithImpl$Mutation$StartConversation(this._instance, this._then);

  final Mutation$StartConversation _instance;

  final TRes Function(Mutation$StartConversation) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? startConversation = _undefined}) => _then(
    Mutation$StartConversation(
      startConversation:
          startConversation == _undefined || startConversation == null
          ? _instance.startConversation
          : (startConversation as Mutation$StartConversation$startConversation),
    ),
  );

  CopyWith$Mutation$StartConversation$startConversation<TRes>
  get startConversation {
    final local$startConversation = _instance.startConversation;
    return CopyWith$Mutation$StartConversation$startConversation(
      local$startConversation,
      (e) => call(startConversation: e),
    );
  }
}

class _CopyWithStubImpl$Mutation$StartConversation<TRes>
    implements CopyWith$Mutation$StartConversation<TRes> {
  _CopyWithStubImpl$Mutation$StartConversation(this._res);

  TRes _res;

  call({Mutation$StartConversation$startConversation? startConversation}) =>
      _res;

  CopyWith$Mutation$StartConversation$startConversation<TRes>
  get startConversation =>
      CopyWith$Mutation$StartConversation$startConversation.stub(_res);
}

const documentNodeMutationStartConversation = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'StartConversation'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'counterpartMemberId')),
          type: NamedTypeNode(name: NameNode(value: 'ID'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
      ],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'startConversation'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'input'),
                value: ObjectValueNode(
                  fields: [
                    ObjectFieldNode(
                      name: NameNode(value: 'counterpartMemberId'),
                      value: VariableNode(
                        name: NameNode(value: 'counterpartMemberId'),
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
                  name: NameNode(value: 'conversationId'),
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

class Mutation$StartConversation$startConversation {
  Mutation$StartConversation$startConversation({
    required this.success,
    required this.userErrors,
    this.conversationId,
  });

  factory Mutation$StartConversation$startConversation.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$success = json['success'];
    final l$userErrors = json['userErrors'];
    final l$conversationId = json['conversationId'];
    return Mutation$StartConversation$startConversation(
      success: (l$success as bool),
      userErrors: (l$userErrors as List<dynamic>)
          .map(
            (e) =>
                Mutation$StartConversation$startConversation$userErrors.fromJson(
                  (e as Map<String, dynamic>),
                ),
          )
          .toList(),
      conversationId: (l$conversationId as String?),
    );
  }

  final bool success;

  final List<Mutation$StartConversation$startConversation$userErrors>
  userErrors;

  final String? conversationId;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$success = success;
    _resultData['success'] = l$success;
    final l$userErrors = userErrors;
    _resultData['userErrors'] = l$userErrors.map((e) => e.toJson()).toList();
    final l$conversationId = conversationId;
    _resultData['conversationId'] = l$conversationId;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$success = success;
    final l$userErrors = userErrors;
    final l$conversationId = conversationId;
    return Object.hashAll([
      l$success,
      Object.hashAll(l$userErrors.map((v) => v)),
      l$conversationId,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$StartConversation$startConversation ||
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
    final l$conversationId = conversationId;
    final lOther$conversationId = other.conversationId;
    if (l$conversationId != lOther$conversationId) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Mutation$StartConversation$startConversation
    on Mutation$StartConversation$startConversation {
  CopyWith$Mutation$StartConversation$startConversation<
    Mutation$StartConversation$startConversation
  >
  get copyWith =>
      CopyWith$Mutation$StartConversation$startConversation(this, (i) => i);
}

abstract class CopyWith$Mutation$StartConversation$startConversation<TRes> {
  factory CopyWith$Mutation$StartConversation$startConversation(
    Mutation$StartConversation$startConversation instance,
    TRes Function(Mutation$StartConversation$startConversation) then,
  ) = _CopyWithImpl$Mutation$StartConversation$startConversation;

  factory CopyWith$Mutation$StartConversation$startConversation.stub(TRes res) =
      _CopyWithStubImpl$Mutation$StartConversation$startConversation;

  TRes call({
    bool? success,
    List<Mutation$StartConversation$startConversation$userErrors>? userErrors,
    String? conversationId,
  });
  TRes userErrors(
    Iterable<Mutation$StartConversation$startConversation$userErrors> Function(
      Iterable<
        CopyWith$Mutation$StartConversation$startConversation$userErrors<
          Mutation$StartConversation$startConversation$userErrors
        >
      >,
    )
    _fn,
  );
}

class _CopyWithImpl$Mutation$StartConversation$startConversation<TRes>
    implements CopyWith$Mutation$StartConversation$startConversation<TRes> {
  _CopyWithImpl$Mutation$StartConversation$startConversation(
    this._instance,
    this._then,
  );

  final Mutation$StartConversation$startConversation _instance;

  final TRes Function(Mutation$StartConversation$startConversation) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? success = _undefined,
    Object? userErrors = _undefined,
    Object? conversationId = _undefined,
  }) => _then(
    Mutation$StartConversation$startConversation(
      success: success == _undefined || success == null
          ? _instance.success
          : (success as bool),
      userErrors: userErrors == _undefined || userErrors == null
          ? _instance.userErrors
          : (userErrors
                as List<
                  Mutation$StartConversation$startConversation$userErrors
                >),
      conversationId: conversationId == _undefined
          ? _instance.conversationId
          : (conversationId as String?),
    ),
  );

  TRes userErrors(
    Iterable<Mutation$StartConversation$startConversation$userErrors> Function(
      Iterable<
        CopyWith$Mutation$StartConversation$startConversation$userErrors<
          Mutation$StartConversation$startConversation$userErrors
        >
      >,
    )
    _fn,
  ) => call(
    userErrors: _fn(
      _instance.userErrors.map(
        (e) => CopyWith$Mutation$StartConversation$startConversation$userErrors(
          e,
          (i) => i,
        ),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl$Mutation$StartConversation$startConversation<TRes>
    implements CopyWith$Mutation$StartConversation$startConversation<TRes> {
  _CopyWithStubImpl$Mutation$StartConversation$startConversation(this._res);

  TRes _res;

  call({
    bool? success,
    List<Mutation$StartConversation$startConversation$userErrors>? userErrors,
    String? conversationId,
  }) => _res;

  userErrors(_fn) => _res;
}

class Mutation$StartConversation$startConversation$userErrors {
  Mutation$StartConversation$startConversation$userErrors({
    required this.code,
    required this.message,
    this.field,
  });

  factory Mutation$StartConversation$startConversation$userErrors.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$code = json['code'];
    final l$message = json['message'];
    final l$field = json['field'];
    return Mutation$StartConversation$startConversation$userErrors(
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
    if (other is! Mutation$StartConversation$startConversation$userErrors ||
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

extension UtilityExtension$Mutation$StartConversation$startConversation$userErrors
    on Mutation$StartConversation$startConversation$userErrors {
  CopyWith$Mutation$StartConversation$startConversation$userErrors<
    Mutation$StartConversation$startConversation$userErrors
  >
  get copyWith =>
      CopyWith$Mutation$StartConversation$startConversation$userErrors(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Mutation$StartConversation$startConversation$userErrors<
  TRes
> {
  factory CopyWith$Mutation$StartConversation$startConversation$userErrors(
    Mutation$StartConversation$startConversation$userErrors instance,
    TRes Function(Mutation$StartConversation$startConversation$userErrors) then,
  ) = _CopyWithImpl$Mutation$StartConversation$startConversation$userErrors;

  factory CopyWith$Mutation$StartConversation$startConversation$userErrors.stub(
    TRes res,
  ) = _CopyWithStubImpl$Mutation$StartConversation$startConversation$userErrors;

  TRes call({String? code, String? message, String? field});
}

class _CopyWithImpl$Mutation$StartConversation$startConversation$userErrors<
  TRes
>
    implements
        CopyWith$Mutation$StartConversation$startConversation$userErrors<TRes> {
  _CopyWithImpl$Mutation$StartConversation$startConversation$userErrors(
    this._instance,
    this._then,
  );

  final Mutation$StartConversation$startConversation$userErrors _instance;

  final TRes Function(Mutation$StartConversation$startConversation$userErrors)
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? code = _undefined,
    Object? message = _undefined,
    Object? field = _undefined,
  }) => _then(
    Mutation$StartConversation$startConversation$userErrors(
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

class _CopyWithStubImpl$Mutation$StartConversation$startConversation$userErrors<
  TRes
>
    implements
        CopyWith$Mutation$StartConversation$startConversation$userErrors<TRes> {
  _CopyWithStubImpl$Mutation$StartConversation$startConversation$userErrors(
    this._res,
  );

  TRes _res;

  call({String? code, String? message, String? field}) => _res;
}

class Variables$Mutation$SendMessage {
  factory Variables$Mutation$SendMessage({
    required String conversationId,
    required String body,
    String? photoKey,
  }) => Variables$Mutation$SendMessage._({
    r'conversationId': conversationId,
    r'body': body,
    if (photoKey != null) r'photoKey': photoKey,
  });

  Variables$Mutation$SendMessage._(this._$data);

  factory Variables$Mutation$SendMessage.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$conversationId = data['conversationId'];
    result$data['conversationId'] = (l$conversationId as String);
    final l$body = data['body'];
    result$data['body'] = (l$body as String);
    if (data.containsKey('photoKey')) {
      final l$photoKey = data['photoKey'];
      result$data['photoKey'] = (l$photoKey as String?);
    }
    return Variables$Mutation$SendMessage._(result$data);
  }

  Map<String, dynamic> _$data;

  String get conversationId => (_$data['conversationId'] as String);

  String get body => (_$data['body'] as String);

  String? get photoKey => (_$data['photoKey'] as String?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$conversationId = conversationId;
    result$data['conversationId'] = l$conversationId;
    final l$body = body;
    result$data['body'] = l$body;
    if (_$data.containsKey('photoKey')) {
      final l$photoKey = photoKey;
      result$data['photoKey'] = l$photoKey;
    }
    return result$data;
  }

  CopyWith$Variables$Mutation$SendMessage<Variables$Mutation$SendMessage>
  get copyWith => CopyWith$Variables$Mutation$SendMessage(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Mutation$SendMessage ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$conversationId = conversationId;
    final lOther$conversationId = other.conversationId;
    if (l$conversationId != lOther$conversationId) {
      return false;
    }
    final l$body = body;
    final lOther$body = other.body;
    if (l$body != lOther$body) {
      return false;
    }
    final l$photoKey = photoKey;
    final lOther$photoKey = other.photoKey;
    if (_$data.containsKey('photoKey') !=
        other._$data.containsKey('photoKey')) {
      return false;
    }
    if (l$photoKey != lOther$photoKey) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$conversationId = conversationId;
    final l$body = body;
    final l$photoKey = photoKey;
    return Object.hashAll([
      l$conversationId,
      l$body,
      _$data.containsKey('photoKey') ? l$photoKey : const {},
    ]);
  }
}

abstract class CopyWith$Variables$Mutation$SendMessage<TRes> {
  factory CopyWith$Variables$Mutation$SendMessage(
    Variables$Mutation$SendMessage instance,
    TRes Function(Variables$Mutation$SendMessage) then,
  ) = _CopyWithImpl$Variables$Mutation$SendMessage;

  factory CopyWith$Variables$Mutation$SendMessage.stub(TRes res) =
      _CopyWithStubImpl$Variables$Mutation$SendMessage;

  TRes call({String? conversationId, String? body, String? photoKey});
}

class _CopyWithImpl$Variables$Mutation$SendMessage<TRes>
    implements CopyWith$Variables$Mutation$SendMessage<TRes> {
  _CopyWithImpl$Variables$Mutation$SendMessage(this._instance, this._then);

  final Variables$Mutation$SendMessage _instance;

  final TRes Function(Variables$Mutation$SendMessage) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? conversationId = _undefined,
    Object? body = _undefined,
    Object? photoKey = _undefined,
  }) => _then(
    Variables$Mutation$SendMessage._({
      ..._instance._$data,
      if (conversationId != _undefined && conversationId != null)
        'conversationId': (conversationId as String),
      if (body != _undefined && body != null) 'body': (body as String),
      if (photoKey != _undefined) 'photoKey': (photoKey as String?),
    }),
  );
}

class _CopyWithStubImpl$Variables$Mutation$SendMessage<TRes>
    implements CopyWith$Variables$Mutation$SendMessage<TRes> {
  _CopyWithStubImpl$Variables$Mutation$SendMessage(this._res);

  TRes _res;

  call({String? conversationId, String? body, String? photoKey}) => _res;
}

class Mutation$SendMessage {
  Mutation$SendMessage({required this.sendMessage});

  factory Mutation$SendMessage.fromJson(Map<String, dynamic> json) {
    final l$sendMessage = json['sendMessage'];
    return Mutation$SendMessage(
      sendMessage: Mutation$SendMessage$sendMessage.fromJson(
        (l$sendMessage as Map<String, dynamic>),
      ),
    );
  }

  final Mutation$SendMessage$sendMessage sendMessage;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$sendMessage = sendMessage;
    _resultData['sendMessage'] = l$sendMessage.toJson();
    return _resultData;
  }

  @override
  int get hashCode {
    final l$sendMessage = sendMessage;
    return Object.hashAll([l$sendMessage]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$SendMessage || runtimeType != other.runtimeType) {
      return false;
    }
    final l$sendMessage = sendMessage;
    final lOther$sendMessage = other.sendMessage;
    if (l$sendMessage != lOther$sendMessage) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Mutation$SendMessage on Mutation$SendMessage {
  CopyWith$Mutation$SendMessage<Mutation$SendMessage> get copyWith =>
      CopyWith$Mutation$SendMessage(this, (i) => i);
}

abstract class CopyWith$Mutation$SendMessage<TRes> {
  factory CopyWith$Mutation$SendMessage(
    Mutation$SendMessage instance,
    TRes Function(Mutation$SendMessage) then,
  ) = _CopyWithImpl$Mutation$SendMessage;

  factory CopyWith$Mutation$SendMessage.stub(TRes res) =
      _CopyWithStubImpl$Mutation$SendMessage;

  TRes call({Mutation$SendMessage$sendMessage? sendMessage});
  CopyWith$Mutation$SendMessage$sendMessage<TRes> get sendMessage;
}

class _CopyWithImpl$Mutation$SendMessage<TRes>
    implements CopyWith$Mutation$SendMessage<TRes> {
  _CopyWithImpl$Mutation$SendMessage(this._instance, this._then);

  final Mutation$SendMessage _instance;

  final TRes Function(Mutation$SendMessage) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? sendMessage = _undefined}) => _then(
    Mutation$SendMessage(
      sendMessage: sendMessage == _undefined || sendMessage == null
          ? _instance.sendMessage
          : (sendMessage as Mutation$SendMessage$sendMessage),
    ),
  );

  CopyWith$Mutation$SendMessage$sendMessage<TRes> get sendMessage {
    final local$sendMessage = _instance.sendMessage;
    return CopyWith$Mutation$SendMessage$sendMessage(
      local$sendMessage,
      (e) => call(sendMessage: e),
    );
  }
}

class _CopyWithStubImpl$Mutation$SendMessage<TRes>
    implements CopyWith$Mutation$SendMessage<TRes> {
  _CopyWithStubImpl$Mutation$SendMessage(this._res);

  TRes _res;

  call({Mutation$SendMessage$sendMessage? sendMessage}) => _res;

  CopyWith$Mutation$SendMessage$sendMessage<TRes> get sendMessage =>
      CopyWith$Mutation$SendMessage$sendMessage.stub(_res);
}

const documentNodeMutationSendMessage = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'SendMessage'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'conversationId')),
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
          variable: VariableNode(name: NameNode(value: 'photoKey')),
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
            name: NameNode(value: 'sendMessage'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'input'),
                value: ObjectValueNode(
                  fields: [
                    ObjectFieldNode(
                      name: NameNode(value: 'conversationId'),
                      value: VariableNode(
                        name: NameNode(value: 'conversationId'),
                      ),
                    ),
                    ObjectFieldNode(
                      name: NameNode(value: 'body'),
                      value: VariableNode(name: NameNode(value: 'body')),
                    ),
                    ObjectFieldNode(
                      name: NameNode(value: 'photoKey'),
                      value: VariableNode(name: NameNode(value: 'photoKey')),
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
                  name: NameNode(value: 'messageId'),
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

class Mutation$SendMessage$sendMessage {
  Mutation$SendMessage$sendMessage({
    required this.success,
    required this.userErrors,
    this.messageId,
  });

  factory Mutation$SendMessage$sendMessage.fromJson(Map<String, dynamic> json) {
    final l$success = json['success'];
    final l$userErrors = json['userErrors'];
    final l$messageId = json['messageId'];
    return Mutation$SendMessage$sendMessage(
      success: (l$success as bool),
      userErrors: (l$userErrors as List<dynamic>)
          .map(
            (e) => Mutation$SendMessage$sendMessage$userErrors.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      messageId: (l$messageId as String?),
    );
  }

  final bool success;

  final List<Mutation$SendMessage$sendMessage$userErrors> userErrors;

  final String? messageId;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$success = success;
    _resultData['success'] = l$success;
    final l$userErrors = userErrors;
    _resultData['userErrors'] = l$userErrors.map((e) => e.toJson()).toList();
    final l$messageId = messageId;
    _resultData['messageId'] = l$messageId;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$success = success;
    final l$userErrors = userErrors;
    final l$messageId = messageId;
    return Object.hashAll([
      l$success,
      Object.hashAll(l$userErrors.map((v) => v)),
      l$messageId,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$SendMessage$sendMessage ||
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
    final l$messageId = messageId;
    final lOther$messageId = other.messageId;
    if (l$messageId != lOther$messageId) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Mutation$SendMessage$sendMessage
    on Mutation$SendMessage$sendMessage {
  CopyWith$Mutation$SendMessage$sendMessage<Mutation$SendMessage$sendMessage>
  get copyWith => CopyWith$Mutation$SendMessage$sendMessage(this, (i) => i);
}

abstract class CopyWith$Mutation$SendMessage$sendMessage<TRes> {
  factory CopyWith$Mutation$SendMessage$sendMessage(
    Mutation$SendMessage$sendMessage instance,
    TRes Function(Mutation$SendMessage$sendMessage) then,
  ) = _CopyWithImpl$Mutation$SendMessage$sendMessage;

  factory CopyWith$Mutation$SendMessage$sendMessage.stub(TRes res) =
      _CopyWithStubImpl$Mutation$SendMessage$sendMessage;

  TRes call({
    bool? success,
    List<Mutation$SendMessage$sendMessage$userErrors>? userErrors,
    String? messageId,
  });
  TRes userErrors(
    Iterable<Mutation$SendMessage$sendMessage$userErrors> Function(
      Iterable<
        CopyWith$Mutation$SendMessage$sendMessage$userErrors<
          Mutation$SendMessage$sendMessage$userErrors
        >
      >,
    )
    _fn,
  );
}

class _CopyWithImpl$Mutation$SendMessage$sendMessage<TRes>
    implements CopyWith$Mutation$SendMessage$sendMessage<TRes> {
  _CopyWithImpl$Mutation$SendMessage$sendMessage(this._instance, this._then);

  final Mutation$SendMessage$sendMessage _instance;

  final TRes Function(Mutation$SendMessage$sendMessage) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? success = _undefined,
    Object? userErrors = _undefined,
    Object? messageId = _undefined,
  }) => _then(
    Mutation$SendMessage$sendMessage(
      success: success == _undefined || success == null
          ? _instance.success
          : (success as bool),
      userErrors: userErrors == _undefined || userErrors == null
          ? _instance.userErrors
          : (userErrors as List<Mutation$SendMessage$sendMessage$userErrors>),
      messageId: messageId == _undefined
          ? _instance.messageId
          : (messageId as String?),
    ),
  );

  TRes userErrors(
    Iterable<Mutation$SendMessage$sendMessage$userErrors> Function(
      Iterable<
        CopyWith$Mutation$SendMessage$sendMessage$userErrors<
          Mutation$SendMessage$sendMessage$userErrors
        >
      >,
    )
    _fn,
  ) => call(
    userErrors: _fn(
      _instance.userErrors.map(
        (e) =>
            CopyWith$Mutation$SendMessage$sendMessage$userErrors(e, (i) => i),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl$Mutation$SendMessage$sendMessage<TRes>
    implements CopyWith$Mutation$SendMessage$sendMessage<TRes> {
  _CopyWithStubImpl$Mutation$SendMessage$sendMessage(this._res);

  TRes _res;

  call({
    bool? success,
    List<Mutation$SendMessage$sendMessage$userErrors>? userErrors,
    String? messageId,
  }) => _res;

  userErrors(_fn) => _res;
}

class Mutation$SendMessage$sendMessage$userErrors {
  Mutation$SendMessage$sendMessage$userErrors({
    required this.code,
    required this.message,
    this.field,
  });

  factory Mutation$SendMessage$sendMessage$userErrors.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$code = json['code'];
    final l$message = json['message'];
    final l$field = json['field'];
    return Mutation$SendMessage$sendMessage$userErrors(
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
    if (other is! Mutation$SendMessage$sendMessage$userErrors ||
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

extension UtilityExtension$Mutation$SendMessage$sendMessage$userErrors
    on Mutation$SendMessage$sendMessage$userErrors {
  CopyWith$Mutation$SendMessage$sendMessage$userErrors<
    Mutation$SendMessage$sendMessage$userErrors
  >
  get copyWith =>
      CopyWith$Mutation$SendMessage$sendMessage$userErrors(this, (i) => i);
}

abstract class CopyWith$Mutation$SendMessage$sendMessage$userErrors<TRes> {
  factory CopyWith$Mutation$SendMessage$sendMessage$userErrors(
    Mutation$SendMessage$sendMessage$userErrors instance,
    TRes Function(Mutation$SendMessage$sendMessage$userErrors) then,
  ) = _CopyWithImpl$Mutation$SendMessage$sendMessage$userErrors;

  factory CopyWith$Mutation$SendMessage$sendMessage$userErrors.stub(TRes res) =
      _CopyWithStubImpl$Mutation$SendMessage$sendMessage$userErrors;

  TRes call({String? code, String? message, String? field});
}

class _CopyWithImpl$Mutation$SendMessage$sendMessage$userErrors<TRes>
    implements CopyWith$Mutation$SendMessage$sendMessage$userErrors<TRes> {
  _CopyWithImpl$Mutation$SendMessage$sendMessage$userErrors(
    this._instance,
    this._then,
  );

  final Mutation$SendMessage$sendMessage$userErrors _instance;

  final TRes Function(Mutation$SendMessage$sendMessage$userErrors) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? code = _undefined,
    Object? message = _undefined,
    Object? field = _undefined,
  }) => _then(
    Mutation$SendMessage$sendMessage$userErrors(
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

class _CopyWithStubImpl$Mutation$SendMessage$sendMessage$userErrors<TRes>
    implements CopyWith$Mutation$SendMessage$sendMessage$userErrors<TRes> {
  _CopyWithStubImpl$Mutation$SendMessage$sendMessage$userErrors(this._res);

  TRes _res;

  call({String? code, String? message, String? field}) => _res;
}

class Variables$Mutation$NotifyTyping {
  factory Variables$Mutation$NotifyTyping({required String conversationId}) =>
      Variables$Mutation$NotifyTyping._({r'conversationId': conversationId});

  Variables$Mutation$NotifyTyping._(this._$data);

  factory Variables$Mutation$NotifyTyping.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$conversationId = data['conversationId'];
    result$data['conversationId'] = (l$conversationId as String);
    return Variables$Mutation$NotifyTyping._(result$data);
  }

  Map<String, dynamic> _$data;

  String get conversationId => (_$data['conversationId'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$conversationId = conversationId;
    result$data['conversationId'] = l$conversationId;
    return result$data;
  }

  CopyWith$Variables$Mutation$NotifyTyping<Variables$Mutation$NotifyTyping>
  get copyWith => CopyWith$Variables$Mutation$NotifyTyping(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Mutation$NotifyTyping ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$conversationId = conversationId;
    final lOther$conversationId = other.conversationId;
    if (l$conversationId != lOther$conversationId) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$conversationId = conversationId;
    return Object.hashAll([l$conversationId]);
  }
}

abstract class CopyWith$Variables$Mutation$NotifyTyping<TRes> {
  factory CopyWith$Variables$Mutation$NotifyTyping(
    Variables$Mutation$NotifyTyping instance,
    TRes Function(Variables$Mutation$NotifyTyping) then,
  ) = _CopyWithImpl$Variables$Mutation$NotifyTyping;

  factory CopyWith$Variables$Mutation$NotifyTyping.stub(TRes res) =
      _CopyWithStubImpl$Variables$Mutation$NotifyTyping;

  TRes call({String? conversationId});
}

class _CopyWithImpl$Variables$Mutation$NotifyTyping<TRes>
    implements CopyWith$Variables$Mutation$NotifyTyping<TRes> {
  _CopyWithImpl$Variables$Mutation$NotifyTyping(this._instance, this._then);

  final Variables$Mutation$NotifyTyping _instance;

  final TRes Function(Variables$Mutation$NotifyTyping) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? conversationId = _undefined}) => _then(
    Variables$Mutation$NotifyTyping._({
      ..._instance._$data,
      if (conversationId != _undefined && conversationId != null)
        'conversationId': (conversationId as String),
    }),
  );
}

class _CopyWithStubImpl$Variables$Mutation$NotifyTyping<TRes>
    implements CopyWith$Variables$Mutation$NotifyTyping<TRes> {
  _CopyWithStubImpl$Variables$Mutation$NotifyTyping(this._res);

  TRes _res;

  call({String? conversationId}) => _res;
}

class Mutation$NotifyTyping {
  Mutation$NotifyTyping({required this.notifyTyping});

  factory Mutation$NotifyTyping.fromJson(Map<String, dynamic> json) {
    final l$notifyTyping = json['notifyTyping'];
    return Mutation$NotifyTyping(
      notifyTyping: Mutation$NotifyTyping$notifyTyping.fromJson(
        (l$notifyTyping as Map<String, dynamic>),
      ),
    );
  }

  final Mutation$NotifyTyping$notifyTyping notifyTyping;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$notifyTyping = notifyTyping;
    _resultData['notifyTyping'] = l$notifyTyping.toJson();
    return _resultData;
  }

  @override
  int get hashCode {
    final l$notifyTyping = notifyTyping;
    return Object.hashAll([l$notifyTyping]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$NotifyTyping || runtimeType != other.runtimeType) {
      return false;
    }
    final l$notifyTyping = notifyTyping;
    final lOther$notifyTyping = other.notifyTyping;
    if (l$notifyTyping != lOther$notifyTyping) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Mutation$NotifyTyping on Mutation$NotifyTyping {
  CopyWith$Mutation$NotifyTyping<Mutation$NotifyTyping> get copyWith =>
      CopyWith$Mutation$NotifyTyping(this, (i) => i);
}

abstract class CopyWith$Mutation$NotifyTyping<TRes> {
  factory CopyWith$Mutation$NotifyTyping(
    Mutation$NotifyTyping instance,
    TRes Function(Mutation$NotifyTyping) then,
  ) = _CopyWithImpl$Mutation$NotifyTyping;

  factory CopyWith$Mutation$NotifyTyping.stub(TRes res) =
      _CopyWithStubImpl$Mutation$NotifyTyping;

  TRes call({Mutation$NotifyTyping$notifyTyping? notifyTyping});
  CopyWith$Mutation$NotifyTyping$notifyTyping<TRes> get notifyTyping;
}

class _CopyWithImpl$Mutation$NotifyTyping<TRes>
    implements CopyWith$Mutation$NotifyTyping<TRes> {
  _CopyWithImpl$Mutation$NotifyTyping(this._instance, this._then);

  final Mutation$NotifyTyping _instance;

  final TRes Function(Mutation$NotifyTyping) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? notifyTyping = _undefined}) => _then(
    Mutation$NotifyTyping(
      notifyTyping: notifyTyping == _undefined || notifyTyping == null
          ? _instance.notifyTyping
          : (notifyTyping as Mutation$NotifyTyping$notifyTyping),
    ),
  );

  CopyWith$Mutation$NotifyTyping$notifyTyping<TRes> get notifyTyping {
    final local$notifyTyping = _instance.notifyTyping;
    return CopyWith$Mutation$NotifyTyping$notifyTyping(
      local$notifyTyping,
      (e) => call(notifyTyping: e),
    );
  }
}

class _CopyWithStubImpl$Mutation$NotifyTyping<TRes>
    implements CopyWith$Mutation$NotifyTyping<TRes> {
  _CopyWithStubImpl$Mutation$NotifyTyping(this._res);

  TRes _res;

  call({Mutation$NotifyTyping$notifyTyping? notifyTyping}) => _res;

  CopyWith$Mutation$NotifyTyping$notifyTyping<TRes> get notifyTyping =>
      CopyWith$Mutation$NotifyTyping$notifyTyping.stub(_res);
}

const documentNodeMutationNotifyTyping = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'NotifyTyping'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'conversationId')),
          type: NamedTypeNode(name: NameNode(value: 'ID'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
      ],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'notifyTyping'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'input'),
                value: ObjectValueNode(
                  fields: [
                    ObjectFieldNode(
                      name: NameNode(value: 'conversationId'),
                      value: VariableNode(
                        name: NameNode(value: 'conversationId'),
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

class Mutation$NotifyTyping$notifyTyping {
  Mutation$NotifyTyping$notifyTyping({
    required this.success,
    required this.userErrors,
  });

  factory Mutation$NotifyTyping$notifyTyping.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$success = json['success'];
    final l$userErrors = json['userErrors'];
    return Mutation$NotifyTyping$notifyTyping(
      success: (l$success as bool),
      userErrors: (l$userErrors as List<dynamic>)
          .map(
            (e) => Mutation$NotifyTyping$notifyTyping$userErrors.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
    );
  }

  final bool success;

  final List<Mutation$NotifyTyping$notifyTyping$userErrors> userErrors;

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
    if (other is! Mutation$NotifyTyping$notifyTyping ||
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

extension UtilityExtension$Mutation$NotifyTyping$notifyTyping
    on Mutation$NotifyTyping$notifyTyping {
  CopyWith$Mutation$NotifyTyping$notifyTyping<
    Mutation$NotifyTyping$notifyTyping
  >
  get copyWith => CopyWith$Mutation$NotifyTyping$notifyTyping(this, (i) => i);
}

abstract class CopyWith$Mutation$NotifyTyping$notifyTyping<TRes> {
  factory CopyWith$Mutation$NotifyTyping$notifyTyping(
    Mutation$NotifyTyping$notifyTyping instance,
    TRes Function(Mutation$NotifyTyping$notifyTyping) then,
  ) = _CopyWithImpl$Mutation$NotifyTyping$notifyTyping;

  factory CopyWith$Mutation$NotifyTyping$notifyTyping.stub(TRes res) =
      _CopyWithStubImpl$Mutation$NotifyTyping$notifyTyping;

  TRes call({
    bool? success,
    List<Mutation$NotifyTyping$notifyTyping$userErrors>? userErrors,
  });
  TRes userErrors(
    Iterable<Mutation$NotifyTyping$notifyTyping$userErrors> Function(
      Iterable<
        CopyWith$Mutation$NotifyTyping$notifyTyping$userErrors<
          Mutation$NotifyTyping$notifyTyping$userErrors
        >
      >,
    )
    _fn,
  );
}

class _CopyWithImpl$Mutation$NotifyTyping$notifyTyping<TRes>
    implements CopyWith$Mutation$NotifyTyping$notifyTyping<TRes> {
  _CopyWithImpl$Mutation$NotifyTyping$notifyTyping(this._instance, this._then);

  final Mutation$NotifyTyping$notifyTyping _instance;

  final TRes Function(Mutation$NotifyTyping$notifyTyping) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? success = _undefined, Object? userErrors = _undefined}) =>
      _then(
        Mutation$NotifyTyping$notifyTyping(
          success: success == _undefined || success == null
              ? _instance.success
              : (success as bool),
          userErrors: userErrors == _undefined || userErrors == null
              ? _instance.userErrors
              : (userErrors
                    as List<Mutation$NotifyTyping$notifyTyping$userErrors>),
        ),
      );

  TRes userErrors(
    Iterable<Mutation$NotifyTyping$notifyTyping$userErrors> Function(
      Iterable<
        CopyWith$Mutation$NotifyTyping$notifyTyping$userErrors<
          Mutation$NotifyTyping$notifyTyping$userErrors
        >
      >,
    )
    _fn,
  ) => call(
    userErrors: _fn(
      _instance.userErrors.map(
        (e) =>
            CopyWith$Mutation$NotifyTyping$notifyTyping$userErrors(e, (i) => i),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl$Mutation$NotifyTyping$notifyTyping<TRes>
    implements CopyWith$Mutation$NotifyTyping$notifyTyping<TRes> {
  _CopyWithStubImpl$Mutation$NotifyTyping$notifyTyping(this._res);

  TRes _res;

  call({
    bool? success,
    List<Mutation$NotifyTyping$notifyTyping$userErrors>? userErrors,
  }) => _res;

  userErrors(_fn) => _res;
}

class Mutation$NotifyTyping$notifyTyping$userErrors {
  Mutation$NotifyTyping$notifyTyping$userErrors({
    required this.code,
    required this.message,
    this.field,
  });

  factory Mutation$NotifyTyping$notifyTyping$userErrors.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$code = json['code'];
    final l$message = json['message'];
    final l$field = json['field'];
    return Mutation$NotifyTyping$notifyTyping$userErrors(
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
    if (other is! Mutation$NotifyTyping$notifyTyping$userErrors ||
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

extension UtilityExtension$Mutation$NotifyTyping$notifyTyping$userErrors
    on Mutation$NotifyTyping$notifyTyping$userErrors {
  CopyWith$Mutation$NotifyTyping$notifyTyping$userErrors<
    Mutation$NotifyTyping$notifyTyping$userErrors
  >
  get copyWith =>
      CopyWith$Mutation$NotifyTyping$notifyTyping$userErrors(this, (i) => i);
}

abstract class CopyWith$Mutation$NotifyTyping$notifyTyping$userErrors<TRes> {
  factory CopyWith$Mutation$NotifyTyping$notifyTyping$userErrors(
    Mutation$NotifyTyping$notifyTyping$userErrors instance,
    TRes Function(Mutation$NotifyTyping$notifyTyping$userErrors) then,
  ) = _CopyWithImpl$Mutation$NotifyTyping$notifyTyping$userErrors;

  factory CopyWith$Mutation$NotifyTyping$notifyTyping$userErrors.stub(
    TRes res,
  ) = _CopyWithStubImpl$Mutation$NotifyTyping$notifyTyping$userErrors;

  TRes call({String? code, String? message, String? field});
}

class _CopyWithImpl$Mutation$NotifyTyping$notifyTyping$userErrors<TRes>
    implements CopyWith$Mutation$NotifyTyping$notifyTyping$userErrors<TRes> {
  _CopyWithImpl$Mutation$NotifyTyping$notifyTyping$userErrors(
    this._instance,
    this._then,
  );

  final Mutation$NotifyTyping$notifyTyping$userErrors _instance;

  final TRes Function(Mutation$NotifyTyping$notifyTyping$userErrors) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? code = _undefined,
    Object? message = _undefined,
    Object? field = _undefined,
  }) => _then(
    Mutation$NotifyTyping$notifyTyping$userErrors(
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

class _CopyWithStubImpl$Mutation$NotifyTyping$notifyTyping$userErrors<TRes>
    implements CopyWith$Mutation$NotifyTyping$notifyTyping$userErrors<TRes> {
  _CopyWithStubImpl$Mutation$NotifyTyping$notifyTyping$userErrors(this._res);

  TRes _res;

  call({String? code, String? message, String? field}) => _res;
}

class Variables$Mutation$MarkConversationRead {
  factory Variables$Mutation$MarkConversationRead({
    required String conversationId,
    String? upToMessageId,
  }) => Variables$Mutation$MarkConversationRead._({
    r'conversationId': conversationId,
    if (upToMessageId != null) r'upToMessageId': upToMessageId,
  });

  Variables$Mutation$MarkConversationRead._(this._$data);

  factory Variables$Mutation$MarkConversationRead.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    final l$conversationId = data['conversationId'];
    result$data['conversationId'] = (l$conversationId as String);
    if (data.containsKey('upToMessageId')) {
      final l$upToMessageId = data['upToMessageId'];
      result$data['upToMessageId'] = (l$upToMessageId as String?);
    }
    return Variables$Mutation$MarkConversationRead._(result$data);
  }

  Map<String, dynamic> _$data;

  String get conversationId => (_$data['conversationId'] as String);

  String? get upToMessageId => (_$data['upToMessageId'] as String?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$conversationId = conversationId;
    result$data['conversationId'] = l$conversationId;
    if (_$data.containsKey('upToMessageId')) {
      final l$upToMessageId = upToMessageId;
      result$data['upToMessageId'] = l$upToMessageId;
    }
    return result$data;
  }

  CopyWith$Variables$Mutation$MarkConversationRead<
    Variables$Mutation$MarkConversationRead
  >
  get copyWith =>
      CopyWith$Variables$Mutation$MarkConversationRead(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Mutation$MarkConversationRead ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$conversationId = conversationId;
    final lOther$conversationId = other.conversationId;
    if (l$conversationId != lOther$conversationId) {
      return false;
    }
    final l$upToMessageId = upToMessageId;
    final lOther$upToMessageId = other.upToMessageId;
    if (_$data.containsKey('upToMessageId') !=
        other._$data.containsKey('upToMessageId')) {
      return false;
    }
    if (l$upToMessageId != lOther$upToMessageId) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$conversationId = conversationId;
    final l$upToMessageId = upToMessageId;
    return Object.hashAll([
      l$conversationId,
      _$data.containsKey('upToMessageId') ? l$upToMessageId : const {},
    ]);
  }
}

abstract class CopyWith$Variables$Mutation$MarkConversationRead<TRes> {
  factory CopyWith$Variables$Mutation$MarkConversationRead(
    Variables$Mutation$MarkConversationRead instance,
    TRes Function(Variables$Mutation$MarkConversationRead) then,
  ) = _CopyWithImpl$Variables$Mutation$MarkConversationRead;

  factory CopyWith$Variables$Mutation$MarkConversationRead.stub(TRes res) =
      _CopyWithStubImpl$Variables$Mutation$MarkConversationRead;

  TRes call({String? conversationId, String? upToMessageId});
}

class _CopyWithImpl$Variables$Mutation$MarkConversationRead<TRes>
    implements CopyWith$Variables$Mutation$MarkConversationRead<TRes> {
  _CopyWithImpl$Variables$Mutation$MarkConversationRead(
    this._instance,
    this._then,
  );

  final Variables$Mutation$MarkConversationRead _instance;

  final TRes Function(Variables$Mutation$MarkConversationRead) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? conversationId = _undefined,
    Object? upToMessageId = _undefined,
  }) => _then(
    Variables$Mutation$MarkConversationRead._({
      ..._instance._$data,
      if (conversationId != _undefined && conversationId != null)
        'conversationId': (conversationId as String),
      if (upToMessageId != _undefined)
        'upToMessageId': (upToMessageId as String?),
    }),
  );
}

class _CopyWithStubImpl$Variables$Mutation$MarkConversationRead<TRes>
    implements CopyWith$Variables$Mutation$MarkConversationRead<TRes> {
  _CopyWithStubImpl$Variables$Mutation$MarkConversationRead(this._res);

  TRes _res;

  call({String? conversationId, String? upToMessageId}) => _res;
}

class Mutation$MarkConversationRead {
  Mutation$MarkConversationRead({required this.markConversationRead});

  factory Mutation$MarkConversationRead.fromJson(Map<String, dynamic> json) {
    final l$markConversationRead = json['markConversationRead'];
    return Mutation$MarkConversationRead(
      markConversationRead:
          Mutation$MarkConversationRead$markConversationRead.fromJson(
            (l$markConversationRead as Map<String, dynamic>),
          ),
    );
  }

  final Mutation$MarkConversationRead$markConversationRead markConversationRead;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$markConversationRead = markConversationRead;
    _resultData['markConversationRead'] = l$markConversationRead.toJson();
    return _resultData;
  }

  @override
  int get hashCode {
    final l$markConversationRead = markConversationRead;
    return Object.hashAll([l$markConversationRead]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$MarkConversationRead ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$markConversationRead = markConversationRead;
    final lOther$markConversationRead = other.markConversationRead;
    if (l$markConversationRead != lOther$markConversationRead) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Mutation$MarkConversationRead
    on Mutation$MarkConversationRead {
  CopyWith$Mutation$MarkConversationRead<Mutation$MarkConversationRead>
  get copyWith => CopyWith$Mutation$MarkConversationRead(this, (i) => i);
}

abstract class CopyWith$Mutation$MarkConversationRead<TRes> {
  factory CopyWith$Mutation$MarkConversationRead(
    Mutation$MarkConversationRead instance,
    TRes Function(Mutation$MarkConversationRead) then,
  ) = _CopyWithImpl$Mutation$MarkConversationRead;

  factory CopyWith$Mutation$MarkConversationRead.stub(TRes res) =
      _CopyWithStubImpl$Mutation$MarkConversationRead;

  TRes call({
    Mutation$MarkConversationRead$markConversationRead? markConversationRead,
  });
  CopyWith$Mutation$MarkConversationRead$markConversationRead<TRes>
  get markConversationRead;
}

class _CopyWithImpl$Mutation$MarkConversationRead<TRes>
    implements CopyWith$Mutation$MarkConversationRead<TRes> {
  _CopyWithImpl$Mutation$MarkConversationRead(this._instance, this._then);

  final Mutation$MarkConversationRead _instance;

  final TRes Function(Mutation$MarkConversationRead) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? markConversationRead = _undefined}) => _then(
    Mutation$MarkConversationRead(
      markConversationRead:
          markConversationRead == _undefined || markConversationRead == null
          ? _instance.markConversationRead
          : (markConversationRead
                as Mutation$MarkConversationRead$markConversationRead),
    ),
  );

  CopyWith$Mutation$MarkConversationRead$markConversationRead<TRes>
  get markConversationRead {
    final local$markConversationRead = _instance.markConversationRead;
    return CopyWith$Mutation$MarkConversationRead$markConversationRead(
      local$markConversationRead,
      (e) => call(markConversationRead: e),
    );
  }
}

class _CopyWithStubImpl$Mutation$MarkConversationRead<TRes>
    implements CopyWith$Mutation$MarkConversationRead<TRes> {
  _CopyWithStubImpl$Mutation$MarkConversationRead(this._res);

  TRes _res;

  call({
    Mutation$MarkConversationRead$markConversationRead? markConversationRead,
  }) => _res;

  CopyWith$Mutation$MarkConversationRead$markConversationRead<TRes>
  get markConversationRead =>
      CopyWith$Mutation$MarkConversationRead$markConversationRead.stub(_res);
}

const documentNodeMutationMarkConversationRead = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'MarkConversationRead'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'conversationId')),
          type: NamedTypeNode(name: NameNode(value: 'ID'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'upToMessageId')),
          type: NamedTypeNode(name: NameNode(value: 'ID'), isNonNull: false),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
      ],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'markConversationRead'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'input'),
                value: ObjectValueNode(
                  fields: [
                    ObjectFieldNode(
                      name: NameNode(value: 'conversationId'),
                      value: VariableNode(
                        name: NameNode(value: 'conversationId'),
                      ),
                    ),
                    ObjectFieldNode(
                      name: NameNode(value: 'upToMessageId'),
                      value: VariableNode(
                        name: NameNode(value: 'upToMessageId'),
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
                  name: NameNode(value: 'unreadCount'),
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

class Mutation$MarkConversationRead$markConversationRead {
  Mutation$MarkConversationRead$markConversationRead({
    required this.success,
    required this.userErrors,
    required this.unreadCount,
  });

  factory Mutation$MarkConversationRead$markConversationRead.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$success = json['success'];
    final l$userErrors = json['userErrors'];
    final l$unreadCount = json['unreadCount'];
    return Mutation$MarkConversationRead$markConversationRead(
      success: (l$success as bool),
      userErrors: (l$userErrors as List<dynamic>)
          .map(
            (e) =>
                Mutation$MarkConversationRead$markConversationRead$userErrors.fromJson(
                  (e as Map<String, dynamic>),
                ),
          )
          .toList(),
      unreadCount: (l$unreadCount as int),
    );
  }

  final bool success;

  final List<Mutation$MarkConversationRead$markConversationRead$userErrors>
  userErrors;

  final int unreadCount;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$success = success;
    _resultData['success'] = l$success;
    final l$userErrors = userErrors;
    _resultData['userErrors'] = l$userErrors.map((e) => e.toJson()).toList();
    final l$unreadCount = unreadCount;
    _resultData['unreadCount'] = l$unreadCount;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$success = success;
    final l$userErrors = userErrors;
    final l$unreadCount = unreadCount;
    return Object.hashAll([
      l$success,
      Object.hashAll(l$userErrors.map((v) => v)),
      l$unreadCount,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$MarkConversationRead$markConversationRead ||
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
    final l$unreadCount = unreadCount;
    final lOther$unreadCount = other.unreadCount;
    if (l$unreadCount != lOther$unreadCount) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Mutation$MarkConversationRead$markConversationRead
    on Mutation$MarkConversationRead$markConversationRead {
  CopyWith$Mutation$MarkConversationRead$markConversationRead<
    Mutation$MarkConversationRead$markConversationRead
  >
  get copyWith => CopyWith$Mutation$MarkConversationRead$markConversationRead(
    this,
    (i) => i,
  );
}

abstract class CopyWith$Mutation$MarkConversationRead$markConversationRead<
  TRes
> {
  factory CopyWith$Mutation$MarkConversationRead$markConversationRead(
    Mutation$MarkConversationRead$markConversationRead instance,
    TRes Function(Mutation$MarkConversationRead$markConversationRead) then,
  ) = _CopyWithImpl$Mutation$MarkConversationRead$markConversationRead;

  factory CopyWith$Mutation$MarkConversationRead$markConversationRead.stub(
    TRes res,
  ) = _CopyWithStubImpl$Mutation$MarkConversationRead$markConversationRead;

  TRes call({
    bool? success,
    List<Mutation$MarkConversationRead$markConversationRead$userErrors>?
    userErrors,
    int? unreadCount,
  });
  TRes userErrors(
    Iterable<Mutation$MarkConversationRead$markConversationRead$userErrors>
    Function(
      Iterable<
        CopyWith$Mutation$MarkConversationRead$markConversationRead$userErrors<
          Mutation$MarkConversationRead$markConversationRead$userErrors
        >
      >,
    )
    _fn,
  );
}

class _CopyWithImpl$Mutation$MarkConversationRead$markConversationRead<TRes>
    implements
        CopyWith$Mutation$MarkConversationRead$markConversationRead<TRes> {
  _CopyWithImpl$Mutation$MarkConversationRead$markConversationRead(
    this._instance,
    this._then,
  );

  final Mutation$MarkConversationRead$markConversationRead _instance;

  final TRes Function(Mutation$MarkConversationRead$markConversationRead) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? success = _undefined,
    Object? userErrors = _undefined,
    Object? unreadCount = _undefined,
  }) => _then(
    Mutation$MarkConversationRead$markConversationRead(
      success: success == _undefined || success == null
          ? _instance.success
          : (success as bool),
      userErrors: userErrors == _undefined || userErrors == null
          ? _instance.userErrors
          : (userErrors
                as List<
                  Mutation$MarkConversationRead$markConversationRead$userErrors
                >),
      unreadCount: unreadCount == _undefined || unreadCount == null
          ? _instance.unreadCount
          : (unreadCount as int),
    ),
  );

  TRes userErrors(
    Iterable<Mutation$MarkConversationRead$markConversationRead$userErrors>
    Function(
      Iterable<
        CopyWith$Mutation$MarkConversationRead$markConversationRead$userErrors<
          Mutation$MarkConversationRead$markConversationRead$userErrors
        >
      >,
    )
    _fn,
  ) => call(
    userErrors: _fn(
      _instance.userErrors.map(
        (e) =>
            CopyWith$Mutation$MarkConversationRead$markConversationRead$userErrors(
              e,
              (i) => i,
            ),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl$Mutation$MarkConversationRead$markConversationRead<TRes>
    implements
        CopyWith$Mutation$MarkConversationRead$markConversationRead<TRes> {
  _CopyWithStubImpl$Mutation$MarkConversationRead$markConversationRead(
    this._res,
  );

  TRes _res;

  call({
    bool? success,
    List<Mutation$MarkConversationRead$markConversationRead$userErrors>?
    userErrors,
    int? unreadCount,
  }) => _res;

  userErrors(_fn) => _res;
}

class Mutation$MarkConversationRead$markConversationRead$userErrors {
  Mutation$MarkConversationRead$markConversationRead$userErrors({
    required this.code,
    required this.message,
    this.field,
  });

  factory Mutation$MarkConversationRead$markConversationRead$userErrors.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$code = json['code'];
    final l$message = json['message'];
    final l$field = json['field'];
    return Mutation$MarkConversationRead$markConversationRead$userErrors(
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
            is! Mutation$MarkConversationRead$markConversationRead$userErrors ||
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

extension UtilityExtension$Mutation$MarkConversationRead$markConversationRead$userErrors
    on Mutation$MarkConversationRead$markConversationRead$userErrors {
  CopyWith$Mutation$MarkConversationRead$markConversationRead$userErrors<
    Mutation$MarkConversationRead$markConversationRead$userErrors
  >
  get copyWith =>
      CopyWith$Mutation$MarkConversationRead$markConversationRead$userErrors(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Mutation$MarkConversationRead$markConversationRead$userErrors<
  TRes
> {
  factory CopyWith$Mutation$MarkConversationRead$markConversationRead$userErrors(
    Mutation$MarkConversationRead$markConversationRead$userErrors instance,
    TRes Function(Mutation$MarkConversationRead$markConversationRead$userErrors)
    then,
  ) = _CopyWithImpl$Mutation$MarkConversationRead$markConversationRead$userErrors;

  factory CopyWith$Mutation$MarkConversationRead$markConversationRead$userErrors.stub(
    TRes res,
  ) = _CopyWithStubImpl$Mutation$MarkConversationRead$markConversationRead$userErrors;

  TRes call({String? code, String? message, String? field});
}

class _CopyWithImpl$Mutation$MarkConversationRead$markConversationRead$userErrors<
  TRes
>
    implements
        CopyWith$Mutation$MarkConversationRead$markConversationRead$userErrors<
          TRes
        > {
  _CopyWithImpl$Mutation$MarkConversationRead$markConversationRead$userErrors(
    this._instance,
    this._then,
  );

  final Mutation$MarkConversationRead$markConversationRead$userErrors _instance;

  final TRes Function(
    Mutation$MarkConversationRead$markConversationRead$userErrors,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? code = _undefined,
    Object? message = _undefined,
    Object? field = _undefined,
  }) => _then(
    Mutation$MarkConversationRead$markConversationRead$userErrors(
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

class _CopyWithStubImpl$Mutation$MarkConversationRead$markConversationRead$userErrors<
  TRes
>
    implements
        CopyWith$Mutation$MarkConversationRead$markConversationRead$userErrors<
          TRes
        > {
  _CopyWithStubImpl$Mutation$MarkConversationRead$markConversationRead$userErrors(
    this._res,
  );

  TRes _res;

  call({String? code, String? message, String? field}) => _res;
}

class Variables$Mutation$ReportMessages {
  factory Variables$Mutation$ReportMessages({
    required List<String> messageIds,
    required Enum$ReportReason reason,
    String? detail,
  }) => Variables$Mutation$ReportMessages._({
    r'messageIds': messageIds,
    r'reason': reason,
    if (detail != null) r'detail': detail,
  });

  Variables$Mutation$ReportMessages._(this._$data);

  factory Variables$Mutation$ReportMessages.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    final l$messageIds = data['messageIds'];
    result$data['messageIds'] = (l$messageIds as List<dynamic>)
        .map((e) => (e as String))
        .toList();
    final l$reason = data['reason'];
    result$data['reason'] = fromJson$Enum$ReportReason((l$reason as String));
    if (data.containsKey('detail')) {
      final l$detail = data['detail'];
      result$data['detail'] = (l$detail as String?);
    }
    return Variables$Mutation$ReportMessages._(result$data);
  }

  Map<String, dynamic> _$data;

  List<String> get messageIds => (_$data['messageIds'] as List<String>);

  Enum$ReportReason get reason => (_$data['reason'] as Enum$ReportReason);

  String? get detail => (_$data['detail'] as String?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$messageIds = messageIds;
    result$data['messageIds'] = l$messageIds.map((e) => e).toList();
    final l$reason = reason;
    result$data['reason'] = toJson$Enum$ReportReason(l$reason);
    if (_$data.containsKey('detail')) {
      final l$detail = detail;
      result$data['detail'] = l$detail;
    }
    return result$data;
  }

  CopyWith$Variables$Mutation$ReportMessages<Variables$Mutation$ReportMessages>
  get copyWith => CopyWith$Variables$Mutation$ReportMessages(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Mutation$ReportMessages ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$messageIds = messageIds;
    final lOther$messageIds = other.messageIds;
    if (l$messageIds.length != lOther$messageIds.length) {
      return false;
    }
    for (int i = 0; i < l$messageIds.length; i++) {
      final l$messageIds$entry = l$messageIds[i];
      final lOther$messageIds$entry = lOther$messageIds[i];
      if (l$messageIds$entry != lOther$messageIds$entry) {
        return false;
      }
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
    final l$messageIds = messageIds;
    final l$reason = reason;
    final l$detail = detail;
    return Object.hashAll([
      Object.hashAll(l$messageIds.map((v) => v)),
      l$reason,
      _$data.containsKey('detail') ? l$detail : const {},
    ]);
  }
}

abstract class CopyWith$Variables$Mutation$ReportMessages<TRes> {
  factory CopyWith$Variables$Mutation$ReportMessages(
    Variables$Mutation$ReportMessages instance,
    TRes Function(Variables$Mutation$ReportMessages) then,
  ) = _CopyWithImpl$Variables$Mutation$ReportMessages;

  factory CopyWith$Variables$Mutation$ReportMessages.stub(TRes res) =
      _CopyWithStubImpl$Variables$Mutation$ReportMessages;

  TRes call({
    List<String>? messageIds,
    Enum$ReportReason? reason,
    String? detail,
  });
}

class _CopyWithImpl$Variables$Mutation$ReportMessages<TRes>
    implements CopyWith$Variables$Mutation$ReportMessages<TRes> {
  _CopyWithImpl$Variables$Mutation$ReportMessages(this._instance, this._then);

  final Variables$Mutation$ReportMessages _instance;

  final TRes Function(Variables$Mutation$ReportMessages) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? messageIds = _undefined,
    Object? reason = _undefined,
    Object? detail = _undefined,
  }) => _then(
    Variables$Mutation$ReportMessages._({
      ..._instance._$data,
      if (messageIds != _undefined && messageIds != null)
        'messageIds': (messageIds as List<String>),
      if (reason != _undefined && reason != null)
        'reason': (reason as Enum$ReportReason),
      if (detail != _undefined) 'detail': (detail as String?),
    }),
  );
}

class _CopyWithStubImpl$Variables$Mutation$ReportMessages<TRes>
    implements CopyWith$Variables$Mutation$ReportMessages<TRes> {
  _CopyWithStubImpl$Variables$Mutation$ReportMessages(this._res);

  TRes _res;

  call({List<String>? messageIds, Enum$ReportReason? reason, String? detail}) =>
      _res;
}

class Mutation$ReportMessages {
  Mutation$ReportMessages({required this.reportMessages});

  factory Mutation$ReportMessages.fromJson(Map<String, dynamic> json) {
    final l$reportMessages = json['reportMessages'];
    return Mutation$ReportMessages(
      reportMessages: Mutation$ReportMessages$reportMessages.fromJson(
        (l$reportMessages as Map<String, dynamic>),
      ),
    );
  }

  final Mutation$ReportMessages$reportMessages reportMessages;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$reportMessages = reportMessages;
    _resultData['reportMessages'] = l$reportMessages.toJson();
    return _resultData;
  }

  @override
  int get hashCode {
    final l$reportMessages = reportMessages;
    return Object.hashAll([l$reportMessages]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$ReportMessages || runtimeType != other.runtimeType) {
      return false;
    }
    final l$reportMessages = reportMessages;
    final lOther$reportMessages = other.reportMessages;
    if (l$reportMessages != lOther$reportMessages) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Mutation$ReportMessages on Mutation$ReportMessages {
  CopyWith$Mutation$ReportMessages<Mutation$ReportMessages> get copyWith =>
      CopyWith$Mutation$ReportMessages(this, (i) => i);
}

abstract class CopyWith$Mutation$ReportMessages<TRes> {
  factory CopyWith$Mutation$ReportMessages(
    Mutation$ReportMessages instance,
    TRes Function(Mutation$ReportMessages) then,
  ) = _CopyWithImpl$Mutation$ReportMessages;

  factory CopyWith$Mutation$ReportMessages.stub(TRes res) =
      _CopyWithStubImpl$Mutation$ReportMessages;

  TRes call({Mutation$ReportMessages$reportMessages? reportMessages});
  CopyWith$Mutation$ReportMessages$reportMessages<TRes> get reportMessages;
}

class _CopyWithImpl$Mutation$ReportMessages<TRes>
    implements CopyWith$Mutation$ReportMessages<TRes> {
  _CopyWithImpl$Mutation$ReportMessages(this._instance, this._then);

  final Mutation$ReportMessages _instance;

  final TRes Function(Mutation$ReportMessages) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? reportMessages = _undefined}) => _then(
    Mutation$ReportMessages(
      reportMessages: reportMessages == _undefined || reportMessages == null
          ? _instance.reportMessages
          : (reportMessages as Mutation$ReportMessages$reportMessages),
    ),
  );

  CopyWith$Mutation$ReportMessages$reportMessages<TRes> get reportMessages {
    final local$reportMessages = _instance.reportMessages;
    return CopyWith$Mutation$ReportMessages$reportMessages(
      local$reportMessages,
      (e) => call(reportMessages: e),
    );
  }
}

class _CopyWithStubImpl$Mutation$ReportMessages<TRes>
    implements CopyWith$Mutation$ReportMessages<TRes> {
  _CopyWithStubImpl$Mutation$ReportMessages(this._res);

  TRes _res;

  call({Mutation$ReportMessages$reportMessages? reportMessages}) => _res;

  CopyWith$Mutation$ReportMessages$reportMessages<TRes> get reportMessages =>
      CopyWith$Mutation$ReportMessages$reportMessages.stub(_res);
}

const documentNodeMutationReportMessages = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'ReportMessages'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'messageIds')),
          type: ListTypeNode(
            type: NamedTypeNode(name: NameNode(value: 'ID'), isNonNull: true),
            isNonNull: true,
          ),
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
            name: NameNode(value: 'reportMessages'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'input'),
                value: ObjectValueNode(
                  fields: [
                    ObjectFieldNode(
                      name: NameNode(value: 'messageIds'),
                      value: VariableNode(name: NameNode(value: 'messageIds')),
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

class Mutation$ReportMessages$reportMessages {
  Mutation$ReportMessages$reportMessages({
    required this.success,
    required this.userErrors,
  });

  factory Mutation$ReportMessages$reportMessages.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$success = json['success'];
    final l$userErrors = json['userErrors'];
    return Mutation$ReportMessages$reportMessages(
      success: (l$success as bool),
      userErrors: (l$userErrors as List<dynamic>)
          .map(
            (e) => Mutation$ReportMessages$reportMessages$userErrors.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
    );
  }

  final bool success;

  final List<Mutation$ReportMessages$reportMessages$userErrors> userErrors;

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
    if (other is! Mutation$ReportMessages$reportMessages ||
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

extension UtilityExtension$Mutation$ReportMessages$reportMessages
    on Mutation$ReportMessages$reportMessages {
  CopyWith$Mutation$ReportMessages$reportMessages<
    Mutation$ReportMessages$reportMessages
  >
  get copyWith =>
      CopyWith$Mutation$ReportMessages$reportMessages(this, (i) => i);
}

abstract class CopyWith$Mutation$ReportMessages$reportMessages<TRes> {
  factory CopyWith$Mutation$ReportMessages$reportMessages(
    Mutation$ReportMessages$reportMessages instance,
    TRes Function(Mutation$ReportMessages$reportMessages) then,
  ) = _CopyWithImpl$Mutation$ReportMessages$reportMessages;

  factory CopyWith$Mutation$ReportMessages$reportMessages.stub(TRes res) =
      _CopyWithStubImpl$Mutation$ReportMessages$reportMessages;

  TRes call({
    bool? success,
    List<Mutation$ReportMessages$reportMessages$userErrors>? userErrors,
  });
  TRes userErrors(
    Iterable<Mutation$ReportMessages$reportMessages$userErrors> Function(
      Iterable<
        CopyWith$Mutation$ReportMessages$reportMessages$userErrors<
          Mutation$ReportMessages$reportMessages$userErrors
        >
      >,
    )
    _fn,
  );
}

class _CopyWithImpl$Mutation$ReportMessages$reportMessages<TRes>
    implements CopyWith$Mutation$ReportMessages$reportMessages<TRes> {
  _CopyWithImpl$Mutation$ReportMessages$reportMessages(
    this._instance,
    this._then,
  );

  final Mutation$ReportMessages$reportMessages _instance;

  final TRes Function(Mutation$ReportMessages$reportMessages) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? success = _undefined, Object? userErrors = _undefined}) =>
      _then(
        Mutation$ReportMessages$reportMessages(
          success: success == _undefined || success == null
              ? _instance.success
              : (success as bool),
          userErrors: userErrors == _undefined || userErrors == null
              ? _instance.userErrors
              : (userErrors
                    as List<Mutation$ReportMessages$reportMessages$userErrors>),
        ),
      );

  TRes userErrors(
    Iterable<Mutation$ReportMessages$reportMessages$userErrors> Function(
      Iterable<
        CopyWith$Mutation$ReportMessages$reportMessages$userErrors<
          Mutation$ReportMessages$reportMessages$userErrors
        >
      >,
    )
    _fn,
  ) => call(
    userErrors: _fn(
      _instance.userErrors.map(
        (e) => CopyWith$Mutation$ReportMessages$reportMessages$userErrors(
          e,
          (i) => i,
        ),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl$Mutation$ReportMessages$reportMessages<TRes>
    implements CopyWith$Mutation$ReportMessages$reportMessages<TRes> {
  _CopyWithStubImpl$Mutation$ReportMessages$reportMessages(this._res);

  TRes _res;

  call({
    bool? success,
    List<Mutation$ReportMessages$reportMessages$userErrors>? userErrors,
  }) => _res;

  userErrors(_fn) => _res;
}

class Mutation$ReportMessages$reportMessages$userErrors {
  Mutation$ReportMessages$reportMessages$userErrors({
    required this.code,
    required this.message,
    this.field,
  });

  factory Mutation$ReportMessages$reportMessages$userErrors.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$code = json['code'];
    final l$message = json['message'];
    final l$field = json['field'];
    return Mutation$ReportMessages$reportMessages$userErrors(
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
    if (other is! Mutation$ReportMessages$reportMessages$userErrors ||
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

extension UtilityExtension$Mutation$ReportMessages$reportMessages$userErrors
    on Mutation$ReportMessages$reportMessages$userErrors {
  CopyWith$Mutation$ReportMessages$reportMessages$userErrors<
    Mutation$ReportMessages$reportMessages$userErrors
  >
  get copyWith => CopyWith$Mutation$ReportMessages$reportMessages$userErrors(
    this,
    (i) => i,
  );
}

abstract class CopyWith$Mutation$ReportMessages$reportMessages$userErrors<
  TRes
> {
  factory CopyWith$Mutation$ReportMessages$reportMessages$userErrors(
    Mutation$ReportMessages$reportMessages$userErrors instance,
    TRes Function(Mutation$ReportMessages$reportMessages$userErrors) then,
  ) = _CopyWithImpl$Mutation$ReportMessages$reportMessages$userErrors;

  factory CopyWith$Mutation$ReportMessages$reportMessages$userErrors.stub(
    TRes res,
  ) = _CopyWithStubImpl$Mutation$ReportMessages$reportMessages$userErrors;

  TRes call({String? code, String? message, String? field});
}

class _CopyWithImpl$Mutation$ReportMessages$reportMessages$userErrors<TRes>
    implements
        CopyWith$Mutation$ReportMessages$reportMessages$userErrors<TRes> {
  _CopyWithImpl$Mutation$ReportMessages$reportMessages$userErrors(
    this._instance,
    this._then,
  );

  final Mutation$ReportMessages$reportMessages$userErrors _instance;

  final TRes Function(Mutation$ReportMessages$reportMessages$userErrors) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? code = _undefined,
    Object? message = _undefined,
    Object? field = _undefined,
  }) => _then(
    Mutation$ReportMessages$reportMessages$userErrors(
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

class _CopyWithStubImpl$Mutation$ReportMessages$reportMessages$userErrors<TRes>
    implements
        CopyWith$Mutation$ReportMessages$reportMessages$userErrors<TRes> {
  _CopyWithStubImpl$Mutation$ReportMessages$reportMessages$userErrors(
    this._res,
  );

  TRes _res;

  call({String? code, String? message, String? field}) => _res;
}

class Variables$Subscription$TypingIndicator {
  factory Variables$Subscription$TypingIndicator({
    required String conversationId,
  }) => Variables$Subscription$TypingIndicator._({
    r'conversationId': conversationId,
  });

  Variables$Subscription$TypingIndicator._(this._$data);

  factory Variables$Subscription$TypingIndicator.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    final l$conversationId = data['conversationId'];
    result$data['conversationId'] = (l$conversationId as String);
    return Variables$Subscription$TypingIndicator._(result$data);
  }

  Map<String, dynamic> _$data;

  String get conversationId => (_$data['conversationId'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$conversationId = conversationId;
    result$data['conversationId'] = l$conversationId;
    return result$data;
  }

  CopyWith$Variables$Subscription$TypingIndicator<
    Variables$Subscription$TypingIndicator
  >
  get copyWith =>
      CopyWith$Variables$Subscription$TypingIndicator(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Subscription$TypingIndicator ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$conversationId = conversationId;
    final lOther$conversationId = other.conversationId;
    if (l$conversationId != lOther$conversationId) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$conversationId = conversationId;
    return Object.hashAll([l$conversationId]);
  }
}

abstract class CopyWith$Variables$Subscription$TypingIndicator<TRes> {
  factory CopyWith$Variables$Subscription$TypingIndicator(
    Variables$Subscription$TypingIndicator instance,
    TRes Function(Variables$Subscription$TypingIndicator) then,
  ) = _CopyWithImpl$Variables$Subscription$TypingIndicator;

  factory CopyWith$Variables$Subscription$TypingIndicator.stub(TRes res) =
      _CopyWithStubImpl$Variables$Subscription$TypingIndicator;

  TRes call({String? conversationId});
}

class _CopyWithImpl$Variables$Subscription$TypingIndicator<TRes>
    implements CopyWith$Variables$Subscription$TypingIndicator<TRes> {
  _CopyWithImpl$Variables$Subscription$TypingIndicator(
    this._instance,
    this._then,
  );

  final Variables$Subscription$TypingIndicator _instance;

  final TRes Function(Variables$Subscription$TypingIndicator) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? conversationId = _undefined}) => _then(
    Variables$Subscription$TypingIndicator._({
      ..._instance._$data,
      if (conversationId != _undefined && conversationId != null)
        'conversationId': (conversationId as String),
    }),
  );
}

class _CopyWithStubImpl$Variables$Subscription$TypingIndicator<TRes>
    implements CopyWith$Variables$Subscription$TypingIndicator<TRes> {
  _CopyWithStubImpl$Variables$Subscription$TypingIndicator(this._res);

  TRes _res;

  call({String? conversationId}) => _res;
}

class Subscription$TypingIndicator {
  Subscription$TypingIndicator({required this.typingIndicator});

  factory Subscription$TypingIndicator.fromJson(Map<String, dynamic> json) {
    final l$typingIndicator = json['typingIndicator'];
    return Subscription$TypingIndicator(
      typingIndicator: Subscription$TypingIndicator$typingIndicator.fromJson(
        (l$typingIndicator as Map<String, dynamic>),
      ),
    );
  }

  final Subscription$TypingIndicator$typingIndicator typingIndicator;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$typingIndicator = typingIndicator;
    _resultData['typingIndicator'] = l$typingIndicator.toJson();
    return _resultData;
  }

  @override
  int get hashCode {
    final l$typingIndicator = typingIndicator;
    return Object.hashAll([l$typingIndicator]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Subscription$TypingIndicator ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$typingIndicator = typingIndicator;
    final lOther$typingIndicator = other.typingIndicator;
    if (l$typingIndicator != lOther$typingIndicator) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Subscription$TypingIndicator
    on Subscription$TypingIndicator {
  CopyWith$Subscription$TypingIndicator<Subscription$TypingIndicator>
  get copyWith => CopyWith$Subscription$TypingIndicator(this, (i) => i);
}

abstract class CopyWith$Subscription$TypingIndicator<TRes> {
  factory CopyWith$Subscription$TypingIndicator(
    Subscription$TypingIndicator instance,
    TRes Function(Subscription$TypingIndicator) then,
  ) = _CopyWithImpl$Subscription$TypingIndicator;

  factory CopyWith$Subscription$TypingIndicator.stub(TRes res) =
      _CopyWithStubImpl$Subscription$TypingIndicator;

  TRes call({Subscription$TypingIndicator$typingIndicator? typingIndicator});
  CopyWith$Subscription$TypingIndicator$typingIndicator<TRes>
  get typingIndicator;
}

class _CopyWithImpl$Subscription$TypingIndicator<TRes>
    implements CopyWith$Subscription$TypingIndicator<TRes> {
  _CopyWithImpl$Subscription$TypingIndicator(this._instance, this._then);

  final Subscription$TypingIndicator _instance;

  final TRes Function(Subscription$TypingIndicator) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? typingIndicator = _undefined}) => _then(
    Subscription$TypingIndicator(
      typingIndicator: typingIndicator == _undefined || typingIndicator == null
          ? _instance.typingIndicator
          : (typingIndicator as Subscription$TypingIndicator$typingIndicator),
    ),
  );

  CopyWith$Subscription$TypingIndicator$typingIndicator<TRes>
  get typingIndicator {
    final local$typingIndicator = _instance.typingIndicator;
    return CopyWith$Subscription$TypingIndicator$typingIndicator(
      local$typingIndicator,
      (e) => call(typingIndicator: e),
    );
  }
}

class _CopyWithStubImpl$Subscription$TypingIndicator<TRes>
    implements CopyWith$Subscription$TypingIndicator<TRes> {
  _CopyWithStubImpl$Subscription$TypingIndicator(this._res);

  TRes _res;

  call({Subscription$TypingIndicator$typingIndicator? typingIndicator}) => _res;

  CopyWith$Subscription$TypingIndicator$typingIndicator<TRes>
  get typingIndicator =>
      CopyWith$Subscription$TypingIndicator$typingIndicator.stub(_res);
}

const documentNodeSubscriptionTypingIndicator = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.subscription,
      name: NameNode(value: 'TypingIndicator'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'conversationId')),
          type: NamedTypeNode(name: NameNode(value: 'ID'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
      ],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'typingIndicator'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'conversationId'),
                value: VariableNode(name: NameNode(value: 'conversationId')),
              ),
            ],
            directives: [],
            selectionSet: SelectionSetNode(
              selections: [
                FieldNode(
                  name: NameNode(value: 'sender'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: SelectionSetNode(
                    selections: [
                      FragmentSpreadNode(
                        name: NameNode(value: 'DmAuthorParts'),
                        directives: [],
                      ),
                    ],
                  ),
                ),
                FieldNode(
                  name: NameNode(value: 'emittedAt'),
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
    fragmentDefinitionDmAuthorParts,
  ],
);

class Subscription$TypingIndicator$typingIndicator {
  Subscription$TypingIndicator$typingIndicator({
    required this.sender,
    required this.emittedAt,
  });

  factory Subscription$TypingIndicator$typingIndicator.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$sender = json['sender'];
    final l$emittedAt = json['emittedAt'];
    return Subscription$TypingIndicator$typingIndicator(
      sender: Fragment$DmAuthorParts.fromJson(
        (l$sender as Map<String, dynamic>),
      ),
      emittedAt: (l$emittedAt as String),
    );
  }

  final Fragment$DmAuthorParts sender;

  final String emittedAt;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$sender = sender;
    _resultData['sender'] = l$sender.toJson();
    final l$emittedAt = emittedAt;
    _resultData['emittedAt'] = l$emittedAt;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$sender = sender;
    final l$emittedAt = emittedAt;
    return Object.hashAll([l$sender, l$emittedAt]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Subscription$TypingIndicator$typingIndicator ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$sender = sender;
    final lOther$sender = other.sender;
    if (l$sender != lOther$sender) {
      return false;
    }
    final l$emittedAt = emittedAt;
    final lOther$emittedAt = other.emittedAt;
    if (l$emittedAt != lOther$emittedAt) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Subscription$TypingIndicator$typingIndicator
    on Subscription$TypingIndicator$typingIndicator {
  CopyWith$Subscription$TypingIndicator$typingIndicator<
    Subscription$TypingIndicator$typingIndicator
  >
  get copyWith =>
      CopyWith$Subscription$TypingIndicator$typingIndicator(this, (i) => i);
}

abstract class CopyWith$Subscription$TypingIndicator$typingIndicator<TRes> {
  factory CopyWith$Subscription$TypingIndicator$typingIndicator(
    Subscription$TypingIndicator$typingIndicator instance,
    TRes Function(Subscription$TypingIndicator$typingIndicator) then,
  ) = _CopyWithImpl$Subscription$TypingIndicator$typingIndicator;

  factory CopyWith$Subscription$TypingIndicator$typingIndicator.stub(TRes res) =
      _CopyWithStubImpl$Subscription$TypingIndicator$typingIndicator;

  TRes call({Fragment$DmAuthorParts? sender, String? emittedAt});
  CopyWith$Fragment$DmAuthorParts<TRes> get sender;
}

class _CopyWithImpl$Subscription$TypingIndicator$typingIndicator<TRes>
    implements CopyWith$Subscription$TypingIndicator$typingIndicator<TRes> {
  _CopyWithImpl$Subscription$TypingIndicator$typingIndicator(
    this._instance,
    this._then,
  );

  final Subscription$TypingIndicator$typingIndicator _instance;

  final TRes Function(Subscription$TypingIndicator$typingIndicator) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? sender = _undefined, Object? emittedAt = _undefined}) =>
      _then(
        Subscription$TypingIndicator$typingIndicator(
          sender: sender == _undefined || sender == null
              ? _instance.sender
              : (sender as Fragment$DmAuthorParts),
          emittedAt: emittedAt == _undefined || emittedAt == null
              ? _instance.emittedAt
              : (emittedAt as String),
        ),
      );

  CopyWith$Fragment$DmAuthorParts<TRes> get sender {
    final local$sender = _instance.sender;
    return CopyWith$Fragment$DmAuthorParts(
      local$sender,
      (e) => call(sender: e),
    );
  }
}

class _CopyWithStubImpl$Subscription$TypingIndicator$typingIndicator<TRes>
    implements CopyWith$Subscription$TypingIndicator$typingIndicator<TRes> {
  _CopyWithStubImpl$Subscription$TypingIndicator$typingIndicator(this._res);

  TRes _res;

  call({Fragment$DmAuthorParts? sender, String? emittedAt}) => _res;

  CopyWith$Fragment$DmAuthorParts<TRes> get sender =>
      CopyWith$Fragment$DmAuthorParts.stub(_res);
}

class Variables$Subscription$NewMessage {
  factory Variables$Subscription$NewMessage({required String conversationId}) =>
      Variables$Subscription$NewMessage._({r'conversationId': conversationId});

  Variables$Subscription$NewMessage._(this._$data);

  factory Variables$Subscription$NewMessage.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    final l$conversationId = data['conversationId'];
    result$data['conversationId'] = (l$conversationId as String);
    return Variables$Subscription$NewMessage._(result$data);
  }

  Map<String, dynamic> _$data;

  String get conversationId => (_$data['conversationId'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$conversationId = conversationId;
    result$data['conversationId'] = l$conversationId;
    return result$data;
  }

  CopyWith$Variables$Subscription$NewMessage<Variables$Subscription$NewMessage>
  get copyWith => CopyWith$Variables$Subscription$NewMessage(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Subscription$NewMessage ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$conversationId = conversationId;
    final lOther$conversationId = other.conversationId;
    if (l$conversationId != lOther$conversationId) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$conversationId = conversationId;
    return Object.hashAll([l$conversationId]);
  }
}

abstract class CopyWith$Variables$Subscription$NewMessage<TRes> {
  factory CopyWith$Variables$Subscription$NewMessage(
    Variables$Subscription$NewMessage instance,
    TRes Function(Variables$Subscription$NewMessage) then,
  ) = _CopyWithImpl$Variables$Subscription$NewMessage;

  factory CopyWith$Variables$Subscription$NewMessage.stub(TRes res) =
      _CopyWithStubImpl$Variables$Subscription$NewMessage;

  TRes call({String? conversationId});
}

class _CopyWithImpl$Variables$Subscription$NewMessage<TRes>
    implements CopyWith$Variables$Subscription$NewMessage<TRes> {
  _CopyWithImpl$Variables$Subscription$NewMessage(this._instance, this._then);

  final Variables$Subscription$NewMessage _instance;

  final TRes Function(Variables$Subscription$NewMessage) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? conversationId = _undefined}) => _then(
    Variables$Subscription$NewMessage._({
      ..._instance._$data,
      if (conversationId != _undefined && conversationId != null)
        'conversationId': (conversationId as String),
    }),
  );
}

class _CopyWithStubImpl$Variables$Subscription$NewMessage<TRes>
    implements CopyWith$Variables$Subscription$NewMessage<TRes> {
  _CopyWithStubImpl$Variables$Subscription$NewMessage(this._res);

  TRes _res;

  call({String? conversationId}) => _res;
}

class Subscription$NewMessage {
  Subscription$NewMessage({required this.newMessage});

  factory Subscription$NewMessage.fromJson(Map<String, dynamic> json) {
    final l$newMessage = json['newMessage'];
    return Subscription$NewMessage(
      newMessage: Fragment$MessageParts.fromJson(
        (l$newMessage as Map<String, dynamic>),
      ),
    );
  }

  final Fragment$MessageParts newMessage;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$newMessage = newMessage;
    _resultData['newMessage'] = l$newMessage.toJson();
    return _resultData;
  }

  @override
  int get hashCode {
    final l$newMessage = newMessage;
    return Object.hashAll([l$newMessage]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Subscription$NewMessage || runtimeType != other.runtimeType) {
      return false;
    }
    final l$newMessage = newMessage;
    final lOther$newMessage = other.newMessage;
    if (l$newMessage != lOther$newMessage) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Subscription$NewMessage on Subscription$NewMessage {
  CopyWith$Subscription$NewMessage<Subscription$NewMessage> get copyWith =>
      CopyWith$Subscription$NewMessage(this, (i) => i);
}

abstract class CopyWith$Subscription$NewMessage<TRes> {
  factory CopyWith$Subscription$NewMessage(
    Subscription$NewMessage instance,
    TRes Function(Subscription$NewMessage) then,
  ) = _CopyWithImpl$Subscription$NewMessage;

  factory CopyWith$Subscription$NewMessage.stub(TRes res) =
      _CopyWithStubImpl$Subscription$NewMessage;

  TRes call({Fragment$MessageParts? newMessage});
  CopyWith$Fragment$MessageParts<TRes> get newMessage;
}

class _CopyWithImpl$Subscription$NewMessage<TRes>
    implements CopyWith$Subscription$NewMessage<TRes> {
  _CopyWithImpl$Subscription$NewMessage(this._instance, this._then);

  final Subscription$NewMessage _instance;

  final TRes Function(Subscription$NewMessage) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? newMessage = _undefined}) => _then(
    Subscription$NewMessage(
      newMessage: newMessage == _undefined || newMessage == null
          ? _instance.newMessage
          : (newMessage as Fragment$MessageParts),
    ),
  );

  CopyWith$Fragment$MessageParts<TRes> get newMessage {
    final local$newMessage = _instance.newMessage;
    return CopyWith$Fragment$MessageParts(
      local$newMessage,
      (e) => call(newMessage: e),
    );
  }
}

class _CopyWithStubImpl$Subscription$NewMessage<TRes>
    implements CopyWith$Subscription$NewMessage<TRes> {
  _CopyWithStubImpl$Subscription$NewMessage(this._res);

  TRes _res;

  call({Fragment$MessageParts? newMessage}) => _res;

  CopyWith$Fragment$MessageParts<TRes> get newMessage =>
      CopyWith$Fragment$MessageParts.stub(_res);
}

const documentNodeSubscriptionNewMessage = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.subscription,
      name: NameNode(value: 'NewMessage'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'conversationId')),
          type: NamedTypeNode(name: NameNode(value: 'ID'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
      ],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'newMessage'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'conversationId'),
                value: VariableNode(name: NameNode(value: 'conversationId')),
              ),
            ],
            directives: [],
            selectionSet: SelectionSetNode(
              selections: [
                FragmentSpreadNode(
                  name: NameNode(value: 'MessageParts'),
                  directives: [],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
    fragmentDefinitionMessageParts,
    fragmentDefinitionDmAuthorParts,
  ],
);
