import 'auth_session.dart';

/// 토큰 갱신 시도의 결과를 세 갈래로 나눈 값(SPEC-0005 §2.2).
///
/// R9(세션 종료)와 R10(세션 유지)이 정반대의 처리를 요구하므로, "서버가
/// refreshToken을 거부함"과 "네트워크가 끊김"을 하나로 뭉개면 두 요구사항 중 하나는
/// 반드시 위반된다. 이 타입이 그 분기를 타입 수준에서 강제한다.
sealed class RefreshOutcome {
  const RefreshOutcome();
}

/// 갱신 성공 — 새 토큰 쌍을 받았다. accessToken과 refreshToken을 함께 기록하고
/// 이전 값을 남기지 않는다(R12, AC-30).
class RefreshSucceeded extends RefreshOutcome {
  const RefreshSucceeded(this.session);

  final AuthSession session;
}

/// 서버가 refreshToken을 거부했다(E3·E4) — 토큰을 제거하고 세션을 종료한다
/// (R9·R11). 재사용 감지(E4)도 동일하게 처리한다.
class RefreshRejected extends RefreshOutcome {
  const RefreshRejected();
}

/// 서버에 닿지 못했다(E5) — 토큰을 **유지**한 채 오류만 전파한다(R10). 복구 후
/// 재시도 시 보관된 refreshToken으로 갱신이 성공해야 한다(AC-29).
class RefreshUnavailable extends RefreshOutcome {
  const RefreshUnavailable();
}
