import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';

class AuthHeader extends StatelessWidget {
  const AuthHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: kToolbarHeight,
      width: double.infinity,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Theme.of(context).appBarTheme.backgroundColor,
        border: Border(
          bottom: BorderSide(color: _getBorderColor(context), width: 1.5),
        ),
      ),
      child: Text(
        AppConstants.appName,
        style: Theme.of(context).appBarTheme.titleTextStyle,
      ),
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
