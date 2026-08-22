// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, unused_element
class Input$RecordVisitsInput {
  factory Input$RecordVisitsInput({required List<String> districtCodes}) =>
      Input$RecordVisitsInput._({r'districtCodes': districtCodes});

  Input$RecordVisitsInput._(this._$data);

  factory Input$RecordVisitsInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$districtCodes = data['districtCodes'];
    result$data['districtCodes'] = (l$districtCodes as List<dynamic>)
        .map((e) => (e as String))
        .toList();
    return Input$RecordVisitsInput._(result$data);
  }

  Map<String, dynamic> _$data;

  List<String> get districtCodes => (_$data['districtCodes'] as List<String>);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$districtCodes = districtCodes;
    result$data['districtCodes'] = l$districtCodes.map((e) => e).toList();
    return result$data;
  }

  CopyWith$Input$RecordVisitsInput<Input$RecordVisitsInput> get copyWith =>
      CopyWith$Input$RecordVisitsInput(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Input$RecordVisitsInput || runtimeType != other.runtimeType) {
      return false;
    }
    final l$districtCodes = districtCodes;
    final lOther$districtCodes = other.districtCodes;
    if (l$districtCodes.length != lOther$districtCodes.length) {
      return false;
    }
    for (int i = 0; i < l$districtCodes.length; i++) {
      final l$districtCodes$entry = l$districtCodes[i];
      final lOther$districtCodes$entry = lOther$districtCodes[i];
      if (l$districtCodes$entry != lOther$districtCodes$entry) {
        return false;
      }
    }
    return true;
  }

  @override
  int get hashCode {
    final l$districtCodes = districtCodes;
    return Object.hashAll([Object.hashAll(l$districtCodes.map((v) => v))]);
  }
}

abstract class CopyWith$Input$RecordVisitsInput<TRes> {
  factory CopyWith$Input$RecordVisitsInput(
    Input$RecordVisitsInput instance,
    TRes Function(Input$RecordVisitsInput) then,
  ) = _CopyWithImpl$Input$RecordVisitsInput;

  factory CopyWith$Input$RecordVisitsInput.stub(TRes res) =
      _CopyWithStubImpl$Input$RecordVisitsInput;

  TRes call({List<String>? districtCodes});
}

class _CopyWithImpl$Input$RecordVisitsInput<TRes>
    implements CopyWith$Input$RecordVisitsInput<TRes> {
  _CopyWithImpl$Input$RecordVisitsInput(this._instance, this._then);

  final Input$RecordVisitsInput _instance;

  final TRes Function(Input$RecordVisitsInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? districtCodes = _undefined}) => _then(
    Input$RecordVisitsInput._({
      ..._instance._$data,
      if (districtCodes != _undefined && districtCodes != null)
        'districtCodes': (districtCodes as List<String>),
    }),
  );
}

class _CopyWithStubImpl$Input$RecordVisitsInput<TRes>
    implements CopyWith$Input$RecordVisitsInput<TRes> {
  _CopyWithStubImpl$Input$RecordVisitsInput(this._res);

  TRes _res;

  call({List<String>? districtCodes}) => _res;
}

class Input$RemoveVisitInput {
  factory Input$RemoveVisitInput({required String cellId}) =>
      Input$RemoveVisitInput._({r'cellId': cellId});

  Input$RemoveVisitInput._(this._$data);

  factory Input$RemoveVisitInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$cellId = data['cellId'];
    result$data['cellId'] = (l$cellId as String);
    return Input$RemoveVisitInput._(result$data);
  }

  Map<String, dynamic> _$data;

  String get cellId => (_$data['cellId'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$cellId = cellId;
    result$data['cellId'] = l$cellId;
    return result$data;
  }

  CopyWith$Input$RemoveVisitInput<Input$RemoveVisitInput> get copyWith =>
      CopyWith$Input$RemoveVisitInput(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Input$RemoveVisitInput || runtimeType != other.runtimeType) {
      return false;
    }
    final l$cellId = cellId;
    final lOther$cellId = other.cellId;
    if (l$cellId != lOther$cellId) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$cellId = cellId;
    return Object.hashAll([l$cellId]);
  }
}

abstract class CopyWith$Input$RemoveVisitInput<TRes> {
  factory CopyWith$Input$RemoveVisitInput(
    Input$RemoveVisitInput instance,
    TRes Function(Input$RemoveVisitInput) then,
  ) = _CopyWithImpl$Input$RemoveVisitInput;

  factory CopyWith$Input$RemoveVisitInput.stub(TRes res) =
      _CopyWithStubImpl$Input$RemoveVisitInput;

