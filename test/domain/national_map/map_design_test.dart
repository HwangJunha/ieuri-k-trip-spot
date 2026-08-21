import 'dart:convert';
import 'dart:io';
import 'dart:ui' show Color;

import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/domain/national_map/model/landmark_kind.dart';
import 'package:ieuri_k_trip_spot/domain/national_map/component/province_palette.dart';

/// 서버가 실제로 주는 161개 랜드마크 이름. 분류가 이 목록을 덮는지 확인한다.
///
/// 라이브 서버에서 받아 고정해 둔 값이다 — 테스트가 서버에 의존하면 안 된다.
const List<String> _realCaptions = <String>[
  '경복궁', '광안대교', '서문시장', '강화 고인돌 유적', '5·18 민주광장',
  '대청호오백리길', '태화강 국가정원', '세종호수공원', '행주산성', '한국만화박물관',
  '율동공원', '수원화성', '대부도', '안양예술공원', '한국민속촌',
  '의정부 부대찌개 거리', '광명동굴', '평택호 관광단지', '소요산', '서울대공원',
  '동구릉', '다산 정약용 유적지', '물향기수목원', '시흥갯골생태공원', '수리산',
  '왕송호수', '하남 동사지', '임진각 평화누리', '이천 도예촌', '안성팜랜드',
  '김포 장릉', '융건릉', '남한산성', '양주 회암사지', '한탄강 유네스코 세계지질공원',
  '여주 영릉', '재인폭포', '자라섬', '두물머리', '청주 상당산성',
  '충주 탑평리 칠층석탑 (중앙탑)', '제천 의림지', '속리산 법주사', '부소담악', '영동 와인',
  '좌구산자연휴양림', '진천 농다리', '괴산 화양구곡', '감곡매괴성모순례지성당', '도담삼봉',
  '유관순 열사 유적', '공산성', '대천해수욕장', '현충사', '해미읍성',
  '관촉사 석조미륵보살입상', '사계고택 (은농재)', '왜목마을', '금산 인삼', '부소산성',
  '신성리 갈대밭', '청양 고추·구기자', '홍주읍성', '수덕사 대웅전', '태안해안국립공원',
  '목포근대역사관', '오동도', '순천만습지', '나주 영산포', '광양 매화마을',
  '죽녹원', '태안사', '화엄사', '팔영산', '보성 녹차밭',
  '화순 고인돌 유적', '정남진 편백숲 우드랜드', '다산초당', '대흥사', '월출산국립공원',
  '회산 백련지', '함평 한우', '영광 굴비', '축령산 편백숲', '청산도',
  '진도 신비의 바닷길', '신안 갯벌', '호미곶 해맞이광장', '불국사', '직지사',
  '하회마을', '금오산 도립공원', '부석사', '은해사', '경천대',
  '문경새재', '갓바위(관봉 석조여래좌상)', '금성산 고분군', '주왕산 국립공원',
  '영양국제밤하늘보호공원', '영덕 블루로드', '청도 반시', '지산동 고분군', '성주 참외',
  '가실성당', '회룡포', '청량산 도립공원', '성류굴', '독도',
  '진해 군항제 벚꽃길(여좌천)', '진주성', '한산도', '삼천포대교', '대성동 고분군',
  '영남루', '외도 보타니아', '통도사', '의령 망개떡', '말이산 고분군',
  '우포늪', '상족암 군립공원', '가천 다랭이마을', '쌍계사', '지리산 국립공원 천왕봉',
  '함양 상림', '수승대', '해인사 장경판전', '한라산국립공원', '성산일출봉',
  '남이섬', '치악산 국립공원', '강릉 경포대', '무릉계곡', '태백산 국립공원',
  '설악산 국립공원', '삼척 죽서루', '수타사', '횡성호수길', '장릉',
  '월정사', '아우라지', '고석정', '화천천', '대암산 용늪',
  '백담사', '화진포', '낙산사 의상대와 홍련암', '전주한옥마을', '군산 근대역사문화거리',
  '미륵사지', '내장산국립공원', '광한루원', '금산사', '오성한옥마을',
  '마이산', '덕유산국립공원', '논개사당(의암사)', '옥정호·붕어섬', '강천산군립공원',
  '고창 고인돌 유적', '변산반도국립공원',
];

