import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gate_authentication_system/core/constants/app_constants.dart';
import 'package:gate_authentication_system/features/auth/widgets/auth_widgets.dart';
import 'package:go_router/go_router.dart';
import '../repositories/auth_repository.dart';
import '../models/auth_state.dart';
import 'package:gate_authentication_system/core/utils/validators.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/toast_utils.dart';

class RegisterPage extends ConsumerStatefulWidget {
  final bool isLinking;
  const RegisterPage({super.key, this.isLinking = false});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      final authRepo = ref.read(authRepositoryProvider.notifier);
      if (widget.isLinking) {
        await authRepo.linkWithEmailAccount(
          _emailController.text.trim(),
          _passwordController.text,
          _nameController.text.trim(),
        );
      } else {
        await authRepo.registerWithEmailAndPassword(
          _emailController.text.trim(),
          _passwordController.text,
          _nameController.text.trim(),
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authState = ref.watch(authRepositoryProvider);
    String? currentName;
    if (authState is Authenticated) {
      currentName = authState.user.displayName;
    }

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
                          Text(
                            'Join for Free',
                            style: theme.textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          LabeledField(
                            label: 'Email',
                            isRequired: true,
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
                            isRequired: true,
                            child: TextFormField(
                              controller: _passwordController,
                              obscureText: true,
                              textInputAction: TextInputAction.next,
                              decoration: const InputDecoration(
                                hintText: 'Password',
                              ),
                              validator: Validators.validateNewPassword,
                            ),
                          ),
                          AppSpacing.verticalGapMD,
                          LabeledField(
                            label: 'Username',
                            isRequired: true,
                            child: TextFormField(
                              controller: _nameController,
                              textInputAction: TextInputAction.done,
                              textCapitalization: TextCapitalization.sentences,
                              decoration: InputDecoration(
                                hintText: currentName ?? 'Username',
                              ),
                              onFieldSubmitted: (_) => _register(),
                              validator: Validators.validateName,
                            ),
                          ),
                          AppSpacing.verticalGapXL,
                          AuthButton(
                            label: 'SUBMIT',
                            isLoading: _isLoading,
                            onPressed: _register,
                          ),
                          AppSpacing.verticalGapLG,
                          const LegalText(
                            prefix:
                                "By creating an account you agree with ${AppConstants.appName}'s ",
                          ),
                          AppSpacing.verticalGapMD,
                          TextButton(
                            onPressed: () =>
                                context.replace(RouteConstants.login),
                            child: Text(
                              'Already a ${AppConstants.appName}r? Log In',
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
