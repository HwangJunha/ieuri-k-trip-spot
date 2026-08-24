import 'package:flutter/material.dart';

/// "인증을 마쳐야 이메일이 바뀐다"는 대기 안내(SPEC-0011 R7, 디자인 §4).
///
/// **이 배너가 없으면 사용자가 실패로 오해한다.** 코드를 보냈는데 프로필의 이메일이
/// 그대로라, 무엇이 잘못됐다고 읽기 쉽다. 오류가 아니라 대기 상태임을 색으로도
/// 구분하려고 error가 아닌 tertiary 계열을 쓴다(디자인의 amber에 대응하는
/// 테마 슬롯 — 색값을 직접 박지 않는다, DESIGN.md §12).
class EmailChangePendingBanner extends StatelessWidget {
  const EmailChangePendingBanner({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.tertiaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(
            Icons.info_outline,
            size: 20,
            color: theme.colorScheme.onTertiaryContainer,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onTertiaryContainer,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
