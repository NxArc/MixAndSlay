import 'package:fasionrecommender/data/responsive_utils.dart';
import 'package:fasionrecommender/services/storage/clothingItems_service.dart';
import 'package:fasionrecommender/services/storage/outfits_service.dart';
import 'package:fasionrecommender/views/widget/closetwidgets.dart/popups/saved_dialog.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditOutfit extends StatefulWidget {
  final String outfitId;

  const EditOutfit({
    super.key,
    required this.outfitId,
  });

  @override
  State<EditOutfit> createState() => _EditOutfitState();
}

class _EditOutfitState extends State<EditOutfit> {
  String? selectedOccasion;
  String? selectedWeatherFit;
  final TextEditingController nameController = TextEditingController();

  final Map<String, String> _categoryMap = {
    'Top': 'Tops',
    'Bottom': 'Bottoms',
    'Headwear': 'Headwear',
    'Footwear': 'Footwear',
    'Outerwear': 'Outerwear',
    'Accessory': 'Accessories',
  };

  final Map<String, String?> selectedItemIds = {
    'Headwear': null,
    'Top': null,
    'Bottom': null,
    'Footwear': null,
    'Outerwear': null,
    'Accessory': null,
  };

  final Map<String, String?> selectedItemImages = {
    'Headwear': null,
    'Top': null,
    'Bottom': null,
    'Footwear': null,
    'Outerwear': null,
    'Accessory': null,
  };

  late final OutfitService outfitService;
  late final ClothingItemService clothingItemService;

  @override
  void initState() {
    super.initState();
    outfitService = OutfitService(Supabase.instance.client);
    clothingItemService = ClothingItemService(Supabase.instance.client);
    _loadOutfitDetails();
  }

  Future<void> _loadOutfitDetails() async {
    try {
      final data = await outfitService.retrieveOutfitByOutfitID(widget.outfitId);
      if (data != null) {
        setState(() {
          nameController.text = data['outfit_name'] ?? '';
          selectedOccasion = data['occasion'];
          selectedWeatherFit = data['weather_fit'];

          for (var entry in _categoryMap.entries) {
            final idField = entry.key.toLowerCase();
            final itemId = data[idField];
            if (itemId != null) {
              selectedItemIds[entry.key] = itemId;
              _fetchImageForItem(entry.key, itemId);
            }
          }
        });
      }
    } catch (e) {
      debugPrint('Error loading outfit: $e');
    }
  }

  Future<void> _fetchImageForItem(String label, String itemId) async {
    final item = await clothingItemService.retrieveClothingItem(itemId);
    if (item != null) {
      setState(() {
        selectedItemImages[label] = item['image_url'];
      });
    }
  }

