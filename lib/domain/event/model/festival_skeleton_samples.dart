import 'festival.dart';

/// 로딩 중 뼈대를 그리기 위한 더미 축제들. 값은 화면에 드러나지 않는다 —
/// `AppSkeleton`이 덮으므로 글자 수만 레이아웃에 남는다.
///
/// **`const`가 아니다.** [Festival]이 `DateTime`을 요구하는데 `DateTime` 리터럴은
/// 상수 표현식이 될 수 없다. 대신 **고정된 날짜**를 쓴다 — `DateTime.now()`를 쓰면
/// 뼈대가 프레임마다 달라져 스켈레톤이 깜빡인다.
///
/// `thumbnailImageUrl`은 빈 문자열이다. `SpotThumbnail`이 URL이 아닌 값을 색블록으로
/// 폴백하므로 뼈대가 네트워크 요청을 내지 않는다.
final List<Festival> festivalSkeletonSamples = List<Festival>.unmodifiable(
  <Festival>[
    Festival(
      id: '_skeleton_0',
      title: '한강 여름 불꽃 축제',
      thumbnailImageUrl: '',
      distanceMeters: 1800,
      attributionText: '한국관광공사',
      startDate: DateTime.utc(2026, 8, 1),
      endDate: DateTime.utc(2026, 8, 15),
      address: '서울특별시 영등포구 여의동로 330',
    ),
    Festival(
      id: '_skeleton_1',
      title: '전주 한옥마을 야행',
      thumbnailImageUrl: '',
      distanceMeters: 4200,
      attributionText: '한국관광공사',
      startDate: DateTime.utc(2026, 8, 5),
      endDate: DateTime.utc(2026, 8, 20),
      address: '전라북도 전주시 완산구 기린대로 99',
    ),
  ],
);
