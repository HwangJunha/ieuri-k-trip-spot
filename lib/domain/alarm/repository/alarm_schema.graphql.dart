// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, unused_element
class Input$RegisterDeviceTokenInput {
  factory Input$RegisterDeviceTokenInput({
    required String deviceId,
    required String fcmToken,
    required Enum$Locale language,
    required Enum$DevicePlatform platform,
  }) => Input$RegisterDeviceTokenInput._({
    r'deviceId': deviceId,
    r'fcmToken': fcmToken,
    r'language': language,
    r'platform': platform,
  });

  Input$RegisterDeviceTokenInput._(this._$data);

  factory Input$RegisterDeviceTokenInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$deviceId = data['deviceId'];
    result$data['deviceId'] = (l$deviceId as String);
    final l$fcmToken = data['fcmToken'];
    result$data['fcmToken'] = (l$fcmToken as String);
    final l$language = data['language'];
    result$data['language'] = fromJson$Enum$Locale((l$language as String));
    final l$platform = data['platform'];
    result$data['platform'] = fromJson$Enum$DevicePlatform(
      (l$platform as String),
    );
    return Input$RegisterDeviceTokenInput._(result$data);
  }

  Map<String, dynamic> _$data;

  String get deviceId => (_$data['deviceId'] as String);

  String get fcmToken => (_$data['fcmToken'] as String);

  Enum$Locale get language => (_$data['language'] as Enum$Locale);

  Enum$DevicePlatform get platform =>
      (_$data['platform'] as Enum$DevicePlatform);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$deviceId = deviceId;
    result$data['deviceId'] = l$deviceId;
    final l$fcmToken = fcmToken;
    result$data['fcmToken'] = l$fcmToken;
    final l$language = language;
    result$data['language'] = toJson$Enum$Locale(l$language);
    final l$platform = platform;
    result$data['platform'] = toJson$Enum$DevicePlatform(l$platform);
    return result$data;
  }

  CopyWith$Input$RegisterDeviceTokenInput<Input$RegisterDeviceTokenInput>
  get copyWith => CopyWith$Input$RegisterDeviceTokenInput(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Input$RegisterDeviceTokenInput ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$deviceId = deviceId;
    final lOther$deviceId = other.deviceId;
    if (l$deviceId != lOther$deviceId) {
      return false;
    }
    final l$fcmToken = fcmToken;
    final lOther$fcmToken = other.fcmToken;
    if (l$fcmToken != lOther$fcmToken) {
      return false;
    }
    final l$language = language;
    final lOther$language = other.language;
    if (l$language != lOther$language) {
      return false;
    }
    final l$platform = platform;
    final lOther$platform = other.platform;
    if (l$platform != lOther$platform) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$deviceId = deviceId;
    final l$fcmToken = fcmToken;
    final l$language = language;
    final l$platform = platform;
    return Object.hashAll([l$deviceId, l$fcmToken, l$language, l$platform]);
  }
}

abstract class CopyWith$Input$RegisterDeviceTokenInput<TRes> {
  factory CopyWith$Input$RegisterDeviceTokenInput(
    Input$RegisterDeviceTokenInput instance,
    TRes Function(Input$RegisterDeviceTokenInput) then,
  ) = _CopyWithImpl$Input$RegisterDeviceTokenInput;

  factory CopyWith$Input$RegisterDeviceTokenInput.stub(TRes res) =
      _CopyWithStubImpl$Input$RegisterDeviceTokenInput;

  TRes call({
    String? deviceId,
    String? fcmToken,
    Enum$Locale? language,
    Enum$DevicePlatform? platform,
  });
}

class _CopyWithImpl$Input$RegisterDeviceTokenInput<TRes>
    implements CopyWith$Input$RegisterDeviceTokenInput<TRes> {
  _CopyWithImpl$Input$RegisterDeviceTokenInput(this._instance, this._then);

  final Input$RegisterDeviceTokenInput _instance;

  final TRes Function(Input$RegisterDeviceTokenInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? deviceId = _undefined,
    Object? fcmToken = _undefined,
    Object? language = _undefined,
    Object? platform = _undefined,
  }) => _then(
    Input$RegisterDeviceTokenInput._({
      ..._instance._$data,
      if (deviceId != _undefined && deviceId != null)
        'deviceId': (deviceId as String),
      if (fcmToken != _undefined && fcmToken != null)
        'fcmToken': (fcmToken as String),
      if (language != _undefined && language != null)
        'language': (language as Enum$Locale),
      if (platform != _undefined && platform != null)
        'platform': (platform as Enum$DevicePlatform),
    }),
  );
}

