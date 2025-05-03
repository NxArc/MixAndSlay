import 'package:flutter/material.dart';
import 'package:fasionrecommender/services/storage/clothingItems_service.dart';
import 'package:provider/provider.dart';

Future<void> showClothingItemDialog(BuildContext context, String itemId) async {
  final storageService = Provider.of<ClothingItemService>(context, listen: false);
  final theme = Theme.of(context);
  final textTheme = theme.textTheme;
  final colorScheme = theme.colorScheme;

  final item = await storageService.retrieveClothingItem(itemId);
  if (item == null) {
    if (context.mounted) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Item not found'),
          content: const Text('The clothing item could not be found.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
    return;
  }

  return showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (item['image_url'] != null)
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    child: Image.network(
                      item['image_url'],
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: 300,
                      fit: BoxFit.cover,
                    ),
                  )
                else
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Icon(Icons.image_not_supported,
                        size: 100, color: colorScheme.onSurface),
                  ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          item['name'] ?? 'Unnamed Item',
                          style: textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Category: ${item['category'] ?? 'Unknown'}',
                        style: textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Material: ${item['material'] ?? 'Unknown'}',
                        style: textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Color: ${item['color'] ?? 'Unknown'}',
                        style: textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: ElevatedButton(
                          onPressed: () async {
                            try {
                              await storageService.deleteClothingItem(item['item_id']);
                              if (context.mounted) {
                                await showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('Success'),
                                    content: const Text(
                                      'Clothing item deleted successfully.',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context); // Close alert
                                          Navigator.pop(context); // Close dialog
                                        },
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  ),
                                );
                              }
                            } catch (e) {
                              if (context.mounted) {
                                await showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('Error'),
                                    content: Text('Failed to delete item: $e'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context); // Close alert
                                          Navigator.pop(context); // Close dialog
                                        },
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  ),
                                );
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colorScheme.error,
                          ),
                          child: Text(
                            'Delete Item',
                            style: TextStyle(color: colorScheme.onError),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              right: 4,
              top: 4,
              child: IconButton(
                icon: Icon(Icons.close, color: colorScheme.onSurface),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      );
    },
  );
}
