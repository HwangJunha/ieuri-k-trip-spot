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
/// **다만 헛치는 것은 이 위젯이 센다**(2026-08-25). 항목이 늘지 않은 채 세 번
/// 연속 요청하면 더 부르지 않는다 — 컨트롤러들이 실패 시 `isLoadingMore`만
/// 되돌리고 `hasMore`를 true로 남기기 때문에, 그대로 두면 바닥에서 스크롤할 때마다
/// 요청이 나간다. 자세한 것은 `_consecutiveFailures` 문서 참고.
///
/// [onRefresh]는 **선택이다.** 주면 당겨서 새로고침이 붙고, 주지 않으면 [RefreshIndicator]
/// 자체를 그리지 않는다 — 새로고침이 의미 없는 목록(시트 안의 선택 목록 등)에 빈
/// 제스처를 심지 않기 위해서다.
class PaginationListView extends StatefulWidget {
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
  State<PaginationListView> createState() => _PaginationListViewState();
}

class _PaginationListViewState extends State<PaginationListView> {
  /// 이어 받기를 몇 번 연속 헛쳤는지.
  ///
  /// ## 왜 세는가 — 여기가 무한 요청 경로였다
  ///
  /// 컨트롤러들은 `loadMore`가 실패하면 `isLoadingMore`만 false로 되돌리고
  /// **`hasMore`는 true로 남긴다**(12개 파일이 같은 형태다). 그러면 아래 스크롤
  /// 리스너의 가드(`!hasMore || isLoadingMore`)가 다시 열리므로, 사용자가 목록
  /// 바닥에 머물러 손가락을 조금씩 움직이는 동안 **스크롤 이벤트마다 요청이
  /// 나간다.**
  ///
  /// provider의 재시도 정책은 `build()`에만 걸려 이 경로를 막지 못한다.
  ///
  /// **서버에 WAF도 rate limit도 없다**(사용자, 2026-08-25) — 끊기는 편이 낫다.
  /// 여기서 막으면 이 위젯을 쓰는 목록 전부가 한 번에 안전해진다.
  int _consecutiveFailures = 0;

  /// 항목 수가 늘지 않은 채 이만큼 연속으로 요청하면 멈춘다.
  ///
  /// 성공했는데 서버가 빈 페이지를 준 경우도 여기 걸린다 — 그것도 더 받을 것이
  /// 없다는 뜻이라 계속 물어볼 이유가 없다.
  static const int _maxConsecutiveFailures = 3;

  /// 마지막으로 요청을 낸 시점의 항목 수. 늘었으면 성공한 것이다.
  int _itemCountAtLastRequest = -1;

  @override
  void didUpdateWidget(PaginationListView old) {
    super.didUpdateWidget(old);
    // 항목이 늘었다 = 이어 받기가 성공했다. 처음부터 다시 센다.
    if (widget.itemCount > _itemCountAtLastRequest) {
      _consecutiveFailures = 0;
    }
    // 목록이 통째로 갈렸으면(새로고침·필터 변경) 상한도 함께 푼다.
    if (widget.itemCount < _itemCountAtLastRequest) {
      _consecutiveFailures = 0;
      _itemCountAtLastRequest = -1;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Widget list = _buildList(context);
    return widget.onRefresh == null
        ? list
        : RefreshIndicator(onRefresh: widget.onRefresh!, child: list);
  }

  Widget _buildList(BuildContext context) {
    return NotificationListener<ScrollUpdateNotification>(
      onNotification: (ScrollUpdateNotification notification) {
        if (!widget.hasMore || widget.isLoadingMore) return false;
        if (_consecutiveFailures >= _maxConsecutiveFailures) return false;

        final ScrollMetrics m = notification.metrics;
        // 끝에서 한 화면 남았을 때 미리 받아 스크롤이 끊기지 않게 한다.
        if (m.pixels >= m.maxScrollExtent - m.viewportDimension) {
          // 지난번 요청 이후 항목이 늘지 않았으면 헛친 것으로 센다. 늘었다면
          // `didUpdateWidget`이 이미 0으로 되돌렸다.
          if (widget.itemCount == _itemCountAtLastRequest) {
            _consecutiveFailures++;
          }
          _itemCountAtLastRequest = widget.itemCount;
          widget.onLoadMore();
        }
        return false;
      },
      child: ListView.builder(
        padding: widget.padding,
        // 새로고침이 붙어 있으면 **항상 스크롤 가능해야 한다** — 한 화면에 다 들어가는
        // 짧은 목록은 기본 physics로는 당겨지지 않아 제스처가 먹통이 된다.
        physics: widget.onRefresh == null
            ? null
            : const AlwaysScrollableScrollPhysics(),
        // 마지막 한 칸은 추가 로딩 인디케이터 자리다.
        itemCount: widget.itemCount + (widget.isLoadingMore ? 1 : 0),
        itemBuilder: (BuildContext context, int index) =>
            index >= widget.itemCount
            ? const Padding(
                padding: EdgeInsets.all(16),
                child: Center(child: CircularProgressIndicator()),
              )
            : widget.itemBuilder(context, index),
      ),
    );
  }
}
