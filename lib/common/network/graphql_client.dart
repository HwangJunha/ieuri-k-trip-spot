import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../storage/secure_storage.dart';
import 'graphql_endpoint.dart';

part 'graphql_client.g.dart';

/// A hook the auth layer registers so the network layer can refresh an expired
/// access token WITHOUT importing the auth provider (spec §7/§8 — the link ↔
/// auth-state cycle is broken with this callback/token-getter pattern).
///
/// Returns the new access token on success, or `null` if refresh failed (which
/// tells the caller to sign out).
typedef TokenRefresher = Future<String?> Function();

/// Holds the current [TokenRefresher]. The auth controller assigns [refresher]
/// after it is built; the [AuthLink] below reads it lazily so there is no
/// direct provider → client → provider dependency cycle.
class TokenRefreshBridge {
  TokenRefreshBridge();

  TokenRefresher? refresher;
}

@Riverpod(keepAlive: true)
TokenRefreshBridge tokenRefreshBridge(Ref ref) => TokenRefreshBridge();

/// The shared `graphql_flutter` client (CLAUDE.md §4 — lives only in
/// `common/network`). Injects `Authorization: Bearer <accessToken>` from
/// [SecureStorage] on every request, and on an auth error tries one refresh via
/// the [TokenRefreshBridge] before retrying the original operation.
@Riverpod(keepAlive: true)
GraphQLClient graphqlClient(Ref ref) {
  final SecureStorage storage = ref.watch(secureStorageProvider);
  final TokenRefreshBridge bridge = ref.watch(tokenRefreshBridgeProvider);

  final HttpLink httpLink = HttpLink(GraphqlEndpoint.resolve());

  final AuthLink authLink = AuthLink(
    getToken: () async {
      final String? token = await storage.readAccessToken();
      return token == null ? null : 'Bearer $token';
    },
  );

  final Link refreshLink = _RefreshLink(bridge);

  return GraphQLClient(
    link: refreshLink.concat(authLink).concat(httpLink),
    cache: GraphQLCache(),
    defaultPolicies: DefaultPolicies(
      mutate: Policies(fetch: FetchPolicy.noCache),
      query: Policies(fetch: FetchPolicy.noCache),
    ),
  );
}

/// On an auth error from downstream, calls the registered refresher once and
/// retries the request. On refresh failure it lets the original error surface
/// so the auth controller signs out (spec §6.3).
class _RefreshLink extends Link {
  _RefreshLink(this._bridge);

  final TokenRefreshBridge _bridge;

  static const String _authErrorCode = 'UNAUTHENTICATED';

  @override
  Stream<Response> request(Request request, [NextLink? forward]) async* {
    final NextLink next = forward!;
    await for (final Response response in next(request)) {
      if (_isAuthError(response) && _bridge.refresher != null) {
        final String? newToken = await _bridge.refresher!();
        if (newToken != null) {
          yield* next(request);
          return;
        }
      }
      yield response;
    }
  }

  bool _isAuthError(Response response) {
    final List<GraphQLError>? errors = response.errors;
    if (errors == null) return false;
    return errors.any(
      (GraphQLError e) => e.extensions?['code'] == _authErrorCode,
    );
  }
}
