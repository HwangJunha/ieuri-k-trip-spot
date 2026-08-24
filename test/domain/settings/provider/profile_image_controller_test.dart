import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/common/storage/secure_storage.dart';
import 'package:ieuri_k_trip_spot/domain/auth/provider/auth_repository_provider.dart';
import 'package:ieuri_k_trip_spot/domain/settings/model/profile_image_upload.dart';
import 'package:ieuri_k_trip_spot/domain/settings/model/settings_failure.dart';
import 'package:ieuri_k_trip_spot/domain/settings/provider/profile_image_controller.dart';
import 'package:ieuri_k_trip_spot/domain/settings/provider/profile_providers.dart';

import '../../auth/auth_test_doubles.dart';
import '../profile_test_doubles.dart';

/// SPEC-0011 R6 — 3단계 진행, 중간 실패 시 정리, 제거.

/// 성공 경로가 세션의 `Me`를 다시 맞추므로(`refreshMe`) auth 의존까지 override한다.
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

/// 고정 바이트. 컨트롤러가 바이트만 받으므로 갤러리 없이 3단계가 전부 검증된다.
const ProfileImageBytes _image = ProfileImageBytes(
  bytes: <int>[1, 2, 3, 4, 5],
  contentType: 'image/jpeg',
);

void main() {
  test('교체는 발급→PUT→확정 세 단계를 순서대로 밟는다', () async {
    final FakeProfileRepository repo = FakeProfileRepository();
    final ProviderContainer container = _container(repo);

    await container
        .read(profileImageControllerProvider.notifier)
        .replace(_image);

    expect(repo.steps, <String>[stepCreateUrl, stepUpload, stepConfirm]);
    expect(
      container.read(profileImageControllerProvider).confirmedKey,
      'profile/confirmed-1',
    );
  });

  test('1단계에 선언한 길이가 실제 PUT 바이트 수와 같다', () async {
    final FakeProfileRepository repo = FakeProfileRepository();
    final ProviderContainer container = _container(repo);

    await container
        .read(profileImageControllerProvider.notifier)
        .replace(_image);

    // 어긋나면 스토리지가 서명 불일치로 거부한다(R6).
    expect(repo.declaredContentLength, repo.sentByteCount);
    expect(repo.declaredContentType, repo.sentContentType);
  });

  test('PUT이 실패하면 확정하지 않는다', () async {
    final FakeProfileRepository repo = FakeProfileRepository()
      ..uploadFailure = SettingsFailure.network;
    final ProviderContainer container = _container(repo);

    await container
        .read(profileImageControllerProvider.notifier)
        .replace(_image);

    // 확정이 없어야 임시 키가 확정된 이미지로 승격되지 않는다.
    expect(repo.steps, <String>[stepCreateUrl, stepUpload]);
    expect(container.read(profileImageControllerProvider).failure, isNotNull);
    expect(container.read(profileImageControllerProvider).confirmedKey, isNull);
  });

  test('발급이 실패하면 PUT도 확정도 하지 않는다', () async {
    final FakeProfileRepository repo = FakeProfileRepository()
      ..createUrlFailure = SettingsFailure.network;
    final ProviderContainer container = _container(repo);

    await container
        .read(profileImageControllerProvider.notifier)
        .replace(_image);

    expect(repo.steps, <String>[stepCreateUrl]);
  });

  test('실패 뒤에는 idle로 돌아와 다시 시도할 수 있다', () async {
    final FakeProfileRepository repo = FakeProfileRepository()
      ..confirmFailure = SettingsFailure.network;
    final ProviderContainer container = _container(repo);
    await container
        .read(profileImageControllerProvider.notifier)
        .replace(_image);

    // isBusy가 남아 있으면 두 번째 시도가 조용히 무시된다.
    expect(container.read(profileImageControllerProvider).isBusy, isFalse);

    repo.confirmFailure = null;
    await container
        .read(profileImageControllerProvider.notifier)
        .replace(_image);

    expect(
      container.read(profileImageControllerProvider).confirmedKey,
      isNotNull,
    );
  });

  test('제거는 업로드 단계를 거치지 않는 별도 동작이다', () async {
    final FakeProfileRepository repo = FakeProfileRepository();
    final ProviderContainer container = _container(repo);

    await container.read(profileImageControllerProvider.notifier).remove();

    expect(repo.steps, <String>[stepRemove]);
    expect(container.read(profileImageControllerProvider).removed, isTrue);
  });

  test('제거가 실패하면 성공으로 표시하지 않는다', () async {
    final FakeProfileRepository repo = FakeProfileRepository()
      ..removeFailure = SettingsFailure.network;
    final ProviderContainer container = _container(repo);

    await container.read(profileImageControllerProvider.notifier).remove();

    final ProfileImageState state = container.read(
      profileImageControllerProvider,
    );
    expect(state.removed, isFalse);
    expect(state.failure, isNotNull);
  });

  // `SettingsFailure`가 아닌 예외에서도 idle로 돌아와야 한다.
  //
  // 원래는 `on SettingsFailure`만 잡아서, 매핑 중 `TypeError` 같은 것이 새면 state가
  // `uploading`에 멈춘 채 `isBusy`가 영영 true로 남았다 — 사용자는 화면을 나갔다
  // 오지 않는 한 **다시 시도조차 못 했다**.
  test('예상 밖의 예외에도 idle로 돌아와 다시 시도할 수 있다', () async {
    final FakeProfileRepository repo = FakeProfileRepository()
      ..uploadRawError = StateError('unexpected');
    final ProviderContainer container = _container(repo);

    await container
        .read(profileImageControllerProvider.notifier)
        .replace(_image);

    final ProfileImageState state = container.read(
      profileImageControllerProvider,
    );
    expect(state.isBusy, isFalse, reason: '멈춰 있으면 재시도가 막힌다');
    expect(state.failure, isNotNull);
    // 확정까지 가지 않았으므로 키는 확정되지 않는다.
    expect(state.confirmedKey, isNull);
  });
}
