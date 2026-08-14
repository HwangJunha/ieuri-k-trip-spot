// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, unused_element
import '../../community/repository/community_schema.graphql.dart';

class Input$CreateFeedItemInput {
  factory Input$CreateFeedItemInput({
    required String body,
    required String catalogId,
    required List<String> photoKeys,
  }) => Input$CreateFeedItemInput._({
    r'body': body,
    r'catalogId': catalogId,
    r'photoKeys': photoKeys,
  });

  Input$CreateFeedItemInput._(this._$data);

  factory Input$CreateFeedItemInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$body = data['body'];
    result$data['body'] = (l$body as String);
    final l$catalogId = data['catalogId'];
    result$data['catalogId'] = (l$catalogId as String);
    final l$photoKeys = data['photoKeys'];
    result$data['photoKeys'] = (l$photoKeys as List<dynamic>)
        .map((e) => (e as String))
        .toList();
    return Input$CreateFeedItemInput._(result$data);
  }

  Map<String, dynamic> _$data;

  String get body => (_$data['body'] as String);

  String get catalogId => (_$data['catalogId'] as String);

  List<String> get photoKeys => (_$data['photoKeys'] as List<String>);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$body = body;
    result$data['body'] = l$body;
    final l$catalogId = catalogId;
    result$data['catalogId'] = l$catalogId;
    final l$photoKeys = photoKeys;
    result$data['photoKeys'] = l$photoKeys.map((e) => e).toList();
    return result$data;
  }

  CopyWith$Input$CreateFeedItemInput<Input$CreateFeedItemInput> get copyWith =>
      CopyWith$Input$CreateFeedItemInput(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Input$CreateFeedItemInput ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$body = body;
    final lOther$body = other.body;
    if (l$body != lOther$body) {
      return false;
    }
    final l$catalogId = catalogId;
    final lOther$catalogId = other.catalogId;
    if (l$catalogId != lOther$catalogId) {
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
    final l$body = body;
    final l$catalogId = catalogId;
    final l$photoKeys = photoKeys;
    return Object.hashAll([
      l$body,
      l$catalogId,
      Object.hashAll(l$photoKeys.map((v) => v)),
    ]);
  }
}

abstract class CopyWith$Input$CreateFeedItemInput<TRes> {
  factory CopyWith$Input$CreateFeedItemInput(
    Input$CreateFeedItemInput instance,
    TRes Function(Input$CreateFeedItemInput) then,
  ) = _CopyWithImpl$Input$CreateFeedItemInput;

  factory CopyWith$Input$CreateFeedItemInput.stub(TRes res) =
      _CopyWithStubImpl$Input$CreateFeedItemInput;

  TRes call({String? body, String? catalogId, List<String>? photoKeys});
}

class _CopyWithImpl$Input$CreateFeedItemInput<TRes>
    implements CopyWith$Input$CreateFeedItemInput<TRes> {
  _CopyWithImpl$Input$CreateFeedItemInput(this._instance, this._then);

  final Input$CreateFeedItemInput _instance;

  final TRes Function(Input$CreateFeedItemInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? body = _undefined,
    Object? catalogId = _undefined,
    Object? photoKeys = _undefined,
  }) => _then(
    Input$CreateFeedItemInput._({
      ..._instance._$data,
      if (body != _undefined && body != null) 'body': (body as String),
      if (catalogId != _undefined && catalogId != null)
        'catalogId': (catalogId as String),
      if (photoKeys != _undefined && photoKeys != null)
        'photoKeys': (photoKeys as List<String>),
    }),
  );
}

class _CopyWithStubImpl$Input$CreateFeedItemInput<TRes>
    implements CopyWith$Input$CreateFeedItemInput<TRes> {
  _CopyWithStubImpl$Input$CreateFeedItemInput(this._res);

  TRes _res;

  call({String? body, String? catalogId, List<String>? photoKeys}) => _res;
}

class Input$LikeFeedItemInput {
  factory Input$LikeFeedItemInput({required String feedItemId}) =>
      Input$LikeFeedItemInput._({r'feedItemId': feedItemId});

  Input$LikeFeedItemInput._(this._$data);

