import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/common/pagination/pagination_list_view.dart';

/// [PaginationListView]를 화면 하나에 띄운다. 항목은 높이 100짜리 상자라 몇 개만
/// 있어도 스크롤이 생긴다.
Future<void> _pump(
  WidgetTester tester, {
  int itemCount = 20,
  Future<void> Function()? onRefresh,
  VoidCallback? onLoadMore,
}) => tester.pumpWidget(
  MaterialApp(
    home: Scaffold(
      body: PaginationListView(
        itemCount: itemCount,
        hasMore: false,
        isLoadingMore: false,
        onLoadMore: onLoadMore ?? () {},
        onRefresh: onRefresh,
        itemBuilder: (BuildContext context, int index) =>
            SizedBox(height: 100, child: Text('item $index')),
      ),
    ),
  ),
);

void main() {
  // 새로고침이 필요 없는 목록(시트 안의 선택 목록 등)에 빈 제스처를 심지 않는다.
  testWidgets('onRefresh가 없으면 RefreshIndicator를 그리지 않는다', (
    WidgetTester tester,
  ) async {
    await _pump(tester);

    expect(find.byType(RefreshIndicator), findsNothing);
  });

  testWidgets('onRefresh를 주면 당겨서 새로고침이 붙는다', (WidgetTester tester) async {
    int calls = 0;
    await _pump(tester, onRefresh: () async => calls++);

    expect(find.byType(RefreshIndicator), findsOneWidget);

    await tester.fling(find.byType(ListView), const Offset(0, 400), 1000);
    await tester.pumpAndSettle();

    expect(calls, 1);
  });

  // 한 화면에 다 들어가는 짧은 목록은 기본 physics로는 당겨지지 않는다 — 그러면
  // 빈 피드에서 새로고침이 먹통이 된다.
  testWidgets('항목이 한 화면에 다 들어가도 당길 수 있다', (WidgetTester tester) async {
    int calls = 0;
    await _pump(tester, itemCount: 1, onRefresh: () async => calls++);

    await tester.fling(find.byType(ListView), const Offset(0, 400), 1000);
    await tester.pumpAndSettle();

    expect(calls, 1);
  });

  // 반환한 Future가 끝나야 인디케이터가 걷힌다 — 즉시 완결되는 Future를 주면
  // 데이터가 오기 전에 스피너가 사라져 새로고침이 안 된 것처럼 보인다.
  testWidgets('새로고침이 끝날 때까지 스피너가 남는다', (WidgetTester tester) async {
    final Completer<void> completer = Completer<void>();
    await _pump(tester, onRefresh: () => completer.future);

    await tester.fling(find.byType(ListView), const Offset(0, 400), 1000);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.byType(RefreshProgressIndicator), findsOneWidget);

    completer.complete();
    await tester.pumpAndSettle();

    expect(find.byType(RefreshProgressIndicator), findsNothing);
  });
}
