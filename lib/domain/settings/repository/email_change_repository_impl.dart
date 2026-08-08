import 'package:gql/ast.dart' show DocumentNode;
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../../common/network/graphql_debug_log.dart';
import '../../../common/network/graphql_failure.dart';
import '../model/email_change_confirmation.dart';
import '../model/email_change_failure_reason.dart';
import '../model/email_change_request.dart';
import '../model/settings_failure.dart';
import 'email_change_operations.graphql.dart';
import 'email_change_repository.dart';
// `Input$*`는 오퍼레이션이 아니라 **스키마** 조각에서 생성된다(프로필 repository와
// 같은 구조).
import 'email_change_schema.graphql.dart';

/// GraphQL 기반 [EmailChangeRepository](SPEC-0011 R7·R8). 생성 타입은 **이 파일 밖으로
/// 나가지 않는다**(CLAUDE.md §3).
///
/// 실패 판정은 프로필·약관 repository와 같은 두 단계다:
///  1. 전송 실패 — 링크 예외나 최상위 `errors[]`. **HTTP는 실패해도 200이다.**
///  2. 도메인 실패 — payload의 `success == false` 또는 `userErrors[]`가 비어있지 않음.
///
/// 예외는 [confirmEmailChange]다. 코드 불일치·만료·시도 초과는 **정상 응답이 담은
/// 판정**이고 화면이 사유별로 다른 안내를 해야 하므로(디자인 §4), 예외가 아니라
/// [EmailChangeConfirmation] 값으로 돌려준다.
class EmailChangeRepositoryImpl implements EmailChangeRepository {
  EmailChangeRepositoryImpl(this._client);

  final GraphQLClient _client;

  @override
  Future<EmailChangeRequest> requestEmailChange(String newEmail) async {
    final Map<String, dynamic> data = await _mutate(
      documentNodeMutationChangeEmail,
      Variables$Mutation$ChangeEmail(
        input: Input$ChangeEmailInput(newEmail: newEmail),
      ).toJson(),
      'changeEmail',
    );
    final Mutation$ChangeEmail$changeEmail payload =
        Mutation$ChangeEmail.fromJson(data).changeEmail;
    _check('changeEmail', payload.success, payload.userErrors);
    return _request('changeEmail', payload.verificationId, payload.expiresAt);
  }

  @override
  Future<EmailChangeConfirmation> confirmEmailChange({
    required String verificationId,
    required String code,
  }) async {
    final Map<String, dynamic> data = await _mutate(
      documentNodeMutationConfirmEmailChange,
      Variables$Mutation$ConfirmEmailChange(
        input: Input$ConfirmEmailChangeInput(
          verificationId: verificationId,
          code: code,
        ),
      ).toJson(),
      'confirmEmailChange',
    );
    final Mutation$ConfirmEmailChange$confirmEmailChange payload =
        Mutation$ConfirmEmailChange.fromJson(data).confirmEmailChange;

    // `userErrors`는 여전히 예외다 — 입력 자체가 거절된 것(인증 만료 등)이라
    // 사유별 안내로 다룰 대상이 아니다. 검증 판정만 값으로 내려간다.
    if (payload.userErrors.isNotEmpty) {
      _check('confirmEmailChange', payload.success, payload.userErrors);
    }

    if (!payload.success) {
      final EmailChangeFailureReason reason =
          EmailChangeFailureReason.fromServer(payload.failureReason);
      // **사유 코드만 남긴다** — 서버 원문 message는 PII를 담을 수 있다(POL-013).
      GraphqlDebugLog.userErrors(
        'confirmEmailChange',
        <({String code, String? field})>[(code: reason.name, field: null)],
      );
      return EmailChangeConfirmation.failure(reason);
    }

    final String? email = payload.email;
    // 성공인데 이메일이 없으면 무엇으로 바뀌었는지 알 수 없다. 세션을 다시 조회해
    // 맞추는 것은 provider의 몫이므로 여기서는 응답 이상으로 본다.
    if (email == null) throw SettingsFailure.unknown;
    return EmailChangeConfirmation.success(email);
  }

