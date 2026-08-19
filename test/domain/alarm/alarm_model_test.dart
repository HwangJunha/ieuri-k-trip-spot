import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/domain/alarm/model/device_registration.dart';
import 'package:ieuri_k_trip_spot/domain/alarm/model/notification_preference.dart';
import 'package:ieuri_k_trip_spot/domain/alarm/model/push_destination.dart';

/// 알림 도메인의 순수 로직(SPEC-0028 §10). 위젯도 컨테이너도 필요 없다.

void main() {
  group('PushDestination.tryParse — 3종 페이로드 복원 (R11·R16)', () {
    test('DM은 대화 화면으로 간다', () {
      final PushDestination? result = PushDestination.tryParse(
        <String, String>{'type': 'DM', 'conversationId': '42'},
      );

      expect(result?.type, PushNotificationType.dm);
      expect(result?.location, '/conversations/42');
    });

    test('답변은 질문 상세로 간다', () {
      final PushDestination? result = PushDestination.tryParse(
        <String, String>{
          'type': 'SPOT_QA_ANSWER',
          'spotId': '7',
          'questionId': '13',
        },
      );

      expect(result?.type, PushNotificationType.spotQaAnswer);
      expect(result?.location, '/spot/7/qa/13');
    });

    test('답글도 같은 질문 상세로 간다 — 답글 단독 화면이 없다', () {
      final PushDestination? reply = PushDestination.tryParse(
        <String, String>{
          'type': 'SPOT_QA_REPLY',
          'spotId': '7',
          'questionId': '13',
        },
      );
      final PushDestination? answer = PushDestination.tryParse(
        <String, String>{
          'type': 'SPOT_QA_ANSWER',
          'spotId': '7',
          'questionId': '13',
        },
      );

      expect(reply?.location, answer?.location);
    });

    test('식별자에 경로 구분자가 있어도 라우트가 깨지지 않는다', () {
      final PushDestination? result = PushDestination.tryParse(
        <String, String>{'type': 'DM', 'conversationId': 'a/b'},
      );

      expect(
        result?.location,
        '/conversations/a%2Fb',
        reason: '이스케이프하지 않으면 다른 라우트로 흘러간다',
      );
    });
  });

  group('PushDestination.tryParse — 복원 실패는 null (AC16.4)', () {
    test('알 수 없는 type은 오류가 아니라 null이다', () {
      expect(
        PushDestination.tryParse(<String, String>{'type': 'SOMETHING_NEW'}),
        isNull,
        reason: '서버가 트리거를 더해도 구버전 앱이 죽으면 안 된다',
      );
    });

    test('type이 없으면 null이다', () {
      expect(PushDestination.tryParse(const <String, String>{}), isNull);
    });

    test('DM에 conversationId가 없으면 null이다', () {
      expect(
        PushDestination.tryParse(<String, String>{'type': 'DM'}),
        isNull,
      );
    });

    test('질문 상세는 spotId만으로 만들 수 없다', () {
      expect(
        PushDestination.tryParse(<String, String>{
          'type': 'SPOT_QA_ANSWER',
          'spotId': '7',
        }),
        isNull,
        reason: 'questionId도 경로 파라미터라 하나만으로는 라우트가 안 된다',
      );
    });

    test('질문 상세는 questionId만으로도 만들 수 없다', () {
      expect(
        PushDestination.tryParse(<String, String>{
          'type': 'SPOT_QA_ANSWER',
          'questionId': '13',
        }),
        isNull,
      );
    });

    test('빈 문자열 식별자는 없는 것으로 본다', () {
      expect(
        PushDestination.tryParse(<String, String>{
          'type': 'DM',
          'conversationId': '   ',
        }),
        isNull,
        reason: '빈 값으로 라우트를 만들면 `/conversations/`가 되어 엉뚱하다',
      );
    });
  });

  group('languageFromDeviceCode — 기기 언어 폴백 (AC20.3)', () {
    test('지원 언어는 그대로 옮긴다', () {
      expect(languageFromDeviceCode('ko'), 'KO');
      expect(languageFromDeviceCode('ja'), 'JA');
      expect(languageFromDeviceCode('zh'), 'ZH');
      expect(languageFromDeviceCode('en'), 'EN');
    });

    test('지역 태그가 붙어도 언어만 본다', () {
      expect(languageFromDeviceCode('ko_KR'), 'KO');
      expect(languageFromDeviceCode('zh-Hant-TW'), 'ZH');
    });

    test('지원하지 않는 언어는 EN이다', () {
      expect(languageFromDeviceCode('fr'), 'EN');
      expect(languageFromDeviceCode(''), 'EN');
    });
  });

  group('DeviceRegistration.digest — 재등록 판정 (R20)', () {
    DeviceRegistration registration({
      String deviceId = 'd1',
      String token = 't1',
      String language = 'KO',
    }) => DeviceRegistration(
      deviceId: deviceId,
      fcmToken: token,
      languageCode: language,
      platform: DevicePlatform.android,
    );

    test('같은 값이면 지문이 같다 — 재등록을 건너뛴다', () {
      expect(registration().digest, registration().digest);
    });

    test('언어가 바뀌면 지문이 달라진다', () {
      expect(
        registration(language: 'JA').digest,
        isNot(registration(language: 'KO').digest),
      );
    });

    test('토큰이 로테이션되면 지문이 달라진다', () {
      expect(
        registration(token: 't2').digest,
        isNot(registration(token: 't1').digest),
      );
    });

    test('지문에 원문이 남지 않는다', () {
      final DeviceRegistration value = registration(token: 'secret-value');
      expect(value.digest, isNot(contains('secret-value')));
    });

    test('toString이 토큰 원문을 흘리지 않는다 (POL-013)', () {
      final DeviceRegistration value = registration(token: 'secret-value');
      expect(value.toString(), isNot(contains('secret-value')));
    });
  });

  group('NotificationPreferenceList.isEnabled (R19)', () {
    test('목록의 값을 그대로 읽는다', () {
      const List<NotificationPreference> preferences =
          <NotificationPreference>[
            NotificationPreference(
              category: NotificationCategory.message,
              enabled: false,
            ),
            NotificationPreference(
              category: NotificationCategory.spotQa,
              enabled: true,
            ),
          ];

      expect(preferences.isEnabled(NotificationCategory.message), isFalse);
      expect(preferences.isEnabled(NotificationCategory.spotQa), isTrue);
    });

    test('목록에 없으면 켜진 것으로 본다 (AC10.3)', () {
      expect(
        const <NotificationPreference>[].isEnabled(
          NotificationCategory.message,
        ),
        isTrue,
        reason: '기본값은 켜짐이고, 꺼졌다고 오해시키는 쪽이 더 나쁘다',
      );
    });
  });

  group('NotificationCategory.fromWire', () {
    test('서버 문자열을 도메인 값으로 옮긴다', () {
      expect(
        NotificationCategory.fromWire('MESSAGE'),
        NotificationCategory.message,
      );
      expect(
        NotificationCategory.fromWire('SPOT_QA'),
        NotificationCategory.spotQa,
      );
    });

    test('모르는 값은 null이다', () {
      expect(NotificationCategory.fromWire('MARKETING'), isNull);
      expect(NotificationCategory.fromWire(null), isNull);
    });
  });
}
