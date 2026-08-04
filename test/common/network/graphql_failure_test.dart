import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:ieuri_k_trip_spot/common/network/graphql_failure.dart';

/// `errors[].path`로 실패 범위를 판별한다(SPEC-0008 §2.1, AC-25).
///
/// 이 판별이 R-7 전체를 떠받친다 — 부분 실패를 전체 실패로 오판하면 갤러리 하나
/// 실패에 상세 화면이 통째로 오류가 된다.
///
/// 주의: DGS가 중첩 필드 실패에 실제로 `["spotDetail","gallery"]` 형태를 내려주는지는
/// 여기서 검증되지 않는다(§8 `[TBD-3]`) — 실제 응답 육안 확인이 필요한 가정이다.
QueryResult<Object?> _result({
  List<GraphQLError>? errors,
  bool linkException = false,
}) => QueryResult<Object?>(
  source: QueryResultSource.network,
  data: const <String, dynamic>{},
  exception: (errors == null && !linkException)
      ? null
      : OperationException(
          linkException: linkException
              ? const ServerException(originalException: 'down')
              : null,
          graphqlErrors: errors ?? const <GraphQLError>[],
        ),
  options: QueryOptions<Object?>(document: gql('query { a }')),
);

void main() {
  test('예외가 없으면 실패가 아니다', () {
    expect(hasRootFailure(_result(), 'spotDetail'), isFalse);
  });

  test('링크 예외는 항상 전체 실패다', () {
    // 응답 자체를 못 받았으므로 범위를 따질 것이 없다.
    expect(hasRootFailure(_result(linkException: true), 'spotDetail'), isTrue);
  });

  test('path가 최상위 필드 한 칸이면 전체 실패다', () {
    final QueryResult<Object?> result = _result(
      errors: const <GraphQLError>[
        GraphQLError(message: 'boom', path: <dynamic>['spotDetail']),
      ],
    );

    expect(hasRootFailure(result, 'spotDetail'), isTrue);
  });

  test('path가 하위 필드까지 내려가면 부분 실패다', () {
    // 갤러리만 실패했고 본문은 정상이므로 오류 화면을 띄우면 안 된다.
    final QueryResult<Object?> result = _result(
      errors: const <GraphQLError>[
        GraphQLError(message: 'boom', path: <dynamic>['spotDetail', 'gallery']),
      ],
    );

    expect(hasRootFailure(result, 'spotDetail'), isFalse);
  });

  test('path가 없으면 안전한 쪽(전체 실패)으로 본다', () {
    final QueryResult<Object?> result = _result(
      errors: const <GraphQLError>[GraphQLError(message: 'boom')],
    );

    expect(hasRootFailure(result, 'spotDetail'), isTrue);
  });

  test('다른 최상위 필드를 가리키는 오류는 무시한다', () {
    final QueryResult<Object?> result = _result(
      errors: const <GraphQLError>[
        GraphQLError(message: 'boom', path: <dynamic>['somethingElse']),
      ],
    );

    expect(hasRootFailure(result, 'spotDetail'), isFalse);
  });

  test('부분 실패와 전체 실패가 섞이면 전체 실패다', () {
    final QueryResult<Object?> result = _result(
      errors: const <GraphQLError>[
        GraphQLError(
          message: 'partial',
          path: <dynamic>['spotDetail', 'gallery'],
        ),
        GraphQLError(message: 'total', path: <dynamic>['spotDetail']),
      ],
    );

    expect(hasRootFailure(result, 'spotDetail'), isTrue);
  });
}
