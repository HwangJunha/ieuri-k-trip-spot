import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../common/pagination/page.dart';
import '../model/spot_question.dart';
import '../repository/spot_qa_repository.dart';
import 'spot_qa_providers.dart';

part 'spot_question_by_id_providers.g.dart';

/// id 하나로 질문을 집어 온다(2026-08-18 서버가 `ids` 필터를 더했다).
///
/// **딥링크·알림 진입의 폴백이다.** 상세 화면은 보통 목록 provider가 이미 받아 둔
/// 항목에서 질문을 찾는데, 목록을 거치지 않고 들어오거나 아직 받지 못한 페이지의
/// 질문이면 거기 없다. 예전에는 그 경우 "불러오지 못했습니다"로 끝났지만 이제
/// 서버에 직접 물어 연다.
///
/// **없으면 null이다. 오류가 아니다.** 차단·숨김·삭제로 가려진 질문은 결과에서
/// 빠지도록 서버가 정해 두었고, 그 구분은 클라이언트에 오지 않는다 — "없거나 볼 수
/// 없음"을 하나로 다룬다.
@Riverpod(retry: spotQaRetryPolicy)
Future<SpotQuestion?> spotQuestionById(Ref ref, String questionId) async {
  final SpotQaRepository repository = ref.watch(spotQaRepositoryProvider);
  final CursorPage<SpotQuestion> page = await repository.fetchQuestionsByIds(
    <String>[questionId],
    first: 1,
  );
  return page.items.isEmpty ? null : page.items.first;
}
