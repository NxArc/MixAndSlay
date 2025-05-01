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

      final response = await supabase
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
}
