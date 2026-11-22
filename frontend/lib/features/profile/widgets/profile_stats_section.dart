import 'package:flutter/material.dart';
import '../../../core/theme/app_spacing.dart';

class ProfileStatsSection extends StatelessWidget {
  final String title;

  const ProfileStatsSection({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        AppSpacing.verticalGapSM,
        Container(
          height: 180,
          width: double.infinity,
          decoration: BoxDecoration(
            color: theme.brightness == Brightness.dark
                ? theme.colorScheme.surfaceContainerHighest.withValues(
                    alpha: 0.3,
                  )
                : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(AppSpacing.sm),
            border: Border.all(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.1),
            ),
          ),
          child: Center(
            child: Icon(
              Icons.bar_chart_rounded,
              size: 48,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.2),
            ),
          ),
        ),
      ],
    );
  }
}