  factory Input$LikeFeedItemInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$feedItemId = data['feedItemId'];
    result$data['feedItemId'] = (l$feedItemId as String);
    return Input$LikeFeedItemInput._(result$data);
  }

  Map<String, dynamic> _$data;

  String get feedItemId => (_$data['feedItemId'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$feedItemId = feedItemId;
    result$data['feedItemId'] = l$feedItemId;
    return result$data;
  }

  CopyWith$Input$LikeFeedItemInput<Input$LikeFeedItemInput> get copyWith =>
      CopyWith$Input$LikeFeedItemInput(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Input$LikeFeedItemInput || runtimeType != other.runtimeType) {
      return false;
    }
    final l$feedItemId = feedItemId;
    final lOther$feedItemId = other.feedItemId;
    if (l$feedItemId != lOther$feedItemId) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$feedItemId = feedItemId;
    return Object.hashAll([l$feedItemId]);
  }
}

abstract class CopyWith$Input$LikeFeedItemInput<TRes> {
  factory CopyWith$Input$LikeFeedItemInput(
    Input$LikeFeedItemInput instance,
    TRes Function(Input$LikeFeedItemInput) then,
  ) = _CopyWithImpl$Input$LikeFeedItemInput;

  factory CopyWith$Input$LikeFeedItemInput.stub(TRes res) =
      _CopyWithStubImpl$Input$LikeFeedItemInput;

  TRes call({String? feedItemId});
}

class _CopyWithImpl$Input$LikeFeedItemInput<TRes>
    implements CopyWith$Input$LikeFeedItemInput<TRes> {
  _CopyWithImpl$Input$LikeFeedItemInput(this._instance, this._then);

  final Input$LikeFeedItemInput _instance;

  final TRes Function(Input$LikeFeedItemInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? feedItemId = _undefined}) => _then(
    Input$LikeFeedItemInput._({
      ..._instance._$data,
      if (feedItemId != _undefined && feedItemId != null)
        'feedItemId': (feedItemId as String),
    }),
  );
}

class _CopyWithStubImpl$Input$LikeFeedItemInput<TRes>
    implements CopyWith$Input$LikeFeedItemInput<TRes> {
  _CopyWithStubImpl$Input$LikeFeedItemInput(this._res);

  TRes _res;

  call({String? feedItemId}) => _res;
}

class Input$UnlikeFeedItemInput {
  factory Input$UnlikeFeedItemInput({required String feedItemId}) =>
      Input$UnlikeFeedItemInput._({r'feedItemId': feedItemId});

  Input$UnlikeFeedItemInput._(this._$data);

  factory Input$UnlikeFeedItemInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$feedItemId = data['feedItemId'];
    result$data['feedItemId'] = (l$feedItemId as String);
    return Input$UnlikeFeedItemInput._(result$data);
  }

  Map<String, dynamic> _$data;

  String get feedItemId => (_$data['feedItemId'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$feedItemId = feedItemId;
    result$data['feedItemId'] = l$feedItemId;
    return result$data;
  }

  CopyWith$Input$UnlikeFeedItemInput<Input$UnlikeFeedItemInput> get copyWith =>
      CopyWith$Input$UnlikeFeedItemInput(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Input$UnlikeFeedItemInput ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$feedItemId = feedItemId;
    final lOther$feedItemId = other.feedItemId;
    if (l$feedItemId != lOther$feedItemId) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$feedItemId = feedItemId;
    return Object.hashAll([l$feedItemId]);
  }
}

abstract class CopyWith$Input$UnlikeFeedItemInput<TRes> {
  factory CopyWith$Input$UnlikeFeedItemInput(
    Input$UnlikeFeedItemInput instance,
    TRes Function(Input$UnlikeFeedItemInput) then,
  ) = _CopyWithImpl$Input$UnlikeFeedItemInput;

  factory CopyWith$Input$UnlikeFeedItemInput.stub(TRes res) =
      _CopyWithStubImpl$Input$UnlikeFeedItemInput;

  TRes call({String? feedItemId});
}

class _CopyWithImpl$Input$UnlikeFeedItemInput<TRes>
    implements CopyWith$Input$UnlikeFeedItemInput<TRes> {
  _CopyWithImpl$Input$UnlikeFeedItemInput(this._instance, this._then);

  final Input$UnlikeFeedItemInput _instance;

  final TRes Function(Input$UnlikeFeedItemInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? feedItemId = _undefined}) => _then(
    Input$UnlikeFeedItemInput._({
      ..._instance._$data,
      if (feedItemId != _undefined && feedItemId != null)
        'feedItemId': (feedItemId as String),
    }),
  );
}

class _CopyWithStubImpl$Input$UnlikeFeedItemInput<TRes>
    implements CopyWith$Input$UnlikeFeedItemInput<TRes> {
  _CopyWithStubImpl$Input$UnlikeFeedItemInput(this._res);

  TRes _res;

  call({String? feedItemId}) => _res;
}

