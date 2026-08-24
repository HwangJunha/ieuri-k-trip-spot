import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/common/model/terms_code.dart';
import 'package:ieuri_k_trip_spot/domain/settings/model/agreement_status.dart';
import 'package:ieuri_k_trip_spot/domain/settings/provider/agreements_controller.dart';

import '../settings_test_doubles.dart';

/// 약관 notifier(SPEC-0011 R10·R12) — 낙관적 토글과 실패 롤백, 일괄 동의.

Future<ProviderContainer> _container(FakeSettingsRepository repo) async {
  final ProviderContainer container = await authenticatedContainer(repo);
  addTearDown(container.dispose);
  return container;
}

bool _agreed(List<AgreementStatus> list, TermsCode code) =>
    list.firstWhere((AgreementStatus a) => a.termsCode == code).agreed;

void main() {
  test('첫 조회가 약관 목록을 싣는다', () async {
    final ProviderContainer container = await _container(
      FakeSettingsRepository(),
    );

    final List<AgreementStatus> result = await container.read(
      agreementsControllerProvider.future,
    );

    expect(result, hasLength(4));
    expect(result.requiredSatisfied, isTrue);
  });

  test('선택 항목 토글이 서버 응답을 기다리지 않고 즉시 반영된다', () async {
    final ProviderContainer container = await _container(
      FakeSettingsRepository(),
    );
    await container.read(agreementsControllerProvider.future);

    // await 하지 않고 바로 상태를 본다 — 낙관적 갱신이면 이미 켜져 있어야 한다.
    final Future<void> pending = container
        .read(agreementsControllerProvider.notifier)
        .toggle(TermsCode.marketing, true);

    expect(
      _agreed(
        container.read(agreementsControllerProvider).value!,
        TermsCode.marketing,
      ),
      isTrue,
    );
    await pending;
  });

  test('토글이 실패하면 원래 값으로 되돌아간다', () async {
    final FakeSettingsRepository repo = FakeSettingsRepository()
      ..failUpdate = true;
    final ProviderContainer container = await _container(repo);
    await container.read(agreementsControllerProvider.future);

    await expectLater(
      container
          .read(agreementsControllerProvider.notifier)
          .toggle(TermsCode.marketing, true),
      throwsA(anything),
    );

    expect(
      _agreed(
        container.read(agreementsControllerProvider).value!,
        TermsCode.marketing,
      ),
      isFalse,
      reason: '실패했는데 켜진 채로 남으면 사용자가 저장됐다고 오해한다',
    );
  });

  test('토글이 실패해도 목록 자체는 오류 상태가 되지 않는다', () async {
    // 화면 전체가 사라지면 나머지 항목까지 못 본다 — 스위치가 제자리로 돌아가는 것이
    // 피드백이다.
    final FakeSettingsRepository repo = FakeSettingsRepository()
      ..failUpdate = true;
    final ProviderContainer container = await _container(repo);
    await container.read(agreementsControllerProvider.future);

    await container
        .read(agreementsControllerProvider.notifier)
        .toggle(TermsCode.marketing, true)
        .catchError((Object _) {});

    expect(container.read(agreementsControllerProvider).hasValue, isTrue);
  });

  // 사용자가 동의를 거두는 것을 막지 않는다. 막으면 스위치가 있는데 안 움직이는
  // 화면이 되고, 그건 고장으로 읽힌다. 대신 게이트가 걸려 서비스가 막힌다.
  test('필수 항목도 끌 수 있다', () async {
    final FakeSettingsRepository repo = FakeSettingsRepository();
    final ProviderContainer container = await _container(repo);
    await container.read(agreementsControllerProvider.future);

    await container
        .read(agreementsControllerProvider.notifier)
        .toggle(TermsCode.service, false);

    final List<AgreementStatus> result = container
        .read(agreementsControllerProvider)
        .value!;
    expect(_agreed(result, TermsCode.service), isFalse);
  });

  // "동의하지 않으면 서비스 이용 불가"가 문구가 아니라 동작으로 드러나는 지점이다 —
  // 라우터 게이트(R11)가 이 값을 보고 홈·탐색·커뮤니티를 막는다.
  test('필수 항목을 끄면 필수 충족이 깨진다', () async {
    final FakeSettingsRepository repo = FakeSettingsRepository();
    final ProviderContainer container = await _container(repo);
    final List<AgreementStatus> before = await container.read(
      agreementsControllerProvider.future,
    );
    expect(before.requiredSatisfied, isTrue);

    await container
        .read(agreementsControllerProvider.notifier)
        .toggle(TermsCode.privacy, false);

    final List<AgreementStatus> after = container
        .read(agreementsControllerProvider)
        .value!;
    expect(after.requiredSatisfied, isFalse, reason: '게이트가 닫혀야 한다');
  });

  test('필수 항목 토글이 실패하면 되돌아간다', () async {
    final FakeSettingsRepository repo = FakeSettingsRepository()
      ..failUpdate = true;
    final ProviderContainer container = await _container(repo);
    await container.read(agreementsControllerProvider.future);

    await expectLater(
      container
          .read(agreementsControllerProvider.notifier)
          .toggle(TermsCode.service, false),
      throwsA(anything),
    );

    final List<AgreementStatus> result = container
        .read(agreementsControllerProvider)
        .value!;
    expect(
      _agreed(result, TermsCode.service),
      isTrue,
      reason: '서버가 거부하면 켜진 채다',
    );
  });

  test('일괄 동의가 미동의 필수 항목만 보낸다', () async {
    final FakeSettingsRepository repo = FakeSettingsRepository(
      agreements: <AgreementStatus>[
        agreement(TermsCode.service, required: true),
        agreement(TermsCode.privacy, required: true, agreed: true),
        agreement(TermsCode.marketing),
      ],
    );
    final ProviderContainer container = await _container(repo);
    await container.read(agreementsControllerProvider.future);

    await container
        .read(agreementsControllerProvider.notifier)
        .agreeToRequired();

    expect(repo.agreedCodes, <TermsCode>[TermsCode.service]);
  });

  test('일괄 동의 성공이 재조회 없이 필수 충족 상태로 바꾼다', () async {
    // R12 첫 기준 — 반환된 상태로 갱신하므로 게이트가 그 자리에서 풀린다.
    final FakeSettingsRepository repo = FakeSettingsRepository(
      agreements: <AgreementStatus>[
        agreement(TermsCode.service, required: true),
        agreement(TermsCode.privacy, required: true),
      ],
    );
    final ProviderContainer container = await _container(repo);
    await container.read(agreementsControllerProvider.future);
    expect(
      container.read(agreementsControllerProvider).value!.requiredSatisfied,
      isFalse,
    );

    await container
        .read(agreementsControllerProvider.notifier)
        .agreeToRequired();

    expect(
      container.read(agreementsControllerProvider).value!.requiredSatisfied,
      isTrue,
    );
  });

  test('일괄 동의 실패는 오류 상태로 남는다', () async {
    final FakeSettingsRepository repo = FakeSettingsRepository(
      agreements: <AgreementStatus>[
        agreement(TermsCode.service, required: true),
      ],
    )..failAgree = true;
    final ProviderContainer container = await _container(repo);
    await container.read(agreementsControllerProvider.future);

    await container
        .read(agreementsControllerProvider.notifier)
        .agreeToRequired();

    expect(container.read(agreementsControllerProvider).hasError, isTrue);
  });

  // 두 항목을 **동시에** 토글했을 때 한쪽 실패가 다른 쪽을 덮지 않는지 본다.
  //
  // 실제로 여기서 버그가 났다: 롤백이 "진입 시점의 목록 전체"를 되돌려서, 나중에
  // 토글한 항목의 낙관적 값까지 지워 사용자가 건드리지도 않은 스위치가 되돌아갔다.
  // 항목 하나씩 굴리는 테스트로는 절대 잡히지 않는다.
  test('한 항목의 토글이 실패해도 다른 항목의 토글을 되돌리지 않는다', () async {
    final FakeSettingsRepository repo = FakeSettingsRepository();
    // 위치는 붙잡아 두고 실패시킨다 — 마케팅이 그 사이에 끼어들 수 있게.
    repo.gates[TermsCode.location] = Completer<void>();
    repo.failCodes.add(TermsCode.location);
    final ProviderContainer container = await _container(repo);
    await container.read(agreementsControllerProvider.future);

    final AgreementsController notifier = container.read(
      agreementsControllerProvider.notifier,
    );

    // 위치 토글을 띄워 두고(응답 대기), 그 사이 마케팅을 토글해 성공시킨다.
    final Future<void> location = notifier
        .toggle(TermsCode.location, true)
        .catchError((Object _) {});
    await notifier.toggle(TermsCode.marketing, true);

    // 이제 위치 요청을 실패로 풀어 준다.
    repo.gates[TermsCode.location]!.complete();
    await location;

    final List<AgreementStatus> result = container
        .read(agreementsControllerProvider)
        .value!;
    expect(
      _agreed(result, TermsCode.location),
      isFalse,
      reason: '실패한 쪽은 되돌아간다',
    );
    expect(_agreed(result, TermsCode.marketing), isTrue, reason: '성공한 쪽은 그대로다');
  });
}
