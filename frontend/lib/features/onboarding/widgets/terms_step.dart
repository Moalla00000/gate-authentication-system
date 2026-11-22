import 'package:flutter/material.dart';
import 'package:gate_authentication_system/l10n/app_localizations.dart';
import 'package:gate_authentication_system/core/constants/app_constants.dart';
import 'package:gate_authentication_system/features/auth/widgets/auth_widgets.dart';
import '../../../core/theme/app_spacing.dart';

class TermsStep extends StatelessWidget {
  final VoidCallback? onNext;

  const TermsStep({super.key, this.onNext});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Stack(
      children: [
        // 1. Illustration Layer (optional, can be added later)

        // 2. Outer "Frame" Container
        Align(
          alignment: Alignment.topCenter,
          child: Container(
            height: size.height * 0.45,
            padding: const EdgeInsets.all(
              AppSpacing.sm,
            ), // Thick outer border look
            decoration: BoxDecoration(
              color: theme.primaryColor,
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(AppSpacing.xl),
              ),
            ),
            child: Container(
              // 3. Inner White Card
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.xxl,
              ),
              decoration: BoxDecoration(
                color: theme.scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(AppSpacing.lg),
                border: Border.all(color: theme.primaryColor, width: 3),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    l10n.welcome(AppConstants.appName),
                    textAlign: TextAlign.center,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  AppSpacing.verticalGapLG,
                  Text(
                    l10n.followSteps,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyLarge,
                  ),
                  AppSpacing.verticalGapLG,
                  ElevatedButton(
                    onPressed: onNext,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(AppSpacing.hg),
                      shape: const StadiumBorder(),
                    ),
                    child: Text(
                      l10n.okGotcha,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  AppSpacing.verticalGapLG,
                  LegalText(prefix: l10n.acceptTerms),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
