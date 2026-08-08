// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, unused_element
import 'email_change_schema.graphql.dart';
import 'package:gql/ast.dart';

class Variables$Mutation$ChangeEmail {
  factory Variables$Mutation$ChangeEmail({
    required Input$ChangeEmailInput input,
  }) => Variables$Mutation$ChangeEmail._({r'input': input});

  Variables$Mutation$ChangeEmail._(this._$data);

  factory Variables$Mutation$ChangeEmail.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$input = data['input'];
    result$data['input'] = Input$ChangeEmailInput.fromJson(
      (l$input as Map<String, dynamic>),
    );
    return Variables$Mutation$ChangeEmail._(result$data);
  }

  Map<String, dynamic> _$data;

  Input$ChangeEmailInput get input =>
      (_$data['input'] as Input$ChangeEmailInput);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$input = input;
    result$data['input'] = l$input.toJson();
    return result$data;
  }

  CopyWith$Variables$Mutation$ChangeEmail<Variables$Mutation$ChangeEmail>
  get copyWith => CopyWith$Variables$Mutation$ChangeEmail(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Mutation$ChangeEmail ||
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

abstract class CopyWith$Variables$Mutation$ChangeEmail<TRes> {
  factory CopyWith$Variables$Mutation$ChangeEmail(
    Variables$Mutation$ChangeEmail instance,
    TRes Function(Variables$Mutation$ChangeEmail) then,
  ) = _CopyWithImpl$Variables$Mutation$ChangeEmail;

  factory CopyWith$Variables$Mutation$ChangeEmail.stub(TRes res) =
      _CopyWithStubImpl$Variables$Mutation$ChangeEmail;

  TRes call({Input$ChangeEmailInput? input});
}

class _CopyWithImpl$Variables$Mutation$ChangeEmail<TRes>
    implements CopyWith$Variables$Mutation$ChangeEmail<TRes> {
  _CopyWithImpl$Variables$Mutation$ChangeEmail(this._instance, this._then);

  final Variables$Mutation$ChangeEmail _instance;

  final TRes Function(Variables$Mutation$ChangeEmail) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? input = _undefined}) => _then(
    Variables$Mutation$ChangeEmail._({
      ..._instance._$data,
      if (input != _undefined && input != null)
        'input': (input as Input$ChangeEmailInput),
    }),
  );
}

class _CopyWithStubImpl$Variables$Mutation$ChangeEmail<TRes>
    implements CopyWith$Variables$Mutation$ChangeEmail<TRes> {
  _CopyWithStubImpl$Variables$Mutation$ChangeEmail(this._res);

  TRes _res;

  call({Input$ChangeEmailInput? input}) => _res;
}

class Mutation$ChangeEmail {
  Mutation$ChangeEmail({required this.changeEmail});

  factory Mutation$ChangeEmail.fromJson(Map<String, dynamic> json) {
    final l$changeEmail = json['changeEmail'];
    return Mutation$ChangeEmail(
      changeEmail: Mutation$ChangeEmail$changeEmail.fromJson(
        (l$changeEmail as Map<String, dynamic>),
      ),
    );
  }

  final Mutation$ChangeEmail$changeEmail changeEmail;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$changeEmail = changeEmail;
    _resultData['changeEmail'] = l$changeEmail.toJson();
    return _resultData;
  }

  @override
  int get hashCode {
    final l$changeEmail = changeEmail;
    return Object.hashAll([l$changeEmail]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$ChangeEmail || runtimeType != other.runtimeType) {
      return false;
    }
    final l$changeEmail = changeEmail;
    final lOther$changeEmail = other.changeEmail;
    if (l$changeEmail != lOther$changeEmail) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Mutation$ChangeEmail on Mutation$ChangeEmail {
  CopyWith$Mutation$ChangeEmail<Mutation$ChangeEmail> get copyWith =>
      CopyWith$Mutation$ChangeEmail(this, (i) => i);
}

abstract class CopyWith$Mutation$ChangeEmail<TRes> {
  factory CopyWith$Mutation$ChangeEmail(
    Mutation$ChangeEmail instance,
    TRes Function(Mutation$ChangeEmail) then,
  ) = _CopyWithImpl$Mutation$ChangeEmail;

  factory CopyWith$Mutation$ChangeEmail.stub(TRes res) =
      _CopyWithStubImpl$Mutation$ChangeEmail;

  TRes call({Mutation$ChangeEmail$changeEmail? changeEmail});
  CopyWith$Mutation$ChangeEmail$changeEmail<TRes> get changeEmail;
}

class _CopyWithImpl$Mutation$ChangeEmail<TRes>
    implements CopyWith$Mutation$ChangeEmail<TRes> {
  _CopyWithImpl$Mutation$ChangeEmail(this._instance, this._then);

  final Mutation$ChangeEmail _instance;

  final TRes Function(Mutation$ChangeEmail) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? changeEmail = _undefined}) => _then(
    Mutation$ChangeEmail(
      changeEmail: changeEmail == _undefined || changeEmail == null
          ? _instance.changeEmail
          : (changeEmail as Mutation$ChangeEmail$changeEmail),
    ),
  );

  CopyWith$Mutation$ChangeEmail$changeEmail<TRes> get changeEmail {
    final local$changeEmail = _instance.changeEmail;
    return CopyWith$Mutation$ChangeEmail$changeEmail(
      local$changeEmail,
      (e) => call(changeEmail: e),
    );
  }
}

