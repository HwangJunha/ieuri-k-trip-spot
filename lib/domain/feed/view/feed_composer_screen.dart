import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/media/photo_picker_providers.dart';
import '../../../common/model/composer_photo.dart';
import '../../../common/model/post_spot.dart';
import '../../../common/network/media_cdn.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../../community/component/spot_picker_sheet.dart';
import '../model/feed_draft.dart';
import '../provider/feed_composer_providers.dart';

/// 피드 작성 화면(R1·R2, 디자인 §3).
///
/// ```
/// AppBar   ✕ · "새 글" · [올리기](조건 미충족 시 비활성)
/// 본문
///   ├── 사진 스트립   가로 스크롤 썸네일, 1~5장
///   ├── 장소 줄       고른 장소 1곳 + 바꾸기/지우기
///   └── 본문 입력     테두리 없음, 남은 높이를 전부 채운다(1~500자)
/// ```
///
/// **커뮤니티 컴포저와 요구가 다르다.** 저쪽은 장소가 선택 항목이고 카테고리·제목이
/// 필수인데, 피드는 **장소 1곳과 사진 1장 이상이 필수**이고 제목이 없다(R1·R2).
/// 그래서 화면을 공유하지 않고 톤만 맞춘다 — 한 화면에 두 규칙을 넣으면 어느 쪽
/// 규칙인지가 조건문에 숨는다.
///
/// **판정은 [FeedDraft.canSubmit]이 한다.** 화면은 그 값으로 버튼을 켤 뿐이라
/// 규칙이 위젯에 흩어지지 않는다. 서버가 같은 규칙을 다시 판정하므로 이 판정은
/// 서버를 대신하는 것이 아니라 UX 미러링이다(설계 §4).
///
/// **사진은 고를 때가 아니라 올릴 때 업로드된다** — 글을 쓰지 않고 나간 사용자의
/// 사진이 스토리지에 고아로 남지 않게 한다(디자인 §3). 그 순서는 provider의
/// `submit()`이 쥔다.
class FeedComposerScreen extends ConsumerStatefulWidget {
  const FeedComposerScreen({super.key});

  static const String routeName = 'feed-composer';

  @override
  ConsumerState<FeedComposerScreen> createState() => _FeedComposerScreenState();
}

class _FeedComposerScreenState extends ConsumerState<FeedComposerScreen> {
  final TextEditingController _body = TextEditingController();

