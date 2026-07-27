import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../common/network/graphql_client.dart';
import '../repository/auth_repository.dart';
import '../repository/auth_repository_impl.dart';

part 'auth_repository_provider.g.dart';

/// Exposes the [AuthRepository] built over the shared GraphQL client. Widgets
/// never construct the repository directly (CLAUDE.md §5); the controller reads
/// it from here.
@Riverpod(keepAlive: true)
AuthRepository authRepository(Ref ref) =>
    AuthRepositoryImpl(ref.watch(graphqlClientProvider));
