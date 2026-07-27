/// Client-side password policy (spec §5.2, confirmed Q3): at least 8 characters
/// and must contain a letter, a digit, and a special character. Pure value
/// logic so it can be unit-tested and reused by the sign-up form.
class PasswordPolicy {
  const PasswordPolicy._();

  static const int minLength = 8;

  static final RegExp _letter = RegExp(r'[A-Za-z]');
  static final RegExp _digit = RegExp(r'\d');
  static final RegExp _special = RegExp(r'[^A-Za-z0-9]');

  static bool isValid(String password) =>
      password.length >= minLength &&
      _letter.hasMatch(password) &&
      _digit.hasMatch(password) &&
      _special.hasMatch(password);
}

/// Minimal RFC-ish email shape check (spec §5.1/§5.2). Not exhaustive by design.
class EmailFormat {
  const EmailFormat._();

  static final RegExp _pattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  static bool isValid(String email) => _pattern.hasMatch(email.trim());
}