  @override
  void dispose() {
    _body.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final FeedDraft draft = ref.watch(feedComposerProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Text(l10n.feedComposeTitle),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 8),
            // 제출 중에는 버튼을 스피너로 바꿔 재탭을 막는다(디자인 §3.5).
            child: draft.submitting
                ? const Center(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                : TextButton(
                    // **장소·사진·본문이 갖춰지기 전엔 비활성이다**(R1·R2).
                    onPressed: draft.canSubmit ? _submit : null,
                    child: Text(l10n.feedComposeSubmit),
                  ),
          ),
        ],
      ),
      // 키보드가 올라와도 본문이 그만큼 줄어들 뿐 넘치지 않는다 — Scaffold가
      // viewInsets를 body 높이에서 빼 주고, 본문은 Expanded라 그 높이를 따라간다.
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _PhotoStrip(
              photos: draft.photos,
              onAdd: _addPhotos,
              onRemove: (String id) =>
                  ref.read(feedComposerProvider.notifier).removePhoto(id),
            ),
            const Divider(height: 1, thickness: 0.5),
            _SpotRow(
              spot: draft.spot,
              onPick: _pickSpot,
              onClear: () =>
                  ref.read(feedComposerProvider.notifier).clearSpot(),
            ),
            const Divider(height: 1, thickness: 0.5),
            // **본문이 남은 높이를 전부 차지한다** — 커뮤니티 컴포저와 같은 원칙이다.
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: TextField(
                  controller: _body,
                  maxLines: null,
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
                  keyboardType: TextInputType.multiline,
                  // **maxLength를 두지 않는다** — 두면 붙여넣은 초과분이 조용히
                  // 잘려 무엇이 사라졌는지 알 수 없다. 길이는 제출만 막는다.
                  decoration: InputDecoration(
                    hintText: l10n.feedComposeBodyHint,
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                  onChanged: (String value) =>
                      ref.read(feedComposerProvider.notifier).setBody(value),
                ),
              ),
            ),
            _BottomBar(draft: draft),
          ],
        ),
      ),
    );
  }

  /// 장소 선택 시트를 연다. **커뮤니티의 시트를 그대로 재사용한다**(설계 §4) —
  /// 새로 만들면 검색 동작이 두 벌이 된다.
  ///
  /// 시트는 `NearbySpot`을 주고 초안은 `PostSpot`을 쥔다. 둘은 값이 겹치지만 서로
  /// 다른 타입이라 여기서 옮겨 담는다 — 썸네일이 없으면 빈 문자열이고, 그때 화면은
  /// 자리채움 아이콘으로 떨어진다.
  Future<void> _pickSpot() async {
    final SpotPickerResult? result = await showSpotPickerSheet(context);
    if (!mounted || result == null) return;
    switch (result) {
      case SpotPickerChosen(:final spot):
        ref
            .read(feedComposerProvider.notifier)
            .setSpot(
              PostSpot(
                id: spot.id,
                title: spot.title,
                thumbnailImageUrl: spot.thumbnailImageUrl ?? '',
              ),
            );
    }
  }

  /// 사진을 고른다. **네트워크를 타지 않는다** — 고른 바이트를 초안에 들고 있다가
  /// 올리기를 누를 때 업로드한다(디자인 §3).
  ///
  /// 고르는 수단은 주입된다([photoPickerProvider]) — 위젯 테스트가 갤러리를 열지
  /// 않도록 override할 수 있어야 하기 때문이다. null은 사용자가 취소한 것이라
  /// 아무 안내도 하지 않는다.
  ///
  /// **크기 상한은 고르는 자리에서 거른다.** 업로드를 미뤄도 이 검사는 여기 남는다 —
  /// 사용자는 사진이 너무 크다는 것을 글을 다 쓴 뒤가 아니라 그 자리에서 알아야
  /// 하고, 큰 장을 그대로 넘기면 발급이 **전부** 거절돼 멀쩡한 장까지 같이 죽는다.
  Future<void> _addPhotos() async {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final int remaining = ref.read(feedComposerProvider).remainingPhotoSlots;
    if (remaining <= 0) {
      _toast(l10n.feedComposeTooManyPhotos);
      return;
    }

    final List<LocalPhoto>? picked = await ref.read(photoPickerProvider)(
      limit: remaining,
    );
    if (!mounted || picked == null || picked.isEmpty) return;

    final List<LocalPhoto> withinLimit = picked
        .where((LocalPhoto p) => p.contentLength <= maxComposerPhotoBytes)
        .toList();
    if (withinLimit.length != picked.length) {
      _toast(l10n.feedComposePhotoTooLarge(picked.length - withinLimit.length));
    }
    if (withinLimit.isEmpty) return;

    ref.read(feedComposerProvider.notifier).addPhotos(withinLimit);
  }

  /// 올린다. 사진 업로드도 이 안에서 일어난다.
  ///
  /// **실패한 사진은 어느 장인지 이름으로 알린다**(설계 §4) — "업로드 실패"로
  /// 뭉뚱그리면 5장 중 어느 장을 다시 골라야 하는지 알 수 없다.
  Future<void> _submit() async {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final NavigatorState navigator = Navigator.of(context);
    final FeedComposerResult result = await ref
        .read(feedComposerProvider.notifier)
        .submit();
    if (!mounted) return;

    switch (result) {
      case FeedComposerSucceeded(:final List<String> failedPhotoNames):
        // 성공했으면 화면을 닫고 피드로 돌아간다. true를 돌려줘 부른 쪽이 목록을
        // 새로 고칠지 정한다.
        navigator.pop(true);
        _toast(
          failedPhotoNames.isEmpty
              ? l10n.feedComposeDone
              : l10n.feedComposeDonePhotosFailed(failedPhotoNames.join(', ')),
        );
      // 사진이 한 장도 올라가지 않아 제출 자체를 못 했다. **화면을 닫지 않는다** —
      // 입력을 보존해야 사용자가 다시 쓰지 않는다(디자인 §3.5).
      case FeedComposerPhotosFailed(:final List<String> failedPhotoNames):
        _toast(l10n.feedComposePhotosFailed(failedPhotoNames.join(', ')));
      case FeedComposerRejected(:final String? code):
        _toast(_messageFor(l10n, code));
      case FeedComposerFailed():
        _toast(l10n.feedComposeFailed);
    }
  }

  /// 서버 오류 코드 → 화면 문구. 모르는 코드는 일반 실패로 떨어뜨린다 — 서버
  /// message를 그대로 띄우지 않는다(PII가 실릴 수 있다, POL-013).
  String _messageFor(AppLocalizations l10n, String? code) => switch (code) {
    'SPOT_REQUIRED' || 'SPOT_NOT_FOUND' => l10n.feedComposeSpotRequired,
    'PHOTO_REQUIRED' => l10n.feedComposePhotosRequired,
    'TOO_MANY_PHOTOS' => l10n.feedComposeTooManyPhotos,
    'UNAUTHENTICATED' => l10n.feedComposeSignInRequired,
    _ => l10n.feedComposeFailed,
  };

  void _toast(String message) => ScaffoldMessenger.of(
    context,
  ).showSnackBar(SnackBar(content: Text(message)));
}

/// 고른 사진 줄 — 가로 스크롤 썸네일 + 추가 타일.
///
/// **사진이 필수라 빈 상태에서도 자리를 지킨다**(R2). 커뮤니티처럼 "붙인 것이 있을
/// 때만" 그리면, 사진 없이는 올릴 수 없는 화면에서 사진을 넣는 수단이 하단 바에만
/// 숨는다 — 필수 항목은 첫 화면에 보여야 한다.
class _PhotoStrip extends StatelessWidget {
  const _PhotoStrip({
    required this.photos,
    required this.onAdd,
    required this.onRemove,
  });

