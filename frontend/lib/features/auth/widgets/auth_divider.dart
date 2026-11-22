import 'package:flutter/material.dart';
import '../../../core/theme/app_spacing.dart';

class AuthDivider extends StatelessWidget {
  const AuthDivider({super.key});

  @override
  Widget build(BuildContext context) {
    final borderColor = _getBorderColor(context);

    return Row(
      children: [
        Expanded(child: Divider(color: borderColor, thickness: 1.5)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Text("OR", style: Theme.of(context).textTheme.bodySmall),
        ),
        Expanded(child: Divider(color: borderColor, thickness: 1.5)),
      ],
    );
  }

  Color _getBorderColor(BuildContext context) {
    final shape = Theme.of(context).appBarTheme.shape;
    if (shape is Border) {
      return shape.bottom.color;
    }
    return Theme.of(context).dividerColor;
  }
}
