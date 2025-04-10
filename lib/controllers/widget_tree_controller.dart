import 'package:shared_preferences/shared_preferences.dart';

class WidgetTreeController {
  Future<bool> checkOnboardingStatus(String uid) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('hasSeenOnboarding_$uid') ?? false;
  }

  Future<void> completeOnboarding(String uid) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasSeenOnboarding_$uid', true);
  }
}