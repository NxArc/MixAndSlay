import 'package:fasionrecommender/services/storage/outfits_service.dart';
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
    final userOutfits =
        await outfitService.retrieveOutfitByOutfitID(widget.outfitID);

    if (userOutfits != null) {
      setState(() {
        outfit = userOutfits;
      });
      _loadClothingItems(userOutfits);
    }
  }

  Future<void> _loadClothingItems(Map<String, dynamic> outfitData) async {
    final storageService =
        Provider.of<ClothingItemService>(context, listen: false);

    final headwearData = outfitData['headwear'] != null
        ? await storageService.retrieveClothingItem(outfitData['headwear'])
        : null;
    final topData = outfitData['top'] != null
        ? await storageService.retrieveClothingItem(outfitData['top'])
        : null;
    final bottomData = outfitData['bottom'] != null
        ? await storageService.retrieveClothingItem(outfitData['bottom'])
        : null;
    final footwearData = outfitData['footwear'] != null
        ? await storageService.retrieveClothingItem(outfitData['footwear'])
        : null;
    final accessoriesData = outfitData['accessories'] != null
        ? await storageService.retrieveClothingItem(outfitData['accessories'])
        : null;
    final outerwearData = outfitData['outerwear'] != null
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
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildFitImage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (headwear != null && headwear!['image_url'] != null)
          _buildShadowedImage(headwear!['image_url'], 150, 150),
        if (top != null && top!['image_url'] != null)
          _buildShadowedImage(top!['image_url'], 180, 200),
        if (bottom != null && bottom!['image_url'] != null)
          _buildShadowedImage(bottom!['image_url'], 180, 200),
        if (footwear != null && footwear!['image_url'] != null)
          _buildShadowedImage(footwear!['image_url'], 150, 120),
      ],
    );
  }

  Widget _buildAccessoryOuterwearRow() {
    List<Widget> items = [];

    if (accessories != null && accessories!['image_url'] != null) {
      items.add(Column(
        children: [
          _buildShadowedImage(accessories!['image_url'], 120, 120),
          const SizedBox(height: 8),
          Text(
            'Accessory',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ));
    }

    if (outerwear != null && outerwear!['image_url'] != null) {
      items.add(Column(
        children: [
          _buildShadowedImage(outerwear!['image_url'], 120, 120),
          const SizedBox(height: 8),
          Text(
            'Outerwear',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ));
    }

    return Row(
      mainAxisAlignment: items.length == 1
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
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Fixed width title block
        Container(
          width: 140, // 👈 Set this width to align all titles
          child: Text(
            '${item['name'] ?? 'Unnamed'} ($label)',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(width: 12),
        // Badges
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
  );
}

  Widget _buildBadge(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 12, color: Colors.grey[800]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (outfit == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Outfit name
          Text(
            outfit!['outfit_name'] ?? 'Unnamed Outfit',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),

          // Layer 1: Fit Image
          _buildFitImage(),
          const SizedBox(height: 24),

          // Layer 2: Accessory + Outerwear side by side (auto-center)
          _buildAccessoryOuterwearRow(),
          const SizedBox(height: 24),

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
                  'WeatherFit: ${outfit!['weatherFit'] ?? 'N/A'}', Colors.blue),
              _buildTag(
                  'Occasion: ${outfit!['occasion'] ?? 'N/A'}', Colors.green),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String text, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
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

