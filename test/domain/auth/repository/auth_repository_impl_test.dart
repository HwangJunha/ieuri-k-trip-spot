import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:ieuri_k_trip_spot/domain/auth/model/auth_failure.dart';
import 'package:ieuri_k_trip_spot/domain/auth/model/auth_session.dart';
import 'package:ieuri_k_trip_spot/domain/auth/model/email_verification_handle.dart';
import 'package:ieuri_k_trip_spot/domain/auth/model/me.dart';
import 'package:ieuri_k_trip_spot/domain/auth/model/sns_provider.dart';
import 'package:ieuri_k_trip_spot/domain/auth/model/sns_registration_result.dart';
import 'package:ieuri_k_trip_spot/domain/auth/repository/auth_repository_impl.dart';

/// A link that returns one canned [Response] (or throws a link exception),
/// standing in for the real network so the repository's mapping is exercised
/// without a server.
class _FakeLink extends Link {
  _FakeLink({this.data, this.errors, this.throwLinkException = false});

  final Map<String, dynamic>? data;
  final List<GraphQLError>? errors;
  final bool throwLinkException;

  @override
  Stream<Response> request(Request request, [NextLink? forward]) async* {
    if (throwLinkException) {
      throw const ServerException(originalException: 'down');
    }
    yield Response(
      data: data,
      errors: errors,
      response: const <String, dynamic>{},
      context: const Context(),
    );
  }
}

AuthRepositoryImpl _repo(_FakeLink link) => AuthRepositoryImpl(
  GraphQLClient(
    link: link,
    cache: GraphQLCache(),
    // Mirror the production client (common/network): no cache/normalization,
    // so canned test data need not carry `__typename`.
    defaultPolicies: DefaultPolicies(
      mutate: Policies(fetch: FetchPolicy.noCache),
      query: Policies(fetch: FetchPolicy.noCache),
    ),
  ),
);

List<dynamic> _oneUserError({String code = 'EMAIL_TAKEN'}) => <dynamic>[
  <String, dynamic>{'code': code, 'message': 'x', 'field': 'email'},
];

