import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../common/model/post_author.dart';
import '../../auth/model/auth_state.dart';
import '../../auth/model/me.dart';
import '../../auth/provider/auth_controller.dart';

part 'viewer_providers.g.dart';

/// 지금 로그인한 사용자를 **작성자 표현으로** 옮긴 값. 로그인하지 않았으면 null이다.
///
/// **왜 필요한가.** `ConversationController.send`는 낙관적 말풍선을 그리려고 발신자
/// 정보를 요구한다 — 서버 응답이 오기 전에 아바타·닉네임을 그려야 하기 때문이다.
/// 그 값의 출처는 세션 하나뿐이라 화면마다 세션을 파헤치는 대신 여기서 한 번 옮긴다.
///
/// DM 재진입 아이콘의 표시 여부도 이 값으로 가른다 — 로그인하지 않았으면 눌러도
/// 갈 곳이 없다(디자인 §1.5).
///
/// **`domain/auth` 의존은 기능 간 import가 아니라 세션 의존이다.** 세션은 특정 기능이
/// 아니라 앱 전체의 상태이며, `domain/settings`가 이미 같은 방식으로 읽는다.
@riverpod
PostAuthor? viewerAuthor(Ref ref) {
  final AuthState? auth = ref.watch(authControllerProvider).value;
  final Me? me = auth?.session?.user;
  if (me == null) return null;
  return PostAuthor(
    id: me.id,
    nickname: me.nickname,
    profileImageUrl: me.profileImageUrl,
  );
}
