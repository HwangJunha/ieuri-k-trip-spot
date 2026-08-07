import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/common/network/media_cdn.dart';

/// 프로필 이미지 값 → 표시 가능한 URL.
///
/// 서버의 `profileImageUrl`은 이름과 달리 **오브젝트 키일 수 있다**(업로드 확정이
/// 돌려주는 값이 그대로 나온다). 키를 그대로 `NetworkImage`에 넘기면 스킴이 없어
/// `_HttpClient._openUrl`에서 예외가 나고, **위젯 페인트 중이라 앱이 빨간 화면이
/// 된다.** 실제로 그렇게 터졌다.
void main() {
  test('완전한 URL은 그대로 둔다', () {
    expect(
      MediaCdn.profileImage('https://cdn.example.com/a.jpg'),
      'https://cdn.example.com/a.jpg',
    );
  });

  test('오브젝트 키에는 CDN 베이스를 붙인다', () {
    final String? url = MediaCdn.profileImage('profile/7/avatar.jpg');

    expect(url, isNotNull);
    expect(Uri.parse(url!).hasScheme, isTrue, reason: '스킴이 없으면 NetworkImage가 던진다');
    expect(url, endsWith('profile/7/avatar.jpg'));
  });

  test('앞의 슬래시가 있어도 경로가 겹치지 않는다', () {
    expect(
      MediaCdn.profileImage('/profile/7/avatar.jpg'),
      MediaCdn.profileImage('profile/7/avatar.jpg'),
    );
  });

  test('null과 빈 문자열은 null이다', () {
    expect(MediaCdn.profileImage(null), isNull);
    expect(MediaCdn.profileImage(''), isNull);
    expect(MediaCdn.profileImage('   '), isNull);
  });

  test('결과는 언제나 파싱 가능한 절대 URL이다', () {
    for (final String raw in <String>[
      'profile/7/avatar.jpg',
      '/profile/7/avatar.jpg',
      'https://cdn.example.com/a.jpg',
    ]) {
      final Uri uri = Uri.parse(MediaCdn.profileImage(raw)!);
      expect(uri.hasScheme, isTrue, reason: raw);
      expect(uri.host, isNotEmpty, reason: raw);
    }
  });
}
