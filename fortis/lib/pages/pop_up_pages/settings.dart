import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Settings screen showing navigation shortcuts, audio controls, dark mode, notifications, and reset feature.
///
/// - Persists user choices with `shared_preferences`.
/// - Allows enabling/disabling sound effects and adjusting volume (0–100 %).
/// - Enables/disables dark mode.
/// - Enables/disabling notifications.
/// - Resets all settings to defaults.
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  static const _kSoundOnKey = 'soundOn';
  static const _kVolumeKey = 'volume';
  static const _kDarkModeKey = 'darkMode';
  static const _kNotificationsKey = 'notifications';

  bool _soundOn = true;
  double _volume = 1.0; // 0.0 → muted, 1.0 → max
  bool _darkMode = false;
  bool _notifications = true;

  @override
  void initState() {
    super.initState();
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _soundOn = prefs.getBool(_kSoundOnKey) ?? true;
      _volume = prefs.getDouble(_kVolumeKey) ?? 1.0;
      _darkMode = prefs.getBool(_kDarkModeKey) ?? false;
      _notifications = prefs.getBool(_kNotificationsKey) ?? true;
    });
  }

  Future<void> _toggleSound(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kSoundOnKey, value);
    setState(() => _soundOn = value);
  }

  Future<void> _changeVolume(double value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_kVolumeKey, value);
    setState(() => _volume = value);
  }

  Future<void> _toggleDarkMode(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kDarkModeKey, value);
    setState(() => _darkMode = value);
  }

  Future<void> _toggleNotifications(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kNotificationsKey, value);
    setState(() => _notifications = value);
  }

  Future<void> _resetSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kSoundOnKey);
    await prefs.remove(_kVolumeKey);
    await prefs.remove(_kDarkModeKey);
    await prefs.remove(_kNotificationsKey);
    setState(() {
      _soundOn = true;
      _volume = 1.0;
      _darkMode = false;
      _notifications = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Settings reset to defaults')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          // ── Navigation section ──────────────────────────────────────────────
          const _SectionHeader('Navigation'),
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: const Text('Home'),
            onTap: () {
              // TODO: Navigator.push(context, MaterialPageRoute(builder: (_) => const HomePage()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.storefront_outlined),
            title: const Text('Shop'),
            onTap: () {
              // TODO: Navigator.push(context, MaterialPageRoute(builder: (_) => const ShopPage()));
            },
          ),
          const Divider(),

          // ── Audio section ───────────────────────────────────────────────────
          const _SectionHeader('Audio'),
          SwitchListTile(
            secondary: const Icon(Icons.volume_up_outlined),
            title: const Text('Sound effects'),
            value: _soundOn,
            onChanged: _toggleSound,
          ),
          ListTile(
            leading: const Icon(Icons.tune_outlined),
            title: const Text('Volume'),
            subtitle: Slider(
              value: _volume,
              min: 0,
              max: 1,
              divisions: 10,
              label: '\${(_volume * 100).round()}%',
              onChanged: _soundOn ? _changeVolume : null,
            ),
            trailing: Text('\${(_volume * 100).round()}%'),
          ),
          const Divider(),

          // ── Appearance section ─────────────────────────────────────────────
          const _SectionHeader('Appearance'),
          SwitchListTile(
            secondary: const Icon(Icons.dark_mode_outlined),
            title: const Text('Dark Mode'),
            value: _darkMode,
            onChanged: _toggleDarkMode,
          ),
          const Divider(),

          // ── Notifications section ──────────────────────────────────────────
          const _SectionHeader('Notifications'),
          SwitchListTile(
            secondary: const Icon(Icons.notifications_outlined),
            title: const Text('Notifications'),
            value: _notifications,
            onChanged: _toggleNotifications,
          ),
          const Divider(),

          // ── Miscellaneous section ──────────────────────────────────────────
          const _SectionHeader('Miscellaneous'),
          ListTile(
            leading: const Icon(Icons.refresh_outlined),
            title: const Text('Reset Settings'),
            onTap: _resetSettings,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
/// Simple grey section header used throughout the settings list.
class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.label);
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.grey,
        ),
      ),
    );
  }
}
