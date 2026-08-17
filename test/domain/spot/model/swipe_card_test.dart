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

  group('이미지 맞춤 — [AMEND] 전 유형 cover (사용자 결정 2026-08-18)', () {
    /// **R13의 분기가 뒤집혔다.** 원래 TYPE3·미지정은 `contain` + 블러 배경이었으나
    /// (SPEC-0002 §4.7), 전체화면에서 세로 화면에 가로 사진이 들어오면 블러 여백이
    /// 화면 대부분을 차지해 사용자가 뒤집었다.
    ///
    /// 저작인격권 상 트레이드오프가 있다 — `problem/SPEC-0025-client.md` §7 참조.
    /// 되돌릴 때는 여기 네 개 테스트가 함께 바뀐다.
    test('저작권 유형과 무관하게 영역을 채운다', () {
      for (final CopyrightType? copyright in <CopyrightType?>[
        CopyrightType.type1,
        CopyrightType.type3,
        CopyrightType.unspecified,
        null,
      ]) {
        expect(
          SwipeCardDisplay.fitFor(copyright),
          SwipeCardFit.cover,
          reason: '$copyright도 cover여야 한다',
        );
      }
    });

    /// 영역을 채우면 여백이 없으므로 블러 배경도 필요 없다.
    test('채우기에는 블러 배경이 필요 없다', () {
      expect(SwipeCardFit.cover.needsBlurBackdrop, isFalse);
    });

    /// `contain` 자체는 남겨 둔다 — 되돌릴 때 쓸 경로이고, 블러 배경 규칙도 함께
    /// 살아 있어야 한다.
    test('크롭을 피하는 경로는 여전히 블러 배경을 요구한다', () {
      expect(SwipeCardFit.contain.needsBlurBackdrop, isTrue);
    });

    /// 크롭 여부와 별개로 **출처 표기는 계속 지킨다.**
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

    /// R14: 겹침 영역의 가독성 보조. 상단 스크림이 상태바와 카테고리 바를 덮는다.
    test('상단 스크림이 상태바와 조작 영역을 덮는다', () {
      expect(metricsOf(topPadding: 47).topScrimHeight, 47 + 68);
    });

    /// **사진은 카드를 다 채우지 않는다**(사용자 결정 2026-08-18). 관광공사 원본이
    /// 940×705가 최대라 전체화면으로 늘리면 3.7배까지 확대돼 깨졌다 — 사진 영역을
    /// 줄여 확대율을 절반 아래로 눌렀다.
    test('사진은 카드 높이의 일부만 차지한다', () {
      final SwipeCardMetrics metrics = metricsOf(height: 800);

      expect(metrics.photoHeight, lessThan(metrics.height));
      expect(metrics.photoHeight, greaterThan(metrics.height / 2));
    });

    /// 나머지가 정보 영역이므로 사진이 카드를 다 먹으면 안 된다.
    test('정보 영역이 남는다', () {
      final SwipeCardMetrics metrics = metricsOf(height: 800);

      expect(metrics.height - metrics.photoHeight, greaterThan(100));
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

    /// AC R3-1: 오른쪽으로 확정하면 좋아요.
    test('오른쪽으로 끌면 좋아요다', () {
      expect(
        SwipeDrag.resolve(dragX: 200, width: 400, velocity: 0),
        SpotReaction.like,
      );
    });

    /// AC R3-2: 왼쪽으로 확정하면 관심 없음.
    test('왼쪽으로 끌면 관심 없음이다', () {
      expect(
        SwipeDrag.resolve(dragX: -200, width: 400, velocity: 0),
        SpotReaction.dislike,
      );
    });

    /// 임계에 못 미치면 확정하지 않는다(스프링백).
    test('임계에 못 미치면 판정하지 않는다', () {
      expect(SwipeDrag.resolve(dragX: 10, width: 400, velocity: 0), isNull);
    });

    /// 짧게 튕기는 조작을 거리만으로 판정하면 "분명히 넘겼는데 돌아온다"가 된다.
    test('빠르게 튕기면 거리가 짧아도 확정된다', () {
      expect(
        SwipeDrag.resolve(dragX: 10, width: 400, velocity: 900),
        SpotReaction.like,
      );
      expect(
        SwipeDrag.resolve(dragX: -10, width: 400, velocity: -900),
        SpotReaction.dislike,
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
      expect(SwipeDrag.resolve(dragX: 50, width: 0, velocity: 0), isNull);
    });
  });
}
