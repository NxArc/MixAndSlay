import 'package:fasionrecommender/services/storage/outfits_retrieval.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fasionrecommender/services/storage/creation_and_deletions.dart';

class OutfitDisplayWidget extends StatefulWidget {
  final String outfitID;
  const OutfitDisplayWidget({super.key, required this.outfitID});

  @override
  State<OutfitDisplayWidget> createState() => _OutfitDisplayWidgetState();
}

class _OutfitDisplayWidgetState extends State<OutfitDisplayWidget> {
  Map<String, dynamic>? outfit;

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
    }
  }

  Future<Map<String, dynamic>?> _fetchItem(String? itemId) async {
    if (itemId == null) return null;
    final storageService = Provider.of<StorageService>(context, listen: false);
    return await storageService.retrieveClothingItem(itemId);
  }

  Widget _buildItemTile(String label, String? itemId) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: _fetchItem(itemId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return ListTile(title: Text('$label: Loading...'));
        }
        final item = snapshot.data;
        if (item == null) return ListTile(title: Text('$label: Not found'));

        return ListTile(
          contentPadding: const EdgeInsets.symmetric(
            vertical: 8.0,
            horizontal: 16.0,
          ),
          leading:
              item['image_url'] != null
                  ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      item['image_url'],
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                  )
                  : const Icon(Icons.image_not_supported, size: 60),
          title: Text(
            '$label: ${item['name'] ?? 'Unnamed'}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (item['color'] != null)
                Text(
                  'Color: ${item['color']}',
                  style: const TextStyle(fontSize: 14),
                ),
              if (item['clothing_type'] != null)
                Text(
                  'Type: ${item['clothing_type']}',
                  style: const TextStyle(fontSize: 14),
                ),
              if (item['material'] != null)
                Text(
                  'Material: ${item['material']}',
                  style: const TextStyle(fontSize: 14),
                ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    if (outfit == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                outfit!['outfit_name'] ?? 'Unnamed Outfit',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _buildItemTile('Headwear', outfit!['headwear']),
              _buildItemTile('Top', outfit!['top']),
              _buildItemTile('Bottom', outfit!['bottom']),
              _buildItemTile('Outerwear', outfit!['outerwear']),
              _buildItemTile('Footwear', outfit!['footwear']),
              _buildItemTile('Accessories', outfit!['accessories']),
              const SizedBox(height: 24),
              Divider(),
              const SizedBox(height: 12),
              screenWidth > 500
                  ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'WeatherFit: ${outfit!['weatherFit'] ?? 'N/A'}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      Text(
                        'Occasion: ${outfit!['occasion'] ?? 'N/A'}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  )
                  : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Text(
                          'WeatherFit: ${outfit!['weatherFit'] ?? 'N/A'}',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Text(
                          'Occasion: ${outfit!['occasion'] ?? 'N/A'}',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
