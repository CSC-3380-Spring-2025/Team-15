import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '/services/firebase_auth.dart';
import '/main.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
  }

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuthService _firebaseAuthService = FirebaseAuthService();

  void _signIn(String email, String password) async {
    User? user = await _firebaseAuthService.signInWithEmailAndPassword(email, password);

    if (!mounted) return;

    if (user != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Login failed, email or password is incorrect")),
      );
    }
  }

  void _toRegstrationPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RegistrationPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: CredentialsUI(
        title: 'Sign in',
        firstButtonText: 'Login',
        secondButtonText: 'Register',
        secondButtonTextNote: "Don't have an account?",
        onFirstButtonPress: (email, password) {
          _signIn(email, password);
        },
        onSecondButtonPress: _toRegstrationPage,
      ),
    );
  }
}

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage>{
  final FirebaseAuthService _firebaseAuthService = FirebaseAuthService();

  void _signUp(String email, String password) async {
    User? user = await _firebaseAuthService.signUpWithEmailAndPassword(email, password);

    if (!mounted) return;

    if (user != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Registration successful!")),
      );
      Navigator.pop(context); 
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to register, use an email or stronger password. (test message, change later)")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: CredentialsUI(
        title: 'Register',
        firstButtonText: 'Register',
        secondButtonText: 'Login',
        secondButtonTextNote: "Already have an account?",
        onFirstButtonPress: (email, password) {
          _signUp(email, password);
        },
        onSecondButtonPress: () {
          Navigator.pop(context); 
        },
      ),
    );
  }
}

class CredentialsUI extends StatefulWidget {
  final String title;
  final String firstButtonText;
  final String secondButtonText;
  final void Function(String email, String password) onFirstButtonPress;
  final VoidCallback onSecondButtonPress;
  final String? secondButtonTextNote;

  const CredentialsUI({
    required this.title,
    required this.firstButtonText,
    required this.secondButtonText,
    required this.onFirstButtonPress,
    required this.onSecondButtonPress,
    this.secondButtonTextNote,
    super.key
  });

  @override
  State<CredentialsUI> createState() => _CredentialsUIState();
}

class _CredentialsUIState extends State<CredentialsUI> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String get email => _emailController.text;
  String get password => _passwordController.text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: ListView(
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(10),
            child: const Text(
              'Fortis', 
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: 30,
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(10),
            child: Text(
              widget.title,
              style: const TextStyle(fontSize: 20),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Email',
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: TextField(
              obscureText: true,
              controller: _passwordController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password',
              ),
            ),
          ),
          Container(
            height: 50,
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: ElevatedButton(
              onPressed: () {
                widget.onFirstButtonPress(email, password);
              },
              child: Text(widget.firstButtonText),
            ),
          ),
          if (widget.secondButtonTextNote != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(widget.secondButtonTextNote!),
                TextButton(
                  onPressed: widget.onSecondButtonPress,
                  child: Text(
                    widget.secondButtonText,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}