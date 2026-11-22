import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/repositories/auth_repository.dart' show authStateProvider;
import '../widgets/profile_header.dart';
import '../widgets/profile_action_buttons.dart';
import '../widgets/profile_stats_section.dart';
import '../../../core/theme/app_spacing.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider).value;

    return Scaffold(
      appBar: AppBar(title: const Text("Your Profile")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xl,
          vertical: AppSpacing.lg,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ProfileHeader(user: user),
            AppSpacing.verticalGapXL,
            ProfileActionButtons(user: user),
            AppSpacing.verticalGapXXL,
            const ProfileStatsSection(title: "Stats"),
            AppSpacing.verticalGapXL,
            const ProfileStatsSection(title: "Stats"),
          ],
        ),
      ),
    );
  }
}
