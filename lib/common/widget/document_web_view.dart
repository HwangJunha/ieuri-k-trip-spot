import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../l10n/gen/app_localizations.dart';

/// 약관·정책 전문을 앱 안에서 띄우는 웹뷰.
///
/// **왜 웹뷰인가.** 약관은 앱 배포 주기와 무관하게 개정되고 개정본이 즉시 효력을
/// 갖는다. 본문을 번들에 넣으면 심사를 통과한 구버전 앱이 낡은 약관을 계속 보여
/// 주게 된다. 게시된 문서를 그대로 여는 편이 항상 최신이다.
///
/// **왜 외부 브라우저가 아닌가.** 가입 도중 약관을 보려고 앱을 나갔다 오면
/// 입력하던 폼이 날아갈 수 있다. 심사자도 같은 경로를 밟으므로, 가입 흐름은
/// 앱 안에서 끝나야 한다.
///
/// 로딩·실패를 모두 다룬다 — 통신이 끊긴 상태에서 흰 화면만 남으면 사용자는
/// 약관이 없는 앱으로 읽는다.
class DocumentWebView extends StatefulWidget {
  const DocumentWebView({super.key, required this.title, required this.url});

  final String title;
  final Uri url;

  @override
  State<DocumentWebView> createState() => _DocumentWebViewState();
}

class _DocumentWebViewState extends State<DocumentWebView> {
  late final WebViewController _controller;

  /// 첫 로드가 끝났는가. 끝나기 전에는 스피너를 덮는다.
  bool _loading = true;

  /// 로드가 실패했는가(오프라인·404 등).
  bool _failed = false;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (_) {
            if (mounted) setState(() => _loading = false);
          },
          // **본문 로드 실패만 잡는다.** 페이지 안의 이미지 하나가 404여도
          // `onWebResourceError`가 불리는데, 그걸로 전체를 오류 처리하면 멀쩡한
          // 약관이 오류 화면에 가린다.
          onWebResourceError: (WebResourceError error) {
            if (!mounted || error.isForMainFrame != true) return;
            setState(() {
              _loading = false;
              _failed = true;
            });
          },
          // 문서 안의 바깥 링크는 기본 브라우저로 보낸다 — 약관 화면이 웹
          // 브라우저로 변해 사용자가 돌아오지 못하는 것을 막는다.
          onNavigationRequest: (NavigationRequest request) {
            if (request.url == widget.url.toString()) {
              return NavigationDecision.navigate;
            }
            _openExternally(Uri.parse(request.url));
            return NavigationDecision.prevent;
          },
        ),
      )
      ..loadRequest(widget.url);
  }

  /// 실패했을 때 같은 주소를 다시 받는다.
  void _reload() {
    setState(() {
      _loading = true;
      _failed = false;
    });
    _controller.loadRequest(widget.url);
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    return Scaffold(
      // **외부 브라우저 버튼을 두지 않는다**(사용자 결정 2026-08-24). 약관은
      // 여기서 다 읽히므로 밖으로 내보낼 이유가 없고, 아이콘 하나가 상단을
      // 어지럽힌다. 문서 안의 바깥 링크는 아래 내비게이션 델리게이트가 여전히
      // 브라우저로 넘긴다.
      appBar: AppBar(title: Text(widget.title)),
      body: SafeArea(
        child: _failed
            ? _LoadFailed(
                message: l10n.termsDocumentLoadFailed,
                retryLabel: l10n.termsRetry,
                onRetry: _reload,
              )
            : Stack(
                children: <Widget>[
                  WebViewWidget(controller: _controller),
                  if (_loading)
                    const Center(child: CircularProgressIndicator()),
                ],
              ),
      ),
    );
  }
}

/// 외부 브라우저로 연다. 실패해도 화면을 막지 않는다 — 약관 자체는 이미 앱
/// 안에서 볼 수 있으므로 이 경로는 부가 수단이다.
void _openExternally(Uri url) {
  launchUrl(url, mode: LaunchMode.externalApplication).ignore();
}

class _LoadFailed extends StatelessWidget {
  const _LoadFailed({
    required this.message,
    required this.retryLabel,
    required this.onRetry,
  });

  final String message;
  final String retryLabel;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.cloud_off_outlined,
              size: 56,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            FilledButton(onPressed: onRetry, child: Text(retryLabel)),
          ],
        ),
      ),
    );
  }
}
