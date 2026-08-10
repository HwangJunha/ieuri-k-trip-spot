import 'package:flutter/material.dart';

import '../../../l10n/gen/app_localizations.dart';

/// 지도 상단에 얹는 얇은 안내 배너(디자인 §5·§6).
///
/// **지도를 막지 않는다.** 두 안내(잘림·혼잡도 실패) 모두 "지금 보이는 것은 유효하되
/// 일부가 빠졌다"는 뜻이라, 전면 오류 화면으로 덮으면 사실과 다르다. 마커도 지도
/// 조작도 그대로 살아 있어야 한다(R23·R29).
///
/// 두 안내가 모양이 같아 한 위젯을 공유한다. `error` 계열 색을 쓰지 않는 것도 같은
/// 이유다 — 빨간 배너는 "실패했으니 다시 하라"로 읽히는데, 여기서 사용자가 할 일은
/// 확대하거나(잘림) 기다리는 것(실패)뿐이다.
class MapNoticeBanner extends StatelessWidget {
  const MapNoticeBanner({
    required this.icon,
    required this.message,
    this.onDismiss,
    super.key,
  });

  final IconData icon;
  final String message;

  /// 닫기 콜백. null이면 닫기 버튼을 두지 않는다.
  final VoidCallback? onDismiss;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final VoidCallback? dismiss = onDismiss;

    return Material(
      color: theme.colorScheme.surfaceContainerHigh,
      elevation: 2,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: EdgeInsets.fromLTRB(12, 10, dismiss == null ? 12 : 4, 10),
        child: Row(
          children: <Widget>[
            Icon(icon, size: 18, color: theme.colorScheme.onSurfaceVariant),
            const SizedBox(width: 8),
            Expanded(child: Text(message, style: theme.textTheme.bodySmall)),
            if (dismiss != null)
              IconButton(
                onPressed: dismiss,
                icon: const Icon(Icons.close),
                iconSize: 18,
                visualDensity: VisualDensity.compact,
                tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
              ),
          ],
        ),
      ),
    );
  }
}

/// 결과가 상한에 걸려 일부만 보인다는 안내(R23).
///
/// 마커를 지우거나 지도를 막지 않는다 — **보이는 것은 유효한 결과다**(설계 §4.3).
/// 확대하면 전부 볼 수 있다는 것만 알린다.
class TruncatedNoticeBanner extends StatelessWidget {
  const TruncatedNoticeBanner({required this.onDismiss, super.key});

  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) => MapNoticeBanner(
    icon: Icons.zoom_in,
    message: AppLocalizations.of(context).mapTruncatedNotice,
    onDismiss: onDismiss,
  );
}

/// 혼잡도 레이어만 쓸 수 없다는 안내(R29).
///
/// **닫기를 두지 않는다.** 잘림과 달리 이건 사용자가 조작으로 해소할 수 없는 상태라,
/// 닫아 버리면 왜 폴리곤이 없는지 알 방법이 사라진다. 서버가 이것을 GraphQL 오류가
/// 아니라 `degraded` 표식으로 내려주는 이유가 여기 있다(spec §7.6) — 한 레이어만
/// 없는 상태이며 지도는 정상 사용 가능하다.
class CongestionDegradedNotice extends StatelessWidget {
  const CongestionDegradedNotice({super.key});

  @override
  Widget build(BuildContext context) => MapNoticeBanner(
    icon: Icons.cloud_off,
    message: AppLocalizations.of(context).mapCongestionUnavailable,
  );
}
