import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OutfitService with ChangeNotifier {
  final SupabaseClient supabase;

  OutfitService(this.supabase);

  // ------------------------------------------------------
  // Function 1: Create a Custom Outfit (Manual Selection)
  // ------------------------------------------------------
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
        'created_at': DateTime.now().toIso8601String(),
        'outfit_name': outfitName,
        'uuid': user.id,
        'headwear': headwearId,
        'top': topId,
        'bottom': bottomId,
        'accessories': accessoriesId,
        'footwear': footwearId,
        'outerwear' : outerwearId,
        'weatherFit': weatherFit,
        'occasion': occasion,
      });

      if (response.error != null) {
        throw Exception('Failed to create custom outfit');
      }

      notifyListeners();
    } catch (e) {
      print('Error creating custom outfit: $e');
    }
  }

  // ------------------------------------------------------
  // Function 2: Generate Smart Outfit (Automatic Matching)
  // ------------------------------------------------------
  
  Future<void> generateSmartOutfit({
    required String occasion,
    String? weatherFit,
  }) async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      // Fetch all user clothing items
      final response = await supabase
          .from('user_clothing_items')
          .select('*')
          .eq('user_id', user.id);

      if (response.isEmpty) {
        throw Exception('No clothing items found');
      }

      final items = List<Map<String, dynamic>>.from(response);

      // Separate items by category
      final tops = items.where((item) => item['category'] == 'top').toList();
      final bottoms =
          items.where((item) => item['category'] == 'bottom').toList();
      final headwears =
          items.where((item) => item['category'] == 'headwear').toList();
      final accessories =
          items.where((item) => item['category'] == 'accessories').toList();
      final footwears =
          items.where((item) => item['category'] == 'footwear').toList();

      if (tops.isEmpty || bottoms.isEmpty) {
        throw Exception('At least one top and one bottom are required');
      }

      // Pick top and bottom with simple matching logic
      Map<String, dynamic> selectedTop = tops.first;
      Map<String, dynamic> selectedBottom = bottoms.firstWhere(
        (bottom) =>
            bottom['color'] != selectedTop['color'] &&
            bottom['material'] == selectedTop['material'],
        orElse: () => bottoms.first,
      );

      // Pick optional pieces if available (simple fallback)
      Map<String, dynamic>? selectedHeadwear =
          headwears.isNotEmpty ? headwears.first : null;
      Map<String, dynamic>? selectedAccessory =
          accessories.isNotEmpty ? accessories.first : null;
      Map<String, dynamic>? selectedFootwear;
      if (footwears.isNotEmpty) {
        selectedFootwear = footwears.firstWhere(
          (footwear) => footwear['color'] == selectedBottom['color'],
          orElse: () => footwears.first,
        );
      } else {
        selectedFootwear = null;
      }

      final outfitId = DateTime.now().millisecondsSinceEpoch.toString();
      final outfitName = 'Smart Outfit for $occasion';

      // Insert generated outfit into the database
      final insertResponse = await supabase.from('user_outfits').insert({
        'outfit_id': outfitId,
        'created_at': DateTime.now().toIso8601String(),
        'outfit_name': outfitName,
        'uuid': user.id,
        'headwear': selectedHeadwear?['id'],
        'top': selectedTop['id'],
        'bottom': selectedBottom['id'],
        'accessories': selectedAccessory?['id'],
        'footwear': selectedFootwear?['id'],
        'weatherFit': weatherFit,
        'occasion': occasion,
      });

      if (insertResponse.error != null) {
        throw Exception('Failed to create smart outfit');
      }

      notifyListeners();
    } catch (e) {
      print('Error generating smart outfit: $e');
    }
  }
}
