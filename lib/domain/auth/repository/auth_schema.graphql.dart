// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, unused_element
class Input$AgreementInput {
  factory Input$AgreementInput({
    required Enum$TermsCode termsCode,
    required bool agreed,
  }) => Input$AgreementInput._({r'termsCode': termsCode, r'agreed': agreed});

  Input$AgreementInput._(this._$data);

  factory Input$AgreementInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$termsCode = data['termsCode'];
    result$data['termsCode'] = fromJson$Enum$TermsCode((l$termsCode as String));
    final l$agreed = data['agreed'];
    result$data['agreed'] = (l$agreed as bool);
    return Input$AgreementInput._(result$data);
  }

  Map<String, dynamic> _$data;

  Enum$TermsCode get termsCode => (_$data['termsCode'] as Enum$TermsCode);

  bool get agreed => (_$data['agreed'] as bool);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$termsCode = termsCode;
    result$data['termsCode'] = toJson$Enum$TermsCode(l$termsCode);
    final l$agreed = agreed;
    result$data['agreed'] = l$agreed;
    return result$data;
  }

  CopyWith$Input$AgreementInput<Input$AgreementInput> get copyWith =>
      CopyWith$Input$AgreementInput(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Input$AgreementInput || runtimeType != other.runtimeType) {
      return false;
    }
    final l$termsCode = termsCode;
    final lOther$termsCode = other.termsCode;
    if (l$termsCode != lOther$termsCode) {
      return false;
    }
    final l$agreed = agreed;
    final lOther$agreed = other.agreed;
    if (l$agreed != lOther$agreed) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$termsCode = termsCode;
    final l$agreed = agreed;
    return Object.hashAll([l$termsCode, l$agreed]);
  }
}

abstract class CopyWith$Input$AgreementInput<TRes> {
  factory CopyWith$Input$AgreementInput(
    Input$AgreementInput instance,
    TRes Function(Input$AgreementInput) then,
  ) = _CopyWithImpl$Input$AgreementInput;

  factory CopyWith$Input$AgreementInput.stub(TRes res) =
      _CopyWithStubImpl$Input$AgreementInput;

  TRes call({Enum$TermsCode? termsCode, bool? agreed});
}

class _CopyWithImpl$Input$AgreementInput<TRes>
    implements CopyWith$Input$AgreementInput<TRes> {
  _CopyWithImpl$Input$AgreementInput(this._instance, this._then);

  final Input$AgreementInput _instance;

  final TRes Function(Input$AgreementInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? termsCode = _undefined, Object? agreed = _undefined}) =>
      _then(
        Input$AgreementInput._({
          ..._instance._$data,
          if (termsCode != _undefined && termsCode != null)
            'termsCode': (termsCode as Enum$TermsCode),
          if (agreed != _undefined && agreed != null)
            'agreed': (agreed as bool),
        }),
      );
}

class _CopyWithStubImpl$Input$AgreementInput<TRes>
    implements CopyWith$Input$AgreementInput<TRes> {
  _CopyWithStubImpl$Input$AgreementInput(this._res);

  TRes _res;

  call({Enum$TermsCode? termsCode, bool? agreed}) => _res;
}

class Input$AssignRoleInput {
  factory Input$AssignRoleInput({
    required String memberId,
    required String roleCode,
  }) => Input$AssignRoleInput._({r'memberId': memberId, r'roleCode': roleCode});

  Input$AssignRoleInput._(this._$data);

  factory Input$AssignRoleInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$memberId = data['memberId'];
    result$data['memberId'] = (l$memberId as String);
    final l$roleCode = data['roleCode'];
    result$data['roleCode'] = (l$roleCode as String);
    return Input$AssignRoleInput._(result$data);
  }

  Map<String, dynamic> _$data;

  String get memberId => (_$data['memberId'] as String);

  String get roleCode => (_$data['roleCode'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$memberId = memberId;
    result$data['memberId'] = l$memberId;
    final l$roleCode = roleCode;
    result$data['roleCode'] = l$roleCode;
    return result$data;
  }

  CopyWith$Input$AssignRoleInput<Input$AssignRoleInput> get copyWith =>
      CopyWith$Input$AssignRoleInput(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Input$AssignRoleInput || runtimeType != other.runtimeType) {
      return false;
    }
    final l$memberId = memberId;
    final lOther$memberId = other.memberId;
    if (l$memberId != lOther$memberId) {
      return false;
    }
    final l$roleCode = roleCode;
    final lOther$roleCode = other.roleCode;
    if (l$roleCode != lOther$roleCode) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$memberId = memberId;
    final l$roleCode = roleCode;
    return Object.hashAll([l$memberId, l$roleCode]);
  }
}

abstract class CopyWith$Input$AssignRoleInput<TRes> {
  factory CopyWith$Input$AssignRoleInput(
    Input$AssignRoleInput instance,
    TRes Function(Input$AssignRoleInput) then,
  ) = _CopyWithImpl$Input$AssignRoleInput;

  factory CopyWith$Input$AssignRoleInput.stub(TRes res) =
      _CopyWithStubImpl$Input$AssignRoleInput;

  TRes call({String? memberId, String? roleCode});
}

class _CopyWithImpl$Input$AssignRoleInput<TRes>
    implements CopyWith$Input$AssignRoleInput<TRes> {
  _CopyWithImpl$Input$AssignRoleInput(this._instance, this._then);

  final Input$AssignRoleInput _instance;

  final TRes Function(Input$AssignRoleInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? memberId = _undefined, Object? roleCode = _undefined}) =>
      _then(
        Input$AssignRoleInput._({
          ..._instance._$data,
          if (memberId != _undefined && memberId != null)
            'memberId': (memberId as String),
          if (roleCode != _undefined && roleCode != null)
            'roleCode': (roleCode as String),
        }),
      );
}

class _CopyWithStubImpl$Input$AssignRoleInput<TRes>
    implements CopyWith$Input$AssignRoleInput<TRes> {
  _CopyWithStubImpl$Input$AssignRoleInput(this._res);

  TRes _res;

  call({String? memberId, String? roleCode}) => _res;
}

class Input$LoginEmailInput {
  factory Input$LoginEmailInput({
    required String email,
    required String password,
  }) => Input$LoginEmailInput._({r'email': email, r'password': password});

  Input$LoginEmailInput._(this._$data);

  factory Input$LoginEmailInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$email = data['email'];
    result$data['email'] = (l$email as String);
    final l$password = data['password'];
    result$data['password'] = (l$password as String);
    return Input$LoginEmailInput._(result$data);
  }

  Map<String, dynamic> _$data;

  String get email => (_$data['email'] as String);

  String get password => (_$data['password'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$email = email;
    result$data['email'] = l$email;
    final l$password = password;
    result$data['password'] = l$password;
    return result$data;
  }

  CopyWith$Input$LoginEmailInput<Input$LoginEmailInput> get copyWith =>
      CopyWith$Input$LoginEmailInput(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Input$LoginEmailInput || runtimeType != other.runtimeType) {
      return false;
    }
    final l$email = email;
    final lOther$email = other.email;
    if (l$email != lOther$email) {
      return false;
    }
    final l$password = password;
    final lOther$password = other.password;
    if (l$password != lOther$password) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$email = email;
    final l$password = password;
    return Object.hashAll([l$email, l$password]);
  }
}

abstract class CopyWith$Input$LoginEmailInput<TRes> {
  factory CopyWith$Input$LoginEmailInput(
    Input$LoginEmailInput instance,
    TRes Function(Input$LoginEmailInput) then,
  ) = _CopyWithImpl$Input$LoginEmailInput;

  factory CopyWith$Input$LoginEmailInput.stub(TRes res) =
      _CopyWithStubImpl$Input$LoginEmailInput;

  TRes call({String? email, String? password});
}

class _CopyWithImpl$Input$LoginEmailInput<TRes>
    implements CopyWith$Input$LoginEmailInput<TRes> {
  _CopyWithImpl$Input$LoginEmailInput(this._instance, this._then);

  final Input$LoginEmailInput _instance;

  final TRes Function(Input$LoginEmailInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? email = _undefined, Object? password = _undefined}) =>
      _then(
        Input$LoginEmailInput._({
          ..._instance._$data,
          if (email != _undefined && email != null) 'email': (email as String),
          if (password != _undefined && password != null)
            'password': (password as String),
        }),
      );
}

