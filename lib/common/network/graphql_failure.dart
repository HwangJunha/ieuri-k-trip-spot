import 'package:graphql_flutter/graphql_flutter.dart';

/// Transport/system GraphQL failure detection shared by every feature
/// repository (CLAUDE.md §4). GraphQL returns HTTP 200 even on failure, so a
/// populated top-level `errors` array — or a link/connection exception — is a
/// failure. Repositories map the result to their own domain failure without
/// logging raw server text (tokens/PII, spec §6.4).
///
/// Detects a transport-level failure on a mutation/query [result]: a link
/// exception (no network / server unreachable) or a populated top-level
/// `errors` array. Does NOT inspect domain `userErrors` — that is the feature
/// repository's job (spec §6.4).
///
/// **부분 실패를 다루지 않는 연산 전용이다.** `errors[]`가 하나라도 있으면 전체
/// 실패로 본다. 커넥션이나 중첩 필드가 있어 일부만 실패할 수 있는 조회에는
/// [hasRootFailure]를 쓸 것 — 이 함수를 쓰면 갤러리 하나 실패에 화면 전체가
/// 오류가 된다(SPEC-0008 R-7).
bool hasTransportFailure(QueryResult<Object?> result) =>
    result.hasException &&
    (result.exception?.linkException != null ||
        (result.exception?.graphqlErrors.isNotEmpty ?? false));

/// 최상위 필드 [rootField]의 조회가 **통째로** 실패했는지(SPEC-0008 §2.1, AC-25).
///
/// `errors[]`가 비어있지 않다는 사실만으로 전체 실패를 단정하지 않는다. 부분 실패는
/// 같은 배열에 실려 오기 때문이다 — `path`가 `["spotDetail","gallery"]`면 갤러리
/// 하위 필드만 실패한 것이고 본문은 정상이므로 오류 화면을 띄우면 안 된다.
///
/// 판별 규칙은 **path의 길이**다:
/// - 링크 예외(연결 실패)는 응답 자체가 없으므로 항상 전체 실패다.
/// - `path`가 없거나 `[rootField]` 한 칸이면 그 필드의 해소가 실패한 것 → 전체 실패.
/// - `path`가 `[rootField, ...]`로 더 깊으면 하위 필드만 실패 → 부분 실패.
///
/// 다른 최상위 필드를 가리키는 오류는 이 조회의 관심사가 아니므로 무시한다.
///
/// 주의: DGS가 중첩 필드 실패에 실제로 이 형태를 내려주는지는 단위 테스트로 검증되지
/// 않는다(SPEC-0008 §8 `[TBD-3]`) — 실제 응답 육안 확인이 필요한 가정이다.
bool hasRootFailure(QueryResult<Object?> result, String rootField) =>
    result.exception?.linkException != null ||
    firstRootError(result, rootField) != null;

/// 전체 실패로 판정되는 **첫 오류**. 없으면 null(=부분 실패이거나 실패가 아님).
///
/// [hasRootFailure]와 **같은 술어를 쓴다.** 판정과 코드 추출이 서로 다른 오류를 보면
/// 어긋난다 — `ErrorPolicy.all` 이후로는 부분 실패와 전체 실패가 **같은 배열에 함께**
/// 실려 오기 때문이다. 예를 들어
/// `[{path:["spotDetail","gallery"]}, {path:["spotDetail"], code:"UNAUTHENTICATED"}]`
/// 에서 첫 항목만 보면 코드를 못 찾아 인증 실패가 네트워크 실패로 둔갑하고, 재시도
/// 상한에 계상되어 SPEC-0006 R5·AC-14가 깨진다.
GraphQLError? firstRootError(QueryResult<Object?> result, String rootField) {
  if (!result.hasException) return null;

  final List<GraphQLError> errors =
      result.exception?.graphqlErrors ?? const <GraphQLError>[];
  for (final GraphQLError error in errors) {
    final List<dynamic>? path = error.path;
    // path가 없으면 범위를 좁힐 근거가 없다 — 안전한 쪽(전체 실패)으로 본다.
    if (path == null || path.isEmpty) return error;
    if (path.first != rootField) continue;
    if (path.length == 1) return error;
  }
  return null;
}
