import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/common/localization/app_language.dart';
import 'package:ieuri_k_trip_spot/common/localization/locale_controller.dart';
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

  // SPEC-0029 R-21 — 검색 결과가 활성 언어의 장소로 한정되므로 이력도 언어별로
  // 갈린다. **비우는 것이 아니라 가르는 것**이라 오갈 때 각자의 이력이 남는다.
  group('언어별 분리 (R-21)', () {
    /// 기기 로케일이 무엇이든 영어에서 시작하도록 못 박는다 — 시작 언어가 흔들리면
    /// 저장 키를 단언할 수 없다.
    Future<ProviderContainer> englishContainer() async {
      final container = makeContainer();
      await container
          .read(localeControllerProvider.notifier)
          .select(AppLanguage.english);
      return container;
    }

    test('언어를 바꾸면 그 언어의 이력을 본다', () async {
      final container = await englishContainer();

      await container.read(recentSearchesProvider.notifier).record('경복궁');
      expect(container.read(recentSearchesProvider), <String>['경복궁']);

      await container
          .read(localeControllerProvider.notifier)
          .select(AppLanguage.japanese);

      // 일본어에는 아직 이력이 없다 — 한국어 이력이 새어 나오면 안 된다.
      expect(container.read(recentSearchesProvider), isEmpty);
    });

    test('원래 언어로 돌아오면 이력이 그대로 있다', () async {
      final container = await englishContainer();

      await container.read(recentSearchesProvider.notifier).record('경복궁');

      final notifier = container.read(localeControllerProvider.notifier);
      await notifier.select(AppLanguage.japanese);
      await container.read(recentSearchesProvider.notifier).record('金閣寺');
      await notifier.select(AppLanguage.english);

      // 비웠다면 여기가 비어 있을 것이다 — 사용자가 지운 적 없는 기록이다.
      expect(container.read(recentSearchesProvider), <String>['경복궁']);

      await notifier.select(AppLanguage.japanese);
      expect(container.read(recentSearchesProvider), <String>['金閣寺']);
    });

    test('저장 키가 언어별로 다르다', () async {
      final container = await englishContainer();

      await container.read(recentSearchesProvider.notifier).record('경복궁');
      await container
          .read(localeControllerProvider.notifier)
          .select(AppLanguage.japanese);
      await container.read(recentSearchesProvider.notifier).record('金閣寺');

      // 한 키를 공유했다면 두 질의가 한 목록에 섞여 있을 것이다.
      expect(prefs.getStringList('recent_searches_en'), <String>['경복궁']);
      expect(prefs.getStringList('recent_searches_ja'), <String>['金閣寺']);
    });
  });
}
