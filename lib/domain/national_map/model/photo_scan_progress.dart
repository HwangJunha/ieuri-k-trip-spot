/// 시군구 코드를 칸 id로 접는다(SPEC-0034 R5).
///
/// 판정 결과는 시군구 코드인데 지도는 칸 단위로 칠해진다. **서울 3개 구는 한
/// 칸이므로 1이다** — 코드 수를 그대로 세면 지도에 칸 하나가 칠해졌는데 "3곳"이
/// 된다. 그 오독이 이 버그였다.
///
/// [cellIdOf]에 없는 코드는 버린다. 어느 칸에도 속하지 않는 코드는 칠할 칸이
/// 없으니 셀 것도 없다.
Set<String> foldToCellIds(
  Iterable<String> districtCodes,
  Map<String, String> cellIdOf,
) => <String>{
  for (final String code in districtCodes)
    if (cellIdOf[code] case final String id) id,
};

/// 사진 스캔의 단계(R29·R32).
enum PhotoScanStage {
  /// 아직 시작하지 않았다.
  idle,

  /// 사진 접근 권한을 기다린다.
  requestingPermission,

  /// 권한이 거부됐다. **오류가 아니다**(R31·R32) — 안내만 하고 다른 기능은 그대로 쓴다.
  permissionDenied,

  /// 라이브러리를 훑는 중.
  scanning,

  /// 판정된 지역을 사용자에게 확인받는 중(R30).
  awaitingConfirmation,

  /// 끝났다.
  completed,

  /// 실패했다. 재시도 횟수가 남아 있으면 다시 시도할 수 있다(POL-040).
  failed,
}

/// 사진 스캔의 진행 상태(R28·R29).
///
/// **중단·재개를 담는다.** [processed]가 다음 시작점이다 — 400장 처리하고 멈추면
/// 다음에 401번째부터 읽는다.
class PhotoScanProgress {
  const PhotoScanProgress({
    this.stage = PhotoScanStage.idle,
    this.processed = 0,
    this.total = 0,
    this.foundCoordinates = 0,
    this.resolvedDistrictCodes = const <String>[],
    this.retryCount = 0,
    this.limitedAccess = false,
    this.alreadyOnMapCellCount = 0,
    this.newCellCount = 0,
    this.registeredCellCount,
  });

  final PhotoScanStage stage;

  /// 지금까지 읽은 사진 수. 재개 시작점이기도 하다(R28).
  final int processed;

  /// 훑어야 할 전체 사진 수.
  final int total;

  /// 위치 정보를 찾은 사진 수.
  ///
  /// 0으로 끝나도 오류가 아니다(R32) — "위치 정보가 있는 사진을 찾지 못했습니다".
  final int foundCoordinates;

  /// 판정된 **시군구 코드**(5자리). 사용자가 확인해야 등록된다(R30).
  ///
  /// **칸 id가 아니다**(SPEC-0034 R5). 예전 이름이 `resolvedCellCodes`라
  /// "판정된 칸 코드"로 읽혔고, 시트가 이 리스트의 길이를 그대로 칸 수로 표시해
  /// **서울 3개 구를 다녀오면 칸 하나가 칠해지는데 "3곳"이라고 말했다.** 지도는
  /// 맞게 칠해지고 숫자만 틀렸다.
  ///
  /// 등록 요청이 보내는 값은 이것이 맞다 — 서버가 시군구 단위로 저장한다.
  /// 표시용 수는 [newCellCount]·[registeredCellCount]가 따로 갖는다.
  final List<String> resolvedDistrictCodes;

  /// 지금까지 쓴 재시도 횟수(POL-040).
  final int retryCount;

  /// 사진첩을 **일부만** 볼 수 있는 상태인지(iOS "선택한 사진만", 2026-08-26).
  ///
  /// 이때 훑는 대상은 사진첩 전체가 아니라 사용자가 고른 몇 장뿐이다 —
  /// `photo_manager`의 `getAssetCount`가 그 몇 장만 센다(공식 문서). 화면이 이
  /// 사실을 알리고 재선택 수단을 줘야, 사용자가 "왜 3장만 훑었지"에서 멈추지 않는다.
  final bool limitedAccess;

  /// 사진에서 찾았으나 **이미 지도에 있던** 칸 수(2026-08-26).
  ///
  /// 등록 대상은 아니지만 결과를 말할 때는 세야 한다 — 빼고 말하면 "1장에서
  /// 0곳을 찾았어요"가 되어 실패로 읽힌다(사용자 지적).
  ///
  /// **칸 단위다**(SPEC-0034 R6). 예전에는 시군구 단위라 같은 칸이 신규와
  /// 기존으로 갈려 이중 계상됐다. 접은 뒤 신규 집합에서 기존 집합을 빼므로
  /// 겹치는 칸은 [newCellCount]에서 빠지고 여기에만 남는다.
  final int alreadyOnMapCellCount;