class _CopyWithStubImpl$Input$LoginEmailInput<TRes>
    implements CopyWith$Input$LoginEmailInput<TRes> {
  _CopyWithStubImpl$Input$LoginEmailInput(this._res);

  TRes _res;

  call({String? email, String? password}) => _res;
}

class Input$LoginSnsInput {
  factory Input$LoginSnsInput({
    required Enum$Provider provider,
    required String idToken,
    String? authorizationCode,
  }) => Input$LoginSnsInput._({
    r'provider': provider,
    r'idToken': idToken,
    if (authorizationCode != null) r'authorizationCode': authorizationCode,
  });

  Input$LoginSnsInput._(this._$data);

  factory Input$LoginSnsInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$provider = data['provider'];
    result$data['provider'] = fromJson$Enum$Provider((l$provider as String));
    final l$idToken = data['idToken'];
    result$data['idToken'] = (l$idToken as String);
    if (data.containsKey('authorizationCode')) {
      final l$authorizationCode = data['authorizationCode'];
      result$data['authorizationCode'] = (l$authorizationCode as String?);
    }
    return Input$LoginSnsInput._(result$data);
  }

  Map<String, dynamic> _$data;

  Enum$Provider get provider => (_$data['provider'] as Enum$Provider);

  String get idToken => (_$data['idToken'] as String);

  String? get authorizationCode => (_$data['authorizationCode'] as String?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$provider = provider;
    result$data['provider'] = toJson$Enum$Provider(l$provider);
    final l$idToken = idToken;
    result$data['idToken'] = l$idToken;
    if (_$data.containsKey('authorizationCode')) {
      final l$authorizationCode = authorizationCode;
      result$data['authorizationCode'] = l$authorizationCode;
    }
    return result$data;
  }

  CopyWith$Input$LoginSnsInput<Input$LoginSnsInput> get copyWith =>
      CopyWith$Input$LoginSnsInput(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Input$LoginSnsInput || runtimeType != other.runtimeType) {
      return false;
    }
    final l$provider = provider;
    final lOther$provider = other.provider;
    if (l$provider != lOther$provider) {
      return false;
    }
    final l$idToken = idToken;
    final lOther$idToken = other.idToken;
    if (l$idToken != lOther$idToken) {
      return false;
    }
    final l$authorizationCode = authorizationCode;
    final lOther$authorizationCode = other.authorizationCode;
    if (_$data.containsKey('authorizationCode') !=
        other._$data.containsKey('authorizationCode')) {
      return false;
    }
    if (l$authorizationCode != lOther$authorizationCode) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$provider = provider;
    final l$idToken = idToken;
    final l$authorizationCode = authorizationCode;
    return Object.hashAll([
      l$provider,
      l$idToken,
      _$data.containsKey('authorizationCode') ? l$authorizationCode : const {},
    ]);
  }
}

abstract class CopyWith$Input$LoginSnsInput<TRes> {
  factory CopyWith$Input$LoginSnsInput(
    Input$LoginSnsInput instance,
    TRes Function(Input$LoginSnsInput) then,
  ) = _CopyWithImpl$Input$LoginSnsInput;

  factory CopyWith$Input$LoginSnsInput.stub(TRes res) =
      _CopyWithStubImpl$Input$LoginSnsInput;

  TRes call({
    Enum$Provider? provider,
    String? idToken,
    String? authorizationCode,
  });
}

class _CopyWithImpl$Input$LoginSnsInput<TRes>
    implements CopyWith$Input$LoginSnsInput<TRes> {
  _CopyWithImpl$Input$LoginSnsInput(this._instance, this._then);

  final Input$LoginSnsInput _instance;

  final TRes Function(Input$LoginSnsInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? provider = _undefined,
    Object? idToken = _undefined,
    Object? authorizationCode = _undefined,
  }) => _then(
    Input$LoginSnsInput._({
      ..._instance._$data,
      if (provider != _undefined && provider != null)
        'provider': (provider as Enum$Provider),
      if (idToken != _undefined && idToken != null)
        'idToken': (idToken as String),
      if (authorizationCode != _undefined)
        'authorizationCode': (authorizationCode as String?),
    }),
  );
}

class _CopyWithStubImpl$Input$LoginSnsInput<TRes>
    implements CopyWith$Input$LoginSnsInput<TRes> {
  _CopyWithStubImpl$Input$LoginSnsInput(this._res);

  TRes _res;

  call({Enum$Provider? provider, String? idToken, String? authorizationCode}) =>
      _res;
}

class Input$LogoutInput {
  factory Input$LogoutInput({required String refreshToken}) =>
      Input$LogoutInput._({r'refreshToken': refreshToken});

  Input$LogoutInput._(this._$data);

  factory Input$LogoutInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$refreshToken = data['refreshToken'];
    result$data['refreshToken'] = (l$refreshToken as String);
    return Input$LogoutInput._(result$data);
  }

  Map<String, dynamic> _$data;

  String get refreshToken => (_$data['refreshToken'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$refreshToken = refreshToken;
    result$data['refreshToken'] = l$refreshToken;
    return result$data;
  }

  CopyWith$Input$LogoutInput<Input$LogoutInput> get copyWith =>
      CopyWith$Input$LogoutInput(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Input$LogoutInput || runtimeType != other.runtimeType) {
      return false;
    }
    final l$refreshToken = refreshToken;
    final lOther$refreshToken = other.refreshToken;
    if (l$refreshToken != lOther$refreshToken) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$refreshToken = refreshToken;
    return Object.hashAll([l$refreshToken]);
  }
}

abstract class CopyWith$Input$LogoutInput<TRes> {
  factory CopyWith$Input$LogoutInput(
    Input$LogoutInput instance,
    TRes Function(Input$LogoutInput) then,
  ) = _CopyWithImpl$Input$LogoutInput;

  factory CopyWith$Input$LogoutInput.stub(TRes res) =
      _CopyWithStubImpl$Input$LogoutInput;

  TRes call({String? refreshToken});
}

class _CopyWithImpl$Input$LogoutInput<TRes>
    implements CopyWith$Input$LogoutInput<TRes> {
  _CopyWithImpl$Input$LogoutInput(this._instance, this._then);

  final Input$LogoutInput _instance;

  final TRes Function(Input$LogoutInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? refreshToken = _undefined}) => _then(
    Input$LogoutInput._({
      ..._instance._$data,
      if (refreshToken != _undefined && refreshToken != null)
        'refreshToken': (refreshToken as String),
    }),
  );
}

class _CopyWithStubImpl$Input$LogoutInput<TRes>
    implements CopyWith$Input$LogoutInput<TRes> {
  _CopyWithStubImpl$Input$LogoutInput(this._res);

  TRes _res;

  call({String? refreshToken}) => _res;
}

class Input$ReactivateMemberInput {
  factory Input$ReactivateMemberInput({required String memberId}) =>
      Input$ReactivateMemberInput._({r'memberId': memberId});

  Input$ReactivateMemberInput._(this._$data);

  factory Input$ReactivateMemberInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$memberId = data['memberId'];
    result$data['memberId'] = (l$memberId as String);
    return Input$ReactivateMemberInput._(result$data);
  }

  Map<String, dynamic> _$data;

  String get memberId => (_$data['memberId'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$memberId = memberId;
    result$data['memberId'] = l$memberId;
    return result$data;
  }

  CopyWith$Input$ReactivateMemberInput<Input$ReactivateMemberInput>
  get copyWith => CopyWith$Input$ReactivateMemberInput(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Input$ReactivateMemberInput ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$memberId = memberId;
    final lOther$memberId = other.memberId;
    if (l$memberId != lOther$memberId) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$memberId = memberId;
    return Object.hashAll([l$memberId]);
  }
}

abstract class CopyWith$Input$ReactivateMemberInput<TRes> {
  factory CopyWith$Input$ReactivateMemberInput(
    Input$ReactivateMemberInput instance,
    TRes Function(Input$ReactivateMemberInput) then,
  ) = _CopyWithImpl$Input$ReactivateMemberInput;

  factory CopyWith$Input$ReactivateMemberInput.stub(TRes res) =
      _CopyWithStubImpl$Input$ReactivateMemberInput;

  TRes call({String? memberId});
}

