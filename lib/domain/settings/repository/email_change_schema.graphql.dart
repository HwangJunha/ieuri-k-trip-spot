// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, unused_element
class Input$ChangeEmailInput {
  factory Input$ChangeEmailInput({required String newEmail}) =>
      Input$ChangeEmailInput._({r'newEmail': newEmail});

  Input$ChangeEmailInput._(this._$data);

  factory Input$ChangeEmailInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$newEmail = data['newEmail'];
    result$data['newEmail'] = (l$newEmail as String);
    return Input$ChangeEmailInput._(result$data);
  }

  Map<String, dynamic> _$data;

  String get newEmail => (_$data['newEmail'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$newEmail = newEmail;
    result$data['newEmail'] = l$newEmail;
    return result$data;
  }

  CopyWith$Input$ChangeEmailInput<Input$ChangeEmailInput> get copyWith =>
      CopyWith$Input$ChangeEmailInput(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Input$ChangeEmailInput || runtimeType != other.runtimeType) {
      return false;
    }
    final l$newEmail = newEmail;
    final lOther$newEmail = other.newEmail;
    if (l$newEmail != lOther$newEmail) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$newEmail = newEmail;
    return Object.hashAll([l$newEmail]);
  }
}

abstract class CopyWith$Input$ChangeEmailInput<TRes> {
  factory CopyWith$Input$ChangeEmailInput(
    Input$ChangeEmailInput instance,
    TRes Function(Input$ChangeEmailInput) then,
  ) = _CopyWithImpl$Input$ChangeEmailInput;

  factory CopyWith$Input$ChangeEmailInput.stub(TRes res) =
      _CopyWithStubImpl$Input$ChangeEmailInput;

  TRes call({String? newEmail});
}

class _CopyWithImpl$Input$ChangeEmailInput<TRes>
    implements CopyWith$Input$ChangeEmailInput<TRes> {
  _CopyWithImpl$Input$ChangeEmailInput(this._instance, this._then);

  final Input$ChangeEmailInput _instance;

  final TRes Function(Input$ChangeEmailInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? newEmail = _undefined}) => _then(
    Input$ChangeEmailInput._({
      ..._instance._$data,
      if (newEmail != _undefined && newEmail != null)
        'newEmail': (newEmail as String),
    }),
  );
}

class _CopyWithStubImpl$Input$ChangeEmailInput<TRes>
    implements CopyWith$Input$ChangeEmailInput<TRes> {
  _CopyWithStubImpl$Input$ChangeEmailInput(this._res);

  TRes _res;

  call({String? newEmail}) => _res;
}

class Input$ConfirmEmailChangeInput {
  factory Input$ConfirmEmailChangeInput({
    required String verificationId,
    required String code,
  }) => Input$ConfirmEmailChangeInput._({
    r'verificationId': verificationId,
    r'code': code,
  });

  Input$ConfirmEmailChangeInput._(this._$data);

  factory Input$ConfirmEmailChangeInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$verificationId = data['verificationId'];
    result$data['verificationId'] = (l$verificationId as String);
    final l$code = data['code'];
    result$data['code'] = (l$code as String);
    return Input$ConfirmEmailChangeInput._(result$data);
  }

  Map<String, dynamic> _$data;

  String get verificationId => (_$data['verificationId'] as String);

  String get code => (_$data['code'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$verificationId = verificationId;
    result$data['verificationId'] = l$verificationId;
    final l$code = code;
    result$data['code'] = l$code;
    return result$data;
  }

  CopyWith$Input$ConfirmEmailChangeInput<Input$ConfirmEmailChangeInput>
  get copyWith => CopyWith$Input$ConfirmEmailChangeInput(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Input$ConfirmEmailChangeInput ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$verificationId = verificationId;
    final lOther$verificationId = other.verificationId;
    if (l$verificationId != lOther$verificationId) {
      return false;
    }
    final l$code = code;
    final lOther$code = other.code;
    if (l$code != lOther$code) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$verificationId = verificationId;
    final l$code = code;
    return Object.hashAll([l$verificationId, l$code]);
  }
}

