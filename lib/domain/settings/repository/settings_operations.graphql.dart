// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, unused_element
import '../../auth/repository/auth_schema.graphql.dart';
import 'package:gql/ast.dart';
import 'settings_schema.graphql.dart';

class Query$Agreements {
  Query$Agreements({required this.agreements});

  factory Query$Agreements.fromJson(Map<String, dynamic> json) {
    final l$agreements = json['agreements'];
    return Query$Agreements(
      agreements: (l$agreements as List<dynamic>)
          .map(
            (e) => Query$Agreements$agreements.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
    );
  }

  final List<Query$Agreements$agreements> agreements;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$agreements = agreements;
    _resultData['agreements'] = l$agreements.map((e) => e.toJson()).toList();
    return _resultData;
  }

  @override
  int get hashCode {
    final l$agreements = agreements;
    return Object.hashAll([Object.hashAll(l$agreements.map((v) => v))]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$Agreements || runtimeType != other.runtimeType) {
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
}

extension UtilityExtension$Query$Agreements on Query$Agreements {
  CopyWith$Query$Agreements<Query$Agreements> get copyWith =>
      CopyWith$Query$Agreements(this, (i) => i);
}

abstract class CopyWith$Query$Agreements<TRes> {
  factory CopyWith$Query$Agreements(
    Query$Agreements instance,
    TRes Function(Query$Agreements) then,
  ) = _CopyWithImpl$Query$Agreements;

  factory CopyWith$Query$Agreements.stub(TRes res) =
      _CopyWithStubImpl$Query$Agreements;

  TRes call({List<Query$Agreements$agreements>? agreements});
  TRes agreements(
    Iterable<Query$Agreements$agreements> Function(
      Iterable<
        CopyWith$Query$Agreements$agreements<Query$Agreements$agreements>
      >,
    )
    _fn,
  );
}

class _CopyWithImpl$Query$Agreements<TRes>
    implements CopyWith$Query$Agreements<TRes> {
  _CopyWithImpl$Query$Agreements(this._instance, this._then);

  final Query$Agreements _instance;

  final TRes Function(Query$Agreements) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? agreements = _undefined}) => _then(
    Query$Agreements(
      agreements: agreements == _undefined || agreements == null
          ? _instance.agreements
          : (agreements as List<Query$Agreements$agreements>),
    ),
  );