  final List<ComposerPhoto> photos;
  final VoidCallback onAdd;
  final ValueChanged<String> onRemove;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final ThemeData theme = Theme.of(context);
    final bool canAdd = photos.length < FeedDraft.maxPhotos;

    return SizedBox(
      height: 100,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: <Widget>[
          if (canAdd)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: InkWell(
                onTap: onAdd,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  width: 84,
                  height: 84,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: theme.dividerColor),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.add_a_photo_outlined,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${photos.length}/${FeedDraft.maxPhotos}',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          for (final ComposerPhoto photo in photos)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Stack(
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: SizedBox(
                      width: 84,
                      height: 84,
                      // 아직 올리지 않은 장은 손에 든 바이트로 바로 그린다 —
                      // 업로드 전이라고 빈 칸을 두면 무엇을 골랐는지 알 수 없다.
                      child: switch (photo) {
                        LocalPhoto(:final Uint8List bytes) => Image.memory(
                          bytes,
                          fit: BoxFit.cover,
                        ),
                        RemotePhoto(:final String objectKey) => Image.network(
                          MediaCdn.urlFor(objectKey),
                          fit: BoxFit.cover,
                        ),
                      },
                    ),
                  ),
                  Positioned(
                    top: -6,
                    right: -6,
                    child: IconButton(
                      tooltip: l10n.feedComposePhotoRemove,
                      onPressed: () => onRemove(photo.id),
                      iconSize: 18,
                      icon: const Icon(Icons.cancel),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

/// 고른 장소 한 줄. **피드는 장소가 필수 1곳이라**(R1) 커뮤니티처럼 하단 바 버튼으로
/// 접지 않고 상시 보이는 줄로 둔다 — 비어 있다는 사실 자체가 제출을 막는 이유이므로
/// 눈에 띄어야 한다.
class _SpotRow extends StatelessWidget {
  const _SpotRow({
    required this.spot,
    required this.onPick,
    required this.onClear,
  });

  final PostSpot? spot;
  final VoidCallback onPick;

  /// 고른 장소를 뗀다. **시트에는 해제 항목을 두지 않는다**(기존 규칙) — 고르는
  /// 목록에 "장소 없음"을 섞으면 그것이 장소인 것처럼 읽힌다.
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final ThemeData theme = Theme.of(context);
    final PostSpot? chosen = spot;

    return ListTile(
      onTap: onPick,
      leading: Icon(
        Icons.place_outlined,
        color: chosen == null
            ? theme.colorScheme.onSurfaceVariant
            : theme.colorScheme.primary,
      ),
      title: Text(
        chosen?.title ?? l10n.feedComposeSpotAction,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: chosen == null
              ? theme.colorScheme.onSurfaceVariant
              : theme.colorScheme.onSurface,
        ),
      ),
      trailing: chosen == null
          ? null
          : IconButton(
              tooltip: l10n.feedComposeSpotClear,
              onPressed: onClear,
              icon: const Icon(Icons.close),
            ),
    );
  }
}

/// 하단 바 — 무엇이 모자라서 제출이 막혔는지와 글자 수.
///
/// **비활성 버튼만 두면 왜 못 누르는지 알 수 없다.** 장소·사진이 필수인 화면이라
/// 모자란 항목을 문장으로 짚어 준다. 다 갖춰지면 조용해지고 글자 수만 남는다.
class _BottomBar extends StatelessWidget {
  const _BottomBar({required this.draft});

  final FeedDraft draft;

  /// 카운터를 드러내는 문턱 — 한계의 90%. 늘 띄워 두면 500자 중 12자를 쓴 사람에게도
  /// 남은 분량을 재촉하는 것처럼 보인다(커뮤니티 컴포저와 같은 관례).
  static const double _showFrom = 0.9;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final ThemeData theme = Theme.of(context);

    final int length = draft.trimmedBody.length;
    final bool tooLong = length > FeedDraft.maxBodyLength;
    final String? counter = tooLong
        ? l10n.feedComposeTooLong(length - FeedDraft.maxBodyLength)
        : length >= FeedDraft.maxBodyLength * _showFrom
        ? l10n.feedComposeCounter(length)
        : null;

    // 모자란 것 하나만 짚는다 — 셋을 한꺼번에 늘어놓으면 무엇부터 할지 흐려진다.
    final String? missing = draft.photos.isEmpty
        ? l10n.feedComposePhotosRequired
        : draft.spot == null
        ? l10n.feedComposeSpotRequired
        : null;

    return Container(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: theme.dividerColor, width: 0.5)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: <Widget>[
          Expanded(
            child: missing == null
                ? const SizedBox.shrink()
                : Text(
                    missing,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
          ),
          if (counter != null)
            Text(
              counter,
              style: theme.textTheme.labelMedium?.copyWith(
                color: tooLong
                    ? theme.colorScheme.error
                    : theme.colorScheme.onSurfaceVariant,
              ),
            ),
        ],
      ),
    );
  }
}
