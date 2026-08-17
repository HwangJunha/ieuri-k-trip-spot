// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, unused_element
import 'auth_schema.graphql.dart';
import 'package:gql/ast.dart';

class Variables$Mutation$RegisterEmailMember {
  factory Variables$Mutation$RegisterEmailMember({
    required Input$RegisterEmailMemberInput input,
  }) => Variables$Mutation$RegisterEmailMember._({r'input': input});

  Variables$Mutation$RegisterEmailMember._(this._$data);

  factory Variables$Mutation$RegisterEmailMember.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    final l$input = data['input'];
    result$data['input'] = Input$RegisterEmailMemberInput.fromJson(
      (l$input as Map<String, dynamic>),
    );
    return Variables$Mutation$RegisterEmailMember._(result$data);
  }

  Map<String, dynamic> _$data;

  Input$RegisterEmailMemberInput get input =>
      (_$data['input'] as Input$RegisterEmailMemberInput);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$input = input;
    result$data['input'] = l$input.toJson();
    return result$data;
  }

  CopyWith$Variables$Mutation$RegisterEmailMember<
    Variables$Mutation$RegisterEmailMember
  >
  get copyWith =>
      CopyWith$Variables$Mutation$RegisterEmailMember(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Mutation$RegisterEmailMember ||
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

abstract class CopyWith$Variables$Mutation$RegisterEmailMember<TRes> {
  factory CopyWith$Variables$Mutation$RegisterEmailMember(
    Variables$Mutation$RegisterEmailMember instance,
    TRes Function(Variables$Mutation$RegisterEmailMember) then,
  ) = _CopyWithImpl$Variables$Mutation$RegisterEmailMember;

  factory CopyWith$Variables$Mutation$RegisterEmailMember.stub(TRes res) =
      _CopyWithStubImpl$Variables$Mutation$RegisterEmailMember;

  TRes call({Input$RegisterEmailMemberInput? input});
}

class _CopyWithImpl$Variables$Mutation$RegisterEmailMember<TRes>
    implements CopyWith$Variables$Mutation$RegisterEmailMember<TRes> {
  _CopyWithImpl$Variables$Mutation$RegisterEmailMember(
    this._instance,
    this._then,
  );

  final Variables$Mutation$RegisterEmailMember _instance;

  final TRes Function(Variables$Mutation$RegisterEmailMember) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? input = _undefined}) => _then(
    Variables$Mutation$RegisterEmailMember._({
      ..._instance._$data,
      if (input != _undefined && input != null)
        'input': (input as Input$RegisterEmailMemberInput),
    }),
  );
}

class _CopyWithStubImpl$Variables$Mutation$RegisterEmailMember<TRes>
    implements CopyWith$Variables$Mutation$RegisterEmailMember<TRes> {
  _CopyWithStubImpl$Variables$Mutation$RegisterEmailMember(this._res);

  TRes _res;

  call({Input$RegisterEmailMemberInput? input}) => _res;
}

class Mutation$RegisterEmailMember {
  Mutation$RegisterEmailMember({required this.registerEmailMember});

  factory Mutation$RegisterEmailMember.fromJson(Map<String, dynamic> json) {
    final l$registerEmailMember = json['registerEmailMember'];
    return Mutation$RegisterEmailMember(
      registerEmailMember:
          Mutation$RegisterEmailMember$registerEmailMember.fromJson(
            (l$registerEmailMember as Map<String, dynamic>),
          ),
    );
  }

  final Mutation$RegisterEmailMember$registerEmailMember registerEmailMember;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$registerEmailMember = registerEmailMember;
    _resultData['registerEmailMember'] = l$registerEmailMember.toJson();
    return _resultData;
  }

  @override
  int get hashCode {
    final l$registerEmailMember = registerEmailMember;
    return Object.hashAll([l$registerEmailMember]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$RegisterEmailMember ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$registerEmailMember = registerEmailMember;
    final lOther$registerEmailMember = other.registerEmailMember;
    if (l$registerEmailMember != lOther$registerEmailMember) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Mutation$RegisterEmailMember
    on Mutation$RegisterEmailMember {
  CopyWith$Mutation$RegisterEmailMember<Mutation$RegisterEmailMember>
  get copyWith => CopyWith$Mutation$RegisterEmailMember(this, (i) => i);
}

abstract class CopyWith$Mutation$RegisterEmailMember<TRes> {
  factory CopyWith$Mutation$RegisterEmailMember(
    Mutation$RegisterEmailMember instance,
    TRes Function(Mutation$RegisterEmailMember) then,
  ) = _CopyWithImpl$Mutation$RegisterEmailMember;

  factory CopyWith$Mutation$RegisterEmailMember.stub(TRes res) =
      _CopyWithStubImpl$Mutation$RegisterEmailMember;

  TRes call({
    Mutation$RegisterEmailMember$registerEmailMember? registerEmailMember,
  });
  CopyWith$Mutation$RegisterEmailMember$registerEmailMember<TRes>
  get registerEmailMember;
}

class _CopyWithImpl$Mutation$RegisterEmailMember<TRes>
    implements CopyWith$Mutation$RegisterEmailMember<TRes> {
  _CopyWithImpl$Mutation$RegisterEmailMember(this._instance, this._then);

  final Mutation$RegisterEmailMember _instance;

  final TRes Function(Mutation$RegisterEmailMember) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? registerEmailMember = _undefined}) => _then(
    Mutation$RegisterEmailMember(
      registerEmailMember:
          registerEmailMember == _undefined || registerEmailMember == null
          ? _instance.registerEmailMember
          : (registerEmailMember
                as Mutation$RegisterEmailMember$registerEmailMember),
    ),
  );

  CopyWith$Mutation$RegisterEmailMember$registerEmailMember<TRes>
  get registerEmailMember {
    final local$registerEmailMember = _instance.registerEmailMember;
    return CopyWith$Mutation$RegisterEmailMember$registerEmailMember(
      local$registerEmailMember,
      (e) => call(registerEmailMember: e),
    );
  }
}

class _CopyWithStubImpl$Mutation$RegisterEmailMember<TRes>
    implements CopyWith$Mutation$RegisterEmailMember<TRes> {
  _CopyWithStubImpl$Mutation$RegisterEmailMember(this._res);

  TRes _res;

  call({
    Mutation$RegisterEmailMember$registerEmailMember? registerEmailMember,
  }) => _res;

  CopyWith$Mutation$RegisterEmailMember$registerEmailMember<TRes>
  get registerEmailMember =>
      CopyWith$Mutation$RegisterEmailMember$registerEmailMember.stub(_res);
}

