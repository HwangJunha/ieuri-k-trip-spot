import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../common/navigation/spot_qa_routes.dart';
import '../../../common/widget/skeleton_list.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../component/my_question_tile.dart';
import '../model/spot_qa_skeleton_samples.dart';
import '../model/spot_question.dart';
import '../provider/my_questions_providers.dart';

/// 「내 질문」 화면 — 내가 올린 질문과 거기 달린 답변을 보는 유일한 곳.
///
/// ```
/// AppBar  "내 질문"
/// 목록     MyQuestionTile × N (새 답변 배지)
/// ```
///
/// **목록은 서버가 준다**(`spotQuestions(mine: true)`) — 기기를 바꿔도 그대로 보인다.
///
/// **조회 실패를 빈 목록으로 접지 않는다.** 비로그인이면 바로 이 경로로 들어오는데,
/// "아직 올린 질문이 없습니다"로 그리면 정확히 반대로 알려주는 셈이다 — 실제로는
/// "로그인하면 보인다"이다. 그래서 오류와 빈 목록을 화면이 구분한다.
///
/// **페이지네이션이 없다.** 첫 20건만 보여준다 — 못 본 답변을 확인하러 오는 화면이라
/// 최신 것이 위에 있고, 그보다 옛 질문을 훑는 용도가 아니다. 더 필요해지면 공용
/// [PaginationListView]로 바꾼다.
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
          // **오류를 빈 목록으로 접지 않는다.** 비로그인이 이 경로로 들어오는데
          // "쓴 적 없음"으로 그리면 정반대를 알려주게 된다.
          AsyncError<List<MyQuestionItem>>() => _Failed(
            onRetry: () => ref.invalidate(myQuestionsControllerProvider),
          ),
          // 실제 타일에 더미를 넣어 그린 뒤 시머로 덮는다. 구분선도 실제 목록과
          // 같이 둬야 데이터가 도착할 때 줄 위치가 튀지 않는다.
          _ => SkeletonList(
            separator: const Divider(height: 1),
            itemBuilder: (_, int index) => MyQuestionTile(
              item: _skeletonItem(index),
              now: spotQaSkeletonNow,
              onTap: () {},
            ),
          ),
        },
      ),
    );
  }
}

/// 뼈대 한 줄이 쓸 더미 항목.
///
/// `MyQuestionItem`은 provider 층의 타입이라 모델의 샘플 파일이 만들 수 없다
/// (모델은 Riverpod에 의존하지 않는다 — CLAUDE.md §3). 그래서 질문만 모델에서
/// 가져와 여기서 「본 답변 수」와 묶는다.
///
/// 첫 줄만 `seenAnswerCount`를 답변 수보다 낮게 둔다 — 새 답변 배지가 있는 줄과
/// 없는 줄의 폭이 달라서, 둘이 섞여야 뼈대가 실제 목록과 같은 모양이 된다.
MyQuestionItem _skeletonItem(int index) {
  final SpotQuestion question =
      spotQuestionSkeletonSamples[index % spotQuestionSkeletonSamples.length];
  return MyQuestionItem(
    question: question,
    seenAnswerCount: index.isEven ? 0 : question.answerCount,
  );
}

class _List extends ConsumerWidget {
  const _List({required this.items});

  final List<MyQuestionItem> items;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 목록 전체가 같은 기준으로 상대시각을 계산하도록 빌드 1회당 한 번만 읽는다.
    final DateTime now = DateTime.now().toUtc();

    return RefreshIndicator(
      // **새 값을 await 해야 한다.** invalidate만 하고 끝나면 Future가 즉시
      // 완료돼 데이터가 도착하기 전에 스피너가 걷힌다 — 당겼는데 아무 일도
      // 없었던 것처럼 보인다.
      onRefresh: () async {
        ref.invalidate(myQuestionsControllerProvider);
        await ref
            .read(myQuestionsControllerProvider.future)
            .catchError((Object _) => items);
      },
      child: ListView.separated(
        // 항목이 적어도 당겨서 새로고침이 되도록 항상 스크롤을 허용한다.
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: items.length,
        separatorBuilder: (_, _) => const Divider(height: 1),
        itemBuilder: (BuildContext context, int index) {
          final MyQuestionItem item = items[index];
          return MyQuestionTile(
            item: item,
            now: now,
            onTap: () => context.pushNamed(
              spotQuestionDetailRouteName,
              pathParameters: <String, String>{
                'spotId': item.question.spot.id,
                'questionId': item.question.id,
              },
            ),
          );
        },
      ),
    );
  }
}

/// 조회 실패.
///
/// **비로그인이 이 경로로 온다.** `mine: true`는 인증을 요구하므로 로그인하지 않은
/// 사용자에게는 목록이 아니라 실패가 돌아온다. 그래서 안내 문구가 "불러오지 못했다"와
/// "로그인하면 보인다" 두 줄이다 — 전자만 쓰면 왜 안 보이는지 알 수 없고, 빈 목록으로
/// 접으면 "쓴 적 없음"이라는 정반대 사실을 알려주게 된다.
///
/// 두 경우를 코드로 가르지 않는 이유는 클라이언트가 그 구분을 확실히 할 수 없어서다 —
/// 인증 실패든 네트워크 실패든 사용자가 할 일(로그인 확인, 재시도)은 같다.
class _Failed extends StatelessWidget {
  const _Failed({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              l10n.spotQaMyQuestionsFailed,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.spotQaMyQuestionsSignInBody,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            TextButton(onPressed: onRetry, child: Text(l10n.communityRetry)),
          ],
        ),
      ),
    );
  }
}

/// 정말 질문이 하나도 없을 때. **조회 실패는 여기로 오지 않는다** — 그건 [_Failed]다.
class _Empty extends StatelessWidget {
  const _Empty();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);

    return Column(
      children: <Widget>[
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
