import 'package:fasionrecommender/views/widgets/closetwidgets.dart/popups/saved_dialog.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:fasionrecommender/services/storage/clothingItems_service.dart';
import 'package:fasionrecommender/services/storage/outfits_service.dart';

class SystemOutfitDisplay extends StatefulWidget {
  final String systemOutfitName;

  const SystemOutfitDisplay({super.key, required this.systemOutfitName});

  @override
  State<SystemOutfitDisplay> createState() => _SystemOutfitDisplayState();
}

class _SystemOutfitDisplayState extends State<SystemOutfitDisplay> {
  final OutfitService outfitService = OutfitService(Supabase.instance.client);
  final ClothingItemService clothingItemService = ClothingItemService(
    Supabase.instance.client,
  );
  Map<String, dynamic>? outfit;

  @override
  void initState() {
    super.initState();
    _loadSystemOutfit(widget.systemOutfitName);
  }

  Future<void> _loadSystemOutfit(String name) async {
    try {
      final systemOutfit = await outfitService.retrieveSystemOutfitByName(name);
      if (systemOutfit != null) {
        setState(() {
          outfit = systemOutfit;
        });
      }
    } catch (e) {
      print('Error loading system outfit: $e');
    }
  }

  Widget _buildTag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color),
      ),
      child: Text(
        text,
        style: TextStyle(color: color, fontWeight: FontWeight.bold),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (outfit == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            outfit!['name'] ?? 'Unnamed Outfit',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 20),
          if (outfit!['image_url'] != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                outfit!['image_url'],
                height: MediaQuery.of(context).size.height * 0.4,
                fit: BoxFit.cover,
              ),
            ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 12,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: [
              if (outfit!['weatherFit'] != null)
                _buildTag('WeatherFit: ${outfit!['weatherFit']}', Colors.blue),
              if (outfit!['occasion'] != null)
                _buildTag('Occasion: ${outfit!['occasion']}', Colors.green),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.close, color: theme.colorScheme.onPrimary),
                label: Text(
                  'Close',
                  style: TextStyle(color: theme.colorScheme.onPrimary),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 10,
                  ),
                ),
              ),
              ElevatedButton.icon(
                onPressed: () async {
                  final name = outfit?['name'] as String?;
                  if (name != null) {
                    try {
                      // Safely retrieve clothing item names from the outfit map
                      final topName = outfit?['top_name'] as String?;
                      final bottomName = outfit?['bottom_name'] as String?;
                      final outerwearName =
                          outfit?['outerwear_name'] as String?;
                      final headwearName = outfit?['headwear_name'] as String?;
                      final footwearName = outfit?['footwear_name'] as String?;
                      final accessoriesName =
                          outfit?['accessories_name'] as String?;

                      // Safely retrieve and save each item if the name is not null or empty
                      final topID =
                          topName != null && topName.isNotEmpty
                              ? await clothingItemService
                                  .retrieveAndSavePreMadeClothingItemByName(
                                    topName,
                                  )
                              : null;

                      final bottomID =
                          bottomName != null && bottomName.isNotEmpty
                              ? await clothingItemService
                                  .retrieveAndSavePreMadeClothingItemByName(
                                    bottomName,
                                  )
                              : null;

                      final outerwearID =
                          outerwearName != null && outerwearName.isNotEmpty
                              ? await clothingItemService
                                  .retrieveAndSavePreMadeClothingItemByName(
                                    outerwearName,
                                  )
                              : null;

                      final headwearID =
                          headwearName != null && headwearName.isNotEmpty
                              ? await clothingItemService
                                  .retrieveAndSavePreMadeClothingItemByName(
                                    headwearName,
                                  )
                              : null;

                      final footwearID =
                          footwearName != null && footwearName.isNotEmpty
                              ? await clothingItemService
                                  .retrieveAndSavePreMadeClothingItemByName(
                                    footwearName,
                                  )
                              : null;

                      final accessoriesID =
                          accessoriesName != null && accessoriesName.isNotEmpty
                              ? await clothingItemService
                                  .retrieveAndSavePreMadeClothingItemByName(
                                    accessoriesName,
                                  )
                              : null;

                      // Logging for debugging
                      print('Top ID: $topID');
                      print('Bottom ID: $bottomID');
                      print('Outerwear ID: $outerwearID');
                      print('Headwear ID: $headwearID');
                      print('Footwear ID: $footwearID');
                      print('Accessories ID: $accessoriesID');

                      // Create outfit only if top and bottom are valid
                      if (topID != null && bottomID != null) {
                        await outfitService.createCustomOutfit(
                          topId: topID,
                          bottomId: bottomID,
                          headwearId: headwearID,
                          accessoriesId: accessoriesID,
                          footwearId: footwearID,
                          outerwearId: outerwearID,
                          weatherFit: outfit?['weatherFit'] as String?,
                          outfitName: name,
                          occasion: outfit?['occasion'] as String? ?? 'Casual',
                        );

                        showSuccessDialog(context);
                      } else {
                        throw Exception('Top or Bottom ID is null.');
                      }
                    } catch (e) {
                      print('Failed to add to closet: $e');
                      showFailureDialog(context, '$e');
                    }
                  }
                },
                icon: Icon(Icons.add, color: theme.colorScheme.onPrimary),
                label: Text(
                  'Add to Closet',
                  style: TextStyle(color: theme.colorScheme.onPrimary),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 10,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
