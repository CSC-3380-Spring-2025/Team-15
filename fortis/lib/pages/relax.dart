import 'package:flutter/material.dart';

class RelaxPage extends StatelessWidget {
  const RelaxPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Take a Moment to Relax'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Relax Page Content',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 24),
            const Text(
              'Anxiety Grounding Questions',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              '1. What can you see around you right now?',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            const Text(
              '2. What are three things that you feel at the moment?',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            const Text(
              "3. What are some of the things you're hearing?",
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            const Text(
              "4. What's causing your anxiety right now?",
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}

/*import 'package:flutter/material.dart';

class RelaxPage extends StatelessWidget {
  const RelaxPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Take a Moment to Relax'), centerTitle: true),
      body: const Center(
        child: Text(
          'Relax Page Content',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
*/
