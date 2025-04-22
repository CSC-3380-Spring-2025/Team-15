import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BoxBreathingPage extends StatefulWidget {
  const BoxBreathingPage({super.key});

  @override
  State<BoxBreathingPage> createState() => _BoxBreathingPageState();
}

class _BoxBreathingPageState extends State<BoxBreathingPage> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isPlaying = false;
  bool _pointsAwarded = false;

  @override
  void initState() {
    super.initState();

    // Listen for when the audio completes
    _audioPlayer.onPlayerComplete.listen((_) {
      setState(() {
        _isPlaying = false;
      });

      // Award points and show completion dialog
      _awardPoints();
      _showCompletionDialog();
    });
  }

  Future<void> _awardPoints() async {
    // Don't award points if already awarded for this session
    if (_pointsAwarded) return;

    final user = _auth.currentUser;
    if (user == null) return;

    try {
      // Get current points
      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      int currentPoints = userDoc.data()?['points'] ?? 0;

      // Add 20 points
      int newPoints = currentPoints + 20;

      // Update points in Firestore
      await _firestore.collection('users').doc(user.uid).set({
        'points': newPoints,
      }, SetOptions(merge: true));

      // Mark points as awarded to prevent duplicate awards
      setState(() {
        _pointsAwarded = true;
      });

      // Also update today's challenge if there's a meditation challenge
      await _updateMeditationChallenge();
    } catch (e) {
      print('Error awarding points: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update points')),
        );
      }
    }
  }

  Future<void> _updateMeditationChallenge() async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      DateTime today = DateTime.now();
      String dateString = "${today.year}-${today.month}-${today.day}";

      final challengeDoc =
          await _firestore
              .collection('users')
              .doc(user.uid)
              .collection('dailyChallenges')
              .doc(dateString)
              .get();

      if (challengeDoc.exists) {
        List<dynamic> challenges = challengeDoc.data()?['challenges'] ?? [];
        List<Map<String, dynamic>> todayChallenges =
            List<Map<String, dynamic>>.from(challenges);

        // Find meditation challenge index
        int meditationIndex = todayChallenges.indexWhere(
          (c) => c['name'].toString().contains('Meditate') && !c['completed'],
        );

        // If found and not completed, mark it as completed
        if (meditationIndex != -1) {
          todayChallenges[meditationIndex]['completed'] = true;

          await _firestore
              .collection('users')
              .doc(user.uid)
              .collection('dailyChallenges')
              .doc(dateString)
              .update({'challenges': todayChallenges});
        }
      }
    } catch (e) {
      print('Error updating meditation challenge: $e');
    }
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Great Job!',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'You\'ve completed the Box Breathing exercise. Take a moment to notice how you feel.',
                style: TextStyle(fontFamily: 'Poppins'),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Icon(Icons.star, color: Colors.amber, size: 24),
                  const SizedBox(width: 8),
                  const Text(
                    '+20 points earned!',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Return to Relax',
                style: TextStyle(fontFamily: 'Poppins', color: Colors.blue),
              ),
              onPressed: () {
                // Close dialog and return to previous screen
                Navigator.of(context).pop(); // Close dialog
                Navigator.of(context).pop(); // Return to relax page
              },
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _toggleAudio() async {
    try {
      if (_isPlaying) {
        await _audioPlayer.pause();
        setState(() {
          _isPlaying = false;
        });
      } else {
        await _audioPlayer.play(AssetSource('box-breathing.mp3'));
        setState(() {
          _isPlaying = true;
          // Reset points awarded flag when starting new session
          _pointsAwarded = false;
        });
      }
    } catch (e) {
      print('Error playing audio: $e');
      // Show a user-friendly error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Unable to load audio guide')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Box Breathing Exercise',
          style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              // Image or illustration could go here
              Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                  color: Colors.blue.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.crop_square,
                  size: 100,
                  color: Colors.blue.shade700,
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                'Box Breathing',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                child: Text(
                  'Inhale for 4 seconds, hold for 4 seconds, exhale for 4 seconds, hold for 4 seconds. Repeat.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.amber.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.amber.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.stars, color: Colors.amber, size: 24),
                    const SizedBox(width: 8),
                    const Text(
                      'Complete this exercise to earn 20 points!',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                'Benefits:',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              _buildBenefitItem('Reduces stress and anxiety'),
              _buildBenefitItem('Improves focus and concentration'),
              _buildBenefitItem('Helps regulate emotions'),
              _buildBenefitItem('Can lower blood pressure'),
              const SizedBox(height: 40),
              ElevatedButton.icon(
                onPressed: _toggleAudio,
                icon: Icon(
                  _isPlaying ? Icons.pause_circle : Icons.play_circle,
                  size: 28,
                ),
                label: Text(
                  _isPlaying ? 'Pause Guide' : 'Start Audio Guide',
                  style: const TextStyle(fontFamily: 'Poppins', fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              _buildInstructionsPanel(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBenefitItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 24.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_circle, size: 20, color: Colors.green.shade600),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInstructionsPanel() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'How to Practice:',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12),
          Text(
            '1. Find a comfortable seated position',
            style: TextStyle(fontFamily: 'Poppins'),
          ),
          SizedBox(height: 8),
          Text(
            '2. Inhale through your nose for 4 seconds',
            style: TextStyle(fontFamily: 'Poppins'),
          ),
          SizedBox(height: 8),
          Text(
            '3. Hold your breath for 4 seconds',
            style: TextStyle(fontFamily: 'Poppins'),
          ),
          SizedBox(height: 8),
          Text(
            '4. Exhale through your mouth for 4 seconds',
            style: TextStyle(fontFamily: 'Poppins'),
          ),
          SizedBox(height: 8),
          Text(
            '5. Hold your breath for 4 seconds',
            style: TextStyle(fontFamily: 'Poppins'),
          ),
          SizedBox(height: 8),
          Text(
            '6. Repeat for 5-10 minutes',
            style: TextStyle(fontFamily: 'Poppins'),
          ),
        ],
      ),
    );
  }
}
