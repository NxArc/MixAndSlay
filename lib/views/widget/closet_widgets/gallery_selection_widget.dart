import 'package:fasionrecommender/views/pages/closetpage/item_details_page.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class GallerySelection extends StatefulWidget {
  const GallerySelection({super.key});

  @override
  State<GallerySelection> createState() => _GallerySelectionState();
}

class _GallerySelectionState extends State<GallerySelection> {
  final ImagePicker _picker = ImagePicker();

  // Function to pick an image from gallery
  void _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );

    if (pickedFile != null) {
      // Navigate to ItemDetailsPage with the selected image
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ItemDetailsPage(imageFile: File(pickedFile.path)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'Select Item',
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Golos Text',
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(Icons.close, color: Colors.black, size: 20),
          ),
        ),
      ),
      body: Center(
        child: ElevatedButton.icon(
          onPressed: _pickImage,
          icon: const Icon(Icons.photo_library, color: Colors.black),
          label: const Text(
            'Pick Image from Gallery',
            style: TextStyle(color: Colors.black),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF918E8E),
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(11),
            ),
          ),
        ),
      ),
    );
  }
}
