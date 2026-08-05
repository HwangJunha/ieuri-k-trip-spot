import '../../../l10n/gen/app_localizations.dart';
import '../model/post_topic.dart';

/// [PostTopic]의 표시 문자열(POL-023, 가이드 §10).
///
/// **서버는 표시명을 내려주지 않는다** — enum은 안정 식별자이고 매핑은 클라이언트
/// 몫이다. `SpotCategory`가 이미 같은 방식이라 선례를 따른다. 네 언어 모두 ARB에
/// 값이 있어야 하며, 누락되면 여기서 컴파일이 깨진다(switch가 전수라서).
///
/// 탐색 타일의 `title`은 반대다 — 서버가 언어에 맞는 문자열을 내려주므로 **그대로
/// 표시하고 매핑하지 않는다.**
String postTopicLabel(AppLocalizations l10n, PostTopic topic) =>
    switch (topic) {
      PostTopic.question => l10n.communityTopicQuestion,
      PostTopic.tip => l10n.communityTopicTip,
      PostTopic.review => l10n.communityTopicReview,
      PostTopic.companion => l10n.communityTopicCompanion,
      PostTopic.photo => l10n.communityTopicPhoto,
    };

/// 작성 시각을 상대 표기로 옮긴다. 하루가 넘으면 일 단위로만 보여주고 날짜를 찍지
/// 않는다 — 피드의 관심사는 "얼마나 최근인가"이지 정확한 날짜가 아니다.
///
/// [now]를 인자로 받는 이유는 테스트가 시간을 고정하기 위해서다.
String relativePostTime(
  AppLocalizations l10n,
  DateTime createdAt,
  DateTime now,
) {
  final Duration elapsed = now.difference(createdAt);
  // 서버 시계가 살짝 앞서면 음수가 나온다. 미래 시각은 "방금"으로 접는다.
  if (elapsed.inMinutes < 1) return l10n.communityTimeJustNow;
  if (elapsed.inHours < 1) return l10n.communityTimeMinutes(elapsed.inMinutes);
  if (elapsed.inDays < 1) return l10n.communityTimeHours(elapsed.inHours);
  return l10n.communityTimeDays(elapsed.inDays);
}
