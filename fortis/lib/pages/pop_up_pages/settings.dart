import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _soundOn = true;

  @override
  void initState() {
    super.initState();
    _loadSoundPref();
  }

  Future<void> _loadSoundPref() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() => _soundOn = prefs.getBool('soundOn') ?? true);
  }

  Future<void> _toggleSound(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('soundOn', value);
    setState(() => _soundOn = value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text('Navigation',
                style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w600, color: Colors.grey)),
          ),
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: const Text('Home'),
            onTap: () {
              // Navigator.push(context, MaterialPageRoute(builder: (_) => const HomePage()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.storefront_outlined),
            title: const Text('Shop'),
            onTap: () {
              // Navigator.push(context, MaterialPageRoute(builder: (_) => const ShopPage()));
            },
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text('Audio',
                style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w600, color: Colors.grey)),
          ),
          SwitchListTile(
            secondary: const Icon(Icons.volume_up_outlined),
            title: const Text('Sound effects'),
            value: _soundOn,
            onChanged: _toggleSound,
          ),
        ],
      ),
    );
  }
}