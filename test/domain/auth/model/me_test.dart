import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/domain/auth/model/me.dart';

void main() {
  test('Me round-trips through JSON', () {
    const Me me = Me(
      id: '7',
      email: 'a@b.com',
      nickname: 'Traveler',
      profileImageUrl: 'https://x/y.png',
      status: MemberStatus.active,
      emailVerified: true,
      roles: <String>['USER'],
      permissions: <String>['spot:read'],
      createdAt: '2026-01-01T00:00:00Z',
    );

    final Me restored = Me.fromJson(me.toJson());

    expect(restored, me);
  });

  test('parses the wire status enum', () {
    final Me me = Me.fromJson(<String, dynamic>{
      'id': '1',
      'email': 'a@b.com',
      'nickname': 'n',
      'status': 'SUSPENDED',
      'emailVerified': false,
      'roles': <dynamic>[],
      'permissions': <dynamic>[],
      'createdAt': '',
    });

    expect(me.status, MemberStatus.suspended);
  });
}
