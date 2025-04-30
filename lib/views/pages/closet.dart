import 'package:fasionrecommender/views/widget/closetwidgets.dart/outfit_creation.dart';
import 'package:fasionrecommender/views/widget/closetwidgets.dart/add_item_bottom_sheet.dart';
import 'package:fasionrecommender/views/widget/closetwidgets.dart/outfit_display.dart';
import 'package:flutter/material.dart';

class VirtualClosetPage extends StatelessWidget {
  const VirtualClosetPage({super.key});

Future<void> showOutfitDialog(BuildContext context, String outfitId) {
  return showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return Dialog(

        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 40), // Leave space for X
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height * 0.8,
                child: OutfitDisplayWidget(outfitID: outfitId),
              ),
            ),
            Positioned(
              right: 8,
              top: 8,
              child: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
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
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Closet',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 22),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton.icon(
              onPressed: () {
                showAddItemDialog(context);
              },
              icon: const Icon(Icons.add, color: Colors.black),
              label: const Text(
                'New Item',
                style: TextStyle(color: Colors.black),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF918E8E),
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(11),
                ),
              ),
            ),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const OutfitCreationPage(),
                  ),
                );
              },
              icon: const Icon(Icons.add, color: Colors.black),
              label: const Text(
                'Make Outfit',
                style: TextStyle(color: Colors.black),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF918E8E),
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(11),
                ),
              ),
            ),
            ElevatedButton.icon(
              onPressed: () {
                showOutfitDialog(context, "a9e3877c-e43a-4630-b8b5-6b49e0fe0ce1");
              },
              icon: const Icon(Icons.add, color: Colors.black),
              label: const Text(
                'Show outfit test',
                style: TextStyle(color: Colors.black),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF918E8E),
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(11),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
