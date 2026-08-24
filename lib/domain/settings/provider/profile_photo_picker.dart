import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../model/profile_image_upload.dart';

part 'profile_photo_picker.g.dart';

/// 프로필 사진 한 장을 기기에서 고르는 수단(SPEC-0011 R6).
///
/// provider로 둔 이유는 **테스트가 갤러리를 열지 않게 하기 위해서다** — 위젯 테스트는
/// 이 provider를 고정 바이트로 override하고, 실제 화면만 갤러리를 띄운다.
///
/// null을 돌려주면 사용자가 취소했거나 지원하지 않는 형식을 고른 것이다.
typedef ProfilePhotoPicker = Future<ProfileImageBytes?> Function();

/// 서버가 받는 MIME 타입. 그 밖이면 거부되므로 **고르는 단계에서 미리 거른다.**
const Map<String, String> _contentTypeByExtension = <String, String>{
  'jpg': 'image/jpeg',
  'jpeg': 'image/jpeg',
  'png': 'image/png',
  'webp': 'image/webp',
};

/// 파일 이름의 확장자로 MIME 타입을 고른다. 모르는 확장자면 null이다.
///
/// `image_picker`의 `XFile.mimeType`은 **플랫폼마다 null이 되곤 해서** 믿지 않는다.
String? _contentTypeOf(String name) {
  final int dot = name.lastIndexOf('.');
  if (dot < 0 || dot == name.length - 1) return null;
  return _contentTypeByExtension[name.substring(dot + 1).toLowerCase()];
}

/// 갤러리에서 프로필 사진 한 장을 고른다.
///
/// **리사이즈·품질 옵션을 주지 않는다.** `maxWidth`/`imageQuality`를 주면 패키지가
/// 재인코딩하는데, 그러면 업로드 1단계에 선언한 `contentLength`와 실제 PUT 바이트 수가
/// 어긋나 스토리지가 서명 불일치로 거부한다(설계 §4).
///
/// 커뮤니티의 `photoPicker`와 **따로 둔다** — 그쪽은 여러 장을 고르고 초안용 식별자를
/// 붙이며, 무엇보다 기능 간 import가 금지돼 있다(CLAUDE.md §3). 공유할 만큼 자란다면
/// 그때 `common/`으로 올린다.
@riverpod
ProfilePhotoPicker profilePhotoPicker(Ref ref) {
  final ImagePicker picker = ImagePicker();
  return () async {
    final XFile? file = await picker.pickImage(source: ImageSource.gallery);
    if (file == null) return null;

    final String? contentType = _contentTypeOf(file.name);
    if (contentType == null) return null;
    return ProfileImageBytes(
      bytes: await file.readAsBytes(),
      contentType: contentType,
    );
  };
}
