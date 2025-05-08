import 'package:fasionrecommender/services/storage/outfits_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fasionrecommender/views/widgets/closetwidgets.dart/popups/outfit_display.dart';

class OutfitOfTheDayWidget extends StatelessWidget {
  const OutfitOfTheDayWidget({super.key});

  // Method to show the outfit dialog
  void showOutfitDialog(BuildContext context, String outfitId) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: OutfitDisplayWidget(outfitID: outfitId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final outfitService = Provider.of<OutfitService>(context, listen: false);

    // First, get the Outfit of the Day ID for today
    Future<String?> getOutfitOfTheDayId() async {
      final today = DateTime.now();
      // Assuming you have a method in OutfitService that returns today's OOTD based on the date or a flag
      final otdData = await outfitService.getOutfitOfTheDay(today);
      return otdData?['outfit_id']; // Adjust this to how your data is structured
    }

    return FutureBuilder<String?>(
      future: getOutfitOfTheDayId(), // Get the outfit_id for today
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator()); // Show loading indicator while fetching data
        }
        if (!snapshot.hasData || snapshot.data == null) {
          return Center(
            child: Text(
              'No OOTD for today!', // Show this message if no data is found
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 16),
            ),
          );
        }
        final outfitId = snapshot.data!;

        // Now fetch the full outfit details using the outfit_id
        return FutureBuilder<Map<String, dynamic>?>( 
          future: outfitService.retrieveOutfitByOutfitID(outfitId), // Use the dynamic OOTD outfit_id
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator()); // Show loading indicator while fetching data
            }

            if (!snapshot.hasData || snapshot.data == null) {
              return Center(
                child: Text(
                  'No OOTD details available!', // Show this message if no data is found
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 16),
                ),
              );
            }
            
            final outfit = snapshot.data!;
            final name = outfit['outfit_name'] ?? 'Outfit of the Day';

            return GestureDetector(
              onTap: () {
                // Call the function to show the outfit dialog
                showOutfitDialog(context, outfit['outfit_id']);
              },
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor, // Background color of the card
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.secondary, // Contrasting color for the border
                    width: 2, // Thickness of the border
                  ),
                ),
                child: Card(
                  margin: EdgeInsets.zero, // No margin since the container is wrapping it
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    title: Text('OOTD: $name', style: Theme.of(context).textTheme.titleMedium),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
