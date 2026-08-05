// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, unused_element
class Input$CreatePostInput {
  factory Input$CreatePostInput({
    required Enum$PostTargetType targetType,
    required String targetId,
    required Enum$PostTopic topic,
    required String body,
    required List<String> photoKeys,
  }) => Input$CreatePostInput._({
    r'targetType': targetType,
    r'targetId': targetId,
    r'topic': topic,
    r'body': body,
    r'photoKeys': photoKeys,
  });

  Input$CreatePostInput._(this._$data);

  factory Input$CreatePostInput.fromJson(Map<String, dynamic> data) {
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
    return Input$CreatePostInput._(result$data);
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

  CopyWith$Input$CreatePostInput<Input$CreatePostInput> get copyWith =>
      CopyWith$Input$CreatePostInput(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Input$CreatePostInput || runtimeType != other.runtimeType) {
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

abstract class CopyWith$Input$CreatePostInput<TRes> {
  factory CopyWith$Input$CreatePostInput(
    Input$CreatePostInput instance,
    TRes Function(Input$CreatePostInput) then,
  ) = _CopyWithImpl$Input$CreatePostInput;

  factory CopyWith$Input$CreatePostInput.stub(TRes res) =
      _CopyWithStubImpl$Input$CreatePostInput;

  TRes call({
    Enum$PostTargetType? targetType,
    String? targetId,
    Enum$PostTopic? topic,
    String? body,
    List<String>? photoKeys,
  });
}

class _CopyWithImpl$Input$CreatePostInput<TRes>
    implements CopyWith$Input$CreatePostInput<TRes> {
  _CopyWithImpl$Input$CreatePostInput(this._instance, this._then);

  final Input$CreatePostInput _instance;

  final TRes Function(Input$CreatePostInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? targetType = _undefined,
    Object? targetId = _undefined,
    Object? topic = _undefined,
    Object? body = _undefined,
    Object? photoKeys = _undefined,
  }) => _then(
    Input$CreatePostInput._({
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

class _CopyWithStubImpl$Input$CreatePostInput<TRes>
    implements CopyWith$Input$CreatePostInput<TRes> {
  _CopyWithStubImpl$Input$CreatePostInput(this._res);

  TRes _res;

  call({
    Enum$PostTargetType? targetType,
    String? targetId,
    Enum$PostTopic? topic,
    String? body,
    List<String>? photoKeys,
  }) => _res;
}

class Input$CreateCommentInput {
  factory Input$CreateCommentInput({
    required String postId,
    required String body,
  }) => Input$CreateCommentInput._({r'postId': postId, r'body': body});

  Input$CreateCommentInput._(this._$data);

  factory Input$CreateCommentInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$postId = data['postId'];
    result$data['postId'] = (l$postId as String);
    final l$body = data['body'];
    result$data['body'] = (l$body as String);
    return Input$CreateCommentInput._(result$data);
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

  CopyWith$Input$CreateCommentInput<Input$CreateCommentInput> get copyWith =>
      CopyWith$Input$CreateCommentInput(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Input$CreateCommentInput ||
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

abstract class CopyWith$Input$CreateCommentInput<TRes> {
  factory CopyWith$Input$CreateCommentInput(
    Input$CreateCommentInput instance,
    TRes Function(Input$CreateCommentInput) then,
  ) = _CopyWithImpl$Input$CreateCommentInput;

  factory CopyWith$Input$CreateCommentInput.stub(TRes res) =
      _CopyWithStubImpl$Input$CreateCommentInput;

  TRes call({String? postId, String? body});
}

class _CopyWithImpl$Input$CreateCommentInput<TRes>
    implements CopyWith$Input$CreateCommentInput<TRes> {
  _CopyWithImpl$Input$CreateCommentInput(this._instance, this._then);

  final Input$CreateCommentInput _instance;

  final TRes Function(Input$CreateCommentInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? postId = _undefined, Object? body = _undefined}) => _then(
    Input$CreateCommentInput._({
      ..._instance._$data,
      if (postId != _undefined && postId != null) 'postId': (postId as String),
      if (body != _undefined && body != null) 'body': (body as String),
    }),
  );
}

class _CopyWithStubImpl$Input$CreateCommentInput<TRes>
    implements CopyWith$Input$CreateCommentInput<TRes> {
  _CopyWithStubImpl$Input$CreateCommentInput(this._res);

  TRes _res;

  call({String? postId, String? body}) => _res;
}

class Input$DeletePostInput {
  factory Input$DeletePostInput({required String postId}) =>
      Input$DeletePostInput._({r'postId': postId});

  Input$DeletePostInput._(this._$data);

  factory Input$DeletePostInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$postId = data['postId'];
    result$data['postId'] = (l$postId as String);
    return Input$DeletePostInput._(result$data);
  }

  Map<String, dynamic> _$data;

  String get postId => (_$data['postId'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$postId = postId;
    result$data['postId'] = l$postId;
    return result$data;
  }

  CopyWith$Input$DeletePostInput<Input$DeletePostInput> get copyWith =>
      CopyWith$Input$DeletePostInput(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Input$DeletePostInput || runtimeType != other.runtimeType) {
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

abstract class CopyWith$Input$DeletePostInput<TRes> {
  factory CopyWith$Input$DeletePostInput(
    Input$DeletePostInput instance,
    TRes Function(Input$DeletePostInput) then,
  ) = _CopyWithImpl$Input$DeletePostInput;

  factory CopyWith$Input$DeletePostInput.stub(TRes res) =
      _CopyWithStubImpl$Input$DeletePostInput;

  TRes call({String? postId});
}

class _CopyWithImpl$Input$DeletePostInput<TRes>
    implements CopyWith$Input$DeletePostInput<TRes> {
  _CopyWithImpl$Input$DeletePostInput(this._instance, this._then);

  final Input$DeletePostInput _instance;

  final TRes Function(Input$DeletePostInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? postId = _undefined}) => _then(
    Input$DeletePostInput._({
      ..._instance._$data,
      if (postId != _undefined && postId != null) 'postId': (postId as String),
    }),
  );
}

class _CopyWithStubImpl$Input$DeletePostInput<TRes>
    implements CopyWith$Input$DeletePostInput<TRes> {
  _CopyWithStubImpl$Input$DeletePostInput(this._res);

  TRes _res;

  call({String? postId}) => _res;
}

class Input$BlockUserInput {
  factory Input$BlockUserInput({required String targetMemberId}) =>
      Input$BlockUserInput._({r'targetMemberId': targetMemberId});

  Input$BlockUserInput._(this._$data);

  factory Input$BlockUserInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$targetMemberId = data['targetMemberId'];
    result$data['targetMemberId'] = (l$targetMemberId as String);
    return Input$BlockUserInput._(result$data);
  }

  Map<String, dynamic> _$data;

  String get targetMemberId => (_$data['targetMemberId'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$targetMemberId = targetMemberId;
    result$data['targetMemberId'] = l$targetMemberId;
    return result$data;
  }

  CopyWith$Input$BlockUserInput<Input$BlockUserInput> get copyWith =>
      CopyWith$Input$BlockUserInput(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Input$BlockUserInput || runtimeType != other.runtimeType) {
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

abstract class CopyWith$Input$BlockUserInput<TRes> {
  factory CopyWith$Input$BlockUserInput(
    Input$BlockUserInput instance,
    TRes Function(Input$BlockUserInput) then,
  ) = _CopyWithImpl$Input$BlockUserInput;

  factory CopyWith$Input$BlockUserInput.stub(TRes res) =
      _CopyWithStubImpl$Input$BlockUserInput;

  TRes call({String? targetMemberId});
}

class _CopyWithImpl$Input$BlockUserInput<TRes>
    implements CopyWith$Input$BlockUserInput<TRes> {
  _CopyWithImpl$Input$BlockUserInput(this._instance, this._then);

  final Input$BlockUserInput _instance;

  final TRes Function(Input$BlockUserInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? targetMemberId = _undefined}) => _then(
    Input$BlockUserInput._({
      ..._instance._$data,
      if (targetMemberId != _undefined && targetMemberId != null)
        'targetMemberId': (targetMemberId as String),
    }),
  );
}

class _CopyWithStubImpl$Input$BlockUserInput<TRes>
    implements CopyWith$Input$BlockUserInput<TRes> {
  _CopyWithStubImpl$Input$BlockUserInput(this._res);

  TRes _res;

  call({String? targetMemberId}) => _res;
}

class Input$UnblockUserInput {
  factory Input$UnblockUserInput({required String targetMemberId}) =>
      Input$UnblockUserInput._({r'targetMemberId': targetMemberId});

  Input$UnblockUserInput._(this._$data);

  factory Input$UnblockUserInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$targetMemberId = data['targetMemberId'];
    result$data['targetMemberId'] = (l$targetMemberId as String);
    return Input$UnblockUserInput._(result$data);
  }

  Map<String, dynamic> _$data;

  String get targetMemberId => (_$data['targetMemberId'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$targetMemberId = targetMemberId;
    result$data['targetMemberId'] = l$targetMemberId;
    return result$data;
  }

  CopyWith$Input$UnblockUserInput<Input$UnblockUserInput> get copyWith =>
      CopyWith$Input$UnblockUserInput(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Input$UnblockUserInput || runtimeType != other.runtimeType) {
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

abstract class CopyWith$Input$UnblockUserInput<TRes> {
  factory CopyWith$Input$UnblockUserInput(
    Input$UnblockUserInput instance,
    TRes Function(Input$UnblockUserInput) then,
  ) = _CopyWithImpl$Input$UnblockUserInput;

  factory CopyWith$Input$UnblockUserInput.stub(TRes res) =
      _CopyWithStubImpl$Input$UnblockUserInput;

  TRes call({String? targetMemberId});
}

class _CopyWithImpl$Input$UnblockUserInput<TRes>
    implements CopyWith$Input$UnblockUserInput<TRes> {
  _CopyWithImpl$Input$UnblockUserInput(this._instance, this._then);

  final Input$UnblockUserInput _instance;

  final TRes Function(Input$UnblockUserInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? targetMemberId = _undefined}) => _then(
    Input$UnblockUserInput._({
      ..._instance._$data,
      if (targetMemberId != _undefined && targetMemberId != null)
        'targetMemberId': (targetMemberId as String),
    }),
  );
}

class _CopyWithStubImpl$Input$UnblockUserInput<TRes>
    implements CopyWith$Input$UnblockUserInput<TRes> {
  _CopyWithStubImpl$Input$UnblockUserInput(this._res);

  TRes _res;

  call({String? targetMemberId}) => _res;
}

class Input$ReportContentInput {
  factory Input$ReportContentInput({
    required Enum$ReportTargetType targetType,
    required String targetId,
    required Enum$ReportReason reason,
    String? detail,
  }) => Input$ReportContentInput._({
    r'targetType': targetType,
    r'targetId': targetId,
    r'reason': reason,
    if (detail != null) r'detail': detail,
  });

  Input$ReportContentInput._(this._$data);

  factory Input$ReportContentInput.fromJson(Map<String, dynamic> data) {
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
    return Input$ReportContentInput._(result$data);
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

  CopyWith$Input$ReportContentInput<Input$ReportContentInput> get copyWith =>
      CopyWith$Input$ReportContentInput(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Input$ReportContentInput ||
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

abstract class CopyWith$Input$ReportContentInput<TRes> {
  factory CopyWith$Input$ReportContentInput(
    Input$ReportContentInput instance,
    TRes Function(Input$ReportContentInput) then,
  ) = _CopyWithImpl$Input$ReportContentInput;

  factory CopyWith$Input$ReportContentInput.stub(TRes res) =
      _CopyWithStubImpl$Input$ReportContentInput;

  TRes call({
    Enum$ReportTargetType? targetType,
    String? targetId,
    Enum$ReportReason? reason,
    String? detail,
  });
}

class _CopyWithImpl$Input$ReportContentInput<TRes>
    implements CopyWith$Input$ReportContentInput<TRes> {
  _CopyWithImpl$Input$ReportContentInput(this._instance, this._then);

  final Input$ReportContentInput _instance;

  final TRes Function(Input$ReportContentInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? targetType = _undefined,
    Object? targetId = _undefined,
    Object? reason = _undefined,
    Object? detail = _undefined,
  }) => _then(
    Input$ReportContentInput._({
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

class _CopyWithStubImpl$Input$ReportContentInput<TRes>
    implements CopyWith$Input$ReportContentInput<TRes> {
  _CopyWithStubImpl$Input$ReportContentInput(this._res);

  TRes _res;

  call({
    Enum$ReportTargetType? targetType,
    String? targetId,
    Enum$ReportReason? reason,
    String? detail,
  }) => _res;
}

class Input$LikePostInput {
  factory Input$LikePostInput({required String postId}) =>
      Input$LikePostInput._({r'postId': postId});

  Input$LikePostInput._(this._$data);

  factory Input$LikePostInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$postId = data['postId'];
    result$data['postId'] = (l$postId as String);
    return Input$LikePostInput._(result$data);
  }

  Map<String, dynamic> _$data;

  String get postId => (_$data['postId'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$postId = postId;
    result$data['postId'] = l$postId;
    return result$data;
  }

  CopyWith$Input$LikePostInput<Input$LikePostInput> get copyWith =>
      CopyWith$Input$LikePostInput(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Input$LikePostInput || runtimeType != other.runtimeType) {
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

abstract class CopyWith$Input$LikePostInput<TRes> {
  factory CopyWith$Input$LikePostInput(
    Input$LikePostInput instance,
    TRes Function(Input$LikePostInput) then,
  ) = _CopyWithImpl$Input$LikePostInput;

  factory CopyWith$Input$LikePostInput.stub(TRes res) =
      _CopyWithStubImpl$Input$LikePostInput;

  TRes call({String? postId});
}

class _CopyWithImpl$Input$LikePostInput<TRes>
    implements CopyWith$Input$LikePostInput<TRes> {
  _CopyWithImpl$Input$LikePostInput(this._instance, this._then);

  final Input$LikePostInput _instance;

  final TRes Function(Input$LikePostInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? postId = _undefined}) => _then(
    Input$LikePostInput._({
      ..._instance._$data,
      if (postId != _undefined && postId != null) 'postId': (postId as String),
    }),
  );
}

class _CopyWithStubImpl$Input$LikePostInput<TRes>
    implements CopyWith$Input$LikePostInput<TRes> {
  _CopyWithStubImpl$Input$LikePostInput(this._res);

  TRes _res;

  call({String? postId}) => _res;
}

class Input$UnlikePostInput {
  factory Input$UnlikePostInput({required String postId}) =>
      Input$UnlikePostInput._({r'postId': postId});

  Input$UnlikePostInput._(this._$data);

  factory Input$UnlikePostInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$postId = data['postId'];
    result$data['postId'] = (l$postId as String);
    return Input$UnlikePostInput._(result$data);
  }

  Map<String, dynamic> _$data;

  String get postId => (_$data['postId'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$postId = postId;
    result$data['postId'] = l$postId;
    return result$data;
  }

  CopyWith$Input$UnlikePostInput<Input$UnlikePostInput> get copyWith =>
      CopyWith$Input$UnlikePostInput(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Input$UnlikePostInput || runtimeType != other.runtimeType) {
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

abstract class CopyWith$Input$UnlikePostInput<TRes> {
  factory CopyWith$Input$UnlikePostInput(
    Input$UnlikePostInput instance,
    TRes Function(Input$UnlikePostInput) then,
  ) = _CopyWithImpl$Input$UnlikePostInput;

  factory CopyWith$Input$UnlikePostInput.stub(TRes res) =
      _CopyWithStubImpl$Input$UnlikePostInput;

  TRes call({String? postId});
}

class _CopyWithImpl$Input$UnlikePostInput<TRes>
    implements CopyWith$Input$UnlikePostInput<TRes> {
  _CopyWithImpl$Input$UnlikePostInput(this._instance, this._then);

  final Input$UnlikePostInput _instance;

  final TRes Function(Input$UnlikePostInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? postId = _undefined}) => _then(
    Input$UnlikePostInput._({
      ..._instance._$data,
      if (postId != _undefined && postId != null) 'postId': (postId as String),
    }),
  );
}

class _CopyWithStubImpl$Input$UnlikePostInput<TRes>
    implements CopyWith$Input$UnlikePostInput<TRes> {
  _CopyWithStubImpl$Input$UnlikePostInput(this._res);

  TRes _res;

  call({String? postId}) => _res;
}

enum Enum$PostTopic {
  QUESTION,
  TIP,
  REVIEW,
  COMPANION,
  PHOTO,
  $unknown;

  factory Enum$PostTopic.fromJson(String value) =>
      fromJson$Enum$PostTopic(value);

  String toJson() => toJson$Enum$PostTopic(this);
}

String toJson$Enum$PostTopic(Enum$PostTopic e) {
  switch (e) {
    case Enum$PostTopic.QUESTION:
      return r'QUESTION';
    case Enum$PostTopic.TIP:
      return r'TIP';
    case Enum$PostTopic.REVIEW:
      return r'REVIEW';
    case Enum$PostTopic.COMPANION:
      return r'COMPANION';
    case Enum$PostTopic.PHOTO:
      return r'PHOTO';
    case Enum$PostTopic.$unknown:
      return r'$unknown';
  }
}

Enum$PostTopic fromJson$Enum$PostTopic(String value) {
  switch (value) {
    case r'QUESTION':
      return Enum$PostTopic.QUESTION;
    case r'TIP':
      return Enum$PostTopic.TIP;
    case r'REVIEW':
      return Enum$PostTopic.REVIEW;
    case r'COMPANION':
      return Enum$PostTopic.COMPANION;
    case r'PHOTO':
      return Enum$PostTopic.PHOTO;
    default:
      return Enum$PostTopic.$unknown;
  }
}

enum Enum$PostTargetType {
  SPOT,
  $unknown;

  factory Enum$PostTargetType.fromJson(String value) =>
      fromJson$Enum$PostTargetType(value);

  String toJson() => toJson$Enum$PostTargetType(this);
}

String toJson$Enum$PostTargetType(Enum$PostTargetType e) {
  switch (e) {
    case Enum$PostTargetType.SPOT:
      return r'SPOT';
    case Enum$PostTargetType.$unknown:
      return r'$unknown';
  }
}

Enum$PostTargetType fromJson$Enum$PostTargetType(String value) {
  switch (value) {
    case r'SPOT':
      return Enum$PostTargetType.SPOT;
    default:
      return Enum$PostTargetType.$unknown;
  }
}

enum Enum$ReportReason {
  SPAM,
  ABUSE,
  INAPPROPRIATE_CONTENT,
  OTHER,
  $unknown;

  factory Enum$ReportReason.fromJson(String value) =>
      fromJson$Enum$ReportReason(value);

  String toJson() => toJson$Enum$ReportReason(this);
}

String toJson$Enum$ReportReason(Enum$ReportReason e) {
  switch (e) {
    case Enum$ReportReason.SPAM:
      return r'SPAM';
    case Enum$ReportReason.ABUSE:
      return r'ABUSE';
    case Enum$ReportReason.INAPPROPRIATE_CONTENT:
      return r'INAPPROPRIATE_CONTENT';
    case Enum$ReportReason.OTHER:
      return r'OTHER';
    case Enum$ReportReason.$unknown:
      return r'$unknown';
  }
}

Enum$ReportReason fromJson$Enum$ReportReason(String value) {
  switch (value) {
    case r'SPAM':
      return Enum$ReportReason.SPAM;
    case r'ABUSE':
      return Enum$ReportReason.ABUSE;
    case r'INAPPROPRIATE_CONTENT':
      return Enum$ReportReason.INAPPROPRIATE_CONTENT;
    case r'OTHER':
      return Enum$ReportReason.OTHER;
    default:
      return Enum$ReportReason.$unknown;
  }
}

enum Enum$ReportTargetType {
  POST,
  COMMENT,
  MEMBER,
  $unknown;

  factory Enum$ReportTargetType.fromJson(String value) =>
      fromJson$Enum$ReportTargetType(value);

  String toJson() => toJson$Enum$ReportTargetType(this);
}

String toJson$Enum$ReportTargetType(Enum$ReportTargetType e) {
  switch (e) {
    case Enum$ReportTargetType.POST:
      return r'POST';
    case Enum$ReportTargetType.COMMENT:
      return r'COMMENT';
    case Enum$ReportTargetType.MEMBER:
      return r'MEMBER';
    case Enum$ReportTargetType.$unknown:
      return r'$unknown';
  }
}

Enum$ReportTargetType fromJson$Enum$ReportTargetType(String value) {
  switch (value) {
    case r'POST':
      return Enum$ReportTargetType.POST;
    case r'COMMENT':
      return Enum$ReportTargetType.COMMENT;
    case r'MEMBER':
      return Enum$ReportTargetType.MEMBER;
    default:
      return Enum$ReportTargetType.$unknown;
  }
}
