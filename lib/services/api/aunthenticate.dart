import 'package:supabase_flutter/supabase_flutter.dart';

class Auth {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Supabase doesn't have a direct `currentUser`, but you can get it like this
  User? get currentUser => _supabase.auth.currentUser;

  // Supabase auth state stream
  Stream<AuthState> get authStateChanges => _supabase.auth.onAuthStateChange;

  Future<void> signInwithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      if (response.user == null) {
        throw response.session == null
            ? Exception(response.error?.message ?? 'Unknown login error')
            : Exception('Unknown login error');
      }
    } catch (error) {
      throw Exception('Login failed: ${error.toString()}');
    }
  }

  Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
    } catch (error) {
      throw Exception('Logout failed: ${error.toString()}');
    }
  }
}

extension on AuthResponse {
  get error => null;
}
