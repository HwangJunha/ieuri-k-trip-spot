// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, unused_element
class Input$CreateSpotQuestionInput {
  factory Input$CreateSpotQuestionInput({
    required String catalogId,
    required String body,
    required List<String> photoKeys,
  }) => Input$CreateSpotQuestionInput._({
    r'catalogId': catalogId,
    r'body': body,
    r'photoKeys': photoKeys,
  });

  Input$CreateSpotQuestionInput._(this._$data);

  factory Input$CreateSpotQuestionInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$catalogId = data['catalogId'];
    result$data['catalogId'] = (l$catalogId as String);
    final l$body = data['body'];
    result$data['body'] = (l$body as String);
    final l$photoKeys = data['photoKeys'];
    result$data['photoKeys'] = (l$photoKeys as List<dynamic>)
        .map((e) => (e as String))
        .toList();
    return Input$CreateSpotQuestionInput._(result$data);
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

  CopyWith$Input$CreateSpotQuestionInput<Input$CreateSpotQuestionInput>
  get copyWith => CopyWith$Input$CreateSpotQuestionInput(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Input$CreateSpotQuestionInput ||
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

abstract class CopyWith$Input$CreateSpotQuestionInput<TRes> {
  factory CopyWith$Input$CreateSpotQuestionInput(
    Input$CreateSpotQuestionInput instance,
    TRes Function(Input$CreateSpotQuestionInput) then,
  ) = _CopyWithImpl$Input$CreateSpotQuestionInput;

  factory CopyWith$Input$CreateSpotQuestionInput.stub(TRes res) =
      _CopyWithStubImpl$Input$CreateSpotQuestionInput;

  TRes call({String? catalogId, String? body, List<String>? photoKeys});
}

class _CopyWithImpl$Input$CreateSpotQuestionInput<TRes>
    implements CopyWith$Input$CreateSpotQuestionInput<TRes> {
  _CopyWithImpl$Input$CreateSpotQuestionInput(this._instance, this._then);

  final Input$CreateSpotQuestionInput _instance;

  final TRes Function(Input$CreateSpotQuestionInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? catalogId = _undefined,
    Object? body = _undefined,
    Object? photoKeys = _undefined,
  }) => _then(
    Input$CreateSpotQuestionInput._({
      ..._instance._$data,
      if (catalogId != _undefined && catalogId != null)
        'catalogId': (catalogId as String),
      if (body != _undefined && body != null) 'body': (body as String),
      if (photoKeys != _undefined && photoKeys != null)
        'photoKeys': (photoKeys as List<String>),
    }),
  );
}

class _CopyWithStubImpl$Input$CreateSpotQuestionInput<TRes>
    implements CopyWith$Input$CreateSpotQuestionInput<TRes> {
  _CopyWithStubImpl$Input$CreateSpotQuestionInput(this._res);

  TRes _res;

  call({String? catalogId, String? body, List<String>? photoKeys}) => _res;
}

class Input$DeleteSpotQuestionInput {
  factory Input$DeleteSpotQuestionInput({required String questionId}) =>
      Input$DeleteSpotQuestionInput._({r'questionId': questionId});

  Input$DeleteSpotQuestionInput._(this._$data);

  factory Input$DeleteSpotQuestionInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$questionId = data['questionId'];
    result$data['questionId'] = (l$questionId as String);
    return Input$DeleteSpotQuestionInput._(result$data);
  }

  Map<String, dynamic> _$data;

