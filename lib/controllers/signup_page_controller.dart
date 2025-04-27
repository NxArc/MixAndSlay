import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Controllers for signup email and password input fields
final TextEditingController signup_emailController = TextEditingController();
final TextEditingController signup_passwordController = TextEditingController();

String? errorMessage = '';
bool isLogin = true;

// Sign up function using the Auth class for consistency
Future<void> createUserWithEmailAndPassword() async {
  try {
    if (signup_emailController.text.trim().isEmpty) {
      throw Exception('Email cannot be empty');
    }
    if (signup_passwordController.text.trim().isEmpty) {
      throw Exception('Password cannot be empty');
    }

    await Auth().createUserWithEmailAndPassword(
      email: signup_emailController.text.trim(),
      password: signup_passwordController.text.trim(),
    );
  } catch (e) {
    errorMessage = e.toString(); // Capture the error message for UI display
    rethrow; // Also rethrow if needed
  }
}

// Auth class to manage signup and login
class Auth {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<void> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final response = await _supabase.auth.signUp(
      email: email,
      password: password,
    );

    if (response.user == null) {
      throw Exception('Signup failed: Please check your details.');
    }
  }

  Future<void> signInwithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final response = await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );

    if (response.user == null) {
      throw Exception('Login failed: Invalid credentials.');
    }
  }
}