class _CopyWithStubImpl$Input$RegisterDeviceTokenInput<TRes>
    implements CopyWith$Input$RegisterDeviceTokenInput<TRes> {
  _CopyWithStubImpl$Input$RegisterDeviceTokenInput(this._res);

  TRes _res;

  call({
    String? deviceId,
    String? fcmToken,
    Enum$Locale? language,
    Enum$DevicePlatform? platform,
  }) => _res;
}

class Input$DeleteDeviceTokenInput {
  factory Input$DeleteDeviceTokenInput({required String deviceId}) =>
      Input$DeleteDeviceTokenInput._({r'deviceId': deviceId});

  Input$DeleteDeviceTokenInput._(this._$data);

  factory Input$DeleteDeviceTokenInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$deviceId = data['deviceId'];
    result$data['deviceId'] = (l$deviceId as String);
    return Input$DeleteDeviceTokenInput._(result$data);
  }

  Map<String, dynamic> _$data;

  String get deviceId => (_$data['deviceId'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$deviceId = deviceId;
    result$data['deviceId'] = l$deviceId;
    return result$data;
  }

  CopyWith$Input$DeleteDeviceTokenInput<Input$DeleteDeviceTokenInput>
  get copyWith => CopyWith$Input$DeleteDeviceTokenInput(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Input$DeleteDeviceTokenInput ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$deviceId = deviceId;
    final lOther$deviceId = other.deviceId;
    if (l$deviceId != lOther$deviceId) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$deviceId = deviceId;
    return Object.hashAll([l$deviceId]);
  }
}

abstract class CopyWith$Input$DeleteDeviceTokenInput<TRes> {
  factory CopyWith$Input$DeleteDeviceTokenInput(
    Input$DeleteDeviceTokenInput instance,
    TRes Function(Input$DeleteDeviceTokenInput) then,
  ) = _CopyWithImpl$Input$DeleteDeviceTokenInput;

  factory CopyWith$Input$DeleteDeviceTokenInput.stub(TRes res) =
      _CopyWithStubImpl$Input$DeleteDeviceTokenInput;

  TRes call({String? deviceId});
}

class _CopyWithImpl$Input$DeleteDeviceTokenInput<TRes>
    implements CopyWith$Input$DeleteDeviceTokenInput<TRes> {
  _CopyWithImpl$Input$DeleteDeviceTokenInput(this._instance, this._then);

  final Input$DeleteDeviceTokenInput _instance;

  final TRes Function(Input$DeleteDeviceTokenInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? deviceId = _undefined}) => _then(
    Input$DeleteDeviceTokenInput._({
      ..._instance._$data,
      if (deviceId != _undefined && deviceId != null)
        'deviceId': (deviceId as String),
    }),
  );
}

class _CopyWithStubImpl$Input$DeleteDeviceTokenInput<TRes>
    implements CopyWith$Input$DeleteDeviceTokenInput<TRes> {
  _CopyWithStubImpl$Input$DeleteDeviceTokenInput(this._res);

  TRes _res;

  call({String? deviceId}) => _res;
}

class Input$UpdateNotificationPreferenceInput {
  factory Input$UpdateNotificationPreferenceInput({
    required Enum$NotificationCategory category,
    required bool enabled,
  }) => Input$UpdateNotificationPreferenceInput._({
    r'category': category,
    r'enabled': enabled,
  });

  Input$UpdateNotificationPreferenceInput._(this._$data);

  factory Input$UpdateNotificationPreferenceInput.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    final l$category = data['category'];
    result$data['category'] = fromJson$Enum$NotificationCategory(
      (l$category as String),
    );
    final l$enabled = data['enabled'];
    result$data['enabled'] = (l$enabled as bool);
    return Input$UpdateNotificationPreferenceInput._(result$data);
  }

  Map<String, dynamic> _$data;

  Enum$NotificationCategory get category =>
      (_$data['category'] as Enum$NotificationCategory);

  bool get enabled => (_$data['enabled'] as bool);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$category = category;
    result$data['category'] = toJson$Enum$NotificationCategory(l$category);
    final l$enabled = enabled;
    result$data['enabled'] = l$enabled;
    return result$data;
  }

  CopyWith$Input$UpdateNotificationPreferenceInput<
    Input$UpdateNotificationPreferenceInput
  >
  get copyWith =>
      CopyWith$Input$UpdateNotificationPreferenceInput(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Input$UpdateNotificationPreferenceInput ||
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

  @override
  int get hashCode {
    final l$category = category;
    final l$enabled = enabled;
    return Object.hashAll([l$category, l$enabled]);
  }
}

