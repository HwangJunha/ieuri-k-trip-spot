import 'package:flutter/foundation.dart' show visibleForTesting;
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
  /// **"일부만 허용"을 따로 알린다**(2026-08-26). 예전에는 그것도 그냥 허용으로
  /// 봤는데, 그러면 사용자는 사진첩 전체를 훑었다고 믿지만 실제로는 **고른 몇
  /// 장만** 훑는다 — 실기기에서 사진이 여러 장인데 "훑음 3장"으로 끝났다.
  ///
  /// `photo_manager` 공식 문서가 이 동작을 명시한다: limited 권한에서
  /// `getAssetCount`·`getAssetListRange`는 사용자가 고른 것만 돌려주고, 권장
  /// 대응은 [presentLimitedPicker]로 재선택을 띄우는 것이다.
  Future<PhotoAccess> requestAccess();

  /// "일부만 허용"일 때 고른 사진을 다시 정하도록 시스템 화면을 띄운다.
  ///
  /// **iOS 14+와 Android 14+ 양쪽에 있다**(2026-08-26 확인). `photo_manager`
  /// 3.12.0의 `PermissionDelegate34.presentLimited`가 안드로이드 구현이다.
  /// 그보다 낮은 버전에서는 아무 일도 하지 않는다.
  Future<void> presentLimitedPicker();

  /// 지금의 접근 등급. **요청하지 않고 묻기만 한다**(2026-08-26).
  ///
  /// 설정에서 돌아왔을 때 등급이 올라갔는지 확인하는 데 쓴다 — 여기서
  /// [requestAccess]를 부르면 시스템 프롬프트가 다시 뜰 수 있다.
  Future<PhotoAccess> currentAccess();

  /// 앱의 시스템 설정 화면을 연다(2026-08-26).
  ///
  /// **`permission_handler`가 아니라 `photo_manager`로 연다.** 사진 권한은
  /// `PermissionController`를 지나지 않는 별도 경로라(이 파일이 그 경계다),
  /// 같은 플러그인으로 열어야 상태와 화면이 어긋나지 않는다.
  Future<void> openSettings();

  /// 훑을 사진 총 개수.
  Future<int> photoCount();

  /// [start]부터 [count]장의 **좌표만** 읽는다.
  ///
  /// 좌표가 없는 사진은 결과에서 빠지므로 반환 개수가 [count]보다 적을 수 있다.
  /// 진행 위치는 호출자가 [start]로 관리한다(R28의 중단·재개).
  ///
  /// **사진 자체를 읽지 않는다.** iOS는 Photos DB의 인덱스를, Android는
  /// `ACCESS_MEDIA_LOCATION` 하에서 EXIF를 패키지가 읽어 준다.
  Future<List<GeoPoint>> coordinatesOf({
    required int start,
    required int count,
  });

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

/// 사진첩 접근 상태.
///
/// **`limited`를 `granted`와 나누는 것이 핵심이다.** 둘을 뭉치면 "일부만 허용"인
/// 사용자가 전체를 훑었다고 오해한다 — 화면이 그 사실을 알려 줄 수 있어야 한다.
enum PhotoAccess {
  /// 사진첩 전체를 볼 수 있다.
  granted,

  /// 사용자가 고른 사진만 볼 수 있다(iOS 14+). 훑는 흐름은 같지만 **대상이
  /// 사진첩 전체가 아니다.**
  limited,

  /// 거부. 오류가 아니라 안내 대상이다(R32).
  denied,
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

  /// 권한을 묻고 답할 때 쓰는 옵션. **요청과 조회가 같아야 한다.**
  ///
  /// `type`을 주지 않으면 기본값이 `RequestType.common`, 곧 **이미지+동영상**이다
  /// (`photo_manager` 3.12.0 `PermissionRequestOption` 기본값). 우리는 매니페스트에
  /// `READ_MEDIA_IMAGES`만 선언했으므로 Android 14+에서 동영상은 언제나 거부로
  /// 판정되고, 패키지의 `PermissionDelegate34.getAuthValue`가 "하나는 허용 · 하나는
  /// 거부"를 **`Limited`로 합친다** — 사용자가 전체 허용을 했는데도 "일부만
  /// 허용" 안내가 떴다(사용자 지적 2026-08-26, iOS는 정상). 이미지만 묻게 하면
  /// 이미지 권한 하나로 `Authorized`가 나온다.
  ///
  /// 테스트가 매니페스트와 대조할 수 있도록 공개한다 — 이 값과
  /// `AndroidManifest.xml`이 어긋난 것이 그 버그의 원인이었다.
  @visibleForTesting
  static const pm.PermissionRequestOption permissionOption =
      pm.PermissionRequestOption(
        androidPermission: pm.AndroidPermission(
          type: _images,
          mediaLocation: true,
        ),
      );

  @override
  Future<PhotoAccess> requestAccess() async {
    final pm.PermissionState state = await pm
        .PhotoManager.requestPermissionExtend(requestOption: permissionOption);
    return switch (state) {
      pm.PermissionState.authorized => PhotoAccess.granted,
      pm.PermissionState.limited => PhotoAccess.limited,
      _ => PhotoAccess.denied,
    };
  }

  // **`type`을 준다.** 기본값이 `RequestType.all`이라 그냥 부르면 동영상·오디오까지
  // 재선택 대상이 된다 — 우리가 훑는 것은 이미지뿐이다.
  @override
  Future<void> presentLimitedPicker() =>
      pm.PhotoManager.presentLimited(type: _images);

  @override
  Future<PhotoAccess> currentAccess() async {
    // `requestPermissionExtend`와 달리 프롬프트를 띄우지 않고 현재 값만 읽는다.
    // **옵션은 요청과 같은 것을 쓴다**([permissionOption] 문서) — 다르면 요청과
    // 조회가 서로 다른 등급을 답한다.
    final pm.PermissionState state = await pm.PhotoManager.getPermissionState(
      requestOption: permissionOption,
    );
    return switch (state) {
      pm.PermissionState.authorized => PhotoAccess.granted,
      pm.PermissionState.limited => PhotoAccess.limited,
      _ => PhotoAccess.denied,
    };
  }

  @override
  Future<void> openSettings() => pm.PhotoManager.openSetting();

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
