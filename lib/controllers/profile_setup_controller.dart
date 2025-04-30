import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileSetupController {
  final supabase = Supabase.instance.client;

  Future<String?> uploadProfileImage(File imageFile) async {
    try {
      final imageBytes = await imageFile.readAsBytes();
      final fileName = 'profile_${DateTime.now().millisecondsSinceEpoch}.jpg';

      await supabase.storage
          .from('profile-pictures')
          .uploadBinary(
            fileName,
            imageBytes,
            fileOptions: FileOptions(contentType: 'image/jpeg'),
          );

      final imageUrl = supabase.storage
          .from('profile-pictures')
          .getPublicUrl(fileName);

      return imageUrl;
    } catch (e) {
      debugPrint('Error uploading image: $e');
      return null;
    }
  }

  Future<bool> updateProfile(
    String name,
    String gender,
    String? imageUrl,
  ) async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null) {
        throw Exception('No logged in user');
      }

      await supabase.from('profiles').upsert({
        'username': name,
        'gender': gender,
        'avatar_url': imageUrl,
      });

      return true;
    } catch (e) {
      debugPrint('Error saving profile: $e');
      return false;
    }
  }

  Future<Map<String, dynamic>?> getProfile() async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null) {
        throw Exception('No logged in user');
      }

      final response =
          await supabase
              .from('profiles')
              .select()
              .eq('id', user.id)
              .single(); // Fetch only the single matching record

      return response;
    } catch (e) {
      debugPrint('Error retrieving profile: $e');
      return null;
    }
  }
}
