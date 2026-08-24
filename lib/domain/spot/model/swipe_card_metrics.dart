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
      // 앱바·카테고리 바가 사진 위에 겹치므로 그 영역에 상단 스크림을 깐다(R14).
      // 밝은 사진 위에서 44x44 원형 아이콘이 특히 취약하다(설계 §2.5).
      topScrimHeight:
          _nonNegative(topViewPadding) + _nonNegative(overlayControlsHeight),
    );
  }

  /// 기기와 무관한 기본 하단 여백. 안전 영역 위에 얹는다.
  ///
  /// 36인 이유: 20으로 뒀더니 거리("140m") 아래가 살짝 잘렸다(실기기 확인
  /// 2026-08-18, 사용자 지적). 16을 더해 띄웠다.
  ///
  /// 52로 다시 올린 이유: 잘리지는 않지만 거리("541m")가 하단 탭 바에 딱 붙어
  /// 답답하다(실기기 확인 2026-08-24, 사용자 지적). 다시 16을 더한다.
  static const double _base = 52;

  static double _nonNegative(double value) => value < 0 ? 0 : value;

  /// 카드 폭 — 화면 폭 그대로다(좌우 여백 없음, AC R1-1).
  final double width;

  /// 카드 높이 — 하단 네비게이션 바만 뺀 값(AC R1-2).
  final double height;

  /// 하단 오버레이(제목·주소·거리)를 카드 밑변에서 얼마나 띄울지.
  final double overlayBottomInset;

  /// 상단 스크림 높이. 겹쳐 놓인 카테고리 바의 가독성을 받쳐 준다(R14).
  final double topScrimHeight;

  /// 좌우 여백이 없는가(AC R1-1). 전체화면화의 핵심 판정이다.
  bool get fillsWidth => width > 0;
}
