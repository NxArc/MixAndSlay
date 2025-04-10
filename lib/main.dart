import 'package:fasionrecommender/data/notifiers.dart';
import 'package:fasionrecommender/views/pages/widget_tree.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Import firebase_core

void main() {
  // Ensure Flutter bindings are initialized before Firebase
  WidgetsFlutterBinding.ensureInitialized();
  // Run the app with Firebase initialization
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  // Add a Future to track Firebase initialization
  late Future<void> _initializeFirebase;

  @override
  void initState() {
    super.initState();
    // Initialize Firebase
    _initializeFirebase = Firebase.initializeApp();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Wait for Firebase to initialize
      future: _initializeFirebase,
      builder: (context, snapshot) {
        // Check for errors during initialization
        if (snapshot.hasError) {
          return const MaterialApp(
            home: Scaffold(
              body: Center(
                child: Text('Error initializing Firebase'),
              ),
            ),
          );
        }

        // If Firebase is still initializing, show a loading screen
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MaterialApp(
            home: Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }
        // Once Firebase is initialized, proceed with the app
        return ValueListenableBuilder(
          valueListenable: isDarkModeNotifier,
          builder: (context, isDarkMode, child) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(
                  seedColor: Colors.teal,
                  brightness: isDarkMode ? Brightness.dark : Brightness.light, // Fixed the brightness logic
                ),
              ),
              home: const WidgetTree(),
            );
          },
        );
      },
    );
  }
}