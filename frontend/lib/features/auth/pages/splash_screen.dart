import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gate_authentication_system/l10n/app_localizations.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/constants/app_constants.dart';
import '../providers/connectivity_provider.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectivity = ref.watch(backendConnectivityProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.deepCharcoal,
      body: Stack(
        children: [
          const _SplashBranding(),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.hg),
              child: _StatusIndicator(
                status: connectivity,
                l10n: l10n,
                ref: ref,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SplashBranding extends StatelessWidget {
  const _SplashBranding();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Hero(
              tag: 'app_logo',
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  AppConstants.appName,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 72,
                    fontWeight: FontWeight.w900,
                    color: AppColors.teal,
                    letterSpacing: 12,
                    height: 1.1,
                    shadows: [
                      Shadow(
                        color: AppColors.teal.withValues(alpha: 0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            AppSpacing.verticalGapSM,
            const Text(
              'SECURE ACCESS GATEWAY',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.offWhite60,
                letterSpacing: 6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusIndicator extends StatelessWidget {
  final BackendStatus status;
  final AppLocalizations l10n;
  final WidgetRef ref;

  const _StatusIndicator({
    required this.status,
    required this.l10n,
    required this.ref,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        switchInCurve: Curves.easeOut,
        switchOutCurve: Curves.easeOut,
        child: status == BackendStatus.offline
            ? _OfflineIndicator(l10n: l10n, ref: ref)
            : _LoadingIndicator(
                message: status == BackendStatus.online
                    ? l10n.syncInProgress
                    : l10n.establishingConnection,
              ),
      ),
    );
  }
}

class _LoadingIndicator extends StatelessWidget {
  final String message;

  const _LoadingIndicator({required this.message});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(
          width: AppSpacing.xl,
          height: AppSpacing.xl,
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.teal),
            semanticsLabel: 'Loading',
          ),
        ),
        AppSpacing.verticalGapLG,
        Text(
          message.toUpperCase(),
          style: const TextStyle(
            color: AppColors.offWhite60,
            fontSize: 10,
            fontWeight: FontWeight.w700,
            letterSpacing: 2.0,
          ),
        ),
      ],
    );
  }
}

class _OfflineIndicator extends StatelessWidget {
  final AppLocalizations l10n;
  final WidgetRef ref;

  const _OfflineIndicator({required this.l10n, required this.ref});

  @override
  Widget build(BuildContext context) {
    final errorColor = Theme.of(context).colorScheme.error;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IntrinsicWidth(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.sm,
                ),
                decoration: BoxDecoration(
                  color: errorColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: errorColor.withValues(alpha: 0.3)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, color: errorColor, size: 16),
                    AppSpacing.horizontalGapSM,
                    Text(
                      l10n.serverUnreachable.toUpperCase(),
                      style: TextStyle(
                        color: errorColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        letterSpacing: 1.1,
                      ),
                    ),
                  ],
                ),
              ),
              AppSpacing.verticalGapSM,
              ElevatedButton.icon(
                onPressed: () => ref
                    .read(backendConnectivityProvider.notifier)
                    .checkConnectivity(),
                icon: const Icon(Icons.refresh, size: 16),
                label: Text(l10n.retryConnection.toUpperCase()),
                style: ElevatedButton.styleFrom(
                  backgroundColor: errorColor,
                  foregroundColor: Theme.of(context).colorScheme.onError,
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                  minimumSize: Size.zero,
                  textStyle: Theme.of(context).textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.1,
                    fontSize: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 0,
                ),
              ),
            ],
          ),
        ),
        AppSpacing.verticalGapMD,
        Text(
          l10n.verifyInternet,
          style: TextStyle(color: Theme.of(context).hintColor, fontSize: 11),
        ),
      ],
    );
  }
}
