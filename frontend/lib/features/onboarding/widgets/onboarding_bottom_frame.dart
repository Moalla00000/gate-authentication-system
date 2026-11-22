import 'package:flutter/material.dart';
import 'package:gate_authentication_system/l10n/app_localizations.dart';
import '../../../core/theme/app_spacing.dart';

class OnboardingBottomFrame extends StatelessWidget {
  final bool show;
  final bool isLoading;
  final VoidCallback? onNext;
  final String? label;

  const OnboardingBottomFrame({
    super.key,
    required this.show,
    this.isLoading = false,
    this.onNext,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Align(
      alignment: Alignment.bottomCenter,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, animation) {
          return SizeTransition(
            sizeFactor: animation,
            axisAlignment: -1.0,
            child: FadeTransition(opacity: animation, child: child),
          );
        },
        child: (show || isLoading)
            ? Container(
                key: const ValueKey('bottomFrame'),
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: theme.primaryColor,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(AppSpacing.xl),
                  ),
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.xxl,
                  ),
                  decoration: BoxDecoration(
                    color: theme.scaffoldBackgroundColor,
                    borderRadius: BorderRadius.circular(AppSpacing.lg),
                    border: Border.all(color: theme.primaryColor, width: 3),
                  ),
                  child: ElevatedButton(
                    onPressed: isLoading ? null : onNext,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(AppSpacing.hg),
                      shape: const StadiumBorder(),
                    ),
                    child: isLoading
                        ? const SizedBox(
                            width: AppSpacing.lg,
                            height: AppSpacing.lg,
                            child: CircularProgressIndicator(strokeWidth: 3),
                          )
                        : Text(
                            label ?? AppLocalizations.of(context)!.next,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                  ),
                ),
              )
            : const SizedBox.shrink(key: ValueKey('emptyFrame')),
      ),
    );
  }
}
