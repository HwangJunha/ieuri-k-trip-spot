import 'package:flutter/material.dart';

import 'category_chip_data.dart';

/// 상단 카테고리 바(spec §5). 호출부가 준 [available] 목록만 렌더한다 — 가용성의
/// 단일 출처는 서버이고, 클라이언트는 없는 카테고리를 하드코딩하지 않는다.
///
/// **목록을 provider에서 직접 읽지 않고 인자로 받는다.** 이 위젯은 spot·지도·
/// 커뮤니티가 함께 쓰므로 `common/`에 있는데(CLAUDE.md §4), 여기서 도메인 provider를
/// watch하면 common이 도메인 데이터 접근에 의존하게 되어 방향이 뒤집힌다. 목록을
/// 읽는 일은 화면이 맡고, 이 위젯은 그리기만 한다. 같은 이유로 [SpotCategory]나
/// `TargetCategory` 같은 도메인 타입도 알지 않는다 — 호출부가 [CategoryChipData]로
/// 옮겨 넘긴다.
///
/// **모양은 커뮤니티 줄을 따른다**(사용자 결정, 2026-08-15). 원형 아이콘 + 그 아래
/// 라벨. M3 `FilterChip`을 쓰던 시절보다 언어별 길이 차이에 강하고(칩 폭이 라벨을
/// 따라 늘지 않는다) 아이콘이 커서 자리로 기억하기 쉽다.
///
/// **맨 앞은 "전체"이며 모드 토글이다**(사용자 결정, 2026-08-15).
/// - "전체"를 누르면 개별 선택이 전부 풀린다([onSelectAll]) — 서버에는 카테고리
///   인자를 **보내지 않는다**(빈 배열은 서버가 거절한다).
/// - 개별 칩을 누르면 "전체"가 꺼지고 그 칩이 켜진다.
/// - 마지막 개별 칩을 끄면 선택이 비므로 "전체"가 저절로 다시 켜진다. 그래서
///   "마지막 하나는 해제 불가"라는 옛 규칙이 필요 없어졌다 — 빈 집합이 이제
///   막다른 상태가 아니라 "전체"라는 정상 상태다.
///
/// **선택 표시는 색·굵기에 [Semantics]를 더한다.** `FilterChip`은 체크 표시로
/// 선택을 알렸는데 이 디자인에는 그것이 없다. 색만으로 알리면 색각 이상에서
/// 구분되지 않으므로 접근성 트리에 선택 상태를 명시한다.
class CategoryBar extends StatelessWidget {
  const CategoryBar({
    super.key,
    required this.available,
    required this.selectedIds,
    required this.allLabel,
    required this.onToggle,
    required this.onSelectAll,
    this.onImage = false,
    this.allIcon = Icons.grid_view_rounded,
  });

  /// 사진 위에 얹히는가 — 라벨 색을 가른다(→[CategoryBarEntry.onImage]).
  final bool onImage;

  /// 첫 칩의 아이콘. 기본은 "전체"의 격자. Discover는 첫 칩이 「추천」이라(SPEC-0035)
  /// 문구와 함께 아이콘도 바꾼다 — 문구만 바꾸면 격자 아이콘이 "추천"을 말하지 않는다.
  final IconData allIcon;

  /// 그릴 카테고리. 비어 있으면 바 자체를 그리지 않는다 — 목록이 아직 오지 않았거나
  /// 조회에 실패한 상태이며, 그때 "전체" 하나만 남은 바는 자리만 차지한다.
  final List<CategoryChipData> available;

  /// 지금 켜진 카테고리의 [CategoryChipData.id] 집합. 비어 있으면 "전체"다.
  final Set<String> selectedIds;

  /// "전체" 칩의 표시 문구. 문자열을 l10n에서 읽는 일은 화면이 맡는다 — `common/`은
  /// `AppLocalizations`를 참조해도 되지만, 커뮤니티가 자기 키를 계속 쓸 수 있어야
  /// 해서 문구를 밖에서 받는다.
  final String allLabel;

