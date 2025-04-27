import 'package:fasionrecommender/data/notifiers.dart';
import 'package:fasionrecommender/services/storage/storage.dart';
import 'package:fasionrecommender/views/pages/widget_tree.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase
  await Supabase.initialize(
    url: 'https://dqderqwpilsitwnbvjhj.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRxZGVycXdwaWxzaXR3bmJ2amhqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDU3MzY1MzEsImV4cCI6MjA2MTMxMjUzMX0.JVLsiuyq2aExJFpRnGqfeuIBPcCeZgqjXAjF2ZdmLwU',
  );

  // Create the SupabaseClient instance
  final supabaseClient = Supabase.instance.client;

  // Run the app
  runApp(
    ChangeNotifierProvider(
      create: (context) => StorageService(supabaseClient),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: isDarkModeNotifier,
      builder: (context, isDarkMode, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.teal,
              brightness: isDarkMode ? Brightness.dark : Brightness.light,
            ),
          ),
          home: const WidgetTree(),
        );
      },
    );
  }
}
