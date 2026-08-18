import 'package:flutter/material.dart';

import '../../community/component/post_photo.dart';

/// 질문·답변·답글에 붙은 사진(R9).
///
/// **서버는 처음부터 `photoKeys`를 내려주고 있었는데 그리는 코드가 없었다** — 사진을
/// 올려 저장까지 되는데 화면에 안 보였다. 표시만 빠져 있던 것이다.
///
/// 한 장이면 가로로 크게, 여러 장이면 가로 스크롤 썸네일이다. 질문 본문 바로 아래에
/// 놓여 "이 질문에 딸린 사진"임이 위치로 읽히게 한다.
///
/// 누르면 커뮤니티와 같은 전체화면 뷰어가 열린다 — 사진을 크게 보는 경험이 앱 안에서
/// 한 가지여야 한다.
class SpotQaPhotos extends StatelessWidget {
  const SpotQaPhotos({super.key, required this.photoKeys, this.compact = false});

  final List<String> photoKeys;

  /// 답변·답글처럼 들여쓴 자리에 놓일 때. 높이를 낮춘다.
  final bool compact;

  @override
  Widget build(BuildContext context) {
    if (photoKeys.isEmpty) return const SizedBox.shrink();

    final double height = compact ? 96 : 168;

    // 한 장은 가로를 채운다 — 스트립으로 만들면 옆에 빈 자리가 남아 어색하다.
    if (photoKeys.length == 1) {
      return Padding(
        padding: const EdgeInsets.only(top: 8),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: SizedBox(
            height: height,
            width: double.infinity,
            child: PostPhoto(
              photoKey: photoKeys.first,
              onTap: () =>
                  showPostPhotoViewer(context, photoKeys: photoKeys),
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: SizedBox(
        height: height,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: photoKeys.length,
          separatorBuilder: (_, _) => const SizedBox(width: 6),
          itemBuilder: (BuildContext context, int index) => ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SizedBox(
              width: height,
              child: PostPhoto(
                photoKey: photoKeys[index],
                // 어느 장을 눌렀는지 그대로 열어 준다.
                onTap: () => showPostPhotoViewer(
                  context,
                  photoKeys: photoKeys,
                  initialIndex: index,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
