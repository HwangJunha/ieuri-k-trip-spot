import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/common/storage/secure_storage.dart';
import 'package:ieuri_k_trip_spot/domain/auth/provider/auth_repository_provider.dart';
import 'package:ieuri_k_trip_spot/domain/settings/model/nickname_validation.dart';
import 'package:ieuri_k_trip_spot/domain/settings/model/settings_failure.dart';
import 'package:ieuri_k_trip_spot/domain/settings/provider/profile_edit_controller.dart';
import 'package:ieuri_k_trip_spot/domain/settings/provider/profile_providers.dart';

import '../../auth/auth_test_doubles.dart';
import '../profile_test_doubles.dart';

/// SPEC-0011 R5 — 닉네임 성공·형식 오류 상태.

/// `submit` 성공 경로가 세션의 `Me`를 다시 맞추므로(`refreshMe`) auth 의존까지
/// override해야 컨테이너가 선다 — 빠뜨리면 provider가 오류 상태로 떠서 매달린다.
ProviderContainer _container(FakeProfileRepository repo) {
  final ProviderContainer container = ProviderContainer(
    overrides: [
      profileRepositoryProvider.overrideWithValue(repo),
      secureStorageProvider.overrideWithValue(SecureStorage(MemoryStore())),
      authRepositoryProvider.overrideWithValue(FakeAuthRepository()),
    ],
  );
  addTearDown(container.dispose);
  return container;
}

void main() {
  test('형식이 맞으면 서버로 보내고 저장 성공 상태가 된다', () async {
    final FakeProfileRepository repo = FakeProfileRepository();
    final ProviderContainer container = _container(repo);

    await container
        .read(profileEditControllerProvider.notifier)
        .submit('  Traveler  ');

    expect(container.read(profileEditControllerProvider).saved, isTrue);
    // 앞뒤 공백은 제거해서 보낸다 — 공백만 다른 닉네임은 사용자에게 같아 보인다.
    expect(repo.submittedNickname, 'Traveler');
  });

  test('빈 닉네임은 서버를 부르지 않고 형식 오류가 된다', () async {
    final FakeProfileRepository repo = FakeProfileRepository();
    final ProviderContainer container = _container(repo);

    await container.read(profileEditControllerProvider.notifier).submit('   ');

    expect(
      container.read(profileEditControllerProvider).formatError,
      NicknameValidation.empty,
    );
    expect(repo.submittedNickname, isNull);
  });

  test('길이 초과는 서버를 부르지 않고 형식 오류가 된다', () async {
    final FakeProfileRepository repo = FakeProfileRepository();
    final ProviderContainer container = _container(repo);

    await container
        .read(profileEditControllerProvider.notifier)
        .submit('가' * (nicknameMaxLength + 1));

    expect(
      container.read(profileEditControllerProvider).formatError,
      NicknameValidation.tooLong,
    );
    expect(repo.submittedNickname, isNull);
  });

  test('서버 실패는 입력란이 아니라 일반 오류로 남는다', () async {
    final FakeProfileRepository repo = FakeProfileRepository()
      ..nicknameFailure = SettingsFailure.network;
    final ProviderContainer container = _container(repo);

    await container
        .read(profileEditControllerProvider.notifier)
        .submit('Traveler');

    final ProfileEditState state = container.read(
      profileEditControllerProvider,
    );
    expect(state.hasFieldError, isFalse);
    expect(state.failure, isNotNull);
  });

  test('입력을 고치면 직전 오류가 지워진다', () async {
    final FakeProfileRepository repo = FakeProfileRepository();
    final ProviderContainer container = _container(repo);
    await container.read(profileEditControllerProvider.notifier).submit('   ');

    container.read(profileEditControllerProvider.notifier).clearErrors();

    expect(
      container.read(profileEditControllerProvider).hasFieldError,
      isFalse,
    );
  });
}
