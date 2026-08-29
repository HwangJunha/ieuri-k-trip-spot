import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/domain/spot/component/copyright_badge.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/swipe_card_metrics.dart';

/// 정보 영역의 **계산 높이가 실제 렌더 높이 이상인지** 확인한다.
///
/// `SwipeCardMetrics.fixedOverlayContentHeight`는 정보 영역을 고정 높이로 잡아
/// 사진과 좋아요 버튼이 카드마다 흔들리지 않게 한다(2026-08-28). 그런데 그 값이
/// **눈대중으로 적혀 있어** 실제보다 5px 작았고, 제목·주소가 둘 다 두 줄인 카드에서
/// `BOTTOM OVERFLOWED BY 5.0 PIXELS`가 났다(실기기, 사용자 지적 2026-08-29).
///
/// 어긋난 항목은 셋이었다.
///   - 배지     26 → 실제 24  (-2)
///   - 제목 2줄 55 → 실제 56  (+1) — `titleLarge`가 이미 `height: 1.27`을 갖는다
///   - 거리 줄  36 → 실제 40  (+4) — `visualDensity: compact`가 박스를 키운다
///
/// 계산식을 다시 눈대중으로 고치면 같은 일이 반복되므로, 여기서 **위젯을 실제로
/// 세워 잰다.** 상수를 바꾸는 사람은 이 테스트를 통과시켜야 한다.
void main() {
  /// 정보 영역이 최대로 커지는 경우 — 제목 2줄 + 주소 2줄 + 거리 줄.
  /// `fixedOverlayContentHeight`가 상정한 바로 그 조합이다.
  Future<double> renderWorstCase(WidgetTester tester, {double width = 362}) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Align(
            alignment: Alignment.topLeft,
            child: SizedBox(
              width: width,
              child: Builder(
                builder: (BuildContext context) {
                  final TextTheme text = Theme.of(context).textTheme;
                  final ColorScheme scheme = Theme.of(context).colorScheme;
                  return Column(
                    key: const Key('probe'),
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const CopyrightBadge(
                        attributionText: '출처: 한국관광공사(공공누리 제3유형·변경금지)',
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '엘스테이(Gangnam AN guesthouse) — 두 줄을 꽉 채울 만큼 긴 이름',
                        style: text.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          height: 1.25,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '서울특별시 서초구 사평대로53길 8-3 (반포동,세종빌리지) 201호 '
                        '— 두 줄이 되는 긴 주소',
                        style: text.bodyMedium,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: <Widget>[
                          const Icon(Icons.place_outlined, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            '215m',
                            style: text.labelLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.my_location, size: 18),
                            visualDensity: VisualDensity.compact,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(
                              minWidth: 36,
                              minHeight: 36,
                            ),
                            color: scheme.primary,
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
    return tester.getSize(find.byKey(const Key('probe'))).height;
  }

  testWidgets('계산 높이가 실제 렌더 높이보다 작지 않다 (5px 오버플로우 회귀)', (
    WidgetTester tester,
  ) async {
    final double actual = await renderWorstCase(tester);
    final double computed = SwipeCardMetrics.fixedOverlayContentHeight();

    // **작으면 오버플로우다.** 같거나 크기만 하면 된다 — 남는 자리는 사진이
    // 가져가지 않고 빈 채로 두는 것이 설계다(카드마다 사진 높이가 흔들리지
    // 않게 하려는 것).
    expect(
      computed,
      greaterThanOrEqualTo(actual),
      reason:
          '정보 영역 계산이 ${actual - computed}px 모자란다 — '
          'SwipeCardMetrics의 상수를 실측값에 맞춰야 한다.',
    );
  });

  testWidgets('글자를 키워도 모자라지 않는다', (WidgetTester tester) async {
    // `textScale`은 계산식이 곱셈으로 처리한다. 실제 렌더도 그만큼 커지므로
    // 배율을 올렸을 때 역전되지 않는지 본다 — 접근성 설정을 켠 사용자에게서만
    // 깨지는 것이 가장 늦게 발견된다.
    const double scale = 1.3;
    tester.platformDispatcher.textScaleFactorTestValue = scale;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

    final double actual = await renderWorstCase(tester);
    final double computed = SwipeCardMetrics.fixedOverlayContentHeight(
      textScale: scale,
    );

    expect(computed, greaterThanOrEqualTo(actual));
  });
}
