import 'package:flutter/material.dart';

import 'package:fortis/pages/pop_up_pages/journal.dart';
import 'package:fortis/pages/pop_up_pages/settings.dart';
import 'package:fortis/pages/pop_up_pages/notifications.dart';
import 'package:fortis/pages/pop_up_pages/help_center.dart';
import 'package:fortis/pages/pop_up_pages/profile_details.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fortis/pages/user_login.dart';
import 'package:provider/provider.dart';
import 'package:fortis/theme_change.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? firstName;
  String? lastName;
  User? _currentUser;
  int _selectedAvatarIndex = 0;
  bool _isLoading = false;

  // Achievement fields
  int _daysSignedIn = 0;
  int _challengesCompleted = 0;
  DateTime? _accountCreationDate;

  final List<String> _avatarOptions = [
    'assets/avatars/avatar_1.png',
    'assets/avatars/avatar_2.png',
    'assets/avatars/avatar_3.png',
    'assets/avatars/avatar_4.png',
    'assets/avatars/avatar_5.png',
    'assets/avatars/avatar_6.png',
    'assets/avatars/avatar_7.png',
    'assets/avatars/avatar_8.png',
    'assets/avatars/avatar_9.png',
  ];

  @override
  void initState() {
    super.initState();
    _currentUser = _auth.currentUser;
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    if (_currentUser == null) return;
    setState(() => _isLoading = true);
    try {
      final userDoc =
          await _firestore.collection('users').doc(_currentUser!.uid).get();
      if (userDoc.exists) {
        final userData = userDoc.data() as Map<String, dynamic>;
        _selectedAvatarIndex = userData['avatarIndex'] ?? _selectedAvatarIndex;
        firstName = userData['firstName'] ?? firstName;
        lastName = userData['lastName'] ?? lastName;
        _daysSignedIn = userData['daysSignedIn'] ?? _daysSignedIn;

        _challengesCompleted =
            userData['challengesCompleted'] ?? _challengesCompleted;
        if (userData['createdAt'] != null) {
          _accountCreationDate = (userData['createdAt'] as Timestamp).toDate();
        }
      }
    } catch (e) {
      debugPrint('Error loading user profile: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _updateAvatar(int index) async {
    if (_currentUser == null) return;
    setState(() {
      _isLoading = true;
      _selectedAvatarIndex = index;
    });
    try {
      await _firestore.collection('users').doc(_currentUser!.uid).set({
        'avatarIndex': index,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Avatar updated successfully')),
      );
    } catch (e) {
      debugPrint('Error updating avatar: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to update avatar: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showAvatarSelectionDialog() {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Select Avatar'),
            content: SizedBox(
              width: double.maxFinite,
              child: GridView.builder(
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                ),
                itemCount: _avatarOptions.length,
                itemBuilder:
                    (context, index) => InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                        _updateAvatar(index);
                      },
                      child: CircleAvatar(
                        radius: 30,
                        backgroundImage: AssetImage(_avatarOptions[index]),
                        child:
                            _selectedAvatarIndex == index
                                ? const Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                )
                                : null,
                      ),
                    ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = context.watch<ThemeChanger>().backgroundColor;
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(title: const Text('Profile'), centerTitle: true),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Profile header
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: _showAvatarSelectionDialog,
                            child: CircleAvatar(
                              radius: 50,
                              backgroundImage: AssetImage(
                                _avatarOptions[_selectedAvatarIndex],
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            firstName != null && lastName != null
                                ? '$firstName $lastName'
                                : 'Profile User',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _currentUser?.email ?? '',
                            style: const TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            onPressed: _showAvatarSelectionDialog,
                            child: const Text('Change Avatar'),
                          ),
                        ],
                      ),
                    ),
                    const Divider(),

                    // Achievements in a row
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Achievements',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildAchievementItem(
                                icon: Icons.cake,
                                label: 'Joined',
                                value:
                                    _accountCreationDate != null
                                        ? '${_accountCreationDate!.toLocal()}'
                                            .split(' ')[0]
                                        : 'N/A',
                              ),
                              _buildAchievementItem(
                                icon: Icons.calendar_today,
                                label: 'Days Signed In',
                                value: '$_daysSignedIn',
                              ),
                              _buildAchievementItem(
                                icon: Icons.check_circle_outline,
                                label: 'Challenges',
                                value: '$_challengesCompleted',
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Divider(),

                    //Menu Itmes-------
                    _buildMenuItem(
                      icon: Icons.book_outlined,
                      title: 'My Journals',
                      onTap:
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const MyJournalsPage(),
                            ),
                          ),
                    ),
                    _buildMenuItem(
                      icon: Icons.person_outline,
                      title: 'Profile',
                      onTap:
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ProfileDetailsPage(),
                            ),
                          ),
                    ),
                    _buildMenuItem(
                      icon: Icons.settings_outlined,
                      title: 'Settings',
                      onTap:
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const SettingsPage(),
                            ),
                          ),
                    ),
                    _buildMenuItem(
                      icon: Icons.notifications_outlined,
                      title: 'Notification',
                      onTap:
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const NotificationsPage(),
                            ),
                          ),
                    ),
                    _buildMenuItem(
                      icon: Icons.help_outline,
                      title: 'Help Center',
                      onTap:
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const HelpCenterPage(),
                            ),
                          ),
                    ),
                    const Divider(),
                    _buildMenuItem(
                      icon: Icons.logout_outlined,
                      title: 'Logout',
                      textColor: Colors.red,
                      onTap: () async {
                        await _auth.signOut();
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (_) => const LoginPage()),
                          (route) => false,
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
    );
  }

  Widget _buildAchievementItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Icon(icon, size: 28, color: Colors.blue),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
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
      title: Text(title, style: TextStyle(color: textColor)),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
