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

  /// 마지막 요청이 실어 보낸 변수. 요청이 어떻게 구성됐는지 검증할 때 쓴다.
  Map<String, dynamic>? lastVariables;

  /// 마지막 요청 변수의 `input` 맵(없으면 null).
  Map<String, dynamic>? get lastInput {
    final input = lastVariables?['input'];
    return input is Map<String, dynamic> ? input : null;
  }

  @override
  Stream<Response> request(Request request, [NextLink? forward]) async* {
    lastVariables = request.variables;
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

  test('loginSns puts the authorization code in the request input', () async {
    final _FakeLink link = _FakeLink(
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
    );

    await _repo(link).loginSns(
      provider: SnsProvider.google,
      idToken: 'id-token',
      authorizationCode: 'server-auth-code',
    );

    expect(link.lastInput?['authorizationCode'], 'server-auth-code');
    expect(link.lastInput?['idToken'], 'id-token');
  });

  test('loginSns leaves authorizationCode empty when there is none', () async {
    final _FakeLink link = _FakeLink(
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
    );

    // 카카오처럼 code를 주지 않는 provider — 요청은 그대로 나가고 필드만
    // 비어 있다(R4·R7). 값이 없다는 것과 요청이 막히는 것은 다르다.
    await _repo(
      link,
    ).loginSns(provider: SnsProvider.kakao, idToken: 'id-token');

    expect(link.lastInput?['authorizationCode'], isNull);
    expect(link.lastInput?['idToken'], 'id-token');
  });

  test(
    'registerSnsMember puts the authorization code in the request input',
    () async {
      final _FakeLink link = _FakeLink(
        data: <String, dynamic>{
          'registerSnsMember': <String, dynamic>{
            'success': true,
            'userErrors': <dynamic>[],
            'emailVerified': true,
            'verificationId': null,
          },
        },
      );

      final SnsRegistrationResult result = await _repo(link).registerSnsMember(
        provider: SnsProvider.apple,
        idToken: 'id-token',
        email: 'a@b.com',
        ageVerified: true,
        agreements: const [],
        authorizationCode: 'apple-code',
      );

      expect(result.emailVerified, isTrue);
      expect(link.lastInput?['authorizationCode'], 'apple-code');
      expect(link.lastInput?['email'], 'a@b.com');
    },
  );

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

  // 회원 탈퇴(SPEC-0011 R16). 로그아웃과 달리 실패를 삼키지 않는 경로라, 실패가
  // 실제로 올라오는지가 이 오퍼레이션에서 가장 중요하다 — 서버에서 안 지워졌는데
  // 성공으로 읽히면 사용자는 계정이 사라진 줄 안다.
  test('withdrawMember completes when success is true', () async {
    final AuthRepositoryImpl repo = _repo(
      _FakeLink(
        data: <String, dynamic>{
          'withdrawMember': <String, dynamic>{
            'success': true,
            'userErrors': <dynamic>[],
          },
        },
      ),
    );

    await expectLater(repo.withdrawMember(), completes);
  });

  test('withdrawMember surfaces a userError as an AuthFailure', () async {
    final AuthRepositoryImpl repo = _repo(
      _FakeLink(
        data: <String, dynamic>{
          'withdrawMember': <String, dynamic>{
            'success': false,
            'userErrors': _oneUserError(code: 'UNAUTHORIZED'),
          },
        },
      ),
    );

    await expectLater(repo.withdrawMember(), throwsA(isA<AuthFailure>()));
  });

  test('withdrawMember treats a populated errors array as failure', () async {
    // GraphQL은 실패해도 HTTP 200을 준다 — `errors` 배열이 차 있으면 실패다
    // (CLAUDE.md §4). 탈퇴에서 이걸 놓치면 성공으로 읽힌다.
    final AuthRepositoryImpl repo = _repo(
      _FakeLink(errors: <GraphQLError>[const GraphQLError(message: 'boom')]),
    );

    await expectLater(repo.withdrawMember(), throwsA(isA<AuthFailure>()));
  });
}
