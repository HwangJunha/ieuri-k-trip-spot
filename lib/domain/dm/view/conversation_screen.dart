import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/model/post_author.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../../community/component/post_moderation_sheet.dart';
import '../component/conversation_selection_app_bar.dart';
import '../component/report_reason_code.dart';
import '../component/message_bubble.dart';
import '../component/message_input_bar.dart';
import '../component/typing_indicator_bar.dart';
import '../model/message.dart';
import '../model/message_report_selection.dart';
import '../model/typing_indicator.dart';
import '../provider/conversation_providers.dart';
import '../provider/message_report_providers.dart';
import '../provider/typing_providers.dart';
import '../provider/viewer_providers.dart';

/// 대화 한 방(R8·R9·R10·R15·R18).
///
/// 화면이 열릴 때 셋을 부른다:
/// - [ConversationController.sync] — 캐시 위에 서버 조회를 얹는다. build 안에서
///   스스로 하지 않는 이유는 Riverpod이 build 도중의 상태 변경을 금지해서다
/// - [ConversationController.listenForNewMessages] — 새 메시지 구독을 연다
/// - [ConversationController.markRead] — **조회만으로는 읽음이 되지 않는다.**
///   화면에 들어온 이 시점이 읽음의 기준이다(계약 확정 §4)
///
/// **캐시가 있으면 로딩이 거의 보이지 않는다**(AC18-1) — 컨트롤러의 build가 동기라
/// 첫 프레임부터 캐시된 대화가 그려진다. 화면은 캐시 유무에 따라 다른 스켈레톤을
/// 그리지 않는다.
class ConversationScreen extends ConsumerStatefulWidget {
  const ConversationScreen({super.key, required this.conversationId});

  final String conversationId;

  static String get routeName => 'conversation';

  @override
  ConsumerState<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends ConsumerState<ConversationScreen> {
  final ScrollController _scroll = ScrollController();

  @override
  void initState() {
    super.initState();
    // 첫 프레임 뒤에 부른다 — build 도중 provider 상태를 바꾸면 Riverpod이 막는다.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final ConversationController controller = ref.read(
        conversationControllerProvider(widget.conversationId).notifier,
      );
      controller.listenForNewMessages();
      controller.sync();
      controller.markRead();
    });
    _scroll.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scroll.removeListener(_onScroll);
    _scroll.dispose();
    super.dispose();
  }

  /// **위로 스크롤할 때 과거를 이어받는다** — 리스트가 `reverse: true`라 위쪽이
  /// `maxScrollExtent` 방향이다. 공용 `PaginationListView`는 아래로 스크롤할 때
  /// 받으므로 방향이 반대라 그대로 쓸 수 없다(디자인 §5 갭).
  void _onScroll() {
    if (!_scroll.hasClients) return;
    final ScrollPosition p = _scroll.position;
    if (p.pixels >= p.maxScrollExtent - p.viewportDimension) {
      // 중복 호출은 컨트롤러가 막는다(이미 받는 중이거나 소진이면 무시).
      ref
          .read(conversationControllerProvider(widget.conversationId).notifier)
          .loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final ConversationState state = ref.watch(
      conversationControllerProvider(widget.conversationId),
    );
    final MessageReportSelection selection = ref.watch(
      messageReportSelectionControllerProvider(widget.conversationId),
    );
    final TypingIndicator? typing = ref.watch(
      typingIndicatorControllerProvider(widget.conversationId),
    );

    return Scaffold(
      appBar: selection.active
          ? ConversationSelectionAppBar(
              selectedCount: selection.selectedCount,
              onCancel: () => ref
                  .read(
                    messageReportSelectionControllerProvider(
                      widget.conversationId,
                    ).notifier,
                  )
                  .cancel(),
              onReport: _report,
            )
          : _ConversationAppBar(
              counterpart: _counterpartOf(state),
              onSelectMessages: () => ref
                  .read(
                    messageReportSelectionControllerProvider(
                      widget.conversationId,
                    ).notifier,
                  )
                  .start(),
            ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            // 서버 조회가 실패해도 **화면을 비우지 않는다**(AC18-4) — 캐시된 대화는
            // 그대로 두고 조용한 배너만 얹는다.
            if (state.syncFailed) _SyncFailedBanner(onRetry: _retrySync),
            Expanded(
              child: state.isEmpty
                  ? _EmptyOrLoading(isSyncing: state.isSyncing)
                  : _MessageList(
                      controller: _scroll,
                      state: state,
                      selection: selection,
                      conversationId: widget.conversationId,
                    ),
            ),
            TypingIndicatorBar(nickname: typing?.sender.nickname),
            // 선택 모드에서는 입력창을 감춘다 — 고르는 중에 메시지를 보내면
            // 방금 보낸 것이 목록에 끼어들어 선택이 어긋난다.
            if (!selection.active)
              MessageInputBar(
                onSend: _send,
                onChanged: () => ref
                    .read(typingSignalProvider(widget.conversationId).notifier)
                    .notify(),
              )
            else
              const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }

  /// 상대방을 메시지에서 되짚는다.
  ///
  /// **라우트가 conversationId만 넘기기 때문이다**(CLAUDE.md §6) — 모델 객체를
  /// 라우트로 넘기지 않는다. 내가 보내지 않은 메시지의 발신자가 곧 상대이며, 아직
  /// 아무 메시지도 없으면 null이라 제목이 비고 그것이 맞다(빈 대화다).
  PostAuthor? _counterpartOf(ConversationState state) {
    for (final Message message in state.messages) {
      if (!message.ownedByViewer) return message.sender;
    }
    return null;
  }

  Future<void> _retrySync() => ref
      .read(conversationControllerProvider(widget.conversationId).notifier)
      .sync();

  /// 메시지를 보낸다. **낙관적 말풍선을 그리려면 발신자 정보가 필요하다** — 서버
  /// 응답 전에 아바타·닉네임을 그려야 하기 때문이며, 그 값은 세션에서 온다.
  Future<void> _send(String body) async {
    final PostAuthor? me = ref.read(viewerAuthorProvider);
    if (me == null) return;
    await ref
        .read(conversationControllerProvider(widget.conversationId).notifier)
        .send(me: me, body: body);
  }

  /// 고른 메시지들을 한 신고로 접수한다(AC15-1).
  ///
  /// 사유 시트는 커뮤니티의 것을 **그대로 재사용한다**(설계 §8) — 새 신고 시트를
  /// 만들지 않고, 사유 라벨도 커뮤니티가 이미 쓰는 매핑을 쓴다.
  Future<void> _report() async {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final ReportSubmission? submission = await showReportSheet(context);
    if (submission == null || !mounted) return;

    // 결과 타입(`DmMutationResult`)은 repository 계층의 값이라 이름을 들이지
    // 않는다(CLAUDE.md §3) — 화면이 보는 것은 성공 여부뿐이다.
    final bool succeeded =
        (await ref
                .read(
                  messageReportSelectionControllerProvider(
                    widget.conversationId,
                  ).notifier,
                )
                .submit(
                  reason: reportReasonCode(submission.reason),
                  detail: submission.detail,
                ))
            .succeeded;
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          succeeded ? l10n.dmReportSubmitted : l10n.dmReportFailed,
        ),
      ),
    );
  }
}

