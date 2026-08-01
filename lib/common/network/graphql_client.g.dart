// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'graphql_client.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(tokenRefreshBridge)
const tokenRefreshBridgeProvider = TokenRefreshBridgeProvider._();

final class TokenRefreshBridgeProvider
    extends
        $FunctionalProvider<
          TokenRefreshBridge,
          TokenRefreshBridge,
          TokenRefreshBridge
        >
    with $Provider<TokenRefreshBridge> {
  const TokenRefreshBridgeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'tokenRefreshBridgeProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$tokenRefreshBridgeHash();

  @$internal
  @override
  $ProviderElement<TokenRefreshBridge> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  TokenRefreshBridge create(Ref ref) {
    return tokenRefreshBridge(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TokenRefreshBridge value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TokenRefreshBridge>(value),
    );
  }
}

String _$tokenRefreshBridgeHash() =>
    r'c262e0a7792513d3b10edb7179f219b27abb867c';

/// The shared `graphql_flutter` client (CLAUDE.md §4 — lives only in
/// `common/network`). Injects `Authorization: Bearer <accessToken>` from
/// [SecureStorage] on every request, sends the app's active language as an
/// `Accept-Language` header (the server localizes content from it — spec §2), and
/// on an auth error tries one refresh via the [TokenRefreshBridge] before retrying.

@ProviderFor(graphqlClient)
const graphqlClientProvider = GraphqlClientProvider._();

/// The shared `graphql_flutter` client (CLAUDE.md §4 — lives only in
/// `common/network`). Injects `Authorization: Bearer <accessToken>` from
/// [SecureStorage] on every request, sends the app's active language as an
/// `Accept-Language` header (the server localizes content from it — spec §2), and
/// on an auth error tries one refresh via the [TokenRefreshBridge] before retrying.

final class GraphqlClientProvider
    extends $FunctionalProvider<GraphQLClient, GraphQLClient, GraphQLClient>
    with $Provider<GraphQLClient> {
  /// The shared `graphql_flutter` client (CLAUDE.md §4 — lives only in
  /// `common/network`). Injects `Authorization: Bearer <accessToken>` from
  /// [SecureStorage] on every request, sends the app's active language as an
  /// `Accept-Language` header (the server localizes content from it — spec §2), and
  /// on an auth error tries one refresh via the [TokenRefreshBridge] before retrying.
  const GraphqlClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'graphqlClientProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$graphqlClientHash();

  @$internal
  @override
  $ProviderElement<GraphQLClient> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GraphQLClient create(Ref ref) {
    return graphqlClient(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GraphQLClient value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GraphQLClient>(value),
    );
  }
}

String _$graphqlClientHash() => r'40f05209f622dfb73f475c1bf3b5ee12357c5e6f';
