import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../model/spot_qa_failure.dart';
import '../repository/spot_qa_repository.dart';
import 'spot_qa_providers.dart';

part 'spot_qa_composer_providers.g.dart';

/// 본문 최대 길이(계약 — 1~500자, 서버가 앞뒤 공백을 제거한 뒤 판정한다).
const int kSpotQaBodyMaxLength = 500;

/// 무엇을 쓰는 중인지. 대상에 따라 부르는 뮤테이션이 다르다.
enum SpotQaComposerTarget {
  /// 장소에 질문하기.
  question,

  /// 질문에 답변하기.
  answer,

  /// 답변에 답글 달기(1단계만).
  reply,
}

/// 작성 폼 상태.
///
/// **제출 실패가 [body]를 지우지 않는다.** 무엇 때문에 거절됐든 화면을 닫지 않고
/// 안내만 띄운다 — 사용자가 쓴 글을 서버 사정으로 날리는 것은 과하다.
class SpotQaComposerState {
  const SpotQaComposerState({
    this.body = '',
    this.isSubmitting = false,
    this.errorCode,
  });

  final String body;
  final bool isSubmitting;

  /// 마지막 제출이 남긴 서버 오류 코드. 다음 입력·제출에서 지운다.
  final String? errorCode;

  /// 공백만으로는 제출할 수 없다 — 서버도 트림 후 1자 미만을 거부한다.
  String get trimmedBody => body.trim();

  bool get canSubmit =>
      !isSubmitting &&
      trimmedBody.isNotEmpty &&
      trimmedBody.length <= kSpotQaBodyMaxLength;

  SpotQaComposerState copyWith({
    String? body,
    bool? isSubmitting,
    String? errorCode,
    bool clearError = false,
  }) => SpotQaComposerState(
    body: body ?? this.body,
    isSubmitting: isSubmitting ?? this.isSubmitting,
    errorCode: clearError ? null : (errorCode ?? this.errorCode),
  );
}

/// 질문·답변·답글 작성 폼(R3·R4·R7).
///
/// **낙관적으로 목록에 넣지 않는다**(설계 §상태 관리). 서버가 자격을 판정하므로
/// 거부 시 롤백이 필요한데, 그 사이 사용자가 자기 글을 이미 본 상태가 된다. 작성은
/// 서버 응답을 기다린 뒤 목록을 갱신한다.
///
/// [targetId]는 대상에 따라 다르다 — 질문이면 `catalogId`, 답변이면 `questionId`,
/// 답글이면 `parentAnswerId`.
@riverpod
class SpotQaComposer extends _$SpotQaComposer {
  SpotQaRepository get _repository => ref.read(spotQaRepositoryProvider);

  @override
  SpotQaComposerState build(SpotQaComposerTarget target, String targetId) =>
      const SpotQaComposerState();

  /// 입력이 바뀌면 지난 오류를 지운다 — 고친 뒤에도 빨간 안내가 남아 있으면
  /// 사용자는 아직 막혀 있다고 읽는다.
  void updateBody(String value) =>
      state = state.copyWith(body: value, clearError: true);

  /// 제출한다. 성공하면 새로 만들어진 id, 실패하면 사유 코드가 담긴 결과를 준다.
  ///
  /// **사진은 보내지 않는다** — 업로드 뮤테이션이 서버에 없어 이번 범위에서 빠졌다
  /// (설계 §사진 첨부). 서버가 구현하면 여기서 확정 키를 채운다.
  Future<SpotQaMutationResult<String>> submit() async {
    if (!state.canSubmit) {
      return const SpotQaMutationResult<String>.failure(null);
    }

    final String body = state.trimmedBody;
    state = state.copyWith(isSubmitting: true, clearError: true);

    late final SpotQaMutationResult<String> result;
    try {
      result = switch (target) {
        SpotQaComposerTarget.question => await _repository.createQuestion(
          catalogId: targetId,
          body: body,
        ),
        SpotQaComposerTarget.answer => await _repository.createAnswer(
          questionId: targetId,
          body: body,
        ),
        SpotQaComposerTarget.reply => await _repository.createReply(
          parentAnswerId: targetId,
          body: body,
        ),
      };
    } on Object {
      // 전송·인증 실패도 입력을 지우지 않는다 — 다시 시도하면 되는 상황이다.
      state = state.copyWith(isSubmitting: false);
      rethrow;
    }

    if (!result.succeeded) {
      // **본문을 그대로 둔다.** 자격 없음이든 다른 규칙 위반이든, 사용자가 쓴 글을
      // 날리지 않고 안내만 띄운다.
      state = state.copyWith(isSubmitting: false, errorCode: result.errorCode);
      return result;
    }

    state = const SpotQaComposerState();
    return result;
  }
}