  /// 개별 칩을 누를 때. 켜기·끄기 판단은 호출부(provider)가 한다.
  final ValueChanged<String> onToggle;

  /// "전체"를 누를 때. 개별 선택을 전부 푼다.
  final VoidCallback onSelectAll;

  @override
  Widget build(BuildContext context) {
    // 카테고리 목록 자체가 로딩/실패면 바를 접는다(본문 흐름을 막지 않음).
    if (available.isEmpty) return const SizedBox.shrink();

    final List<CategoryChipData> ordered = orderedCategoryChips(available);
    return SizedBox(
      height: 88,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        // **`children:`이 아니라 `builder`다.** 통짜 목록을 주면 화면 밖 칩까지
        // 매 빌드마다 즉시 만들어진다 — 칩 하나가 `Semantics`+`InkWell`+`Container`
        // +`Icon`+`Text`라 열 개면 그대로 열 배다. 이 바는 부모가 다시 빌드될
        // 때마다 함께 도는 자리라 그 비용이 반복된다.
        //
        // 0번은 "전체"이고 그 뒤가 개별 카테고리라 인덱스를 하나 민다.
        itemCount: ordered.length + 1,
        itemBuilder: (BuildContext context, int index) {
          if (index == 0) {
            return CategoryBarEntry(
              icon: allIcon,
              label: allLabel,
              selected: selectedIds.isEmpty,
              onTap: onSelectAll,
              onImage: onImage,
            );
          }
          final CategoryChipData chip = ordered[index - 1];
          return CategoryBarEntry(
            icon: chip.icon,
            label: chip.label,
            selected: selectedIds.contains(chip.id),
            onTap: () => onToggle(chip.id),
            onImage: onImage,
          );
        },
      ),
    );
  }
}

/// 항목 하나 — 원형 아이콘 + 그 아래 라벨.
///
/// 선택 상태는 원의 채움색과 라벨 굵기로 나타낸다. 테두리를 두르면 납작한 느낌이
/// 사라진다. 색만으로는 색각 이상에서 구분되지 않으므로 [Semantics]에 선택 여부를
/// 함께 싣는다 — 스크린 리더가 "선택됨"으로 읽는다.
///
/// **공개 위젯인 이유**: 커뮤니티가 같은 모양을 자기 단일 선택 규칙으로 쓴다.
class CategoryBarEntry extends StatelessWidget {
  const CategoryBarEntry({
    super.key,
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
    this.onImage = false,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  /// 사진 위에 얹히는가.
  ///
  /// 참이면 라벨을 흰색으로 그린다. 원형 아이콘은 자기 배경색이 있어 사진 위에서도
  /// 버티지만, **라벨은 배경 없는 글자라 밝은 사진에서 그대로 사라진다**(실기기 확인
  /// 2026-08-18: 둘러보기 전체화면에서 "관광지·문화시설"이 건물 사진에 묻혔다).
  ///
  /// 기본값이 거짓인 이유는 이 바를 쓰는 네 화면 중 셋(좋아요·검색·지도)은 평범한
  /// 배경 위에 있어 테마 색이 맞기 때문이다 — 흰색으로 고정하면 그쪽이 사라진다.
  final bool onImage;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color background = selected
        ? theme.colorScheme.primaryContainer
        : theme.colorScheme.surfaceContainerHighest;
    final Color foreground = selected
        ? theme.colorScheme.onPrimaryContainer
        : theme.colorScheme.onSurfaceVariant;

    return Semantics(
      selected: selected,
      button: true,
      label: label,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
          child: SizedBox(
            // 라벨이 길어도 항목 폭이 흔들리지 않도록 상한만 둔다. 고정 폭이 아니라
            // 상한이라 짧은 언어에서는 좁게 붙는다.
            width: 64,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: background,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, size: 22, color: foreground),
                ),
                const SizedBox(height: 6),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: onImage
                        ? Colors.white
                        : (selected
                              ? theme.colorScheme.onSurface
                              : theme.colorScheme.onSurfaceVariant),
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
