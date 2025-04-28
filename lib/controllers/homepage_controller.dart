import 'package:supabase_flutter/supabase_flutter.dart';

// Get the current user
final User? user = Supabase.instance.client.auth.currentUser;

// Sign out method
Future<void> signOut() async {
  final response = await Supabase.instance.client.auth.signOut();
}
