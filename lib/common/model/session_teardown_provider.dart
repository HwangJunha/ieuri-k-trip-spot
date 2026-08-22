import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/spot/provider/recent_searches_providers.dart';
import '../storage/draft_store_impl.dart';
import 'session_teardown.dart';

part 'session_teardown_provider.g.dart';

/// 세션 정리 훅의 단일 출처(SPEC-0028 §3.2).
///
/// `TokenRefreshBridge`가 네트워크 계층과 auth의 순환을 콜백으로 끊은 것과 같은
/// 방식이다 — 등록하는 쪽(alarm)과 부르는 쪽(auth)이 서로를 import하지 않는다.
///
/// **기기에 남는 사용자 데이터 삭제도 여기 건다.** `keepAlive` provider는 인증을
/// watch해 스스로 비워지지만(`SessionScope`), 디스크에 쓴 것은 그렇지 않아 앱을
/// 다시 켜면 되살아난다 — 다음 사용자에게 이전 사람의 검색어와 글 초안이 보인다.
///
/// 등록을 이 provider 안에서 하는 이유는 **부를 자리가 마땅치 않아서**다. alarm은
/// 화면 게이트가 있어 거기서 걸지만, 이쪽은 화면이 없다. `keepAlive`라 한 번만
/// 만들어지므로 중복 등록되지 않는다.
///
/// **common이 domain을 import하는 것은 여기서 의도한 것이다**(CLAUDE.md §4).
/// 지울 대상이 두 기능(spot의 검색 이력, community의 초안)에 걸쳐 있어 어느 한쪽에
/// 둘 수 없고, 저장소를 common으로 끌어올리면 그 기능의 데이터가 자기 도메인을
/// 떠난다. 의존은 이 방향으로만 흐르고 역방향은 없다.
@Riverpod(keepAlive: true)
SessionTeardown sessionTeardown(Ref ref) {
  final SessionTeardown teardown = SessionTeardown();

  teardown.register(() async {
    // 모든 언어의 검색 이력을 지운다 — 활성 언어만 지우면 나머지가 남는다.
    await ref.read(recentSearchesStoreProvider).clearAll();
    // 글 초안: 본문(prefs)과 사진 바이트(앱 디렉토리)를 함께 지운다.
    await ref.read(draftStoreProvider).clear();
  });

  return teardown;
}
