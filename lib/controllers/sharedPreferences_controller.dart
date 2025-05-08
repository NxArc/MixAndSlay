import 'package:shared_preferences/shared_preferences.dart';

Future<void> resetSharedPreferences() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.clear(); // Clears all stored data in SharedPreferences
}