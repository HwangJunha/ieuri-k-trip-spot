import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/domain/community/model/post_body_split.dart';

/// 본문 → 제목+나머지 분해. **서버에 `Post.title`이 생기면 이 파일과 대상 함수를
/// 함께 지운다** — 그때까지 당근 카드의 굵은 제목 위계를 만드는 대역이다.
void main() {
  test('개행이 있으면 첫 줄이 제목이다', () {
    final PostBodySplit split = splitPostBody('경복궁 야간개장 후기\n한복 입고 가면 무료예요.');

    expect(split.title, '경복궁 야간개장 후기');
    expect(split.rest, '한복 입고 가면 무료예요.');
  });

  // 시드 데이터가 전부 이 모양이다 — 개행 없이 문장으로만 이어진 한 덩어리.
  test('개행이 없으면 첫 문장이 제목이다', () {
    final PostBodySplit split = splitPostBody('경복궁은 매주 화요일 휴무예요. 헛걸음하지 마세요.');

    expect(split.title, '경복궁은 매주 화요일 휴무예요.');
    expect(split.rest, '헛걸음하지 마세요.');
  });

  test('영어 문장도 같은 규칙으로 갈린다', () {
    final PostBodySplit split = splitPostBody(
      'Night opening was great! Wear a hanbok for free entry.',
    );

    expect(split.title, 'Night opening was great!');
    expect(split.rest, 'Wear a hanbok for free entry.');
  });

  // 한 문장뿐이면 가르는 의미가 없다 — 제목만 있고 본문이 빈 카드가 되면 위계가
  // 오히려 어색하다.
  test('한 문장뿐이면 제목을 두지 않고 본문으로만 그린다', () {
    final PostBodySplit split = splitPostBody('청계천 야경 좋아요.');

    expect(split.title, isEmpty);
    expect(split.rest, '청계천 야경 좋아요.');
  });

  test('종결부호가 없는 한 덩어리도 본문으로만 그린다', () {
    final PostBodySplit split = splitPostBody('인사동에서 기념품 살 만한 가게 추천');

    expect(split.title, isEmpty);
    expect(split.rest, '인사동에서 기념품 살 만한 가게 추천');
  });

  // 제목만 세 줄이 되는 것을 막는다.
  test('첫 조각이 너무 길면 제목으로 쓰지 않는다', () {
    final String long = '${'가' * 60}. 나머지 문장이다.';

    final PostBodySplit split = splitPostBody(long);

    expect(split.title, isEmpty);
    expect(split.rest, long);
  });

  // 소수점이 문장을 가르면 "주차비는 3."이 제목이 된다.
  test('소수점은 문장 경계가 아니다', () {
    final PostBodySplit split = splitPostBody('입장료는 3.5달러입니다. 현금만 받아요.');

    expect(split.title, '입장료는 3.5달러입니다.');
    expect(split.rest, '현금만 받아요.');
  });

  test('빈 본문에서도 터지지 않는다', () {
    expect(splitPostBody('').title, isEmpty);
    expect(splitPostBody('   ').rest, isEmpty);
  });

  // 캐주얼한 한국어 글에서 이모지는 마침표 자리를 대신한다. 라이브 시드 9건 중
  // 4건이 종결부호 없이 이모지로만 끊긴다 — 이 규칙이 없으면 그 글들은 제목 없이
  // 본문만 나온다.
  group('이모지 경계', () {
    test('종결부호가 없으면 첫 이모지가 경계다', () {
      final PostBodySplit split = splitPostBody('청계천 야경 🌃 여름 밤에 시원해요.');

      expect(split.title, '청계천 야경 🌃');
      expect(split.rest, '여름 밤에 시원해요.');
    });

    test('연달아 오는 이모지는 함께 삼킨다', () {
      final PostBodySplit split = splitPostBody('해운대 같이 가실 분 🌊🚗 대중교통으로 갑니다');

      expect(split.title, '해운대 같이 가실 분 🌊🚗');
      expect(split.rest, '대중교통으로 갑니다');
    });

    // 맨 앞의 이모지를 경계로 삼으면 제목이 비어 버린다.
    test('맨 앞의 이모지는 경계가 아니다', () {
      final PostBodySplit split = splitPostBody('🌊 해운대 같이 가실 분');

      expect(split.title, isEmpty);
      expect(split.rest, '🌊 해운대 같이 가실 분');
    });

    // 앞뒤가 공백이어야 경계다 — 단어에 붙은 이모지는 문장을 가르지 않는다.
    test('단어에 붙은 이모지는 경계가 아니다', () {
      final PostBodySplit split = splitPostBody('경복궁🌙야간개장 다녀왔어요');

      expect(split.title, isEmpty);
      expect(split.rest, '경복궁🌙야간개장 다녀왔어요');
    });

    // 종결부호가 먼저 걸리면 이모지는 보지 않는다(순서가 있다).
    test('종결부호가 있으면 그쪽이 우선한다', () {
      final PostBodySplit split = splitPostBody('덕수궁 좋아요. 저녁 조명이 예뻐요 ✨');

      expect(split.title, '덕수궁 좋아요.');
      expect(split.rest, '저녁 조명이 예뻐요 ✨');
    });

    test('이모지 뒤에 아무것도 없으면 가르지 않는다', () {
      final PostBodySplit split = splitPostBody('경복궁 야간개장 다녀왔어요 🌙');

      expect(split.title, isEmpty);
      expect(split.rest, '경복궁 야간개장 다녀왔어요 🌙');
    });
  });

  // 이모지가 든 본문에서 substring 경계가 깨지면 여기서 드러난다.
  test('이모지가 섞여도 문장 경계를 지킨다', () {
    final PostBodySplit split = splitPostBody(
      '덕수궁 돌담길 산책하기 좋아요 ✨. 저녁 조명이 예뻐요 🌙',
    );

    expect(split.title, '덕수궁 돌담길 산책하기 좋아요 ✨.');
    expect(split.rest, '저녁 조명이 예뻐요 🌙');
  });
}
