// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, unused_element
class Input$MapBoundsInput {
  factory Input$MapBoundsInput({
    required double minLat,
    required double minLng,
    required double maxLat,
    required double maxLng,
  }) => Input$MapBoundsInput._({
    r'minLat': minLat,
    r'minLng': minLng,
    r'maxLat': maxLat,
    r'maxLng': maxLng,
  });

  Input$MapBoundsInput._(this._$data);

  factory Input$MapBoundsInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$minLat = data['minLat'];
    result$data['minLat'] = (l$minLat as num).toDouble();
    final l$minLng = data['minLng'];
    result$data['minLng'] = (l$minLng as num).toDouble();
    final l$maxLat = data['maxLat'];
    result$data['maxLat'] = (l$maxLat as num).toDouble();
    final l$maxLng = data['maxLng'];
    result$data['maxLng'] = (l$maxLng as num).toDouble();
    return Input$MapBoundsInput._(result$data);
  }

  Map<String, dynamic> _$data;

  double get minLat => (_$data['minLat'] as double);

  double get minLng => (_$data['minLng'] as double);

  double get maxLat => (_$data['maxLat'] as double);

  double get maxLng => (_$data['maxLng'] as double);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$minLat = minLat;
    result$data['minLat'] = l$minLat;
    final l$minLng = minLng;
    result$data['minLng'] = l$minLng;
    final l$maxLat = maxLat;
    result$data['maxLat'] = l$maxLat;
    final l$maxLng = maxLng;
    result$data['maxLng'] = l$maxLng;
    return result$data;
  }

  CopyWith$Input$MapBoundsInput<Input$MapBoundsInput> get copyWith =>
      CopyWith$Input$MapBoundsInput(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Input$MapBoundsInput || runtimeType != other.runtimeType) {
      return false;
    }
    final l$minLat = minLat;
    final lOther$minLat = other.minLat;
    if (l$minLat != lOther$minLat) {
      return false;
    }
    final l$minLng = minLng;
    final lOther$minLng = other.minLng;
    if (l$minLng != lOther$minLng) {
      return false;
    }
    final l$maxLat = maxLat;
    final lOther$maxLat = other.maxLat;
    if (l$maxLat != lOther$maxLat) {
      return false;
    }
    final l$maxLng = maxLng;
    final lOther$maxLng = other.maxLng;
    if (l$maxLng != lOther$maxLng) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$minLat = minLat;
    final l$minLng = minLng;
    final l$maxLat = maxLat;
    final l$maxLng = maxLng;
    return Object.hashAll([l$minLat, l$minLng, l$maxLat, l$maxLng]);
  }
}

abstract class CopyWith$Input$MapBoundsInput<TRes> {
  factory CopyWith$Input$MapBoundsInput(
    Input$MapBoundsInput instance,
    TRes Function(Input$MapBoundsInput) then,
  ) = _CopyWithImpl$Input$MapBoundsInput;

  factory CopyWith$Input$MapBoundsInput.stub(TRes res) =
      _CopyWithStubImpl$Input$MapBoundsInput;

  TRes call({double? minLat, double? minLng, double? maxLat, double? maxLng});
}

class _CopyWithImpl$Input$MapBoundsInput<TRes>
    implements CopyWith$Input$MapBoundsInput<TRes> {
  _CopyWithImpl$Input$MapBoundsInput(this._instance, this._then);

  final Input$MapBoundsInput _instance;

  final TRes Function(Input$MapBoundsInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? minLat = _undefined,
    Object? minLng = _undefined,
    Object? maxLat = _undefined,
    Object? maxLng = _undefined,
  }) => _then(
    Input$MapBoundsInput._({
      ..._instance._$data,
      if (minLat != _undefined && minLat != null) 'minLat': (minLat as double),
      if (minLng != _undefined && minLng != null) 'minLng': (minLng as double),
      if (maxLat != _undefined && maxLat != null) 'maxLat': (maxLat as double),
      if (maxLng != _undefined && maxLng != null) 'maxLng': (maxLng as double),
    }),
  );
}

class _CopyWithStubImpl$Input$MapBoundsInput<TRes>
    implements CopyWith$Input$MapBoundsInput<TRes> {
  _CopyWithStubImpl$Input$MapBoundsInput(this._res);

  TRes _res;

  call({double? minLat, double? minLng, double? maxLat, double? maxLng}) =>
      _res;
}

enum Enum$CongestionLevel {
  RELAXED,
  NORMAL,
  SLIGHTLY_CROWDED,
  CROWDED,
  $unknown;

  factory Enum$CongestionLevel.fromJson(String value) =>
      fromJson$Enum$CongestionLevel(value);

  String toJson() => toJson$Enum$CongestionLevel(this);
}

String toJson$Enum$CongestionLevel(Enum$CongestionLevel e) {
  switch (e) {
    case Enum$CongestionLevel.RELAXED:
      return r'RELAXED';
    case Enum$CongestionLevel.NORMAL:
      return r'NORMAL';
    case Enum$CongestionLevel.SLIGHTLY_CROWDED:
      return r'SLIGHTLY_CROWDED';
    case Enum$CongestionLevel.CROWDED:
      return r'CROWDED';
    case Enum$CongestionLevel.$unknown:
      return r'$unknown';
  }
}

Enum$CongestionLevel fromJson$Enum$CongestionLevel(String value) {
  switch (value) {
    case r'RELAXED':
      return Enum$CongestionLevel.RELAXED;
    case r'NORMAL':
      return Enum$CongestionLevel.NORMAL;
    case r'SLIGHTLY_CROWDED':
      return Enum$CongestionLevel.SLIGHTLY_CROWDED;
    case r'CROWDED':
      return Enum$CongestionLevel.CROWDED;
    default:
      return Enum$CongestionLevel.$unknown;
  }
}

enum Enum$CommercialActivityLevel {
  QUIET,
  NORMAL,
  BUSY,
  PEAK,
  $unknown;

  factory Enum$CommercialActivityLevel.fromJson(String value) =>
      fromJson$Enum$CommercialActivityLevel(value);

  String toJson() => toJson$Enum$CommercialActivityLevel(this);
}

String toJson$Enum$CommercialActivityLevel(Enum$CommercialActivityLevel e) {
  switch (e) {
    case Enum$CommercialActivityLevel.QUIET:
      return r'QUIET';
    case Enum$CommercialActivityLevel.NORMAL:
      return r'NORMAL';
    case Enum$CommercialActivityLevel.BUSY:
      return r'BUSY';
    case Enum$CommercialActivityLevel.PEAK:
      return r'PEAK';
    case Enum$CommercialActivityLevel.$unknown:
      return r'$unknown';
  }
}

Enum$CommercialActivityLevel fromJson$Enum$CommercialActivityLevel(
  String value,
) {
  switch (value) {
    case r'QUIET':
      return Enum$CommercialActivityLevel.QUIET;
    case r'NORMAL':
      return Enum$CommercialActivityLevel.NORMAL;
    case r'BUSY':
      return Enum$CommercialActivityLevel.BUSY;
    case r'PEAK':
      return Enum$CommercialActivityLevel.PEAK;
    default:
      return Enum$CommercialActivityLevel.$unknown;
  }
}
