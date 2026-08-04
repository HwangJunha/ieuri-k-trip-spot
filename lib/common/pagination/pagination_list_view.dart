import 'package:flutter/material.dart';

/// 바닥에 닿으면 다음 페이지를 요청하는 목록(CLAUDE.md §4 — 페이지네이션은 공용,
/// 기능이 자기 것을 새로 만들지 않는다).
///
/// 커서든 오프셋이든 "끝에 가까워지면 더 받는다"는 규칙은 같으므로, 어느 페이지
/// 모델을 쓰는지는 이 위젯이 알지 않는다. 호출부는 이미 받은 [itemCount]와 항목
/// 빌더를 주고, 더 받을 것이 있는지([hasMore])와 지금 받는 중인지([isLoadingMore])만
/// 알려주면 된다.
///
/// [onLoadMore]는 끝에 가까워질 때마다 **여러 번 발화할 수 있다** — 중복 호출을 막는
/// 것은 컨트롤러 몫이다(이미 받는 중이면 무시). 스크롤 위치로 중복을 막으려 하면
/// 경계에서 튕길 때마다 조건이 깨진다.
class PaginationListView extends StatelessWidget {
  const PaginationListView({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    required this.hasMore,
    required this.isLoadingMore,
    required this.onLoadMore,
    this.padding,
  });

  /// 이미 받아 둔 항목 수(로딩 인디케이터는 포함하지 않는다).
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;

  /// 다음 페이지 존재 여부. false면 바닥에 닿아도 요청하지 않는다.
  final bool hasMore;

  /// 추가 페이지를 받는 중인지. true면 목록 끝에 인디케이터를 한 칸 붙인다.
  final bool isLoadingMore;

  final VoidCallback onLoadMore;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollUpdateNotification>(
      onNotification: (ScrollUpdateNotification notification) {
        if (!hasMore || isLoadingMore) return false;
        final ScrollMetrics m = notification.metrics;
        // 끝에서 한 화면 남았을 때 미리 받아 스크롤이 끊기지 않게 한다.
        if (m.pixels >= m.maxScrollExtent - m.viewportDimension) {
          onLoadMore();
        }
        return false;
      },
      child: ListView.builder(
        padding: padding,
        // 마지막 한 칸은 추가 로딩 인디케이터 자리다.
        itemCount: itemCount + (isLoadingMore ? 1 : 0),
        itemBuilder: (BuildContext context, int index) => index >= itemCount
            ? const Padding(
                padding: EdgeInsets.all(16),
                child: Center(child: CircularProgressIndicator()),
              )
            : itemBuilder(context, index),
      ),
    );
  }
}
