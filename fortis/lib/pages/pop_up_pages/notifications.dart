import 'package:flutter/material.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          Card(
            elevation: 3,
            child: ListTile(
              leading: Icon(Icons.mood, color: Colors.green),
              title: Text(
                'Keep going, you’re doing great!',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text('Your progress is inspiring.'),
            ),
          ),
        ],
      ),
    );
  }
}
