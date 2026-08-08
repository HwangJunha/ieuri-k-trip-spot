import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:ieuri_k_trip_spot/common/network/graphql_client.dart';

/// 응답을 [delay] 뒤에 주는 가짜 클라이언트. [delay]가 null이면 영원히 답하지
/// 않는다(서버가 조용히 멎은 상황).
class _SlowClient extends http.BaseClient {
  _SlowClient({this.delay});

  final Duration? delay;
  bool closed = false;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    if (delay == null) return Completer<http.StreamedResponse>().future;
    return Future<http.StreamedResponse>.delayed(
      delay!,
      () => http.StreamedResponse(const Stream<List<int>>.empty(), 200),
    );
  }

  @override
  void close() => closed = true;
}

http.BaseRequest _request() =>
    http.Request('POST', Uri.parse('http://localhost:8888/graphql'));

void main() {
  test('시한 안에 답하면 응답을 그대로 넘긴다', () async {
    final http.Client client = buildTimeoutHttpClient(
      inner: _SlowClient(delay: const Duration(milliseconds: 5)),
      timeout: const Duration(seconds: 2),
    );

    final http.StreamedResponse response = await client.send(_request());

    expect(response.statusCode, 200);
  });

  test('응답이 없으면 시한이 지나 끊는다', () async {
    // 끊지 않으면 화면이 로딩 스피너에 갇힌 채 사용자가 할 수 있는 일이 없다.
    final http.Client client = buildTimeoutHttpClient(
      inner: _SlowClient(),
      timeout: const Duration(milliseconds: 20),
    );

    expect(client.send(_request()), throwsA(isA<TimeoutException>()));
  });

  test('close는 감싼 클라이언트까지 닫는다', () {
    final _SlowClient inner = _SlowClient();
    buildTimeoutHttpClient(
      inner: inner,
      timeout: const Duration(seconds: 1),
    ).close();

    expect(inner.closed, isTrue);
  });
}
