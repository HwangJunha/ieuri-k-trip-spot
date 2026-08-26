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

    // **밝기 순서를 색 이름에 맡길 수 없다.** 이 앱의 라이트 스킴은 손으로 지정한
    // 값이라 `surfaceContainerHighest`가 `surfaceContainerLow`보다 어둡고, 시드에서
    // 파생되는 다크 스킴은 반대다. 이름만 보고 고르면 한쪽 모드에서 시머가 어두운
    // 쪽으로 흘러 얼룩처럼 보인다.
    //
    // 그래서 두 색을 밝기로 정렬해 **어두운 쪽을 바탕, 밝은 쪽을 빛**으로 쓴다 —
    // 어느 모드에서도 빛이 지나가는 방향이 같아진다.
    final Color a = scheme.surfaceContainerHighest;
    final Color b = scheme.surfaceContainerLow;
    final bool aIsDarker =
        a.computeLuminance() < b.computeLuminance();
    final Color base = aIsDarker ? a : b;
    final Color highlight = aIsDarker ? b : a;

    return Skeletonizer(
      enabled: enabled,
      // 대비를 키우지 않는다. 뼈대가 실제 콘텐츠보다 눈에 띄면 로딩이 더 길게
      // 느껴진다.
      effect: ShimmerEffect(
        baseColor: base,
        highlightColor: highlight,
        duration: const Duration(milliseconds: 1200),
      ),
      // 텍스트 뼈대의 모서리. 본문 글자 높이에 맞춰 완전한 알약이 되지 않을 만큼만
      // 깎는다.
      textBoneBorderRadius: const TextBoneBorderRadius(
        BorderRadius.all(Radius.circular(4)),
      ),
      // 뼈대는 탭을 먹지 않는다. 더미 모델로 그린 진짜 위젯이라 그대로 두면 아직
      // 오지도 않은 항목의 `onTap`이 돌아 엉뚱한 상세로 들어간다.
      ignorePointers: true,
      child: child,
    );
  }
}
