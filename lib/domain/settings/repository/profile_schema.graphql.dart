// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, unused_element
class Input$ChangeNicknameInput {
  factory Input$ChangeNicknameInput({required String nickname}) =>
      Input$ChangeNicknameInput._({r'nickname': nickname});

  Input$ChangeNicknameInput._(this._$data);

  factory Input$ChangeNicknameInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$nickname = data['nickname'];
    result$data['nickname'] = (l$nickname as String);
    return Input$ChangeNicknameInput._(result$data);
  }

  Map<String, dynamic> _$data;

  String get nickname => (_$data['nickname'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$nickname = nickname;
    result$data['nickname'] = l$nickname;
    return result$data;
  }

  CopyWith$Input$ChangeNicknameInput<Input$ChangeNicknameInput> get copyWith =>
      CopyWith$Input$ChangeNicknameInput(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Input$ChangeNicknameInput ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$nickname = nickname;
    final lOther$nickname = other.nickname;
    if (l$nickname != lOther$nickname) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$nickname = nickname;
    return Object.hashAll([l$nickname]);
  }
}

abstract class CopyWith$Input$ChangeNicknameInput<TRes> {
  factory CopyWith$Input$ChangeNicknameInput(
    Input$ChangeNicknameInput instance,
    TRes Function(Input$ChangeNicknameInput) then,
  ) = _CopyWithImpl$Input$ChangeNicknameInput;

  factory CopyWith$Input$ChangeNicknameInput.stub(TRes res) =
      _CopyWithStubImpl$Input$ChangeNicknameInput;

  TRes call({String? nickname});
}

class _CopyWithImpl$Input$ChangeNicknameInput<TRes>
    implements CopyWith$Input$ChangeNicknameInput<TRes> {
  _CopyWithImpl$Input$ChangeNicknameInput(this._instance, this._then);

  final Input$ChangeNicknameInput _instance;

  final TRes Function(Input$ChangeNicknameInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? nickname = _undefined}) => _then(
    Input$ChangeNicknameInput._({
      ..._instance._$data,
      if (nickname != _undefined && nickname != null)
        'nickname': (nickname as String),
    }),
  );
}

class _CopyWithStubImpl$Input$ChangeNicknameInput<TRes>
    implements CopyWith$Input$ChangeNicknameInput<TRes> {
  _CopyWithStubImpl$Input$ChangeNicknameInput(this._res);

  TRes _res;

  call({String? nickname}) => _res;
}

class Input$CreateProfileImageUploadUrlInput {
  factory Input$CreateProfileImageUploadUrlInput({
    required String contentType,
    required int contentLength,
  }) => Input$CreateProfileImageUploadUrlInput._({
    r'contentType': contentType,
    r'contentLength': contentLength,
  });

  Input$CreateProfileImageUploadUrlInput._(this._$data);

  factory Input$CreateProfileImageUploadUrlInput.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    final l$contentType = data['contentType'];
    result$data['contentType'] = (l$contentType as String);
    final l$contentLength = data['contentLength'];
    result$data['contentLength'] = (l$contentLength as int);
    return Input$CreateProfileImageUploadUrlInput._(result$data);
  }

  Map<String, dynamic> _$data;

  String get contentType => (_$data['contentType'] as String);

  int get contentLength => (_$data['contentLength'] as int);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$contentType = contentType;
    result$data['contentType'] = l$contentType;
    final l$contentLength = contentLength;
    result$data['contentLength'] = l$contentLength;
    return result$data;
  }

  CopyWith$Input$CreateProfileImageUploadUrlInput<
    Input$CreateProfileImageUploadUrlInput
  >
  get copyWith =>
      CopyWith$Input$CreateProfileImageUploadUrlInput(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Input$CreateProfileImageUploadUrlInput ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$contentType = contentType;
    final lOther$contentType = other.contentType;
    if (l$contentType != lOther$contentType) {
      return false;
    }
    final l$contentLength = contentLength;
    final lOther$contentLength = other.contentLength;
    if (l$contentLength != lOther$contentLength) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$contentType = contentType;
    final l$contentLength = contentLength;
    return Object.hashAll([l$contentType, l$contentLength]);
  }
}

