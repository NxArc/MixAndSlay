import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ClothingItemService with ChangeNotifier {
  final SupabaseClient supabase;

  ClothingItemService(this.supabase);
  // Upload Image and Clothing Item to Supabase
  Future<void> uploadClothingItem(
    File imageFile,
    String color,
    String clothingType,
    String name,
    String material,
    String category,
  ) async {
    try {
      // Upload image to Supabase Storage
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';

      final storageResponse = await supabase.storage
          .from('clothing-items')
          .upload(fileName, imageFile);

      //Get the public URL for the uploaded image
      final imageUrl = supabase.storage
          .from('clothing-items')
          .getPublicUrl(fileName);

      // Step 3: Insert clothing item metadata into the user_clothing_items table
      final user = supabase.auth.currentUser;
      if (user == null) {
        throw Exception('User is not authenticated');
      }

      final insertResponse = await supabase.from('user_clothing_items').insert({
        'image_url': imageUrl,
        'color': color,
        'clothing_type': clothingType,
        'name': name,
        'material': material,
        'category': category,
        'created_at': DateTime.now().toIso8601String(),
      });

      if (insertResponse.error != null) {
        throw Exception(
          'Failed to insert clothing item: ${insertResponse.error!.message}',
        );
      }
      print('Clothing item uploaded successfully!');
      notifyListeners();
    } catch (e) {
      print('Error uploading clothing item: $e');
    }
  }

  Future<Map<String, dynamic>?> retrieveClothingItem(String itemId) async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null) {
        throw Exception('User is not authenticated');
      }

      final response =
          await supabase
              .from('user_clothing_items')
              .select()
              .eq('item_id', itemId)
              .maybeSingle(); // Safely returns null if no record found

      if (response == null) {
        print('Clothing item not found.');
        return null;
      }

      return response;
    } catch (e) {
      print('Error retrieving clothing item: $e');
      return null;
    }
  }

  // Retrieve Clothing Items by Category
  Future<List<Map<String, dynamic>>> getClothingItemsByCategory(
    String category,
  ) async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null) {
        throw Exception('User is not authenticated');
      }

      // Query clothing items by category for the current user
      final response = await supabase
          .from('user_clothing_items')
          .select('*')
          .eq('uid', user.id)
          .eq('category', category)
          .order('created_at', ascending: false);
      // Response is already a List<Map<String, dynamic>> if successful
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Error retrieving clothing items: $e');
      return [];
    }
  }

  // Delete Clothing Item from Supabase
  Future<void> deleteClothingItem(String itemId) async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null) {
        throw Exception('User is not authenticated');
      }

      // Fetch the item data first
      final itemResponse =
          await supabase
              .from('user_clothing_items')
              .select('*')
              .eq('uid', user.id)
              .eq('item_id', itemId)
              .single();

      final imageUrl = itemResponse['image_url'];
      final fileName = Uri.parse(imageUrl).pathSegments.last;

      // Attempt to delete the database record
      final deleteResponse = await supabase
          .from('user_clothing_items')
          .delete()
          .eq('uid', user.id)
          .eq('item_id', itemId);

      if (deleteResponse.error != null) {
        final errorMessage = deleteResponse.error!.message;

        throw Exception('Failed to delete clothing item: $errorMessage');
      }
      
      await supabase.storage.from('clothing-items').remove([fileName]);

      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getAllClothingItems() async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null) {
        throw Exception('User is not authenticated');
      }

      // Query clothing items by clothing type for the current user
      final response = await supabase
          .from('user_clothing_items')
          .select('*')
          .eq('uid', user.id)
          .order('created_at', ascending: false);

      // Response is already a List<Map<String, dynamic>> if successful
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Error retrieving clothing items by clothing type: $e');
      return [];
    }
  }
}
