import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';
import '../../auth/repositories/auth_repository.dart';
import '../../../core/theme/app_spacing.dart';
import '../widgets/settings_section_header.dart';
import '../widgets/settings_navigation_tile.dart';
import '../widgets/settings_action_tile.dart';
import '../widgets/account_section.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final user = ref.watch(authStateProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          const SettingsSectionHeader(title: 'Preferences'),
          const SettingsNavigationTile(
            icon: Icons.palette_outlined,
            title: 'Theme',
            route: RouteConstants.settingsTheme,
          ),
          const SettingsNavigationTile(
            icon: Icons.volume_up_outlined,
            title: 'Sounds',
            route: RouteConstants.settingsSounds,
          ),
          const SettingsNavigationTile(
            icon: Icons.speed_outlined,
            title: 'Performance',
            route: RouteConstants.settingsPerformance,
          ),
          const SettingsNavigationTile(
            icon: Icons.notifications_none_outlined,
            title: 'Notifications',
            route: RouteConstants.settingsNotifications,
          ),
          const SettingsNavigationTile(
            icon: Icons.lock_outline,
            title: 'Privacy',
            route: RouteConstants.settingsPrivacy,
          ),
          const Divider(),
          const SettingsSectionHeader(title: 'Account'),
          const SettingsNavigationTile(
            icon: Icons.person_outline,
            title: 'Profile',
            route: RouteConstants.profile,
          ),
          const SettingsNavigationTile(
            icon: Icons.info_outline,
            title: 'Account Info',
            route: RouteConstants.settingsAccount,
          ),
          const Divider(),
          const SettingsSectionHeader(title: 'Actions'),
          SettingsActionTile(
            icon: Icons.ad_units_outlined,
            title: 'Remove Ads',
            onTap: () {},
          ),
          SettingsActionTile(
            icon: Icons.share_outlined,
            title: 'Share',
            onTap: () {},
          ),
          SettingsActionTile(
            icon: Icons.feedback_outlined,
            title: 'Send Feedback',
            onTap: () {},
          ),
          SettingsActionTile(
            icon: Icons.restore_outlined,
            title: 'Restore Purchases',
            onTap: () {},
          ),
          const Divider(),
          const SettingsSectionHeader(title: 'About'),
          const SettingsNavigationTile(
            icon: Icons.description_outlined,
            title: 'Terms of Service',
            route: RouteConstants.terms,
          ),
          const SettingsNavigationTile(
            icon: Icons.shield_outlined,
            title: 'Privacy Policy',
            route: RouteConstants.privacy,
          ),
          AppSpacing.verticalGapMD,
          AccountSection(user: user.value),
          AppSpacing.verticalGapXL,
          Center(
            child: Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.xl),
              child: Text(
                'Copyright © ${DateTime.now().year} ${AppConstants.appName}, INC. Version ${AppConstants.appVersion}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.hintColor.withValues(alpha: 0.6),
                  fontSize: 11,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
