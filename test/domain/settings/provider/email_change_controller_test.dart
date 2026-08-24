import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/common/storage/secure_storage.dart';
import 'package:ieuri_k_trip_spot/domain/auth/provider/auth_controller.dart';
import 'package:ieuri_k_trip_spot/domain/auth/provider/auth_repository_provider.dart';
import 'package:ieuri_k_trip_spot/domain/settings/model/email_change_failure_reason.dart';
import 'package:ieuri_k_trip_spot/domain/settings/model/settings_failure.dart';
import 'package:ieuri_k_trip_spot/domain/settings/provider/email_change_controller.dart';

import '../../auth/auth_test_doubles.dart';
import '../email_change_test_doubles.dart';

/// SPEC-0011 R7·R8 — 이메일 변경 2단계 상태 기계.
///
/// 성공 시 `refreshMe()`를 부르므로 인증 세션이 서 있어야 한다.

Future<ProviderContainer> _container(FakeEmailChangeRepository repo) async {
  final SecureStorage secure = await seededSecureStorage(
    authenticated: true,
    onboarded: true,
  );
  final ProviderContainer container = ProviderContainer(
    overrides: [
      secureStorageProvider.overrideWithValue(secure),
      authRepositoryProvider.overrideWithValue(FakeAuthRepository()),
      emailChangeRepositoryProvider.overrideWithValue(repo),
    ],
  );
  addTearDown(container.dispose);
  await container.read(authControllerProvider.future);
  return container;
}

EmailChangeState _state(ProviderContainer c) =>
    c.read(emailChangeControllerProvider);

EmailChangeController _notifier(ProviderContainer c) =>
    c.read(emailChangeControllerProvider.notifier);

