import 'package:flutter/material.dart';
import '../../widget/closet_widgets/add_item_dialog.dart'; // Import the dialog widget
import '../../widget/closet_widgets/gallery_selection_widget.dart'; // Import the gallery selection page

class VirtualClosetPage extends StatefulWidget {
  const VirtualClosetPage({super.key});

  @override
  State<VirtualClosetPage> createState() => _VirtualClosetPageState();
}

class _VirtualClosetPageState extends State<VirtualClosetPage> {
  bool _isBottomNavVisible = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton.icon(
          onPressed: _showAddItemDialog,
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
    );
  }

  void _showAddItemDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
      ),
      builder: (BuildContext context) {
        return AddItemDialog(onOptionSelected: (selectedOption) {
          if (selectedOption == 'photo') {
            // Handle taking a photo
          } else if (selectedOption == 'gallery') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const GallerySelection(),
              ),
            );
          }
        });
      },
    );
  }
}