class Input$StartConversationInput {
  factory Input$StartConversationInput({required String feedItemId}) =>
      Input$StartConversationInput._({r'feedItemId': feedItemId});

  Input$StartConversationInput._(this._$data);

  factory Input$StartConversationInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$feedItemId = data['feedItemId'];
    result$data['feedItemId'] = (l$feedItemId as String);
    return Input$StartConversationInput._(result$data);
  }

  Map<String, dynamic> _$data;

  String get feedItemId => (_$data['feedItemId'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$feedItemId = feedItemId;
    result$data['feedItemId'] = l$feedItemId;
    return result$data;
  }

  CopyWith$Input$StartConversationInput<Input$StartConversationInput>
  get copyWith => CopyWith$Input$StartConversationInput(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Input$StartConversationInput ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$feedItemId = feedItemId;
    final lOther$feedItemId = other.feedItemId;
    if (l$feedItemId != lOther$feedItemId) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$feedItemId = feedItemId;
    return Object.hashAll([l$feedItemId]);
  }
}

abstract class CopyWith$Input$StartConversationInput<TRes> {
  factory CopyWith$Input$StartConversationInput(
    Input$StartConversationInput instance,
    TRes Function(Input$StartConversationInput) then,
  ) = _CopyWithImpl$Input$StartConversationInput;

  factory CopyWith$Input$StartConversationInput.stub(TRes res) =
      _CopyWithStubImpl$Input$StartConversationInput;

  TRes call({String? feedItemId});
}

class _CopyWithImpl$Input$StartConversationInput<TRes>
    implements CopyWith$Input$StartConversationInput<TRes> {
  _CopyWithImpl$Input$StartConversationInput(this._instance, this._then);

  final Input$StartConversationInput _instance;

  final TRes Function(Input$StartConversationInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? feedItemId = _undefined}) => _then(
    Input$StartConversationInput._({
      ..._instance._$data,
      if (feedItemId != _undefined && feedItemId != null)
        'feedItemId': (feedItemId as String),
    }),
  );
}

class _CopyWithStubImpl$Input$StartConversationInput<TRes>
    implements CopyWith$Input$StartConversationInput<TRes> {
  _CopyWithStubImpl$Input$StartConversationInput(this._res);

  TRes _res;

  call({String? feedItemId}) => _res;
}

class Input$SendMessageInput {
  factory Input$SendMessageInput({
    required String conversationId,
    required String body,
    String? feedItemId,
    String? photoKey,
  }) => Input$SendMessageInput._({
    r'conversationId': conversationId,
    r'body': body,
    if (feedItemId != null) r'feedItemId': feedItemId,
    if (photoKey != null) r'photoKey': photoKey,
  });

  Input$SendMessageInput._(this._$data);

  factory Input$SendMessageInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$conversationId = data['conversationId'];
    result$data['conversationId'] = (l$conversationId as String);
    final l$body = data['body'];
    result$data['body'] = (l$body as String);
    if (data.containsKey('feedItemId')) {
      final l$feedItemId = data['feedItemId'];
      result$data['feedItemId'] = (l$feedItemId as String?);
    }
    if (data.containsKey('photoKey')) {
      final l$photoKey = data['photoKey'];
      result$data['photoKey'] = (l$photoKey as String?);
    }
    return Input$SendMessageInput._(result$data);
  }

  Map<String, dynamic> _$data;

  String get conversationId => (_$data['conversationId'] as String);

  String get body => (_$data['body'] as String);

  String? get feedItemId => (_$data['feedItemId'] as String?);

  String? get photoKey => (_$data['photoKey'] as String?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$conversationId = conversationId;
    result$data['conversationId'] = l$conversationId;
    final l$body = body;
    result$data['body'] = l$body;
    if (_$data.containsKey('feedItemId')) {
      final l$feedItemId = feedItemId;
      result$data['feedItemId'] = l$feedItemId;
    }
    if (_$data.containsKey('photoKey')) {
      final l$photoKey = photoKey;
      result$data['photoKey'] = l$photoKey;
    }
    return result$data;
  }

  CopyWith$Input$SendMessageInput<Input$SendMessageInput> get copyWith =>
      CopyWith$Input$SendMessageInput(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Input$SendMessageInput || runtimeType != other.runtimeType) {
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
    final l$feedItemId = feedItemId;
    final lOther$feedItemId = other.feedItemId;
    if (_$data.containsKey('feedItemId') !=
        other._$data.containsKey('feedItemId')) {
      return false;
    }
    if (l$feedItemId != lOther$feedItemId) {
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
    final l$feedItemId = feedItemId;
    final l$photoKey = photoKey;
    return Object.hashAll([
      l$conversationId,
      l$body,
      _$data.containsKey('feedItemId') ? l$feedItemId : const {},
      _$data.containsKey('photoKey') ? l$photoKey : const {},
    ]);
  }
}

