import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:fortis/globals.dart';

class HomePage extends StatelessWidget {
  final DateTime today;
  final List<Map<String, dynamic>> challenges;
  final int points;
  final void Function(int index) onToggle;
  final void Function(DateTime selectedDay) onDaySelected;

  const HomePage({
    Key? key,
    required this.today,
    required this.challenges,
    required this.points,
    required this.onToggle,
    required this.onDaySelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return ValueListenableBuilder<Color>(
      valueListenable: globalBgColor,
      builder: (context, bgColor, _) {
        return Scaffold(
          backgroundColor: bgColor,
          appBar: AppBar(
            backgroundColor: bgColor,
            title: const Text('Welcome!'),
            centerTitle: true,
          ),

          body: Container(
            color: bgColor,
            child: Column(
              children: [
                const SizedBox(height: 20),
                Text(
                  "Selected Date: ${today.toLocal()}".split(' ')[0],
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TableCalendar(
                  rowHeight: 40,
                  headerStyle:
                      const HeaderStyle(formatButtonVisible: false),
                  focusedDay: today,
                  firstDay: DateTime.utc(2010, 1, 1),
                  lastDay: DateTime.utc(2030, 12, 31),
                  selectedDayPredicate: (day) => isSameDay(today, day),
                  onDaySelected: (selectedDay, focusedDay) =>
                      onDaySelected(selectedDay),
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
                  style:
                      TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemCount: challenges.length,
                    itemBuilder: (context, index) {
                      final challenge = challenges[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          leading: Icon(
                            challenge["completed"]
                                ? Icons.check_circle
                                : Icons.circle_outlined,
                            color: challenge["completed"]
                                ? Colors.green
                                : Colors.grey,
                          ),
                          title: Text(
                            "${challenge["name"]} (+${challenge["points"]} pts)",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: challenge["completed"]
                                  ? Colors.green
                                  : Colors.black,
                            ),
                          ),
                          onTap: () {
                            onToggle(index);
                            // Add navigation for verification
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
