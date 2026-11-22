import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/services/onboarding_service.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../l10n/app_localizations.dart';

class PermissionsModal extends ConsumerStatefulWidget {
  const PermissionsModal({super.key});

  static Future<void> show(BuildContext context) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: AppColors.deepCharcoal.withValues(alpha: 0.8),
      builder: (context) => const PermissionsModal(),
    );
  }

  @override
  ConsumerState<PermissionsModal> createState() => _PermissionsModalState();
}

class _PermissionsModalState extends ConsumerState<PermissionsModal>
    with WidgetsBindingObserver {
  bool _notificationsGranted = false;
  bool _locationGranted = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkPermissions();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkPermissions();
    }
  }

  Future<void> _checkPermissions() async {
    final notificationStatus = await Permission.notification.status;
    final locationStatus = await Permission.locationWhenInUse.status;

    if (mounted) {
      setState(() {
        _notificationsGranted = notificationStatus.isGranted;
        _locationGranted = locationStatus.isGranted;
      });
    }
  }

  Future<void> _requestNotificationPermission() async {
    final status = await Permission.notification.request();
    if (mounted) {
      setState(() => _notificationsGranted = status.isGranted);
    }
  }

  Future<void> _requestLocationPermission() async {
    final status = await Permission.locationWhenInUse.request();
    if (mounted) {
      setState(() => _locationGranted = status.isGranted);
    }
  }

  Future<void> _finish() async {
    await ref.read(onboardingServiceProvider).markPermissionsCompleted();
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.sl),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(AppSpacing.xl),
              boxShadow: [
                BoxShadow(
                  color: AppColors.deepCharcoal.withValues(alpha: 0.2),
                  blurRadius: 40,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.security_rounded,
                    size: AppSpacing.xxl,
                    color: colorScheme.primary,
                  ),
                ),
                AppSpacing.verticalGapSL,
                Text(
                  l10n.permissionsTitle,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: colorScheme.onSurface,
                    letterSpacing: 0.5,
                  ),
                ),
                AppSpacing.verticalGapSM,
                Text(
                  l10n.permissionsSubtitle,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.7),
                    height: 1.4,
                  ),
                ),
                AppSpacing.verticalGapXL,
                _PermissionItem(
                  icon: Icons.notifications_active_rounded,
                  title: l10n.notifications,
                  description: l10n.notificationsDesc,
                  isGranted: _notificationsGranted,
                  onToggle: (val) {
                    if (val && !_notificationsGranted) {
                      _requestNotificationPermission();
                    } else if (!val && _notificationsGranted) {
                      openAppSettings();
                    }
                  },
                ),
                AppSpacing.verticalGapMD,
                _PermissionItem(
                  icon: Icons.location_on_rounded,
                  title: l10n.location,
                  description: l10n.locationDesc,
                  isGranted: _locationGranted,
                  onToggle: (val) {
                    if (val && !_locationGranted) {
                      _requestLocationPermission();
                    } else if (!val && _locationGranted) {
                      openAppSettings();
                    }
                  },
                ),
                AppSpacing.verticalGapXL,
                SizedBox(
                  width: double.infinity,
                  height: AppSpacing.jm,
                  child: ElevatedButton(
                    onPressed: _finish,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppSpacing.md),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      l10n.continueBtn.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: TextButton(
              onPressed: _finish,
              style: TextButton.styleFrom(
                foregroundColor: colorScheme.onSurface.withValues(alpha: 0.5),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.xs,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.sm),
                ),
              ),
              child: Text(
                l10n.skip.toUpperCase(),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PermissionItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final bool isGranted;
  final ValueChanged<bool> onToggle;

  const _PermissionItem({
    required this.icon,
    required this.title,
    required this.description,
    required this.isGranted,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(AppSpacing.sl),
        border: Border.all(
          color: isGranted
              ? colorScheme.primary.withValues(alpha: 0.5)
              : Colors.transparent,
          width: 2,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: isGranted
                ? colorScheme.primary
                : colorScheme.onSurface.withValues(alpha: 0.3),
            size: 28,
          ),
          AppSpacing.horizontalGapMD,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title.toUpperCase(),
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 14,
                    color: colorScheme.onSurface,
                    letterSpacing: 1,
                  ),
                ),
                AppSpacing.verticalGapXXS,
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 11,
                    color: colorScheme.onSurface.withValues(alpha: 0.5),
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
          AppSpacing.horizontalGapXS,
          Switch.adaptive(
            value: isGranted,
            onChanged: onToggle,
            activeTrackColor: colorScheme.primary,
            inactiveTrackColor: colorScheme.onSurface.withValues(alpha: 0.1),
          ),
        ],
      ),
    );
  }
}