class _CopyWithStubImpl$Mutation$ChangeEmail<TRes>
    implements CopyWith$Mutation$ChangeEmail<TRes> {
  _CopyWithStubImpl$Mutation$ChangeEmail(this._res);

  TRes _res;

  call({Mutation$ChangeEmail$changeEmail? changeEmail}) => _res;

  CopyWith$Mutation$ChangeEmail$changeEmail<TRes> get changeEmail =>
      CopyWith$Mutation$ChangeEmail$changeEmail.stub(_res);
}

const documentNodeMutationChangeEmail = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'ChangeEmail'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'input')),
          type: NamedTypeNode(
            name: NameNode(value: 'ChangeEmailInput'),
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
            name: NameNode(value: 'changeEmail'),
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

class Mutation$ChangeEmail$changeEmail {
  Mutation$ChangeEmail$changeEmail({
    required this.success,
    required this.userErrors,
    this.verificationId,
    this.expiresAt,
  });

  factory Mutation$ChangeEmail$changeEmail.fromJson(Map<String, dynamic> json) {
    final l$success = json['success'];
    final l$userErrors = json['userErrors'];
    final l$verificationId = json['verificationId'];
    final l$expiresAt = json['expiresAt'];
    return Mutation$ChangeEmail$changeEmail(
      success: (l$success as bool),
      userErrors: (l$userErrors as List<dynamic>)
          .map(
            (e) => Mutation$ChangeEmail$changeEmail$userErrors.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      verificationId: (l$verificationId as String?),
      expiresAt: (l$expiresAt as String?),
    );
  }

  final bool success;

  final List<Mutation$ChangeEmail$changeEmail$userErrors> userErrors;

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
    if (other is! Mutation$ChangeEmail$changeEmail ||
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

extension UtilityExtension$Mutation$ChangeEmail$changeEmail
    on Mutation$ChangeEmail$changeEmail {
  CopyWith$Mutation$ChangeEmail$changeEmail<Mutation$ChangeEmail$changeEmail>
  get copyWith => CopyWith$Mutation$ChangeEmail$changeEmail(this, (i) => i);
}

abstract class CopyWith$Mutation$ChangeEmail$changeEmail<TRes> {
  factory CopyWith$Mutation$ChangeEmail$changeEmail(
    Mutation$ChangeEmail$changeEmail instance,
    TRes Function(Mutation$ChangeEmail$changeEmail) then,
  ) = _CopyWithImpl$Mutation$ChangeEmail$changeEmail;

  factory CopyWith$Mutation$ChangeEmail$changeEmail.stub(TRes res) =
      _CopyWithStubImpl$Mutation$ChangeEmail$changeEmail;

  TRes call({
    bool? success,
    List<Mutation$ChangeEmail$changeEmail$userErrors>? userErrors,
    String? verificationId,
    String? expiresAt,
  });
  TRes userErrors(
    Iterable<Mutation$ChangeEmail$changeEmail$userErrors> Function(
      Iterable<
        CopyWith$Mutation$ChangeEmail$changeEmail$userErrors<
          Mutation$ChangeEmail$changeEmail$userErrors
        >
      >,
    )
    _fn,
  );
}

class _CopyWithImpl$Mutation$ChangeEmail$changeEmail<TRes>
    implements CopyWith$Mutation$ChangeEmail$changeEmail<TRes> {
  _CopyWithImpl$Mutation$ChangeEmail$changeEmail(this._instance, this._then);

  final Mutation$ChangeEmail$changeEmail _instance;

  final TRes Function(Mutation$ChangeEmail$changeEmail) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? success = _undefined,
    Object? userErrors = _undefined,
    Object? verificationId = _undefined,
    Object? expiresAt = _undefined,
  }) => _then(
    Mutation$ChangeEmail$changeEmail(
      success: success == _undefined || success == null
          ? _instance.success
          : (success as bool),
      userErrors: userErrors == _undefined || userErrors == null
          ? _instance.userErrors
          : (userErrors as List<Mutation$ChangeEmail$changeEmail$userErrors>),
      verificationId: verificationId == _undefined
          ? _instance.verificationId
          : (verificationId as String?),
      expiresAt: expiresAt == _undefined
          ? _instance.expiresAt
          : (expiresAt as String?),
    ),
  );

  TRes userErrors(
    Iterable<Mutation$ChangeEmail$changeEmail$userErrors> Function(
      Iterable<
        CopyWith$Mutation$ChangeEmail$changeEmail$userErrors<
          Mutation$ChangeEmail$changeEmail$userErrors
        >
      >,
    )
    _fn,
  ) => call(
    userErrors: _fn(
      _instance.userErrors.map(
        (e) =>
            CopyWith$Mutation$ChangeEmail$changeEmail$userErrors(e, (i) => i),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl$Mutation$ChangeEmail$changeEmail<TRes>
    implements CopyWith$Mutation$ChangeEmail$changeEmail<TRes> {
  _CopyWithStubImpl$Mutation$ChangeEmail$changeEmail(this._res);

  TRes _res;

  call({
    bool? success,
    List<Mutation$ChangeEmail$changeEmail$userErrors>? userErrors,
    String? verificationId,
    String? expiresAt,
  }) => _res;

  userErrors(_fn) => _res;
}

class Mutation$ChangeEmail$changeEmail$userErrors {
  Mutation$ChangeEmail$changeEmail$userErrors({
    required this.code,
    required this.message,
    this.field,
  });

  factory Mutation$ChangeEmail$changeEmail$userErrors.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$code = json['code'];
    final l$message = json['message'];
    final l$field = json['field'];
    return Mutation$ChangeEmail$changeEmail$userErrors(
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
    if (other is! Mutation$ChangeEmail$changeEmail$userErrors ||
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

extension UtilityExtension$Mutation$ChangeEmail$changeEmail$userErrors
    on Mutation$ChangeEmail$changeEmail$userErrors {
  CopyWith$Mutation$ChangeEmail$changeEmail$userErrors<
    Mutation$ChangeEmail$changeEmail$userErrors
  >
  get copyWith =>
      CopyWith$Mutation$ChangeEmail$changeEmail$userErrors(this, (i) => i);
}

abstract class CopyWith$Mutation$ChangeEmail$changeEmail$userErrors<TRes> {
  factory CopyWith$Mutation$ChangeEmail$changeEmail$userErrors(
    Mutation$ChangeEmail$changeEmail$userErrors instance,
    TRes Function(Mutation$ChangeEmail$changeEmail$userErrors) then,
  ) = _CopyWithImpl$Mutation$ChangeEmail$changeEmail$userErrors;

  factory CopyWith$Mutation$ChangeEmail$changeEmail$userErrors.stub(TRes res) =
      _CopyWithStubImpl$Mutation$ChangeEmail$changeEmail$userErrors;

  TRes call({String? code, String? message, String? field});
}

class _CopyWithImpl$Mutation$ChangeEmail$changeEmail$userErrors<TRes>
    implements CopyWith$Mutation$ChangeEmail$changeEmail$userErrors<TRes> {
  _CopyWithImpl$Mutation$ChangeEmail$changeEmail$userErrors(
    this._instance,
    this._then,
  );

  final Mutation$ChangeEmail$changeEmail$userErrors _instance;

  final TRes Function(Mutation$ChangeEmail$changeEmail$userErrors) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? code = _undefined,
    Object? message = _undefined,
    Object? field = _undefined,
  }) => _then(
    Mutation$ChangeEmail$changeEmail$userErrors(
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

class _CopyWithStubImpl$Mutation$ChangeEmail$changeEmail$userErrors<TRes>
    implements CopyWith$Mutation$ChangeEmail$changeEmail$userErrors<TRes> {
  _CopyWithStubImpl$Mutation$ChangeEmail$changeEmail$userErrors(this._res);

  TRes _res;

  call({String? code, String? message, String? field}) => _res;
}

class Variables$Mutation$ConfirmEmailChange {
  factory Variables$Mutation$ConfirmEmailChange({
    required Input$ConfirmEmailChangeInput input,
  }) => Variables$Mutation$ConfirmEmailChange._({r'input': input});

  Variables$Mutation$ConfirmEmailChange._(this._$data);

  factory Variables$Mutation$ConfirmEmailChange.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    final l$input = data['input'];
    result$data['input'] = Input$ConfirmEmailChangeInput.fromJson(
      (l$input as Map<String, dynamic>),
    );
    return Variables$Mutation$ConfirmEmailChange._(result$data);
  }

  Map<String, dynamic> _$data;

  Input$ConfirmEmailChangeInput get input =>
      (_$data['input'] as Input$ConfirmEmailChangeInput);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$input = input;
    result$data['input'] = l$input.toJson();
    return result$data;
  }

  CopyWith$Variables$Mutation$ConfirmEmailChange<
    Variables$Mutation$ConfirmEmailChange
  >
  get copyWith =>
      CopyWith$Variables$Mutation$ConfirmEmailChange(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Mutation$ConfirmEmailChange ||
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

abstract class CopyWith$Variables$Mutation$ConfirmEmailChange<TRes> {
  factory CopyWith$Variables$Mutation$ConfirmEmailChange(
    Variables$Mutation$ConfirmEmailChange instance,
    TRes Function(Variables$Mutation$ConfirmEmailChange) then,
  ) = _CopyWithImpl$Variables$Mutation$ConfirmEmailChange;

  factory CopyWith$Variables$Mutation$ConfirmEmailChange.stub(TRes res) =
      _CopyWithStubImpl$Variables$Mutation$ConfirmEmailChange;

  TRes call({Input$ConfirmEmailChangeInput? input});
}

class _CopyWithImpl$Variables$Mutation$ConfirmEmailChange<TRes>
    implements CopyWith$Variables$Mutation$ConfirmEmailChange<TRes> {
  _CopyWithImpl$Variables$Mutation$ConfirmEmailChange(
    this._instance,
    this._then,
  );

  final Variables$Mutation$ConfirmEmailChange _instance;

  final TRes Function(Variables$Mutation$ConfirmEmailChange) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? input = _undefined}) => _then(
    Variables$Mutation$ConfirmEmailChange._({
      ..._instance._$data,
      if (input != _undefined && input != null)
        'input': (input as Input$ConfirmEmailChangeInput),
    }),
  );
}

class _CopyWithStubImpl$Variables$Mutation$ConfirmEmailChange<TRes>
    implements CopyWith$Variables$Mutation$ConfirmEmailChange<TRes> {
  _CopyWithStubImpl$Variables$Mutation$ConfirmEmailChange(this._res);

  TRes _res;

  call({Input$ConfirmEmailChangeInput? input}) => _res;
}

class Mutation$ConfirmEmailChange {
  Mutation$ConfirmEmailChange({required this.confirmEmailChange});

  factory Mutation$ConfirmEmailChange.fromJson(Map<String, dynamic> json) {
    final l$confirmEmailChange = json['confirmEmailChange'];
    return Mutation$ConfirmEmailChange(
      confirmEmailChange:
          Mutation$ConfirmEmailChange$confirmEmailChange.fromJson(
            (l$confirmEmailChange as Map<String, dynamic>),
          ),
    );
  }

  final Mutation$ConfirmEmailChange$confirmEmailChange confirmEmailChange;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$confirmEmailChange = confirmEmailChange;
    _resultData['confirmEmailChange'] = l$confirmEmailChange.toJson();
    return _resultData;
  }

  @override
  int get hashCode {
    final l$confirmEmailChange = confirmEmailChange;
    return Object.hashAll([l$confirmEmailChange]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$ConfirmEmailChange ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$confirmEmailChange = confirmEmailChange;
    final lOther$confirmEmailChange = other.confirmEmailChange;
    if (l$confirmEmailChange != lOther$confirmEmailChange) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Mutation$ConfirmEmailChange
    on Mutation$ConfirmEmailChange {
  CopyWith$Mutation$ConfirmEmailChange<Mutation$ConfirmEmailChange>
  get copyWith => CopyWith$Mutation$ConfirmEmailChange(this, (i) => i);
}

abstract class CopyWith$Mutation$ConfirmEmailChange<TRes> {
  factory CopyWith$Mutation$ConfirmEmailChange(
    Mutation$ConfirmEmailChange instance,
    TRes Function(Mutation$ConfirmEmailChange) then,
  ) = _CopyWithImpl$Mutation$ConfirmEmailChange;

  factory CopyWith$Mutation$ConfirmEmailChange.stub(TRes res) =
      _CopyWithStubImpl$Mutation$ConfirmEmailChange;

  TRes call({
    Mutation$ConfirmEmailChange$confirmEmailChange? confirmEmailChange,
  });
  CopyWith$Mutation$ConfirmEmailChange$confirmEmailChange<TRes>
  get confirmEmailChange;
}

class _CopyWithImpl$Mutation$ConfirmEmailChange<TRes>
    implements CopyWith$Mutation$ConfirmEmailChange<TRes> {
  _CopyWithImpl$Mutation$ConfirmEmailChange(this._instance, this._then);

  final Mutation$ConfirmEmailChange _instance;

  final TRes Function(Mutation$ConfirmEmailChange) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? confirmEmailChange = _undefined}) => _then(
    Mutation$ConfirmEmailChange(
      confirmEmailChange:
          confirmEmailChange == _undefined || confirmEmailChange == null
          ? _instance.confirmEmailChange
          : (confirmEmailChange
                as Mutation$ConfirmEmailChange$confirmEmailChange),
    ),
  );

  CopyWith$Mutation$ConfirmEmailChange$confirmEmailChange<TRes>
  get confirmEmailChange {
    final local$confirmEmailChange = _instance.confirmEmailChange;
    return CopyWith$Mutation$ConfirmEmailChange$confirmEmailChange(
      local$confirmEmailChange,
      (e) => call(confirmEmailChange: e),
    );
  }
}

class _CopyWithStubImpl$Mutation$ConfirmEmailChange<TRes>
    implements CopyWith$Mutation$ConfirmEmailChange<TRes> {
  _CopyWithStubImpl$Mutation$ConfirmEmailChange(this._res);

  TRes _res;

  call({Mutation$ConfirmEmailChange$confirmEmailChange? confirmEmailChange}) =>
      _res;

  CopyWith$Mutation$ConfirmEmailChange$confirmEmailChange<TRes>
  get confirmEmailChange =>
      CopyWith$Mutation$ConfirmEmailChange$confirmEmailChange.stub(_res);
}

const documentNodeMutationConfirmEmailChange = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'ConfirmEmailChange'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'input')),
          type: NamedTypeNode(
            name: NameNode(value: 'ConfirmEmailChangeInput'),
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
            name: NameNode(value: 'confirmEmailChange'),
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
                  name: NameNode(value: 'email'),
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

class Mutation$ConfirmEmailChange$confirmEmailChange {
  Mutation$ConfirmEmailChange$confirmEmailChange({
    required this.success,
    required this.userErrors,
    this.email,
    this.failureReason,
  });

  factory Mutation$ConfirmEmailChange$confirmEmailChange.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$success = json['success'];
    final l$userErrors = json['userErrors'];
    final l$email = json['email'];
    final l$failureReason = json['failureReason'];
    return Mutation$ConfirmEmailChange$confirmEmailChange(
      success: (l$success as bool),
      userErrors: (l$userErrors as List<dynamic>)
          .map(
            (e) =>
                Mutation$ConfirmEmailChange$confirmEmailChange$userErrors.fromJson(
                  (e as Map<String, dynamic>),
                ),
          )
          .toList(),
      email: (l$email as String?),
      failureReason: (l$failureReason as String?),
    );
  }

  final bool success;

  final List<Mutation$ConfirmEmailChange$confirmEmailChange$userErrors>
  userErrors;

  final String? email;

  final String? failureReason;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$success = success;
    _resultData['success'] = l$success;
    final l$userErrors = userErrors;
    _resultData['userErrors'] = l$userErrors.map((e) => e.toJson()).toList();
    final l$email = email;
    _resultData['email'] = l$email;
    final l$failureReason = failureReason;
    _resultData['failureReason'] = l$failureReason;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$success = success;
    final l$userErrors = userErrors;
    final l$email = email;
    final l$failureReason = failureReason;
    return Object.hashAll([
      l$success,
      Object.hashAll(l$userErrors.map((v) => v)),
      l$email,
      l$failureReason,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$ConfirmEmailChange$confirmEmailChange ||
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
    final l$email = email;
    final lOther$email = other.email;
    if (l$email != lOther$email) {
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

extension UtilityExtension$Mutation$ConfirmEmailChange$confirmEmailChange
    on Mutation$ConfirmEmailChange$confirmEmailChange {
  CopyWith$Mutation$ConfirmEmailChange$confirmEmailChange<
    Mutation$ConfirmEmailChange$confirmEmailChange
  >
  get copyWith =>
      CopyWith$Mutation$ConfirmEmailChange$confirmEmailChange(this, (i) => i);
}

abstract class CopyWith$Mutation$ConfirmEmailChange$confirmEmailChange<TRes> {
  factory CopyWith$Mutation$ConfirmEmailChange$confirmEmailChange(
    Mutation$ConfirmEmailChange$confirmEmailChange instance,
    TRes Function(Mutation$ConfirmEmailChange$confirmEmailChange) then,
  ) = _CopyWithImpl$Mutation$ConfirmEmailChange$confirmEmailChange;

  factory CopyWith$Mutation$ConfirmEmailChange$confirmEmailChange.stub(
    TRes res,
  ) = _CopyWithStubImpl$Mutation$ConfirmEmailChange$confirmEmailChange;

  TRes call({
    bool? success,
    List<Mutation$ConfirmEmailChange$confirmEmailChange$userErrors>? userErrors,
    String? email,
    String? failureReason,
  });
  TRes userErrors(
    Iterable<Mutation$ConfirmEmailChange$confirmEmailChange$userErrors>
    Function(
      Iterable<
        CopyWith$Mutation$ConfirmEmailChange$confirmEmailChange$userErrors<
          Mutation$ConfirmEmailChange$confirmEmailChange$userErrors
        >
      >,
    )
    _fn,
  );
}

class _CopyWithImpl$Mutation$ConfirmEmailChange$confirmEmailChange<TRes>
    implements CopyWith$Mutation$ConfirmEmailChange$confirmEmailChange<TRes> {
  _CopyWithImpl$Mutation$ConfirmEmailChange$confirmEmailChange(
    this._instance,
    this._then,
  );

  final Mutation$ConfirmEmailChange$confirmEmailChange _instance;

  final TRes Function(Mutation$ConfirmEmailChange$confirmEmailChange) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? success = _undefined,
    Object? userErrors = _undefined,
    Object? email = _undefined,
    Object? failureReason = _undefined,
  }) => _then(
    Mutation$ConfirmEmailChange$confirmEmailChange(
      success: success == _undefined || success == null
          ? _instance.success
          : (success as bool),
      userErrors: userErrors == _undefined || userErrors == null
          ? _instance.userErrors
          : (userErrors
                as List<
                  Mutation$ConfirmEmailChange$confirmEmailChange$userErrors
                >),
      email: email == _undefined ? _instance.email : (email as String?),
      failureReason: failureReason == _undefined
          ? _instance.failureReason
          : (failureReason as String?),
    ),
  );

  TRes userErrors(
    Iterable<Mutation$ConfirmEmailChange$confirmEmailChange$userErrors>
    Function(
      Iterable<
        CopyWith$Mutation$ConfirmEmailChange$confirmEmailChange$userErrors<
          Mutation$ConfirmEmailChange$confirmEmailChange$userErrors
        >
      >,
    )
    _fn,
  ) => call(
    userErrors: _fn(
      _instance.userErrors.map(
        (e) =>
            CopyWith$Mutation$ConfirmEmailChange$confirmEmailChange$userErrors(
              e,
              (i) => i,
            ),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl$Mutation$ConfirmEmailChange$confirmEmailChange<TRes>
    implements CopyWith$Mutation$ConfirmEmailChange$confirmEmailChange<TRes> {
  _CopyWithStubImpl$Mutation$ConfirmEmailChange$confirmEmailChange(this._res);

  TRes _res;

  call({
    bool? success,
    List<Mutation$ConfirmEmailChange$confirmEmailChange$userErrors>? userErrors,
    String? email,
    String? failureReason,
  }) => _res;

  userErrors(_fn) => _res;
}

class Mutation$ConfirmEmailChange$confirmEmailChange$userErrors {
  Mutation$ConfirmEmailChange$confirmEmailChange$userErrors({
    required this.code,
    required this.message,
    this.field,
  });

  factory Mutation$ConfirmEmailChange$confirmEmailChange$userErrors.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$code = json['code'];
    final l$message = json['message'];
    final l$field = json['field'];
    return Mutation$ConfirmEmailChange$confirmEmailChange$userErrors(
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
    if (other is! Mutation$ConfirmEmailChange$confirmEmailChange$userErrors ||
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

extension UtilityExtension$Mutation$ConfirmEmailChange$confirmEmailChange$userErrors
    on Mutation$ConfirmEmailChange$confirmEmailChange$userErrors {
  CopyWith$Mutation$ConfirmEmailChange$confirmEmailChange$userErrors<
    Mutation$ConfirmEmailChange$confirmEmailChange$userErrors
  >
  get copyWith =>
      CopyWith$Mutation$ConfirmEmailChange$confirmEmailChange$userErrors(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Mutation$ConfirmEmailChange$confirmEmailChange$userErrors<
  TRes
> {
  factory CopyWith$Mutation$ConfirmEmailChange$confirmEmailChange$userErrors(
    Mutation$ConfirmEmailChange$confirmEmailChange$userErrors instance,
    TRes Function(Mutation$ConfirmEmailChange$confirmEmailChange$userErrors)
    then,
  ) = _CopyWithImpl$Mutation$ConfirmEmailChange$confirmEmailChange$userErrors;

  factory CopyWith$Mutation$ConfirmEmailChange$confirmEmailChange$userErrors.stub(
    TRes res,
  ) = _CopyWithStubImpl$Mutation$ConfirmEmailChange$confirmEmailChange$userErrors;

  TRes call({String? code, String? message, String? field});
}

class _CopyWithImpl$Mutation$ConfirmEmailChange$confirmEmailChange$userErrors<
  TRes
>
    implements
        CopyWith$Mutation$ConfirmEmailChange$confirmEmailChange$userErrors<
          TRes
        > {
  _CopyWithImpl$Mutation$ConfirmEmailChange$confirmEmailChange$userErrors(
    this._instance,
    this._then,
  );

  final Mutation$ConfirmEmailChange$confirmEmailChange$userErrors _instance;

  final TRes Function(Mutation$ConfirmEmailChange$confirmEmailChange$userErrors)
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? code = _undefined,
    Object? message = _undefined,
    Object? field = _undefined,
  }) => _then(
    Mutation$ConfirmEmailChange$confirmEmailChange$userErrors(
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

class _CopyWithStubImpl$Mutation$ConfirmEmailChange$confirmEmailChange$userErrors<
  TRes
>
    implements
        CopyWith$Mutation$ConfirmEmailChange$confirmEmailChange$userErrors<
          TRes
        > {
  _CopyWithStubImpl$Mutation$ConfirmEmailChange$confirmEmailChange$userErrors(
    this._res,
  );

  TRes _res;

  call({String? code, String? message, String? field}) => _res;
}

class Variables$Mutation$ResendEmailChange {
  factory Variables$Mutation$ResendEmailChange({
    required Input$ResendEmailChangeInput input,
  }) => Variables$Mutation$ResendEmailChange._({r'input': input});

  Variables$Mutation$ResendEmailChange._(this._$data);

  factory Variables$Mutation$ResendEmailChange.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    final l$input = data['input'];
    result$data['input'] = Input$ResendEmailChangeInput.fromJson(
      (l$input as Map<String, dynamic>),
    );
    return Variables$Mutation$ResendEmailChange._(result$data);
  }

  Map<String, dynamic> _$data;

  Input$ResendEmailChangeInput get input =>
      (_$data['input'] as Input$ResendEmailChangeInput);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$input = input;
    result$data['input'] = l$input.toJson();
    return result$data;
  }

  CopyWith$Variables$Mutation$ResendEmailChange<
    Variables$Mutation$ResendEmailChange
  >
  get copyWith => CopyWith$Variables$Mutation$ResendEmailChange(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Mutation$ResendEmailChange ||
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

abstract class CopyWith$Variables$Mutation$ResendEmailChange<TRes> {
  factory CopyWith$Variables$Mutation$ResendEmailChange(
    Variables$Mutation$ResendEmailChange instance,
    TRes Function(Variables$Mutation$ResendEmailChange) then,
  ) = _CopyWithImpl$Variables$Mutation$ResendEmailChange;

  factory CopyWith$Variables$Mutation$ResendEmailChange.stub(TRes res) =
      _CopyWithStubImpl$Variables$Mutation$ResendEmailChange;

  TRes call({Input$ResendEmailChangeInput? input});
}

class _CopyWithImpl$Variables$Mutation$ResendEmailChange<TRes>
    implements CopyWith$Variables$Mutation$ResendEmailChange<TRes> {
  _CopyWithImpl$Variables$Mutation$ResendEmailChange(
    this._instance,
    this._then,
  );

  final Variables$Mutation$ResendEmailChange _instance;

  final TRes Function(Variables$Mutation$ResendEmailChange) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? input = _undefined}) => _then(
    Variables$Mutation$ResendEmailChange._({
      ..._instance._$data,
      if (input != _undefined && input != null)
        'input': (input as Input$ResendEmailChangeInput),
    }),
  );
}

class _CopyWithStubImpl$Variables$Mutation$ResendEmailChange<TRes>
    implements CopyWith$Variables$Mutation$ResendEmailChange<TRes> {
  _CopyWithStubImpl$Variables$Mutation$ResendEmailChange(this._res);

  TRes _res;

  call({Input$ResendEmailChangeInput? input}) => _res;
}

class Mutation$ResendEmailChange {
  Mutation$ResendEmailChange({required this.resendEmailChange});

  factory Mutation$ResendEmailChange.fromJson(Map<String, dynamic> json) {
    final l$resendEmailChange = json['resendEmailChange'];
    return Mutation$ResendEmailChange(
      resendEmailChange: Mutation$ResendEmailChange$resendEmailChange.fromJson(
        (l$resendEmailChange as Map<String, dynamic>),
      ),
    );
  }

  final Mutation$ResendEmailChange$resendEmailChange resendEmailChange;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$resendEmailChange = resendEmailChange;
    _resultData['resendEmailChange'] = l$resendEmailChange.toJson();
    return _resultData;
  }

  @override
  int get hashCode {
    final l$resendEmailChange = resendEmailChange;
    return Object.hashAll([l$resendEmailChange]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$ResendEmailChange ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$resendEmailChange = resendEmailChange;
    final lOther$resendEmailChange = other.resendEmailChange;
    if (l$resendEmailChange != lOther$resendEmailChange) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Mutation$ResendEmailChange
    on Mutation$ResendEmailChange {
  CopyWith$Mutation$ResendEmailChange<Mutation$ResendEmailChange>
  get copyWith => CopyWith$Mutation$ResendEmailChange(this, (i) => i);
}

abstract class CopyWith$Mutation$ResendEmailChange<TRes> {
  factory CopyWith$Mutation$ResendEmailChange(
    Mutation$ResendEmailChange instance,
    TRes Function(Mutation$ResendEmailChange) then,
  ) = _CopyWithImpl$Mutation$ResendEmailChange;

  factory CopyWith$Mutation$ResendEmailChange.stub(TRes res) =
      _CopyWithStubImpl$Mutation$ResendEmailChange;

  TRes call({Mutation$ResendEmailChange$resendEmailChange? resendEmailChange});
  CopyWith$Mutation$ResendEmailChange$resendEmailChange<TRes>
  get resendEmailChange;
}

class _CopyWithImpl$Mutation$ResendEmailChange<TRes>
    implements CopyWith$Mutation$ResendEmailChange<TRes> {
  _CopyWithImpl$Mutation$ResendEmailChange(this._instance, this._then);

  final Mutation$ResendEmailChange _instance;

  final TRes Function(Mutation$ResendEmailChange) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? resendEmailChange = _undefined}) => _then(
    Mutation$ResendEmailChange(
      resendEmailChange:
          resendEmailChange == _undefined || resendEmailChange == null
          ? _instance.resendEmailChange
          : (resendEmailChange as Mutation$ResendEmailChange$resendEmailChange),
    ),
  );

  CopyWith$Mutation$ResendEmailChange$resendEmailChange<TRes>
  get resendEmailChange {
    final local$resendEmailChange = _instance.resendEmailChange;
    return CopyWith$Mutation$ResendEmailChange$resendEmailChange(
      local$resendEmailChange,
      (e) => call(resendEmailChange: e),
    );
  }
}

class _CopyWithStubImpl$Mutation$ResendEmailChange<TRes>
    implements CopyWith$Mutation$ResendEmailChange<TRes> {
  _CopyWithStubImpl$Mutation$ResendEmailChange(this._res);

  TRes _res;

  call({Mutation$ResendEmailChange$resendEmailChange? resendEmailChange}) =>
      _res;

  CopyWith$Mutation$ResendEmailChange$resendEmailChange<TRes>
  get resendEmailChange =>
      CopyWith$Mutation$ResendEmailChange$resendEmailChange.stub(_res);
}

const documentNodeMutationResendEmailChange = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'ResendEmailChange'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'input')),
          type: NamedTypeNode(
            name: NameNode(value: 'ResendEmailChangeInput'),
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
            name: NameNode(value: 'resendEmailChange'),
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

class Mutation$ResendEmailChange$resendEmailChange {
  Mutation$ResendEmailChange$resendEmailChange({
    required this.success,
    required this.userErrors,
    this.verificationId,
    this.expiresAt,
  });

  factory Mutation$ResendEmailChange$resendEmailChange.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$success = json['success'];
    final l$userErrors = json['userErrors'];
    final l$verificationId = json['verificationId'];
    final l$expiresAt = json['expiresAt'];
    return Mutation$ResendEmailChange$resendEmailChange(
      success: (l$success as bool),
      userErrors: (l$userErrors as List<dynamic>)
          .map(
            (e) =>
                Mutation$ResendEmailChange$resendEmailChange$userErrors.fromJson(
                  (e as Map<String, dynamic>),
                ),
          )
          .toList(),
      verificationId: (l$verificationId as String?),
      expiresAt: (l$expiresAt as String?),
    );
  }

  final bool success;

  final List<Mutation$ResendEmailChange$resendEmailChange$userErrors>
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
    if (other is! Mutation$ResendEmailChange$resendEmailChange ||
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

extension UtilityExtension$Mutation$ResendEmailChange$resendEmailChange
    on Mutation$ResendEmailChange$resendEmailChange {
  CopyWith$Mutation$ResendEmailChange$resendEmailChange<
    Mutation$ResendEmailChange$resendEmailChange
  >
  get copyWith =>
      CopyWith$Mutation$ResendEmailChange$resendEmailChange(this, (i) => i);
}

abstract class CopyWith$Mutation$ResendEmailChange$resendEmailChange<TRes> {
  factory CopyWith$Mutation$ResendEmailChange$resendEmailChange(
    Mutation$ResendEmailChange$resendEmailChange instance,
    TRes Function(Mutation$ResendEmailChange$resendEmailChange) then,
  ) = _CopyWithImpl$Mutation$ResendEmailChange$resendEmailChange;

  factory CopyWith$Mutation$ResendEmailChange$resendEmailChange.stub(TRes res) =
      _CopyWithStubImpl$Mutation$ResendEmailChange$resendEmailChange;

  TRes call({
    bool? success,
    List<Mutation$ResendEmailChange$resendEmailChange$userErrors>? userErrors,
    String? verificationId,
    String? expiresAt,
  });
  TRes userErrors(
    Iterable<Mutation$ResendEmailChange$resendEmailChange$userErrors> Function(
      Iterable<
        CopyWith$Mutation$ResendEmailChange$resendEmailChange$userErrors<
          Mutation$ResendEmailChange$resendEmailChange$userErrors
        >
      >,
    )
    _fn,
  );
}

class _CopyWithImpl$Mutation$ResendEmailChange$resendEmailChange<TRes>
    implements CopyWith$Mutation$ResendEmailChange$resendEmailChange<TRes> {
  _CopyWithImpl$Mutation$ResendEmailChange$resendEmailChange(
    this._instance,
    this._then,
  );

  final Mutation$ResendEmailChange$resendEmailChange _instance;

  final TRes Function(Mutation$ResendEmailChange$resendEmailChange) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? success = _undefined,
    Object? userErrors = _undefined,
    Object? verificationId = _undefined,
    Object? expiresAt = _undefined,
  }) => _then(
    Mutation$ResendEmailChange$resendEmailChange(
      success: success == _undefined || success == null
          ? _instance.success
          : (success as bool),
      userErrors: userErrors == _undefined || userErrors == null
          ? _instance.userErrors
          : (userErrors
                as List<
                  Mutation$ResendEmailChange$resendEmailChange$userErrors
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
    Iterable<Mutation$ResendEmailChange$resendEmailChange$userErrors> Function(
      Iterable<
        CopyWith$Mutation$ResendEmailChange$resendEmailChange$userErrors<
          Mutation$ResendEmailChange$resendEmailChange$userErrors
        >
      >,
    )
    _fn,
  ) => call(
    userErrors: _fn(
      _instance.userErrors.map(
        (e) => CopyWith$Mutation$ResendEmailChange$resendEmailChange$userErrors(
          e,
          (i) => i,
        ),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl$Mutation$ResendEmailChange$resendEmailChange<TRes>
    implements CopyWith$Mutation$ResendEmailChange$resendEmailChange<TRes> {
  _CopyWithStubImpl$Mutation$ResendEmailChange$resendEmailChange(this._res);

  TRes _res;

  call({
    bool? success,
    List<Mutation$ResendEmailChange$resendEmailChange$userErrors>? userErrors,
    String? verificationId,
    String? expiresAt,
  }) => _res;

  userErrors(_fn) => _res;
}

class Mutation$ResendEmailChange$resendEmailChange$userErrors {
  Mutation$ResendEmailChange$resendEmailChange$userErrors({
    required this.code,
    required this.message,
    this.field,
  });

  factory Mutation$ResendEmailChange$resendEmailChange$userErrors.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$code = json['code'];
    final l$message = json['message'];
    final l$field = json['field'];
    return Mutation$ResendEmailChange$resendEmailChange$userErrors(
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
    if (other is! Mutation$ResendEmailChange$resendEmailChange$userErrors ||
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

extension UtilityExtension$Mutation$ResendEmailChange$resendEmailChange$userErrors
    on Mutation$ResendEmailChange$resendEmailChange$userErrors {
  CopyWith$Mutation$ResendEmailChange$resendEmailChange$userErrors<
    Mutation$ResendEmailChange$resendEmailChange$userErrors
  >
  get copyWith =>
      CopyWith$Mutation$ResendEmailChange$resendEmailChange$userErrors(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Mutation$ResendEmailChange$resendEmailChange$userErrors<
  TRes
> {
  factory CopyWith$Mutation$ResendEmailChange$resendEmailChange$userErrors(
    Mutation$ResendEmailChange$resendEmailChange$userErrors instance,
    TRes Function(Mutation$ResendEmailChange$resendEmailChange$userErrors) then,
  ) = _CopyWithImpl$Mutation$ResendEmailChange$resendEmailChange$userErrors;

  factory CopyWith$Mutation$ResendEmailChange$resendEmailChange$userErrors.stub(
    TRes res,
  ) = _CopyWithStubImpl$Mutation$ResendEmailChange$resendEmailChange$userErrors;

  TRes call({String? code, String? message, String? field});
}

class _CopyWithImpl$Mutation$ResendEmailChange$resendEmailChange$userErrors<
  TRes
>
    implements
        CopyWith$Mutation$ResendEmailChange$resendEmailChange$userErrors<TRes> {
  _CopyWithImpl$Mutation$ResendEmailChange$resendEmailChange$userErrors(
    this._instance,
    this._then,
  );

  final Mutation$ResendEmailChange$resendEmailChange$userErrors _instance;

  final TRes Function(Mutation$ResendEmailChange$resendEmailChange$userErrors)
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? code = _undefined,
    Object? message = _undefined,
    Object? field = _undefined,
  }) => _then(
    Mutation$ResendEmailChange$resendEmailChange$userErrors(
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

class _CopyWithStubImpl$Mutation$ResendEmailChange$resendEmailChange$userErrors<
  TRes
>
    implements
        CopyWith$Mutation$ResendEmailChange$resendEmailChange$userErrors<TRes> {
  _CopyWithStubImpl$Mutation$ResendEmailChange$resendEmailChange$userErrors(
    this._res,
  );

  TRes _res;

  call({String? code, String? message, String? field}) => _res;
}
