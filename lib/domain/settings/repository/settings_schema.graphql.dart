// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, unused_element
import '../../auth/repository/auth_schema.graphql.dart';

class Input$UpdateAgreementInput {
  factory Input$UpdateAgreementInput({
    required Enum$TermsCode termsCode,
    required bool agreed,
  }) => Input$UpdateAgreementInput._({
    r'termsCode': termsCode,
    r'agreed': agreed,
  });

  Input$UpdateAgreementInput._(this._$data);

  factory Input$UpdateAgreementInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$termsCode = data['termsCode'];
    result$data['termsCode'] = fromJson$Enum$TermsCode((l$termsCode as String));
    final l$agreed = data['agreed'];
    result$data['agreed'] = (l$agreed as bool);
    return Input$UpdateAgreementInput._(result$data);
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

  CopyWith$Input$UpdateAgreementInput<Input$UpdateAgreementInput>
  get copyWith => CopyWith$Input$UpdateAgreementInput(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Input$UpdateAgreementInput ||
        runtimeType != other.runtimeType) {
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

abstract class CopyWith$Input$UpdateAgreementInput<TRes> {
  factory CopyWith$Input$UpdateAgreementInput(
    Input$UpdateAgreementInput instance,
    TRes Function(Input$UpdateAgreementInput) then,
  ) = _CopyWithImpl$Input$UpdateAgreementInput;

  factory CopyWith$Input$UpdateAgreementInput.stub(TRes res) =
      _CopyWithStubImpl$Input$UpdateAgreementInput;

  TRes call({Enum$TermsCode? termsCode, bool? agreed});
}

class _CopyWithImpl$Input$UpdateAgreementInput<TRes>
    implements CopyWith$Input$UpdateAgreementInput<TRes> {
  _CopyWithImpl$Input$UpdateAgreementInput(this._instance, this._then);

  final Input$UpdateAgreementInput _instance;

  final TRes Function(Input$UpdateAgreementInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? termsCode = _undefined, Object? agreed = _undefined}) =>
      _then(
        Input$UpdateAgreementInput._({
          ..._instance._$data,
          if (termsCode != _undefined && termsCode != null)
            'termsCode': (termsCode as Enum$TermsCode),
          if (agreed != _undefined && agreed != null)
            'agreed': (agreed as bool),
        }),
      );
}

class _CopyWithStubImpl$Input$UpdateAgreementInput<TRes>
    implements CopyWith$Input$UpdateAgreementInput<TRes> {
  _CopyWithStubImpl$Input$UpdateAgreementInput(this._res);

  TRes _res;

  call({Enum$TermsCode? termsCode, bool? agreed}) => _res;
}

class Input$AgreeToRequiredTermsInput {
  factory Input$AgreeToRequiredTermsInput({
    required List<Enum$TermsCode> termsCodes,
  }) => Input$AgreeToRequiredTermsInput._({r'termsCodes': termsCodes});

  Input$AgreeToRequiredTermsInput._(this._$data);

  factory Input$AgreeToRequiredTermsInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$termsCodes = data['termsCodes'];
    result$data['termsCodes'] = (l$termsCodes as List<dynamic>)
        .map((e) => fromJson$Enum$TermsCode((e as String)))
        .toList();
    return Input$AgreeToRequiredTermsInput._(result$data);
  }

  Map<String, dynamic> _$data;

  List<Enum$TermsCode> get termsCodes =>
      (_$data['termsCodes'] as List<Enum$TermsCode>);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$termsCodes = termsCodes;
    result$data['termsCodes'] = l$termsCodes
        .map((e) => toJson$Enum$TermsCode(e))
        .toList();
    return result$data;
  }

  CopyWith$Input$AgreeToRequiredTermsInput<Input$AgreeToRequiredTermsInput>
  get copyWith => CopyWith$Input$AgreeToRequiredTermsInput(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Input$AgreeToRequiredTermsInput ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$termsCodes = termsCodes;
    final lOther$termsCodes = other.termsCodes;
    if (l$termsCodes.length != lOther$termsCodes.length) {
      return false;
    }
    for (int i = 0; i < l$termsCodes.length; i++) {
      final l$termsCodes$entry = l$termsCodes[i];
      final lOther$termsCodes$entry = lOther$termsCodes[i];
      if (l$termsCodes$entry != lOther$termsCodes$entry) {
        return false;
      }
    }
    return true;
  }

  @override
  int get hashCode {
    final l$termsCodes = termsCodes;
    return Object.hashAll([Object.hashAll(l$termsCodes.map((v) => v))]);
  }
}

abstract class CopyWith$Input$AgreeToRequiredTermsInput<TRes> {
  factory CopyWith$Input$AgreeToRequiredTermsInput(
    Input$AgreeToRequiredTermsInput instance,
    TRes Function(Input$AgreeToRequiredTermsInput) then,
  ) = _CopyWithImpl$Input$AgreeToRequiredTermsInput;

  factory CopyWith$Input$AgreeToRequiredTermsInput.stub(TRes res) =
      _CopyWithStubImpl$Input$AgreeToRequiredTermsInput;

  TRes call({List<Enum$TermsCode>? termsCodes});
}

class _CopyWithImpl$Input$AgreeToRequiredTermsInput<TRes>
    implements CopyWith$Input$AgreeToRequiredTermsInput<TRes> {
  _CopyWithImpl$Input$AgreeToRequiredTermsInput(this._instance, this._then);

  final Input$AgreeToRequiredTermsInput _instance;

  final TRes Function(Input$AgreeToRequiredTermsInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? termsCodes = _undefined}) => _then(
    Input$AgreeToRequiredTermsInput._({
      ..._instance._$data,
      if (termsCodes != _undefined && termsCodes != null)
        'termsCodes': (termsCodes as List<Enum$TermsCode>),
    }),
  );
}

class _CopyWithStubImpl$Input$AgreeToRequiredTermsInput<TRes>
    implements CopyWith$Input$AgreeToRequiredTermsInput<TRes> {
  _CopyWithStubImpl$Input$AgreeToRequiredTermsInput(this._res);

  TRes _res;

  call({List<Enum$TermsCode>? termsCodes}) => _res;
}
