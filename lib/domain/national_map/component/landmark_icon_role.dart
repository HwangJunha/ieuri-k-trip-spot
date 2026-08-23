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
  0xFFFFFFFF: LandmarkRoleVariants(
    full: Color(0xFFFFFFFF),
    grey: Color(0xFFF4F1EE),
  ),
  0xFFC4403F: LandmarkRoleVariants(
    full: Color(0xFFC4403F),
    grey: Color(0xFF999895),
  ),
  0xFF2E6B4F: LandmarkRoleVariants(
    full: Color(0xFF2E6B4F),
    grey: Color(0xFF999895),
  ),
  0xFF8A4818: LandmarkRoleVariants(
    full: Color(0xFF8A4818),
    grey: Color(0xFF93928F),
  ),
  0xFF3E8E7E: LandmarkRoleVariants(
    full: Color(0xFF3E8E7E),
    grey: Color(0xFFADABA8),
  ),
  0xFF1F4F3A: LandmarkRoleVariants(
    full: Color(0xFF1F4F3A),
    grey: Color(0xFF898885),
  ),
  0xFF6FA455: LandmarkRoleVariants(
    full: Color(0xFF6FA455),
    grey: Color(0xFFBAB8B5),
  ),
  0xFFEFE3D0: LandmarkRoleVariants(
    full: Color(0xFFEFE3D0),
    grey: Color(0xFFE7E4E0),
  ),
  0xFF8FBF6A: LandmarkRoleVariants(
    full: Color(0xFF8FBF6A),
    grey: Color(0xFFCAC8C5),
  ),
  0xFFD9C9B4: LandmarkRoleVariants(
    full: Color(0xFFD9C9B4),
    grey: Color(0xFFD9D7D3),
  ),
  0xFF4E8F63: LandmarkRoleVariants(
    full: Color(0xFF4E8F63),
    grey: Color(0xFFAEACAA),
  ),
  0xFFE0A93B: LandmarkRoleVariants(
    full: Color(0xFFE0A93B),
    grey: Color(0xFFC9C7C4),
  ),
  0xFFFFEDD6: LandmarkRoleVariants(
    full: Color(0xFFFFEDD6),
    grey: Color(0xFFECEAE6),
  ),
  0xFF3E93A8: LandmarkRoleVariants(
    full: Color(0xFF3E93A8),
    grey: Color(0xFFB1AFAC),
  ),
  0xFFF5F7F5: LandmarkRoleVariants(
    full: Color(0xFFF5F7F5),
    grey: Color(0xFFF0EDEA),
  ),
  0xFFA85C22: LandmarkRoleVariants(
    full: Color(0xFFA85C22),
    grey: Color(0xFFA19F9D),
  ),
  0xFF55626E: LandmarkRoleVariants(
    full: Color(0xFF55626E),
    grey: Color(0xFF9C9A98),
  ),
  0xFF63B0C0: LandmarkRoleVariants(
    full: Color(0xFF63B0C0),
    grey: Color(0xFFC2C0BD),
  ),
  0xFF2E7A8C: LandmarkRoleVariants(
    full: Color(0xFF2E7A8C),
    grey: Color(0xFFA3A19E),
  ),
  0xFF8A97A3: LandmarkRoleVariants(
    full: Color(0xFF8A97A3),
    grey: Color(0xFFBCB9B7),
  ),
  0xFF2B2B45: LandmarkRoleVariants(
    full: Color(0xFF2B2B45),
    grey: Color(0xFF2B2B45),
  ),
  0xFFFFEEE9: LandmarkRoleVariants(
    full: Color(0xFFFFEEE9),
    grey: Color(0xFFEDEBE7),
  ),
  0xFFE9F8EE: LandmarkRoleVariants(
    full: Color(0xFFE9F8EE),
    grey: Color(0xFFEFECE8),
  ),
  0xFF94714F: LandmarkRoleVariants(
    full: Color(0xFF94714F),
    grey: Color(0xFFA9A7A5),
  ),
  0xFFC9752F: LandmarkRoleVariants(
    full: Color(0xFFC9752F),
    grey: Color(0xFFB0AEAC),
  ),
  0xFFB08968: LandmarkRoleVariants(
    full: Color(0xFFB08968),
    grey: Color(0xFFB8B6B3),
  ),
  0xFFF5D670: LandmarkRoleVariants(
    full: Color(0xFFF5D670),
    grey: Color(0xFFDFDCD9),
  ),
  0xFFBFAC94: LandmarkRoleVariants(
    full: Color(0xFFBFAC94),
    grey: Color(0xFFCAC7C4),
  ),
  0xFF6E7C89: LandmarkRoleVariants(
    full: Color(0xFF6E7C89),
    grey: Color(0xFFACAAA7),
  ),
  0xFFE88BB0: LandmarkRoleVariants(
    full: Color(0xFFE88BB0),
    grey: Color(0xFFC3C0BD),
  ),
  0xFFE6F4FD: LandmarkRoleVariants(
    full: Color(0xFFE6F4FD),
    grey: Color(0xFFEEEBE7),
  ),
  0xFFE7F8F7: LandmarkRoleVariants(
    full: Color(0xFFE7F8F7),
    grey: Color(0xFFEFECE9),
  ),
  0xFFFFD9A8: LandmarkRoleVariants(
    full: Color(0xFFFFD9A8),
    grey: Color(0xFFE3E0DD),
  ),
  0xFFE8B42E: LandmarkRoleVariants(
    full: Color(0xFFE8B42E),
    grey: Color(0xFFCECBC8),
  ),
  0xFFA8C86A: LandmarkRoleVariants(
    full: Color(0xFFA8C86A),
    grey: Color(0xFFD0CECB),
  ),
  0xFFF2ECFB: LandmarkRoleVariants(
    full: Color(0xFFF2ECFB),
    grey: Color(0xFFECE9E6),
  ),
  0xFF2B3A38: LandmarkRoleVariants(
    full: Color(0xFF2B3A38),
    grey: Color(0xFF807F7D),
  ),
  0xFFBFB4A0: LandmarkRoleVariants(
    full: Color(0xFFBFB4A0),
    grey: Color(0xFFCDCBC8),
  ),
  0xFFFFEEF2: LandmarkRoleVariants(
    full: Color(0xFFFFEEF2),
    grey: Color(0xFFEEEBE7),
  ),
  0xFF6B5A9E: LandmarkRoleVariants(
    full: Color(0xFF6B5A9E),
    grey: Color(0xFF9D9C99),
  ),
  0xFFC0342F: LandmarkRoleVariants(
    full: Color(0xFFC0342F),
    grey: Color(0xFF93918F),
  ),
  0xFFE4655C: LandmarkRoleVariants(
    full: Color(0xFFE4655C),
    grey: Color(0xFFAFADAA),
  ),
  0xFFB9B2A4: LandmarkRoleVariants(
    full: Color(0xFFB9B2A4),
    grey: Color(0xFFCCCAC7),
  ),
  0xFFD3F0DC: LandmarkRoleVariants(
    full: Color(0xFFD3F0DC),
    grey: Color(0xFFE9E6E3),
  ),
  0xFF9E9382: LandmarkRoleVariants(
    full: Color(0xFF9E9382),
    grey: Color(0xFFBBB9B6),
  ),
  0xFFFFDCD2: LandmarkRoleVariants(
    full: Color(0xFFFFDCD2),
    grey: Color(0xFFE6E3E0),
  ),
  0xFFFFF8E2: LandmarkRoleVariants(
    full: Color(0xFFFFF8E2),
    grey: Color(0xFFF1EEEA),
  ),
  0xFFCDB878: LandmarkRoleVariants(
    full: Color(0xFFCDB878),
    grey: Color(0xFFCFCDC9),
  ),
  0xFFC4517E: LandmarkRoleVariants(
    full: Color(0xFFC4517E),
    grey: Color(0xFFA4A29F),
  ),
  0xFF48545E: LandmarkRoleVariants(
    full: Color(0xFF48545E),
    grey: Color(0xFF93918F),
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
  0xFFD8D3C8: LandmarkRoleVariants(
    full: Color(0xFFD8D3C8),
    grey: Color(0xFFDEDBD8),
  ),
  0xFFE8D9A8: LandmarkRoleVariants(
    full: Color(0xFFE8D9A8),
    grey: Color(0xFFE1DEDB),
  ),
  0xFFF0BE2E: LandmarkRoleVariants(
    full: Color(0xFFF0BE2E),
    grey: Color(0xFFD2D0CD),
  ),
  0xFFF0CB6E: LandmarkRoleVariants(
    full: Color(0xFFF0CB6E),
    grey: Color(0xFFDAD7D4),
  ),
  0xFFE6DCF7: LandmarkRoleVariants(
    full: Color(0xFFE6DCF7),
    grey: Color(0xFFE4E2DE),
  ),
  0xFFE0705A: LandmarkRoleVariants(
    full: Color(0xFFE0705A),
    grey: Color(0xFFB3B1AE),
  ),
  0xFFFFDCE4: LandmarkRoleVariants(
    full: Color(0xFFFFDCE4),
    grey: Color(0xFFE7E4E0),
  ),
  0xFF8E7DBE: LandmarkRoleVariants(
    full: Color(0xFF8E7DBE),
    grey: Color(0xFFB3B0AE),
  ),
  0xFF9A88C8: LandmarkRoleVariants(
    full: Color(0xFF9A88C8),
    grey: Color(0xFFB9B7B4),
  ),
  0xFF9E3330: LandmarkRoleVariants(
    full: Color(0xFF9E3330),
    grey: Color(0xFF8D8C8A),
  ),
  0xFF4FA894: LandmarkRoleVariants(
    full: Color(0xFF4FA894),
    grey: Color(0xFFBBB9B6),
  ),
  0xFFD19A12: LandmarkRoleVariants(
    full: Color(0xFFD19A12),
    grey: Color(0xFFBFBDBA),
  ),
  0xFFE8C24A: LandmarkRoleVariants(
    full: Color(0xFFE8C24A),
    grey: Color(0xFFD4D2CF),
  ),
  0xFFBE9526: LandmarkRoleVariants(
    full: Color(0xFFBE9526),
    grey: Color(0xFFBCBAB7),
  ),
  0xFF7B5EA7: LandmarkRoleVariants(
    full: Color(0xFF7B5EA7),
    grey: Color(0xFFA2A09D),
  ),
  0xFFCBAA6A: LandmarkRoleVariants(
    full: Color(0xFFCBAA6A),
    grey: Color(0xFFC9C6C3),
  ),
  0xFF7E7362: LandmarkRoleVariants(
    full: Color(0xFF7E7362),
    grey: Color(0xFFA8A6A4),
  ),
  0xFFFFF0BE: LandmarkRoleVariants(
    full: Color(0xFFFFF0BE),
    grey: Color(0xFFEDEAE6),
  ),
  0xFFB8862A: LandmarkRoleVariants(
    full: Color(0xFFB8862A),
    grey: Color(0xFFB5B3B0),
  ),
  0xFF7EA84E: LandmarkRoleVariants(
    full: Color(0xFF7EA84E),
    grey: Color(0xFFBEBBB9),
  ),
  0xFF4B3A22: LandmarkRoleVariants(
    full: Color(0xFF4B3A22),
    grey: Color(0xFF848281),
  ),
  0xFF7A3D14: LandmarkRoleVariants(
    full: Color(0xFF7A3D14),
    grey: Color(0xFF8C8A88),
  ),
  0xFFF2EADB: LandmarkRoleVariants(
    full: Color(0xFFF2EADB),
    grey: Color(0xFFEAE7E4),
  ),
  0xFFC09B3D: LandmarkRoleVariants(
    full: Color(0xFFC09B3D),
    grey: Color(0xFFC0BDBA),
  ),
  0xFFC79E45: LandmarkRoleVariants(
    full: Color(0xFFC79E45),
    grey: Color(0xFFC2C0BD),
  ),
  0xFF8E2B2C: LandmarkRoleVariants(
    full: Color(0xFF8E2B2C),
    grey: Color(0xFF878583),
  ),
  0xFF8E2A2A: LandmarkRoleVariants(
    full: Color(0xFF8E2A2A),
    grey: Color(0xFF868583),
  ),
  0xFFA2762F: LandmarkRoleVariants(
    full: Color(0xFFA2762F),
    grey: Color(0xFFACAAA7),
  ),
  0xFFB9AE9C: LandmarkRoleVariants(
    full: Color(0xFFB9AE9C),
    grey: Color(0xFFCAC8C5),
  ),
  0xFF5E3620: LandmarkRoleVariants(
    full: Color(0xFF5E3620),
    grey: Color(0xFF858381),
  ),
  0xFFE4D4A8: LandmarkRoleVariants(
    full: Color(0xFFE4D4A8),
    grey: Color(0xFFDEDCD8),
  ),
  0xFFE6F2F6: LandmarkRoleVariants(
    full: Color(0xFFE6F2F6),
    grey: Color(0xFFEDEAE6),
  ),
  0xFFC9A227: LandmarkRoleVariants(
    full: Color(0xFFC9A227),
    grey: Color(0xFFC3C0BD),
  ),
  0xFFF2EDE0: LandmarkRoleVariants(
    full: Color(0xFFF2EDE0),
    grey: Color(0xFFEBE8E5),
  ),
  0xFF9C907C: LandmarkRoleVariants(
    full: Color(0xFF9C907C),
    grey: Color(0xFFB9B7B4),
  ),
  0xFF5E6B75: LandmarkRoleVariants(
    full: Color(0xFF5E6B75),
    grey: Color(0xFFA1A09D),
  ),
  0xFFBFA871: LandmarkRoleVariants(
    full: Color(0xFFBFA871),
    grey: Color(0xFFC7C4C1),
  ),
  0xFF2E7264: LandmarkRoleVariants(
    full: Color(0xFF2E7264),
    grey: Color(0xFF9D9C99),
  ),
  0xFF37424B: LandmarkRoleVariants(
    full: Color(0xFF37424B),
    grey: Color(0xFF878683),
  ),
  0xFFF0DCB0: LandmarkRoleVariants(
    full: Color(0xFFF0DCB0),
    grey: Color(0xFFE3E0DD),
  ),
  0xFF3F2C5E: LandmarkRoleVariants(
    full: Color(0xFF3F2C5E),
    grey: Color(0xFF7E7D7B),
  ),
  0xFF4A7A3C: LandmarkRoleVariants(
    full: Color(0xFF4A7A3C),
    grey: Color(0xFFA3A19F),
  ),
  0xFFD9B871: LandmarkRoleVariants(
    full: Color(0xFFD9B871),
    grey: Color(0xFFD0CECB),
  ),
  0xFFC3B49A: LandmarkRoleVariants(
    full: Color(0xFFC3B49A),
    grey: Color(0xFFCECBC8),
  ),
  0xFFDDD1BC: LandmarkRoleVariants(
    full: Color(0xFFDDD1BC),
    grey: Color(0xFFDDDAD7),
  ),
  0xFFF2F6F7: LandmarkRoleVariants(
    full: Color(0xFFF2F6F7),
    grey: Color(0xFFEFEDE9),
  ),
  0xFF4A5578: LandmarkRoleVariants(
    full: Color(0xFF4A5578),
    grey: Color(0xFF959391),
  ),
  0xFFC6C05E: LandmarkRoleVariants(
    full: Color(0xFFC6C05E),
    grey: Color(0xFFD0CECB),
  ),
  0xFFF2EC9A: LandmarkRoleVariants(
    full: Color(0xFFF2EC9A),
    grey: Color(0xFFE8E6E2),
  ),
  0xFF5E8578: LandmarkRoleVariants(
    full: Color(0xFF5E8578),
    grey: Color(0xFFADABA8),
  ),
  0xFFCBC2B2: LandmarkRoleVariants(
    full: Color(0xFFCBC2B2),
    grey: Color(0xFFD5D2CF),
  ),
  0xFFEAF4F7: LandmarkRoleVariants(
    full: Color(0xFFEAF4F7),
    grey: Color(0xFFEEEBE7),
  ),
  0xFF7A4A2E: LandmarkRoleVariants(
    full: Color(0xFF7A4A2E),
    grey: Color(0xFF93918F),
  ),
  0xFF22303A: LandmarkRoleVariants(
    full: Color(0xFF22303A),
    grey: Color(0xFF7A7877),
  ),
  0xFFF2A0BE: LandmarkRoleVariants(
    full: Color(0xFFF2A0BE),
    grey: Color(0xFFCDCAC7),
  ),
  0xFFDCD6C6: LandmarkRoleVariants(
    full: Color(0xFFDCD6C6),
    grey: Color(0xFFDFDDD9),
  ),
  0xFF9E2F2E: LandmarkRoleVariants(
    full: Color(0xFF9E2F2E),
    grey: Color(0xFF8B8A88),
  ),
  0xFFE8A24C: LandmarkRoleVariants(
    full: Color(0xFFE8A24C),
    grey: Color(0xFFC8C5C2),
  ),
  0xFFD2C4AC: LandmarkRoleVariants(
    full: Color(0xFFD2C4AC),
    grey: Color(0xFFD6D4D1),
  ),
  0xFFB0A187: LandmarkRoleVariants(
    full: Color(0xFFB0A187),
    grey: Color(0xFFC3C1BE),
  ),
  0xFF1E3325: LandmarkRoleVariants(
    full: Color(0xFF1E3325),
    grey: Color(0xFF7A7876),
  ),
  0xFFB0621A: LandmarkRoleVariants(
    full: Color(0xFFB0621A),
    grey: Color(0xFFA4A2A0),
  ),
  0xFF7FA898: LandmarkRoleVariants(
    full: Color(0xFF7FA898),
    grey: Color(0xFFC1BEBC),
  ),
  0xFF66201C: LandmarkRoleVariants(
    full: Color(0xFF66201C),
    grey: Color(0xFF7B7977),
  ),
  0xFFF0C8A8: LandmarkRoleVariants(
    full: Color(0xFFF0C8A8),
    grey: Color(0xFFDBD8D5),
  ),
  0xFFE4EAEE: LandmarkRoleVariants(
    full: Color(0xFFE4EAEE),
    grey: Color(0xFFE9E6E3),
  ),
  0xFF9FAEB8: LandmarkRoleVariants(
    full: Color(0xFF9FAEB8),
    grey: Color(0xFFC8C6C3),
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
  0xFF8A6A4A: LandmarkRoleVariants(
    full: Color(0xFF8A6A4A),
    grey: Color(0xFFA5A3A0),
  ),
  0xFFC9BFA8: LandmarkRoleVariants(
    full: Color(0xFFC9BFA8),
    grey: Color(0xFFD3D1CE),
  ),
  0xFF7FA84E: LandmarkRoleVariants(
    full: Color(0xFF7FA84E),
    grey: Color(0xFFBEBBB9),
  ),
  0xFF3E7A46: LandmarkRoleVariants(
    full: Color(0xFF3E7A46),
    grey: Color(0xFFA2A09D),
  ),
  0xFFF2EFE6: LandmarkRoleVariants(
    full: Color(0xFFF2EFE6),
    grey: Color(0xFFECE9E6),
  ),
  0xFFC4762B: LandmarkRoleVariants(
    full: Color(0xFFC4762B),
    grey: Color(0xFFB0AEAB),
  ),
  0xFFE5A72E: LandmarkRoleVariants(
    full: Color(0xFFE5A72E),
    grey: Color(0xFFC8C6C3),
  ),
  0xFFE07898: LandmarkRoleVariants(
    full: Color(0xFFE07898),
    grey: Color(0xFFB9B7B4),
  ),
  0xFF8A5A2B: LandmarkRoleVariants(
    full: Color(0xFF8A5A2B),
    grey: Color(0xFF9C9B98),
  ),
  0xFF7A4A22: LandmarkRoleVariants(
    full: Color(0xFF7A4A22),
    grey: Color(0xFF92918F),
  ),
  0xFF8E2A2C: LandmarkRoleVariants(
    full: Color(0xFF8E2A2C),
    grey: Color(0xFF868583),
  ),
  0xFFE8C558: LandmarkRoleVariants(
    full: Color(0xFFE8C558),
    grey: Color(0xFFD6D3D0),
  ),
  0xFFC9B79C: LandmarkRoleVariants(
    full: Color(0xFFC9B79C),
    grey: Color(0xFFD0CDCA),
  ),
  0xFFA8763E: LandmarkRoleVariants(
    full: Color(0xFFA8763E),
    grey: Color(0xFFADABA9),
  ),
  0xFF83592C: LandmarkRoleVariants(
    full: Color(0xFF83592C),
    grey: Color(0xFF9B9997),
  ),
  0xFFA79C89: LandmarkRoleVariants(
    full: Color(0xFFA79C89),
    grey: Color(0xFFC0BEBB),
  ),
  0xFFFBD2E1: LandmarkRoleVariants(
    full: Color(0xFFFBD2E1),
    grey: Color(0xFFE2E0DC),
  ),
  0xFF734C33: LandmarkRoleVariants(
    full: Color(0xFF734C33),
    grey: Color(0xFF93928F),
  ),
  0xFFD9A253: LandmarkRoleVariants(
    full: Color(0xFFD9A253),
    grey: Color(0xFFC6C4C1),
  ),
  0xFFEBC489: LandmarkRoleVariants(
    full: Color(0xFFEBC489),
    grey: Color(0xFFD8D5D2),
  ),
  0xFF332821: LandmarkRoleVariants(
    full: Color(0xFF332821),
    grey: Color(0xFF777674),
  ),
  0xFF94826B: LandmarkRoleVariants(
    full: Color(0xFF94826B),
    grey: Color(0xFFB2B0AD),
  ),
  0xFF932C2B: LandmarkRoleVariants(
    full: Color(0xFF932C2B),
    grey: Color(0xFF888785),
  ),
  0xFFDAD3C2: LandmarkRoleVariants(
    full: Color(0xFFDAD3C2),
    grey: Color(0xFFDEDBD8),
  ),
  0xFFF6C3D6: LandmarkRoleVariants(
    full: Color(0xFFF6C3D6),
    grey: Color(0xFFDCD9D6),
  ),
  0xFFF0E4D2: LandmarkRoleVariants(
    full: Color(0xFFF0E4D2),
    grey: Color(0xFFE7E4E1),
  ),
  0xFFFFF4E0: LandmarkRoleVariants(
    full: Color(0xFFFFF4E0),
    grey: Color(0xFFEFECE9),
  ),
  0xFF4E555D: LandmarkRoleVariants(
    full: Color(0xFF4E555D),
    grey: Color(0xFF949390),
  ),
  0xFFF2EAE0: LandmarkRoleVariants(
    full: Color(0xFFF2EAE0),
    grey: Color(0xFFEAE7E4),
  ),
  0xFFE8C46A: LandmarkRoleVariants(
    full: Color(0xFFE8C46A),
    grey: Color(0xFFD6D4D0),
  ),
  0xFFCFC0B0: LandmarkRoleVariants(
    full: Color(0xFFCFC0B0),
    grey: Color(0xFFD5D2CF),
  ),
  0xFFEDE4D2: LandmarkRoleVariants(
    full: Color(0xFFEDE4D2),
    grey: Color(0xFFE7E4E1),
  ),
  0xFF8E2E28: LandmarkRoleVariants(
    full: Color(0xFF8E2E28),
    grey: Color(0xFF888785),
  ),
  0xFF7A2D55: LandmarkRoleVariants(
    full: Color(0xFF7A2D55),
    grey: Color(0xFF878583),
  ),
  0xFF511638: LandmarkRoleVariants(
    full: Color(0xFF511638),
    grey: Color(0xFF737270),
  ),
  0xFFF7DA82: LandmarkRoleVariants(
    full: Color(0xFFF7DA82),
    grey: Color(0xFFE1DFDB),
  ),
  0xFFDCE4E8: LandmarkRoleVariants(
    full: Color(0xFFDCE4E8),
    grey: Color(0xFFE6E3E0),
  ),
  0xFF6B4E84: LandmarkRoleVariants(
    full: Color(0xFF6B4E84),
    grey: Color(0xFF979593),
  ),
  0xFFE8D6AE: LandmarkRoleVariants(
    full: Color(0xFFE8D6AE),
    grey: Color(0xFFE0DDDA),
  ),
  0xFFCDB78A: LandmarkRoleVariants(
    full: Color(0xFFCDB78A),
    grey: Color(0xFFCFCDCA),
  ),
  0xFF4A2A18: LandmarkRoleVariants(
    full: Color(0xFF4A2A18),
    grey: Color(0xFF7B7A78),
  ),
  0xFFCFC6B6: LandmarkRoleVariants(
    full: Color(0xFFCFC6B6),
    grey: Color(0xFFD7D5D1),
  ),
  0xFFDB6F5C: LandmarkRoleVariants(
    full: Color(0xFFDB6F5C),
    grey: Color(0xFFB2B0AD),
  ),
  0xFFD9DEE2: LandmarkRoleVariants(
    full: Color(0xFFD9DEE2),
    grey: Color(0xFFE3E0DD),
  ),
  0xFF948C7E: LandmarkRoleVariants(
    full: Color(0xFF948C7E),
    grey: Color(0xFFB7B5B2),
  ),
  0xFF3C4752: LandmarkRoleVariants(
    full: Color(0xFF3C4752),
    grey: Color(0xFF8B8987),
  ),
  0xFFE0D8C4: LandmarkRoleVariants(
    full: Color(0xFFE0D8C4),
    grey: Color(0xFFE0DEDA),
  ),
  0xFFE0A0A8: LandmarkRoleVariants(
    full: Color(0xFFE0A0A8),
    grey: Color(0xFFCAC7C4),
  ),
  0xFF9E5560: LandmarkRoleVariants(
    full: Color(0xFF9E5560),
    grey: Color(0xFF9F9D9B),
  ),
  0xFF26302E: LandmarkRoleVariants(
    full: Color(0xFF26302E),
    grey: Color(0xFF7A7877),
  ),
  0xFFD6C3A9: LandmarkRoleVariants(
    full: Color(0xFFD6C3A9),
    grey: Color(0xFFD6D4D1),
  ),
  0xFF383D42: LandmarkRoleVariants(
    full: Color(0xFF383D42),
    grey: Color(0xFF848381),
  ),
  0xFFE8D4AA: LandmarkRoleVariants(
    full: Color(0xFFE8D4AA),
    grey: Color(0xFFDFDCD9),
  ),
  0xFF4A4F55: LandmarkRoleVariants(
    full: Color(0xFF4A4F55),
    grey: Color(0xFF918F8D),
  ),
  0xFFFFE9C2: LandmarkRoleVariants(
    full: Color(0xFFFFE9C2),
    grey: Color(0xFFEAE7E4),
  ),
  0xFFC4620F: LandmarkRoleVariants(
    full: Color(0xFFC4620F),
    grey: Color(0xFFA6A4A2),
  ),
  0xFFE4543F: LandmarkRoleVariants(
    full: Color(0xFFE4543F),
    grey: Color(0xFFA6A4A2),
  ),
  0xFF9B2E31: LandmarkRoleVariants(
    full: Color(0xFF9B2E31),
    grey: Color(0xFF8B8987),
  ),
  0xFFB4C4C0: LandmarkRoleVariants(
    full: Color(0xFFB4C4C0),
    grey: Color(0xFFD4D1CE),
  ),
  0xFFE2705C: LandmarkRoleVariants(
    full: Color(0xFFE2705C),
    grey: Color(0xFFB3B1AF),
  ),
  0xFFC4BDB0: LandmarkRoleVariants(
    full: Color(0xFFC4BDB0),
    grey: Color(0xFFD2D0CD),
  ),
  0xFFEFEBE2: LandmarkRoleVariants(
    full: Color(0xFFEFEBE2),
    grey: Color(0xFFEAE7E4),
  ),
  0xFFE8CE93: LandmarkRoleVariants(
    full: Color(0xFFE8CE93),
    grey: Color(0xFFDCD9D6),
  ),
  0xFF256355: LandmarkRoleVariants(
    full: Color(0xFF256355),
    grey: Color(0xFF959391),
  ),
  0xFFEDE3D2: LandmarkRoleVariants(
    full: Color(0xFFEDE3D2),
    grey: Color(0xFFE6E4E0),
  ),
  0xFFCBBCA4: LandmarkRoleVariants(
    full: Color(0xFFCBBCA4),
    grey: Color(0xFFD2D0CC),
  ),
  0xFF7B5433: LandmarkRoleVariants(
    full: Color(0xFF7B5433),
    grey: Color(0xFF989694),
  ),
  0xFF5C3C22: LandmarkRoleVariants(
    full: Color(0xFF5C3C22),
    grey: Color(0xFF888684),
  ),
  0xFF9E2E2E: LandmarkRoleVariants(
    full: Color(0xFF9E2E2E),
    grey: Color(0xFF8B8987),
  ),
  0xFF6E4529: LandmarkRoleVariants(
    full: Color(0xFF6E4529),
    grey: Color(0xFF8F8D8B),
  ),
  0xFF8E2320: LandmarkRoleVariants(
    full: Color(0xFF8E2320),
    grey: Color(0xFF82817F),
  ),
  0xFF3E7A50: LandmarkRoleVariants(
    full: Color(0xFF3E7A50),
    grey: Color(0xFFA2A09E),
  ),
  0xFFA87C31: LandmarkRoleVariants(
    full: Color(0xFFA87C31),
    grey: Color(0xFFAFADAB),
  ),
  0xFFB8443A: LandmarkRoleVariants(
    full: Color(0xFFB8443A),
    grey: Color(0xFF999895),
  ),
  0xFF5C202C: LandmarkRoleVariants(
    full: Color(0xFF5C202C),
    grey: Color(0xFF7A7877),
  ),
  0xFF5A2340: LandmarkRoleVariants(
    full: Color(0xFF5A2340),
    grey: Color(0xFF7C7B79),
  ),
  0xFF3A1428: LandmarkRoleVariants(
    full: Color(0xFF3A1428),
    grey: Color(0xFF6D6C6A),
  ),
  0xFFF2E7D2: LandmarkRoleVariants(
    full: Color(0xFFF2E7D2),
    grey: Color(0xFFE9E6E2),
  ),
  0xFF8FC6D4: LandmarkRoleVariants(
    full: Color(0xFF8FC6D4),
    grey: Color(0xFFD1CECB),
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
  0xFFF2A03F: LandmarkRoleVariants(
    full: Color(0xFFF2A03F),
    grey: Color(0xFFC8C5C2),
  ),
  0xFFC96F22: LandmarkRoleVariants(
    full: Color(0xFFC96F22),
    grey: Color(0xFFADABA9),
  ),
  0xFF7C5A3A: LandmarkRoleVariants(
    full: Color(0xFF7C5A3A),
    grey: Color(0xFF9B9997),
  ),
  0xFFE4DCCE: LandmarkRoleVariants(
    full: Color(0xFFE4DCCE),
    grey: Color(0xFFE3E0DD),
  ),
  0xFF5B3572: LandmarkRoleVariants(
    full: Color(0xFF5B3572),
    grey: Color(0xFF888684),
  ),
  0xFF7A4E96: LandmarkRoleVariants(
    full: Color(0xFF7A4E96),
    grey: Color(0xFF9A9896),
  ),
  0xFF8E2E2D: LandmarkRoleVariants(
    full: Color(0xFF8E2E2D),
    grey: Color(0xFF888785),
  ),
  0xFF4A3D72: LandmarkRoleVariants(
    full: Color(0xFF4A3D72),
    grey: Color(0xFF898886),
  ),
  0xFF9A6B4A: LandmarkRoleVariants(
    full: Color(0xFF9A6B4A),
    grey: Color(0xFFA7A5A3),
  ),
  0xFFF6F1E4: LandmarkRoleVariants(
    full: Color(0xFFF6F1E4),
    grey: Color(0xFFEDEAE7),
  ),
  0xFFDCD3C0: LandmarkRoleVariants(
    full: Color(0xFFDCD3C0),
    grey: Color(0xFFDEDBD8),
  ),
  0xFFBFCBD3: LandmarkRoleVariants(
    full: Color(0xFFBFCBD3),
    grey: Color(0xFFD8D6D3),
  ),
  0xFFDCE6EC: LandmarkRoleVariants(
    full: Color(0xFFDCE6EC),
    grey: Color(0xFFE7E4E1),
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
  0xFFE8EDEA: LandmarkRoleVariants(
    full: Color(0xFFE8EDEA),
    grey: Color(0xFFEBE8E4),
  ),
  0xFFA89C82: LandmarkRoleVariants(
    full: Color(0xFFA89C82),
    grey: Color(0xFFC0BEBB),
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
  0xFFD9D3C0: LandmarkRoleVariants(
    full: Color(0xFFD9D3C0),
    grey: Color(0xFFDEDBD8),
  ),
  0xFFF5F2E6: LandmarkRoleVariants(
    full: Color(0xFFF5F2E6),
    grey: Color(0xFFEEEBE7),
  ),
  0xFF2C5A33: LandmarkRoleVariants(
    full: Color(0xFF2C5A33),
    grey: Color(0xFF908E8C),
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
  0xFFD8C9AC: LandmarkRoleVariants(
    full: Color(0xFFD8C9AC),
    grey: Color(0xFFD9D6D3),
  ),
  0xFFC4757F: LandmarkRoleVariants(
    full: Color(0xFFC4757F),
    grey: Color(0xFFB3B1AE),
  ),
  0xFFA89882: LandmarkRoleVariants(
    full: Color(0xFFA89882),
    grey: Color(0xFFBEBCB9),
  ),
  0xFFCDBDA0: LandmarkRoleVariants(
    full: Color(0xFFCDBDA0),
    grey: Color(0xFFD3D0CD),
  ),
  0xFFA08560: LandmarkRoleVariants(
    full: Color(0xFFA08560),
    grey: Color(0xFFB4B2AF),
  ),
  0xFFC4A882: LandmarkRoleVariants(
    full: Color(0xFFC4A882),
    grey: Color(0xFFC8C6C3),
  ),
  0xFFD6C6AC: LandmarkRoleVariants(
    full: Color(0xFFD6C6AC),
    grey: Color(0xFFD7D5D2),
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
  0xFFB09A7C: LandmarkRoleVariants(
    full: Color(0xFFB09A7C),
    grey: Color(0xFFC0BEBB),
  ),
  0xFFE6C39A: LandmarkRoleVariants(
    full: Color(0xFFE6C39A),
    grey: Color(0xFFD7D5D2),
  ),
  0xFFE07A63: LandmarkRoleVariants(
    full: Color(0xFFE07A63),
    grey: Color(0xFFB8B5B3),
  ),
  0xFFE4DACA: LandmarkRoleVariants(
    full: Color(0xFFE4DACA),
    grey: Color(0xFFE2DFDC),
  ),
  0xFFC4B49C: LandmarkRoleVariants(
    full: Color(0xFFC4B49C),
    grey: Color(0xFFCECBC8),
  ),
  0xFFEFE8DA: LandmarkRoleVariants(
    full: Color(0xFFEFE8DA),
    grey: Color(0xFFE9E6E3),
  ),
  0xFFD9AE93: LandmarkRoleVariants(
    full: Color(0xFFD9AE93),
    grey: Color(0xFFCECBC8),
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
  0xFFBFA274: LandmarkRoleVariants(
    full: Color(0xFFBFA274),
    grey: Color(0xFFC5C2BF),
  ),
  0xFFCFE4EC: LandmarkRoleVariants(
    full: Color(0xFFCFE4EC),
    grey: Color(0xFFE5E2DE),
  ),
  0xFFD6453C: LandmarkRoleVariants(
    full: Color(0xFFD6453C),
    grey: Color(0xFF9E9C9A),
  ),
  0xFFAE3129: LandmarkRoleVariants(
    full: Color(0xFFAE3129),
    grey: Color(0xFF8E8D8B),
  ),
  0xFFB6D4DF: LandmarkRoleVariants(
    full: Color(0xFFB6D4DF),
    grey: Color(0xFFDBD9D5),
  ),
  0xFF972C2C: LandmarkRoleVariants(
    full: Color(0xFF972C2C),
    grey: Color(0xFF898785),
  ),
  0xFFDE6B5C: LandmarkRoleVariants(
    full: Color(0xFFDE6B5C),
    grey: Color(0xFFB1AFAC),
  ),
  0xFFF08A28: LandmarkRoleVariants(
    full: Color(0xFFF08A28),
    grey: Color(0xFFBEBBB9),
  ),
  0xFFFBE7A8: LandmarkRoleVariants(
    full: Color(0xFFFBE7A8),
    grey: Color(0xFFE8E5E2),
  ),
  0xFFEDF1EE: LandmarkRoleVariants(
    full: Color(0xFFEDF1EE),
    grey: Color(0xFFEDEAE6),
  ),
  0xFF3A3F46: LandmarkRoleVariants(
    full: Color(0xFF3A3F46),
    grey: Color(0xFF868482),
  ),
  0xFF2C3036: LandmarkRoleVariants(
    full: Color(0xFF2C3036),
    grey: Color(0xFF7B7A78),
  ),
  0xFFF3EEE2: LandmarkRoleVariants(
    full: Color(0xFFF3EEE2),
    grey: Color(0xFFECE9E6),
  ),
  0xFFF0CE7E: LandmarkRoleVariants(
    full: Color(0xFFF0CE7E),
    grey: Color(0xFFDCD9D6),
  ),
  0xFFC6DC94: LandmarkRoleVariants(
    full: Color(0xFFC6DC94),
    grey: Color(0xFFDDDBD7),
  ),
  0xFF6E9440: LandmarkRoleVariants(
    full: Color(0xFF6E9440),
    grey: Color(0xFFB3B1AE),
  ),
  0xFFF7EEDC: LandmarkRoleVariants(
    full: Color(0xFFF7EEDC),
    grey: Color(0xFFECE9E6),
  ),
  0xFFDDE9F0: LandmarkRoleVariants(
    full: Color(0xFFDDE9F0),
    grey: Color(0xFFE8E5E2),
  ),
  0xFFC3D8E4: LandmarkRoleVariants(
    full: Color(0xFFC3D8E4),
    grey: Color(0xFFDEDCD8),
  ),
  0xFFEDF1F4: LandmarkRoleVariants(
    full: Color(0xFFEDF1F4),
    grey: Color(0xFFEDEAE7),
  ),
  0xFF8F8A7E: LandmarkRoleVariants(
    full: Color(0xFF8F8A7E),
    grey: Color(0xFFB5B3B1),
  ),
  0xFFB9821B: LandmarkRoleVariants(
    full: Color(0xFFB9821B),
    grey: Color(0xFFB3B1AE),
  ),
  0xFF8F2C2B: LandmarkRoleVariants(
    full: Color(0xFF8F2C2B),
    grey: Color(0xFF888684),
  ),
  0xFFB45272: LandmarkRoleVariants(
    full: Color(0xFFB45272),
    grey: Color(0xFFA2A09D),
  ),
  0xFFD8A24A: LandmarkRoleVariants(
    full: Color(0xFFD8A24A),
    grey: Color(0xFFC6C3C1),
  ),
  0xFFF3E3BA: LandmarkRoleVariants(
    full: Color(0xFFF3E3BA),
    grey: Color(0xFFE6E4E0),
  ),
  0xFF5A3A26: LandmarkRoleVariants(
    full: Color(0xFF5A3A26),
    grey: Color(0xFF868583),
  ),
  0xFFF0C79A: LandmarkRoleVariants(
    full: Color(0xFFF0C79A),
    grey: Color(0xFFDAD8D4),
  ),
  0xFF2E4A38: LandmarkRoleVariants(
    full: Color(0xFF2E4A38),
    grey: Color(0xFF898785),
  ),
  0xFFE08A2B: LandmarkRoleVariants(
    full: Color(0xFFE08A2B),
    grey: Color(0xFFBCBAB7),
  ),
  0xFFF0B25E: LandmarkRoleVariants(
    full: Color(0xFFF0B25E),
    grey: Color(0xFFD0CDCA),
  ),
  0xFFF6CE84: LandmarkRoleVariants(
    full: Color(0xFFF6CE84),
    grey: Color(0xFFDDDAD7),
  ),
  0xFFDFA94F: LandmarkRoleVariants(
    full: Color(0xFFDFA94F),
    grey: Color(0xFFCAC7C4),
  ),
  0xFFF2CE4B: LandmarkRoleVariants(
    full: Color(0xFFF2CE4B),
    grey: Color(0xFFDAD7D4),
  ),
  0xFF2B3557: LandmarkRoleVariants(
    full: Color(0xFF2B3557),
    grey: Color(0xFF7F7E7C),
  ),
  0xFF233049: LandmarkRoleVariants(
    full: Color(0xFF233049),
    grey: Color(0xFF7B7978),
  ),
  0xFF42356B: LandmarkRoleVariants(
    full: Color(0xFF42356B),
    grey: Color(0xFF848280),
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
  0xFFD9C0A0: LandmarkRoleVariants(
    full: Color(0xFFD9C0A0),
    grey: Color(0xFFD5D3CF),
  ),
  0xFFB99878: LandmarkRoleVariants(
    full: Color(0xFFB99878),
    grey: Color(0xFFC0BEBB),
  ),
  0xFF8A5A38: LandmarkRoleVariants(
    full: Color(0xFF8A5A38),
    grey: Color(0xFF9D9B99),
  ),
  0xFF2A5B3A: LandmarkRoleVariants(
    full: Color(0xFF2A5B3A),
    grey: Color(0xFF908F8D),
  ),
  0xFF8A6438: LandmarkRoleVariants(
    full: Color(0xFF8A6438),
    grey: Color(0xFFA1A09D),
  ),
  0xFF5E4222: LandmarkRoleVariants(
    full: Color(0xFF5E4222),
    grey: Color(0xFF8B8987),
  ),
  0xFF2E3A38: LandmarkRoleVariants(
    full: Color(0xFF2E3A38),
    grey: Color(0xFF817F7D),
  ),
  0xFF4A5A55: LandmarkRoleVariants(
    full: Color(0xFF4A5A55),
    grey: Color(0xFF969492),
  ),
  0xFFB4BFB8: LandmarkRoleVariants(
    full: Color(0xFFB4BFB8),
    grey: Color(0xFFD1CFCC),
  ),
  0xFFC79A4B: LandmarkRoleVariants(
    full: Color(0xFFC79A4B),
    grey: Color(0xFFC1BEBB),
  ),
  0xFFC08A22: LandmarkRoleVariants(
    full: Color(0xFFC08A22),
    grey: Color(0xFFB8B5B3),
  ),
  0xFF9CC0B0: LandmarkRoleVariants(
    full: Color(0xFF9CC0B0),
    grey: Color(0xFFCFCCC9),
  ),
};
