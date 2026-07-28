/// The SNS identity providers the server accepts (schema `Provider`). Pure
/// domain enum so the login buttons, the SNS sign-up form, and the repository
/// share one source of truth without importing the generated GraphQL enum
/// (spec §6.1, CLAUDE.md §3).
enum SnsProvider {
  google,
  apple,
  kakao;

  /// The wire string the server expects (matches the schema `Provider` names).
  String get wireName => switch (this) {
    SnsProvider.google => 'GOOGLE',
    SnsProvider.apple => 'APPLE',
    SnsProvider.kakao => 'KAKAO',
  };
}