const documentNodeMutationRegisterEmailMember = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'RegisterEmailMember'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'input')),
          type: NamedTypeNode(
            name: NameNode(value: 'RegisterEmailMemberInput'),
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
            name: NameNode(value: 'registerEmailMember'),
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
                        name: NameNode(value: 'codeValue'),
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
                  name: NameNode(value: 'verificationId'),
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

class Mutation$RegisterEmailMember$registerEmailMember {
  Mutation$RegisterEmailMember$registerEmailMember({
    required this.success,
    required this.userErrors,
    this.verificationId,
  });

  factory Mutation$RegisterEmailMember$registerEmailMember.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$success = json['success'];
    final l$userErrors = json['userErrors'];
    final l$verificationId = json['verificationId'];
    return Mutation$RegisterEmailMember$registerEmailMember(
      success: (l$success as bool),
      userErrors: (l$userErrors as List<dynamic>)
          .map(
            (e) =>
                Mutation$RegisterEmailMember$registerEmailMember$userErrors.fromJson(
                  (e as Map<String, dynamic>),
                ),
          )
          .toList(),
      verificationId: (l$verificationId as String?),
    );
  }

  final bool success;

  final List<Mutation$RegisterEmailMember$registerEmailMember$userErrors>
  userErrors;

  final String? verificationId;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$success = success;
    _resultData['success'] = l$success;
    final l$userErrors = userErrors;
    _resultData['userErrors'] = l$userErrors.map((e) => e.toJson()).toList();
    final l$verificationId = verificationId;
    _resultData['verificationId'] = l$verificationId;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$success = success;
    final l$userErrors = userErrors;
    final l$verificationId = verificationId;
    return Object.hashAll([
      l$success,
      Object.hashAll(l$userErrors.map((v) => v)),
      l$verificationId,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$RegisterEmailMember$registerEmailMember ||
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
    final l$verificationId = verificationId;
    final lOther$verificationId = other.verificationId;
    if (l$verificationId != lOther$verificationId) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Mutation$RegisterEmailMember$registerEmailMember
    on Mutation$RegisterEmailMember$registerEmailMember {
  CopyWith$Mutation$RegisterEmailMember$registerEmailMember<
    Mutation$RegisterEmailMember$registerEmailMember
  >
  get copyWith =>
      CopyWith$Mutation$RegisterEmailMember$registerEmailMember(this, (i) => i);
}

abstract class CopyWith$Mutation$RegisterEmailMember$registerEmailMember<TRes> {
  factory CopyWith$Mutation$RegisterEmailMember$registerEmailMember(
    Mutation$RegisterEmailMember$registerEmailMember instance,
    TRes Function(Mutation$RegisterEmailMember$registerEmailMember) then,
  ) = _CopyWithImpl$Mutation$RegisterEmailMember$registerEmailMember;

  factory CopyWith$Mutation$RegisterEmailMember$registerEmailMember.stub(
    TRes res,
  ) = _CopyWithStubImpl$Mutation$RegisterEmailMember$registerEmailMember;

  TRes call({
    bool? success,
    List<Mutation$RegisterEmailMember$registerEmailMember$userErrors>?
    userErrors,
    String? verificationId,
  });
  TRes userErrors(
    Iterable<Mutation$RegisterEmailMember$registerEmailMember$userErrors>
    Function(
      Iterable<
        CopyWith$Mutation$RegisterEmailMember$registerEmailMember$userErrors<
          Mutation$RegisterEmailMember$registerEmailMember$userErrors
        >
      >,
    )
    _fn,
  );
}

class _CopyWithImpl$Mutation$RegisterEmailMember$registerEmailMember<TRes>
    implements CopyWith$Mutation$RegisterEmailMember$registerEmailMember<TRes> {
  _CopyWithImpl$Mutation$RegisterEmailMember$registerEmailMember(
    this._instance,
    this._then,
  );

  final Mutation$RegisterEmailMember$registerEmailMember _instance;

  final TRes Function(Mutation$RegisterEmailMember$registerEmailMember) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? success = _undefined,
    Object? userErrors = _undefined,
    Object? verificationId = _undefined,
  }) => _then(
    Mutation$RegisterEmailMember$registerEmailMember(
      success: success == _undefined || success == null
          ? _instance.success
          : (success as bool),
      userErrors: userErrors == _undefined || userErrors == null
          ? _instance.userErrors
          : (userErrors
                as List<
                  Mutation$RegisterEmailMember$registerEmailMember$userErrors
                >),
      verificationId: verificationId == _undefined
          ? _instance.verificationId
          : (verificationId as String?),
    ),
  );

  TRes userErrors(
    Iterable<Mutation$RegisterEmailMember$registerEmailMember$userErrors>
    Function(
      Iterable<
        CopyWith$Mutation$RegisterEmailMember$registerEmailMember$userErrors<
          Mutation$RegisterEmailMember$registerEmailMember$userErrors
        >
      >,
    )
    _fn,
  ) => call(
    userErrors: _fn(
      _instance.userErrors.map(
        (e) =>
            CopyWith$Mutation$RegisterEmailMember$registerEmailMember$userErrors(
              e,
              (i) => i,
            ),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl$Mutation$RegisterEmailMember$registerEmailMember<TRes>
    implements CopyWith$Mutation$RegisterEmailMember$registerEmailMember<TRes> {
  _CopyWithStubImpl$Mutation$RegisterEmailMember$registerEmailMember(this._res);

  TRes _res;

  call({
    bool? success,
    List<Mutation$RegisterEmailMember$registerEmailMember$userErrors>?
    userErrors,
    String? verificationId,
  }) => _res;

  userErrors(_fn) => _res;
}

class Mutation$RegisterEmailMember$registerEmailMember$userErrors {
  Mutation$RegisterEmailMember$registerEmailMember$userErrors({
    required this.code,
    this.codeValue,
    required this.message,
    this.field,
  });

  factory Mutation$RegisterEmailMember$registerEmailMember$userErrors.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$code = json['code'];
    final l$codeValue = json['codeValue'];
    final l$message = json['message'];
    final l$field = json['field'];
    return Mutation$RegisterEmailMember$registerEmailMember$userErrors(
      code: (l$code as String),
      codeValue: l$codeValue == null
          ? null
          : fromJson$Enum$ErrorCode((l$codeValue as String)),
      message: (l$message as String),
      field: (l$field as String?),
    );
  }

  final String code;

  final Enum$ErrorCode? codeValue;

  final String message;

  final String? field;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$code = code;
    _resultData['code'] = l$code;
    final l$codeValue = codeValue;
    _resultData['codeValue'] = l$codeValue == null
        ? null
        : toJson$Enum$ErrorCode(l$codeValue);
    final l$message = message;
    _resultData['message'] = l$message;
    final l$field = field;
    _resultData['field'] = l$field;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$code = code;
    final l$codeValue = codeValue;
    final l$message = message;
    final l$field = field;
    return Object.hashAll([l$code, l$codeValue, l$message, l$field]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$RegisterEmailMember$registerEmailMember$userErrors ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$code = code;
    final lOther$code = other.code;
    if (l$code != lOther$code) {
      return false;
    }
    final l$codeValue = codeValue;
    final lOther$codeValue = other.codeValue;
    if (l$codeValue != lOther$codeValue) {
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

extension UtilityExtension$Mutation$RegisterEmailMember$registerEmailMember$userErrors
    on Mutation$RegisterEmailMember$registerEmailMember$userErrors {
  CopyWith$Mutation$RegisterEmailMember$registerEmailMember$userErrors<
    Mutation$RegisterEmailMember$registerEmailMember$userErrors
  >
  get copyWith =>
      CopyWith$Mutation$RegisterEmailMember$registerEmailMember$userErrors(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Mutation$RegisterEmailMember$registerEmailMember$userErrors<
  TRes
> {
  factory CopyWith$Mutation$RegisterEmailMember$registerEmailMember$userErrors(
    Mutation$RegisterEmailMember$registerEmailMember$userErrors instance,
    TRes Function(Mutation$RegisterEmailMember$registerEmailMember$userErrors)
    then,
  ) = _CopyWithImpl$Mutation$RegisterEmailMember$registerEmailMember$userErrors;

  factory CopyWith$Mutation$RegisterEmailMember$registerEmailMember$userErrors.stub(
    TRes res,
  ) = _CopyWithStubImpl$Mutation$RegisterEmailMember$registerEmailMember$userErrors;

  TRes call({
    String? code,
    Enum$ErrorCode? codeValue,
    String? message,
    String? field,
  });
}

class _CopyWithImpl$Mutation$RegisterEmailMember$registerEmailMember$userErrors<
  TRes
>
    implements
        CopyWith$Mutation$RegisterEmailMember$registerEmailMember$userErrors<
          TRes
        > {
  _CopyWithImpl$Mutation$RegisterEmailMember$registerEmailMember$userErrors(
    this._instance,
    this._then,
  );

  final Mutation$RegisterEmailMember$registerEmailMember$userErrors _instance;

  final TRes Function(
    Mutation$RegisterEmailMember$registerEmailMember$userErrors,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? code = _undefined,
    Object? codeValue = _undefined,
    Object? message = _undefined,
    Object? field = _undefined,
  }) => _then(
    Mutation$RegisterEmailMember$registerEmailMember$userErrors(
      code: code == _undefined || code == null
          ? _instance.code
          : (code as String),
      codeValue: codeValue == _undefined
          ? _instance.codeValue
          : (codeValue as Enum$ErrorCode?),
      message: message == _undefined || message == null
          ? _instance.message
          : (message as String),
      field: field == _undefined ? _instance.field : (field as String?),
    ),
  );
}

class _CopyWithStubImpl$Mutation$RegisterEmailMember$registerEmailMember$userErrors<
  TRes
>
    implements
        CopyWith$Mutation$RegisterEmailMember$registerEmailMember$userErrors<
          TRes
        > {
  _CopyWithStubImpl$Mutation$RegisterEmailMember$registerEmailMember$userErrors(
    this._res,
  );

  TRes _res;

  call({
    String? code,
    Enum$ErrorCode? codeValue,
    String? message,
    String? field,
  }) => _res;
}

class Variables$Mutation$VerifyEmail {
  factory Variables$Mutation$VerifyEmail({
    required Input$VerifyEmailInput input,
  }) => Variables$Mutation$VerifyEmail._({r'input': input});

  Variables$Mutation$VerifyEmail._(this._$data);

  factory Variables$Mutation$VerifyEmail.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$input = data['input'];
    result$data['input'] = Input$VerifyEmailInput.fromJson(
      (l$input as Map<String, dynamic>),
    );
    return Variables$Mutation$VerifyEmail._(result$data);
  }

  Map<String, dynamic> _$data;

  Input$VerifyEmailInput get input =>
      (_$data['input'] as Input$VerifyEmailInput);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$input = input;
    result$data['input'] = l$input.toJson();
    return result$data;
  }

  CopyWith$Variables$Mutation$VerifyEmail<Variables$Mutation$VerifyEmail>
  get copyWith => CopyWith$Variables$Mutation$VerifyEmail(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Mutation$VerifyEmail ||
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

abstract class CopyWith$Variables$Mutation$VerifyEmail<TRes> {
  factory CopyWith$Variables$Mutation$VerifyEmail(
    Variables$Mutation$VerifyEmail instance,
    TRes Function(Variables$Mutation$VerifyEmail) then,
  ) = _CopyWithImpl$Variables$Mutation$VerifyEmail;

  factory CopyWith$Variables$Mutation$VerifyEmail.stub(TRes res) =
      _CopyWithStubImpl$Variables$Mutation$VerifyEmail;

  TRes call({Input$VerifyEmailInput? input});
}

class _CopyWithImpl$Variables$Mutation$VerifyEmail<TRes>
    implements CopyWith$Variables$Mutation$VerifyEmail<TRes> {
  _CopyWithImpl$Variables$Mutation$VerifyEmail(this._instance, this._then);

  final Variables$Mutation$VerifyEmail _instance;

  final TRes Function(Variables$Mutation$VerifyEmail) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? input = _undefined}) => _then(
    Variables$Mutation$VerifyEmail._({
      ..._instance._$data,
      if (input != _undefined && input != null)
        'input': (input as Input$VerifyEmailInput),
    }),
  );
}

class _CopyWithStubImpl$Variables$Mutation$VerifyEmail<TRes>
    implements CopyWith$Variables$Mutation$VerifyEmail<TRes> {
  _CopyWithStubImpl$Variables$Mutation$VerifyEmail(this._res);

  TRes _res;

  call({Input$VerifyEmailInput? input}) => _res;
}

class Mutation$VerifyEmail {
  Mutation$VerifyEmail({required this.verifyEmail});

  factory Mutation$VerifyEmail.fromJson(Map<String, dynamic> json) {
    final l$verifyEmail = json['verifyEmail'];
    return Mutation$VerifyEmail(
      verifyEmail: Mutation$VerifyEmail$verifyEmail.fromJson(
        (l$verifyEmail as Map<String, dynamic>),
      ),
    );
  }

  final Mutation$VerifyEmail$verifyEmail verifyEmail;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$verifyEmail = verifyEmail;
    _resultData['verifyEmail'] = l$verifyEmail.toJson();
    return _resultData;
  }

  @override
  int get hashCode {
    final l$verifyEmail = verifyEmail;
    return Object.hashAll([l$verifyEmail]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$VerifyEmail || runtimeType != other.runtimeType) {
      return false;
    }
    final l$verifyEmail = verifyEmail;
    final lOther$verifyEmail = other.verifyEmail;
    if (l$verifyEmail != lOther$verifyEmail) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Mutation$VerifyEmail on Mutation$VerifyEmail {
  CopyWith$Mutation$VerifyEmail<Mutation$VerifyEmail> get copyWith =>
      CopyWith$Mutation$VerifyEmail(this, (i) => i);
}

abstract class CopyWith$Mutation$VerifyEmail<TRes> {
  factory CopyWith$Mutation$VerifyEmail(
    Mutation$VerifyEmail instance,
    TRes Function(Mutation$VerifyEmail) then,
  ) = _CopyWithImpl$Mutation$VerifyEmail;

  factory CopyWith$Mutation$VerifyEmail.stub(TRes res) =
      _CopyWithStubImpl$Mutation$VerifyEmail;

  TRes call({Mutation$VerifyEmail$verifyEmail? verifyEmail});
  CopyWith$Mutation$VerifyEmail$verifyEmail<TRes> get verifyEmail;
}

class _CopyWithImpl$Mutation$VerifyEmail<TRes>
    implements CopyWith$Mutation$VerifyEmail<TRes> {
  _CopyWithImpl$Mutation$VerifyEmail(this._instance, this._then);

  final Mutation$VerifyEmail _instance;

  final TRes Function(Mutation$VerifyEmail) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? verifyEmail = _undefined}) => _then(
    Mutation$VerifyEmail(
      verifyEmail: verifyEmail == _undefined || verifyEmail == null
          ? _instance.verifyEmail
          : (verifyEmail as Mutation$VerifyEmail$verifyEmail),
    ),
  );

  CopyWith$Mutation$VerifyEmail$verifyEmail<TRes> get verifyEmail {
    final local$verifyEmail = _instance.verifyEmail;
    return CopyWith$Mutation$VerifyEmail$verifyEmail(
      local$verifyEmail,
      (e) => call(verifyEmail: e),
    );
  }
}

class _CopyWithStubImpl$Mutation$VerifyEmail<TRes>
    implements CopyWith$Mutation$VerifyEmail<TRes> {
  _CopyWithStubImpl$Mutation$VerifyEmail(this._res);

  TRes _res;

  call({Mutation$VerifyEmail$verifyEmail? verifyEmail}) => _res;

  CopyWith$Mutation$VerifyEmail$verifyEmail<TRes> get verifyEmail =>
      CopyWith$Mutation$VerifyEmail$verifyEmail.stub(_res);
}

const documentNodeMutationVerifyEmail = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'VerifyEmail'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'input')),
          type: NamedTypeNode(
            name: NameNode(value: 'VerifyEmailInput'),
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
            name: NameNode(value: 'verifyEmail'),
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
                        name: NameNode(value: 'codeValue'),
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
                  name: NameNode(value: 'verified'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: 'failureReason'),
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

class Mutation$VerifyEmail$verifyEmail {
  Mutation$VerifyEmail$verifyEmail({
    required this.success,
    required this.userErrors,
    this.verified,
    this.failureReason,
  });

  factory Mutation$VerifyEmail$verifyEmail.fromJson(Map<String, dynamic> json) {
    final l$success = json['success'];
    final l$userErrors = json['userErrors'];
    final l$verified = json['verified'];
    final l$failureReason = json['failureReason'];
    return Mutation$VerifyEmail$verifyEmail(
      success: (l$success as bool),
      userErrors: (l$userErrors as List<dynamic>)
          .map(
            (e) => Mutation$VerifyEmail$verifyEmail$userErrors.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      verified: (l$verified as bool?),
      failureReason: (l$failureReason as String?),
    );
  }

  final bool success;

  final List<Mutation$VerifyEmail$verifyEmail$userErrors> userErrors;

  final bool? verified;

  final String? failureReason;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$success = success;
    _resultData['success'] = l$success;
    final l$userErrors = userErrors;
    _resultData['userErrors'] = l$userErrors.map((e) => e.toJson()).toList();
    final l$verified = verified;
    _resultData['verified'] = l$verified;
    final l$failureReason = failureReason;
    _resultData['failureReason'] = l$failureReason;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$success = success;
    final l$userErrors = userErrors;
    final l$verified = verified;
    final l$failureReason = failureReason;
    return Object.hashAll([
      l$success,
      Object.hashAll(l$userErrors.map((v) => v)),
      l$verified,
      l$failureReason,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$VerifyEmail$verifyEmail ||
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
    final l$verified = verified;
    final lOther$verified = other.verified;
    if (l$verified != lOther$verified) {
      return false;
    }
    final l$failureReason = failureReason;
    final lOther$failureReason = other.failureReason;
    if (l$failureReason != lOther$failureReason) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Mutation$VerifyEmail$verifyEmail
    on Mutation$VerifyEmail$verifyEmail {
  CopyWith$Mutation$VerifyEmail$verifyEmail<Mutation$VerifyEmail$verifyEmail>
  get copyWith => CopyWith$Mutation$VerifyEmail$verifyEmail(this, (i) => i);
}

abstract class CopyWith$Mutation$VerifyEmail$verifyEmail<TRes> {
  factory CopyWith$Mutation$VerifyEmail$verifyEmail(
    Mutation$VerifyEmail$verifyEmail instance,
    TRes Function(Mutation$VerifyEmail$verifyEmail) then,
  ) = _CopyWithImpl$Mutation$VerifyEmail$verifyEmail;

  factory CopyWith$Mutation$VerifyEmail$verifyEmail.stub(TRes res) =
      _CopyWithStubImpl$Mutation$VerifyEmail$verifyEmail;

  TRes call({
    bool? success,
    List<Mutation$VerifyEmail$verifyEmail$userErrors>? userErrors,
    bool? verified,
    String? failureReason,
  });
  TRes userErrors(
    Iterable<Mutation$VerifyEmail$verifyEmail$userErrors> Function(
      Iterable<
        CopyWith$Mutation$VerifyEmail$verifyEmail$userErrors<
          Mutation$VerifyEmail$verifyEmail$userErrors
        >
      >,
    )
    _fn,
  );
}

class _CopyWithImpl$Mutation$VerifyEmail$verifyEmail<TRes>
    implements CopyWith$Mutation$VerifyEmail$verifyEmail<TRes> {
  _CopyWithImpl$Mutation$VerifyEmail$verifyEmail(this._instance, this._then);

  final Mutation$VerifyEmail$verifyEmail _instance;

  final TRes Function(Mutation$VerifyEmail$verifyEmail) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? success = _undefined,
    Object? userErrors = _undefined,
    Object? verified = _undefined,
    Object? failureReason = _undefined,
  }) => _then(
    Mutation$VerifyEmail$verifyEmail(
      success: success == _undefined || success == null
          ? _instance.success
          : (success as bool),
      userErrors: userErrors == _undefined || userErrors == null
          ? _instance.userErrors
          : (userErrors as List<Mutation$VerifyEmail$verifyEmail$userErrors>),
      verified: verified == _undefined
          ? _instance.verified
          : (verified as bool?),
      failureReason: failureReason == _undefined
          ? _instance.failureReason
          : (failureReason as String?),
    ),
  );

  TRes userErrors(
    Iterable<Mutation$VerifyEmail$verifyEmail$userErrors> Function(
      Iterable<
        CopyWith$Mutation$VerifyEmail$verifyEmail$userErrors<
          Mutation$VerifyEmail$verifyEmail$userErrors
        >
      >,
    )
    _fn,
  ) => call(
    userErrors: _fn(
      _instance.userErrors.map(
        (e) =>
            CopyWith$Mutation$VerifyEmail$verifyEmail$userErrors(e, (i) => i),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl$Mutation$VerifyEmail$verifyEmail<TRes>
    implements CopyWith$Mutation$VerifyEmail$verifyEmail<TRes> {
  _CopyWithStubImpl$Mutation$VerifyEmail$verifyEmail(this._res);

  TRes _res;

  call({
    bool? success,
    List<Mutation$VerifyEmail$verifyEmail$userErrors>? userErrors,
    bool? verified,
    String? failureReason,
  }) => _res;

  userErrors(_fn) => _res;
}

class Mutation$VerifyEmail$verifyEmail$userErrors {
  Mutation$VerifyEmail$verifyEmail$userErrors({
    required this.code,
    this.codeValue,
    required this.message,
    this.field,
  });

  factory Mutation$VerifyEmail$verifyEmail$userErrors.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$code = json['code'];
    final l$codeValue = json['codeValue'];
    final l$message = json['message'];
    final l$field = json['field'];
    return Mutation$VerifyEmail$verifyEmail$userErrors(
      code: (l$code as String),
      codeValue: l$codeValue == null
          ? null
          : fromJson$Enum$ErrorCode((l$codeValue as String)),
      message: (l$message as String),
      field: (l$field as String?),
    );
  }

  final String code;

  final Enum$ErrorCode? codeValue;

  final String message;

  final String? field;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$code = code;
    _resultData['code'] = l$code;
    final l$codeValue = codeValue;
    _resultData['codeValue'] = l$codeValue == null
        ? null
        : toJson$Enum$ErrorCode(l$codeValue);
    final l$message = message;
    _resultData['message'] = l$message;
    final l$field = field;
    _resultData['field'] = l$field;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$code = code;
    final l$codeValue = codeValue;
    final l$message = message;
    final l$field = field;
    return Object.hashAll([l$code, l$codeValue, l$message, l$field]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$VerifyEmail$verifyEmail$userErrors ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$code = code;
    final lOther$code = other.code;
    if (l$code != lOther$code) {
      return false;
    }
    final l$codeValue = codeValue;
    final lOther$codeValue = other.codeValue;
    if (l$codeValue != lOther$codeValue) {
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

extension UtilityExtension$Mutation$VerifyEmail$verifyEmail$userErrors
    on Mutation$VerifyEmail$verifyEmail$userErrors {
  CopyWith$Mutation$VerifyEmail$verifyEmail$userErrors<
    Mutation$VerifyEmail$verifyEmail$userErrors
  >
  get copyWith =>
      CopyWith$Mutation$VerifyEmail$verifyEmail$userErrors(this, (i) => i);
}

abstract class CopyWith$Mutation$VerifyEmail$verifyEmail$userErrors<TRes> {
  factory CopyWith$Mutation$VerifyEmail$verifyEmail$userErrors(
    Mutation$VerifyEmail$verifyEmail$userErrors instance,
    TRes Function(Mutation$VerifyEmail$verifyEmail$userErrors) then,
  ) = _CopyWithImpl$Mutation$VerifyEmail$verifyEmail$userErrors;

  factory CopyWith$Mutation$VerifyEmail$verifyEmail$userErrors.stub(TRes res) =
      _CopyWithStubImpl$Mutation$VerifyEmail$verifyEmail$userErrors;

  TRes call({
    String? code,
    Enum$ErrorCode? codeValue,
    String? message,
    String? field,
  });
}

class _CopyWithImpl$Mutation$VerifyEmail$verifyEmail$userErrors<TRes>
    implements CopyWith$Mutation$VerifyEmail$verifyEmail$userErrors<TRes> {
  _CopyWithImpl$Mutation$VerifyEmail$verifyEmail$userErrors(
    this._instance,
    this._then,
  );

  final Mutation$VerifyEmail$verifyEmail$userErrors _instance;

  final TRes Function(Mutation$VerifyEmail$verifyEmail$userErrors) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? code = _undefined,
    Object? codeValue = _undefined,
    Object? message = _undefined,
    Object? field = _undefined,
  }) => _then(
    Mutation$VerifyEmail$verifyEmail$userErrors(
      code: code == _undefined || code == null
          ? _instance.code
          : (code as String),
      codeValue: codeValue == _undefined
          ? _instance.codeValue
          : (codeValue as Enum$ErrorCode?),
      message: message == _undefined || message == null
          ? _instance.message
          : (message as String),
      field: field == _undefined ? _instance.field : (field as String?),
    ),
  );
}

class _CopyWithStubImpl$Mutation$VerifyEmail$verifyEmail$userErrors<TRes>
    implements CopyWith$Mutation$VerifyEmail$verifyEmail$userErrors<TRes> {
  _CopyWithStubImpl$Mutation$VerifyEmail$verifyEmail$userErrors(this._res);

  TRes _res;

  call({
    String? code,
    Enum$ErrorCode? codeValue,
    String? message,
    String? field,
  }) => _res;
}

class Variables$Mutation$ResendVerification {
  factory Variables$Mutation$ResendVerification({
    required Input$ResendVerificationInput input,
  }) => Variables$Mutation$ResendVerification._({r'input': input});

  Variables$Mutation$ResendVerification._(this._$data);

  factory Variables$Mutation$ResendVerification.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    final l$input = data['input'];
    result$data['input'] = Input$ResendVerificationInput.fromJson(
      (l$input as Map<String, dynamic>),
    );
    return Variables$Mutation$ResendVerification._(result$data);
  }

  Map<String, dynamic> _$data;

  Input$ResendVerificationInput get input =>
      (_$data['input'] as Input$ResendVerificationInput);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$input = input;
    result$data['input'] = l$input.toJson();
    return result$data;
  }

  CopyWith$Variables$Mutation$ResendVerification<
    Variables$Mutation$ResendVerification
  >
  get copyWith =>
      CopyWith$Variables$Mutation$ResendVerification(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Mutation$ResendVerification ||
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

abstract class CopyWith$Variables$Mutation$ResendVerification<TRes> {
  factory CopyWith$Variables$Mutation$ResendVerification(
    Variables$Mutation$ResendVerification instance,
    TRes Function(Variables$Mutation$ResendVerification) then,
  ) = _CopyWithImpl$Variables$Mutation$ResendVerification;

  factory CopyWith$Variables$Mutation$ResendVerification.stub(TRes res) =
      _CopyWithStubImpl$Variables$Mutation$ResendVerification;

  TRes call({Input$ResendVerificationInput? input});
}

class _CopyWithImpl$Variables$Mutation$ResendVerification<TRes>
    implements CopyWith$Variables$Mutation$ResendVerification<TRes> {
  _CopyWithImpl$Variables$Mutation$ResendVerification(
    this._instance,
    this._then,
  );

  final Variables$Mutation$ResendVerification _instance;

  final TRes Function(Variables$Mutation$ResendVerification) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? input = _undefined}) => _then(
    Variables$Mutation$ResendVerification._({
      ..._instance._$data,
      if (input != _undefined && input != null)
        'input': (input as Input$ResendVerificationInput),
    }),
  );
}

class _CopyWithStubImpl$Variables$Mutation$ResendVerification<TRes>
    implements CopyWith$Variables$Mutation$ResendVerification<TRes> {
  _CopyWithStubImpl$Variables$Mutation$ResendVerification(this._res);

  TRes _res;

  call({Input$ResendVerificationInput? input}) => _res;
}

class Mutation$ResendVerification {
  Mutation$ResendVerification({required this.resendVerification});

  factory Mutation$ResendVerification.fromJson(Map<String, dynamic> json) {
    final l$resendVerification = json['resendVerification'];
    return Mutation$ResendVerification(
      resendVerification:
          Mutation$ResendVerification$resendVerification.fromJson(
            (l$resendVerification as Map<String, dynamic>),
          ),
    );
  }

  final Mutation$ResendVerification$resendVerification resendVerification;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$resendVerification = resendVerification;
    _resultData['resendVerification'] = l$resendVerification.toJson();
    return _resultData;
  }

  @override
  int get hashCode {
    final l$resendVerification = resendVerification;
    return Object.hashAll([l$resendVerification]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$ResendVerification ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$resendVerification = resendVerification;
    final lOther$resendVerification = other.resendVerification;
    if (l$resendVerification != lOther$resendVerification) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Mutation$ResendVerification
    on Mutation$ResendVerification {
  CopyWith$Mutation$ResendVerification<Mutation$ResendVerification>
  get copyWith => CopyWith$Mutation$ResendVerification(this, (i) => i);
}

abstract class CopyWith$Mutation$ResendVerification<TRes> {
  factory CopyWith$Mutation$ResendVerification(
    Mutation$ResendVerification instance,
    TRes Function(Mutation$ResendVerification) then,
  ) = _CopyWithImpl$Mutation$ResendVerification;

  factory CopyWith$Mutation$ResendVerification.stub(TRes res) =
      _CopyWithStubImpl$Mutation$ResendVerification;

  TRes call({
    Mutation$ResendVerification$resendVerification? resendVerification,
  });
  CopyWith$Mutation$ResendVerification$resendVerification<TRes>
  get resendVerification;
}

class _CopyWithImpl$Mutation$ResendVerification<TRes>
    implements CopyWith$Mutation$ResendVerification<TRes> {
  _CopyWithImpl$Mutation$ResendVerification(this._instance, this._then);

  final Mutation$ResendVerification _instance;

  final TRes Function(Mutation$ResendVerification) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? resendVerification = _undefined}) => _then(
    Mutation$ResendVerification(
      resendVerification:
          resendVerification == _undefined || resendVerification == null
          ? _instance.resendVerification
          : (resendVerification
                as Mutation$ResendVerification$resendVerification),
    ),
  );

  CopyWith$Mutation$ResendVerification$resendVerification<TRes>
  get resendVerification {
    final local$resendVerification = _instance.resendVerification;
    return CopyWith$Mutation$ResendVerification$resendVerification(
      local$resendVerification,
      (e) => call(resendVerification: e),
    );
  }
}

class _CopyWithStubImpl$Mutation$ResendVerification<TRes>
    implements CopyWith$Mutation$ResendVerification<TRes> {
  _CopyWithStubImpl$Mutation$ResendVerification(this._res);

  TRes _res;

  call({Mutation$ResendVerification$resendVerification? resendVerification}) =>
      _res;

  CopyWith$Mutation$ResendVerification$resendVerification<TRes>
  get resendVerification =>
      CopyWith$Mutation$ResendVerification$resendVerification.stub(_res);
}

const documentNodeMutationResendVerification = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'ResendVerification'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'input')),
          type: NamedTypeNode(
            name: NameNode(value: 'ResendVerificationInput'),
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
            name: NameNode(value: 'resendVerification'),
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
                        name: NameNode(value: 'codeValue'),
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
                  name: NameNode(value: 'verificationId'),
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

class Mutation$ResendVerification$resendVerification {
  Mutation$ResendVerification$resendVerification({
    required this.success,
    required this.userErrors,
    this.verificationId,
    this.expiresAt,
  });

  factory Mutation$ResendVerification$resendVerification.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$success = json['success'];
    final l$userErrors = json['userErrors'];
    final l$verificationId = json['verificationId'];
    final l$expiresAt = json['expiresAt'];
    return Mutation$ResendVerification$resendVerification(
      success: (l$success as bool),
      userErrors: (l$userErrors as List<dynamic>)
          .map(
            (e) =>
                Mutation$ResendVerification$resendVerification$userErrors.fromJson(
                  (e as Map<String, dynamic>),
                ),
          )
          .toList(),
      verificationId: (l$verificationId as String?),
      expiresAt: (l$expiresAt as String?),
    );
  }

  final bool success;

  final List<Mutation$ResendVerification$resendVerification$userErrors>
  userErrors;

  final String? verificationId;

  final String? expiresAt;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$success = success;
    _resultData['success'] = l$success;
    final l$userErrors = userErrors;
    _resultData['userErrors'] = l$userErrors.map((e) => e.toJson()).toList();
    final l$verificationId = verificationId;
    _resultData['verificationId'] = l$verificationId;
    final l$expiresAt = expiresAt;
    _resultData['expiresAt'] = l$expiresAt;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$success = success;
    final l$userErrors = userErrors;
    final l$verificationId = verificationId;
    final l$expiresAt = expiresAt;
    return Object.hashAll([
      l$success,
      Object.hashAll(l$userErrors.map((v) => v)),
      l$verificationId,
      l$expiresAt,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$ResendVerification$resendVerification ||
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
    final l$verificationId = verificationId;
    final lOther$verificationId = other.verificationId;
    if (l$verificationId != lOther$verificationId) {
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

extension UtilityExtension$Mutation$ResendVerification$resendVerification
    on Mutation$ResendVerification$resendVerification {
  CopyWith$Mutation$ResendVerification$resendVerification<
    Mutation$ResendVerification$resendVerification
  >
  get copyWith =>
      CopyWith$Mutation$ResendVerification$resendVerification(this, (i) => i);
}

abstract class CopyWith$Mutation$ResendVerification$resendVerification<TRes> {
  factory CopyWith$Mutation$ResendVerification$resendVerification(
    Mutation$ResendVerification$resendVerification instance,
    TRes Function(Mutation$ResendVerification$resendVerification) then,
  ) = _CopyWithImpl$Mutation$ResendVerification$resendVerification;

  factory CopyWith$Mutation$ResendVerification$resendVerification.stub(
    TRes res,
  ) = _CopyWithStubImpl$Mutation$ResendVerification$resendVerification;

  TRes call({
    bool? success,
    List<Mutation$ResendVerification$resendVerification$userErrors>? userErrors,
    String? verificationId,
    String? expiresAt,
  });
  TRes userErrors(
    Iterable<Mutation$ResendVerification$resendVerification$userErrors>
    Function(
      Iterable<
        CopyWith$Mutation$ResendVerification$resendVerification$userErrors<
          Mutation$ResendVerification$resendVerification$userErrors
        >
      >,
    )
    _fn,
  );
}

class _CopyWithImpl$Mutation$ResendVerification$resendVerification<TRes>
    implements CopyWith$Mutation$ResendVerification$resendVerification<TRes> {
  _CopyWithImpl$Mutation$ResendVerification$resendVerification(
    this._instance,
    this._then,
  );

  final Mutation$ResendVerification$resendVerification _instance;

  final TRes Function(Mutation$ResendVerification$resendVerification) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? success = _undefined,
    Object? userErrors = _undefined,
    Object? verificationId = _undefined,
    Object? expiresAt = _undefined,
  }) => _then(
    Mutation$ResendVerification$resendVerification(
      success: success == _undefined || success == null
          ? _instance.success
          : (success as bool),
      userErrors: userErrors == _undefined || userErrors == null
          ? _instance.userErrors
          : (userErrors
                as List<
                  Mutation$ResendVerification$resendVerification$userErrors
                >),
      verificationId: verificationId == _undefined
          ? _instance.verificationId
          : (verificationId as String?),
      expiresAt: expiresAt == _undefined
          ? _instance.expiresAt
          : (expiresAt as String?),
    ),
  );

  TRes userErrors(
    Iterable<Mutation$ResendVerification$resendVerification$userErrors>
    Function(
      Iterable<
        CopyWith$Mutation$ResendVerification$resendVerification$userErrors<
          Mutation$ResendVerification$resendVerification$userErrors
        >
      >,
    )
    _fn,
  ) => call(
    userErrors: _fn(
      _instance.userErrors.map(
        (e) =>
            CopyWith$Mutation$ResendVerification$resendVerification$userErrors(
              e,
              (i) => i,
            ),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl$Mutation$ResendVerification$resendVerification<TRes>
    implements CopyWith$Mutation$ResendVerification$resendVerification<TRes> {
  _CopyWithStubImpl$Mutation$ResendVerification$resendVerification(this._res);

  TRes _res;

  call({
    bool? success,
    List<Mutation$ResendVerification$resendVerification$userErrors>? userErrors,
    String? verificationId,
    String? expiresAt,
  }) => _res;

  userErrors(_fn) => _res;
}

class Mutation$ResendVerification$resendVerification$userErrors {
  Mutation$ResendVerification$resendVerification$userErrors({
    required this.code,
    this.codeValue,
    required this.message,
    this.field,
  });

  factory Mutation$ResendVerification$resendVerification$userErrors.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$code = json['code'];
    final l$codeValue = json['codeValue'];
    final l$message = json['message'];
    final l$field = json['field'];
    return Mutation$ResendVerification$resendVerification$userErrors(
      code: (l$code as String),
      codeValue: l$codeValue == null
          ? null
          : fromJson$Enum$ErrorCode((l$codeValue as String)),
      message: (l$message as String),
      field: (l$field as String?),
    );
  }

  final String code;

  final Enum$ErrorCode? codeValue;

  final String message;

  final String? field;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$code = code;
    _resultData['code'] = l$code;
    final l$codeValue = codeValue;
    _resultData['codeValue'] = l$codeValue == null
        ? null
        : toJson$Enum$ErrorCode(l$codeValue);
    final l$message = message;
    _resultData['message'] = l$message;
    final l$field = field;
    _resultData['field'] = l$field;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$code = code;
    final l$codeValue = codeValue;
    final l$message = message;
    final l$field = field;
    return Object.hashAll([l$code, l$codeValue, l$message, l$field]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$ResendVerification$resendVerification$userErrors ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$code = code;
    final lOther$code = other.code;
    if (l$code != lOther$code) {
      return false;
    }
    final l$codeValue = codeValue;
    final lOther$codeValue = other.codeValue;
    if (l$codeValue != lOther$codeValue) {
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

extension UtilityExtension$Mutation$ResendVerification$resendVerification$userErrors
    on Mutation$ResendVerification$resendVerification$userErrors {
  CopyWith$Mutation$ResendVerification$resendVerification$userErrors<
    Mutation$ResendVerification$resendVerification$userErrors
  >
  get copyWith =>
      CopyWith$Mutation$ResendVerification$resendVerification$userErrors(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Mutation$ResendVerification$resendVerification$userErrors<
  TRes
> {
  factory CopyWith$Mutation$ResendVerification$resendVerification$userErrors(
    Mutation$ResendVerification$resendVerification$userErrors instance,
    TRes Function(Mutation$ResendVerification$resendVerification$userErrors)
    then,
  ) = _CopyWithImpl$Mutation$ResendVerification$resendVerification$userErrors;

  factory CopyWith$Mutation$ResendVerification$resendVerification$userErrors.stub(
    TRes res,
  ) = _CopyWithStubImpl$Mutation$ResendVerification$resendVerification$userErrors;

  TRes call({
    String? code,
    Enum$ErrorCode? codeValue,
    String? message,
    String? field,
  });
}

class _CopyWithImpl$Mutation$ResendVerification$resendVerification$userErrors<
  TRes
>
    implements
        CopyWith$Mutation$ResendVerification$resendVerification$userErrors<
          TRes
        > {
  _CopyWithImpl$Mutation$ResendVerification$resendVerification$userErrors(
    this._instance,
    this._then,
  );

  final Mutation$ResendVerification$resendVerification$userErrors _instance;

  final TRes Function(Mutation$ResendVerification$resendVerification$userErrors)
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? code = _undefined,
    Object? codeValue = _undefined,
    Object? message = _undefined,
    Object? field = _undefined,
  }) => _then(
    Mutation$ResendVerification$resendVerification$userErrors(
      code: code == _undefined || code == null
          ? _instance.code
          : (code as String),
      codeValue: codeValue == _undefined
          ? _instance.codeValue
          : (codeValue as Enum$ErrorCode?),
      message: message == _undefined || message == null
          ? _instance.message
          : (message as String),
      field: field == _undefined ? _instance.field : (field as String?),
    ),
  );
}

class _CopyWithStubImpl$Mutation$ResendVerification$resendVerification$userErrors<
  TRes
>
    implements
        CopyWith$Mutation$ResendVerification$resendVerification$userErrors<
          TRes
        > {
  _CopyWithStubImpl$Mutation$ResendVerification$resendVerification$userErrors(
    this._res,
  );

  TRes _res;

  call({
    String? code,
    Enum$ErrorCode? codeValue,
    String? message,
    String? field,
  }) => _res;
}

class Variables$Mutation$RetargetEmailVerification {
  factory Variables$Mutation$RetargetEmailVerification({
    required Input$RetargetEmailVerificationInput input,
  }) => Variables$Mutation$RetargetEmailVerification._({r'input': input});

  Variables$Mutation$RetargetEmailVerification._(this._$data);

  factory Variables$Mutation$RetargetEmailVerification.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    final l$input = data['input'];
    result$data['input'] = Input$RetargetEmailVerificationInput.fromJson(
      (l$input as Map<String, dynamic>),
    );
    return Variables$Mutation$RetargetEmailVerification._(result$data);
  }

  Map<String, dynamic> _$data;

  Input$RetargetEmailVerificationInput get input =>
      (_$data['input'] as Input$RetargetEmailVerificationInput);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$input = input;
    result$data['input'] = l$input.toJson();
    return result$data;
  }

  CopyWith$Variables$Mutation$RetargetEmailVerification<
    Variables$Mutation$RetargetEmailVerification
  >
  get copyWith =>
      CopyWith$Variables$Mutation$RetargetEmailVerification(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Mutation$RetargetEmailVerification ||
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

abstract class CopyWith$Variables$Mutation$RetargetEmailVerification<TRes> {
  factory CopyWith$Variables$Mutation$RetargetEmailVerification(
    Variables$Mutation$RetargetEmailVerification instance,
    TRes Function(Variables$Mutation$RetargetEmailVerification) then,
  ) = _CopyWithImpl$Variables$Mutation$RetargetEmailVerification;

  factory CopyWith$Variables$Mutation$RetargetEmailVerification.stub(TRes res) =
      _CopyWithStubImpl$Variables$Mutation$RetargetEmailVerification;

  TRes call({Input$RetargetEmailVerificationInput? input});
}

class _CopyWithImpl$Variables$Mutation$RetargetEmailVerification<TRes>
    implements CopyWith$Variables$Mutation$RetargetEmailVerification<TRes> {
  _CopyWithImpl$Variables$Mutation$RetargetEmailVerification(
    this._instance,
    this._then,
  );

  final Variables$Mutation$RetargetEmailVerification _instance;

  final TRes Function(Variables$Mutation$RetargetEmailVerification) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? input = _undefined}) => _then(
    Variables$Mutation$RetargetEmailVerification._({
      ..._instance._$data,
      if (input != _undefined && input != null)
        'input': (input as Input$RetargetEmailVerificationInput),
    }),
  );
}

class _CopyWithStubImpl$Variables$Mutation$RetargetEmailVerification<TRes>
    implements CopyWith$Variables$Mutation$RetargetEmailVerification<TRes> {
  _CopyWithStubImpl$Variables$Mutation$RetargetEmailVerification(this._res);

  TRes _res;

  call({Input$RetargetEmailVerificationInput? input}) => _res;
}

class Mutation$RetargetEmailVerification {
  Mutation$RetargetEmailVerification({required this.retargetEmailVerification});

  factory Mutation$RetargetEmailVerification.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$retargetEmailVerification = json['retargetEmailVerification'];
    return Mutation$RetargetEmailVerification(
      retargetEmailVerification:
          Mutation$RetargetEmailVerification$retargetEmailVerification.fromJson(
            (l$retargetEmailVerification as Map<String, dynamic>),
          ),
    );
  }

  final Mutation$RetargetEmailVerification$retargetEmailVerification
  retargetEmailVerification;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$retargetEmailVerification = retargetEmailVerification;
    _resultData['retargetEmailVerification'] = l$retargetEmailVerification
        .toJson();
    return _resultData;
  }

  @override
  int get hashCode {
    final l$retargetEmailVerification = retargetEmailVerification;
    return Object.hashAll([l$retargetEmailVerification]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$RetargetEmailVerification ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$retargetEmailVerification = retargetEmailVerification;
    final lOther$retargetEmailVerification = other.retargetEmailVerification;
    if (l$retargetEmailVerification != lOther$retargetEmailVerification) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Mutation$RetargetEmailVerification
    on Mutation$RetargetEmailVerification {
  CopyWith$Mutation$RetargetEmailVerification<
    Mutation$RetargetEmailVerification
  >
  get copyWith => CopyWith$Mutation$RetargetEmailVerification(this, (i) => i);
}

abstract class CopyWith$Mutation$RetargetEmailVerification<TRes> {
  factory CopyWith$Mutation$RetargetEmailVerification(
    Mutation$RetargetEmailVerification instance,
    TRes Function(Mutation$RetargetEmailVerification) then,
  ) = _CopyWithImpl$Mutation$RetargetEmailVerification;

  factory CopyWith$Mutation$RetargetEmailVerification.stub(TRes res) =
      _CopyWithStubImpl$Mutation$RetargetEmailVerification;

  TRes call({
    Mutation$RetargetEmailVerification$retargetEmailVerification?
    retargetEmailVerification,
  });
  CopyWith$Mutation$RetargetEmailVerification$retargetEmailVerification<TRes>
  get retargetEmailVerification;
}

class _CopyWithImpl$Mutation$RetargetEmailVerification<TRes>
    implements CopyWith$Mutation$RetargetEmailVerification<TRes> {
  _CopyWithImpl$Mutation$RetargetEmailVerification(this._instance, this._then);

  final Mutation$RetargetEmailVerification _instance;

  final TRes Function(Mutation$RetargetEmailVerification) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? retargetEmailVerification = _undefined}) => _then(
    Mutation$RetargetEmailVerification(
      retargetEmailVerification:
          retargetEmailVerification == _undefined ||
              retargetEmailVerification == null
          ? _instance.retargetEmailVerification
          : (retargetEmailVerification
                as Mutation$RetargetEmailVerification$retargetEmailVerification),
    ),
  );

  CopyWith$Mutation$RetargetEmailVerification$retargetEmailVerification<TRes>
  get retargetEmailVerification {
    final local$retargetEmailVerification = _instance.retargetEmailVerification;
    return CopyWith$Mutation$RetargetEmailVerification$retargetEmailVerification(
      local$retargetEmailVerification,
      (e) => call(retargetEmailVerification: e),
    );
  }
}

class _CopyWithStubImpl$Mutation$RetargetEmailVerification<TRes>
    implements CopyWith$Mutation$RetargetEmailVerification<TRes> {
  _CopyWithStubImpl$Mutation$RetargetEmailVerification(this._res);

  TRes _res;

  call({
    Mutation$RetargetEmailVerification$retargetEmailVerification?
    retargetEmailVerification,
  }) => _res;

  CopyWith$Mutation$RetargetEmailVerification$retargetEmailVerification<TRes>
  get retargetEmailVerification =>
      CopyWith$Mutation$RetargetEmailVerification$retargetEmailVerification.stub(
        _res,
      );
}

const documentNodeMutationRetargetEmailVerification = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'RetargetEmailVerification'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'input')),
          type: NamedTypeNode(
            name: NameNode(value: 'RetargetEmailVerificationInput'),
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
            name: NameNode(value: 'retargetEmailVerification'),
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
                        name: NameNode(value: 'codeValue'),
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
                  name: NameNode(value: 'verificationId'),
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

class Mutation$RetargetEmailVerification$retargetEmailVerification {
  Mutation$RetargetEmailVerification$retargetEmailVerification({
    required this.success,
    required this.userErrors,
    this.verificationId,
    this.expiresAt,
  });

  factory Mutation$RetargetEmailVerification$retargetEmailVerification.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$success = json['success'];
    final l$userErrors = json['userErrors'];
    final l$verificationId = json['verificationId'];
    final l$expiresAt = json['expiresAt'];
    return Mutation$RetargetEmailVerification$retargetEmailVerification(
      success: (l$success as bool),
      userErrors: (l$userErrors as List<dynamic>)
          .map(
            (e) =>
                Mutation$RetargetEmailVerification$retargetEmailVerification$userErrors.fromJson(
                  (e as Map<String, dynamic>),
                ),
          )
          .toList(),
      verificationId: (l$verificationId as String?),
      expiresAt: (l$expiresAt as String?),
    );
  }

  final bool success;

  final List<
    Mutation$RetargetEmailVerification$retargetEmailVerification$userErrors
  >
  userErrors;

  final String? verificationId;

  final String? expiresAt;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$success = success;
    _resultData['success'] = l$success;
    final l$userErrors = userErrors;
    _resultData['userErrors'] = l$userErrors.map((e) => e.toJson()).toList();
    final l$verificationId = verificationId;
    _resultData['verificationId'] = l$verificationId;
    final l$expiresAt = expiresAt;
    _resultData['expiresAt'] = l$expiresAt;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$success = success;
    final l$userErrors = userErrors;
    final l$verificationId = verificationId;
    final l$expiresAt = expiresAt;
    return Object.hashAll([
      l$success,
      Object.hashAll(l$userErrors.map((v) => v)),
      l$verificationId,
      l$expiresAt,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Mutation$RetargetEmailVerification$retargetEmailVerification ||
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
    final l$verificationId = verificationId;
    final lOther$verificationId = other.verificationId;
    if (l$verificationId != lOther$verificationId) {
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

extension UtilityExtension$Mutation$RetargetEmailVerification$retargetEmailVerification
    on Mutation$RetargetEmailVerification$retargetEmailVerification {
  CopyWith$Mutation$RetargetEmailVerification$retargetEmailVerification<
    Mutation$RetargetEmailVerification$retargetEmailVerification
  >
  get copyWith =>
      CopyWith$Mutation$RetargetEmailVerification$retargetEmailVerification(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Mutation$RetargetEmailVerification$retargetEmailVerification<
  TRes
> {
  factory CopyWith$Mutation$RetargetEmailVerification$retargetEmailVerification(
    Mutation$RetargetEmailVerification$retargetEmailVerification instance,
    TRes Function(Mutation$RetargetEmailVerification$retargetEmailVerification)
    then,
  ) = _CopyWithImpl$Mutation$RetargetEmailVerification$retargetEmailVerification;

  factory CopyWith$Mutation$RetargetEmailVerification$retargetEmailVerification.stub(
    TRes res,
  ) = _CopyWithStubImpl$Mutation$RetargetEmailVerification$retargetEmailVerification;

  TRes call({
    bool? success,
    List<
      Mutation$RetargetEmailVerification$retargetEmailVerification$userErrors
    >?
    userErrors,
    String? verificationId,
    String? expiresAt,
  });
  TRes userErrors(
    Iterable<
      Mutation$RetargetEmailVerification$retargetEmailVerification$userErrors
    >
    Function(
      Iterable<
        CopyWith$Mutation$RetargetEmailVerification$retargetEmailVerification$userErrors<
          Mutation$RetargetEmailVerification$retargetEmailVerification$userErrors
        >
      >,
    )
    _fn,
  );
}

class _CopyWithImpl$Mutation$RetargetEmailVerification$retargetEmailVerification<
  TRes
>
    implements
        CopyWith$Mutation$RetargetEmailVerification$retargetEmailVerification<
          TRes
        > {
  _CopyWithImpl$Mutation$RetargetEmailVerification$retargetEmailVerification(
    this._instance,
    this._then,
  );

  final Mutation$RetargetEmailVerification$retargetEmailVerification _instance;

  final TRes Function(
    Mutation$RetargetEmailVerification$retargetEmailVerification,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? success = _undefined,
    Object? userErrors = _undefined,
    Object? verificationId = _undefined,
    Object? expiresAt = _undefined,
  }) => _then(
    Mutation$RetargetEmailVerification$retargetEmailVerification(
      success: success == _undefined || success == null
          ? _instance.success
          : (success as bool),
      userErrors: userErrors == _undefined || userErrors == null
          ? _instance.userErrors
          : (userErrors
                as List<
                  Mutation$RetargetEmailVerification$retargetEmailVerification$userErrors
                >),
      verificationId: verificationId == _undefined
          ? _instance.verificationId
          : (verificationId as String?),
      expiresAt: expiresAt == _undefined
          ? _instance.expiresAt
          : (expiresAt as String?),
    ),
  );

  TRes userErrors(
    Iterable<
      Mutation$RetargetEmailVerification$retargetEmailVerification$userErrors
    >
    Function(
      Iterable<
        CopyWith$Mutation$RetargetEmailVerification$retargetEmailVerification$userErrors<
          Mutation$RetargetEmailVerification$retargetEmailVerification$userErrors
        >
      >,
    )
    _fn,
  ) => call(
    userErrors: _fn(
      _instance.userErrors.map(
        (e) =>
            CopyWith$Mutation$RetargetEmailVerification$retargetEmailVerification$userErrors(
              e,
              (i) => i,
            ),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl$Mutation$RetargetEmailVerification$retargetEmailVerification<
  TRes
>
    implements
        CopyWith$Mutation$RetargetEmailVerification$retargetEmailVerification<
          TRes
        > {
  _CopyWithStubImpl$Mutation$RetargetEmailVerification$retargetEmailVerification(
    this._res,
  );

  TRes _res;

  call({
    bool? success,
    List<
      Mutation$RetargetEmailVerification$retargetEmailVerification$userErrors
    >?
    userErrors,
    String? verificationId,
    String? expiresAt,
  }) => _res;

  userErrors(_fn) => _res;
}

class Mutation$RetargetEmailVerification$retargetEmailVerification$userErrors {
  Mutation$RetargetEmailVerification$retargetEmailVerification$userErrors({
    required this.code,
    this.codeValue,
    required this.message,
    this.field,
  });

  factory Mutation$RetargetEmailVerification$retargetEmailVerification$userErrors.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$code = json['code'];
    final l$codeValue = json['codeValue'];
    final l$message = json['message'];
    final l$field = json['field'];
    return Mutation$RetargetEmailVerification$retargetEmailVerification$userErrors(
      code: (l$code as String),
      codeValue: l$codeValue == null
          ? null
          : fromJson$Enum$ErrorCode((l$codeValue as String)),
      message: (l$message as String),
      field: (l$field as String?),
    );
  }

  final String code;

  final Enum$ErrorCode? codeValue;

  final String message;

  final String? field;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$code = code;
    _resultData['code'] = l$code;
    final l$codeValue = codeValue;
    _resultData['codeValue'] = l$codeValue == null
        ? null
        : toJson$Enum$ErrorCode(l$codeValue);
    final l$message = message;
    _resultData['message'] = l$message;
    final l$field = field;
    _resultData['field'] = l$field;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$code = code;
    final l$codeValue = codeValue;
    final l$message = message;
    final l$field = field;
    return Object.hashAll([l$code, l$codeValue, l$message, l$field]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Mutation$RetargetEmailVerification$retargetEmailVerification$userErrors ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$code = code;
    final lOther$code = other.code;
    if (l$code != lOther$code) {
      return false;
    }
    final l$codeValue = codeValue;
    final lOther$codeValue = other.codeValue;
    if (l$codeValue != lOther$codeValue) {
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

extension UtilityExtension$Mutation$RetargetEmailVerification$retargetEmailVerification$userErrors
    on Mutation$RetargetEmailVerification$retargetEmailVerification$userErrors {
  CopyWith$Mutation$RetargetEmailVerification$retargetEmailVerification$userErrors<
    Mutation$RetargetEmailVerification$retargetEmailVerification$userErrors
  >
  get copyWith =>
      CopyWith$Mutation$RetargetEmailVerification$retargetEmailVerification$userErrors(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Mutation$RetargetEmailVerification$retargetEmailVerification$userErrors<
  TRes
> {
  factory CopyWith$Mutation$RetargetEmailVerification$retargetEmailVerification$userErrors(
    Mutation$RetargetEmailVerification$retargetEmailVerification$userErrors
    instance,
    TRes Function(
      Mutation$RetargetEmailVerification$retargetEmailVerification$userErrors,
    )
    then,
  ) = _CopyWithImpl$Mutation$RetargetEmailVerification$retargetEmailVerification$userErrors;

  factory CopyWith$Mutation$RetargetEmailVerification$retargetEmailVerification$userErrors.stub(
    TRes res,
  ) = _CopyWithStubImpl$Mutation$RetargetEmailVerification$retargetEmailVerification$userErrors;

  TRes call({
    String? code,
    Enum$ErrorCode? codeValue,
    String? message,
    String? field,
  });
}

class _CopyWithImpl$Mutation$RetargetEmailVerification$retargetEmailVerification$userErrors<
  TRes
>
    implements
        CopyWith$Mutation$RetargetEmailVerification$retargetEmailVerification$userErrors<
          TRes
        > {
  _CopyWithImpl$Mutation$RetargetEmailVerification$retargetEmailVerification$userErrors(
    this._instance,
    this._then,
  );

  final Mutation$RetargetEmailVerification$retargetEmailVerification$userErrors
  _instance;

  final TRes Function(
    Mutation$RetargetEmailVerification$retargetEmailVerification$userErrors,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? code = _undefined,
    Object? codeValue = _undefined,
    Object? message = _undefined,
    Object? field = _undefined,
  }) => _then(
    Mutation$RetargetEmailVerification$retargetEmailVerification$userErrors(
      code: code == _undefined || code == null
          ? _instance.code
          : (code as String),
      codeValue: codeValue == _undefined
          ? _instance.codeValue
          : (codeValue as Enum$ErrorCode?),
      message: message == _undefined || message == null
          ? _instance.message
          : (message as String),
      field: field == _undefined ? _instance.field : (field as String?),
    ),
  );
}

class _CopyWithStubImpl$Mutation$RetargetEmailVerification$retargetEmailVerification$userErrors<
  TRes
>
    implements
        CopyWith$Mutation$RetargetEmailVerification$retargetEmailVerification$userErrors<
          TRes
        > {
  _CopyWithStubImpl$Mutation$RetargetEmailVerification$retargetEmailVerification$userErrors(
    this._res,
  );

  TRes _res;

  call({
    String? code,
    Enum$ErrorCode? codeValue,
    String? message,
    String? field,
  }) => _res;
}

class Variables$Mutation$RegisterSnsMember {
  factory Variables$Mutation$RegisterSnsMember({
    required Input$RegisterSnsMemberInput input,
  }) => Variables$Mutation$RegisterSnsMember._({r'input': input});

  Variables$Mutation$RegisterSnsMember._(this._$data);

  factory Variables$Mutation$RegisterSnsMember.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    final l$input = data['input'];
    result$data['input'] = Input$RegisterSnsMemberInput.fromJson(
      (l$input as Map<String, dynamic>),
    );
    return Variables$Mutation$RegisterSnsMember._(result$data);
  }

  Map<String, dynamic> _$data;

  Input$RegisterSnsMemberInput get input =>
      (_$data['input'] as Input$RegisterSnsMemberInput);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$input = input;
    result$data['input'] = l$input.toJson();
    return result$data;
  }

  CopyWith$Variables$Mutation$RegisterSnsMember<
    Variables$Mutation$RegisterSnsMember
  >
  get copyWith => CopyWith$Variables$Mutation$RegisterSnsMember(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Mutation$RegisterSnsMember ||
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

abstract class CopyWith$Variables$Mutation$RegisterSnsMember<TRes> {
  factory CopyWith$Variables$Mutation$RegisterSnsMember(
    Variables$Mutation$RegisterSnsMember instance,
    TRes Function(Variables$Mutation$RegisterSnsMember) then,
  ) = _CopyWithImpl$Variables$Mutation$RegisterSnsMember;

  factory CopyWith$Variables$Mutation$RegisterSnsMember.stub(TRes res) =
      _CopyWithStubImpl$Variables$Mutation$RegisterSnsMember;

  TRes call({Input$RegisterSnsMemberInput? input});
}

class _CopyWithImpl$Variables$Mutation$RegisterSnsMember<TRes>
    implements CopyWith$Variables$Mutation$RegisterSnsMember<TRes> {
  _CopyWithImpl$Variables$Mutation$RegisterSnsMember(
    this._instance,
    this._then,
  );

  final Variables$Mutation$RegisterSnsMember _instance;

  final TRes Function(Variables$Mutation$RegisterSnsMember) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? input = _undefined}) => _then(
    Variables$Mutation$RegisterSnsMember._({
      ..._instance._$data,
      if (input != _undefined && input != null)
        'input': (input as Input$RegisterSnsMemberInput),
    }),
  );
}

class _CopyWithStubImpl$Variables$Mutation$RegisterSnsMember<TRes>
    implements CopyWith$Variables$Mutation$RegisterSnsMember<TRes> {
  _CopyWithStubImpl$Variables$Mutation$RegisterSnsMember(this._res);

  TRes _res;

  call({Input$RegisterSnsMemberInput? input}) => _res;
}

class Mutation$RegisterSnsMember {
  Mutation$RegisterSnsMember({required this.registerSnsMember});

  factory Mutation$RegisterSnsMember.fromJson(Map<String, dynamic> json) {
    final l$registerSnsMember = json['registerSnsMember'];
    return Mutation$RegisterSnsMember(
      registerSnsMember: Mutation$RegisterSnsMember$registerSnsMember.fromJson(
        (l$registerSnsMember as Map<String, dynamic>),
      ),
    );
  }

  final Mutation$RegisterSnsMember$registerSnsMember registerSnsMember;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$registerSnsMember = registerSnsMember;
    _resultData['registerSnsMember'] = l$registerSnsMember.toJson();
    return _resultData;
  }

  @override
  int get hashCode {
    final l$registerSnsMember = registerSnsMember;
    return Object.hashAll([l$registerSnsMember]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$RegisterSnsMember ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$registerSnsMember = registerSnsMember;
    final lOther$registerSnsMember = other.registerSnsMember;
    if (l$registerSnsMember != lOther$registerSnsMember) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Mutation$RegisterSnsMember
    on Mutation$RegisterSnsMember {
  CopyWith$Mutation$RegisterSnsMember<Mutation$RegisterSnsMember>
  get copyWith => CopyWith$Mutation$RegisterSnsMember(this, (i) => i);
}

abstract class CopyWith$Mutation$RegisterSnsMember<TRes> {
  factory CopyWith$Mutation$RegisterSnsMember(
    Mutation$RegisterSnsMember instance,
    TRes Function(Mutation$RegisterSnsMember) then,
  ) = _CopyWithImpl$Mutation$RegisterSnsMember;

  factory CopyWith$Mutation$RegisterSnsMember.stub(TRes res) =
      _CopyWithStubImpl$Mutation$RegisterSnsMember;

  TRes call({Mutation$RegisterSnsMember$registerSnsMember? registerSnsMember});
  CopyWith$Mutation$RegisterSnsMember$registerSnsMember<TRes>
  get registerSnsMember;
}

class _CopyWithImpl$Mutation$RegisterSnsMember<TRes>
    implements CopyWith$Mutation$RegisterSnsMember<TRes> {
  _CopyWithImpl$Mutation$RegisterSnsMember(this._instance, this._then);

  final Mutation$RegisterSnsMember _instance;

  final TRes Function(Mutation$RegisterSnsMember) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? registerSnsMember = _undefined}) => _then(
    Mutation$RegisterSnsMember(
      registerSnsMember:
          registerSnsMember == _undefined || registerSnsMember == null
          ? _instance.registerSnsMember
          : (registerSnsMember as Mutation$RegisterSnsMember$registerSnsMember),
    ),
  );

  CopyWith$Mutation$RegisterSnsMember$registerSnsMember<TRes>
  get registerSnsMember {
    final local$registerSnsMember = _instance.registerSnsMember;
    return CopyWith$Mutation$RegisterSnsMember$registerSnsMember(
      local$registerSnsMember,
      (e) => call(registerSnsMember: e),
    );
  }
}

class _CopyWithStubImpl$Mutation$RegisterSnsMember<TRes>
    implements CopyWith$Mutation$RegisterSnsMember<TRes> {
  _CopyWithStubImpl$Mutation$RegisterSnsMember(this._res);

  TRes _res;

  call({Mutation$RegisterSnsMember$registerSnsMember? registerSnsMember}) =>
      _res;

  CopyWith$Mutation$RegisterSnsMember$registerSnsMember<TRes>
  get registerSnsMember =>
      CopyWith$Mutation$RegisterSnsMember$registerSnsMember.stub(_res);
}

const documentNodeMutationRegisterSnsMember = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'RegisterSnsMember'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'input')),
          type: NamedTypeNode(
            name: NameNode(value: 'RegisterSnsMemberInput'),
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
            name: NameNode(value: 'registerSnsMember'),
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
                        name: NameNode(value: 'codeValue'),
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
                  name: NameNode(value: 'emailVerified'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: 'verificationId'),
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

class Mutation$RegisterSnsMember$registerSnsMember {
  Mutation$RegisterSnsMember$registerSnsMember({
    required this.success,
    required this.userErrors,
    this.emailVerified,
    this.verificationId,
  });

  factory Mutation$RegisterSnsMember$registerSnsMember.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$success = json['success'];
    final l$userErrors = json['userErrors'];
    final l$emailVerified = json['emailVerified'];
    final l$verificationId = json['verificationId'];
    return Mutation$RegisterSnsMember$registerSnsMember(
      success: (l$success as bool),
      userErrors: (l$userErrors as List<dynamic>)
          .map(
            (e) =>
                Mutation$RegisterSnsMember$registerSnsMember$userErrors.fromJson(
                  (e as Map<String, dynamic>),
                ),
          )
          .toList(),
      emailVerified: (l$emailVerified as bool?),
      verificationId: (l$verificationId as String?),
    );
  }

  final bool success;

  final List<Mutation$RegisterSnsMember$registerSnsMember$userErrors>
  userErrors;

  final bool? emailVerified;

  final String? verificationId;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$success = success;
    _resultData['success'] = l$success;
    final l$userErrors = userErrors;
    _resultData['userErrors'] = l$userErrors.map((e) => e.toJson()).toList();
    final l$emailVerified = emailVerified;
    _resultData['emailVerified'] = l$emailVerified;
    final l$verificationId = verificationId;
    _resultData['verificationId'] = l$verificationId;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$success = success;
    final l$userErrors = userErrors;
    final l$emailVerified = emailVerified;
    final l$verificationId = verificationId;
    return Object.hashAll([
      l$success,
      Object.hashAll(l$userErrors.map((v) => v)),
      l$emailVerified,
      l$verificationId,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$RegisterSnsMember$registerSnsMember ||
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
    final l$emailVerified = emailVerified;
    final lOther$emailVerified = other.emailVerified;
    if (l$emailVerified != lOther$emailVerified) {
      return false;
    }
    final l$verificationId = verificationId;
    final lOther$verificationId = other.verificationId;
    if (l$verificationId != lOther$verificationId) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Mutation$RegisterSnsMember$registerSnsMember
    on Mutation$RegisterSnsMember$registerSnsMember {
  CopyWith$Mutation$RegisterSnsMember$registerSnsMember<
    Mutation$RegisterSnsMember$registerSnsMember
  >
  get copyWith =>
      CopyWith$Mutation$RegisterSnsMember$registerSnsMember(this, (i) => i);
}

abstract class CopyWith$Mutation$RegisterSnsMember$registerSnsMember<TRes> {
  factory CopyWith$Mutation$RegisterSnsMember$registerSnsMember(
    Mutation$RegisterSnsMember$registerSnsMember instance,
    TRes Function(Mutation$RegisterSnsMember$registerSnsMember) then,
  ) = _CopyWithImpl$Mutation$RegisterSnsMember$registerSnsMember;

  factory CopyWith$Mutation$RegisterSnsMember$registerSnsMember.stub(TRes res) =
      _CopyWithStubImpl$Mutation$RegisterSnsMember$registerSnsMember;

  TRes call({
    bool? success,
    List<Mutation$RegisterSnsMember$registerSnsMember$userErrors>? userErrors,
    bool? emailVerified,
    String? verificationId,
  });
  TRes userErrors(
    Iterable<Mutation$RegisterSnsMember$registerSnsMember$userErrors> Function(
      Iterable<
        CopyWith$Mutation$RegisterSnsMember$registerSnsMember$userErrors<
          Mutation$RegisterSnsMember$registerSnsMember$userErrors
        >
      >,
    )
    _fn,
  );
}

class _CopyWithImpl$Mutation$RegisterSnsMember$registerSnsMember<TRes>
    implements CopyWith$Mutation$RegisterSnsMember$registerSnsMember<TRes> {
  _CopyWithImpl$Mutation$RegisterSnsMember$registerSnsMember(
    this._instance,
    this._then,
  );

  final Mutation$RegisterSnsMember$registerSnsMember _instance;

  final TRes Function(Mutation$RegisterSnsMember$registerSnsMember) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? success = _undefined,
    Object? userErrors = _undefined,
    Object? emailVerified = _undefined,
    Object? verificationId = _undefined,
  }) => _then(
    Mutation$RegisterSnsMember$registerSnsMember(
      success: success == _undefined || success == null
          ? _instance.success
          : (success as bool),
      userErrors: userErrors == _undefined || userErrors == null
          ? _instance.userErrors
          : (userErrors
                as List<
                  Mutation$RegisterSnsMember$registerSnsMember$userErrors
                >),
      emailVerified: emailVerified == _undefined
          ? _instance.emailVerified
          : (emailVerified as bool?),
      verificationId: verificationId == _undefined
          ? _instance.verificationId
          : (verificationId as String?),
    ),
  );

  TRes userErrors(
    Iterable<Mutation$RegisterSnsMember$registerSnsMember$userErrors> Function(
      Iterable<
        CopyWith$Mutation$RegisterSnsMember$registerSnsMember$userErrors<
          Mutation$RegisterSnsMember$registerSnsMember$userErrors
        >
      >,
    )
    _fn,
  ) => call(
    userErrors: _fn(
      _instance.userErrors.map(
        (e) => CopyWith$Mutation$RegisterSnsMember$registerSnsMember$userErrors(
          e,
          (i) => i,
        ),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl$Mutation$RegisterSnsMember$registerSnsMember<TRes>
    implements CopyWith$Mutation$RegisterSnsMember$registerSnsMember<TRes> {
  _CopyWithStubImpl$Mutation$RegisterSnsMember$registerSnsMember(this._res);

  TRes _res;

  call({
    bool? success,
    List<Mutation$RegisterSnsMember$registerSnsMember$userErrors>? userErrors,
    bool? emailVerified,
    String? verificationId,
  }) => _res;

  userErrors(_fn) => _res;
}

class Mutation$RegisterSnsMember$registerSnsMember$userErrors {
  Mutation$RegisterSnsMember$registerSnsMember$userErrors({
    required this.code,
    this.codeValue,
    required this.message,
    this.field,
  });

  factory Mutation$RegisterSnsMember$registerSnsMember$userErrors.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$code = json['code'];
    final l$codeValue = json['codeValue'];
    final l$message = json['message'];
    final l$field = json['field'];
    return Mutation$RegisterSnsMember$registerSnsMember$userErrors(
      code: (l$code as String),
      codeValue: l$codeValue == null
          ? null
          : fromJson$Enum$ErrorCode((l$codeValue as String)),
      message: (l$message as String),
      field: (l$field as String?),
    );
  }

  final String code;

  final Enum$ErrorCode? codeValue;

  final String message;

  final String? field;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$code = code;
    _resultData['code'] = l$code;
    final l$codeValue = codeValue;
    _resultData['codeValue'] = l$codeValue == null
        ? null
        : toJson$Enum$ErrorCode(l$codeValue);
    final l$message = message;
    _resultData['message'] = l$message;
    final l$field = field;
    _resultData['field'] = l$field;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$code = code;
    final l$codeValue = codeValue;
    final l$message = message;
    final l$field = field;
    return Object.hashAll([l$code, l$codeValue, l$message, l$field]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$RegisterSnsMember$registerSnsMember$userErrors ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$code = code;
    final lOther$code = other.code;
    if (l$code != lOther$code) {
      return false;
    }
    final l$codeValue = codeValue;
    final lOther$codeValue = other.codeValue;
    if (l$codeValue != lOther$codeValue) {
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

extension UtilityExtension$Mutation$RegisterSnsMember$registerSnsMember$userErrors
    on Mutation$RegisterSnsMember$registerSnsMember$userErrors {
  CopyWith$Mutation$RegisterSnsMember$registerSnsMember$userErrors<
    Mutation$RegisterSnsMember$registerSnsMember$userErrors
  >
  get copyWith =>
      CopyWith$Mutation$RegisterSnsMember$registerSnsMember$userErrors(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Mutation$RegisterSnsMember$registerSnsMember$userErrors<
  TRes
> {
  factory CopyWith$Mutation$RegisterSnsMember$registerSnsMember$userErrors(
    Mutation$RegisterSnsMember$registerSnsMember$userErrors instance,
    TRes Function(Mutation$RegisterSnsMember$registerSnsMember$userErrors) then,
  ) = _CopyWithImpl$Mutation$RegisterSnsMember$registerSnsMember$userErrors;

  factory CopyWith$Mutation$RegisterSnsMember$registerSnsMember$userErrors.stub(
    TRes res,
  ) = _CopyWithStubImpl$Mutation$RegisterSnsMember$registerSnsMember$userErrors;

  TRes call({
    String? code,
    Enum$ErrorCode? codeValue,
    String? message,
    String? field,
  });
}

class _CopyWithImpl$Mutation$RegisterSnsMember$registerSnsMember$userErrors<
  TRes
>
    implements
        CopyWith$Mutation$RegisterSnsMember$registerSnsMember$userErrors<TRes> {
  _CopyWithImpl$Mutation$RegisterSnsMember$registerSnsMember$userErrors(
    this._instance,
    this._then,
  );

  final Mutation$RegisterSnsMember$registerSnsMember$userErrors _instance;

  final TRes Function(Mutation$RegisterSnsMember$registerSnsMember$userErrors)
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? code = _undefined,
    Object? codeValue = _undefined,
    Object? message = _undefined,
    Object? field = _undefined,
  }) => _then(
    Mutation$RegisterSnsMember$registerSnsMember$userErrors(
      code: code == _undefined || code == null
          ? _instance.code
          : (code as String),
      codeValue: codeValue == _undefined
          ? _instance.codeValue
          : (codeValue as Enum$ErrorCode?),
      message: message == _undefined || message == null
          ? _instance.message
          : (message as String),
      field: field == _undefined ? _instance.field : (field as String?),
    ),
  );
}

class _CopyWithStubImpl$Mutation$RegisterSnsMember$registerSnsMember$userErrors<
  TRes
>
    implements
        CopyWith$Mutation$RegisterSnsMember$registerSnsMember$userErrors<TRes> {
  _CopyWithStubImpl$Mutation$RegisterSnsMember$registerSnsMember$userErrors(
    this._res,
  );

  TRes _res;

  call({
    String? code,
    Enum$ErrorCode? codeValue,
    String? message,
    String? field,
  }) => _res;
}

class Variables$Mutation$LoginSns {
  factory Variables$Mutation$LoginSns({required Input$LoginSnsInput input}) =>
      Variables$Mutation$LoginSns._({r'input': input});

  Variables$Mutation$LoginSns._(this._$data);

  factory Variables$Mutation$LoginSns.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$input = data['input'];
    result$data['input'] = Input$LoginSnsInput.fromJson(
      (l$input as Map<String, dynamic>),
    );
    return Variables$Mutation$LoginSns._(result$data);
  }

  Map<String, dynamic> _$data;

  Input$LoginSnsInput get input => (_$data['input'] as Input$LoginSnsInput);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$input = input;
    result$data['input'] = l$input.toJson();
    return result$data;
  }

  CopyWith$Variables$Mutation$LoginSns<Variables$Mutation$LoginSns>
  get copyWith => CopyWith$Variables$Mutation$LoginSns(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Mutation$LoginSns ||
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

abstract class CopyWith$Variables$Mutation$LoginSns<TRes> {
  factory CopyWith$Variables$Mutation$LoginSns(
    Variables$Mutation$LoginSns instance,
    TRes Function(Variables$Mutation$LoginSns) then,
  ) = _CopyWithImpl$Variables$Mutation$LoginSns;

  factory CopyWith$Variables$Mutation$LoginSns.stub(TRes res) =
      _CopyWithStubImpl$Variables$Mutation$LoginSns;

  TRes call({Input$LoginSnsInput? input});
}

class _CopyWithImpl$Variables$Mutation$LoginSns<TRes>
    implements CopyWith$Variables$Mutation$LoginSns<TRes> {
  _CopyWithImpl$Variables$Mutation$LoginSns(this._instance, this._then);

  final Variables$Mutation$LoginSns _instance;

  final TRes Function(Variables$Mutation$LoginSns) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? input = _undefined}) => _then(
    Variables$Mutation$LoginSns._({
      ..._instance._$data,
      if (input != _undefined && input != null)
        'input': (input as Input$LoginSnsInput),
    }),
  );
}

class _CopyWithStubImpl$Variables$Mutation$LoginSns<TRes>
    implements CopyWith$Variables$Mutation$LoginSns<TRes> {
  _CopyWithStubImpl$Variables$Mutation$LoginSns(this._res);

  TRes _res;

  call({Input$LoginSnsInput? input}) => _res;
}

class Mutation$LoginSns {
  Mutation$LoginSns({required this.loginSns});

  factory Mutation$LoginSns.fromJson(Map<String, dynamic> json) {
    final l$loginSns = json['loginSns'];
    return Mutation$LoginSns(
      loginSns: Mutation$LoginSns$loginSns.fromJson(
        (l$loginSns as Map<String, dynamic>),
      ),
    );
  }

  final Mutation$LoginSns$loginSns loginSns;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$loginSns = loginSns;
    _resultData['loginSns'] = l$loginSns.toJson();
    return _resultData;
  }

  @override
  int get hashCode {
    final l$loginSns = loginSns;
    return Object.hashAll([l$loginSns]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$LoginSns || runtimeType != other.runtimeType) {
      return false;
    }
    final l$loginSns = loginSns;
    final lOther$loginSns = other.loginSns;
    if (l$loginSns != lOther$loginSns) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Mutation$LoginSns on Mutation$LoginSns {
  CopyWith$Mutation$LoginSns<Mutation$LoginSns> get copyWith =>
      CopyWith$Mutation$LoginSns(this, (i) => i);
}

abstract class CopyWith$Mutation$LoginSns<TRes> {
  factory CopyWith$Mutation$LoginSns(
    Mutation$LoginSns instance,
    TRes Function(Mutation$LoginSns) then,
  ) = _CopyWithImpl$Mutation$LoginSns;

  factory CopyWith$Mutation$LoginSns.stub(TRes res) =
      _CopyWithStubImpl$Mutation$LoginSns;

  TRes call({Mutation$LoginSns$loginSns? loginSns});
  CopyWith$Mutation$LoginSns$loginSns<TRes> get loginSns;
}

class _CopyWithImpl$Mutation$LoginSns<TRes>
    implements CopyWith$Mutation$LoginSns<TRes> {
  _CopyWithImpl$Mutation$LoginSns(this._instance, this._then);

  final Mutation$LoginSns _instance;

  final TRes Function(Mutation$LoginSns) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? loginSns = _undefined}) => _then(
    Mutation$LoginSns(
      loginSns: loginSns == _undefined || loginSns == null
          ? _instance.loginSns
          : (loginSns as Mutation$LoginSns$loginSns),
    ),
  );

  CopyWith$Mutation$LoginSns$loginSns<TRes> get loginSns {
    final local$loginSns = _instance.loginSns;
    return CopyWith$Mutation$LoginSns$loginSns(
      local$loginSns,
      (e) => call(loginSns: e),
    );
  }
}

class _CopyWithStubImpl$Mutation$LoginSns<TRes>
    implements CopyWith$Mutation$LoginSns<TRes> {
  _CopyWithStubImpl$Mutation$LoginSns(this._res);

  TRes _res;

  call({Mutation$LoginSns$loginSns? loginSns}) => _res;

  CopyWith$Mutation$LoginSns$loginSns<TRes> get loginSns =>
      CopyWith$Mutation$LoginSns$loginSns.stub(_res);
}

const documentNodeMutationLoginSns = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'LoginSns'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'input')),
          type: NamedTypeNode(
            name: NameNode(value: 'LoginSnsInput'),
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
            name: NameNode(value: 'loginSns'),
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
                        name: NameNode(value: 'codeValue'),
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
                  name: NameNode(value: 'accessToken'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: 'refreshToken'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: 'tokenType'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: 'accessTokenExpiresIn'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: 'refreshTokenExpiresIn'),
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

class Mutation$LoginSns$loginSns {
  Mutation$LoginSns$loginSns({
    required this.success,
    required this.userErrors,
    this.accessToken,
    this.refreshToken,
    this.tokenType,
    this.accessTokenExpiresIn,
    this.refreshTokenExpiresIn,
  });

  factory Mutation$LoginSns$loginSns.fromJson(Map<String, dynamic> json) {
    final l$success = json['success'];
    final l$userErrors = json['userErrors'];
    final l$accessToken = json['accessToken'];
    final l$refreshToken = json['refreshToken'];
    final l$tokenType = json['tokenType'];
    final l$accessTokenExpiresIn = json['accessTokenExpiresIn'];
    final l$refreshTokenExpiresIn = json['refreshTokenExpiresIn'];
    return Mutation$LoginSns$loginSns(
      success: (l$success as bool),
      userErrors: (l$userErrors as List<dynamic>)
          .map(
            (e) => Mutation$LoginSns$loginSns$userErrors.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      accessToken: (l$accessToken as String?),
      refreshToken: (l$refreshToken as String?),
      tokenType: (l$tokenType as String?),
      accessTokenExpiresIn: (l$accessTokenExpiresIn as int?),
      refreshTokenExpiresIn: (l$refreshTokenExpiresIn as int?),
    );
  }

  final bool success;

  final List<Mutation$LoginSns$loginSns$userErrors> userErrors;

  final String? accessToken;

  final String? refreshToken;

  final String? tokenType;

  final int? accessTokenExpiresIn;

  final int? refreshTokenExpiresIn;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$success = success;
    _resultData['success'] = l$success;
    final l$userErrors = userErrors;
    _resultData['userErrors'] = l$userErrors.map((e) => e.toJson()).toList();
    final l$accessToken = accessToken;
    _resultData['accessToken'] = l$accessToken;
    final l$refreshToken = refreshToken;
    _resultData['refreshToken'] = l$refreshToken;
    final l$tokenType = tokenType;
    _resultData['tokenType'] = l$tokenType;
    final l$accessTokenExpiresIn = accessTokenExpiresIn;
    _resultData['accessTokenExpiresIn'] = l$accessTokenExpiresIn;
    final l$refreshTokenExpiresIn = refreshTokenExpiresIn;
    _resultData['refreshTokenExpiresIn'] = l$refreshTokenExpiresIn;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$success = success;
    final l$userErrors = userErrors;
    final l$accessToken = accessToken;
    final l$refreshToken = refreshToken;
    final l$tokenType = tokenType;
    final l$accessTokenExpiresIn = accessTokenExpiresIn;
    final l$refreshTokenExpiresIn = refreshTokenExpiresIn;
    return Object.hashAll([
      l$success,
      Object.hashAll(l$userErrors.map((v) => v)),
      l$accessToken,
      l$refreshToken,
      l$tokenType,
      l$accessTokenExpiresIn,
      l$refreshTokenExpiresIn,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$LoginSns$loginSns ||
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
    final l$accessToken = accessToken;
    final lOther$accessToken = other.accessToken;
    if (l$accessToken != lOther$accessToken) {
      return false;
    }
    final l$refreshToken = refreshToken;
    final lOther$refreshToken = other.refreshToken;
    if (l$refreshToken != lOther$refreshToken) {
      return false;
    }
    final l$tokenType = tokenType;
    final lOther$tokenType = other.tokenType;
    if (l$tokenType != lOther$tokenType) {
      return false;
    }
    final l$accessTokenExpiresIn = accessTokenExpiresIn;
    final lOther$accessTokenExpiresIn = other.accessTokenExpiresIn;
    if (l$accessTokenExpiresIn != lOther$accessTokenExpiresIn) {
      return false;
    }
    final l$refreshTokenExpiresIn = refreshTokenExpiresIn;
    final lOther$refreshTokenExpiresIn = other.refreshTokenExpiresIn;
    if (l$refreshTokenExpiresIn != lOther$refreshTokenExpiresIn) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Mutation$LoginSns$loginSns
    on Mutation$LoginSns$loginSns {
  CopyWith$Mutation$LoginSns$loginSns<Mutation$LoginSns$loginSns>
  get copyWith => CopyWith$Mutation$LoginSns$loginSns(this, (i) => i);
}

abstract class CopyWith$Mutation$LoginSns$loginSns<TRes> {
  factory CopyWith$Mutation$LoginSns$loginSns(
    Mutation$LoginSns$loginSns instance,
    TRes Function(Mutation$LoginSns$loginSns) then,
  ) = _CopyWithImpl$Mutation$LoginSns$loginSns;

  factory CopyWith$Mutation$LoginSns$loginSns.stub(TRes res) =
      _CopyWithStubImpl$Mutation$LoginSns$loginSns;

  TRes call({
    bool? success,
    List<Mutation$LoginSns$loginSns$userErrors>? userErrors,
    String? accessToken,
    String? refreshToken,
    String? tokenType,
    int? accessTokenExpiresIn,
    int? refreshTokenExpiresIn,
  });
  TRes userErrors(
    Iterable<Mutation$LoginSns$loginSns$userErrors> Function(
      Iterable<
        CopyWith$Mutation$LoginSns$loginSns$userErrors<
          Mutation$LoginSns$loginSns$userErrors
        >
      >,
    )
    _fn,
  );
}

class _CopyWithImpl$Mutation$LoginSns$loginSns<TRes>
    implements CopyWith$Mutation$LoginSns$loginSns<TRes> {
  _CopyWithImpl$Mutation$LoginSns$loginSns(this._instance, this._then);

  final Mutation$LoginSns$loginSns _instance;

  final TRes Function(Mutation$LoginSns$loginSns) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? success = _undefined,
    Object? userErrors = _undefined,
    Object? accessToken = _undefined,
    Object? refreshToken = _undefined,
    Object? tokenType = _undefined,
    Object? accessTokenExpiresIn = _undefined,
    Object? refreshTokenExpiresIn = _undefined,
  }) => _then(
    Mutation$LoginSns$loginSns(
      success: success == _undefined || success == null
          ? _instance.success
          : (success as bool),
      userErrors: userErrors == _undefined || userErrors == null
          ? _instance.userErrors
          : (userErrors as List<Mutation$LoginSns$loginSns$userErrors>),
      accessToken: accessToken == _undefined
          ? _instance.accessToken
          : (accessToken as String?),
      refreshToken: refreshToken == _undefined
          ? _instance.refreshToken
          : (refreshToken as String?),
      tokenType: tokenType == _undefined
          ? _instance.tokenType
          : (tokenType as String?),
      accessTokenExpiresIn: accessTokenExpiresIn == _undefined
          ? _instance.accessTokenExpiresIn
          : (accessTokenExpiresIn as int?),
      refreshTokenExpiresIn: refreshTokenExpiresIn == _undefined
          ? _instance.refreshTokenExpiresIn
          : (refreshTokenExpiresIn as int?),
    ),
  );

  TRes userErrors(
    Iterable<Mutation$LoginSns$loginSns$userErrors> Function(
      Iterable<
        CopyWith$Mutation$LoginSns$loginSns$userErrors<
          Mutation$LoginSns$loginSns$userErrors
        >
      >,
    )
    _fn,
  ) => call(
    userErrors: _fn(
      _instance.userErrors.map(
        (e) => CopyWith$Mutation$LoginSns$loginSns$userErrors(e, (i) => i),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl$Mutation$LoginSns$loginSns<TRes>
    implements CopyWith$Mutation$LoginSns$loginSns<TRes> {
  _CopyWithStubImpl$Mutation$LoginSns$loginSns(this._res);

  TRes _res;

  call({
    bool? success,
    List<Mutation$LoginSns$loginSns$userErrors>? userErrors,
    String? accessToken,
    String? refreshToken,
    String? tokenType,
    int? accessTokenExpiresIn,
    int? refreshTokenExpiresIn,
  }) => _res;

  userErrors(_fn) => _res;
}

class Mutation$LoginSns$loginSns$userErrors {
  Mutation$LoginSns$loginSns$userErrors({
    required this.code,
    this.codeValue,
    required this.message,
    this.field,
  });

  factory Mutation$LoginSns$loginSns$userErrors.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$code = json['code'];
    final l$codeValue = json['codeValue'];
    final l$message = json['message'];
    final l$field = json['field'];
    return Mutation$LoginSns$loginSns$userErrors(
      code: (l$code as String),
      codeValue: l$codeValue == null
          ? null
          : fromJson$Enum$ErrorCode((l$codeValue as String)),
      message: (l$message as String),
      field: (l$field as String?),
    );
  }

  final String code;

  final Enum$ErrorCode? codeValue;

  final String message;

  final String? field;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$code = code;
    _resultData['code'] = l$code;
    final l$codeValue = codeValue;
    _resultData['codeValue'] = l$codeValue == null
        ? null
        : toJson$Enum$ErrorCode(l$codeValue);
    final l$message = message;
    _resultData['message'] = l$message;
    final l$field = field;
    _resultData['field'] = l$field;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$code = code;
    final l$codeValue = codeValue;
    final l$message = message;
    final l$field = field;
    return Object.hashAll([l$code, l$codeValue, l$message, l$field]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$LoginSns$loginSns$userErrors ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$code = code;
    final lOther$code = other.code;
    if (l$code != lOther$code) {
      return false;
    }
    final l$codeValue = codeValue;
    final lOther$codeValue = other.codeValue;
    if (l$codeValue != lOther$codeValue) {
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

extension UtilityExtension$Mutation$LoginSns$loginSns$userErrors
    on Mutation$LoginSns$loginSns$userErrors {
  CopyWith$Mutation$LoginSns$loginSns$userErrors<
    Mutation$LoginSns$loginSns$userErrors
  >
  get copyWith =>
      CopyWith$Mutation$LoginSns$loginSns$userErrors(this, (i) => i);
}

abstract class CopyWith$Mutation$LoginSns$loginSns$userErrors<TRes> {
  factory CopyWith$Mutation$LoginSns$loginSns$userErrors(
    Mutation$LoginSns$loginSns$userErrors instance,
    TRes Function(Mutation$LoginSns$loginSns$userErrors) then,
  ) = _CopyWithImpl$Mutation$LoginSns$loginSns$userErrors;

  factory CopyWith$Mutation$LoginSns$loginSns$userErrors.stub(TRes res) =
      _CopyWithStubImpl$Mutation$LoginSns$loginSns$userErrors;

  TRes call({
    String? code,
    Enum$ErrorCode? codeValue,
    String? message,
    String? field,
  });
}

class _CopyWithImpl$Mutation$LoginSns$loginSns$userErrors<TRes>
    implements CopyWith$Mutation$LoginSns$loginSns$userErrors<TRes> {
  _CopyWithImpl$Mutation$LoginSns$loginSns$userErrors(
    this._instance,
    this._then,
  );

  final Mutation$LoginSns$loginSns$userErrors _instance;

  final TRes Function(Mutation$LoginSns$loginSns$userErrors) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? code = _undefined,
    Object? codeValue = _undefined,
    Object? message = _undefined,
    Object? field = _undefined,
  }) => _then(
    Mutation$LoginSns$loginSns$userErrors(
      code: code == _undefined || code == null
          ? _instance.code
          : (code as String),
      codeValue: codeValue == _undefined
          ? _instance.codeValue
          : (codeValue as Enum$ErrorCode?),
      message: message == _undefined || message == null
          ? _instance.message
          : (message as String),
      field: field == _undefined ? _instance.field : (field as String?),
    ),
  );
}

class _CopyWithStubImpl$Mutation$LoginSns$loginSns$userErrors<TRes>
    implements CopyWith$Mutation$LoginSns$loginSns$userErrors<TRes> {
  _CopyWithStubImpl$Mutation$LoginSns$loginSns$userErrors(this._res);

  TRes _res;

  call({
    String? code,
    Enum$ErrorCode? codeValue,
    String? message,
    String? field,
  }) => _res;
}

class Variables$Mutation$LoginEmail {
  factory Variables$Mutation$LoginEmail({
    required Input$LoginEmailInput input,
  }) => Variables$Mutation$LoginEmail._({r'input': input});

  Variables$Mutation$LoginEmail._(this._$data);

  factory Variables$Mutation$LoginEmail.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$input = data['input'];
    result$data['input'] = Input$LoginEmailInput.fromJson(
      (l$input as Map<String, dynamic>),
    );
    return Variables$Mutation$LoginEmail._(result$data);
  }

  Map<String, dynamic> _$data;

  Input$LoginEmailInput get input => (_$data['input'] as Input$LoginEmailInput);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$input = input;
    result$data['input'] = l$input.toJson();
    return result$data;
  }

  CopyWith$Variables$Mutation$LoginEmail<Variables$Mutation$LoginEmail>
  get copyWith => CopyWith$Variables$Mutation$LoginEmail(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Mutation$LoginEmail ||
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

abstract class CopyWith$Variables$Mutation$LoginEmail<TRes> {
  factory CopyWith$Variables$Mutation$LoginEmail(
    Variables$Mutation$LoginEmail instance,
    TRes Function(Variables$Mutation$LoginEmail) then,
  ) = _CopyWithImpl$Variables$Mutation$LoginEmail;

  factory CopyWith$Variables$Mutation$LoginEmail.stub(TRes res) =
      _CopyWithStubImpl$Variables$Mutation$LoginEmail;

  TRes call({Input$LoginEmailInput? input});
}

class _CopyWithImpl$Variables$Mutation$LoginEmail<TRes>
    implements CopyWith$Variables$Mutation$LoginEmail<TRes> {
  _CopyWithImpl$Variables$Mutation$LoginEmail(this._instance, this._then);

  final Variables$Mutation$LoginEmail _instance;

  final TRes Function(Variables$Mutation$LoginEmail) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? input = _undefined}) => _then(
    Variables$Mutation$LoginEmail._({
      ..._instance._$data,
      if (input != _undefined && input != null)
        'input': (input as Input$LoginEmailInput),
    }),
  );
}

class _CopyWithStubImpl$Variables$Mutation$LoginEmail<TRes>
    implements CopyWith$Variables$Mutation$LoginEmail<TRes> {
  _CopyWithStubImpl$Variables$Mutation$LoginEmail(this._res);

  TRes _res;

  call({Input$LoginEmailInput? input}) => _res;
}

class Mutation$LoginEmail {
  Mutation$LoginEmail({required this.loginEmail});

  factory Mutation$LoginEmail.fromJson(Map<String, dynamic> json) {
    final l$loginEmail = json['loginEmail'];
    return Mutation$LoginEmail(
      loginEmail: Mutation$LoginEmail$loginEmail.fromJson(
        (l$loginEmail as Map<String, dynamic>),
      ),
    );
  }

  final Mutation$LoginEmail$loginEmail loginEmail;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$loginEmail = loginEmail;
    _resultData['loginEmail'] = l$loginEmail.toJson();
    return _resultData;
  }

  @override
  int get hashCode {
    final l$loginEmail = loginEmail;
    return Object.hashAll([l$loginEmail]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$LoginEmail || runtimeType != other.runtimeType) {
      return false;
    }
    final l$loginEmail = loginEmail;
    final lOther$loginEmail = other.loginEmail;
    if (l$loginEmail != lOther$loginEmail) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Mutation$LoginEmail on Mutation$LoginEmail {
  CopyWith$Mutation$LoginEmail<Mutation$LoginEmail> get copyWith =>
      CopyWith$Mutation$LoginEmail(this, (i) => i);
}

abstract class CopyWith$Mutation$LoginEmail<TRes> {
  factory CopyWith$Mutation$LoginEmail(
    Mutation$LoginEmail instance,
    TRes Function(Mutation$LoginEmail) then,
  ) = _CopyWithImpl$Mutation$LoginEmail;

  factory CopyWith$Mutation$LoginEmail.stub(TRes res) =
      _CopyWithStubImpl$Mutation$LoginEmail;

  TRes call({Mutation$LoginEmail$loginEmail? loginEmail});
  CopyWith$Mutation$LoginEmail$loginEmail<TRes> get loginEmail;
}

class _CopyWithImpl$Mutation$LoginEmail<TRes>
    implements CopyWith$Mutation$LoginEmail<TRes> {
  _CopyWithImpl$Mutation$LoginEmail(this._instance, this._then);

  final Mutation$LoginEmail _instance;

  final TRes Function(Mutation$LoginEmail) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? loginEmail = _undefined}) => _then(
    Mutation$LoginEmail(
      loginEmail: loginEmail == _undefined || loginEmail == null
          ? _instance.loginEmail
          : (loginEmail as Mutation$LoginEmail$loginEmail),
    ),
  );

  CopyWith$Mutation$LoginEmail$loginEmail<TRes> get loginEmail {
    final local$loginEmail = _instance.loginEmail;
    return CopyWith$Mutation$LoginEmail$loginEmail(
      local$loginEmail,
      (e) => call(loginEmail: e),
    );
  }
}

class _CopyWithStubImpl$Mutation$LoginEmail<TRes>
    implements CopyWith$Mutation$LoginEmail<TRes> {
  _CopyWithStubImpl$Mutation$LoginEmail(this._res);

  TRes _res;

  call({Mutation$LoginEmail$loginEmail? loginEmail}) => _res;

  CopyWith$Mutation$LoginEmail$loginEmail<TRes> get loginEmail =>
      CopyWith$Mutation$LoginEmail$loginEmail.stub(_res);
}

const documentNodeMutationLoginEmail = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'LoginEmail'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'input')),
          type: NamedTypeNode(
            name: NameNode(value: 'LoginEmailInput'),
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
            name: NameNode(value: 'loginEmail'),
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
                        name: NameNode(value: 'codeValue'),
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
                  name: NameNode(value: 'accessToken'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: 'refreshToken'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: 'tokenType'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: 'accessTokenExpiresIn'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: 'refreshTokenExpiresIn'),
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

class Mutation$LoginEmail$loginEmail {
  Mutation$LoginEmail$loginEmail({
    required this.success,
    required this.userErrors,
    this.accessToken,
    this.refreshToken,
    this.tokenType,
    this.accessTokenExpiresIn,
    this.refreshTokenExpiresIn,
  });

  factory Mutation$LoginEmail$loginEmail.fromJson(Map<String, dynamic> json) {
    final l$success = json['success'];
    final l$userErrors = json['userErrors'];
    final l$accessToken = json['accessToken'];
    final l$refreshToken = json['refreshToken'];
    final l$tokenType = json['tokenType'];
    final l$accessTokenExpiresIn = json['accessTokenExpiresIn'];
    final l$refreshTokenExpiresIn = json['refreshTokenExpiresIn'];
    return Mutation$LoginEmail$loginEmail(
      success: (l$success as bool),
      userErrors: (l$userErrors as List<dynamic>)
          .map(
            (e) => Mutation$LoginEmail$loginEmail$userErrors.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      accessToken: (l$accessToken as String?),
      refreshToken: (l$refreshToken as String?),
      tokenType: (l$tokenType as String?),
      accessTokenExpiresIn: (l$accessTokenExpiresIn as int?),
      refreshTokenExpiresIn: (l$refreshTokenExpiresIn as int?),
    );
  }

  final bool success;

  final List<Mutation$LoginEmail$loginEmail$userErrors> userErrors;

  final String? accessToken;

  final String? refreshToken;

  final String? tokenType;

  final int? accessTokenExpiresIn;

  final int? refreshTokenExpiresIn;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$success = success;
    _resultData['success'] = l$success;
    final l$userErrors = userErrors;
    _resultData['userErrors'] = l$userErrors.map((e) => e.toJson()).toList();
    final l$accessToken = accessToken;
    _resultData['accessToken'] = l$accessToken;
    final l$refreshToken = refreshToken;
    _resultData['refreshToken'] = l$refreshToken;
    final l$tokenType = tokenType;
    _resultData['tokenType'] = l$tokenType;
    final l$accessTokenExpiresIn = accessTokenExpiresIn;
    _resultData['accessTokenExpiresIn'] = l$accessTokenExpiresIn;
    final l$refreshTokenExpiresIn = refreshTokenExpiresIn;
    _resultData['refreshTokenExpiresIn'] = l$refreshTokenExpiresIn;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$success = success;
    final l$userErrors = userErrors;
    final l$accessToken = accessToken;
    final l$refreshToken = refreshToken;
    final l$tokenType = tokenType;
    final l$accessTokenExpiresIn = accessTokenExpiresIn;
    final l$refreshTokenExpiresIn = refreshTokenExpiresIn;
    return Object.hashAll([
      l$success,
      Object.hashAll(l$userErrors.map((v) => v)),
      l$accessToken,
      l$refreshToken,
      l$tokenType,
      l$accessTokenExpiresIn,
      l$refreshTokenExpiresIn,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$LoginEmail$loginEmail ||
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
    final l$accessToken = accessToken;
    final lOther$accessToken = other.accessToken;
    if (l$accessToken != lOther$accessToken) {
      return false;
    }
    final l$refreshToken = refreshToken;
    final lOther$refreshToken = other.refreshToken;
    if (l$refreshToken != lOther$refreshToken) {
      return false;
    }
    final l$tokenType = tokenType;
    final lOther$tokenType = other.tokenType;
    if (l$tokenType != lOther$tokenType) {
      return false;
    }
    final l$accessTokenExpiresIn = accessTokenExpiresIn;
    final lOther$accessTokenExpiresIn = other.accessTokenExpiresIn;
    if (l$accessTokenExpiresIn != lOther$accessTokenExpiresIn) {
      return false;
    }
    final l$refreshTokenExpiresIn = refreshTokenExpiresIn;
    final lOther$refreshTokenExpiresIn = other.refreshTokenExpiresIn;
    if (l$refreshTokenExpiresIn != lOther$refreshTokenExpiresIn) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Mutation$LoginEmail$loginEmail
    on Mutation$LoginEmail$loginEmail {
  CopyWith$Mutation$LoginEmail$loginEmail<Mutation$LoginEmail$loginEmail>
  get copyWith => CopyWith$Mutation$LoginEmail$loginEmail(this, (i) => i);
}

abstract class CopyWith$Mutation$LoginEmail$loginEmail<TRes> {
  factory CopyWith$Mutation$LoginEmail$loginEmail(
    Mutation$LoginEmail$loginEmail instance,
    TRes Function(Mutation$LoginEmail$loginEmail) then,
  ) = _CopyWithImpl$Mutation$LoginEmail$loginEmail;

  factory CopyWith$Mutation$LoginEmail$loginEmail.stub(TRes res) =
      _CopyWithStubImpl$Mutation$LoginEmail$loginEmail;

  TRes call({
    bool? success,
    List<Mutation$LoginEmail$loginEmail$userErrors>? userErrors,
    String? accessToken,
    String? refreshToken,
    String? tokenType,
    int? accessTokenExpiresIn,
    int? refreshTokenExpiresIn,
  });
  TRes userErrors(
    Iterable<Mutation$LoginEmail$loginEmail$userErrors> Function(
      Iterable<
        CopyWith$Mutation$LoginEmail$loginEmail$userErrors<
          Mutation$LoginEmail$loginEmail$userErrors
        >
      >,
    )
    _fn,
  );
}

class _CopyWithImpl$Mutation$LoginEmail$loginEmail<TRes>
    implements CopyWith$Mutation$LoginEmail$loginEmail<TRes> {
  _CopyWithImpl$Mutation$LoginEmail$loginEmail(this._instance, this._then);

  final Mutation$LoginEmail$loginEmail _instance;

  final TRes Function(Mutation$LoginEmail$loginEmail) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? success = _undefined,
    Object? userErrors = _undefined,
    Object? accessToken = _undefined,
    Object? refreshToken = _undefined,
    Object? tokenType = _undefined,
    Object? accessTokenExpiresIn = _undefined,
    Object? refreshTokenExpiresIn = _undefined,
  }) => _then(
    Mutation$LoginEmail$loginEmail(
      success: success == _undefined || success == null
          ? _instance.success
          : (success as bool),
      userErrors: userErrors == _undefined || userErrors == null
          ? _instance.userErrors
          : (userErrors as List<Mutation$LoginEmail$loginEmail$userErrors>),
      accessToken: accessToken == _undefined
          ? _instance.accessToken
          : (accessToken as String?),
      refreshToken: refreshToken == _undefined
          ? _instance.refreshToken
          : (refreshToken as String?),
      tokenType: tokenType == _undefined
          ? _instance.tokenType
          : (tokenType as String?),
      accessTokenExpiresIn: accessTokenExpiresIn == _undefined
          ? _instance.accessTokenExpiresIn
          : (accessTokenExpiresIn as int?),
      refreshTokenExpiresIn: refreshTokenExpiresIn == _undefined
          ? _instance.refreshTokenExpiresIn
          : (refreshTokenExpiresIn as int?),
    ),
  );

  TRes userErrors(
    Iterable<Mutation$LoginEmail$loginEmail$userErrors> Function(
      Iterable<
        CopyWith$Mutation$LoginEmail$loginEmail$userErrors<
          Mutation$LoginEmail$loginEmail$userErrors
        >
      >,
    )
    _fn,
  ) => call(
    userErrors: _fn(
      _instance.userErrors.map(
        (e) => CopyWith$Mutation$LoginEmail$loginEmail$userErrors(e, (i) => i),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl$Mutation$LoginEmail$loginEmail<TRes>
    implements CopyWith$Mutation$LoginEmail$loginEmail<TRes> {
  _CopyWithStubImpl$Mutation$LoginEmail$loginEmail(this._res);

  TRes _res;

  call({
    bool? success,
    List<Mutation$LoginEmail$loginEmail$userErrors>? userErrors,
    String? accessToken,
    String? refreshToken,
    String? tokenType,
    int? accessTokenExpiresIn,
    int? refreshTokenExpiresIn,
  }) => _res;

  userErrors(_fn) => _res;
}

class Mutation$LoginEmail$loginEmail$userErrors {
  Mutation$LoginEmail$loginEmail$userErrors({
    required this.code,
    this.codeValue,
    required this.message,
    this.field,
  });

  factory Mutation$LoginEmail$loginEmail$userErrors.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$code = json['code'];
    final l$codeValue = json['codeValue'];
    final l$message = json['message'];
    final l$field = json['field'];
    return Mutation$LoginEmail$loginEmail$userErrors(
      code: (l$code as String),
      codeValue: l$codeValue == null
          ? null
          : fromJson$Enum$ErrorCode((l$codeValue as String)),
      message: (l$message as String),
      field: (l$field as String?),
    );
  }

  final String code;

  final Enum$ErrorCode? codeValue;

  final String message;

  final String? field;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$code = code;
    _resultData['code'] = l$code;
    final l$codeValue = codeValue;
    _resultData['codeValue'] = l$codeValue == null
        ? null
        : toJson$Enum$ErrorCode(l$codeValue);
    final l$message = message;
    _resultData['message'] = l$message;
    final l$field = field;
    _resultData['field'] = l$field;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$code = code;
    final l$codeValue = codeValue;
    final l$message = message;
    final l$field = field;
    return Object.hashAll([l$code, l$codeValue, l$message, l$field]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$LoginEmail$loginEmail$userErrors ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$code = code;
    final lOther$code = other.code;
    if (l$code != lOther$code) {
      return false;
    }
    final l$codeValue = codeValue;
    final lOther$codeValue = other.codeValue;
    if (l$codeValue != lOther$codeValue) {
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

extension UtilityExtension$Mutation$LoginEmail$loginEmail$userErrors
    on Mutation$LoginEmail$loginEmail$userErrors {
  CopyWith$Mutation$LoginEmail$loginEmail$userErrors<
    Mutation$LoginEmail$loginEmail$userErrors
  >
  get copyWith =>
      CopyWith$Mutation$LoginEmail$loginEmail$userErrors(this, (i) => i);
}

abstract class CopyWith$Mutation$LoginEmail$loginEmail$userErrors<TRes> {
  factory CopyWith$Mutation$LoginEmail$loginEmail$userErrors(
    Mutation$LoginEmail$loginEmail$userErrors instance,
    TRes Function(Mutation$LoginEmail$loginEmail$userErrors) then,
  ) = _CopyWithImpl$Mutation$LoginEmail$loginEmail$userErrors;

  factory CopyWith$Mutation$LoginEmail$loginEmail$userErrors.stub(TRes res) =
      _CopyWithStubImpl$Mutation$LoginEmail$loginEmail$userErrors;

  TRes call({
    String? code,
    Enum$ErrorCode? codeValue,
    String? message,
    String? field,
  });
}

class _CopyWithImpl$Mutation$LoginEmail$loginEmail$userErrors<TRes>
    implements CopyWith$Mutation$LoginEmail$loginEmail$userErrors<TRes> {
  _CopyWithImpl$Mutation$LoginEmail$loginEmail$userErrors(
    this._instance,
    this._then,
  );

  final Mutation$LoginEmail$loginEmail$userErrors _instance;

  final TRes Function(Mutation$LoginEmail$loginEmail$userErrors) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? code = _undefined,
    Object? codeValue = _undefined,
    Object? message = _undefined,
    Object? field = _undefined,
  }) => _then(
    Mutation$LoginEmail$loginEmail$userErrors(
      code: code == _undefined || code == null
          ? _instance.code
          : (code as String),
      codeValue: codeValue == _undefined
          ? _instance.codeValue
          : (codeValue as Enum$ErrorCode?),
      message: message == _undefined || message == null
          ? _instance.message
          : (message as String),
      field: field == _undefined ? _instance.field : (field as String?),
    ),
  );
}

class _CopyWithStubImpl$Mutation$LoginEmail$loginEmail$userErrors<TRes>
    implements CopyWith$Mutation$LoginEmail$loginEmail$userErrors<TRes> {
  _CopyWithStubImpl$Mutation$LoginEmail$loginEmail$userErrors(this._res);

  TRes _res;

  call({
    String? code,
    Enum$ErrorCode? codeValue,
    String? message,
    String? field,
  }) => _res;
}

class Variables$Mutation$RefreshToken {
  factory Variables$Mutation$RefreshToken({
    required Input$RefreshTokenInput input,
  }) => Variables$Mutation$RefreshToken._({r'input': input});

  Variables$Mutation$RefreshToken._(this._$data);

  factory Variables$Mutation$RefreshToken.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$input = data['input'];
    result$data['input'] = Input$RefreshTokenInput.fromJson(
      (l$input as Map<String, dynamic>),
    );
    return Variables$Mutation$RefreshToken._(result$data);
  }

  Map<String, dynamic> _$data;

  Input$RefreshTokenInput get input =>
      (_$data['input'] as Input$RefreshTokenInput);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$input = input;
    result$data['input'] = l$input.toJson();
    return result$data;
  }

  CopyWith$Variables$Mutation$RefreshToken<Variables$Mutation$RefreshToken>
  get copyWith => CopyWith$Variables$Mutation$RefreshToken(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Mutation$RefreshToken ||
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

abstract class CopyWith$Variables$Mutation$RefreshToken<TRes> {
  factory CopyWith$Variables$Mutation$RefreshToken(
    Variables$Mutation$RefreshToken instance,
    TRes Function(Variables$Mutation$RefreshToken) then,
  ) = _CopyWithImpl$Variables$Mutation$RefreshToken;

  factory CopyWith$Variables$Mutation$RefreshToken.stub(TRes res) =
      _CopyWithStubImpl$Variables$Mutation$RefreshToken;

  TRes call({Input$RefreshTokenInput? input});
}

class _CopyWithImpl$Variables$Mutation$RefreshToken<TRes>
    implements CopyWith$Variables$Mutation$RefreshToken<TRes> {
  _CopyWithImpl$Variables$Mutation$RefreshToken(this._instance, this._then);

  final Variables$Mutation$RefreshToken _instance;

  final TRes Function(Variables$Mutation$RefreshToken) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? input = _undefined}) => _then(
    Variables$Mutation$RefreshToken._({
      ..._instance._$data,
      if (input != _undefined && input != null)
        'input': (input as Input$RefreshTokenInput),
    }),
  );
}

class _CopyWithStubImpl$Variables$Mutation$RefreshToken<TRes>
    implements CopyWith$Variables$Mutation$RefreshToken<TRes> {
  _CopyWithStubImpl$Variables$Mutation$RefreshToken(this._res);

  TRes _res;

  call({Input$RefreshTokenInput? input}) => _res;
}

class Mutation$RefreshToken {
  Mutation$RefreshToken({required this.refreshToken});

  factory Mutation$RefreshToken.fromJson(Map<String, dynamic> json) {
    final l$refreshToken = json['refreshToken'];
    return Mutation$RefreshToken(
      refreshToken: Mutation$RefreshToken$refreshToken.fromJson(
        (l$refreshToken as Map<String, dynamic>),
      ),
    );
  }

  final Mutation$RefreshToken$refreshToken refreshToken;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$refreshToken = refreshToken;
    _resultData['refreshToken'] = l$refreshToken.toJson();
    return _resultData;
  }

  @override
  int get hashCode {
    final l$refreshToken = refreshToken;
    return Object.hashAll([l$refreshToken]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$RefreshToken || runtimeType != other.runtimeType) {
      return false;
    }
    final l$refreshToken = refreshToken;
    final lOther$refreshToken = other.refreshToken;
    if (l$refreshToken != lOther$refreshToken) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Mutation$RefreshToken on Mutation$RefreshToken {
  CopyWith$Mutation$RefreshToken<Mutation$RefreshToken> get copyWith =>
      CopyWith$Mutation$RefreshToken(this, (i) => i);
}

abstract class CopyWith$Mutation$RefreshToken<TRes> {
  factory CopyWith$Mutation$RefreshToken(
    Mutation$RefreshToken instance,
    TRes Function(Mutation$RefreshToken) then,
  ) = _CopyWithImpl$Mutation$RefreshToken;

  factory CopyWith$Mutation$RefreshToken.stub(TRes res) =
      _CopyWithStubImpl$Mutation$RefreshToken;

  TRes call({Mutation$RefreshToken$refreshToken? refreshToken});
  CopyWith$Mutation$RefreshToken$refreshToken<TRes> get refreshToken;
}

class _CopyWithImpl$Mutation$RefreshToken<TRes>
    implements CopyWith$Mutation$RefreshToken<TRes> {
  _CopyWithImpl$Mutation$RefreshToken(this._instance, this._then);

  final Mutation$RefreshToken _instance;

  final TRes Function(Mutation$RefreshToken) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? refreshToken = _undefined}) => _then(
    Mutation$RefreshToken(
      refreshToken: refreshToken == _undefined || refreshToken == null
          ? _instance.refreshToken
          : (refreshToken as Mutation$RefreshToken$refreshToken),
    ),
  );

  CopyWith$Mutation$RefreshToken$refreshToken<TRes> get refreshToken {
    final local$refreshToken = _instance.refreshToken;
    return CopyWith$Mutation$RefreshToken$refreshToken(
      local$refreshToken,
      (e) => call(refreshToken: e),
    );
  }
}

class _CopyWithStubImpl$Mutation$RefreshToken<TRes>
    implements CopyWith$Mutation$RefreshToken<TRes> {
  _CopyWithStubImpl$Mutation$RefreshToken(this._res);

  TRes _res;

  call({Mutation$RefreshToken$refreshToken? refreshToken}) => _res;

  CopyWith$Mutation$RefreshToken$refreshToken<TRes> get refreshToken =>
      CopyWith$Mutation$RefreshToken$refreshToken.stub(_res);
}

const documentNodeMutationRefreshToken = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'RefreshToken'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'input')),
          type: NamedTypeNode(
            name: NameNode(value: 'RefreshTokenInput'),
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
            name: NameNode(value: 'refreshToken'),
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
                        name: NameNode(value: 'codeValue'),
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
                  name: NameNode(value: 'accessToken'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: 'refreshToken'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: 'tokenType'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: 'accessTokenExpiresIn'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: 'refreshTokenExpiresIn'),
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

class Mutation$RefreshToken$refreshToken {
  Mutation$RefreshToken$refreshToken({
    required this.success,
    required this.userErrors,
    this.accessToken,
    this.refreshToken,
    this.tokenType,
    this.accessTokenExpiresIn,
    this.refreshTokenExpiresIn,
  });

  factory Mutation$RefreshToken$refreshToken.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$success = json['success'];
    final l$userErrors = json['userErrors'];
    final l$accessToken = json['accessToken'];
    final l$refreshToken = json['refreshToken'];
    final l$tokenType = json['tokenType'];
    final l$accessTokenExpiresIn = json['accessTokenExpiresIn'];
    final l$refreshTokenExpiresIn = json['refreshTokenExpiresIn'];
    return Mutation$RefreshToken$refreshToken(
      success: (l$success as bool),
      userErrors: (l$userErrors as List<dynamic>)
          .map(
            (e) => Mutation$RefreshToken$refreshToken$userErrors.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      accessToken: (l$accessToken as String?),
      refreshToken: (l$refreshToken as String?),
      tokenType: (l$tokenType as String?),
      accessTokenExpiresIn: (l$accessTokenExpiresIn as int?),
      refreshTokenExpiresIn: (l$refreshTokenExpiresIn as int?),
    );
  }

  final bool success;

  final List<Mutation$RefreshToken$refreshToken$userErrors> userErrors;

  final String? accessToken;

  final String? refreshToken;

  final String? tokenType;

  final int? accessTokenExpiresIn;

  final int? refreshTokenExpiresIn;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$success = success;
    _resultData['success'] = l$success;
    final l$userErrors = userErrors;
    _resultData['userErrors'] = l$userErrors.map((e) => e.toJson()).toList();
    final l$accessToken = accessToken;
    _resultData['accessToken'] = l$accessToken;
    final l$refreshToken = refreshToken;
    _resultData['refreshToken'] = l$refreshToken;
    final l$tokenType = tokenType;
    _resultData['tokenType'] = l$tokenType;
    final l$accessTokenExpiresIn = accessTokenExpiresIn;
    _resultData['accessTokenExpiresIn'] = l$accessTokenExpiresIn;
    final l$refreshTokenExpiresIn = refreshTokenExpiresIn;
    _resultData['refreshTokenExpiresIn'] = l$refreshTokenExpiresIn;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$success = success;
    final l$userErrors = userErrors;
    final l$accessToken = accessToken;
    final l$refreshToken = refreshToken;
    final l$tokenType = tokenType;
    final l$accessTokenExpiresIn = accessTokenExpiresIn;
    final l$refreshTokenExpiresIn = refreshTokenExpiresIn;
    return Object.hashAll([
      l$success,
      Object.hashAll(l$userErrors.map((v) => v)),
      l$accessToken,
      l$refreshToken,
      l$tokenType,
      l$accessTokenExpiresIn,
      l$refreshTokenExpiresIn,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$RefreshToken$refreshToken ||
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
    final l$accessToken = accessToken;
    final lOther$accessToken = other.accessToken;
    if (l$accessToken != lOther$accessToken) {
      return false;
    }
    final l$refreshToken = refreshToken;
    final lOther$refreshToken = other.refreshToken;
    if (l$refreshToken != lOther$refreshToken) {
      return false;
    }
    final l$tokenType = tokenType;
    final lOther$tokenType = other.tokenType;
    if (l$tokenType != lOther$tokenType) {
      return false;
    }
    final l$accessTokenExpiresIn = accessTokenExpiresIn;
    final lOther$accessTokenExpiresIn = other.accessTokenExpiresIn;
    if (l$accessTokenExpiresIn != lOther$accessTokenExpiresIn) {
      return false;
    }
    final l$refreshTokenExpiresIn = refreshTokenExpiresIn;
    final lOther$refreshTokenExpiresIn = other.refreshTokenExpiresIn;
    if (l$refreshTokenExpiresIn != lOther$refreshTokenExpiresIn) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Mutation$RefreshToken$refreshToken
    on Mutation$RefreshToken$refreshToken {
  CopyWith$Mutation$RefreshToken$refreshToken<
    Mutation$RefreshToken$refreshToken
  >
  get copyWith => CopyWith$Mutation$RefreshToken$refreshToken(this, (i) => i);
}

abstract class CopyWith$Mutation$RefreshToken$refreshToken<TRes> {
  factory CopyWith$Mutation$RefreshToken$refreshToken(
    Mutation$RefreshToken$refreshToken instance,
    TRes Function(Mutation$RefreshToken$refreshToken) then,
  ) = _CopyWithImpl$Mutation$RefreshToken$refreshToken;

  factory CopyWith$Mutation$RefreshToken$refreshToken.stub(TRes res) =
      _CopyWithStubImpl$Mutation$RefreshToken$refreshToken;

  TRes call({
    bool? success,
    List<Mutation$RefreshToken$refreshToken$userErrors>? userErrors,
    String? accessToken,
    String? refreshToken,
    String? tokenType,
    int? accessTokenExpiresIn,
    int? refreshTokenExpiresIn,
  });
  TRes userErrors(
    Iterable<Mutation$RefreshToken$refreshToken$userErrors> Function(
      Iterable<
        CopyWith$Mutation$RefreshToken$refreshToken$userErrors<
          Mutation$RefreshToken$refreshToken$userErrors
        >
      >,
    )
    _fn,
  );
}

class _CopyWithImpl$Mutation$RefreshToken$refreshToken<TRes>
    implements CopyWith$Mutation$RefreshToken$refreshToken<TRes> {
  _CopyWithImpl$Mutation$RefreshToken$refreshToken(this._instance, this._then);

  final Mutation$RefreshToken$refreshToken _instance;

  final TRes Function(Mutation$RefreshToken$refreshToken) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? success = _undefined,
    Object? userErrors = _undefined,
    Object? accessToken = _undefined,
    Object? refreshToken = _undefined,
    Object? tokenType = _undefined,
    Object? accessTokenExpiresIn = _undefined,
    Object? refreshTokenExpiresIn = _undefined,
  }) => _then(
    Mutation$RefreshToken$refreshToken(
      success: success == _undefined || success == null
          ? _instance.success
          : (success as bool),
      userErrors: userErrors == _undefined || userErrors == null
          ? _instance.userErrors
          : (userErrors as List<Mutation$RefreshToken$refreshToken$userErrors>),
      accessToken: accessToken == _undefined
          ? _instance.accessToken
          : (accessToken as String?),
      refreshToken: refreshToken == _undefined
          ? _instance.refreshToken
          : (refreshToken as String?),
      tokenType: tokenType == _undefined
          ? _instance.tokenType
          : (tokenType as String?),
      accessTokenExpiresIn: accessTokenExpiresIn == _undefined
          ? _instance.accessTokenExpiresIn
          : (accessTokenExpiresIn as int?),
      refreshTokenExpiresIn: refreshTokenExpiresIn == _undefined
          ? _instance.refreshTokenExpiresIn
          : (refreshTokenExpiresIn as int?),
    ),
  );

  TRes userErrors(
    Iterable<Mutation$RefreshToken$refreshToken$userErrors> Function(
      Iterable<
        CopyWith$Mutation$RefreshToken$refreshToken$userErrors<
          Mutation$RefreshToken$refreshToken$userErrors
        >
      >,
    )
    _fn,
  ) => call(
    userErrors: _fn(
      _instance.userErrors.map(
        (e) =>
            CopyWith$Mutation$RefreshToken$refreshToken$userErrors(e, (i) => i),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl$Mutation$RefreshToken$refreshToken<TRes>
    implements CopyWith$Mutation$RefreshToken$refreshToken<TRes> {
  _CopyWithStubImpl$Mutation$RefreshToken$refreshToken(this._res);

  TRes _res;

  call({
    bool? success,
    List<Mutation$RefreshToken$refreshToken$userErrors>? userErrors,
    String? accessToken,
    String? refreshToken,
    String? tokenType,
    int? accessTokenExpiresIn,
    int? refreshTokenExpiresIn,
  }) => _res;

  userErrors(_fn) => _res;
}

class Mutation$RefreshToken$refreshToken$userErrors {
  Mutation$RefreshToken$refreshToken$userErrors({
    required this.code,
    this.codeValue,
    required this.message,
    this.field,
  });

  factory Mutation$RefreshToken$refreshToken$userErrors.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$code = json['code'];
    final l$codeValue = json['codeValue'];
    final l$message = json['message'];
    final l$field = json['field'];
    return Mutation$RefreshToken$refreshToken$userErrors(
      code: (l$code as String),
      codeValue: l$codeValue == null
          ? null
          : fromJson$Enum$ErrorCode((l$codeValue as String)),
      message: (l$message as String),
      field: (l$field as String?),
    );
  }

  final String code;

  final Enum$ErrorCode? codeValue;

  final String message;

  final String? field;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$code = code;
    _resultData['code'] = l$code;
    final l$codeValue = codeValue;
    _resultData['codeValue'] = l$codeValue == null
        ? null
        : toJson$Enum$ErrorCode(l$codeValue);
    final l$message = message;
    _resultData['message'] = l$message;
    final l$field = field;
    _resultData['field'] = l$field;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$code = code;
    final l$codeValue = codeValue;
    final l$message = message;
    final l$field = field;
    return Object.hashAll([l$code, l$codeValue, l$message, l$field]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$RefreshToken$refreshToken$userErrors ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$code = code;
    final lOther$code = other.code;
    if (l$code != lOther$code) {
      return false;
    }
    final l$codeValue = codeValue;
    final lOther$codeValue = other.codeValue;
    if (l$codeValue != lOther$codeValue) {
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

extension UtilityExtension$Mutation$RefreshToken$refreshToken$userErrors
    on Mutation$RefreshToken$refreshToken$userErrors {
  CopyWith$Mutation$RefreshToken$refreshToken$userErrors<
    Mutation$RefreshToken$refreshToken$userErrors
  >
  get copyWith =>
      CopyWith$Mutation$RefreshToken$refreshToken$userErrors(this, (i) => i);
}

abstract class CopyWith$Mutation$RefreshToken$refreshToken$userErrors<TRes> {
  factory CopyWith$Mutation$RefreshToken$refreshToken$userErrors(
    Mutation$RefreshToken$refreshToken$userErrors instance,
    TRes Function(Mutation$RefreshToken$refreshToken$userErrors) then,
  ) = _CopyWithImpl$Mutation$RefreshToken$refreshToken$userErrors;

  factory CopyWith$Mutation$RefreshToken$refreshToken$userErrors.stub(
    TRes res,
  ) = _CopyWithStubImpl$Mutation$RefreshToken$refreshToken$userErrors;

  TRes call({
    String? code,
    Enum$ErrorCode? codeValue,
    String? message,
    String? field,
  });
}

class _CopyWithImpl$Mutation$RefreshToken$refreshToken$userErrors<TRes>
    implements CopyWith$Mutation$RefreshToken$refreshToken$userErrors<TRes> {
  _CopyWithImpl$Mutation$RefreshToken$refreshToken$userErrors(
    this._instance,
    this._then,
  );

  final Mutation$RefreshToken$refreshToken$userErrors _instance;

  final TRes Function(Mutation$RefreshToken$refreshToken$userErrors) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? code = _undefined,
    Object? codeValue = _undefined,
    Object? message = _undefined,
    Object? field = _undefined,
  }) => _then(
    Mutation$RefreshToken$refreshToken$userErrors(
      code: code == _undefined || code == null
          ? _instance.code
          : (code as String),
      codeValue: codeValue == _undefined
          ? _instance.codeValue
          : (codeValue as Enum$ErrorCode?),
      message: message == _undefined || message == null
          ? _instance.message
          : (message as String),
      field: field == _undefined ? _instance.field : (field as String?),
    ),
  );
}

class _CopyWithStubImpl$Mutation$RefreshToken$refreshToken$userErrors<TRes>
    implements CopyWith$Mutation$RefreshToken$refreshToken$userErrors<TRes> {
  _CopyWithStubImpl$Mutation$RefreshToken$refreshToken$userErrors(this._res);

  TRes _res;

  call({
    String? code,
    Enum$ErrorCode? codeValue,
    String? message,
    String? field,
  }) => _res;
}

class Variables$Mutation$Logout {
  factory Variables$Mutation$Logout({required Input$LogoutInput input}) =>
      Variables$Mutation$Logout._({r'input': input});

  Variables$Mutation$Logout._(this._$data);

  factory Variables$Mutation$Logout.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$input = data['input'];
    result$data['input'] = Input$LogoutInput.fromJson(
      (l$input as Map<String, dynamic>),
    );
    return Variables$Mutation$Logout._(result$data);
  }

  Map<String, dynamic> _$data;

  Input$LogoutInput get input => (_$data['input'] as Input$LogoutInput);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$input = input;
    result$data['input'] = l$input.toJson();
    return result$data;
  }

  CopyWith$Variables$Mutation$Logout<Variables$Mutation$Logout> get copyWith =>
      CopyWith$Variables$Mutation$Logout(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Mutation$Logout ||
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

abstract class CopyWith$Variables$Mutation$Logout<TRes> {
  factory CopyWith$Variables$Mutation$Logout(
    Variables$Mutation$Logout instance,
    TRes Function(Variables$Mutation$Logout) then,
  ) = _CopyWithImpl$Variables$Mutation$Logout;

  factory CopyWith$Variables$Mutation$Logout.stub(TRes res) =
      _CopyWithStubImpl$Variables$Mutation$Logout;

  TRes call({Input$LogoutInput? input});
}

class _CopyWithImpl$Variables$Mutation$Logout<TRes>
    implements CopyWith$Variables$Mutation$Logout<TRes> {
  _CopyWithImpl$Variables$Mutation$Logout(this._instance, this._then);

  final Variables$Mutation$Logout _instance;

  final TRes Function(Variables$Mutation$Logout) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? input = _undefined}) => _then(
    Variables$Mutation$Logout._({
      ..._instance._$data,
      if (input != _undefined && input != null)
        'input': (input as Input$LogoutInput),
    }),
  );
}

class _CopyWithStubImpl$Variables$Mutation$Logout<TRes>
    implements CopyWith$Variables$Mutation$Logout<TRes> {
  _CopyWithStubImpl$Variables$Mutation$Logout(this._res);

  TRes _res;

  call({Input$LogoutInput? input}) => _res;
}

class Mutation$Logout {
  Mutation$Logout({required this.logout});

  factory Mutation$Logout.fromJson(Map<String, dynamic> json) {
    final l$logout = json['logout'];
    return Mutation$Logout(
      logout: Mutation$Logout$logout.fromJson(
        (l$logout as Map<String, dynamic>),
      ),
    );
  }

  final Mutation$Logout$logout logout;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$logout = logout;
    _resultData['logout'] = l$logout.toJson();
    return _resultData;
  }

  @override
  int get hashCode {
    final l$logout = logout;
    return Object.hashAll([l$logout]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$Logout || runtimeType != other.runtimeType) {
      return false;
    }
    final l$logout = logout;
    final lOther$logout = other.logout;
    if (l$logout != lOther$logout) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Mutation$Logout on Mutation$Logout {
  CopyWith$Mutation$Logout<Mutation$Logout> get copyWith =>
      CopyWith$Mutation$Logout(this, (i) => i);
}

abstract class CopyWith$Mutation$Logout<TRes> {
  factory CopyWith$Mutation$Logout(
    Mutation$Logout instance,
    TRes Function(Mutation$Logout) then,
  ) = _CopyWithImpl$Mutation$Logout;

  factory CopyWith$Mutation$Logout.stub(TRes res) =
      _CopyWithStubImpl$Mutation$Logout;

  TRes call({Mutation$Logout$logout? logout});
  CopyWith$Mutation$Logout$logout<TRes> get logout;
}

class _CopyWithImpl$Mutation$Logout<TRes>
    implements CopyWith$Mutation$Logout<TRes> {
  _CopyWithImpl$Mutation$Logout(this._instance, this._then);

  final Mutation$Logout _instance;

  final TRes Function(Mutation$Logout) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? logout = _undefined}) => _then(
    Mutation$Logout(
      logout: logout == _undefined || logout == null
          ? _instance.logout
          : (logout as Mutation$Logout$logout),
    ),
  );

  CopyWith$Mutation$Logout$logout<TRes> get logout {
    final local$logout = _instance.logout;
    return CopyWith$Mutation$Logout$logout(
      local$logout,
      (e) => call(logout: e),
    );
  }
}

class _CopyWithStubImpl$Mutation$Logout<TRes>
    implements CopyWith$Mutation$Logout<TRes> {
  _CopyWithStubImpl$Mutation$Logout(this._res);

  TRes _res;

  call({Mutation$Logout$logout? logout}) => _res;

  CopyWith$Mutation$Logout$logout<TRes> get logout =>
      CopyWith$Mutation$Logout$logout.stub(_res);
}

const documentNodeMutationLogout = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'Logout'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'input')),
          type: NamedTypeNode(
            name: NameNode(value: 'LogoutInput'),
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
            name: NameNode(value: 'logout'),
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
                        name: NameNode(value: 'codeValue'),
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

class Mutation$Logout$logout {
  Mutation$Logout$logout({required this.success, required this.userErrors});

  factory Mutation$Logout$logout.fromJson(Map<String, dynamic> json) {
    final l$success = json['success'];
    final l$userErrors = json['userErrors'];
    return Mutation$Logout$logout(
      success: (l$success as bool),
      userErrors: (l$userErrors as List<dynamic>)
          .map(
            (e) => Mutation$Logout$logout$userErrors.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
    );
  }

  final bool success;

  final List<Mutation$Logout$logout$userErrors> userErrors;

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
    if (other is! Mutation$Logout$logout || runtimeType != other.runtimeType) {
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

extension UtilityExtension$Mutation$Logout$logout on Mutation$Logout$logout {
  CopyWith$Mutation$Logout$logout<Mutation$Logout$logout> get copyWith =>
      CopyWith$Mutation$Logout$logout(this, (i) => i);
}

abstract class CopyWith$Mutation$Logout$logout<TRes> {
  factory CopyWith$Mutation$Logout$logout(
    Mutation$Logout$logout instance,
    TRes Function(Mutation$Logout$logout) then,
  ) = _CopyWithImpl$Mutation$Logout$logout;

  factory CopyWith$Mutation$Logout$logout.stub(TRes res) =
      _CopyWithStubImpl$Mutation$Logout$logout;

  TRes call({
    bool? success,
    List<Mutation$Logout$logout$userErrors>? userErrors,
  });
  TRes userErrors(
    Iterable<Mutation$Logout$logout$userErrors> Function(
      Iterable<
        CopyWith$Mutation$Logout$logout$userErrors<
          Mutation$Logout$logout$userErrors
        >
      >,
    )
    _fn,
  );
}

class _CopyWithImpl$Mutation$Logout$logout<TRes>
    implements CopyWith$Mutation$Logout$logout<TRes> {
  _CopyWithImpl$Mutation$Logout$logout(this._instance, this._then);

  final Mutation$Logout$logout _instance;

  final TRes Function(Mutation$Logout$logout) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? success = _undefined, Object? userErrors = _undefined}) =>
      _then(
        Mutation$Logout$logout(
          success: success == _undefined || success == null
              ? _instance.success
              : (success as bool),
          userErrors: userErrors == _undefined || userErrors == null
              ? _instance.userErrors
              : (userErrors as List<Mutation$Logout$logout$userErrors>),
        ),
      );

  TRes userErrors(
    Iterable<Mutation$Logout$logout$userErrors> Function(
      Iterable<
        CopyWith$Mutation$Logout$logout$userErrors<
          Mutation$Logout$logout$userErrors
        >
      >,
    )
    _fn,
  ) => call(
    userErrors: _fn(
      _instance.userErrors.map(
        (e) => CopyWith$Mutation$Logout$logout$userErrors(e, (i) => i),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl$Mutation$Logout$logout<TRes>
    implements CopyWith$Mutation$Logout$logout<TRes> {
  _CopyWithStubImpl$Mutation$Logout$logout(this._res);

  TRes _res;

  call({bool? success, List<Mutation$Logout$logout$userErrors>? userErrors}) =>
      _res;

  userErrors(_fn) => _res;
}

class Mutation$Logout$logout$userErrors {
  Mutation$Logout$logout$userErrors({
    required this.code,
    this.codeValue,
    required this.message,
    this.field,
  });

  factory Mutation$Logout$logout$userErrors.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$code = json['code'];
    final l$codeValue = json['codeValue'];
    final l$message = json['message'];
    final l$field = json['field'];
    return Mutation$Logout$logout$userErrors(
      code: (l$code as String),
      codeValue: l$codeValue == null
          ? null
          : fromJson$Enum$ErrorCode((l$codeValue as String)),
      message: (l$message as String),
      field: (l$field as String?),
    );
  }

  final String code;

  final Enum$ErrorCode? codeValue;

  final String message;

  final String? field;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$code = code;
    _resultData['code'] = l$code;
    final l$codeValue = codeValue;
    _resultData['codeValue'] = l$codeValue == null
        ? null
        : toJson$Enum$ErrorCode(l$codeValue);
    final l$message = message;
    _resultData['message'] = l$message;
    final l$field = field;
    _resultData['field'] = l$field;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$code = code;
    final l$codeValue = codeValue;
    final l$message = message;
    final l$field = field;
    return Object.hashAll([l$code, l$codeValue, l$message, l$field]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$Logout$logout$userErrors ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$code = code;
    final lOther$code = other.code;
    if (l$code != lOther$code) {
      return false;
    }
    final l$codeValue = codeValue;
    final lOther$codeValue = other.codeValue;
    if (l$codeValue != lOther$codeValue) {
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

extension UtilityExtension$Mutation$Logout$logout$userErrors
    on Mutation$Logout$logout$userErrors {
  CopyWith$Mutation$Logout$logout$userErrors<Mutation$Logout$logout$userErrors>
  get copyWith => CopyWith$Mutation$Logout$logout$userErrors(this, (i) => i);
}

abstract class CopyWith$Mutation$Logout$logout$userErrors<TRes> {
  factory CopyWith$Mutation$Logout$logout$userErrors(
    Mutation$Logout$logout$userErrors instance,
    TRes Function(Mutation$Logout$logout$userErrors) then,
  ) = _CopyWithImpl$Mutation$Logout$logout$userErrors;

  factory CopyWith$Mutation$Logout$logout$userErrors.stub(TRes res) =
      _CopyWithStubImpl$Mutation$Logout$logout$userErrors;

  TRes call({
    String? code,
    Enum$ErrorCode? codeValue,
    String? message,
    String? field,
  });
}

class _CopyWithImpl$Mutation$Logout$logout$userErrors<TRes>
    implements CopyWith$Mutation$Logout$logout$userErrors<TRes> {
  _CopyWithImpl$Mutation$Logout$logout$userErrors(this._instance, this._then);

  final Mutation$Logout$logout$userErrors _instance;

  final TRes Function(Mutation$Logout$logout$userErrors) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? code = _undefined,
    Object? codeValue = _undefined,
    Object? message = _undefined,
    Object? field = _undefined,
  }) => _then(
    Mutation$Logout$logout$userErrors(
      code: code == _undefined || code == null
          ? _instance.code
          : (code as String),
      codeValue: codeValue == _undefined
          ? _instance.codeValue
          : (codeValue as Enum$ErrorCode?),
      message: message == _undefined || message == null
          ? _instance.message
          : (message as String),
      field: field == _undefined ? _instance.field : (field as String?),
    ),
  );
}

class _CopyWithStubImpl$Mutation$Logout$logout$userErrors<TRes>
    implements CopyWith$Mutation$Logout$logout$userErrors<TRes> {
  _CopyWithStubImpl$Mutation$Logout$logout$userErrors(this._res);

  TRes _res;

  call({
    String? code,
    Enum$ErrorCode? codeValue,
    String? message,
    String? field,
  }) => _res;
}

class Variables$Mutation$RequestPasswordReset {
  factory Variables$Mutation$RequestPasswordReset({
    required Input$RequestPasswordResetInput input,
  }) => Variables$Mutation$RequestPasswordReset._({r'input': input});

  Variables$Mutation$RequestPasswordReset._(this._$data);

  factory Variables$Mutation$RequestPasswordReset.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    final l$input = data['input'];
    result$data['input'] = Input$RequestPasswordResetInput.fromJson(
      (l$input as Map<String, dynamic>),
    );
    return Variables$Mutation$RequestPasswordReset._(result$data);
  }

  Map<String, dynamic> _$data;

  Input$RequestPasswordResetInput get input =>
      (_$data['input'] as Input$RequestPasswordResetInput);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$input = input;
    result$data['input'] = l$input.toJson();
    return result$data;
  }

  CopyWith$Variables$Mutation$RequestPasswordReset<
    Variables$Mutation$RequestPasswordReset
  >
  get copyWith =>
      CopyWith$Variables$Mutation$RequestPasswordReset(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Mutation$RequestPasswordReset ||
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

abstract class CopyWith$Variables$Mutation$RequestPasswordReset<TRes> {
  factory CopyWith$Variables$Mutation$RequestPasswordReset(
    Variables$Mutation$RequestPasswordReset instance,
    TRes Function(Variables$Mutation$RequestPasswordReset) then,
  ) = _CopyWithImpl$Variables$Mutation$RequestPasswordReset;

  factory CopyWith$Variables$Mutation$RequestPasswordReset.stub(TRes res) =
      _CopyWithStubImpl$Variables$Mutation$RequestPasswordReset;

  TRes call({Input$RequestPasswordResetInput? input});
}

class _CopyWithImpl$Variables$Mutation$RequestPasswordReset<TRes>
    implements CopyWith$Variables$Mutation$RequestPasswordReset<TRes> {
  _CopyWithImpl$Variables$Mutation$RequestPasswordReset(
    this._instance,
    this._then,
  );

  final Variables$Mutation$RequestPasswordReset _instance;

  final TRes Function(Variables$Mutation$RequestPasswordReset) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? input = _undefined}) => _then(
    Variables$Mutation$RequestPasswordReset._({
      ..._instance._$data,
      if (input != _undefined && input != null)
        'input': (input as Input$RequestPasswordResetInput),
    }),
  );
}

class _CopyWithStubImpl$Variables$Mutation$RequestPasswordReset<TRes>
    implements CopyWith$Variables$Mutation$RequestPasswordReset<TRes> {
  _CopyWithStubImpl$Variables$Mutation$RequestPasswordReset(this._res);

  TRes _res;

  call({Input$RequestPasswordResetInput? input}) => _res;
}

class Mutation$RequestPasswordReset {
  Mutation$RequestPasswordReset({required this.requestPasswordReset});

  factory Mutation$RequestPasswordReset.fromJson(Map<String, dynamic> json) {
    final l$requestPasswordReset = json['requestPasswordReset'];
    return Mutation$RequestPasswordReset(
      requestPasswordReset:
          Mutation$RequestPasswordReset$requestPasswordReset.fromJson(
            (l$requestPasswordReset as Map<String, dynamic>),
          ),
    );
  }

  final Mutation$RequestPasswordReset$requestPasswordReset requestPasswordReset;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$requestPasswordReset = requestPasswordReset;
    _resultData['requestPasswordReset'] = l$requestPasswordReset.toJson();
    return _resultData;
  }

  @override
  int get hashCode {
    final l$requestPasswordReset = requestPasswordReset;
    return Object.hashAll([l$requestPasswordReset]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$RequestPasswordReset ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$requestPasswordReset = requestPasswordReset;
    final lOther$requestPasswordReset = other.requestPasswordReset;
    if (l$requestPasswordReset != lOther$requestPasswordReset) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Mutation$RequestPasswordReset
    on Mutation$RequestPasswordReset {
  CopyWith$Mutation$RequestPasswordReset<Mutation$RequestPasswordReset>
  get copyWith => CopyWith$Mutation$RequestPasswordReset(this, (i) => i);
}

abstract class CopyWith$Mutation$RequestPasswordReset<TRes> {
  factory CopyWith$Mutation$RequestPasswordReset(
    Mutation$RequestPasswordReset instance,
    TRes Function(Mutation$RequestPasswordReset) then,
  ) = _CopyWithImpl$Mutation$RequestPasswordReset;

  factory CopyWith$Mutation$RequestPasswordReset.stub(TRes res) =
      _CopyWithStubImpl$Mutation$RequestPasswordReset;

  TRes call({
    Mutation$RequestPasswordReset$requestPasswordReset? requestPasswordReset,
  });
  CopyWith$Mutation$RequestPasswordReset$requestPasswordReset<TRes>
  get requestPasswordReset;
}

class _CopyWithImpl$Mutation$RequestPasswordReset<TRes>
    implements CopyWith$Mutation$RequestPasswordReset<TRes> {
  _CopyWithImpl$Mutation$RequestPasswordReset(this._instance, this._then);

  final Mutation$RequestPasswordReset _instance;

  final TRes Function(Mutation$RequestPasswordReset) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? requestPasswordReset = _undefined}) => _then(
    Mutation$RequestPasswordReset(
      requestPasswordReset:
          requestPasswordReset == _undefined || requestPasswordReset == null
          ? _instance.requestPasswordReset
          : (requestPasswordReset
                as Mutation$RequestPasswordReset$requestPasswordReset),
    ),
  );

  CopyWith$Mutation$RequestPasswordReset$requestPasswordReset<TRes>
  get requestPasswordReset {
    final local$requestPasswordReset = _instance.requestPasswordReset;
    return CopyWith$Mutation$RequestPasswordReset$requestPasswordReset(
      local$requestPasswordReset,
      (e) => call(requestPasswordReset: e),
    );
  }
}

class _CopyWithStubImpl$Mutation$RequestPasswordReset<TRes>
    implements CopyWith$Mutation$RequestPasswordReset<TRes> {
  _CopyWithStubImpl$Mutation$RequestPasswordReset(this._res);

  TRes _res;

  call({
    Mutation$RequestPasswordReset$requestPasswordReset? requestPasswordReset,
  }) => _res;

  CopyWith$Mutation$RequestPasswordReset$requestPasswordReset<TRes>
  get requestPasswordReset =>
      CopyWith$Mutation$RequestPasswordReset$requestPasswordReset.stub(_res);
}

const documentNodeMutationRequestPasswordReset = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'RequestPasswordReset'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'input')),
          type: NamedTypeNode(
            name: NameNode(value: 'RequestPasswordResetInput'),
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
            name: NameNode(value: 'requestPasswordReset'),
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
                        name: NameNode(value: 'codeValue'),
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

class Mutation$RequestPasswordReset$requestPasswordReset {
  Mutation$RequestPasswordReset$requestPasswordReset({
    required this.success,
    required this.userErrors,
  });

  factory Mutation$RequestPasswordReset$requestPasswordReset.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$success = json['success'];
    final l$userErrors = json['userErrors'];
    return Mutation$RequestPasswordReset$requestPasswordReset(
      success: (l$success as bool),
      userErrors: (l$userErrors as List<dynamic>)
          .map(
            (e) =>
                Mutation$RequestPasswordReset$requestPasswordReset$userErrors.fromJson(
                  (e as Map<String, dynamic>),
                ),
          )
          .toList(),
    );
  }

  final bool success;

  final List<Mutation$RequestPasswordReset$requestPasswordReset$userErrors>
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
    if (other is! Mutation$RequestPasswordReset$requestPasswordReset ||
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

extension UtilityExtension$Mutation$RequestPasswordReset$requestPasswordReset
    on Mutation$RequestPasswordReset$requestPasswordReset {
  CopyWith$Mutation$RequestPasswordReset$requestPasswordReset<
    Mutation$RequestPasswordReset$requestPasswordReset
  >
  get copyWith => CopyWith$Mutation$RequestPasswordReset$requestPasswordReset(
    this,
    (i) => i,
  );
}

abstract class CopyWith$Mutation$RequestPasswordReset$requestPasswordReset<
  TRes
> {
  factory CopyWith$Mutation$RequestPasswordReset$requestPasswordReset(
    Mutation$RequestPasswordReset$requestPasswordReset instance,
    TRes Function(Mutation$RequestPasswordReset$requestPasswordReset) then,
  ) = _CopyWithImpl$Mutation$RequestPasswordReset$requestPasswordReset;

  factory CopyWith$Mutation$RequestPasswordReset$requestPasswordReset.stub(
    TRes res,
  ) = _CopyWithStubImpl$Mutation$RequestPasswordReset$requestPasswordReset;

  TRes call({
    bool? success,
    List<Mutation$RequestPasswordReset$requestPasswordReset$userErrors>?
    userErrors,
  });
  TRes userErrors(
    Iterable<Mutation$RequestPasswordReset$requestPasswordReset$userErrors>
    Function(
      Iterable<
        CopyWith$Mutation$RequestPasswordReset$requestPasswordReset$userErrors<
          Mutation$RequestPasswordReset$requestPasswordReset$userErrors
        >
      >,
    )
    _fn,
  );
}

class _CopyWithImpl$Mutation$RequestPasswordReset$requestPasswordReset<TRes>
    implements
        CopyWith$Mutation$RequestPasswordReset$requestPasswordReset<TRes> {
  _CopyWithImpl$Mutation$RequestPasswordReset$requestPasswordReset(
    this._instance,
    this._then,
  );

  final Mutation$RequestPasswordReset$requestPasswordReset _instance;

  final TRes Function(Mutation$RequestPasswordReset$requestPasswordReset) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? success = _undefined,
    Object? userErrors = _undefined,
  }) => _then(
    Mutation$RequestPasswordReset$requestPasswordReset(
      success: success == _undefined || success == null
          ? _instance.success
          : (success as bool),
      userErrors: userErrors == _undefined || userErrors == null
          ? _instance.userErrors
          : (userErrors
                as List<
                  Mutation$RequestPasswordReset$requestPasswordReset$userErrors
                >),
    ),
  );

  TRes userErrors(
    Iterable<Mutation$RequestPasswordReset$requestPasswordReset$userErrors>
    Function(
      Iterable<
        CopyWith$Mutation$RequestPasswordReset$requestPasswordReset$userErrors<
          Mutation$RequestPasswordReset$requestPasswordReset$userErrors
        >
      >,
    )
    _fn,
  ) => call(
    userErrors: _fn(
      _instance.userErrors.map(
        (e) =>
            CopyWith$Mutation$RequestPasswordReset$requestPasswordReset$userErrors(
              e,
              (i) => i,
            ),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl$Mutation$RequestPasswordReset$requestPasswordReset<TRes>
    implements
        CopyWith$Mutation$RequestPasswordReset$requestPasswordReset<TRes> {
  _CopyWithStubImpl$Mutation$RequestPasswordReset$requestPasswordReset(
    this._res,
  );

  TRes _res;

  call({
    bool? success,
    List<Mutation$RequestPasswordReset$requestPasswordReset$userErrors>?
    userErrors,
  }) => _res;

  userErrors(_fn) => _res;
}

class Mutation$RequestPasswordReset$requestPasswordReset$userErrors {
  Mutation$RequestPasswordReset$requestPasswordReset$userErrors({
    required this.code,
    this.codeValue,
    required this.message,
    this.field,
  });

  factory Mutation$RequestPasswordReset$requestPasswordReset$userErrors.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$code = json['code'];
    final l$codeValue = json['codeValue'];
    final l$message = json['message'];
    final l$field = json['field'];
    return Mutation$RequestPasswordReset$requestPasswordReset$userErrors(
      code: (l$code as String),
      codeValue: l$codeValue == null
          ? null
          : fromJson$Enum$ErrorCode((l$codeValue as String)),
      message: (l$message as String),
      field: (l$field as String?),
    );
  }

  final String code;

  final Enum$ErrorCode? codeValue;

  final String message;

  final String? field;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$code = code;
    _resultData['code'] = l$code;
    final l$codeValue = codeValue;
    _resultData['codeValue'] = l$codeValue == null
        ? null
        : toJson$Enum$ErrorCode(l$codeValue);
    final l$message = message;
    _resultData['message'] = l$message;
    final l$field = field;
    _resultData['field'] = l$field;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$code = code;
    final l$codeValue = codeValue;
    final l$message = message;
    final l$field = field;
    return Object.hashAll([l$code, l$codeValue, l$message, l$field]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Mutation$RequestPasswordReset$requestPasswordReset$userErrors ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$code = code;
    final lOther$code = other.code;
    if (l$code != lOther$code) {
      return false;
    }
    final l$codeValue = codeValue;
    final lOther$codeValue = other.codeValue;
    if (l$codeValue != lOther$codeValue) {
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

extension UtilityExtension$Mutation$RequestPasswordReset$requestPasswordReset$userErrors
    on Mutation$RequestPasswordReset$requestPasswordReset$userErrors {
  CopyWith$Mutation$RequestPasswordReset$requestPasswordReset$userErrors<
    Mutation$RequestPasswordReset$requestPasswordReset$userErrors
  >
  get copyWith =>
      CopyWith$Mutation$RequestPasswordReset$requestPasswordReset$userErrors(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Mutation$RequestPasswordReset$requestPasswordReset$userErrors<
  TRes
> {
  factory CopyWith$Mutation$RequestPasswordReset$requestPasswordReset$userErrors(
    Mutation$RequestPasswordReset$requestPasswordReset$userErrors instance,
    TRes Function(Mutation$RequestPasswordReset$requestPasswordReset$userErrors)
    then,
  ) = _CopyWithImpl$Mutation$RequestPasswordReset$requestPasswordReset$userErrors;

  factory CopyWith$Mutation$RequestPasswordReset$requestPasswordReset$userErrors.stub(
    TRes res,
  ) = _CopyWithStubImpl$Mutation$RequestPasswordReset$requestPasswordReset$userErrors;

  TRes call({
    String? code,
    Enum$ErrorCode? codeValue,
    String? message,
    String? field,
  });
}

class _CopyWithImpl$Mutation$RequestPasswordReset$requestPasswordReset$userErrors<
  TRes
>
    implements
        CopyWith$Mutation$RequestPasswordReset$requestPasswordReset$userErrors<
          TRes
        > {
  _CopyWithImpl$Mutation$RequestPasswordReset$requestPasswordReset$userErrors(
    this._instance,
    this._then,
  );

  final Mutation$RequestPasswordReset$requestPasswordReset$userErrors _instance;

  final TRes Function(
    Mutation$RequestPasswordReset$requestPasswordReset$userErrors,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? code = _undefined,
    Object? codeValue = _undefined,
    Object? message = _undefined,
    Object? field = _undefined,
  }) => _then(
    Mutation$RequestPasswordReset$requestPasswordReset$userErrors(
      code: code == _undefined || code == null
          ? _instance.code
          : (code as String),
      codeValue: codeValue == _undefined
          ? _instance.codeValue
          : (codeValue as Enum$ErrorCode?),
      message: message == _undefined || message == null
          ? _instance.message
          : (message as String),
      field: field == _undefined ? _instance.field : (field as String?),
    ),
  );
}

class _CopyWithStubImpl$Mutation$RequestPasswordReset$requestPasswordReset$userErrors<
  TRes
>
    implements
        CopyWith$Mutation$RequestPasswordReset$requestPasswordReset$userErrors<
          TRes
        > {
  _CopyWithStubImpl$Mutation$RequestPasswordReset$requestPasswordReset$userErrors(
    this._res,
  );

  TRes _res;

  call({
    String? code,
    Enum$ErrorCode? codeValue,
    String? message,
    String? field,
  }) => _res;
}

class Variables$Mutation$ResetPassword {
  factory Variables$Mutation$ResetPassword({
    required Input$ResetPasswordInput input,
  }) => Variables$Mutation$ResetPassword._({r'input': input});

  Variables$Mutation$ResetPassword._(this._$data);

  factory Variables$Mutation$ResetPassword.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$input = data['input'];
    result$data['input'] = Input$ResetPasswordInput.fromJson(
      (l$input as Map<String, dynamic>),
    );
    return Variables$Mutation$ResetPassword._(result$data);
  }

  Map<String, dynamic> _$data;

  Input$ResetPasswordInput get input =>
      (_$data['input'] as Input$ResetPasswordInput);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$input = input;
    result$data['input'] = l$input.toJson();
    return result$data;
  }

  CopyWith$Variables$Mutation$ResetPassword<Variables$Mutation$ResetPassword>
  get copyWith => CopyWith$Variables$Mutation$ResetPassword(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Mutation$ResetPassword ||
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

abstract class CopyWith$Variables$Mutation$ResetPassword<TRes> {
  factory CopyWith$Variables$Mutation$ResetPassword(
    Variables$Mutation$ResetPassword instance,
    TRes Function(Variables$Mutation$ResetPassword) then,
  ) = _CopyWithImpl$Variables$Mutation$ResetPassword;

  factory CopyWith$Variables$Mutation$ResetPassword.stub(TRes res) =
      _CopyWithStubImpl$Variables$Mutation$ResetPassword;

  TRes call({Input$ResetPasswordInput? input});
}

class _CopyWithImpl$Variables$Mutation$ResetPassword<TRes>
    implements CopyWith$Variables$Mutation$ResetPassword<TRes> {
  _CopyWithImpl$Variables$Mutation$ResetPassword(this._instance, this._then);

  final Variables$Mutation$ResetPassword _instance;

  final TRes Function(Variables$Mutation$ResetPassword) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? input = _undefined}) => _then(
    Variables$Mutation$ResetPassword._({
      ..._instance._$data,
      if (input != _undefined && input != null)
        'input': (input as Input$ResetPasswordInput),
    }),
  );
}

class _CopyWithStubImpl$Variables$Mutation$ResetPassword<TRes>
    implements CopyWith$Variables$Mutation$ResetPassword<TRes> {
  _CopyWithStubImpl$Variables$Mutation$ResetPassword(this._res);

  TRes _res;

  call({Input$ResetPasswordInput? input}) => _res;
}

class Mutation$ResetPassword {
  Mutation$ResetPassword({required this.resetPassword});

  factory Mutation$ResetPassword.fromJson(Map<String, dynamic> json) {
    final l$resetPassword = json['resetPassword'];
    return Mutation$ResetPassword(
      resetPassword: Mutation$ResetPassword$resetPassword.fromJson(
        (l$resetPassword as Map<String, dynamic>),
      ),
    );
  }

  final Mutation$ResetPassword$resetPassword resetPassword;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$resetPassword = resetPassword;
    _resultData['resetPassword'] = l$resetPassword.toJson();
    return _resultData;
  }

  @override
  int get hashCode {
    final l$resetPassword = resetPassword;
    return Object.hashAll([l$resetPassword]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$ResetPassword || runtimeType != other.runtimeType) {
      return false;
    }
    final l$resetPassword = resetPassword;
    final lOther$resetPassword = other.resetPassword;
    if (l$resetPassword != lOther$resetPassword) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Mutation$ResetPassword on Mutation$ResetPassword {
  CopyWith$Mutation$ResetPassword<Mutation$ResetPassword> get copyWith =>
      CopyWith$Mutation$ResetPassword(this, (i) => i);
}

abstract class CopyWith$Mutation$ResetPassword<TRes> {
  factory CopyWith$Mutation$ResetPassword(
    Mutation$ResetPassword instance,
    TRes Function(Mutation$ResetPassword) then,
  ) = _CopyWithImpl$Mutation$ResetPassword;

  factory CopyWith$Mutation$ResetPassword.stub(TRes res) =
      _CopyWithStubImpl$Mutation$ResetPassword;

  TRes call({Mutation$ResetPassword$resetPassword? resetPassword});
  CopyWith$Mutation$ResetPassword$resetPassword<TRes> get resetPassword;
}

class _CopyWithImpl$Mutation$ResetPassword<TRes>
    implements CopyWith$Mutation$ResetPassword<TRes> {
  _CopyWithImpl$Mutation$ResetPassword(this._instance, this._then);

  final Mutation$ResetPassword _instance;

  final TRes Function(Mutation$ResetPassword) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? resetPassword = _undefined}) => _then(
    Mutation$ResetPassword(
      resetPassword: resetPassword == _undefined || resetPassword == null
          ? _instance.resetPassword
          : (resetPassword as Mutation$ResetPassword$resetPassword),
    ),
  );

  CopyWith$Mutation$ResetPassword$resetPassword<TRes> get resetPassword {
    final local$resetPassword = _instance.resetPassword;
    return CopyWith$Mutation$ResetPassword$resetPassword(
      local$resetPassword,
      (e) => call(resetPassword: e),
    );
  }
}

class _CopyWithStubImpl$Mutation$ResetPassword<TRes>
    implements CopyWith$Mutation$ResetPassword<TRes> {
  _CopyWithStubImpl$Mutation$ResetPassword(this._res);

  TRes _res;

  call({Mutation$ResetPassword$resetPassword? resetPassword}) => _res;

  CopyWith$Mutation$ResetPassword$resetPassword<TRes> get resetPassword =>
      CopyWith$Mutation$ResetPassword$resetPassword.stub(_res);
}

const documentNodeMutationResetPassword = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'ResetPassword'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'input')),
          type: NamedTypeNode(
            name: NameNode(value: 'ResetPasswordInput'),
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
            name: NameNode(value: 'resetPassword'),
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
                        name: NameNode(value: 'codeValue'),
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
                  name: NameNode(value: 'failureReason'),
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

class Mutation$ResetPassword$resetPassword {
  Mutation$ResetPassword$resetPassword({
    required this.success,
    required this.userErrors,
    this.failureReason,
  });

  factory Mutation$ResetPassword$resetPassword.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$success = json['success'];
    final l$userErrors = json['userErrors'];
    final l$failureReason = json['failureReason'];
    return Mutation$ResetPassword$resetPassword(
      success: (l$success as bool),
      userErrors: (l$userErrors as List<dynamic>)
          .map(
            (e) => Mutation$ResetPassword$resetPassword$userErrors.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      failureReason: (l$failureReason as String?),
    );
  }

  final bool success;

  final List<Mutation$ResetPassword$resetPassword$userErrors> userErrors;

  final String? failureReason;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$success = success;
    _resultData['success'] = l$success;
    final l$userErrors = userErrors;
    _resultData['userErrors'] = l$userErrors.map((e) => e.toJson()).toList();
    final l$failureReason = failureReason;
    _resultData['failureReason'] = l$failureReason;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$success = success;
    final l$userErrors = userErrors;
    final l$failureReason = failureReason;
    return Object.hashAll([
      l$success,
      Object.hashAll(l$userErrors.map((v) => v)),
      l$failureReason,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$ResetPassword$resetPassword ||
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
    final l$failureReason = failureReason;
    final lOther$failureReason = other.failureReason;
    if (l$failureReason != lOther$failureReason) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Mutation$ResetPassword$resetPassword
    on Mutation$ResetPassword$resetPassword {
  CopyWith$Mutation$ResetPassword$resetPassword<
    Mutation$ResetPassword$resetPassword
  >
  get copyWith => CopyWith$Mutation$ResetPassword$resetPassword(this, (i) => i);
}

abstract class CopyWith$Mutation$ResetPassword$resetPassword<TRes> {
  factory CopyWith$Mutation$ResetPassword$resetPassword(
    Mutation$ResetPassword$resetPassword instance,
    TRes Function(Mutation$ResetPassword$resetPassword) then,
  ) = _CopyWithImpl$Mutation$ResetPassword$resetPassword;

  factory CopyWith$Mutation$ResetPassword$resetPassword.stub(TRes res) =
      _CopyWithStubImpl$Mutation$ResetPassword$resetPassword;

  TRes call({
    bool? success,
    List<Mutation$ResetPassword$resetPassword$userErrors>? userErrors,
    String? failureReason,
  });
  TRes userErrors(
    Iterable<Mutation$ResetPassword$resetPassword$userErrors> Function(
      Iterable<
        CopyWith$Mutation$ResetPassword$resetPassword$userErrors<
          Mutation$ResetPassword$resetPassword$userErrors
        >
      >,
    )
    _fn,
  );
}

class _CopyWithImpl$Mutation$ResetPassword$resetPassword<TRes>
    implements CopyWith$Mutation$ResetPassword$resetPassword<TRes> {
  _CopyWithImpl$Mutation$ResetPassword$resetPassword(
    this._instance,
    this._then,
  );

  final Mutation$ResetPassword$resetPassword _instance;

  final TRes Function(Mutation$ResetPassword$resetPassword) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? success = _undefined,
    Object? userErrors = _undefined,
    Object? failureReason = _undefined,
  }) => _then(
    Mutation$ResetPassword$resetPassword(
      success: success == _undefined || success == null
          ? _instance.success
          : (success as bool),
      userErrors: userErrors == _undefined || userErrors == null
          ? _instance.userErrors
          : (userErrors
                as List<Mutation$ResetPassword$resetPassword$userErrors>),
      failureReason: failureReason == _undefined
          ? _instance.failureReason
          : (failureReason as String?),
    ),
  );

  TRes userErrors(
    Iterable<Mutation$ResetPassword$resetPassword$userErrors> Function(
      Iterable<
        CopyWith$Mutation$ResetPassword$resetPassword$userErrors<
          Mutation$ResetPassword$resetPassword$userErrors
        >
      >,
    )
    _fn,
  ) => call(
    userErrors: _fn(
      _instance.userErrors.map(
        (e) => CopyWith$Mutation$ResetPassword$resetPassword$userErrors(
          e,
          (i) => i,
        ),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl$Mutation$ResetPassword$resetPassword<TRes>
    implements CopyWith$Mutation$ResetPassword$resetPassword<TRes> {
  _CopyWithStubImpl$Mutation$ResetPassword$resetPassword(this._res);

  TRes _res;

  call({
    bool? success,
    List<Mutation$ResetPassword$resetPassword$userErrors>? userErrors,
    String? failureReason,
  }) => _res;

  userErrors(_fn) => _res;
}

class Mutation$ResetPassword$resetPassword$userErrors {
  Mutation$ResetPassword$resetPassword$userErrors({
    required this.code,
    this.codeValue,
    required this.message,
    this.field,
  });

  factory Mutation$ResetPassword$resetPassword$userErrors.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$code = json['code'];
    final l$codeValue = json['codeValue'];
    final l$message = json['message'];
    final l$field = json['field'];
    return Mutation$ResetPassword$resetPassword$userErrors(
      code: (l$code as String),
      codeValue: l$codeValue == null
          ? null
          : fromJson$Enum$ErrorCode((l$codeValue as String)),
      message: (l$message as String),
      field: (l$field as String?),
    );
  }

  final String code;

  final Enum$ErrorCode? codeValue;

  final String message;

  final String? field;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$code = code;
    _resultData['code'] = l$code;
    final l$codeValue = codeValue;
    _resultData['codeValue'] = l$codeValue == null
        ? null
        : toJson$Enum$ErrorCode(l$codeValue);
    final l$message = message;
    _resultData['message'] = l$message;
    final l$field = field;
    _resultData['field'] = l$field;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$code = code;
    final l$codeValue = codeValue;
    final l$message = message;
    final l$field = field;
    return Object.hashAll([l$code, l$codeValue, l$message, l$field]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$ResetPassword$resetPassword$userErrors ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$code = code;
    final lOther$code = other.code;
    if (l$code != lOther$code) {
      return false;
    }
    final l$codeValue = codeValue;
    final lOther$codeValue = other.codeValue;
    if (l$codeValue != lOther$codeValue) {
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

extension UtilityExtension$Mutation$ResetPassword$resetPassword$userErrors
    on Mutation$ResetPassword$resetPassword$userErrors {
  CopyWith$Mutation$ResetPassword$resetPassword$userErrors<
    Mutation$ResetPassword$resetPassword$userErrors
  >
  get copyWith =>
      CopyWith$Mutation$ResetPassword$resetPassword$userErrors(this, (i) => i);
}

abstract class CopyWith$Mutation$ResetPassword$resetPassword$userErrors<TRes> {
  factory CopyWith$Mutation$ResetPassword$resetPassword$userErrors(
    Mutation$ResetPassword$resetPassword$userErrors instance,
    TRes Function(Mutation$ResetPassword$resetPassword$userErrors) then,
  ) = _CopyWithImpl$Mutation$ResetPassword$resetPassword$userErrors;

  factory CopyWith$Mutation$ResetPassword$resetPassword$userErrors.stub(
    TRes res,
  ) = _CopyWithStubImpl$Mutation$ResetPassword$resetPassword$userErrors;

  TRes call({
    String? code,
    Enum$ErrorCode? codeValue,
    String? message,
    String? field,
  });
}

class _CopyWithImpl$Mutation$ResetPassword$resetPassword$userErrors<TRes>
    implements CopyWith$Mutation$ResetPassword$resetPassword$userErrors<TRes> {
  _CopyWithImpl$Mutation$ResetPassword$resetPassword$userErrors(
    this._instance,
    this._then,
  );

  final Mutation$ResetPassword$resetPassword$userErrors _instance;

  final TRes Function(Mutation$ResetPassword$resetPassword$userErrors) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? code = _undefined,
    Object? codeValue = _undefined,
    Object? message = _undefined,
    Object? field = _undefined,
  }) => _then(
    Mutation$ResetPassword$resetPassword$userErrors(
      code: code == _undefined || code == null
          ? _instance.code
          : (code as String),
      codeValue: codeValue == _undefined
          ? _instance.codeValue
          : (codeValue as Enum$ErrorCode?),
      message: message == _undefined || message == null
          ? _instance.message
          : (message as String),
      field: field == _undefined ? _instance.field : (field as String?),
    ),
  );
}

class _CopyWithStubImpl$Mutation$ResetPassword$resetPassword$userErrors<TRes>
    implements CopyWith$Mutation$ResetPassword$resetPassword$userErrors<TRes> {
  _CopyWithStubImpl$Mutation$ResetPassword$resetPassword$userErrors(this._res);

  TRes _res;

  call({
    String? code,
    Enum$ErrorCode? codeValue,
    String? message,
    String? field,
  }) => _res;
}

class Query$Me {
  Query$Me({required this.me});

  factory Query$Me.fromJson(Map<String, dynamic> json) {
    final l$me = json['me'];
    return Query$Me(me: Query$Me$me.fromJson((l$me as Map<String, dynamic>)));
  }

  final Query$Me$me me;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$me = me;
    _resultData['me'] = l$me.toJson();
    return _resultData;
  }

  @override
  int get hashCode {
    final l$me = me;
    return Object.hashAll([l$me]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$Me || runtimeType != other.runtimeType) {
      return false;
    }
    final l$me = me;
    final lOther$me = other.me;
    if (l$me != lOther$me) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Query$Me on Query$Me {
  CopyWith$Query$Me<Query$Me> get copyWith => CopyWith$Query$Me(this, (i) => i);
}

abstract class CopyWith$Query$Me<TRes> {
  factory CopyWith$Query$Me(Query$Me instance, TRes Function(Query$Me) then) =
      _CopyWithImpl$Query$Me;

  factory CopyWith$Query$Me.stub(TRes res) = _CopyWithStubImpl$Query$Me;

  TRes call({Query$Me$me? me});
  CopyWith$Query$Me$me<TRes> get me;
}

class _CopyWithImpl$Query$Me<TRes> implements CopyWith$Query$Me<TRes> {
  _CopyWithImpl$Query$Me(this._instance, this._then);

  final Query$Me _instance;

  final TRes Function(Query$Me) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? me = _undefined}) => _then(
    Query$Me(
      me: me == _undefined || me == null ? _instance.me : (me as Query$Me$me),
    ),
  );

  CopyWith$Query$Me$me<TRes> get me {
    final local$me = _instance.me;
    return CopyWith$Query$Me$me(local$me, (e) => call(me: e));
  }
}

class _CopyWithStubImpl$Query$Me<TRes> implements CopyWith$Query$Me<TRes> {
  _CopyWithStubImpl$Query$Me(this._res);

  TRes _res;

  call({Query$Me$me? me}) => _res;

  CopyWith$Query$Me$me<TRes> get me => CopyWith$Query$Me$me.stub(_res);
}

const documentNodeQueryMe = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'Me'),
      variableDefinitions: [],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'me'),
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
                  name: NameNode(value: 'email'),
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
                FieldNode(
                  name: NameNode(value: 'status'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: 'emailVerified'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: 'canChangeEmail'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: 'roles'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: 'permissions'),
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
          ),
        ],
      ),
    ),
  ],
);

class Query$Me$me {
  Query$Me$me({
    required this.id,
    required this.email,
    required this.nickname,
    this.profileImageUrl,
    required this.status,
    required this.emailVerified,
    required this.canChangeEmail,
    required this.roles,
    required this.permissions,
    required this.createdAt,
  });

  factory Query$Me$me.fromJson(Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$email = json['email'];
    final l$nickname = json['nickname'];
    final l$profileImageUrl = json['profileImageUrl'];
    final l$status = json['status'];
    final l$emailVerified = json['emailVerified'];
    final l$canChangeEmail = json['canChangeEmail'];
    final l$roles = json['roles'];
    final l$permissions = json['permissions'];
    final l$createdAt = json['createdAt'];
    return Query$Me$me(
      id: (l$id as String),
      email: (l$email as String),
      nickname: (l$nickname as String),
      profileImageUrl: (l$profileImageUrl as String?),
      status: fromJson$Enum$MemberStatus((l$status as String)),
      emailVerified: (l$emailVerified as bool),
      canChangeEmail: (l$canChangeEmail as bool),
      roles: (l$roles as List<dynamic>).map((e) => (e as String)).toList(),
      permissions: (l$permissions as List<dynamic>)
          .map((e) => (e as String))
          .toList(),
      createdAt: (l$createdAt as String),
    );
  }

  final String id;

  final String email;

  final String nickname;

  final String? profileImageUrl;

  final Enum$MemberStatus status;

  final bool emailVerified;

  final bool canChangeEmail;

  final List<String> roles;

  final List<String> permissions;

  final String createdAt;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$email = email;
    _resultData['email'] = l$email;
    final l$nickname = nickname;
    _resultData['nickname'] = l$nickname;
    final l$profileImageUrl = profileImageUrl;
    _resultData['profileImageUrl'] = l$profileImageUrl;
    final l$status = status;
    _resultData['status'] = toJson$Enum$MemberStatus(l$status);
    final l$emailVerified = emailVerified;
    _resultData['emailVerified'] = l$emailVerified;
    final l$canChangeEmail = canChangeEmail;
    _resultData['canChangeEmail'] = l$canChangeEmail;
    final l$roles = roles;
    _resultData['roles'] = l$roles.map((e) => e).toList();
    final l$permissions = permissions;
    _resultData['permissions'] = l$permissions.map((e) => e).toList();
    final l$createdAt = createdAt;
    _resultData['createdAt'] = l$createdAt;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$email = email;
    final l$nickname = nickname;
    final l$profileImageUrl = profileImageUrl;
    final l$status = status;
    final l$emailVerified = emailVerified;
    final l$canChangeEmail = canChangeEmail;
    final l$roles = roles;
    final l$permissions = permissions;
    final l$createdAt = createdAt;
    return Object.hashAll([
      l$id,
      l$email,
      l$nickname,
      l$profileImageUrl,
      l$status,
      l$emailVerified,
      l$canChangeEmail,
      Object.hashAll(l$roles.map((v) => v)),
      Object.hashAll(l$permissions.map((v) => v)),
      l$createdAt,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$Me$me || runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$email = email;
    final lOther$email = other.email;
    if (l$email != lOther$email) {
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
    final l$status = status;
    final lOther$status = other.status;
    if (l$status != lOther$status) {
      return false;
    }
    final l$emailVerified = emailVerified;
    final lOther$emailVerified = other.emailVerified;
    if (l$emailVerified != lOther$emailVerified) {
      return false;
    }
    final l$canChangeEmail = canChangeEmail;
    final lOther$canChangeEmail = other.canChangeEmail;
    if (l$canChangeEmail != lOther$canChangeEmail) {
      return false;
    }
    final l$roles = roles;
    final lOther$roles = other.roles;
    if (l$roles.length != lOther$roles.length) {
      return false;
    }
    for (int i = 0; i < l$roles.length; i++) {
      final l$roles$entry = l$roles[i];
      final lOther$roles$entry = lOther$roles[i];
      if (l$roles$entry != lOther$roles$entry) {
        return false;
      }
    }
    final l$permissions = permissions;
    final lOther$permissions = other.permissions;
    if (l$permissions.length != lOther$permissions.length) {
      return false;
    }
    for (int i = 0; i < l$permissions.length; i++) {
      final l$permissions$entry = l$permissions[i];
      final lOther$permissions$entry = lOther$permissions[i];
      if (l$permissions$entry != lOther$permissions$entry) {
        return false;
      }
    }
    final l$createdAt = createdAt;
    final lOther$createdAt = other.createdAt;
    if (l$createdAt != lOther$createdAt) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Query$Me$me on Query$Me$me {
  CopyWith$Query$Me$me<Query$Me$me> get copyWith =>
      CopyWith$Query$Me$me(this, (i) => i);
}

abstract class CopyWith$Query$Me$me<TRes> {
  factory CopyWith$Query$Me$me(
    Query$Me$me instance,
    TRes Function(Query$Me$me) then,
  ) = _CopyWithImpl$Query$Me$me;

  factory CopyWith$Query$Me$me.stub(TRes res) = _CopyWithStubImpl$Query$Me$me;

  TRes call({
    String? id,
    String? email,
    String? nickname,
    String? profileImageUrl,
    Enum$MemberStatus? status,
    bool? emailVerified,
    bool? canChangeEmail,
    List<String>? roles,
    List<String>? permissions,
    String? createdAt,
  });
}

class _CopyWithImpl$Query$Me$me<TRes> implements CopyWith$Query$Me$me<TRes> {
  _CopyWithImpl$Query$Me$me(this._instance, this._then);

  final Query$Me$me _instance;

  final TRes Function(Query$Me$me) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? email = _undefined,
    Object? nickname = _undefined,
    Object? profileImageUrl = _undefined,
    Object? status = _undefined,
    Object? emailVerified = _undefined,
    Object? canChangeEmail = _undefined,
    Object? roles = _undefined,
    Object? permissions = _undefined,
    Object? createdAt = _undefined,
  }) => _then(
    Query$Me$me(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      email: email == _undefined || email == null
          ? _instance.email
          : (email as String),
      nickname: nickname == _undefined || nickname == null
          ? _instance.nickname
          : (nickname as String),
      profileImageUrl: profileImageUrl == _undefined
          ? _instance.profileImageUrl
          : (profileImageUrl as String?),
      status: status == _undefined || status == null
          ? _instance.status
          : (status as Enum$MemberStatus),
      emailVerified: emailVerified == _undefined || emailVerified == null
          ? _instance.emailVerified
          : (emailVerified as bool),
      canChangeEmail: canChangeEmail == _undefined || canChangeEmail == null
          ? _instance.canChangeEmail
          : (canChangeEmail as bool),
      roles: roles == _undefined || roles == null
          ? _instance.roles
          : (roles as List<String>),
      permissions: permissions == _undefined || permissions == null
          ? _instance.permissions
          : (permissions as List<String>),
      createdAt: createdAt == _undefined || createdAt == null
          ? _instance.createdAt
          : (createdAt as String),
    ),
  );
}

class _CopyWithStubImpl$Query$Me$me<TRes>
    implements CopyWith$Query$Me$me<TRes> {
  _CopyWithStubImpl$Query$Me$me(this._res);

  TRes _res;

  call({
    String? id,
    String? email,
    String? nickname,
    String? profileImageUrl,
    Enum$MemberStatus? status,
    bool? emailVerified,
    bool? canChangeEmail,
    List<String>? roles,
    List<String>? permissions,
    String? createdAt,
  }) => _res;
}

class Mutation$WithdrawMember {
  Mutation$WithdrawMember({required this.withdrawMember});

  factory Mutation$WithdrawMember.fromJson(Map<String, dynamic> json) {
    final l$withdrawMember = json['withdrawMember'];
    return Mutation$WithdrawMember(
      withdrawMember: Mutation$WithdrawMember$withdrawMember.fromJson(
        (l$withdrawMember as Map<String, dynamic>),
      ),
    );
  }

  final Mutation$WithdrawMember$withdrawMember withdrawMember;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$withdrawMember = withdrawMember;
    _resultData['withdrawMember'] = l$withdrawMember.toJson();
    return _resultData;
  }

  @override
  int get hashCode {
    final l$withdrawMember = withdrawMember;
    return Object.hashAll([l$withdrawMember]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$WithdrawMember || runtimeType != other.runtimeType) {
      return false;
    }
    final l$withdrawMember = withdrawMember;
    final lOther$withdrawMember = other.withdrawMember;
    if (l$withdrawMember != lOther$withdrawMember) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Mutation$WithdrawMember on Mutation$WithdrawMember {
  CopyWith$Mutation$WithdrawMember<Mutation$WithdrawMember> get copyWith =>
      CopyWith$Mutation$WithdrawMember(this, (i) => i);
}

abstract class CopyWith$Mutation$WithdrawMember<TRes> {
  factory CopyWith$Mutation$WithdrawMember(
    Mutation$WithdrawMember instance,
    TRes Function(Mutation$WithdrawMember) then,
  ) = _CopyWithImpl$Mutation$WithdrawMember;

  factory CopyWith$Mutation$WithdrawMember.stub(TRes res) =
      _CopyWithStubImpl$Mutation$WithdrawMember;

  TRes call({Mutation$WithdrawMember$withdrawMember? withdrawMember});
  CopyWith$Mutation$WithdrawMember$withdrawMember<TRes> get withdrawMember;
}

class _CopyWithImpl$Mutation$WithdrawMember<TRes>
    implements CopyWith$Mutation$WithdrawMember<TRes> {
  _CopyWithImpl$Mutation$WithdrawMember(this._instance, this._then);

  final Mutation$WithdrawMember _instance;

  final TRes Function(Mutation$WithdrawMember) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? withdrawMember = _undefined}) => _then(
    Mutation$WithdrawMember(
      withdrawMember: withdrawMember == _undefined || withdrawMember == null
          ? _instance.withdrawMember
          : (withdrawMember as Mutation$WithdrawMember$withdrawMember),
    ),
  );

  CopyWith$Mutation$WithdrawMember$withdrawMember<TRes> get withdrawMember {
    final local$withdrawMember = _instance.withdrawMember;
    return CopyWith$Mutation$WithdrawMember$withdrawMember(
      local$withdrawMember,
      (e) => call(withdrawMember: e),
    );
  }
}

class _CopyWithStubImpl$Mutation$WithdrawMember<TRes>
    implements CopyWith$Mutation$WithdrawMember<TRes> {
  _CopyWithStubImpl$Mutation$WithdrawMember(this._res);

  TRes _res;

  call({Mutation$WithdrawMember$withdrawMember? withdrawMember}) => _res;

  CopyWith$Mutation$WithdrawMember$withdrawMember<TRes> get withdrawMember =>
      CopyWith$Mutation$WithdrawMember$withdrawMember.stub(_res);
}

const documentNodeMutationWithdrawMember = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'WithdrawMember'),
      variableDefinitions: [],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'withdrawMember'),
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
                        name: NameNode(value: 'codeValue'),
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

class Mutation$WithdrawMember$withdrawMember {
  Mutation$WithdrawMember$withdrawMember({
    required this.success,
    required this.userErrors,
  });

  factory Mutation$WithdrawMember$withdrawMember.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$success = json['success'];
    final l$userErrors = json['userErrors'];
    return Mutation$WithdrawMember$withdrawMember(
      success: (l$success as bool),
      userErrors: (l$userErrors as List<dynamic>)
          .map(
            (e) => Mutation$WithdrawMember$withdrawMember$userErrors.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
    );
  }

  final bool success;

  final List<Mutation$WithdrawMember$withdrawMember$userErrors> userErrors;

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
    if (other is! Mutation$WithdrawMember$withdrawMember ||
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

extension UtilityExtension$Mutation$WithdrawMember$withdrawMember
    on Mutation$WithdrawMember$withdrawMember {
  CopyWith$Mutation$WithdrawMember$withdrawMember<
    Mutation$WithdrawMember$withdrawMember
  >
  get copyWith =>
      CopyWith$Mutation$WithdrawMember$withdrawMember(this, (i) => i);
}

abstract class CopyWith$Mutation$WithdrawMember$withdrawMember<TRes> {
  factory CopyWith$Mutation$WithdrawMember$withdrawMember(
    Mutation$WithdrawMember$withdrawMember instance,
    TRes Function(Mutation$WithdrawMember$withdrawMember) then,
  ) = _CopyWithImpl$Mutation$WithdrawMember$withdrawMember;

  factory CopyWith$Mutation$WithdrawMember$withdrawMember.stub(TRes res) =
      _CopyWithStubImpl$Mutation$WithdrawMember$withdrawMember;

  TRes call({
    bool? success,
    List<Mutation$WithdrawMember$withdrawMember$userErrors>? userErrors,
  });
  TRes userErrors(
    Iterable<Mutation$WithdrawMember$withdrawMember$userErrors> Function(
      Iterable<
        CopyWith$Mutation$WithdrawMember$withdrawMember$userErrors<
          Mutation$WithdrawMember$withdrawMember$userErrors
        >
      >,
    )
    _fn,
  );
}

class _CopyWithImpl$Mutation$WithdrawMember$withdrawMember<TRes>
    implements CopyWith$Mutation$WithdrawMember$withdrawMember<TRes> {
  _CopyWithImpl$Mutation$WithdrawMember$withdrawMember(
    this._instance,
    this._then,
  );

  final Mutation$WithdrawMember$withdrawMember _instance;

  final TRes Function(Mutation$WithdrawMember$withdrawMember) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? success = _undefined, Object? userErrors = _undefined}) =>
      _then(
        Mutation$WithdrawMember$withdrawMember(
          success: success == _undefined || success == null
              ? _instance.success
              : (success as bool),
          userErrors: userErrors == _undefined || userErrors == null
              ? _instance.userErrors
              : (userErrors
                    as List<Mutation$WithdrawMember$withdrawMember$userErrors>),
        ),
      );

  TRes userErrors(
    Iterable<Mutation$WithdrawMember$withdrawMember$userErrors> Function(
      Iterable<
        CopyWith$Mutation$WithdrawMember$withdrawMember$userErrors<
          Mutation$WithdrawMember$withdrawMember$userErrors
        >
      >,
    )
    _fn,
  ) => call(
    userErrors: _fn(
      _instance.userErrors.map(
        (e) => CopyWith$Mutation$WithdrawMember$withdrawMember$userErrors(
          e,
          (i) => i,
        ),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl$Mutation$WithdrawMember$withdrawMember<TRes>
    implements CopyWith$Mutation$WithdrawMember$withdrawMember<TRes> {
  _CopyWithStubImpl$Mutation$WithdrawMember$withdrawMember(this._res);

  TRes _res;

  call({
    bool? success,
    List<Mutation$WithdrawMember$withdrawMember$userErrors>? userErrors,
  }) => _res;

  userErrors(_fn) => _res;
}

class Mutation$WithdrawMember$withdrawMember$userErrors {
  Mutation$WithdrawMember$withdrawMember$userErrors({
    required this.code,
    this.codeValue,
    required this.message,
    this.field,
  });

  factory Mutation$WithdrawMember$withdrawMember$userErrors.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$code = json['code'];
    final l$codeValue = json['codeValue'];
    final l$message = json['message'];
    final l$field = json['field'];
    return Mutation$WithdrawMember$withdrawMember$userErrors(
      code: (l$code as String),
      codeValue: l$codeValue == null
          ? null
          : fromJson$Enum$ErrorCode((l$codeValue as String)),
      message: (l$message as String),
      field: (l$field as String?),
    );
  }

  final String code;

  final Enum$ErrorCode? codeValue;

  final String message;

  final String? field;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$code = code;
    _resultData['code'] = l$code;
    final l$codeValue = codeValue;
    _resultData['codeValue'] = l$codeValue == null
        ? null
        : toJson$Enum$ErrorCode(l$codeValue);
    final l$message = message;
    _resultData['message'] = l$message;
    final l$field = field;
    _resultData['field'] = l$field;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$code = code;
    final l$codeValue = codeValue;
    final l$message = message;
    final l$field = field;
    return Object.hashAll([l$code, l$codeValue, l$message, l$field]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$WithdrawMember$withdrawMember$userErrors ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$code = code;
    final lOther$code = other.code;
    if (l$code != lOther$code) {
      return false;
    }
    final l$codeValue = codeValue;
    final lOther$codeValue = other.codeValue;
    if (l$codeValue != lOther$codeValue) {
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

extension UtilityExtension$Mutation$WithdrawMember$withdrawMember$userErrors
    on Mutation$WithdrawMember$withdrawMember$userErrors {
  CopyWith$Mutation$WithdrawMember$withdrawMember$userErrors<
    Mutation$WithdrawMember$withdrawMember$userErrors
  >
  get copyWith => CopyWith$Mutation$WithdrawMember$withdrawMember$userErrors(
    this,
    (i) => i,
  );
}

abstract class CopyWith$Mutation$WithdrawMember$withdrawMember$userErrors<
  TRes
> {
  factory CopyWith$Mutation$WithdrawMember$withdrawMember$userErrors(
    Mutation$WithdrawMember$withdrawMember$userErrors instance,
    TRes Function(Mutation$WithdrawMember$withdrawMember$userErrors) then,
  ) = _CopyWithImpl$Mutation$WithdrawMember$withdrawMember$userErrors;

  factory CopyWith$Mutation$WithdrawMember$withdrawMember$userErrors.stub(
    TRes res,
  ) = _CopyWithStubImpl$Mutation$WithdrawMember$withdrawMember$userErrors;

  TRes call({
    String? code,
    Enum$ErrorCode? codeValue,
    String? message,
    String? field,
  });
}

class _CopyWithImpl$Mutation$WithdrawMember$withdrawMember$userErrors<TRes>
    implements
        CopyWith$Mutation$WithdrawMember$withdrawMember$userErrors<TRes> {
  _CopyWithImpl$Mutation$WithdrawMember$withdrawMember$userErrors(
    this._instance,
    this._then,
  );

  final Mutation$WithdrawMember$withdrawMember$userErrors _instance;

  final TRes Function(Mutation$WithdrawMember$withdrawMember$userErrors) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? code = _undefined,
    Object? codeValue = _undefined,
    Object? message = _undefined,
    Object? field = _undefined,
  }) => _then(
    Mutation$WithdrawMember$withdrawMember$userErrors(
      code: code == _undefined || code == null
          ? _instance.code
          : (code as String),
      codeValue: codeValue == _undefined
          ? _instance.codeValue
          : (codeValue as Enum$ErrorCode?),
      message: message == _undefined || message == null
          ? _instance.message
          : (message as String),
      field: field == _undefined ? _instance.field : (field as String?),
    ),
  );
}

class _CopyWithStubImpl$Mutation$WithdrawMember$withdrawMember$userErrors<TRes>
    implements
        CopyWith$Mutation$WithdrawMember$withdrawMember$userErrors<TRes> {
  _CopyWithStubImpl$Mutation$WithdrawMember$withdrawMember$userErrors(
    this._res,
  );

  TRes _res;

  call({
    String? code,
    Enum$ErrorCode? codeValue,
    String? message,
    String? field,
  }) => _res;
}
