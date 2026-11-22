import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/services/onboarding_service.dart';
import '../../../l10n/app_localizations.dart';

class PermissionsPage extends ConsumerStatefulWidget {
  const PermissionsPage({super.key});

  @override
  ConsumerState<PermissionsPage> createState() => _PermissionsPageState();
}

class _PermissionsPageState extends ConsumerState<PermissionsPage>
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
      context.go(RouteConstants.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.xl,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.security_rounded,
                      size: 80,
                      color: AppColors.teal,
                    ),
                    AppSpacing.verticalGapLG,
                    Text(
                      l10n.permissionsTitle,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.deepCharcoal,
                      ),
                    ),
                    AppSpacing.verticalGapSM,
                    Text(
                      l10n.permissionsSubtitle,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: AppColors.slateGrey,
                      ),
                    ),
                    AppSpacing.verticalGapXXXL,
                    _PermissionTile(
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
                    _PermissionTile(
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
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: SizedBox(
                width: double.infinity,
                height: AppSpacing.jm,
                child: ElevatedButton(
                  onPressed: _finish,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.teal,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.md),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    l10n.continueBtn,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PermissionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final bool isGranted;
  final ValueChanged<bool> onToggle;

  const _PermissionTile({
    required this.icon,
    required this.title,
    required this.description,
    required this.isGranted,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.offWhite,
        borderRadius: BorderRadius.circular(AppSpacing.sl),
        border: Border.all(
          color: isGranted ? AppColors.teal : Colors.transparent,
          width: 2,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: isGranted
                  ? AppColors.teal.withValues(alpha: 0.1)
                  : AppColors.slateGrey.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: isGranted ? AppColors.teal : AppColors.slateGrey,
            ),
          ),
          AppSpacing.horizontalGapMD,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: AppColors.deepCharcoal,
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.slateGrey.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
          AppSpacing.horizontalGapXS,
          Column(
            children: [
              Switch.adaptive(
                value: isGranted,
                onChanged: onToggle,
                activeThumbColor: AppColors.teal,
              ),
              Text(
                isGranted ? l10n.granted : l10n.denied,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: isGranted ? AppColors.teal : Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
