import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

/// Debug-only diagnostics for GraphQL calls. In release builds every method is a
/// no-op — production must never log request/response bodies that may carry
/// tokens or PII (CLAUDE.md §7). In local/debug builds it traces each call end
/// to end — the operation + variables sent and the data/errors returned — so a
/// generic "network error" in the UI is diagnosable.
///
/// Sensitive variable values (passwords, tokens, verification/reset codes) are
/// **masked** before logging even in debug (see [_sensitiveKeys]); everything
/// else is shown as sent/received.
class GraphqlDebugLog {
  const GraphqlDebugLog._();

  /// Variable-key substrings whose values are replaced with `***` before
  /// logging, matched case-insensitively — so `newPassword`, `accessToken`,
  /// `refreshToken` are all covered.
  static const List<String> _sensitiveSubstrings = <String>[
    'password',
    'token',
    'secret',
    // OAuth authorization code (SPEC-0012). refresh token으로 교환 가능한
    // 값이라 토큰과 같은 급의 비밀이다. `authorizationCode`/`serverAuthCode`를
    // 함께 덮으면서 `termsCode`는 건드리지 않는다.
    'authorizationcode',
    'authcode',
  ];

  /// Variable keys masked by an exact (case-insensitive) match only — `code`
  /// alone is a verification/reset secret, but `termsCode` is a plain enum that
  /// must stay visible for debugging.
  static const List<String> _sensitiveExactKeys = <String>['code'];

  static bool _isSensitiveKey(String key) {
    final String k = key.toLowerCase();
    return _sensitiveExactKeys.contains(k) ||
        _sensitiveSubstrings.any((String s) => k.contains(s));
  }

  /// Logs the outgoing [operation] and its [variables] (sensitive values
  /// masked). No-op unless [kDebugMode].
  static void request(String operation, Map<String, dynamic> variables) {
    if (!kDebugMode) return;
    debugPrint(
      '[GraphQL] → $operation\n'
      '  variables: ${_encode(_mask(variables))}',
    );
  }

  /// Logs the response [result] for [operation] — the returned data and any
  /// GraphQL errors. No-op unless [kDebugMode]. Response data is not masked (the
  /// server does not echo passwords; tokens in an auth payload are the point of
  /// the call and only ever printed to a local debug console), so this stays
  /// debug-only and never runs in release.
  static void response(String operation, QueryResult<Object?> result) {
    if (!kDebugMode) return;
    final StringBuffer buffer = StringBuffer()
      ..writeln('[GraphQL] ← $operation');
    buffer.writeln('  data: ${_encode(result.data)}');
    final List<GraphQLError> errors =
        result.exception?.graphqlErrors ?? const <GraphQLError>[];
    for (final GraphQLError error in errors) {
      buffer.writeln('  graphqlError: ${error.message}');
    }
    debugPrint(buffer.toString());
  }

  /// Returns a copy of [variables] with any sensitive value replaced by `***`,
  /// recursing into nested maps/lists (e.g. `input: { password: … }`).
  static Object? _mask(Object? value) {
    if (value is Map) {
      return value.map((Object? k, Object? v) {
        final bool sensitive = k is String && _isSensitiveKey(k);
        return MapEntry<Object?, Object?>(k, sensitive ? '***' : _mask(v));
      });
    }
    if (value is List) return value.map(_mask).toList();
    return value;
  }

  static String _encode(Object? value) {
    try {
      return const JsonEncoder.withIndent('  ').convert(value);
    } on Object {
      return '$value';
    }
  }

  /// Logs a transport failure for [operation]. No-op unless [kDebugMode].
  static void transportFailure(
    String operation,
    QueryResult<Object?> result, {
    String? endpoint,
  }) {
    if (!kDebugMode) return;

    final OperationException? ex = result.exception;
    final StringBuffer buffer = StringBuffer()
      ..writeln('[GraphQL] "$operation" transport failure');
    if (endpoint != null) buffer.writeln('  endpoint: $endpoint');

    final LinkException? link = ex?.linkException;
    if (link != null) {
      buffer.writeln('  linkException: ${link.runtimeType}');
      // originalException is the underlying cause — a SocketException
      // ("Connection refused") when the server is unreachable / the endpoint is
      // wrong, or an HTTP status error when the server rejected the request.
      if (link is ServerException) {
        buffer.writeln('  originalException: ${link.originalException}');
      } else if (link is HttpLinkParserException) {
        buffer.writeln('  parseError: ${link.originalException}');
      } else {
        // 타입을 특정하지 못한 경우(`UnknownException` 등)에도 원인은 남긴다.
        // 이게 없으면 "linkException: UnknownException" 한 줄만 남아 무엇이
        // 잘못됐는지 알 수 없다 — 실기기에서 연결 실패를 짚지 못한 원인이었다.
        buffer.writeln('  cause: $link');
      }
    }

    final List<GraphQLError> errors =
        ex?.graphqlErrors ?? const <GraphQLError>[];
    for (final GraphQLError error in errors) {
      // Message + path only — GraphQLError.message is the schema/validation
      // reason (e.g. "Cannot query field X"), which is safe and the most useful
      // signal when the hand-written operation doesn't match the real schema.
      buffer.writeln('  graphqlError: ${error.message}');
    }

    debugPrint(buffer.toString());
  }

  /// Logs an exception thrown by the client itself (no [QueryResult] to
  /// inspect). No-op unless [kDebugMode]. [error] is the raw cause — a
  /// SocketException here means the endpoint is unreachable.
  static void clientThrew(String operation, Object error) {
    if (!kDebugMode) return;
    debugPrint('[GraphQL] "$operation" threw: $error');
  }

  /// Logs the domain `userErrors` returned by a mutation payload so the real
  /// `UserError.code` strings can be collected and the `AuthFailure.fromCode`
  /// mapping finalized (spec §6.4). No-op unless [kDebugMode].
  ///
  /// Logs ONLY `code` and `field` — both non-sensitive identifiers. The human
  /// `message` is deliberately omitted since it can echo user input (e.g. an
  /// email), keeping tokens/PII out of logs in every build (CLAUDE.md §7).
  static void userErrors(
    String operation,
    List<({String code, String? field})> errors,
  ) {
    if (!kDebugMode || errors.isEmpty) return;
    final StringBuffer buffer = StringBuffer()
      ..writeln('[GraphQL] "$operation" userErrors:');
    for (final ({String code, String? field}) error in errors) {
      buffer.writeln('  code=${error.code} field=${error.field ?? '-'}');
    }
    debugPrint(buffer.toString());
  }
}
