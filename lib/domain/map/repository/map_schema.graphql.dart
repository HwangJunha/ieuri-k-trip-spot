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

class Input$CoordinatesInput {
  factory Input$CoordinatesInput({required double lat, required double lng}) =>
      Input$CoordinatesInput._({r'lat': lat, r'lng': lng});

  Input$CoordinatesInput._(this._$data);

  factory Input$CoordinatesInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$lat = data['lat'];
    result$data['lat'] = (l$lat as num).toDouble();
    final l$lng = data['lng'];
    result$data['lng'] = (l$lng as num).toDouble();
    return Input$CoordinatesInput._(result$data);
  }

  Map<String, dynamic> _$data;

  double get lat => (_$data['lat'] as double);

  double get lng => (_$data['lng'] as double);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$lat = lat;
    result$data['lat'] = l$lat;
    final l$lng = lng;
    result$data['lng'] = l$lng;
    return result$data;
  }

  CopyWith$Input$CoordinatesInput<Input$CoordinatesInput> get copyWith =>
      CopyWith$Input$CoordinatesInput(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Input$CoordinatesInput || runtimeType != other.runtimeType) {
      return false;
    }
    final l$lat = lat;
    final lOther$lat = other.lat;
    if (l$lat != lOther$lat) {
      return false;
    }
    final l$lng = lng;
    final lOther$lng = other.lng;
    if (l$lng != lOther$lng) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$lat = lat;
    final l$lng = lng;
    return Object.hashAll([l$lat, l$lng]);
  }
}

abstract class CopyWith$Input$CoordinatesInput<TRes> {
  factory CopyWith$Input$CoordinatesInput(
    Input$CoordinatesInput instance,
    TRes Function(Input$CoordinatesInput) then,
  ) = _CopyWithImpl$Input$CoordinatesInput;

  factory CopyWith$Input$CoordinatesInput.stub(TRes res) =
      _CopyWithStubImpl$Input$CoordinatesInput;

  TRes call({double? lat, double? lng});
}

class _CopyWithImpl$Input$CoordinatesInput<TRes>
    implements CopyWith$Input$CoordinatesInput<TRes> {
  _CopyWithImpl$Input$CoordinatesInput(this._instance, this._then);

  final Input$CoordinatesInput _instance;

  final TRes Function(Input$CoordinatesInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? lat = _undefined, Object? lng = _undefined}) => _then(
    Input$CoordinatesInput._({
      ..._instance._$data,
      if (lat != _undefined && lat != null) 'lat': (lat as double),
      if (lng != _undefined && lng != null) 'lng': (lng as double),
    }),
  );
}

class _CopyWithStubImpl$Input$CoordinatesInput<TRes>
    implements CopyWith$Input$CoordinatesInput<TRes> {
  _CopyWithStubImpl$Input$CoordinatesInput(this._res);

  TRes _res;

  call({double? lat, double? lng}) => _res;
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

enum Enum$RegionScoreFactor {
  CONGESTION,
  VISITOR_VOLUME,
  STAY_INTENSITY,
  SPENDING_INTENSITY,
  DISTANCE,
  $unknown;

  factory Enum$RegionScoreFactor.fromJson(String value) =>
      fromJson$Enum$RegionScoreFactor(value);

  String toJson() => toJson$Enum$RegionScoreFactor(this);
}

String toJson$Enum$RegionScoreFactor(Enum$RegionScoreFactor e) {
  switch (e) {
    case Enum$RegionScoreFactor.CONGESTION:
      return r'CONGESTION';
    case Enum$RegionScoreFactor.VISITOR_VOLUME:
      return r'VISITOR_VOLUME';
    case Enum$RegionScoreFactor.STAY_INTENSITY:
      return r'STAY_INTENSITY';
    case Enum$RegionScoreFactor.SPENDING_INTENSITY:
      return r'SPENDING_INTENSITY';
    case Enum$RegionScoreFactor.DISTANCE:
      return r'DISTANCE';
    case Enum$RegionScoreFactor.$unknown:
      return r'$unknown';
  }
}

Enum$RegionScoreFactor fromJson$Enum$RegionScoreFactor(String value) {
  switch (value) {
    case r'CONGESTION':
      return Enum$RegionScoreFactor.CONGESTION;
    case r'VISITOR_VOLUME':
      return Enum$RegionScoreFactor.VISITOR_VOLUME;
    case r'STAY_INTENSITY':
      return Enum$RegionScoreFactor.STAY_INTENSITY;
    case r'SPENDING_INTENSITY':
      return Enum$RegionScoreFactor.SPENDING_INTENSITY;
    case r'DISTANCE':
      return Enum$RegionScoreFactor.DISTANCE;
    default:
      return Enum$RegionScoreFactor.$unknown;
  }
}
