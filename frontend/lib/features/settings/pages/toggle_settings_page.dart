import 'package:flutter/material.dart';

/// A template for static toggle settings pages.
class _BaseSettingPage extends StatefulWidget {
  final String title;
  const _BaseSettingPage({required this.title});

  @override
  State<_BaseSettingPage> createState() => _BaseSettingPageState();
}

class _BaseSettingPageState extends State<_BaseSettingPage> {
  bool _value = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: ListView(
        children: [
          SwitchListTile(
            title: Text('Enable ${widget.title}'),
            subtitle: Text(
              'Toggle ${widget.title.toLowerCase()} for the application',
            ),
            value: _value,
            onChanged: (val) => setState(() => _value = val),
          ),
        ],
      ),
    );
  }
}

class SoundsSettingsPage extends StatelessWidget {
  const SoundsSettingsPage({super.key});
  @override
  Widget build(BuildContext context) => const _BaseSettingPage(title: 'Sounds');
}

class PerformanceSettingsPage extends StatelessWidget {
  const PerformanceSettingsPage({super.key});
  @override
  Widget build(BuildContext context) =>
      const _BaseSettingPage(title: 'Performance');
}

class NotificationsSettingsPage extends StatelessWidget {
  const NotificationsSettingsPage({super.key});
  @override
  Widget build(BuildContext context) =>
      const _BaseSettingPage(title: 'Notifications');
}

class PrivacySettingsPage extends StatelessWidget {
  const PrivacySettingsPage({super.key});
  @override
  Widget build(BuildContext context) =>
      const _BaseSettingPage(title: 'Privacy');
}
