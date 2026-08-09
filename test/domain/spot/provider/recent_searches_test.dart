import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/common/storage/app_preferences.dart';
import 'package:ieuri_k_trip_spot/domain/spot/repository/recent_searches_store.dart';
import 'package:ieuri_k_trip_spot/domain/spot/provider/recent_searches_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 최근 검색어 notifier + 저장소(SPEC-0013 R12, AC-12.1~12.4).
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late SharedPreferences prefs;

  setUp(() async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    prefs = await SharedPreferences.getInstance();
  });

  ProviderContainer makeContainer() {
    final container = ProviderContainer(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
    );
    addTearDown(container.dispose);
    return container;
  }

  test('AC-12.1 · 검색을 실행하면 저장소에 기록된다', () async {
    final container = makeContainer();

    await container.read(recentSearchesProvider.notifier).record('경복궁');

    expect(container.read(recentSearchesProvider), <String>['경복궁']);
    expect(container.read(recentSearchesStoreProvider).read(), <String>['경복궁']);
  });

  test('AC-12.2 · 앱 재시작을 모사해 다시 읽으면 유지된다', () async {
    final first = makeContainer();
    await first.read(recentSearchesProvider.notifier).record('불국사');
    first.dispose();

    // 새 컨테이너 = 앱 재시작. 값은 provider가 아니라 SharedPreferences가 지킨다.
    final second = ProviderContainer(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
    );
    addTearDown(second.dispose);

    expect(second.read(recentSearchesProvider), <String>['불국사']);
  });

  test('AC-12.3 · 개별 삭제는 그 항목만 지운다', () async {
    final container = makeContainer();
    final notifier = container.read(recentSearchesProvider.notifier);
    await notifier.record('경복궁');
    await notifier.record('불국사');

    await notifier.remove('경복궁');

    expect(container.read(recentSearchesProvider), <String>['불국사']);
  });

  test('AC-12.4 · 전체 삭제는 저장소를 비운다', () async {
    final container = makeContainer();
    final notifier = container.read(recentSearchesProvider.notifier);
    await notifier.record('경복궁');
    await notifier.record('불국사');

    await notifier.clear();

    expect(container.read(recentSearchesProvider), isEmpty);
    expect(container.read(recentSearchesStoreProvider).read(), isEmpty);
  });

  test('최신 검색이 앞에 오고 같은 질의는 중복되지 않는다', () async {
    final container = makeContainer();
    final notifier = container.read(recentSearchesProvider.notifier);
    await notifier.record('경복궁');
    await notifier.record('불국사');
    await notifier.record('경복궁');

    expect(container.read(recentSearchesProvider), <String>['경복궁', '불국사']);
  });

  test('공백뿐인 질의는 기록하지 않는다', () async {
    final container = makeContainer();

    await container.read(recentSearchesProvider.notifier).record('   ');

    expect(container.read(recentSearchesProvider), isEmpty);
  });

  test('상한을 넘으면 가장 오래된 항목이 밀려난다', () async {
    final container = makeContainer();
    final notifier = container.read(recentSearchesProvider.notifier);
    for (int i = 0; i <= recentSearchesLimit; i++) {
      await notifier.record('q$i');
    }

    final List<String> saved = container.read(recentSearchesProvider);
    expect(saved.length, recentSearchesLimit);
    expect(saved.first, 'q$recentSearchesLimit');
    expect(saved, isNot(contains('q0')));
  });
}