class _CopyWithImpl$Input$ReactivateMemberInput<TRes>
    implements CopyWith$Input$ReactivateMemberInput<TRes> {
  _CopyWithImpl$Input$ReactivateMemberInput(this._instance, this._then);

  final Input$ReactivateMemberInput _instance;

  final TRes Function(Input$ReactivateMemberInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? memberId = _undefined}) => _then(
    Input$ReactivateMemberInput._({
      ..._instance._$data,
      if (memberId != _undefined && memberId != null)
        'memberId': (memberId as String),
    }),
  );
}

class _CopyWithStubImpl$Input$ReactivateMemberInput<TRes>
    implements CopyWith$Input$ReactivateMemberInput<TRes> {
  _CopyWithStubImpl$Input$ReactivateMemberInput(this._res);

  TRes _res;

  call({String? memberId}) => _res;
}

class Input$RefreshTokenInput {
  factory Input$RefreshTokenInput({required String refreshToken}) =>
      Input$RefreshTokenInput._({r'refreshToken': refreshToken});

  Input$RefreshTokenInput._(this._$data);

  factory Input$RefreshTokenInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$refreshToken = data['refreshToken'];
    result$data['refreshToken'] = (l$refreshToken as String);
    return Input$RefreshTokenInput._(result$data);
  }

  Map<String, dynamic> _$data;

  String get refreshToken => (_$data['refreshToken'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$refreshToken = refreshToken;
    result$data['refreshToken'] = l$refreshToken;
    return result$data;
  }

  CopyWith$Input$RefreshTokenInput<Input$RefreshTokenInput> get copyWith =>
      CopyWith$Input$RefreshTokenInput(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Input$RefreshTokenInput || runtimeType != other.runtimeType) {
      return false;
    }
    final l$refreshToken = refreshToken;
    final lOther$refreshToken = other.refreshToken;
    if (l$refreshToken != lOther$refreshToken) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$refreshToken = refreshToken;
    return Object.hashAll([l$refreshToken]);
  }
}

abstract class CopyWith$Input$RefreshTokenInput<TRes> {
  factory CopyWith$Input$RefreshTokenInput(
    Input$RefreshTokenInput instance,
    TRes Function(Input$RefreshTokenInput) then,
  ) = _CopyWithImpl$Input$RefreshTokenInput;

  factory CopyWith$Input$RefreshTokenInput.stub(TRes res) =
      _CopyWithStubImpl$Input$RefreshTokenInput;

  TRes call({String? refreshToken});
}

class _CopyWithImpl$Input$RefreshTokenInput<TRes>
    implements CopyWith$Input$RefreshTokenInput<TRes> {
  _CopyWithImpl$Input$RefreshTokenInput(this._instance, this._then);

  final Input$RefreshTokenInput _instance;

  final TRes Function(Input$RefreshTokenInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? refreshToken = _undefined}) => _then(
    Input$RefreshTokenInput._({
      ..._instance._$data,
      if (refreshToken != _undefined && refreshToken != null)
        'refreshToken': (refreshToken as String),
    }),
  );
}

class _CopyWithStubImpl$Input$RefreshTokenInput<TRes>
    implements CopyWith$Input$RefreshTokenInput<TRes> {
  _CopyWithStubImpl$Input$RefreshTokenInput(this._res);

  TRes _res;

  call({String? refreshToken}) => _res;
}

class Input$RegisterEmailMemberInput {
  factory Input$RegisterEmailMemberInput({
    required String email,
    required String password,
    required bool ageVerified,
    required List<Input$AgreementInput> agreements,
  }) => Input$RegisterEmailMemberInput._({
    r'email': email,
    r'password': password,
    r'ageVerified': ageVerified,
    r'agreements': agreements,
  });

  Input$RegisterEmailMemberInput._(this._$data);

  factory Input$RegisterEmailMemberInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$email = data['email'];
    result$data['email'] = (l$email as String);
    final l$password = data['password'];
    result$data['password'] = (l$password as String);
    final l$ageVerified = data['ageVerified'];
    result$data['ageVerified'] = (l$ageVerified as bool);
    final l$agreements = data['agreements'];
    result$data['agreements'] = (l$agreements as List<dynamic>)
        .map((e) => Input$AgreementInput.fromJson((e as Map<String, dynamic>)))
        .toList();
    return Input$RegisterEmailMemberInput._(result$data);
  }

  Map<String, dynamic> _$data;

  String get email => (_$data['email'] as String);

  String get password => (_$data['password'] as String);

  bool get ageVerified => (_$data['ageVerified'] as bool);

  List<Input$AgreementInput> get agreements =>
      (_$data['agreements'] as List<Input$AgreementInput>);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$email = email;
    result$data['email'] = l$email;
    final l$password = password;
    result$data['password'] = l$password;
    final l$ageVerified = ageVerified;
    result$data['ageVerified'] = l$ageVerified;
    final l$agreements = agreements;
    result$data['agreements'] = l$agreements.map((e) => e.toJson()).toList();
    return result$data;
  }

  CopyWith$Input$RegisterEmailMemberInput<Input$RegisterEmailMemberInput>
  get copyWith => CopyWith$Input$RegisterEmailMemberInput(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Input$RegisterEmailMemberInput ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$email = email;
    final lOther$email = other.email;
    if (l$email != lOther$email) {
      return false;
    }
    final l$password = password;
    final lOther$password = other.password;
    if (l$password != lOther$password) {
      return false;
    }
    final l$ageVerified = ageVerified;
    final lOther$ageVerified = other.ageVerified;
    if (l$ageVerified != lOther$ageVerified) {
      return false;
    }
    final l$agreements = agreements;
    final lOther$agreements = other.agreements;
    if (l$agreements.length != lOther$agreements.length) {
      return false;
    }
    for (int i = 0; i < l$agreements.length; i++) {
      final l$agreements$entry = l$agreements[i];
      final lOther$agreements$entry = lOther$agreements[i];
      if (l$agreements$entry != lOther$agreements$entry) {
        return false;
      }
    }
    return true;
  }

  @override
  int get hashCode {
    final l$email = email;
    final l$password = password;
    final l$ageVerified = ageVerified;
    final l$agreements = agreements;
    return Object.hashAll([
      l$email,
      l$password,
      l$ageVerified,
      Object.hashAll(l$agreements.map((v) => v)),
    ]);
  }
}

abstract class CopyWith$Input$RegisterEmailMemberInput<TRes> {
  factory CopyWith$Input$RegisterEmailMemberInput(
    Input$RegisterEmailMemberInput instance,
    TRes Function(Input$RegisterEmailMemberInput) then,
  ) = _CopyWithImpl$Input$RegisterEmailMemberInput;

  factory CopyWith$Input$RegisterEmailMemberInput.stub(TRes res) =
      _CopyWithStubImpl$Input$RegisterEmailMemberInput;

  TRes call({
    String? email,
    String? password,
    bool? ageVerified,
    List<Input$AgreementInput>? agreements,
  });
  TRes agreements(
    Iterable<Input$AgreementInput> Function(
      Iterable<CopyWith$Input$AgreementInput<Input$AgreementInput>>,
    )
    _fn,
  );
}