  TRes agreements(
    Iterable<Query$Agreements$agreements> Function(
      Iterable<
        CopyWith$Query$Agreements$agreements<Query$Agreements$agreements>
      >,
    )
    _fn,
  ) => call(
    agreements: _fn(
      _instance.agreements.map(
        (e) => CopyWith$Query$Agreements$agreements(e, (i) => i),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl$Query$Agreements<TRes>
    implements CopyWith$Query$Agreements<TRes> {
  _CopyWithStubImpl$Query$Agreements(this._res);

  TRes _res;

  call({List<Query$Agreements$agreements>? agreements}) => _res;

  agreements(_fn) => _res;
}

const documentNodeQueryAgreements = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'Agreements'),
      variableDefinitions: [],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'agreements'),
            alias: null,
            arguments: [],
            directives: [],
            selectionSet: SelectionSetNode(
              selections: [
                FieldNode(
                  name: NameNode(value: 'termsCode'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: 'required'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: 'agreed'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: 'agreedAt'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: 'version'),
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

class Query$Agreements$agreements {
  Query$Agreements$agreements({
    required this.termsCode,
    required this.required,
    required this.agreed,
    this.agreedAt,
    required this.version,
  });

  factory Query$Agreements$agreements.fromJson(Map<String, dynamic> json) {
    final l$termsCode = json['termsCode'];
    final l$required = json['required'];
    final l$agreed = json['agreed'];
    final l$agreedAt = json['agreedAt'];
    final l$version = json['version'];
    return Query$Agreements$agreements(
      termsCode: fromJson$Enum$TermsCode((l$termsCode as String)),
      required: (l$required as bool),
      agreed: (l$agreed as bool),
      agreedAt: (l$agreedAt as String?),
      version: (l$version as String),
    );
  }

  final Enum$TermsCode termsCode;

  final bool required;

  final bool agreed;

  final String? agreedAt;

  final String version;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$termsCode = termsCode;
    _resultData['termsCode'] = toJson$Enum$TermsCode(l$termsCode);
    final l$required = required;
    _resultData['required'] = l$required;
    final l$agreed = agreed;
    _resultData['agreed'] = l$agreed;
    final l$agreedAt = agreedAt;
    _resultData['agreedAt'] = l$agreedAt;
    final l$version = version;
    _resultData['version'] = l$version;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$termsCode = termsCode;
    final l$required = required;
    final l$agreed = agreed;
    final l$agreedAt = agreedAt;
    final l$version = version;
    return Object.hashAll([
      l$termsCode,
      l$required,
      l$agreed,
      l$agreedAt,
      l$version,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$Agreements$agreements ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$termsCode = termsCode;
    final lOther$termsCode = other.termsCode;
    if (l$termsCode != lOther$termsCode) {
      return false;
    }
    final l$required = required;
    final lOther$required = other.required;
    if (l$required != lOther$required) {
      return false;
    }
    final l$agreed = agreed;
    final lOther$agreed = other.agreed;
    if (l$agreed != lOther$agreed) {
      return false;
    }
    final l$agreedAt = agreedAt;
    final lOther$agreedAt = other.agreedAt;
    if (l$agreedAt != lOther$agreedAt) {
      return false;
    }
    final l$version = version;
    final lOther$version = other.version;
    if (l$version != lOther$version) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Query$Agreements$agreements
    on Query$Agreements$agreements {
  CopyWith$Query$Agreements$agreements<Query$Agreements$agreements>
  get copyWith => CopyWith$Query$Agreements$agreements(this, (i) => i);
}

abstract class CopyWith$Query$Agreements$agreements<TRes> {
  factory CopyWith$Query$Agreements$agreements(
    Query$Agreements$agreements instance,
    TRes Function(Query$Agreements$agreements) then,
  ) = _CopyWithImpl$Query$Agreements$agreements;

  factory CopyWith$Query$Agreements$agreements.stub(TRes res) =
      _CopyWithStubImpl$Query$Agreements$agreements;

  TRes call({
    Enum$TermsCode? termsCode,
    bool? required,
    bool? agreed,
    String? agreedAt,
    String? version,
  });
}

class _CopyWithImpl$Query$Agreements$agreements<TRes>
    implements CopyWith$Query$Agreements$agreements<TRes> {
  _CopyWithImpl$Query$Agreements$agreements(this._instance, this._then);

  final Query$Agreements$agreements _instance;

  final TRes Function(Query$Agreements$agreements) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? termsCode = _undefined,
    Object? required = _undefined,
    Object? agreed = _undefined,
    Object? agreedAt = _undefined,
    Object? version = _undefined,
  }) => _then(
    Query$Agreements$agreements(
      termsCode: termsCode == _undefined || termsCode == null
          ? _instance.termsCode
          : (termsCode as Enum$TermsCode),
      required: required == _undefined || required == null
          ? _instance.required
          : (required as bool),
      agreed: agreed == _undefined || agreed == null
          ? _instance.agreed
          : (agreed as bool),
      agreedAt: agreedAt == _undefined
          ? _instance.agreedAt
          : (agreedAt as String?),
      version: version == _undefined || version == null
          ? _instance.version
          : (version as String),
    ),
  );
}

class _CopyWithStubImpl$Query$Agreements$agreements<TRes>
    implements CopyWith$Query$Agreements$agreements<TRes> {
  _CopyWithStubImpl$Query$Agreements$agreements(this._res);

  TRes _res;

  call({
    Enum$TermsCode? termsCode,
    bool? required,
    bool? agreed,
    String? agreedAt,
    String? version,
  }) => _res;
}

class Variables$Mutation$UpdateAgreement {
  factory Variables$Mutation$UpdateAgreement({
    required Input$UpdateAgreementInput input,
  }) => Variables$Mutation$UpdateAgreement._({r'input': input});

  Variables$Mutation$UpdateAgreement._(this._$data);

  factory Variables$Mutation$UpdateAgreement.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    final l$input = data['input'];
    result$data['input'] = Input$UpdateAgreementInput.fromJson(
      (l$input as Map<String, dynamic>),
    );
    return Variables$Mutation$UpdateAgreement._(result$data);
  }

  Map<String, dynamic> _$data;

  Input$UpdateAgreementInput get input =>
      (_$data['input'] as Input$UpdateAgreementInput);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$input = input;
    result$data['input'] = l$input.toJson();
    return result$data;
  }

  CopyWith$Variables$Mutation$UpdateAgreement<
    Variables$Mutation$UpdateAgreement
  >
  get copyWith => CopyWith$Variables$Mutation$UpdateAgreement(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Mutation$UpdateAgreement ||
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

abstract class CopyWith$Variables$Mutation$UpdateAgreement<TRes> {
  factory CopyWith$Variables$Mutation$UpdateAgreement(
    Variables$Mutation$UpdateAgreement instance,
    TRes Function(Variables$Mutation$UpdateAgreement) then,
  ) = _CopyWithImpl$Variables$Mutation$UpdateAgreement;

  factory CopyWith$Variables$Mutation$UpdateAgreement.stub(TRes res) =
      _CopyWithStubImpl$Variables$Mutation$UpdateAgreement;

  TRes call({Input$UpdateAgreementInput? input});
}

class _CopyWithImpl$Variables$Mutation$UpdateAgreement<TRes>
    implements CopyWith$Variables$Mutation$UpdateAgreement<TRes> {
  _CopyWithImpl$Variables$Mutation$UpdateAgreement(this._instance, this._then);

  final Variables$Mutation$UpdateAgreement _instance;

  final TRes Function(Variables$Mutation$UpdateAgreement) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? input = _undefined}) => _then(
    Variables$Mutation$UpdateAgreement._({
      ..._instance._$data,
      if (input != _undefined && input != null)
        'input': (input as Input$UpdateAgreementInput),
    }),
  );
}

class _CopyWithStubImpl$Variables$Mutation$UpdateAgreement<TRes>
    implements CopyWith$Variables$Mutation$UpdateAgreement<TRes> {
  _CopyWithStubImpl$Variables$Mutation$UpdateAgreement(this._res);

  TRes _res;

  call({Input$UpdateAgreementInput? input}) => _res;
}

class Mutation$UpdateAgreement {
  Mutation$UpdateAgreement({required this.updateAgreement});

  factory Mutation$UpdateAgreement.fromJson(Map<String, dynamic> json) {
    final l$updateAgreement = json['updateAgreement'];
    return Mutation$UpdateAgreement(
      updateAgreement: Mutation$UpdateAgreement$updateAgreement.fromJson(
        (l$updateAgreement as Map<String, dynamic>),
      ),
    );
  }

  final Mutation$UpdateAgreement$updateAgreement updateAgreement;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$updateAgreement = updateAgreement;
    _resultData['updateAgreement'] = l$updateAgreement.toJson();
    return _resultData;
  }

  @override
  int get hashCode {
    final l$updateAgreement = updateAgreement;
    return Object.hashAll([l$updateAgreement]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$UpdateAgreement ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$updateAgreement = updateAgreement;
    final lOther$updateAgreement = other.updateAgreement;
    if (l$updateAgreement != lOther$updateAgreement) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Mutation$UpdateAgreement
    on Mutation$UpdateAgreement {
  CopyWith$Mutation$UpdateAgreement<Mutation$UpdateAgreement> get copyWith =>
      CopyWith$Mutation$UpdateAgreement(this, (i) => i);
}

abstract class CopyWith$Mutation$UpdateAgreement<TRes> {
  factory CopyWith$Mutation$UpdateAgreement(
    Mutation$UpdateAgreement instance,
    TRes Function(Mutation$UpdateAgreement) then,
  ) = _CopyWithImpl$Mutation$UpdateAgreement;

  factory CopyWith$Mutation$UpdateAgreement.stub(TRes res) =
      _CopyWithStubImpl$Mutation$UpdateAgreement;

  TRes call({Mutation$UpdateAgreement$updateAgreement? updateAgreement});
  CopyWith$Mutation$UpdateAgreement$updateAgreement<TRes> get updateAgreement;
}

class _CopyWithImpl$Mutation$UpdateAgreement<TRes>
    implements CopyWith$Mutation$UpdateAgreement<TRes> {
  _CopyWithImpl$Mutation$UpdateAgreement(this._instance, this._then);

  final Mutation$UpdateAgreement _instance;

  final TRes Function(Mutation$UpdateAgreement) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? updateAgreement = _undefined}) => _then(
    Mutation$UpdateAgreement(
      updateAgreement: updateAgreement == _undefined || updateAgreement == null
          ? _instance.updateAgreement
          : (updateAgreement as Mutation$UpdateAgreement$updateAgreement),
    ),
  );

  CopyWith$Mutation$UpdateAgreement$updateAgreement<TRes> get updateAgreement {
    final local$updateAgreement = _instance.updateAgreement;
    return CopyWith$Mutation$UpdateAgreement$updateAgreement(
      local$updateAgreement,
      (e) => call(updateAgreement: e),
    );
  }
}

class _CopyWithStubImpl$Mutation$UpdateAgreement<TRes>
    implements CopyWith$Mutation$UpdateAgreement<TRes> {
  _CopyWithStubImpl$Mutation$UpdateAgreement(this._res);

  TRes _res;

  call({Mutation$UpdateAgreement$updateAgreement? updateAgreement}) => _res;

  CopyWith$Mutation$UpdateAgreement$updateAgreement<TRes> get updateAgreement =>
      CopyWith$Mutation$UpdateAgreement$updateAgreement.stub(_res);
}

const documentNodeMutationUpdateAgreement = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'UpdateAgreement'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'input')),
          type: NamedTypeNode(
            name: NameNode(value: 'UpdateAgreementInput'),
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
            name: NameNode(value: 'updateAgreement'),
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
                  name: NameNode(value: 'agreement'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: SelectionSetNode(
                    selections: [
                      FieldNode(
                        name: NameNode(value: 'termsCode'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'required'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'agreed'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'agreedAt'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'version'),
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

class Mutation$UpdateAgreement$updateAgreement {
  Mutation$UpdateAgreement$updateAgreement({
    required this.success,
    required this.userErrors,
    this.agreement,
  });

  factory Mutation$UpdateAgreement$updateAgreement.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$success = json['success'];
    final l$userErrors = json['userErrors'];
    final l$agreement = json['agreement'];
    return Mutation$UpdateAgreement$updateAgreement(
      success: (l$success as bool),
      userErrors: (l$userErrors as List<dynamic>)
          .map(
            (e) => Mutation$UpdateAgreement$updateAgreement$userErrors.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      agreement: l$agreement == null
          ? null
          : Mutation$UpdateAgreement$updateAgreement$agreement.fromJson(
              (l$agreement as Map<String, dynamic>),
            ),
    );
  }

  final bool success;

  final List<Mutation$UpdateAgreement$updateAgreement$userErrors> userErrors;

  final Mutation$UpdateAgreement$updateAgreement$agreement? agreement;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$success = success;
    _resultData['success'] = l$success;
    final l$userErrors = userErrors;
    _resultData['userErrors'] = l$userErrors.map((e) => e.toJson()).toList();
    final l$agreement = agreement;
    _resultData['agreement'] = l$agreement?.toJson();
    return _resultData;
  }

  @override
  int get hashCode {
    final l$success = success;
    final l$userErrors = userErrors;
    final l$agreement = agreement;
    return Object.hashAll([
      l$success,
      Object.hashAll(l$userErrors.map((v) => v)),
      l$agreement,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$UpdateAgreement$updateAgreement ||
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
    final l$agreement = agreement;
    final lOther$agreement = other.agreement;
    if (l$agreement != lOther$agreement) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Mutation$UpdateAgreement$updateAgreement
    on Mutation$UpdateAgreement$updateAgreement {
  CopyWith$Mutation$UpdateAgreement$updateAgreement<
    Mutation$UpdateAgreement$updateAgreement
  >
  get copyWith =>
      CopyWith$Mutation$UpdateAgreement$updateAgreement(this, (i) => i);
}

abstract class CopyWith$Mutation$UpdateAgreement$updateAgreement<TRes> {
  factory CopyWith$Mutation$UpdateAgreement$updateAgreement(
    Mutation$UpdateAgreement$updateAgreement instance,
    TRes Function(Mutation$UpdateAgreement$updateAgreement) then,
  ) = _CopyWithImpl$Mutation$UpdateAgreement$updateAgreement;

  factory CopyWith$Mutation$UpdateAgreement$updateAgreement.stub(TRes res) =
      _CopyWithStubImpl$Mutation$UpdateAgreement$updateAgreement;

  TRes call({
    bool? success,
    List<Mutation$UpdateAgreement$updateAgreement$userErrors>? userErrors,
    Mutation$UpdateAgreement$updateAgreement$agreement? agreement,
  });
  TRes userErrors(
    Iterable<Mutation$UpdateAgreement$updateAgreement$userErrors> Function(
      Iterable<
        CopyWith$Mutation$UpdateAgreement$updateAgreement$userErrors<
          Mutation$UpdateAgreement$updateAgreement$userErrors
        >
      >,
    )
    _fn,
  );
  CopyWith$Mutation$UpdateAgreement$updateAgreement$agreement<TRes>
  get agreement;
}

class _CopyWithImpl$Mutation$UpdateAgreement$updateAgreement<TRes>
    implements CopyWith$Mutation$UpdateAgreement$updateAgreement<TRes> {
  _CopyWithImpl$Mutation$UpdateAgreement$updateAgreement(
    this._instance,
    this._then,
  );

  final Mutation$UpdateAgreement$updateAgreement _instance;

  final TRes Function(Mutation$UpdateAgreement$updateAgreement) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? success = _undefined,
    Object? userErrors = _undefined,
    Object? agreement = _undefined,
  }) => _then(
    Mutation$UpdateAgreement$updateAgreement(
      success: success == _undefined || success == null
          ? _instance.success
          : (success as bool),
      userErrors: userErrors == _undefined || userErrors == null
          ? _instance.userErrors
          : (userErrors
                as List<Mutation$UpdateAgreement$updateAgreement$userErrors>),
      agreement: agreement == _undefined
          ? _instance.agreement
          : (agreement as Mutation$UpdateAgreement$updateAgreement$agreement?),
    ),
  );

  TRes userErrors(
    Iterable<Mutation$UpdateAgreement$updateAgreement$userErrors> Function(
      Iterable<
        CopyWith$Mutation$UpdateAgreement$updateAgreement$userErrors<
          Mutation$UpdateAgreement$updateAgreement$userErrors
        >
      >,
    )
    _fn,
  ) => call(
    userErrors: _fn(
      _instance.userErrors.map(
        (e) => CopyWith$Mutation$UpdateAgreement$updateAgreement$userErrors(
          e,
          (i) => i,
        ),
      ),
    ).toList(),
  );

  CopyWith$Mutation$UpdateAgreement$updateAgreement$agreement<TRes>
  get agreement {
    final local$agreement = _instance.agreement;
    return local$agreement == null
        ? CopyWith$Mutation$UpdateAgreement$updateAgreement$agreement.stub(
            _then(_instance),
          )
        : CopyWith$Mutation$UpdateAgreement$updateAgreement$agreement(
            local$agreement,
            (e) => call(agreement: e),
          );
  }
}

class _CopyWithStubImpl$Mutation$UpdateAgreement$updateAgreement<TRes>
    implements CopyWith$Mutation$UpdateAgreement$updateAgreement<TRes> {
  _CopyWithStubImpl$Mutation$UpdateAgreement$updateAgreement(this._res);

  TRes _res;

  call({
    bool? success,
    List<Mutation$UpdateAgreement$updateAgreement$userErrors>? userErrors,
    Mutation$UpdateAgreement$updateAgreement$agreement? agreement,
  }) => _res;

  userErrors(_fn) => _res;

  CopyWith$Mutation$UpdateAgreement$updateAgreement$agreement<TRes>
  get agreement =>
      CopyWith$Mutation$UpdateAgreement$updateAgreement$agreement.stub(_res);
}

class Mutation$UpdateAgreement$updateAgreement$userErrors {
  Mutation$UpdateAgreement$updateAgreement$userErrors({
    required this.code,
    required this.message,
    this.field,
  });

  factory Mutation$UpdateAgreement$updateAgreement$userErrors.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$code = json['code'];
    final l$message = json['message'];
    final l$field = json['field'];
    return Mutation$UpdateAgreement$updateAgreement$userErrors(
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
    if (other is! Mutation$UpdateAgreement$updateAgreement$userErrors ||
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

extension UtilityExtension$Mutation$UpdateAgreement$updateAgreement$userErrors
    on Mutation$UpdateAgreement$updateAgreement$userErrors {
  CopyWith$Mutation$UpdateAgreement$updateAgreement$userErrors<
    Mutation$UpdateAgreement$updateAgreement$userErrors
  >
  get copyWith => CopyWith$Mutation$UpdateAgreement$updateAgreement$userErrors(
    this,
    (i) => i,
  );
}

abstract class CopyWith$Mutation$UpdateAgreement$updateAgreement$userErrors<
  TRes
> {
  factory CopyWith$Mutation$UpdateAgreement$updateAgreement$userErrors(
    Mutation$UpdateAgreement$updateAgreement$userErrors instance,
    TRes Function(Mutation$UpdateAgreement$updateAgreement$userErrors) then,
  ) = _CopyWithImpl$Mutation$UpdateAgreement$updateAgreement$userErrors;

  factory CopyWith$Mutation$UpdateAgreement$updateAgreement$userErrors.stub(
    TRes res,
  ) = _CopyWithStubImpl$Mutation$UpdateAgreement$updateAgreement$userErrors;

  TRes call({String? code, String? message, String? field});
}

class _CopyWithImpl$Mutation$UpdateAgreement$updateAgreement$userErrors<TRes>
    implements
        CopyWith$Mutation$UpdateAgreement$updateAgreement$userErrors<TRes> {
  _CopyWithImpl$Mutation$UpdateAgreement$updateAgreement$userErrors(
    this._instance,
    this._then,
  );

  final Mutation$UpdateAgreement$updateAgreement$userErrors _instance;

  final TRes Function(Mutation$UpdateAgreement$updateAgreement$userErrors)
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? code = _undefined,
    Object? message = _undefined,
    Object? field = _undefined,
  }) => _then(
    Mutation$UpdateAgreement$updateAgreement$userErrors(
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

class _CopyWithStubImpl$Mutation$UpdateAgreement$updateAgreement$userErrors<
  TRes
>
    implements
        CopyWith$Mutation$UpdateAgreement$updateAgreement$userErrors<TRes> {
  _CopyWithStubImpl$Mutation$UpdateAgreement$updateAgreement$userErrors(
    this._res,
  );

  TRes _res;

  call({String? code, String? message, String? field}) => _res;
}

class Mutation$UpdateAgreement$updateAgreement$agreement {
  Mutation$UpdateAgreement$updateAgreement$agreement({
    required this.termsCode,
    required this.required,
    required this.agreed,
    this.agreedAt,
    required this.version,
  });

  factory Mutation$UpdateAgreement$updateAgreement$agreement.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$termsCode = json['termsCode'];
    final l$required = json['required'];
    final l$agreed = json['agreed'];
    final l$agreedAt = json['agreedAt'];
    final l$version = json['version'];
    return Mutation$UpdateAgreement$updateAgreement$agreement(
      termsCode: fromJson$Enum$TermsCode((l$termsCode as String)),
      required: (l$required as bool),
      agreed: (l$agreed as bool),
      agreedAt: (l$agreedAt as String?),
      version: (l$version as String),
    );
  }

  final Enum$TermsCode termsCode;

  final bool required;

  final bool agreed;

  final String? agreedAt;

  final String version;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$termsCode = termsCode;
    _resultData['termsCode'] = toJson$Enum$TermsCode(l$termsCode);
    final l$required = required;
    _resultData['required'] = l$required;
    final l$agreed = agreed;
    _resultData['agreed'] = l$agreed;
    final l$agreedAt = agreedAt;
    _resultData['agreedAt'] = l$agreedAt;
    final l$version = version;
    _resultData['version'] = l$version;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$termsCode = termsCode;
    final l$required = required;
    final l$agreed = agreed;
    final l$agreedAt = agreedAt;
    final l$version = version;
    return Object.hashAll([
      l$termsCode,
      l$required,
      l$agreed,
      l$agreedAt,
      l$version,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$UpdateAgreement$updateAgreement$agreement ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$termsCode = termsCode;
    final lOther$termsCode = other.termsCode;
    if (l$termsCode != lOther$termsCode) {
      return false;
    }
    final l$required = required;
    final lOther$required = other.required;
    if (l$required != lOther$required) {
      return false;
    }
    final l$agreed = agreed;
    final lOther$agreed = other.agreed;
    if (l$agreed != lOther$agreed) {
      return false;
    }
    final l$agreedAt = agreedAt;
    final lOther$agreedAt = other.agreedAt;
    if (l$agreedAt != lOther$agreedAt) {
      return false;
    }
    final l$version = version;
    final lOther$version = other.version;
    if (l$version != lOther$version) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Mutation$UpdateAgreement$updateAgreement$agreement
    on Mutation$UpdateAgreement$updateAgreement$agreement {
  CopyWith$Mutation$UpdateAgreement$updateAgreement$agreement<
    Mutation$UpdateAgreement$updateAgreement$agreement
  >
  get copyWith => CopyWith$Mutation$UpdateAgreement$updateAgreement$agreement(
    this,
    (i) => i,
  );
}

abstract class CopyWith$Mutation$UpdateAgreement$updateAgreement$agreement<
  TRes
> {
  factory CopyWith$Mutation$UpdateAgreement$updateAgreement$agreement(
    Mutation$UpdateAgreement$updateAgreement$agreement instance,
    TRes Function(Mutation$UpdateAgreement$updateAgreement$agreement) then,
  ) = _CopyWithImpl$Mutation$UpdateAgreement$updateAgreement$agreement;

  factory CopyWith$Mutation$UpdateAgreement$updateAgreement$agreement.stub(
    TRes res,
  ) = _CopyWithStubImpl$Mutation$UpdateAgreement$updateAgreement$agreement;

  TRes call({
    Enum$TermsCode? termsCode,
    bool? required,
    bool? agreed,
    String? agreedAt,
    String? version,
  });
}

class _CopyWithImpl$Mutation$UpdateAgreement$updateAgreement$agreement<TRes>
    implements
        CopyWith$Mutation$UpdateAgreement$updateAgreement$agreement<TRes> {
  _CopyWithImpl$Mutation$UpdateAgreement$updateAgreement$agreement(
    this._instance,
    this._then,
  );

  final Mutation$UpdateAgreement$updateAgreement$agreement _instance;

  final TRes Function(Mutation$UpdateAgreement$updateAgreement$agreement) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? termsCode = _undefined,
    Object? required = _undefined,
    Object? agreed = _undefined,
    Object? agreedAt = _undefined,
    Object? version = _undefined,
  }) => _then(
    Mutation$UpdateAgreement$updateAgreement$agreement(
      termsCode: termsCode == _undefined || termsCode == null
          ? _instance.termsCode
          : (termsCode as Enum$TermsCode),
      required: required == _undefined || required == null
          ? _instance.required
          : (required as bool),
      agreed: agreed == _undefined || agreed == null
          ? _instance.agreed
          : (agreed as bool),
      agreedAt: agreedAt == _undefined
          ? _instance.agreedAt
          : (agreedAt as String?),
      version: version == _undefined || version == null
          ? _instance.version
          : (version as String),
    ),
  );
}

class _CopyWithStubImpl$Mutation$UpdateAgreement$updateAgreement$agreement<TRes>
    implements
        CopyWith$Mutation$UpdateAgreement$updateAgreement$agreement<TRes> {
  _CopyWithStubImpl$Mutation$UpdateAgreement$updateAgreement$agreement(
    this._res,
  );

  TRes _res;

  call({
    Enum$TermsCode? termsCode,
    bool? required,
    bool? agreed,
    String? agreedAt,
    String? version,
  }) => _res;
}

class Variables$Mutation$AgreeToRequiredTerms {
  factory Variables$Mutation$AgreeToRequiredTerms({
    required Input$AgreeToRequiredTermsInput input,
  }) => Variables$Mutation$AgreeToRequiredTerms._({r'input': input});

  Variables$Mutation$AgreeToRequiredTerms._(this._$data);

  factory Variables$Mutation$AgreeToRequiredTerms.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    final l$input = data['input'];
    result$data['input'] = Input$AgreeToRequiredTermsInput.fromJson(
      (l$input as Map<String, dynamic>),
    );
    return Variables$Mutation$AgreeToRequiredTerms._(result$data);
  }

  Map<String, dynamic> _$data;

  Input$AgreeToRequiredTermsInput get input =>
      (_$data['input'] as Input$AgreeToRequiredTermsInput);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$input = input;
    result$data['input'] = l$input.toJson();
    return result$data;
  }

  CopyWith$Variables$Mutation$AgreeToRequiredTerms<
    Variables$Mutation$AgreeToRequiredTerms
  >
  get copyWith =>
      CopyWith$Variables$Mutation$AgreeToRequiredTerms(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Mutation$AgreeToRequiredTerms ||
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

abstract class CopyWith$Variables$Mutation$AgreeToRequiredTerms<TRes> {
  factory CopyWith$Variables$Mutation$AgreeToRequiredTerms(
    Variables$Mutation$AgreeToRequiredTerms instance,
    TRes Function(Variables$Mutation$AgreeToRequiredTerms) then,
  ) = _CopyWithImpl$Variables$Mutation$AgreeToRequiredTerms;

  factory CopyWith$Variables$Mutation$AgreeToRequiredTerms.stub(TRes res) =
      _CopyWithStubImpl$Variables$Mutation$AgreeToRequiredTerms;

  TRes call({Input$AgreeToRequiredTermsInput? input});
}

class _CopyWithImpl$Variables$Mutation$AgreeToRequiredTerms<TRes>
    implements CopyWith$Variables$Mutation$AgreeToRequiredTerms<TRes> {
  _CopyWithImpl$Variables$Mutation$AgreeToRequiredTerms(
    this._instance,
    this._then,
  );

  final Variables$Mutation$AgreeToRequiredTerms _instance;

  final TRes Function(Variables$Mutation$AgreeToRequiredTerms) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? input = _undefined}) => _then(
    Variables$Mutation$AgreeToRequiredTerms._({
      ..._instance._$data,
      if (input != _undefined && input != null)
        'input': (input as Input$AgreeToRequiredTermsInput),
    }),
  );
}

class _CopyWithStubImpl$Variables$Mutation$AgreeToRequiredTerms<TRes>
    implements CopyWith$Variables$Mutation$AgreeToRequiredTerms<TRes> {
  _CopyWithStubImpl$Variables$Mutation$AgreeToRequiredTerms(this._res);

  TRes _res;

  call({Input$AgreeToRequiredTermsInput? input}) => _res;
}

class Mutation$AgreeToRequiredTerms {
  Mutation$AgreeToRequiredTerms({required this.agreeToRequiredTerms});

  factory Mutation$AgreeToRequiredTerms.fromJson(Map<String, dynamic> json) {
    final l$agreeToRequiredTerms = json['agreeToRequiredTerms'];
    return Mutation$AgreeToRequiredTerms(
      agreeToRequiredTerms:
          Mutation$AgreeToRequiredTerms$agreeToRequiredTerms.fromJson(
            (l$agreeToRequiredTerms as Map<String, dynamic>),
          ),
    );
  }

  final Mutation$AgreeToRequiredTerms$agreeToRequiredTerms agreeToRequiredTerms;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$agreeToRequiredTerms = agreeToRequiredTerms;
    _resultData['agreeToRequiredTerms'] = l$agreeToRequiredTerms.toJson();
    return _resultData;
  }

  @override
  int get hashCode {
    final l$agreeToRequiredTerms = agreeToRequiredTerms;
    return Object.hashAll([l$agreeToRequiredTerms]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$AgreeToRequiredTerms ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$agreeToRequiredTerms = agreeToRequiredTerms;
    final lOther$agreeToRequiredTerms = other.agreeToRequiredTerms;
    if (l$agreeToRequiredTerms != lOther$agreeToRequiredTerms) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Mutation$AgreeToRequiredTerms
    on Mutation$AgreeToRequiredTerms {
  CopyWith$Mutation$AgreeToRequiredTerms<Mutation$AgreeToRequiredTerms>
  get copyWith => CopyWith$Mutation$AgreeToRequiredTerms(this, (i) => i);
}

abstract class CopyWith$Mutation$AgreeToRequiredTerms<TRes> {
  factory CopyWith$Mutation$AgreeToRequiredTerms(
    Mutation$AgreeToRequiredTerms instance,
    TRes Function(Mutation$AgreeToRequiredTerms) then,
  ) = _CopyWithImpl$Mutation$AgreeToRequiredTerms;

  factory CopyWith$Mutation$AgreeToRequiredTerms.stub(TRes res) =
      _CopyWithStubImpl$Mutation$AgreeToRequiredTerms;

  TRes call({
    Mutation$AgreeToRequiredTerms$agreeToRequiredTerms? agreeToRequiredTerms,
  });
  CopyWith$Mutation$AgreeToRequiredTerms$agreeToRequiredTerms<TRes>
  get agreeToRequiredTerms;
}

class _CopyWithImpl$Mutation$AgreeToRequiredTerms<TRes>
    implements CopyWith$Mutation$AgreeToRequiredTerms<TRes> {
  _CopyWithImpl$Mutation$AgreeToRequiredTerms(this._instance, this._then);

  final Mutation$AgreeToRequiredTerms _instance;

  final TRes Function(Mutation$AgreeToRequiredTerms) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? agreeToRequiredTerms = _undefined}) => _then(
    Mutation$AgreeToRequiredTerms(
      agreeToRequiredTerms:
          agreeToRequiredTerms == _undefined || agreeToRequiredTerms == null
          ? _instance.agreeToRequiredTerms
          : (agreeToRequiredTerms
                as Mutation$AgreeToRequiredTerms$agreeToRequiredTerms),
    ),
  );

  CopyWith$Mutation$AgreeToRequiredTerms$agreeToRequiredTerms<TRes>
  get agreeToRequiredTerms {
    final local$agreeToRequiredTerms = _instance.agreeToRequiredTerms;
    return CopyWith$Mutation$AgreeToRequiredTerms$agreeToRequiredTerms(
      local$agreeToRequiredTerms,
      (e) => call(agreeToRequiredTerms: e),
    );
  }
}

class _CopyWithStubImpl$Mutation$AgreeToRequiredTerms<TRes>
    implements CopyWith$Mutation$AgreeToRequiredTerms<TRes> {
  _CopyWithStubImpl$Mutation$AgreeToRequiredTerms(this._res);

  TRes _res;

  call({
    Mutation$AgreeToRequiredTerms$agreeToRequiredTerms? agreeToRequiredTerms,
  }) => _res;

  CopyWith$Mutation$AgreeToRequiredTerms$agreeToRequiredTerms<TRes>
  get agreeToRequiredTerms =>
      CopyWith$Mutation$AgreeToRequiredTerms$agreeToRequiredTerms.stub(_res);
}

const documentNodeMutationAgreeToRequiredTerms = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'AgreeToRequiredTerms'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'input')),
          type: NamedTypeNode(
            name: NameNode(value: 'AgreeToRequiredTermsInput'),
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
            name: NameNode(value: 'agreeToRequiredTerms'),
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
                  name: NameNode(value: 'agreements'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: SelectionSetNode(
                    selections: [
                      FieldNode(
                        name: NameNode(value: 'termsCode'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'required'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'agreed'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'agreedAt'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'version'),
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

class Mutation$AgreeToRequiredTerms$agreeToRequiredTerms {
  Mutation$AgreeToRequiredTerms$agreeToRequiredTerms({
    required this.success,
    required this.userErrors,
    required this.agreements,
  });

  factory Mutation$AgreeToRequiredTerms$agreeToRequiredTerms.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$success = json['success'];
    final l$userErrors = json['userErrors'];
    final l$agreements = json['agreements'];
    return Mutation$AgreeToRequiredTerms$agreeToRequiredTerms(
      success: (l$success as bool),
      userErrors: (l$userErrors as List<dynamic>)
          .map(
            (e) =>
                Mutation$AgreeToRequiredTerms$agreeToRequiredTerms$userErrors.fromJson(
                  (e as Map<String, dynamic>),
                ),
          )
          .toList(),
      agreements: (l$agreements as List<dynamic>)
          .map(
            (e) =>
                Mutation$AgreeToRequiredTerms$agreeToRequiredTerms$agreements.fromJson(
                  (e as Map<String, dynamic>),
                ),
          )
          .toList(),
    );
  }

  final bool success;

  final List<Mutation$AgreeToRequiredTerms$agreeToRequiredTerms$userErrors>
  userErrors;

  final List<Mutation$AgreeToRequiredTerms$agreeToRequiredTerms$agreements>
  agreements;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$success = success;
    _resultData['success'] = l$success;
    final l$userErrors = userErrors;
    _resultData['userErrors'] = l$userErrors.map((e) => e.toJson()).toList();
    final l$agreements = agreements;
    _resultData['agreements'] = l$agreements.map((e) => e.toJson()).toList();
    return _resultData;
  }

  @override
  int get hashCode {
    final l$success = success;
    final l$userErrors = userErrors;
    final l$agreements = agreements;
    return Object.hashAll([
      l$success,
      Object.hashAll(l$userErrors.map((v) => v)),
      Object.hashAll(l$agreements.map((v) => v)),
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$AgreeToRequiredTerms$agreeToRequiredTerms ||
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
}

extension UtilityExtension$Mutation$AgreeToRequiredTerms$agreeToRequiredTerms
    on Mutation$AgreeToRequiredTerms$agreeToRequiredTerms {
  CopyWith$Mutation$AgreeToRequiredTerms$agreeToRequiredTerms<
    Mutation$AgreeToRequiredTerms$agreeToRequiredTerms
  >
  get copyWith => CopyWith$Mutation$AgreeToRequiredTerms$agreeToRequiredTerms(
    this,
    (i) => i,
  );
}

abstract class CopyWith$Mutation$AgreeToRequiredTerms$agreeToRequiredTerms<
  TRes
> {
  factory CopyWith$Mutation$AgreeToRequiredTerms$agreeToRequiredTerms(
    Mutation$AgreeToRequiredTerms$agreeToRequiredTerms instance,
    TRes Function(Mutation$AgreeToRequiredTerms$agreeToRequiredTerms) then,
  ) = _CopyWithImpl$Mutation$AgreeToRequiredTerms$agreeToRequiredTerms;

  factory CopyWith$Mutation$AgreeToRequiredTerms$agreeToRequiredTerms.stub(
    TRes res,
  ) = _CopyWithStubImpl$Mutation$AgreeToRequiredTerms$agreeToRequiredTerms;

  TRes call({
    bool? success,
    List<Mutation$AgreeToRequiredTerms$agreeToRequiredTerms$userErrors>?
    userErrors,
    List<Mutation$AgreeToRequiredTerms$agreeToRequiredTerms$agreements>?
    agreements,
  });
  TRes userErrors(
    Iterable<Mutation$AgreeToRequiredTerms$agreeToRequiredTerms$userErrors>
    Function(
      Iterable<
        CopyWith$Mutation$AgreeToRequiredTerms$agreeToRequiredTerms$userErrors<
          Mutation$AgreeToRequiredTerms$agreeToRequiredTerms$userErrors
        >
      >,
    )
    _fn,
  );
  TRes agreements(
    Iterable<Mutation$AgreeToRequiredTerms$agreeToRequiredTerms$agreements>
    Function(
      Iterable<
        CopyWith$Mutation$AgreeToRequiredTerms$agreeToRequiredTerms$agreements<
          Mutation$AgreeToRequiredTerms$agreeToRequiredTerms$agreements
        >
      >,
    )
    _fn,
  );
}

class _CopyWithImpl$Mutation$AgreeToRequiredTerms$agreeToRequiredTerms<TRes>
    implements
        CopyWith$Mutation$AgreeToRequiredTerms$agreeToRequiredTerms<TRes> {
  _CopyWithImpl$Mutation$AgreeToRequiredTerms$agreeToRequiredTerms(
    this._instance,
    this._then,
  );

  final Mutation$AgreeToRequiredTerms$agreeToRequiredTerms _instance;

  final TRes Function(Mutation$AgreeToRequiredTerms$agreeToRequiredTerms) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? success = _undefined,
    Object? userErrors = _undefined,
    Object? agreements = _undefined,
  }) => _then(
    Mutation$AgreeToRequiredTerms$agreeToRequiredTerms(
      success: success == _undefined || success == null
          ? _instance.success
          : (success as bool),
      userErrors: userErrors == _undefined || userErrors == null
          ? _instance.userErrors
          : (userErrors
                as List<
                  Mutation$AgreeToRequiredTerms$agreeToRequiredTerms$userErrors
                >),
      agreements: agreements == _undefined || agreements == null
          ? _instance.agreements
          : (agreements
                as List<
                  Mutation$AgreeToRequiredTerms$agreeToRequiredTerms$agreements
                >),
    ),
  );

  TRes userErrors(
    Iterable<Mutation$AgreeToRequiredTerms$agreeToRequiredTerms$userErrors>
    Function(
      Iterable<
        CopyWith$Mutation$AgreeToRequiredTerms$agreeToRequiredTerms$userErrors<
          Mutation$AgreeToRequiredTerms$agreeToRequiredTerms$userErrors
        >
      >,
    )
    _fn,
  ) => call(
    userErrors: _fn(
      _instance.userErrors.map(
        (e) =>
            CopyWith$Mutation$AgreeToRequiredTerms$agreeToRequiredTerms$userErrors(
              e,
              (i) => i,
            ),
      ),
    ).toList(),
  );

  TRes agreements(
    Iterable<Mutation$AgreeToRequiredTerms$agreeToRequiredTerms$agreements>
    Function(
      Iterable<
        CopyWith$Mutation$AgreeToRequiredTerms$agreeToRequiredTerms$agreements<
          Mutation$AgreeToRequiredTerms$agreeToRequiredTerms$agreements
        >
      >,
    )
    _fn,
  ) => call(
    agreements: _fn(
      _instance.agreements.map(
        (e) =>
            CopyWith$Mutation$AgreeToRequiredTerms$agreeToRequiredTerms$agreements(
              e,
              (i) => i,
            ),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl$Mutation$AgreeToRequiredTerms$agreeToRequiredTerms<TRes>
    implements
        CopyWith$Mutation$AgreeToRequiredTerms$agreeToRequiredTerms<TRes> {
  _CopyWithStubImpl$Mutation$AgreeToRequiredTerms$agreeToRequiredTerms(
    this._res,
  );

  TRes _res;

  call({
    bool? success,
    List<Mutation$AgreeToRequiredTerms$agreeToRequiredTerms$userErrors>?
    userErrors,
    List<Mutation$AgreeToRequiredTerms$agreeToRequiredTerms$agreements>?
    agreements,
  }) => _res;

  userErrors(_fn) => _res;

  agreements(_fn) => _res;
}

class Mutation$AgreeToRequiredTerms$agreeToRequiredTerms$userErrors {
  Mutation$AgreeToRequiredTerms$agreeToRequiredTerms$userErrors({
    required this.code,
    required this.message,
    this.field,
  });

  factory Mutation$AgreeToRequiredTerms$agreeToRequiredTerms$userErrors.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$code = json['code'];
    final l$message = json['message'];
    final l$field = json['field'];
    return Mutation$AgreeToRequiredTerms$agreeToRequiredTerms$userErrors(
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
            is! Mutation$AgreeToRequiredTerms$agreeToRequiredTerms$userErrors ||
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

extension UtilityExtension$Mutation$AgreeToRequiredTerms$agreeToRequiredTerms$userErrors
    on Mutation$AgreeToRequiredTerms$agreeToRequiredTerms$userErrors {
  CopyWith$Mutation$AgreeToRequiredTerms$agreeToRequiredTerms$userErrors<
    Mutation$AgreeToRequiredTerms$agreeToRequiredTerms$userErrors
  >
  get copyWith =>
      CopyWith$Mutation$AgreeToRequiredTerms$agreeToRequiredTerms$userErrors(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Mutation$AgreeToRequiredTerms$agreeToRequiredTerms$userErrors<
  TRes
> {
  factory CopyWith$Mutation$AgreeToRequiredTerms$agreeToRequiredTerms$userErrors(
    Mutation$AgreeToRequiredTerms$agreeToRequiredTerms$userErrors instance,
    TRes Function(Mutation$AgreeToRequiredTerms$agreeToRequiredTerms$userErrors)
    then,
  ) = _CopyWithImpl$Mutation$AgreeToRequiredTerms$agreeToRequiredTerms$userErrors;

  factory CopyWith$Mutation$AgreeToRequiredTerms$agreeToRequiredTerms$userErrors.stub(
    TRes res,
  ) = _CopyWithStubImpl$Mutation$AgreeToRequiredTerms$agreeToRequiredTerms$userErrors;

  TRes call({String? code, String? message, String? field});
}

class _CopyWithImpl$Mutation$AgreeToRequiredTerms$agreeToRequiredTerms$userErrors<
  TRes
>
    implements
        CopyWith$Mutation$AgreeToRequiredTerms$agreeToRequiredTerms$userErrors<
          TRes
        > {
  _CopyWithImpl$Mutation$AgreeToRequiredTerms$agreeToRequiredTerms$userErrors(
    this._instance,
    this._then,
  );

  final Mutation$AgreeToRequiredTerms$agreeToRequiredTerms$userErrors _instance;

  final TRes Function(
    Mutation$AgreeToRequiredTerms$agreeToRequiredTerms$userErrors,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? code = _undefined,
    Object? message = _undefined,
    Object? field = _undefined,
  }) => _then(
    Mutation$AgreeToRequiredTerms$agreeToRequiredTerms$userErrors(
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

class _CopyWithStubImpl$Mutation$AgreeToRequiredTerms$agreeToRequiredTerms$userErrors<
  TRes
>
    implements
        CopyWith$Mutation$AgreeToRequiredTerms$agreeToRequiredTerms$userErrors<
          TRes
        > {
  _CopyWithStubImpl$Mutation$AgreeToRequiredTerms$agreeToRequiredTerms$userErrors(
    this._res,
  );

  TRes _res;

  call({String? code, String? message, String? field}) => _res;
}

class Mutation$AgreeToRequiredTerms$agreeToRequiredTerms$agreements {
  Mutation$AgreeToRequiredTerms$agreeToRequiredTerms$agreements({
    required this.termsCode,
    required this.required,
    required this.agreed,
    this.agreedAt,
    required this.version,
  });

  factory Mutation$AgreeToRequiredTerms$agreeToRequiredTerms$agreements.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$termsCode = json['termsCode'];
    final l$required = json['required'];
    final l$agreed = json['agreed'];
    final l$agreedAt = json['agreedAt'];
    final l$version = json['version'];
    return Mutation$AgreeToRequiredTerms$agreeToRequiredTerms$agreements(
      termsCode: fromJson$Enum$TermsCode((l$termsCode as String)),
      required: (l$required as bool),
      agreed: (l$agreed as bool),
      agreedAt: (l$agreedAt as String?),
      version: (l$version as String),
    );
  }

  final Enum$TermsCode termsCode;

  final bool required;

  final bool agreed;

  final String? agreedAt;

  final String version;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$termsCode = termsCode;
    _resultData['termsCode'] = toJson$Enum$TermsCode(l$termsCode);
    final l$required = required;
    _resultData['required'] = l$required;
    final l$agreed = agreed;
    _resultData['agreed'] = l$agreed;
    final l$agreedAt = agreedAt;
    _resultData['agreedAt'] = l$agreedAt;
    final l$version = version;
    _resultData['version'] = l$version;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$termsCode = termsCode;
    final l$required = required;
    final l$agreed = agreed;
    final l$agreedAt = agreedAt;
    final l$version = version;
    return Object.hashAll([
      l$termsCode,
      l$required,
      l$agreed,
      l$agreedAt,
      l$version,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Mutation$AgreeToRequiredTerms$agreeToRequiredTerms$agreements ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$termsCode = termsCode;
    final lOther$termsCode = other.termsCode;
    if (l$termsCode != lOther$termsCode) {
      return false;
    }
    final l$required = required;
    final lOther$required = other.required;
    if (l$required != lOther$required) {
      return false;
    }
    final l$agreed = agreed;
    final lOther$agreed = other.agreed;
    if (l$agreed != lOther$agreed) {
      return false;
    }
    final l$agreedAt = agreedAt;
    final lOther$agreedAt = other.agreedAt;
    if (l$agreedAt != lOther$agreedAt) {
      return false;
    }
    final l$version = version;
    final lOther$version = other.version;
    if (l$version != lOther$version) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Mutation$AgreeToRequiredTerms$agreeToRequiredTerms$agreements
    on Mutation$AgreeToRequiredTerms$agreeToRequiredTerms$agreements {
  CopyWith$Mutation$AgreeToRequiredTerms$agreeToRequiredTerms$agreements<
    Mutation$AgreeToRequiredTerms$agreeToRequiredTerms$agreements
  >
  get copyWith =>
      CopyWith$Mutation$AgreeToRequiredTerms$agreeToRequiredTerms$agreements(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Mutation$AgreeToRequiredTerms$agreeToRequiredTerms$agreements<
  TRes
> {
  factory CopyWith$Mutation$AgreeToRequiredTerms$agreeToRequiredTerms$agreements(
    Mutation$AgreeToRequiredTerms$agreeToRequiredTerms$agreements instance,
    TRes Function(Mutation$AgreeToRequiredTerms$agreeToRequiredTerms$agreements)
    then,
  ) = _CopyWithImpl$Mutation$AgreeToRequiredTerms$agreeToRequiredTerms$agreements;

  factory CopyWith$Mutation$AgreeToRequiredTerms$agreeToRequiredTerms$agreements.stub(
    TRes res,
  ) = _CopyWithStubImpl$Mutation$AgreeToRequiredTerms$agreeToRequiredTerms$agreements;

  TRes call({
    Enum$TermsCode? termsCode,
    bool? required,
    bool? agreed,
    String? agreedAt,
    String? version,
  });
}

class _CopyWithImpl$Mutation$AgreeToRequiredTerms$agreeToRequiredTerms$agreements<
  TRes
>
    implements
        CopyWith$Mutation$AgreeToRequiredTerms$agreeToRequiredTerms$agreements<
          TRes
        > {
  _CopyWithImpl$Mutation$AgreeToRequiredTerms$agreeToRequiredTerms$agreements(
    this._instance,
    this._then,
  );

  final Mutation$AgreeToRequiredTerms$agreeToRequiredTerms$agreements _instance;

  final TRes Function(
    Mutation$AgreeToRequiredTerms$agreeToRequiredTerms$agreements,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? termsCode = _undefined,
    Object? required = _undefined,
    Object? agreed = _undefined,
    Object? agreedAt = _undefined,
    Object? version = _undefined,
  }) => _then(
    Mutation$AgreeToRequiredTerms$agreeToRequiredTerms$agreements(
      termsCode: termsCode == _undefined || termsCode == null
          ? _instance.termsCode
          : (termsCode as Enum$TermsCode),
      required: required == _undefined || required == null
          ? _instance.required
          : (required as bool),
      agreed: agreed == _undefined || agreed == null
          ? _instance.agreed
          : (agreed as bool),
      agreedAt: agreedAt == _undefined
          ? _instance.agreedAt
          : (agreedAt as String?),
      version: version == _undefined || version == null
          ? _instance.version
          : (version as String),
    ),
  );
}

class _CopyWithStubImpl$Mutation$AgreeToRequiredTerms$agreeToRequiredTerms$agreements<
  TRes
>
    implements
        CopyWith$Mutation$AgreeToRequiredTerms$agreeToRequiredTerms$agreements<
          TRes
        > {
  _CopyWithStubImpl$Mutation$AgreeToRequiredTerms$agreeToRequiredTerms$agreements(
    this._res,
  );

  TRes _res;

  call({
    Enum$TermsCode? termsCode,
    bool? required,
    bool? agreed,
    String? agreedAt,
    String? version,
  }) => _res;
}
