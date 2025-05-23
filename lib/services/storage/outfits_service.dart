import 'package:fasionrecommender/data/outfit_data_compatibility_maps.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OutfitService with ChangeNotifier {
  final SupabaseClient supabase;

  OutfitService(this.supabase);

  Future<void> createCustomOutfit({
    required String topId,
    required String bottomId,
    String? headwearId,
    String? accessoriesId,
    String? footwearId,
    String? weatherFit,
    String? outerwearId,
    String? outfitName,
    required String occasion,
  }) async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      outfitName ??= 'Unnamed Outfit';

      final insertData = {
        'uuid': user.id,
        'created_at': DateTime.now().toIso8601String(),
        'outfit_name': outfitName,
        'top': topId,
        'bottom': bottomId,
        'occasion': occasion,
      };

      if (headwearId != null) insertData['headwear'] = headwearId;
      if (accessoriesId != null) insertData['accessories'] = accessoriesId;
      if (footwearId != null) insertData['footwear'] = footwearId;
      if (outerwearId != null) insertData['outerwear'] = outerwearId;
      if (weatherFit != null) insertData['weatherFit'] = weatherFit;
      // Insert the outfit into the database
      await supabase.from('user_outfits').insert(insertData);
      // Notify listeners if you're using ChangeNotifier
      notifyListeners();
    } catch (e) {
      print('Error creating custom outfit: $e');
      rethrow; // Optional: propagate the error if needed
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

  //Retrieve System Outfit by Category
Future<List<Map<String, dynamic>>> retrieveSystemOutfitsByCategory({
  required String category,
  String? gender,
}) async {
  try {
    var query = supabase
        .from('system_outfits')
        .select('*')
        .eq('category', category);

    if (gender != null &&
        gender.isNotEmpty &&
        gender != 'other') {
      query = query.eq('gender', gender);
    }

    final response = await query;

    return List<Map<String, dynamic>>.from(response);
  } catch (e) {
    print('Error retrieving outfits by category: $e');
    return [];
  }
}



  //Retrieve System Outfit By Name
  Future<Map<String, dynamic>?> retrieveSystemOutfitByName(String name) async {
    try {
      final response =
          await supabase
              .from('system_outfits')
              .select('*')
              .eq('name', name)
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

      final List<Map<String, dynamic>> tops = await _getClothingItemsByCategory(
        'Tops',
      );
      final List<Map<String, dynamic>> bottoms =
          await _getClothingItemsByCategory('Bottoms');
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

      // CHECK TOP OCCASION COMPATIBILITY
      tops.shuffle();
      for (var top in tops) {
        final topType = (top['clothing_type'] as String?)?.trim();
        if (topType == null || topType.isEmpty) continue;

        final occasionCompatibleTops = occasionTopMap[occasion] ?? [];
        final isOccasionCompatible = occasionCompatibleTops
            .map((e) => e.toLowerCase())
            .contains(topType.toLowerCase());

        if (!isOccasionCompatible) continue;

        //CHECK TOP BOTTOM COMPATIBILITY
        final compatibilityKey = topBottomCompatibilityMap.keys.firstWhere(
          (k) => k.toLowerCase() == topType.toLowerCase(),
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

      //Add accessory
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

      // Add compatible outerwear
      for (final outer in outerwears) {
        final outerType = (outer['clothing_type'] as String?);
        final topType = (selectedTop['clothing_type'] as String?);
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

      // Add compatible footwear
      for (final foot in footwears) {
        final footType = (foot['clothing_type'] as String?);
        final bottomType = (selectedBottom['clothing_type'] as String?);
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

      // Add compatible headwear
      for (final head in headwears) {
        final headType = (head['clothing_type'] as String?);
        final topType = (selectedTop['clothing_type'] as String?);
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

  //GET CLOTHING ITEMS BY CATEGORY
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

  // Add Outfit of the Day (OOTD)
Future<void> setOutfitOfTheDay({
  required String outfitId,
  required DateTime date,
}) async {
  try {
    final user = supabase.auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    final isoDateOnly = DateTime(date.year, date.month, date.day).toIso8601String();

    // Delete any existing entry for this user and date (match on date only, not timestamp)
    await supabase
        .from('user_ootd')
        .delete()
        .eq('uid', user.id)
        .eq('date', isoDateOnly);

    // Prepare new insert data
    final insertData = {
      'uid': user.id,
      'outfit_id': outfitId,
      'date': isoDateOnly,
      'created_at': DateTime.now().toIso8601String(),
    };

    // Insert the new OOTD entry
    await supabase.from('user_ootd').insert(insertData);

    notifyListeners();
    print('Outfit of the Day set successfully.');
  } catch (e) {
    print('Error setting Outfit of the Day: $e');
    rethrow;
  }
}


  Future<List<Map<String, dynamic>>> retrieveOutfitsOfTheDay() async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      final response = await supabase
          .from('user_ootd')
          .select('outfit_id, date')
          .eq('uid', user.id);

      final data = response;

        return data.cast<Map<String, dynamic>>();

    } catch (e) {
      print('Error retrieving OOTDs: $e');
      rethrow;
    }
  }

  // Retrieve Outfit of the Day by date
  Future<Map<String, dynamic>?> getOutfitOfTheDay(DateTime date) async {
  try {
    final user = supabase.auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    // Step 1: Retrieve the Outfit ID for the given date
    final response =
        await supabase
            .from('user_ootd')
            .select('outfit_id, date')
            .eq('uid', user.id)
            .eq('date', date.toIso8601String())
            .maybeSingle();

    if (response != null && response['outfit_id'] != null) {
      final outfitId = response['outfit_id'];

      // Step 2: Retrieve the outfit details based on the outfit_id
      final outfitResponse =
          await supabase
              .from('user_outfits')
              .select('*')
              .eq('outfit_id', outfitId)
              .maybeSingle();

      return outfitResponse;
    } else {
      print('No Outfit of the Day set for this date.');
      return null;
    }
  } catch (e) {
    print('Error retrieving Outfit of the Day: $e');
    return null;
  }
}
  Future<void> deleteOutfitOfTheDay(DateTime date) async {
  final userId = supabase.auth.currentUser?.id;
  if (userId == null) {
    throw Exception('User not authenticated');
  }

  final formattedDate = DateTime(date.year, date.month, date.day);

  await supabase
      .from('user_ootd')
      .delete()
      .eq('uid', userId)
      .eq('date', formattedDate.toIso8601String().split('T').first);

}

}
