import 'package:flutter/material.dart';
import 'package:gate_authentication_system/l10n/app_localizations.dart';
import 'package:gate_authentication_system/core/constants/app_constants.dart';
import '../../../core/theme/app_spacing.dart';
import 'onboarding_bottom_frame.dart';

class UsernameStep extends StatefulWidget {
  final TextEditingController controller;
  final String? errorText;
  final ValueChanged<String> onChanged;
  final VoidCallback? onNext;

  const UsernameStep({
    super.key,
    required this.controller,
    required this.errorText,
    required this.onChanged,
    this.onNext,
  });

  @override
  State<UsernameStep> createState() => _UsernameStepState();
}

class _UsernameStepState extends State<UsernameStep>
    with AutomaticKeepAliveClientMixin {
  bool _showButton = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    // If the controller already has text (e.g. user swiped back), check if we should show the button
    final text = widget.controller.text;
    if (text.length >= 3 &&
        text.length <= 20 &&
        RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(text)) {
      _showButton = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Stack(
      children: [
        // 1. Text field at the top (centered title + stadium input)
        Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.xxxl,
              AppSpacing.lg,
              0,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  l10n.username,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                AppSpacing.verticalGapLG,
                TextField(
                  controller: widget.controller,
                  textInputAction: TextInputAction.done,
                  textCapitalization: TextCapitalization.sentences,
                  style: const TextStyle(color: AppColors.deepCharcoal),
                  onChanged: (val) {
                    if (_showButton) {
                      setState(() => _showButton = false);
                    }
                    widget.onChanged(val);
                  },
                  onSubmitted: (val) async {
                    if (widget.onNext != null) {
                      // Add a subtle pause before showing the continue button
                      await Future.delayed(const Duration(milliseconds: 400));
                      if (mounted) {
                        setState(() => _showButton = true);
                      }
                    }
                  },
                  decoration: InputDecoration(
                    hintText: l10n.username,
                    errorText: widget.errorText,
                    filled: true,
                    // The user requested the specific "white in app theme" (offWhite)
                    fillColor: AppColors.offWhite,
                    // We need to ensure text isn't invisible if they type in dark mode
                    // Since bg is offWhite, text MUST be dark.
                    hintStyle: TextStyle(
                      color: AppColors.deepCharcoal.withValues(alpha: 0.4),
                    ),
                    // Stadium border
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.hg),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.hg),
                      borderSide: BorderSide(
                        color: theme.primaryColor,
                        width: 2,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.hg),
                      borderSide: BorderSide(
                        color: theme.primaryColor,
                        width: 3,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // 2. Bottom "Frame" Container
        OnboardingBottomFrame(show: _showButton, onNext: widget.onNext),
      ],
    );
  }
}