  String get questionId => (_$data['questionId'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$questionId = questionId;
    result$data['questionId'] = l$questionId;
    return result$data;
  }

  CopyWith$Input$DeleteSpotQuestionInput<Input$DeleteSpotQuestionInput>
  get copyWith => CopyWith$Input$DeleteSpotQuestionInput(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Input$DeleteSpotQuestionInput ||
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

abstract class CopyWith$Input$DeleteSpotQuestionInput<TRes> {
  factory CopyWith$Input$DeleteSpotQuestionInput(
    Input$DeleteSpotQuestionInput instance,
    TRes Function(Input$DeleteSpotQuestionInput) then,
  ) = _CopyWithImpl$Input$DeleteSpotQuestionInput;

  factory CopyWith$Input$DeleteSpotQuestionInput.stub(TRes res) =
      _CopyWithStubImpl$Input$DeleteSpotQuestionInput;

  TRes call({String? questionId});
}

class _CopyWithImpl$Input$DeleteSpotQuestionInput<TRes>
    implements CopyWith$Input$DeleteSpotQuestionInput<TRes> {
  _CopyWithImpl$Input$DeleteSpotQuestionInput(this._instance, this._then);

  final Input$DeleteSpotQuestionInput _instance;

  final TRes Function(Input$DeleteSpotQuestionInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? questionId = _undefined}) => _then(
    Input$DeleteSpotQuestionInput._({
      ..._instance._$data,
      if (questionId != _undefined && questionId != null)
        'questionId': (questionId as String),
    }),
  );
}

class _CopyWithStubImpl$Input$DeleteSpotQuestionInput<TRes>
    implements CopyWith$Input$DeleteSpotQuestionInput<TRes> {
  _CopyWithStubImpl$Input$DeleteSpotQuestionInput(this._res);

  TRes _res;

  call({String? questionId}) => _res;
}

class Input$ResolveSpotQuestionInput {
  factory Input$ResolveSpotQuestionInput({required String questionId}) =>
      Input$ResolveSpotQuestionInput._({r'questionId': questionId});

  Input$ResolveSpotQuestionInput._(this._$data);

  factory Input$ResolveSpotQuestionInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$questionId = data['questionId'];
    result$data['questionId'] = (l$questionId as String);
    return Input$ResolveSpotQuestionInput._(result$data);
  }

  Map<String, dynamic> _$data;

  String get questionId => (_$data['questionId'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$questionId = questionId;
    result$data['questionId'] = l$questionId;
    return result$data;
  }

  CopyWith$Input$ResolveSpotQuestionInput<Input$ResolveSpotQuestionInput>
  get copyWith => CopyWith$Input$ResolveSpotQuestionInput(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Input$ResolveSpotQuestionInput ||
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

abstract class CopyWith$Input$ResolveSpotQuestionInput<TRes> {
  factory CopyWith$Input$ResolveSpotQuestionInput(
    Input$ResolveSpotQuestionInput instance,
    TRes Function(Input$ResolveSpotQuestionInput) then,
  ) = _CopyWithImpl$Input$ResolveSpotQuestionInput;

  factory CopyWith$Input$ResolveSpotQuestionInput.stub(TRes res) =
      _CopyWithStubImpl$Input$ResolveSpotQuestionInput;

  TRes call({String? questionId});
}

class _CopyWithImpl$Input$ResolveSpotQuestionInput<TRes>
    implements CopyWith$Input$ResolveSpotQuestionInput<TRes> {
  _CopyWithImpl$Input$ResolveSpotQuestionInput(this._instance, this._then);

  final Input$ResolveSpotQuestionInput _instance;

  final TRes Function(Input$ResolveSpotQuestionInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? questionId = _undefined}) => _then(
    Input$ResolveSpotQuestionInput._({
      ..._instance._$data,
      if (questionId != _undefined && questionId != null)
        'questionId': (questionId as String),
    }),
  );
}

class _CopyWithStubImpl$Input$ResolveSpotQuestionInput<TRes>
    implements CopyWith$Input$ResolveSpotQuestionInput<TRes> {
  _CopyWithStubImpl$Input$ResolveSpotQuestionInput(this._res);

  TRes _res;

  call({String? questionId}) => _res;
}

class Input$CreateSpotAnswerInput {
  factory Input$CreateSpotAnswerInput({
    required String questionId,
    required String body,
    required List<String> photoKeys,
  }) => Input$CreateSpotAnswerInput._({
    r'questionId': questionId,
    r'body': body,
    r'photoKeys': photoKeys,
  });

  Input$CreateSpotAnswerInput._(this._$data);

  factory Input$CreateSpotAnswerInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$questionId = data['questionId'];
    result$data['questionId'] = (l$questionId as String);
    final l$body = data['body'];
    result$data['body'] = (l$body as String);
    final l$photoKeys = data['photoKeys'];
    result$data['photoKeys'] = (l$photoKeys as List<dynamic>)
        .map((e) => (e as String))
        .toList();
    return Input$CreateSpotAnswerInput._(result$data);
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

  CopyWith$Input$CreateSpotAnswerInput<Input$CreateSpotAnswerInput>
  get copyWith => CopyWith$Input$CreateSpotAnswerInput(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Input$CreateSpotAnswerInput ||
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

abstract class CopyWith$Input$CreateSpotAnswerInput<TRes> {
  factory CopyWith$Input$CreateSpotAnswerInput(
    Input$CreateSpotAnswerInput instance,
    TRes Function(Input$CreateSpotAnswerInput) then,
  ) = _CopyWithImpl$Input$CreateSpotAnswerInput;

  factory CopyWith$Input$CreateSpotAnswerInput.stub(TRes res) =
      _CopyWithStubImpl$Input$CreateSpotAnswerInput;

  TRes call({String? questionId, String? body, List<String>? photoKeys});
}

class _CopyWithImpl$Input$CreateSpotAnswerInput<TRes>
    implements CopyWith$Input$CreateSpotAnswerInput<TRes> {
  _CopyWithImpl$Input$CreateSpotAnswerInput(this._instance, this._then);

  final Input$CreateSpotAnswerInput _instance;

  final TRes Function(Input$CreateSpotAnswerInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? questionId = _undefined,
    Object? body = _undefined,
    Object? photoKeys = _undefined,
  }) => _then(
    Input$CreateSpotAnswerInput._({
      ..._instance._$data,
      if (questionId != _undefined && questionId != null)
        'questionId': (questionId as String),
      if (body != _undefined && body != null) 'body': (body as String),
      if (photoKeys != _undefined && photoKeys != null)
        'photoKeys': (photoKeys as List<String>),
    }),
  );
}

class _CopyWithStubImpl$Input$CreateSpotAnswerInput<TRes>
    implements CopyWith$Input$CreateSpotAnswerInput<TRes> {
  _CopyWithStubImpl$Input$CreateSpotAnswerInput(this._res);

  TRes _res;

  call({String? questionId, String? body, List<String>? photoKeys}) => _res;
}

class Input$DeleteSpotAnswerInput {
  factory Input$DeleteSpotAnswerInput({required String answerId}) =>
      Input$DeleteSpotAnswerInput._({r'answerId': answerId});

  Input$DeleteSpotAnswerInput._(this._$data);

  factory Input$DeleteSpotAnswerInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$answerId = data['answerId'];
    result$data['answerId'] = (l$answerId as String);
    return Input$DeleteSpotAnswerInput._(result$data);
  }

  Map<String, dynamic> _$data;

  String get answerId => (_$data['answerId'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$answerId = answerId;
    result$data['answerId'] = l$answerId;
    return result$data;
  }

  CopyWith$Input$DeleteSpotAnswerInput<Input$DeleteSpotAnswerInput>
  get copyWith => CopyWith$Input$DeleteSpotAnswerInput(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Input$DeleteSpotAnswerInput ||
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

abstract class CopyWith$Input$DeleteSpotAnswerInput<TRes> {
  factory CopyWith$Input$DeleteSpotAnswerInput(
    Input$DeleteSpotAnswerInput instance,
    TRes Function(Input$DeleteSpotAnswerInput) then,
  ) = _CopyWithImpl$Input$DeleteSpotAnswerInput;

  factory CopyWith$Input$DeleteSpotAnswerInput.stub(TRes res) =
      _CopyWithStubImpl$Input$DeleteSpotAnswerInput;

  TRes call({String? answerId});
}

class _CopyWithImpl$Input$DeleteSpotAnswerInput<TRes>
    implements CopyWith$Input$DeleteSpotAnswerInput<TRes> {
  _CopyWithImpl$Input$DeleteSpotAnswerInput(this._instance, this._then);

  final Input$DeleteSpotAnswerInput _instance;

  final TRes Function(Input$DeleteSpotAnswerInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? answerId = _undefined}) => _then(
    Input$DeleteSpotAnswerInput._({
      ..._instance._$data,
      if (answerId != _undefined && answerId != null)
        'answerId': (answerId as String),
    }),
  );
}

class _CopyWithStubImpl$Input$DeleteSpotAnswerInput<TRes>
    implements CopyWith$Input$DeleteSpotAnswerInput<TRes> {
  _CopyWithStubImpl$Input$DeleteSpotAnswerInput(this._res);

  TRes _res;

  call({String? answerId}) => _res;
}

class Input$CreateSpotAnswerReplyInput {
  factory Input$CreateSpotAnswerReplyInput({
    required String parentAnswerId,
    required String body,
    required List<String> photoKeys,
  }) => Input$CreateSpotAnswerReplyInput._({
    r'parentAnswerId': parentAnswerId,
    r'body': body,
    r'photoKeys': photoKeys,
  });

  Input$CreateSpotAnswerReplyInput._(this._$data);

  factory Input$CreateSpotAnswerReplyInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$parentAnswerId = data['parentAnswerId'];
    result$data['parentAnswerId'] = (l$parentAnswerId as String);
    final l$body = data['body'];
    result$data['body'] = (l$body as String);
    final l$photoKeys = data['photoKeys'];
    result$data['photoKeys'] = (l$photoKeys as List<dynamic>)
        .map((e) => (e as String))
        .toList();
    return Input$CreateSpotAnswerReplyInput._(result$data);
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

  CopyWith$Input$CreateSpotAnswerReplyInput<Input$CreateSpotAnswerReplyInput>
  get copyWith => CopyWith$Input$CreateSpotAnswerReplyInput(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Input$CreateSpotAnswerReplyInput ||
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

abstract class CopyWith$Input$CreateSpotAnswerReplyInput<TRes> {
  factory CopyWith$Input$CreateSpotAnswerReplyInput(
    Input$CreateSpotAnswerReplyInput instance,
    TRes Function(Input$CreateSpotAnswerReplyInput) then,
  ) = _CopyWithImpl$Input$CreateSpotAnswerReplyInput;

  factory CopyWith$Input$CreateSpotAnswerReplyInput.stub(TRes res) =
      _CopyWithStubImpl$Input$CreateSpotAnswerReplyInput;

  TRes call({String? parentAnswerId, String? body, List<String>? photoKeys});
}

class _CopyWithImpl$Input$CreateSpotAnswerReplyInput<TRes>
    implements CopyWith$Input$CreateSpotAnswerReplyInput<TRes> {
  _CopyWithImpl$Input$CreateSpotAnswerReplyInput(this._instance, this._then);

  final Input$CreateSpotAnswerReplyInput _instance;

  final TRes Function(Input$CreateSpotAnswerReplyInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? parentAnswerId = _undefined,
    Object? body = _undefined,
    Object? photoKeys = _undefined,
  }) => _then(
    Input$CreateSpotAnswerReplyInput._({
      ..._instance._$data,
      if (parentAnswerId != _undefined && parentAnswerId != null)
        'parentAnswerId': (parentAnswerId as String),
      if (body != _undefined && body != null) 'body': (body as String),
      if (photoKeys != _undefined && photoKeys != null)
        'photoKeys': (photoKeys as List<String>),
    }),
  );
}

class _CopyWithStubImpl$Input$CreateSpotAnswerReplyInput<TRes>
    implements CopyWith$Input$CreateSpotAnswerReplyInput<TRes> {
  _CopyWithStubImpl$Input$CreateSpotAnswerReplyInput(this._res);

  TRes _res;

  call({String? parentAnswerId, String? body, List<String>? photoKeys}) => _res;
}

class Input$DeleteSpotAnswerReplyInput {
  factory Input$DeleteSpotAnswerReplyInput({required String replyId}) =>
      Input$DeleteSpotAnswerReplyInput._({r'replyId': replyId});

  Input$DeleteSpotAnswerReplyInput._(this._$data);

  factory Input$DeleteSpotAnswerReplyInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$replyId = data['replyId'];
    result$data['replyId'] = (l$replyId as String);
    return Input$DeleteSpotAnswerReplyInput._(result$data);
  }

  Map<String, dynamic> _$data;

  String get replyId => (_$data['replyId'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$replyId = replyId;
    result$data['replyId'] = l$replyId;
    return result$data;
  }

  CopyWith$Input$DeleteSpotAnswerReplyInput<Input$DeleteSpotAnswerReplyInput>
  get copyWith => CopyWith$Input$DeleteSpotAnswerReplyInput(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Input$DeleteSpotAnswerReplyInput ||
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

abstract class CopyWith$Input$DeleteSpotAnswerReplyInput<TRes> {
  factory CopyWith$Input$DeleteSpotAnswerReplyInput(
    Input$DeleteSpotAnswerReplyInput instance,
    TRes Function(Input$DeleteSpotAnswerReplyInput) then,
  ) = _CopyWithImpl$Input$DeleteSpotAnswerReplyInput;

  factory CopyWith$Input$DeleteSpotAnswerReplyInput.stub(TRes res) =
      _CopyWithStubImpl$Input$DeleteSpotAnswerReplyInput;

  TRes call({String? replyId});
}

class _CopyWithImpl$Input$DeleteSpotAnswerReplyInput<TRes>
    implements CopyWith$Input$DeleteSpotAnswerReplyInput<TRes> {
  _CopyWithImpl$Input$DeleteSpotAnswerReplyInput(this._instance, this._then);

  final Input$DeleteSpotAnswerReplyInput _instance;

  final TRes Function(Input$DeleteSpotAnswerReplyInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? replyId = _undefined}) => _then(
    Input$DeleteSpotAnswerReplyInput._({
      ..._instance._$data,
      if (replyId != _undefined && replyId != null)
        'replyId': (replyId as String),
    }),
  );
}

class _CopyWithStubImpl$Input$DeleteSpotAnswerReplyInput<TRes>
    implements CopyWith$Input$DeleteSpotAnswerReplyInput<TRes> {
  _CopyWithStubImpl$Input$DeleteSpotAnswerReplyInput(this._res);

  TRes _res;

  call({String? replyId}) => _res;
}
