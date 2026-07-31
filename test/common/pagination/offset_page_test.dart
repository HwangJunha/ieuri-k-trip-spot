import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/common/pagination/offset_page.dart';

void main() {
  test('nextPage is the page after when hasNext, null otherwise', () {
    const OffsetPage<int> more = OffsetPage<int>(
      items: <int>[1, 2],
      page: 0,
      hasNext: true,
    );
    expect(more.nextPage, 1);

    const OffsetPage<int> last = OffsetPage<int>(
      items: <int>[9],
      page: 4,
      hasNext: false,
    );
    expect(last.nextPage, isNull);
  });

  test('empty is an empty, exhausted first page', () {
    final OffsetPage<int> page = OffsetPage.empty<int>();
    expect(page.items, isEmpty);
    expect(page.page, 0);
    expect(page.hasNext, isFalse);
    expect(page.nextPage, isNull);
  });

  test('equality is value-based over items, page, hasNext, totalCount', () {
    const OffsetPage<int> a = OffsetPage<int>(
      items: <int>[1, 2],
      page: 1,
      hasNext: true,
      totalCount: 10,
    );
    const OffsetPage<int> b = OffsetPage<int>(
      items: <int>[1, 2],
      page: 1,
      hasNext: true,
      totalCount: 10,
    );
    const OffsetPage<int> c = OffsetPage<int>(
      items: <int>[1, 2],
      page: 2,
      hasNext: true,
      totalCount: 10,
    );
    expect(a, b);
    expect(a, isNot(c));
  });
}
