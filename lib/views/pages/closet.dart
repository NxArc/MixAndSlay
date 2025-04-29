import 'package:fasionrecommender/views/widget/closetwidgets.dart/outfit_creation.dart';
import 'package:fasionrecommender/views/widget/closetwidgets.dart/add_item_bottom_sheet.dart';
import 'package:flutter/material.dart';

class VirtualClosetPage extends StatelessWidget {
  const VirtualClosetPage({super.key});

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
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11)),
              ),
            ),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const OutfitCreationPage(),));
              },
              icon: const Icon(Icons.add, color: Colors.black),
              label: const Text(
                'Make Outfit',
                style: TextStyle(color: Colors.black),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF918E8E),
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
