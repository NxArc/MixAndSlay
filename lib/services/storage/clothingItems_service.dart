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

      await supabase.storage.from('clothing-items').upload(fileName, imageFile);

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

      // Extract relative storage path from image URL
      final fullPath = Uri.parse(imageUrl).pathSegments
          .skipWhile((s) => s != 'clothing-items') // Find bucket name
          .skip(1) // Skip the bucket name itself
          .join('/');

      // Delete the database record
      await supabase
          .from('user_clothing_items')
          .delete()
          .eq('uid', user.id)
          .eq('item_id', itemId);

      // Delete the image from storage
      await supabase.storage.from('clothing-items').remove([fullPath]);

      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting clothing item: $e');
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


Future<String?> retrieveAndSavePreMadeClothingItemByName(String name) async {
  try {
    final user = supabase.auth.currentUser;
    if (user == null) {
      throw Exception('User is not authenticated');
    }

    final response = await supabase
        .from('system_clothing_items')
        .select('*')
        .eq('name', name)
        .order('created_at', ascending: false)
        .limit(1);

    final items = List<Map<String, dynamic>>.from(response);

    if (items.isEmpty) {
      print('No system item found with name: $name');
      return null;
    }

    final item = items.first;


    final insertResponse = await supabase
        .from('user_clothing_items')
        .insert({
          'image_url': item['image_url'],
          'color': item['color'],
          'clothing_type': item['clothing_type'],
          'name': item['name'],
          'material': item['material'],
          'category': item['category'],
          'created_at': DateTime.now().toIso8601String(),
        })
        .select()
        .single();

    final itemId = insertResponse['clothing_id'] as String;
    print('Clothing item "${item['name']}" saved successfully with ID $itemId!');
    notifyListeners();
    return itemId;
  } catch (e) {
    print('Error retrieving and saving clothing item: $e');
    return null;
  }
}

// final itemId = await clothingItemService.retrieveAndSavePreMadeClothingItemByName('Classic T-Shirt');
// // if (itemId != null) {
// //   print('Item saved with ID: $itemId');
// //   // You can now use itemId for navigation, displaying item details, etc.
// // } else {
// //   print('Failed to save item.');
// // }

}
