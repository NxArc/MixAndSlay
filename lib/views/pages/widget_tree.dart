import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fasionrecommender/views/pages/homepage.dart';
import 'package:fasionrecommender/services/authenticate/login_page.dart';
import 'package:fasionrecommender/views/pages/onboarding_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({super.key});

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  Future<bool> _checkOnboardingStatus(String uid) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('hasSeenOnboarding_$uid') ?? false;
  }

  Future<void> _completeOnboarding(String uid) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasSeenOnboarding_$uid', true);
    setState(() {}); // Rebuild with updated onboarding status
  }




  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        final user = snapshot.data?.session?.user;

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (user == null) {
          return const LoginPage(); // Not signed in yet
        }

        return FutureBuilder<bool>(
          future: _checkOnboardingStatus(user.id),
          builder: (context, onboardingSnapshot) {
            if (!onboardingSnapshot.hasData) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }
            if (!onboardingSnapshot.data!) {
              return OnboardingPage(
                onFinish: () => _completeOnboarding(user.id),
              );
            }
            return Home(); // Signed in and onboarding complete
          },
        );
      },
    );
  }
}
