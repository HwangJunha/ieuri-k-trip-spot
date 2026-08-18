/// 장소 질문/답변 라우트 이름(SPEC-0026).
///
/// **왜 `common/`에 있는가.** 진입점이 장소 상세(`domain/spot`)에 있고 화면은
/// `domain/spot_qa`가 소유한다 — 이름을 쓰겠다고 서로의 `view/`를 import하면 기능 간
/// 의존이 생기므로 이름만 공용으로 올린다(CLAUDE.md §3·§4, `spot_detail_route.dart`와
/// 같은 방식이다).
///
/// 진실의 출처는 각 화면의 `routeName`이고 이 상수들이 그 값을 준다.
const String spotQuestionsRouteName = 'spotQuestions';

/// 질문 상세. `spotId`와 `questionId` 둘 다 경로 파라미터다.
const String spotQuestionDetailRouteName = 'spotQuestionDetail';

/// 질문 작성.
const String spotQaComposerRouteName = 'spotQaComposer';
