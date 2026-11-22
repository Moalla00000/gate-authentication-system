import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/language_service.dart';

final languageProvider = StateNotifierProvider<LanguageNotifier, Locale?>((
  ref,
) {
  final service = ref.watch(languageServiceProvider);
  return LanguageNotifier(service);
});

class LanguageNotifier extends StateNotifier<Locale?> {
  final LanguageService _service;

  LanguageNotifier(this._service) : super(null) {
    _init();
  }

  Future<void> _init() async {
    final languageCode = await _service.getLanguage();
    if (languageCode != null) {
      if (languageCode == 'ar_TN') {
        state = const Locale.fromSubtags(languageCode: 'ar', countryCode: 'TN');
      } else {
        state = Locale(languageCode);
      }
    }
  }

  Future<void> setLanguage(String languageCode) async {
    await _service.setLanguage(languageCode);
    if (languageCode == 'ar_TN') {
      state = const Locale.fromSubtags(languageCode: 'ar', countryCode: 'TN');
    } else {
      state = Locale(languageCode);
    }
  }
}