abstract class CopyWith$Input$CreateProfileImageUploadUrlInput<TRes> {
  factory CopyWith$Input$CreateProfileImageUploadUrlInput(
    Input$CreateProfileImageUploadUrlInput instance,
    TRes Function(Input$CreateProfileImageUploadUrlInput) then,
  ) = _CopyWithImpl$Input$CreateProfileImageUploadUrlInput;

  factory CopyWith$Input$CreateProfileImageUploadUrlInput.stub(TRes res) =
      _CopyWithStubImpl$Input$CreateProfileImageUploadUrlInput;

  TRes call({String? contentType, int? contentLength});
}

class _CopyWithImpl$Input$CreateProfileImageUploadUrlInput<TRes>
    implements CopyWith$Input$CreateProfileImageUploadUrlInput<TRes> {
  _CopyWithImpl$Input$CreateProfileImageUploadUrlInput(
    this._instance,
    this._then,
  );

  final Input$CreateProfileImageUploadUrlInput _instance;

  final TRes Function(Input$CreateProfileImageUploadUrlInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? contentType = _undefined,
    Object? contentLength = _undefined,
  }) => _then(
    Input$CreateProfileImageUploadUrlInput._({
      ..._instance._$data,
      if (contentType != _undefined && contentType != null)
        'contentType': (contentType as String),
      if (contentLength != _undefined && contentLength != null)
        'contentLength': (contentLength as int),
    }),
  );
}

class _CopyWithStubImpl$Input$CreateProfileImageUploadUrlInput<TRes>
    implements CopyWith$Input$CreateProfileImageUploadUrlInput<TRes> {
  _CopyWithStubImpl$Input$CreateProfileImageUploadUrlInput(this._res);

  TRes _res;

  call({String? contentType, int? contentLength}) => _res;
}

class Input$ConfirmProfileImageUploadInput {
  factory Input$ConfirmProfileImageUploadInput({required String objectKey}) =>
      Input$ConfirmProfileImageUploadInput._({r'objectKey': objectKey});

  Input$ConfirmProfileImageUploadInput._(this._$data);

  factory Input$ConfirmProfileImageUploadInput.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    final l$objectKey = data['objectKey'];
    result$data['objectKey'] = (l$objectKey as String);
    return Input$ConfirmProfileImageUploadInput._(result$data);
  }

  Map<String, dynamic> _$data;

  String get objectKey => (_$data['objectKey'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$objectKey = objectKey;
    result$data['objectKey'] = l$objectKey;
    return result$data;
  }

  CopyWith$Input$ConfirmProfileImageUploadInput<
    Input$ConfirmProfileImageUploadInput
  >
  get copyWith => CopyWith$Input$ConfirmProfileImageUploadInput(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Input$ConfirmProfileImageUploadInput ||
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

abstract class CopyWith$Input$ConfirmProfileImageUploadInput<TRes> {
  factory CopyWith$Input$ConfirmProfileImageUploadInput(
    Input$ConfirmProfileImageUploadInput instance,
    TRes Function(Input$ConfirmProfileImageUploadInput) then,
  ) = _CopyWithImpl$Input$ConfirmProfileImageUploadInput;

  factory CopyWith$Input$ConfirmProfileImageUploadInput.stub(TRes res) =
      _CopyWithStubImpl$Input$ConfirmProfileImageUploadInput;

  TRes call({String? objectKey});
}

class _CopyWithImpl$Input$ConfirmProfileImageUploadInput<TRes>
    implements CopyWith$Input$ConfirmProfileImageUploadInput<TRes> {
  _CopyWithImpl$Input$ConfirmProfileImageUploadInput(
    this._instance,
    this._then,
  );

  final Input$ConfirmProfileImageUploadInput _instance;

  final TRes Function(Input$ConfirmProfileImageUploadInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? objectKey = _undefined}) => _then(
    Input$ConfirmProfileImageUploadInput._({
      ..._instance._$data,
      if (objectKey != _undefined && objectKey != null)
        'objectKey': (objectKey as String),
    }),
  );
}

class _CopyWithStubImpl$Input$ConfirmProfileImageUploadInput<TRes>
    implements CopyWith$Input$ConfirmProfileImageUploadInput<TRes> {
  _CopyWithStubImpl$Input$ConfirmProfileImageUploadInput(this._res);

  TRes _res;

  call({String? objectKey}) => _res;
}
