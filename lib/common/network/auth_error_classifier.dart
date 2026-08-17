import 'package:graphql_flutter/graphql_flutter.dart';

/// GraphQL 응답이 어떤 종류의 실패인지 나타내는 분류 결과(SPEC-0005 §2.2).
///
/// 분류만 밖으로 나가고 서버 원본 message는 절대 나가지 않는다(POL-013). 원본
/// message에는 서버 패키지 경로와 예외 클래스명이 그대로 들어 있으므로, 이 enum이
/// 도메인 계층이 볼 수 있는 유일한 값이다.
enum AuthErrorClass {
  /// 인증 실패 — accessToken이 만료/무효. 갱신을 트리거해야 한다(E1·E2, R4·R5).
  ///
  /// 서버의 `UNAUTHENTICATED`와 `INVALID_TOKEN`이 모두 여기로 온다. 둘 다 갱신으로
  /// 회복될 수 있는 상태이고, 갱신이 실패하면 그때 [refreshRejected]로 넘어간다.
  unauthenticated,

  /// 갱신 거부 — refreshToken 자체가 무효하다. 토큰을 제거하고 세션을 종료해야
  /// 한다(E3, R9·R11).
  refreshRejected,

  /// 재사용 감지 — 회원의 모든 refresh가 폐기됐다(SPEC-0024 §6, E4).
  ///
  /// **[refreshRejected]와 나눈다.** 결과는 둘 다 세션 종료지만, 이쪽은 **재발급을
  /// 시도해서는 안 되는** 상태다. 뭉개 두면 갱신 링크가 회복 불가능한 상태에서
  /// 갱신을 계속 시도한다. 서버가 이번에 코드를 붙여 주기 전에는 구분할 수 없었다.
  tokenReuseDetected,

  /// 이메일 인증을 마치지 않은 회원의 비허용 호출(SPEC-0024 §2). 인증 화면으로
  /// 보내는 신호다 — 토큰은 유효하므로 갱신하거나 지우면 안 된다.
  emailNotVerified,

  /// 권한 없음. 인증은 됐으나 이 오퍼레이션을 부를 자격이 없다.
  forbidden,

  /// 전송 실패 — 네트워크가 끊겼거나 서버에 닿지 못함. 토큰을 유지한 채 오류만
  /// 전파한다(E5, R10).
  transport,

  /// 위 어느 것도 아님 — 실패가 아니거나 도메인 수준에서 처리할 응답.
  none,
}

/// 서버가 인증 실패를 알리는 `errorType` 값(E2). 서버가 정리되면 이 값만 남고
/// [_unauthorizedMessageMarkers] 분기는 제거된다.
const String _unauthenticatedErrorType = 'UNAUTHENTICATED';

/// 서버가 아직 인증 실패를 `INTERNAL`로 내려보내는 동안의 임시 판별 근거(E1, AC-14).
/// message에 노출된 예외 클래스명을 본다. `ieuri-server#26`이 닫히면 이 목록과
/// 이를 쓰는 분기를 함께 제거한다(SPEC-0005 §5).
const List<String> _unauthorizedMessageMarkers = <String>[
  'UnauthorizedException',
  'ExpiredJwtException',
];

/// refreshToken이 거부됐음을 알리는 서버 예외 클래스명(E3·E4). 재사용 감지(E4)도
/// 동일하게 세션 종료로 처리한다 — 사용자에게 다른 안내를 하지 않는 것은 의도된
/// 선택이다(SPEC-0005 §2.2).
const List<String> _refreshRejectedMessageMarkers = <String>[
  'TokenReuseDetectedException',
  'InvalidRefreshTokenException',
  'RefreshTokenNotFoundException',
];

/// `errorType`이 `INTERNAL`일 때만 message 매칭으로 내려간다(AC-14). 그 외
/// errorType은 message를 보지 않는다.
const String _internalErrorType = 'INTERNAL';

/// GraphQL 응답 하나를 세 갈래 실패 분류로 판별한다(SPEC-0005 §2.1).
///
/// 판별 순서는 E2를 먼저 본다 — `errorType == "UNAUTHENTICATED"`이면 message를
/// 보지 않고 확정하고(AC-15), 아니면 `INTERNAL` + message 매칭으로 내려간다
/// (AC-14). 서버가 정리되면 아래 분기만 지우면 되도록 순서를 잡았다.
///
/// [extensions]나 [errorType]이 없는 응답에서도 예외가 나지 않는다(AC-17).
AuthErrorClass classifyGraphqlErrors(List<GraphQLError> errors) {
  for (final GraphQLError error in errors) {
    final AuthErrorClass classified = _classifyOne(error);
    if (classified != AuthErrorClass.none) return classified;
  }
  return AuthErrorClass.none;
}

