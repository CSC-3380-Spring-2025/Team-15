import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class HomePage extends StatelessWidget {
  final DateTime today;
  final List<Map<String, dynamic>> challenges;
  final int points;
  final void Function(int index) onToggle;
  final void Function(DateTime selectedDay) onDaySelected;
  final Map<DateTime, bool> completedDays;
  final int streak;

  const HomePage({
    super.key,
    required this.today,
    required this.challenges,
    required this.points,
    required this.onToggle,
    required this.onDaySelected,
    required this.completedDays,
    required this.streak,
  });

  @override
  Widget build(BuildContext context) {
    final bool isToday = isSameDay(today, DateTime.now());

    return Scaffold(
      appBar: AppBar(title: const Text('Welcome!'), centerTitle: true),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Text(
            "🔥 Current Streak: $streak Day${streak == 1 ? '' : 's'}",
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.orange,
            ),
          ),
          const SizedBox(height: 10),
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
            onDaySelected: (selectedDay, focusedDay) => onDaySelected(selectedDay),
            calendarBuilders: CalendarBuilders(
              defaultBuilder: (context, day, focusedDay) {
                final normalizedDay = DateTime(day.year, day.month, day.day);
                final isCompleted = completedDays[normalizedDay] ?? false;

                if (isCompleted) {
                  return Container(
                    margin: const EdgeInsets.all(6.0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${day.day}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }
                return null;
              },
              todayBuilder: (context, day, focusedDay) {
                final normalizedDay = DateTime(day.year, day.month, day.day);
                final isCompleted = completedDays[normalizedDay] ?? false;

                if (isCompleted) {
                  return Container(
                    margin: const EdgeInsets.all(6.0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${day.day}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }

                return Container(
                  margin: const EdgeInsets.all(6.0),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '${day.day}',
                    style: const TextStyle(color: Colors.white),
                  ),
                );
              },
              selectedBuilder: (context, day, focusedDay) {
                final normalizedDay = DateTime(day.year, day.month, day.day);
                final isCompleted = completedDays[normalizedDay] ?? false;
                final isToday = isSameDay(day, DateTime.now());

                Color backgroundColor;
                if (isCompleted) {
                  backgroundColor = Colors.green.shade700;
                } else if (isToday) {
                  backgroundColor = Colors.blueAccent;
                } else {
                  backgroundColor = Colors.orangeAccent;
                }

                return Container(
                  margin: const EdgeInsets.all(6.0),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '${day.day}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
            ),
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
              itemCount: challenges.length,
              itemBuilder: (context, index) {
                var challenge = challenges[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: Icon(
                      challenge["completed"]
                          ? Icons.check_circle
                          : Icons.circle_outlined,
                      color: challenge["completed"] ? Colors.green : Colors.grey,
                    ),
                    title: Text(
                      "${challenge["name"]} (+${challenge["points"]} pts)",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: challenge["completed"]
                            ? Colors.green
                            : (isToday ? Colors.black : Colors.grey),
                      ),
                    ),
                    onTap: () {
                      if (isToday) {
                        if (challenge['type'] == 'journal') {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("This challenge is completed by writing a journal entry."),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        } else {
                          onToggle(index);
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("You can only complete today's challenges!"),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      }
                    },
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
