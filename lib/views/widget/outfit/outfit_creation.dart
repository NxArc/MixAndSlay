import 'package:fasionrecommender/data/responsive_utils.dart';
import 'package:fasionrecommender/services/storage/clothingItems_service.dart';
import 'package:fasionrecommender/services/storage/outfits_service.dart';
import 'package:fasionrecommender/views/widget/closetwidgets.dart/popups/saved_dialog.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OutfitCreationPage extends StatefulWidget {
  const OutfitCreationPage({super.key});

  @override
  State<OutfitCreationPage> createState() => _OutfitCreationPageState();
}

class _OutfitCreationPageState extends State<OutfitCreationPage> {
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
  }

  Future<void> _selectClothingItem(String displayLabel, String category) async {
    showDialog(
      context: context,
      builder: (context) {
        return FutureBuilder<List<Map<String, dynamic>>>(
          future: clothingItemService.getClothingItemsByCategory(category),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return AlertDialog(
                title: Text('Loading $category...'),
                content: const SizedBox(
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

            if (items.isEmpty) {
              return AlertDialog(
                title: Text('No $category items'),
                content: const Text('You have no items in this category.'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('OK'),
                  ),
                ],
              );
            }

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
                          selectedItemIds[displayLabel] =
                              item['item_id'].toString();
                          selectedItemImages[displayLabel] = item['image_url'];
                        });
                        Navigator.of(context).pop();
                      },
                      child:
                          item['image_url'] != null
                              ? Image.network(
                                item['image_url'],
                                fit: BoxFit.cover,
                                errorBuilder:
                                    (context, error, stackTrace) =>
                                        const Icon(Icons.broken_image),
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
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.16,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(12),
              image:
                  selectedImage != null
                      ? DecorationImage(
                        image: NetworkImage(selectedImage),
                        fit: BoxFit.cover,
                      )
                      : null,
            ),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    final paddingH = ResponsiveUtils.paddingH(context);
    final paddingV = ResponsiveUtils.paddingV(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: paddingH, vertical: paddingV),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: screenHeight * 0.01,
                        horizontal: screenWidth * 0.02,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextField(
                            controller: nameController,
                            decoration: const InputDecoration(
                              labelText: 'Outfit Name',
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          Row(
                            children: [
                              Expanded(
                                child: DropdownButton<String>(
                                  isExpanded: true,
                                  hint: const Text("Occasion"),
                                  value: selectedOccasion,
                                  items:
                                      ['Casual', 'Formal', 'Indoors'].map((
                                        String value,
                                      ) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedOccasion = newValue;
                                    });
                                  },
                                ),
                              ),
                              SizedBox(width: screenWidth * 0.03),
                              Expanded(
                                child: DropdownButton<String>(
                                  isExpanded: true,
                                  hint: const Text("WeatherFit"),
                                  value: selectedWeatherFit,
                                  items:
                                      ['Cold', 'Chilly', 'Hot', 'Rainy'].map((
                                        String value,
                                      ) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedWeatherFit = newValue;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: screenWidth * 0.03,
                      mainAxisSpacing: screenHeight * 0.001,
                      childAspectRatio: 1,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
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
            SizedBox(height: screenHeight * 0.01),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: ResponsiveUtils.buttonWidth(context) * 0.45,
                  child: ElevatedButton(
                    onPressed: () async {
                      final outfitName = nameController.text.trim();

                      if (outfitName.isEmpty ||
                          selectedItemIds['Top']!.isEmpty ||
                          selectedItemIds['Bottom']!.isEmpty ||
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
                        // Make sure this function exists in your OutfitService, not StorageService
                        await outfitService.createCustomOutfit(
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
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        vertical: screenHeight * 0.02,
                      ),
                    ),
                    child: const Text("Create Outfit"),
                  ),
                ),
                SizedBox(width: screenWidth * 0.15),
                SizedBox(
                  width: ResponsiveUtils.buttonWidth(context) * 0.45,
                  child: ElevatedButton(
                    onPressed: () {
                      // Use selectedItemIds map
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        vertical: screenHeight * 0.02,
                      ),
                    ),
                    child: const Text("Generate Outfit"),
                  ),
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.05),
          ],
        ),
      ),
    );
  }
}
