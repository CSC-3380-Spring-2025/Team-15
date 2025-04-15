import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ImagePicker _picker = ImagePicker();

  User? _currentUser;
  String? _profileImageUrl;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _currentUser = _auth.currentUser;
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    if (_currentUser == null) return;

    try {
      // will get profile data from Firestore
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(_currentUser!.uid).get();

      if (userDoc.exists) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        if (userData.containsKey('profileImageUrl')) {
          setState(() {
            _profileImageUrl = userData['profileImageUrl'];
          });
        }
      }
    } catch (e) {
      print('Error loading user profile: $e');
    }
  }

  Future<void> _pickAndUploadImage() async {
    if (_currentUser == null) return;

    try {
      setState(() {
        _isLoading = true;
      });

      // Pick image from files
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 75,
      );

      if (image == null) {
        setState(() {
          _isLoading = false;
        });
        return;
      }

      // Get file extension
      String extension = image.path.split('.').last.toLowerCase();
      if (extension != 'jpg' && extension != 'jpeg' && extension != 'png') {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Only JPG and PNG images are supported'),
          ),
        );
        return;
      }

      File imageFile = File(image.path);
      String fileName =
          'profile_${_currentUser!.uid}_${DateTime.now().millisecondsSinceEpoch}.$extension';

      print("Uploading file: $fileName");
      print("File size: ${await imageFile.length()} bytes");

      // Upload to Firebase Storage with metadata
      final Reference storageRef = _storage.ref().child(
        'profile_images/$fileName',
      );

      // Set correct content type based on extension
      final metadata = SettableMetadata(
        contentType: extension == 'png' ? 'image/png' : 'image/jpeg',
      );

      final UploadTask uploadTask = storageRef.putFile(imageFile, metadata);

      // Monitor upload progress and handle errors
      uploadTask.snapshotEvents.listen(
        (TaskSnapshot snapshot) {
          print(
            'Upload progress: ${snapshot.bytesTransferred}/${snapshot.totalBytes}',
          );
        },
        onError: (e) {
          print('Upload error: $e');
          setState(() {
            _isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Upload error: ${e.toString()}')),
          );
        },
      );

      // Get download URL after upload completes
      try {
        final TaskSnapshot snapshot = await uploadTask;
        final String downloadUrl = await snapshot.ref.getDownloadURL();

        // Update user's profile in Firestore
        await _firestore.collection('users').doc(_currentUser!.uid).set({
          'profileImageUrl': downloadUrl,
          'updatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));

        setState(() {
          _profileImageUrl = downloadUrl;
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile picture updated successfully')),
        );
      } catch (e) {
        print('Error getting download URL: $e');
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error finalizing upload: ${e.toString()}')),
        );
      }
    } catch (e) {
      print('Error in image upload process: $e');
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update profile picture: ${e.toString()}'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile'), centerTitle: true),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                child: Column(
                  children: [
                    // Profile section
                    Container(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          // Profile image
                          GestureDetector(
                            onTap: _pickAndUploadImage,
                            child: Stack(
                              children: [
                                CircleAvatar(
                                  radius: 50,
                                  backgroundImage:
                                      _profileImageUrl != null
                                          ? NetworkImage(_profileImageUrl!)
                                          : null,
                                  child:
                                      _profileImageUrl == null
                                          ? const Icon(Icons.person, size: 50)
                                          : null,
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: const Icon(
                                      Icons.camera_alt,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Email display
                          Text(
                            _currentUser?.email ?? '',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 20),
                          // Upload button
                          ElevatedButton(
                            onPressed: _pickAndUploadImage,
                            child: const Text('Change Profile Picture'),
                          ),
                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
                    // Divider
                    const Divider(thickness: 1),
                    // Menu items
                    _buildMenuItem(
                      icon: Icons.book_outlined,
                      title: 'My Journals',
                      onTap: () {},
                    ),
                    _buildMenuItem(
                      icon: Icons.person_outline,
                      title: 'Profile',
                      onTap: () {},
                    ),
                    _buildMenuItem(
                      icon: Icons.settings_outlined,
                      title: 'Settings',
                      onTap: () {},
                    ),
                    _buildMenuItem(
                      icon: Icons.notifications_outlined,
                      title: 'Notification',
                      onTap: () {},
                    ),
                    _buildMenuItem(
                      icon: Icons.help_outline,
                      title: 'Help Center',
                      onTap: () {},
                    ),
                    const Divider(height: 32, thickness: 1),
                    _buildMenuItem(
                      icon: Icons.logout_outlined,
                      title: 'Logout',
                      onTap: () {
                        // Add your logout logic here
                        FirebaseAuth.instance.signOut();
                        // Navigate to login page
                      },
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
