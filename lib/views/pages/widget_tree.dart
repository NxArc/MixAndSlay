import 'package:fasionrecommender/views/pages/authenticate/aunthenticate.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fasionrecommender/views/pages/home/homepage.dart';
import 'package:fasionrecommender/views/pages/authenticate/login_page.dart';
import 'package:fasionrecommender/views/pages/onboarding_page.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({super.key});

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  Future<bool> _checkOnboardingStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('hasSeenOnboarding') ?? false;
  }

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasSeenOnboarding', true);
    setState(() {}); // Refresh the widget tree
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      
      future: _checkOnboardingStatus(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (!snapshot.data!) {
          return OnboardingPage(onFinish: _completeOnboarding);
        }


        return StreamBuilder(
          stream: Auth().authStateChanges,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Home();
            } else {
              return const LoginPage();
            }
          },
        );
      },
    );
  }
}
