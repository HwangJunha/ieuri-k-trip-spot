import 'package:gql/ast.dart' show DocumentNode;
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../../common/network/graphql_debug_log.dart';
import '../../../common/network/graphql_failure.dart';
import '../model/alarm_failure.dart';
import '../model/device_registration.dart';
import '../model/notification_preference.dart';
import 'alarm_operations.graphql.dart';
import 'alarm_repository.dart';
import 'alarm_schema.graphql.dart';

/// [AlarmRepository]의 GraphQL 구현(SPEC-0028). 생성 타입은 이 파일 밖으로 나가지
/// 않는다(CLAUDE.md §3 · POL-020).
class AlarmRepositoryImpl implements AlarmRepository {
  AlarmRepositoryImpl(this._client);

  final GraphQLClient _client;

  @override
  Future<void> registerDeviceToken(DeviceRegistration registration) async {
    final Map<String, dynamic> data = await _mutate(
      documentNodeMutationRegisterDeviceToken,
      Variables$Mutation$RegisterDeviceToken(
        input: Input$RegisterDeviceTokenInput(
          deviceId: registration.deviceId,
          fcmToken: registration.fcmToken,
          language: _locale(registration.languageCode),
          platform: _platform(registration.platform),
        ),
      ).toJson(),
      'registerDeviceToken',
    );
    final payload = Mutation$RegisterDeviceToken.fromJson(
      data,
    ).registerDeviceToken;
    _check('registerDeviceToken', payload.success, payload.userErrors);
  }

  @override
  Future<void> deleteDeviceToken(String deviceId) async {
    final Map<String, dynamic> data = await _mutate(
      documentNodeMutationDeleteDeviceToken,
      Variables$Mutation$DeleteDeviceToken(
        input: Input$DeleteDeviceTokenInput(deviceId: deviceId),
      ).toJson(),
      'deleteDeviceToken',
    );
    final payload = Mutation$DeleteDeviceToken.fromJson(data).deleteDeviceToken;
    _check('deleteDeviceToken', payload.success, payload.userErrors);
  }

  @override
  Future<List<NotificationPreference>> fetchPreferences() async {
    final Map<String, dynamic> data = await _query(
      documentNodeQueryNotificationPreferences,
      const <String, dynamic>{},
      'notificationPreferences',
    );
    final me = Query$NotificationPreferences.fromJson(data).me;
    return me.notificationPreferences.map(_preference).toList();
  }

  @override
  Future<List<NotificationPreference>> updatePreference({
    required NotificationCategory category,
    required bool enabled,
  }) async {
    final Map<String, dynamic> data = await _mutate(
      documentNodeMutationUpdateNotificationPreference,
      Variables$Mutation$UpdateNotificationPreference(
        input: Input$UpdateNotificationPreferenceInput(
          category: _category(category),
          enabled: enabled,
        ),
      ).toJson(),
      'updateNotificationPreference',
    );
    final payload = Mutation$UpdateNotificationPreference.fromJson(
      data,
    ).updateNotificationPreference;
    _check('updateNotificationPreference', payload.success, payload.userErrors);
    return payload.notificationPreferences.map(_preference).toList();
  }

  /// 생성 타입 → 도메인 모델. codegen이 오퍼레이션마다 별개 클래스를 만들어 필드가
  /// 같아도 타입이 다르므로 JSON을 거쳐 옮긴다(settings 조각과 같은 방식).
  NotificationPreference _preference(Object item) {
    final Map<String, dynamic> json =
        (item as dynamic).toJson() as Map<String, dynamic>;
    final NotificationCategory? category = NotificationCategory.fromWire(
      json['category'] as String?,
    );
    // 모르는 카테고리는 매핑할 도메인 값이 없어 실패로 본다 — 임의의 값으로
    // 떨어뜨리면 사용자가 끈 것과 켠 것이 뒤바뀐다.
    if (category == null) throw AlarmFailure.unknown;
    return NotificationPreference(
      category: category,
      enabled: json['enabled'] as bool? ?? true,
    );
  }

  Enum$NotificationCategory _category(NotificationCategory category) =>
      switch (category) {
        NotificationCategory.message => Enum$NotificationCategory.MESSAGE,
        NotificationCategory.spotQa => Enum$NotificationCategory.SPOT_QA,
      };

