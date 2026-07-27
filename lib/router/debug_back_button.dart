import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../domain/auth/provider/auth_controller.dart';
import 'app_router.dart';

/// TEMPORARY testing aid — a back button pinned to the top-left that steps back
/// through the first-run flow (onboarding → language, home → onboarding).
///
/// From home it resets the onboarding flag first so the flow replays instead of
/// being bounced straight back by the completion guard. Wired as a `ShellRoute`
/// overlay around the flow routes. Remove before shipping.
class DebugBackButton extends ConsumerWidget {
  const DebugBackButton({
    super.key,
    required this.location,
    required this.child,
  });

  final String location;
  final Widget child;

  static const Map<String, String> _previousOf = <String, String>{
    Routes.login: Routes.language,
    Routes.onboarding: Routes.login,
    Routes.home: Routes.login,
  };

  Future<void> _onBack(
    BuildContext context,
    WidgetRef ref,
    String target,
  ) async {
    // Stepping back past the auth gate means signing out so the flow replays
    // (spec §10 — the router redirect otherwise bounces authenticated users
    // straight back to home/onboarding).
    if (location == Routes.home || location == Routes.onboarding) {
      await ref.read(authControllerProvider.notifier).signOut();
    }
    if (context.mounted) context.go(target);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String? target = _previousOf[location];

    return Stack(
      children: <Widget>[
        child,
        if (target != null)
          Positioned(
            top: 0,
            left: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Material(
                  color: Colors.black45,
                  shape: const CircleBorder(),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    tooltip: 'Debug: back',
                    onPressed: () => _onBack(context, ref, target),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
