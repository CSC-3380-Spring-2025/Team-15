import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class RelaxPage extends StatefulWidget {
  const RelaxPage({super.key});

  @override
  State<RelaxPage> createState() => _RelaxPageState();
}

class _RelaxPageState extends State<RelaxPage> {
  final AudioPlayer _player = AudioPlayer();
  bool _isMuted = false;

  void _playSound(String url) async {
    await _player.stop();
    await _player.setVolume(_isMuted ? 0.0 : 1.0);
    await _player.play(UrlSource(url));
  }

  void _pauseSound() async {
    await _player.pause();
  }

  void _stopSound() async {
    await _player.stop();
  }

  void _toggleMute() async {
    setState(() {
      _isMuted = !_isMuted;
    });
    await _player.setVolume(_isMuted ? 0.0 : 1.0);
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
            // 🌿 Your original layout remains unchanged here...

            const Text(
              'Find your calm with these exercises.',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 24),
            // [Keep your anxiety relief, breathing, meditation sections as-is]

            const SizedBox(height: 32),

            // 🎵 New Section: Listen & Relax
            const Text(
              'Listen & Relax',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 16),

            ElevatedButton.icon(
              onPressed: () => _playSound(
                  'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3'),
              icon: const Icon(Icons.music_note),
              label: const Text(
                'Soothing Piano',
                style: TextStyle(fontFamily: 'Poppins'),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade50,
                foregroundColor: Colors.blue.shade700,
              ),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: () => _playSound(
                  'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3'),
              icon: const Icon(Icons.spa),
              label: const Text(
                'Ocean Waves',
                style: TextStyle(fontFamily: 'Poppins'),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal.shade50,
                foregroundColor: Colors.teal.shade700,
              ),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: () => _playSound(
                  'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3'),
              icon: const Icon(Icons.nature),
              label: const Text(
                'Forest Ambience',
                style: TextStyle(fontFamily: 'Poppins'),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade50,
                foregroundColor: Colors.green.shade700,
              ),
            ),
            const SizedBox(height: 16),

            // 🎛️ Controls
            const Text(
              'Playback Controls',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 12,
              children: [
                ElevatedButton.icon(
                  onPressed: _pauseSound,
                  icon: const Icon(Icons.pause),
                  label: const Text('Pause'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange.shade50,
                    foregroundColor: Colors.orange.shade700,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _stopSound,
                  icon: const Icon(Icons.stop),
                  label: const Text('Stop'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade50,
                    foregroundColor: Colors.red.shade700,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _toggleMute,
                  icon: Icon(_isMuted ? Icons.volume_off : Icons.volume_up),
                  label: Text(_isMuted ? 'Unmute' : 'Mute'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade200,
                    foregroundColor: Colors.grey.shade800,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}