import 'package:fasionrecommender/data/notifiers.dart';
import 'package:fasionrecommender/services/storage/clothingItems_service.dart';
import 'package:fasionrecommender/services/storage/outfits_service.dart';
import 'package:fasionrecommender/views/pages/widget_tree.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://dqderqwpilsitwnbvjhj.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRxZGVycXdwaWxzaXR3bmJ2amhqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDU3MzY1MzEsImV4cCI6MjA2MTMxMjUzMX0.JVLsiuyq2aExJFpRnGqfeuIBPcCeZgqjXAjF2ZdmLwU',
  );

  final supabaseClient = Supabase.instance.client;

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ClothingItemService(supabaseClient),
        ),
        ChangeNotifierProvider(
          create: (_) => OutfitService(supabaseClient),
        ),
      ],
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
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeModeNotifier,
      builder: (context, themeMode, _) {
        return ValueListenableBuilder<Color>(
          valueListenable: themeColorNotifier,
          builder: (context, themeColor, _) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(
                  seedColor: themeColor,
                  brightness: Brightness.light,
                ),
              ),
              darkTheme: ThemeData(
                colorScheme: ColorScheme.fromSeed(
                  seedColor: themeColor,
                  brightness: Brightness.dark,
                ),
              ),
              themeMode: themeMode,
              home: const WidgetTree(),
            );
          },
        );
      },
    );
  }
}
