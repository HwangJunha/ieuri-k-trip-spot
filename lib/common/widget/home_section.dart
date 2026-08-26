import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/gen/app_localizations.dart';
import '../location/location_service.dart';
import 'app_skeleton.dart';

/// 홈 섹션 하나의 상태 경계(R19). 로딩·결과·빈 상태·실패를 **섹션 안에서** 그린다.
///
/// **왜 `common/`에 있는가.** 홈의 세 섹션 중 둘은 `domain/spot`이 소유하지만
/// "Happening Now"는 `domain/event`가 소유한다 — 두 기능이 함께 쓰므로 어느 한쪽
/// 안에 두면 기능 간 import가 생긴다(CLAUDE.md §3·§4).
///
/// 섹션마다 이 위젯을 쓰기 때문에 한 섹션의 실패가 다른 섹션이나 화면 전체로
/// 번지지 않는다(AC-19.1·AC-19.2). 실패했을 때 [onRetry]가 그 섹션의 provider
/// 하나만 무효화하므로 재시도도 섹션 단위다(AC-20.1·AC-20.2).
///
/// **빈 상태는 실패가 아니다.** 반경 안에 진행 중인 축제가 없는 것은 흔한 정상
/// 상태라(설계 §2) 오류 문구나 재시도 버튼 대신 이유를 알려주는 [emptyMessage]를
/// 띄운다. 빈 공간을 그대로 두면 사용자는 로딩이 멈춘 것으로 읽는다.
class HomeSection<T> extends ConsumerWidget {
  const HomeSection({
    super.key,
    required this.title,
    required this.value,
    required this.emptyMessage,
    required this.onRetry,
    required this.builder,
    this.skeletonItems = const <Never>[],
  });

  final String title;
  final AsyncValue<List<T>> value;

  /// 결과가 0건일 때 보여줄 이유 문구. 실패 문구와 구분된다.
  final String emptyMessage;

  /// 이 섹션의 provider만 무효화한다. 다른 섹션은 건드리지 않는다(AC-20.2).
  final VoidCallback onRetry;

  final Widget Function(List<T> items) builder;

  /// 로딩 중 뼈대로 그릴 더미 항목들. **[builder]에 그대로 넘겨 진짜 카드를 그린 뒤**
  /// 시머로 덮으므로, 섹션마다 다른 레이아웃(가로 스크롤 / 세로 카드)이 저절로 맞는다.
  ///
  /// 비워 두면 예전처럼 스피너를 그린다 — 더미를 만들 수 없는 섹션이 남아도 이 위젯을
  /// 계속 쓸 수 있게 한다.
  final List<T> skeletonItems;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(title, style: theme.textTheme.titleLarge),
        ),
        const SizedBox(height: 8),
        value.when(
          data: (List<T> items) =>
              items.isEmpty ? _Message(text: emptyMessage) : builder(items),
          // 더미를 받았으면 **진짜 카드 레이아웃 그대로** 뼈대를 그린다. 스피너는
          // "무언가 돌고 있다"만 말하지만 뼈대는 무엇이 올지까지 말한다.
          loading: () => skeletonItems.isEmpty
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: CircularProgressIndicator(),
                  ),
                )
              : AppSkeleton(child: builder(skeletonItems)),
          // 실패는 빈 상태와 달리 재시도 수단을 함께 준다(AC-20.1).
          //
          // **위치 실패는 조회 실패와 다르게 그린다**(2026-08-26). 좌표를 못 얻은
          // 것은 서버가 준 결과가 아니라 기기 상태이고, 사용자가 할 일도 "다시
          // 시도"가 아니라 설정에서 위치를 켜는 것이다. 같은 문구로 뭉뚱그리면
          // 권한을 거부해 놓고 재시도만 반복하게 된다 — 실제로 홈·지도·전국지도가
          // 그랬고 「위치가 꺼져 있어요」는 발견 탭에서만 나왔다.
          //
          // 재시도 버튼을 빼는 이유: 이 상태는 눌러서 풀리지 않는다. 설정에서
          // 위치를 켜고 돌아오면 provider가 다시 조회한다.
          error: (Object error, _) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: error is LocationUnavailable
                ? Text(
                    l10n.permissionLocationBlockedMessage,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        l10n.homeSectionError,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton(
                          onPressed: onRetry,
                          child: Text(l10n.homeSectionRetry),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ],
    );
  }
}

/// 빈 상태 문구. 오류처럼 보이지 않도록 본문 색을 쓰고 버튼을 두지 않는다.
class _Message extends StatelessWidget {
  const _Message({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        text,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
