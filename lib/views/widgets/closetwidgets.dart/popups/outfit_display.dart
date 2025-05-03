import 'package:fasionrecommender/services/storage/outfits_service.dart';
import 'package:fasionrecommender/views/widgets/object%20widgets/modify_outfitpage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fasionrecommender/services/storage/clothingItems_service.dart';

class OutfitDisplayWidget extends StatefulWidget {
  final String outfitID;
  const OutfitDisplayWidget({super.key, required this.outfitID});

  @override
  State<OutfitDisplayWidget> createState() => _OutfitDisplayWidgetState();
}

class _OutfitDisplayWidgetState extends State<OutfitDisplayWidget> {
  Map<String, dynamic>? outfit;
  Map<String, dynamic>? headwear;
  Map<String, dynamic>? top;
  Map<String, dynamic>? bottom;
  Map<String, dynamic>? footwear;
  Map<String, dynamic>? accessories;
  Map<String, dynamic>? outerwear;

  @override
  void initState() {
    super.initState();
    _loadOutfit();
  }

  Future<void> _loadOutfit() async {
    final outfitService = Provider.of<OutfitService>(context, listen: false);
    final userOutfits = await outfitService.retrieveOutfitByOutfitID(
      widget.outfitID,
    );

    if (userOutfits != null) {
      setState(() {
        outfit = userOutfits;
      });
      _loadClothingItems(userOutfits);
    }
  }

  Future<void> _loadClothingItems(Map<String, dynamic> outfitData) async {
    final storageService = Provider.of<ClothingItemService>(
      context,
      listen: false,
    );

    final headwearData =
        outfitData['headwear'] != null
            ? await storageService.retrieveClothingItem(outfitData['headwear'])
            : null;
    final topData =
        outfitData['top'] != null
            ? await storageService.retrieveClothingItem(outfitData['top'])
            : null;
    final bottomData =
        outfitData['bottom'] != null
            ? await storageService.retrieveClothingItem(outfitData['bottom'])
            : null;
    final footwearData =
        outfitData['footwear'] != null
            ? await storageService.retrieveClothingItem(outfitData['footwear'])
            : null;
    final accessoriesData =
        outfitData['accessories'] != null
            ? await storageService.retrieveClothingItem(
              outfitData['accessories'],
            )
            : null;
    final outerwearData =
        outfitData['outerwear'] != null
            ? await storageService.retrieveClothingItem(outfitData['outerwear'])
            : null;

    setState(() {
      headwear = headwearData;
      top = topData;
      bottom = bottomData;
      footwear = footwearData;
      accessories = accessoriesData;
      outerwear = outerwearData;
    });
  }

  Widget _buildShadowedImage(String imageUrl, double width, double height) {
    return Container(
      width: width,
      height: height,
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(imageUrl, fit: BoxFit.cover),
      ),
    );
  }

  Widget _buildFitImage(BuildContext context) {
    double imageWidth = MediaQuery.of(context).size.width * 0.4;
    double imageHeight = MediaQuery.of(context).size.height * 0.25;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (headwear != null && headwear!['image_url'] != null)
          _buildShadowedImage(headwear!['image_url'], imageWidth, imageHeight),
        if (top != null && top!['image_url'] != null)
          _buildShadowedImage(
            top!['image_url'],
            imageWidth * 1.2,
            imageHeight * 1.2,
          ),
        if (bottom != null && bottom!['image_url'] != null)
          _buildShadowedImage(
            bottom!['image_url'],
            imageWidth * 1.2,
            imageHeight * 1.2,
          ),
        if (footwear != null && footwear!['image_url'] != null)
          _buildShadowedImage(
            footwear!['image_url'],
            imageWidth,
            imageHeight * 0.8,
          ),
      ],
    );
  }

  Widget _buildAccessoryOuterwearRow(BuildContext context) {
    List<Widget> items = [];
    double itemWidth = MediaQuery.of(context).size.width * 0.3;

    if (accessories != null && accessories!['image_url'] != null) {
      items.add(
        Column(
          children: [
            _buildShadowedImage(
              accessories!['image_url'],
              itemWidth,
              itemWidth,
            ),
            const SizedBox(height: 8),
            Text(
              'Accessory',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color:
                    Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black,
              ),
            ),
          ],
        ),
      );
    }

    if (outerwear != null && outerwear!['image_url'] != null) {
      items.add(
        Column(
          children: [
            _buildShadowedImage(outerwear!['image_url'], itemWidth, itemWidth),
            const SizedBox(height: 8),
            Text(
              'Outerwear',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color:
                    Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black,
              ),
            ),
          ],
        ),
      );
    }

    return Row(
      mainAxisAlignment:
          items.length == 1
              ? MainAxisAlignment.center
              : MainAxisAlignment.spaceEvenly,
      children: items,
    );
  }

  Widget _buildItemDetails(String label, Map<String, dynamic>? item) {
    if (item == null) {
      return SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 140, // 👈 Set this width to align all titles
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(
                        item['name'] ?? 'Unnamed',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color:
                              Theme.of(context).brightness == Brightness.dark
                                  ? Colors.black
                                  : Colors.white,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: [
                    if (item['color'] != null)
                      _buildBadge('Color: ${item['color']}'),
                    if (item['clothing_type'] != null)
                      _buildBadge('Type: ${item['clothing_type']}'),
                    if (item['material'] != null)
                      _buildBadge('Material: ${item['material']}'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(text, style: TextStyle(fontSize: 12, color: Colors.black)),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (outfit == null) {
      return const Center(child: CircularProgressIndicator());
    }

    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      color: Theme.of(context).colorScheme.onSurface,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Outfit name
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  outfit!['outfit_name'] ?? 'Unnamed Outfit',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: screenWidth > 400 ? 22 : 18, // Adaptive font size
                    color:
                        Theme.of(context).brightness == Brightness.dark
                            ? Colors.black
                            : Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                IconButton(
                  icon: Icon(Icons.edit, size: screenWidth > 400 ? 24 : 20),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => EditOutfit(outfitId: widget.outfitID),
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),
      
            // Layer 1: Fit Image
            _buildFitImage(context),
            const SizedBox(height: 24),
      
            // Layer 2: Accessory + Outerwear side by side (auto-center)
            _buildAccessoryOuterwearRow(context),
            const SizedBox(height: 24),
            Center(
              child: Text(
                'Outfit Information',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color:
                      Theme.of(context).brightness == Brightness.dark
                          ? Colors.black
                          : Colors.white,
                ),
              ),
            ),
            Divider(thickness: 1),
            const SizedBox(height: 12),
      
            // Layer 3: All Item Details
            _buildItemDetails('Headwear', headwear),
            _buildItemDetails('Top', top),
            _buildItemDetails('Bottom', bottom),
            _buildItemDetails('Footwear', footwear),
            _buildItemDetails('Accessory', accessories),
            _buildItemDetails('Outerwear', outerwear),
      
            const SizedBox(height: 24),
            // Tags
            Wrap(
              spacing: 12,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: [
                _buildTag(
                  'WeatherFit: ${outfit!['weatherFit'] ?? 'N/A'}',
                  Colors.blue,
                ),
                _buildTag(
                  'Occasion: ${outfit!['occasion'] ?? 'N/A'}',
                  Colors.green,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTag(String text, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withAlpha((0.1 * 255).round()),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withAlpha((0.1 * 255).round())),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
