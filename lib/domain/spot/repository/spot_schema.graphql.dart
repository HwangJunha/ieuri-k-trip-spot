// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, unused_element
class Input$ReactToSpotInput {
  factory Input$ReactToSpotInput({
    required String catalogId,
    required Enum$SpotReaction reaction,
  }) => Input$ReactToSpotInput._({
    r'catalogId': catalogId,
    r'reaction': reaction,
  });

  Input$ReactToSpotInput._(this._$data);

  factory Input$ReactToSpotInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$catalogId = data['catalogId'];
    result$data['catalogId'] = (l$catalogId as String);
    final l$reaction = data['reaction'];
    result$data['reaction'] = fromJson$Enum$SpotReaction(
      (l$reaction as String),
    );
    return Input$ReactToSpotInput._(result$data);
  }

  Map<String, dynamic> _$data;

  String get catalogId => (_$data['catalogId'] as String);

  Enum$SpotReaction get reaction => (_$data['reaction'] as Enum$SpotReaction);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$catalogId = catalogId;
    result$data['catalogId'] = l$catalogId;
    final l$reaction = reaction;
    result$data['reaction'] = toJson$Enum$SpotReaction(l$reaction);
    return result$data;
  }

  CopyWith$Input$ReactToSpotInput<Input$ReactToSpotInput> get copyWith =>
      CopyWith$Input$ReactToSpotInput(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Input$ReactToSpotInput || runtimeType != other.runtimeType) {
      return false;
    }
    final l$catalogId = catalogId;
    final lOther$catalogId = other.catalogId;
    if (l$catalogId != lOther$catalogId) {
      return false;
    }
    final l$reaction = reaction;
    final lOther$reaction = other.reaction;
    if (l$reaction != lOther$reaction) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$catalogId = catalogId;
    final l$reaction = reaction;
    return Object.hashAll([l$catalogId, l$reaction]);
  }
}

abstract class CopyWith$Input$ReactToSpotInput<TRes> {
  factory CopyWith$Input$ReactToSpotInput(
    Input$ReactToSpotInput instance,
    TRes Function(Input$ReactToSpotInput) then,
  ) = _CopyWithImpl$Input$ReactToSpotInput;

  factory CopyWith$Input$ReactToSpotInput.stub(TRes res) =
      _CopyWithStubImpl$Input$ReactToSpotInput;

  TRes call({String? catalogId, Enum$SpotReaction? reaction});
}

class _CopyWithImpl$Input$ReactToSpotInput<TRes>
    implements CopyWith$Input$ReactToSpotInput<TRes> {
  _CopyWithImpl$Input$ReactToSpotInput(this._instance, this._then);

  final Input$ReactToSpotInput _instance;

  final TRes Function(Input$ReactToSpotInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? catalogId = _undefined, Object? reaction = _undefined}) =>
      _then(
        Input$ReactToSpotInput._({
          ..._instance._$data,
          if (catalogId != _undefined && catalogId != null)
            'catalogId': (catalogId as String),
          if (reaction != _undefined && reaction != null)
            'reaction': (reaction as Enum$SpotReaction),
        }),
      );
}

class _CopyWithStubImpl$Input$ReactToSpotInput<TRes>
    implements CopyWith$Input$ReactToSpotInput<TRes> {
  _CopyWithStubImpl$Input$ReactToSpotInput(this._res);

  TRes _res;

  call({String? catalogId, Enum$SpotReaction? reaction}) => _res;
}

enum Enum$SpotCategory {
  TOURIST_SPOT,
  CULTURAL_FACILITY,
  FESTIVAL_EVENT,
  TRAVEL_COURSE,
  LEISURE_SPORTS,
  LODGING,
  SHOPPING,
  RESTAURANT,
  TRANSPORT,
  $unknown;

  factory Enum$SpotCategory.fromJson(String value) =>
      fromJson$Enum$SpotCategory(value);

  String toJson() => toJson$Enum$SpotCategory(this);
}

