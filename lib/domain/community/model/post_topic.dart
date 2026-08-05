/// 게시글의 주제 태그(SPEC-0010). 안정 식별자이며 **표시 문자열은 클라이언트가
/// l10n으로 매핑한다** — 서버는 표시명을 내려주지 않는다(가이드 §10, POL-023).
/// `SpotCategory`와 같은 방식이다.
///
/// 값 집합은 서버 `PostTopic` enum과 1:1이다: QUESTION / TIP / REVIEW / COMPANION /
/// PHOTO. 순수 도메인 enum — flutter·graphql·riverpod 의존 없음.
enum PostTopic { question, tip, review, companion, photo }

/// 게시글이 달린 대상의 종류(서버 `PostTargetType`).
///
/// **지금은 `SPOT` 하나뿐이지만 값으로 다룬다** — 커뮤니티는 관광지 전용이 아니라
/// 플랫폼이고 상품 등이 붙을 자리가 열려 있다(가이드 §1). 하드코딩하지 않는다.
enum PostTargetType { spot }
