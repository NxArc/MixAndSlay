import 'package:fasionrecommender/services/storage/clothingItems_service.dart';
import 'package:fasionrecommender/views/widget/closetwidgets.dart/popups/clothing_item_display.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ViewSavedItemsPage extends StatefulWidget {
  final String category;

  const ViewSavedItemsPage({super.key, required this.category});

  @override
  State<ViewSavedItemsPage> createState() => _ViewSavedItemsPageState();
}

class _ViewSavedItemsPageState extends State<ViewSavedItemsPage> {
  late final ClothingItemService _clothingItemService;
  late final Future<List<Map<String, dynamic>>> _itemsFuture;

  @override
  void initState() {
    super.initState();
    _clothingItemService = ClothingItemService(Supabase.instance.client);
    _itemsFuture = _clothingItemService.getClothingItemsByCategory(
      widget.category,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _itemsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error loading items.',
                style: textTheme.bodyMedium?.copyWith(
                  color: theme.dividerColor.withAlpha((0.6 * 255).round()),
                ),
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                'No saved items yet.',
                style: textTheme.bodyMedium?.copyWith(
                  color: theme.dividerColor.withAlpha((0.6 * 255).round()),
                ),
              ),
            );
          }
          return _buildItemsGrid(context, snapshot.data!);
        },
      ),
    );
  }

  Widget _buildItemsGrid(
    BuildContext context,
    List<Map<String, dynamic>> items,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = (constraints.maxWidth ~/ 130).clamp(2, 4);

        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.65,
          ),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            final imageUrl = item['image_url'] as String;
            final itemName = item['name'] as String;
            final itemId = item['item_id'] as String;

            return GestureDetector(
              onTap: () {
                showClothingItemDialog(context, itemId);
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        errorBuilder:
                            (_, __, ___) => Container(
                              color: theme.scaffoldBackgroundColor,
                              child: Icon(
                                Icons.broken_image,
                                color: theme.dividerColor.withAlpha(
                                  (0.5 * 255).round(),
                                ),
                              ),
                            ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 6),
                  Center(
                    child: Text(
                      itemName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
