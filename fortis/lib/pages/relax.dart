import 'package:flutter/material.dart';
import 'dart:async';

class BreathingExercise extends StatefulWidget {
  const BreathingExercise({super.key});

  @override
  State<BreathingExercise> createState() => _BreathingExerciseState();
}

class _BreathingExerciseState extends State<BreathingExercise> {
  int _remainingSeconds = 60;
  Timer? _timer;

  // Start the timer if it's not already running
  void _startTimer() {
    if (_timer != null) return;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds == 0) {
        timer.cancel();
        _timer = null;
      } else {
        setState(() {
          _remainingSeconds--;
        });
      }
    });
  }

  // Resets the timer to 60 seconds
  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _remainingSeconds = 60;
      _timer = null;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Breathing Exercise',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text(
          'Take 1 minute to focus on your deep breathing. Tap "Start" to begin.',
          style: TextStyle(fontSize: 18),
        ),
        const SizedBox(height: 16),
        Center(
          child: Text(
            '$_remainingSeconds s',
            style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _startTimer,
              child: const Text('Start'),
            ),
            const SizedBox(width: 16),
            ElevatedButton(
              onPressed: _resetTimer,
              child: const Text('Reset'),
            ),
          ],
        ),
      ],
    );
  }
}

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
            const SizedBox(height: 24),
            // Insert the BreathingExercise widget
            const BreathingExercise(),
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
*/

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
