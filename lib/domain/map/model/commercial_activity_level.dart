/// 구역의 상업 활성도 4단계(R10). 서버 `CommercialActivityLevel`과 1:1로 맞춘다.
///
/// 혼잡도([CongestionLevel])와 **값 집합이 다른 별개의 enum이다**. 신한카드 소비
/// 데이터 기반이라 121곳 중 82곳에만 존재한다(spec §4.5).
///
/// [normal]을 단독으로 신뢰하면 안 된다 — 실측 기준선이 없는 39곳도 업스트림이 이
/// 값으로 고정 반환하므로, 실측 여부는 `isDefaulted`가 따로 말한다(R28).
enum CommercialActivityLevel {
  /// 한산한 시간대.
  quiet,

  /// 보통 시간대. **실측과 자리표시자가 같은 값으로 온다** — 구분은 `isDefaulted`가
  /// 한다.
  normal,

  /// 바쁜 시간대.
  busy,

  /// 분주한 시간대.
  peak,
}
