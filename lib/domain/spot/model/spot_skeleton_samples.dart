/// 로딩 중 뼈대를 그리기 위한 더미 spot들. **화면에 값이 보이지는 않는다** —
/// `AppSkeleton`이 텍스트와 이미지를 뼈대로 덮으므로 글자 수만 레이아웃에 남는다.
///
/// ## 왜 값이 이렇게 생겼는가
///
/// - `imageRef`/`thumbnailImageUrl`이 **빈 문자열**이다. `SpotThumbnail`이 `http`로
///   시작하지 않는 값을 색블록으로 폴백하므로, 뼈대가 네트워크 요청을 내지 않는다.
///   가짜 URL을 넣으면 로딩 화면이 실패할 요청을 쏘아 댄다.
/// - 이름·주소 길이가 제각각이다. 전부 같은 길이면 뼈대가 표처럼 보여 부자연스럽다.
/// - 개수는 한 화면에 들어갈 만큼만 둔다. 더 그려 봐야 스크롤 밖이라 보이지 않고
///   빌드 비용만 든다.
library;

import 'popular_spot.dart';
import 'tourist_spot.dart';

const TouristSpot _sample0 = TouristSpot(
  id: '_skeleton_0',
  name: '경복궁 근정전',
  imageRef: '',
  location: '서울 종로구',
  address: '서울특별시 종로구 사직로 161',
  distanceMeters: 1200,
);

const TouristSpot _sample1 = TouristSpot(
  id: '_skeleton_1',
  name: '북촌 한옥마을',
  imageRef: '',
  location: '서울 종로구',
  address: '서울특별시 종로구 계동길 37',
  distanceMeters: 2400,
);

const TouristSpot _sample2 = TouristSpot(
  id: '_skeleton_2',
  name: '남산서울타워',
  imageRef: '',
  location: '서울 용산구',
  address: '서울특별시 용산구 남산공원길 105',
  distanceMeters: 3800,
);

const List<TouristSpot> spotSkeletonSamples = <TouristSpot>[
  _sample0,
  _sample1,
  _sample2,
];

/// 인기 섹션용. 좋아요 수는 자릿수만 레이아웃에 영향을 준다.
const List<PopularSpot> popularSpotSkeletonSamples = <PopularSpot>[
  PopularSpot(spot: _sample0, likeCount: 128),
  PopularSpot(spot: _sample1, likeCount: 96),
  PopularSpot(spot: _sample2, likeCount: 74),
];
