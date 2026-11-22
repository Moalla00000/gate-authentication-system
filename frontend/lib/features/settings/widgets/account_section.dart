import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../core/theme/app_spacing.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../auth/repositories/auth_repository.dart';
import '../../../core/utils/toast_utils.dart';
import '../../../shared/widgets/backend_guard.dart';

class AccountSection extends ConsumerWidget {
  final User? user;

  const AccountSection({super.key, required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (user == null) {
      return Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: ElevatedButton(
          onPressed: () => context.push(RouteConstants.authLanding),
          child: const Text('SIGN IN / CREATE ACCOUNT'),
        ),
      );
    } else {
      final bool isAnonymous = user!.isAnonymous || user!.providerData.isEmpty;

      if (isAnonymous) {
        return Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: ElevatedButton(
            onPressed: () => context.push(RouteConstants.authLanding),
            child: const Text('SIGN IN / CREATE ACCOUNT'),
          ),
        );
      }

      return Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: BackendGuard(
          errorMessage: 'Cannot sign out while offline',
          child: ElevatedButton(
            onPressed: () async {
              try {
                final authRepo = ref.read(authRepositoryProvider.notifier);
                await authRepo.signOut();
              } catch (e) {
                if (context.mounted) {
                  ToastUtils.showError(context, e.toString());
                }
              }
            },
            child: Text('SIGN OUT ${user!.displayName!.toUpperCase()}'),
          ),
        ),
      );
    }
  }
}
