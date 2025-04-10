import 'package:fasionrecommender/views/pages/authenticate/aunthenticate.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

final TextEditingController emailController = TextEditingController();
final TextEditingController passwordController = TextEditingController();
String? errorMessage = '';
bool isLogin = true;

Future<void> signInwithEmailAndPassword() async {
  try {
    await Auth().signInwithEmailAndPassword(
      email: emailController.text,
      password: passwordController.text,
    );
  } on FirebaseAuthException catch (e) {
    errorMessage = e.message;
  }
}