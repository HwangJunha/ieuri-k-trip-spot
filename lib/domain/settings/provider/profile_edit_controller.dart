import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../auth/provider/auth_controller.dart';
import '../model/nickname_validation.dart';
import '../model/settings_failure.dart';
import 'profile_providers.dart';

part 'profile_edit_controller.g.dart';

/// 서버가 닉네임 중복에 쓰는 코드(R5). 이것만 입력란 오류로 옮기고 나머지는 화면
/// 상단의 일반 오류로 남긴다 — 원인이 입력값에 있는 것만 입력란에 붙어야 사용자가
/// 어디를 고칠지 안다.
const String nicknameAlreadyTakenCode = 'NICKNAME_ALREADY_TAKEN';

/// 닉네임 변경 화면의 상태(SPEC-0011 R5).
///
/// **입력값을 여기 담지 않는다** — 텍스트는 `TextEditingController`가 들고, 이
/// notifier는 제출 결과만 갖는다. 매 타자에 provider를 갱신하면 화면 전체가 다시
/// 그려진다.
class ProfileEditState {
  const ProfileEditState({
    this.formatError,
    this.nicknameTaken = false,
    this.failure,
    this.saved = false,
  });

  /// 형식 오류(R5). 제출 전 클라이언트가 판정한다.
  final NicknameValidation? formatError;

  /// 서버가 중복이라고 답했는지. 입력란 아래 오류로 그린다.
  final bool nicknameTaken;

  /// 그 밖의 실패(네트워크·인증 등). 입력값 문제가 아니므로 입력란에 붙이지 않는다.
  final SettingsFailure? failure;

  /// 직전 제출이 성공했는지. 화면이 스낵바를 띄우고 뒤로 가는 계기다.
  final bool saved;

  /// 입력란 아래 오류가 있는지.
  bool get hasFieldError => formatError != null || nicknameTaken;
}

/// 닉네임 변경(R5).
///
/// **중복을 미리 조회하지 않는다.** 제출 전에는 형식만 보고, 중복은 서버가
/// `NICKNAME_ALREADY_TAKEN`으로 답한 것을 입력란 오류로 옮긴다 — 미리 조회해도 조회와
/// 제출 사이에 선점당할 수 있어 어차피 서버 오류를 처리해야 한다(설계 §4).
@riverpod
class ProfileEditController extends _$ProfileEditController {
  @override
  ProfileEditState build() => const ProfileEditState();

  /// 사용자가 입력을 고치면 직전 오류를 지운다 — 고쳤는데 빨간 줄이 남아 있으면
  /// 아직 틀린 줄 안다.
  void clearErrors() {
    if (state.hasFieldError || state.failure != null || state.saved) {
      state = const ProfileEditState();
    }
  }

  /// 닉네임을 제출한다. 형식 오류면 서버를 부르지 않는다.
  ///
  /// 성공하면 세션의 `Me`를 다시 맞춘다 — 설정 홈과 홈 화면이 그리는 값이 그것이라,
  /// 갱신하지 않으면 저장했는데 옛 닉네임이 남는다.
  Future<void> submit(String raw) async {
    final NicknameValidation validation = validateNickname(raw);
    if (validation != NicknameValidation.ok) {
      state = ProfileEditState(formatError: validation);
      return;
    }

    state = const ProfileEditState();
    try {
      await ref
          .read(profileRepositoryProvider)
          .changeNickname(normalizeNickname(raw));
      await ref.read(authControllerProvider.notifier).refreshMe();
      state = const ProfileEditState(saved: true);
    } on SettingsFailure catch (failure) {
      state = failure.code == nicknameAlreadyTakenCode
          ? const ProfileEditState(nicknameTaken: true)
          : ProfileEditState(failure: failure);
    }
  }
}