abstract class CopyWith$Input$SendMessageInput<TRes> {
  factory CopyWith$Input$SendMessageInput(
    Input$SendMessageInput instance,
    TRes Function(Input$SendMessageInput) then,
  ) = _CopyWithImpl$Input$SendMessageInput;

  factory CopyWith$Input$SendMessageInput.stub(TRes res) =
      _CopyWithStubImpl$Input$SendMessageInput;

  TRes call({
    String? conversationId,
    String? body,
    String? feedItemId,
    String? photoKey,
  });
}

class _CopyWithImpl$Input$SendMessageInput<TRes>
    implements CopyWith$Input$SendMessageInput<TRes> {
  _CopyWithImpl$Input$SendMessageInput(this._instance, this._then);

  final Input$SendMessageInput _instance;

  final TRes Function(Input$SendMessageInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? conversationId = _undefined,
    Object? body = _undefined,
    Object? feedItemId = _undefined,
    Object? photoKey = _undefined,
  }) => _then(
    Input$SendMessageInput._({
      ..._instance._$data,
      if (conversationId != _undefined && conversationId != null)
        'conversationId': (conversationId as String),
      if (body != _undefined && body != null) 'body': (body as String),
      if (feedItemId != _undefined) 'feedItemId': (feedItemId as String?),
      if (photoKey != _undefined) 'photoKey': (photoKey as String?),
    }),
  );
}

class _CopyWithStubImpl$Input$SendMessageInput<TRes>
    implements CopyWith$Input$SendMessageInput<TRes> {
  _CopyWithStubImpl$Input$SendMessageInput(this._res);

  TRes _res;

  call({
    String? conversationId,
    String? body,
    String? feedItemId,
    String? photoKey,
  }) => _res;
}

class Input$NotifyTypingInput {
  factory Input$NotifyTypingInput({required String conversationId}) =>
      Input$NotifyTypingInput._({r'conversationId': conversationId});

  Input$NotifyTypingInput._(this._$data);

