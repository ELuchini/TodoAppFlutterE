/*
import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isSignup = true; // Toggle between signup and login

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Authentication')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_isSignup) ...[
                // Signup form fields
                const TextField(decoration: InputDecoration(labelText: 'Email')),
                const TextField(
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                ),
                ElevatedButton(
                  onPressed: () {
                    // Handle signup logic

                  },
                  child: const Text('Sign Up'),
                ),
              ] else ...[
                // Login form fields
                const TextField(decoration: InputDecoration(labelText: 'Email')),
                const TextField(
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                ),
                ElevatedButton(
                  onPressed: () {
                    // Handle login logic
                  },
                  child: const Text('Login'),
                ),
              ],
              TextButton(
                onPressed: () {
                  setState(() {
                    _isSignup = !_isSignup;
                  });
                },
                child: Text(_isSignup
                    ? 'Already have an account? Login'
                    : 'Don\'t have an account? Signup'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
*/