void main() {
  test('처음에는 주소 입력 단계다', () async {
    final ProviderContainer c = await _container(FakeEmailChangeRepository());

    expect(_state(c).step, EmailChangeStep.address);
    expect(_state(c).verificationId, isNull);
  });

  test('1단계가 성공하면 코드 단계로 넘어간다 (R7)', () async {
    final FakeEmailChangeRepository repo = FakeEmailChangeRepository();
    final ProviderContainer c = await _container(repo);

    await _notifier(c).requestChange('new@example.com');

    expect(_state(c).step, EmailChangeStep.code);
    expect(_state(c).verificationId, 'verify-1');
    expect(repo.requestedEmails, <String>['new@example.com']);
  });

  test('주소의 앞뒤 공백을 떼고 보낸다', () async {
    final FakeEmailChangeRepository repo = FakeEmailChangeRepository();
    final ProviderContainer c = await _container(repo);

    await _notifier(c).requestChange('  new@example.com  ');

    expect(repo.requestedEmails, <String>['new@example.com']);
  });

  // R7 첫 기준 — 코드를 보낸 것만으로 프로필 이메일이 바뀌면 안 된다.
  test('1단계만으로는 이메일이 확정되지 않는다 (R7)', () async {
    final ProviderContainer c = await _container(FakeEmailChangeRepository());

    await _notifier(c).requestChange('new@example.com');

    expect(_state(c).confirmedEmail, isNull, reason: '검증 전까지는 확정이 아니다');
    expect(_state(c).pendingEmail, 'new@example.com');
  });

  test('1단계가 실패하면 주소 단계에 남는다', () async {
    final FakeEmailChangeRepository repo = FakeEmailChangeRepository()
      ..requestFailure = SettingsFailure.network;
    final ProviderContainer c = await _container(repo);

    await _notifier(c).requestChange('new@example.com');

    expect(_state(c).step, EmailChangeStep.address);
    expect(_state(c).failure, isNotNull);
    expect(_state(c).busy, isFalse, reason: '멈춰 있으면 재시도가 막힌다');
  });

  // SettingsFailure가 아닌 예외에도 busy가 풀려야 한다 — 안 그러면 화면을
  // 나갔다 오지 않는 한 다시 시도조차 못 한다.
  test('예상 밖의 예외에도 다시 시도할 수 있다', () async {
    final FakeEmailChangeRepository repo = FakeEmailChangeRepository()
      ..requestFailure = null;
    final ProviderContainer c = await _container(repo);
    repo.gate = Completer<void>()..completeError(StateError('boom'));

    await _notifier(c).requestChange('new@example.com');

    expect(_state(c).busy, isFalse);
    expect(_state(c).failure, isNotNull);
  });

  test('2단계가 성공하면 done이 되고 새 이메일이 실린다 (R8)', () async {
    final FakeEmailChangeRepository repo = FakeEmailChangeRepository()
      ..confirmedEmail = 'new@example.com';
    final ProviderContainer c = await _container(repo);
    await _notifier(c).requestChange('new@example.com');

    await _notifier(c).confirm('123456');

    expect(_state(c).step, EmailChangeStep.done);
    expect(_state(c).confirmedEmail, 'new@example.com');
  });

  test('코드의 앞뒤 공백을 떼고 보낸다', () async {
    final FakeEmailChangeRepository repo = FakeEmailChangeRepository();
    final ProviderContainer c = await _container(repo);
    await _notifier(c).requestChange('new@example.com');

    await _notifier(c).confirm(' 123456 ');

    expect(repo.confirmedCodes, <String>['123456']);
  });

  test('코드 불일치는 코드 단계에 머문다 (R8)', () async {
    final FakeEmailChangeRepository repo = FakeEmailChangeRepository()
      ..confirmReason = EmailChangeFailureReason.codeMismatch;
    final ProviderContainer c = await _container(repo);
    await _notifier(c).requestChange('new@example.com');

    await _notifier(c).confirm('000000');

    expect(_state(c).step, EmailChangeStep.code, reason: '다시 입력하면 된다');
    expect(_state(c).reason, EmailChangeFailureReason.codeMismatch);
    expect(_state(c).verificationId, 'verify-1', reason: '같은 검증 건이 살아 있다');
  });

  test('만료도 코드 단계에 머문다 — 재발송하면 되기 때문이다 (R8)', () async {
    final FakeEmailChangeRepository repo = FakeEmailChangeRepository()
      ..confirmReason = EmailChangeFailureReason.expired;
    final ProviderContainer c = await _container(repo);
    await _notifier(c).requestChange('new@example.com');

    await _notifier(c).confirm('000000');

    expect(_state(c).step, EmailChangeStep.code);
    expect(_state(c).verificationId, isNotNull, reason: '재발송에 이 id가 필요하다');
  });

  // 이 검증 건은 죽었으므로 주소부터 다시 해야 한다.
  test('시도 초과는 주소 단계로 되돌리고 검증 건을 버린다 (R8)', () async {
    final FakeEmailChangeRepository repo = FakeEmailChangeRepository()
      ..confirmReason = EmailChangeFailureReason.maxAttemptsExceeded;
    final ProviderContainer c = await _container(repo);
    await _notifier(c).requestChange('new@example.com');

    await _notifier(c).confirm('000000');

    expect(_state(c).step, EmailChangeStep.address);
    expect(_state(c).verificationId, isNull, reason: '죽은 id를 들고 가지 않는다');
    expect(_state(c).reason, EmailChangeFailureReason.maxAttemptsExceeded);
    expect(_state(c).pendingEmail, 'new@example.com', reason: '주소는 다시 채워 준다');
  });

  test('검증 실패(전송 오류)는 검증 판정과 구분된다', () async {
    final FakeEmailChangeRepository repo = FakeEmailChangeRepository()
      ..confirmFailure = SettingsFailure.network;
    final ProviderContainer c = await _container(repo);
    await _notifier(c).requestChange('new@example.com');

    await _notifier(c).confirm('123456');

    expect(_state(c).failure, isNotNull);
    expect(_state(c).reason, isNull, reason: '전송 실패는 검증 사유가 아니다');
    expect(_state(c).step, EmailChangeStep.code);
  });

  test('검증 건이 없으면 2단계를 부르지 않는다', () async {
    final FakeEmailChangeRepository repo = FakeEmailChangeRepository();
    final ProviderContainer c = await _container(repo);

    await _notifier(c).confirm('123456');

    expect(repo.confirmedCodes, isEmpty);
  });

  group('재발송 쿨다운 (R8)', () {
    test('1단계 직후에는 쿨다운이 걸려 재발송하지 않는다', () async {
      final FakeEmailChangeRepository repo = FakeEmailChangeRepository();
      final ProviderContainer c = await _container(repo);
      await _notifier(c).requestChange('new@example.com');

      await _notifier(c).resend();

      expect(repo.resendCalls, 0, reason: '코드가 방금 나갔다');
      expect(_notifier(c).canResendNow(), isFalse);
    });

    test('쿨다운이 지나면 재발송하고 새 검증 건으로 갈아끼운다', () async {
      final FakeEmailChangeRepository repo = FakeEmailChangeRepository();
      final ProviderContainer c = await _container(repo);
      await _notifier(c).requestChange('new@example.com');
      // 쿨다운을 과거로 밀어 만료를 흉내 낸다.
      _notifier(c).state = _state(c).copyWith(
        resendCooldownUntil: DateTime.now().subtract(
          const Duration(minutes: 1),
        ),
      );

      await _notifier(c).resend();

      expect(repo.resendCalls, 1);
      expect(_state(c).verificationId, 'verify-1-resent');
      expect(_state(c).resent, isTrue);
    });

    test('재발송에 성공하면 쿨다운이 다시 걸린다', () async {
      final FakeEmailChangeRepository repo = FakeEmailChangeRepository();
      final ProviderContainer c = await _container(repo);
      await _notifier(c).requestChange('new@example.com');
      _notifier(c).state = _state(c).copyWith(
        resendCooldownUntil: DateTime.now().subtract(
          const Duration(minutes: 1),
        ),
      );

      await _notifier(c).resend();

      expect(_notifier(c).canResendNow(), isFalse);
    });

    // 서버가 쿨다운으로 거절했다 = 우리 시계가 앞섰다. 다시 막아 두는 편이 낫다.
    test('서버가 쿨다운으로 거절하면 창을 다시 건다', () async {
      final FakeEmailChangeRepository repo = FakeEmailChangeRepository()
        ..resendFailure = SettingsFailure.userError('RESEND_COOLDOWN_ACTIVE');
      final ProviderContainer c = await _container(repo);
      await _notifier(c).requestChange('new@example.com');
      _notifier(c).state = _state(c).copyWith(
        resendCooldownUntil: DateTime.now().subtract(
          const Duration(minutes: 1),
        ),
      );

      await _notifier(c).resend();

      expect(_notifier(c).canResendNow(), isFalse);
      expect(_state(c).failure, isNotNull);
    });
  });

  group('중복 제출 방지', () {
    test('진행 중에는 1단계를 두 번 보내지 않는다', () async {
      final FakeEmailChangeRepository repo = FakeEmailChangeRepository()
        ..gate = Completer<void>();
      final ProviderContainer c = await _container(repo);

      final Future<void> first = _notifier(c).requestChange('a@example.com');
      await _notifier(c).requestChange('b@example.com');
      repo.gate!.complete();
      await first;

      expect(repo.requestedEmails, <String>['a@example.com']);
    });

    test('진행 중에는 2단계를 두 번 보내지 않는다', () async {
      final FakeEmailChangeRepository repo = FakeEmailChangeRepository();
      final ProviderContainer c = await _container(repo);
      await _notifier(c).requestChange('new@example.com');
      repo.gate = Completer<void>();

      final Future<void> first = _notifier(c).confirm('111111');
      await _notifier(c).confirm('222222');
      repo.gate!.complete();
      await first;

      expect(repo.confirmedCodes, <String>['111111']);
    });
  });

  test('입력을 고치면 직전 오류가 지워진다', () async {
    final FakeEmailChangeRepository repo = FakeEmailChangeRepository()
      ..confirmReason = EmailChangeFailureReason.codeMismatch;
    final ProviderContainer c = await _container(repo);
    await _notifier(c).requestChange('new@example.com');
    await _notifier(c).confirm('000000');
    expect(_state(c).reason, isNotNull);

    _notifier(c).clearErrors();

    expect(_state(c).reason, isNull);
    expect(_state(c).failure, isNull);
  });
}
