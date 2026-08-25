/// 로딩 중 뼈대를 그리기 위한 더미 글들. **화면에 값이 보이지는 않는다** —
/// `AppSkeleton`이 텍스트와 이미지를 뼈대로 덮으므로 글자 수만 레이아웃에 남는다.
///
/// ## 왜 커뮤니티의 더미를 가져다 쓰지 않는가
///
/// [Post]는 `common/model/`에 있어 두 기능이 함께 쓰지만, **더미 목록은 화면 전용
/// 표시 데이터라 기능이 각자 갖는다.** 커뮤니티의 파일을 import하면 기능 간 의존이
/// 생기고(CLAUDE.md §3), `common/`으로 올리자니 두 화면의 행 배치가 달라 필요한
/// 값도 다르다 — 여기는 작성자 줄이 없고 카테고리·장소가 윗줄로 올라온다.
///
/// ## 왜 값이 이렇게 생겼는가
///
/// - `photoKeys`가 **비어 있다.** `MyPostRow`가 키가 있을 때만 썸네일을 그리므로,
///   비워 두면 뼈대가 이미지 요청을 한 건도 내지 않는다. 가짜 키를 넣으면 로딩
///   화면이 실패할 요청을 쏘아 댄다.
/// - `createdAt`이 **고정된 날짜다.** `DateTime.now()`를 쓰면 상대 시각 문구가
///   프레임마다 달라져 뼈대가 깜빡인다.
library;

import '../../../common/model/post.dart';
import '../../../common/model/post_author.dart';
import '../../../common/model/target_category.dart';

final DateTime _createdAt = DateTime.utc(2026, 8, 1, 9);

/// 내 글 목록이라 작성자는 화면에 그려지지 않는다 — 모델이 요구해 채울 뿐이다.
const PostAuthor _author = PostAuthor(id: '_skeleton_me', nickname: 'Me');

/// 내가 쓴 글 목록의 더미. 호출부는 `index % length`로 골라 길이가 제각각인 행을
/// 만든다.
final List<Post> myPostSkeletonSamples = <Post>[
  Post(
    id: '_skeleton_my_post_0',
    title: '광장시장 빈대떡 후기',
    body: '녹두 갈아 부친 빈대떡을 막걸리와 함께. 줄이 길어도 회전이 빨라 오래 기다리지 않았다.',
    category: TargetCategory.restaurant,
    author: _author,
    createdAt: _createdAt,
    likeCount: 12,
    commentCount: 4,
    viewCount: 330,
  ),
  Post(
    id: '_skeleton_my_post_1',
    title: '북촌 한옥마을 산책 코스',
    body: '골목이 조용하고 오르막이 완만해 천천히 걷기 좋다.',
    category: TargetCategory.touristSpot,
    author: _author,
    createdAt: _createdAt,
    likeCount: 34,
    commentCount: 9,
    viewCount: 1280,
  ),
  Post(
    id: '_skeleton_my_post_2',
    title: '남산 야경 보러 가는 시간대',
    body: '해 지고 30분쯤이 가장 붐비지 않았다.',
    category: TargetCategory.touristSpot,
    author: _author,
    createdAt: _createdAt,
    likeCount: 7,
    commentCount: 2,
    viewCount: 96,
  ),
];
