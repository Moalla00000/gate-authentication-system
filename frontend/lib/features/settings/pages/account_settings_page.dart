import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/string_utils.dart';
import '../../../core/utils/date_utils.dart';
import '../../auth/repositories/auth_repository.dart';
import '../../../core/utils/toast_utils.dart';
import '../../../shared/widgets/backend_guard.dart';
import '../../../core/theme/app_spacing.dart';

class AccountSettingsPage extends ConsumerStatefulWidget {
  const AccountSettingsPage({super.key});

  @override
  ConsumerState<AccountSettingsPage> createState() =>
      _AccountSettingsPageState();
}

class _AccountSettingsPageState extends ConsumerState<AccountSettingsPage> {
  bool _isDeleting = false;

  Future<void> _handleDeleteAccount() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Account?'),
        content: const Text(
          'This action is permanent and cannot be undone. All your data will be removed.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('DELETE'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      setState(() => _isDeleting = true);
      try {
        await ref.read(authRepositoryProvider.notifier).deleteAccount();
        if (mounted) {
          ToastUtils.showSuccess(context, 'Account deleted successfully.');
        }
      } catch (e) {
        if (mounted) {
          ToastUtils.showError(context, e.toString());
        }
      } finally {
        if (mounted) setState(() => _isDeleting = false);
      }
    }
  }

  Widget _buildPasswordSection(User? user) {
    if (user == null || user.isAnonymous) return const SizedBox.shrink();

    final providers = user.providerData.map((p) => p.providerId).toList();
    final isGoogle = providers.contains('google.com');
    final hasPassword = providers.contains('password');

    if (isGoogle && !hasPassword) {
      return ListTile(
        title: const Text('Password'),
        subtitle: const Text('Managed via your Google Account'),
        leading: const Icon(Icons.account_circle_outlined),
        trailing: const Icon(Icons.info_outline, size: 20),
        onTap: () {
          ToastUtils.showInfo(
            context,
            'Your security is managed by Google. To change your password, please visit your Google Account settings.',
          );
        },
      );
    }

    return ListTile(
      title: const Text('Password'),
      subtitle: const Text('Modify your password'),
      leading: const Icon(Icons.lock_reset_outlined),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => context.go(RouteConstants.settingsChangePassword),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authStateProvider).value;

    return Scaffold(
      appBar: AppBar(title: const Text('Account Info')),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                if (user != null) ...[
                  ListTile(
                    title: const Text('Display Name'),
                    subtitle: Text(
                      (user.displayName ?? 'No name set').capitalize(),
                    ),
                    leading: const Icon(Icons.person_outline),
                  ),
                  ListTile(
                    title: const Text('Email'),
                    subtitle: Text(
                      (user.email == null || user.email!.isEmpty)
                          ? 'No email set'
                          : user.email!,
                    ),
                    leading: const Icon(Icons.email_outlined),
                  ),
                  ListTile(
                    title: const Text('Creation Date'),
                    subtitle: Text(
                      user.metadata.creationTime != null
                          ? AppDateUtils.formatJoinDate(
                              user.metadata.creationTime!.toLocal(),
                            )
                          : 'Unknown',
                    ),
                    leading: const Icon(Icons.calendar_today_outlined),
                  ),
                ],
                const Divider(),
                _buildPasswordSection(user),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: _isDeleting
                ? const CircularProgressIndicator()
                : BackendGuard(
                    errorMessage: 'Cannot delete account while offline',
                    child: TextButton(
                      onPressed: _handleDeleteAccount,
                      child: Text(
                        'Want to delete your account? Click here',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
