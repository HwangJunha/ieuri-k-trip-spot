import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../common/storage/app_preferences.dart';
import '../repository/photo_scan_checkpoint_store.dart';

part 'photo_scan_checkpoint_provider.g.dart';

/// 사진 스캔 중단 지점 저장소의 출처. 테스트는 이것만 오버라이드해 페이크를 준다.
@riverpod
PhotoScanCheckpointStore photoScanCheckpointStore(Ref ref) =>
    SharedPreferencesPhotoScanCheckpointStore(
      ref.watch(sharedPreferencesProvider),
    );
