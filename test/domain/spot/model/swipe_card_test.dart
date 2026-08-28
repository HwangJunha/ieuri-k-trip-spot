import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/copyright_type.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/spot_reaction.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/swipe_card_display.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/swipe_card_metrics.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/swipe_drag.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/tourist_spot.dart';

/// 전체화면 스와이프 카드의 배치·표시·드래그 판정(SPEC-0025 R1~R4·R13).
///
/// 전부 위젯 트리 없이 판정한다 — 그러라고 순수 값으로 뽑아 둔 것이다(설계 §2.4).
void main() {
  TouristSpot spotWith({
    CopyrightType? copyright,
    String? address,
    int? distanceMeters,
    String? attributionText,
    String? thumbnailImageUrl = 'https://example.com/a.jpg',
  }) => TouristSpot(
    id: 's1',
    name: '경복궁',
    imageRef: 'mock:palace',
    location: '서울',
    thumbnailImageUrl: thumbnailImageUrl,
    address: address,
    distanceMeters: distanceMeters,
    copyright: copyright,
    attributionText: attributionText,
  );

  group('저작권 유형별 이미지 맞춤 (R13)', () {
    /// AC R13-1: TYPE1은 자유 이용이라 영역을 채운다.
    test('TYPE1은 영역을 채운다', () {
      expect(SwipeCardDisplay.fitFor(CopyrightType.type1), SwipeCardFit.cover);
    });

    /// AC R13-2: TYPE3은 변형 금지라 크롭하지 않는다.
    ///
    /// **한 번 뒤집혔다가 되돌아온 규칙이다.** 전체화면화 직후 잠시 `cover`로
    /// 통일했으나, 행사 포스터가 잘려 제목이 통째로 날아가는 것을 보고 사용자가
    /// 다시 뒤집었다(2026-08-18) — 포스터는 세로로 길고 글자가 가장자리까지 차
    /// 있어 크롭에 가장 취약하다.
    test('TYPE3은 크롭하지 않는다', () {
      expect(
        SwipeCardDisplay.fitFor(CopyrightType.type3),
        SwipeCardFit.contain,
      );
    });

    /// AC R13-3: 미지정은 변형 불가로 간주한다 — 변형해도 되는지 모르는 이미지를
    /// 크롭하는 것보다 여백을 남기는 편이 안전하다.
    test('미지정은 TYPE3과 같이 다룬다', () {
      expect(
        SwipeCardDisplay.fitFor(CopyrightType.unspecified),
        SwipeCardFit.contain,
      );
    });

    /// 저작권 정보 자체가 없는 경우도 같은 이유로 크롭하지 않는다.
    test('저작권 정보가 없으면 크롭하지 않는다', () {
      expect(SwipeCardDisplay.fitFor(null), SwipeCardFit.contain);
    });

    /// AC R13-4: 크롭을 피하면 여백이 생기고, 그 여백은 블러 배경이 메운다.
    test('크롭을 피할 때만 블러 배경이 필요하다', () {
      expect(SwipeCardFit.contain.needsBlurBackdrop, isTrue);
      expect(SwipeCardFit.cover.needsBlurBackdrop, isFalse);
    });

    /// 맞춤 방식과 별개로 **출처 표기는 언제나 지킨다.**
    test('출처 표기는 유지된다', () {
      expect(
        SwipeCardDisplay.of(spotWith(attributionText: '한국관광공사'))
            .showsAttribution,
        isTrue,
      );
    });
  });

  group('카드 표시 구성 (R2)', () {
    /// AC R2: 이름·주소·거리·출처가 있으면 그리고, 없으면 자리를 비우지 않는다.
    test('값이 있으면 모두 표시 대상이다', () {
      final SwipeCardDisplay display = SwipeCardDisplay.of(
        spotWith(
          address: '서울 종로구',
          distanceMeters: 850,
          attributionText: '한국관광공사',
        ),
      );

      expect(display.name, '경복궁');
      expect(display.showsAddress, isTrue);
      expect(display.showsDistance, isTrue);
      expect(display.showsAttribution, isTrue);
    });

    test('값이 없으면 표시하지 않는다', () {
      final SwipeCardDisplay display = SwipeCardDisplay.of(spotWith());

      expect(display.showsAddress, isFalse);
      expect(display.showsDistance, isFalse);
      expect(display.showsAttribution, isFalse);
    });

    /// 썸네일이 없으면 목 참조로 떨어져 플레이스홀더가 그려진다.
    test('썸네일이 없으면 목 참조를 쓴다', () {
      expect(
        SwipeCardDisplay.of(spotWith(thumbnailImageUrl: null)).imageRef,
        'mock:palace',
      );
    });
  });

  group('전체화면 배치 (R1·R14)', () {
    SwipeCardMetrics metricsOf({
      double width = 400,
      double height = 800,
      double bottomNav = 0,
      double bottomPadding = 34,
      double topPadding = 47,
    }) => SwipeCardMetrics.fromScreen(
      screenWidth: width,
      screenHeight: height,
      bottomNavHeight: bottomNav,
      bottomViewPadding: bottomPadding,
      topViewPadding: topPadding,
      overlayControlsHeight: 68,
    );

    /// AC R1-1: 좌우 여백이 없다 — 카드 폭이 화면 폭 그대로다.
    test('카드 폭은 화면 폭과 같다', () {
      expect(metricsOf(width: 400).width, 400);
      expect(metricsOf(width: 400).fillsWidth, isTrue);
    });

    /// AC R1-2: **하단 네비게이션 바만** 뺀다. 앱바·카테고리 바는 사진 위에 겹치므로
    /// (R14, 사용자 결정 2026-08-17) 높이를 차지하지 않는다 — 그것까지 빼면 사진
    /// 면적이 줄어 전체화면화의 뜻이 사라진다.
    test('카드 높이에서 하단 탭 바만 뺀다', () {
      expect(metricsOf(height: 800, bottomNav: 80).height, 720);
    });

    test('하단 탭 바가 없으면 화면 높이를 다 쓴다', () {
      expect(metricsOf(height: 800, bottomNav: 0).height, 800);
    });

    /// AC R1-3: 하단 정보는 기기 안전 영역을 침범하지 않는다. 고정 픽셀값은 기기별로
    /// 어긋난다(설계 §2.2).
    test('안전 영역이 클수록 하단 여백도 커진다', () {
      final double narrow = metricsOf(bottomPadding: 0).overlayBottomInset;
      final double wide = metricsOf(bottomPadding: 34).overlayBottomInset;

      expect(wide, greaterThan(narrow));
    });

    /// 셸이 `extendBody: true`라 사진은 떠 있는 내비 바 아래까지 깔리지만, **글자는
    /// 그 바를 피해야 한다**(실기기 확인 2026-08-18: 출처와 거리가 바에 묻혔다).
    /// 호출부가 바 높이를 안전 영역에 실어 보내므로 여백이 그만큼 커진다.
    test('내비 바 높이를 실어 보내면 하단 여백이 그만큼 커진다', () {
      const double barExtent = 96;

      expect(
        metricsOf(bottomPadding: 34 + barExtent).overlayBottomInset -
            metricsOf(bottomPadding: 34).overlayBottomInset,
        barExtent,
      );
    });

    /// **정보 영역 높이는 카드 내용과 무관하게 같다**(사용자 결정 2026-08-28).
    ///
    /// 내용만큼만 차지하게 두면 제목이 한 줄이냐 두 줄이냐에 따라 높이가 달라지고,
    /// 사진이 그 나머지를 가져가므로 카드가 넘어갈 때마다 사진이 커졌다 작아졌다
    /// 한다 — 사진 우하단의 좋아요 버튼도 함께 오르내린다(실기기 녹화 분석:
    /// 정보 영역 시작점이 490 ↔ 504로 진동).
    ///
    /// 이 값은 화면 크기·안전 영역과 무관해야 한다. 기기가 달라도 **한 기기 안에서는
    /// 모든 카드가 같은 높이**라는 것이 요점이다.
    test('정보 영역 높이는 화면 크기와 무관하게 일정하다', () {
      expect(
        metricsOf(width: 400, height: 800).overlayContentHeight,
        metricsOf(width: 320, height: 1200).overlayContentHeight,
      );
      expect(
        metricsOf(bottomPadding: 0).overlayContentHeight,
        metricsOf(bottomPadding: 34).overlayContentHeight,
      );
    });

    /// 제목 2줄·주소 2줄·거리 1줄이 다 들어가야 한다 — 최댓값으로 잡으므로 짧은
    /// 카드는 아래가 남고, 긴 카드도 잘리지 않는다.
    test('정보 영역은 제목 2줄·주소 2줄·거리 줄을 담을 만큼 크다', () {
      const double titleTwoLines = 22 * 1.25 * 2;
      const double addressTwoLines = 20 * 2;
      const double distanceRow = 36;

      expect(
        metricsOf().overlayContentHeight,
        greaterThanOrEqualTo(titleTwoLines + addressTwoLines + distanceRow),
      );
    });

    /// 글자를 키운 사용자에게도 잘리지 않아야 한다 — 고정 높이의 위험이 여기다.
    test('글자 크기를 키우면 정보 영역도 그만큼 커진다', () {
      final double normal = SwipeCardMetrics.fixedOverlayContentHeight();
      final double large = SwipeCardMetrics.fixedOverlayContentHeight(
        textScale: 1.5,
      );

      expect(large, greaterThan(normal));
      expect(large, closeTo(normal * 1.5, 0.01));
    });

    /// 0이나 음수가 들어와도 무너지지 않는다(기기 설정을 그대로 믿지 않는다).
    test('글자 배율이 0 이하면 기본 배율로 본다', () {
      expect(
        SwipeCardMetrics.fixedOverlayContentHeight(textScale: 0),
        SwipeCardMetrics.fixedOverlayContentHeight(),
      );
      expect(
        SwipeCardMetrics.fixedOverlayContentHeight(textScale: -1),
        SwipeCardMetrics.fixedOverlayContentHeight(),
      );
    });

    /// R14: 겹침 영역의 가독성 보조. 상단 스크림이 상태바와 카테고리 바를 덮는다.
    test('상단 스크림이 상태바와 조작 영역을 덮는다', () {
      expect(metricsOf(topPadding: 47).topScrimHeight, 47 + 68);
    });

    /// **스크림이 실제 칩 높이를 덮어야 한다.**
    ///
    /// 사진은 `topScrimHeight`만큼 내려오므로, 이 값이 조작 영역보다 작으면 그
    /// 차이만큼 **칩 라벨이 사진 위로 삐져나온다** — 68로 어림잡았다가 실제
    /// 높이(88+패딩)보다 작아 라벨이 사진을 침범했다(사용자 지적 2026-08-18).
    test('스크림은 조작 영역 높이를 그대로 반영한다', () {
      const double controls = 124; // CategoryBar(88) + 패딩(8+28)

      expect(
        SwipeCardMetrics.fromScreen(
          screenWidth: 400,
          screenHeight: 800,
          bottomNavHeight: 0,
          bottomViewPadding: 34,
          topViewPadding: 47,
          overlayControlsHeight: controls,
        ).topScrimHeight,
        47 + controls,
      );
    });

  });

  group('드래그 판정 (R3·R4)', () {
    /// AC R3-3: 임계값은 **비율**이다. 전체화면화로 카드가 넓어져도 "같은 비율만큼
    /// 끌면 같은 결과"여야 한다(설계 §2.1) — 절대 픽셀로 고정하면 화면 크기가 다른
    /// 기기에서 판정이 어긋난다.
    test('임계 비율은 카드 폭에 비례한다', () {
      // 좁은 카드(패딩 있던 시절)와 넓은 카드(전체화면) 모두 28%에서 확정된다.
      for (final double width in <double>[368, 400]) {
        final double atThreshold = width * SwipeDrag.confirmFraction;

        expect(
          SwipeDrag.confirms(dragX: atThreshold, width: width, velocity: 0),
          isTrue,
          reason: '폭 $width에서 28%를 끌면 확정',
        );
        expect(
          SwipeDrag.confirms(
            dragX: atThreshold - 1,
            width: width,
            velocity: 0,
          ),
          isFalse,
          reason: '폭 $width에서 28%에 못 미치면 스프링백',
        );
      }
    });

    /// R3 개정(2026-08-27): **어느 쪽으로 밀어도 패스다.** 넘기는 동작과 좋아요가
    /// 같은 제스처를 쓰면 구분되지 않아, 넘기려던 카드가 보관함에 쌓였다. 좋아요는
    /// 카드의 버튼과 상세 화면에서만 받는다.
    test('오른쪽으로 끌어도 패스다', () {
      expect(
        SwipeDrag.resolveHorizontal(
          drag: const Offset(200, 0),
          size: const Size2D(400, 800),
          velocity: Offset.zero,
        )?.reaction,
        SpotReaction.dislike,
      );
    });

    test('왼쪽으로 끌어도 패스다', () {
      expect(
        SwipeDrag.resolveHorizontal(
          drag: const Offset(-200, 0),
          size: const Size2D(400, 800),
          velocity: Offset.zero,
        )?.reaction,
        SpotReaction.dislike,
      );
    });

    /// 임계에 못 미치면 확정하지 않는다(스프링백).
    test('임계에 못 미치면 판정하지 않는다', () {
      expect(
        SwipeDrag.resolveHorizontal(
          drag: const Offset(10, 0),
          size: const Size2D(400, 800),
          velocity: Offset.zero,
        ),
        isNull,
      );
    });

    /// 짧게 튕기는 조작을 거리만으로 판정하면 "분명히 넘겼는데 돌아온다"가 된다.
    ///
    /// 판정 결과는 둘 다 패스지만, **카드가 날아가는 방향**은 민 쪽을 따라야 한다 —
    /// 그래서 방향 자체는 여전히 구분된다.
    test('빠르게 튕기면 거리가 짧아도 확정된다', () {
      expect(
        SwipeDrag.resolveHorizontal(
          drag: const Offset(10, 0),
          size: const Size2D(400, 800),
          velocity: const Offset(900, 0),
        ),
        SwipeDirection.right,
      );
      expect(
        SwipeDrag.resolveHorizontal(
          drag: const Offset(-10, 0),
          size: const Size2D(400, 800),
          velocity: const Offset(-900, 0),
        ),
        SwipeDirection.left,
      );
    });

    /// AC R4: 표시 강도는 진행도를 따르고, 임계에서 최대가 된 뒤 더 세지지 않는다.
    test('진행도는 임계에서 1이 되고 더 커지지 않는다', () {
      const double width = 400;
      final double threshold = width * SwipeDrag.confirmFraction;

      expect(SwipeDrag.progress(0, width), 0);
      expect(SwipeDrag.progress(threshold / 2, width), closeTo(0.5, 0.001));
      expect(SwipeDrag.progress(threshold, width), 1);
      expect(SwipeDrag.progress(threshold * 3, width), 1);
    });

    /// 방향과 무관하게 세기만 본다 — 왼쪽으로 끌어도 표시가 나와야 한다.
    test('진행도는 방향을 가리지 않는다', () {
      expect(
        SwipeDrag.progress(-50, 400),
        SwipeDrag.progress(50, 400),
      );
    });

    /// 다음 카드는 끌수록 제 크기로 올라온다.
    test('다음 카드는 진행도만큼 커진다', () {
      expect(SwipeDrag.nextCardScale(0, 400), SwipeDrag.nextCardRestScale);
      expect(
        SwipeDrag.nextCardScale(400 * SwipeDrag.confirmFraction, 400),
        1.0,
      );
    });

    /// 기울기는 변위에 비례하되 최대치를 넘지 않는다.
    test('기울기는 최대치에서 잘린다', () {
      expect(SwipeDrag.tilt(0, 400), 0);
      expect(SwipeDrag.tilt(1000, 400), SwipeDrag.maxTiltRadians);
      expect(SwipeDrag.tilt(-1000, 400), -SwipeDrag.maxTiltRadians);
    });

    /// 폭을 아직 모르는 첫 프레임에서 0으로 나누지 않는다.
    test('폭이 0이면 계산이 무너지지 않는다', () {
      expect(SwipeDrag.progress(50, 0), 0);
      expect(SwipeDrag.tilt(50, 0), 0);
      expect(
        SwipeDrag.resolveHorizontal(
          drag: const Offset(50, 0),
          size: const Size2D(0, 0),
          velocity: Offset.zero,
        ),
        isNull,
      );
    });
  });
}
