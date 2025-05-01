import 'package:fasionrecommender/services/storage/clothingItems_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CollectionSection extends StatelessWidget {
  final bool isExpanded;
  final VoidCallback onTap;

  const CollectionSection({
    super.key,
    required this.isExpanded,
    required this.onTap,
  });

  Future<void> showClothingItemDialog(
    BuildContext context,
    Map<String, dynamic> item,
  ) {
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
                    const Padding(
                      padding: EdgeInsets.all(24),
                      child: Icon(Icons.image_not_supported, size: 100),
                    ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            item['name'] ?? 'Unnamed Item',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Category: ${item['category'] ?? 'Unknown'}',
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Material: ${item['material'] ?? 'Unknown'}',
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Color: ${item['color'] ?? 'Unknown'}',
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: ElevatedButton(
                            onPressed: () async {
                              final storageService =
                                  Provider.of<ClothingItemService>(
                                    context,
                                    listen: false,
                                  );

                              try {
                                await storageService.deleteClothingItem(
                                  item['item_id'],
                                );

                                if (context.mounted) {
                                  await showDialog(
                                    context: context,
                                    builder:
                                        (context) => AlertDialog(
                                          title: const Text('Success'),
                                          content: const Text(
                                            'Clothing item deleted successfully.',
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                                Navigator.pop(context);
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
                                    builder:
                                        (context) => AlertDialog(
                                          title: const Text('Error'),
                                          content: Text(
                                            'Failed to delete item: $e',
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                                Navigator.pop(context);
                                                onTap(); // refresh
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
                              backgroundColor: Colors.red,
                            ),
                            child: const Text('Delete Item'),
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
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final storageService = Provider.of<ClothingItemService>(
      context,
      listen: false,
    );

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(50),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Collection',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontFamily: 'Montserrat',
                fontWeight: isExpanded ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child:
                  isExpanded
                      ? FutureBuilder<List<Map<String, dynamic>>>(
                        future: storageService.getAllClothingItems(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Padding(
                              padding: EdgeInsets.only(top: 12),
                              child: Center(child: CircularProgressIndicator()),
                            );
                          } else if (snapshot.hasError) {
                            return const Padding(
                              padding: EdgeInsets.only(top: 12),
                              child: Text(
                                'Error loading clothing items.',
                                style: TextStyle(color: Colors.black54),
                              ),
                            );
                          } else if (!snapshot.hasData ||
                              snapshot.data!.isEmpty) {
                            return const Padding(
                              padding: EdgeInsets.only(top: 12.0),
                              child: Text(
                                "You haven't saved any items here yet.",
                                style: TextStyle(color: Colors.black54),
                              ),
                            );
                          } else {
                            final items = snapshot.data!;
                            return Padding(
                              padding: const EdgeInsets.only(top: 12.0),
                              child: GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                padding: EdgeInsets.zero,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 12,
                                      mainAxisSpacing: 12,
                                      childAspectRatio: 0.8,
                                    ),
                                itemCount: items.length,
                                itemBuilder: (context, index) {
                                  final item = items[index];
                                  return GestureDetector(
                                    onTap: () {
                                      showClothingItemDialog(context, item);
                                    },
                                    child: Card(
                                      elevation: 2,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          Expanded(
                                            child:
                                                item['image_url'] != null
                                                    ? ClipRRect(
                                                      borderRadius:
                                                          const BorderRadius.vertical(
                                                            top:
                                                                Radius.circular(
                                                                  12,
                                                                ),
                                                          ),
                                                      child: Image.network(
                                                        item['image_url'],
                                                        fit: BoxFit.cover,
                                                      ),
                                                    )
                                                    : const Icon(
                                                      Icons.image_not_supported,
                                                    ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              item['name'] ?? 'Unnamed Item',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          }
                        },
                      )
                      : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}
