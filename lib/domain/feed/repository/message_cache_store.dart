import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../common/model/post_author.dart';
import '../model/message.dart';

/// 대화 메시지의 로컬 캐시(R18).
///
/// **서버가 원본이고 로컬은 사본이다**(설계 §7). 로컬을 원본으로 두는 설계(카카오톡식)는
/// 동기화·충돌·백업을 직접 만들어야 해서 이번 범위를 넘는다.
///
/// 캐시가 지키는 성질은 셋이다:
/// - 대화를 다시 열면 캐시된 메시지를 **즉시** 그린다. 빈 화면을 거치지 않는다(AC18-1)
/// - **서버의 6개월 보관 기간이 로컬 기록을 지우지 않는다**(AC18-3). 서버에서 사라진
///   메시지가 로컬에 남아 있으면 그대로 보여준다
/// - 캐시가 비어 있어도 정상 동작한다(AC18-4). **캐시는 최적화이지 동작의 전제가
///   아니다**
///
/// 정리 정책은 이번 스펙에서 정하지 않는다 — 용량이 문제가 되면 그때 다룬다. 지금
/// 근거 없는 상한을 박지 않는다(POL-044).
///
/// 토큰·비밀값이 아니라 일반 데이터라 `flutter_secure_storage`가 아니라
/// [SharedPreferences]를 쓴다(CLAUDE.md §7의 대상은 토큰·비밀값이다). DM 본문이
/// 기기에 평문으로 남는 것은 서버 at-rest 암호화(R16)와 별개 문제이며, 기기 저장소
/// 암호화는 이번 범위 밖이다.
///
/// **인터페이스로 둔 이유**는 notifier 단위 테스트가 저장소를 교체할 수 있게 하기
/// 위해서다. provider 선언은 `provider/` 계층이 갖는다(CLAUDE.md §3).
abstract interface class MessageCacheStore {
  /// 한 대화의 캐시된 메시지를 최신순으로 읽는다. 캐시가 없으면 빈 목록이다 —
  /// **오류가 아니다**(AC18-4).
  List<Message> read(String conversationId);

  /// 한 대화의 캐시를 통째로 저장한다. 호출부가 병합·정렬을 마친 목록을 넘긴다.
  Future<void> write(String conversationId, List<Message> messages);
}

/// 서버 응답과 캐시를 합친다(AC18-3).
///
/// **서버에 없다는 이유로 기기의 기록을 삭제하지 않는다.** 서버가 6개월 지난 메시지를
/// 지워도 로컬에 남아 있으면 그대로 보여준다. 그래서 이 병합은 교체가 아니라 합집합이다.
///
/// 같은 id가 양쪽에 있으면 **서버 값이 이긴다** — 서버가 원본이므로 최신이다.
/// 전송 중·실패한 로컬 메시지는 아직 서버에 없으므로 그대로 남는다.
///
/// 결과는 [Message.createdAt] 내림차순(최신순)이며, 같은 시각이면 id로 안정 정렬한다
/// — 순서가 매 조회마다 흔들리면 화면이 튄다.
List<Message> mergeCachedMessages({
  required List<Message> cached,
  required List<Message> fromServer,
}) {
  final merged = <String, Message>{for (final m in cached) m.id: m};
  for (final m in fromServer) {
    merged[m.id] = m;
  }
  final result = merged.values.toList()
    ..sort((a, b) {
      final byTime = b.createdAt.compareTo(a.createdAt);
      return byTime != 0 ? byTime : a.id.compareTo(b.id);
    });
  return result;
}

/// [SharedPreferences] 기반 구현.
///
/// 대화별로 키를 나눈다 — 한 덩어리에 모으면 대화 하나를 읽으려 전부 역직렬화해야 한다.
class SharedPreferencesMessageCacheStore implements MessageCacheStore {
  SharedPreferencesMessageCacheStore(this._prefs);

  final SharedPreferences _prefs;

  static const String _keyPrefix = 'dm_messages_';

  String _keyFor(String conversationId) => '$_keyPrefix$conversationId';

  @override
  List<Message> read(String conversationId) {
    final raw = _prefs.getStringList(_keyFor(conversationId));
    if (raw == null) return const <Message>[];
    final messages = <Message>[];
    for (final line in raw) {
      final message = _decode(line);
      // 형식이 깨진 항목은 건너뛴다 — 캐시 한 줄 때문에 대화 전체를 못 열면
      // 캐시가 동작의 전제가 되어버린다(AC18-4).
      if (message != null) messages.add(message);
    }
    return messages;
  }

  @override
  Future<void> write(String conversationId, List<Message> messages) {
    // 전송 중·실패한 메시지는 캐시하지 않는다 — 서버가 받았다는 보장이 없어
    // 다음 실행에서 되살아나면 보낸 적 없는 메시지가 보인다.
    final durable = messages
        .where((m) => m.status == MessageDeliveryStatus.sent && !m.localId)
        .map(_encode)
        .toList();
    return _prefs.setStringList(_keyFor(conversationId), durable);
  }

  static String _encode(Message m) => jsonEncode(<String, Object?>{
    'id': m.id,
    'body': m.body,
    'senderId': m.sender.id,
    'senderNickname': m.sender.nickname,
    'senderProfileImageUrl': m.sender.profileImageUrl,
    'createdAt': m.createdAt.toIso8601String(),
    'ownedByViewer': m.ownedByViewer,
  });

  static Message? _decode(String line) {
    try {
      final json = jsonDecode(line);
      if (json is! Map<String, Object?>) return null;
      final id = json['id'];
      final body = json['body'];
      final senderId = json['senderId'];
      final nickname = json['senderNickname'];
      final createdAt = DateTime.tryParse(json['createdAt'] as String? ?? '');
      if (id is! String || body is! String) return null;
      if (senderId is! String || nickname is! String || createdAt == null) {
        return null;
      }
      return Message(
        id: id,
        body: body,
        sender: PostAuthor(
          id: senderId,
          nickname: nickname,
          profileImageUrl: json['senderProfileImageUrl'] as String?,
        ),
        createdAt: createdAt,
        ownedByViewer: json['ownedByViewer'] == true,
      );
    } on FormatException {
      return null;
    }
  }
}
