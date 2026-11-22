import 'package:flutter/material.dart';
import '../../core/theme/app_spacing.dart';

class LabeledField extends StatelessWidget {
  final String label;
  final Widget child;
  final bool isRequired;
  final Widget? trailing;

  const LabeledField({
    super.key,
    required this.label,
    required this.child,
    this.isRequired = false,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(
                text: TextSpan(
                  text: label,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                  children: [
                    if (isRequired)
                      const TextSpan(
                        text: ' *',
                        style: TextStyle(color: Colors.red),
                      ),
                  ],
                ),
              ),
              // ignore: use_null_aware_elements
              if (trailing != null) trailing!,
            ],
          ),
        ),
        AppSpacing.verticalGapXS,
        child,
      ],
    );
  }
}
