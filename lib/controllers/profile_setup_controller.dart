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
          .from('profile_pictures')
          .uploadBinary(
            fileName,
            imageBytes,
            fileOptions: FileOptions(contentType: 'image/jpeg'),
          );

      final imageUrl = supabase.storage 
          .from('profile_pictures')
          .getPublicUrl(fileName);

      return imageUrl;
    } catch (e) {
      debugPrint('Error uploading image: $e');
      return null;
    }
  }

  Future<bool> saveProfile(String name, String gender, String? imageUrl) async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null) {
        throw Exception('No logged in user');
      }

      await supabase.from('profiles').upsert({
        'id': user.id,
        'name': name,
        'gender': gender,
        'profile_picture_url': imageUrl,
      });

      return true;
    } catch (e) {
      debugPrint('Error saving profile: $e');
      return false;
    }
  }
}
