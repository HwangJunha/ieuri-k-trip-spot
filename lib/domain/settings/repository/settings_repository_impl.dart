import 'package:gql/ast.dart' show DocumentNode;
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../../common/model/terms_code.dart';
import '../../../common/network/graphql_debug_log.dart';
import '../../../common/network/graphql_failure.dart';
// **생성 타입 하나만 가져온다 — 기능 간 의존이 아니다.** codegen은 모든 스키마 조각을
// 한 이름공간에 합치므로 `TermsCode`의 생성 enum은 그것을 선언한 auth 조각에 놓인다
// (community가 `SpotCategory`를 이렇게 가져오는 것과 같다). 같은 enum을 설정 조각에
// 다시 선언하면 중복 정의로 빌드가 깨진다. 이 타입은 repository 밖으로 나가지 않고,
// 도메인 값은 `common/model/terms_code.dart`다(CLAUDE.md §3).
import '../../auth/repository/auth_schema.graphql.dart';
import '../model/agreement_status.dart';
import '../model/settings_failure.dart';
import 'settings_operations.graphql.dart';
import 'settings_repository.dart';
import 'settings_schema.graphql.dart';

/// GraphQL 기반 [SettingsRepository](SPEC-0011 R9~R12). graphql_codegen이 만든 타입
/// 연산을 공용 클라이언트로 실행하고 응답을 도메인 모델로 매핑한다. 생성 타입
/// (`*.graphql.dart`)은 **이 파일 밖으로 나가지 않는다**(CLAUDE.md §3).
///
/// 실패 판정은 두 단계다(auth·community와 같은 규약):
///  1. 전송 실패 — 링크 예외나 최상위 `errors[]`. **HTTP는 실패해도 200이다.**
///  2. 도메인 실패 — payload의 `success == false` 또는 `userErrors[]`가 비어있지 않음.
class SettingsRepositoryImpl implements SettingsRepository {
  SettingsRepositoryImpl(this._client);

  final GraphQLClient _client;

  @override
  Future<List<AgreementStatus>> fetchAgreements() async {
    final Map<String, dynamic> data = await _query(
      documentNodeQueryAgreements,
      const <String, dynamic>{},
      'agreements',
    );
    return Query$Agreements.fromJson(data).agreements.map(_status).toList();
  }

  @override
  Future<AgreementStatus?> updateAgreement({
    required TermsCode termsCode,
    required bool agreed,
  }) async {
    final Map<String, dynamic> data = await _mutate(
      documentNodeMutationUpdateAgreement,
      Variables$Mutation$UpdateAgreement(
        input: Input$UpdateAgreementInput(
          termsCode: _termsCodeInput(termsCode),
          agreed: agreed,
        ),
      ).toJson(),
      'updateAgreement',
    );
    final payload = Mutation$UpdateAgreement.fromJson(data).updateAgreement;
    _check('updateAgreement', payload.success, payload.userErrors);
    final agreement = payload.agreement;
    return agreement == null ? null : _status(agreement);
  }

  @override
  Future<List<AgreementStatus>> agreeToRequiredTerms(
    List<TermsCode> codes,
  ) async {
    final Map<String, dynamic> data = await _mutate(
      documentNodeMutationAgreeToRequiredTerms,
      Variables$Mutation$AgreeToRequiredTerms(
        input: Input$AgreeToRequiredTermsInput(
          termsCodes: codes.map(_termsCodeInput).toList(),
        ),
      ).toJson(),
      'agreeToRequiredTerms',
    );
    final payload = Mutation$AgreeToRequiredTerms.fromJson(
      data,
    ).agreeToRequiredTerms;
    _check('agreeToRequiredTerms', payload.success, payload.userErrors);
    return payload.agreements.map(_status).toList();
  }

  // --- 매핑 ------------------------------------------------------------------

  /// 생성 타입을 도메인 [AgreementStatus]로 옮긴다. 세 오퍼레이션의 생성 타입이 서로
  /// 다르므로(같은 필드셋이라도 codegen은 오퍼레이션별로 클래스를 만든다) JSON을 거쳐
  /// 한 곳에서 매핑한다.
  AgreementStatus _status(Object status) {
    final Map<String, dynamic> json =
        (status as dynamic).toJson() as Map<String, dynamic>;
    return AgreementStatus(
      termsCode: _termsCode(json['termsCode'] as String?),
      required: json['required'] as bool? ?? false,
      agreed: json['agreed'] as bool? ?? false,
      agreedAt: json['agreedAt'] as String?,
      version: json['version'] as String? ?? '',
    );
  }

  /// 서버 enum 문자열을 도메인 값으로 되돌린다. 모르는 값이면 매핑할 도메인 값이 없어
  /// 실패로 본다 — 임의의 값으로 떨어뜨리면 필수/선택 판정이 조용히 틀어진다.
  TermsCode _termsCode(String? wireName) => TermsCode.values.firstWhere(
    (TermsCode c) => c.wireName == wireName,
    orElse: () => throw SettingsFailure.unknown,
  );

  Enum$TermsCode _termsCodeInput(TermsCode code) => switch (code) {
    TermsCode.service => Enum$TermsCode.SERVICE,
    TermsCode.privacy => Enum$TermsCode.PRIVACY,
    TermsCode.location => Enum$TermsCode.LOCATION,
    TermsCode.marketing => Enum$TermsCode.MARKETING,
  };

  // --- 전송/실행 -------------------------------------------------------------

  Future<Map<String, dynamic>> _query(
    DocumentNode document,
    Map<String, dynamic> variables,
    String operation,
  ) => _run(
    () => _client.query(QueryOptions(document: document, variables: variables)),
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
    GraphqlDebugLog.request(operation, variables);
    late final QueryResult<Object?> result;
    try {
      result = await call();
    } on Exception catch (error) {
      GraphqlDebugLog.clientThrew(operation, error);
      // 클라이언트가 던졌다 = 응답 자체를 못 받았다 → 전송 실패.
      throw SettingsFailure.network;
    }

    GraphqlDebugLog.response(operation, result);

    // 이 슬라이스에는 부분 실패가 없다(중첩 커넥션이 없다) — `errors[]`가 하나라도
    // 있으면 전체 실패다.
    if (hasTransportFailure(result)) {
      GraphqlDebugLog.transportFailure(operation, result);
      throw SettingsFailure.fromQueryErrorCode(_errorCode(result));
    }

    final Object? data = result.data;
    if (data is! Map<String, dynamic>) throw SettingsFailure.unknown;
    return data;
  }

  /// 최상위 오류의 코드 문자열. `extensions.code`가 관례이고, 없으면 코드처럼 보이는
  /// 메시지(SCREAMING_SNAKE)를 폴백으로 본다.
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
      throw SettingsFailure.userError(parsed.first.code);
    }
    if (!success) throw SettingsFailure.unknown;
  }

  /// 생성된 `*$userErrors` payload에서 `code`/`field`만 JSON으로 꺼낸다 —
  /// 오퍼레이션별 생성 타입에 묶이지 않기 위해서다(auth repository와 같은 방식).
  ({String code, String? field}) _userError(Object? error) {
    if (error == null) return (code: '', field: null);
    final Map<String, dynamic> json =
        (error as dynamic).toJson() as Map<String, dynamic>;
    return (
      code: json['code'] as String? ?? '',
      field: json['field'] as String?,
    );
  }
}