  Future<void> _selectClothingItem(String displayLabel, String category) async {
    showDialog(
      context: context,
      builder: (context) {
        return FutureBuilder<List<Map<String, dynamic>>>(
          future: clothingItemService.getClothingItemsByCategory(category),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const AlertDialog(
                content: SizedBox(
                  height: 100,
                  child: Center(child: CircularProgressIndicator()),
                ),
              );
            } else if (snapshot.hasError) {
              return AlertDialog(
                title: const Text('Error'),
                content: Text('Failed to load $category items.'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('OK'),
                  ),
                ],
              );
            }

            final items = snapshot.data ?? [];

            return AlertDialog(
              title: Text('Select $category'),
              content: SizedBox(
                width: double.maxFinite,
                height: MediaQuery.of(context).size.height * 0.5,
                child: GridView.builder(
                  itemCount: items.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedItemIds[displayLabel] = item['item_id'];
                          selectedItemImages[displayLabel] = item['image_url'];
                        });
                        Navigator.of(context).pop();
                      },
                      child: item['image_url'] != null
                          ? Image.network(
                              item['image_url'],
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
                            )
                          : const Icon(Icons.image_not_supported),
                    );
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildItemTile(String label) {
    final selectedImage = selectedItemImages[label];

    return GestureDetector(
      onTap: () {
        final category = _categoryMap[label] ?? label;
        _selectClothingItem(label, category);
      },
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          Column(
            children: [
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.16,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(12),
                  image: selectedImage != null
                      ? DecorationImage(
                          image: NetworkImage(selectedImage),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: selectedImage == null
                    ? const Center(child: Icon(Icons.image_not_supported))
                    : null,
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
              Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: ResponsiveUtils.subtitleSize(context),
                ),
              ),
            ],
          ),
          if (selectedImage != null)
            Positioned(
              top: 4,
              right: 4,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    selectedItemImages[label] = null;
                    selectedItemIds[label] = null;
                  });
                },
                child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black54,
                  ),
                  padding: const EdgeInsets.all(4),
                  child: const Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
         automaticallyImplyLeading: true,
        title: const Text("Update Outfit"),
        ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveUtils.paddingH(context),
          vertical: ResponsiveUtils.paddingV(context),
        ),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(labelText: 'Outfit Name'),
                    ),
                    
                    SizedBox(height: screenHeight * 0.02),

                    Row(
                      children: [
                        Expanded(
                          child: DropdownButton<String>(
                            isExpanded: true,
                            hint: const Text("Occasion"),
                            value: selectedOccasion,
                            items: ['Casual', 'Formal', 'Indoors']
                                .map((value) => DropdownMenuItem(
                                      value: value,
                                      child: Text(value),
                                    ))
                                .toList(),
                            onChanged: (newValue) =>
                                setState(() => selectedOccasion = newValue),
                          ),
                        ),
                        SizedBox(width: screenWidth * 0.03),
                        Expanded(
                          child: DropdownButton<String>(
                            isExpanded: true,
                            hint: const Text("WeatherFit"),
                            value: selectedWeatherFit,
                            items: ['Cold', 'Chilly', 'Hot', 'Rainy']
                                .map((value) => DropdownMenuItem(
                                      value: value,
                                      child: Text(value),
                                    ))
                                .toList(),
                            onChanged: (newValue) =>
                                setState(() => selectedWeatherFit = newValue),
                          ),
                        ),
                      ],
                    ),
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      childAspectRatio: 1,
                      crossAxisSpacing: screenWidth * 0.03,
                      mainAxisSpacing: screenHeight * 0.001,
                      children: [
                        _buildItemTile('Headwear'),
                        _buildItemTile('Accessory'),
                        _buildItemTile('Top'),
                        _buildItemTile('Outerwear'),
                        _buildItemTile('Bottom'),
                        _buildItemTile('Footwear'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                final outfitName = nameController.text.trim();

                if (outfitName.isEmpty ||
                    selectedItemIds['Top'] == null ||
                    selectedItemIds['Bottom'] == null ||
                    selectedOccasion == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Please enter name, select Top, Bottom, and Occasion',
                      ),
                    ),
                  );
                  return;
                }

                try {
                  await outfitService.updateOutfit(
                    outfitId: widget.outfitId,
                    outfitName: outfitName,
                    topId: selectedItemIds['Top']!,
                    bottomId: selectedItemIds['Bottom']!,
                    occasion: selectedOccasion!,
                    weatherFit: selectedWeatherFit,
                    headwearId: selectedItemIds['Headwear'],
                    accessoriesId: selectedItemIds['Accessory'],
                    footwearId: selectedItemIds['Footwear'],
                    outerwearId: selectedItemIds['Outerwear'],
                  );

                  // ignore: use_build_context_synchronously
                  showSuccessDialog(context);
                } catch (e) {
                  // ignore: use_build_context_synchronously
                  showFailureDialog(context, e.toString());
                }
              },
              child: const Text("Update Outfit"),
            ),
            SizedBox(height: screenHeight * 0.05),
          ],
        ),
      ),
    );
  }
}
