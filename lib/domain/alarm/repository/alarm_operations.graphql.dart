// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, unused_element
import 'alarm_schema.graphql.dart';
import 'package:gql/ast.dart';

class Variables$Mutation$RegisterDeviceToken {
  factory Variables$Mutation$RegisterDeviceToken({
    required Input$RegisterDeviceTokenInput input,
  }) => Variables$Mutation$RegisterDeviceToken._({r'input': input});

  Variables$Mutation$RegisterDeviceToken._(this._$data);

  factory Variables$Mutation$RegisterDeviceToken.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    final l$input = data['input'];
    result$data['input'] = Input$RegisterDeviceTokenInput.fromJson(
      (l$input as Map<String, dynamic>),
    );
    return Variables$Mutation$RegisterDeviceToken._(result$data);
  }

  Map<String, dynamic> _$data;

  Input$RegisterDeviceTokenInput get input =>
      (_$data['input'] as Input$RegisterDeviceTokenInput);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$input = input;
    result$data['input'] = l$input.toJson();
    return result$data;
  }

  CopyWith$Variables$Mutation$RegisterDeviceToken<
    Variables$Mutation$RegisterDeviceToken
  >
  get copyWith =>
      CopyWith$Variables$Mutation$RegisterDeviceToken(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Mutation$RegisterDeviceToken ||
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

abstract class CopyWith$Variables$Mutation$RegisterDeviceToken<TRes> {
  factory CopyWith$Variables$Mutation$RegisterDeviceToken(
    Variables$Mutation$RegisterDeviceToken instance,
    TRes Function(Variables$Mutation$RegisterDeviceToken) then,
  ) = _CopyWithImpl$Variables$Mutation$RegisterDeviceToken;

  factory CopyWith$Variables$Mutation$RegisterDeviceToken.stub(TRes res) =
      _CopyWithStubImpl$Variables$Mutation$RegisterDeviceToken;

  TRes call({Input$RegisterDeviceTokenInput? input});
}

class _CopyWithImpl$Variables$Mutation$RegisterDeviceToken<TRes>
    implements CopyWith$Variables$Mutation$RegisterDeviceToken<TRes> {
  _CopyWithImpl$Variables$Mutation$RegisterDeviceToken(
    this._instance,
    this._then,
  );

  final Variables$Mutation$RegisterDeviceToken _instance;

  final TRes Function(Variables$Mutation$RegisterDeviceToken) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? input = _undefined}) => _then(
    Variables$Mutation$RegisterDeviceToken._({
      ..._instance._$data,
      if (input != _undefined && input != null)
        'input': (input as Input$RegisterDeviceTokenInput),
    }),
  );
}

class _CopyWithStubImpl$Variables$Mutation$RegisterDeviceToken<TRes>
    implements CopyWith$Variables$Mutation$RegisterDeviceToken<TRes> {
  _CopyWithStubImpl$Variables$Mutation$RegisterDeviceToken(this._res);

  TRes _res;

  call({Input$RegisterDeviceTokenInput? input}) => _res;
}

class Mutation$RegisterDeviceToken {
  Mutation$RegisterDeviceToken({required this.registerDeviceToken});

  factory Mutation$RegisterDeviceToken.fromJson(Map<String, dynamic> json) {
    final l$registerDeviceToken = json['registerDeviceToken'];
    return Mutation$RegisterDeviceToken(
      registerDeviceToken:
          Mutation$RegisterDeviceToken$registerDeviceToken.fromJson(
            (l$registerDeviceToken as Map<String, dynamic>),
          ),
    );
  }

  final Mutation$RegisterDeviceToken$registerDeviceToken registerDeviceToken;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$registerDeviceToken = registerDeviceToken;
    _resultData['registerDeviceToken'] = l$registerDeviceToken.toJson();
    return _resultData;
  }

  @override
  int get hashCode {
    final l$registerDeviceToken = registerDeviceToken;
    return Object.hashAll([l$registerDeviceToken]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$RegisterDeviceToken ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$registerDeviceToken = registerDeviceToken;
    final lOther$registerDeviceToken = other.registerDeviceToken;
    if (l$registerDeviceToken != lOther$registerDeviceToken) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Mutation$RegisterDeviceToken
    on Mutation$RegisterDeviceToken {
  CopyWith$Mutation$RegisterDeviceToken<Mutation$RegisterDeviceToken>
  get copyWith => CopyWith$Mutation$RegisterDeviceToken(this, (i) => i);
}

abstract class CopyWith$Mutation$RegisterDeviceToken<TRes> {
  factory CopyWith$Mutation$RegisterDeviceToken(
    Mutation$RegisterDeviceToken instance,
    TRes Function(Mutation$RegisterDeviceToken) then,
  ) = _CopyWithImpl$Mutation$RegisterDeviceToken;

  factory CopyWith$Mutation$RegisterDeviceToken.stub(TRes res) =
      _CopyWithStubImpl$Mutation$RegisterDeviceToken;

  TRes call({
    Mutation$RegisterDeviceToken$registerDeviceToken? registerDeviceToken,
  });
  CopyWith$Mutation$RegisterDeviceToken$registerDeviceToken<TRes>
  get registerDeviceToken;
}

class _CopyWithImpl$Mutation$RegisterDeviceToken<TRes>
    implements CopyWith$Mutation$RegisterDeviceToken<TRes> {
  _CopyWithImpl$Mutation$RegisterDeviceToken(this._instance, this._then);

  final Mutation$RegisterDeviceToken _instance;

  final TRes Function(Mutation$RegisterDeviceToken) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? registerDeviceToken = _undefined}) => _then(
    Mutation$RegisterDeviceToken(
      registerDeviceToken:
          registerDeviceToken == _undefined || registerDeviceToken == null
          ? _instance.registerDeviceToken
          : (registerDeviceToken
                as Mutation$RegisterDeviceToken$registerDeviceToken),
    ),
  );

  CopyWith$Mutation$RegisterDeviceToken$registerDeviceToken<TRes>
  get registerDeviceToken {
    final local$registerDeviceToken = _instance.registerDeviceToken;
    return CopyWith$Mutation$RegisterDeviceToken$registerDeviceToken(
      local$registerDeviceToken,
      (e) => call(registerDeviceToken: e),
    );
  }
}

class _CopyWithStubImpl$Mutation$RegisterDeviceToken<TRes>
    implements CopyWith$Mutation$RegisterDeviceToken<TRes> {
  _CopyWithStubImpl$Mutation$RegisterDeviceToken(this._res);

  TRes _res;

  call({
    Mutation$RegisterDeviceToken$registerDeviceToken? registerDeviceToken,
  }) => _res;

  CopyWith$Mutation$RegisterDeviceToken$registerDeviceToken<TRes>
  get registerDeviceToken =>
      CopyWith$Mutation$RegisterDeviceToken$registerDeviceToken.stub(_res);
}

const documentNodeMutationRegisterDeviceToken = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'RegisterDeviceToken'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'input')),
          type: NamedTypeNode(
            name: NameNode(value: 'RegisterDeviceTokenInput'),
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
            name: NameNode(value: 'registerDeviceToken'),
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
              ],
            ),
          ),
        ],
      ),
    ),
  ],
);

class Mutation$RegisterDeviceToken$registerDeviceToken {
  Mutation$RegisterDeviceToken$registerDeviceToken({
    required this.success,
    required this.userErrors,
  });

