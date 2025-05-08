import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BreathingExercisePage extends StatefulWidget {
  const BreathingExercisePage({super.key});

  @override
  _BreathingExercisePageState createState() => _BreathingExercisePageState();
}

class _BreathingExercisePageState extends State<BreathingExercisePage> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isPlaying = false;
  bool _pointsAwarded = false;
  static const int pointsReward = 20;

  @override
  void initState() {
    super.initState();

    _audioPlayer.onPlayerComplete.listen((_) {
      setState(() {
        _isPlaying = false;
      });

      _awardPoints();
    });
  }

  Future<void> _awardPoints() async {
    final user = _auth.currentUser;
    if (user != null && !_pointsAwarded) {
      try {
        final userDoc =
            await _firestore.collection('users').doc(user.uid).get();
        int currentPoints = 0;

        if (userDoc.exists) {
          currentPoints = userDoc.data()?['points'] ?? 0;
        }

        // Update points in Firestore
        await _firestore.collection('users').doc(user.uid).set({
          'points': currentPoints + pointsReward,
        }, SetOptions(merge: true));

        // Record this activity in the user's history
        String dateString =
            "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}";
        await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('activities')
            .add({
              'type': 'breathing_exercise',
              'points': pointsReward,
              'date': dateString,
              'timestamp': FieldValue.serverTimestamp(),
            });

        setState(() {
          _pointsAwarded = true;
        });

        // sHow completion dialog with points award, then navigate back
        _showCompletionDialog(true);
      } catch (e) {
        print('Error awarding points: $e');

        _showCompletionDialog(false);
      }
    } else {
      _showCompletionDialog(false);
    }
  }

  void _showCompletionDialog(bool pointsAwarded) {
    showDialog(
      context: context,
      barrierDismissible: false,
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
                'You\'ve completed the 4-7-8 breathing exercise. Take a moment to notice how you feel.',
                style: TextStyle(fontFamily: 'Poppins'),
              ),
              if (pointsAwarded) ...[
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber),
                    const SizedBox(width: 8),
                    Text(
                      '+$pointsReward points awarded!',
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Return to Relax',
                style: TextStyle(fontFamily: 'Poppins', color: Colors.blue),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
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
        setState(() {
          _pointsAwarded = false;
        });

        await _audioPlayer.play(AssetSource('4-7-8-breathing.mp3'));
        setState(() {
          _isPlaying = true;
        });
      }
    } catch (e) {
      print('Error playing audio: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to load audio guide')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '4-7-8 Breathing Exercise',
          style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '4-7-8 Breathing Technique',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                'Inhale for 4 seconds, hold for 7 seconds, exhale for 8 seconds. Repeat.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.star, color: Colors.amber),
                  SizedBox(width: 8),
                  Text(
                    'Complete to earn 20 points',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            IconButton(
              icon: Icon(
                _isPlaying ? Icons.pause_circle : Icons.play_circle,
                size: 100,
                color: Colors.blue,
              ),
              onPressed: _toggleAudio,
            ),
            const SizedBox(height: 20),
            Text(
              _isPlaying ? 'Pause Guide' : 'Start Guide',
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 18,
                color: Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