String toJson$Enum$SpotCategory(Enum$SpotCategory e) {
  switch (e) {
    case Enum$SpotCategory.TOURIST_SPOT:
      return r'TOURIST_SPOT';
    case Enum$SpotCategory.CULTURAL_FACILITY:
      return r'CULTURAL_FACILITY';
    case Enum$SpotCategory.FESTIVAL_EVENT:
      return r'FESTIVAL_EVENT';
    case Enum$SpotCategory.TRAVEL_COURSE:
      return r'TRAVEL_COURSE';
    case Enum$SpotCategory.LEISURE_SPORTS:
      return r'LEISURE_SPORTS';
    case Enum$SpotCategory.LODGING:
      return r'LODGING';
    case Enum$SpotCategory.SHOPPING:
      return r'SHOPPING';
    case Enum$SpotCategory.RESTAURANT:
      return r'RESTAURANT';
    case Enum$SpotCategory.TRANSPORT:
      return r'TRANSPORT';
    case Enum$SpotCategory.$unknown:
      return r'$unknown';
  }
}

Enum$SpotCategory fromJson$Enum$SpotCategory(String value) {
  switch (value) {
    case r'TOURIST_SPOT':
      return Enum$SpotCategory.TOURIST_SPOT;
    case r'CULTURAL_FACILITY':
      return Enum$SpotCategory.CULTURAL_FACILITY;
    case r'FESTIVAL_EVENT':
      return Enum$SpotCategory.FESTIVAL_EVENT;
    case r'TRAVEL_COURSE':
      return Enum$SpotCategory.TRAVEL_COURSE;
    case r'LEISURE_SPORTS':
      return Enum$SpotCategory.LEISURE_SPORTS;
    case r'LODGING':
      return Enum$SpotCategory.LODGING;
    case r'SHOPPING':
      return Enum$SpotCategory.SHOPPING;
    case r'RESTAURANT':
      return Enum$SpotCategory.RESTAURANT;
    case r'TRANSPORT':
      return Enum$SpotCategory.TRANSPORT;
    default:
      return Enum$SpotCategory.$unknown;
  }
}

enum Enum$CopyrightType {
  TYPE1,
  TYPE3,
  UNSPECIFIED,
  $unknown;

  factory Enum$CopyrightType.fromJson(String value) =>
      fromJson$Enum$CopyrightType(value);

  String toJson() => toJson$Enum$CopyrightType(this);
}

String toJson$Enum$CopyrightType(Enum$CopyrightType e) {
  switch (e) {
    case Enum$CopyrightType.TYPE1:
      return r'TYPE1';
    case Enum$CopyrightType.TYPE3:
      return r'TYPE3';
    case Enum$CopyrightType.UNSPECIFIED:
      return r'UNSPECIFIED';
    case Enum$CopyrightType.$unknown:
      return r'$unknown';
  }
}

Enum$CopyrightType fromJson$Enum$CopyrightType(String value) {
  switch (value) {
    case r'TYPE1':
      return Enum$CopyrightType.TYPE1;
    case r'TYPE3':
      return Enum$CopyrightType.TYPE3;
    case r'UNSPECIFIED':
      return Enum$CopyrightType.UNSPECIFIED;
    default:
      return Enum$CopyrightType.$unknown;
  }
}

enum Enum$SpotReaction {
  LIKE,
  DISLIKE,
  $unknown;

  factory Enum$SpotReaction.fromJson(String value) =>
      fromJson$Enum$SpotReaction(value);

  String toJson() => toJson$Enum$SpotReaction(this);
}

String toJson$Enum$SpotReaction(Enum$SpotReaction e) {
  switch (e) {
    case Enum$SpotReaction.LIKE:
      return r'LIKE';
    case Enum$SpotReaction.DISLIKE:
      return r'DISLIKE';
    case Enum$SpotReaction.$unknown:
      return r'$unknown';
  }
}

Enum$SpotReaction fromJson$Enum$SpotReaction(String value) {
  switch (value) {
    case r'LIKE':
      return Enum$SpotReaction.LIKE;
    case r'DISLIKE':
      return Enum$SpotReaction.DISLIKE;
    default:
      return Enum$SpotReaction.$unknown;
  }
}
