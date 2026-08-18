// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, unused_element
import '../../community/repository/community_schema.graphql.dart';

class Input$StartConversationInput {
  factory Input$StartConversationInput({
    required String counterpartMemberId,
    String? sourceAnswerId,
  }) => Input$StartConversationInput._({
    r'counterpartMemberId': counterpartMemberId,
    if (sourceAnswerId != null) r'sourceAnswerId': sourceAnswerId,
  });

  Input$StartConversationInput._(this._$data);

  factory Input$StartConversationInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$counterpartMemberId = data['counterpartMemberId'];
    result$data['counterpartMemberId'] = (l$counterpartMemberId as String);
    if (data.containsKey('sourceAnswerId')) {
      final l$sourceAnswerId = data['sourceAnswerId'];
      result$data['sourceAnswerId'] = (l$sourceAnswerId as String?);
    }
    return Input$StartConversationInput._(result$data);
  }

  Map<String, dynamic> _$data;

  String get counterpartMemberId => (_$data['counterpartMemberId'] as String);

  String? get sourceAnswerId => (_$data['sourceAnswerId'] as String?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$counterpartMemberId = counterpartMemberId;
    result$data['counterpartMemberId'] = l$counterpartMemberId;
    if (_$data.containsKey('sourceAnswerId')) {
      final l$sourceAnswerId = sourceAnswerId;
      result$data['sourceAnswerId'] = l$sourceAnswerId;
    }
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
    final l$counterpartMemberId = counterpartMemberId;
    final lOther$counterpartMemberId = other.counterpartMemberId;
    if (l$counterpartMemberId != lOther$counterpartMemberId) {
      return false;
    }
    final l$sourceAnswerId = sourceAnswerId;
    final lOther$sourceAnswerId = other.sourceAnswerId;
    if (_$data.containsKey('sourceAnswerId') !=
        other._$data.containsKey('sourceAnswerId')) {
      return false;
    }
    if (l$sourceAnswerId != lOther$sourceAnswerId) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$counterpartMemberId = counterpartMemberId;
    final l$sourceAnswerId = sourceAnswerId;
    return Object.hashAll([
      l$counterpartMemberId,
      _$data.containsKey('sourceAnswerId') ? l$sourceAnswerId : const {},
    ]);
  }
}

abstract class CopyWith$Input$StartConversationInput<TRes> {
  factory CopyWith$Input$StartConversationInput(
    Input$StartConversationInput instance,
    TRes Function(Input$StartConversationInput) then,
  ) = _CopyWithImpl$Input$StartConversationInput;

  factory CopyWith$Input$StartConversationInput.stub(TRes res) =
      _CopyWithStubImpl$Input$StartConversationInput;

  TRes call({String? counterpartMemberId, String? sourceAnswerId});
}

class _CopyWithImpl$Input$StartConversationInput<TRes>
    implements CopyWith$Input$StartConversationInput<TRes> {
  _CopyWithImpl$Input$StartConversationInput(this._instance, this._then);

  final Input$StartConversationInput _instance;

  final TRes Function(Input$StartConversationInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? counterpartMemberId = _undefined,
    Object? sourceAnswerId = _undefined,
  }) => _then(
    Input$StartConversationInput._({
      ..._instance._$data,
      if (counterpartMemberId != _undefined && counterpartMemberId != null)
        'counterpartMemberId': (counterpartMemberId as String),
      if (sourceAnswerId != _undefined)
        'sourceAnswerId': (sourceAnswerId as String?),
    }),
  );
}

class _CopyWithStubImpl$Input$StartConversationInput<TRes>
    implements CopyWith$Input$StartConversationInput<TRes> {
  _CopyWithStubImpl$Input$StartConversationInput(this._res);

  TRes _res;

  call({String? counterpartMemberId, String? sourceAnswerId}) => _res;
}

class Input$SendMessageInput {
  factory Input$SendMessageInput({
    required String conversationId,
    required String body,
    String? photoKey,
  }) => Input$SendMessageInput._({
    r'conversationId': conversationId,
    r'body': body,
    if (photoKey != null) r'photoKey': photoKey,
  });

  Input$SendMessageInput._(this._$data);

  factory Input$SendMessageInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$conversationId = data['conversationId'];
    result$data['conversationId'] = (l$conversationId as String);
    final l$body = data['body'];
    result$data['body'] = (l$body as String);
    if (data.containsKey('photoKey')) {
      final l$photoKey = data['photoKey'];
      result$data['photoKey'] = (l$photoKey as String?);
    }
    return Input$SendMessageInput._(result$data);
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

abstract class CopyWith$Input$SendMessageInput<TRes> {
  factory CopyWith$Input$SendMessageInput(
    Input$SendMessageInput instance,
    TRes Function(Input$SendMessageInput) then,
  ) = _CopyWithImpl$Input$SendMessageInput;

  factory CopyWith$Input$SendMessageInput.stub(TRes res) =
      _CopyWithStubImpl$Input$SendMessageInput;

  TRes call({String? conversationId, String? body, String? photoKey});
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
    Object? photoKey = _undefined,
  }) => _then(
    Input$SendMessageInput._({
      ..._instance._$data,
      if (conversationId != _undefined && conversationId != null)
        'conversationId': (conversationId as String),
      if (body != _undefined && body != null) 'body': (body as String),
      if (photoKey != _undefined) 'photoKey': (photoKey as String?),
    }),
  );
}

class _CopyWithStubImpl$Input$SendMessageInput<TRes>
    implements CopyWith$Input$SendMessageInput<TRes> {
  _CopyWithStubImpl$Input$SendMessageInput(this._res);

  TRes _res;

  call({String? conversationId, String? body, String? photoKey}) => _res;
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