  factory Mutation$RegisterDeviceToken$registerDeviceToken.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$success = json['success'];
    final l$userErrors = json['userErrors'];
    return Mutation$RegisterDeviceToken$registerDeviceToken(
      success: (l$success as bool),
      userErrors: (l$userErrors as List<dynamic>)
          .map(
            (e) =>
                Mutation$RegisterDeviceToken$registerDeviceToken$userErrors.fromJson(
                  (e as Map<String, dynamic>),
                ),
          )
          .toList(),
    );
  }

  final bool success;

  final List<Mutation$RegisterDeviceToken$registerDeviceToken$userErrors>
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
    if (other is! Mutation$RegisterDeviceToken$registerDeviceToken ||
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

extension UtilityExtension$Mutation$RegisterDeviceToken$registerDeviceToken
    on Mutation$RegisterDeviceToken$registerDeviceToken {
  CopyWith$Mutation$RegisterDeviceToken$registerDeviceToken<
    Mutation$RegisterDeviceToken$registerDeviceToken
  >
  get copyWith =>
      CopyWith$Mutation$RegisterDeviceToken$registerDeviceToken(this, (i) => i);
}

abstract class CopyWith$Mutation$RegisterDeviceToken$registerDeviceToken<TRes> {
  factory CopyWith$Mutation$RegisterDeviceToken$registerDeviceToken(
    Mutation$RegisterDeviceToken$registerDeviceToken instance,
    TRes Function(Mutation$RegisterDeviceToken$registerDeviceToken) then,
  ) = _CopyWithImpl$Mutation$RegisterDeviceToken$registerDeviceToken;

  factory CopyWith$Mutation$RegisterDeviceToken$registerDeviceToken.stub(
    TRes res,
  ) = _CopyWithStubImpl$Mutation$RegisterDeviceToken$registerDeviceToken;

  TRes call({
    bool? success,
    List<Mutation$RegisterDeviceToken$registerDeviceToken$userErrors>?
    userErrors,
  });
  TRes userErrors(
    Iterable<Mutation$RegisterDeviceToken$registerDeviceToken$userErrors>
    Function(
      Iterable<
        CopyWith$Mutation$RegisterDeviceToken$registerDeviceToken$userErrors<
          Mutation$RegisterDeviceToken$registerDeviceToken$userErrors
        >
      >,
    )
    _fn,
  );
}

class _CopyWithImpl$Mutation$RegisterDeviceToken$registerDeviceToken<TRes>
    implements CopyWith$Mutation$RegisterDeviceToken$registerDeviceToken<TRes> {
  _CopyWithImpl$Mutation$RegisterDeviceToken$registerDeviceToken(
    this._instance,
    this._then,
  );

  final Mutation$RegisterDeviceToken$registerDeviceToken _instance;

  final TRes Function(Mutation$RegisterDeviceToken$registerDeviceToken) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? success = _undefined,
    Object? userErrors = _undefined,
  }) => _then(
    Mutation$RegisterDeviceToken$registerDeviceToken(
      success: success == _undefined || success == null
          ? _instance.success
          : (success as bool),
      userErrors: userErrors == _undefined || userErrors == null
          ? _instance.userErrors
          : (userErrors
                as List<
                  Mutation$RegisterDeviceToken$registerDeviceToken$userErrors
                >),
    ),
  );

  TRes userErrors(
    Iterable<Mutation$RegisterDeviceToken$registerDeviceToken$userErrors>
    Function(
      Iterable<
        CopyWith$Mutation$RegisterDeviceToken$registerDeviceToken$userErrors<
          Mutation$RegisterDeviceToken$registerDeviceToken$userErrors
        >
      >,
    )
    _fn,
  ) => call(
    userErrors: _fn(
      _instance.userErrors.map(
        (e) =>
            CopyWith$Mutation$RegisterDeviceToken$registerDeviceToken$userErrors(
              e,
              (i) => i,
            ),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl$Mutation$RegisterDeviceToken$registerDeviceToken<TRes>
    implements CopyWith$Mutation$RegisterDeviceToken$registerDeviceToken<TRes> {
  _CopyWithStubImpl$Mutation$RegisterDeviceToken$registerDeviceToken(this._res);

  TRes _res;

  call({
    bool? success,
    List<Mutation$RegisterDeviceToken$registerDeviceToken$userErrors>?
    userErrors,
  }) => _res;

  userErrors(_fn) => _res;
}

class Mutation$RegisterDeviceToken$registerDeviceToken$userErrors {
  Mutation$RegisterDeviceToken$registerDeviceToken$userErrors({
    required this.code,
    required this.message,
    this.field,
  });

  factory Mutation$RegisterDeviceToken$registerDeviceToken$userErrors.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$code = json['code'];
    final l$message = json['message'];
    final l$field = json['field'];
    return Mutation$RegisterDeviceToken$registerDeviceToken$userErrors(
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
    if (other is! Mutation$RegisterDeviceToken$registerDeviceToken$userErrors ||
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

extension UtilityExtension$Mutation$RegisterDeviceToken$registerDeviceToken$userErrors
    on Mutation$RegisterDeviceToken$registerDeviceToken$userErrors {
  CopyWith$Mutation$RegisterDeviceToken$registerDeviceToken$userErrors<
    Mutation$RegisterDeviceToken$registerDeviceToken$userErrors
  >
  get copyWith =>
      CopyWith$Mutation$RegisterDeviceToken$registerDeviceToken$userErrors(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Mutation$RegisterDeviceToken$registerDeviceToken$userErrors<
  TRes
> {
  factory CopyWith$Mutation$RegisterDeviceToken$registerDeviceToken$userErrors(
    Mutation$RegisterDeviceToken$registerDeviceToken$userErrors instance,
    TRes Function(Mutation$RegisterDeviceToken$registerDeviceToken$userErrors)
    then,
  ) = _CopyWithImpl$Mutation$RegisterDeviceToken$registerDeviceToken$userErrors;

  factory CopyWith$Mutation$RegisterDeviceToken$registerDeviceToken$userErrors.stub(
    TRes res,
  ) = _CopyWithStubImpl$Mutation$RegisterDeviceToken$registerDeviceToken$userErrors;

  TRes call({String? code, String? message, String? field});
}

class _CopyWithImpl$Mutation$RegisterDeviceToken$registerDeviceToken$userErrors<
  TRes
>
    implements
        CopyWith$Mutation$RegisterDeviceToken$registerDeviceToken$userErrors<
          TRes
        > {
  _CopyWithImpl$Mutation$RegisterDeviceToken$registerDeviceToken$userErrors(
    this._instance,
    this._then,
  );

  final Mutation$RegisterDeviceToken$registerDeviceToken$userErrors _instance;

  final TRes Function(
    Mutation$RegisterDeviceToken$registerDeviceToken$userErrors,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? code = _undefined,
    Object? message = _undefined,
    Object? field = _undefined,
  }) => _then(
    Mutation$RegisterDeviceToken$registerDeviceToken$userErrors(
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

class _CopyWithStubImpl$Mutation$RegisterDeviceToken$registerDeviceToken$userErrors<
  TRes
>
    implements
        CopyWith$Mutation$RegisterDeviceToken$registerDeviceToken$userErrors<
          TRes
        > {
  _CopyWithStubImpl$Mutation$RegisterDeviceToken$registerDeviceToken$userErrors(
    this._res,
  );

  TRes _res;

  call({String? code, String? message, String? field}) => _res;
}

class Variables$Mutation$DeleteDeviceToken {
  factory Variables$Mutation$DeleteDeviceToken({
    required Input$DeleteDeviceTokenInput input,
  }) => Variables$Mutation$DeleteDeviceToken._({r'input': input});

  Variables$Mutation$DeleteDeviceToken._(this._$data);

  factory Variables$Mutation$DeleteDeviceToken.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    final l$input = data['input'];
    result$data['input'] = Input$DeleteDeviceTokenInput.fromJson(
      (l$input as Map<String, dynamic>),
    );
    return Variables$Mutation$DeleteDeviceToken._(result$data);
  }

  Map<String, dynamic> _$data;

  Input$DeleteDeviceTokenInput get input =>
      (_$data['input'] as Input$DeleteDeviceTokenInput);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$input = input;
    result$data['input'] = l$input.toJson();
    return result$data;
  }

  CopyWith$Variables$Mutation$DeleteDeviceToken<
    Variables$Mutation$DeleteDeviceToken
  >
  get copyWith => CopyWith$Variables$Mutation$DeleteDeviceToken(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Mutation$DeleteDeviceToken ||
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

abstract class CopyWith$Variables$Mutation$DeleteDeviceToken<TRes> {
  factory CopyWith$Variables$Mutation$DeleteDeviceToken(
    Variables$Mutation$DeleteDeviceToken instance,
    TRes Function(Variables$Mutation$DeleteDeviceToken) then,
  ) = _CopyWithImpl$Variables$Mutation$DeleteDeviceToken;

  factory CopyWith$Variables$Mutation$DeleteDeviceToken.stub(TRes res) =
      _CopyWithStubImpl$Variables$Mutation$DeleteDeviceToken;

  TRes call({Input$DeleteDeviceTokenInput? input});
}

class _CopyWithImpl$Variables$Mutation$DeleteDeviceToken<TRes>
    implements CopyWith$Variables$Mutation$DeleteDeviceToken<TRes> {
  _CopyWithImpl$Variables$Mutation$DeleteDeviceToken(
    this._instance,
    this._then,
  );

  final Variables$Mutation$DeleteDeviceToken _instance;

  final TRes Function(Variables$Mutation$DeleteDeviceToken) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? input = _undefined}) => _then(
    Variables$Mutation$DeleteDeviceToken._({
      ..._instance._$data,
      if (input != _undefined && input != null)
        'input': (input as Input$DeleteDeviceTokenInput),
    }),
  );
}

class _CopyWithStubImpl$Variables$Mutation$DeleteDeviceToken<TRes>
    implements CopyWith$Variables$Mutation$DeleteDeviceToken<TRes> {
  _CopyWithStubImpl$Variables$Mutation$DeleteDeviceToken(this._res);

  TRes _res;

  call({Input$DeleteDeviceTokenInput? input}) => _res;
}

class Mutation$DeleteDeviceToken {
  Mutation$DeleteDeviceToken({required this.deleteDeviceToken});

  factory Mutation$DeleteDeviceToken.fromJson(Map<String, dynamic> json) {
    final l$deleteDeviceToken = json['deleteDeviceToken'];
    return Mutation$DeleteDeviceToken(
      deleteDeviceToken: Mutation$DeleteDeviceToken$deleteDeviceToken.fromJson(
        (l$deleteDeviceToken as Map<String, dynamic>),
      ),
    );
  }

  final Mutation$DeleteDeviceToken$deleteDeviceToken deleteDeviceToken;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$deleteDeviceToken = deleteDeviceToken;
    _resultData['deleteDeviceToken'] = l$deleteDeviceToken.toJson();
    return _resultData;
  }

  @override
  int get hashCode {
    final l$deleteDeviceToken = deleteDeviceToken;
    return Object.hashAll([l$deleteDeviceToken]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$DeleteDeviceToken ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$deleteDeviceToken = deleteDeviceToken;
    final lOther$deleteDeviceToken = other.deleteDeviceToken;
    if (l$deleteDeviceToken != lOther$deleteDeviceToken) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Mutation$DeleteDeviceToken
    on Mutation$DeleteDeviceToken {
  CopyWith$Mutation$DeleteDeviceToken<Mutation$DeleteDeviceToken>
  get copyWith => CopyWith$Mutation$DeleteDeviceToken(this, (i) => i);
}

abstract class CopyWith$Mutation$DeleteDeviceToken<TRes> {
  factory CopyWith$Mutation$DeleteDeviceToken(
    Mutation$DeleteDeviceToken instance,
    TRes Function(Mutation$DeleteDeviceToken) then,
  ) = _CopyWithImpl$Mutation$DeleteDeviceToken;

  factory CopyWith$Mutation$DeleteDeviceToken.stub(TRes res) =
      _CopyWithStubImpl$Mutation$DeleteDeviceToken;

  TRes call({Mutation$DeleteDeviceToken$deleteDeviceToken? deleteDeviceToken});
  CopyWith$Mutation$DeleteDeviceToken$deleteDeviceToken<TRes>
  get deleteDeviceToken;
}

class _CopyWithImpl$Mutation$DeleteDeviceToken<TRes>
    implements CopyWith$Mutation$DeleteDeviceToken<TRes> {
  _CopyWithImpl$Mutation$DeleteDeviceToken(this._instance, this._then);

  final Mutation$DeleteDeviceToken _instance;

  final TRes Function(Mutation$DeleteDeviceToken) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? deleteDeviceToken = _undefined}) => _then(
    Mutation$DeleteDeviceToken(
      deleteDeviceToken:
          deleteDeviceToken == _undefined || deleteDeviceToken == null
          ? _instance.deleteDeviceToken
          : (deleteDeviceToken as Mutation$DeleteDeviceToken$deleteDeviceToken),
    ),
  );

  CopyWith$Mutation$DeleteDeviceToken$deleteDeviceToken<TRes>
  get deleteDeviceToken {
    final local$deleteDeviceToken = _instance.deleteDeviceToken;
    return CopyWith$Mutation$DeleteDeviceToken$deleteDeviceToken(
      local$deleteDeviceToken,
      (e) => call(deleteDeviceToken: e),
    );
  }
}

class _CopyWithStubImpl$Mutation$DeleteDeviceToken<TRes>
    implements CopyWith$Mutation$DeleteDeviceToken<TRes> {
  _CopyWithStubImpl$Mutation$DeleteDeviceToken(this._res);

  TRes _res;

  call({Mutation$DeleteDeviceToken$deleteDeviceToken? deleteDeviceToken}) =>
      _res;

  CopyWith$Mutation$DeleteDeviceToken$deleteDeviceToken<TRes>
  get deleteDeviceToken =>
      CopyWith$Mutation$DeleteDeviceToken$deleteDeviceToken.stub(_res);
}

const documentNodeMutationDeleteDeviceToken = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'DeleteDeviceToken'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'input')),
          type: NamedTypeNode(
            name: NameNode(value: 'DeleteDeviceTokenInput'),
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
            name: NameNode(value: 'deleteDeviceToken'),
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
              ],
            ),
          ),
        ],
      ),
    ),
  ],
);