/// 평소 앱바 — 상대 아바타 + 닉네임 + ⋮(선택 모드 진입).
class _ConversationAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const _ConversationAppBar({
    required this.counterpart,
    required this.onSelectMessages,
  });

  final PostAuthor? counterpart;
  final VoidCallback onSelectMessages;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    return AppBar(
      title: Text(counterpart?.nickname ?? l10n.dmConversationsTitle),
      actions: <Widget>[
        // **수정·삭제 메뉴는 없다**(설계 §5) — 이 메뉴가 여는 것은 선택 모드뿐이다.
        PopupMenuButton<void>(
          itemBuilder: (BuildContext context) => <PopupMenuEntry<void>>[
            PopupMenuItem<void>(
              onTap: onSelectMessages,
              child: Text(l10n.dmSelectMessagesAction),
            ),
          ],
        ),
      ],
    );
  }
}

/// 메시지 목록. **역방향이다** — 최신이 아래에 오고 위로 올릴수록 과거다.
class _MessageList extends ConsumerWidget {
  const _MessageList({
    required this.controller,
    required this.state,
    required this.selection,
    required this.conversationId,
  });

  final ScrollController controller;
  final ConversationState state;
  final MessageReportSelection selection;
  final String conversationId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<Message> messages = state.messages;
    return ListView.builder(
      controller: controller,
      // 최신순 목록을 그대로 역방향으로 그린다 — 뒤집어 담을 필요가 없다.
      reverse: true,
      padding: const EdgeInsets.symmetric(vertical: 8),
      // 마지막 한 칸은 과거 방향(위)의 로딩 인디케이터 자리다.
      itemCount: messages.length + (state.isLoadingMore ? 1 : 0),
      itemBuilder: (BuildContext context, int index) {
        if (index >= messages.length) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        final Message message = messages[index];
        return MessageBubble(
          message: message,
          selectionMode: selection.active,
          selected: selection.isSelected(message.id),
          retryExhausted: message.retryCount >= maxMessageRetries,
          onRetry: () => ref
              .read(conversationControllerProvider(conversationId).notifier)
              .retry(message.id),
          // 선택 모드에서는 탭이 선택 토글이다. **자기 메시지는 무시된다**
          // (AC15-5) — 판정은 모델([Message.reportable])이 한다.
          onTap: selection.active
              ? () => ref
                    .read(
                      messageReportSelectionControllerProvider(
                        conversationId,
                      ).notifier,
                    )
                    .toggle(message)
              : null,
          // 길게 눌러 선택 모드로 들어간다. 누른 메시지가 첫 선택이 되며, 자기
          // 메시지면 모드만 켜지고 선택은 되지 않는다.
          onLongPress: selection.active
              ? null
              : () => ref
                    .read(
                      messageReportSelectionControllerProvider(
                        conversationId,
                      ).notifier,
                    )
                    .start(message),
        );
      },
    );
  }
}

/// 메시지가 하나도 없을 때. 서버 조회 중이면 스피너, 아니면 빈 대화 안내다.
///
/// **캐시가 있으면 여기까지 오지 않는다** — 컨트롤러가 첫 프레임부터 캐시를
/// 그리기 때문이다(AC18-1).
class _EmptyOrLoading extends StatelessWidget {
  const _EmptyOrLoading({required this.isSyncing});

  final bool isSyncing;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);
    if (isSyncing) return const Center(child: CircularProgressIndicator());
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Text(
          l10n.dmConversationEmpty,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}

/// 서버 동기화 실패 배너. **조용하다** — 캐시된 대화를 계속 읽을 수 있으므로
/// 화면을 오류로 덮지 않는다(AC18-4).
class _SyncFailedBanner extends StatelessWidget {
  const _SyncFailedBanner({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);
    return Material(
      color: theme.colorScheme.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.only(left: 16),
        child: Row(
          children: <Widget>[
            Icon(
              Icons.cloud_off_outlined,
              size: 16,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                l10n.dmSyncFailedBanner,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            TextButton(onPressed: onRetry, child: Text(l10n.dmRetry)),
          ],
        ),
      ),
    );
  }
}
