import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Feature Pages
import 'features/home/pages/home_page.dart';
import 'features/profile/pages/profile_page.dart';
import 'features/profile/pages/edit_profile_page.dart';
import 'features/auth/pages/signin_page.dart';
import 'features/auth/pages/register_page.dart';
import 'features/auth/pages/auth_landing_page.dart';
import 'features/onboarding/pages/onboarding_page.dart';
import 'features/onboarding/pages/permissions_page.dart';
import 'features/settings/pages/settings_page.dart';
import 'features/settings/pages/account_settings_page.dart';
import 'features/settings/pages/theme_settings_page.dart';
import 'features/settings/pages/toggle_settings_page.dart';
import 'features/settings/pages/change_password_page.dart';
import 'features/auth/pages/splash_screen.dart';
import 'features/settings/pages/tos_page.dart';
import 'features/settings/pages/privacy_policy_page.dart';

import 'features/auth/models/auth_state.dart';
import 'features/auth/repositories/auth_repository.dart';
import 'features/auth/providers/connectivity_provider.dart';
import 'core/services/onboarding_service.dart';
import 'core/utils/auth_listenable.dart';
import 'core/constants/app_constants.dart';
import 'shared/widgets/main_shell.dart';

/// Provides the GoRouter configuration for the application.
/// Handles routing, redirects based on auth and onboarding state,
/// and defining the shell route for bottom navigation.
/// 
/// Auth state mapping:
///   AuthInitial / AuthLoading → Splash
///   Unauthenticated / AuthSyncFailed → Onboarding or Auth Landing
///   Authenticated → Home / Profile

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: RouteConstants.splash,
    refreshListenable: AuthListenable([
      ref.watch(authRepositoryProvider.notifier).stream,
      ref.watch(backendConnectivityProvider.notifier).stream,
    ]),
    redirect: (context, state) async {
      final authState = ref.read(authRepositoryProvider);
      final onboardingService = ref.read(onboardingServiceProvider);
      final connectivity = ref.read(backendConnectivityProvider);
      final onboardingCompleted = await onboardingService
          .isOnboardingCompleted();

      final isSplashScreen = state.matchedLocation == RouteConstants.splash;
      final isLoggingIn =
          state.matchedLocation == RouteConstants.login ||
          state.matchedLocation == RouteConstants.register ||
          state.matchedLocation == RouteConstants.authLanding;
      final isOnboarding = state.matchedLocation == RouteConstants.onboarding;
      final isPermissions = state.matchedLocation == RouteConstants.permissions;

      // Gate screens are screens where connectivity is MANDATORY to proceed.
      final isAtGate =
          isSplashScreen || isLoggingIn || isOnboarding || isPermissions;

      // 0. If backend is checking or offline
      if (connectivity == BackendStatus.initial ||
          connectivity == BackendStatus.checking ||
          connectivity == BackendStatus.offline) {
        // Only force splash if we are at a gate OR have no determined auth state yet.
        if (isAtGate || authState is AuthInitial) {
          return isSplashScreen ? null : RouteConstants.splash;
        }
        // If we are mid-session (not at gate), stay where we are.
        return null;
      }

      // 1. If loading or initial, stay on splash — but do NOT interrupt active
      //    onboarding. The Finish button's loading feedback is handled locally
      //    via _isSubmitting, so redirecting the onboarding page to splash here
      //    would destroy the widget and wipe all step/username/avatar state.
      if (authState is AuthLoading || authState is AuthInitial) {
        if (isOnboarding) return null;
        return isSplashScreen ? null : RouteConstants.splash;
      }

      // 2. Sync failed: treat like unauthenticated — route to onboarding.
      // onboardingCompleted is false (markOnboardingCompleted is only called
      // after a successful sync), so the block below will redirect correctly.
      if (authState is AuthSyncFailed) {
        if (!onboardingCompleted) {
          if (isSplashScreen) return RouteConstants.onboarding;
          return isOnboarding ? null : RouteConstants.onboarding;
        }
        // Onboarding was previously completed (e.g. retry after a mid-session
        // backend hiccup) — send them to auth landing.
        if (isSplashScreen) return RouteConstants.authLanding;
        return isLoggingIn || isOnboarding || isPermissions
            ? null
            : RouteConstants.authLanding;
      }

      // 3. If not authenticated (Guest)
      if (authState is Unauthenticated) {
        if (connectivity == BackendStatus.offline) {
          return isSplashScreen ? null : RouteConstants.splash;
        }

        if (!onboardingCompleted) {
          if (isSplashScreen) return RouteConstants.onboarding;
          return isOnboarding ? null : RouteConstants.onboarding;
        }

        if (isSplashScreen) return RouteConstants.authLanding;
        return isLoggingIn || isOnboarding || isPermissions
            ? null
            : RouteConstants.authLanding;
      }

      // 4. If authenticated
      if (authState is Authenticated) {
        // PRODUCTION GUARD: Never show onboarding to an authenticated user
        if (isOnboarding) return RouteConstants.home;

        final user = authState.user;

        // If they are on splash, send to home
        if (isSplashScreen) return RouteConstants.home;

        final isAnonymous = user.isAnonymous || user.providerData.isEmpty;
        if (isLoggingIn && !isAnonymous) return RouteConstants.profile;
      }

      return null;
    },
    routes: [
      /// Splash Route
      GoRoute(
        path: RouteConstants.splash,
        builder: (context, state) => const SplashScreen(),
      ),

      /// Onboarding Route
      GoRoute(
        path: RouteConstants.onboarding,
        builder: (context, state) => const OnboardingPage(),
      ),

      /// Permissions Route
      GoRoute(
        path: RouteConstants.permissions,
        builder: (context, state) => const PermissionsPage(),
      ),

      /// Auth Routes (no bottom nav)
      GoRoute(
        path: RouteConstants.login,
        builder: (context, state) {
          final isLinking = state.uri.queryParameters['linking'] == 'true';
          return LoginPage(isLinking: isLinking);
        },
      ),
      GoRoute(
        path: RouteConstants.register,
        builder: (context, state) {
          final isLinking = state.uri.queryParameters['linking'] == 'true';
          return RegisterPage(isLinking: isLinking);
        },
      ),
      GoRoute(
        path: RouteConstants.authLanding,
        builder: (context, state) {
          final isLinking = state.uri.queryParameters['linking'] == 'true';
          return AuthLandingPage(isLinking: isLinking);
        },
      ),

      /// Main App Shell (with bottom nav)
      ShellRoute(
        builder: (context, state, child) {
          return MainShell(child: child);
        },
        routes: [
          GoRoute(
            path: RouteConstants.home,
            builder: (context, state) => const HomePage(),
          ),
          GoRoute(
            path: RouteConstants.profile,
            builder: (context, state) => const ProfilePage(),
            routes: [
              GoRoute(
                path: 'edit',
                builder: (context, state) => const EditProfilePage(),
              ),
            ],
          ),
          GoRoute(
            path: RouteConstants.settings,
            builder: (context, state) => const SettingsPage(),
            routes: [
              GoRoute(
                path: 'theme',
                builder: (context, state) => const ThemeSettingsPage(),
              ),
              GoRoute(
                path: 'sounds',
                builder: (context, state) => const SoundsSettingsPage(),
              ),
              GoRoute(
                path: 'performance',
                builder: (context, state) => const PerformanceSettingsPage(),
              ),
              GoRoute(
                path: 'notifications',
                builder: (context, state) => const NotificationsSettingsPage(),
              ),
              GoRoute(
                path: 'privacy',
                builder: (context, state) => const PrivacySettingsPage(),
              ),
              GoRoute(
                path: 'account',
                builder: (context, state) => const AccountSettingsPage(),
                routes: [
                  GoRoute(
                    path: 'change-password',
                    builder: (context, state) => const ChangePasswordPage(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),

      /// Legal Routes
      GoRoute(
        path: RouteConstants.terms,
        builder: (context, state) => const ToSPage(),
      ),
      GoRoute(
        path: RouteConstants.privacy,
        builder: (context, state) => const PrivacyPolicyPage(),
      ),
    ],
  );
});
