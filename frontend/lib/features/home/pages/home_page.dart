import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/services/onboarding_service.dart';
import '../../../core/theme/app_spacing.dart';
import '../../onboarding/widgets/permissions_modal.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  void initState() {
    super.initState();
    // Use addPostFrameCallback to show the modal after the first frame is rendered
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkPermissions());
  }

  Future<void> _checkPermissions() async {
    final onboardingService = ref.read(onboardingServiceProvider);
    final completed = await onboardingService.isPermissionsCompleted();

    if (!completed && mounted) {
      await PermissionsModal.show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // Main Content
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(
                top: AppSpacing.vh,
              ), // adjust the value as needed
              child: Text(
                AppConstants.appName,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2.0,
                ),
              ),
            ),
          ),

          // Settings Button
          SafeArea(
            child: Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xs),
                child: IconButton(
                  icon: const Icon(Icons.settings),
                  onPressed: () => context.push(RouteConstants.settings),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
