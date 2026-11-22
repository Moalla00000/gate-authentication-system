import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A simple provider to manage the app's theme mode.
/// By default, it follows the system theme.
final themeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.system);
