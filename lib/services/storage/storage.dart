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
    String material
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
        'color': color,
        'clothing_type': clothingType,
        'name': name,
        'category': category,
        'material': material,
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



  Future<List<Map<String, dynamic>>> getClothingItemsByType(
    String clothingType,
  ) async {
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
          .eq('clothing_type', clothingType) // Filter by clothing type
          .order('created_at', ascending: false);

      // Response is already a List<Map<String, dynamic>> if successful
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Error retrieving clothing items by clothing type: $e');
      return [];
    }
  }
  Future<void> createOutfit({
    required String outfitName,
    required List<String> clothingItemIds,
    required String weatherFit, 
  }) async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null) {
        throw Exception('User is not authenticated');
      }

      // Map the clothing item ids to their respective columns
      final itemMap = {
        'headwear': clothingItemIds.length > 0 ? clothingItemIds[0] : null,
        'top': clothingItemIds.length > 1 ? clothingItemIds[1] : null,
        'bottom': clothingItemIds.length > 2 ? clothingItemIds[2] : null,
        'accessories': clothingItemIds.length > 3 ? clothingItemIds[3] : null,
      };

      // Create the outfit with references to clothing items
      final insertResponse =
          await supabase
              .from('user_outfits')
              .insert({
                'uuid': user.id,
                'outfit_name': outfitName,
                'weatherFit': weatherFit,  // Added weatherFit
                'created_at': DateTime.now().toIso8601String(),
                'headwear': itemMap['headwear'],
                'top': itemMap['top'],
                'bottom': itemMap['bottom'],
                'accessories': itemMap['accessories'],
              })
              .select('outfit_id')
              .single();

      if (insertResponse == null || insertResponse['outfit_id'] == null) {
        throw Exception('Failed to create outfit: No ID returned');
      }

      print('Outfit created successfully!');
      notifyListeners();
    } catch (e) {
      print('Error creating outfit: $e');
      rethrow;
    }
  }

  // DELETE AN OUTFIT
  Future<void> deleteOutfit(String outfitId) async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null) {
        throw Exception('User is not authenticated');
      }

      // Step 1: Delete the outfit itself
      final deleteOutfitResponse = await supabase
          .from('user_outfits')
          .delete()
          .eq('outfit_id', outfitId)
          .eq('uuid', user.id);

      if (deleteOutfitResponse.error != null) {
        throw Exception(
          'Failed to delete outfit: ${deleteOutfitResponse.error!.message}',
        );
      }

      print('Outfit deleted successfully!');
      notifyListeners();
    } catch (e) {
      print('Error deleting outfit: $e');
      rethrow;
    }
  }


}