import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:ieuri_k_trip_spot/domain/settings/model/email_change_confirmation.dart';
import 'package:ieuri_k_trip_spot/domain/settings/model/email_change_failure_reason.dart';
import 'package:ieuri_k_trip_spot/domain/settings/model/email_change_request.dart';
import 'package:ieuri_k_trip_spot/domain/settings/model/settings_failure.dart';
import 'package:ieuri_k_trip_spot/domain/settings/repository/email_change_repository_impl.dart';

/// SPEC-0011 R7·R8 — 이메일 변경 저장소. GraphQL은 실패해도 HTTP 200이므로
/// `errors` 배열과 `userErrors`를 실패로 옮기는지가 핵심이다(CLAUDE.md §4·§8).

class _FakeLink extends Link {
  _FakeLink({this.data, this.errors});

  final Map<String, dynamic>? data;
  final List<GraphQLError>? errors;

  /// 마지막으로 나간 변수(전송 내용 검증용).
  Map<String, dynamic>? sentVariables;

  @override
  Stream<Response> request(Request request, [NextLink? forward]) async* {
    sentVariables = request.variables;
    yield Response(
      data: data,
      errors: errors,
      response: const <String, dynamic>{},
      context: const Context(),
    );
  }
}

EmailChangeRepositoryImpl _repo(Link link) => EmailChangeRepositoryImpl(
  GraphQLClient(
    link: link,
    cache: GraphQLCache(),
    defaultPolicies: DefaultPolicies(
      mutate: Policies(fetch: FetchPolicy.noCache, error: ErrorPolicy.all),
      query: Policies(fetch: FetchPolicy.noCache, error: ErrorPolicy.all),
    ),
  ),
);

List<dynamic> _oneUserError({String code = 'EMAIL_ALREADY_IN_USE'}) =>
    <dynamic>[
      <String, dynamic>{'code': code, 'message': 'x', 'field': 'newEmail'},
    ];

