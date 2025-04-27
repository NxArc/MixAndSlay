import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Controllers for email and password input fields
final TextEditingController emailController = TextEditingController();
final TextEditingController passwordController = TextEditingController();

// Sign in function using the Auth class for consistency
Future<void> signInwithEmailAndPassword() async {
  try {
    // Basic input validation
    if (emailController.text.trim().isEmpty) {
      throw Exception('Email cannot be empty');
    }
    if (passwordController.text.trim().isEmpty) {
      throw Exception('Password cannot be empty');
    }

    // Use the Auth class to handle the actual sign-in
    await Auth().signInwithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );
  } catch (e) {
    rethrow; // Pass the error up to be handled by the caller
  }
}

// Auth class to manage authentication logic
class Auth {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<void> signInwithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final response = await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );

    if (response.user == null) {
      throw Exception('Login failed: Invalid credentials');
    }
  }
}
