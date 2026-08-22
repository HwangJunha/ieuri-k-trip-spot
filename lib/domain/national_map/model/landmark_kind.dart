/// 랜드마크를 그림으로 나타내기 위한 유형(SPEC-0030 R23·R24 보완).
///
/// 서버는 칸마다 `representativeImage`로 **실사진**과 이름(`caption`)을 준다.
/// 지도의 칸은 화면에서 20~60px이라 실사진을 넣으면 무엇인지 안 보이고 색 얼룩만
/// 남는다. 그래서 지도에는 이름에서 뽑은 유형별 **단순 도형**을 그리고, 실사진은
/// 칸을 눌렀을 때·상세 화면에서 크게 보여준다.
///
/// 실사진을 칸 모양대로 오려 넣지 않는 이유가 하나 더 있다 — 161칸 중 56칸이
/// 공공누리 제3유형(변경금지)이라 형태를 바꾸는 것이 저촉될 수 있다(POL-051).
enum LandmarkKind {
  /// 산·고개·계곡·동굴. 가장 많다.
  mountain,

  /// 사찰·성당 등 종교 건축.
  temple,

  /// 성곽·읍성·고분·유적.
  fortress,

  /// 궁궐·한옥·고택·누각.
  hanok,

  /// 해변·섬·갯벌·일출 명소.
  sea,

  /// 호수·폭포·늪·강.
  water,

  /// 숲·수목원·공원·정원.
  forest,

  /// 다리.
  bridge,

  /// 특산품·먹거리.
  food,

  /// 시장·박물관·광장 등 도심 명소.
  modern,

  /// 석탑.
  tower,
}

/// 랜드마크 이름에서 유형을 고른다.
///
/// **규칙 순서가 곧 우선순위다.** 구체적인 것을 먼저 본다 — "속리산 법주사"는
/// 산이 아니라 사찰이고, "성주 참외"는 성곽이 아니라 특산품이다.
///
/// 어디에도 걸리지 않으면 [LandmarkKind.forest]로 둔다. 자연 명소가 가장 많고
/// 무난한 그림이라 틀려도 어색함이 적다.
LandmarkKind landmarkKindOf(String caption) {
  for (final (LandmarkKind kind, RegExp pattern) in _rules) {
    if (pattern.hasMatch(caption)) return kind;
  }
  return LandmarkKind.forest;
}

/// 이름 -> 유형 규칙. 161개 실제 랜드마크 이름을 보고 만들었다.
final List<(LandmarkKind, RegExp)> _rules = <(LandmarkKind, RegExp)>[
  (
    LandmarkKind.food,
    RegExp(
      r'참외|굴비|한우|인삼|와인|녹차|고추|구기자|반시|부대찌개|망개떡|도예|매화마을|다랭이',
    ),
  ),
  (LandmarkKind.bridge, RegExp(r'대교|농다리')),
  (
    LandmarkKind.modern,
    RegExp(r'박물관|미술관|역사관|광장|거리|시장|만화|평화누리|블루로드|오백리길|보타니아'),
  ),
  (
    LandmarkKind.hanok,
    RegExp(r'한옥|민속촌|고택|서원|남루|광한루|죽서루|경포대|초당|궁$|경복궁|하회마을|사당|의암사'),
  ),
  (
    LandmarkKind.temple,
    RegExp(
      r'사$|대웅전|암$|성당|법주사|해인사|불국사|직지사|부석사|은해사|통도사|쌍계사|화엄사|금산사|백담사|월정사|태안사|대흥사|갓바위',
    ),
  ),
  (LandmarkKind.tower, RegExp(r'탑$|석탑|미륵사지|중앙탑')),
  (
    LandmarkKind.fortress,
    RegExp(r'성$|산성|읍성|고분|유적|고인돌|릉$|능$|미륵|보살|장경판전|동사지|회암사지'),
  ),
  (
    LandmarkKind.sea,
    RegExp(
      r'해수욕장|해안|섬$|갯벌|갯골|일출봉|바닷길|해맞이|왜목|영산포|화진포|청산도|한산도|독도|대부도|자라섬|백련지|오동도|삼봉',
    ),
  ),
  (
    LandmarkKind.water,
    RegExp(
      r'호수|호$|호 |폭포|계곡|늪|담$|의림지|우포|구곡|두물머리|경천대|회룡포|수승대|고석정|천$|용늪|아우라지|옥정호|담악|왕송',
    ),
  ),
  (
    LandmarkKind.mountain,
    RegExp(
      r'산$|산국립|산 국립|산도립|산 도립|천왕봉|팔영산|마이산|문경새재|소요산|수리산|금오산|주왕산|청량산|월출산|내장산|덕유산|한라산|설악산|지리산|치악산|태백산|무릉계곡|동굴|성류굴',
    ),
  ),
  (
    LandmarkKind.forest,
    RegExp(r'숲|수목원|편백|죽녹원|휴양림|정원|공원|팜랜드|갈대밭|상림|녹차밭|습지|밤하늘|벚꽃'),
  ),
];
