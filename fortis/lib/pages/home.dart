import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Welcome!'), centerTitle: true),
      body: const Center(
        child: Text('Home Page Content', style: TextStyle(fontSize: 20)),
      ),
    );
  }
}