abstract class CopyWith$Input$UpdateNotificationPreferenceInput<TRes> {
  factory CopyWith$Input$UpdateNotificationPreferenceInput(
    Input$UpdateNotificationPreferenceInput instance,
    TRes Function(Input$UpdateNotificationPreferenceInput) then,
  ) = _CopyWithImpl$Input$UpdateNotificationPreferenceInput;

  factory CopyWith$Input$UpdateNotificationPreferenceInput.stub(TRes res) =
      _CopyWithStubImpl$Input$UpdateNotificationPreferenceInput;

  TRes call({Enum$NotificationCategory? category, bool? enabled});
}

class _CopyWithImpl$Input$UpdateNotificationPreferenceInput<TRes>
    implements CopyWith$Input$UpdateNotificationPreferenceInput<TRes> {
  _CopyWithImpl$Input$UpdateNotificationPreferenceInput(
    this._instance,
    this._then,
  );

  final Input$UpdateNotificationPreferenceInput _instance;

  final TRes Function(Input$UpdateNotificationPreferenceInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? category = _undefined, Object? enabled = _undefined}) =>
      _then(
        Input$UpdateNotificationPreferenceInput._({
          ..._instance._$data,
          if (category != _undefined && category != null)
            'category': (category as Enum$NotificationCategory),
          if (enabled != _undefined && enabled != null)
            'enabled': (enabled as bool),
        }),
      );
}

class _CopyWithStubImpl$Input$UpdateNotificationPreferenceInput<TRes>
    implements CopyWith$Input$UpdateNotificationPreferenceInput<TRes> {
  _CopyWithStubImpl$Input$UpdateNotificationPreferenceInput(this._res);

  TRes _res;

  call({Enum$NotificationCategory? category, bool? enabled}) => _res;
}

enum Enum$Locale {
  EN,
  KO,
  JA,
  ZH,
  $unknown;

  factory Enum$Locale.fromJson(String value) => fromJson$Enum$Locale(value);

  String toJson() => toJson$Enum$Locale(this);
}

String toJson$Enum$Locale(Enum$Locale e) {
  switch (e) {
    case Enum$Locale.EN:
      return r'EN';
    case Enum$Locale.KO:
      return r'KO';
    case Enum$Locale.JA:
      return r'JA';
    case Enum$Locale.ZH:
      return r'ZH';
    case Enum$Locale.$unknown:
      return r'$unknown';
  }
}

Enum$Locale fromJson$Enum$Locale(String value) {
  switch (value) {
    case r'EN':
      return Enum$Locale.EN;
    case r'KO':
      return Enum$Locale.KO;
    case r'JA':
      return Enum$Locale.JA;
    case r'ZH':
      return Enum$Locale.ZH;
    default:
      return Enum$Locale.$unknown;
  }
}

enum Enum$DevicePlatform {
  IOS,
  ANDROID,
  $unknown;

  factory Enum$DevicePlatform.fromJson(String value) =>
      fromJson$Enum$DevicePlatform(value);

  String toJson() => toJson$Enum$DevicePlatform(this);
}

String toJson$Enum$DevicePlatform(Enum$DevicePlatform e) {
  switch (e) {
    case Enum$DevicePlatform.IOS:
      return r'IOS';
    case Enum$DevicePlatform.ANDROID:
      return r'ANDROID';
    case Enum$DevicePlatform.$unknown:
      return r'$unknown';
  }
}

Enum$DevicePlatform fromJson$Enum$DevicePlatform(String value) {
  switch (value) {
    case r'IOS':
      return Enum$DevicePlatform.IOS;
    case r'ANDROID':
      return Enum$DevicePlatform.ANDROID;
    default:
      return Enum$DevicePlatform.$unknown;
  }
}

enum Enum$NotificationCategory {
  MESSAGE,
  SPOT_QA,
  $unknown;

  factory Enum$NotificationCategory.fromJson(String value) =>
      fromJson$Enum$NotificationCategory(value);

  String toJson() => toJson$Enum$NotificationCategory(this);
}

String toJson$Enum$NotificationCategory(Enum$NotificationCategory e) {
  switch (e) {
    case Enum$NotificationCategory.MESSAGE:
      return r'MESSAGE';
    case Enum$NotificationCategory.SPOT_QA:
      return r'SPOT_QA';
    case Enum$NotificationCategory.$unknown:
      return r'$unknown';
  }
}

Enum$NotificationCategory fromJson$Enum$NotificationCategory(String value) {
  switch (value) {
    case r'MESSAGE':
      return Enum$NotificationCategory.MESSAGE;
    case r'SPOT_QA':
      return Enum$NotificationCategory.SPOT_QA;
    default:
      return Enum$NotificationCategory.$unknown;
  }
}
