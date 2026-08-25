import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

/// 로딩 중 시머 스켈레톤. **앱 전체가 같은 로딩 모양을 쓰기 위한 단일 진입점이다.**
///
/// ## 왜 화면마다 `Skeletonizer`를 직접 부르지 않는가
///
/// 효과·색·모서리 반경을 호출부가 각자 정하면 화면마다 로딩이 달라 보인다. 이 저장소는
/// 이미 그 판단을 내려 뒀다 — `region_recommendation_screen.dart`의 주석이 "이 화면만
/// 스켈레톤을 두면 로딩 모양이 화면마다 달라진다"며 스켈레톤 도입을 **전 화면 일괄
/// 결정으로 미뤄** 두고 중앙 스피너를 쓰고 있었다. 이 위젯이 그 결정이다.
///
/// ## 어떻게 쓰는가 — 가짜 데이터로 진짜 위젯을 그린다
///
/// 스켈레톤 레이아웃을 손으로 그리지 않는다. **실제 카드 위젯에 더미 모델을 넣어
/// 그대로 그린 뒤** 이 위젯으로 감싸면 skeletonizer가 텍스트·아이콘·박스를 뼈대로
/// 바꾼다. 카드 디자인이 바뀌면 스켈레톤이 저절로 따라가므로 둘이 어긋날 수 없다.
///
/// ```dart
/// AppSkeleton(
///   child: Column(children: dummySpots.map(SpotCard.new).toList()),
/// )
/// ```
///
/// 더미 모델의 이미지 URL에는 **빈 문자열을 준다.** `SpotThumbnail`이 `http`로
/// 시작하지 않는 값을 색블록으로 폴백하므로, 스켈레톤이 네트워크 요청을 내지 않는다.
class AppSkeleton extends StatelessWidget {
  const AppSkeleton({super.key, required this.child, this.enabled = true});

  final Widget child;

  /// false면 [child]를 그대로 그린다. 로딩 여부를 호출부가 이미 갈라냈다면 기본값을
  /// 쓰고, 한 위젯이 두 상태를 모두 맡는다면 이 값으로 전환한다.
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;

    return Skeletonizer(
      enabled: enabled,
      // 시머는 표면색에서 살짝 밝은 쪽으로만 흐른다. 대비를 키우면 뼈대가 실제
      // 콘텐츠보다 눈에 띄어 로딩이 더 길게 느껴진다.
      effect: ShimmerEffect(
        baseColor: scheme.surfaceContainerHighest,
        highlightColor: scheme.surfaceContainerLow,
        duration: const Duration(milliseconds: 1200),
      ),
      // 텍스트 뼈대의 모서리. 본문 글자 높이에 맞춰 완전한 알약이 되지 않을 만큼만
      // 깎는다.
      textBoneBorderRadius: const TextBoneBorderRadius(
        BorderRadius.all(Radius.circular(4)),
      ),
      // 뼈대를 누르면 그 아래 진짜 위젯의 콜백이 돈다 — 로딩 중 오작동을 막는다.
      ignorePointers: true,
      child: child,
    );
  }
}
