import 'package:flutter/material.dart';
import 'package:fortis/pages/pop_up_pages/journal.dart';
import 'package:fortis/pages/pop_up_pages/settings.dart';
import 'package:fortis/pages/pop_up_pages/notifications.dart';
import 'package:fortis/pages/pop_up_pages/help_center.dart';
import 'package:fortis/pages/pop_up_pages/profile_details.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Picture and Name
            const SizedBox(height: 24),
            Center(
              child: Stack(
                children: [
                  const CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(
                      'https://randomuser.me/api/portraits/men/32.jpg',
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Lorenzo Jackson',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),

            // Menu Items
            _buildMenuItem(
              icon: Icons.book_outlined,
              title: 'My Journals',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MyJournalsPage()),
                );
              },
            ),
            _buildMenuItem(
              icon: Icons.person_outline,
              title: 'Profile',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfileDetailsPage()),
                );
              },
            ),
            _buildMenuItem(
              icon: Icons.settings_outlined,
              title: 'Settings',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsPage()),
                );
              },
            ),
            _buildMenuItem(
              icon: Icons.notifications_outlined,
              title: 'Notification',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const NotificationsPage()),
                );
              },
            ),
            _buildMenuItem(
              icon: Icons.help_outline,
              title: 'Help Center',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HelpCenterPage()),
                );
              },
            ),
            const Divider(height: 32, thickness: 1),
            _buildMenuItem(
              icon: Icons.logout_outlined,
              title: 'Logout',
              onTap: () {}, 
              textColor: Colors.red,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color textColor = Colors.black87,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title, style: TextStyle(fontSize: 16, color: textColor)),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
