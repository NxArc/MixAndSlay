import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

final TextEditingController signup_emailController = TextEditingController();
final TextEditingController signup_passwordController = TextEditingController();
String? errorMessage = '';
bool isLogin = true;

// Assuming Auth class is defined somewhere else in your project
final FirebaseAuth _auth = FirebaseAuth.instance;

Future<void> createUserWithEmailAndPassword() async {
  try {
    await _auth.createUserWithEmailAndPassword(
      email: signup_emailController.text,
      password: signup_passwordController.text,
    );
    // Handle success (e.g., navigate to home screen)
  } on FirebaseAuthException catch (e) {
    errorMessage = e.message;
  }
}
