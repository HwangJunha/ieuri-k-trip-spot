import 'package:flutter/material.dart';

import '../../../common/network/media_cdn.dart';
import '../../../common/widget/image_placeholder.dart';
import '../../../common/widget/network_photo.dart';
import '../../../l10n/gen/app_localizations.dart';

/// 사진 키 하나를 그린다.
///
/// **키는 URL이 아니다** — CDN 베이스와 조합하는 것이 표시 계층의 몫이고, 그 조합은
/// `common/network`의 [MediaCdn]이 한 곳에서 한다(가이드 §4). 위젯에 문자열을
/// 박으면 CDN이 바뀔 때 찾아다녀야 한다.
///
/// **개발 환경 시드의 키는 실제 오브젝트가 없어 404가 정상이다.** 그래서 항상
/// 플레이스홀더를 깔고 그 위에 이미지를 그린다 — 실패해도 레이아웃이 무너지지 않고
/// 빈 검은 칸이 남지도 않는다.
class PostPhoto extends StatelessWidget {
  const PostPhoto({super.key, required this.photoKey, this.onTap});

  final String photoKey;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final Widget image = Stack(
      fit: StackFit.expand,
      children: <Widget>[
        ImagePlaceholder(imageRef: photoKey),
        NetworkPhoto(
          url: MediaCdn.urlFor(photoKey),
          fit: BoxFit.cover,
          // 목록 안 작은 사진이라 원본 해상도로 디코딩할 이유가 없다. 글 하나에
          // 사진이 다섯 장까지 붙으므로 피드를 훑을 때 그대로 쌓인다.
          decodeWidth: 400,
          // 404여도 아래 플레이스홀더가 그대로 남는다.
          errorBuilder: (_, _, _) => const SizedBox.shrink(),
        ),
      ],
    );
    return onTap == null ? image : GestureDetector(onTap: onTap, child: image);
  }
}

/// 사진 전체 화면 뷰어. 여러 장이면 좌우로 넘긴다.
///
/// 확대·축소는 [InteractiveViewer]가 맡는다 — 별도 패키지를 들이지 않는다.
class PostPhotoViewer extends StatefulWidget {
  const PostPhotoViewer({
    super.key,
    required this.photoKeys,
    this.initialIndex = 0,
  });

  final List<String> photoKeys;
  final int initialIndex;

  @override
  State<PostPhotoViewer> createState() => _PostPhotoViewerState();
}

class _PostPhotoViewerState extends State<PostPhotoViewer> {
  late final PageController _controller = PageController(
    initialPage: widget.initialIndex,
  );
  late int _index = widget.initialIndex;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.scrim,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: theme.colorScheme.onPrimary,
        title: widget.photoKeys.length > 1
            ? Text(
                l10n.communityPhotoViewerTitle(
                  _index + 1,
                  widget.photoKeys.length,
                ),
              )
            : null,
      ),
      extendBodyBehindAppBar: true,
      body: PageView.builder(
        controller: _controller,
        itemCount: widget.photoKeys.length,
        onPageChanged: (int next) => setState(() => _index = next),
        itemBuilder: (BuildContext context, int index) => InteractiveViewer(
          child: Center(
            // **여기는 `NetworkPhoto`를 쓰지 않는다.** [InteractiveViewer]가 확대를
            // 허용하므로 디코딩을 줄이면 확대했을 때 뭉개진다 — 목록 썸네일과 달리
            // 이 화면은 원본 화질이 목적이다.
            child: Image.network(
              MediaCdn.urlFor(widget.photoKeys[index]),
              fit: BoxFit.contain,
              // 시드 키는 404가 정상이다 — 검은 화면 대신 사유를 알 수 있는
              // 아이콘을 둔다.
              errorBuilder: (_, _, _) => Icon(
                Icons.broken_image_outlined,
                size: 48,
                color: theme.colorScheme.onPrimary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// 사진 뷰어를 연다. 목록 카드와 상세가 같은 진입을 쓴다.
void showPostPhotoViewer(
  BuildContext context, {
  required List<String> photoKeys,
  int initialIndex = 0,
}) {
  if (photoKeys.isEmpty) return;
  Navigator.of(context).push(
    MaterialPageRoute<void>(
      fullscreenDialog: true,
      builder: (_) =>
          PostPhotoViewer(photoKeys: photoKeys, initialIndex: initialIndex),
    ),
  );
}
