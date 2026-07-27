import 'me.dart';

/// A live authenticated session: the token pair (with server-provided type and
/// expiries) plus the account it belongs to.
///
/// The login payload (`AuthTokenPayload`) carries no user, so [user] is fetched
/// separately via `me` and attached by the controller (spec §4.2/§6.2). Expiry
/// seconds come straight from the server — we trust `accessTokenExpiresIn` /
/// `refreshTokenExpiresIn`, not a hardcoded policy (spec §6.3).
///
/// Tokens live here only in memory while the app runs; the durable copy lives in
/// secure storage (spec §8). This model never persists itself.
class AuthSession {
  const AuthSession({
    required this.accessToken,
    required this.refreshToken,
    this.tokenType = 'Bearer',
    this.accessTokenExpiresIn,
    this.refreshTokenExpiresIn,
    this.user,
  });

  final String accessToken;
  final String refreshToken;
  final String tokenType;

  /// Access-token lifetime in seconds, as reported by the server (spec §6.3).
  final int? accessTokenExpiresIn;

  /// Refresh-token lifetime in seconds, as reported by the server.
  final int? refreshTokenExpiresIn;

  /// The account, attached by the controller after a `me` fetch. Null until then
  /// (login itself returns no user).
  final Me? user;

  AuthSession copyWith({
    String? accessToken,
    String? refreshToken,
    String? tokenType,
    int? accessTokenExpiresIn,
    int? refreshTokenExpiresIn,
    Me? user,
  }) => AuthSession(
    accessToken: accessToken ?? this.accessToken,
    refreshToken: refreshToken ?? this.refreshToken,
    tokenType: tokenType ?? this.tokenType,
    accessTokenExpiresIn: accessTokenExpiresIn ?? this.accessTokenExpiresIn,
    refreshTokenExpiresIn: refreshTokenExpiresIn ?? this.refreshTokenExpiresIn,
    user: user ?? this.user,
  );

  @override
  bool operator ==(Object other) =>
      other is AuthSession &&
      other.accessToken == accessToken &&
      other.refreshToken == refreshToken &&
      other.tokenType == tokenType &&
      other.accessTokenExpiresIn == accessTokenExpiresIn &&
      other.refreshTokenExpiresIn == refreshTokenExpiresIn &&
      other.user == user;

  @override
  int get hashCode => Object.hash(
    accessToken,
    refreshToken,
    tokenType,
    accessTokenExpiresIn,
    refreshTokenExpiresIn,
    user,
  );
}
