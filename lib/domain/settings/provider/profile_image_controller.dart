import 'dart:developer' as developer;

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../auth/provider/auth_controller.dart';
import '../model/profile_image_upload.dart';
import '../model/settings_failure.dart';
import '../repository/profile_repository.dart';
import 'profile_providers.dart';

part 'profile_image_controller.g.dart';

/// 프로필 이미지 업로드가 지금 어느 단계인지(R6). 화면이 진행 표시와 버튼 비활성을
/// 이 값으로 가른다.
enum ProfileImageStep {
  /// 아무것도 진행 중이 아니다.
  idle,

  /// 1단계 — 서명 URL 발급 중.
  creatingUrl,

  /// 2단계 — 스토리지로 직접 PUT 중.
  uploading,

  /// 3단계 — 확정 중.
  confirming,

  /// 제거 중(교체와 **별도 동작**이다).
  removing,
}

/// 프로필 이미지 화면의 상태(SPEC-0011 R6).
class ProfileImageState {
  const ProfileImageState({
    this.step = ProfileImageStep.idle,
    this.failure,
    this.confirmedKey,
    this.removed = false,
  });

  final ProfileImageStep step;

  /// 실패 사유. 다음 시도를 시작하면 지워진다.
  final SettingsFailure? failure;

  /// 확정된 이미지 키. 성공 계기이며 화면이 이것으로 스낵바를 띄운다.
  final String? confirmedKey;

  /// 직전 동작이 제거였고 성공했는지.
  final bool removed;

  bool get isBusy => step != ProfileImageStep.idle;
}

/// 프로필 이미지 업로드·제거(R6).
///
/// **3단계다**: URL 발급 → 스토리지 직접 PUT → 확정. 선언한 `contentType`·
/// `contentLength`가 실제 PUT과 정확히 일치해야 서명이 유효하므로, 바이트를 먼저
/// 확보한 뒤 그 길이로 발급을 요청한다(설계 §4).
///
/// **바이트를 인자로 받는다 — 사진을 고르는 일은 여기 관심사가 아니다.** 화면이
/// picker에서 받은 바이트를 넘기고, 테스트는 고정 바이트를 넘긴다. 그래서 이 notifier는
/// 기기 없이도 3단계 전이를 전부 검증할 수 있다.
@riverpod
class ProfileImageController extends _$ProfileImageController {
  @override
  ProfileImageState build() => const ProfileImageState();

  ProfileRepository get _repository => ref.read(profileRepositoryProvider);

  /// 이미지를 교체한다. 세 단계를 순서대로 밟고, **중간에 실패하면 이미 발급받은
  /// 임시 키를 버린다**(설계 §4 — 확정 전에 벗어나면 키가 떠돈다).
  Future<void> replace(ProfileImageBytes image) async {
    if (state.isBusy) return;

    state = const ProfileImageState(step: ProfileImageStep.creatingUrl);
    ProfileImageUploadUrl? issued;
    try {
      // 1단계 — 실제 바이트 길이로 발급받는다. 여기서 어림값을 쓰면 2단계 서명이 깨진다.
      issued = await _repository.createProfileImageUploadUrl(
        contentType: image.contentType,
        contentLength: image.contentLength,
      );

      // 2단계 — 서버를 거치지 않고 스토리지로 직접 보낸다.
      state = const ProfileImageState(step: ProfileImageStep.uploading);
      await _repository.uploadProfileImage(
        uploadUrl: issued.uploadUrl,
        contentType: image.contentType,
        bytes: image.bytes,
      );

      // 3단계 — 확정. 이 시점부터 키는 더 이상 임시가 아니다.
      state = const ProfileImageState(step: ProfileImageStep.confirming);
      final String? key = await _repository.confirmProfileImageUpload(
        issued.objectKey,
      );

      // 세션의 `Me`를 다시 맞춘다 — 설정 홈의 아바타가 그 값을 그린다.
      await ref.read(authControllerProvider.notifier).refreshMe();
      state = ProfileImageState(confirmedKey: key ?? issued.objectKey);
    } on Object catch (error) {
      // **`SettingsFailure`만 잡으면 안 된다.** 매핑 중의 `TypeError`처럼 예상 밖의
      // 예외가 새어 나가면 state가 `uploading`/`confirming`에 멈춘 채로 남고,
      // `isBusy`가 영영 true라 사용자가 **다시 시도조차 못 한다** — 화면을 나갔다
      // 와야 풀린다. 어떤 실패든 idle로 돌아오는 것이 재시도 가능성보다 우선이다.
      _discard(issued);
      state = ProfileImageState(
        failure: error is SettingsFailure ? error : SettingsFailure.unknown,
      );
    }
  }

  /// 프로필 이미지를 제거한다(R6). 교체와 **별도 동작**이다.
  Future<void> remove() async {
    if (state.isBusy) return;

    state = const ProfileImageState(step: ProfileImageStep.removing);
    try {
      await _repository.removeProfileImage();
      await ref.read(authControllerProvider.notifier).refreshMe();
      state = const ProfileImageState(removed: true);
    } on Object catch (error) {
      // 위와 같은 이유 — 어떤 실패든 idle로 돌아와야 다시 시도할 수 있다.
      state = ProfileImageState(
        failure: error is SettingsFailure ? error : SettingsFailure.unknown,
      );
    }
  }

  /// 확정되지 못한 임시 키를 버린다.
  ///
  /// **서버에 취소 오퍼레이션이 없다**(2026-08-08 라이브 스키마 기준 —
  /// `createProfileImageUploadUrl`/`confirmProfileImageUpload`/`removeProfileImage`가
  /// 전부다). 그래서 여기서 할 수 있는 것은 **확정하지 않고 키를 놓는 것**뿐이고,
  /// 실제 정리는 서버의 만료 회수에 달려 있다. 남긴 로그가 그 사실의 흔적이다 —
  /// 취소 오퍼레이션이 생기면 이 자리에서 부르면 된다.
  void _discard(ProfileImageUploadUrl? issued) {
    if (issued == null) return;
    developer.log(
      'profile image upload abandoned before confirm: ${issued.objectKey}',
      name: 'ProfileImageController',
    );
  }
}
