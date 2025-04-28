import 'package:flutter/material.dart';
import 'package:fasionrecommender/services/storage/storage.dart';
import 'package:provider/provider.dart';

class OutfitCreationController {
  final BuildContext context;
  final TextEditingController outfitNameController;
  final Map<String, Map<String, dynamic>?> selectedItems;

  OutfitCreationController({
    required this.context,
    required this.outfitNameController,
    required this.selectedItems,
  });

  // Fetch Clothing Items by Category and Type
  Future<void> selectItem(BuildContext context, String categoryName) async {
    final storageService = Provider.of<StorageService>(context, listen: false);

    try {
      final typeMapping = {
        'Headwear': ['Headwear'],
        'Top': ['T-shirt', 'Blouse', 'Dress', 'Sweater', 'Jacket', 'Top'],
        'Bottom': ['Pants', 'Shorts', 'Skirt', 'Jeans', 'Bottom'],
        'Footwear': ['Shoes', 'Sandals', 'Boots', 'Footwear'],
        'Accessories': ['Necklace', 'Bracelet', 'Hat', 'Watch', 'Accessory'],
      };

      List<Map<String, dynamic>> allItems = [];
      for (String type in typeMapping[categoryName] ?? []) {
        final items = await storageService.getClothingItemsByType(type);
        allItems.addAll(items);
      }

      if (allItems.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No items available for $categoryName. Please upload items first.')),
        );
        return;
      }

      final selectedItem = await showDialog<Map<String, dynamic>>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Select $categoryName Item'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: allItems.length,
              itemBuilder: (context, index) {
                final item = allItems[index];
                return ListTile(
                  leading: Image.network(item['image_url'], width: 50, height: 50, fit: BoxFit.cover),
                  title: Text(item['name'] ?? 'Unnamed'),
                  subtitle: Text(item['clothing_type'] ?? ''),
                  onTap: () => Navigator.of(context).pop(item),
                );
              },
            ),
          ),
        ),
      );

      if (selectedItem != null) {
        selectedItems[categoryName] = selectedItem;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error selecting item: $e')),
      );
    }
  }

  Future<void> createOutfit() async {
    final storageService = Provider.of<StorageService>(context, listen: false);
    final outfitName = outfitNameController.text.trim();

    if (outfitName.isEmpty) {
      _showErrorDialog('Outfit name cannot be empty.');
      return;
    }

    try {
      final clothingItemIds = {
        'headwear': selectedItems['Headwear']?['id'],
        'top': selectedItems['Top']?['id'],
        'bottom': selectedItems['Bottom']?['id'],
        'footwear': selectedItems['Footwear']?['id'],
        'accessories': selectedItems['Accessories']?['id'],
      };

      final itemIds = clothingItemIds.entries
          .where((entry) => entry.value != null)
          .map((entry) => entry.value as String)
          .toList();

      if (itemIds.isEmpty) {
        _showErrorDialog('Please select at least one item to create an outfit.');
        return;
      }

      const weatherFit = 'Any';

      await storageService.createOutfit(
        outfitName: outfitName,
        clothingItemIds: itemIds,
        weatherFit: weatherFit,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Outfit created successfully!')),
      );
    } catch (e) {
      _showErrorDialog('Error creating outfit: $e');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}