class _CopyWithImpl$Input$RegisterEmailMemberInput<TRes>
    implements CopyWith$Input$RegisterEmailMemberInput<TRes> {
  _CopyWithImpl$Input$RegisterEmailMemberInput(this._instance, this._then);

  final Input$RegisterEmailMemberInput _instance;

  final TRes Function(Input$RegisterEmailMemberInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? email = _undefined,
    Object? password = _undefined,
    Object? ageVerified = _undefined,
    Object? agreements = _undefined,
  }) => _then(
    Input$RegisterEmailMemberInput._({
      ..._instance._$data,
      if (email != _undefined && email != null) 'email': (email as String),
      if (password != _undefined && password != null)
        'password': (password as String),
      if (ageVerified != _undefined && ageVerified != null)
        'ageVerified': (ageVerified as bool),
      if (agreements != _undefined && agreements != null)
        'agreements': (agreements as List<Input$AgreementInput>),
    }),
  );

  TRes agreements(
    Iterable<Input$AgreementInput> Function(
      Iterable<CopyWith$Input$AgreementInput<Input$AgreementInput>>,
    )
    _fn,
  ) => call(
    agreements: _fn(
      _instance.agreements.map(
        (e) => CopyWith$Input$AgreementInput(e, (i) => i),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl$Input$RegisterEmailMemberInput<TRes>
    implements CopyWith$Input$RegisterEmailMemberInput<TRes> {
  _CopyWithStubImpl$Input$RegisterEmailMemberInput(this._res);

  TRes _res;

  call({
    String? email,
    String? password,
    bool? ageVerified,
    List<Input$AgreementInput>? agreements,
  }) => _res;

  agreements(_fn) => _res;
}

class Input$RegisterSnsMemberInput {
  factory Input$RegisterSnsMemberInput({
    required Enum$Provider provider,
    required String idToken,
    required String email,
    required bool ageVerified,
    required List<Input$AgreementInput> agreements,
    String? authorizationCode,
  }) => Input$RegisterSnsMemberInput._({
    r'provider': provider,
    r'idToken': idToken,
    r'email': email,
    r'ageVerified': ageVerified,
    r'agreements': agreements,
    if (authorizationCode != null) r'authorizationCode': authorizationCode,
  });

  Input$RegisterSnsMemberInput._(this._$data);

  factory Input$RegisterSnsMemberInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$provider = data['provider'];
    result$data['provider'] = fromJson$Enum$Provider((l$provider as String));
    final l$idToken = data['idToken'];
    result$data['idToken'] = (l$idToken as String);
    final l$email = data['email'];
    result$data['email'] = (l$email as String);
    final l$ageVerified = data['ageVerified'];
    result$data['ageVerified'] = (l$ageVerified as bool);
    final l$agreements = data['agreements'];
    result$data['agreements'] = (l$agreements as List<dynamic>)
        .map((e) => Input$AgreementInput.fromJson((e as Map<String, dynamic>)))
        .toList();
    if (data.containsKey('authorizationCode')) {
      final l$authorizationCode = data['authorizationCode'];
      result$data['authorizationCode'] = (l$authorizationCode as String?);
    }
    return Input$RegisterSnsMemberInput._(result$data);
  }

  Map<String, dynamic> _$data;

  Enum$Provider get provider => (_$data['provider'] as Enum$Provider);

  String get idToken => (_$data['idToken'] as String);

  String get email => (_$data['email'] as String);

  bool get ageVerified => (_$data['ageVerified'] as bool);

  List<Input$AgreementInput> get agreements =>
      (_$data['agreements'] as List<Input$AgreementInput>);

  String? get authorizationCode => (_$data['authorizationCode'] as String?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$provider = provider;
    result$data['provider'] = toJson$Enum$Provider(l$provider);
    final l$idToken = idToken;
    result$data['idToken'] = l$idToken;
    final l$email = email;
    result$data['email'] = l$email;
    final l$ageVerified = ageVerified;
    result$data['ageVerified'] = l$ageVerified;
    final l$agreements = agreements;
    result$data['agreements'] = l$agreements.map((e) => e.toJson()).toList();
    if (_$data.containsKey('authorizationCode')) {
      final l$authorizationCode = authorizationCode;
      result$data['authorizationCode'] = l$authorizationCode;
    }
    return result$data;
  }

  CopyWith$Input$RegisterSnsMemberInput<Input$RegisterSnsMemberInput>
  get copyWith => CopyWith$Input$RegisterSnsMemberInput(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Input$RegisterSnsMemberInput ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$provider = provider;
    final lOther$provider = other.provider;
    if (l$provider != lOther$provider) {
      return false;
    }
    final l$idToken = idToken;
    final lOther$idToken = other.idToken;
    if (l$idToken != lOther$idToken) {
      return false;
    }
    final l$email = email;
    final lOther$email = other.email;
    if (l$email != lOther$email) {
      return false;
    }
    final l$ageVerified = ageVerified;
    final lOther$ageVerified = other.ageVerified;
    if (l$ageVerified != lOther$ageVerified) {
      return false;
    }
    final l$agreements = agreements;
    final lOther$agreements = other.agreements;
    if (l$agreements.length != lOther$agreements.length) {
      return false;
    }
    for (int i = 0; i < l$agreements.length; i++) {
      final l$agreements$entry = l$agreements[i];
      final lOther$agreements$entry = lOther$agreements[i];
      if (l$agreements$entry != lOther$agreements$entry) {
        return false;
      }
    }
    final l$authorizationCode = authorizationCode;
    final lOther$authorizationCode = other.authorizationCode;
    if (_$data.containsKey('authorizationCode') !=
        other._$data.containsKey('authorizationCode')) {
      return false;
    }
    if (l$authorizationCode != lOther$authorizationCode) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$provider = provider;
    final l$idToken = idToken;
    final l$email = email;
    final l$ageVerified = ageVerified;
    final l$agreements = agreements;
    final l$authorizationCode = authorizationCode;
    return Object.hashAll([
      l$provider,
      l$idToken,
      l$email,
      l$ageVerified,
      Object.hashAll(l$agreements.map((v) => v)),
      _$data.containsKey('authorizationCode') ? l$authorizationCode : const {},
    ]);
  }
}

abstract class CopyWith$Input$RegisterSnsMemberInput<TRes> {
  factory CopyWith$Input$RegisterSnsMemberInput(
    Input$RegisterSnsMemberInput instance,
    TRes Function(Input$RegisterSnsMemberInput) then,
  ) = _CopyWithImpl$Input$RegisterSnsMemberInput;

  factory CopyWith$Input$RegisterSnsMemberInput.stub(TRes res) =
      _CopyWithStubImpl$Input$RegisterSnsMemberInput;

  TRes call({
    Enum$Provider? provider,
    String? idToken,
    String? email,
    bool? ageVerified,
    List<Input$AgreementInput>? agreements,
    String? authorizationCode,
  });
  TRes agreements(
    Iterable<Input$AgreementInput> Function(
      Iterable<CopyWith$Input$AgreementInput<Input$AgreementInput>>,
    )
    _fn,
  );
}

class _CopyWithImpl$Input$RegisterSnsMemberInput<TRes>
    implements CopyWith$Input$RegisterSnsMemberInput<TRes> {
  _CopyWithImpl$Input$RegisterSnsMemberInput(this._instance, this._then);

  final Input$RegisterSnsMemberInput _instance;

  final TRes Function(Input$RegisterSnsMemberInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? provider = _undefined,
    Object? idToken = _undefined,
    Object? email = _undefined,
    Object? ageVerified = _undefined,
    Object? agreements = _undefined,
    Object? authorizationCode = _undefined,
  }) => _then(
    Input$RegisterSnsMemberInput._({
      ..._instance._$data,
      if (provider != _undefined && provider != null)
        'provider': (provider as Enum$Provider),
      if (idToken != _undefined && idToken != null)
        'idToken': (idToken as String),
      if (email != _undefined && email != null) 'email': (email as String),
      if (ageVerified != _undefined && ageVerified != null)
        'ageVerified': (ageVerified as bool),
      if (agreements != _undefined && agreements != null)
        'agreements': (agreements as List<Input$AgreementInput>),
      if (authorizationCode != _undefined)
        'authorizationCode': (authorizationCode as String?),
    }),
  );

  TRes agreements(
    Iterable<Input$AgreementInput> Function(
      Iterable<CopyWith$Input$AgreementInput<Input$AgreementInput>>,
    )
    _fn,
  ) => call(
    agreements: _fn(
      _instance.agreements.map(
        (e) => CopyWith$Input$AgreementInput(e, (i) => i),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl$Input$RegisterSnsMemberInput<TRes>
    implements CopyWith$Input$RegisterSnsMemberInput<TRes> {
  _CopyWithStubImpl$Input$RegisterSnsMemberInput(this._res);

  TRes _res;

  call({
    Enum$Provider? provider,
    String? idToken,
    String? email,
    bool? ageVerified,
    List<Input$AgreementInput>? agreements,
    String? authorizationCode,
  }) => _res;

  agreements(_fn) => _res;
}

class Input$RequestPasswordResetInput {
  factory Input$RequestPasswordResetInput({required String email}) =>
      Input$RequestPasswordResetInput._({r'email': email});

  Input$RequestPasswordResetInput._(this._$data);

  factory Input$RequestPasswordResetInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$email = data['email'];
    result$data['email'] = (l$email as String);
    return Input$RequestPasswordResetInput._(result$data);
  }

  Map<String, dynamic> _$data;

  String get email => (_$data['email'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$email = email;
    result$data['email'] = l$email;
    return result$data;
  }

  CopyWith$Input$RequestPasswordResetInput<Input$RequestPasswordResetInput>
  get copyWith => CopyWith$Input$RequestPasswordResetInput(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Input$RequestPasswordResetInput ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$email = email;
    final lOther$email = other.email;
    if (l$email != lOther$email) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$email = email;
    return Object.hashAll([l$email]);
  }
}

abstract class CopyWith$Input$RequestPasswordResetInput<TRes> {
  factory CopyWith$Input$RequestPasswordResetInput(
    Input$RequestPasswordResetInput instance,
    TRes Function(Input$RequestPasswordResetInput) then,
  ) = _CopyWithImpl$Input$RequestPasswordResetInput;

  factory CopyWith$Input$RequestPasswordResetInput.stub(TRes res) =
      _CopyWithStubImpl$Input$RequestPasswordResetInput;

  TRes call({String? email});
}

class _CopyWithImpl$Input$RequestPasswordResetInput<TRes>
    implements CopyWith$Input$RequestPasswordResetInput<TRes> {
  _CopyWithImpl$Input$RequestPasswordResetInput(this._instance, this._then);

  final Input$RequestPasswordResetInput _instance;

  final TRes Function(Input$RequestPasswordResetInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? email = _undefined}) => _then(
    Input$RequestPasswordResetInput._({
      ..._instance._$data,
      if (email != _undefined && email != null) 'email': (email as String),
    }),
  );
}

class _CopyWithStubImpl$Input$RequestPasswordResetInput<TRes>
    implements CopyWith$Input$RequestPasswordResetInput<TRes> {
  _CopyWithStubImpl$Input$RequestPasswordResetInput(this._res);

  TRes _res;

  call({String? email}) => _res;
}

class Input$ResendVerificationInput {
  factory Input$ResendVerificationInput({required String verificationId}) =>
      Input$ResendVerificationInput._({r'verificationId': verificationId});

  Input$ResendVerificationInput._(this._$data);

  factory Input$ResendVerificationInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$verificationId = data['verificationId'];
    result$data['verificationId'] = (l$verificationId as String);
    return Input$ResendVerificationInput._(result$data);
  }

  Map<String, dynamic> _$data;

  String get verificationId => (_$data['verificationId'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$verificationId = verificationId;
    result$data['verificationId'] = l$verificationId;
    return result$data;
  }

  CopyWith$Input$ResendVerificationInput<Input$ResendVerificationInput>
  get copyWith => CopyWith$Input$ResendVerificationInput(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Input$ResendVerificationInput ||
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

abstract class CopyWith$Input$ResendVerificationInput<TRes> {
  factory CopyWith$Input$ResendVerificationInput(
    Input$ResendVerificationInput instance,
    TRes Function(Input$ResendVerificationInput) then,
  ) = _CopyWithImpl$Input$ResendVerificationInput;

  factory CopyWith$Input$ResendVerificationInput.stub(TRes res) =
      _CopyWithStubImpl$Input$ResendVerificationInput;

  TRes call({String? verificationId});
}

class _CopyWithImpl$Input$ResendVerificationInput<TRes>
    implements CopyWith$Input$ResendVerificationInput<TRes> {
  _CopyWithImpl$Input$ResendVerificationInput(this._instance, this._then);

  final Input$ResendVerificationInput _instance;

  final TRes Function(Input$ResendVerificationInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? verificationId = _undefined}) => _then(
    Input$ResendVerificationInput._({
      ..._instance._$data,
      if (verificationId != _undefined && verificationId != null)
        'verificationId': (verificationId as String),
    }),
  );
}

class _CopyWithStubImpl$Input$ResendVerificationInput<TRes>
    implements CopyWith$Input$ResendVerificationInput<TRes> {
  _CopyWithStubImpl$Input$ResendVerificationInput(this._res);

  TRes _res;

  call({String? verificationId}) => _res;
}

class Input$ResetPasswordInput {
  factory Input$ResetPasswordInput({
    required String email,
    required String code,
    required String newPassword,
  }) => Input$ResetPasswordInput._({
    r'email': email,
    r'code': code,
    r'newPassword': newPassword,
  });

  Input$ResetPasswordInput._(this._$data);

  factory Input$ResetPasswordInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$email = data['email'];
    result$data['email'] = (l$email as String);
    final l$code = data['code'];
    result$data['code'] = (l$code as String);
    final l$newPassword = data['newPassword'];
    result$data['newPassword'] = (l$newPassword as String);
    return Input$ResetPasswordInput._(result$data);
  }

  Map<String, dynamic> _$data;

  String get email => (_$data['email'] as String);

  String get code => (_$data['code'] as String);

  String get newPassword => (_$data['newPassword'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$email = email;
    result$data['email'] = l$email;
    final l$code = code;
    result$data['code'] = l$code;
    final l$newPassword = newPassword;
    result$data['newPassword'] = l$newPassword;
    return result$data;
  }

  CopyWith$Input$ResetPasswordInput<Input$ResetPasswordInput> get copyWith =>
      CopyWith$Input$ResetPasswordInput(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Input$ResetPasswordInput ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$email = email;
    final lOther$email = other.email;
    if (l$email != lOther$email) {
      return false;
    }
    final l$code = code;
    final lOther$code = other.code;
    if (l$code != lOther$code) {
      return false;
    }
    final l$newPassword = newPassword;
    final lOther$newPassword = other.newPassword;
    if (l$newPassword != lOther$newPassword) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$email = email;
    final l$code = code;
    final l$newPassword = newPassword;
    return Object.hashAll([l$email, l$code, l$newPassword]);
  }
}

abstract class CopyWith$Input$ResetPasswordInput<TRes> {
  factory CopyWith$Input$ResetPasswordInput(
    Input$ResetPasswordInput instance,
    TRes Function(Input$ResetPasswordInput) then,
  ) = _CopyWithImpl$Input$ResetPasswordInput;

  factory CopyWith$Input$ResetPasswordInput.stub(TRes res) =
      _CopyWithStubImpl$Input$ResetPasswordInput;

  TRes call({String? email, String? code, String? newPassword});
}

class _CopyWithImpl$Input$ResetPasswordInput<TRes>
    implements CopyWith$Input$ResetPasswordInput<TRes> {
  _CopyWithImpl$Input$ResetPasswordInput(this._instance, this._then);

  final Input$ResetPasswordInput _instance;

  final TRes Function(Input$ResetPasswordInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? email = _undefined,
    Object? code = _undefined,
    Object? newPassword = _undefined,
  }) => _then(
    Input$ResetPasswordInput._({
      ..._instance._$data,
      if (email != _undefined && email != null) 'email': (email as String),
      if (code != _undefined && code != null) 'code': (code as String),
      if (newPassword != _undefined && newPassword != null)
        'newPassword': (newPassword as String),
    }),
  );
}

class _CopyWithStubImpl$Input$ResetPasswordInput<TRes>
    implements CopyWith$Input$ResetPasswordInput<TRes> {
  _CopyWithStubImpl$Input$ResetPasswordInput(this._res);

  TRes _res;

  call({String? email, String? code, String? newPassword}) => _res;
}

class Input$RevokeRoleInput {
  factory Input$RevokeRoleInput({
    required String memberId,
    required String roleCode,
  }) => Input$RevokeRoleInput._({r'memberId': memberId, r'roleCode': roleCode});

  Input$RevokeRoleInput._(this._$data);

  factory Input$RevokeRoleInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$memberId = data['memberId'];
    result$data['memberId'] = (l$memberId as String);
    final l$roleCode = data['roleCode'];
    result$data['roleCode'] = (l$roleCode as String);
    return Input$RevokeRoleInput._(result$data);
  }

  Map<String, dynamic> _$data;

  String get memberId => (_$data['memberId'] as String);

  String get roleCode => (_$data['roleCode'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$memberId = memberId;
    result$data['memberId'] = l$memberId;
    final l$roleCode = roleCode;
    result$data['roleCode'] = l$roleCode;
    return result$data;
  }

  CopyWith$Input$RevokeRoleInput<Input$RevokeRoleInput> get copyWith =>
      CopyWith$Input$RevokeRoleInput(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Input$RevokeRoleInput || runtimeType != other.runtimeType) {
      return false;
    }
    final l$memberId = memberId;
    final lOther$memberId = other.memberId;
    if (l$memberId != lOther$memberId) {
      return false;
    }
    final l$roleCode = roleCode;
    final lOther$roleCode = other.roleCode;
    if (l$roleCode != lOther$roleCode) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$memberId = memberId;
    final l$roleCode = roleCode;
    return Object.hashAll([l$memberId, l$roleCode]);
  }
}

abstract class CopyWith$Input$RevokeRoleInput<TRes> {
  factory CopyWith$Input$RevokeRoleInput(
    Input$RevokeRoleInput instance,
    TRes Function(Input$RevokeRoleInput) then,
  ) = _CopyWithImpl$Input$RevokeRoleInput;

  factory CopyWith$Input$RevokeRoleInput.stub(TRes res) =
      _CopyWithStubImpl$Input$RevokeRoleInput;

  TRes call({String? memberId, String? roleCode});
}

class _CopyWithImpl$Input$RevokeRoleInput<TRes>
    implements CopyWith$Input$RevokeRoleInput<TRes> {
  _CopyWithImpl$Input$RevokeRoleInput(this._instance, this._then);

  final Input$RevokeRoleInput _instance;

  final TRes Function(Input$RevokeRoleInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? memberId = _undefined, Object? roleCode = _undefined}) =>
      _then(
        Input$RevokeRoleInput._({
          ..._instance._$data,
          if (memberId != _undefined && memberId != null)
            'memberId': (memberId as String),
          if (roleCode != _undefined && roleCode != null)
            'roleCode': (roleCode as String),
        }),
      );
}

class _CopyWithStubImpl$Input$RevokeRoleInput<TRes>
    implements CopyWith$Input$RevokeRoleInput<TRes> {
  _CopyWithStubImpl$Input$RevokeRoleInput(this._res);

  TRes _res;

  call({String? memberId, String? roleCode}) => _res;
}

class Input$SuspendMemberInput {
  factory Input$SuspendMemberInput({
    required String memberId,
    required String reason,
    String? suspendedUntil,
  }) => Input$SuspendMemberInput._({
    r'memberId': memberId,
    r'reason': reason,
    if (suspendedUntil != null) r'suspendedUntil': suspendedUntil,
  });

  Input$SuspendMemberInput._(this._$data);

  factory Input$SuspendMemberInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$memberId = data['memberId'];
    result$data['memberId'] = (l$memberId as String);
    final l$reason = data['reason'];
    result$data['reason'] = (l$reason as String);
    if (data.containsKey('suspendedUntil')) {
      final l$suspendedUntil = data['suspendedUntil'];
      result$data['suspendedUntil'] = (l$suspendedUntil as String?);
    }
    return Input$SuspendMemberInput._(result$data);
  }

  Map<String, dynamic> _$data;

  String get memberId => (_$data['memberId'] as String);

  String get reason => (_$data['reason'] as String);

  String? get suspendedUntil => (_$data['suspendedUntil'] as String?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$memberId = memberId;
    result$data['memberId'] = l$memberId;
    final l$reason = reason;
    result$data['reason'] = l$reason;
    if (_$data.containsKey('suspendedUntil')) {
      final l$suspendedUntil = suspendedUntil;
      result$data['suspendedUntil'] = l$suspendedUntil;
    }
    return result$data;
  }

  CopyWith$Input$SuspendMemberInput<Input$SuspendMemberInput> get copyWith =>
      CopyWith$Input$SuspendMemberInput(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Input$SuspendMemberInput ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$memberId = memberId;
    final lOther$memberId = other.memberId;
    if (l$memberId != lOther$memberId) {
      return false;
    }
    final l$reason = reason;
    final lOther$reason = other.reason;
    if (l$reason != lOther$reason) {
      return false;
    }
    final l$suspendedUntil = suspendedUntil;
    final lOther$suspendedUntil = other.suspendedUntil;
    if (_$data.containsKey('suspendedUntil') !=
        other._$data.containsKey('suspendedUntil')) {
      return false;
    }
    if (l$suspendedUntil != lOther$suspendedUntil) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$memberId = memberId;
    final l$reason = reason;
    final l$suspendedUntil = suspendedUntil;
    return Object.hashAll([
      l$memberId,
      l$reason,
      _$data.containsKey('suspendedUntil') ? l$suspendedUntil : const {},
    ]);
  }
}

abstract class CopyWith$Input$SuspendMemberInput<TRes> {
  factory CopyWith$Input$SuspendMemberInput(
    Input$SuspendMemberInput instance,
    TRes Function(Input$SuspendMemberInput) then,
  ) = _CopyWithImpl$Input$SuspendMemberInput;

  factory CopyWith$Input$SuspendMemberInput.stub(TRes res) =
      _CopyWithStubImpl$Input$SuspendMemberInput;

  TRes call({String? memberId, String? reason, String? suspendedUntil});
}

class _CopyWithImpl$Input$SuspendMemberInput<TRes>
    implements CopyWith$Input$SuspendMemberInput<TRes> {
  _CopyWithImpl$Input$SuspendMemberInput(this._instance, this._then);

  final Input$SuspendMemberInput _instance;

  final TRes Function(Input$SuspendMemberInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? memberId = _undefined,
    Object? reason = _undefined,
    Object? suspendedUntil = _undefined,
  }) => _then(
    Input$SuspendMemberInput._({
      ..._instance._$data,
      if (memberId != _undefined && memberId != null)
        'memberId': (memberId as String),
      if (reason != _undefined && reason != null) 'reason': (reason as String),
      if (suspendedUntil != _undefined)
        'suspendedUntil': (suspendedUntil as String?),
    }),
  );
}

