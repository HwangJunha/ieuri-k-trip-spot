import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../model/sns_credential.dart';

part 'pending_sns_credential.g.dart';

/// SNS 가입 화면으로 넘길 자격증명을 잠시 보관한다.
///
/// **`extra`로 넘기면 사라진다.** GoRouter의 `extra`는 메모리에만 있고 URL에
/// 실리지 않는데, 이 앱은 `refreshListenable`로 인증 상태 변화마다 라우트를 다시
/// 만든다. `signInSns`가 `state`를 `loading` → `previous`로 두 번 바꾸므로 가입
/// 화면으로 push한 직후 재빌드가 일어나고, 그때 `extra`가 null이 되어 가입 화면
/// 대신 로그인 화면이 뜬다.
///
/// 구글·애플에서만 재현되고 카카오는 멀쩡했던 것이 이 타이밍 때문이다 — 두 provider는
/// `authorizationCode`를 따로 받아 오느라 상태 변화와 push 순서가 어긋난다
/// (실기기 확인 2026-08-25).
///
/// **keepAlive다.** autoDispose면 화면 전환 중 잠깐 구독이 끊긴 사이에 값이 날아가
/// 같은 문제가 반복된다.
@Riverpod(keepAlive: true)
class PendingSnsCredential extends _$PendingSnsCredential {
  @override
  SnsCredential? build() => null;

  /// 가입 화면으로 보내기 직전에 담는다.
  void set(SnsCredential credential) => state = credential;

  /// 가입을 마쳤거나 화면을 떠날 때 비운다. 남겨 두면 다음 로그인 시도에서
  /// 남의 자격증명으로 가입 화면이 열릴 수 있다.
  void clear() => state = null;
}
