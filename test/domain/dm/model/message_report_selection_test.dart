import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/domain/dm/model/message.dart';
import 'package:ieuri_k_trip_spot/domain/dm/model/message_report_selection.dart';

import '../dm_test_doubles.dart';

void main() {
  group('선택 상태 (R15)', () {
    test('선택이 0건이면 신고할 수 없다 (AC15-3)', () {
      const MessageReportSelection selection = MessageReportSelection(
        active: true,
      );

      expect(selection.canReport, isFalse);
    });

    test('상대 메시지를 고르면 신고할 수 있다', () {
      final MessageReportSelection selection = const MessageReportSelection(
        active: true,
      ).toggle(message('m1'));

      expect(selection.canReport, isTrue);
      expect(selection.selectedCount, 1);
    });

    test('자기 메시지는 골라지지 않는다 (AC15-5)', () {
      final MessageReportSelection selection = const MessageReportSelection(
        active: true,
      ).toggle(message('m1', ownedByViewer: true));

      expect(selection.selectedCount, 0);
      expect(selection.canReport, isFalse);
    });

    test('아직 서버에 없는 메시지는 골라지지 않는다', () {
      // 전송 중인 메시지는 서버가 id로 지목할 수 없다.
      final MessageReportSelection selection =
          const MessageReportSelection(active: true).toggle(
            message(
              'local-1',
              status: MessageDeliveryStatus.sending,
              localId: true,
            ),
          );

      expect(selection.selectedCount, 0);
    });

    test('같은 메시지를 다시 누르면 선택이 풀린다', () {
      final Message m = message('m1');
      final MessageReportSelection selection = const MessageReportSelection(
        active: true,
      ).toggle(m).toggle(m);

      expect(selection.selectedCount, 0);
      expect(selection.canReport, isFalse);
    });

    test('여러 건을 함께 고를 수 있다 (AC15-1)', () {
      final MessageReportSelection selection = const MessageReportSelection(
        active: true,
      ).toggle(message('m1')).toggle(message('m2')).toggle(message('m3'));

      expect(selection.selectedCount, 3);
      expect(selection.canReport, isTrue);
    });

    test('선택 모드가 꺼져 있으면 고른 게 있어도 신고할 수 없다', () {
      const MessageReportSelection selection = MessageReportSelection(
        selectedIds: <String>{'m1'},
      );

      expect(selection.canReport, isFalse);
    });
  });

  group('선택 모드 진입·해제', () {
    test('길게 누른 메시지가 첫 선택이 된다', () {
      final MessageReportSelection selection = const MessageReportSelection()
          .start(message('m1'));

      expect(selection.active, isTrue);
      expect(selection.isSelected('m1'), isTrue);
    });

    test('자기 메시지로 진입하면 선택 없이 모드만 켜진다', () {
      final MessageReportSelection selection = const MessageReportSelection()
          .start(message('m1', ownedByViewer: true));

      expect(selection.active, isTrue);
      expect(selection.selectedCount, 0);
    });

    test('취소하면 선택도 함께 비운다', () {
      final MessageReportSelection selection = const MessageReportSelection()
          .start(message('m1'))
          .cancel();

      expect(selection.active, isFalse);
      expect(selection.selectedCount, 0);
    });
  });
}
