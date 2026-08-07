import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:ieuri_k_trip_spot/common/model/terms_code.dart';
import 'package:ieuri_k_trip_spot/domain/settings/model/agreement_status.dart';
import 'package:ieuri_k_trip_spot/domain/settings/model/settings_failure.dart';
import 'package:ieuri_k_trip_spot/domain/settings/repository/settings_repository_impl.dart';

/// 캔드 응답 하나만 돌려주는 링크. 실제 네트워크 없이 repository의 매핑과 실패 판정을
/// 돌린다(auth repository 테스트와 같은 방식).
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

SettingsRepositoryImpl _repo(_FakeLink link) => SettingsRepositoryImpl(
  GraphQLClient(
    link: link,
    cache: GraphQLCache(),
    // 운영 클라이언트(common/network)와 같이 캐시·정규화를 끈다 — 캔드 데이터가
    // `__typename`을 들고 있지 않아도 된다.
    defaultPolicies: DefaultPolicies(
      mutate: Policies(fetch: FetchPolicy.noCache),
      query: Policies(fetch: FetchPolicy.noCache),
    ),
  ),
);

Map<String, dynamic> _status({
  String termsCode = 'SERVICE',
  bool required = true,
  bool agreed = true,
  String? agreedAt = '2026-01-12',
  String version = 'v1',
}) => <String, dynamic>{
  'termsCode': termsCode,
  'required': required,
  'agreed': agreed,
  'agreedAt': agreedAt,
  'version': version,
};

void main() {
  test('agreements가 AgreementStatus 목록으로 매핑된다', () async {
    final SettingsRepositoryImpl repo = _repo(
      _FakeLink(
        data: <String, dynamic>{
          'agreements': <dynamic>[
            _status(),
            _status(
              termsCode: 'MARKETING',
              required: false,
              agreed: false,
              agreedAt: null,
            ),
          ],
        },
      ),
    );

    final List<AgreementStatus> result = await repo.fetchAgreements();

    expect(result, hasLength(2));
    expect(result.first.termsCode, TermsCode.service);
    expect(result.first.required, isTrue);
    expect(result.first.agreedAt, '2026-01-12');
    expect(result.last.termsCode, TermsCode.marketing);
    expect(result.last.agreed, isFalse);
  });

  test('errors 배열이 채워져 오면 성공이 아니라 실패다', () async {
    // GraphQL은 실패해도 HTTP 200이라, 최상위 errors를 보지 않으면 통과해 버린다.
    final SettingsRepositoryImpl repo = _repo(
      _FakeLink(
        data: null,
        errors: <GraphQLError>[const GraphQLError(message: 'boom')],
      ),
    );

    await expectLater(repo.fetchAgreements(), throwsA(isA<SettingsFailure>()));
  });

  test('최상위 UNAUTHENTICATED는 인증 실패로 분류된다', () async {
    final SettingsRepositoryImpl repo = _repo(
      _FakeLink(
        data: null,
        errors: <GraphQLError>[
          const GraphQLError(
            message: 'nope',
            extensions: <String, dynamic>{'code': 'UNAUTHENTICATED'},
          ),
        ],
      ),
    );

    await expectLater(
      repo.fetchAgreements(),
      throwsA(
        isA<SettingsFailure>().having(
          (SettingsFailure f) => f.kind,
          'kind',
          SettingsFailureKind.unauthenticated,
        ),
      ),
    );
  });

  test('updateAgreement가 갱신된 항목을 돌려준다', () async {
    final SettingsRepositoryImpl repo = _repo(
      _FakeLink(
        data: <String, dynamic>{
          'updateAgreement': <String, dynamic>{
            'success': true,
            'userErrors': <dynamic>[],
            'agreement': _status(
              termsCode: 'LOCATION',
              required: false,
              agreed: true,
            ),
          },
        },
      ),
    );

    final AgreementStatus? updated = await repo.updateAgreement(
      termsCode: TermsCode.location,
      agreed: true,
    );

    expect(updated?.termsCode, TermsCode.location);
    expect(updated?.agreed, isTrue);
  });

  test('updateAgreement의 userErrors는 도메인 실패로 올라온다', () async {
    final SettingsRepositoryImpl repo = _repo(
      _FakeLink(
        data: <String, dynamic>{
          'updateAgreement': <String, dynamic>{
            'success': false,
            'userErrors': <dynamic>[
              <String, dynamic>{
                'code': 'TERMS_NOT_WITHDRAWABLE',
                'message': 'x',
                'field': 'termsCode',
              },
            ],
            'agreement': null,
          },
        },
      ),
    );

    await expectLater(
      repo.updateAgreement(termsCode: TermsCode.location, agreed: false),
      throwsA(
        isA<SettingsFailure>().having(
          (SettingsFailure f) => f.code,
          'code',
          'TERMS_NOT_WITHDRAWABLE',
        ),
      ),
    );
  });

  test('agreeToRequiredTerms가 전체 상태를 돌려준다', () async {
    // 재조회 없이 게이트가 풀리는 근거다(R12 첫 기준).
    final SettingsRepositoryImpl repo = _repo(
      _FakeLink(
        data: <String, dynamic>{
          'agreeToRequiredTerms': <String, dynamic>{
            'success': true,
            'userErrors': <dynamic>[],
            'agreements': <dynamic>[_status(), _status(termsCode: 'PRIVACY')],
          },
        },
      ),
    );

    final List<AgreementStatus> result = await repo.agreeToRequiredTerms(
      <TermsCode>[TermsCode.service, TermsCode.privacy],
    );

    expect(result.map((AgreementStatus a) => a.termsCode), <TermsCode>[
      TermsCode.service,
      TermsCode.privacy,
    ]);
    expect(result.requiredSatisfied, isTrue);
  });

  test('링크가 던지면 네트워크 실패다', () async {
    final SettingsRepositoryImpl repo = _repo(
      _FakeLink(throwLinkException: true),
    );

    await expectLater(
      repo.fetchAgreements(),
      throwsA(
        isA<SettingsFailure>().having(
          (SettingsFailure f) => f.kind,
          'kind',
          SettingsFailureKind.network,
        ),
      ),
    );
  });
}