  @override
  Future<EmailChangeRequest> resendEmailChange(String verificationId) async {
    final Map<String, dynamic> data = await _mutate(
      documentNodeMutationResendEmailChange,
      Variables$Mutation$ResendEmailChange(
        input: Input$ResendEmailChangeInput(verificationId: verificationId),
      ).toJson(),
      'resendEmailChange',
    );
    final Mutation$ResendEmailChange$resendEmailChange payload =
        Mutation$ResendEmailChange.fromJson(data).resendEmailChange;
    _check('resendEmailChange', payload.success, payload.userErrors);
    // 서버가 새 id를 주지 않으면 기존 것이 유효하다는 뜻이다.
    return _request(
      'resendEmailChange',
      payload.verificationId ?? verificationId,
      payload.expiresAt,
    );
  }

  // --- 매핑 (생성 타입 → 도메인) ---------------------------------------------

  /// 1단계·재발송 payload → [EmailChangeRequest]. `verificationId`가 없으면 다음
  /// 단계를 진행할 수 없으므로 조용히 넘기지 않는다 — 코드 화면이 빈 id로 검증을
  /// 보내면 원인을 알 수 없는 실패가 된다.
  EmailChangeRequest _request(
    String operation,
    String? verificationId,
    String? expiresAt,
  ) {
    if (verificationId == null || verificationId.isEmpty) {
      GraphqlDebugLog.clientThrew(
        operation,
        const FormatException('missing verificationId'),
      );
      throw SettingsFailure.unknown;
    }
    return EmailChangeRequest(
      verificationId: verificationId,
      expiresAt: expiresAt,
    );
  }

  // --- 전송/실행 -------------------------------------------------------------

  Future<Map<String, dynamic>> _mutate(
    DocumentNode document,
    Map<String, dynamic> variables,
    String operation,
  ) async {
    // **변수를 로깅하지 않는다** — 새 이메일 주소와 인증 코드가 들어 있다(POL-013).
    GraphqlDebugLog.request(operation, const <String, dynamic>{});
    late final QueryResult<Object?> result;
    try {
      result = await _client.mutate(
        MutationOptions(document: document, variables: variables),
      );
    } on Exception catch (error) {
      GraphqlDebugLog.clientThrew(operation, error);
      // 클라이언트가 던졌다 = 응답 자체를 못 받았다 → 전송 실패.
      throw SettingsFailure.network;
    }

    GraphqlDebugLog.response(operation, result);

    if (hasRootFailure(result, operation)) {
      GraphqlDebugLog.transportFailure(operation, result);
      throw SettingsFailure.fromQueryErrorCode(
        _rootErrorCode(result, operation),
      );
    }

    final Object? data = result.data;
    if (data is! Map<String, dynamic>) throw SettingsFailure.unknown;
    return data;
  }

  /// 전체 실패로 판정된 오류의 코드 문자열. `extensions.code`가 관례이고, 없으면
  /// 코드처럼 보이는 메시지(SCREAMING_SNAKE)를 폴백으로 본다.
  String? _rootErrorCode(QueryResult<Object?> result, String rootField) {
    final GraphQLError? error = firstRootError(result, rootField);
    if (error == null) return null;
    final Object? code = error.extensions?['code'];
    if (code is String && code.isNotEmpty) return code;
    final String message = error.message;
    return RegExp(r'^[A-Z][A-Z0-9_]+$').hasMatch(message) ? message : null;
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

  /// 생성된 `*$userErrors` payload에서 `code`/`field`만 JSON으로 꺼낸다 — 오퍼레이션별
  /// 생성 타입에 묶이지 않기 위해서다(다른 repository와 같은 방식).
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
