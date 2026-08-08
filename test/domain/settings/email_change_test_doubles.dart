import 'dart:async';

import 'package:ieuri_k_trip_spot/domain/settings/model/email_change_confirmation.dart';
import 'package:ieuri_k_trip_spot/domain/settings/model/email_change_failure_reason.dart';
import 'package:ieuri_k_trip_spot/domain/settings/model/email_change_request.dart';
import 'package:ieuri_k_trip_spot/domain/settings/model/settings_failure.dart';
import 'package:ieuri_k_trip_spot/domain/settings/repository/email_change_repository.dart';

/// 이메일 변경(SPEC-0011 R7·R8) 저장소 페이크.
///
/// **검증 판정과 전송 실패를 따로 조작한다** — 실제 저장소가 그 둘을 값과 예외로
/// 갈라 놓았으므로, 페이크도 같은 방식이어야 컨트롤러의 분기를 제대로 밟는다.
class FakeEmailChangeRepository implements EmailChangeRepository {
  FakeEmailChangeRepository({this.verificationId = 'verify-1'});

  final String verificationId;

  /// 호출 기록. 재발송이 실제로 나갔는지, 몇 번 나갔는지 센다.
  final List<String> requestedEmails = <String>[];
  final List<String> confirmedCodes = <String>[];
  int resendCalls = 0;

  /// 2단계가 돌려줄 판정. null이면 성공으로 본다.
  EmailChangeFailureReason? confirmReason;

  /// 성공 시 서버가 확정했다고 할 이메일.
  String confirmedEmail = 'new@example.com';

  /// 각 메서드가 던질 실패(전송·인증 계열). 검증 판정과 구분된다.
  SettingsFailure? requestFailure;
  SettingsFailure? confirmFailure;
  SettingsFailure? resendFailure;

  /// 응답을 붙잡아 둔다 — 진행 중에 두 번 눌렀을 때를 보려면 첫 호출이 끝나기 전에
  /// 두 번째를 시작할 수 있어야 한다.
  Completer<void>? gate;

  @override
  Future<EmailChangeRequest> requestEmailChange(String newEmail) async {
    requestedEmails.add(newEmail);
    if (gate != null) await gate!.future;
    if (requestFailure != null) throw requestFailure!;
    return EmailChangeRequest(verificationId: verificationId);
  }

  @override
  Future<EmailChangeConfirmation> confirmEmailChange({
    required String verificationId,
    required String code,
  }) async {
    confirmedCodes.add(code);
    if (gate != null) await gate!.future;
    if (confirmFailure != null) throw confirmFailure!;
    final EmailChangeFailureReason? reason = confirmReason;
    return reason == null
        ? EmailChangeConfirmation.success(confirmedEmail)
        : EmailChangeConfirmation.failure(reason);
  }

  @override
  Future<EmailChangeRequest> resendEmailChange(String verificationId) async {
    resendCalls++;
    if (gate != null) await gate!.future;
    if (resendFailure != null) throw resendFailure!;
    // 서버가 새 손잡이를 줄 수 있다 — 그 경우를 재현한다.
    return EmailChangeRequest(verificationId: '$verificationId-resent');
  }
}