void main() {
  test('registerEmailMember returns a verificationId and no tokens', () async {
    final AuthRepositoryImpl repo = _repo(
      _FakeLink(
        data: <String, dynamic>{
          'registerEmailMember': <String, dynamic>{
            'success': true,
            'userErrors': <dynamic>[],
            'verificationId': 'verify-42',
          },
        },
      ),
    );

    final EmailVerificationHandle handle = await repo.registerEmailMember(
      email: 'a@b.com',
      password: 'pw',
      ageVerified: true,
      agreements: const [],
    );

    expect(handle.verificationId, 'verify-42');
  });

  test(
    'loginEmail maps AuthTokenPayload to an AuthSession with expiries',
    () async {
      final AuthRepositoryImpl repo = _repo(
        _FakeLink(
          data: <String, dynamic>{
            'loginEmail': <String, dynamic>{
              'success': true,
              'userErrors': <dynamic>[],
              'accessToken': 'access',
              'refreshToken': 'refresh',
              'tokenType': 'Bearer',
              'accessTokenExpiresIn': 300,
              'refreshTokenExpiresIn': 2592000,
            },
          },
        ),
      );

      final AuthSession session = await repo.loginEmail(
        email: 'a@b.com',
        password: 'pw',
      );

      expect(session.accessToken, 'access');
      expect(session.refreshToken, 'refresh');
      expect(session.tokenType, 'Bearer');
      expect(session.accessTokenExpiresIn, 300);
      expect(session.refreshTokenExpiresIn, 2592000);
      expect(session.user, isNull); // login carries no user (spec §4.2).
    },
  );

  test('fetchMe maps the me query to a Me model', () async {
    final AuthRepositoryImpl repo = _repo(
      _FakeLink(
        data: <String, dynamic>{
          'me': <String, dynamic>{
            'id': '7',
            'email': 'a@b.com',
            'nickname': 'Traveler',
            'profileImageUrl': null,
            'status': 'ACTIVE',
            'emailVerified': true,
            'roles': <dynamic>['USER'],
            'permissions': <dynamic>[],
            'createdAt': '2026-01-01',
          },
        },
      ),
    );

    final Me me = await repo.fetchMe();

    expect(me.id, '7');
    expect(me.nickname, 'Traveler');
    expect(me.status, MemberStatus.active);
  });

  test('verifyEmail succeeds when verified is true', () async {
    final AuthRepositoryImpl repo = _repo(
      _FakeLink(
        data: <String, dynamic>{
          'verifyEmail': <String, dynamic>{
            'success': true,
            'userErrors': <dynamic>[],
            'verified': true,
            'failureReason': null,
          },
        },
      ),
    );

    await expectLater(
      repo.verifyEmail(verificationId: 'v', code: '123456'),
      completes,
    );
  });

  test('verifyEmail fails when verified is false', () async {
    final AuthRepositoryImpl repo = _repo(
      _FakeLink(
        data: <String, dynamic>{
          'verifyEmail': <String, dynamic>{
            'success': true,
            'userErrors': <dynamic>[],
            'verified': false,
            'failureReason': 'expired',
          },
        },
      ),
    );

    await expectLater(
      repo.verifyEmail(verificationId: 'v', code: 'bad'),
      throwsA(isA<AuthFailure>()),
    );
  });

  test('a non-empty userErrors list surfaces as an AuthFailure', () async {
    final AuthRepositoryImpl repo = _repo(
      _FakeLink(
        data: <String, dynamic>{
          'registerEmailMember': <String, dynamic>{
            'success': false,
            'userErrors': _oneUserError(),
            'verificationId': null,
          },
        },
      ),
    );

    await expectLater(
      repo.registerEmailMember(
        email: 'a@b.com',
        password: 'pw',
        ageVerified: true,
        agreements: const [],
      ),
      throwsA(
        isA<AuthFailure>().having(
          (AuthFailure f) => f.kind,
          'kind',
          AuthFailureKind.emailAlreadyInUse,
        ),
      ),
    );
  });

  test('success=false with empty userErrors still fails', () async {
    final AuthRepositoryImpl repo = _repo(
      _FakeLink(
        data: <String, dynamic>{
          'loginEmail': <String, dynamic>{
            'success': false,
            'userErrors': <dynamic>[],
            'accessToken': null,
            'refreshToken': null,
            'tokenType': null,
            'accessTokenExpiresIn': null,
            'refreshTokenExpiresIn': null,
          },
        },
      ),
    );

    await expectLater(
      repo.loginEmail(email: 'a@b.com', password: 'pw'),
      throwsA(isA<AuthFailure>()),
    );
  });

  test(
    'an unrecognized top-level errors array surfaces as a transport failure',
    () async {
      final AuthRepositoryImpl repo = _repo(
        _FakeLink(errors: const <GraphQLError>[GraphQLError(message: 'boom')]),
      );

      await expectLater(
        repo.loginEmail(email: 'a@b.com', password: 'pw'),
        throwsA(
          isA<AuthFailure>().having(
            (AuthFailure f) => f.kind,
            'kind',
            AuthFailureKind.transportFailure,
          ),
        ),
      );
    },
  );

  test('a link exception surfaces as a transport failure', () async {
    final AuthRepositoryImpl repo = _repo(_FakeLink(throwLinkException: true));

    await expectLater(
      repo.loginEmail(email: 'a@b.com', password: 'pw'),
      throwsA(
        isA<AuthFailure>().having(
          (AuthFailure f) => f.kind,
          'kind',
          AuthFailureKind.transportFailure,
        ),
      ),
    );
  });

  // 갱신 거부(E3·E4)와 전송 실패(E5)가 repository 계층에서 다른 값으로 나와야 R9와
  // R10이 서로 다르게 처리될 수 있다(SPEC-0005 §2.2, AC-25·AC-27).
  test(
    'a rejected refresh token surfaces as a refreshRejected failure',
    () async {
      final AuthRepositoryImpl repo = _repo(
        _FakeLink(
          errors: const <GraphQLError>[
            GraphQLError(
              message:
                  'org.around.ieuri.common.security.TokenReuseDetectedException: reused',
            ),
          ],
        ),
      );

      await expectLater(
        repo.loginEmail(email: 'a@b.com', password: 'pw'),
        throwsA(
          isA<AuthFailure>().having(
            (AuthFailure f) => f.kind,
            'kind',
            AuthFailureKind.refreshRejected,
          ),
        ),
      );
    },
  );

  test('loginSns maps AuthTokenPayload to an AuthSession', () async {
    final AuthRepositoryImpl repo = _repo(
      _FakeLink(
        data: <String, dynamic>{
          'loginSns': <String, dynamic>{
            'success': true,
            'userErrors': <dynamic>[],
            'accessToken': 'access',
            'refreshToken': 'refresh',
            'tokenType': 'Bearer',
            'accessTokenExpiresIn': 300,
            'refreshTokenExpiresIn': 2592000,
          },
        },
      ),
    );

    final AuthSession session = await repo.loginSns(
      provider: SnsProvider.google,
      idToken: 'id-token',
    );

    expect(session.accessToken, 'access');
    expect(session.refreshToken, 'refresh');
    expect(session.accessTokenExpiresIn, 300);
  });

  test('loginSns for an unregistered identity is a memberNotFound failure', () {
    final AuthRepositoryImpl repo = _repo(
      _FakeLink(
        data: <String, dynamic>{
          'loginSns': <String, dynamic>{
            'success': false,
            'userErrors': _oneUserError(code: 'MEMBER_NOT_FOUND'),
            'accessToken': null,
            'refreshToken': null,
            'tokenType': null,
            'accessTokenExpiresIn': null,
            'refreshTokenExpiresIn': null,
          },
        },
      ),
    );

    expect(
      repo.loginSns(provider: SnsProvider.google, idToken: 'id-token'),
      throwsA(
        isA<AuthFailure>().having(
          (AuthFailure f) => f.kind,
          'kind',
          AuthFailureKind.memberNotFound,
        ),
      ),
    );
  });

  test(
    'registerSnsMember maps an already-verified payload (no verificationId)',
    () async {
      final AuthRepositoryImpl repo = _repo(
        _FakeLink(
          data: <String, dynamic>{
            'registerSnsMember': <String, dynamic>{
              'success': true,
              'userErrors': <dynamic>[],
              'emailVerified': true,
              'verificationId': null,
            },
          },
        ),
      );

      final SnsRegistrationResult result = await repo.registerSnsMember(
        provider: SnsProvider.kakao,
        idToken: 'id-token',
        email: 'a@b.com',
        ageVerified: true,
        agreements: const [],
      );

      expect(result.emailVerified, isTrue);
      expect(result.needsVerification, isFalse);
    },
  );

  test('registerSnsMember maps an unverified payload with a handle', () async {
    final AuthRepositoryImpl repo = _repo(
      _FakeLink(
        data: <String, dynamic>{
          'registerSnsMember': <String, dynamic>{
            'success': true,
            'userErrors': <dynamic>[],
            'emailVerified': false,
            'verificationId': 'verify-9',
          },
        },
      ),
    );

    final SnsRegistrationResult result = await repo.registerSnsMember(
      provider: SnsProvider.apple,
      idToken: 'id-token',
      email: 'edited@b.com',
      ageVerified: true,
      agreements: const [],
    );

    expect(result.needsVerification, isTrue);
    expect(result.verificationId, 'verify-9');
  });
}
