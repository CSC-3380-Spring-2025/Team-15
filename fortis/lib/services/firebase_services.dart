// In the services/firebase_services.dart file
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get current user ID
  String? get currentUserId => _auth.currentUser?.uid;

  // Save points and challenges
  Future<void> saveUserChallenges(
    DateTime date,
    List<Map<String, dynamic>> challenges,
    int totalPoints,
  ) async {
    if (currentUserId == null) return;

    String dateString = "${date.year}-${date.month}-${date.day}";

    // Save challenges for the day
    await _firestore
        .collection('users')
        .doc(currentUserId)
        .collection('dailyChallenges')
        .doc(dateString)
        .set({'date': dateString, 'challenges': challenges});

    // Update total points
    await _firestore.collection('users').doc(currentUserId).set({
      'points': totalPoints,
    }, SetOptions(merge: true));
  }

  // Get challenges for a specific date
  Future<List<Map<String, dynamic>>> getChallengesForDate(DateTime date) async {
    if (currentUserId == null) return [];

    String dateString = "${date.year}-${date.month}-${date.day}";

    DocumentSnapshot doc =
        await _firestore
            .collection('users')
            .doc(currentUserId)
            .collection('dailyChallenges')
            .doc(dateString)
            .get();

    if (doc.exists && doc.data() != null) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return (data['challenges'] as List).cast<Map<String, dynamic>>();
    }

    // Return default challenges if none found for this date
    return [
      {"name": "🧘 Meditate", "completed": false, "points": 10},
      {"name": "✍ Journal", "completed": false, "points": 10},
      {"name": "🤔 Reflect", "completed": false, "points": 10},
      {"name": "💪 Physical Exercise", "completed": false, "points": 10},
    ];
  }

  // Get total user points
  Future<int> getTotalPoints() async {
    if (currentUserId == null) return 0;

    DocumentSnapshot doc =
        await _firestore.collection('users').doc(currentUserId).get();

    if (doc.exists && doc.data() != null) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return data['points'] ?? 0;
    }

    return 0;
  }
}
