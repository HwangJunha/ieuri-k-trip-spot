/// 스팟 데이터 접근 실패(SPEC-0002). repository가 전송/도메인 오류를 이 값으로
/// 번역해 provider·UI에 넘긴다 — 서버 코드 문자열을 UI로 직접 흘리지 않는다
/// (POL-016 대비). 순수 도메인.
class SpotFailure implements Exception {
  const SpotFailure(this.kind, {this.code});

  /// 전송 오류(네트워크·서버 도달 불가·top-level errors).
  static const SpotFailure network = SpotFailure(SpotFailureKind.network);

  /// 예상치 못한 응답(데이터 없음·형태 불일치).
  static const SpotFailure unknown = SpotFailure(SpotFailureKind.unknown);

  final SpotFailureKind kind;

  /// 뮤테이션 userErrors의 서버 코드(있으면). 로깅·분기용이며 UI엔 노출하지 않는다.
  final String? code;

  @override
  String toString() => 'SpotFailure($kind${code == null ? '' : ', $code'})';
}

enum SpotFailureKind { network, userError, unknown }
