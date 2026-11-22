import 'package:flutter/material.dart';

class AppConstants {
  static const String appName = 'Gate';
  static const String appVersion = '1.0.0+1';
}

class ApiConstants {
  /// Base API URL for backend calls. Hardcoded for Android emulator by default.
  static const String baseUrl = 'http://10.0.2.2:5000';
  static const String apiBasePath = '$baseUrl/api/';
}

class RouteConstants {
  // Main Navigation Routes
  static const String splash = '/';
  static const String home = '/home';
  static const String profile = '/profile';
  static const String editProfile = '/profile/edit';
  static const String settings = '/settings';

  // Auth & Onboarding Routes
  static const String onboarding = '/onboarding';
  static const String authLanding = '/auth';
  static const String login = '/login';
  static const String register = '/register';
  static const String permissions = '/permissions';

  // Sub-Routes
  static const String settingsTheme = '/settings/theme';
  static const String settingsSounds = '/settings/sounds';
  static const String settingsPerformance = '/settings/performance';
  static const String settingsNotifications = '/settings/notifications';
  static const String settingsPrivacy = '/settings/privacy';
  static const String settingsAccount = '/settings/account';
  static const String settingsChangePassword =
      '/settings/account/change-password';

  // Feature Paths (e.g. Terms, Privacy policies)
  static const String terms = '/terms';
  static const String privacy = '/privacy';
}

class StorageConstants {
  // Keys for SharedPreferences
  static const String onboardingCompleted = 'onboarding_completed';
  static const String anonUsername = 'anon_username';
  static const String anonPhoto = 'anon_photo';
  static const String selectedLanguage = 'selected_language';
  static const String permissionsCompleted = 'permissions_completed';
}

class AssetConstants {
  // Default Avatar Options
  static const List<String> avatars = [
    'https://api.dicebear.com/7.x/avataaars/svg?seed=Felix',
    'https://api.dicebear.com/7.x/avataaars/svg?seed=Aneka',
    'https://api.dicebear.com/7.x/avataaars/svg?seed=Max',
    'https://api.dicebear.com/7.x/avataaars/svg?seed=Sasha',
    'https://api.dicebear.com/7.x/avataaars/svg?seed=Luna',
    'https://api.dicebear.com/7.x/avataaars/svg?seed=Leo',
    'https://api.dicebear.com/7.x/avataaars/svg?seed=Ivy',
    'https://api.dicebear.com/7.x/avataaars/svg?seed=Milo',
    'https://api.dicebear.com/7.x/avataaars/svg?seed=Nova',
    'https://api.dicebear.com/7.x/avataaars/svg?seed=Zara',
    'https://api.dicebear.com/7.x/avataaars/svg?seed=Orion',
    'https://api.dicebear.com/7.x/avataaars/svg?seed=Juno',
    'https://api.dicebear.com/7.x/avataaars/svg?seed=Kai',
    'https://api.dicebear.com/7.x/avataaars/svg?seed=Vera',
    'https://api.dicebear.com/7.x/avataaars/svg?seed=Theo',
    'https://api.dicebear.com/7.x/avataaars/svg?seed=Ayla',
    'https://api.dicebear.com/7.x/avataaars/svg?seed=Rex',
    'https://api.dicebear.com/7.x/avataaars/svg?seed=Clio',
    'https://api.dicebear.com/7.x/avataaars/svg?seed=Nico',
    'https://api.dicebear.com/7.x/avataaars/svg?seed=Zeke',
  ];
}

class AppColors {
  // Brand Colours
  static const Color deepCharcoal = Color(0xFF222831);
  static const Color deepCharcoal60 = Color(0x99222831);
  static const Color slateGrey = Color(0xFF393E46);
  static const Color teal = Color(0xFF00ADB5);
  static const Color offWhite = Color(0xFFEEEEEE);
  static const Color offWhite60 = Color(0x99EEEEEE);

  // Semantic & UI Colours
  static const Color white = Color(0xFFFFFFFF);
  static const Color errorDark = Color(0xFFCF6679);
  static const Color errorLight = Color(0xFFB00020);
  static const Color textDimDark = Color(0xFFAAAAAA);
  static const Color borderLight = Color(0xFFDDDDDD);
  static const Color inputFillLight = Color(0xFFE0E0E0);
}
