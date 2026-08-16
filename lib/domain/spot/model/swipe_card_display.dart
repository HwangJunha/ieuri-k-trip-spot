import 'copyright_type.dart';
import 'tourist_spot.dart';

/// 카드 이미지를 어떻게 맞출 것인가(SPEC-0025 R13, SPEC-0002 §4.7).
///
/// `BoxFit`을 그대로 쓰지 않는 이유는 이 판단이 **모델의 몫**이기 때문이다 —
/// `model/**`은 순수해야 하므로 flutter 타입을 들일 수 없다(CLAUDE.md §3). 위젯이
/// 이 값을 `BoxFit`으로 번역한다.
enum SwipeCardFit {
  /// 영역을 채운다(크롭 허용). TYPE1 전용.
  cover,

  /// 크롭을 피한다(원본 유지). 남는 여백은 블러 배경으로 메운다.
  contain;

  /// 여백을 블러 배경으로 메워야 하는가. `contain`일 때만 여백이 생긴다.
  bool get needsBlurBackdrop => this == SwipeCardFit.contain;
}

/// 스와이프 카드 한 장의 **표시 명세**.
///
/// ## 왜 위젯 밖에 있는가
///
/// AC R1·R2·R13은 "무엇이 어떻게 보이는가"를 판정하는데, 이 계산이 `build` 안에
/// 인라인돼 있으면 위젯 트리를 세워야만 확인할 수 있다(설계 §2.4). 순수 값으로 뽑아
/// 두면 같은 판정을 위젯 없이 그대로 쓴다.
///
/// 계산이랄 것이 없어 보여도 자리를 옮기는 값이 아니다 — 저작권 분기(R13)가 여기
/// 들어 있고, 그 분기는 구현 편의로 두 번 지워진 적이 있다.
class SwipeCardDisplay {
  const SwipeCardDisplay({
    required this.name,
    required this.imageRef,
    required this.fit,
    this.address,
    this.distanceMeters,
    this.attributionText,
  });

  /// [spot]이 카드에서 어떻게 보여야 하는지 정한다.
  factory SwipeCardDisplay.of(TouristSpot spot) => SwipeCardDisplay(
    name: spot.name,
    // 썸네일이 있으면 그것을, 없으면 목 참조를 쓴다(플레이스홀더로 떨어진다).
    imageRef: spot.thumbnailImageUrl ?? spot.imageRef,
    fit: fitFor(spot.copyright),
    address: spot.address,
    distanceMeters: spot.distanceMeters,
    attributionText: spot.attributionText,
  );

  /// 저작권 유형 → 맞춤 방식(R13).
  ///
  /// **미지정은 TYPE3과 같이 다룬다** — 변형해도 되는지 모르는 이미지를 크롭하는
  /// 것보다 여백을 남기는 편이 안전하다. 이 판단은 SPEC-0002 §4.7이 정했고
  /// SPEC-0025 R13이 되살린 것이다.
  ///
  /// 저작권 정보 자체가 없어도(null) 같은 이유로 크롭하지 않는다.
  static SwipeCardFit fitFor(CopyrightType? copyright) =>
      (copyright?.cropAllowed ?? false)
      ? SwipeCardFit.cover
      : SwipeCardFit.contain;

  final String name;
  final String imageRef;
  final SwipeCardFit fit;
  final String? address;
  final int? distanceMeters;

  /// 출처 표기. 있으면 제목 위에 배지로 그린다.
  final String? attributionText;

  /// 주소 줄을 그리는가. 값이 없으면 자리를 비우지 않는다(빈 줄이 남으면 제목이
  /// 떠 보인다).
  bool get showsAddress => address != null;

  /// 거리 줄을 그리는가.
  bool get showsDistance => distanceMeters != null;

  /// 출처 배지를 그리는가.
  bool get showsAttribution => attributionText != null;
}
