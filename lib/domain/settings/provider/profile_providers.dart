import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../common/network/graphql_client.dart';
import '../repository/profile_repository.dart';
import '../repository/profile_repository_impl.dart';

part 'profile_providers.g.dart';

/// 프로필 repository 하나의 출처(CLAUDE.md §5 — 위젯이 repository를 직접 만들지
/// 않는다). 테스트는 이 provider 하나만 오버라이드해 페이크를 주입한다.
///
/// 약관의 `settingsRepositoryProvider`와 **따로 둔다** — 둘을 한 인터페이스로 합치면
/// 약관 화면 테스트가 프로필 메서드까지 전부 스텁해야 한다.
@Riverpod(keepAlive: true)
ProfileRepository profileRepository(Ref ref) =>
    ProfileRepositoryImpl(ref.watch(graphqlClientProvider));
