import 'package:flutter/material.dart';

import '../../../common/widget/network_photo.dart';

/// `contain`으로 그릴 때 남는 여백을 채우는 블러 배경(SPEC-0002 §4.7).
///
/// 원본을 확대·블러해 뒤에 깔고 그 위에 원본을 온전히 얹는다 — **원본은 변형되지
/// 않는다**(TYPE3 변경금지를 지키는 방식). 배경색으로 비우면 가로로 넓은 사진에서
/// 위아래가 통째로 빈 띠가 된다(사용자 지적 2026-08-18).
///
/// **스와이프 카드와 상세 갤러리가 같은 것을 쓴다.** 두 곳에 복제돼 있었는데, 한쪽만
/// 성능을 고치면 다른 쪽이 그대로 남는다 — 실제로 그럴 뻔했다.
///
/// ## 흐림은 필터가 아니라 확대로 만든다
///
/// 40px로 디코딩한 그림을 전체화면으로 늘리면 **그 자체가 이미 뭉개진 그림**이다.
/// 확대 보간이 블러 역할을 대신하므로 `ImageFilter.blur`가 필요 없다.
///
/// 예전에는 sigma를 줄여 `ImageFiltered`를 걸었는데 그것으로는 부족했다 —
/// **디코딩을 줄여도 필터는 출력 크기(전체화면)에서 돌기 때문에** 비용이 그대로다.
/// 이 위젯이 드래그하는 `Transform` 안에 있어 매 프레임 다시 합성됐고, 카드가 두 장
/// 겹치는 구간에서는 전체화면 필터가 동시에 둘이었다(실기기 영상 확인, 2026-08-25).
///
/// 이 경로를 타는 카드가 예외가 아니라 **대부분**이다 — 저작권 미지정과 TYPE3가
/// `contain`이고 실제 데이터는 거의 전부 "공공누리 제3유형"이다.
class BlurBackdrop extends StatelessWidget {
  const BlurBackdrop({super.key, required this.imageRef});

  final String imageRef;

  /// 배경을 디코딩할 논리 폭. 이 값이 곧 흐림의 정도다 — 작을수록 더 뭉개진다.
  static const double _decodeWidth = 40;

  @override
  Widget build(BuildContext context) {
    // **블러 필터를 쓰지 않는다.** 40px로 디코딩한 그림을 전체화면으로 늘리면 그
    // 자체가 이미 뭉개진 그림이다 — 확대 보간이 블러 역할을 대신한다.
    //
    // 처음에는 `ImageFiltered`에 sigma를 줄여 걸었는데, 그것으로는 부족했다.
    // **디코딩 크기를 줄여도 필터는 출력 크기(전체화면)에서 돈다** — 비용이 그대로다.
    // `RepaintBoundary`도 여기서는 약을 못 쓴다: 경계는 자식이 안 바뀔 때 래스터를
    // 재사용하지만, 부모 `Transform`이 움직이면 필터 레이어는 다시 합성된다.
    //
    // 카드 대부분이 이 경로를 탄다 — 저작권 미지정·TYPE3가 `contain`이고, 실제
    // 데이터에서 거의 모든 항목이 "공공누리 제3유형"이다(실기기 영상 확인,
    // 2026-08-25). 전체화면 블러 두 장(위 카드 + 다음 카드)이 매 프레임 돌고 있었다.
    // **어둡게 덮지 않는다**(사용자 지적 2026-08-25). 예전에는 `black26`을
    // `darken`으로 얹었는데, 강한 가우시안이 그 어두움까지 뭉개 놔서 티가 안 났다.
    // 필터를 걷어내자 **어두움만 선명하게 남아 화면 전체가 칙칙해졌다.**
    //
    // 배경과 원본을 가르는 일은 어둡게 누르는 것 말고도 된다 — 확대 보간으로 이미
    // 형체가 없어져 원본과 충분히 구별된다.
    return RepaintBoundary(
      child: NetworkPhoto(
        url: imageRef,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        decodeWidth: _decodeWidth,
        // 작은 그림을 크게 늘리므로 보간 품질이 곧 흐림의 결이 된다. `low`는
        // 바이리니어라 사실상 공짜이고, 이 용도에는 부드러운 편이 오히려 맞다.
        filterQuality: FilterQuality.low,
        // 배경이 실패해도 카드는 성립한다 — 빈 색으로 떨어뜨린다.
        errorBuilder:
            (BuildContext context, Object error, StackTrace? stack) =>
                ColoredBox(color: Theme.of(context).colorScheme.surface),
      ),
    );
  }
}
