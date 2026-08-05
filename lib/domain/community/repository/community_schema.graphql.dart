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
