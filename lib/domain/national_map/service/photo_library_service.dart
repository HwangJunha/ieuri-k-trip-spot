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

  /// [start]부터 [count]장을 읽되 **한 장씩 흘려보낸다**(R29).
  ///
  /// [coordinatesOf]는 200장을 다 읽어야 반환하는데, 좌표는 사진 한 장마다
  /// 비동기 호출로 읽으므로 그 대기가 스캔 시간의 대부분이다. 그동안 진행률이
  /// 멈춰 있어 막대가 200장 단위로 계단처럼 뛰었다 — 실기기에서 확인한 문제다.
  ///
  /// 좌표가 없는 사진도 [PhotoCoordinate.point]가 null인 채로 흘려보낸다.
  /// 호출자가 "몇 장 읽었는지"를 세려면 건너뛴 사진도 알아야 한다.
  Stream<PhotoCoordinate> streamCoordinates({
    required int start,
    required int count,
  });
}

/// 사진 한 장을 읽은 결과.
///
/// 좌표가 없으면 [point]가 null이다. 그래도 흘려보내는 이유는 진행률이 "읽은
/// 장수"를 세기 때문이다 — 좌표 있는 사진만 세면 막대가 실제보다 느리게 찬다.
class PhotoCoordinate {
  const PhotoCoordinate(this.point);

  final GeoPoint? point;
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
      final GeoPoint? p = await _coordinateOf(asset);
      if (p != null) out.add(p);
    }
    return out;
  }

  @override
  Stream<PhotoCoordinate> streamCoordinates({
    required int start,
    required int count,
  }) async* {
    final int total = await photoCount();
    if (start >= total) return;

    final List<pm.AssetEntity> assets = await pm.PhotoManager.getAssetListRange(
      start: start,
      end: (start + count) > total ? total : (start + count),
      type: _images,
    );

    // **한 장 읽을 때마다 내보낸다.** 좌표 읽기가 장당 비동기 호출이라
    // 여기가 스캔 시간의 대부분이다 — 다 모아서 반환하면 그동안 진행률이 멈춘다.
    for (final pm.AssetEntity asset in assets) {
      yield PhotoCoordinate(await _coordinateOf(asset));
    }
  }

  /// 사진 한 장의 좌표. 없거나 쓸 수 없으면 null이다.
  Future<GeoPoint?> _coordinateOf(pm.AssetEntity asset) async {
    // **`latitude`/`longitude` 속성을 쓰지 않는다** — 3.8.0에서 deprecated이고
    // Android 10 이상에서는 항상 null이다(패키지 주석). EXIF를 실제로 읽어 오는
    // 경로가 이 비동기 호출이다.
    final pm.LatLng? latLng = await asset.latlngAsync();
    // 좌표가 없는 사진이 대부분이다 — 오류가 아니다(R32).
    if (latLng == null) return null;
    final double lat = latLng.latitude;
    final double lng = latLng.longitude;
    // 미기록을 0,0으로 주는 기기가 있다. 기니만 앞바다라 한국 좌표가 아니다.
    if (lat == 0 && lng == 0) return null;
    return GeoPoint(lng, lat);
  }
}