AuthErrorClass _classifyOne(GraphQLError error) {
  final Map<String, dynamic>? extensions = error.extensions;

  // 1) 정본 — `extensions.code`(SPEC-0024 §6). 서버가 최상위 오류 5종에 코드를
  //    붙여 주므로 message를 볼 필요가 없다. 이 분기가 아래 문자열 매칭을 대체한다.
  final Object? codeRaw = extensions?['code'];
  if (codeRaw is String) {
    final AuthErrorClass? byCode = _classifyByCode(codeRaw);
    if (byCode != null) return byCode;
  }

  final Object? errorTypeRaw =
      extensions?['errorType'] ?? extensions?['classification'];
  final String? errorType = errorTypeRaw is String ? errorTypeRaw : null;

  // 2) E2 — errorType이 확정적이면 message를 보지 않는다(AC-15).
  if (errorType == _unauthenticatedErrorType) {
    return AuthErrorClass.unauthenticated;
  }

  // 3) 폴백 — 코드가 붙지 않은 경로가 남아 있다. `retargetEmailVerification`의
  //    미인증 호출이 지금도 코드 없이 `errorType: INTERNAL`로 온다(라이브 확인).
  //    errorType이 아예 없는 응답도 포함한다(AC-17: null 안전).
  if (errorType == null || errorType == _internalErrorType) {
    final String message = error.message;
    if (_containsAny(message, _refreshRejectedMessageMarkers)) {
      return AuthErrorClass.refreshRejected;
    }
    if (_containsAny(message, _unauthorizedMessageMarkers)) {
      return AuthErrorClass.unauthenticated;
    }
  }
  return AuthErrorClass.none;
}

/// 서버의 최상위 오류 코드를 분류로 옮긴다(SPEC-0024 §6의 5종).
///
/// 아는 코드가 아니면 `null`을 돌려줘 호출자가 다음 판별로 내려가게 한다 — 여기서
/// [AuthErrorClass.none]을 반환하면 코드가 붙은 다른 실패까지 삼켜 버린다.
AuthErrorClass? _classifyByCode(String code) => switch (code) {
  'UNAUTHENTICATED' => AuthErrorClass.unauthenticated,
  // 서명·만료·타입 불일치 — 갱신으로 회복될 수 있다.
  'INVALID_TOKEN' => AuthErrorClass.unauthenticated,
  // 재사용 감지 — 갱신으로 회복되지 않는다. 반드시 위와 구분한다.
  'TOKEN_REUSE_DETECTED' => AuthErrorClass.tokenReuseDetected,
  'EMAIL_NOT_VERIFIED' => AuthErrorClass.emailNotVerified,
  'FORBIDDEN' => AuthErrorClass.forbidden,
  _ => null,
};

bool _containsAny(String message, List<String> markers) =>
    markers.any(message.contains);

/// [QueryResult] 하나를 분류한다. `errors[]`가 채워져 있으면 그 내용으로 판별하고,
/// `errors[]` 없이 `linkException`만 있으면 전송 실패다(E5).
///
/// GraphQL은 실패해도 HTTP 200을 돌려주므로 `errors` 배열이 판별의 출발점이다
/// (CLAUDE.md §4).
AuthErrorClass classifyQueryResult(QueryResult<Object?> result) {
  final OperationException? exception = result.exception;
  if (exception == null) return AuthErrorClass.none;

  final List<GraphQLError> errors = exception.graphqlErrors;
  if (errors.isNotEmpty) {
    final AuthErrorClass classified = classifyGraphqlErrors(errors);
    // errors[]가 있으나 인증과 무관한 실패도 전송 실패로 다룬다 — 토큰은 건드리지
    // 않고 오류만 전파한다(R10).
    return classified == AuthErrorClass.none
        ? AuthErrorClass.transport
        : classified;
  }

  // E5 — linkException만 존재(네트워크 끊김/서버 도달 실패).
  if (exception.linkException != null) return AuthErrorClass.transport;
  return AuthErrorClass.none;
}