void main() {
  group('랜드마크 유형 분류', () {
    test('구체적인 규칙이 일반 규칙을 이긴다', () {
      // "속리산 법주사"는 산이 아니라 사찰이다 — 순서가 뒤집히면 산이 된다.
      expect(landmarkKindOf('속리산 법주사'), LandmarkKind.temple);
      // "성주 참외"는 성곽이 아니라 특산품이다.
      expect(landmarkKindOf('성주 참외'), LandmarkKind.food);
      // "수원화성"은 성곽이다.
      expect(landmarkKindOf('수원화성'), LandmarkKind.fortress);
    });

    test('대표적인 이름이 기대한 유형으로 간다', () {
      expect(landmarkKindOf('경복궁'), LandmarkKind.hanok);
      expect(landmarkKindOf('광안대교'), LandmarkKind.bridge);
      expect(landmarkKindOf('서문시장'), LandmarkKind.modern);
      expect(landmarkKindOf('설악산 국립공원'), LandmarkKind.mountain);
      expect(landmarkKindOf('대천해수욕장'), LandmarkKind.sea);
      expect(landmarkKindOf('재인폭포'), LandmarkKind.water);
      expect(landmarkKindOf('죽녹원'), LandmarkKind.forest);
      expect(landmarkKindOf('불국사'), LandmarkKind.temple);
      expect(landmarkKindOf('강화 고인돌 유적'), LandmarkKind.fortress);
      expect(landmarkKindOf('영광 굴비'), LandmarkKind.food);
    });

    test('실제 161개 이름이 전부 분류된다', () {
      // 분류가 안 되면 폴백으로 가는데, 폴백이 과하게 많으면 규칙이 부실한 것이다.
      expect(_realCaptions, hasLength(161));

      final Map<LandmarkKind, int> counts = <LandmarkKind, int>{};
      for (final String caption in _realCaptions) {
        final LandmarkKind kind = landmarkKindOf(caption);
        counts[kind] = (counts[kind] ?? 0) + 1;
      }

      // 한 유형이 전체의 3분의 1을 넘으면 그림이 단조로워진다.
      for (final MapEntry<LandmarkKind, int> e in counts.entries) {
        expect(
          e.value,
          lessThan(_realCaptions.length ~/ 3),
          reason: '${e.key}가 너무 많다 — 규칙을 더 나눠야 한다',
        );
      }
      // 유형이 골고루 쓰여야 알록달록하다.
      expect(counts.keys.length, greaterThanOrEqualTo(9));
    });

    test('빈 이름도 터지지 않는다', () {
      expect(landmarkKindOf(''), isA<LandmarkKind>());
    });
  });

  group('시도별 색', () {
    test('17개 시도에 색이 있다', () {
      expect(ProvincePalette.definedCount, 17);
    });

    test('모르는 시도 코드는 폴백이다', () {
      const Color fallback = Color(0xFF123456);
      expect(ProvincePalette.of('99', fallback: fallback), fallback);
    });

    test('색이 서로 다르다', () {
      // 같은 색이 둘이면 인접 시도가 구분되지 않을 수 있다.
      const List<String> codes = <String>[
        '11', '26', '27', '28', '29', '30', '31', '36',
        '41', '43', '44', '46', '47', '48', '50', '51', '52',
      ];
      final Set<int> used = <int>{
        for (final String c in codes)
          ProvincePalette.of(c, fallback: const Color(0xFF000000)).toARGB32(),
      };

      expect(used, hasLength(codes.length));
    });

    test('맞닿은 시도끼리 계열이 다르다', () {
      // 경기(41)–강원(51)–충북(43)은 서로 접한다. 색상 거리가 충분해야 한다.
      const Color black = Color(0xFF000000);
      final Color gyeonggi = ProvincePalette.of('41', fallback: black);
      final Color gangwon = ProvincePalette.of('51', fallback: black);
      final Color chungbuk = ProvincePalette.of('43', fallback: black);

      // 임계 50은 실측으로 정했다 — 이보다 가까우면 지도에서 두 시도가
      // 한 덩어리로 보인다(경북·경남이 9였을 때 실제로 그랬다).
      expect(_distance(gyeonggi, gangwon), greaterThan(50));
      expect(_distance(gyeonggi, chungbuk), greaterThan(50));
      expect(_distance(gangwon, chungbuk), greaterThan(50));
    });
  });

  group('경계 자산이 리포에 있다', () {
    test('판정용 원본이 유효한 GeoJSON이다', () {
      // 자산이 빠지면 앱이 지도를 아예 못 그린다.
      final File f = File('asset/geo/district-boundaries.geojson');
      expect(f.existsSync(), isTrue);

      final Map<String, dynamic> d =
          json.decode(f.readAsStringSync()) as Map<String, dynamic>;
      expect((d['features'] as List).length, 252);
    });

    test('직접 만든 칸 도형 자산은 더 이상 없다', () {
      // 묶음 규칙은 서버 소유다. 자산을 되살리면 코드 체계가 다시 어긋난다.
      expect(File('asset/geo/korea_cells.json').existsSync(), isFalse);
    });
  });
}

/// 두 색의 RGB 거리. 계열이 갈렸는지 보는 거친 잣대다.
double _distance(Color a, Color b) {
  final int dr = ((a.r - b.r) * 255).round();
  final int dg = ((a.g - b.g) * 255).round();
  final int db = ((a.b - b.b) * 255).round();
  return (dr * dr + dg * dg + db * db).toDouble() / 255;
}
