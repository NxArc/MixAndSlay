import 'package:cached_network_image/cached_network_image.dart';
import 'package:fasionrecommender/services/storage/outfits_service.dart';
import 'package:fasionrecommender/views/widgets/closetwidgets.dart/popups/system_outfit_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OutfitGrid extends StatelessWidget {
  final String category;
  const OutfitGrid({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final outfitService = OutfitService(Supabase.instance.client);

    return FutureBuilder<List<Map<String, dynamic>>>(
      future: outfitService.retrieveSystemOutfitsByCategory(category: category),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No outfits found.'));
        }

        final outfits = snapshot.data!;

        return MasonryGridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
          ),
          itemCount: outfits.length,
          itemBuilder: (context, index) {
            final outfit = outfits[index];
            final imageUrl = outfit['image_url'] as String? ?? '';
            final outfitName = outfit['name'] as String? ?? 'Unnamed Outfit';

            return GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder:
                      (_) => SystemOutfitDisplay(systemOutfitName: outfitName),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    fit: BoxFit.cover,
                    placeholder:
                        (context, url) => Container(
                          height: 150,
                          color: Colors.grey[200],
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                    errorWidget:
                        (context, url, error) => Container(
                          height: 150,
                          color: Colors.grey[300],
                          child: const Center(
                            child: Icon(
                              Icons.broken_image,
                              color: Colors.grey,
                              size: 40,
                            ),
                          ),
                        ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
