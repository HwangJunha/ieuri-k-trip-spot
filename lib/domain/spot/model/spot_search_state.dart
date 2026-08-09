import 'spot_search_result.dart';

/// 검색 페이지의 상태(R11). 다섯 상태는 **서로 배타적이다**.
///
/// 특히 [SpotSearchEmpty]와 [SpotSearchFailed]를 하나로 뭉치지 않는다 — AC-11.2와
/// AC-11.3이 둘을 구분해 요구한다. 결과 0건은 정상이라 실패 문구도 재시도 버튼도
/// 쓰지 않고, 조회 실패만 재시도 수단을 준다.
///
/// `AsyncValue`를 쓰지 않고 전용 sealed 타입을 두는 이유는 "질의 없음(초기)"과
/// "질의했는데 0건"이 `AsyncValue`에서 둘 다 `data([])`로 같아지기 때문이다.
/// 화면은 전자에 최근 검색어를, 후자에 빈 결과 문구를 띄워야 한다.
sealed class SpotSearchState {
  const SpotSearchState();
}

/// 아직 검색하지 않았다 — 화면은 최근 검색어를 보여준다(설계 §2).
class SpotSearchIdle extends SpotSearchState {
  const SpotSearchIdle();
}

/// 질의를 보냈고 응답 전이다(AC-11.4).
class SpotSearchLoading extends SpotSearchState {
  const SpotSearchLoading(this.query);

  final String query;
}

/// 결과가 1건 이상이다(AC-11.1).
class SpotSearchLoaded extends SpotSearchState {
  const SpotSearchLoaded({
    required this.query,
    required this.result,
    this.isLoadingMore = false,
  });

  final String query;
  final SpotSearchResult result;

  /// 다음 페이지를 받는 중인지. 목록을 스피너로 갈아 끼우지 않고 끝에 인디케이터
  /// 한 칸만 붙이기 위해 별도 상태가 아니라 이 상태의 플래그로 둔다 — 추가 로딩
  /// 중에도 사용자는 이미 받은 결과를 계속 본다.
  final bool isLoadingMore;

  SpotSearchLoaded copyWith({SpotSearchResult? result, bool? isLoadingMore}) =>
      SpotSearchLoaded(
        query: query,
        result: result ?? this.result,
        isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      );
}

/// 결과가 0건이다. **정상 상태다**(AC-11.2).
class SpotSearchEmpty extends SpotSearchState {
  const SpotSearchEmpty(this.query);

  final String query;
}

/// 조회가 실패했다 — 화면이 재시도 수단을 준다(AC-11.3).
class SpotSearchFailed extends SpotSearchState {
  const SpotSearchFailed(this.query);

  /// 재시도가 같은 질의를 다시 보낼 수 있도록 들고 있는다.
  final String query;
}
