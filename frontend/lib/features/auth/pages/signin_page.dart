import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gate_authentication_system/core/constants/app_constants.dart';
import 'package:gate_authentication_system/features/auth/widgets/auth_widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:gate_authentication_system/core/utils/validators.dart';
import '../repositories/auth_repository.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/toast_utils.dart';

class LoginPage extends ConsumerStatefulWidget {
  final bool isLinking;
  const LoginPage({super.key, this.isLinking = false});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      final authRepo = ref.read(authRepositoryProvider.notifier);
      if (widget.isLinking) {
        await authRepo.linkWithEmailAccount(
          _emailController.text.trim(),
          _passwordController.text,
        );
      } else {
        await authRepo.signInWithEmailAndPassword(
          _emailController.text.trim(),
          _passwordController.text,
        );
      }
      if (mounted) context.go(RouteConstants.profile);
    } catch (e) {
      if (mounted) {
        ToastUtils.showError(context, e.toString());
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _forgotPassword() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      ToastUtils.showInfo(context, 'Please enter your email first.');
      return;
    }

    setState(() => _isLoading = true);
    try {
      await ref
          .read(authRepositoryProvider.notifier)
          .sendPasswordResetEmail(email);
      if (mounted) {
        ToastUtils.showSuccess(
          context,
          'Password reset email sent! Please check your inbox.',
        );
      }
    } catch (e) {
      if (mounted) {
        ToastUtils.showError(context, e.toString());
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign In / Create Account')),
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
                      vertical: AppSpacing.lg,
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          LabeledField(
                            label: 'Email',
                            child: TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              decoration: const InputDecoration(
                                hintText: 'Email',
                              ),
                              validator: Validators.validateEmail,
                            ),
                          ),
                          AppSpacing.verticalGapMD,
                          LabeledField(
                            label: 'Password',
                            trailing: TextButton(
                              onPressed: _isLoading ? null : _forgotPassword,
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: const Text('Forgot Password?'),
                            ),
                            child: TextFormField(
                              controller: _passwordController,
                              obscureText: true,
                              textInputAction: TextInputAction.done,
                              decoration: const InputDecoration(
                                hintText: 'Password',
                              ),
                              onFieldSubmitted: (_) => _login(),
                              validator: Validators.validatePassword,
                            ),
                          ),
                          AppSpacing.verticalGapXL,
                          AuthButton(
                            label: 'LOG IN',
                            isLoading: _isLoading,
                            onPressed: _login,
                          ),
                          AppSpacing.verticalGapLG,
                          TextButton(
                            onPressed: () =>
                                context.replace(RouteConstants.register),
                            child: Text(
                              'Join ${AppConstants.appName} for Free',
                            ),
                          ),
                        ],
                      ),
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
