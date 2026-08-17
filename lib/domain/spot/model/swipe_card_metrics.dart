/// 전체화면 스와이프 카드의 배치 수치(SPEC-0025 R1·R14).
///
/// **위젯 밖에 두는 이유**는 AC R1-1~3이 "카드가 화면을 꽉 채우는가"를 판정하는데,
/// 그 계산이 `build` 안에 있으면 위젯 트리를 세워야만 확인되기 때문이다(설계 §2.4).
///
/// 화면 크기와 기기 인셋을 받아 순수하게 값만 낸다 — `MediaQuery`를 여기서 읽지
/// 않는다(그러면 다시 위젯이 필요해진다).
class SwipeCardMetrics {
  const SwipeCardMetrics({
    required this.width,
    required this.height,
    required this.overlayBottomInset,
    required this.topScrimHeight,
    required this.photoHeight,
  });

  /// [screenWidth]×[screenHeight] 화면에서의 카드 배치를 정한다.
  ///
  /// [bottomNavHeight]는 하단 탭 바가 차지하는 높이, [bottomViewPadding]은 기기의
  /// 하단 안전 영역(홈 인디케이터 등), [topViewPadding]은 상태바 높이다.
  ///
  /// **카드 높이에서 빼는 것은 하단 네비게이션 바뿐이다**(AC R1-2) — 앱바와 카테고리
  /// 바는 카드 **위에 겹치므로**(R14, 사용자 결정 2026-08-17) 높이를 차지하지 않는다.
  /// 이 둘을 빼면 사진 면적이 그만큼 줄어 전체화면화의 뜻이 사라진다.
  factory SwipeCardMetrics.fromScreen({
    required double screenWidth,
    required double screenHeight,
    required double bottomNavHeight,
    required double bottomViewPadding,
    required double topViewPadding,
    required double overlayControlsHeight,
  }) {
    final double width = screenWidth < 0 ? 0 : screenWidth;
    final double height = (screenHeight - bottomNavHeight).clamp(
      0.0,
      screenHeight < 0 ? 0.0 : screenHeight,
    );

    return SwipeCardMetrics(
      width: width,
      height: height,
      // **고정 픽셀값을 쓰지 않는다**(설계 §2.2). 정보가 화면 최하단에 붙으므로 기기의
      // 안전 영역을 침범하지 않아야 하는데, 그 높이는 기기마다 다르다.
      //
      // 카드가 하단 내비 바 **아래까지** 그려지는 셸에서는(`extendBody: true`)
      // 호출부가 그 바 높이를 [bottomViewPadding]에 함께 실어 보낸다 — 사진은 바
      // 뒤로 흘러도 되지만 글자가 가리면 읽을 수 없기 때문이다.
      overlayBottomInset: _base + _nonNegative(bottomViewPadding),
      // **사진은 화면을 다 채우지 않는다**(사용자 결정 2026-08-18).
      //
      // 관광공사 원본이 940×705가 최대인데(실측: `_image2_`가 가장 큰 변형이고
      // `_image3_`은 150×113짜리 축소본이다) 이것을 1206×2622 화면에 `cover`로
      // 늘리면 세로로 3.7배가 되어 눈에 띄게 깨진다. 상세 화면이 멀쩡해 보이는
      // 이유는 거기서는 같은 사진을 화면 일부에만 그리기 때문이다.
      //
      // 사진 영역을 [_photoFraction]으로 줄이면 확대율이 절반 아래로 떨어져
      // 선명해지고, 남는 아래쪽은 정보 영역이 된다.
      photoHeight: height * _photoFraction,
      // 앱바·카테고리 바가 사진 위에 겹치므로 그 영역에 상단 스크림을 깐다(R14).
      // 밝은 사진 위에서 44x44 원형 아이콘이 특히 취약하다(설계 §2.5).
      topScrimHeight:
          _nonNegative(topViewPadding) + _nonNegative(overlayControlsHeight),
    );
  }

  /// 기기와 무관한 기본 하단 여백. 안전 영역 위에 얹는다.
  ///
  /// 36인 이유: 20으로 뒀더니 거리("140m") 아래가 살짝 잘렸다(실기기 확인
  /// 2026-08-18, 사용자 지적). 16을 더해 띄운다.
  static const double _base = 36;

  /// 사진이 카드 높이에서 차지하는 비율.
  ///
  /// 확대율과 정보 공간을 맞바꾼 값이다 — 원본 940×705를 iPhone 17 Pro 기준으로
  /// 약 2.3배까지만 늘려(전체화면이면 3.7배) 깨짐을 눈에 띄지 않게 누른다.
  ///
  /// **상한일 뿐 실제 높이가 아니다.** 사진은 제 비율대로 그려지므로 가로 사진은
  /// 여기 닿지 않고, 세로로 긴 포스터만 여기 걸려 좌우에 여백을 남긴다.
  ///
  /// 0.62 → 0.7 → 0.8로 올려 왔다. 세 줄짜리 정보 아래가 비는 것을 줄이려는 것이고,
  /// 정보는 어차피 제 내용만큼만 차지하므로 상한을 올려도 글자가 밀리지 않는다.
  static const double _photoFraction = 0.8;

  static double _nonNegative(double value) => value < 0 ? 0 : value;

  /// 카드 폭 — 화면 폭 그대로다(좌우 여백 없음, AC R1-1).
  final double width;

  /// 카드 높이 — 하단 네비게이션 바만 뺀 값(AC R1-2).
  final double height;

  /// 하단 오버레이(제목·주소·거리)를 카드 밑변에서 얼마나 띄울지.
  final double overlayBottomInset;

  /// 상단 스크림 높이. 겹쳐 놓인 카테고리 바의 가독성을 받쳐 준다(R14).
  final double topScrimHeight;

  /// 사진이 차지할 수 있는 최대 높이. 나머지는 정보 영역이다.
  final double photoHeight;

  /// 사진 영역에 **하한을 두지 않는 이유**.
  ///
  /// 한때 [photoHeight]의 80%를 하한으로 뒀다. 가로로 넓은 사진이 낮게 깔려 아래가
  /// 비는 것을 막으려는 것이었는데, 하한에 걸리면 영역이 실제 사진보다 커지고 그
  /// 안에서 `contain`이 가운데 놓여 **사진과 정보 사이에 빈 띠가 생겼다**(실기기
  /// 확인 2026-08-18). 아래가 좀 비는 편이 그 띠보다 낫다.

  /// 좌우 여백이 없는가(AC R1-1). 전체화면화의 핵심 판정이다.
  bool get fillsWidth => width > 0;
}
