import 'package:flutter/material.dart';

class HelpCenterPage extends StatelessWidget {
  const HelpCenterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Help Center')),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Text(
            'Welcome to the Help Center!',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          const Text(
            'Fortis is a self-care help app where you can complete daily challenges to improve your well-being.',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 10),
          const Text(
            'Earn points by completing challenges and redeem them for rewards or items in the app.',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 20),
          const Text(
            'Here are some common topics to help you get started:',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 10),
          ListTile(
            title: const Text('Home'),
            subtitle: const Text('The Home page shows your calendar, daily challenges, and tracks your streaks.'),
            onTap: () {
              // Navigate to the Home section or show detailed help
            },
          ),
          ListTile(
            title: const Text('Relax'),
            subtitle: const Text('The Relax page provides various relaxation techniques such as breathing exercises and meditation to help you unwind.'),
            onTap: () {
              // Show how to use the Relax section
            },
          ),
          ListTile(
            title: const Text('Shop'),
            subtitle: const Text('The Shop allows you to purchase themes to personalize your app experience.'),
            onTap: () {
              // Explain how to use the Shop section
            },
          ),
          ListTile(
            title: const Text('Friends'),
            subtitle: const Text('The Friends page lets you view your friends list and add new friends for motivation and support.'),
            onTap: () {
              // Explain how to connect and interact with friends
            },
          ),
          ListTile(
            title: const Text('Profile'),
            subtitle: const Text('The Profile page displays your achievements, journal, and details about your personal progress.'),
            onTap: () {
              // Show how to manage the user's profile
            },
          ),
          const SizedBox(height: 20),
          const Text(
            'Frequently Asked Questions',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          ExpansionTile(
            title: const Text('How do I complete daily challenges?'),
            children: [
              const ListTile(
                title: Text(
                    'To complete daily challenges, go to the Home page where you will see a list of tasks for the day. Mark each challenge as completed when you finish it, and you will earn points.'),
              ),
            ],
          ),
          ExpansionTile(
            title: const Text('How can I earn more points?'),
            children: [
              const ListTile(
                title: Text(
                    'You can earn more points by completing daily challenges consistently.'),
              ),
            ],
          ),
          ExpansionTile(
            title: const Text('What is the Shop used for?'),
            children: [
              const ListTile(
                title: Text(
                    'The Shop allows you to purchase different themes that personalize the look and feel of the app. You can buy these using the points you\'ve earned.'),
              ),
            ],
          ),
          ExpansionTile(
            title: const Text('What can I see on my Profile page?'),
            children: [
              const ListTile(
                title: Text(
                    'Your Profile page shows your personal achievements, profile details, and your journal entries. It\'s a place to track your self-care journey.'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
