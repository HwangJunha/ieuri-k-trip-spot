import 'package:graphql_flutter/graphql_flutter.dart';

/// Transport/system GraphQL failure detection shared by every feature
/// repository (CLAUDE.md §4). GraphQL returns HTTP 200 even on failure, so a
/// populated top-level `errors` array — or a link/connection exception — is a
/// failure. Repositories map the result to their own domain failure without
/// logging raw server text (tokens/PII, spec §6.4).
///
/// Detects a transport-level failure on a mutation/query [result]: a link
/// exception (no network / server unreachable) or a populated top-level
/// `errors` array. Does NOT inspect domain `userErrors` — that is the feature
/// repository's job (spec §6.4).
bool hasTransportFailure(QueryResult<Object?> result) =>
    result.hasException &&
    (result.exception?.linkException != null ||
        (result.exception?.graphqlErrors.isNotEmpty ?? false));
