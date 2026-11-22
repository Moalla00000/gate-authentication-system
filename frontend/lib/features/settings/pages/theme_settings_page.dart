import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/theme_provider.dart';

class ThemeSettingsPage extends ConsumerWidget {
  const ThemeSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.watch(themeProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Theme Settings')),
      body: ListView(
        children: [
          // ignore: deprecated_member_use
          RadioListTile<ThemeMode>(
            title: const Text('System Default'),
            value: ThemeMode.system,
            // ignore: deprecated_member_use
            groupValue: currentTheme,
            // ignore: deprecated_member_use
            onChanged: (val) => ref.read(themeProvider.notifier).state = val!,
          ),
          // ignore: deprecated_member_use
          RadioListTile<ThemeMode>(
            title: const Text('Light Mode'),
            value: ThemeMode.light,
            // ignore: deprecated_member_use
            groupValue: currentTheme,
            // ignore: deprecated_member_use
            onChanged: (val) => ref.read(themeProvider.notifier).state = val!,
          ),
          // ignore: deprecated_member_use
          RadioListTile<ThemeMode>(
            title: const Text('Dark Mode'),
            value: ThemeMode.dark,
            // ignore: deprecated_member_use
            groupValue: currentTheme,
            // ignore: deprecated_member_use
            onChanged: (val) => ref.read(themeProvider.notifier).state = val!,
          ),
        ],
      ),
    );
  }
}
