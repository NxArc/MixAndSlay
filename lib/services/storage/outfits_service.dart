import 'package:fasionrecommender/data/outfit_data_compatibility_maps.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OutfitService with ChangeNotifier {
  final SupabaseClient supabase;

  OutfitService(this.supabase);

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

      await supabase
          .from('user_outfits')
          .delete()
          .eq('uuid', user.id)
          .eq('outfit_id', outfitId);

      notifyListeners();
      print('Outfit deleted successfully.');
    } catch (e) {
      print('Error deleting outfit: $e');
      rethrow;
    }
  }

  // Retrieve all outfits
  Future<List<Map<String, dynamic>>> retrieveOutfits() async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null) throw Exception('User is not authenticated');

      final response = await supabase
          .from('user_outfits')
          .select(
            'outfit_id, outfit_name, top, bottom, headwear, accessories, footwear, outerwear, weatherFit, occasion',
          )
          .eq('uuid', user.id)
          .order('created_at', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Error retrieving outfits: $e');
      return [];
    }
  }

  // Retrieve outfits by ID
  Future<Map<String, dynamic>?> retrieveOutfitByOutfitID(
    String outfitId,
  ) async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null) throw Exception('User is not authenticated');

      final response =
          await supabase
              .from('user_outfits')
              .select()
              .eq('uuid', user.id)
              .eq('outfit_id', outfitId)
              .maybeSingle();

      return response;
    } catch (e) {
      print('Error retrieving outfit: $e');
      return null;
    }
  }

  // Retrieve outfits by category (weatherFit or occasion)
  Future<List<Map<String, dynamic>>> retrieveOutfitsByCategory({
    required String categoryType,
    required String value,
  }) async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null) throw Exception('User is not authenticated');

      if (categoryType != 'weatherFit' && categoryType != 'occasion') {
        throw Exception(
          'Invalid category type. Use "weatherFit" or "occasion".',
        );
      }

      final response = await supabase
          .from('user_outfits')
          .select(
            'outfit_id, outfit_name, top, bottom, headwear, accessories, footwear, outerwear, weatherFit, occasion',
          )
          .eq('uuid', user.id)
          .eq(categoryType, value)
          .order('created_at', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Error retrieving outfits by category: $e');
      return [];
    }
  }

  Future<void> updateOutfit({
    required String outfitId,
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
      await supabase
          .from('user_outfits')
          .update({
            'outfit_name': outfitName,
            'headwear': headwearId,
            'top': topId,
            'bottom': bottomId,
            'accessories': accessoriesId,
            'footwear': footwearId,
            'outerwear': outerwearId,
            'weatherFit': weatherFit,
            'occasion': occasion,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('uuid', user.id)
          .eq('outfit_id', outfitId);

      notifyListeners();
      print('Outfit updated successfully.');
    } catch (e) {
      print('Error updating outfit: $e');
      rethrow;
    }
  }

  //SMART OUTFIT GENERATION
  Future<Map<String, dynamic>?> generateSmartOutfit({
    required String outfitName,
    required String occasion,
    String? weatherFit,
  }) async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      // Required clothing categories
      final List<Map<String, dynamic>> tops = await _getClothingItemsByCategory(
        'Tops',
      );
      final List<Map<String, dynamic>> bottoms =
          await _getClothingItemsByCategory('Bottoms');

      // Optional clothing categories
      final List<Map<String, dynamic>> accessories =
          await _getClothingItemsByCategory('Accessories');
      final List<Map<String, dynamic>> outerwears =
          await _getClothingItemsByCategory('Outerwear');
      final List<Map<String, dynamic>> footwears =
          await _getClothingItemsByCategory('Footwear');
      final List<Map<String, dynamic>> headwears =
          await _getClothingItemsByCategory('Headwear');

      if (tops.isEmpty) throw Exception('No tops available in database');
      if (bottoms.isEmpty) throw Exception('No bottoms available in database');

      Map<String, dynamic>? selectedTop;
      Map<String, dynamic>? selectedBottom;

      // Match compatible top and bottom
      tops.shuffle();
      for (var top in tops) {
        final topType = (top['clothing_type'] as String?)?.trim().toLowerCase();
        if (topType == null || topType.isEmpty) continue;

        final compatibilityKey = topBottomCompatibilityMap.keys.firstWhere(
          (k) => k.toLowerCase() == topType,
          orElse: () => '',
        );

        if (compatibilityKey.isNotEmpty) {
          final compatibleBottoms = topBottomCompatibilityMap[compatibilityKey];
          if (compatibleBottoms != null) {
            final match = bottoms.firstWhere((b) {
              final bottomType =
                  (b['clothing_type'] as String?)?.trim().toLowerCase();
              return bottomType != null &&
                  compatibleBottoms
                      .map((e) => e.toLowerCase())
                      .contains(bottomType);
            }, orElse: () => {});

            if (match.isNotEmpty) {
              selectedTop = top;
              selectedBottom = match;
              break;
            }
          }
        }
      }

      if (selectedTop == null || selectedBottom == null) {
        print('DEBUG: Top types: ${tops.map((t) => t['clothing_type'])}');
        print('DEBUG: Bottom types: ${bottoms.map((b) => b['clothing_type'])}');
        throw Exception(
          'No compatible top-bottom match found after checking all available items',
        );
      }

      final outfit = {
        'Top': {
          'id': selectedTop['item_id'],
          'image_url': selectedTop['image_url'],
        },
        'Bottom': {
          'id': selectedBottom['item_id'],
          'image_url': selectedBottom['image_url'],
        },
      };

      // Optionally add accessory
      if (occasionAccessoryMap.containsKey(occasion)) {
        final accessoryNames = occasionAccessoryMap[occasion]!;
        final match = accessories.firstWhere(
          (a) => accessoryNames
              .map((e) => e.toLowerCase())
              .contains((a['name'] as String).toLowerCase()),
          orElse: () => {},
        );
        if (match.isNotEmpty) {
          outfit['Accessory'] = {
            'id': match['item_id'],
            'image_url': match['image_url'],
          };
        }
      }

      // Optionally add compatible outerwear
      for (final outer in outerwears) {
        final outerType = (outer['clothing_type'] as String?)?.toLowerCase();
        final topType =
            (selectedTop['clothing_type'] as String?)?.toLowerCase();
        if (outerType != null &&
            topType != null &&
            outerwearTopCompatibilityMap[outerType]?.contains(topType) ==
                true) {
          outfit['Outerwear'] = {
            'id': outer['item_id'],
            'image_url': outer['image_url'],
          };
          break;
        }
      }

      // Optionally add compatible footwear
      for (final foot in footwears) {
        final footType = (foot['clothing_type'] as String?)?.toLowerCase();
        final bottomType =
            (selectedBottom['clothing_type'] as String?)?.toLowerCase();
        if (footType != null &&
            bottomType != null &&
            footwearBottomCompatibilityMap[bottomType]?.contains(footType) ==
                true) {
          outfit['Footwear'] = {
            'id': foot['item_id'],
            'image_url': foot['image_url'],
          };
          break;
        }
      }

      // Optionally add compatible headwear
      for (final head in headwears) {
        final headType = (head['clothing_type'] as String?)?.toLowerCase();
        final topType =
            (selectedTop['clothing_type'] as String?)?.toLowerCase();
        if (headType != null &&
            topType != null &&
            headwearTopCompatibilityMap[headType]?.contains(topType) == true) {
          outfit['Headwear'] = {
            'id': head['item_id'],
            'image_url': head['image_url'],
          };
          break;
        }
      }

      return outfit;
    } catch (e, stack) {
      print('Error generating smart outfit: $e');
      print('Stack trace: $stack');
      return null;
    }
  }

  // Mocked helper method - replace with real DB queries
  Future<List<Map<String, dynamic>>> _getClothingItemsByCategory(
    String category,
  ) async {
    final user = supabase.auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    final response = await supabase
        .from('user_clothing_items')
        .select()
        .eq('uid', user.id)
        .eq('category', category);

    return List<Map<String, dynamic>>.from(response);
  }
}