  TRes call({String? cellId});
}

class _CopyWithImpl$Input$RemoveVisitInput<TRes>
    implements CopyWith$Input$RemoveVisitInput<TRes> {
  _CopyWithImpl$Input$RemoveVisitInput(this._instance, this._then);

  final Input$RemoveVisitInput _instance;

  final TRes Function(Input$RemoveVisitInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? cellId = _undefined}) => _then(
    Input$RemoveVisitInput._({
      ..._instance._$data,
      if (cellId != _undefined && cellId != null) 'cellId': (cellId as String),
    }),
  );
}

class _CopyWithStubImpl$Input$RemoveVisitInput<TRes>
    implements CopyWith$Input$RemoveVisitInput<TRes> {
  _CopyWithStubImpl$Input$RemoveVisitInput(this._res);

  TRes _res;

  call({String? cellId}) => _res;
}

class Input$RevokeMapShareLinkInput {
  factory Input$RevokeMapShareLinkInput({required String shareUrl}) =>
      Input$RevokeMapShareLinkInput._({r'shareUrl': shareUrl});

  Input$RevokeMapShareLinkInput._(this._$data);

  factory Input$RevokeMapShareLinkInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$shareUrl = data['shareUrl'];
    result$data['shareUrl'] = (l$shareUrl as String);
    return Input$RevokeMapShareLinkInput._(result$data);
  }

  Map<String, dynamic> _$data;

  String get shareUrl => (_$data['shareUrl'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$shareUrl = shareUrl;
    result$data['shareUrl'] = l$shareUrl;
    return result$data;
  }

  CopyWith$Input$RevokeMapShareLinkInput<Input$RevokeMapShareLinkInput>
  get copyWith => CopyWith$Input$RevokeMapShareLinkInput(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Input$RevokeMapShareLinkInput ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$shareUrl = shareUrl;
    final lOther$shareUrl = other.shareUrl;
    if (l$shareUrl != lOther$shareUrl) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$shareUrl = shareUrl;
    return Object.hashAll([l$shareUrl]);
  }
}

abstract class CopyWith$Input$RevokeMapShareLinkInput<TRes> {
  factory CopyWith$Input$RevokeMapShareLinkInput(
    Input$RevokeMapShareLinkInput instance,
    TRes Function(Input$RevokeMapShareLinkInput) then,
  ) = _CopyWithImpl$Input$RevokeMapShareLinkInput;

  factory CopyWith$Input$RevokeMapShareLinkInput.stub(TRes res) =
      _CopyWithStubImpl$Input$RevokeMapShareLinkInput;

  TRes call({String? shareUrl});
}

class _CopyWithImpl$Input$RevokeMapShareLinkInput<TRes>
    implements CopyWith$Input$RevokeMapShareLinkInput<TRes> {
  _CopyWithImpl$Input$RevokeMapShareLinkInput(this._instance, this._then);

  final Input$RevokeMapShareLinkInput _instance;

  final TRes Function(Input$RevokeMapShareLinkInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? shareUrl = _undefined}) => _then(
    Input$RevokeMapShareLinkInput._({
      ..._instance._$data,
      if (shareUrl != _undefined && shareUrl != null)
        'shareUrl': (shareUrl as String),
    }),
  );
}

class _CopyWithStubImpl$Input$RevokeMapShareLinkInput<TRes>
    implements CopyWith$Input$RevokeMapShareLinkInput<TRes> {
  _CopyWithStubImpl$Input$RevokeMapShareLinkInput(this._res);

  TRes _res;

  call({String? shareUrl}) => _res;
}

class Input$CreateMapRelationInput {
  factory Input$CreateMapRelationInput({required String shareUrl}) =>
      Input$CreateMapRelationInput._({r'shareUrl': shareUrl});

  Input$CreateMapRelationInput._(this._$data);

  factory Input$CreateMapRelationInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$shareUrl = data['shareUrl'];
    result$data['shareUrl'] = (l$shareUrl as String);
    return Input$CreateMapRelationInput._(result$data);
  }

  Map<String, dynamic> _$data;

  String get shareUrl => (_$data['shareUrl'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$shareUrl = shareUrl;
    result$data['shareUrl'] = l$shareUrl;
    return result$data;
  }

  CopyWith$Input$CreateMapRelationInput<Input$CreateMapRelationInput>
  get copyWith => CopyWith$Input$CreateMapRelationInput(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Input$CreateMapRelationInput ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$shareUrl = shareUrl;
    final lOther$shareUrl = other.shareUrl;
    if (l$shareUrl != lOther$shareUrl) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$shareUrl = shareUrl;
    return Object.hashAll([l$shareUrl]);
  }
}

