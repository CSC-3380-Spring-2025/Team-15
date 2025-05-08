import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fortis/pages/relax.dart';

class GroundingExercisePage extends StatefulWidget {
  const GroundingExercisePage({Key? key}) : super(key: key);

  @override
  _GroundingExercisePageState createState() => _GroundingExercisePageState();
}

class _GroundingExercisePageState extends State<GroundingExercisePage> {
  final TextEditingController _answerController = TextEditingController();
  late final List<String> _prompts;
  int _stepIndex = 0;
  int? _initialRating;
  int? _finalRating;
  double _sliderValue = 5.0;

  final List<String> _questions = [
    'How many windows are in the room?',
    'How many electrical outlets do you see?',
    'What does the surface you are sitting/standing on feel like?',
    'What can you hear?',
    'What material is the floor made of? Is it smooth or bumpy? Dirty or clean?',
    'Name your favorite TV show.',
    'Name your favorite movie.',
    'Name your favorite color.',
    'What color is your shirt? What does the material feel like?',
    'As you breathe deeply, can you smell anything new? Is it pleasant?',
    'What color do you associate with calm? Can you see it here?',
    'Observe three different colors around you and name them.',
    'Describe the temperature of the room in one word.',
    'What is one object you can see that is blue?',
    'Can you touch something with a rough texture? Describe it.',
    'Hear the silence—what do you notice when you listen closely?',
    'Find a spot of natural light—what does it look like?',
    'Locate a scent that reminds you of a happy memory.',
  ];

  @override
  void initState() {
    super.initState();

    final rand = Random();
    final questions = List<String>.from(_questions)..shuffle(rand);
    final selected = questions.take(5).toList();

    _prompts = [
      'Please rate your anxiety (1-10):',
      '🧘‍♀️  Relax your body. Breathe deeply and slowly throughout the exercise.',
      ...selected,
      '🏁  Please rate your anxiety (1-10) again:',
    ];
  }

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }

  void _next() {
    final isRatingStep =
        _stepIndex == 0 || _stepIndex == _prompts.length - 1;

    if (isRatingStep) {
      final rating = _sliderValue.round();
      if (_stepIndex == 0) {
        _initialRating = rating;
      } else {
        _finalRating = rating;
      }
    }

    if (_stepIndex == _prompts.length - 1) {
      _handleCompletion();
      return;
    }

    setState(() {
      _stepIndex++;
      _answerController.clear();
      _sliderValue = 5.0;
    });
  }

  void _handleCompletion() {
    if (_finalRating != null &&
        _initialRating != null &&
        _finalRating! > _initialRating!) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Feeling Worse?'),
          content: const Text(
            'Your anxiety rating is higher now than at the start.\n'
            'Would you like to go through the exercise again?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                _restart();
              },
              child: const Text('Retry'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                Navigator.of(context).pop();
              },
              child: const Text('Done'),
            ),
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Well Done'),
          content: const Text('You have completed the grounding exercise.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const RelaxPage()),
                );
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  void _restart() {
    setState(() {
      _stepIndex = 0;
      _initialRating = null;
      _finalRating = null;
      _answerController.clear();
      _sliderValue = 5.0;

      final rand = Random();
      final questions = List<String>.from(_questions)..shuffle(rand);
      final selected = questions.take(5).toList();
      _prompts
        ..clear()
        ..addAll([
          'Please rate your anxiety (1–10):',
          '🧘‍♀️  Relax your body. Breathe deeply and slowly throughout the exercise.',
          ...selected,
          '🏁  Please rate your anxiety (1–10) again:',
        ]);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isInstructionStep = _stepIndex == 1;
    final isRatingStep =
        _stepIndex == 0 || _stepIndex == _prompts.length - 1;

    return Scaffold(
      appBar: AppBar(title: const Text('Grounding Exercise')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Prompt
            Text(
              _prompts[_stepIndex],
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 24),

            if (isInstructionStep) ...[],

            if (isRatingStep && !isInstructionStep) ...[
              Slider(
                value: _sliderValue,
                min: 1,
                max: 10,
                divisions: 9,
                label: _sliderValue.round().toString(),
                onChanged: (v) => setState(() => _sliderValue = v),
              ),
              const SizedBox(height: 24),
            ],

            if (!isInstructionStep && !isRatingStep) ...[
              TextField(
                controller: _answerController,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Type your answer here',
                ),
              ),
              const SizedBox(height: 24),
            ],

            ElevatedButton(
              onPressed: _next,
              child: Text(
                _stepIndex == _prompts.length - 1 ? 'Finish' : 'Next',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
