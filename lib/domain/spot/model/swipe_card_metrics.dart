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
    required this.overlayContentHeight,
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
    double textScale = 1,
  }) {
    final double width = screenWidth < 0 ? 0 : screenWidth;
    final double height = (screenHeight - bottomNavHeight).clamp(
      0.0,
      screenHeight < 0 ? 0.0 : screenHeight,
    );

    return SwipeCardMetrics(
      width: width,
      height: height,
      overlayContentHeight: fixedOverlayContentHeight(textScale: textScale),
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

  /// 정보 영역이 **늘 차지할** 높이(패딩 제외한 내용 높이).
  ///
  /// **왜 고정하는가.** 예전에는 정보가 자기 내용만큼만 차지했다. 그런데 그 높이가
  /// 카드마다 달랐다 — 제목이 한 줄이냐 두 줄이냐, 주소가 있냐 없냐에 따라
  /// 33px쯤 오르내렸다. 정보가 남긴 자리를 사진이 가져가므로(`Expanded`),
  /// **카드가 넘어갈 때마다 사진이 커졌다 작아졌다** 했다. 사진 우하단에 붙은
  /// 좋아요 버튼도 함께 오르내려 더 눈에 띄었다(사용자 지적 2026-08-28, 실기기
  /// 녹화 분석: 정보 영역 시작점이 490 ↔ 504로 진동).
  ///
  /// 최댓값으로 고정한다 — 제목 2줄·주소 2줄·거리 1줄이 다 들어가는 높이다.
  /// 짧은 카드는 아래에 빈 자리가 남지만, **사진과 버튼이 흔들리지 않는 편이**
  /// 낫다(사용자 결정 2026-08-28).
  ///
  /// [textScale]은 기기 글자 크기 설정. 사용자가 글자를 키우면 정보도 그만큼
  /// 커져야 잘리지 않는다.
  static double fixedOverlayContentHeight({double textScale = 1}) {
    final double scale = textScale <= 0 ? 1 : textScale;
    return (_badgeHeight +
            _badgeGap +
            _titleLineHeight * _titleMaxLines +
            _addressGap +
            _addressLineHeight * _addressMaxLines +
            _distanceGap +
            _distanceRowHeight) *
        scale;
  }

  // ---------------------------------------------------------------------------
  //  아래 값들은 **실측이다**(2026-08-29).
  //
  //  눈대중으로 적었다가 합이 5px 모자라 카드가
  //  `BOTTOM OVERFLOWED BY 5.0 PIXELS`로 깨졌다(실기기, 사용자 지적). 값을 바꿀
  //  때는 `swipe_card_metrics_test.dart`가 위젯을 실제로 세워 재므로 거기서
  //  확인하고 고친다 — 다시 눈대중하면 같은 일이 반복된다.
  // ---------------------------------------------------------------------------

  /// 출처 배지 한 줄. 글자(`labelSmall` 11 × 1.45 ≈ 16)와 상하 패딩 4+4.
  static const double _badgeHeight = 24;
  static const double _badgeGap = 10;

  /// 제목 한 줄 — `titleLarge`(22).
  ///
  /// **22 × 1.25가 아니다.** 위젯이 `height: 1.25`를 주지만 Material 3의
  /// `titleLarge`가 이미 `height: 1.27`을 갖고 있어 실제 줄 높이는 27.5가 아니라
  /// 28로 잡힌다.
  static const double _titleLineHeight = 28;
  static const int _titleMaxLines = 2;

  static const double _addressGap = 6;

  /// 주소 한 줄 — `bodyMedium`(14 × 1.43 = 20.02 → 20).
  static const double _addressLineHeight = 20;
  static const int _addressMaxLines = 2;

  static const double _distanceGap = 8;

  /// 거리 줄 — 새로고침 `IconButton`이 지배한다.
  ///
  /// **`minHeight: 36`이 아니라 40이다.** `visualDensity: compact`가 세로로 -2를
  /// 주는데, `IconButton`은 그만큼 자기 박스를 **키운다**(제약을 줄이는 것이
  /// 아니다). 36을 그대로 믿었다가 4px이 새어 오버플로우의 대부분을 만들었다.
  static const double _distanceRowHeight = 40;

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

  /// 정보 영역이 늘 차지하는 높이. **카드마다 같아야** 사진과 좋아요 버튼이
  /// 흔들리지 않는다 — 계산 근거는 [fixedOverlayContentHeight].
  final double overlayContentHeight;

  /// 좌우 여백이 없는가(AC R1-1). 전체화면화의 핵심 판정이다.
  bool get fillsWidth => width > 0;
}
