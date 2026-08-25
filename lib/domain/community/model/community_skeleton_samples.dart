/// 로딩 중 뼈대를 그리기 위한 더미 커뮤니티 모델들. **화면에 값이 보이지는 않는다** —
/// `AppSkeleton`이 텍스트와 이미지를 뼈대로 덮으므로 글자 수만 레이아웃에 남는다.
///
/// ## 왜 값이 이렇게 생겼는가
///
/// - `photoKeys`가 **비어 있다.** `PostCard`·`MyPostRow`가 키가 있을 때만 썸네일을
///   그리므로, 비워 두면 뼈대가 이미지 요청을 한 건도 내지 않는다. 가짜 키를 넣으면
///   로딩 화면이 실패할 요청을 쏘아 댄다.
/// - `profileImageUrl`이 **null이다.** 아바타가 이니셜로 떨어져 역시 네트워크를 타지
///   않으면서 자리 크기는 그대로다.
/// - `createdAt`이 **고정된 날짜다.** `DateTime.now()`를 쓰면 상대 시각 문구가 프레임
///   마다 달라져 뼈대가 깜빡인다.
/// - 제목·본문 길이가 제각각이다. 전부 같은 길이면 뼈대가 표처럼 보여 부자연스럽다.
library;

import '../../../common/model/comment.dart';
import '../../../common/model/post.dart';
import '../../../common/model/post_author.dart';
import '../../../common/model/target_category.dart';

/// 뼈대의 시간 기준. 실제 화면이 넘기는 `now`와 함께 상대 시각 문구가 되지만, 그
/// 문구도 뼈대로 덮이므로 자릿수만 의미가 있다.
final DateTime _createdAt = DateTime.utc(2026, 8, 1, 9);

const PostAuthor _author = PostAuthor(
  id: '_skeleton_author',
  nickname: 'Traveler',
);

final Post _post0 = Post(
  id: '_skeleton_post_0',
  title: '광장시장 빈대떡 후기',
  body: '녹두 갈아 부친 빈대떡을 막걸리와 함께. 줄이 길어도 회전이 빨라 오래 기다리지 않았다.',
  category: TargetCategory.restaurant,
  author: _author,
  createdAt: _createdAt,
  likeCount: 12,
  commentCount: 4,
  viewCount: 330,
);

final Post _post1 = Post(
  id: '_skeleton_post_1',
  title: '북촌 한옥마을 산책 코스',
  body: '골목이 조용하고 오르막이 완만해 천천히 걷기 좋다.',
  category: TargetCategory.touristSpot,
  author: _author,
  createdAt: _createdAt,
  likeCount: 34,
  commentCount: 9,
  viewCount: 1280,
);

final Post _post2 = Post(
  id: '_skeleton_post_2',
  title: '남산 야경 보러 가는 시간대',
  body: '해 지고 30분쯤이 가장 붐비지 않았다. 케이블카 대기 줄은 그 뒤로 길어진다.',
  category: TargetCategory.touristSpot,
  author: _author,
  createdAt: _createdAt,
  likeCount: 7,
  commentCount: 2,
  viewCount: 96,
);

/// 피드·내 글 목록·숨긴 글 목록이 함께 쓰는 더미 글. 호출부는 `index % length`로
/// 골라 길이가 제각각인 줄을 만든다.
final List<Post> postSkeletonSamples = <Post>[_post0, _post1, _post2];

/// 차단 목록의 줄. 닉네임 길이만 레이아웃에 남는다.
const List<PostAuthor> blockedUserSkeletonSamples = <PostAuthor>[
  PostAuthor(id: '_skeleton_blocked_0', nickname: 'Seoul Walker'),
  PostAuthor(id: '_skeleton_blocked_1', nickname: 'Jun'),
  PostAuthor(id: '_skeleton_blocked_2', nickname: 'Night Market Fan'),
];

/// 글 상세 아래에 붙는 댓글 뼈대. **본문 길이를 다르게 둬** 두 줄짜리 댓글과 한 줄짜리
/// 댓글이 섞인 실제 모습에 가깝게 한다.
final List<Comment> commentSkeletonSamples = <Comment>[
  Comment(
    id: '_skeleton_comment_0',
    body: '저도 지난주에 다녀왔는데 줄이 생각보다 짧았어요.',
    author: _author,
    createdAt: _createdAt,
  ),
  Comment(
    id: '_skeleton_comment_1',
    body: '가는 길 알려주셔서 감사합니다.',
    author: _author,
    createdAt: _createdAt,
  ),
];