  Enum$DevicePlatform _platform(DevicePlatform platform) => switch (platform) {
    DevicePlatform.ios => Enum$DevicePlatform.IOS,
    DevicePlatform.android => Enum$DevicePlatform.ANDROID,
  };

  /// 도메인은 서버 enum 문자열을 그대로 들고 있고(`languageFromDeviceCode`가 이미
  /// EN 폴백을 했다), 여기서 생성 enum으로 옮긴다. 모르는 값은 EN이다(AC20.3).
  Enum$Locale _locale(String code) => switch (code) {
    'KO' => Enum$Locale.KO,
    'JA' => Enum$Locale.JA,
    'ZH' => Enum$Locale.ZH,
    _ => Enum$Locale.EN,
  };

  Future<Map<String, dynamic>> _query(
    DocumentNode document,
    Map<String, dynamic> variables,
    String operation,
  ) => _run(
    () => _client.query(
      QueryOptions(document: document, variables: variables),
    ),
    operation,
    variables,
  );

  Future<Map<String, dynamic>> _mutate(
    DocumentNode document,
    Map<String, dynamic> variables,
    String operation,
  ) => _run(
    () => _client.mutate(
      MutationOptions(document: document, variables: variables),
    ),
    operation,
    variables,
  );

  Future<Map<String, dynamic>> _run(
    Future<QueryResult<Object?>> Function() call,
    String operation,
    Map<String, dynamic> variables,
  ) async {
    // 변수에 FCM 토큰이 들어 있다. 디버그 로그는 값 자체를 찍지 않도록
    // GraphqlDebugLog가 키만 남긴다(POL-013·POL-047).
    GraphqlDebugLog.request(operation, variables);
    late final QueryResult<Object?> result;
    try {
      result = await call();
    } on Exception catch (error) {
      GraphqlDebugLog.clientThrew(operation, error);
      // 클라이언트가 던졌다 = 응답 자체를 못 받았다 → 전송 실패.
      throw AlarmFailure.network;
    }
    GraphqlDebugLog.response(operation, result);
    if (hasTransportFailure(result)) {
      GraphqlDebugLog.transportFailure(operation, result);
      throw AlarmFailure.fromQueryErrorCode(_errorCode(result));
    }
    final Object? data = result.data;
    if (data is! Map<String, dynamic>) throw AlarmFailure.unknown;
    return data;
  }

  String? _errorCode(QueryResult<Object?> result) {
    final List<GraphQLError> errors =
        result.exception?.graphqlErrors ?? const <GraphQLError>[];
    if (errors.isEmpty) return null;

    // **첫 오류만 보지 않는다**(2026-08-25). `ErrorPolicy.all` 이후로는 여러 오류가
    // 한 배열에 실려 오는데, 코드가 붙은 것이 앞자리라는 보장이 없다 — 첫 항목만
    // 보면 인증 실패가 네트워크 실패로 둔갑해 재시도 예산을 태운다
    // (`graphql_failure.dart`의 `firstRootError` 문서가 같은 위험을 적고 있다).
    //
    // 코드가 붙은 첫 오류를 고르고, 하나도 없을 때만 메시지 폴백으로 내려간다.
    for (final GraphQLError error in errors) {
      final Object? code = error.extensions?['code'];
      if (code is String && code.isNotEmpty) return code;
    }
    for (final GraphQLError error in errors) {
      final String message = error.message;
      if (RegExp(r'^[A-Z][A-Z0-9_]+$').hasMatch(message)) return message;
    }
    return null;
  }

  /// 도메인 실패 검사: `userErrors`가 비어 있지 않거나 `success == false`면 실패.
  /// **코드만** 로깅한다 — 서버 message는 PII를 담을 수 있다(POL-013).
  void _check(String operation, bool success, List<Object?> userErrors) {
    final List<({String code, String? field})> parsed = userErrors
        .map(_userError)
        .toList();
    if (parsed.isNotEmpty) {
      GraphqlDebugLog.userErrors(operation, parsed);
      throw AlarmFailure.userError(parsed.first.code);
    }
    if (!success) throw AlarmFailure.unknown;
  }

  ({String code, String? field}) _userError(Object? error) {
    if (error == null) return (code: '', field: null);
    final Map<String, dynamic> json =
        (error as dynamic).toJson() as Map<String, dynamic>;
    return (code: json['code'] as String? ?? '', field: json['field'] as String?);
  }
}
