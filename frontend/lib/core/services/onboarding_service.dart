import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/app_constants.dart';

final onboardingServiceProvider = Provider<OnboardingService>((ref) {
  return OnboardingService();
});

class OnboardingService {
  Future<bool> isOnboardingCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(StorageConstants.onboardingCompleted) ?? false;
  }

  Future<void> markOnboardingCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(StorageConstants.onboardingCompleted, true);
  }

  Future<bool> isPermissionsCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(StorageConstants.permissionsCompleted) ?? false;
  }

  Future<void> markPermissionsCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(StorageConstants.permissionsCompleted, true);
  }

  Future<void> resetOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(StorageConstants.onboardingCompleted);
    await prefs.remove(StorageConstants.permissionsCompleted);
  }
}
