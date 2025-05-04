import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class JournalEntry {
  final String id;
  final String title;
  final String content;
  final DateTime createdAt;

  JournalEntry({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
  });
}

class MyJournalsPage extends StatefulWidget {
  const MyJournalsPage({super.key});

  @override
  _MyJournalsPageState createState() => _MyJournalsPageState();
}

class _MyJournalsPageState extends State<MyJournalsPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<QuerySnapshot>? _journalStream() {
    final user = _auth.currentUser;
    if (user != null) {
      return _firestore
          .collection('users')
          .doc(user.uid)
          .collection('journalEntries')
          .orderBy('createdAt', descending: true)
          .snapshots();
    }
    return null;
  }

  void _onNewEntry() {
    if (_auth.currentUser != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const NewJournalEntryPage()),
      );
    } else {
      _showSignInPrompt();
    }
  }

  void _showSignInPrompt() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Sign In Required', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold)),
          content: const Text('You need to sign in to create or view journal entries.', style: TextStyle(fontFamily: 'Poppins')),
          actions: [
            TextButton(
              child: const Text('OK', style: TextStyle(fontFamily: 'Poppins')),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        );
      },
    );
  }

  void _onViewEntry(JournalEntry entry) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => JournalDetailPage(entry: entry)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('My Journals', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600))),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Please sign in to view your journals', style: TextStyle(fontFamily: 'Poppins', fontSize: 16)),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {}, // Implement sign-in logic
                child: const Text('Sign In', style: TextStyle(fontFamily: 'Poppins')),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Journals', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600)),
        actions: [
          IconButton(icon: const Icon(Icons.add), tooltip: 'New Entry', onPressed: _onNewEntry),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: _journalStream(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(
                child: Text(
                  'No journal entries yet.\nTap the "+" button to create one.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontFamily: 'Poppins'),
                ),
              );
            }

            List<JournalEntry> entries = snapshot.data!.docs.map((doc) {
              final data = doc.data() as Map<String, dynamic>;
              return JournalEntry(
                id: doc.id,
                title: data['title'] ?? '',
                content: data['content'] ?? '',
                createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
              );
            }).toList();

            return ListView.separated(
              itemCount: entries.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final entry = entries[index];
                return ListTile(
                  title: Text(entry.title, style: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w500)),
                  subtitle: Text('${entry.createdAt.day}/${entry.createdAt.month}/${entry.createdAt.year}', style: const TextStyle(fontFamily: 'Poppins')),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _onViewEntry(entry),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onNewEntry,
        tooltip: 'New Entry',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class NewJournalEntryPage extends StatefulWidget {
  const NewJournalEntryPage({super.key});

  @override
  _NewJournalEntryPageState createState() => _NewJournalEntryPageState();
}

class _NewJournalEntryPageState extends State<NewJournalEntryPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  bool _isSaving = false;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  static const int pointsReward = 15;

  Future<void> _saveEntry() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSaving = true);

      final user = _auth.currentUser;
      if (user == null) {
        setState(() => _isSaving = false);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('You need to be signed in to save entries')));
        return;
      }

      try {
        await _firestore.collection('users').doc(user.uid).collection('journalEntries').add({
          'title': _titleController.text,
          'content': _contentController.text,
          'createdAt': FieldValue.serverTimestamp(),
        });

        final userDoc = await _firestore.collection('users').doc(user.uid).get();
        int currentPoints = userDoc.exists ? (userDoc.data()?['points'] ?? 0) : 0;

        await _firestore.collection('users').doc(user.uid).set({
          'points': currentPoints + pointsReward,
        }, SetOptions(merge: true));

        final now = DateTime.now();
        final dateString = "${now.year}-${now.month}-${now.day}";
        await _firestore.collection('users').doc(user.uid).collection('activities').add({
          'type': 'journal_entry',
          'points': pointsReward,
          'date': dateString,
          'timestamp': FieldValue.serverTimestamp(),
        });

        // Mark the journal challenge complete
        try {
          final challengesRef = _firestore
              .collection('users')
              .doc(user.uid)
              .collection('dailyChallenges')
              .doc(dateString);

          final doc = await challengesRef.get();
          if (doc.exists) {
            List<dynamic> challenges = doc.data()?['challenges'] ?? [];
            bool updated = false;

            for (var challenge in challenges) {
              if ((challenge['name'] as String).contains('Journal') || challenge['type'] == 'journal') {
                if (!(challenge['completed'] as bool)) {
                  challenge['completed'] = true;
                  updated = true;
                }
              }
            }

            if (updated) {
              bool allCompleted = challenges.every((c) => c['completed'] == true);
              await challengesRef.set({
                'challenges': challenges,
                'dayCompleted': allCompleted,
                'date': dateString,
              });
            }
          }
        } catch (e) {
          print('Failed to update journal challenge: \$e');
        }

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Journal Entry Saved!'),
                    Text('+$pointsReward points earned', style: const TextStyle(fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
          duration: const Duration(seconds: 3),
          backgroundColor: Colors.green,
        ));

        Navigator.of(context).pop();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error: Please try again')));
      } finally {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Journal Entry', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600))),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.star, color: Colors.amber),
                    SizedBox(width: 8),
                    Text('Complete to earn 15 points', style: TextStyle(fontFamily: 'Poppins', fontSize: 14, color: Colors.blue)),
                  ],
                ),
              ),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                  labelStyle: TextStyle(fontFamily: 'Poppins'),
                ),
                style: const TextStyle(fontFamily: 'Poppins'),
                validator: (value) => (value == null || value.trim().isEmpty) ? 'Please enter a title' : null,
              ),
              const SizedBox(height: 16),
              Expanded(
                child: TextFormField(
                  controller: _contentController,
                  decoration: const InputDecoration(
                    labelText: 'Content',
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true,
                    labelStyle: TextStyle(fontFamily: 'Poppins'),
                  ),
                  style: const TextStyle(fontFamily: 'Poppins'),
                  maxLines: null,
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
                  validator: (value) => (value == null || value.trim().isEmpty) ? 'Please enter some content' : null,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isSaving ? null : _saveEntry,
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 12)),
                child: _isSaving
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Text('Save Entry', style: TextStyle(fontFamily: 'Poppins', fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class JournalDetailPage extends StatelessWidget {
  final JournalEntry entry;
  const JournalDetailPage({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(entry.title, style: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Created on: ${entry.createdAt.day}/${entry.createdAt.month}/${entry.createdAt.year}',
              style: TextStyle(fontFamily: 'Poppins', fontSize: 12, color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),
            Text(
              entry.content,
              style: const TextStyle(fontFamily: 'Poppins', fontSize: 16, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}
