import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'pages/profile.dart';
import 'pages/relax.dart';
import 'pages/shop.dart';
import 'pages/user_login.dart';
import 'pages/home.dart';
import 'pages/friends.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const LoginPage(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  DateTime today = DateTime.now();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<Map<String, dynamic>> todayChallenges = [
    {"name": "🧘 Meditate", "completed": false, "points": 10},
    {"name": "✍ Journal", "completed": false, "points": 10},
    {"name": "🤔 Reflect", "completed": false, "points": 10},
    {"name": "💪 Physical Exercise", "completed": false, "points": 10},
  ];

  int _totalPoints = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await _loadTotalPoints();
    await _loadChallengesForDate(today);

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _loadTotalPoints() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final doc = await _firestore.collection('users').doc(user.uid).get();
        if (doc.exists && doc.data() != null) {
          setState(() {
            _totalPoints = doc.data()?['points'] ?? 0;
          });
        }
      }
    } catch (e) {
      print('Error loading points: $e');
    }
  }

  Future<void> _loadChallengesForDate(DateTime date) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        String dateString = "${date.year}-${date.month}-${date.day}";
        final doc =
            await _firestore
                .collection('users')
                .doc(user.uid)
                .collection('dailyChallenges')
                .doc(dateString)
                .get();

        if (doc.exists && doc.data() != null) {
          List<dynamic> challenges = doc.data()?['challenges'] ?? [];
          setState(() {
            todayChallenges = List<Map<String, dynamic>>.from(challenges);
          });
        }
      }
    } catch (e) {
      print('Error loading challenges: $e');
    }
  }

  int get dailyPoints => todayChallenges
      .where((c) => c["completed"])
      .fold<int>(0, (sum, c) => sum + (c["points"] as int));

  void toggleChallenge(int index) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final bool wasCompleted = todayChallenges[index]["completed"];
    final int challengePoints = todayChallenges[index]["points"] as int;

    setState(() {
      todayChallenges[index]["completed"] = !wasCompleted;
    });

    int pointChange = wasCompleted ? -challengePoints : challengePoints;
    setState(() {
      _totalPoints += pointChange;
    });

    try {
      String dateString = "${today.year}-${today.month}-${today.day}";
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('dailyChallenges')
          .doc(dateString)
          .set({'date': dateString, 'challenges': todayChallenges});

      await _firestore.collection('users').doc(user.uid).set({
        'points': _totalPoints,
      }, SetOptions(merge: true));
    } catch (e) {
      print('Error saving data: $e');
      setState(() {
        todayChallenges[index]["completed"] = wasCompleted;
        _totalPoints -= pointChange;
      });
    }
  }

  void changeDay(DateTime selectedDay) async {
    setState(() {
      today = selectedDay;
      _isLoading = true;
    });

    await _loadChallengesForDate(selectedDay);

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      _isLoading
          ? const Center(child: CircularProgressIndicator())
          : HomePage(
            today: today,
            challenges: todayChallenges,
            onToggle: toggleChallenge,
            onDaySelected: changeDay,
            points: _totalPoints,
          ),
      const RelaxPage(),
      const ShopPage(),
      const FriendsPage(),
      const ProfilePage(),
    ];

    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });

          if (index == 0) {
            _loadTotalPoints();
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.tag_faces), label: 'Relax'),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag_outlined),
            label: 'Shop',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.group), label: 'Friends'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
