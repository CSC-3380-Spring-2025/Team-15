import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ProfileDetailsPage extends StatefulWidget {
  const ProfileDetailsPage({super.key});

  @override
  State<ProfileDetailsPage> createState() => _ProfileDetailsPageState();
}

class _ProfileDetailsPageState extends State<ProfileDetailsPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final _formKey = GlobalKey<FormState>();
  bool _isLoading = true;
  bool _isEditing = false;

  // User profile data
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _dateOfBirthController;
  late TextEditingController _bioController;

  String? _selectedGender;

  DateTime? _selectedDate;
  final List<String> _genderOptions = [
    'Male',
    'Female',
    'Non-binary',
    'Prefer not to say',
  ];

  // Track whether fields have been modified
  bool _profileModified = false;
  int _currentPoints = 0;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _dateOfBirthController = TextEditingController();
    _bioController = TextEditingController();

    // Add listeners to track changes
    _firstNameController.addListener(_fieldChanged);
    _lastNameController.addListener(_fieldChanged);
    _phoneController.addListener(_fieldChanged);
    _bioController.addListener(_fieldChanged);

    _loadUserData();
  }

  void _fieldChanged() {
    if (!_profileModified) {
      setState(() => _profileModified = true);
    }
  }

  Future<int> _getCurrentPoints() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final doc = await _firestore.collection('users').doc(user.uid).get();
        if (doc.exists && doc.data() != null) {
          return doc.data()?['points'] ?? 0;
        }
      }
      return _currentPoints;
    } catch (e) {
      debugPrint('Error getting points: $e');
      return _currentPoints;
    }
  }

  @override
  void dispose() {
    // Remove listeners
    _firstNameController.removeListener(_fieldChanged);
    _lastNameController.removeListener(_fieldChanged);
    _phoneController.removeListener(_fieldChanged);
    _bioController.removeListener(_fieldChanged);

    // Dispose controllers
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _dateOfBirthController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    setState(() => _isLoading = true);

    try {
      final User? currentUser = _auth.currentUser;
      if (currentUser != null) {
        // Set email from Firebase Auth
        _emailController.text = currentUser.email ?? '';

        // Get additional user data from Firestore
        final userDoc =
            await _firestore.collection('users').doc(currentUser.uid).get();

        if (userDoc.exists) {
          final userData = userDoc.data() as Map<String, dynamic>;

          _firstNameController.text = userData['firstName'] ?? '';
          _lastNameController.text = userData['lastName'] ?? '';
          _phoneController.text = userData['phone'] ?? '';
          _bioController.text = userData['bio'] ?? '';
          _selectedGender = userData['gender'];
          _currentPoints = userData['points'] ?? 0;

          // Handle date of birth if exists
          if (userData['dateOfBirth'] != null) {
            _selectedDate = (userData['dateOfBirth'] as Timestamp).toDate();
            _dateOfBirthController.text = DateFormat(
              'yyyy-MM-dd',
            ).format(_selectedDate!);
          }

          // Reset modification tracking
          setState(() => _profileModified = false);
        } else {
          // Create user document if it doesn't exist
          await _firestore.collection('users').doc(currentUser.uid).set({
            'email': currentUser.email,
            'createdAt': FieldValue.serverTimestamp(),
            'points': 0,
            'daysSignedIn': 0,
            'challengesCompleted': 0,
          });
        }
      }
    } catch (e) {
      debugPrint('Error loading user data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load profile data: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _saveUserData() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final User? currentUser = _auth.currentUser;
      if (currentUser != null) {
        // Prepare data to save
        final Map<String, dynamic> userData = {
          'firstName': _firstNameController.text.trim(),
          'lastName': _lastNameController.text.trim(),
          'phone': _phoneController.text.trim(),
          'gender': _selectedGender,
          'bio': _bioController.text.trim(),
          'updatedAt': FieldValue.serverTimestamp(),
          // Preserve existing user data
          'points': await _getCurrentPoints(),
          'updatedAtDetails': DateTime.now().millisecondsSinceEpoch,
        };

        // Add date of birth if it exists
        if (_selectedDate != null) {
          userData['dateOfBirth'] = Timestamp.fromDate(_selectedDate!);
        }

        // Save to Firestore
        await _firestore
            .collection('users')
            .doc(currentUser.uid)
            .set(userData, SetOptions(merge: true));

        // Log profile update in user activity collection
        await _firestore
            .collection('users')
            .doc(currentUser.uid)
            .collection('userActivity')
            .add({
              'activityType': 'profile_update',
              'timestamp': FieldValue.serverTimestamp(),
              'details': 'Updated profile information',
            });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully')),
        );

        setState(() => _isEditing = false);
      }
    } catch (e) {
      debugPrint('Error saving user data: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to update profile: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
        _dateOfBirthController.text = DateFormat(
          'yyyy-MM-dd',
        ).format(pickedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Details'),
        actions: [
          if (!_isEditing)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => setState(() => _isEditing = true),
            )
          else
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => setState(() => _isEditing = false),
            ),
        ],
      ),
      // will add actually functionality to this later
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Personal Information',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // First Name
                      TextFormField(
                        controller: _firstNameController,
                        decoration: const InputDecoration(
                          labelText: 'First Name',
                          border: OutlineInputBorder(),
                        ),
                        enabled: _isEditing,
                        validator: (value) {
                          if (_isEditing && (value == null || value.isEmpty)) {
                            return 'Please enter your first name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Last Name
                      TextFormField(
                        controller: _lastNameController,
                        decoration: const InputDecoration(
                          labelText: 'Last Name',
                          border: OutlineInputBorder(),
                        ),
                        enabled: _isEditing,
                        validator: (value) {
                          if (_isEditing && (value == null || value.isEmpty)) {
                            return 'Please enter your last name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Email
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(),
                          helperText: 'Email cannot be changed',
                        ),
                        enabled: false,
                      ),
                      const SizedBox(height: 16),

                      // Phone
                      TextFormField(
                        controller: _phoneController,
                        decoration: const InputDecoration(
                          labelText: 'Phone Number',
                          border: OutlineInputBorder(),
                        ),
                        enabled: _isEditing,
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 16),

                      // Date of Birth
                      TextFormField(
                        controller: _dateOfBirthController,
                        decoration: InputDecoration(
                          labelText: 'Date of Birth',
                          border: const OutlineInputBorder(),
                          suffixIcon:
                              _isEditing
                                  ? IconButton(
                                    icon: const Icon(Icons.calendar_today),
                                    onPressed: () => _selectDate(context),
                                  )
                                  : null,
                        ),
                        readOnly: true,
                        enabled: _isEditing,
                      ),
                      const SizedBox(height: 16),

                      // Gender
                      if (_isEditing)
                        DropdownButtonFormField<String>(
                          value: _selectedGender,
                          decoration: const InputDecoration(
                            labelText: 'Gender',
                            border: OutlineInputBorder(),
                          ),
                          items:
                              _genderOptions.map((String gender) {
                                return DropdownMenuItem<String>(
                                  value: gender,
                                  child: Text(gender),
                                );
                              }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedGender = newValue;
                            });
                          },
                        )
                      else
                        TextFormField(
                          initialValue: _selectedGender ?? 'Not specified',
                          decoration: const InputDecoration(
                            labelText: 'Gender',
                            border: OutlineInputBorder(),
                          ),
                          enabled: false,
                        ),
                      const SizedBox(height: 16),

                      // Bio
                      TextFormField(
                        controller: _bioController,
                        decoration: const InputDecoration(
                          labelText: 'Bio',
                          border: OutlineInputBorder(),
                          hintText: 'Tell us about yourself...',
                        ),
                        enabled: _isEditing,
                        maxLines: 3,
                      ),
                      const SizedBox(height: 24),

                      const Text(
                        'Account Information',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),

                      ListTile(
                        title: const Text('Account Created'),
                        subtitle: FutureBuilder<DocumentSnapshot>(
                          future:
                              _firestore
                                  .collection('users')
                                  .doc(_auth.currentUser!.uid)
                                  .get(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Text('Loading...');
                            }

                            if (snapshot.hasError) {
                              return const Text('Error loading data');
                            }

                            final data =
                                snapshot.data?.data() as Map<String, dynamic>?;
                            final createdAt = data?['createdAt'] as Timestamp?;

                            if (createdAt != null) {
                              return Text(
                                DateFormat(
                                  'MMMM d, yyyy',
                                ).format(createdAt.toDate()),
                              );
                            } else {
                              return const Text('Not available');
                            }
                          },
                        ),
                        leading: const Icon(Icons.cake_outlined),
                      ),

                      ListTile(
                        title: const Text('Points'),
                        subtitle: FutureBuilder<DocumentSnapshot>(
                          future:
                              _firestore
                                  .collection('users')
                                  .doc(_auth.currentUser!.uid)
                                  .get(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Text('Loading...');
                            }

                            if (snapshot.hasError) {
                              return const Text('Error loading data');
                            }

                            final data =
                                snapshot.data?.data() as Map<String, dynamic>?;
                            final points = data?['points'] ?? 0;

                            return Text(points.toString());
                          },
                        ),
                        leading: const Icon(Icons.emoji_events_outlined),
                      ),

                      ListTile(
                        title: const Text('Challenges Completed'),
                        subtitle: FutureBuilder<DocumentSnapshot>(
                          future:
                              _firestore
                                  .collection('users')
                                  .doc(_auth.currentUser!.uid)
                                  .get(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Text('Loading...');
                            }

                            if (snapshot.hasError) {
                              return const Text('Error loading data');
                            }

                            final data =
                                snapshot.data?.data() as Map<String, dynamic>?;
                            final challengesCompleted =
                                data?['challengesCompleted'] ?? 0;

                            return Text(challengesCompleted.toString());
                          },
                        ),
                        leading: const Icon(Icons.check_circle_outline),
                      ),

                      ListTile(
                        title: const Text('Change Password'),
                        subtitle: const Text('Update your account password'),
                        leading: const Icon(Icons.lock_outline),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Password change feature coming soon',
                              ),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 32),

                      if (_isEditing)
                        Column(
                          children: [
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _saveUserData,
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                ),
                                child:
                                    _isLoading
                                        ? const SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Colors.white,
                                          ),
                                        )
                                        : const Text('Save Changes'),
                              ),
                            ),
                            if (_profileModified)
                              const Padding(
                                padding: EdgeInsets.only(top: 8.0),
                                child: Text(
                                  'Your profile has been modified. Please save your changes.',
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
    );
  }
}