abstract class CopyWith$Input$ConfirmEmailChangeInput<TRes> {
  factory CopyWith$Input$ConfirmEmailChangeInput(
    Input$ConfirmEmailChangeInput instance,
    TRes Function(Input$ConfirmEmailChangeInput) then,
  ) = _CopyWithImpl$Input$ConfirmEmailChangeInput;

  factory CopyWith$Input$ConfirmEmailChangeInput.stub(TRes res) =
      _CopyWithStubImpl$Input$ConfirmEmailChangeInput;

  TRes call({String? verificationId, String? code});
}

class _CopyWithImpl$Input$ConfirmEmailChangeInput<TRes>
    implements CopyWith$Input$ConfirmEmailChangeInput<TRes> {
  _CopyWithImpl$Input$ConfirmEmailChangeInput(this._instance, this._then);

  final Input$ConfirmEmailChangeInput _instance;

  final TRes Function(Input$ConfirmEmailChangeInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? verificationId = _undefined, Object? code = _undefined}) =>
      _then(
        Input$ConfirmEmailChangeInput._({
          ..._instance._$data,
          if (verificationId != _undefined && verificationId != null)
            'verificationId': (verificationId as String),
          if (code != _undefined && code != null) 'code': (code as String),
        }),
      );
}

class _CopyWithStubImpl$Input$ConfirmEmailChangeInput<TRes>
    implements CopyWith$Input$ConfirmEmailChangeInput<TRes> {
  _CopyWithStubImpl$Input$ConfirmEmailChangeInput(this._res);

  TRes _res;

  call({String? verificationId, String? code}) => _res;
}

class Input$ResendEmailChangeInput {
  factory Input$ResendEmailChangeInput({required String verificationId}) =>
      Input$ResendEmailChangeInput._({r'verificationId': verificationId});

  Input$ResendEmailChangeInput._(this._$data);

  factory Input$ResendEmailChangeInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$verificationId = data['verificationId'];
    result$data['verificationId'] = (l$verificationId as String);
    return Input$ResendEmailChangeInput._(result$data);
  }

  Map<String, dynamic> _$data;

  String get verificationId => (_$data['verificationId'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$verificationId = verificationId;
    result$data['verificationId'] = l$verificationId;
    return result$data;
  }

  CopyWith$Input$ResendEmailChangeInput<Input$ResendEmailChangeInput>
  get copyWith => CopyWith$Input$ResendEmailChangeInput(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Input$ResendEmailChangeInput ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$verificationId = verificationId;
    final lOther$verificationId = other.verificationId;
    if (l$verificationId != lOther$verificationId) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$verificationId = verificationId;
    return Object.hashAll([l$verificationId]);
  }
}

abstract class CopyWith$Input$ResendEmailChangeInput<TRes> {
  factory CopyWith$Input$ResendEmailChangeInput(
    Input$ResendEmailChangeInput instance,
    TRes Function(Input$ResendEmailChangeInput) then,
  ) = _CopyWithImpl$Input$ResendEmailChangeInput;

  factory CopyWith$Input$ResendEmailChangeInput.stub(TRes res) =
      _CopyWithStubImpl$Input$ResendEmailChangeInput;

  TRes call({String? verificationId});
}

class _CopyWithImpl$Input$ResendEmailChangeInput<TRes>
    implements CopyWith$Input$ResendEmailChangeInput<TRes> {
  _CopyWithImpl$Input$ResendEmailChangeInput(this._instance, this._then);

  final Input$ResendEmailChangeInput _instance;

  final TRes Function(Input$ResendEmailChangeInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? verificationId = _undefined}) => _then(
    Input$ResendEmailChangeInput._({
      ..._instance._$data,
      if (verificationId != _undefined && verificationId != null)
        'verificationId': (verificationId as String),
    }),
  );
}

class _CopyWithStubImpl$Input$ResendEmailChangeInput<TRes>
    implements CopyWith$Input$ResendEmailChangeInput<TRes> {
  _CopyWithStubImpl$Input$ResendEmailChangeInput(this._res);

  TRes _res;

  call({String? verificationId}) => _res;
}
