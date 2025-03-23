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
      body: const Center(
        child: Text('Relax Page Content', style: TextStyle(fontSize: 20)),
      ),
    );
  }
}
