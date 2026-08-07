import '../../../common/model/terms_code.dart';
import '../model/agreement_status.dart';

/// 설정 도메인의 데이터 접근 경계(SPEC-0011 R9~R12). 구현은 GraphQL이고 생성 타입은
/// 이 인터페이스를 넘지 않는다(CLAUDE.md §3).
///
/// 실패는 전부 `SettingsFailure`를 던진다 — null로 뭉개면 호출부가 "없음"과 "실패"를
/// 구분하지 못한다.
abstract interface class SettingsRepository {
  /// 필수·선택 약관의 현재 동의 상태 전체(R9).
  Future<List<AgreementStatus>> fetchAgreements();

  /// 선택 약관 하나를 토글한다(R10). 갱신된 항목을 돌려주며, 서버가 항목을 주지
  /// 않으면 null이다 — 호출부가 낙관적 갱신을 되돌릴지 판단한다.
  Future<AgreementStatus?> updateAgreement({
    required TermsCode termsCode,
    required bool agreed,
  });

  /// 필수 약관 일괄 동의(R12). **전체 상태를 돌려준다** — 이 값으로 캐시를 갱신하면
  /// 재조회 없이 게이트가 풀린다.
  Future<List<AgreementStatus>> agreeToRequiredTerms(List<TermsCode> codes);
}
