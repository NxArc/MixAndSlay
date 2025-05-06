import 'package:cached_network_image/cached_network_image.dart';
import 'package:fasionrecommender/services/storage/outfits_service.dart';
import 'package:fasionrecommender/views/widgets/object%20creation/modify_outfitpage.dart';
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
    final userOutfits = await outfitService.retrieveOutfitByOutfitID(widget.outfitID);

    if (userOutfits != null) {
      setState(() {
        outfit = userOutfits;
      });
      _loadClothingItems(userOutfits);
    }
  }

  Future<void> _loadClothingItems(Map<String, dynamic> outfitData) async {
    final storageService = Provider.of<ClothingItemService>(context, listen: false);

    headwear = await _loadItem(storageService, outfitData['headwear']);
    top = await _loadItem(storageService, outfitData['top']);
    bottom = await _loadItem(storageService, outfitData['bottom']);
    footwear = await _loadItem(storageService, outfitData['footwear']);
    accessories = await _loadItem(storageService, outfitData['accessories']);
    outerwear = await _loadItem(storageService, outfitData['outerwear']);

    setState(() {});
  }

  Future<Map<String, dynamic>?> _loadItem(
    ClothingItemService service,
    dynamic itemId,
  ) async {
    return itemId != null ? await service.retrieveClothingItem(itemId) : null;
  }
Widget _buildShadowedImage(String imageUrl, double width, double height) {
  final colorScheme = Theme.of(context).colorScheme;

  return Container(
    width: width,
    height: height,
    margin: EdgeInsets.all(8),
    decoration: BoxDecoration(
      color: colorScheme.surface,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: colorScheme.shadow.withOpacity(0.15),
          blurRadius: 10,
          offset: Offset(0, 4),
        ),
      ],
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        fit: BoxFit.cover,
        placeholder: (context, url) => Center(child: CircularProgressIndicator()),
        errorWidget: (context, url, error) => Icon(Icons.error, color: colorScheme.error),
      ),
    ),
  );
}


  Widget _buildFitImage(BuildContext context) {
    double imageWidth = MediaQuery.of(context).size.width * 0.4;
    double imageHeight = MediaQuery.of(context).size.height * 0.25;

    return Column(
      children: [
        if (headwear?['image_url'] != null)
          _buildShadowedImage(headwear!['image_url'], imageWidth, imageHeight),
        if (top?['image_url'] != null)
          _buildShadowedImage(top!['image_url'], imageWidth * 1.2, imageHeight * 1.2),
        if (bottom?['image_url'] != null)
          _buildShadowedImage(bottom!['image_url'], imageWidth * 1.2, imageHeight * 1.2),
        if (footwear?['image_url'] != null)
          _buildShadowedImage(footwear!['image_url'], imageWidth, imageHeight * 0.8),
      ],
    );
  }

  Widget _buildAccessoryOuterwearRow(BuildContext context) {
    List<Widget> items = [];
    double itemWidth = MediaQuery.of(context).size.width * 0.3;

    if (accessories?['image_url'] != null) {
      items.add(
        Column(
          children: [
            _buildShadowedImage(accessories!['image_url'], itemWidth, itemWidth),
            const SizedBox(height: 8),
            Text('Accessory', style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      );
    }

    if (outerwear?['image_url'] != null) {
      items.add(
        Column(
          children: [
            _buildShadowedImage(outerwear!['image_url'], itemWidth, itemWidth),
            const SizedBox(height: 8),
            Text('Outerwear', style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      );
    }

    return Row(
      mainAxisAlignment: items.length == 1 ? MainAxisAlignment.center : MainAxisAlignment.spaceEvenly,
      children: items,
    );
  }

  Widget _buildItemDetails(String label, Map<String, dynamic>? item) {
    if (item == null) return SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: 140,
                child: Text(
                  item['name'] ?? 'Unnamed',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: [
                    if (item['color'] != null) _buildBadge('Color: ${item['color']}'),
                    if (item['clothing_type'] != null) _buildBadge('Type: ${item['clothing_type']}'),
                    if (item['material'] != null) _buildBadge('Material: ${item['material']}'),
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
  final colorScheme = Theme.of(context).colorScheme;

  return Container(
    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    decoration: BoxDecoration(
      color: colorScheme.secondaryContainer,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(
      text,
      style: TextStyle(
        fontSize: 12,
        color: colorScheme.onSecondaryContainer,
      ),
    ),
  );
}

@override
Widget build(BuildContext context) {
  final colorScheme = Theme.of(context).colorScheme;

  if (outfit == null) {
    return const Center(child: CircularProgressIndicator());
  }

  return Scaffold(
    backgroundColor: colorScheme.background,
    body: SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    outfit!['outfit_name'] ?? 'Unnamed Outfit',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditOutfit(outfitId: widget.outfitID),
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildFitImage(context),
            const SizedBox(height: 24),
            _buildAccessoryOuterwearRow(context),
            const SizedBox(height: 24),
            Center(
              child: Text(
                'Outfit Information',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            const Divider(thickness: 1),
            _buildItemDetails('Headwear', headwear),
            _buildItemDetails('Top', top),
            _buildItemDetails('Bottom', bottom),
            _buildItemDetails('Footwear', footwear),
            _buildItemDetails('Accessory', accessories),
            _buildItemDetails('Outerwear', outerwear),
            const SizedBox(height: 24),
            Wrap(
              spacing: 12,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: [
                _buildTag('WeatherFit: ${outfit!['weatherFit'] ?? 'N/A'}', Colors.blue),
                _buildTag('Occasion: ${outfit!['occasion'] ?? 'N/A'}', Colors.green),
              ],
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: Icon(Icons.close, color: colorScheme.onPrimary),
              label: Text('Close', style: TextStyle(color: colorScheme.onPrimary)),
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              ),
            ),
          ],
        ),
      ),
    )
  );
  }

Widget _buildTag(String text, Color fallbackColor) {
  final tagColor = fallbackColor.withOpacity(0.2);

  return Container(
    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    decoration: BoxDecoration(
      color: tagColor,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: tagColor),
    ),
    child: Text(
      text,
      style: TextStyle(
        fontSize: 14,
        color: fallbackColor,
        fontWeight: FontWeight.w600,
      ),
    ),
  );
}

}