class _CopyWithStubImpl$Input$SuspendMemberInput<TRes>
    implements CopyWith$Input$SuspendMemberInput<TRes> {
  _CopyWithStubImpl$Input$SuspendMemberInput(this._res);

  TRes _res;

  call({String? memberId, String? reason, String? suspendedUntil}) => _res;
}

class Input$VerifyEmailInput {
  factory Input$VerifyEmailInput({
    required String verificationId,
    required String code,
  }) => Input$VerifyEmailInput._({
    r'verificationId': verificationId,
    r'code': code,
  });

  Input$VerifyEmailInput._(this._$data);

  factory Input$VerifyEmailInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$verificationId = data['verificationId'];
    result$data['verificationId'] = (l$verificationId as String);
    final l$code = data['code'];
    result$data['code'] = (l$code as String);
    return Input$VerifyEmailInput._(result$data);
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

  CopyWith$Input$VerifyEmailInput<Input$VerifyEmailInput> get copyWith =>
      CopyWith$Input$VerifyEmailInput(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Input$VerifyEmailInput || runtimeType != other.runtimeType) {
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

abstract class CopyWith$Input$VerifyEmailInput<TRes> {
  factory CopyWith$Input$VerifyEmailInput(
    Input$VerifyEmailInput instance,
    TRes Function(Input$VerifyEmailInput) then,
  ) = _CopyWithImpl$Input$VerifyEmailInput;

  factory CopyWith$Input$VerifyEmailInput.stub(TRes res) =
      _CopyWithStubImpl$Input$VerifyEmailInput;

  TRes call({String? verificationId, String? code});
}

class _CopyWithImpl$Input$VerifyEmailInput<TRes>
    implements CopyWith$Input$VerifyEmailInput<TRes> {
  _CopyWithImpl$Input$VerifyEmailInput(this._instance, this._then);

  final Input$VerifyEmailInput _instance;

  final TRes Function(Input$VerifyEmailInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? verificationId = _undefined, Object? code = _undefined}) =>
      _then(
        Input$VerifyEmailInput._({
          ..._instance._$data,
          if (verificationId != _undefined && verificationId != null)
            'verificationId': (verificationId as String),
          if (code != _undefined && code != null) 'code': (code as String),
        }),
      );
}

class _CopyWithStubImpl$Input$VerifyEmailInput<TRes>
    implements CopyWith$Input$VerifyEmailInput<TRes> {
  _CopyWithStubImpl$Input$VerifyEmailInput(this._res);

  TRes _res;

  call({String? verificationId, String? code}) => _res;
}

enum Enum$ErrorDetail {
  UNKNOWN,
  FIELD_NOT_FOUND,
  INVALID_CURSOR,
  UNIMPLEMENTED,
  INVALID_ARGUMENT,
  DEADLINE_EXCEEDED,
  SERVICE_ERROR,
  THROTTLED_CPU,
  THROTTLED_CONCURRENCY,
  ENHANCE_YOUR_CALM,
  TOO_MANY_REQUESTS,
  TCP_FAILURE,
  MISSING_RESOURCE,
  $unknown;

