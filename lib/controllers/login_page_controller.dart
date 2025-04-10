import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Avoid global controllers if possible; manage them in a widget or state management solution
final TextEditingController emailController = TextEditingController();
final TextEditingController passwordController = TextEditingController();

Future<void> signInwithEmailAndPassword() async {
  try {
    // Basic input validation
    if (emailController.text.trim().isEmpty) {
      throw Exception('Email cannot be empty');
    }
    if (passwordController.text.trim().isEmpty) {
      throw Exception('Password cannot be empty');
    }

    // Call the authentication method
    await Auth().signInwithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );

    // If no exception is thrown, login is successful
  } on FirebaseAuthException catch (e) {
    // Re-throw the exception with a meaningful message so the UI can handle it
    switch (e.code) {
      case 'user-not-found':
        throw Exception('No account found with this email.');
      case 'wrong-password':
        throw Exception('Incorrect password. Please try again.');
      case 'invalid-email':
        throw Exception('Invalid email format.');
      case 'user-disabled':
        throw Exception('This account has been disabled.');
      default:
        throw Exception('Login failed: ${e.message}');
    }
  } catch (e) {
    // Re-throw any other unexpected errors
    rethrow;
  }
}

// Optional: Verify the Auth class implementation
class Auth {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> signInwithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }
}