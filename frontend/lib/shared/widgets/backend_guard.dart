import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/auth/providers/connectivity_provider.dart';
import '../../core/utils/toast_utils.dart';

/// A utility widget that guards children against backend unreachability.
/// If the backend is offline, it can disable the child and show an error message.
class BackendGuard extends ConsumerWidget {
  final Widget child;
  final String? errorMessage;
  final bool disableOnly;

  const BackendGuard({
    super.key,
    required this.child,
    this.errorMessage = 'Action blocked: Server unreachable',
    this.disableOnly = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectivity = ref.watch(backendConnectivityProvider);
    final isOffline = connectivity == BackendStatus.offline;

    if (!isOffline) return child;

    return GestureDetector(
      onTapDown: (_) {
        if (errorMessage != null) {
          ToastUtils.showError(context, errorMessage!);
        }
      },
      child: AbsorbPointer(
        absorbing: true,
        child: Opacity(opacity: 0.5, child: child),
      ),
    );
  }
}
