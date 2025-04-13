import 'package:flutter/material.dart';

class HelpCenterPage extends StatelessWidget {
  const HelpCenterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Help Center')),
      body: const Center(
        child: Text('Help Center page'),
      ),
    );
  }
}