import 'package:flutter/material.dart';

class ProfileDetailsPage extends StatelessWidget {
  const ProfileDetailsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile Details')),
      body: const Center(
        child: Text('Include any profile details'),
      ),
    );
  }
}