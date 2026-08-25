/// 로딩 중 뼈대를 그리기 위한 더미 질문·답변. **화면에 값이 보이지는 않는다** —
/// `AppSkeleton`이 텍스트와 이미지를 뼈대로 덮으므로 글자 수만 레이아웃에 남는다.
///
/// ## 왜 값이 이렇게 생겼는가
///
/// - `thumbnailImageUrl`이 **빈 문자열**, `profileImageUrl`이 **null**이다.
///   `SpotThumbnail`은 `http`로 시작하지 않는 값을 색블록으로 폴백하고
///   `SpotQaAuthorLine`은 null 아바타를 이니셜로 대체하므로, 뼈대가 네트워크
///   요청을 내지 않는다. 가짜 URL을 넣으면 로딩 화면이 실패할 요청을 쏘아 댄다.
/// - `photoKeys`가 비어 있다. 첨부가 있으면 `SpotQaPhotos`가 CDN 사진을 받으러
///   가는데, 뼈대는 그럴 이유가 없다.
/// - `createdAt`이 **고정 날짜**다. `DateTime.now()`를 쓰면 상대시각 문구가
///   프레임마다 달라져 뼈대가 깜빡인다.
/// - 본문 길이가 제각각이다. 전부 같은 길이면 뼈대가 표처럼 보여 부자연스럽다.
library;

import '../../../common/model/post_author.dart';
import '../../../common/model/post_spot.dart';
import 'spot_answer.dart';
import 'spot_question.dart';

/// 뼈대의 시간 기준. 상대시각이 매 프레임 바뀌지 않도록 고정한다.
final DateTime _fixedNow = DateTime.utc(2026, 8, 1);

const PostAuthor _author = PostAuthor(
  id: '_skeleton_author',
  nickname: '여행자',
  // 아바타는 네트워크를 타지 않도록 비운다 — null이면 이니셜로 그린다.
  profileImageUrl: null,
);

const PostSpot _spot = PostSpot(
  id: '_skeleton_spot',
  title: '경복궁 근정전',
  thumbnailImageUrl: '',
);

SpotQuestion _question({
  required String id,
  required String body,
  required int answerCount,
  bool resolved = false,
}) => SpotQuestion(
  id: id,
  spot: _spot,
  body: body,
  author: _author,
  resolved: resolved,
  answerCount: answerCount,
  createdAt: _fixedNow,
);

/// 질문 목록용. 본문 길이를 달리해 3줄·2줄·1줄이 섞이게 한다.
final List<SpotQuestion> spotQuestionSkeletonSamples = <SpotQuestion>[
  _question(
    id: '_skeleton_q0',
    body: '주차장이 따로 있나요? 주말 오후에 방문할 예정인데 근처에 차를 댈 곳이 있는지 궁금합니다.',
    answerCount: 3,
  ),
  _question(
    id: '_skeleton_q1',
    body: '입장권은 현장에서 살 수 있나요?',
    answerCount: 1,
  ),
  _question(
    id: '_skeleton_q2',
    body: '야간 개장은 몇 시까지 하는지 알고 싶습니다. 사진 찍기 좋은 시간대도 알려주세요.',
    answerCount: 5,
    resolved: true,
  ),
];

/// 질문 목록 뼈대 한 칸. 목록이 같은 카드를 반복하므로 하나만 있으면 된다.
final SpotQuestion spotQuestionSkeletonSample = spotQuestionSkeletonSamples.first;

/// 「내 질문」 목록용. `hasNewAnswers`가 참인 항목을 하나 두어 배지 자리도 뼈대에
/// 잡히게 한다 — 배지가 있고 없고에 따라 줄 폭이 달라진다.
final List<MyQuestionItem> myQuestionSkeletonSamples = <MyQuestionItem>[
  MyQuestionItem(question: spotQuestionSkeletonSamples[0], seenAnswerCount: 1),
  MyQuestionItem(question: spotQuestionSkeletonSamples[1], seenAnswerCount: 1),
  MyQuestionItem(question: spotQuestionSkeletonSamples[2], seenAnswerCount: 5),
];

/// 답변 목록용(질문 상세의 인라인 로딩).
final List<SpotAnswer> spotAnswerSkeletonSamples = <SpotAnswer>[
  SpotAnswer(
    id: '_skeleton_a0',
    questionId: '_skeleton_q0',
    body: '주차장은 동편 주차장을 쓰시면 됩니다. 주말 오후에는 자리가 금방 차니 대중교통을 권합니다.',
    author: _author,
    createdAt: _fixedNow,
  ),
  SpotAnswer(
    id: '_skeleton_a1',
    questionId: '_skeleton_q0',
    body: '근처 공영주차장도 있어요.',
    author: _author,
    createdAt: _fixedNow,
  ),
];
