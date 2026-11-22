import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';

final storageServiceProvider = Provider<StorageService>((ref) {
  return StorageService();
});

class StorageService {
  Future<void> saveAnonProfile({
    required String username,
    required String photo,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(StorageConstants.anonUsername, username);
    await prefs.setString(StorageConstants.anonPhoto, photo);
  }

  Future<(String, String)> getAnonProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString(StorageConstants.anonUsername) ?? 'Guest';
    final photo = prefs.getString(StorageConstants.anonPhoto) ?? '';
    return (username, photo);
  }

  Future<void> clearAnonProfile() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(StorageConstants.anonUsername);
    await prefs.remove(StorageConstants.anonPhoto);
  }
}
