import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ieuri_k_trip_spot/common/model/terms_code.dart';
import 'package:ieuri_k_trip_spot/common/storage/secure_storage.dart';
import 'package:ieuri_k_trip_spot/domain/auth/provider/auth_controller.dart';
import 'package:ieuri_k_trip_spot/domain/auth/provider/auth_repository_provider.dart';
import 'package:ieuri_k_trip_spot/domain/settings/model/agreement_status.dart';
import 'package:ieuri_k_trip_spot/domain/settings/model/settings_failure.dart';
import 'package:ieuri_k_trip_spot/domain/settings/provider/agreements_controller.dart';
import 'package:ieuri_k_trip_spot/domain/settings/repository/settings_repository.dart';

import '../auth/auth_test_doubles.dart';

/// 로그인된 세션 위에 [repo]를 꽂은 컨테이너.
///
/// **약관 provider는 인증을 watch한다** — `agreements`가 토큰의 주체를 보는 쿼리라
/// 미인증 상태에서는 아예 조회하지 않는다. 그래서 약관을 다루는 테스트는 세션이 먼저
/// 서 있어야 하고, 인증을 안 깔면 provider가 loading에 매달려 30초 타임아웃까지 간다.
Future<ProviderContainer> authenticatedContainer(
  FakeSettingsRepository repo,
) async {
  final SecureStorage secure = await seededSecureStorage(
    authenticated: true,
    onboarded: true,
  );
  final ProviderContainer container = ProviderContainer(
    overrides: [
      secureStorageProvider.overrideWithValue(secure),
      authRepositoryProvider.overrideWithValue(FakeAuthRepository()),
      settingsRepositoryProvider.overrideWithValue(repo),
    ],
  );
  // 약관 provider가 인증을 watch하므로 먼저 해소해 둔다.
  await container.read(authControllerProvider.future);
  return container;
}

/// 약관 상태 하나를 만드는 헬퍼. 테스트가 관심 있는 필드만 적게 한다.
AgreementStatus agreement(
  TermsCode code, {
  bool required = false,
  bool agreed = false,
  String? agreedAt,
  String version = 'v1',
}) => AgreementStatus(
  termsCode: code,
  required: required,
  agreed: agreed,
  agreedAt: agreedAt,
  version: version,
);

/// 필수 둘(동의) + 선택 둘(미동의)의 기본 목록.
List<AgreementStatus> defaultAgreements() => <AgreementStatus>[
  agreement(
    TermsCode.service,
    required: true,
    agreed: true,
    agreedAt: '2026-01-12',
  ),
  agreement(
    TermsCode.privacy,
    required: true,
    agreed: true,
    agreedAt: '2026-01-12',
  ),
  agreement(TermsCode.location),
  agreement(TermsCode.marketing),
];

/// 네트워크 없는 [SettingsRepository]. 반환값과 실패를 테스트가 정한다.
class FakeSettingsRepository implements SettingsRepository {
  FakeSettingsRepository({List<AgreementStatus>? agreements})
    : agreements = agreements ?? defaultAgreements();

  List<AgreementStatus> agreements;

  /// true면 [updateAgreement]가 실패한다 — 낙관적 갱신의 롤백을 관찰하는 스위치.
  bool failUpdate = false;

  /// true면 [agreeToRequiredTerms]가 실패한다.
  bool failAgree = false;

  /// 마지막 [agreeToRequiredTerms] 호출에 실린 코드들.
  List<TermsCode>? agreedCodes;

  @override
  Future<List<AgreementStatus>> fetchAgreements() async => agreements;

  /// 코드별로 응답을 붙잡아 둔다. 두 토글을 **동시에 띄워** 롤백이 서로를 덮는지
  /// 보려면 첫 요청이 응답하기 전에 둘째를 시작할 수 있어야 한다.
  final Map<TermsCode, Completer<void>> gates = <TermsCode, Completer<void>>{};

  /// 이 코드의 [updateAgreement]만 실패시킨다. [failUpdate]가 전부를 실패시키는 것과
  /// 달리, 한쪽만 실패했을 때 다른 쪽이 멀쩡한지 보는 데 쓴다.
  final Set<TermsCode> failCodes = <TermsCode>{};

  @override
  Future<AgreementStatus?> updateAgreement({
    required TermsCode termsCode,
    required bool agreed,
  }) async {
    final Completer<void>? gate = gates[termsCode];
    if (gate != null) await gate.future;
    if (failUpdate || failCodes.contains(termsCode)) {
      throw SettingsFailure.userError('NOPE');
    }
    // **`required`를 보존한다.** 서버는 그 약관이 필수인지 여부를 그대로 되돌려
    // 주는데, 여기서 기본값(false)으로 새로 만들면 필수 항목이 갱신 후 선택으로
    // 둔갑해 `requiredSatisfied`가 늘 true가 된다 — 게이트 검증이 통째로 무의미해진다.
    final AgreementStatus? existing = agreements
        .where((AgreementStatus a) => a.termsCode == termsCode)
        .firstOrNull;
    return agreement(
      termsCode,
      agreed: agreed,
      required: existing?.required ?? false,
    );
  }

  @override
  Future<List<AgreementStatus>> agreeToRequiredTerms(
    List<TermsCode> codes,
  ) async {
    agreedCodes = codes;
    if (failAgree) throw SettingsFailure.network;
    return agreements
        .map(
          (AgreementStatus a) =>
              codes.contains(a.termsCode) ? a.copyWith(agreed: true) : a,
        )
        .toList();
  }
}