abstract class CopyWith$Input$CreateMapRelationInput<TRes> {
  factory CopyWith$Input$CreateMapRelationInput(
    Input$CreateMapRelationInput instance,
    TRes Function(Input$CreateMapRelationInput) then,
  ) = _CopyWithImpl$Input$CreateMapRelationInput;

  factory CopyWith$Input$CreateMapRelationInput.stub(TRes res) =
      _CopyWithStubImpl$Input$CreateMapRelationInput;

  TRes call({String? shareUrl});
}

class _CopyWithImpl$Input$CreateMapRelationInput<TRes>
    implements CopyWith$Input$CreateMapRelationInput<TRes> {
  _CopyWithImpl$Input$CreateMapRelationInput(this._instance, this._then);

  final Input$CreateMapRelationInput _instance;

  final TRes Function(Input$CreateMapRelationInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? shareUrl = _undefined}) => _then(
    Input$CreateMapRelationInput._({
      ..._instance._$data,
      if (shareUrl != _undefined && shareUrl != null)
        'shareUrl': (shareUrl as String),
    }),
  );
}

class _CopyWithStubImpl$Input$CreateMapRelationInput<TRes>
    implements CopyWith$Input$CreateMapRelationInput<TRes> {
  _CopyWithStubImpl$Input$CreateMapRelationInput(this._res);

  TRes _res;

  call({String? shareUrl}) => _res;
}

class Input$RemoveMapRelationInput {
  factory Input$RemoveMapRelationInput({required String memberId}) =>
      Input$RemoveMapRelationInput._({r'memberId': memberId});

  Input$RemoveMapRelationInput._(this._$data);

  factory Input$RemoveMapRelationInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$memberId = data['memberId'];
    result$data['memberId'] = (l$memberId as String);
    return Input$RemoveMapRelationInput._(result$data);
  }

  Map<String, dynamic> _$data;

  String get memberId => (_$data['memberId'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$memberId = memberId;
    result$data['memberId'] = l$memberId;
    return result$data;
  }

  CopyWith$Input$RemoveMapRelationInput<Input$RemoveMapRelationInput>
  get copyWith => CopyWith$Input$RemoveMapRelationInput(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Input$RemoveMapRelationInput ||
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

abstract class CopyWith$Input$RemoveMapRelationInput<TRes> {
  factory CopyWith$Input$RemoveMapRelationInput(
    Input$RemoveMapRelationInput instance,
    TRes Function(Input$RemoveMapRelationInput) then,
  ) = _CopyWithImpl$Input$RemoveMapRelationInput;

  factory CopyWith$Input$RemoveMapRelationInput.stub(TRes res) =
      _CopyWithStubImpl$Input$RemoveMapRelationInput;

  TRes call({String? memberId});
}

class _CopyWithImpl$Input$RemoveMapRelationInput<TRes>
    implements CopyWith$Input$RemoveMapRelationInput<TRes> {
  _CopyWithImpl$Input$RemoveMapRelationInput(this._instance, this._then);

  final Input$RemoveMapRelationInput _instance;

  final TRes Function(Input$RemoveMapRelationInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? memberId = _undefined}) => _then(
    Input$RemoveMapRelationInput._({
      ..._instance._$data,
      if (memberId != _undefined && memberId != null)
        'memberId': (memberId as String),
    }),
  );
}

class _CopyWithStubImpl$Input$RemoveMapRelationInput<TRes>
    implements CopyWith$Input$RemoveMapRelationInput<TRes> {
  _CopyWithStubImpl$Input$RemoveMapRelationInput(this._res);

  TRes _res;

  call({String? memberId}) => _res;
}

enum Enum$CellImageKind {
  LANDMARK,
  SPECIALTY,
  $unknown;

  factory Enum$CellImageKind.fromJson(String value) =>
      fromJson$Enum$CellImageKind(value);

  String toJson() => toJson$Enum$CellImageKind(this);
}

String toJson$Enum$CellImageKind(Enum$CellImageKind e) {
  switch (e) {
    case Enum$CellImageKind.LANDMARK:
      return r'LANDMARK';
    case Enum$CellImageKind.SPECIALTY:
      return r'SPECIALTY';
    case Enum$CellImageKind.$unknown:
      return r'$unknown';
  }
}

Enum$CellImageKind fromJson$Enum$CellImageKind(String value) {
  switch (value) {
    case r'LANDMARK':
      return Enum$CellImageKind.LANDMARK;
    case r'SPECIALTY':
      return Enum$CellImageKind.SPECIALTY;
    default:
      return Enum$CellImageKind.$unknown;
  }
}
