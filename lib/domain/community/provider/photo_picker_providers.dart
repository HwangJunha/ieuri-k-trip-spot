import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'post_composer_providers.dart';

part 'photo_picker_providers.g.dart';

/// 기기에서 사진을 고르는 수단. **구현체가 아직 없다.**
///
/// 사진 선택은 플랫폼 채널이 필요해 패키지(`image_picker` 등)를 들여야 하는데,
/// pubspec에 없고 이 슬라이스를 위해 새 의존을 추가하지 않았다. 대신 **이음매만
/// 만들어 두었다** — 업로드 4단계(발급 → PUT → 확인 → 글 붙이기)는 repository와
/// provider에 전부 구현돼 있고, 이 provider를 실제 picker로 override하면 그날부터
/// 사진 첨부가 돈다.
///
/// null을 돌려주면 사용자가 취소한 것이고, 빈 목록이면 고른 것이 없는 것이다.
typedef PhotoPicker = Future<List<PickedPhoto>?> Function({required int limit});

/// 기본 구현은 **아무것도 고르지 않는다.** 화면은 이 결과(null)를 "고를 수 없음"으로
/// 안내하고, 사진 없이 글을 쓰는 경로는 그대로 열려 있다(`photoKeys: []`).
@riverpod
PhotoPicker photoPicker(Ref ref) =>
    ({required int limit}) async => null;