  /// 이번 스캔이 **새로 찾은 칸** 수(SPEC-0034 R5).
  ///
  /// 스캔 중에는 등록 응답이 없으므로 이 로컬 추정을 쓴다 — 시군구 코드를 칸
  /// id로 접은 집합의 크기다. 서울 3개 구는 1이 된다.
  final int newCellCount;

  /// 등록이 실제로 갱신한 칸 수(SPEC-0034 R7). 등록 전이거나 실패했으면 null.
  ///
  /// **완료 문구는 이 값을 쓴다.** 서버 응답이 알려주는 실제 갱신 칸이라 지도에
  /// 칠해진 것과 정의상 일치한다. 실패한 경우에 수를 표시하지 않으려면 "0"이
  /// 아니라 null이어야 한다 — 0은 "확인한 곳이 없다"는 참인 진술이 되어 버린다.
  final int? registeredCellCount;

  /// 0.0~1.0. 전체를 모르면 0이다.
  double get ratio => total == 0 ? 0 : (processed / total).clamp(0.0, 1.0);

  bool get isRunning => stage == PhotoScanStage.scanning;

  /// 이어서 읽을 수 있는 상태인지(R28).
  bool get isResumable =>
      processed > 0 &&
      processed < total &&
      (stage == PhotoScanStage.idle || stage == PhotoScanStage.failed);

  /// 좌표가 하나도 없이 끝났는지(R32). 안내 문구를 고르는 데 쓴다.
  bool get finishedWithoutCoordinates =>
      stage == PhotoScanStage.completed && foundCoordinates == 0;

  /// 완료 화면에 "다시 채우기"를 보여 줄지.
  ///
  /// **"일부만 허용"에서만 감춘다.** 그 화면의 해법은 사진 재선택과 전체 허용
  /// 버튼이고, 둘 다 끝나면 스캔이 자동으로 다시 돈다 — 같은 몇 장을 다시 훑는
  /// 버튼은 군더더기다.
  ///
  /// **좌표를 못 찾은 경우에는 보여 준다**(사용자 지적 2026-08-26). 한때 이쪽도
  /// 감췄는데, 그러면 "위치 정보가 있는 사진을 찾지 못했어요" 화면에 닫기 하나만
  /// 남아 **막다른 길이 됐다.** 같은 사진을 다시 훑어야 결과가 같다는 전제가
  /// 여기서는 틀리다 — 그 사이 사진을 새로 찍었을 수도, 설정에서 권한을 넓혔을
  /// 수도 있다.
  bool get canRescan => !limitedAccess;

  /// [registeredCellCount]는 **지우려면 `clearRegisteredCellCount`를 쓴다.**
  /// null을 넘기면 `??`가 기존 값을 살려 두므로 새 스캔이 지난 회차의 수를
  /// 물려받는다.
  PhotoScanProgress copyWith({
    PhotoScanStage? stage,
    int? processed,
    int? total,
    int? foundCoordinates,
    List<String>? resolvedDistrictCodes,
    int? retryCount,
    bool? limitedAccess,
    int? alreadyOnMapCellCount,
    int? newCellCount,
    int? registeredCellCount,
    bool clearRegisteredCellCount = false,
  }) => PhotoScanProgress(
    stage: stage ?? this.stage,
    processed: processed ?? this.processed,
    total: total ?? this.total,
    foundCoordinates: foundCoordinates ?? this.foundCoordinates,
    resolvedDistrictCodes: resolvedDistrictCodes ?? this.resolvedDistrictCodes,
    retryCount: retryCount ?? this.retryCount,
    limitedAccess: limitedAccess ?? this.limitedAccess,
    alreadyOnMapCellCount: alreadyOnMapCellCount ?? this.alreadyOnMapCellCount,
    newCellCount: newCellCount ?? this.newCellCount,
    registeredCellCount: clearRegisteredCellCount
        ? null
        : (registeredCellCount ?? this.registeredCellCount),
  );

  @override
  bool operator ==(Object other) =>
      other is PhotoScanProgress &&
      other.stage == stage &&
      other.processed == processed &&
      other.total == total &&
      other.foundCoordinates == foundCoordinates &&
      other.retryCount == retryCount &&
      other.limitedAccess == limitedAccess &&
      other.alreadyOnMapCellCount == alreadyOnMapCellCount &&
      other.newCellCount == newCellCount &&
      other.registeredCellCount == registeredCellCount &&
      _sameCodes(other.resolvedDistrictCodes, resolvedDistrictCodes);

  @override
  int get hashCode => Object.hash(
    stage,
    processed,
    total,
    foundCoordinates,
    retryCount,
    limitedAccess,
    alreadyOnMapCellCount,
    newCellCount,
    registeredCellCount,
    Object.hashAll(resolvedDistrictCodes),
  );

  static bool _sameCodes(List<String> a, List<String> b) {
    if (identical(a, b)) return true;
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}
