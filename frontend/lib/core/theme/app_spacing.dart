import 'package:flutter/material.dart';

/// A centralized spacing system for the Gate application.
/// Follows a consistent scale to ensure UI harmony.
class AppSpacing {
  AppSpacing._();

  // Spacing Scale
  static const double xxs = 4.0;
  static const double xs = 8.0;
  static const double sm = 12.0;
  static const double md = 16.0;
  static const double sl = 20.0; // Small-Large / Medium-Plus
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 40.0;
  static const double xxxl = 48.0;
  static const double jm = 56.0; // Jumbo
  static const double hg = 64.0; // Huge
  static const double vh = 80.0; // Very Huge

  // Semantic Spacing
  static const double pageHorizontalPadding = md;
  static const double sectionSpacing = lg;
  static const double elementSpacing = sm;
  static const double cardPadding = md;
  static const double inputSpacing = md;

  // Gaps (SizedBox Helpers)
  static const SizedBox gapXXS = SizedBox(width: xxs, height: xxs);
  static const SizedBox gapXS = SizedBox(width: xs, height: xs);
  static const SizedBox gapSM = SizedBox(width: sm, height: sm);
  static const SizedBox gapMD = SizedBox(width: md, height: md);
  static const SizedBox gapSL = SizedBox(width: sl, height: sl);
  static const SizedBox gapLG = SizedBox(width: lg, height: lg);
  static const SizedBox gapXL = SizedBox(width: xl, height: xl);
  static const SizedBox gapXXL = SizedBox(width: xxl, height: xxl);
  static const SizedBox gapXXXL = SizedBox(width: xxxl, height: xxxl);

  // Vertical Gaps
  static const SizedBox verticalGapXXS = SizedBox(height: xxs);
  static const SizedBox verticalGapXS = SizedBox(height: xs);
  static const SizedBox verticalGapSM = SizedBox(height: sm);
  static const SizedBox verticalGapMD = SizedBox(height: md);
  static const SizedBox verticalGapSL = SizedBox(height: sl);
  static const SizedBox verticalGapLG = SizedBox(height: lg);
  static const SizedBox verticalGapXL = SizedBox(height: xl);
  static const SizedBox verticalGapXXL = SizedBox(height: xxl);
  static const SizedBox verticalGapXXXL = SizedBox(height: xxxl);

  // Horizontal Gaps
  static const SizedBox horizontalGapXXS = SizedBox(width: xxs);
  static const SizedBox horizontalGapXS = SizedBox(width: xs);
  static const SizedBox horizontalGapSM = SizedBox(width: sm);
  static const SizedBox horizontalGapMD = SizedBox(width: md);
  static const SizedBox horizontalGapSL = SizedBox(width: sl);
  static const SizedBox horizontalGapLG = SizedBox(width: lg);
  static const SizedBox horizontalGapXL = SizedBox(width: xl);
  static const SizedBox horizontalGapXXL = SizedBox(width: xxl);
  static const SizedBox horizontalGapXXXL = SizedBox(width: xxxl);
}
