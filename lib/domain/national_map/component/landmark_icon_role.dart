// 이 파일은 생성물이다. 손으로 고치지 말 것.
// 만드는 법: tmp/v4/genroles.py — out/*.svg 에 실제로 쓰인 색을 훑어 만든다.
//
// 미방문 칸은 **채도만 빼고 명도는 유지**한다. 그래야 형태가 남는다.
// 다만 명도를 밝은 쪽(128~236)으로 압축해 '밑그림'처럼 보이게 한다 —
// 원래 명도를 그대로 두면 161칸이 한 화면에서 시멘트 덩어리가 된다.

import 'dart:ui' show Color;

/// 한 색의 두 변형. `full` 은 방문, `grey` 는 미방문이다.
class LandmarkRoleVariants {
  const LandmarkRoleVariants({required this.full, required this.grey});

  /// 방문 칸에서 쓰는 색.
  final Color full;

  /// 미방문 칸에서 쓰는 무채색.
  final Color grey;
}

/// SVG 안의 색(ARGB) → 두 변형.
///
/// 여기 없는 색은 [UnvisitedLandmarkColorMapper] 가 **그대로 돌려준다** —
/// 알 수 없는 색을 임의로 바꾸면 그림이 조용히 망가지기 때문이다. 그래서
/// 새 그림을 넣을 때마다 이 표를 다시 만들어야 한다.
const Map<int, LandmarkRoleVariants> landmarkRoleVariants =
    <int, LandmarkRoleVariants>{
  0xFF3E8E7E: LandmarkRoleVariants(
    full: Color(0xFF3E8E7E),
    grey: Color(0xFFADABA8),
  ),
  0xFFFFFFFF: LandmarkRoleVariants(
    full: Color(0xFFFFFFFF),
    grey: Color(0xFFF4F1EE),
  ),
  0xFFC4403F: LandmarkRoleVariants(
    full: Color(0xFFC4403F),
    grey: Color(0xFF999895),
  ),
  0xFFD9C9B4: LandmarkRoleVariants(
    full: Color(0xFFD9C9B4),
    grey: Color(0xFFD9D7D3),
  ),
  0xFF8A4818: LandmarkRoleVariants(
    full: Color(0xFF8A4818),
    grey: Color(0xFF93928F),
  ),
  0xFF2E6B4F: LandmarkRoleVariants(
    full: Color(0xFF2E6B4F),
    grey: Color(0xFF999895),
  ),
  0xFF4E8F63: LandmarkRoleVariants(
    full: Color(0xFF4E8F63),
    grey: Color(0xFFAEACAA),
  ),
  0xFFE0A93B: LandmarkRoleVariants(
    full: Color(0xFFE0A93B),
    grey: Color(0xFFC9C7C4),
  ),
  0xFFEFE3D0: LandmarkRoleVariants(
    full: Color(0xFFEFE3D0),
    grey: Color(0xFFE7E4E0),
  ),
  0xFF1F4F3A: LandmarkRoleVariants(
    full: Color(0xFF1F4F3A),
    grey: Color(0xFF898885),
  ),
  0xFF8FBF6A: LandmarkRoleVariants(
    full: Color(0xFF8FBF6A),
    grey: Color(0xFFCAC8C5),
  ),
  0xFF6FA455: LandmarkRoleVariants(
    full: Color(0xFF6FA455),
    grey: Color(0xFFBAB8B5),
  ),
  0xFFF5F7F5: LandmarkRoleVariants(
    full: Color(0xFFF5F7F5),
    grey: Color(0xFFF0EDEA),
  ),
  0xFFC9752F: LandmarkRoleVariants(
    full: Color(0xFFC9752F),
    grey: Color(0xFFB0AEAC),
  ),
  0xFFFFEDD6: LandmarkRoleVariants(
    full: Color(0xFFFFEDD6),
    grey: Color(0xFFECEAE6),
  ),
  0xFF3E93A8: LandmarkRoleVariants(
    full: Color(0xFF3E93A8),
    grey: Color(0xFFB1AFAC),
  ),
  0xFF55626E: LandmarkRoleVariants(
    full: Color(0xFF55626E),
    grey: Color(0xFF9C9A98),
  ),
  0xFFA85C22: LandmarkRoleVariants(
    full: Color(0xFFA85C22),
    grey: Color(0xFFA19F9D),
  ),
  0xFF63B0C0: LandmarkRoleVariants(
    full: Color(0xFF63B0C0),
    grey: Color(0xFFC2C0BD),
  ),
  0xFF2E7A8C: LandmarkRoleVariants(
    full: Color(0xFF2E7A8C),
    grey: Color(0xFFA3A19E),
  ),
  0xFF2B2B45: LandmarkRoleVariants(
    full: Color(0xFF2B2B45),
    grey: Color(0xFF2B2B45),
  ),
  0xFF94714F: LandmarkRoleVariants(
    full: Color(0xFF94714F),
    grey: Color(0xFFA9A7A5),
  ),
  0xFFBFAC94: LandmarkRoleVariants(
    full: Color(0xFFBFAC94),
    grey: Color(0xFFCAC7C4),
  ),
  0xFFFFEEE9: LandmarkRoleVariants(
    full: Color(0xFFFFEEE9),
    grey: Color(0xFFEDEBE7),
  ),
  0xFFE9F8EE: LandmarkRoleVariants(
    full: Color(0xFFE9F8EE),
    grey: Color(0xFFEFECE8),
  ),
  0xFFB08968: LandmarkRoleVariants(
    full: Color(0xFFB08968),
    grey: Color(0xFFB8B6B3),
  ),
  0xFF8A97A3: LandmarkRoleVariants(
    full: Color(0xFF8A97A3),
    grey: Color(0xFFBCB9B7),
  ),
  0xFFE7F8F7: LandmarkRoleVariants(
    full: Color(0xFFE7F8F7),
    grey: Color(0xFFEFECE9),
  ),
  0xFFA8C86A: LandmarkRoleVariants(
    full: Color(0xFFA8C86A),
    grey: Color(0xFFD0CECB),
  ),
  0xFFFFD9A8: LandmarkRoleVariants(
    full: Color(0xFFFFD9A8),
    grey: Color(0xFFE3E0DD),
  ),
  0xFFF2ECFB: LandmarkRoleVariants(
    full: Color(0xFFF2ECFB),
    grey: Color(0xFFECE9E6),
  ),
  0xFF6E7C89: LandmarkRoleVariants(
    full: Color(0xFF6E7C89),
    grey: Color(0xFFACAAA7),
  ),
  0xFFE6F4FD: LandmarkRoleVariants(
    full: Color(0xFFE6F4FD),
    grey: Color(0xFFEEEBE7),
  ),
  0xFFBFB4A0: LandmarkRoleVariants(
    full: Color(0xFFBFB4A0),
    grey: Color(0xFFCDCBC8),
  ),
  0xFFFFEEF2: LandmarkRoleVariants(
    full: Color(0xFFFFEEF2),
    grey: Color(0xFFEEEBE7),
  ),
  0xFFB9B2A4: LandmarkRoleVariants(
    full: Color(0xFFB9B2A4),
    grey: Color(0xFFCCCAC7),
  ),
  0xFF5C4382: LandmarkRoleVariants(
    full: Color(0xFF5C4382),
    grey: Color(0xFF908E8C),
  ),
  0xFF2B3A38: LandmarkRoleVariants(
    full: Color(0xFF2B3A38),
    grey: Color(0xFF807F7D),
  ),
  0xFF3F2C5E: LandmarkRoleVariants(
    full: Color(0xFF3F2C5E),
    grey: Color(0xFF7E7D7B),
  ),
  0xFF7B5EA7: LandmarkRoleVariants(
    full: Color(0xFF7B5EA7),
    grey: Color(0xFFA2A09D),
  ),
  0xFF9E9382: LandmarkRoleVariants(
    full: Color(0xFF9E9382),
    grey: Color(0xFFBBB9B6),
  ),
  0xFFFFDCD2: LandmarkRoleVariants(
    full: Color(0xFFFFDCD2),
    grey: Color(0xFFE6E3E0),
  ),
  0xFFD3F0DC: LandmarkRoleVariants(
    full: Color(0xFFD3F0DC),
    grey: Color(0xFFE9E6E3),
  ),
  0xFFFFF8E2: LandmarkRoleVariants(
    full: Color(0xFFFFF8E2),
    grey: Color(0xFFF1EEEA),
  ),
  0xFF48545E: LandmarkRoleVariants(
    full: Color(0xFF48545E),
    grey: Color(0xFF93918F),
  ),
  0xFFD8D3C8: LandmarkRoleVariants(
    full: Color(0xFFD8D3C8),
    grey: Color(0xFFDEDBD8),
  ),
  0xFFDCD3C2: LandmarkRoleVariants(
    full: Color(0xFFDCD3C2),
    grey: Color(0xFFDEDBD8),
  ),
  0xFFCFF0EE: LandmarkRoleVariants(
    full: Color(0xFFCFF0EE),
    grey: Color(0xFFE9E6E3),
  ),
  0xFFCFE9FA: LandmarkRoleVariants(
    full: Color(0xFFCFE9FA),
    grey: Color(0xFFE7E4E1),
  ),
  0xFFF0CB6E: LandmarkRoleVariants(
    full: Color(0xFFF0CB6E),
    grey: Color(0xFFDAD7D4),
  ),
  0xFFE6DCF7: LandmarkRoleVariants(
    full: Color(0xFFE6DCF7),
    grey: Color(0xFFE4E2DE),
  ),
  0xFFFFDCE4: LandmarkRoleVariants(
    full: Color(0xFFFFDCE4),
    grey: Color(0xFFE7E4E0),
  ),
  0xFFF2EDE0: LandmarkRoleVariants(
    full: Color(0xFFF2EDE0),
    grey: Color(0xFFEBE8E5),
  ),
  0xFF22303A: LandmarkRoleVariants(
    full: Color(0xFF22303A),
    grey: Color(0xFF7A7877),
  ),
  0xFF8CA3B4: LandmarkRoleVariants(
    full: Color(0xFF8CA3B4),
    grey: Color(0xFFC1BFBC),
  ),
  0xFF7E7362: LandmarkRoleVariants(
    full: Color(0xFF7E7362),
    grey: Color(0xFFA8A6A4),
  ),
  0xFFFFF0BE: LandmarkRoleVariants(
    full: Color(0xFFFFF0BE),
    grey: Color(0xFFEDEAE6),
  ),
  0xFFF2A0BE: LandmarkRoleVariants(
    full: Color(0xFFF2A0BE),
    grey: Color(0xFFCDCAC7),
  ),
  0xFF4B3A22: LandmarkRoleVariants(
    full: Color(0xFF4B3A22),
    grey: Color(0xFF848281),
  ),
  0xFFB09A7C: LandmarkRoleVariants(
    full: Color(0xFFB09A7C),
    grey: Color(0xFFC0BEBB),
  ),
  0xFFC09B3D: LandmarkRoleVariants(
    full: Color(0xFFC09B3D),
    grey: Color(0xFFC0BDBA),
  ),
  0xFFE4543F: LandmarkRoleVariants(
    full: Color(0xFFE4543F),
    grey: Color(0xFFA6A4A2),
  ),
  0xFFEFE8DA: LandmarkRoleVariants(
    full: Color(0xFFEFE8DA),
    grey: Color(0xFFE9E6E3),
  ),
  0xFFB8944B: LandmarkRoleVariants(
    full: Color(0xFFB8944B),
    grey: Color(0xFFBCBAB7),
  ),
  0xFFA87B36: LandmarkRoleVariants(
    full: Color(0xFFA87B36),
    grey: Color(0xFFAFADAA),
  ),
  0xFFB08A5E: LandmarkRoleVariants(
    full: Color(0xFFB08A5E),
    grey: Color(0xFFB8B6B3),
  ),
  0xFFB9AE9C: LandmarkRoleVariants(
    full: Color(0xFFB9AE9C),
    grey: Color(0xFFCAC8C5),
  ),
  0xFF5E6B75: LandmarkRoleVariants(
    full: Color(0xFF5E6B75),
    grey: Color(0xFFA1A09D),
  ),
  0xFFC08A22: LandmarkRoleVariants(
    full: Color(0xFFC08A22),
    grey: Color(0xFFB8B5B3),
  ),
  0xFF5E3620: LandmarkRoleVariants(
    full: Color(0xFF5E3620),
    grey: Color(0xFF858381),
  ),
  0xFFB39A55: LandmarkRoleVariants(
    full: Color(0xFFB39A55),
    grey: Color(0xFFBFBCBA),
  ),
  0xFFF2CE4A: LandmarkRoleVariants(
    full: Color(0xFFF2CE4A),
    grey: Color(0xFFDAD7D4),
  ),
  0xFFCFC0A6: LandmarkRoleVariants(
    full: Color(0xFFCFC0A6),
    grey: Color(0xFFD4D2CE),
  ),
  0xFF5E8F52: LandmarkRoleVariants(
    full: Color(0xFF5E8F52),
    grey: Color(0xFFAFADAB),
  ),
  0xFF9E2F2E: LandmarkRoleVariants(
    full: Color(0xFF9E2F2E),
    grey: Color(0xFF8B8A88),
  ),
  0xFFF9C2D6: LandmarkRoleVariants(
    full: Color(0xFFF9C2D6),
    grey: Color(0xFFDCD9D6),
  ),
  0xFFD9705C: LandmarkRoleVariants(
    full: Color(0xFFD9705C),
    grey: Color(0xFFB2B0AD),
  ),
  0xFFE6F2F6: LandmarkRoleVariants(
    full: Color(0xFFE6F2F6),
    grey: Color(0xFFEDEAE6),
  ),
  0xFFC9A227: LandmarkRoleVariants(
    full: Color(0xFFC9A227),
    grey: Color(0xFFC3C0BD),
  ),
  0xFF9C907C: LandmarkRoleVariants(
    full: Color(0xFF9C907C),
    grey: Color(0xFFB9B7B4),
  ),
  0xFF37424B: LandmarkRoleVariants(
    full: Color(0xFF37424B),
    grey: Color(0xFF878683),
  ),
  0xFF4E555D: LandmarkRoleVariants(
    full: Color(0xFF4E555D),
    grey: Color(0xFF949390),
  ),
  0xFFF0DCB0: LandmarkRoleVariants(
    full: Color(0xFFF0DCB0),
    grey: Color(0xFFE3E0DD),
  ),
  0xFF5D7385: LandmarkRoleVariants(
    full: Color(0xFF5D7385),
    grey: Color(0xFFA6A4A1),
  ),
  0xFFBFD2DE: LandmarkRoleVariants(
    full: Color(0xFFBFD2DE),
    grey: Color(0xFFDBD9D6),
  ),
  0xFFD25F8E: LandmarkRoleVariants(
    full: Color(0xFFD25F8E),
    grey: Color(0xFFACAAA8),
  ),
  0xFF8E2A2C: LandmarkRoleVariants(
    full: Color(0xFF8E2A2C),
    grey: Color(0xFF868583),
  ),
  0xFFD9B871: LandmarkRoleVariants(
    full: Color(0xFFD9B871),
    grey: Color(0xFFD0CECB),
  ),
  0xFFDA8530: LandmarkRoleVariants(
    full: Color(0xFFDA8530),
    grey: Color(0xFFB9B7B4),
  ),
  0xFF9B2E31: LandmarkRoleVariants(
    full: Color(0xFF9B2E31),
    grey: Color(0xFF8B8987),
  ),
  0xFFC2A056: LandmarkRoleVariants(
    full: Color(0xFFC2A056),
    grey: Color(0xFFC3C1BE),
  ),
  0xFFD9AE93: LandmarkRoleVariants(
    full: Color(0xFFD9AE93),
    grey: Color(0xFFCECBC8),
  ),
  0xFFCBC2B2: LandmarkRoleVariants(
    full: Color(0xFFCBC2B2),
    grey: Color(0xFFD5D2CF),
  ),
  0xFFCDB78A: LandmarkRoleVariants(
    full: Color(0xFFCDB78A),
    grey: Color(0xFFCFCDCA),
  ),
  0xFF7A4A2E: LandmarkRoleVariants(
    full: Color(0xFF7A4A2E),
    grey: Color(0xFF93918F),
  ),
  0xFFDCD6C6: LandmarkRoleVariants(
    full: Color(0xFFDCD6C6),
    grey: Color(0xFFDFDDD9),
  ),
  0xFFEE8FB4: LandmarkRoleVariants(
    full: Color(0xFFEE8FB4),
    grey: Color(0xFFC5C3C0),
  ),
  0xFFE8A24C: LandmarkRoleVariants(
    full: Color(0xFFE8A24C),
    grey: Color(0xFFC8C5C2),
  ),
  0xFFC4B49C: LandmarkRoleVariants(
    full: Color(0xFFC4B49C),
    grey: Color(0xFFCECBC8),
  ),
  0xFF8A6A4A: LandmarkRoleVariants(
    full: Color(0xFF8A6A4A),
    grey: Color(0xFFA5A3A0),
  ),
  0xFF66492C: LandmarkRoleVariants(
    full: Color(0xFF66492C),
    grey: Color(0xFF908E8C),
  ),
  0xFF66201C: LandmarkRoleVariants(
    full: Color(0xFF66201C),
    grey: Color(0xFF7B7977),
  ),
  0xFFF0C8A8: LandmarkRoleVariants(
    full: Color(0xFFF0C8A8),
    grey: Color(0xFFDBD8D5),
  ),
  0xFF94742A: LandmarkRoleVariants(
    full: Color(0xFF94742A),
    grey: Color(0xFFA9A7A5),
  ),
  0xFFE3C168: LandmarkRoleVariants(
    full: Color(0xFFE3C168),
    grey: Color(0xFFD4D2CF),
  ),
  0xFF6B7850: LandmarkRoleVariants(
    full: Color(0xFF6B7850),
    grey: Color(0xFFA7A5A3),
  ),
  0xFF9CA878: LandmarkRoleVariants(
    full: Color(0xFF9CA878),
    grey: Color(0xFFC3C1BE),
  ),
  0xFF9E2E2E: LandmarkRoleVariants(
    full: Color(0xFF9E2E2E),
    grey: Color(0xFF8B8987),
  ),
  0xFFE8D6AE: LandmarkRoleVariants(
    full: Color(0xFFE8D6AE),
    grey: Color(0xFFE0DDDA),
  ),
  0xFFDCD5C6: LandmarkRoleVariants(
    full: Color(0xFFDCD5C6),
    grey: Color(0xFFDFDCD9),
  ),
  0xFFEFCE72: LandmarkRoleVariants(
    full: Color(0xFFEFCE72),
    grey: Color(0xFFDBD9D5),
  ),
  0xFFC4762B: LandmarkRoleVariants(
    full: Color(0xFFC4762B),
    grey: Color(0xFFB0AEAB),
  ),
  0xFFFFF4E0: LandmarkRoleVariants(
    full: Color(0xFFFFF4E0),
    grey: Color(0xFFEFECE9),
  ),
  0xFF5A6874: LandmarkRoleVariants(
    full: Color(0xFF5A6874),
    grey: Color(0xFFA09E9B),
  ),
  0xFFF2CE4B: LandmarkRoleVariants(
    full: Color(0xFFF2CE4B),
    grey: Color(0xFFDAD7D4),
  ),
  0xFFE8C558: LandmarkRoleVariants(
    full: Color(0xFFE8C558),
    grey: Color(0xFFD6D3D0),
  ),
  0xFFF7EBCE: LandmarkRoleVariants(
    full: Color(0xFFF7EBCE),
    grey: Color(0xFFEAE8E4),
  ),
  0xFFC4A66E: LandmarkRoleVariants(
    full: Color(0xFFC4A66E),
    grey: Color(0xFFC6C4C1),
  ),
  0xFF3A5248: LandmarkRoleVariants(
    full: Color(0xFF3A5248),
    grey: Color(0xFF8F8D8B),
  ),
  0xFFD2C0A6: LandmarkRoleVariants(
    full: Color(0xFFD2C0A6),
    grey: Color(0xFFD5D2CF),
  ),
  0xFF8A7538: LandmarkRoleVariants(
    full: Color(0xFF8A7538),
    grey: Color(0xFFA9A7A4),
  ),
  0xFFD9C07A: LandmarkRoleVariants(
    full: Color(0xFFD9C07A),
    grey: Color(0xFFD4D1CE),
  ),
  0xFFF2DCCB: LandmarkRoleVariants(
    full: Color(0xFFF2DCCB),
    grey: Color(0xFFE4E1DE),
  ),
  0xFFAFA087: LandmarkRoleVariants(
    full: Color(0xFFAFA087),
    grey: Color(0xFFC3C0BD),
  ),
  0xFFE6DAC6: LandmarkRoleVariants(
    full: Color(0xFFE6DAC6),
    grey: Color(0xFFE2DFDC),
  ),
  0xFFFBD2E1: LandmarkRoleVariants(
    full: Color(0xFFFBD2E1),
    grey: Color(0xFFE2E0DC),
  ),
  0xFFF3EEE2: LandmarkRoleVariants(
    full: Color(0xFFF3EEE2),
    grey: Color(0xFFECE9E6),
  ),
  0xFFDED6C4: LandmarkRoleVariants(
    full: Color(0xFFDED6C4),
    grey: Color(0xFFDFDDD9),
  ),
  0xFF332821: LandmarkRoleVariants(
    full: Color(0xFF332821),
    grey: Color(0xFF777674),
  ),
  0xFF94826B: LandmarkRoleVariants(
    full: Color(0xFF94826B),
    grey: Color(0xFFB2B0AD),
  ),
  0xFFF2EFE6: LandmarkRoleVariants(
    full: Color(0xFFF2EFE6),
    grey: Color(0xFFECE9E6),
  ),
  0xFFDAD3C2: LandmarkRoleVariants(
    full: Color(0xFFDAD3C2),
    grey: Color(0xFFDEDBD8),
  ),
  0xFFE0715C: LandmarkRoleVariants(
    full: Color(0xFFE0715C),
    grey: Color(0xFFB4B1AF),
  ),
  0xFF8A3529: LandmarkRoleVariants(
    full: Color(0xFF8A3529),
    grey: Color(0xFF8B8987),
  ),
  0xFFD8CBB4: LandmarkRoleVariants(
    full: Color(0xFFD8CBB4),
    grey: Color(0xFFDAD7D4),
  ),
  0xFFB3A288: LandmarkRoleVariants(
    full: Color(0xFFB3A288),
    grey: Color(0xFFC4C2BF),
  ),
  0xFFD6453C: LandmarkRoleVariants(
    full: Color(0xFFD6453C),
    grey: Color(0xFF9E9C9A),
  ),
  0xFFAE3129: LandmarkRoleVariants(
    full: Color(0xFFAE3129),
    grey: Color(0xFF8E8D8B),
  ),
  0xFFD2739E: LandmarkRoleVariants(
    full: Color(0xFFD2739E),
    grey: Color(0xFFB5B3B1),
  ),
  0xFFE4C98A: LandmarkRoleVariants(
    full: Color(0xFFE4C98A),
    grey: Color(0xFFD9D6D3),
  ),
  0xFFC9A0B4: LandmarkRoleVariants(
    full: Color(0xFFC9A0B4),
    grey: Color(0xFFC7C5C2),
  ),
  0xFFF0D89A: LandmarkRoleVariants(
    full: Color(0xFFF0D89A),
    grey: Color(0xFFE1DEDB),
  ),
  0xFFEDE4D2: LandmarkRoleVariants(
    full: Color(0xFFEDE4D2),
    grey: Color(0xFFE7E4E1),
  ),
  0xFF20302C: LandmarkRoleVariants(
    full: Color(0xFF20302C),
    grey: Color(0xFF797776),
  ),
  0xFF2C4038: LandmarkRoleVariants(
    full: Color(0xFF2C4038),
    grey: Color(0xFF848280),
  ),
  0xFF3E7A46: LandmarkRoleVariants(
    full: Color(0xFF3E7A46),
    grey: Color(0xFFA2A09D),
  ),
  0xFF8E2E28: LandmarkRoleVariants(
    full: Color(0xFF8E2E28),
    grey: Color(0xFF888785),
  ),
  0xFFF3D97A: LandmarkRoleVariants(
    full: Color(0xFFF3D97A),
    grey: Color(0xFFE0DDDA),
  ),
  0xFF6B4E84: LandmarkRoleVariants(
    full: Color(0xFF6B4E84),
    grey: Color(0xFF979593),
  ),
  0xFFF2A03F: LandmarkRoleVariants(
    full: Color(0xFFF2A03F),
    grey: Color(0xFFC8C5C2),
  ),
  0xFFC96F22: LandmarkRoleVariants(
    full: Color(0xFFC96F22),
    grey: Color(0xFFADABA9),
  ),
  0xFF4A2A18: LandmarkRoleVariants(
    full: Color(0xFF4A2A18),
    grey: Color(0xFF7B7A78),
  ),
  0xFFDB6F5C: LandmarkRoleVariants(
    full: Color(0xFFDB6F5C),
    grey: Color(0xFFB2B0AD),
  ),
  0xFF948C7E: LandmarkRoleVariants(
    full: Color(0xFF948C7E),
    grey: Color(0xFFB7B5B2),
  ),
  0xFF3A3F46: LandmarkRoleVariants(
    full: Color(0xFF3A3F46),
    grey: Color(0xFF868482),
  ),
  0xFF2C3036: LandmarkRoleVariants(
    full: Color(0xFF2C3036),
    grey: Color(0xFF7B7A78),
  ),
  0xFF8FD3E8: LandmarkRoleVariants(
    full: Color(0xFF8FD3E8),
    grey: Color(0xFFD7D4D1),
  ),
  0xFFF2EDE3: LandmarkRoleVariants(
    full: Color(0xFFF2EDE3),
    grey: Color(0xFFEBE9E5),
  ),
  0xFFE3B26A: LandmarkRoleVariants(
    full: Color(0xFFE3B26A),
    grey: Color(0xFFCFCCC9),
  ),
  0xFFC4884A: LandmarkRoleVariants(
    full: Color(0xFFC4884A),
    grey: Color(0xFFB9B7B4),
  ),
  0xFFE0A0A8: LandmarkRoleVariants(
    full: Color(0xFFE0A0A8),
    grey: Color(0xFFCAC7C4),
  ),
  0xFF9E5560: LandmarkRoleVariants(
    full: Color(0xFF9E5560),
    grey: Color(0xFF9F9D9B),
  ),
  0xFFFDE0EA: LandmarkRoleVariants(
    full: Color(0xFFFDE0EA),
    grey: Color(0xFFE8E5E2),
  ),
  0xFF9E8E76: LandmarkRoleVariants(
    full: Color(0xFF9E8E76),
    grey: Color(0xFFB9B6B4),
  ),
  0xFF4A4F55: LandmarkRoleVariants(
    full: Color(0xFF4A4F55),
    grey: Color(0xFF918F8D),
  ),
  0xFFFFE9C2: LandmarkRoleVariants(
    full: Color(0xFFFFE9C2),
    grey: Color(0xFFEAE7E4),
  ),
  0xFFB4C4C0: LandmarkRoleVariants(
    full: Color(0xFFB4C4C0),
    grey: Color(0xFFD4D1CE),
  ),
  0xFFE2705C: LandmarkRoleVariants(
    full: Color(0xFFE2705C),
    grey: Color(0xFFB3B1AF),
  ),
  0xFFDCE9EE: LandmarkRoleVariants(
    full: Color(0xFFDCE9EE),
    grey: Color(0xFFE8E5E2),
  ),
  0xFFC4BDB0: LandmarkRoleVariants(
    full: Color(0xFFC4BDB0),
    grey: Color(0xFFD2D0CD),
  ),
  0xFFEFEBE2: LandmarkRoleVariants(
    full: Color(0xFFEFEBE2),
    grey: Color(0xFFEAE7E4),
  ),
  0xFFD9739B: LandmarkRoleVariants(
    full: Color(0xFFD9739B),
    grey: Color(0xFFB6B4B1),
  ),
  0xFFE8DCC6: LandmarkRoleVariants(
    full: Color(0xFFE8DCC6),
    grey: Color(0xFFE3E0DD),
  ),
  0xFF6E523A: LandmarkRoleVariants(
    full: Color(0xFF6E523A),
    grey: Color(0xFF969492),
  ),
  0xFF57402C: LandmarkRoleVariants(
    full: Color(0xFF57402C),
    grey: Color(0xFF898886),
  ),
  0xFF6E4529: LandmarkRoleVariants(
    full: Color(0xFF6E4529),
    grey: Color(0xFF8F8D8B),
  ),
  0xFFB8443A: LandmarkRoleVariants(
    full: Color(0xFFB8443A),
    grey: Color(0xFF999895),
  ),
  0xFF5C202C: LandmarkRoleVariants(
    full: Color(0xFF5C202C),
    grey: Color(0xFF7A7877),
  ),
  0xFFCFC7B6: LandmarkRoleVariants(
    full: Color(0xFFCFC7B6),
    grey: Color(0xFFD7D5D2),
  ),
  0xFFE8B93C: LandmarkRoleVariants(
    full: Color(0xFFE8B93C),
    grey: Color(0xFFD0CECB),
  ),
  0xFFE4E0D6: LandmarkRoleVariants(
    full: Color(0xFFE4E0D6),
    grey: Color(0xFFE5E2DE),
  ),
  0xFFC3BEB2: LandmarkRoleVariants(
    full: Color(0xFFC3BEB2),
    grey: Color(0xFFD2D0CD),
  ),
  0xFF8E6FA8: LandmarkRoleVariants(
    full: Color(0xFF8E6FA8),
    grey: Color(0xFFACAAA7),
  ),
  0xFFF3C6BE: LandmarkRoleVariants(
    full: Color(0xFFF3C6BE),
    grey: Color(0xFFDBD9D6),
  ),
  0xFFE86A78: LandmarkRoleVariants(
    full: Color(0xFFE86A78),
    grey: Color(0xFFB3B1AE),
  ),
  0xFFB7841F: LandmarkRoleVariants(
    full: Color(0xFFB7841F),
    grey: Color(0xFFB4B2AF),
  ),
  0xFF2C1E44: LandmarkRoleVariants(
    full: Color(0xFF2C1E44),
    grey: Color(0xFF72716F),
  ),
  0xFF8E2E2D: LandmarkRoleVariants(
    full: Color(0xFF8E2E2D),
    grey: Color(0xFF888785),
  ),
  0xFFE2E7EB: LandmarkRoleVariants(
    full: Color(0xFFE2E7EB),
    grey: Color(0xFFE8E5E1),
  ),
  0xFFB8C1C9: LandmarkRoleVariants(
    full: Color(0xFFB8C1C9),
    grey: Color(0xFFD3D1CE),
  ),
  0xFF7FB8A6: LandmarkRoleVariants(
    full: Color(0xFF7FB8A6),
    grey: Color(0xFFC8C5C2),
  ),
  0xFF2A6A5D: LandmarkRoleVariants(
    full: Color(0xFF2A6A5D),
    grey: Color(0xFF999795),
  ),
  0xFFF7DCE5: LandmarkRoleVariants(
    full: Color(0xFFF7DCE5),
    grey: Color(0xFFE6E3E0),
  ),
  0xFFF0B9CC: LandmarkRoleVariants(
    full: Color(0xFFF0B9CC),
    grey: Color(0xFFD7D4D1),
  ),
  0xFFF3AFC4: LandmarkRoleVariants(
    full: Color(0xFFF3AFC4),
    grey: Color(0xFFD3D0CD),
  ),
  0xFFFBD3DE: LandmarkRoleVariants(
    full: Color(0xFFFBD3DE),
    grey: Color(0xFFE3E0DC),
  ),
  0xFFE087A6: LandmarkRoleVariants(
    full: Color(0xFFE087A6),
    grey: Color(0xFFC0BDBB),
  ),
  0xFF20242F: LandmarkRoleVariants(
    full: Color(0xFF20242F),
    grey: Color(0xFF72716F),
  ),
  0xFFA79E89: LandmarkRoleVariants(
    full: Color(0xFFA79E89),
    grey: Color(0xFFC1BFBC),
  ),
  0xFF4A3B33: LandmarkRoleVariants(
    full: Color(0xFF4A3B33),
    grey: Color(0xFF858482),
  ),
  0xFFB54F2A: LandmarkRoleVariants(
    full: Color(0xFFB54F2A),
    grey: Color(0xFF9D9B99),
  ),
  0xFF8E3B1E: LandmarkRoleVariants(
    full: Color(0xFF8E3B1E),
    grey: Color(0xFF8E8C8A),
  ),
  0xFFD9A93A: LandmarkRoleVariants(
    full: Color(0xFFD9A93A),
    grey: Color(0xFFC8C6C3),
  ),
  0xFFA87C1E: LandmarkRoleVariants(
    full: Color(0xFFA87C1E),
    grey: Color(0xFFAFACAA),
  ),
  0xFFFBF8F1: LandmarkRoleVariants(
    full: Color(0xFFFBF8F1),
    grey: Color(0xFFF1EEEA),
  ),
  0xFFE2DACA: LandmarkRoleVariants(
    full: Color(0xFFE2DACA),
    grey: Color(0xFFE2DFDC),
  ),
  0xFF82AE70: LandmarkRoleVariants(
    full: Color(0xFF82AE70),
    grey: Color(0xFFC2C0BD),
  ),
  0xFF456B3C: LandmarkRoleVariants(
    full: Color(0xFF456B3C),
    grey: Color(0xFF9C9A97),
  ),
  0xFFF7F5EE: LandmarkRoleVariants(
    full: Color(0xFFF7F5EE),
    grey: Color(0xFFEFECE9),
  ),
  0xFFC9A86A: LandmarkRoleVariants(
    full: Color(0xFFC9A86A),
    grey: Color(0xFFC8C5C2),
  ),
  0xFFE0C58E: LandmarkRoleVariants(
    full: Color(0xFFE0C58E),
    grey: Color(0xFFD7D5D1),
  ),
  0xFFA88748: LandmarkRoleVariants(
    full: Color(0xFFA88748),
    grey: Color(0xFFB5B3B0),
  ),
  0xFFF5F0E2: LandmarkRoleVariants(
    full: Color(0xFFF5F0E2),
    grey: Color(0xFFEDEAE6),
  ),
  0xFF9E3B32: LandmarkRoleVariants(
    full: Color(0xFF9E3B32),
    grey: Color(0xFF91908D),
  ),
  0xFFF0EBE0: LandmarkRoleVariants(
    full: Color(0xFFF0EBE0),
    grey: Color(0xFFEAE8E4),
  ),
  0xFFFBFBF6: LandmarkRoleVariants(
    full: Color(0xFFFBFBF6),
    grey: Color(0xFFF2EFEC),
  ),
  0xFFCFC7B8: LandmarkRoleVariants(
    full: Color(0xFFCFC7B8),
    grey: Color(0xFFD8D5D2),
  ),
  0xFFD3A32C: LandmarkRoleVariants(
    full: Color(0xFFD3A32C),
    grey: Color(0xFFC4C2BF),
  ),
  0xFFF0C64B: LandmarkRoleVariants(
    full: Color(0xFFF0C64B),
    grey: Color(0xFFD7D4D1),
  ),
  0xFFC4757F: LandmarkRoleVariants(
    full: Color(0xFFC4757F),
    grey: Color(0xFFB3B1AE),
  ),
  0xFFFBE7D3: LandmarkRoleVariants(
    full: Color(0xFFFBE7D3),
    grey: Color(0xFFEAE7E3),
  ),
  0xFF9A3A22: LandmarkRoleVariants(
    full: Color(0xFF9A3A22),
    grey: Color(0xFF8F8E8C),
  ),
  0xFF36584D: LandmarkRoleVariants(
    full: Color(0xFF36584D),
    grey: Color(0xFF92908E),
  ),
  0xFF9CC2B2: LandmarkRoleVariants(
    full: Color(0xFF9CC2B2),
    grey: Color(0xFFD0CDCA),
  ),
  0xFF5E8E7E: LandmarkRoleVariants(
    full: Color(0xFF5E8E7E),
    grey: Color(0xFFB1AFAC),
  ),
  0xFFE4D8C4: LandmarkRoleVariants(
    full: Color(0xFFE4D8C4),
    grey: Color(0xFFE1DEDB),
  ),
  0xFFB04A3C: LandmarkRoleVariants(
    full: Color(0xFFB04A3C),
    grey: Color(0xFF9B9997),
  ),
  0xFF383D42: LandmarkRoleVariants(
    full: Color(0xFF383D42),
    grey: Color(0xFF848381),
  ),
  0xFFEFE9DE: LandmarkRoleVariants(
    full: Color(0xFFEFE9DE),
    grey: Color(0xFFE9E7E3),
  ),
  0xFFB4ABA0: LandmarkRoleVariants(
    full: Color(0xFFB4ABA0),
    grey: Color(0xFFC9C6C3),
  ),
  0xFFE4DACA: LandmarkRoleVariants(
    full: Color(0xFFE4DACA),
    grey: Color(0xFFE2DFDC),
  ),
  0xFFB8836A: LandmarkRoleVariants(
    full: Color(0xFFB8836A),
    grey: Color(0xFFB7B5B2),
  ),
  0xFFF2ECE0: LandmarkRoleVariants(
    full: Color(0xFFF2ECE0),
    grey: Color(0xFFEBE8E5),
  ),
  0xFFD9CFBC: LandmarkRoleVariants(
    full: Color(0xFFD9CFBC),
    grey: Color(0xFFDCD9D6),
  ),
  0xFFCFE4EC: LandmarkRoleVariants(
    full: Color(0xFFCFE4EC),
    grey: Color(0xFFE5E2DE),
  ),
  0xFFB6D4DF: LandmarkRoleVariants(
    full: Color(0xFFB6D4DF),
    grey: Color(0xFFDBD9D5),
  ),
  0xFFFBE7A8: LandmarkRoleVariants(
    full: Color(0xFFFBE7A8),
    grey: Color(0xFFE8E5E2),
  ),
  0xFFEDF1EE: LandmarkRoleVariants(
    full: Color(0xFFEDF1EE),
    grey: Color(0xFFEDEAE6),
  ),
  0xFFF0CE7E: LandmarkRoleVariants(
    full: Color(0xFFF0CE7E),
    grey: Color(0xFFDCD9D6),
  ),
  0xFFF7EEDC: LandmarkRoleVariants(
    full: Color(0xFFF7EEDC),
    grey: Color(0xFFECE9E6),
  ),
  0xFF7E8C99: LandmarkRoleVariants(
    full: Color(0xFF7E8C99),
    grey: Color(0xFFB5B3B0),
  ),
  0xFFC9D3DA: LandmarkRoleVariants(
    full: Color(0xFFC9D3DA),
    grey: Color(0xFFDDDAD7),
  ),
  0xFF8F8A7E: LandmarkRoleVariants(
    full: Color(0xFF8F8A7E),
    grey: Color(0xFFB5B3B1),
  ),
  0xFFD9A85C: LandmarkRoleVariants(
    full: Color(0xFFD9A85C),
    grey: Color(0xFFC9C7C4),
  ),
  0xFFF5F2E8: LandmarkRoleVariants(
    full: Color(0xFFF5F2E8),
    grey: Color(0xFFEEEBE7),
  ),
  0xFF4E5C4B: LandmarkRoleVariants(
    full: Color(0xFF4E5C4B),
    grey: Color(0xFF979593),
  ),
  0xFF3A4638: LandmarkRoleVariants(
    full: Color(0xFF3A4638),
    grey: Color(0xFF898785),
  ),
  0xFFEE9A32: LandmarkRoleVariants(
    full: Color(0xFFEE9A32),
    grey: Color(0xFFC4C2BF),
  ),
  0xFFC97A1E: LandmarkRoleVariants(
    full: Color(0xFFC97A1E),
    grey: Color(0xFFB2B0AD),
  ),
  0xFFF7B45C: LandmarkRoleVariants(
    full: Color(0xFFF7B45C),
    grey: Color(0xFFD1CFCC),
  ),
  0xFFF5C98A: LandmarkRoleVariants(
    full: Color(0xFFF5C98A),
    grey: Color(0xFFDBD8D5),
  ),
  0xFF5E656C: LandmarkRoleVariants(
    full: Color(0xFF5E656C),
    grey: Color(0xFF9E9D9A),
  ),
  0xFFB8862A: LandmarkRoleVariants(
    full: Color(0xFFB8862A),
    grey: Color(0xFFB5B3B0),
  ),
  0xFFC9D2DA: LandmarkRoleVariants(
    full: Color(0xFFC9D2DA),
    grey: Color(0xFFDCDAD6),
  ),
  0xFF5FA84E: LandmarkRoleVariants(
    full: Color(0xFF5FA84E),
    grey: Color(0xFFBAB8B5),
  ),
  0xFF3C7F3A: LandmarkRoleVariants(
    full: Color(0xFF3C7F3A),
    grey: Color(0xFFA3A19F),
  ),
  0xFF4E9149: LandmarkRoleVariants(
    full: Color(0xFF4E9149),
    grey: Color(0xFFAEACA9),
  ),
  0xFFA8851C: LandmarkRoleVariants(
    full: Color(0xFFA8851C),
    grey: Color(0xFFB2B0AD),
  ),
  0xFFD8623F: LandmarkRoleVariants(
    full: Color(0xFFD8623F),
    grey: Color(0xFFABA9A6),
  ),
  0xFF8A5A38: LandmarkRoleVariants(
    full: Color(0xFF8A5A38),
    grey: Color(0xFF9D9B99),
  ),
  0xFF8A6640: LandmarkRoleVariants(
    full: Color(0xFF8A6640),
    grey: Color(0xFFA3A19E),
  ),
  0xFFC99A52: LandmarkRoleVariants(
    full: Color(0xFFC99A52),
    grey: Color(0xFFC1BFBC),
  ),
};