class Mutation$DeleteDeviceToken$deleteDeviceToken {
  Mutation$DeleteDeviceToken$deleteDeviceToken({
    required this.success,
    required this.userErrors,
  });

  factory Mutation$DeleteDeviceToken$deleteDeviceToken.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$success = json['success'];
    final l$userErrors = json['userErrors'];
    return Mutation$DeleteDeviceToken$deleteDeviceToken(
      success: (l$success as bool),
      userErrors: (l$userErrors as List<dynamic>)
          .map(
            (e) =>
                Mutation$DeleteDeviceToken$deleteDeviceToken$userErrors.fromJson(
                  (e as Map<String, dynamic>),
                ),
          )
          .toList(),
    );
  }

  final bool success;

  final List<Mutation$DeleteDeviceToken$deleteDeviceToken$userErrors>
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
    if (other is! Mutation$DeleteDeviceToken$deleteDeviceToken ||
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

extension UtilityExtension$Mutation$DeleteDeviceToken$deleteDeviceToken
    on Mutation$DeleteDeviceToken$deleteDeviceToken {
  CopyWith$Mutation$DeleteDeviceToken$deleteDeviceToken<
    Mutation$DeleteDeviceToken$deleteDeviceToken
  >
  get copyWith =>
      CopyWith$Mutation$DeleteDeviceToken$deleteDeviceToken(this, (i) => i);
}

abstract class CopyWith$Mutation$DeleteDeviceToken$deleteDeviceToken<TRes> {
  factory CopyWith$Mutation$DeleteDeviceToken$deleteDeviceToken(
    Mutation$DeleteDeviceToken$deleteDeviceToken instance,
    TRes Function(Mutation$DeleteDeviceToken$deleteDeviceToken) then,
  ) = _CopyWithImpl$Mutation$DeleteDeviceToken$deleteDeviceToken;

  factory CopyWith$Mutation$DeleteDeviceToken$deleteDeviceToken.stub(TRes res) =
      _CopyWithStubImpl$Mutation$DeleteDeviceToken$deleteDeviceToken;

  TRes call({
    bool? success,
    List<Mutation$DeleteDeviceToken$deleteDeviceToken$userErrors>? userErrors,
  });
  TRes userErrors(
    Iterable<Mutation$DeleteDeviceToken$deleteDeviceToken$userErrors> Function(
      Iterable<
        CopyWith$Mutation$DeleteDeviceToken$deleteDeviceToken$userErrors<
          Mutation$DeleteDeviceToken$deleteDeviceToken$userErrors
        >
      >,
    )
    _fn,
  );
}

class _CopyWithImpl$Mutation$DeleteDeviceToken$deleteDeviceToken<TRes>
    implements CopyWith$Mutation$DeleteDeviceToken$deleteDeviceToken<TRes> {
  _CopyWithImpl$Mutation$DeleteDeviceToken$deleteDeviceToken(
    this._instance,
    this._then,
  );

  final Mutation$DeleteDeviceToken$deleteDeviceToken _instance;

  final TRes Function(Mutation$DeleteDeviceToken$deleteDeviceToken) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? success = _undefined, Object? userErrors = _undefined}) =>
      _then(
        Mutation$DeleteDeviceToken$deleteDeviceToken(
          success: success == _undefined || success == null
              ? _instance.success
              : (success as bool),
          userErrors: userErrors == _undefined || userErrors == null
              ? _instance.userErrors
              : (userErrors
                    as List<
                      Mutation$DeleteDeviceToken$deleteDeviceToken$userErrors
                    >),
        ),
      );

  TRes userErrors(
    Iterable<Mutation$DeleteDeviceToken$deleteDeviceToken$userErrors> Function(
      Iterable<
        CopyWith$Mutation$DeleteDeviceToken$deleteDeviceToken$userErrors<
          Mutation$DeleteDeviceToken$deleteDeviceToken$userErrors
        >
      >,
    )
    _fn,
  ) => call(
    userErrors: _fn(
      _instance.userErrors.map(
        (e) => CopyWith$Mutation$DeleteDeviceToken$deleteDeviceToken$userErrors(
          e,
          (i) => i,
        ),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl$Mutation$DeleteDeviceToken$deleteDeviceToken<TRes>
    implements CopyWith$Mutation$DeleteDeviceToken$deleteDeviceToken<TRes> {
  _CopyWithStubImpl$Mutation$DeleteDeviceToken$deleteDeviceToken(this._res);

  TRes _res;

  call({
    bool? success,
    List<Mutation$DeleteDeviceToken$deleteDeviceToken$userErrors>? userErrors,
  }) => _res;

  userErrors(_fn) => _res;
}

class Mutation$DeleteDeviceToken$deleteDeviceToken$userErrors {
  Mutation$DeleteDeviceToken$deleteDeviceToken$userErrors({
    required this.code,
    required this.message,
    this.field,
  });

  factory Mutation$DeleteDeviceToken$deleteDeviceToken$userErrors.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$code = json['code'];
    final l$message = json['message'];
    final l$field = json['field'];
    return Mutation$DeleteDeviceToken$deleteDeviceToken$userErrors(
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
    if (other is! Mutation$DeleteDeviceToken$deleteDeviceToken$userErrors ||
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

extension UtilityExtension$Mutation$DeleteDeviceToken$deleteDeviceToken$userErrors
    on Mutation$DeleteDeviceToken$deleteDeviceToken$userErrors {
  CopyWith$Mutation$DeleteDeviceToken$deleteDeviceToken$userErrors<
    Mutation$DeleteDeviceToken$deleteDeviceToken$userErrors
  >
  get copyWith =>
      CopyWith$Mutation$DeleteDeviceToken$deleteDeviceToken$userErrors(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Mutation$DeleteDeviceToken$deleteDeviceToken$userErrors<
  TRes
> {
  factory CopyWith$Mutation$DeleteDeviceToken$deleteDeviceToken$userErrors(
    Mutation$DeleteDeviceToken$deleteDeviceToken$userErrors instance,
    TRes Function(Mutation$DeleteDeviceToken$deleteDeviceToken$userErrors) then,
  ) = _CopyWithImpl$Mutation$DeleteDeviceToken$deleteDeviceToken$userErrors;

  factory CopyWith$Mutation$DeleteDeviceToken$deleteDeviceToken$userErrors.stub(
    TRes res,
  ) = _CopyWithStubImpl$Mutation$DeleteDeviceToken$deleteDeviceToken$userErrors;

  TRes call({String? code, String? message, String? field});
}

class _CopyWithImpl$Mutation$DeleteDeviceToken$deleteDeviceToken$userErrors<
  TRes
>
    implements
        CopyWith$Mutation$DeleteDeviceToken$deleteDeviceToken$userErrors<TRes> {
  _CopyWithImpl$Mutation$DeleteDeviceToken$deleteDeviceToken$userErrors(
    this._instance,
    this._then,
  );

  final Mutation$DeleteDeviceToken$deleteDeviceToken$userErrors _instance;

  final TRes Function(Mutation$DeleteDeviceToken$deleteDeviceToken$userErrors)
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? code = _undefined,
    Object? message = _undefined,
    Object? field = _undefined,
  }) => _then(
    Mutation$DeleteDeviceToken$deleteDeviceToken$userErrors(
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

class _CopyWithStubImpl$Mutation$DeleteDeviceToken$deleteDeviceToken$userErrors<
  TRes
>
    implements
        CopyWith$Mutation$DeleteDeviceToken$deleteDeviceToken$userErrors<TRes> {
  _CopyWithStubImpl$Mutation$DeleteDeviceToken$deleteDeviceToken$userErrors(
    this._res,
  );

  TRes _res;

  call({String? code, String? message, String? field}) => _res;
}

class Query$NotificationPreferences {
  Query$NotificationPreferences({required this.me});

  factory Query$NotificationPreferences.fromJson(Map<String, dynamic> json) {
    final l$me = json['me'];
    return Query$NotificationPreferences(
      me: Query$NotificationPreferences$me.fromJson(
        (l$me as Map<String, dynamic>),
      ),
    );
  }

  final Query$NotificationPreferences$me me;

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
    if (other is! Query$NotificationPreferences ||
        runtimeType != other.runtimeType) {
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

extension UtilityExtension$Query$NotificationPreferences
    on Query$NotificationPreferences {
  CopyWith$Query$NotificationPreferences<Query$NotificationPreferences>
  get copyWith => CopyWith$Query$NotificationPreferences(this, (i) => i);
}

abstract class CopyWith$Query$NotificationPreferences<TRes> {
  factory CopyWith$Query$NotificationPreferences(
    Query$NotificationPreferences instance,
    TRes Function(Query$NotificationPreferences) then,
  ) = _CopyWithImpl$Query$NotificationPreferences;

  factory CopyWith$Query$NotificationPreferences.stub(TRes res) =
      _CopyWithStubImpl$Query$NotificationPreferences;

  TRes call({Query$NotificationPreferences$me? me});
  CopyWith$Query$NotificationPreferences$me<TRes> get me;
}

class _CopyWithImpl$Query$NotificationPreferences<TRes>
    implements CopyWith$Query$NotificationPreferences<TRes> {
  _CopyWithImpl$Query$NotificationPreferences(this._instance, this._then);

  final Query$NotificationPreferences _instance;

  final TRes Function(Query$NotificationPreferences) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? me = _undefined}) => _then(
    Query$NotificationPreferences(
      me: me == _undefined || me == null
          ? _instance.me
          : (me as Query$NotificationPreferences$me),
    ),
  );

  CopyWith$Query$NotificationPreferences$me<TRes> get me {
    final local$me = _instance.me;
    return CopyWith$Query$NotificationPreferences$me(
      local$me,
      (e) => call(me: e),
    );
  }
}

class _CopyWithStubImpl$Query$NotificationPreferences<TRes>
    implements CopyWith$Query$NotificationPreferences<TRes> {
  _CopyWithStubImpl$Query$NotificationPreferences(this._res);

  TRes _res;

  call({Query$NotificationPreferences$me? me}) => _res;

  CopyWith$Query$NotificationPreferences$me<TRes> get me =>
      CopyWith$Query$NotificationPreferences$me.stub(_res);
}

const documentNodeQueryNotificationPreferences = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'NotificationPreferences'),
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
                  name: NameNode(value: 'notificationPreferences'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: SelectionSetNode(
                    selections: [
                      FieldNode(
                        name: NameNode(value: 'category'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'enabled'),
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

class Query$NotificationPreferences$me {
  Query$NotificationPreferences$me({required this.notificationPreferences});

  factory Query$NotificationPreferences$me.fromJson(Map<String, dynamic> json) {
    final l$notificationPreferences = json['notificationPreferences'];
    return Query$NotificationPreferences$me(
      notificationPreferences: (l$notificationPreferences as List<dynamic>)
          .map(
            (e) =>
                Query$NotificationPreferences$me$notificationPreferences.fromJson(
                  (e as Map<String, dynamic>),
                ),
          )
          .toList(),
    );
  }

  final List<Query$NotificationPreferences$me$notificationPreferences>
  notificationPreferences;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$notificationPreferences = notificationPreferences;
    _resultData['notificationPreferences'] = l$notificationPreferences
        .map((e) => e.toJson())
        .toList();
    return _resultData;
  }

  @override
  int get hashCode {
    final l$notificationPreferences = notificationPreferences;
    return Object.hashAll([
      Object.hashAll(l$notificationPreferences.map((v) => v)),
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$NotificationPreferences$me ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$notificationPreferences = notificationPreferences;
    final lOther$notificationPreferences = other.notificationPreferences;
    if (l$notificationPreferences.length !=
        lOther$notificationPreferences.length) {
      return false;
    }
    for (int i = 0; i < l$notificationPreferences.length; i++) {
      final l$notificationPreferences$entry = l$notificationPreferences[i];
      final lOther$notificationPreferences$entry =
          lOther$notificationPreferences[i];
      if (l$notificationPreferences$entry !=
          lOther$notificationPreferences$entry) {
        return false;
      }
    }
    return true;
  }
}

extension UtilityExtension$Query$NotificationPreferences$me
    on Query$NotificationPreferences$me {
  CopyWith$Query$NotificationPreferences$me<Query$NotificationPreferences$me>
  get copyWith => CopyWith$Query$NotificationPreferences$me(this, (i) => i);
}

abstract class CopyWith$Query$NotificationPreferences$me<TRes> {
  factory CopyWith$Query$NotificationPreferences$me(
    Query$NotificationPreferences$me instance,
    TRes Function(Query$NotificationPreferences$me) then,
  ) = _CopyWithImpl$Query$NotificationPreferences$me;

  factory CopyWith$Query$NotificationPreferences$me.stub(TRes res) =
      _CopyWithStubImpl$Query$NotificationPreferences$me;

  TRes call({
    List<Query$NotificationPreferences$me$notificationPreferences>?
    notificationPreferences,
  });
  TRes notificationPreferences(
    Iterable<Query$NotificationPreferences$me$notificationPreferences> Function(
      Iterable<
        CopyWith$Query$NotificationPreferences$me$notificationPreferences<
          Query$NotificationPreferences$me$notificationPreferences
        >
      >,
    )
    _fn,
  );
}

class _CopyWithImpl$Query$NotificationPreferences$me<TRes>
    implements CopyWith$Query$NotificationPreferences$me<TRes> {
  _CopyWithImpl$Query$NotificationPreferences$me(this._instance, this._then);

  final Query$NotificationPreferences$me _instance;

  final TRes Function(Query$NotificationPreferences$me) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? notificationPreferences = _undefined}) => _then(
    Query$NotificationPreferences$me(
      notificationPreferences:
          notificationPreferences == _undefined ||
              notificationPreferences == null
          ? _instance.notificationPreferences
          : (notificationPreferences
                as List<
                  Query$NotificationPreferences$me$notificationPreferences
                >),
    ),
  );

  TRes notificationPreferences(
    Iterable<Query$NotificationPreferences$me$notificationPreferences> Function(
      Iterable<
        CopyWith$Query$NotificationPreferences$me$notificationPreferences<
          Query$NotificationPreferences$me$notificationPreferences
        >
      >,
    )
    _fn,
  ) => call(
    notificationPreferences: _fn(
      _instance.notificationPreferences.map(
        (e) =>
            CopyWith$Query$NotificationPreferences$me$notificationPreferences(
              e,
              (i) => i,
            ),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl$Query$NotificationPreferences$me<TRes>
    implements CopyWith$Query$NotificationPreferences$me<TRes> {
  _CopyWithStubImpl$Query$NotificationPreferences$me(this._res);

  TRes _res;

  call({
    List<Query$NotificationPreferences$me$notificationPreferences>?
    notificationPreferences,
  }) => _res;

  notificationPreferences(_fn) => _res;
}

class Query$NotificationPreferences$me$notificationPreferences {
  Query$NotificationPreferences$me$notificationPreferences({
    required this.category,
    required this.enabled,
  });

  factory Query$NotificationPreferences$me$notificationPreferences.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$category = json['category'];
    final l$enabled = json['enabled'];
    return Query$NotificationPreferences$me$notificationPreferences(
      category: fromJson$Enum$NotificationCategory((l$category as String)),
      enabled: (l$enabled as bool),
    );
  }

  final Enum$NotificationCategory category;

  final bool enabled;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$category = category;
    _resultData['category'] = toJson$Enum$NotificationCategory(l$category);
    final l$enabled = enabled;
    _resultData['enabled'] = l$enabled;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$category = category;
    final l$enabled = enabled;
    return Object.hashAll([l$category, l$enabled]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$NotificationPreferences$me$notificationPreferences ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$category = category;
    final lOther$category = other.category;
    if (l$category != lOther$category) {
      return false;
    }
    final l$enabled = enabled;
    final lOther$enabled = other.enabled;
    if (l$enabled != lOther$enabled) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Query$NotificationPreferences$me$notificationPreferences
    on Query$NotificationPreferences$me$notificationPreferences {
  CopyWith$Query$NotificationPreferences$me$notificationPreferences<
    Query$NotificationPreferences$me$notificationPreferences
  >
  get copyWith =>
      CopyWith$Query$NotificationPreferences$me$notificationPreferences(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Query$NotificationPreferences$me$notificationPreferences<
  TRes
> {
  factory CopyWith$Query$NotificationPreferences$me$notificationPreferences(
    Query$NotificationPreferences$me$notificationPreferences instance,
    TRes Function(Query$NotificationPreferences$me$notificationPreferences)
    then,
  ) = _CopyWithImpl$Query$NotificationPreferences$me$notificationPreferences;

  factory CopyWith$Query$NotificationPreferences$me$notificationPreferences.stub(
    TRes res,
  ) = _CopyWithStubImpl$Query$NotificationPreferences$me$notificationPreferences;

  TRes call({Enum$NotificationCategory? category, bool? enabled});
}

class _CopyWithImpl$Query$NotificationPreferences$me$notificationPreferences<
  TRes
>
    implements
        CopyWith$Query$NotificationPreferences$me$notificationPreferences<
          TRes
        > {
  _CopyWithImpl$Query$NotificationPreferences$me$notificationPreferences(
    this._instance,
    this._then,
  );

  final Query$NotificationPreferences$me$notificationPreferences _instance;

  final TRes Function(Query$NotificationPreferences$me$notificationPreferences)
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? category = _undefined, Object? enabled = _undefined}) =>
      _then(
        Query$NotificationPreferences$me$notificationPreferences(
          category: category == _undefined || category == null
              ? _instance.category
              : (category as Enum$NotificationCategory),
          enabled: enabled == _undefined || enabled == null
              ? _instance.enabled
              : (enabled as bool),
        ),
      );
}

class _CopyWithStubImpl$Query$NotificationPreferences$me$notificationPreferences<
  TRes
>
    implements
        CopyWith$Query$NotificationPreferences$me$notificationPreferences<
          TRes
        > {
  _CopyWithStubImpl$Query$NotificationPreferences$me$notificationPreferences(
    this._res,
  );

  TRes _res;

  call({Enum$NotificationCategory? category, bool? enabled}) => _res;
}

class Variables$Mutation$UpdateNotificationPreference {
  factory Variables$Mutation$UpdateNotificationPreference({
    required Input$UpdateNotificationPreferenceInput input,
  }) => Variables$Mutation$UpdateNotificationPreference._({r'input': input});

  Variables$Mutation$UpdateNotificationPreference._(this._$data);

  factory Variables$Mutation$UpdateNotificationPreference.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    final l$input = data['input'];
    result$data['input'] = Input$UpdateNotificationPreferenceInput.fromJson(
      (l$input as Map<String, dynamic>),
    );
    return Variables$Mutation$UpdateNotificationPreference._(result$data);
  }

  Map<String, dynamic> _$data;

  Input$UpdateNotificationPreferenceInput get input =>
      (_$data['input'] as Input$UpdateNotificationPreferenceInput);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$input = input;
    result$data['input'] = l$input.toJson();
    return result$data;
  }

  CopyWith$Variables$Mutation$UpdateNotificationPreference<
    Variables$Mutation$UpdateNotificationPreference
  >
  get copyWith =>
      CopyWith$Variables$Mutation$UpdateNotificationPreference(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Mutation$UpdateNotificationPreference ||
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

abstract class CopyWith$Variables$Mutation$UpdateNotificationPreference<TRes> {
  factory CopyWith$Variables$Mutation$UpdateNotificationPreference(
    Variables$Mutation$UpdateNotificationPreference instance,
    TRes Function(Variables$Mutation$UpdateNotificationPreference) then,
  ) = _CopyWithImpl$Variables$Mutation$UpdateNotificationPreference;

  factory CopyWith$Variables$Mutation$UpdateNotificationPreference.stub(
    TRes res,
  ) = _CopyWithStubImpl$Variables$Mutation$UpdateNotificationPreference;

  TRes call({Input$UpdateNotificationPreferenceInput? input});
}

class _CopyWithImpl$Variables$Mutation$UpdateNotificationPreference<TRes>
    implements CopyWith$Variables$Mutation$UpdateNotificationPreference<TRes> {
  _CopyWithImpl$Variables$Mutation$UpdateNotificationPreference(
    this._instance,
    this._then,
  );

  final Variables$Mutation$UpdateNotificationPreference _instance;

  final TRes Function(Variables$Mutation$UpdateNotificationPreference) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? input = _undefined}) => _then(
    Variables$Mutation$UpdateNotificationPreference._({
      ..._instance._$data,
      if (input != _undefined && input != null)
        'input': (input as Input$UpdateNotificationPreferenceInput),
    }),
  );
}

class _CopyWithStubImpl$Variables$Mutation$UpdateNotificationPreference<TRes>
    implements CopyWith$Variables$Mutation$UpdateNotificationPreference<TRes> {
  _CopyWithStubImpl$Variables$Mutation$UpdateNotificationPreference(this._res);

  TRes _res;

  call({Input$UpdateNotificationPreferenceInput? input}) => _res;
}

class Mutation$UpdateNotificationPreference {
  Mutation$UpdateNotificationPreference({
    required this.updateNotificationPreference,
  });

  factory Mutation$UpdateNotificationPreference.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$updateNotificationPreference = json['updateNotificationPreference'];
    return Mutation$UpdateNotificationPreference(
      updateNotificationPreference:
          Mutation$UpdateNotificationPreference$updateNotificationPreference.fromJson(
            (l$updateNotificationPreference as Map<String, dynamic>),
          ),
    );
  }

  final Mutation$UpdateNotificationPreference$updateNotificationPreference
  updateNotificationPreference;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$updateNotificationPreference = updateNotificationPreference;
    _resultData['updateNotificationPreference'] = l$updateNotificationPreference
        .toJson();
    return _resultData;
  }

  @override
  int get hashCode {
    final l$updateNotificationPreference = updateNotificationPreference;
    return Object.hashAll([l$updateNotificationPreference]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$UpdateNotificationPreference ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$updateNotificationPreference = updateNotificationPreference;
    final lOther$updateNotificationPreference =
        other.updateNotificationPreference;
    if (l$updateNotificationPreference != lOther$updateNotificationPreference) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Mutation$UpdateNotificationPreference
    on Mutation$UpdateNotificationPreference {
  CopyWith$Mutation$UpdateNotificationPreference<
    Mutation$UpdateNotificationPreference
  >
  get copyWith =>
      CopyWith$Mutation$UpdateNotificationPreference(this, (i) => i);
}

abstract class CopyWith$Mutation$UpdateNotificationPreference<TRes> {
  factory CopyWith$Mutation$UpdateNotificationPreference(
    Mutation$UpdateNotificationPreference instance,
    TRes Function(Mutation$UpdateNotificationPreference) then,
  ) = _CopyWithImpl$Mutation$UpdateNotificationPreference;

  factory CopyWith$Mutation$UpdateNotificationPreference.stub(TRes res) =
      _CopyWithStubImpl$Mutation$UpdateNotificationPreference;

  TRes call({
    Mutation$UpdateNotificationPreference$updateNotificationPreference?
    updateNotificationPreference,
  });
  CopyWith$Mutation$UpdateNotificationPreference$updateNotificationPreference<
    TRes
  >
  get updateNotificationPreference;
}

class _CopyWithImpl$Mutation$UpdateNotificationPreference<TRes>
    implements CopyWith$Mutation$UpdateNotificationPreference<TRes> {
  _CopyWithImpl$Mutation$UpdateNotificationPreference(
    this._instance,
    this._then,
  );

  final Mutation$UpdateNotificationPreference _instance;

  final TRes Function(Mutation$UpdateNotificationPreference) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? updateNotificationPreference = _undefined}) => _then(
    Mutation$UpdateNotificationPreference(
      updateNotificationPreference:
          updateNotificationPreference == _undefined ||
              updateNotificationPreference == null
          ? _instance.updateNotificationPreference
          : (updateNotificationPreference
                as Mutation$UpdateNotificationPreference$updateNotificationPreference),
    ),
  );

  CopyWith$Mutation$UpdateNotificationPreference$updateNotificationPreference<
    TRes
  >
  get updateNotificationPreference {
    final local$updateNotificationPreference =
        _instance.updateNotificationPreference;
    return CopyWith$Mutation$UpdateNotificationPreference$updateNotificationPreference(
      local$updateNotificationPreference,
      (e) => call(updateNotificationPreference: e),
    );
  }
}

class _CopyWithStubImpl$Mutation$UpdateNotificationPreference<TRes>
    implements CopyWith$Mutation$UpdateNotificationPreference<TRes> {
  _CopyWithStubImpl$Mutation$UpdateNotificationPreference(this._res);

  TRes _res;

  call({
    Mutation$UpdateNotificationPreference$updateNotificationPreference?
    updateNotificationPreference,
  }) => _res;

  CopyWith$Mutation$UpdateNotificationPreference$updateNotificationPreference<
    TRes
  >
  get updateNotificationPreference =>
      CopyWith$Mutation$UpdateNotificationPreference$updateNotificationPreference.stub(
        _res,
      );
}

const documentNodeMutationUpdateNotificationPreference = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'UpdateNotificationPreference'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'input')),
          type: NamedTypeNode(
            name: NameNode(value: 'UpdateNotificationPreferenceInput'),
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
            name: NameNode(value: 'updateNotificationPreference'),
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
                  name: NameNode(value: 'notificationPreferences'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: SelectionSetNode(
                    selections: [
                      FieldNode(
                        name: NameNode(value: 'category'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'enabled'),
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

class Mutation$UpdateNotificationPreference$updateNotificationPreference {
  Mutation$UpdateNotificationPreference$updateNotificationPreference({
    required this.success,
    required this.userErrors,
    required this.notificationPreferences,
  });

  factory Mutation$UpdateNotificationPreference$updateNotificationPreference.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$success = json['success'];
    final l$userErrors = json['userErrors'];
    final l$notificationPreferences = json['notificationPreferences'];
    return Mutation$UpdateNotificationPreference$updateNotificationPreference(
      success: (l$success as bool),
      userErrors: (l$userErrors as List<dynamic>)
          .map(
            (e) =>
                Mutation$UpdateNotificationPreference$updateNotificationPreference$userErrors.fromJson(
                  (e as Map<String, dynamic>),
                ),
          )
          .toList(),
      notificationPreferences: (l$notificationPreferences as List<dynamic>)
          .map(
            (e) =>
                Mutation$UpdateNotificationPreference$updateNotificationPreference$notificationPreferences.fromJson(
                  (e as Map<String, dynamic>),
                ),
          )
          .toList(),
    );
  }

  final bool success;

  final List<
    Mutation$UpdateNotificationPreference$updateNotificationPreference$userErrors
  >
  userErrors;

  final List<
    Mutation$UpdateNotificationPreference$updateNotificationPreference$notificationPreferences
  >
  notificationPreferences;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$success = success;
    _resultData['success'] = l$success;
    final l$userErrors = userErrors;
    _resultData['userErrors'] = l$userErrors.map((e) => e.toJson()).toList();
    final l$notificationPreferences = notificationPreferences;
    _resultData['notificationPreferences'] = l$notificationPreferences
        .map((e) => e.toJson())
        .toList();
    return _resultData;
  }

  @override
  int get hashCode {
    final l$success = success;
    final l$userErrors = userErrors;
    final l$notificationPreferences = notificationPreferences;
    return Object.hashAll([
      l$success,
      Object.hashAll(l$userErrors.map((v) => v)),
      Object.hashAll(l$notificationPreferences.map((v) => v)),
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Mutation$UpdateNotificationPreference$updateNotificationPreference ||
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
    final l$notificationPreferences = notificationPreferences;
    final lOther$notificationPreferences = other.notificationPreferences;
    if (l$notificationPreferences.length !=
        lOther$notificationPreferences.length) {
      return false;
    }
    for (int i = 0; i < l$notificationPreferences.length; i++) {
      final l$notificationPreferences$entry = l$notificationPreferences[i];
      final lOther$notificationPreferences$entry =
          lOther$notificationPreferences[i];
      if (l$notificationPreferences$entry !=
          lOther$notificationPreferences$entry) {
        return false;
      }
    }
    return true;
  }
}

extension UtilityExtension$Mutation$UpdateNotificationPreference$updateNotificationPreference
    on Mutation$UpdateNotificationPreference$updateNotificationPreference {
  CopyWith$Mutation$UpdateNotificationPreference$updateNotificationPreference<
    Mutation$UpdateNotificationPreference$updateNotificationPreference
  >
  get copyWith =>
      CopyWith$Mutation$UpdateNotificationPreference$updateNotificationPreference(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Mutation$UpdateNotificationPreference$updateNotificationPreference<
  TRes
> {
  factory CopyWith$Mutation$UpdateNotificationPreference$updateNotificationPreference(
    Mutation$UpdateNotificationPreference$updateNotificationPreference instance,
    TRes Function(
      Mutation$UpdateNotificationPreference$updateNotificationPreference,
    )
    then,
  ) = _CopyWithImpl$Mutation$UpdateNotificationPreference$updateNotificationPreference;

  factory CopyWith$Mutation$UpdateNotificationPreference$updateNotificationPreference.stub(
    TRes res,
  ) = _CopyWithStubImpl$Mutation$UpdateNotificationPreference$updateNotificationPreference;

  TRes call({
    bool? success,
    List<
      Mutation$UpdateNotificationPreference$updateNotificationPreference$userErrors
    >?
    userErrors,
    List<
      Mutation$UpdateNotificationPreference$updateNotificationPreference$notificationPreferences
    >?
    notificationPreferences,
  });
  TRes userErrors(
    Iterable<
      Mutation$UpdateNotificationPreference$updateNotificationPreference$userErrors
    >
    Function(
      Iterable<
        CopyWith$Mutation$UpdateNotificationPreference$updateNotificationPreference$userErrors<
          Mutation$UpdateNotificationPreference$updateNotificationPreference$userErrors
        >
      >,
    )
    _fn,
  );
  TRes notificationPreferences(
    Iterable<
      Mutation$UpdateNotificationPreference$updateNotificationPreference$notificationPreferences
    >
    Function(
      Iterable<
        CopyWith$Mutation$UpdateNotificationPreference$updateNotificationPreference$notificationPreferences<
          Mutation$UpdateNotificationPreference$updateNotificationPreference$notificationPreferences
        >
      >,
    )
    _fn,
  );
}

class _CopyWithImpl$Mutation$UpdateNotificationPreference$updateNotificationPreference<
  TRes
>
    implements
        CopyWith$Mutation$UpdateNotificationPreference$updateNotificationPreference<
          TRes
        > {
  _CopyWithImpl$Mutation$UpdateNotificationPreference$updateNotificationPreference(
    this._instance,
    this._then,
  );

  final Mutation$UpdateNotificationPreference$updateNotificationPreference
  _instance;

  final TRes Function(
    Mutation$UpdateNotificationPreference$updateNotificationPreference,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? success = _undefined,
    Object? userErrors = _undefined,
    Object? notificationPreferences = _undefined,
  }) => _then(
    Mutation$UpdateNotificationPreference$updateNotificationPreference(
      success: success == _undefined || success == null
          ? _instance.success
          : (success as bool),
      userErrors: userErrors == _undefined || userErrors == null
          ? _instance.userErrors
          : (userErrors
                as List<
                  Mutation$UpdateNotificationPreference$updateNotificationPreference$userErrors
                >),
      notificationPreferences:
          notificationPreferences == _undefined ||
              notificationPreferences == null
          ? _instance.notificationPreferences
          : (notificationPreferences
                as List<
                  Mutation$UpdateNotificationPreference$updateNotificationPreference$notificationPreferences
                >),
    ),
  );

  TRes userErrors(
    Iterable<
      Mutation$UpdateNotificationPreference$updateNotificationPreference$userErrors
    >
    Function(
      Iterable<
        CopyWith$Mutation$UpdateNotificationPreference$updateNotificationPreference$userErrors<
          Mutation$UpdateNotificationPreference$updateNotificationPreference$userErrors
        >
      >,
    )
    _fn,
  ) => call(
    userErrors: _fn(
      _instance.userErrors.map(
        (e) =>
            CopyWith$Mutation$UpdateNotificationPreference$updateNotificationPreference$userErrors(
              e,
              (i) => i,
            ),
      ),
    ).toList(),
  );

  TRes notificationPreferences(
    Iterable<
      Mutation$UpdateNotificationPreference$updateNotificationPreference$notificationPreferences
    >
    Function(
      Iterable<
        CopyWith$Mutation$UpdateNotificationPreference$updateNotificationPreference$notificationPreferences<
          Mutation$UpdateNotificationPreference$updateNotificationPreference$notificationPreferences
        >
      >,
    )
    _fn,
  ) => call(
    notificationPreferences: _fn(
      _instance.notificationPreferences.map(
        (e) =>
            CopyWith$Mutation$UpdateNotificationPreference$updateNotificationPreference$notificationPreferences(
              e,
              (i) => i,
            ),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl$Mutation$UpdateNotificationPreference$updateNotificationPreference<
  TRes
>
    implements
        CopyWith$Mutation$UpdateNotificationPreference$updateNotificationPreference<
          TRes
        > {
  _CopyWithStubImpl$Mutation$UpdateNotificationPreference$updateNotificationPreference(
    this._res,
  );

  TRes _res;

  call({
    bool? success,
    List<
      Mutation$UpdateNotificationPreference$updateNotificationPreference$userErrors
    >?
    userErrors,
    List<
      Mutation$UpdateNotificationPreference$updateNotificationPreference$notificationPreferences
    >?
    notificationPreferences,
  }) => _res;

  userErrors(_fn) => _res;

  notificationPreferences(_fn) => _res;
}

class Mutation$UpdateNotificationPreference$updateNotificationPreference$userErrors {
  Mutation$UpdateNotificationPreference$updateNotificationPreference$userErrors({
    required this.code,
    required this.message,
    this.field,
  });

  factory Mutation$UpdateNotificationPreference$updateNotificationPreference$userErrors.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$code = json['code'];
    final l$message = json['message'];
    final l$field = json['field'];
    return Mutation$UpdateNotificationPreference$updateNotificationPreference$userErrors(
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
    if (other
            is! Mutation$UpdateNotificationPreference$updateNotificationPreference$userErrors ||
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

extension UtilityExtension$Mutation$UpdateNotificationPreference$updateNotificationPreference$userErrors
    on Mutation$UpdateNotificationPreference$updateNotificationPreference$userErrors {
  CopyWith$Mutation$UpdateNotificationPreference$updateNotificationPreference$userErrors<
    Mutation$UpdateNotificationPreference$updateNotificationPreference$userErrors
  >
  get copyWith =>
      CopyWith$Mutation$UpdateNotificationPreference$updateNotificationPreference$userErrors(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Mutation$UpdateNotificationPreference$updateNotificationPreference$userErrors<
  TRes
> {
  factory CopyWith$Mutation$UpdateNotificationPreference$updateNotificationPreference$userErrors(
    Mutation$UpdateNotificationPreference$updateNotificationPreference$userErrors
    instance,
    TRes Function(
      Mutation$UpdateNotificationPreference$updateNotificationPreference$userErrors,
    )
    then,
  ) = _CopyWithImpl$Mutation$UpdateNotificationPreference$updateNotificationPreference$userErrors;

  factory CopyWith$Mutation$UpdateNotificationPreference$updateNotificationPreference$userErrors.stub(
    TRes res,
  ) = _CopyWithStubImpl$Mutation$UpdateNotificationPreference$updateNotificationPreference$userErrors;

  TRes call({String? code, String? message, String? field});
}

class _CopyWithImpl$Mutation$UpdateNotificationPreference$updateNotificationPreference$userErrors<
  TRes
>
    implements
        CopyWith$Mutation$UpdateNotificationPreference$updateNotificationPreference$userErrors<
          TRes
        > {
  _CopyWithImpl$Mutation$UpdateNotificationPreference$updateNotificationPreference$userErrors(
    this._instance,
    this._then,
  );

  final Mutation$UpdateNotificationPreference$updateNotificationPreference$userErrors
  _instance;

  final TRes Function(
    Mutation$UpdateNotificationPreference$updateNotificationPreference$userErrors,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? code = _undefined,
    Object? message = _undefined,
    Object? field = _undefined,
  }) => _then(
    Mutation$UpdateNotificationPreference$updateNotificationPreference$userErrors(
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

class _CopyWithStubImpl$Mutation$UpdateNotificationPreference$updateNotificationPreference$userErrors<
  TRes
>
    implements
        CopyWith$Mutation$UpdateNotificationPreference$updateNotificationPreference$userErrors<
          TRes
        > {
  _CopyWithStubImpl$Mutation$UpdateNotificationPreference$updateNotificationPreference$userErrors(
    this._res,
  );

  TRes _res;

  call({String? code, String? message, String? field}) => _res;
}

class Mutation$UpdateNotificationPreference$updateNotificationPreference$notificationPreferences {
  Mutation$UpdateNotificationPreference$updateNotificationPreference$notificationPreferences({
    required this.category,
    required this.enabled,
  });

  factory Mutation$UpdateNotificationPreference$updateNotificationPreference$notificationPreferences.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$category = json['category'];
    final l$enabled = json['enabled'];
    return Mutation$UpdateNotificationPreference$updateNotificationPreference$notificationPreferences(
      category: fromJson$Enum$NotificationCategory((l$category as String)),
      enabled: (l$enabled as bool),
    );
  }

  final Enum$NotificationCategory category;

  final bool enabled;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$category = category;
    _resultData['category'] = toJson$Enum$NotificationCategory(l$category);
    final l$enabled = enabled;
    _resultData['enabled'] = l$enabled;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$category = category;
    final l$enabled = enabled;
    return Object.hashAll([l$category, l$enabled]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Mutation$UpdateNotificationPreference$updateNotificationPreference$notificationPreferences ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$category = category;
    final lOther$category = other.category;
    if (l$category != lOther$category) {
      return false;
    }
    final l$enabled = enabled;
    final lOther$enabled = other.enabled;
    if (l$enabled != lOther$enabled) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Mutation$UpdateNotificationPreference$updateNotificationPreference$notificationPreferences
    on
        Mutation$UpdateNotificationPreference$updateNotificationPreference$notificationPreferences {
  CopyWith$Mutation$UpdateNotificationPreference$updateNotificationPreference$notificationPreferences<
    Mutation$UpdateNotificationPreference$updateNotificationPreference$notificationPreferences
  >
  get copyWith =>
      CopyWith$Mutation$UpdateNotificationPreference$updateNotificationPreference$notificationPreferences(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Mutation$UpdateNotificationPreference$updateNotificationPreference$notificationPreferences<
  TRes
> {
  factory CopyWith$Mutation$UpdateNotificationPreference$updateNotificationPreference$notificationPreferences(
    Mutation$UpdateNotificationPreference$updateNotificationPreference$notificationPreferences
    instance,
    TRes Function(
      Mutation$UpdateNotificationPreference$updateNotificationPreference$notificationPreferences,
    )
    then,
  ) = _CopyWithImpl$Mutation$UpdateNotificationPreference$updateNotificationPreference$notificationPreferences;

  factory CopyWith$Mutation$UpdateNotificationPreference$updateNotificationPreference$notificationPreferences.stub(
    TRes res,
  ) = _CopyWithStubImpl$Mutation$UpdateNotificationPreference$updateNotificationPreference$notificationPreferences;

  TRes call({Enum$NotificationCategory? category, bool? enabled});
}

class _CopyWithImpl$Mutation$UpdateNotificationPreference$updateNotificationPreference$notificationPreferences<
  TRes
>
    implements
        CopyWith$Mutation$UpdateNotificationPreference$updateNotificationPreference$notificationPreferences<
          TRes
        > {
  _CopyWithImpl$Mutation$UpdateNotificationPreference$updateNotificationPreference$notificationPreferences(
    this._instance,
    this._then,
  );

  final Mutation$UpdateNotificationPreference$updateNotificationPreference$notificationPreferences
  _instance;

  final TRes Function(
    Mutation$UpdateNotificationPreference$updateNotificationPreference$notificationPreferences,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? category = _undefined,
    Object? enabled = _undefined,
  }) => _then(
    Mutation$UpdateNotificationPreference$updateNotificationPreference$notificationPreferences(
      category: category == _undefined || category == null
          ? _instance.category
          : (category as Enum$NotificationCategory),
      enabled: enabled == _undefined || enabled == null
          ? _instance.enabled
          : (enabled as bool),
    ),
  );
}

class _CopyWithStubImpl$Mutation$UpdateNotificationPreference$updateNotificationPreference$notificationPreferences<
  TRes
>
    implements
        CopyWith$Mutation$UpdateNotificationPreference$updateNotificationPreference$notificationPreferences<
          TRes
        > {
  _CopyWithStubImpl$Mutation$UpdateNotificationPreference$updateNotificationPreference$notificationPreferences(
    this._res,
  );

  TRes _res;

  call({Enum$NotificationCategory? category, bool? enabled}) => _res;
}