  factory Enum$ErrorDetail.fromJson(String value) =>
      fromJson$Enum$ErrorDetail(value);

  String toJson() => toJson$Enum$ErrorDetail(this);
}

String toJson$Enum$ErrorDetail(Enum$ErrorDetail e) {
  switch (e) {
    case Enum$ErrorDetail.UNKNOWN:
      return r'UNKNOWN';
    case Enum$ErrorDetail.FIELD_NOT_FOUND:
      return r'FIELD_NOT_FOUND';
    case Enum$ErrorDetail.INVALID_CURSOR:
      return r'INVALID_CURSOR';
    case Enum$ErrorDetail.UNIMPLEMENTED:
      return r'UNIMPLEMENTED';
    case Enum$ErrorDetail.INVALID_ARGUMENT:
      return r'INVALID_ARGUMENT';
    case Enum$ErrorDetail.DEADLINE_EXCEEDED:
      return r'DEADLINE_EXCEEDED';
    case Enum$ErrorDetail.SERVICE_ERROR:
      return r'SERVICE_ERROR';
    case Enum$ErrorDetail.THROTTLED_CPU:
      return r'THROTTLED_CPU';
    case Enum$ErrorDetail.THROTTLED_CONCURRENCY:
      return r'THROTTLED_CONCURRENCY';
    case Enum$ErrorDetail.ENHANCE_YOUR_CALM:
      return r'ENHANCE_YOUR_CALM';
    case Enum$ErrorDetail.TOO_MANY_REQUESTS:
      return r'TOO_MANY_REQUESTS';
    case Enum$ErrorDetail.TCP_FAILURE:
      return r'TCP_FAILURE';
    case Enum$ErrorDetail.MISSING_RESOURCE:
      return r'MISSING_RESOURCE';
    case Enum$ErrorDetail.$unknown:
      return r'$unknown';
  }
}

Enum$ErrorDetail fromJson$Enum$ErrorDetail(String value) {
  switch (value) {
    case r'UNKNOWN':
      return Enum$ErrorDetail.UNKNOWN;
    case r'FIELD_NOT_FOUND':
      return Enum$ErrorDetail.FIELD_NOT_FOUND;
    case r'INVALID_CURSOR':
      return Enum$ErrorDetail.INVALID_CURSOR;
    case r'UNIMPLEMENTED':
      return Enum$ErrorDetail.UNIMPLEMENTED;
    case r'INVALID_ARGUMENT':
      return Enum$ErrorDetail.INVALID_ARGUMENT;
    case r'DEADLINE_EXCEEDED':
      return Enum$ErrorDetail.DEADLINE_EXCEEDED;
    case r'SERVICE_ERROR':
      return Enum$ErrorDetail.SERVICE_ERROR;
    case r'THROTTLED_CPU':
      return Enum$ErrorDetail.THROTTLED_CPU;
    case r'THROTTLED_CONCURRENCY':
      return Enum$ErrorDetail.THROTTLED_CONCURRENCY;
    case r'ENHANCE_YOUR_CALM':
      return Enum$ErrorDetail.ENHANCE_YOUR_CALM;
    case r'TOO_MANY_REQUESTS':
      return Enum$ErrorDetail.TOO_MANY_REQUESTS;
    case r'TCP_FAILURE':
      return Enum$ErrorDetail.TCP_FAILURE;
    case r'MISSING_RESOURCE':
      return Enum$ErrorDetail.MISSING_RESOURCE;
    default:
      return Enum$ErrorDetail.$unknown;
  }
}

enum Enum$ErrorType {
  UNKNOWN,
  INTERNAL,
  NOT_FOUND,
  UNAUTHENTICATED,
  PERMISSION_DENIED,
  BAD_REQUEST,
  UNAVAILABLE,
  FAILED_PRECONDITION,
  $unknown;

