import 'package:photo_manager/photo_manager.dart' as pm;

import '../model/cell_geometry.dart';

/// 사진첩 접근 경계(SPEC-0030 R25·R28·R31).
///
/// `photo_manager`는 **이 파일 밖으로 나가지 않는다.** provider·view는
/// [PhotoLibraryService]와 [GeoPoint]로만 대화하므로 패키지 타입이 도메인에
/// 새지 않는다(CLAUDE.md §3, 권한 래퍼의 선례).
abstract interface class PhotoLibraryService {
  /// 실제 앱에서 쓰는 `photo_manager` 기반 구현.
  const factory PhotoLibraryService() = PhotoManagerLibraryService;

  /// 사진 접근 권한을 요청한다(R31).
  ///
  /// iOS의 "일부만 허용"(limited)도 허용으로 본다 — 고른 사진만 훑을 뿐 흐름은
  /// 같고, 거부로 다루면 사용자가 허용했는데 막히는 것으로 보인다.
  Future<bool> requestAccess();

  /// 훑을 사진 총 개수.
  Future<int> photoCount();

  /// [start]부터 [count]장의 **좌표만** 읽는다.
  ///
  /// 좌표가 없는 사진은 결과에서 빠지므로 반환 개수가 [count]보다 적을 수 있다.
  /// 진행 위치는 호출자가 [start]로 관리한다(R28의 중단·재개).
  ///
  /// **사진 자체를 읽지 않는다.** iOS는 Photos DB의 인덱스를, Android는
  /// `ACCESS_MEDIA_LOCATION` 하에서 EXIF를 패키지가 읽어 준다.
  Future<List<GeoPoint>> coordinatesOf({required int start, required int count});
}

/// `photo_manager` 기반 구현.
class PhotoManagerLibraryService implements PhotoLibraryService {
  const PhotoManagerLibraryService();

  /// 이미지만 본다. 동영상은 좌표가 있어도 훑을 대상이 아니다.
  static const pm.RequestType _images = pm.RequestType.image;

  @override
  Future<bool> requestAccess() async {
    final pm.PermissionState state = await pm.PhotoManager.requestPermissionExtend();
    return state == pm.PermissionState.authorized ||
        state == pm.PermissionState.limited;
  }

  @override
  Future<int> photoCount() => pm.PhotoManager.getAssetCount(type: _images);

  @override
  Future<List<GeoPoint>> coordinatesOf({
    required int start,
    required int count,
  }) async {
    final int total = await photoCount();
    if (start >= total) return const <GeoPoint>[];

    final List<pm.AssetEntity> assets = await pm.PhotoManager.getAssetListRange(
      start: start,
      // 범위 끝은 포함하지 않으며 총 개수를 넘으면 안 된다.
      end: (start + count) > total ? total : (start + count),
      type: _images,
    );

    final List<GeoPoint> out = <GeoPoint>[];
    for (final pm.AssetEntity asset in assets) {
      // **`latitude`/`longitude` 속성을 쓰지 않는다** — 3.8.0에서 deprecated이고
      // Android 10 이상에서는 항상 null이다(패키지 주석). EXIF를 실제로 읽어 오는
      // 경로가 이 비동기 호출이다.
      final pm.LatLng? latLng = await asset.latlngAsync();
      // 좌표가 없는 사진이 대부분이다 — 오류가 아니다(R32).
      if (latLng == null) continue;
      final double lat = latLng.latitude;
      final double lng = latLng.longitude;
      // 미기록을 0,0으로 주는 기기가 있다. 기니만 앞바다라 한국 좌표가 아니다.
      if (lat == 0 && lng == 0) continue;
      out.add(GeoPoint(lng, lat));
    }
    return out;
  }
}
