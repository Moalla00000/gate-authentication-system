import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gate_authentication_system/core/constants/app_constants.dart';
import 'package:gate_authentication_system/features/auth/widgets/auth_widgets.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/toast_utils.dart';
import '../repositories/auth_repository.dart';

/// Tracks loading state for the Google Sign-In flow.
final googleSignInLoadingProvider = StateProvider<bool>((ref) => false);

class AuthLandingPage extends ConsumerWidget {
  final bool isLinking;
  const AuthLandingPage({super.key, this.isLinking = false});

  Future<void> _handleGoogleSignIn(BuildContext context, WidgetRef ref) async {
    ref.read(googleSignInLoadingProvider.notifier).state = true;
    try {
      final authRepo = ref.read(authRepositoryProvider.notifier);
      if (isLinking) {
        await authRepo.linkWithGoogle();
      } else {
        await authRepo.signInWithGoogle();
      }

      if (!context.mounted) return;
      context.go(RouteConstants.profile);
    } catch (e) {
      if (!context.mounted) return;
      ToastUtils.showError(
        context,
        '${isLinking ? 'Linking' : 'Google sign-in'} failed: $e',
      );
    } finally {
      ref.read(googleSignInLoadingProvider.notifier).state = false;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(googleSignInLoadingProvider);
    final user = ref.watch(authStateProvider).value;
    final isAnonymous = user?.isAnonymous ?? false;
    final theme = Theme.of(context);

    // If already a guest, 'Create Account' should link by default to save progress
    final String registerPath = isLinking || isAnonymous
        ? '${RouteConstants.register}?linking=true'
        : RouteConstants.register;

    // 'Sign In' should also prioritize linking/account switching context
    final String loginPath = isLinking || isAnonymous
        ? '${RouteConstants.login}?linking=true'
        : RouteConstants.login;

    return Scaffold(
      appBar: AppBar(title: Text('Sign In / Create Account')),
      body: CustomScrollView(
        physics: const ClampingScrollPhysics(),
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
              children: [
                const AuthHeader(),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.xl,
                      vertical: AppSpacing.xxxl,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Get the best of ${AppConstants.appName}',
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const Spacer(),
                        AuthButton(
                          label: 'CREATE AN ACCOUNT',
                          onPressed: () => context.push(registerPath),
                        ),
                        AppSpacing.verticalGapMD,
                        const Center(child: Text('OR')),
                        AppSpacing.verticalGapMD,
                        AuthButton(
                          label: 'Sign in with ${AppConstants.appName}',
                          onPressed: () => context.push(loginPath),
                        ),
                        AppSpacing.verticalGapMD,
                        AuthButton(
                          label: 'Sign in with Google',
                          isSocial: true,
                          isLoading: isLoading,
                          icon: SvgPicture.asset(
                            'assets/icons/google_logo.svg',
                            width: 20,
                            height: 20,
                          ),
                          onPressed: () => _handleGoogleSignIn(context, ref),
                        ),
                        AppSpacing.verticalGapLG,
                        const LegalText(),
                      ],
                    ),
                  ),
                ),
                const AuthFooter(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
