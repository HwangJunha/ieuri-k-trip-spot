/// 관광지 분류(SPEC-0020 R11). **enum이 아니라 값 객체다.**
///
/// 예전에는 서버 enum과 1:1로 맞춘 로컬 enum이었으나, 서버가 앱 업데이트 없이
/// 카테고리를 늘릴 수 있어야 하므로 값 집합을 클라이언트가 고정하지 않는다(AC1.3).
/// enum으로 두면 서버가 새 값을 추가할 때 파싱이 깨지거나 `unknown`으로 흘러
/// 조용히 사라진다 — 그 경로를 없애는 것이 이 전환의 목적이다.
///
/// - [code]가 안정 식별자다. 비교·필터·전송·라우팅은 **전부 이 값**으로 한다.
/// - [label]은 서버가 활성 언어로 준 표시 문구다. 클라이언트가 번역하지 않는다
///   (l10n `discoverCategory*` 키와 `spotCategoryLabel()`은 이 전환으로 제거됐다).
/// - [iconUrl]은 현재 전 카테고리가 null이라, 실제로는 `code` 기반 Material 아이콘
///   폴백이 쓰인다(AC11.5).
///
/// **동등성은 [code]만 본다.** Riverpod family 인자로 쓰이므로(swipe·likedSpots·
/// spotDetail 컨트롤러) 같은 카테고리를 가리키는 두 인스턴스가 같은 provider를
/// 가리켜야 한다. `label`은 언어에 따라 달라지므로 동등성에 넣으면 언어 전환 시
/// 같은 카테고리가 다른 family 키가 된다.
class SpotCategory {
  const SpotCategory({
    required this.code,
    required this.label,
    this.iconUrl,
  });

  /// 서버가 준 코드만 있고 표시 문구가 없을 때(라우팅 복원 등) 쓴다.
  ///
  /// 라우터는 동기이고 카테고리 목록은 서버에서 비동기로 오므로, URL의 `code`만으로
  /// 인스턴스를 만들어야 하는 자리가 있다. 표시가 필요 없는 경로에서만 쓴다 —
  /// 화면에 라벨을 그려야 하면 목록 provider에서 온 인스턴스를 써야 한다.
  const SpotCategory.ofCode(this.code) : label = code, iconUrl = null;

  /// 안정 식별자(`TOURIST_SPOT` 등). 서버 값을 그대로 담으며 클라이언트가 해석하지
  /// 않는다 — 모르는 코드도 버리지 않고 그대로 통과시킨다(AC1.3).
  final String code;

  /// 활성 언어의 표시 문구. 서버가 준 값을 그대로 그린다(POL-023).
  final String label;

  /// 서버 제공 아이콘. null이면 [code] 기반 Material 아이콘으로 떨어진다(AC11.5).
  final String? iconUrl;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is SpotCategory && other.code == code);

  @override
  int get hashCode => code.hashCode;

  @override
  String toString() => 'SpotCategory($code)';
}

/// 기본 선택 카테고리의 코드(R4). 목록에 이 코드가 없으면 목록의 첫 값으로
/// 떨어진다(AC4.2) — 언어에 따라 가용 목록이 다르기 때문이다.
const String kDefaultSpotCategoryCode = 'TOURIST_SPOT';

/// 축제 카테고리 코드. `domain/event`가 축제를 상세로 열 때 쓴다.
const String kFestivalEventCategoryCode = 'FESTIVAL_EVENT';
