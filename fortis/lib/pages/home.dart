import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      today = selectedDay;
    });
  }

  void _toggleChallenge(int index) {
    setState(() {
      todayChallenges[index]["completed"] =
          !todayChallenges[index]["completed"];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Welcome!'), centerTitle: true),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Text(
            "Selected Date: ${today.toLocal()}".split(' ')[0],
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          TableCalendar(
            rowHeight: 40,
            headerStyle: const HeaderStyle(formatButtonVisible: false),
            focusedDay: today,
            firstDay: DateTime.utc(2010, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            selectedDayPredicate: (day) => isSameDay(today, day),
            onDaySelected: _onDaySelected,
          ),
          const SizedBox(height: 20),
          Text(
            "🏆 Points: $points",
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            "✅ Today's Challenges",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: todayChallenges.length,
              itemBuilder: (context, index) {
                var challenge = todayChallenges[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: Icon(
                      challenge["completed"]
                          ? Icons.check_circle
                          : Icons.circle_outlined,
                      color:
                          challenge["completed"] ? Colors.green : Colors.grey,
                    ),
                    title: Text(
                      "${challenge["name"]} (+${challenge["points"]} pts)",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color:
                            challenge["completed"]
                                ? Colors.green
                                : Colors.black,
                      ),
                    ),
                    onTap: () => _toggleChallenge(index),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
