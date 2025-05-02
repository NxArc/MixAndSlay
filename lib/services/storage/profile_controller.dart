import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileSetupController {
  final supabase = Supabase.instance.client;

  Future<String?> uploadProfileImage(File imageFile) async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null) {
        throw Exception('No logged in user');
      }

      // Step 1: Retrieve current profile to get existing avatar_url
      final profile = await getProfile();
      final oldImageUrl = profile?['avatar_url'];

      // Step 2: If there's an existing image, delete it
      if (oldImageUrl != null &&
          oldImageUrl is String &&
          oldImageUrl.isNotEmpty) {
        final uri = Uri.parse(oldImageUrl);
        final segments = uri.pathSegments;
        final index = segments.indexOf('profile-pictures');
        if (index != -1 && index + 1 < segments.length) {
          final fileNameToDelete = segments[index + 1];
          await supabase.storage.from('profile-pictures').remove([
            fileNameToDelete,
          ]);
        }
      }

      // Step 3: Upload new image
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

Future<String?> loadGender() async {
  final userId = supabase.auth.currentUser?.id;
  if (userId == null) return null;

  final response = await supabase
      .from('profiles')
      .select('gender')
      .eq('id', userId)
      .single();

  if (response['gender'] != null) {
    return response['gender'].toString().toLowerCase(); // e.g., 'male', 'female'
  }

  return null;
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
