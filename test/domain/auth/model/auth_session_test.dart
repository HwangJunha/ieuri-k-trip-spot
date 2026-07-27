import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/domain/auth/model/auth_session.dart';
import 'package:ieuri_k_trip_spot/domain/auth/model/me.dart';

void main() {
  test('AuthSession carries the server-provided token type and expiries', () {
    const AuthSession session = AuthSession(
      accessToken: 'a',
      refreshToken: 'r',
      tokenType: 'Bearer',
      accessTokenExpiresIn: 300,
      refreshTokenExpiresIn: 2592000,
    );

    expect(session.tokenType, 'Bearer');
    expect(session.accessTokenExpiresIn, 300);
    expect(session.refreshTokenExpiresIn, 2592000);
    expect(session.user, isNull);
  });

  test('copyWith attaches the Me user without touching the tokens', () {
    const AuthSession tokens = AuthSession(accessToken: 'a', refreshToken: 'r');
    const Me me = Me(id: '7', email: 'a@b.com', nickname: 'Traveler');

    final AuthSession full = tokens.copyWith(user: me);

    expect(full.accessToken, 'a');
    expect(full.user, me);
  });

  test('equality includes tokens, expiries, and user', () {
    const AuthSession a = AuthSession(
      accessToken: 'a',
      refreshToken: 'r',
      accessTokenExpiresIn: 300,
    );
    const AuthSession b = AuthSession(
      accessToken: 'a',
      refreshToken: 'r',
      accessTokenExpiresIn: 300,
    );
    const AuthSession c = AuthSession(
      accessToken: 'a',
      refreshToken: 'r',
      accessTokenExpiresIn: 999,
    );

    expect(a, b);
    expect(a, isNot(c));
  });
}
