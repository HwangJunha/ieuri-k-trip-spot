import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../common/navigation/spot_qa_routes.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../component/my_question_tile.dart';
import '../provider/my_questions_providers.dart';

/// 「내 질문」 화면 — 내가 올린 질문과 거기 달린 답변을 보는 유일한 곳.
///
/// ```
/// AppBar  "내 질문"
/// 안내     이 목록은 이 기기에만 저장됩니다
/// 목록     MyQuestionTile × N (새 답변 배지)
/// ```
///
/// **서버에 `myQuestions`도 알림도 없어서 존재한다.** 로컬 기록으로 되짚는 임시
/// 방편이며(`MyQuestionRef` 주석), 그래서 화면에 "이 기기에만 저장된다"는 안내를
/// 한 번 띄운다 — 기기를 바꾸면 사라지는 목록임을 숨기지 않는다.
///
/// **페이지네이션이 없다.** 로컬 기록은 상한(`myQuestionsLimit`)이 걸린 짧은 목록이라
/// 한 번에 다 그린다 — 공용 [PaginationListView]는 커서를 가진 서버 목록의 도구다.
///
/// 서버에서 못 찾은 항목도 **지우지 않고** 안내와 함께 남긴다: 조회 실패를 삭제로
/// 해석하면 일시적인 네트워크 오류에 내 기록이 사라진다.
class MyQuestionsScreen extends ConsumerWidget {
  const MyQuestionsScreen({super.key});

  static String get routeName => myQuestionsRouteName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final AsyncValue<List<MyQuestionItem>> state = ref.watch(
      myQuestionsControllerProvider,
    );

    return Scaffold(
      appBar: AppBar(title: Text(l10n.spotQaMyQuestionsTitle)),
      body: SafeArea(
        child: switch (state) {
          // 값이 있으면 재조회 중에도 그것을 그린다 — 배지를 끄고 돌아왔을 때
          // 목록이 스피너로 덮이면 읽던 자리를 잃는다.
          AsyncValue<List<MyQuestionItem>>(:final List<MyQuestionItem> value?)
              when value.isNotEmpty =>
            _List(items: value),
          AsyncValue<List<MyQuestionItem>>(hasValue: true) => const _Empty(),
          AsyncError<List<MyQuestionItem>>() => const _Empty(),
          _ => const Center(child: CircularProgressIndicator()),
        },
      ),
    );
  }
}

class _List extends ConsumerWidget {
  const _List({required this.items});

  final List<MyQuestionItem> items;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 목록 전체가 같은 기준으로 상대시각을 계산하도록 빌드 1회당 한 번만 읽는다.
    final DateTime now = DateTime.now().toUtc();

    return RefreshIndicator(
      onRefresh: () async => ref.invalidate(myQuestionsControllerProvider),
      child: ListView.separated(
        // 항목이 적어도 당겨서 새로고침이 되도록 항상 스크롤을 허용한다.
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: items.length + 1,
        separatorBuilder: (_, _) => const Divider(height: 1),
        itemBuilder: (BuildContext context, int index) {
          // 0번은 "이 기기에만 저장됩니다" 안내 — 목록 맨 위에 한 번만 나온다.
          if (index == 0) return const _LocalOnlyNotice();
          final MyQuestionItem item = items[index - 1];
          return MyQuestionTile(
            item: item,
            now: now,
            onTap: () => context.pushNamed(
              spotQuestionDetailRouteName,
              pathParameters: <String, String>{
                'spotId': item.ref.catalogId,
                'questionId': item.ref.questionId,
              },
            ),
          );
        },
      ),
    );
  }
}

/// 로컬 저장 안내. 목록이 비었을 때도 같은 문구를 쓴다.
class _LocalOnlyNotice extends StatelessWidget {
  const _LocalOnlyNotice();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      width: double.infinity,
      color: theme.colorScheme.surfaceContainerHighest,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: <Widget>[
          Icon(
            Icons.phone_iphone,
            size: 16,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              AppLocalizations.of(context).spotQaLocalOnlyNotice,
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 빈 목록. **조회 실패도 여기로 온다** — 로컬 기록이 비면 서버 조회 자체가 없고,
/// 기록이 있는데 조회가 실패하면 컨트롤러가 그 장소만 접고 나머지를 돌려주므로
/// 사용자에게는 "아직 없다"와 구분되지 않는다.
class _Empty extends StatelessWidget {
  const _Empty();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);

    return Column(
      children: <Widget>[
        const _LocalOnlyNotice(),
        Expanded(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    l10n.spotQaMyQuestionsEmptyTitle,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.spotQaMyQuestionsEmptyBody,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
