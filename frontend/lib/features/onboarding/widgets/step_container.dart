import 'package:flutter/material.dart';
import '../../../core/theme/app_spacing.dart';

class StepContainer extends StatelessWidget {
  final String title;
  final Widget child;

  const StepContainer({super.key, required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          AppSpacing.verticalGapLG,
          Expanded(child: child),
        ],
      ),
    );
  }
}
