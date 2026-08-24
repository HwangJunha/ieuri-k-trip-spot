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
///
/// [onRefresh]는 **선택이다.** 주면 당겨서 새로고침이 붙고, 주지 않으면 [RefreshIndicator]
/// 자체를 그리지 않는다 — 새로고침이 의미 없는 목록(시트 안의 선택 목록 등)에 빈
/// 제스처를 심지 않기 위해서다.
class PaginationListView extends StatelessWidget {
  const PaginationListView({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    required this.hasMore,
    required this.isLoadingMore,
    required this.onLoadMore,
    this.padding,
    this.onRefresh,
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

  /// 당겨서 새로고침. null이면 [RefreshIndicator]를 붙이지 않는다(기존 호출부는
  /// 영향을 받지 않는다).
  ///
  /// **완료될 때까지 스피너가 돈다** — 반환한 Future가 끝나야 인디케이터가 걷히므로,
  /// 호출부는 다시 받아 온 값을 `await`해서 넘겨야 한다. 즉시 완결되는 Future를 주면
  /// 데이터가 오기 전에 스피너가 사라져 새로고침이 안 된 것처럼 보인다.
  final Future<void> Function()? onRefresh;

  @override
  Widget build(BuildContext context) {
    final Widget list = _buildList(context);
    return onRefresh == null
        ? list
        : RefreshIndicator(onRefresh: onRefresh!, child: list);
  }

  Widget _buildList(BuildContext context) {
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
        // 새로고침이 붙어 있으면 **항상 스크롤 가능해야 한다** — 한 화면에 다 들어가는
        // 짧은 목록은 기본 physics로는 당겨지지 않아 제스처가 먹통이 된다.
        physics: onRefresh == null
            ? null
            : const AlwaysScrollableScrollPhysics(),
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
