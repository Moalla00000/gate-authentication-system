import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_spacing.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Privacy Policy')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Privacy Policy',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.teal,
              ),
            ),
            AppSpacing.verticalGapXS,
            Text(
              'Last Updated: February 24, 2026',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            AppSpacing.verticalGapXL,
            _buildSection(
              context,
              '1. Information We Collect',
              'We collect information you provide directly to us, such as when you create an account. This includes your name, email address, and profile information. For anonymous users, we store local session identifiers.',
            ),
            _buildSection(
              context,
              '2. How We Use Information',
              'We use the information we collect to provide, maintain, and improve our services, to process transactions, and to synchronize your profile across devices.',
            ),
            _buildSection(
              context,
              '3. Authentication Services',
              'Gate uses Firebase Authentication. Depending on your choice, this includes login via Email/Password or third-party providers like Google. These services collect information necessary for secure authentication.',
            ),
            _buildSection(
              context,
              '4. Data Synchronization',
              'Your profile data is synchronized with our secure backend to ensure a consistent experience. We use industry-standard encryption to protect your data during transmission and at rest.',
            ),
            _buildSection(
              context,
              '5. Your Rights',
              'You have the right to access, update, or delete your personal information at any time through the Account Settings. We comply with applicable data protection laws, including GDPR and CCPA.',
            ),
            _buildSection(
              context,
              '6. Data Protection',
              'We implement a variety of security measures to maintain the safety of your personal information. However, no method of transmission over the Internet is 100% secure.',
            ),
            AppSpacing.verticalGapXL,
            const Text(
              'If you have any questions about this Privacy Policy, please contact us.',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
            AppSpacing.verticalGapXXXL,
          ],
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          AppSpacing.verticalGapXS,
          Text(
            content,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              height: 1.5,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }
}
