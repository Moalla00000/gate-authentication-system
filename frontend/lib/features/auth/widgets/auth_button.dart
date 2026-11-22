import 'package:flutter/material.dart';
import '../../../core/theme/app_spacing.dart';

class AuthButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Widget? icon;
  final bool isSocial;

  const AuthButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.icon,
    this.isSocial = false,
  });

  @override
  Widget build(BuildContext context) {
    Widget content = isLoading
        ? const SizedBox.square(
            dimension: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
        : Text(label);

    if (icon != null && !isLoading) {
      content = Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [icon!, AppSpacing.horizontalGapXS, Text(label)],
      );
    }

    ButtonStyle style = ElevatedButton.styleFrom(
      minimumSize: const Size(double.infinity, AppSpacing.jm),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.sm),
      ),
    );

    if (isSocial) {
      final theme = Theme.of(context);
      style = style.copyWith(
        backgroundColor: WidgetStateProperty.all(theme.colorScheme.surface),
        foregroundColor: WidgetStateProperty.all(theme.colorScheme.onSurface),
        elevation: WidgetStateProperty.all(1),
        side: WidgetStateProperty.all(
          BorderSide(color: theme.dividerColor.withValues(alpha: 0.5)),
        ),
      );
    }

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: style,
        onPressed: isLoading ? null : onPressed,
        child: content,
      ),
    );
  }
}