void main() {
  group('requestEmailChange (R7)', () {
    test('성공하면 검증 건의 손잡이를 돌려준다', () async {
      final _FakeLink link = _FakeLink(
        data: <String, dynamic>{
          'changeEmail': <String, dynamic>{
            'success': true,
            'userErrors': <dynamic>[],
            'verificationId': 'verify-9',
            'expiresAt': '2026-08-09T10:00:00Z',
          },
        },
      );

      final EmailChangeRequest result = await _repo(
        link,
      ).requestEmailChange('new@example.com');

      expect(result.verificationId, 'verify-9');
    });

    test('새 주소를 그대로 실어 보낸다', () async {
      final _FakeLink link = _FakeLink(
        data: <String, dynamic>{
          'changeEmail': <String, dynamic>{
            'success': true,
            'userErrors': <dynamic>[],
            'verificationId': 'verify-9',
            'expiresAt': null,
          },
        },
      );

      await _repo(link).requestEmailChange('new@example.com');

      expect(
        link.sentVariables?['input'],
        containsPair('newEmail', 'new@example.com'),
      );
    });

    test('userErrors는 실패로 올라온다', () async {
      final _FakeLink link = _FakeLink(
        data: <String, dynamic>{
          'changeEmail': <String, dynamic>{
            'success': false,
            'userErrors': _oneUserError(),
            'verificationId': null,
            'expiresAt': null,
          },
        },
      );

      await expectLater(
        _repo(link).requestEmailChange('taken@example.com'),
        throwsA(isA<SettingsFailure>()),
      );
    });

    // GraphQL은 실패해도 HTTP 200을 준다 — errors 배열이 유일한 신호다.
    test('errors 배열이 차 있으면 실패다', () async {
      final _FakeLink link = _FakeLink(
        errors: <GraphQLError>[const GraphQLError(message: 'boom')],
      );

      await expectLater(
        _repo(link).requestEmailChange('new@example.com'),
        throwsA(isA<SettingsFailure>()),
      );
    });
  });

  group('confirmEmailChange (R8)', () {
    test('성공하면 확정된 이메일이 실려 온다', () async {
      final _FakeLink link = _FakeLink(
        data: <String, dynamic>{
          'confirmEmailChange': <String, dynamic>{
            'success': true,
            'userErrors': <dynamic>[],
            'email': 'new@example.com',
            'failureReason': null,
          },
        },
      );

      final EmailChangeConfirmation result = await _repo(
        link,
      ).confirmEmailChange(verificationId: 'v1', code: '123456');

      expect(result.succeeded, isTrue);
      expect(result.email, 'new@example.com');
    });

    // 검증 판정은 **예외가 아니라 값**이다 — 사유마다 다음 행동이 달라서다.
    test('failureReason은 예외가 아니라 값으로 온다', () async {
      final _FakeLink link = _FakeLink(
        data: <String, dynamic>{
          'confirmEmailChange': <String, dynamic>{
            'success': false,
            'userErrors': <dynamic>[],
            'email': null,
            'failureReason': 'CODE_MISMATCH',
          },
        },
      );

      final EmailChangeConfirmation result = await _repo(
        link,
      ).confirmEmailChange(verificationId: 'v1', code: '000000');

      expect(result.succeeded, isFalse);
      expect(result.reason, EmailChangeFailureReason.codeMismatch);
    });

    test('모르는 failureReason은 unknown으로 흡수한다', () async {
      final _FakeLink link = _FakeLink(
        data: <String, dynamic>{
          'confirmEmailChange': <String, dynamic>{
            'success': false,
            'userErrors': <dynamic>[],
            'email': null,
            'failureReason': 'SOMETHING_THE_APP_DOES_NOT_KNOW',
          },
        },
      );

      final EmailChangeConfirmation result = await _repo(
        link,
      ).confirmEmailChange(verificationId: 'v1', code: '000000');

      expect(result.reason, EmailChangeFailureReason.unknown);
    });

    test('userErrors는 검증 판정과 달리 실패로 던진다', () async {
      final _FakeLink link = _FakeLink(
        data: <String, dynamic>{
          'confirmEmailChange': <String, dynamic>{
            'success': false,
            'userErrors': _oneUserError(code: 'UNAUTHENTICATED'),
            'email': null,
            'failureReason': null,
          },
        },
      );

      await expectLater(
        _repo(link).confirmEmailChange(verificationId: 'v1', code: '123456'),
        throwsA(isA<SettingsFailure>()),
      );
    });

    test('errors 배열이 차 있으면 실패다', () async {
      final _FakeLink link = _FakeLink(
        errors: <GraphQLError>[const GraphQLError(message: 'boom')],
      );

      await expectLater(
        _repo(link).confirmEmailChange(verificationId: 'v1', code: '123456'),
        throwsA(isA<SettingsFailure>()),
      );
    });
  });

  group('resendEmailChange (R8)', () {
    // 서버가 새 손잡이를 줄 수 있다 — 옛 id로 다음 검증을 보내면 실패한다.
    test('서버가 준 새 verificationId를 돌려준다', () async {
      final _FakeLink link = _FakeLink(
        data: <String, dynamic>{
          'resendEmailChange': <String, dynamic>{
            'success': true,
            'userErrors': <dynamic>[],
            'verificationId': 'verify-renewed',
            'expiresAt': null,
          },
        },
      );

      final EmailChangeRequest result = await _repo(
        link,
      ).resendEmailChange('verify-old');

      expect(result.verificationId, 'verify-renewed');
    });

    test('쿨다운 거절은 코드를 실은 실패로 올라온다', () async {
      final _FakeLink link = _FakeLink(
        data: <String, dynamic>{
          'resendEmailChange': <String, dynamic>{
            'success': false,
            'userErrors': _oneUserError(code: 'RESEND_COOLDOWN_ACTIVE'),
            'verificationId': null,
            'expiresAt': null,
          },
        },
      );

      await expectLater(
        _repo(link).resendEmailChange('v1'),
        throwsA(
          isA<SettingsFailure>().having(
            (SettingsFailure f) => f.code,
            'code',
            'RESEND_COOLDOWN_ACTIVE',
          ),
        ),
      );
    });

    test('errors 배열이 차 있으면 실패다', () async {
      final _FakeLink link = _FakeLink(
        errors: <GraphQLError>[const GraphQLError(message: 'boom')],
      );

      await expectLater(
        _repo(link).resendEmailChange('v1'),
        throwsA(isA<SettingsFailure>()),
      );
    });
  });
}
