import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/domain/auth/model/verification_code_input.dart';

/// 6칸 인증 코드 입력의 순수 로직(SPEC-0024 R11, 설계 §7).
///
/// 위젯을 세우지 않고 값 계산만 검증한다 — 포커스가 실제로 옮겨지는지는 범위 밖이고,
/// 틀리기 쉬운 건 "어느 칸이 다음인가"와 "값이 어떻게 합쳐지는가"뿐이다.

void main() {
  group('코드 결합 — 앞자리 0 보존 (R11-5)', () {
    test('앞자리가 0이어도 그대로 남는다', () {
      // 이 프로젝트가 실제로 깨질 수 있는 지점이다. 어딘가에서 int를 거치면
      // 012345가 12345가 되어 서버가 코드를 거부한다.
      final VerificationCodeInput input = VerificationCodeInput.of(<String>[
        '0',
        '1',
        '2',
        '3',
        '4',
        '5',
      ]);
      expect(input.code, '012345');
    });

    test('전부 0이어도 여섯 자리가 유지된다', () {
      final VerificationCodeInput input = VerificationCodeInput.of(
        List<String>.filled(6, '0'),
      );
      expect(input.code, '000000');
      expect(input.code.length, 6);
    });

    test('덜 찬 코드는 그만큼 짧다', () {
      final VerificationCodeInput input = VerificationCodeInput.empty()
          .enter(0, '0')
          .enter(1, '7');
      expect(input.code, '07');
      expect(input.isComplete, isFalse);
    });

    test('여섯 칸이 다 차야 완성이다', () {
      final VerificationCodeInput input = VerificationCodeInput.of(<String>[
        '0',
        '0',
        '0',
        '0',
        '0',
        '0',
      ]);
      expect(input.isComplete, isTrue);
    });
  });

  group('붙여넣기 분배 (R11-4)', () {
    test('6자리를 붙여넣으면 여섯 칸이 순서대로 찬다', () {
      final VerificationCodeInput input = VerificationCodeInput.empty().paste(
        '048261',
      );
      expect(input.digits, <String>['0', '4', '8', '2', '6', '1']);
      expect(input.code, '048261');
    });

    test('앞자리 0이 있는 문자열을 붙여넣어도 보존된다', () {
      expect(VerificationCodeInput.empty().paste('000123').code, '000123');
    });

    test('공백과 줄바꿈이 섞여 있어도 숫자만 골라 담는다', () {
      // 메일에서 복사하면 흔히 딸려 온다. 통째로 버리면 사용자가 손으로 다시 친다.
      expect(VerificationCodeInput.empty().paste(' 01 23-45\n').code, '012345');
    });

    test('여섯 자리를 넘치면 넘친 만큼 버린다', () {
      expect(VerificationCodeInput.empty().paste('0123456789').code, '012345');
    });

    test('중간 칸부터 붙여넣으면 그 자리부터 채운다', () {
      final VerificationCodeInput input = VerificationCodeInput.empty().paste(
        '99',
        from: 4,
      );
      expect(input.digits, <String>['', '', '', '', '9', '9']);
    });

    test('숫자가 하나도 없으면 상태가 그대로다', () {
      final VerificationCodeInput before = VerificationCodeInput.empty().enter(
        0,
        '5',
      );
      expect(before.paste('abc'), before);
    });

    test('한 칸에 여러 글자가 들어오면 붙여넣기로 처리된다', () {
      // 실제 붙여넣기는 TextField의 onChanged로 이렇게 도착한다.
      final VerificationCodeInput input = VerificationCodeInput.empty().enter(
        0,
        '012345',
      );
      expect(input.code, '012345');
    });
  });

  group('입력과 삭제', () {
    test('숫자가 아닌 입력은 무시된다', () {
      final VerificationCodeInput before = VerificationCodeInput.empty();
      expect(before.enter(0, 'a'), before);
    });

    test('값이 있는 칸을 삭제하면 그 칸만 비워진다', () {
      final VerificationCodeInput input = VerificationCodeInput.of(<String>[
        '1',
        '2',
        '3',
        '',
        '',
        '',
      ]).deleteAt(2);
      expect(input.digits, <String>['1', '2', '', '', '', '']);
    });

    test('빈 칸에서 삭제하면 이전 칸이 비워진다 (R11-3)', () {
      final VerificationCodeInput input = VerificationCodeInput.of(<String>[
        '1',
        '2',
        '',
        '',
        '',
        '',
      ]).deleteAt(2);
      expect(input.digits, <String>['1', '', '', '', '', '']);
    });

    test('첫 칸이 비어 있으면 삭제해도 아무 일도 없다', () {
      final VerificationCodeInput before = VerificationCodeInput.empty();
      expect(before.deleteAt(0), before);
    });

    test('enterEmpty는 이전 칸을 건드리지 않는다', () {
      // 텍스트 필드가 "값이 지워졌다"고 알려 온 경우 — 지워진 칸이 확정돼 있어서
      // 이전 칸까지 비우면 사용자가 지우지 않은 자리가 사라진다.
      final VerificationCodeInput input = VerificationCodeInput.of(<String>[
        '1',
        '2',
        '',
        '',
        '',
        '',
      ]).enterEmpty(2);
      expect(input.digits, <String>['1', '2', '', '', '', '']);
    });
  });

  group('포커스 이동 규칙 (R11-2, R11-3)', () {
    test('한 칸 입력하면 다음 칸으로 전진한다', () {
      final VerificationCodeInput input = VerificationCodeInput.empty().enter(
        0,
        '1',
      );
      expect(focusAfterEntry(input, 0), 1);
    });

    test('마지막 칸에서는 그 자리에 머문다', () {
      // 포커스가 사라지면 사용자가 마지막 자리를 고칠 수 없다.
      final VerificationCodeInput input = VerificationCodeInput.of(
        List<String>.filled(6, '1'),
      );
      expect(focusAfterEntry(input, 5), 5);
    });

    test('값이 있던 칸을 지우면 그 자리에 머문다', () {
      final VerificationCodeInput before = VerificationCodeInput.of(<String>[
        '1',
        '2',
        '3',
        '',
        '',
        '',
      ]);
      expect(focusAfterDelete(before, 2), 2);
    });

    test('빈 칸에서 지우면 이전 칸으로 후퇴한다', () {
      final VerificationCodeInput before = VerificationCodeInput.of(<String>[
        '1',
        '2',
        '',
        '',
        '',
        '',
      ]);
      expect(focusAfterDelete(before, 2), 1);
    });

    test('첫 칸에서 후퇴하지 않는다', () {
      expect(focusAfterDelete(VerificationCodeInput.empty(), 0), 0);
    });

    test('붙여넣기 뒤에는 첫 번째 빈 칸으로 간다', () {
      final VerificationCodeInput input = VerificationCodeInput.empty().paste(
        '012',
      );
      expect(focusAfterPaste(input), 3);
    });

    test('붙여넣기로 다 차면 마지막 칸에 둔다', () {
      final VerificationCodeInput input = VerificationCodeInput.empty().paste(
        '012345',
      );
      expect(focusAfterPaste(input), 5);
    });
  });
}
