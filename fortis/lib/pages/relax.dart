import 'package:flutter/material.dart';
import 'package:fortis/pages/pop_up_pages/body_scan.dart';
import 'package:fortis/pages/pop_up_pages/box-breathing.dart';
import 'package:fortis/pages/pop_up_pages/deep-breathing.dart';
import 'pop_up_pages/breathing_exercise_page.dart';
import 'pop_up_pages/beach_waves.dart';
import 'pop_up_pages/grounding_exercise.dart';
// Import journal page
import 'package:fortis/pages/my_journals_page.dart'; // Adjust the import path as necessary

// Convert to StatefulWidget to properly handle state changes
class RelaxPage extends StatefulWidget {
  const RelaxPage({super.key});

  @override
  State<RelaxPage> createState() => _RelaxPageState();
}

class _RelaxPageState extends State<RelaxPage> {
  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // This triggers when the page is revisited
    _refreshData();
  }

  void _refreshData() {
    // Find the parent MainScreen state and refresh points
    // Note: You'll need to ensure your MainScreen widget exists and has the proper state
    final mainScreenState = context.findAncestorStateOfType<MainScreenState>();
    if (mainScreenState != null) {
      mainScreenState.loadTotalPoints();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Take a Moment to Relax',
          style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Find your calm with these exercises.',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 24),

            // Journal Section - NEW ADDITION
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MyJournalsPage(),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.amber.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.amber.shade200, width: 1),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.amber.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.book, color: Colors.amber),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Journal Your Thoughts',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            'Express your feelings and track your progress',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              color: Colors.black54,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.amber,
                      size: 18,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Anxiety Relief Section
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const GroundingExercisePage(),
                  ),
                );
              },
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.favorite, color: Colors.blue),
                  ),
                  const SizedBox(width: 12),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Anxiety Relief',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'Quick grounding',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.black54,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Calming Sounds Section
            GestureDetector(
              onTap: () {
                // Add navigation to a calming sounds page
                print('Calming Sounds tapped!');
                // Will add functionality here
              },
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.purple.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.music_note, color: Colors.purple),
                  ),
                  const SizedBox(width: 12),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Calming Sounds',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'Ambient music',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.black54,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Breathing Exercises Section
            const Text(
              'Breathing Exercises',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 16),

            // 4-7-8 Breathing
            _buildExerciseCard(
              title: '4-7-8 Breathing',
              duration: '5 mins',
              sessions: '12 times',
              icon: Icons.air,
              color: Colors.green.shade100,
              iconColor: Colors.green,
              onIconTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BreathingExercisePage(),
                  ),
                );
              },
            ),

            const SizedBox(height: 12),

            // Box Breathing
            _buildExerciseCard(
              title: 'Box Breathing',
              duration: '5 mins',
              sessions: '8 times',
              icon: Icons.crop_square,
              color: Colors.blue.shade100,
              iconColor: Colors.blue,
              onIconTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BoxBreathingPage()),
                );
              },
            ),

            const SizedBox(height: 12),

            // Deep Breath
            _buildExerciseCard(
              title: 'Deep Breath',
              duration: '6 mins',
              sessions: '10 times',
              icon: Icons.health_and_safety,
              color: Colors.orange.shade100,
              iconColor: Colors.orange,
              onIconTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DeepBreathPage()),
                );
              },
            ),

            const SizedBox(height: 24),

            // Meditation Section
            const Text(
              'Meditation',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 16),

            // Body Scan
            _buildExerciseCard(
              title: 'Body Scan',
              duration: '10 mins',
              sessions: '6 times',
              icon: Icons.self_improvement,
              color: Colors.purple.shade100,
              iconColor: Colors.purple,
              onIconTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BodyScanPage()),
                );
              },
            ),

            const SizedBox(height: 12),

            // Mindful Minutes
            _buildExerciseCard(
              title: 'Mindful Minutes',
              duration: '5 mins',
              sessions: '25 times',
              icon: Icons.watch_later,
              color: Colors.teal.shade100,
              iconColor: Colors.teal,
              onIconTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BodyScanPage()),
                );
              },
            ),

            const SizedBox(height: 24),

            // Sleep Stories Section
            const Text(
              'Sleep Stories',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 16),

            // Sleep Story
            _buildExerciseCard(
              title: 'Beach Waves',
              duration: '10 mins',
              sessions: '4 times',
              icon: Icons.nightlight,
              color: Colors.indigo.shade100,
              iconColor: Colors.indigo,
              onIconTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BeachWavesPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExerciseCard({
    required String title,
    required String duration,
    required String sessions,
    required IconData icon,
    required Color color,
    required Color iconColor,
    VoidCallback? onIconTap,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          // Left side (just an icon for display, no tap functionality)
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: iconColor),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.timer_outlined,
                      size: 14,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      duration,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Icon(Icons.repeat, size: 14, color: Colors.grey.shade600),
                    const SizedBox(width: 4),
                    Text(
                      sessions,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Play button with GestureDetector for onTap functionality
          GestureDetector(
            onTap: onIconTap,
            child: const Icon(
              Icons.play_circle_fill,
              color: Colors.blue,
              size: 36,
            ),
          ),
        ],
      ),
    );
  }
}

// Placeholder for the MainScreen state class that needs to be defined elsewhere
class MainScreenState extends State<MainScreen> {
  void loadTotalPoints() {
    // Implementation for loading total points
  }

  @override
  Widget build(BuildContext context) {
    // Implementation needed
    return Container();
  }
}

// Placeholder for the MainScreen widget
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  MainScreenState createState() => MainScreenState();
}
