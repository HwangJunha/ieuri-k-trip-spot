import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../common/navigation/spot_qa_routes.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../provider/my_questions_providers.dart';

/// 홈 상단의 「내 질문」 진입점.
///
/// **서버에 알림이 없어 이 배지가 "답이 달렸다"를 알리는 유일한 채널이다.** 그래서
/// 앱을 열면 무조건 보이는 자리에 있어야 한다 — 설정 2뎁스 안의 배지는 이미 찾아온
/// 사람에게만 보이므로 알림 역할을 못 한다.
///
/// **메시지(DM) 버튼 옆이 자리다.** 둘 다 "내가 보낸 것에 대한 응답을 기다리는
/// 인박스"라 성격이 같고, 사용자는 이미 "응답은 상단 우측"이라는 모델을 DM으로
/// 학습했다. 네이버 지식iN이 `내소식`을, 구글 지도가 `Contribute`를 전역 자리에 둔
/// 것과 같은 이유다 — **장소를 가로지르는 목록의 집은 장소에 묶이지 않은 화면이다.**
///
/// 배지는 **숫자**다. 못 본 답변이 몇 개인지가 들어갈지 말지를 가르는 정보라
/// 점보다 숫자가 맞다(DM은 "왔다/안 왔다"만 필요해 점이다).
///
/// **비로그인이면 0이라 배지가 안 뜬다.** 버튼은 남아 있어 눌러서 로그인 흐름으로
/// 갈 수 있다.
class MyQuestionsButton extends ConsumerWidget {
  const MyQuestionsButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);
    final int unseen = ref.watch(myQuestionsUnseenCountProvider);

    return IconButton(
      tooltip: l10n.spotQaMyQuestionsEntry,
      onPressed: () => context.pushNamed(myQuestionsRouteName),
      icon: Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          const Icon(Icons.forum_outlined),
          if (unseen > 0)
            PositionedDirectional(
              top: -4,
              end: -6,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                constraints: const BoxConstraints(minWidth: 15),
                decoration: BoxDecoration(
                  color: theme.colorScheme.error,
                  borderRadius: BorderRadius.circular(999),
                  // 아이콘 선과 배지가 붙어 보이지 않게 배경색으로 테를 두른다.
                  border: Border.all(color: theme.colorScheme.surface),
                ),
                child: Text(
                  // 두 자리를 넘으면 아이콘을 밀어낸다 — 그 이상은 "많다"로 충분하다.
                  unseen > 9 ? '9+' : '$unseen',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onError,
                    fontSize: 10,
                    height: 1.3,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
