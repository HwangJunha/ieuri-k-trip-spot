import 'dart:io' show Platform;

/// Resolves the GraphQL endpoint (spec §6.1). Injected via
/// `--dart-define=GRAPHQL_ENDPOINT=...`; when unset, defaults per emulator host
/// — Android emulators reach the host loopback at `10.0.2.2`, iOS simulators use
/// `localhost`. Both targets are emulators.
class GraphqlEndpoint {
  const GraphqlEndpoint._();

  static const String _override = String.fromEnvironment('GRAPHQL_ENDPOINT');

  static const String _androidHost = 'http://10.0.2.2:8888/graphql';
  static const String _defaultHost = 'http://localhost:8888/graphql';

  static String resolve() {
    if (_override.isNotEmpty) return _override;
    return Platform.isAndroid ? _androidHost : _defaultHost;
  }
}
