import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
// Assuming you have an Auth service file with Auth().currentUser and signOut() methods.
// Get the current user from Supabase
final user = Supabase.instance.client.auth.currentUser;

// Request location permission and get current position
Future<Position> getCurrentLocation() async {
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    throw Exception('Location services are disabled.');
  }

  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      throw Exception('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    throw Exception('Location permissions are permanently denied.');
  }

  return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
}

// Fetch temperature using OpenWeatherMap API
Future<String> getTemperature(double latitude, double longitude) async {
  final String apiKey = '580980c95268fc1878fa6db4455c3d40'; // Replace with your real API key
  final String url =
      'https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&units=metric&appid=$apiKey';

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final jsonData = jsonDecode(response.body);
    final temperature = jsonData['main']['temp'];
    return temperature.toString(); // Celsius
  } else {
    throw Exception('Failed to load temperature');
  }
}
