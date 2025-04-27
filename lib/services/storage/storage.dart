import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class StorageService with ChangeNotifier {
  final SupabaseClient supabase;

  StorageService(this.supabase);

  // Upload Image and Clothing Item to Supabase
  Future<void> uploadClothingItem(
    File imageFile,
    String color,
    String clothingType,
    String name,
    String category,
  ) async {
    try {
      // Upload image to Supabase Storage
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';

      final storageResponse = await supabase.storage
          .from('clothing-items')
          .upload(fileName, imageFile);

      //Get the public URL for the uploaded image
      final imageUrl = supabase.storage.from('clothing-items').getPublicUrl(fileName);

      // Step 3: Insert clothing item metadata into the user_clothing_items table
      final user = supabase.auth.currentUser;
      if (user == null) {
        throw Exception('User is not authenticated');
      }

      final insertResponse = await supabase.from('user_clothing_items').insert({
        'image_url': imageUrl,
        'category': category,
        'color': color,
        'clothing_type': clothingType,
        'created_at': DateTime.now().toIso8601String(),
      });

      if (insertResponse.error != null) {
        throw Exception('Failed to insert clothing item: ${insertResponse.error!.message}');
      }

      print('Clothing item uploaded successfully!');
      notifyListeners();
    } catch (e) {
      print('Error uploading clothing item: $e');
      rethrow;
    }
  }






  // Retrieve Clothing Items by Category for the Authenticated User
  Future<List<Map<String, dynamic>>> getClothingItemsByCategory(String category) async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null) {
        throw Exception('User is not authenticated');
      }

      // Query clothing items by category for the current user
      final response = await supabase
          .from('user_clothing_items')
          .select('*')
          .eq('user_id', user.id)
          .eq('category', category)
          .order('created_at', ascending: false);

      // Response is already a List<Map<String, dynamic>> if successful
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Error retrieving clothing items: $e');
      return [];
    }
  }




  // Image Picker function to select an image
  Future<File?> pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        return File(pickedFile.path);
      }
      return null;
    } catch (e) {
      print('Error picking image: $e');
      return null;
    }
  }




  // Delete Clothing Item from Supabase
  Future<void> deleteClothingItem(String itemId) async {
    try {
      // Step 1: Get the user and check if they are authenticated
      final user = supabase.auth.currentUser;
      if (user == null) {
        throw Exception('User is not authenticated');
      }

      // Get the clothing item from the database
      final itemResponse = await supabase
          .from('user_clothing_items')
          .select('*')
          .eq('user_id', user.id)
          .eq('id', itemId)
          .single();

      // SDelete the image from Supabase Storage
      final imageUrl = itemResponse['image_url'];
      final fileName = Uri.parse(imageUrl).pathSegments.last;

      final storageResponse = await supabase.storage
          .from('clothing-items')
          .remove([fileName]);

      // Delete the clothing item metadata from the user_clothing_items table
      final deleteResponse = await supabase
          .from('user_clothing_items')
          .delete()
          .eq('user_id', user.id)
          .eq('id', itemId);

      if (deleteResponse.error != null) {
        throw Exception('Failed to delete clothing item: ${deleteResponse.error!.message}');
      }

      notifyListeners(); // Notify listeners to update UI
    } catch (e) {
      rethrow; // Rethrow to allow caller to handle the error
    }
  }
}
