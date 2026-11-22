import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_spacing.dart';

class ToSPage extends StatelessWidget {
  const ToSPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Terms of Service')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Terms of Service',
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
              '1. Acceptance of Terms',
              'By accessing or using the Gate application, you agree to be bound by these Terms of Service. If you do not agree to these terms, please do not use the application.',
            ),
            _buildSection(
              context,
              '2. Description of Service',
              'Gate provides a secure access management and profile synchronization platform. We reserve the right to modify or discontinue any part of the service at any time.',
            ),
            _buildSection(
              context,
              '3. User Responsibilities',
              'You are responsible for maintaining the confidentiality of your account and for all activities that occur under your account. You agree to use the service only for lawful purposes.',
            ),
            _buildSection(
              context,
              '4. Privacy & Data',
              'Your use of the service is also governed by our Privacy Policy. By using Gate, you consent to the collection and use of information as described therein.',
            ),
            _buildSection(
              context,
              '5. Limitation of Liability',
              'Gate is provided "as is" without any warranties. We shall not be liable for any indirect, incidental, or consequential damages arising out of your use of the service.',
            ),
            _buildSection(
              context,
              '6. Intellectual Property',
              'All content and materials available on Gate, including but not limited to text, graphics, and logos, are the property of Gate and are protected by applicable intellectual property laws.',
            ),
            AppSpacing.verticalGapXL,
            const Text(
              'For any questions regarding these terms, please contact us.',
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
