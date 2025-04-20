import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'pages/profile.dart';
import 'pages/relax.dart';
import 'pages/shop.dart';
import 'pages/user_login.dart';
import 'pages/home.dart'; // Updated version of HomePage below

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

  final List<Map<String, dynamic>> todayChallenges = [
    {"name": "🧘 Meditate", "completed": false, "points": 10},
    {"name": "✍ Journal", "completed": false, "points": 10},
    {"name": "🤔 Reflect", "completed": false, "points": 10},
    {"name": "💪 Physical Exercise", "completed": false, "points": 10},
  ];

  int get points => todayChallenges
      .where((c) => c["completed"])
      .fold<int>(0, (sum, c) => sum + (c["points"] as int));

  void toggleChallenge(int index) {
    setState(() {
      todayChallenges[index]["completed"] =
          !todayChallenges[index]["completed"];
    });
  }

  void changeDay(DateTime selectedDay) {
    setState(() {
      today = selectedDay;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      HomePage(
        today: today,
        challenges: todayChallenges,
        onToggle: toggleChallenge,
        onDaySelected: changeDay,
        points: points,
      ),
      const RelaxPage(),
      const ShopPage(),
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
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.tag_faces), label: 'Relax'),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag_outlined),
            label: 'Shop',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
