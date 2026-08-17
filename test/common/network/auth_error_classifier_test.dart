import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:ieuri_k_trip_spot/common/network/auth_error_classifier.dart';

/// 판별 함수 단위 테스트(SPEC-0005 §4, AC-14~AC-17). 서버를 띄우지 않고 응답 형태를
/// 직접 만들어 검증한다.
void main() {
  GraphQLError error(String message, {Map<String, dynamic>? extensions}) =>
      GraphQLError(message: message, extensions: extensions);

  group('errorType 우선 판별 (E2, AC-15)', () {
    test('errorType이 UNAUTHENTICATED면 message를 보지 않고 확정한다', () {
      // message에 아무 단서가 없어도 errorType만으로 확정되어야 한다.
      expect(
        classifyGraphqlErrors(<GraphQLError>[
          error(
            'nothing recognizable here',
            extensions: <String, dynamic>{'errorType': 'UNAUTHENTICATED'},
          ),
        ]),
        AuthErrorClass.unauthenticated,
      );
    });

    test('errorType이 UNAUTHENTICATED면 갱신 거부 마커가 있어도 인증 실패로 본다', () {
      expect(
        classifyGraphqlErrors(<GraphQLError>[
          error(
            'TokenReuseDetectedException',
            extensions: <String, dynamic>{'errorType': 'UNAUTHENTICATED'},
          ),
        ]),
        AuthErrorClass.unauthenticated,
      );
    });
  });

  group('INTERNAL + message 매칭 (E1·E3·E4, AC-14)', () {
    test('UnauthorizedException은 인증 실패로 분류된다', () {
      expect(
        classifyGraphqlErrors(<GraphQLError>[
          error(
            'org.around.ieuri.common.security.UnauthorizedException: bad token',
            extensions: <String, dynamic>{'errorType': 'INTERNAL'},
          ),
        ]),
        AuthErrorClass.unauthenticated,
      );
    });

    test('TokenReuseDetectedException은 갱신 거부로 분류된다', () {
      expect(
        classifyGraphqlErrors(<GraphQLError>[
          error(
            'org.around.ieuri.auth.TokenReuseDetectedException: reused jti',
            extensions: <String, dynamic>{'errorType': 'INTERNAL'},
          ),
        ]),
        AuthErrorClass.refreshRejected,
      );
    });

    test('알아볼 수 없는 INTERNAL 오류는 인증 실패로 분류되지 않는다', () {
      expect(
        classifyGraphqlErrors(<GraphQLError>[
          error(
            'NullPointerException',
            extensions: <String, dynamic>{'errorType': 'INTERNAL'},
          ),
        ]),
        AuthErrorClass.none,
      );
    });
  });

  group('null 안전성 (AC-17)', () {
    test('extensions가 없어도 예외가 나지 않는다', () {
      expect(
        classifyGraphqlErrors(<GraphQLError>[error('UnauthorizedException')]),
        AuthErrorClass.unauthenticated,
      );
    });

    test('errorType이 없어도 예외가 나지 않는다', () {
      expect(
        classifyGraphqlErrors(<GraphQLError>[
          error('boom', extensions: <String, dynamic>{'other': 1}),
        ]),
        AuthErrorClass.none,
      );
    });

    test('errorType이 문자열이 아니어도 예외가 나지 않는다', () {
      expect(
        classifyGraphqlErrors(<GraphQLError>[
          error(
            'UnauthorizedException',
            extensions: <String, dynamic>{'errorType': 42},
          ),
        ]),
        AuthErrorClass.unauthenticated,
      );
    });

    test('빈 오류 목록은 실패가 아니다', () {
      expect(
        classifyGraphqlErrors(const <GraphQLError>[]),
        AuthErrorClass.none,
      );
    });
  });

  group('QueryResult 분류 (E5)', () {
    QueryResult<Object?> resultWith(OperationException? exception) =>
        QueryResult<Object?>(
          options: QueryOptions<Object?>(document: gql('{ a }')),
          source: QueryResultSource.network,
          exception: exception,
        );

    test('errors 없이 linkException만 있으면 전송 실패다', () {
      expect(
        classifyQueryResult(
          resultWith(
            OperationException(
              linkException: ServerException(
                originalException: Exception('connection refused'),
                parsedResponse: null,
              ),
            ),
          ),
        ),
        AuthErrorClass.transport,
      );
    });

    test('인증과 무관한 errors는 전송 실패로 다뤄 토큰을 건드리지 않는다', () {
      expect(
        classifyQueryResult(
          resultWith(
            OperationException(
              graphqlErrors: <GraphQLError>[error('Cannot query field X')],
            ),
          ),
        ),
        AuthErrorClass.transport,
      );
    });

    test('갱신 거부는 전송 실패와 구분된다', () {
      expect(
        classifyQueryResult(
          resultWith(
            OperationException(
              graphqlErrors: <GraphQLError>[
                error('TokenReuseDetectedException'),
              ],
            ),
          ),
        ),
        AuthErrorClass.refreshRejected,
      );
    });

    test('예외가 없으면 실패가 아니다', () {
      expect(classifyQueryResult(resultWith(null)), AuthErrorClass.none);
    });
  });

  group('최상위 오류 코드 5종 (SPEC-0024 §6)', () {
    AuthErrorClass byCode(String code) =>
        classifyGraphqlErrors(<GraphQLError>[
          error('irrelevant', extensions: <String, dynamic>{'code': code}),
        ]);

    test('UNAUTHENTICATED는 인증 실패다', () {
      expect(byCode('UNAUTHENTICATED'), AuthErrorClass.unauthenticated);
    });

    test('INVALID_TOKEN은 갱신으로 회복될 수 있다', () {
      // 서명·만료·타입 불일치 — refresh를 태워야 하므로 unauthenticated다.
      expect(byCode('INVALID_TOKEN'), AuthErrorClass.unauthenticated);
    });

    test('TOKEN_REUSE_DETECTED는 INVALID_TOKEN과 다르게 분류된다', () {
      // **이 구분이 핵심이다.** 재사용 감지는 회원의 모든 refresh가 폐기된
      // 상태라 재발급으로 회복되지 않는다. 뭉개 두면 앱이 회복 불가능한 상태에서
      // 갱신을 반복한다.
      expect(byCode('TOKEN_REUSE_DETECTED'), AuthErrorClass.tokenReuseDetected);
      expect(
        byCode('TOKEN_REUSE_DETECTED'),
        isNot(AuthErrorClass.unauthenticated),
      );
    });

    test('EMAIL_NOT_VERIFIED는 인증 화면으로 보내는 신호다', () {
      // 토큰은 유효하다 — 갱신하거나 지우면 안 된다.
      expect(byCode('EMAIL_NOT_VERIFIED'), AuthErrorClass.emailNotVerified);
    });

    test('FORBIDDEN은 권한 문제로 따로 분류된다', () {
      expect(byCode('FORBIDDEN'), AuthErrorClass.forbidden);
    });

    test('모르는 코드는 아래 판별로 내려간다', () {
      // 여기서 none으로 확정하면 코드가 붙은 다른 실패까지 삼킨다.
      expect(
        classifyGraphqlErrors(<GraphQLError>[
          error(
            'UnauthorizedException',
            extensions: <String, dynamic>{'code': 'SOMETHING_ELSE'},
          ),
        ]),
        AuthErrorClass.unauthenticated,
      );
    });

    test('code가 errorType보다 우선한다', () {
      // 서버가 둘 다 실으면 정본인 code를 따른다.
      expect(
        classifyGraphqlErrors(<GraphQLError>[
          error(
            'irrelevant',
            extensions: <String, dynamic>{
              'code': 'EMAIL_NOT_VERIFIED',
              'errorType': 'UNAUTHENTICATED',
            },
          ),
        ]),
        AuthErrorClass.emailNotVerified,
      );
    });
  });
}
