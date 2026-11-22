import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gate_authentication_system/core/constants/app_constants.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/providers/language_provider.dart';

class LanguageStep extends ConsumerWidget {
  final VoidCallback onNext;

  const LanguageStep({super.key, required this.onNext});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final currentLocale = ref.watch(languageProvider);

    final languages = [
      {'name': 'اللهجة التونسية', 'code': 'ar_TN', 'flag': '🇹🇳'},
      {'name': 'العربية', 'code': 'ar', 'flag': '🇸🇦'},
      {'name': 'Français', 'code': 'fr', 'flag': '🇫🇷'},
      {'name': 'English', 'code': 'en', 'flag': '🇺🇸'},
    ];

    return Container(
      decoration: BoxDecoration(color: theme.primaryColor),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.xl,
        ),
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Hero(
              tag: 'app_logo',
              child: Text(
                AppConstants.appName,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w900,
                  color: AppColors.teal,
                  letterSpacing: 6,
                  height: 1.1,
                  shadows: [
                    Shadow(
                      color: AppColors.teal.withValues(alpha: 0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
              ),
            ),
            AppSpacing.verticalGapXL,
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: languages.length,
              separatorBuilder: (context, index) => AppSpacing.verticalGapSM,
              itemBuilder: (context, index) {
                final lang = languages[index];
                final isSelected =
                    (lang['code'] == 'ar_TN' &&
                        currentLocale?.languageCode == 'ar' &&
                        currentLocale?.countryCode == 'TN') ||
                    (lang['code'] == 'ar' &&
                        currentLocale?.languageCode == 'ar' &&
                        currentLocale?.countryCode == null) ||
                    (lang['code'] != 'ar' &&
                        lang['code'] != 'ar_TN' &&
                        currentLocale?.languageCode == lang['code']);

                return InkWell(
                  onTap: () async {
                    await ref
                        .read(languageProvider.notifier)
                        .setLanguage(lang['code']!);
                    onNext();
                  },
                  borderRadius: BorderRadius.circular(AppSpacing.sm),
                  child: Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppSpacing.sm),
                      border: Border.all(
                        color: isSelected
                            ? theme.primaryColor
                            : theme.dividerColor,
                        width: isSelected ? 2 : 1,
                      ),
                      color: isSelected
                          ? theme.primaryColor.withValues(alpha: 0.1)
                          : null,
                    ),
                    child: Row(
                      children: [
                        Text(
                          lang['flag']!,
                          style: const TextStyle(fontSize: 24),
                        ),
                        AppSpacing.horizontalGapMD,
                        Text(
                          lang['name']!,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: isSelected ? FontWeight.bold : null,
                          ),
                        ),
                        const Spacer(),
                        if (isSelected)
                          Icon(Icons.check_circle, color: theme.primaryColor),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