  factory Input$NotifyTypingInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$conversationId = data['conversationId'];
    result$data['conversationId'] = (l$conversationId as String);
    return Input$NotifyTypingInput._(result$data);
  }

  Map<String, dynamic> _$data;

  String get conversationId => (_$data['conversationId'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$conversationId = conversationId;
    result$data['conversationId'] = l$conversationId;
    return result$data;
  }

  CopyWith$Input$NotifyTypingInput<Input$NotifyTypingInput> get copyWith =>
      CopyWith$Input$NotifyTypingInput(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Input$NotifyTypingInput || runtimeType != other.runtimeType) {
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

abstract class CopyWith$Input$NotifyTypingInput<TRes> {
  factory CopyWith$Input$NotifyTypingInput(
    Input$NotifyTypingInput instance,
    TRes Function(Input$NotifyTypingInput) then,
  ) = _CopyWithImpl$Input$NotifyTypingInput;

  factory CopyWith$Input$NotifyTypingInput.stub(TRes res) =
      _CopyWithStubImpl$Input$NotifyTypingInput;

  TRes call({String? conversationId});
}

class _CopyWithImpl$Input$NotifyTypingInput<TRes>
    implements CopyWith$Input$NotifyTypingInput<TRes> {
  _CopyWithImpl$Input$NotifyTypingInput(this._instance, this._then);

  final Input$NotifyTypingInput _instance;

  final TRes Function(Input$NotifyTypingInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? conversationId = _undefined}) => _then(
    Input$NotifyTypingInput._({
      ..._instance._$data,
      if (conversationId != _undefined && conversationId != null)
        'conversationId': (conversationId as String),
    }),
  );
}

class _CopyWithStubImpl$Input$NotifyTypingInput<TRes>
    implements CopyWith$Input$NotifyTypingInput<TRes> {
  _CopyWithStubImpl$Input$NotifyTypingInput(this._res);

  TRes _res;

  call({String? conversationId}) => _res;
}

class Input$MarkConversationReadInput {
  factory Input$MarkConversationReadInput({
    required String conversationId,
    String? upToMessageId,
  }) => Input$MarkConversationReadInput._({
    r'conversationId': conversationId,
    if (upToMessageId != null) r'upToMessageId': upToMessageId,
  });

  Input$MarkConversationReadInput._(this._$data);

  factory Input$MarkConversationReadInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$conversationId = data['conversationId'];
    result$data['conversationId'] = (l$conversationId as String);
    if (data.containsKey('upToMessageId')) {
      final l$upToMessageId = data['upToMessageId'];
      result$data['upToMessageId'] = (l$upToMessageId as String?);
    }
    return Input$MarkConversationReadInput._(result$data);
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

  CopyWith$Input$MarkConversationReadInput<Input$MarkConversationReadInput>
  get copyWith => CopyWith$Input$MarkConversationReadInput(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Input$MarkConversationReadInput ||
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

abstract class CopyWith$Input$MarkConversationReadInput<TRes> {
  factory CopyWith$Input$MarkConversationReadInput(
    Input$MarkConversationReadInput instance,
    TRes Function(Input$MarkConversationReadInput) then,
  ) = _CopyWithImpl$Input$MarkConversationReadInput;

  factory CopyWith$Input$MarkConversationReadInput.stub(TRes res) =
      _CopyWithStubImpl$Input$MarkConversationReadInput;

  TRes call({String? conversationId, String? upToMessageId});
}

class _CopyWithImpl$Input$MarkConversationReadInput<TRes>
    implements CopyWith$Input$MarkConversationReadInput<TRes> {
  _CopyWithImpl$Input$MarkConversationReadInput(this._instance, this._then);

  final Input$MarkConversationReadInput _instance;

  final TRes Function(Input$MarkConversationReadInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? conversationId = _undefined,
    Object? upToMessageId = _undefined,
  }) => _then(
    Input$MarkConversationReadInput._({
      ..._instance._$data,
      if (conversationId != _undefined && conversationId != null)
        'conversationId': (conversationId as String),
      if (upToMessageId != _undefined)
        'upToMessageId': (upToMessageId as String?),
    }),
  );
}

class _CopyWithStubImpl$Input$MarkConversationReadInput<TRes>
    implements CopyWith$Input$MarkConversationReadInput<TRes> {
  _CopyWithStubImpl$Input$MarkConversationReadInput(this._res);

  TRes _res;

  call({String? conversationId, String? upToMessageId}) => _res;
}

class Input$ReportMessagesInput {
  factory Input$ReportMessagesInput({
    required List<String> messageIds,
    required Enum$ReportReason reason,
    String? detail,
  }) => Input$ReportMessagesInput._({
    r'messageIds': messageIds,
    r'reason': reason,
    if (detail != null) r'detail': detail,
  });

  Input$ReportMessagesInput._(this._$data);

  factory Input$ReportMessagesInput.fromJson(Map<String, dynamic> data) {
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
    return Input$ReportMessagesInput._(result$data);
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

  CopyWith$Input$ReportMessagesInput<Input$ReportMessagesInput> get copyWith =>
      CopyWith$Input$ReportMessagesInput(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Input$ReportMessagesInput ||
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

abstract class CopyWith$Input$ReportMessagesInput<TRes> {
  factory CopyWith$Input$ReportMessagesInput(
    Input$ReportMessagesInput instance,
    TRes Function(Input$ReportMessagesInput) then,
  ) = _CopyWithImpl$Input$ReportMessagesInput;

  factory CopyWith$Input$ReportMessagesInput.stub(TRes res) =
      _CopyWithStubImpl$Input$ReportMessagesInput;

  TRes call({
    List<String>? messageIds,
    Enum$ReportReason? reason,
    String? detail,
  });
}

class _CopyWithImpl$Input$ReportMessagesInput<TRes>
    implements CopyWith$Input$ReportMessagesInput<TRes> {
  _CopyWithImpl$Input$ReportMessagesInput(this._instance, this._then);

  final Input$ReportMessagesInput _instance;

  final TRes Function(Input$ReportMessagesInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? messageIds = _undefined,
    Object? reason = _undefined,
    Object? detail = _undefined,
  }) => _then(
    Input$ReportMessagesInput._({
      ..._instance._$data,
      if (messageIds != _undefined && messageIds != null)
        'messageIds': (messageIds as List<String>),
      if (reason != _undefined && reason != null)
        'reason': (reason as Enum$ReportReason),
      if (detail != _undefined) 'detail': (detail as String?),
    }),
  );
}

class _CopyWithStubImpl$Input$ReportMessagesInput<TRes>
    implements CopyWith$Input$ReportMessagesInput<TRes> {
  _CopyWithStubImpl$Input$ReportMessagesInput(this._res);

  TRes _res;

  call({List<String>? messageIds, Enum$ReportReason? reason, String? detail}) =>
      _res;
}
