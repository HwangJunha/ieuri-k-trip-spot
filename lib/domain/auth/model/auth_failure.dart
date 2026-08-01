/// A domain-level auth failure, mapped from a server `userErrors[].code` or a
/// top-level GraphQL/transport error (spec §6.4). Carries no raw server text so
/// nothing sensitive is logged; the UI resolves a localized message from [kind].
///
/// [field] echoes the offending input field name when the server supplies one,
/// so the UI can show an inline error under that field.
enum AuthFailureKind {
  invalidCredentials,
  emailAlreadyInUse,

  /// SNS login for an account that doesn't exist yet (spec §4). The server
  /// rejects `loginSns` for an unregistered identity rather than auto-creating
  /// one; the caller routes the user to SNS sign-up.
  memberNotFound,
  network,
  unknown,
}

class AuthFailure implements Exception {
  const AuthFailure(this.kind, {this.field});

  final AuthFailureKind kind;
  final String? field;

  /// Maps a server `userErrors[].code` string to a domain failure kind.
  ///
  /// `UserError.code` is a `String` in the schema (not an enum), so the exact
  /// constants aren't discoverable statically. The candidates below are the
  /// common ones; unknown codes fall back to [AuthFailureKind.unknown].
  ///
  /// TODO(runtime): confirm the real code constants by exercising the live
  /// server (bad login, duplicate email, wrong verification code). The repo's
  /// `GraphqlDebugLog.userErrors` logs code/field in debug so they can be
  /// collected and this mapping finalized (spec §6.4).
  factory AuthFailure.fromCode(String? code, {String? field}) {
    switch (code) {
      case 'INVALID_CREDENTIALS':
        return AuthFailure(AuthFailureKind.invalidCredentials, field: field);
      case 'EMAIL_TAKEN':
      case 'EMAIL_ALREADY_IN_USE':
        return AuthFailure(AuthFailureKind.emailAlreadyInUse, field: field);
      case 'MEMBER_NOT_FOUND':
        return AuthFailure(AuthFailureKind.memberNotFound, field: field);
      default:
        return AuthFailure(AuthFailureKind.unknown, field: field);
    }
  }

  static const AuthFailure networkFailure = AuthFailure(
    AuthFailureKind.network,
  );

  @override
  bool operator ==(Object other) =>
      other is AuthFailure && other.kind == kind && other.field == field;

  @override
  int get hashCode => Object.hash(kind, field);

  @override
  String toString() => 'AuthFailure(${kind.name})';
}
