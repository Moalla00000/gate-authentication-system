import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_constants.dart';

class LegalText extends StatefulWidget {
  final String? prefix;
  const LegalText({super.key, this.prefix});

  @override
  State<LegalText> createState() => _LegalTextState();
}

class _LegalTextState extends State<LegalText> {
  late final TapGestureRecognizer _termsRecognizer;
  late final TapGestureRecognizer _privacyRecognizer;

  @override
  void initState() {
    super.initState();
    _termsRecognizer = TapGestureRecognizer()
      ..onTap = () => context.push(RouteConstants.terms);
    _privacyRecognizer = TapGestureRecognizer()
      ..onTap = () => context.push(RouteConstants.privacy);
  }

  @override
  void dispose() {
    _termsRecognizer.dispose();
    _privacyRecognizer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final linkStyle = theme.textTheme.bodyMedium?.copyWith(
      color: theme.colorScheme.primary,
      decoration: TextDecoration.underline,
      decorationColor: theme.colorScheme.primary,
    );

    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        text: widget.prefix ?? "By signing in, you agree to our ",
        style: theme.textTheme.bodyMedium,
        children: [
          TextSpan(
            text: "Terms of Service",
            style: linkStyle,
            recognizer: _termsRecognizer,
          ),
          const TextSpan(text: " and "),
          TextSpan(
            text: "Privacy Policy",
            style: linkStyle,
            recognizer: _privacyRecognizer,
          ),
          const TextSpan(text: "."),
        ],
      ),
    );
  }
}
