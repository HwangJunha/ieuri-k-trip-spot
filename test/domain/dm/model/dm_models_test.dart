// DM 모델 테스트를 한 파일에 모았다.
//
// **파일을 쪼개지 않는 이유는 속도다** — flutter test는 파일마다 격리된 VM을 띄우므로
// 파일 수가 곧 실행 시간이다. 모델별 구분은 group으로 충분하다(CLAUDE.md §8).

import '../dm_test_doubles.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/domain/dm/model/message.dart';
import 'package:ieuri_k_trip_spot/domain/dm/model/message_report_selection.dart';
import 'package:ieuri_k_trip_spot/domain/dm/model/typing_indicator.dart';

// ─── typing_indicator ──────────────────────────────────────────
final DateTime _t0 = DateTime.utc(2026, 8, 12, 10);

TypingIndicator _event({Duration ago = Duration.zero}) =>
    TypingIndicator(sender: author('other'), emittedAt: _t0.subtract(ago));

void main() {
  // ─── message_report_selection ────────────────────────────────

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

  // ─── message ─────────────────────────────────────────────────

  // SPEC-0021 R4 — 피드 인용만 있던 과거 메시지는 서버가 인용을 걷어낸 뒤로 **본문도
  // 사진도 없이** 내려온다. 그대로 그리면 빈 말풍선이 되므로, 모델이 그 상태를
  // 구분해 표시 계층에 알려야 한다.
  group('내용 없는 메시지 (R4)', () {
    test('본문도 사진도 없으면 비어 있다고 판정한다', () {
      expect(message('m1', body: '').isEmpty, isTrue);
    });

    test('본문이 있으면 비어 있지 않다', () {
      expect(message('m1', body: '안녕').isEmpty, isFalse);
    });

    test('본문이 없어도 사진이 있으면 비어 있지 않다', () {
      // 사진만 보낸 메시지는 정상이며 "내용 없음"으로 표시하면 안 된다.
      final Message photoOnly = Message(
        id: 'm1',
        body: '',
        sender: author('other'),
        createdAt: DateTime.utc(2026, 8, 12),
        ownedByViewer: false,
        photoKey: 'images/p1',
      );

      expect(photoOnly.isEmpty, isFalse);
    });

    test('본문이 비어도 말풍선을 숨기지 않도록 hasBody와 구분된다', () {
      // hasBody는 본문 줄을 그릴지, isEmpty는 "내용 없음"을 그릴지를 가른다 —
      // 하나로 합치면 사진만 보낸 메시지가 "내용 없음"으로 뜬다.
      final Message photoOnly = Message(
        id: 'm1',
        body: '',
        sender: author('other'),
        createdAt: DateTime.utc(2026, 8, 12),
        ownedByViewer: false,
        photoKey: 'images/p1',
      );

      expect(photoOnly.hasBody, isFalse);
      expect(photoOnly.isEmpty, isFalse);
    });
  });

  // ─── typing_indicator ────────────────────────────────────────

  group('타임아웃 자동 해제 (R10 — AC10-4)', () {
    const Duration timeout = Duration(seconds: 5);

    test('방금 온 이벤트는 유효하다', () {
      expect(_event().isActiveAt(_t0, timeout), isTrue);
    });

    test('타임아웃이 지나면 표시가 해제된다', () {
      // 후속 이벤트가 끊긴 채 시간이 흘렀다 — 서버의 "멈췄다" 이벤트를 기다리지
      // 않고 스스로 내린다.
      expect(
        _event().isActiveAt(_t0.add(const Duration(seconds: 6)), timeout),
        isFalse,
      );
    });

    test('경계에서는 아직 유효하다', () {
      expect(
        _event().isActiveAt(_t0.add(const Duration(seconds: 5)), timeout),
        isTrue,
      );
    });

    test('경계를 1밀리초라도 넘으면 해제된다', () {
      expect(
        _event().isActiveAt(
          _t0.add(const Duration(seconds: 5, milliseconds: 1)),
          timeout,
        ),
        isFalse,
      );
    });

    test('전달이 지연돼 이미 만료된 이벤트는 켜지지 않는다', () {
      // emittedAt이 수신 시각이 아니라 발생 시각이라 이 판정이 가능하다.
      expect(
        _event(ago: const Duration(seconds: 10)).isActiveAt(_t0, timeout),
        isFalse,
      );
    });
  });

}
