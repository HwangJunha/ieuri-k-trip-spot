import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/domain/dm/model/message_report_selection.dart';
import 'package:ieuri_k_trip_spot/domain/dm/provider/dm_providers.dart';
import 'package:ieuri_k_trip_spot/domain/dm/provider/message_report_providers.dart';
import 'package:ieuri_k_trip_spot/domain/dm/repository/dm_repository.dart';

import '../dm_test_doubles.dart';

const String _cid = 'c1';

ProviderContainer _container(FakeDmRepository repo) {
  final ProviderContainer container = ProviderContainer(
    overrides: [dmRepositoryProvider.overrideWithValue(repo)],
  );
  addTearDown(container.dispose);
  return container;
}

void main() {
  group('신고 접수 (R15)', () {
    test('고른 메시지가 한 신고로 함께 접수된다 (AC15-1)', () async {
      final FakeDmRepository repo = FakeDmRepository();
      final ProviderContainer container = _container(repo);
      final MessageReportSelectionController notifier = container.read(
        messageReportSelectionControllerProvider(_cid).notifier,
      )..start(message('m1'));
      notifier
        ..toggle(message('m2'))
        ..toggle(message('m3'));

      final DmMutationResult<void> result = await notifier.submit(
        reason: 'SPAM',
      );

      expect(result.succeeded, isTrue);
      // 3번이 아니라 한 번 접수됐다.
      expect(repo.reportedMessageIds.length, 1);
      expect(repo.reportedMessageIds.single..sort(), <String>[
        'm1',
        'm2',
        'm3',
      ]);
    });

    test('0건이면 요청 자체가 나가지 않는다 (AC15-3)', () async {
      final FakeDmRepository repo = FakeDmRepository();
      final ProviderContainer container = _container(repo);
      final MessageReportSelectionController notifier = container.read(
        messageReportSelectionControllerProvider(_cid).notifier,
      )..start();

      final DmMutationResult<void> result = await notifier.submit(
        reason: 'SPAM',
      );

      expect(result.succeeded, isFalse);
      expect(result.errorCode, 'INVALID_INPUT');
      expect(repo.reportedMessageIds, isEmpty);
    });

    test('자기 메시지만 골랐다면 접수되지 않는다 (AC15-5)', () async {
      final FakeDmRepository repo = FakeDmRepository();
      final ProviderContainer container = _container(repo);
      final MessageReportSelectionController notifier = container.read(
        messageReportSelectionControllerProvider(_cid).notifier,
      )..start(message('mine', ownedByViewer: true));

      final DmMutationResult<void> result = await notifier.submit(
        reason: 'SPAM',
      );

      expect(result.succeeded, isFalse);
      expect(repo.reportedMessageIds, isEmpty);
    });

    test('접수되면 선택 모드가 닫힌다', () async {
      final ProviderContainer container = _container(FakeDmRepository());
      final MessageReportSelectionController notifier = container.read(
        messageReportSelectionControllerProvider(_cid).notifier,
      )..start(message('m1'));

      await notifier.submit(reason: 'SPAM');

      final MessageReportSelection selection = container.read(
        messageReportSelectionControllerProvider(_cid),
      );
      expect(selection.active, isFalse);
      expect(selection.selectedCount, 0);
    });

    test('이미 신고한 건이면 선택이 유지된다', () async {
      // 사용자가 무엇을 골랐는지 잃지 않아야 다시 판단할 수 있다.
      final FakeDmRepository repo = FakeDmRepository()
        ..reportErrorCode = 'ALREADY_REPORTED';
      final ProviderContainer container = _container(repo);
      final MessageReportSelectionController notifier = container.read(
        messageReportSelectionControllerProvider(_cid).notifier,
      )..start(message('m1'));

      final DmMutationResult<void> result = await notifier.submit(
        reason: 'SPAM',
      );

      expect(result.errorCode, 'ALREADY_REPORTED');
      expect(
        container.read(messageReportSelectionControllerProvider(_cid)).active,
        isTrue,
      );
    });

    test('대화마다 선택이 따로 관리된다 (AC15-4)', () {
      final ProviderContainer container = _container(FakeDmRepository());
      container
          .read(messageReportSelectionControllerProvider(_cid).notifier)
          .start(message('m1'));

      // 다른 대화의 선택은 비어 있다 — 화면 구조상 섞이지 않는다.
      expect(
        container
            .read(messageReportSelectionControllerProvider('c2'))
            .selectedCount,
        0,
      );
    });
  });
}
