/// 서버가 계산한 미터 거리(POL-024: 콘텐츠는 서버)를 클라이언트가 표시용 숫자로
/// 다듬는 순수 값. 단위 문구("km"/"キロ" 등)는 l10n 키가 담당하고, 이 클래스는
/// **숫자 부분만** 만든다 — 표시 포맷은 클라이언트 책임이되 언어 문구는 위젯이
/// l10n으로 붙인다.
///
/// 순수 도메인: flutter/intl 미의존. 소수 자리 규칙만 담는다.
class Distance {
  const Distance(this.meters);

  /// 서버 계산 미터 거리(음수 없음 가정).
  final int meters;

  /// 킬로미터 실수값.
  double get kilometers => meters / 1000;

  /// 1km 미만이면 미터 단위가 더 자연스러운지 여부. 위젯이 km/m 문구를 고르는 데 쓴다.
  bool get isSubKilometer => meters < 1000;

  /// 표시용 km 숫자 문자열(소수 1자리). 예: 1234m → "1.2".
  String get kilometersLabel => kilometers.toStringAsFixed(1);

  /// 표시용 m 숫자 문자열(정수). 예: 850m → "850".
  String get metersLabel => '$meters';

  @override
  bool operator ==(Object other) => other is Distance && other.meters == meters;

  @override
  int get hashCode => meters.hashCode;
}
