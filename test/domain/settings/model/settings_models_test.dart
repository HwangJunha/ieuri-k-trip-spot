// 설정 모델 테스트를 한 파일에 모았다.
//
// **파일을 쪼개지 않는 이유는 속도다** — flutter test는 파일마다 격리된 VM을 띄우므로
// 파일 수가 곧 실행 시간이다. 모델별 구분은 group으로 충분하다(CLAUDE.md §8).

import '../settings_test_doubles.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/common/model/terms_code.dart';
import 'package:ieuri_k_trip_spot/domain/settings/model/agreement_status.dart';
import 'package:ieuri_k_trip_spot/domain/settings/model/email_change_failure_reason.dart';
import 'package:ieuri_k_trip_spot/domain/settings/model/nickname_validation.dart';

// ─── agreement_date ────────────────────────────────────────────
AgreementStatus _at(String? raw) => AgreementStatus(
  termsCode: TermsCode.service,
  required: true,
  agreed: true,
  version: 'v1',
  agreedAt: raw,
);

void main() {
  // ─── agreement_date ──────────────────────────────────────────

  test('ISO 타임스탬프를 DateTime으로 바꾼다', () {
    final DateTime? parsed = _at('2026-08-07T18:42:30.024670Z').agreedAtDate;

    expect(parsed, isNotNull);
    expect(parsed!.toUtc().year, 2026);
    expect(parsed.toUtc().month, 8);
    expect(parsed.toUtc().day, 7);
  });

  test('UTC를 현지 시간대로 옮긴다', () {
    final DateTime? parsed = _at('2026-08-07T18:42:30.024670Z').agreedAtDate;

    expect(parsed!.isUtc, isFalse, reason: '표시는 사용자의 시간대를 따른다');
  });

  test('날짜만 있는 값도 받는다', () {
    expect(_at('2026-01-12').agreedAtDate, isNotNull);
  });

  test('미동의(null)는 null이다', () {
    expect(_at(null).agreedAtDate, isNull);
  });

  // 일자 하나 때문에 약관 화면 전체가 사라지면 손해가 더 크다.
  test('형식이 어긋나면 null로 떨어뜨린다', () {
    expect(_at('nonsense').agreedAtDate, isNull);
    expect(_at('').agreedAtDate, isNull);
  });

  // ─── agreement_status ────────────────────────────────────────

  test('미동의 필수 약관이 있으면 충족이 아니다', () {
    final List<AgreementStatus> list = <AgreementStatus>[
      agreement(TermsCode.service, required: true, agreed: true),
      agreement(TermsCode.privacy, required: true),
    ];

    expect(list.requiredSatisfied, isFalse);
    expect(list.unmetRequired.single.termsCode, TermsCode.privacy);
  });

  test('선택 항목이 미동의여도 필수는 충족된다', () {
    final List<AgreementStatus> list = <AgreementStatus>[
      agreement(TermsCode.service, required: true, agreed: true),
      agreement(TermsCode.marketing),
    ];

    expect(list.requiredSatisfied, isTrue);
  });

  test('필수 여부는 서버 값을 따른다', () {
    // `TermsCode.isRequired`가 아니라 서버가 준 `required`를 본다 — 정책은 서버가
    // 바꿀 수 있고 클라이언트가 덮어쓰면 게이트가 실제와 어긋난다.
    final List<AgreementStatus> list = <AgreementStatus>[
      agreement(TermsCode.location, required: true),
    ];

    expect(list.requiredItems, hasLength(1));
    expect(list.requiredSatisfied, isFalse);
  });

  test('copyWith는 동의 여부만 바꾸고 나머지를 보존한다', () {
    final AgreementStatus original = agreement(
      TermsCode.marketing,
      agreedAt: '2026-01-12',
      version: 'v2',
    );

    final AgreementStatus toggled = original.copyWith(agreed: true);

    expect(toggled.agreed, isTrue);
    expect(toggled.agreedAt, '2026-01-12');
    expect(toggled.version, 'v2');
    expect(toggled.termsCode, TermsCode.marketing);
  });

  // ─── email_change_failure_reason ─────────────────────────────

  test('서버 문자열을 사유로 옮긴다', () {
    expect(
      EmailChangeFailureReason.fromServer('CODE_MISMATCH'),
      EmailChangeFailureReason.codeMismatch,
    );
    expect(
      EmailChangeFailureReason.fromServer('EXPIRED'),
      EmailChangeFailureReason.expired,
    );
    expect(
      EmailChangeFailureReason.fromServer('MAX_ATTEMPTS_EXCEEDED'),
      EmailChangeFailureReason.maxAttemptsExceeded,
    );
  });

  // 서버가 새 사유를 추가해도 화면이 깨지지 않아야 한다.
  test('모르는 값과 null은 unknown이다', () {
    expect(
      EmailChangeFailureReason.fromServer('SOMETHING_NEW'),
      EmailChangeFailureReason.unknown,
    );
    expect(
      EmailChangeFailureReason.fromServer(null),
      EmailChangeFailureReason.unknown,
    );
    expect(
      EmailChangeFailureReason.fromServer(''),
      EmailChangeFailureReason.unknown,
    );
  });

  test('대소문자를 가리지 않는다', () {
    expect(
      EmailChangeFailureReason.fromServer('code_mismatch'),
      EmailChangeFailureReason.codeMismatch,
    );
  });

  // 이 값이 "코드 화면에 머무를지 주소부터 다시 할지"를 가른다.
  test('시도 초과만 이 자리에서 재시도할 수 없다', () {
    expect(EmailChangeFailureReason.codeMismatch.canRetryHere, isTrue);
    expect(EmailChangeFailureReason.expired.canRetryHere, isTrue);
    expect(EmailChangeFailureReason.unknown.canRetryHere, isTrue);
    expect(
      EmailChangeFailureReason.maxAttemptsExceeded.canRetryHere,
      isFalse,
      reason: '남은 시도가 없는 화면에 붙잡아 두면 무엇을 눌러도 같은 오류다',
    );
  });

  // ─── nickname_validation ─────────────────────────────────────

  test('공백만 있으면 비어 있는 것으로 본다', () {
    expect(validateNickname('   '), NicknameValidation.empty);
  });

  test('앞뒤 공백을 제거한 값이 제출값이다', () {
    expect(normalizeNickname('  Traveler  '), 'Traveler');
  });

  test('최대 길이까지는 통과한다', () {
    expect(validateNickname('가' * nicknameMaxLength), NicknameValidation.ok);
  });

  test('최대 길이를 넘으면 거절한다', () {
    expect(
      validateNickname('가' * (nicknameMaxLength + 1)),
      NicknameValidation.tooLong,
    );
  });

  test('이모지는 한 글자로 센다', () {
    // UTF-16 코드 단위로 세면 2가 되어 카운터가 사용자가 보는 것과 어긋난다.
    expect(nicknameLength('😀'), 1);
  });

}
