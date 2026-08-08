import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:ieuri_k_trip_spot/common/network/graphql_client.dart';
import 'package:ieuri_k_trip_spot/common/storage/secure_storage.dart';

import '../../domain/auth/auth_test_doubles.dart';

/// 앱이 만드는 클라이언트가 느린 응답을 끊지 않는지 확인한다.
///
/// graphql_flutter의 `queryRequestTimeout` 기본값은 **5초**다. 이 시한은 링크
/// 체인 바깥에 있어 HttpLink에 더 긴 시한을 걸어도 먼저 발동한다. 5초는 회원가입·
/// 인증 코드 발송처럼 서버가 외부를 거치는 요청에 짧아, 정상 처리 중인 요청이
/// "네트워크 오류"로 실패했다(실기기에서 관측).
void main() {
  test('앱 클라이언트는 8초 걸리는 응답을 끊지 않는다', () async {
    final HttpServer server = await HttpServer.bind(
      InternetAddress.loopbackIPv4,
      0,
    );
    server.listen((HttpRequest req) async {
      await Future<void>.delayed(const Duration(seconds: 8));
      req.response
        ..headers.contentType = ContentType.json
        ..write(
          jsonEncode(<String, dynamic>{
            'data': <String, dynamic>{'__typename': 'Query'},
          }),
        );
      await req.response.close();
    });
    addTearDown(() => server.close(force: true));

    final ProviderContainer container = ProviderContainer(
      overrides: [
        secureStorageProvider.overrideWithValue(SecureStorage(MemoryStore())),
      ],
    );
    addTearDown(container.dispose);

    // 앱의 provider가 조립한 그대로의 클라이언트에서 링크만 이 서버로 돌린다 —
    // 검증 대상은 엔드포인트가 아니라 시한 설정이다.
    final GraphQLClient app = container.read(graphqlClientProvider);
    final GraphQLClient probe = app.copyWith(
      link: HttpLink('http://127.0.0.1:${server.port}/graphql'),
    );

    final QueryResult<Object?> result = await probe.query(
      QueryOptions(document: gql('query P { __typename }')),
    );

    // 5초 기본값이 살아 있으면 여기서 linkException(TimeoutException)이 잡힌다.
    expect(result.exception?.linkException, isNull);
    expect(result.data?['__typename'], 'Query');
  }, timeout: const Timeout(Duration(seconds: 60)));
}