  factory Enum$ErrorType.fromJson(String value) =>
      fromJson$Enum$ErrorType(value);

  String toJson() => toJson$Enum$ErrorType(this);
}

String toJson$Enum$ErrorType(Enum$ErrorType e) {
  switch (e) {
    case Enum$ErrorType.UNKNOWN:
      return r'UNKNOWN';
    case Enum$ErrorType.INTERNAL:
      return r'INTERNAL';
    case Enum$ErrorType.NOT_FOUND:
      return r'NOT_FOUND';
    case Enum$ErrorType.UNAUTHENTICATED:
      return r'UNAUTHENTICATED';
    case Enum$ErrorType.PERMISSION_DENIED:
      return r'PERMISSION_DENIED';
    case Enum$ErrorType.BAD_REQUEST:
      return r'BAD_REQUEST';
    case Enum$ErrorType.UNAVAILABLE:
      return r'UNAVAILABLE';
    case Enum$ErrorType.FAILED_PRECONDITION:
      return r'FAILED_PRECONDITION';
    case Enum$ErrorType.$unknown:
      return r'$unknown';
  }
}

Enum$ErrorType fromJson$Enum$ErrorType(String value) {
  switch (value) {
    case r'UNKNOWN':
      return Enum$ErrorType.UNKNOWN;
    case r'INTERNAL':
      return Enum$ErrorType.INTERNAL;
    case r'NOT_FOUND':
      return Enum$ErrorType.NOT_FOUND;
    case r'UNAUTHENTICATED':
      return Enum$ErrorType.UNAUTHENTICATED;
    case r'PERMISSION_DENIED':
      return Enum$ErrorType.PERMISSION_DENIED;
    case r'BAD_REQUEST':
      return Enum$ErrorType.BAD_REQUEST;
    case r'UNAVAILABLE':
      return Enum$ErrorType.UNAVAILABLE;
    case r'FAILED_PRECONDITION':
      return Enum$ErrorType.FAILED_PRECONDITION;
    default:
      return Enum$ErrorType.$unknown;
  }
}

enum Enum$MemberStatus {
  ACTIVE,
  SUSPENDED,
  $unknown;

  factory Enum$MemberStatus.fromJson(String value) =>
      fromJson$Enum$MemberStatus(value);

  String toJson() => toJson$Enum$MemberStatus(this);
}

String toJson$Enum$MemberStatus(Enum$MemberStatus e) {
  switch (e) {
    case Enum$MemberStatus.ACTIVE:
      return r'ACTIVE';
    case Enum$MemberStatus.SUSPENDED:
      return r'SUSPENDED';
    case Enum$MemberStatus.$unknown:
      return r'$unknown';
  }
}

Enum$MemberStatus fromJson$Enum$MemberStatus(String value) {
  switch (value) {
    case r'ACTIVE':
      return Enum$MemberStatus.ACTIVE;
    case r'SUSPENDED':
      return Enum$MemberStatus.SUSPENDED;
    default:
      return Enum$MemberStatus.$unknown;
  }
}

enum Enum$Provider {
  APPLE,
  GOOGLE,
  KAKAO,
  $unknown;

  factory Enum$Provider.fromJson(String value) => fromJson$Enum$Provider(value);

  String toJson() => toJson$Enum$Provider(this);
}

String toJson$Enum$Provider(Enum$Provider e) {
  switch (e) {
    case Enum$Provider.APPLE:
      return r'APPLE';
    case Enum$Provider.GOOGLE:
      return r'GOOGLE';
    case Enum$Provider.KAKAO:
      return r'KAKAO';
    case Enum$Provider.$unknown:
      return r'$unknown';
  }
}

Enum$Provider fromJson$Enum$Provider(String value) {
  switch (value) {
    case r'APPLE':
      return Enum$Provider.APPLE;
    case r'GOOGLE':
      return Enum$Provider.GOOGLE;
    case r'KAKAO':
      return Enum$Provider.KAKAO;
    default:
      return Enum$Provider.$unknown;
  }
}

enum Enum$TermsCode {
  SERVICE,
  PRIVACY,
  LOCATION,
  MARKETING,
  $unknown;

