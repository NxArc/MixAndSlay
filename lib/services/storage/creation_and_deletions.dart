import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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
      // Step 1: Get the user and check if they are authenticated
      final user = supabase.auth.currentUser;
      if (user == null) {
        throw Exception('User is not authenticated');
      }

      // Get the clothing item from the database
      final itemResponse =
          await supabase
              .from('user_clothing_items')
              .select('*')
              .eq('uid', user.id)
              .eq('item_id', itemId)
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
          .eq('uid', user.id)
          .eq('item_id', itemId);

      if (deleteResponse.error != null) {
        throw Exception(
          'Failed to delete clothing item: ${deleteResponse.error!.message}',
        );
      }

      notifyListeners(); // Notify listeners to update UI
    } catch (e) {
      rethrow; // Rethrow to allow caller to handle the error
    }
  }

  Future<void> createCustomOutfit({
    required String outfitName,
    required String topId,
    required String bottomId,
    String? headwearId,
    String? accessoriesId,
    String? footwearId,
    String? weatherFit,
    String? outerwearId,
    required String occasion,
  }) async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      final response = await supabase.from('user_outfits').insert({
        'uuid': user.id,
        'created_at': DateTime.now().toIso8601String(),
        'outfit_name': outfitName,
        'headwear': headwearId,
        'top': topId,
        'bottom': bottomId,
        'accessories': accessoriesId,
        'footwear': footwearId,
        'outerwear': outerwearId,
        'weatherFit': weatherFit,
        'occasion': occasion,
      });

      if (response == null || response.isEmpty) {
        throw Exception('Failed to create custom outfit');
      }

      notifyListeners();
    } catch (e) {
      print('Error creating custom outfit: $e');
    }
  }

  //Delete Outfit From Database
  Future<void> deleteOutfit(String outfitId) async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null) {
        throw Exception('User is not authenticated');
      }

      final response = await supabase
          .from('user_outfits')
          .delete()
          .eq('uuid', user.id)
          .eq('id', outfitId);

      if (response == null || response.error != null) {
        throw Exception('Failed to delete outfit: ${response.error?.message}');
      }

      notifyListeners();
      print('Outfit deleted successfully.');
    } catch (e) {
      print('Error deleting outfit: $e');
      rethrow;
    }
  }
}
