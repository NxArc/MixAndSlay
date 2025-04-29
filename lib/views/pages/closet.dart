import 'package:flutter/material.dart';
import 'package:fasionrecommender/views/widget/closetwidgets.dart/add_item_bottom_sheet.dart';
import 'package:fasionrecommender/views/widget/closetwidgets.dart/collection_section.dart';
import 'package:fasionrecommender/views/widget/closetwidgets.dart/generated_outfits_section.dart';


class VirtualClosetPage extends StatefulWidget {
  const VirtualClosetPage({super.key});


  @override
  State<VirtualClosetPage> createState() => _VirtualClosetPageState();
}


class _VirtualClosetPageState extends State<VirtualClosetPage> {
  int? expandedIndex; // 0 = Collection, 1 = Generated Outfits


  void toggleExpand(int index) {
    setState(() {
      expandedIndex = expandedIndex == index ? null : index;
    });
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CollectionSection(
              isExpanded: expandedIndex == 0,
              onTap: () => toggleExpand(0),
            ),
            const SizedBox(height: 15),
            GeneratedOutfitsSection(
              isExpanded: expandedIndex == 1,
              onTap: () => toggleExpand(1),
            ),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton.icon(
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
            ),
          ],
        ),
      ),
    );
  }
}