  factory Enum$TermsCode.fromJson(String value) =>
      fromJson$Enum$TermsCode(value);

  String toJson() => toJson$Enum$TermsCode(this);
}

String toJson$Enum$TermsCode(Enum$TermsCode e) {
  switch (e) {
    case Enum$TermsCode.SERVICE:
      return r'SERVICE';
    case Enum$TermsCode.PRIVACY:
      return r'PRIVACY';
    case Enum$TermsCode.LOCATION:
      return r'LOCATION';
    case Enum$TermsCode.MARKETING:
      return r'MARKETING';
    case Enum$TermsCode.$unknown:
      return r'$unknown';
  }
}

Enum$TermsCode fromJson$Enum$TermsCode(String value) {
  switch (value) {
    case r'SERVICE':
      return Enum$TermsCode.SERVICE;
    case r'PRIVACY':
      return Enum$TermsCode.PRIVACY;
    case r'LOCATION':
      return Enum$TermsCode.LOCATION;
    case r'MARKETING':
      return Enum$TermsCode.MARKETING;
    default:
      return Enum$TermsCode.$unknown;
  }
}

enum Enum$__TypeKind {
  SCALAR,
  OBJECT,
  INTERFACE,
  UNION,
  ENUM,
  INPUT_OBJECT,
  LIST,
  NON_NULL,
  $unknown;

  factory Enum$__TypeKind.fromJson(String value) =>
      fromJson$Enum$__TypeKind(value);

  String toJson() => toJson$Enum$__TypeKind(this);
}

String toJson$Enum$__TypeKind(Enum$__TypeKind e) {
  switch (e) {
    case Enum$__TypeKind.SCALAR:
      return r'SCALAR';
    case Enum$__TypeKind.OBJECT:
      return r'OBJECT';
    case Enum$__TypeKind.INTERFACE:
      return r'INTERFACE';
    case Enum$__TypeKind.UNION:
      return r'UNION';
    case Enum$__TypeKind.ENUM:
      return r'ENUM';
    case Enum$__TypeKind.INPUT_OBJECT:
      return r'INPUT_OBJECT';
    case Enum$__TypeKind.LIST:
      return r'LIST';
    case Enum$__TypeKind.NON_NULL:
      return r'NON_NULL';
    case Enum$__TypeKind.$unknown:
      return r'$unknown';
  }
}

Enum$__TypeKind fromJson$Enum$__TypeKind(String value) {
  switch (value) {
    case r'SCALAR':
      return Enum$__TypeKind.SCALAR;
    case r'OBJECT':
      return Enum$__TypeKind.OBJECT;
    case r'INTERFACE':
      return Enum$__TypeKind.INTERFACE;
    case r'UNION':
      return Enum$__TypeKind.UNION;
    case r'ENUM':
      return Enum$__TypeKind.ENUM;
    case r'INPUT_OBJECT':
      return Enum$__TypeKind.INPUT_OBJECT;
    case r'LIST':
      return Enum$__TypeKind.LIST;
    case r'NON_NULL':
      return Enum$__TypeKind.NON_NULL;
    default:
      return Enum$__TypeKind.$unknown;
  }
}

enum Enum$__DirectiveLocation {
  QUERY,
  MUTATION,
  SUBSCRIPTION,
  FIELD,
  FRAGMENT_DEFINITION,
  FRAGMENT_SPREAD,
  INLINE_FRAGMENT,
  VARIABLE_DEFINITION,
  SCHEMA,
  SCALAR,
  OBJECT,
  FIELD_DEFINITION,
  ARGUMENT_DEFINITION,
  INTERFACE,
  UNION,
  ENUM,
  ENUM_VALUE,
  INPUT_OBJECT,
  INPUT_FIELD_DEFINITION,
  $unknown;

  factory Enum$__DirectiveLocation.fromJson(String value) =>
      fromJson$Enum$__DirectiveLocation(value);

  String toJson() => toJson$Enum$__DirectiveLocation(this);
}

String toJson$Enum$__DirectiveLocation(Enum$__DirectiveLocation e) {
  switch (e) {
    case Enum$__DirectiveLocation.QUERY:
      return r'QUERY';
    case Enum$__DirectiveLocation.MUTATION:
      return r'MUTATION';
    case Enum$__DirectiveLocation.SUBSCRIPTION:
      return r'SUBSCRIPTION';
    case Enum$__DirectiveLocation.FIELD:
      return r'FIELD';
    case Enum$__DirectiveLocation.FRAGMENT_DEFINITION:
      return r'FRAGMENT_DEFINITION';
    case Enum$__DirectiveLocation.FRAGMENT_SPREAD:
      return r'FRAGMENT_SPREAD';
    case Enum$__DirectiveLocation.INLINE_FRAGMENT:
      return r'INLINE_FRAGMENT';
    case Enum$__DirectiveLocation.VARIABLE_DEFINITION:
      return r'VARIABLE_DEFINITION';
    case Enum$__DirectiveLocation.SCHEMA:
      return r'SCHEMA';
    case Enum$__DirectiveLocation.SCALAR:
      return r'SCALAR';
    case Enum$__DirectiveLocation.OBJECT:
      return r'OBJECT';
    case Enum$__DirectiveLocation.FIELD_DEFINITION:
      return r'FIELD_DEFINITION';
    case Enum$__DirectiveLocation.ARGUMENT_DEFINITION:
      return r'ARGUMENT_DEFINITION';
    case Enum$__DirectiveLocation.INTERFACE:
      return r'INTERFACE';
    case Enum$__DirectiveLocation.UNION:
      return r'UNION';
    case Enum$__DirectiveLocation.ENUM:
      return r'ENUM';
    case Enum$__DirectiveLocation.ENUM_VALUE:
      return r'ENUM_VALUE';
    case Enum$__DirectiveLocation.INPUT_OBJECT:
      return r'INPUT_OBJECT';
    case Enum$__DirectiveLocation.INPUT_FIELD_DEFINITION:
      return r'INPUT_FIELD_DEFINITION';
    case Enum$__DirectiveLocation.$unknown:
      return r'$unknown';
  }
}

Enum$__DirectiveLocation fromJson$Enum$__DirectiveLocation(String value) {
  switch (value) {
    case r'QUERY':
      return Enum$__DirectiveLocation.QUERY;
    case r'MUTATION':
      return Enum$__DirectiveLocation.MUTATION;
    case r'SUBSCRIPTION':
      return Enum$__DirectiveLocation.SUBSCRIPTION;
    case r'FIELD':
      return Enum$__DirectiveLocation.FIELD;
    case r'FRAGMENT_DEFINITION':
      return Enum$__DirectiveLocation.FRAGMENT_DEFINITION;
    case r'FRAGMENT_SPREAD':
      return Enum$__DirectiveLocation.FRAGMENT_SPREAD;
    case r'INLINE_FRAGMENT':
      return Enum$__DirectiveLocation.INLINE_FRAGMENT;
    case r'VARIABLE_DEFINITION':
      return Enum$__DirectiveLocation.VARIABLE_DEFINITION;
    case r'SCHEMA':
      return Enum$__DirectiveLocation.SCHEMA;
    case r'SCALAR':
      return Enum$__DirectiveLocation.SCALAR;
    case r'OBJECT':
      return Enum$__DirectiveLocation.OBJECT;
    case r'FIELD_DEFINITION':
      return Enum$__DirectiveLocation.FIELD_DEFINITION;
    case r'ARGUMENT_DEFINITION':
      return Enum$__DirectiveLocation.ARGUMENT_DEFINITION;
    case r'INTERFACE':
      return Enum$__DirectiveLocation.INTERFACE;
    case r'UNION':
      return Enum$__DirectiveLocation.UNION;
    case r'ENUM':
      return Enum$__DirectiveLocation.ENUM;
    case r'ENUM_VALUE':
      return Enum$__DirectiveLocation.ENUM_VALUE;
    case r'INPUT_OBJECT':
      return Enum$__DirectiveLocation.INPUT_OBJECT;
    case r'INPUT_FIELD_DEFINITION':
      return Enum$__DirectiveLocation.INPUT_FIELD_DEFINITION;
    default:
      return Enum$__DirectiveLocation.$unknown;
  }
}

const possibleTypesMap = <String, Set<String>>{};
