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
    final userOutfits = await outfitService.retrieveOutfitByOutfitID(widget.outfitID);

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
          leading: item['image_url'] != null
              ? Image.network(item['image_url'], width: 50, height: 50, fit: BoxFit.cover)
              : const Icon(Icons.image_not_supported),
          title: Text('$label: ${item['name'] ?? 'Unnamed'}'),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (outfit == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              outfit!['outfit_name'] ?? 'Unnamed Outfit',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildItemTile('Top', outfit!['top']),
            _buildItemTile('Bottom', outfit!['bottom']),
            _buildItemTile('Headwear', outfit!['headwear']),
            _buildItemTile('Outerwear', outfit!['outerwear']),
            _buildItemTile('Footwear', outfit!['footwear']),
            _buildItemTile('Accessories', outfit!['accessories']),
          ],
        ),
      ),
    );
  }
}
