import 'post_topic.dart';

/// 커뮤니티 탭 상단의 탐색 타일(서버 `DiscoveryTile`).
///
/// **[title]은 서버가 내려준 문자열을 그대로 표시한다** — 운영자가 시즌마다 바꾸는
/// 자유 문구라 매핑할 enum이 없다(가이드 §10). 클라이언트가 매핑하려 들면 안 된다.
///
/// 타일은 `Accept-Language` 헤더로 언어를 고르며, **해당 언어의 타일이 없으면 빈
/// 목록이고 다른 언어로 대체되지 않는다.** 어드민이 아직 없어 당분간 비어 있을 수
/// 있으므로 **빈 목록은 정상**이며 레이아웃이 그 경우를 허용해야 한다(가이드 §15).
class DiscoveryTile {
  const DiscoveryTile({
    required this.id,
    required this.title,
    this.imageUrl,
    this.filterTopic,
    this.filterTargetType,
  });

  final String id;

  /// 서버 문자열. 그대로 표시한다.
  final String title;

  /// 타일 배경 이미지. 없으면(null) 색 배경으로 대체한다.
  final String? imageUrl;

  /// 탭했을 때 적용할 주제 필터. null이면 주제 필터를 걸지 않는다.
  final PostTopic? filterTopic;

  /// 탭했을 때 적용할 대상 종류 필터. 지금 화면(지역 피드)은 이 값을 쓰지 않지만
  /// 서버가 내려주므로 보유한다.
  final PostTargetType? filterTargetType;

  @override
  bool operator ==(Object other) =>
      other is DiscoveryTile &&
      other.id == id &&
      other.title == title &&
      other.imageUrl == imageUrl &&
      other.filterTopic == filterTopic &&
      other.filterTargetType == filterTargetType;

  @override
  int get hashCode =>
      Object.hash(id, title, imageUrl, filterTopic, filterTargetType);
}
