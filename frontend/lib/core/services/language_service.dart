import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/app_constants.dart';

final languageServiceProvider = Provider<LanguageService>((ref) {
  return LanguageService();
});

class LanguageService {
  Future<String?> getLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(StorageConstants.selectedLanguage);
  }

  Future<void> setLanguage(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(StorageConstants.selectedLanguage, languageCode);
  }

  Future<void> clearLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(StorageConstants.selectedLanguage);
  }
}
