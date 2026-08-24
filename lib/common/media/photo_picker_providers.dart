import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../model/composer_photo.dart';

part 'photo_picker_providers.g.dart';

/// 기기에서 사진을 고르는 수단.
///
/// provider로 둔 이유는 **테스트가 갤러리를 열지 않게 하기 위해서다** — 위젯 테스트는
/// 이 provider를 고정된 목록으로 override하고, 실제 화면만 갤러리를 띄운다.
///
/// **`common/`에 있는 이유**: 커뮤니티 컴포저와 피드 컴포저가 같은 수단을 쓴다.
/// 기능이 둘 이상 공유하면 `common/`이 자리다(CLAUDE.md §4) — 피드가 커뮤니티
/// 것을 직접 import하면 기능 간 의존이 생긴다(§3).
///
/// null을 돌려주면 사용자가 취소한 것이고, 빈 목록이면 고른 것이 없는 것이다.
typedef PhotoPicker = Future<List<LocalPhoto>?> Function({required int limit});

/// 서버가 받는 MIME 타입. 그 밖이면 `UNSUPPORTED_CONTENT_TYPE`으로 거부되므로
/// **고르는 단계에서 미리 거른다**(가이드 §4).
const Map<String, String> _contentTypeByExtension = <String, String>{
  'jpg': 'image/jpeg',
  'jpeg': 'image/jpeg',
  'png': 'image/png',
  'webp': 'image/webp',
};

/// 고른 사진에 붙일 식별자의 일련번호. 초안 안에서만 쓰이고 서버로 나가지 않는다.
int _nextPickId = 0;

/// 파일 이름의 확장자로 MIME 타입을 고른다. 모르는 확장자면 null이고 그 장은 버린다.
///
/// `image_picker`의 `XFile.mimeType`은 **플랫폼마다 null이 되곤 해서** 믿지 않는다.
String? _contentTypeOf(String name) {
  final int dot = name.lastIndexOf('.');
  if (dot < 0 || dot == name.length - 1) return null;
  return _contentTypeByExtension[name.substring(dot + 1).toLowerCase()];
}

/// 갤러리에서 사진을 고른다.
///
/// **리사이즈·품질 옵션을 주지 않는다.** `maxWidth`/`imageQuality`를 주면 패키지가
/// 재인코딩하는데, 그러면 1단계에 선언한 `contentLength`와 실제 PUT 바이트 수가
/// 어긋나 스토리지가 `403 SignatureDoesNotMatch`로 거부한다(가이드 §4). 크기 상한
/// (10 MiB)은 고른 뒤 바이트 수로 판정한다.
@riverpod
PhotoPicker photoPicker(Ref ref) {
  final ImagePicker picker = ImagePicker();
  return ({required int limit}) async {
    // limit를 패키지에 넘겨 **선택 단계에서** 개수를 막는다 — 6장을 고르게 한 뒤
    // 거절하면 사용자가 무엇이 빠졌는지 모른다.
    final List<XFile> files = await picker.pickMultiImage(limit: limit);
    if (files.isEmpty) return null;

    final List<LocalPhoto> picked = <LocalPhoto>[];
    for (final XFile file in files) {
      final String? contentType = _contentTypeOf(file.name);
      if (contentType == null) continue;
      picked.add(
        LocalPhoto(
          // 같은 파일을 두 번 골라도 서로 다른 장이므로 이름으로는 구분할 수
          // 없다 — 고른 순서로 단조 증가하는 값을 붙인다.
          id: 'local-${_nextPickId++}',
          bytes: await file.readAsBytes(),
          contentType: contentType,
          name: file.name,
        ),
      );
    }
    return picked;
  };
}
